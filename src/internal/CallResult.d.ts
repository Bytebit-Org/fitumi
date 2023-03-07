/** The result of callTo */
export interface CallResult<T = unknown> {
	/**
	 * Makes calls with matching arguments execute the given callback before throwing or returning
	 * @param callback
	 */
	executes(callback: T extends Callback ? (...args: Parameters<T>) => void : (...args: ReadonlyArray<unknown>) => void): CallResult<T>;

	/** Checks whether a call with the matching arguments did happen */
	didHappen(): boolean;

	/** Checks whether a call with the matching arguments did not happen */
	didNotHappen(): boolean;

	/**
	 * Makes calls with matching arguments throw the given error arguments.
	 * Note that this will take precedence over a matching return value
	 * @param errorArgs The arguments to include in the error call
	 */
	throws(errorArgs: unknown): CallResult<T>;

	/**
	 * Sets calls with matching arguments to return the given values.
	 * Note that if there is a matching error to be thrown, it will be thrown instead of this value being returned.
	 * @param values The values to return; if there are multiple, will be returned as a tuple
	 */
	returns(...values: T extends Callback ? ReturnType<T> extends [] ? ReturnType<T> : [ReturnType<T>] : ReadonlyArray<unknown>): CallResult<T>;
}