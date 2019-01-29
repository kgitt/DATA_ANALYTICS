----Домашняя работа 2
SELECT 'ФИО: Петр Захаров';

--1.1 SELECT , LIMIT - выбрать 10 записей из таблицы rating

SELECT * FROM ratings
LIMIT 10;

--1.2 WHERE, LIKE - выбрать из таблицы links всё записи, у которых imdbid оканчивается на "42", а поле movieid между 100 и1000
SELECT * FROM links
WHERE movieid < 1000 AND movieid > 100
AND imdbid LIKE '%42'
LIMIT 10;

--2.1 INNER JOIN выбрать из таблицы links все imdbId, которым ставили рейтинг 5

SELECT imdbId
FROM links INNER JOIN ratings
ON links.movieid = ratings.movieid
WHERE rating = 5
LIMIT 10;

--3.1 COUNT() Посчитать число фильмов без оценок

SELECT COUNT(*)
FROM ratings RIGHT JOIN links
ON links.movieid = ratings.movieid
WHERE rating IS NULL
LIMIT 10;


--3.2 GROUP BY, HAVING вывести top-10 пользователей, у который средний рейтинг выше 3.5

SELECT userid FROM ratings
GROUP BY userid
HAVING AVG(rating) > 3.5
LIMIT 10;

--4.1 Подзапросы: достать любые 10 imbdId из links у которых средний рейтинг больше 3.5.
SELECT imdbId
FROM links
WHERE movieid IN (SELECT movieid
FROM ratings
GROUP BY movieid
HAVING AVG(rating) > 3.5)
LIMIT 10;

--4.2 Common Table Expressions: посчитать средний рейтинг по пользователям, у которых более 10 оценок. Нужно подсчитать средний рейтинг по все пользователям, которые попали под условие - то есть в ответе должно быть одно число.


