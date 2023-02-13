TRUNCATE TABLE makers, spaces RESTART IDENTITY CASCADE;

INSERT INTO makers (name, email, password) VALUES('Terry', 'terry@terry.com', '1234');
INSERT INTO makers (name, email, password) VALUES('Chris', 'chris@chris.com', 'password');

INSERT INTO spaces (name, description, price, location, maker_id, available_date) VALUES('Place A', 'It is nice', 100, 'London', 1, '{ 2022-02-13 , 2022-02-15 }');
INSERT INTO spaces (name, description, price, location, maker_id, available_date) VALUES('Place B', 'It is awesome', 80, 'Leeds', 2, '{ 2022-02-16, 2022-02-14 }');
INSERT INTO spaces (name, description, price, location, maker_id, available_date) VALUES('Place C', 'It is awesome', 50, 'Leeds', 2,'{ 2022-02-18, 2022-02-14 }');
