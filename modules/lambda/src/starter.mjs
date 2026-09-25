import { SFNClient, StartExecutionCommand } from "@aws-sdk/client-sfn";

const sfn = new SFNClient({});

export const handler = async (event) => {
  const stateMachineArn = process.env.STATE_MACHINE_ARN;
  const executions = (event.Records ?? []).map((record) =>
    sfn.send(new StartExecutionCommand({
      stateMachineArn,
      input: record.body,
    })),
  );
  await Promise.all(executions);
  return { started: executions.length };
};
