export type fake = <T>() => T extends Callback ? T : {
	-readonly [P in keyof T]: T[P];
};
