package sns_client

import (
	"context"
	"fmt"

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

	if payload.TopicArn == "" {
		return nil, fmt.Errorf("topicArn is required")
	}
	if payload.Message == "" {
		return nil, fmt.Errorf("message is required")
	}
	if payload.MessageType == "" {
		return nil, fmt.Errorf("messageType is required")
	}

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
