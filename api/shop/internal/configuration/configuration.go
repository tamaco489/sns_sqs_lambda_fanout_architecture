package configuration

import (
	"context"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/kelseyhightower/envconfig"
)

var globalConfig Config

type Config struct {
	API struct {
		Env         string `envconfig:"API_ENV" default:"dev"`
		Port        string `envconfig:"API_PORT" default:"8080"`
		ServiceName string `envconfig:"API_SERVICE_NAME" default:"shop-api"`
	}
	SQS struct {
		PushNotificationURL string `envconfig:"SQS_PUSH_NOTIFICATION_URL"`
	}
	Logging   string `envconfig:"LOGGING" default:"off"`
	AWSConfig aws.Config
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
