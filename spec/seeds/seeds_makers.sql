-- (file: spec/seeds_makers.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE makers, spaces, bookings RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO makers (name, email, password) VALUES ('Jack Black', 'black_jack@email.com', 'giant');
INSERT INTO makers (name, email, password) VALUES ('Micheal Jackson', 'dance@email.com', 'monkey');
INSERT INTO makers (name, email, password) VALUES ('Penelope Cruz', 'actor@email.com', 'Women<3');