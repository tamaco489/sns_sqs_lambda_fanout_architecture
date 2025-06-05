package usecase

import (
	"crypto/rand"
	"fmt"
	"log/slog"
	"math/big"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/tamaco489/sns_sqs_lambda_fanout_architecture/api/shop/internal/configuration"
	"github.com/tamaco489/sns_sqs_lambda_fanout_architecture/api/shop/internal/gen"
	"github.com/tamaco489/sns_sqs_lambda_fanout_architecture/api/shop/internal/library/sns_client"
)

func (u *chargeUseCase) CreateCharge(ctx *gin.Context, request gen.CreateChargeRequestObject) (gen.CreateChargeResponseObject, error) {

	time.Sleep(1000 * time.Millisecond)

	// order_idを生成
	orderID := uuid.New().String()

	// user_idを生成（10010001 ~ 3000000までのランダムな数値を設定する）
	diff := new(big.Int).Sub(new(big.Int).SetUint64(30000000), new(big.Int).SetUint64(10010001))
	uid, err := rand.Int(rand.Reader, diff)
	if err != nil {
		return gen.CreateCharge500Response{}, fmt.Errorf("error generating rand: %v", err)
	}

	slog.InfoContext(ctx, "sample data by create charge api", "uid", uid.Uint64(), "order_id", orderID)

	if configuration.Get().API.Env != "dev" {
		payload := sns_client.SendChargeNotificationsPayload{
			TopicArn:    configuration.Get().SNS.ChargeNotificationsTopicArn,
			Message:     "order accepted",
			MessageType: sns_client.MessageTypeBroadcast,
		}

		res, err := u.snsClient.SendChargeNotifications(ctx, payload)
		if err != nil {
			return gen.CreateCharge500Response{}, fmt.Errorf("failed to send message to sns: %v", err)
		}

		slog.InfoContext(ctx, "sns publish response",
			"message_id", res.MessageId,
			"sequence_number", res.SequenceNumber,
			"result_metadata", res.ResultMetadata,
		)
	}

	return gen.CreateCharge204Response{}, nil
}
