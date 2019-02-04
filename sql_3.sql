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
                                                                                                                                                                                                                            
--Создаю пустую таблицу ключевых слов
                                                                                                              
  CREATE TABLE keywords (
    movieid bigint,
    tags text
  );                                                                                                    
                                                                                                              
--Копирую в нее данные из keywords.csv
                                                                                                           
\copy keywords FROM '/usr/local/share/netology/raw_data/keywords.csv' DELIMITER ',' CSV HEADER;
                                                                                                         
--TRANSFORM делаем выборку 150 фильмов по заданным параметрам                                                                                                             

                                                                                                              
SELECT movieId, AVG(rating) as avg_rating
FROM ratings
GROUP BY movieid
HAVING COUNT(*)>50
ORDER BY
avg_rating DESC,
movieId
LIMIT 150;
                        
--тестово присоединяю таблицу keywords 
                                                                                                            
WITH top_rated AS (
SELECT movieId, AVG(rating) as avg_rating
FROM ratings
GROUP BY movieid
HAVING COUNT(*)>50
ORDER BY
avg_rating DESC,
movieId
LIMIT 150
)                                            
SELECT * FROM top_rated 
INNER JOIN keywords
ON keywords.movieid = top_rated.movieid;                                                                                                             
                                                                                                              
-- LOAD повторяю предыдущий запрос с определенными колонками и выгружаю выборку в таблицу top_rated_tags
 
WITH top_rated AS (
SELECT movieId, AVG(rating) as avg_rating
FROM ratings
GROUP BY movieid
HAVING COUNT(*)>50
ORDER BY
avg_rating DESC,
movieid
LIMIT 150
)                                                                                                            
SELECT top_rated.movieid, tags as top_rated_tags INTO top_rated_tags 
FROM top_rated 
INNER JOIN keywords
ON keywords.movieid = top_rated.movieid; 
                                                                                                              
                                                                                                         
--Выгрузка данных из top_rated_tags. Не смог найти файл
\copy (SELECT * FROM top_rated_tags) TO 'ratings_tags.csv' WITH CSV HEADER DELIMITER as ',';
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
