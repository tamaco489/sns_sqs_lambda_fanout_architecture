package sns_client

import (
	"context"
	"encoding/json"
	"fmt"
	"log/slog"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/sns"

	snstypes "github.com/aws/aws-sdk-go-v2/service/sns/types"
)

// SendChargeNotificationsPayload は通知の送信に必要なパラメータをまとめた構造体です。
type SendChargeNotificationsPayload struct {
	TopicArn     string
	Message      string
	MessageTypes []MessageType
}

// SendChargeNotifications はSNSトピックに通知メッセージを送信します。
//
// MessageTypesはSNSのメッセージ属性に設定され、各SQSサブスクリプションでのフィルタリングに利用されます。
func (sw *SNSWrapper) SendChargeNotifications(ctx context.Context, payload SendChargeNotificationsPayload) (*sns.PublishOutput, error) {

	if err := payload.Validate(); err != nil {
		return nil, fmt.Errorf("invalid payload: %w", err)
	}

	slog.InfoContext(ctx, "send charge notifications",
		"topic_arn", payload.TopicArn,
		"message", payload.Message,
		"message_types", payload.MessageTypes,
	)

	// MessageTypesをJSON配列としてシリアライズし、SNSメッセージ属性に設定
	// → SQSのサブスクリプションで `MessageAttributes.type = "xxx"` によるフィルタリングが可能
	typesJson, err := json.Marshal(payload.MessageTypes)
	if err != nil {
		return nil, fmt.Errorf("failed to marshal message types: %w", err)
	}

	messageAttributes := map[string]snstypes.MessageAttributeValue{
		"type": {
			DataType:    aws.String("String.Array"),    // NOTE: JSON配列として明示
			StringValue: aws.String(string(typesJson)), // 例: ["slack_message", "line_message"]
		},
	}

	input := &sns.PublishInput{
		TopicArn:          aws.String(payload.TopicArn),
		Message:           aws.String(payload.Message),
		MessageAttributes: messageAttributes,
	}

	res, err := sw.Client.Publish(ctx, input)
	if err != nil {
		return nil, fmt.Errorf("failed to publish message: %w", err)
	}

	return res, nil
}

// Validate は Payload の検証を行います。
//   - 1. TopicArn, Messageの必須チェック
//   - 2. MessageTypesが最低1つあるか
//   - 3. 各MessageTypeが定義された型か
func (p *SendChargeNotificationsPayload) Validate() error {
	if p.TopicArn == "" {
		return fmt.Errorf("topicArn is required")
	}
	if p.Message == "" {
		return fmt.Errorf("message is required")
	}
	if len(p.MessageTypes) == 0 {
		return fmt.Errorf("at least one messageType is required")
	}
	for _, mt := range p.MessageTypes {
		if !mt.IsValid() {
			return fmt.Errorf("invalid messageType: %s", mt)
		}
	}
	return nil
}
