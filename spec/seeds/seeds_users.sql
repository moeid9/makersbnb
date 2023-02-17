-- (file: spec/seeds_users.sql)
-- Write your SQL seed here. 
-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)
TRUNCATE TABLE users,
bookings RESTART IDENTITY;

-- replace with your own table name.
-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.
-- Password: pikipi
INSERT INTO
  users (name, email, password)
VALUES
  (
    'Ash Ketchum',
    'pikachu@pokemon.com',
    '$2a$12$ldp6Sfhx1heNDgHzN3iREO19XfdlSnZs8sgGWOKEFeO3Df3UO3.1q'
  );

-- Passwrod: Pilup
INSERT INTO
  users (name, email, password)
VALUES
  (
    'Dawn Misty',
    'water@pokemon.com',
    '$2a$12$Jv7iy8qnvJBgrqsIQGt/Gu3fHJVa1K7eq7n6V/dD6.QMEX7jmcuiy'
  );

-- Password: Women<3
INSERT INTO
  users (name, email, password)
VALUES
  (
    'Brock Rocky',
    'steelix@pokemon.com',
    '$2a$12$zPrhw0IggUF.1KfQ2f0UJOpqscOEFktfMa/tpMNuKP30aBo4IzlP.'
  );