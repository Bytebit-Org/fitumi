interface CallResult {
	didHappen(): boolean;
	didNotHappen(): boolean;
	returns(...args: ReadonlyArray<unknown>): void;
}

export type callTo = <T>(fakedTable: T, key: object, ...args: ReadonlyArray<unknown>) => CallResult;
