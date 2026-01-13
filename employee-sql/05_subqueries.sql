/*
EJERCICIO 5 – Comparaciones mediante subconsultas

Contexto:
Para análisis más profundos, es necesario comparar el comportamiento
individual de los empleados contra métricas globales o parciales, como
promedios generales o promedios por grupo.

Preguntas:

21. Identificar empleados cuya edad sea superior al promedio general
    de la empresa.
22. Identificar empleados cuya experiencia sea mayor al promedio de
    su ciudad.
23. Determinar cuál es la ciudad con mayor número de empleados.
24. Identificar el año con mayor cantidad de contrataciones.
25. Determinar qué nivel salarial presenta la mayor tasa de abandono.
*/

'''
\d employee.employee;
                                               Table "employee.employee"
            Column            |  Type   | Collation | Nullable |                        Default                         
------------------------------+---------+-----------+----------+--------------------------------------------------------
 employee_id                  | integer |           | not null | nextval('employee.employee_employee_id_seq'::regclass)
 education                    | text    |           | not null | 
 joining_year                 | integer |           | not null | 
 city                         | text    |           | not null | 
 payment_tier                 | integer |           | not null | 
 age                          | integer |           | not null | 
 gender                       | text    |           | not null | 
 ever_benched                 | boolean |           | not null | 
 experience_in_current_domain | integer |           | not null | 
 leave_or_not                 | boolean |           | not null | 
Indexes:
    "employee_pkey" PRIMARY KEY, btree (employee_id)
'''

-- 21)
/*Identificar empleados cuya edad sea superior al promedio general
    de la empresa.*/
    
SELECT ROUND(AVG(age),2) AS average_global FROM employee.employee;
 average_global 
----------------
          29.39
(1 row)

SELECT age AS employees_above_average FROM employee.employee
WHERE age  > (SELECT AVG(age) FROM employee.employee);

SELECT COUNT(*) AS total_average FROM employee.employee
WHERE age  > (SELECT AVG(age) FROM employee.employee);
 employees_above_average 
-------------
        1623
(1 row)

-- 22) 

/* Identificar empleados cuya experiencia sea mayor al promedio de
    su ciudad.*/

SELECT city, ROUND(AVG(experience_in_current_domain),2) AS average_by_city
FROM employee.employee
GROUP BY city;

'''
   city    | average_by_city 
-----------+-----------------
 Bangalore |            2.92
 Pune      |            2.89
 New Delhi |            2.89
(3 rows)
'''

SELECT e.employee_id, e.city, e.experience_in_current_domain
FROM employee.employee e
WHERE e.experience_in_current_domain >
(SELECT AVG(e2.experience_in_current_domain) FROM employee.employee e2
WHERE e2.city = e.city);

-- 23) 

-- Determinar cuál es la ciudad con mayor número de empleados.

SELECT city, count(*) AS total_employees FROM employee.employee
GROUP BY city ORDER BY total_employees DESC LIMIT 1;

'''
   city    | total_employees 
-----------+-----------------
 Bangalore |            2228
(1 row)
'''
-- 24) 

-- Identificar el año con mayor cantidad de contrataciones.

SELECT joining_year, COUNT(*) AS total_joining_year
FROM employee.employee
GROUP BY joining_year
ORDER BY total_joining_year DESC 
LIMIT 1;

'''
 joining_year | total_joining_year 
--------------+--------------------
         2017 |               1108
(1 row)
'''
-- 25) 

-- Determinar qué nivel salarial presenta la mayor tasa de abandono.

SELECT payment_tier,ROUND(COUNT(*) FILTER 
(WHERE leave_or_not = true)::DECIMAL / COUNT(*) * 100, 2) AS dropout_rate_percentage
FROM employee.employee
GROUP BY payment_tier
ORDER BY dropout_rate_percentage DESC
LIMIT 1;

'''
 payment_tier | dropout_rate_percentage 
--------------+-------------------------
            2 |                   59.91
(1 row)
'''

