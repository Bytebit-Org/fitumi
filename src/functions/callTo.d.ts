interface CallResult {
	returns(...args: ReadonlyArray<unknown>): void;
}

export declare function callTo<T>(fakedTable: T, key: object, ...args: ReadonlyArray<unknown>): CallResult;
