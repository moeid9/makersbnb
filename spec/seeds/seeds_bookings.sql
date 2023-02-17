-- (file: spec/seeds_bookings.sql)
-- Write your SQL seed here. 
-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)
TRUNCATE TABLE bookings RESTART IDENTITY CASCADE;

-- replace with your own table name.
-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.
INSERT INTO
  bookings (confirmed, requested_space_id, requested_user_id)
VALUES
  (TRUE, 1, 1);

INSERT INTO
  bookings (confirmed, requested_space_id, requested_user_id)
VALUES
  (TRUE, 2, 2);

INSERT INTO
  bookings (confirmed, requested_space_id, requested_user_id)
VALUES
  (FALSE, 3, 3);