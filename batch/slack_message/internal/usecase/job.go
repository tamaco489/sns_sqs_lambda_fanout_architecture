package usecase

import (
	"context"

	"github.com/tamaco489/sns_sqs_lambda_fanout_architecture/batch/slack_message/internal/configuration"
)

type Jobber interface {
	SendSlackMessage(ctx context.Context) error
}

var _ Jobber = (*Job)(nil)

type Job struct{}

func NewJob(cfg configuration.Config) (*Job, error) {
	return &Job{}, nil
}
