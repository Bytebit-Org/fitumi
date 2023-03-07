import { CallResult } from "../internal/CallResult";

export type methodCallTo = <T, K extends keyof T>(fakedObject: T, methodName: K, ...args: T[K] extends Callback ? Parameters<T[K]> : ReadonlyArray<unknown>) => CallResult<T[K]>;
