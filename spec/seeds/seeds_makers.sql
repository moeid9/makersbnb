-- (file: spec/seeds_makers.sql)
-- Write your SQL seed here. 
-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)
TRUNCATE TABLE makers,
spaces,
bookings RESTART IDENTITY;

-- replace with your own table name.
-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.
-- Password: giant
INSERT INTO
  makers (name, email, password)
VALUES
  (
    'Jack Black',
    'black_jack@email.com',
    '$2a$12$n1bS9MlnA3wv2SsrhqLW1OoTaCbq6jqeBAKtc2r8GVznLCKojpeqi'
  );

-- Password: monkey
INSERT INTO
  makers (name, email, password)
VALUES
  (
    'Micheal Jackson',
    'dance@email.com',
    '$2a$12$p32LnXsl.5jCBo4fby06U.mLkkEWxVDBn6vHv.9W15TA75eCvvH9O'
  );

-- Password: Women<3
INSERT INTO
  makers (name, email, password)
VALUES
  (
    'Penelope Cruz',
    'actor@email.com',
    '$2a$12$UKyyTXNARBHh/Qxcd56BZuHn5WdRh.06IjDgY5iB1oMPGK0E0ISWi'
  );