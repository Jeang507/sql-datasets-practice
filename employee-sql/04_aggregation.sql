/*
EJERCICIO 4 – Análisis agregado con condiciones

Contexto:
No todos los grupos tienen la misma relevancia para la toma de decisiones.
La dirección desea enfocarse en ciudades, niveles educativos y segmentos
salariales con suficiente volumen de empleados para que los análisis
sean estadísticamente representativos.

Preguntas:

16. Identificar las ciudades que cuentan con más de 50 empleados.
17. Determinar los niveles educativos cuyo promedio de edad sea superior
    a los 30 años.
18. Identificar las ciudades donde más del 30% de los empleados han
    abandonado la empresa.
19. Determinar qué niveles salariales tienen más de 20 empleados.
20. Identificar los años de ingreso en los que la edad promedio de los
    empleados supera los 35 años.
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

-- 16) ciudades que cuentan con más de 50 empleados.

SELECT city, COUNT(employee_id) AS employee_by_city
FROM employee.employee
GROUP BY city 
HAVING COUNT(employee_id) > 50;

'''
   city    | employee_by_city 
-----------+------------------
 Bangalore |             2228
 Pune      |             1268
 New Delhi |             1157
(3 rows)
'''

/* 17) Niveles educativos cuyo promedio de edad sea superior
    a los 30 años.*/

SELECT education, ROUND(AVG(age)) AS age_over_30 
FROM employee.employee
GROUP BY education
HAVING AVG(age) > 30;

'''
 education | age_over_30 
-----------+-------------
(0 rows)
'''

/* 18) Ciudades donde más del 30% de los empleados han
    abandonado la empresa.*/
SELECT city, COUNT(*) FILTER (WHERE leave_or_not = true) AS job_abandonment,
ROUND(COUNT(*) FILTER (WHERE leave_or_not = true) * 100.0 / COUNT(*), 2) AS abandonment_percentage
FROM employee.employee 
GROUP BY city
HAVING COUNT(*) FILTER (WHERE leave_or_not = true) * 1.0 / COUNT(*) > 0.30;

'''
   city    | job_abandonment | abandonment_percentage 
-----------+-----------------+------------------------
 Pune      |             639 |                  50.39
 New Delhi |             366 |                  31.63
(2 rows)
'''

-- 19) Niveles salariales que tienen más de 20 empleados.

SELECT payment_tier, COUNT(*) AS total_payment_tier,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS porcentage 
FROM employee.employee
GROUP BY payment_tier
HAVING COUNT(*) > 20;

'''
 payment_tier | total_payment_tier | porcentage 
--------------+--------------------+------------
            1 |                243 |       5.22
            3 |               3492 |      75.05
            2 |                918 |      19.73
(3 rows)
'''

/* 20) Años de ingreso en los que la edad promedio de los
    empleados supera los 35 años.*/

SELECT joining_year, COUNT(*) AS total_joining_year, ROUND(AVG(age),2) AS average_age    
FROM employee.employee
GROUP BY joining_year HAVING AVG(age) > 35 ORDER BY total_joining_year DESC;

'''
 joining_year | total_joining_year | average_age 
--------------+--------------------+-------------
(0 rows)
'''
-- Visualizar promedio por grupo 
SELECT joining_year, ROUND(AVG(age), 2) AS average_age 
FROM employee.employee
GROUP BY joining_year ORDER BY average_age ASC;

'''
 joining_year | average_age 
--------------+-------------
         2013 |       29.01
         2014 |       29.29
         2017 |       29.42
         2015 |       29.48
         2018 |       29.53
         2016 |       29.55
         2012 |       29.60
(7 rows)
'''
--Visualizar totalidad por grupo 
SELECT joining_year, COUNT(*) AS total_joining_year
FROM employee.employee
GROUP BY joining_year 
ORDER BY total_joining_year DESC;

'''
 joining_year | total_joining_year 
--------------+--------------------
         2017 |               1108
         2015 |                781
         2014 |                699
         2013 |                669
         2016 |                525
         2012 |                504
         2018 |                367
(7 rows)
'''