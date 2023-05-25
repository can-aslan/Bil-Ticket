enum UserType {
	Company = 'Company',
	Traveler = 'Traveler',
}

export type User = {
	name: string;
	surname: string;
	email: string;
	TCK: string;
	phone: string;
	userType: UserType;
	accessToken: string;
	refreshToken: string;
};
