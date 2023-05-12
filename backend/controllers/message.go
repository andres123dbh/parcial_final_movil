package controllers

import (
	"context"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
	"github.com/lib/pq"

	"github.com/andres123dbh/parcial_final_backend/configuration"
	"github.com/andres123dbh/parcial_final_backend/interfaces"
	"github.com/andres123dbh/parcial_final_backend/utils"

	"firebase.google.com/go/messaging"
)

func SendMessage(c *gin.Context) {
	var form interfaces.RequestSendMessage

	if err := c.ShouldBindJSON(&form); err != nil {
		c.JSON(http.StatusBadRequest, "Invalid json")
		return
	}

	//var tokens interfaces.Tokens

	database, err := configuration.GetDatabase()

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": err,
		})
		return
	}

	results, err := database.Query("SELECT token_fmc FROM users_devices,users WHERE users_devices.user_id = ( SELECT users.id  WHERE users.email = ?)", form.RecipientEmail)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": err,
		})
		return
	}
	defer results.Close()

	var resourceList []string

	for results.Next() {
		var resource string
		if err := results.Scan(&resource); err != nil {
			// Check for a scan error.
			// Query rows will be closed with defer.
			fmt.Println(err)
		}
		resourceList = append(resourceList, resource)
	}

	client, err := utils.GetClientMessageFirebase()

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": "error firebase",
		})
		return
	}

	message := &messaging.MulticastMessage{
		Notification: &messaging.Notification{
			Title: form.Title,
			Body:  form.Message,
		},
		Tokens: resourceList,
	}

	response, err := client.SendMulticast(context.Background(), message)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": "error send meesage",
		})
		return
	}

	var responseString = "SuccessCount:" + strconv.Itoa(response.SuccessCount) + "-FailureCount:" + strconv.Itoa(response.FailureCount)

	_, err = database.Query("CALL save_sent_message(?,?,?,?,JSON_ARRAY(?),?)", form.Title, form.Message, form.SenderEmail, form.RecipientEmail, pq.Array(resourceList), responseString)

	if err != nil {
		fmt.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": err,
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"error":   false,
		"message": "Message sent",
	})
}
