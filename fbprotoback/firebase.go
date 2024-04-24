package main

import (
	"context"
	"log"
	"strings"

	firebase "firebase.google.com/go"
	"github.com/gin-gonic/gin"
	"google.golang.org/api/option"
)

func FirebaseAuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		opt := option.WithCredentialsFile("./serviceAccountKey.json")
		app, err := firebase.NewApp(context.Background(), nil, opt)
		if err != nil {
			log.Println("error initializing app: ", err)
			c.JSON(500, gin.H{"error": "error initializing app"})
		}

		client, err := app.Auth(context.Background())
		if err != nil {
			log.Println("error getting Auth client: ", err)
			c.JSON(500, gin.H{"error": "error getting Auth client"})
		}
		accessToken := strings.TrimPrefix(c.GetHeader("Authorization"), "Bearer ")
		idToken, err := client.VerifyIDToken(context.Background(), accessToken)
		if err != nil {
			log.Println("error verifying ID token: ", err)
			c.JSON(401, gin.H{"error": "error verifying ID token"})
		}
		// Set the user in the context
		c.Set("user", idToken)
		c.Next()
	}
}
