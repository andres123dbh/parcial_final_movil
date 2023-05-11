package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	//"github.com/andres123dbh/parcial_final_backend/configuration"
	//"github.com/andres123dbh/parcial_final_backend/interfaces"
)

func Test(c *gin.Context) {

	c.IndentedJSON(http.StatusOK, gin.H{"error": false,
		"message": "hola"})

}
