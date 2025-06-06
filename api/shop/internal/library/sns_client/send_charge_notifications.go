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

type SendChargeNotificationsPayload struct {
	TopicArn     string
	Message      string
	MessageTypes []MessageType
}

func (sw *SNSWrapper) SendChargeNotifications(ctx context.Context, payload SendChargeNotificationsPayload) (*sns.PublishOutput, error) {

	if err := payload.Validate(); err != nil {
		return nil, fmt.Errorf("invalid payload: %w", err)
	}

	slog.InfoContext(ctx, "send charge notifications",
		"topic_arn", payload.TopicArn,
		"message", payload.Message,
		"message_types", payload.MessageTypes,
	)

	typesJson, err := json.Marshal(payload.MessageTypes)
	if err != nil {
		return nil, fmt.Errorf("failed to marshal message types: %w", err)
	}

	messageAttributes := map[string]snstypes.MessageAttributeValue{
		"type": {
			DataType:    aws.String("String.Array"),
			StringValue: aws.String(string(typesJson)),
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
