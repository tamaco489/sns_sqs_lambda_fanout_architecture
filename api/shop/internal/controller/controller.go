package controller

import (
	"github.com/tamaco489/sns_sqs_lambda_fanout_architecture/api/shop/internal/configuration"
	"github.com/tamaco489/sns_sqs_lambda_fanout_architecture/api/shop/internal/usecase"
)

type Controllers struct {
	config             configuration.Config
	chargeUseCase      usecase.IChargeUseCase
	reservationUseCase usecase.IReservationUseCase
}

func NewControllers(cnf configuration.Config) (*Controllers, error) {

	// sqsClient, err := sqs_client.NewSQSClient(cnf.AWSConfig, cnf.API.Env)
	// if err != nil {
	// 	return nil, fmt.Errorf("failed to init sqs client: %w", err)
	// }

	// chargeUseCase := usecase.NewChargeUseCase(sqsClient)
	chargeUseCase := usecase.NewChargeUseCase()
	reservationUseCase := usecase.NewReservationUseCase()

	return &Controllers{
		cnf,
		chargeUseCase,
		reservationUseCase,
	}, nil
}
