# eventbridge

Two rules:

1. S3 `Object Created` → start `my_sfn`
2. `aws.states` execution status `SUCCEEDED` for `my_sfn` → invoke `my_lambda`
