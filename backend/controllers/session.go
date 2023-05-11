package controllers

import (
	"database/sql"
	"net/http"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"

	"github.com/andres123dbh/parcial_final_backend/configuration"
	"github.com/andres123dbh/parcial_final_backend/interfaces"
	"github.com/andres123dbh/parcial_final_backend/utils"
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

// Handle the request to login with the user credentials
func Login(c *gin.Context) {
	var form interfaces.RequestLogIn

	if err := c.ShouldBindJSON(&form); err != nil {
		c.JSON(http.StatusBadRequest, "Invalid json")
		return
	}

	var result_pr_login uint64

	database, err := configuration.GetDatabase()

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": err,
		})
		return
	}

	results, err := database.Query("SELECT login(?, ?)", form.Email, form.Password)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": err,
		})
		return
	}

	for results.Next() {
		err := results.Scan(&result_pr_login)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				"error":   true,
				"message": err,
			})
			return
		}
	}

	if result_pr_login == 1 {
		var token_fmc sql.NullString
		results, err := database.Query("SELECT get_token_user(?,?,?)", form.Email, form.UUID, form.Model)

		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				"error":   true,
				"message": err,
			})
			return
		}

		for results.Next() {
			err := results.Scan(&token_fmc)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{
					"errorf":  true,
					"message": err,
				})
				return
			}
		}

		if token_fmc.String == "" {
			_, err = database.Query("CALL insert_token(?,?,?,?)", form.Email, form.UUID, form.Model, form.Token_FMC)

			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{
					"error":   true,
					"message": err,
				})
				return
			}
		}

		if token_fmc.String != form.Token_FMC {
			_, err = database.Query("CALL change_token_user(?,?,?,?)", form.Email, form.UUID, form.Model, form.Token_FMC)

			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{
					"error":   true,
					"message": err,
				})
				return
			}
		}

		token, err := utils.CreateAccessToken(form.Email)

		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				"error":   false,
				"message": err,
			})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"error":   http.StatusOK,
			"message": "Logged in successfully",
			"token":   token,
		})
		return
	} else {
		c.JSON(http.StatusUnauthorized, gin.H{
			"error":   true,
			"message": "Invalid Credentials",
		})
		return
	}
}
