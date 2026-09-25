# step-function

STANDARD state machine `process-data`: invoke `process-<region>`, then `sqs:sendMessage` to the output queue.
