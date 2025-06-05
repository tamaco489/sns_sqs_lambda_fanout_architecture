package sns_client

import (
	"context"
	"fmt"

	"github.com/aws/aws-sdk-go-v2/service/sns"
	"github.com/tamaco489/sns_sqs_lambda_fanout_architecture/api/shop/internal/configuration"
)

func (sw *SNSWrapper) SendChargeNotifications(ctx context.Context, input *sns.PublishInput) (*sns.PublishOutput, error) {

	if input.TopicArn == nil {
		return nil, fmt.Errorf("topicArn is required")
	}

	topicArn := *input.TopicArn

	if topicArn != configuration.Get().SNS.ChargeNotificationsTopicArn {
		return nil, fmt.Errorf("topicArn is not valid")
	}

	res, err := sw.Client.Publish(ctx, input)
	if err != nil {
		return nil, fmt.Errorf("failed to publish message: %w", err)
	}

	return res, nil
}
