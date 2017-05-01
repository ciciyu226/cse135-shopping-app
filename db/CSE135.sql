CREATE TABLE Client (
    id          SERIAL PRIMARY KEY,
    username    TEXT UNIQUE NOT NULL,
    role        TEXT NOT NULL,
    age         INTEGER NOT NULL,
    loc_state   TEXT NOT NULL
);
CREATE TABLE Category (
    id          SERIAL PRIMARY KEY,
    name         TEXT UNIQUE NOT NULL,
    description  TEXT NOT NULL,
    owner       INTEGER REFERENCES Client(id) NOT NULL
);
CREATE TABLE Product (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    SKU         TEXT UNIQUE NOT NULL,
    price       DECIMAL NOT NULL,
    owner       INTEGER REFERENCES Client(id) NOT NULL,
    category    INTEGER REFERENCES Category(id) NOT NULL
);

CREATE TABLE Purchase_History (
    id                  SERIAL PRIMARY KEY,
    customer            INTEGER REFERENCES Client(id) NOT NULL,
    product             INTEGER REFERENCES Product(id) NOT NULL,
    quantity            INTEGER NOT NULL,
    price_at_purchase   DECIMAL NOT NULL,
    time        TIMESTAMP NOT NULL,
    card_number CHARACTER(16)
);

-- Insert data into tables
INSERT INTO Client (username, role, age, loc_state) VALUES ('ciciyu', 'customer', '22', 'CA');
INSERT INTO Client (username, role, age, loc_state) VALUES ('davischo', 'customer', '22', 'CA');
-- INSERT INTO classes (name, number, date_code, start_time, end_time) VALUES ('Databases', 'CSE132A', 'TuTh', '3:30', '4:50');
-- INSERT INTO classes (name, number, date_code, start_time, end_time) VALUES ('Compilers', 'CSE131', 'F', '9:30', '10:50');
-- INSERT INTO classes (name, number, date_code, start_time, end_time) VALUES ('VLSI', 'CSE121', 'F', '11:00', '12:00');
--
-- INSERT INTO students (pid, first_name, last_name) VALUES ('8888888', 'John', 'Smith');
-- INSERT INTO students (pid, first_name, last_name) VALUES ('1111111', 'Mary', 'Doe');
-- INSERT INTO students (pid, first_name, last_name) VALUES ('2222222', 'Jay', 'Chen');
--
-- INSERT INTO enrollment (class, student, credits) VALUES (1, 1, 4);
-- INSERT INTO enrollment (class, student, credits) VALUES (1, 2, 3);
-- INSERT INTO enrollment (class, student, credits) VALUES (4, 3, 4);
-- INSERT INTO enrollment (class, student, credits) VALUES (1, 3, 3);

SELECT * FROM Client;
SELECT * FROM Category;
SELECT * FROM Product;
SELECT * FROM Purchase_History;

DROP TABLE Client CASCADE;
DROP TABLE Category CASCADE;
DROP TABLE Product CASCADE;
DROP TABLE Purchase_History CASCADE;