package controllers

import (
	"log"
	"net/http"

	"github.com/andres123dbh/parcial_final_backend/configuration"
	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
	//"github.com/andres123dbh/parcial_final_backend/interfaces"
)

type UserI struct {
	ID       int    `json:"id"`
	Username string `json:"email"`
	Password string `json:"contrasenna"`
}

func Test(c *gin.Context) {
	database, err := configuration.GetDatabase()

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": err,
		})
		return
	}

	results, err := database.Query("SELECT id, email, contrasenna FROM users")
	if err != nil {
		panic(err.Error())
	}

	for results.Next() {
		var user UserI
		err = results.Scan(&user.ID, &user.Username, &user.Password)
		if err != nil {
			panic(err.Error())
		}
		log.Printf(user.Username + " " + user.Password)
	}

	c.IndentedJSON(http.StatusOK, gin.H{"error": false,
		"message": database})

}
