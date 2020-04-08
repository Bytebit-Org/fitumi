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
### Using `a`
`a.callTo(fakedTable, ...)`\
Creates a set of methods for reading or handling calls to the given faked table with the provided arguments
#### Parameters
- fakedTable\
The faked table that would be called\
Should only be created from [`a.fake()`](#Creating-fakes)
- ...\
A vararg of expected arguments\
For every [`wildcard`](#wildcard) given here, any value at all will match
#### Returns
A table with a set of methods as described in [Result methods from callTo](#Result-methods-from-callTo)

### Result methods from callTo
`a.callTo(...):didHappen()`\
Checks whether a call with the matching arguments did happen
#### Returns
A boolean indicating whether a call with the matching arguments did happen

`a.callTo(...):didNotHappen()`\
Checks whether a call with the matching arguments did not happen
#### Returns
A boolean indicating whether a call with the matching arguments did not happen

`a.callTo(...):returns(...)`\
Sets calls with matching arguments to return the given values
#### Parameters
- ...\
The values to return; if there are multiple, will be returned as a tuple

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
