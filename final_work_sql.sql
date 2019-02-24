
vagrant up
vagrant ssh

--ETL. Загружаем дамп тренировочной БД, брал отсюда https://habr.com/ru/company/postgrespro/blog/316428/

cd /vagrant_data/
psql -f demo_small.sql
psql demo
\dt
\dt bookings
SET search_path TO bookings;
\dt bookings
\dn

--SQL запросы


--1. Найти кол-во рейсов прибывших в каждый аэропорт, в промежутке дат с 2015-10-14 по 2016-10-07.

SELECT arrival_airport, COUNT(*) FROM flights 
WHERE actual_arrival BETWEEN '2015-10-14' AND '2016-10-07'
GROUP BY arrival_airport;


--2. Найти суммарное кол-во пассажиров перевезенных этими рейсами;

SELECT COUNT(DISTINCT t.passenger_id)
FROM 
Tickets t INNER JOIN Ticket_flights tf
ON t.ticket_no = tf.ticket_no
INNER JOIN Flights f
ON tf.flight_id = f.flight_id
WHERE f.actual_arrival BETWEEN '2015-10-14' AND '2016-10-07';


--3. Вывести название самолетов их код и кол-во сидений, которые летали в Мурманск;

WITH a1 AS
(SELECT a.model, a.aircraft_code, COUNT(DISTINCT s.seat_no) FROM Seats s
INNER JOIN Aircrafts a
ON s.aircraft_code = a.aircraft_code
GROUP BY a.model, a.aircraft_code)
WITH a2 AS(
SELECT a.aircraft_code, COUNT(DISTINCT flight_id)
FROM Flights f
INNER JOIN airports a
ON f.arrival_airport = a.airport_name
WHERE a.airport_name IN (
SELECT airport.name FROM airports
WHERE city = 'Мурманск')
SELECT * FROM a1 INNER JOIN a2
ON a1.aircraft_code = a2.aircraft_code;


--4. Сколько рейсов за все время сделал самолет с самым большим количеством мест;

WITH a AS(
SELECT a.aircraft_code, COUNT(DISTINCT s.seat_no) seats
FROM Seats s
INNER JOIN Aircrafts a
ON s.aircraft_code = a.aircraft_code
GROUP BY a.aircraft_code
ORDER BY seats DESC
LIMIT 1)
SELECT COUNT(flight_id) AS count_flights 
FROM Flights 
GROUP BY aircraft_code HAVING aircraft_code = (SELECT a.aircraft_code FROM a);


--5. Найти наименее популярный город, в который прилетело меньше всего рейсов.


WITH a AS(
SELECT arrival_airport, COUNT(DISTINCT flight_id) flightscount FROM flights
GROUP BY arrival_airport
ORDER BY flightscount
LIMIT 1)
SELECT city FROM Airports
WHERE airport_code = (SELECT arrival_airport FROM a);


--6. Сколько было продано билетов, содержащих в себе бизнес класс хотя бы для одного пассажира для билетов с вылетом(по билетам, не реальное время вылета) в промежутке с 2015-10-14 по 2016-10-07;


WITH a AS(
SELECT flight_id, ticket_no, fare_conditions FROM ticket_flights
WHERE fare_conditions LIKE 'Business')
SELECT COUNT(*) FROM a
INNER JOIN flights f
ON a.flight_id = f.flight_id
WHERE scheduled_departure BETWEEN '2015-10-14' AND '2016-10-07';


--7. Найти имена пассажиров которые летели в DME и их рейс был задержан; 

SELECT t.passenger_name, f.arrival_airport, f.status FROM tickets t
INNER JOIN
Ticket_flights tf
ON t.ticket_no = tf.ticket_no
INNER JOIN flights f
ON tf.flight_id = f.flight_id
WHERE f.arrival_airport = 'DME' AND
f.status = 'Delayed';


--8. Найти кто-летает чаще бизнес классом - люди с именем PETR или ALEKSANDR. Вывести для каждого кол-во купленных билетов бизнес класса;

WITH a AS(
SELECT DISTINCT t.ticket_no, t.passenger_name, tf.fare_conditions FROM tickets t
INNER JOIN
Ticket_flights tf
ON t.ticket_no = tf.ticket_no
INNER JOIN flights f
ON tf.flight_id = f.flight_id
WHERE 
(tf.fare_conditions = 'Business')
AND (t.passenger_name LIKE 'PETR %' OR 
t.passenger_name LIKE 'ALEKSANDR %'))
SELECT ('ALEKSANDR') as name, COUNT(DISTINCT a.ticket_no) FROM a
WHERE a.passenger_name LIKE 'ALEKSANDR %'
UNION ALL
SELECT ('PETR') as name, COUNT(DISTINCT a.ticket_no) FROM a
WHERE a.passenger_name LIKE 'PETR %';


--9. Найти все модели самолетов на которых летали пассажиры с именем PETR.

SELECT t.passenger_name, a.model FROM tickets t
INNER JOIN
Ticket_flights tf
ON t.ticket_no = tf.ticket_no
INNER JOIN flights f
ON tf.flight_id = f.flight_id
INNER JOIN Aircrafts a
ON f.aircraft_code = a.aircraft_code
WHERE t.passenger_name LIKE 'PETR %';



--10. Найти неудачников, кому чаще всего задерживали рейсы.
WITH a AS(
SELECT passenger_name, COUNT(status) b
FROM tickets t INNER JOIN ticket_flights tf
ON t.ticket_no = tf.ticket_no
INNER JOIN flights f
ON tf.flight_id = f.flight_id
GROUP BY passenger_name, status HAVING status = 'Delayed')
SELECT a.passenger_name, a.b FROM a
WHERE b = (SELECT MAX(b) FROM a);











