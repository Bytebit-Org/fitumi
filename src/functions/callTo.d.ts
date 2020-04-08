interface CallResult {
	didHappen(): boolean;
	didNotHappen(): boolean;
	returns(...args: ReadonlyArray<unknown>): void;
}

export type callTo = (fakedTable: object, ...args: ReadonlyArray<unknown>) => CallResult;
