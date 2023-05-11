package main

import (
	"github.com/andres123dbh/parcial_final_backend/routes"
	"github.com/gin-gonic/gin"
)

func main() {
	// Setup server
	engine := gin.Default()
	routes.SetupRoutes(engine)
	engine.Run()
}
