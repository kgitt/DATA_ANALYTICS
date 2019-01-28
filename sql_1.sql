CREATE TABLE
films (
    name VARCHAR (355),
    id serial PRIMARY KEY,
    country VARCHAR (355),
    box_office INT,
    year VARCHAR (355)
    
);


INSERT INTO
    films
VALUES
    (‘The Shawshank Redemption’, 0001, ‘USA’, 59841469, ’1994’),
    (‘The Green Mile ’, 0002, ‘USA’, 286801374, ’1999’),
    (‘Forrest Gump’, 0003, ‘USA’, 677386686, ’1994’),
    (‘Schindler's List’, 0004, ‘USA’, 321265768, ’1993’),
    (‘Intouchables’, 0005, ‘France’, 426588510, ’2011’);


CREATE TABLE
persons (
    name_surname VARCHAR (355),
    id serial PRIMARY KEY
);




INSERT INTO
    persons
VALUES
(‘Тим Роббинс’, 1001),
(‘Том Хэнкс’,2002),
(‘Роберт Земекис’,3003),
(‘Стивен Спилберг’,4004),
(‘Омар Си’,5005);



CREATE TABLE
persons2content (
    id_persons INT,
    id_content INT,
    person_type VARCHAR (355),
    FOREIGN KEY (id_persons)
    REFERENCES persons (id),
    FOREIGN KEY (id_content)
    REFERENCES films (id)
);

     


INSERT INTO
    persons2content
VALUES
(1001, 0001, ‘actor’),
(2002, 0002, ‘actor’),
(3003, 0003, ‘producer’),
(4004, 0004, ‘producer’),
(5005, 0005, ‘actor’);
