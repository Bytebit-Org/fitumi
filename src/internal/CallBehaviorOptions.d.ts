import { CallMatchOptions } from "./CallMatchOptions";

/** The result of callTo */
export interface CallBehaviorOptions<T = unknown> {
	/**
	 * Makes this behavior happen only once, then this call match will no longer be spotted
	 */
	once(): CallBehaviorOptions;

	/**
	 * Makes this behavior happen only twice, then this call match will no longer be spotted
	 */
	twice(): CallBehaviorOptions;

	/**
	 * Makes this behavior happen only the exact number of times specified, then this call match will no longer be spotted
	 */
	numberOfTimes(numberOfTimes: number): CallBehaviorOptions;

	/**
	 * Gets the call match options reference that this CallBehaviorOptions was created by.
	 */
	readonly andThen: CallMatchOptions<T>;
}
