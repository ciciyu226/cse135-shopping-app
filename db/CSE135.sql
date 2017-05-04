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
    category    INTEGER REFERENCES Category(id) NOT NULL
);

CREATE TABLE Transactions(
    id                  SERIAL PRIMARY KEY,
    customer            INTEGER REFERENCES Client(id) NOT NULL,
    time                TIMESTAMP NOT NULL,
    card_number         CHARACTER(16),
    total               INTEGER CHECK (total>=0)
);

CREATE TABLE Purchase_History (
    id                  SERIAL PRIMARY KEY,
    customer            INTEGER REFERENCES Client(id) NOT NULL,
    product             INTEGER REFERENCES Product(id) NOT NULL,
    quantity            INTEGER NOT NULL,
    price_at_purchase   DECIMAL NOT NULL,
    bought              TEXT,
    trans_id            INTEGER REFERENCES Transactions(id)
);

-- Insert data into tables
INSERT INTO Client (username, role, age, loc_state) VALUES ('ciciyu', 'customer', '22', 'CA');
INSERT INTO Client (username, role, age, loc_state) VALUES ('davischo', 'customer', '22', 'CA');
INSERT INTO Category(name, description, owner) VALUES('Vegetables','All the healthy stuff','1');
INSERT INTO Category(name, description, owner) VALUES('Fruits','Delicious','2');
INSERT INTO Category(name, description, owner) VALUES('Animals','Cuuute','3');
INSERT INTO Product (name, SKU, price, category) VALUES('potatoes','A1B2C3','0.79',1);
INSERT INTO Product (name, SKU, price, category) VALUES('dog','woof','200.0',3);
INSERT INTO Product (name, SKU, price, category) VALUES('cat','meow','200.01',3);
INSERT INTO Product (name, SKU, price, category) VALUES('banana','banana','.50',2);
INSERT INTO Product (name, SKU, price, category) VALUES('carrot','plant','.75',1);
INSERT INTO Purchase_History(customer, product, quantity, price_at_purchase, bought)
    VALUES(7,40,2,2.00,'Y');
INSERT INTO Purchase_History(customer, product, quantity, price_at_purchase, bought)
    VALUES(7,41,3,3.00,'Y');

INSERT INTO Purchase_History(customer, product, quantity, price_at_purchase)
    VALUES(7,40,2,2.00);
INSERT INTO Purchase_History(customer, product, quantity, price_at_purchase)
    VALUES(7,41,3,3.00);

SELECT * FROM Client;
SELECT * FROM Category;
SELECT * FROM Product;
SELECT * FROM Purchase_History;

DROP TABLE Client CASCADE;
DROP TABLE Category CASCADE;
DROP TABLE Product CASCADE;
DROP TABLE Purchase_History CASCADE;