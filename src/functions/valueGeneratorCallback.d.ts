export type valueGeneratorCallback = <A extends Array<never>, R>(callback: (...args: A) => R) => R;
