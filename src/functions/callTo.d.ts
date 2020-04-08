/** The result of callTo */
interface CallResult {
	/** Checks whether a call with the matching arguments did happen */
	didHappen(): boolean;

	/** Checks whether a call with the matching arguments did not happen */
	didNotHappen(): boolean;

	/**
	 * Sets calls with matching arguments to return the given values
	 * @param values The values to return; if there are multiple, will be returned as a tuple
	 */
	returns(...values: ReadonlyArray<unknown>): void;
}

export type callTo = (fakedTable: object, ...args: ReadonlyArray<unknown>) => CallResult;
