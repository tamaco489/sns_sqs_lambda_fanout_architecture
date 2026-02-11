# Architecture Diagrams

[日本語版はこちら](README.ja.md)

Architecture diagrams for the SNS/SQS Lambda Fanout project in draw.io (`.drawio`) format.
Open with [draw.io Desktop](https://www.drawio.com/), [VS Code extension](https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio), or [app.diagrams.net](https://app.diagrams.net).

## 01. Infrastructure Overview

> [`01_infrastructure_overview.drawio`](01_infrastructure_overview.drawio)

VPC (10.1.0.0/16) with Public Subnets (AZ-a: 10.1.11.0/24 / AZ-d: 10.1.12.0/24). Key services: Lambda x3 (Shop API, Slack Batch, Line Batch), API Gateway v2, SNS, SQS x2, DLQ x4, ECR, Route 53, ACM, SNS VPC Endpoint, Internet Gateway.

![Infrastructure Overview](01_infrastructure_overview.png)

## 02. API Request Flow

> [`02_api_request_flow.drawio`](02_api_request_flow.drawio)

Client → Route 53 → API Gateway v2 (HTTP, ACM TLS) → Lambda (shop-api, Gin framework, port 8080) → SNS VPC Endpoint (Private DNS, HTTPS 443) → SNS Topic (stg-fanout-notifications). Shop API publishes charge notifications with message attributes for fanout filtering.

![API Request Flow](02_api_request_flow.png)

## 03. Fanout Message Flow

> [`03_fanout_message_flow.drawio`](03_fanout_message_flow.drawio)

SNS Topic filters messages by `type` attribute: `slack_message` → Slack SQS Queue, `line_message` → Line SQS Queue. Raw message delivery enabled. Each queue triggers a dedicated Lambda (batch_size=1). Failed messages (max 3 retries) route to DLQ (2-day retention). SNS subscription failures also captured in separate DLQs.

![Fanout Message Flow](03_fanout_message_flow.png)
