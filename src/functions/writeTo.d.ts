interface CallResult {
	didHappen(): boolean;
	didNotHappen(): boolean;
}

export type writeTo = (fakedTable: object, key: object, value: unknown) => CallResult;
