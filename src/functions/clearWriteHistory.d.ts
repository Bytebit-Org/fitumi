/**
 * Clears write history for the given faked table.
 * If a key is provided, only the write history for that key is cleared, otherwise all write history is cleared.
 */
export type clearWriteHistory = (fakedTable: object, key?: object) => void;
