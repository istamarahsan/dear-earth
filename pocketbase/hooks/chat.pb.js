/// <reference path="../pb_data/types.d.ts" />

routerAdd("POST", "/api/dearearth/chat/create", (ctx) => {
    const user = $apis.requestInfo(ctx).authRecord
    if (user === undefined) {
        return ctx.noContent(400)
    }
    
    const tempFixedStarterIdx = 0
    const starterId = $app.dao().findRecordsByFilter("chat_starters", "", "", 1)[tempFixedStarterIdx].getId()
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
    const chatId = ctx.pathParam("id")
    if (chatId === undefined) {
        return ctx.noContent(400)
    }

    const user = $apis.requestInfo(ctx).authRecord
    if (user === undefined) {
        return ctx.noContent(400)
    }

    const responseText = $apis.requestInfo(ctx).data.content
    if (typeof responseText !== "string") {
        return ctx.noContent(400)
    }

    const chat = $app.dao().findRecordById("chats", chatId)

    $app.dao().expandRecord(chat, ["user", "history", "starter"], null)

    if (chat.expandedOne("user").getId() !== user.id) {
        return ctx.noContent(401)
    }

    const chatIsNew = chat.expandedAll("history").length === 0

    let modelResponse = chatIsNew
        ? "hey this is Gemini responding for the first time. I just received the full prompt."
        : "thank you for responding."

    const histories = $app.dao().findCollectionByNameOrId("chat_histories")
    const latestHistoryOrder = chat.expandedAll("history")
        .map(it => it.getInt("order"))
        .reduce((max, next) => next > max ? next : max, 0)

    const userResponseHistory = new Record(histories, {
        order: latestHistoryOrder + 1,
        content: responseText
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

routerAdd("POST", "/api/dearearth/vertextest", (ctx) => {
    const vertex = require(`${__hooks}/vertex.js`)
    const token = $os.getenv("GCLOUD_ACCESS_TOKEN")
    const history = 
    [
        {
            "role": "USER",
            "text": `
                You are a chatbot designed to help people increase their climate literacy. 
                You know a lot about the climate, but mainly what you do is to respond to me and ask relevant questions to encourage me to find out more about the topic and also do some self-reflection about my climate literacy. 
                For context in giving me information, I live in Indonesia. 
                We are going to have a chat. 
                The topic is "saving energy: energy vampires". 
                You just asked me: "how often do you forget to unplug your unused devices?". 
                Here's my response: "Well, I don't really think about unplugging my devices too much.
            `
        }
    ]
    const answer = vertex.chat(token, history, $http.send)
    return ctx.json(200, answer)
})