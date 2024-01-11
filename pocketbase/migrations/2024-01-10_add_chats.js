/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const snapshot = [
    {
      "id": "_pb_users_auth_",
      "created": "2024-01-10 12:42:07.760Z",
      "updated": "2024-01-10 12:42:07.766Z",
      "name": "users",
      "type": "auth",
      "system": false,
      "schema": [
        {
          "system": false,
          "id": "users_name",
          "name": "name",
          "type": "text",
          "required": false,
          "presentable": false,
          "unique": false,
          "options": {
            "min": null,
            "max": null,
            "pattern": ""
          }
        },
        {
          "system": false,
          "id": "users_avatar",
          "name": "avatar",
          "type": "file",
          "required": false,
          "presentable": false,
          "unique": false,
          "options": {
            "mimeTypes": [
              "image/jpeg",
              "image/png",
              "image/svg+xml",
              "image/gif",
              "image/webp"
            ],
            "thumbs": null,
            "maxSelect": 1,
            "maxSize": 5242880,
            "protected": false
          }
        },
        {
          "system": false,
          "id": "dzudvkvx",
          "name": "hasDoneOnboarding",
          "type": "bool",
          "required": false,
          "presentable": false,
          "unique": false,
          "options": {}
        }
      ],
      "indexes": [],
      "listRule": "id = @request.auth.id",
      "viewRule": "id = @request.auth.id",
      "createRule": "",
      "updateRule": "id = @request.auth.id",
      "deleteRule": "id = @request.auth.id",
      "options": {
        "allowEmailAuth": false,
        "allowOAuth2Auth": true,
        "allowUsernameAuth": false,
        "exceptEmailDomains": null,
        "manageRule": null,
        "minPasswordLength": 8,
        "onlyEmailDomains": null,
        "onlyVerified": false,
        "requireEmail": false
      }
    },
    {
      "id": "yqdgg8adjyb5k9w",
      "created": "2024-01-10 12:45:25.134Z",
      "updated": "2024-01-10 13:07:53.545Z",
      "name": "chat_histories",
      "type": "base",
      "system": false,
      "schema": [
        {
          "system": false,
          "id": "4bzugp95",
          "name": "order",
          "type": "number",
          "required": false,
          "presentable": false,
          "unique": false,
          "options": {
            "min": 0,
            "max": null,
            "noDecimal": true
          }
        },
        {
          "system": false,
          "id": "8i560mrm",
          "name": "content",
          "type": "text",
          "required": false,
          "presentable": false,
          "unique": false,
          "options": {
            "min": null,
            "max": null,
            "pattern": ""
          }
        }
      ],
      "indexes": [],
      "listRule": null,
      "viewRule": null,
      "createRule": null,
      "updateRule": null,
      "deleteRule": null,
      "options": {}
    },
    {
      "id": "mhikh5mck64dy5h",
      "created": "2024-01-10 12:45:40.135Z",
      "updated": "2024-01-10 13:13:55.934Z",
      "name": "chats",
      "type": "base",
      "system": false,
      "schema": [
        {
          "system": false,
          "id": "kancwaur",
          "name": "user",
          "type": "relation",
          "required": true,
          "presentable": false,
          "unique": false,
          "options": {
            "collectionId": "_pb_users_auth_",
            "cascadeDelete": false,
            "minSelect": null,
            "maxSelect": 1,
            "displayFields": null
          }
        },
        {
          "system": false,
          "id": "pqravtmb",
          "name": "history",
          "type": "relation",
          "required": false,
          "presentable": false,
          "unique": false,
          "options": {
            "collectionId": "yqdgg8adjyb5k9w",
            "cascadeDelete": false,
            "minSelect": null,
            "maxSelect": null,
            "displayFields": null
          }
        },
        {
          "system": false,
          "id": "3sd23oz9",
          "name": "starter",
          "type": "relation",
          "required": true,
          "presentable": false,
          "unique": false,
          "options": {
            "collectionId": "jqzgp79s3w7n8mm",
            "cascadeDelete": false,
            "minSelect": null,
            "maxSelect": 1,
            "displayFields": null
          }
        },
        {
          "system": false,
          "id": "rbjymsvf",
          "name": "submission_caption",
          "type": "text",
          "required": false,
          "presentable": false,
          "unique": false,
          "options": {
            "min": null,
            "max": null,
            "pattern": ""
          }
        },
        {
          "system": false,
          "id": "jmqauaeu",
          "name": "submission_image",
          "type": "file",
          "required": false,
          "presentable": false,
          "unique": false,
          "options": {
            "mimeTypes": [],
            "thumbs": [],
            "maxSelect": 1,
            "maxSize": 5242880,
            "protected": true
          }
        }
      ],
      "indexes": [],
      "listRule": "user.id = @request.auth.id",
      "viewRule": "user.id = @request.auth.id",
      "createRule": null,
      "updateRule": null,
      "deleteRule": null,
      "options": {}
    },
    {
      "id": "jqzgp79s3w7n8mm",
      "created": "2024-01-10 12:55:03.751Z",
      "updated": "2024-01-10 13:13:41.943Z",
      "name": "chat_starters",
      "type": "base",
      "system": false,
      "schema": [
        {
          "system": false,
          "id": "kawlhr9a",
          "name": "content",
          "type": "text",
          "required": false,
          "presentable": false,
          "unique": false,
          "options": {
            "min": null,
            "max": null,
            "pattern": ""
          }
        },
        {
          "system": false,
          "id": "p0laqslg",
          "name": "thumbnail",
          "type": "file",
          "required": false,
          "presentable": false,
          "unique": false,
          "options": {
            "mimeTypes": [
              "image/png"
            ],
            "thumbs": [],
            "maxSelect": 1,
            "maxSize": 5242880,
            "protected": true
          }
        }
      ],
      "indexes": [],
      "listRule": null,
      "viewRule": null,
      "createRule": null,
      "updateRule": null,
      "deleteRule": null,
      "options": {}
    }
  ];

  const collections = snapshot.map((item) => new Collection(item));

  return Dao(db).importCollections(collections, true, null);
}, (db) => {
  return null;
})
