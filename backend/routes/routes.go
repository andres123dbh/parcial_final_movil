package routes

import (
	"github.com/andres123dbh/parcial_final_backend/controllers"
	//"github.com/andres123dbh/parcial_final_backend/middlewares"
	"github.com/gin-gonic/gin"
)

func SetupRoutes(engine *gin.Engine) {
	// Test
	engine.GET("/test", controllers.Test)

	//Session
	engine.POST("/signup", controllers.Signup)
}
