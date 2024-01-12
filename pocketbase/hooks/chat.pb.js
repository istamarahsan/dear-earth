/// <reference path="../pb_data/types.d.ts" />

routerAdd("POST", "/api/dearearth/chat/create", (ctx) => {
    const user = $apis.requestInfo(ctx).authRecord
    if (user === undefined) {
        return ctx.noContent(400)
    }

    const starter = new Record()
    $app.dao().recordQuery("chat_starters").limit(1).one(starter)
    const starterId = starter.getId()
    const chats = $app.dao().findCollectionByNameOrId("chats")
    const newChat = new Record(chats, {
        user: user.id,
        starter: starterId
    })
    $app.dao().saveRecord(newChat)

    return ctx.json(200, {
        id: newChat.id
    })
}, $apis.requireRecordAuth("users"))

routerAdd("POST", "/api/dearearth/chat/respond/:id", (ctx) => {
    /**
     * 
     * @param {{ title: string, content: string }} starter
     * @param {string} initialUserResponse 
     */
    const buildInitialPrompt = ({ title, content }, initialUserResponse) => `
        You are a chatbot designed to help people increase their climate literacy. 
        You know a lot about the climate, but mainly what you do is to respond to me and ask relevant questions to encourage me to find out more about the topic and also do some self-reflection about my climate literacy. 
        If I respond in a way that seems out of topic, just reply with "sorry, I don't understand what you mean".
        For additional context in giving me information, I live in Indonesia. 
        We are going to have a chat. 
        The topic is "${title}". 
        You just asked me: "${content}". 
        Here's my response: "${initialUserResponse}"
    `

    const vertex = require(`${__hooks}/vertex.js`)
    const gcloudToken = $os.getenv("GCLOUD_ACCESS_TOKEN")

    const chatId = ctx.pathParam("id")
    if (chatId === undefined) {
        return ctx.noContent(400)
    }

    const user = $apis.requestInfo(ctx).authRecord
    if (user === undefined) {
        return ctx.noContent(400)
    }

    const userResponseText = $apis.requestInfo(ctx).data.content
    if (typeof userResponseText !== "string") {
        return ctx.noContent(400)
    }

    const chat = $app.dao().findRecordById("chats", chatId)

    $app.dao().expandRecord(chat, ["user", "history", "starter"], null)

    if (chat.expandedOne("user").getId() !== user.id) {
        return ctx.noContent(401)
    }

    const chatIsNew = chat.expandedAll("history").length === 0

    let modelResponse = chatIsNew
        ? vertex.chat(
            gcloudToken, 
            [
                { 
                    role: "USER", 
                    text: buildInitialPrompt(
                        { 
                            title: chat.expandedOne("starter").getString("title"), 
                            content: chat.expandedOne("starter").getString("content") 
                        },
                        userResponseText
                    ) 
                }
            ],
            $http.send,
            $app.logger()
        )
        : vertex.chat(
            gcloudToken,
            [
                ...chat.expandedAll("history")
                    .sort((a, b) => a.getInt("order") - b.getInt("order"))
                    .map((history) => ({
                        role: history.getInt("order") % 2 === 0 ? "MODEL" : "USER",
                        text: history.getString("content")
                    })),
                {
                    role: "USER",
                    text: userResponseText
                }
            ],
            $http.send,
            $app.logger()
        )

    const histories = $app.dao().findCollectionByNameOrId("chat_histories")
    const latestHistoryOrder = chat.expandedAll("history")
        .map(it => it.getInt("order"))
        .reduce((max, next) => next > max ? next : max, 0)

    const userResponseHistory = new Record(histories, {
        order: latestHistoryOrder + 1,
        content: userResponseText
    })

    const modelResponseHistory = new Record(histories, {
        order: latestHistoryOrder + 2,
        content: modelResponse
    })

    $app.dao().saveRecord(userResponseHistory)
    $app.dao().saveRecord(modelResponseHistory)

    chat.set("history", [...chat.getStringSlice("history"), userResponseHistory.getId(), modelResponseHistory.getId()])
    $app.dao().saveRecord(chat)

    return ctx.json(200, {
        content: modelResponse
    })
}, $apis.requireRecordAuth("users"))

// TODO: analyze submission
routerAdd("POST", "/api/dearearth/chat/submit/:id", (ctx) => {
    const chatId = ctx.pathParam("id")
    if (chatId === undefined) {
        return ctx.noContent(400)
    }

    const user = $apis.requestInfo(ctx).authRecord
    if (user === undefined) {
        return ctx.noContent(400)
    }

    const { caption, imageData } = $apis.requestInfo(ctx).data
    if (typeof caption !== "string") {
        return ctx.noContent(400)
    }

    const chat = $app.dao().findRecordById("chats", chatId)
    $app.dao().expandRecord(chat, ["user"], null)

    if (chat.expandedOne("user").getId() !== user.id) {
        return ctx.noContent(401)
    }

    if (typeof imageData === "string") {
        const bytesFromBase64 = atob(imageData)
        const file = $filesystem.fileFromBytes(bytesFromBase64, `submission_${chat.getId()}.png`)
        chat.set("submission_image", file)
    }
    chat.set("submission_caption", caption)
    $app.dao().saveRecord(chat)

    return ctx.noContent(200)
}, $apis.requireRecordAuth("users"))
