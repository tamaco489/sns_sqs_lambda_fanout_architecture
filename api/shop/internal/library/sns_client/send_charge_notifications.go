package sns_client

import (
	"context"
	"fmt"
	"log/slog"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/sns"

	snstypes "github.com/aws/aws-sdk-go-v2/service/sns/types"
)

type SendChargeNotificationsPayload struct {
	TopicArn    string
	Message     string
	MessageType MessageType
}

func (sw *SNSWrapper) SendChargeNotifications(ctx context.Context, payload SendChargeNotificationsPayload) (*sns.PublishOutput, error) {

	if err := payload.Validate(); err != nil {
		return nil, fmt.Errorf("invalid payload: %w", err)
	}

	// todo: 検証終了後に削除
	slog.InfoContext(ctx, "send charge notifications", "payload", payload)

	messageAttributes := map[string]snstypes.MessageAttributeValue{
		"type": {
			DataType:    aws.String("String"),
			StringValue: aws.String(payload.MessageType.String()),
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

func (p *SendChargeNotificationsPayload) Validate() error {
	if p.TopicArn == "" {
		return fmt.Errorf("topicArn is required")
	}
	if p.Message == "" {
		return fmt.Errorf("message is required")
	}
	if !p.MessageType.IsValid() {
		return fmt.Errorf("invalid messageType: %s", p.MessageType)
	}
	return nil
}
