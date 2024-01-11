/// <reference path="../pb_data/types.d.ts" />

const API_ENDPOINT = "asia-southeast1-aiplatform.googleapis.com"
const PROJECT_ID = "hackfest-bytebrigade"
const MODEL_ID = "gemini-pro"
const LOCATION_ID = "asia-southeast1"
const endpoint = `https://${API_ENDPOINT}/v1/projects/${PROJECT_ID}/locations/${LOCATION_ID}/publishers/google/models/${MODEL_ID}:streamGenerateContent`

const genConfig = {
    maxOutputTokens: 2048,
    temperature: 0.4,
    topP: 1
}

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
     * @returns {string}
     */
    chat: (token, history, httpClient) => {
        const response = httpClient(
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
                    "generation_config": genConfig
                }),
                headers: { "Authorization": `Bearer ${token}`, "Content-Type": "application/json; charset=utf-8" }
            })
        return response.json
    }
}