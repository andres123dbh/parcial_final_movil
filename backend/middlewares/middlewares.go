package middlewares

import (
	"github.com/andres123dbh/parcial_final_backend/utils"

	"net/http"

	"github.com/gin-gonic/gin"
)

func ProvideAccessToken() gin.HandlerFunc {
	return func(c *gin.Context) {
		// Get access token from header
		accessToken := c.GetHeader("accessToken")

		if accessToken == "" {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"message": "Access token is required"})
			return
		}

		// Check if access token is valid
		email, error := utils.ValidateAccessToken(accessToken)
		if error != nil {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"message": error.Error()})
			return
		}

		// Set user id to context
		c.Set("email", email)
	}
}
