package sns_client

import (
	"context"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/sns"
)

type SNSClient interface {
	SendChargeNotifications(ctx context.Context, payload SendChargeNotificationsPayload) (*sns.PublishOutput, error)
}

type SNSWrapper struct {
	Client *sns.Client
}

func NewSNSClient(cfg aws.Config) *SNSWrapper {
	client := sns.NewFromConfig(cfg)
	return &SNSWrapper{
		Client: client,
	}
}

var _ SNSClient = (*SNSWrapper)(nil)
