DROP TABLE IF EXISTS users,
makers,
spaces,
bookings cascade;

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
  "date" date,
  "name" text,
  "price" int,
  "description" text,
  "location" text,
  "available" boolean,
  "maker_id" int
);

CREATE TABLE "bookings" (
  "id" serial PRIMARY KEY,
  "confirmed" boolean,
  "requested_space_id" int,
  "requested_user_id" int
);

ALTER TABLE
  "spaces"
ADD
  FOREIGN KEY ("maker_id") REFERENCES "makers" ("id");

ALTER TABLE
  "bookings"
ADD
  FOREIGN KEY ("requested_space_id") REFERENCES "spaces" ("id");

ALTER TABLE
  "bookings"
ADD
  FOREIGN KEY ("requested_user_id") REFERENCES "users" ("id");