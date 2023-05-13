package configuration

import (
	"database/sql"
	"fmt"
	"os"

	_ "github.com/go-sql-driver/mysql"
	"github.com/joho/godotenv"
)

func GetDatabase() (*sql.DB, error) {
	var err error

	// get USER,PASSWORD and DATABASE from enviroment

	if err := godotenv.Load(); err != nil {
		fmt.Println("No .env file found")
	}

	user := os.Getenv("USER")
	password := os.Getenv("PASSWORD")
	data := os.Getenv("DATABASE")
	port := os.Getenv("PORT")

	uri := user + ":" + password + "@tcp(localhost:" + port + ")/" + data + "?parseTime=true"

	database, err := sql.Open("mysql", uri)
	if err != nil {
		return database, err
	}

	return database, nil
}
