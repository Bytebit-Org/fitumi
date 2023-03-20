import { CallMatchOptions } from "../classes/CallMatchOptions";

export type callTo = <T = unknown>(fakedTable: T, ...args: T extends Callback ? Parameters<T> : ReadonlyArray<unknown>) => CallMatchOptions<T>;
