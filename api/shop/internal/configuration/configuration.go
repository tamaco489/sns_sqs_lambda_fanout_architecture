package configuration

import (
	"context"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/kelseyhightower/envconfig"
)

var globalConfig Config

type Config struct {
	AWSConfig aws.Config
	Logging   string `envconfig:"LOGGING" default:"off"`
	API       struct {
		Env         string `envconfig:"API_ENV" default:"dev"`
		Port        string `envconfig:"API_PORT" default:"8080"`
		ServiceName string `envconfig:"API_SERVICE_NAME" default:"shop-api"`
	}
	SNS struct {
		// todo: これ secret manager から取得できるようにする。
		ChargeNotificationsTopicArn string `envconfig:"SNS_CHARGE_NOTIFICATIONS_TOPIC_ARN" default:"arn:aws:sns:ap-northeast-1:123456789012:stg-fanout-notifications"`
	}
}

func Get() Config { return globalConfig }

func Load(ctx context.Context) (Config, error) {
	envconfig.MustProcess("", &globalConfig)
	ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	if err := loadAWSConf(ctx); err != nil {
		return globalConfig, err
	}

	return globalConfig, nil
}
