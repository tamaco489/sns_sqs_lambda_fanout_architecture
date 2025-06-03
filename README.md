### sns_sqs_lambda_fanout_architecture

```
[SNS Topic]
     │
     ├────▶ [SQS Queue: slack-sqs] ──▶ [Lambda: slack handler]
     │
     └────▶ [SQS Queue: line-message-sqs] ──▶ [Lambda: line handler]
```