package controller

import (
	"fmt"

	"github.com/gin-gonic/gin"
	"github.com/tamaco489/sns_sqs_lambda_fanout_architecture/api/shop/internal/gen"

	validation "github.com/go-ozzo/ozzo-validation/v4"
)

func (c *Controllers) CreateReservation(ctx *gin.Context, request gen.CreateReservationRequestObject) (gen.CreateReservationResponseObject, error) {

	err := validation.Validate(request.Body,
		validation.Required,
		validation.By(validateReservationRequest),
	)
	if err != nil {
		_ = ctx.Error(err)
		return gen.CreateCharge400Response{}, nil
	}

	res, err := c.reservationUseCase.CreateReservation(ctx, request)
	if err != nil {
		return gen.CreateReservation500Response{}, err
	}

	return res, nil
}

func validateReservationRequest(value interface{}) error {

	const MinProductID, MaxProductID = 1, 99999999
	const MinQuantity, MaxQuantity = 1, 10

	reservations, ok := value.(*gen.CreateReservationJSONRequestBody)
	if !ok {
		return fmt.Errorf("invalid request format")
	}
	if len(*reservations) == 0 {
		return fmt.Errorf("request body must contain at least one reservation item")
	}

	for _, item := range *reservations {
		if item.ProductId < MinProductID || item.ProductId > MaxProductID {
			return fmt.Errorf("product_id must be between %d and %d", MinProductID, MaxProductID)
		}
		if item.Quantity < MinQuantity || item.Quantity > MaxQuantity {
			return fmt.Errorf("quantity must be between %d and %d", MinQuantity, MaxQuantity)
		}
	}
	return nil
}
