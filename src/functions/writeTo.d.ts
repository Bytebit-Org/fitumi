/** The result of writeTo */
interface CallResult {
	/** Checks whether a write to the given faked table for the given key with a matching value did happen */
	didHappen(): boolean;

	/** Checks whether a write to the given faked table for the given key with a matching value did not happen */
	didNotHappen(): boolean;
}

export type writeTo = (fakedTable: object, key: object, value: unknown) => CallResult;
