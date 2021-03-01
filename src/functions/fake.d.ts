export type fake = <T>() => {
	-readonly [P in keyof T]: T[P];
};
