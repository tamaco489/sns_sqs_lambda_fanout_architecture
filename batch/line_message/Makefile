# =================================================================
# awsリソースいろいろ操作する時用のやつ
# =================================================================
VERSION := line_message_batch_v0.0.0

# ecr
.PHONY: auth push get-images delete-images
auth:
	aws ecr get-login-password --region ap-northeast-1 --profile ${AWS_PROFILE} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com

push: auth
	docker build --platform linux/amd64 --no-cache -t $(AWS_ACCOUNT_ID).dkr.ecr.ap-northeast-1.amazonaws.com/stg-line-message-batch:$(VERSION) -f ./build/Dockerfile.line_message .
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/stg-line-message-batch:$(VERSION)

get-images:
	aws ecr list-images --repository-name stg-line-message-batch --region ap-northeast-1 --profile ${AWS_PROFILE} --query 'imageIds[*]' | jq .

delete-images:
	@aws ecr list-images --repository-name stg-line-message-batch --region ap-northeast-1 --profile ${AWS_PROFILE} --query 'imageIds[*]' --output json > /tmp/images.json
	@cat /tmp/images.json | jq -c '.[]' | while read -r image_id; do \
		aws ecr batch-delete-image --repository-name stg-line-message-batch --region ap-northeast-1 --profile ${AWS_PROFILE} --image-ids $${image_id}; \
	done | jq .

# lambda
.PHONY: deploy
deploy: push
	aws lambda update-function-code  --profile ${AWS_PROFILE} \
		--function-name stg-line-message-batch \
		--image-uri $(AWS_ACCOUNT_ID).dkr.ecr.ap-northeast-1.amazonaws.com/stg-line-message-batch:$(VERSION) | jq .

# sns
sns-publish:
	aws sns publish \
		--topic-arn arn:aws:sns:ap-northeast-1:$(AWS_ACCOUNT_ID):stg-fanout-notifications \
    --message "send line message" \
    --message-attributes '{"type": {"DataType": "String", "StringValue": "line_message"}}' \
		--profile ${AWS_PROFILE} | jq .

# sqs
sqs-receive:
	aws sqs receive-message \
		--queue-url https://sqs.ap-northeast-1.amazonaws.com/$(AWS_ACCOUNT_ID)/stg-line-message-lambda-process-standard-sqs \
		--max-number-of-messages 1 \
		--wait-time-seconds 5 \
		--profile ${AWS_PROFILE} | jq .
