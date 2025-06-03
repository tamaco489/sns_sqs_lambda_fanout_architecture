package handler

import (
	"context"
	"time"

	"github.com/aws/aws-lambda-go/events"
)

var timeout = 25 * time.Second

// タイムアウトを設定するミドルウェア
//
// Lambdaの最大実行時間を30秒に設定しているため、その時間よりも短く設定することで安全に処理を切り上げられるようにすることが目的。
func TimeoutMiddleware(fn SQSEventJob) SQSEventJob {
	return func(ctx context.Context, sqsEvent events.SQSEvent) error {
		newCtx, cancel := context.WithTimeout(ctx, timeout)
		defer cancel()

		return fn(newCtx, sqsEvent)
	}
}
