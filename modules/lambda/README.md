# lambda

Node.js 24 Lambda (`my_lambda`) plus execution role and log group. Invoked by EventBridge after `my_sfn` succeeds. Grants `s3:GetObject` on the source bucket.
