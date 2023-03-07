import { CallMatchOptions } from "../internal/CallMatchOptions";

export type methodCallTo = <T, K extends keyof T>(fakedObject: T, methodName: K, ...args: T[K] extends Callback ? Parameters<T[K]> : ReadonlyArray<unknown>) => CallMatchOptions<T[K]>;
