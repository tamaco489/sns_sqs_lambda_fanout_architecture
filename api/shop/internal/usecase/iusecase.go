package usecase

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/sns_sqs_lambda_fanout_architecture/api/shop/internal/gen"
)

type IChargeUseCase interface {
	CreateCharge(ctx *gin.Context, request gen.CreateChargeRequestObject) (gen.CreateChargeResponseObject, error)
}

type IReservationUseCase interface {
	CreateReservation(ctx *gin.Context, request gen.CreateReservationRequestObject) (gen.CreateReservationResponseObject, error)
}

// type chargeUseCase struct{ sqsClient *sqs_client.SQSClient }
type chargeUseCase struct{}

type reservationUseCase struct{}

// func NewChargeUseCase(sqsClient *sqs_client.SQSClient) IChargeUseCase {
// 	return &chargeUseCase{sqsClient: sqsClient}
// }

func NewChargeUseCase() IChargeUseCase {
	return &chargeUseCase{}
}

func NewReservationUseCase() IReservationUseCase {
	return &reservationUseCase{}
}
