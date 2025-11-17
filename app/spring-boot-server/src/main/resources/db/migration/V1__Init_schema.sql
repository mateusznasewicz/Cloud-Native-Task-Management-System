CREATE SCHEMA IF NOT EXISTS todo_app;
SET search_path TO todo_app;

CREATE TABLE IF NOT EXISTS tutorials (
    id          BIGSERIAL PRIMARY KEY,
    title       VARCHAR(255),
    description TEXT,
    published   BOOLEAN NOT NULL DEFAULT FALSE
);