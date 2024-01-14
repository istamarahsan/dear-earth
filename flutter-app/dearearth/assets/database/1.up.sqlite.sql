CREATE TABLE chat_starter (
  `name` TEXT PRIMARY KEY,
  `content` TEXT NOT NULL
);

CREATE TABLE chat (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `starter_name` TEXT NOT NULL,
  `status` TEXT NOT NULL CHECK (`status` IN ('active', 'accepted')),
  `time_started` TEXT NOT NULL,
  FOREIGN KEY (`starter_name`) REFERENCES `chat_starter`(`name`)
);

CREATE TABLE chat_message (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `chat_id` INTEGER NOT NULL,
  `role` TEXT NOT NULL CHECK (`role` IN ('model', 'user')),
  `content` TEXT NOT NULL,
  `timestamp` TEXT NOT NULL,
  FOREIGN KEY (`chat_id`) REFERENCES `chat`(`id`) ON DELETE CASCADE
);

CREATE TABLE chat_submission (
  `chat_id` INTEGER NOT NULL,
  `number` INTEGER NOT NULL,
  `attachment` TEXT NOT NULL,
  `caption` TEXT NOT NULL,
  PRIMARY KEY (`chat_id`, `number`),
  FOREIGN KEY (`chat_id`) REFERENCES `chat`(`id`) ON DELETE CASCADE
);

INSERT INTO chat_starter(`name`, `content`) VALUES ('debug_starter', 'DEBUG');