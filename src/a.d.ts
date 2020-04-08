import { callTo } from "./functions/callTo";
import { fake } from "./functions/fake";
import { writeTo } from "./functions/writeTo";

export type a = {
	/**
	 * Checks for a call to a given faked table with matching arguments and returns a set of methods
	 */
	callTo: callTo;

	/** Creates a faked table */
	fake: fake;

	/** Checks for a write to a given faked table with the given key for a matching value */
	writeTo: writeTo;
};
