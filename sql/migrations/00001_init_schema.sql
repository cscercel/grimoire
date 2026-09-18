-- +goose Up
CREATE TABLE users (
    id              TEXT        PRIMARY KEY,
    email           TEXT        NOT NULL UNIQUE,
    hashed_password TEXT        NOT NULL,
    created_at      TEXT        NOT NULL DEFAULT (datetime('now')),
    updated_at      TEXT        NOT NULL DEFAULT (datetime('now'))
);


CREATE TABLE clubs (
    id          TEXT    PRIMARY KEY,
    name        TEXT    NOT NULL UNIQUE,
    admin_id    TEXT    REFERENCES users(id),
    passkey     TEXT    NOT NULL,
    created_at  TEXT    NOT NULL DEFAULT (datetime('now')),
    updated_at  TEXT    NOT NULL DEFAULT (datetime('now'))
)


CREATE TABLE club_members (
    id          TEXT    PRIMARY KEY,
    username    TEXT    NOT NULL UNIQUE,
    club_id     TEXT    REFERENCES clubs(id),
    user_id     TEXT    REFERENCES users(id),
    created_at  TEXT    NOT NULL DEFAULT (datetime('now')),
    updated_at  TEXT    NOT NULL DEFAULT (datetime('now'))
)


CREATE TABLE books (
    id          TEXT    PRIMARY KEY,
    isbn        TEXT    NOT NULL UNIQUE,
    title       TEXT    NOT NULL,
    author      TEXT    NOT NULL,
    publisher   TEXT    NOT NULL,
    subject     TEXT    NOT NULL,
    created_at  TEXT    NOT NULL DEFAULT (datetime('now')),
    updated_at  TEXT    NOT NULL DEFAULT (datetime('now'))
);


CREATE TABLE club_member_books (
    id          INTEGER     PRIMARY KEY AUTOINCREMENT,
    member_id   TEXT        REFERENCES club_members(id),
    book_id     TEXT        REFERENCES books(id),
    status      TEXT        NOT NULL DEFAULT 'tbr',
    rating      INTEGER,
    review      TEXT,
    bookmark    INTEGER     NOT NULL DEFAULT 0,
    created_at  TEXT        NOT NULL DEFAULT (datetime('now')),
    updated_at  TEXT        NOT NULL DEFAULT (datetime('now'))
);


-- +goose Down
DROP TABLE users;
DROP TABLE clubs;
DROP TABLE club_members;
DROP TABLE books;
DROP TABLE club_member_books;
