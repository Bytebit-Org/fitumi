import { callTo } from "./functions/callTo";
import { fake } from "./functions/fake";
import { methodCallTo } from "./functions/methodCallTo";
import { valueGeneratorCallback } from "./functions/valueGeneratorCallback";
import { writeTo } from "./functions/writeTo";

export type a = {
	/**
	 * Checks for a call to a given faked table with matching arguments and returns a set of methods
	 */
	callTo: callTo;

	/** Creates a faked table */
	fake: fake;

	/**
	 * Checks for a method call to a given faked table with matching arguments and returns a set of methods
	 */
	methodCallTo: methodCallTo;

	/**
	 * Creates a value generator callback that will just return the result of calling the provided callback.
	 * Useful for a.callTo(...):returns() usage.
	 */
	valueGeneratorCallback: valueGeneratorCallback;

	/** Checks for a write to a given faked table with the given key for a matching value */
	writeTo: writeTo;
};
