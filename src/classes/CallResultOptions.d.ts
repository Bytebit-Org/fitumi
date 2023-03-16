import { CallMatchOptions } from "./CallMatchOptions";

/** The result of callTo */
export interface CallResultOptions<T = unknown> {
	/**
	 * Makes this behavior happen only once, then this call match will no longer be spotted
	 */
	once(): CallResultOptions;

	/**
	 * Makes this behavior happen only twice, then this call match will no longer be spotted
	 */
	twice(): CallResultOptions;

	/**
	 * Makes this behavior happen only the exact number of times specified, then this call match will no longer be spotted
	 */
	numberOfTimes(numberOfTimes: number): CallResultOptions;

	/**
	 * Gets the call match options reference that this CallResultOptions was created by.
	 */
	readonly andThen: CallMatchOptions<T>;
}
