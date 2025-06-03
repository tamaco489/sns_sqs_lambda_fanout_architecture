### sns_sqs_lambda_fanout_architecture

```
[SNS Topic]
     │
     ├────▶ [SQS Queue: slack-message-sqs] ──▶ [Lambda: slack message handler]
     │
     └────▶ [SQS Queue: line-message-sqs] ──▶ [Lambda: line message handler]
```
