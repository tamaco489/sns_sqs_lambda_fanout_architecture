package handler

import (
	"context"
	"log/slog"

	"github.com/aws/aws-lambda-go/events"
	"github.com/tamaco489/sns_sqs_lambda_fanout_architecture/batch/line_message/internal/usecase"
)

type SQSEventJob func(ctx context.Context, sqsEvent events.SQSEvent) error

func LineMessageHandler(job usecase.Job) SQSEventJob {
	return func(ctx context.Context, sqsEvent events.SQSEvent) error {

		slog.InfoContext(ctx, "start slack message handler by handler")

		for _, record := range sqsEvent.Records {
			slog.InfoContext(ctx, "message", "record (all)", record)
			if err := job.SendLineMessage(ctx); err != nil {
				return err
			}
		}

		return nil
	}
}
