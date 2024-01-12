/// <reference path="../pb_data/types.d.ts" />

const API_ENDPOINT = "asia-southeast1-aiplatform.googleapis.com"
const PROJECT_ID = "hackfest-bytebrigade"
const MODEL_ID = "gemini-pro"
const LOCATION_ID = "asia-southeast1"
const endpoint = `https://${API_ENDPOINT}/v1/projects/${PROJECT_ID}/locations/${LOCATION_ID}/publishers/google/models/${MODEL_ID}:streamGenerateContent`

const genConfig = {
    maxOutputTokens: 1024,
    temperature: 0.4,
    topP: 1
}

const safetySettings = [
    {
        "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
        "threshold": "BLOCK_NONE"
    },
    {
        "category": "HARM_CATEGORY_HATE_SPEECH",
        "threshold": "BLOCK_NONE"
    },
    {
        "category": "HARM_CATEGORY_HARASSMENT",
        "threshold": "BLOCK_NONE"
    },
    {
        "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
        "threshold": "BLOCK_NONE"
    }
]


/**
 * 
 * @param {string} token 
 * @param {{ role: "USER" | "MODEL", text: string }[]} history 
 * @param {(params: {method: string, url: string, body: string, headers: { [key:string]: string }}) => {
 * statusCode: number,
 * headers:    { [key:string]: Array<string> },
 * cookies:    { [key:string]: http.Cookie },
 * raw:        string,
 * json:       any,
 * }} httpClient
 * @returns {{
 * statusCode: number,
 * headers:    { [key:string]: Array<string> },
 * cookies:    { [key:string]: http.Cookie },
 * raw:        string,
 * json:       any,
 * }}
 */
const _sendGenerateRequest = (token, history, httpClient) => httpClient(
    {
        method: "POST",
        url: endpoint,
        body: JSON.stringify({
            "contents": history.map(({ role, text }) => ({
                "role": role,
                "parts": [
                    { "text": text }
                ]
            })),
            "generation_config": genConfig,
            "safety_settings": safetySettings
        }),
        headers: { "Authorization": `Bearer ${token}`, "Content-Type": "application/json; charset=utf-8" }
    })

module.exports = {
    /**
     * 
     * @param {string} token 
     * @param {{ role: "USER" | "MODEL", text: string }[]} history 
     * @param {(params: {method: string, url: string, body: string, headers: { [key:string]: string }}) => {
     * statusCode: number,
     * headers:    { [key:string]: Array<string> },
     * cookies:    { [key:string]: http.Cookie },
     * raw:        string,
     * json:       any,
     * }} httpClient
     * @param {slog.Logger | undefined | null} logger
     * @returns {string}
     */
    chat: (token, history, httpClient, logger) => {
        const response = _sendGenerateRequest(token, history, httpClient)
        if (response.statusCode !== 200) {
            if (logger) {
                logger.error(JSON.stringify(response))
            }
            throw new Error("Failed to authenticate with Google API")
        }
        if (logger) {
            logger.info(JSON.stringify(response.json))
        }
        const blockedDueToSafety = response.json.slice(-1)[0]["candidates"][0]["finishReason"] === "SAFETY"
        if (blockedDueToSafety) {
            throw new Error("Response was blocked due to safety.")
        }
        return response.json.reduce(
            (acc, nextSegment) =>
                acc + (nextSegment["candidates"][0]["content"]["parts"]
                    ? nextSegment["candidates"][0]["content"]["parts"][0]["text"]
                    : ""),
            "")
    }
}