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
  "makerId" int,
  "available_date" text
);

CREATE TABLE "requests" (
  "id" serial PRIMARY KEY,
  "requested_date" text,
  "requested_spaceId" int,
  "requested_userId" int
);

ALTER TABLE
  "spaces"
ADD
  FOREIGN KEY ("makerId") REFERENCES "makers" ("id");

ALTER TABLE
  "requests"
ADD
  FOREIGN KEY ("requested_spaceId") REFERENCES "spaces" ("id");

ALTER TABLE
  "requests"
ADD
  FOREIGN KEY ("requested_userId") REFERENCES "users" ("id");