-- +goose Up
CREATE TABLE users (
    id              TEXT        PRIMARY KEY DEFAULT,
    email           TEXT        NOT NULL UNIQUE,
    hashed_password TEXT        NOT NULL,
    created_at      TEXT        NOT NULL DEFAULT (datetime('now')),
    updated_at      TEXT        NOT NULL DEFAULT (datetime('now'))
);


CREATE TABLE books (
    id        TEXT PRIMARY KEY,
    isbn      TEXT NOT NULL UNIQUE,
    title     TEXT NOT NULL,
    author    TEXT NOT NULL,
    publisher TEXT NOT NULL,
    subject   TEXT NOT NULL,
);


CREATE TABLE shelves (
    id          INTEGER     PRIMARY KEY AUTOINCREMENT,
    user_id     TEXT        REFERENCES(user.id),
    book_id     TEXT        REFERENCES(books.id),
    status      TEXT        NOT NULL DEFAULT 'tbr',
    rating      INTEGER,
    review      TEXT,
    bookmark    INTEGER     NOT NULL DEFAULT 0,
    created_at  TEXT        NOT NULL DEFAULT (datetime('now')),
    updated_at  TEXT        NOT NULL DEFAULT (datetime('now'))
);


-- +goose Down
DROP TABLE users;
DROP TABLE books;
DROP TABLE shelves;
