package usecase

import (
	"context"

	"github.com/tamaco489/sns_sqs_lambda_fanout_architecture/batch/line_message/internal/configuration"
)

type Jobber interface {
	SendLineMessage(ctx context.Context) error
}

var _ Jobber = (*Job)(nil)

type Job struct{}

func NewJob(cfg configuration.Config) (*Job, error) {
	return &Job{}, nil
}
