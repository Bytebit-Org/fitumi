import { CallResult } from "../internal/CallResult";

export type callTo = <T = unknown>(fakedTable: object, ...args: T extends Callback ? Parameters<T> : ReadonlyArray<unknown>) => CallResult<T>;
