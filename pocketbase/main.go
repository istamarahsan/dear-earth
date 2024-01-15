package main

import (
	"context"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"

	_ "dearearthpb/migrations"

	"cloud.google.com/go/vertexai/genai"
	"github.com/labstack/echo/v5"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/models"
	"github.com/pocketbase/pocketbase/plugins/migratecmd"
	"golang.org/x/oauth2/google"
	"google.golang.org/api/option"
)

const REGION = "asia-southeast1"
const MODEL = "gemini-pro"

type ChatRequestChatMessage struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

type ChatRequest struct {
	StarterName string                   `json:"starter"`
	History     []ChatRequestChatMessage `json:"history"`
}

type ChatResponse struct {
	Content string `json:"content"`
}

type ChatStarter struct {
	Name    string
	Content string
}

func main() {
	ctx := context.Background()

	gcreds, err := loadGoogleCredentials(ctx)

	client, err := genai.NewClient(ctx, gcreds.ProjectID, REGION, option.WithCredentials(gcreds))
	if err != nil {
		log.Fatal(err)
	}

	model := client.GenerativeModel(MODEL)
	model.SetCandidateCount(1)
	model.SafetySettings = append(model.SafetySettings, &genai.SafetySetting{
		Category:  genai.HarmCategoryDangerousContent,
		Threshold: genai.HarmBlockNone,
	})
	model.SetMaxOutputTokens(1024)
	model.SetTemperature(0.4)
	model.SetTopP(1)

	app := pocketbase.New()

	app.OnBeforeServe().Add(func(e *core.ServeEvent) error {
		e.Router.POST("/api/dearearth/chat", func(c echo.Context) error {
			var data ChatRequest
			err := json.NewDecoder(c.Request().Body).Decode(&data)
			if err != nil || len(data.History) == 0 {
				return c.NoContent(http.StatusBadRequest)
			}
			for _, msg := range data.History {
				if msg.Role != "USER" && msg.Role != "MODEL" {
					return c.JSON(http.StatusBadRequest, "roles must be either USER or MODEL")
				}
			}

			starterRecord := models.Record{}

			err = app.Dao().
				RecordQuery("chat_starters").
				Select("name", "content").
				AndWhere(dbx.HashExp{"name": data.StarterName}).
				Limit(1).
				Build().
				One(&starterRecord)
			if err != nil {
				app.Logger().Debug(err.Error())
				return c.JSON(http.StatusNotFound, "Starter not found")
			}

			starter := parseStarter(starterRecord)
			initialPrompt := constructInitialPrompt(starter, data.History[0].Content)

			chat := model.StartChat()
			isFirstMessage := len(data.History) == 1
			if isFirstMessage {
				modelResponse, err := chat.SendMessage(c.Request().Context(), genai.Text(initialPrompt))
				if err != nil {
					app.Logger().Error(err.Error())
					return c.NoContent(http.StatusInternalServerError)
				}
				return c.JSON(http.StatusOK, ChatResponse{
					Content: string(modelResponse.Candidates[0].Content.Parts[0].(genai.Text)),
				})
			} else {
				history := []*genai.Content{}

				history = append(history, &genai.Content{
					Role: "USER",
					Parts: []genai.Part{
						genai.Text(initialPrompt),
					},
				})

				for i := 1; i < len(data.History)-1; i++ {
					content := data.History[i].toContent()
					history = append(history, &content)
				}
				chat.History = append(chat.History, history...)

				last := data.History[len(data.History)-1]
				if last.Role != "USER" {
					return c.JSON(http.StatusBadRequest, "Final message must be from role USER")
				}

				response, err := chat.SendMessage(c.Request().Context(), genai.Text(last.Content))
				if err != nil {
					app.Logger().Error(err.Error())
					return c.NoContent(http.StatusInternalServerError)
				}
				responseText := response.Candidates[0].Content.Parts[0].(genai.Text)
				return c.JSON(http.StatusOK, ChatResponse{
					Content: string(responseText),
				})
			}
		}, apis.ActivityLogger(app), apis.RequireRecordAuth())
		return nil
	})

	migratecmd.MustRegister(app, app.RootCmd, migratecmd.Config{
		Automigrate: false,
	})

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}

func (self ChatRequestChatMessage) toContent() genai.Content {
	return genai.Content{
		Role:  strings.ToUpper(self.Role),
		Parts: []genai.Part{genai.Text(self.Content)},
	}
}

func parseStarter(rec models.Record) ChatStarter {
	return ChatStarter{
		Name:    rec.GetString("name"),
		Content: rec.GetString("content"),
	}
}

func constructInitialPrompt(starter ChatStarter, userResponse string) string {
	return fmt.Sprintf(
		`
        You are a chatbot designed to help people increase their climate literacy. 
        You know a lot about the climate, but mainly what you do is to respond to me and ask relevant questions to encourage me to find out more about the topic and also do some self-reflection about my climate literacy. 
        If I respond in a way that seems out of topic, just reply with "sorry, I don't understand what you mean".
        For additional context in giving me information, I live in Indonesia. 
        We are going to have a chat. 
        You just asked me: "%s". 
        Here's my response: "%s"
    	`,
		starter.Content,
		userResponse,
	)
}

var GCREDS_SCOPES = []string{"https://www.googleapis.com/auth/cloud-platform"}

func loadGoogleCredentials(ctx context.Context) (*google.Credentials, error) {
	if gcredsB64, present := os.LookupEnv("GCREDS_B64"); present {
		decoded, err := base64.StdEncoding.DecodeString(gcredsB64)
		if err != nil {
			return nil, err
		}

		gcreds, err := google.CredentialsFromJSON(ctx, decoded, GCREDS_SCOPES...)
		if err != nil {
			return nil, err
		}

		return gcreds, nil
	}

	gcredsJson, err := os.ReadFile("gcreds/gcreds.json")
	if err != nil {
		return nil, err
	}

	gcreds, err := google.CredentialsFromJSON(ctx, gcredsJson, GCREDS_SCOPES...)
	if err != nil {
		return nil, err
	}

	return gcreds, nil
}
