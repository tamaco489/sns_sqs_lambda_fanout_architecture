package logging

import (
	"context"
	"log/slog"

	"github.com/aws/aws-lambda-go/lambdacontext"
)

type LambdaSlogHandler struct {
	slog.Handler
}

func NewLambdaSlogHandler(h slog.Handler) *LambdaSlogHandler {
	return &LambdaSlogHandler{Handler: h}
}

func (h *LambdaSlogHandler) Handle(ctx context.Context, record slog.Record) error {
	lc, ok := lambdacontext.FromContext(ctx)
	if ok {
		record.AddAttrs(slog.Attr{
			Key:   "aws_request_id",
			Value: slog.StringValue(lc.AwsRequestID),
		})
	}

	return h.Handler.Handle(ctx, record)
}
