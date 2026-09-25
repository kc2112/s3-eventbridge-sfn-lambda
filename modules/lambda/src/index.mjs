/**
 * my_lambda — Node.js 24
 * Invoked by EventBridge after my_sfn succeeds.
 * Event shape: Step Functions Execution Status Change.
 * detail.input / detail.output are JSON strings of the original S3 Object Created payload.
 */
function parseMaybeJson(value) {
  if (value == null) return undefined;
  if (typeof value !== "string") return value;
  try {
    return JSON.parse(value);
  } catch {
    return value;
  }
}

export const handler = async (event, context) => {
  const original = parseMaybeJson(event?.detail?.output) ?? parseMaybeJson(event?.detail?.input) ?? {};
  const s3Detail = original?.detail ?? original;
  const bucket = s3Detail?.bucket?.name ?? process.env.BUCKET_NAME;
  const rawKey = s3Detail?.object?.key;
  const key = rawKey ? decodeURIComponent(String(rawKey).replace(/\+/g, " ")) : undefined;

  console.log(JSON.stringify({
    requestId: context.awsRequestId,
    source: event?.source,
    detailType: event?.["detail-type"],
    executionArn: event?.detail?.executionArn,
    sfnStatus: event?.detail?.status,
    bucket,
    key,
    size: s3Detail?.object?.size,
    reason: s3Detail?.reason,
  }));

  return {
    ok: true,
    requestId: context.awsRequestId,
    bucket,
    key,
    receivedAt: new Date().toISOString(),
  };
};
