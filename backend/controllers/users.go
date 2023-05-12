package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"

	"github.com/andres123dbh/parcial_final_backend/configuration"
	"github.com/andres123dbh/parcial_final_backend/interfaces"
)

func Get_users(c *gin.Context) {
	database, err := configuration.GetDatabase()
	var users []interfaces.ResponseUsers

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": err,
		})
		return
	}

	results, err := database.Query("SELECT email, nombre_completo, foto FROM users")

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": err,
		})
		return
	}

	for results.Next() {
		var user interfaces.ResponseUsers
		err = results.Scan(&user.Email, &user.Name, &user.Photo)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				"error":   true,
				"message": err,
			})
			return
		}
		users = append(users, user)
	}

	c.JSON(http.StatusOK, gin.H{
		"error":   http.StatusOK,
		"message": "Get users",
		"users":   users,
	})
}
