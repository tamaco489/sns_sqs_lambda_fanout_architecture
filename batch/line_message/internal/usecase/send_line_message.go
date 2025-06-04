package usecase

import (
	"context"
	"log/slog"
)

func (j *Job) SendLineMessage(ctx context.Context) error {

	slog.InfoContext(ctx, "send line message by usecase job")

	return nil
}
