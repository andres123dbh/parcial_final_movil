package utils

import (
	"context"

	_ "github.com/go-sql-driver/mysql"

	firebase "firebase.google.com/go"
	"firebase.google.com/go/messaging"
	"google.golang.org/api/option"
)

func GetClientMessageFirebase() (*messaging.Client, error) {

	opt := option.WithCredentialsFile("controllers/serviceAccountKey.json")
	config := &firebase.Config{ProjectID: "parcial-final-movil-fbb16"}
	app, err := firebase.NewApp(context.Background(), config, opt)

	if err != nil {
		return nil, err
	}

	client, err := app.Messaging(context.Background())

	if err != nil {
		return nil, err
	}

	return client, nil
}
