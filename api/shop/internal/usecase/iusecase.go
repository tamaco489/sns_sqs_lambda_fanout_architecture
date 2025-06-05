package usecase

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/sns_sqs_lambda_fanout_architecture/api/shop/internal/gen"
	"github.com/tamaco489/sns_sqs_lambda_fanout_architecture/api/shop/internal/library/sns_client"
)

type IChargeUseCase interface {
	CreateCharge(ctx *gin.Context, request gen.CreateChargeRequestObject) (gen.CreateChargeResponseObject, error)
}

type IReservationUseCase interface {
	CreateReservation(ctx *gin.Context, request gen.CreateReservationRequestObject) (gen.CreateReservationResponseObject, error)
}

type chargeUseCase struct{ snsClient *sns_client.SNSWrapper }

type reservationUseCase struct{}

func NewChargeUseCase(snsClient *sns_client.SNSWrapper) IChargeUseCase {
	return &chargeUseCase{snsClient: snsClient}
}

func NewReservationUseCase() IReservationUseCase {
	return &reservationUseCase{}
}
