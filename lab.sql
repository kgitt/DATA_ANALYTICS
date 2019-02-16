
--Вывести список названий департаментов и количество главных врачей в каждом из этих департаментов. 
--Тк в задании заметка: "Поле “chief_doc_id” - это id главного врача из какой-то таблицы, которая нам недоступна. Рассматривайте это просто как номер главного врача." Берем только уникальные chief_doc_id.

SELECT Department.name department_name, count(DISTINCT chief_doc_id)
FROM Department INNER JOIN Employee
ON Department.id = Employee.department_id
GROUP BY Department.name;

--Вывести список департаментов, в которых работают 3 и более сотрудников (id и название департамента, количество сотрудников)

SELECT department_id, department.name, COUNT(*) FROM Employee 
INNER JOIN Department
ON Department.id = Employee.department_id
GROUP BY department_id, department.name
HAVING COUNT(*) >=3;

--Вывести список департаментов с максимальным количеством публикаций  (id и название департамента, количество публикаций)

WITH abc AS (
SELECT department_id, department.name, SUM(num_public) AS publication
FROM Employee 
INNER JOIN Department
ON Department.id = Employee.department_id
GROUP BY department_id, department.name)
SELECT * FROM abc
WHERE publication = (SELECT MAX(publication) FROM abc);


--Вывести список сотрудников с минимальным количеством публикаций в своем департаменте (id и название департамента, имя сотрудника, количество публикаций)

WITH a1 AS (
SELECT department_id, d.name,  MIN(num_public) FROM Employee e
INNER JOIN Department d
ON d.id = e.department_id
GROUP BY department_id, d.name)

SELECT a1.department_id, a1.name,b.name, min FROM a1
INNER JOIN
Employee b
ON a1.department_id = b.department_id
AND a1.min=b.num_public;

--Вывести список департаментов и среднее количество публикаций для тех департаментов, в которых работает более одного главного врача (id и название департамента, среднее количество публикаций)

SELECT a.department_id,a.name, a.avg_publications FROM
(SELECT e.department_id, d.name, AVG(num_public) avg_publications FROM Employee e
INNER JOIN Department d
ON d.id = e.department_id
GROUP BY department_id, d.name) a
INNER JOIN
(SELECT department_id, count(DISTINCT chief_doc_id) glavvrach
FROM Employee
GROUP BY department_id) b
ON a.department_id = b.department_id
WHERE glavvrach>1
