import { CallMatchOptions } from "../internal/CallMatchOptions";

export type callTo = <T = unknown>(fakedTable: object, ...args: T extends Callback ? Parameters<T> : ReadonlyArray<unknown>) => CallMatchOptions<T>;
