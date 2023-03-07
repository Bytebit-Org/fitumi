# API documentation

## Symbols
### Wildcard
`wildcard`\
Used for comparing argument values and write values

## Creating fakes
### Using `a`
`a.fake()`\
Creates a faked table - complete with call and write history logging
#### Returns
The faked table

## Checking for calls to a faked table
### Using `a.callTo`
`a.callTo(fakedTable, ...)`\
Creates a new `CallMatchOptions` object associated with the given faked table and expected arguments
#### Parameters
- fakedTable\
The faked table that would be called\
Should only be created from [`a.fake()`](#Creating-fakes)
- ...\
A vararg of expected arguments\
For every [`wildcard`](#wildcard) given here, any value at all will match
#### Returns
A `CallMatchOptions` object, as described in [CallMatchOptions](#CallMatchOptions)

### Using `a.methodCallTo`
`a.methodCallTo(fakedTable, methodKey, ...)`\
Creates a new `CallMatchOptions` object associated with the given faked table and expected arguments,\
injecting a reference to `fakedTable` as the first argument so as to make faking calls to methods look nicer in tests
#### Parameters
- fakedTable\
The faked table that would be called\
Should only be created from [`a.fake()`](#Creating-fakes)
- methodKey\
The key of the method to fake in the fakedTable
- ...\
A vararg of expected arguments\
For every [`wildcard`](#wildcard) given here, any value at all will match
#### Returns
A `CallMatchOptions` object, as described in [CallMatchOptions](#CallMatchOptions)

### CallMatchOptions
`callMatchOptions:countNumberOfMatchingCalls()`\
Counts the number of matching calls that have been invoked against the source faked table with appropriate parameters as per the source callTo arguments
#### Returns
The number of matching calls

`callMatchOptions:didHappen()`\
Checks whether a call with the matching arguments did happen
#### Returns
A boolean indicating whether a call with the matching arguments did happen

`callMatchOptions:didNotHappen()`\
Checks whether a call with the matching arguments did not happen
#### Returns
A boolean indicating whether a call with the matching arguments did not happen

`callMatchOptions:executes(callback)`\
Sets calls with matching arguments to execute the given callback - the arguments to the call are passed to the callback
#### Parameters
- callback\
The callback to invoke with the given arguments
#### Returns
A `CallBehaviorOptions` object, as described in [CallBehaviorOptions](#CallBehaviorOptions)

`callMatchOptions:returns(...)`\
Sets calls with matching arguments to return the given values
#### Parameters
- ...\
The values to return; if there are multiple, will be returned as a tuple
#### Returns
A `CallBehaviorOptions` object, as described in [CallBehaviorOptions](#CallBehaviorOptions)

`callMatchOptions:throws(...)`\
Sets calls with matching arguments to error with the given values
#### Parameters
- ...\
The values to error with
#### Returns
A `CallBehaviorOptions` object, as described in [CallBehaviorOptions](#CallBehaviorOptions)

### CallBehaviorOptions
`callBehaviorOptions:once()`\
Sets this call behavior to only be used once, then discarded to make way for other matching call behaviors
#### Returns
A reference back to the same `CallBehaviorOptions` instance

`callBehaviorOptions:twice()`\
Sets this call behavior to only be used twice, then discarded to make way for other matching call behaviors
#### Returns
A reference back to the same `CallBehaviorOptions` instance

`callBehaviorOptions:numberOfTimes(numberOfTimes)`\
Sets this call behavior to only be used exactly the number of times specified, then discarded to make way for other matching call behaviors
#### Returns
A reference back to the same `CallBehaviorOptions` instance

`callBehaviorOptions.andThen`\
Points back to the source `CallMatchOptions` for this `CallBehaviorOptions` instance

## Checking for writes to a faked table
### Using `a`
`a.writeTo(fakedTable, key, value)`\
Creates a set of methods for reading whether writes to the given faked table of the given key with a matching value happened or not
#### Returns
A table with a set of methods as described in [Result methods from writeTo](#Result-methods-from-writeTo)

### Result methods from callTo
`a.writeTo(...):didHappen()`\
Checks whether a write to the given faked table for the given key with a matching value did happen
#### Returns
A boolean indicating whether a write to the given faked table for the given key with a matching value did happen

`a.writeTo(...):didNotHappen()`\
Checks whether a write to the given faked table for the given key with a matching value did not happen
#### Returns
A boolean indicating whether a write to the given faked table for the given key with a matching value did not happen

## Clearing history
### Clearing call history
`clearCallHistory(fakedTable)`\
Clears the call history logged in the given faked table
#### Parameters
- fakedTable\
The faked table to clear the call history from

### Clearing write history
`clearWriteHistory(fakedTable[, key])`\
Clears the write history logged in the given faked table
If a key is provided, only the write history for that key is cleared, otherwise all write history is cleared
#### Parameters
- fakedTable\
The faked table to clear the write history from
- key\
An optional parameter that determines whether the write history for only a specific key is cleared; if `nil`, then the write history for the entire faked table is cleared
