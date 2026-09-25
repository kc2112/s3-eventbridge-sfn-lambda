# lambda

Reusable Node.js 24 function module (execution role, logs, optional extra policy).

Used twice in the pipeline:

- `module.throttle` — SQS consumer that calls `StartExecution` (`src/throttle.mjs`)
- `module.process` — in-state-machine passthrough (`src/passthrough.mjs`)
