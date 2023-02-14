-- (file: spec/seeds_users.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE users, bookings RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO users (name, email, password) VALUES ('Ash Ketchum', 'pikachu@pokemon.com', 'pikipi');
INSERT INTO users (name, email, password) VALUES ('Dawn Misty', 'water@pokemon.com', 'Pilup');
INSERT INTO users (name, email, password) VALUES ('Brock Rocky', 'steelix@pokemon.com', 'Women<3');