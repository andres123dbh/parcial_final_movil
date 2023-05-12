package interfaces

type UserITest struct {
	ID       int    `json:"id"`
	Username string `json:"email"`
	Password string `json:"contrasenna"`
}

type User struct {
	Email     string `json:"email"`
	Password  string `json:"contrasenna"`
	Photo     string `json:"foto"`
	Name      string `json:"nombre_completo"`
	Cellphone int    `json:"celular"`
	Position  string `json:"cargo"`
}

type RequestSignup struct {
	Email     string `json:"email"`
	Password  string `json:"password"`
	Photo     string `json:"photo"`
	Name      string `json:"name"`
	Cellphone int    `json:"cellphone"`
	Position  string `json:"position"`
	Model     string `json:"model"`
	UUID      string `json:"uuid"`
	Token_FMC string `json:"token_FMC"`
}

type RequestLogIn struct {
	Email     string `json:"email"`
	Password  string `json:"password"`
	Model     string `json:"model"`
	UUID      string `json:"uuid"`
	Token_FMC string `json:"token_FMC"`
}

type ResponseUsers struct {
	Email string `json:"email"`
	Photo string `json:"foto"`
	Name  string `json:"nombre_completo"`
}
