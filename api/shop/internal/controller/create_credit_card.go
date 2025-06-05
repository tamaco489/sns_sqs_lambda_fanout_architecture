package controller

import (
	"time"

	"github.com/gin-gonic/gin"
	"github.com/tamaco489/sns_sqs_lambda_fanout_architecture/api/shop/internal/gen"
)

func (c *Controllers) CreateCreditCard(ctx *gin.Context, request gen.CreateCreditCardRequestObject) (gen.CreateCreditCardResponseObject, error) {

	time.Sleep(500 * time.Millisecond)

	return gen.CreateCreditCard204Response{}, nil
}
