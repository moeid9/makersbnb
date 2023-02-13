DROP TABLE IF EXISTS users, makers, spaces, requests cascade;

CREATE TABLE "users" (
  "id" serial PRIMARY KEY,
  "name" text,
  "email" text,
  "password" text
);

CREATE TABLE "makers" (
  "id" serial PRIMARY KEY,
  "name" text,
  "email" text,
  "password" text
);

CREATE TABLE "spaces" (
  "id" serial PRIMARY KEY,
  "description" text,
  "price" int,
  "name" text,
  "location" text,
  "maker_id" int,
  "available_date" date ARRAY
);

CREATE TABLE "requests" (
  "id" serial PRIMARY KEY,
  "requested_date" text,
  "requested_space_id" int,
  "requested_user_id" int
);

ALTER TABLE
  "spaces"
ADD
  FOREIGN KEY ("maker_id") REFERENCES "makers" ("id");

ALTER TABLE
  "requests"
ADD
  FOREIGN KEY ("requested_space_id") REFERENCES "spaces" ("id");

ALTER TABLE
  "requests"
ADD
  FOREIGN KEY ("requested_user_id") REFERENCES "users" ("id");