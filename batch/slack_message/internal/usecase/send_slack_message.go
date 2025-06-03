package usecase

import (
	"context"
	"log/slog"
)

func (j *Job) SendSlackMessage(ctx context.Context) error {

	slog.InfoContext(ctx, "send slack message by usecase job")

	return nil
}
