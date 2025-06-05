package controller

import (
	"github.com/tamaco489/sns_sqs_lambda_fanout_architecture/api/shop/internal/configuration"
	"github.com/tamaco489/sns_sqs_lambda_fanout_architecture/api/shop/internal/library/sns_client"
	"github.com/tamaco489/sns_sqs_lambda_fanout_architecture/api/shop/internal/usecase"
)

type Controllers struct {
	config             configuration.Config
	chargeUseCase      usecase.IChargeUseCase
	reservationUseCase usecase.IReservationUseCase
}

func NewControllers(cnf configuration.Config) (*Controllers, error) {
	// library
	snsClient := sns_client.NewSNSClient(cnf.AWSConfig)

	// usecase
	chargeUseCase := usecase.NewChargeUseCase(snsClient)
	reservationUseCase := usecase.NewReservationUseCase()

	return &Controllers{
		cnf,
		chargeUseCase,
		reservationUseCase,
	}, nil
}
