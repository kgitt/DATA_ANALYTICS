/*
Вывести список пользователей в формате userId, movieId, normed_rating, avg_rating где
userId, movieId - без изменения
для каждого пользователя преобразовать рейтинг r в нормированный - normed_rating=(r - r_min)/(r_max - r_min), где r_min и r_max соответственно минимально и максимальное значение рейтинга у данного пользователя
avg_rating - среднее значение рейтинга у данного пользователя
Вывести первые 30 таких записей 
*/

SELECT userid, movieid,
(rating - MIN(rating) OVER (PARTITION BY userid))/(MAX(rating) OVER (PARTITION BY userid) - MIN(rating) OVER (PARTITION BY userid)) normed_rating,
AVG(rating) OVER (PARTITION BY userId) avg_rating
FROM ratings
LIMIT 30;

                               
--Загрузка CSV файла в базу 
                                                                                                              
                                                                                                              
ls $NETOLOGY_DATA/raw_data | grep keywords
                                                                                                              
--Результат: 
keywords1.csv
keywords.csv                                                                                                              
                                                                                                                                                                                                                            
--Создаю таблицу ключевых слов
  CREATE TABLE keywords (
    movieId bigint,
    tags text
  );'                                                                                                           
                                                                                                              
--Копирую в нее csv
                                                                                                              
\copy keywords FROM 'NETOLOGY_DATA/raw_data/keywords.csv' DELIMITER' ',' CSV HEADER;                                                                                                             

                                                                                                              
--Transform                                                                                                              
--проверить? 
                                                                                                              
SELECT movieId, AVG(rating) as avg_rating
FROM ratings
GROUP BY movieid
HAVING COUNT(rating)>50
ORDER BY
avg_rating DESC,
movieId
LIMIT 150;
                        
--присоединяем таблицу keywords
--проверить?
                                                                                                              
 WITH top_rated AS (
SELECT movieId, AVG(rating) as avg_rating
FROM ratings
GROUP BY movieid
HAVING COUNT(rating)>50
ORDER BY
avg_rating DESC,
movieId
LIMIT 150
)
--обозначить название новой колонки!                                                                                                              
SELECT * FROM top_rated 
LEFT JOIN keywords
ON keywords.movied = top_rated.movieid                                                                                                             
                                                                                                              
--Load
 
WITH top_rated as (
SELECT movieId, AVG(rating) as avg_rating
FROM ratings
GROUP BY movieid
HAVING COUNT(rating)>50
ORDER BY
avg_rating DESC,
movieId
LIMIT 150)  
                                                                                                              
SELECT movieId, top_rated_tags INTO top_rated_tags 
FROM top_rated 
LEFT JOIN keywords
ON keywords.movied = top_rated.movieid 
                                                                                                              
LEFT JOIN keywords                                                                                                             
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
