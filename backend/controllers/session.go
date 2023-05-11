package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"

	"github.com/andres123dbh/parcial_final_backend/configuration"
	"github.com/andres123dbh/parcial_final_backend/interfaces"
)

// Handle the request to create a new user
func Signup(c *gin.Context) {
	var userI interfaces.RequestSignup

	if err := c.ShouldBindJSON(&userI); err != nil {
		c.JSON(http.StatusBadRequest, "Invalid json")
		return
	}

	database, err := configuration.GetDatabase()

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": err,
		})
		return
	}

	_, err = database.Query("CALL signup(?,?,?,?,?,?)", userI.Email, userI.Password, userI.Photo, userI.Name, userI.Cellphone, userI.Position)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": err,
		})
		return
	}

	_, err = database.Query(" CALL insert_token(?,?,?,?)", userI.Email, userI.UUID, userI.Model, userI.Token_FMC)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": err,
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"error":   false,
		"message": "User Created",
	})
}
