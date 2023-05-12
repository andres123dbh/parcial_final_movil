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
		"error":   false,
		"message": "Get users",
		"users":   users,
	})
}

func Information(c *gin.Context) {
	var form interfaces.RequestInformation

	if err := c.ShouldBindJSON(&form); err != nil {
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

	results, err := database.Query("SELECT email, nombre_completo, foto, celular, cargo FROM users WHERE email=?", form.Email)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": err,
		})
		return
	}

	var user interfaces.ResponseUser

	for results.Next() {
		err = results.Scan(&user.Email, &user.Name, &user.Photo, &user.Cellphone, &user.Position)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				"error":   true,
				"message": err,
			})
			return
		}
	}

	c.JSON(http.StatusOK, gin.H{
		"error":   false,
		"message": "Get infomation",
		"user":    user,
	})
}
