package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/sns_sqs_lambda_fanout_architecture/api/shop/internal/gen"
)

func (c *Controllers) CreateUser(ctx *gin.Context, request gen.CreateUserRequestObject) (gen.CreateUserResponseObject, error) {

	// NOTE: uidは一旦固定値で返す
	var uid int64 = 10001001

	return gen.CreateUser201JSONResponse{
		UserId: uid,
	}, nil
}
