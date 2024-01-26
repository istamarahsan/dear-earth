CREATE TABLE journal_topic (
  `title` TEXT PRIMARY KEY,
  `lead` TEXT NOT NULL,
  `starter` TEXT NOT NULL
);

CREATE TABLE journal_entry (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `topic_title` TEXT NOT NULL,
  `status` TEXT NOT NULL CHECK (`status` IN ('active', 'accepted')),
  `time_started` TEXT NOT NULL,
  FOREIGN KEY (`topic_title`) REFERENCES `journal_topic`(`title`)
);

CREATE TABLE journal_entry_message (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `entry_id` INTEGER NOT NULL,
  `role` TEXT NOT NULL CHECK (`role` IN ('model', 'user')),
  `content` TEXT NOT NULL,
  `timestamp` TEXT NOT NULL,
  FOREIGN KEY (`entry_id`) REFERENCES `journal_entry`(`id`) ON DELETE CASCADE
);

CREATE TABLE journal_entry_submission (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `entry_id` INTEGER NOT NULL,
  `attachment` TEXT NOT NULL,
  `caption` TEXT NOT NULL,
  FOREIGN KEY (`entry_id`) REFERENCES `journal_entry`(`id`) ON DELETE CASCADE
);

