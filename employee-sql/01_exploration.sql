/*
EJERCICIO 1 – Exploración inicial de datos
Fecha realizada: 01/07/26

Contexto:
La empresa ha centralizado información histórica de empleados provenientes
de distintos sistemas internos. Antes de realizar análisis de rotación,
rendimiento o retención de talento, es necesario comprender qué información
contiene el dataset, cómo se distribuyen los datos y si existen patrones
evidentes a simple vista.
*/

-- Preguntas:
-- 1. Visualizar todos los registros disponibles en la tabla employee. ✔️
-- 2. Mostrar únicamente la información relacionada con educación, ciudad y edad. ✔️
-- 3. Identificar a los empleados cuya edad supera los 30 años. ✔️
-- 4. Extraer los registros correspondientes a empleados que trabajan en Bangalore. ✔️
-- 5. Obtener el grupo de empleados que pertenecen al nivel salarial más alto. ✔️

-- 1)

SELECT * FROM employee.employee; -- Visualizar todos los registros

SELECT COUNT(*) FROM employee.employee; -- Cantidad total de registros

'''
 count 
-------
  4653
(1 row)
'''

SELECT * FROM employee.employee LIMIT 5; -- Vista rápida de algunos registros

'''
 employee_id | education | joining_year |   city    | payment_tier | age | gender | ever_benched | experience_in_current_domain | leave_or_not 
-------------+-----------+--------------+-----------+--------------+-----+--------+--------------+------------------------------+--------------
           1 | Bachelors |         2017 | Bangalore |            3 |  34 | Male   | f            |                            0 | f
           2 | Bachelors |         2013 | Pune      |            1 |  28 | Female | f            |                            3 | t
           3 | Bachelors |         2014 | New Delhi |            3 |  38 | Female | f            |                            2 | f
           4 | Masters   |         2016 | Bangalore |            3 |  27 | Male   | f            |                            5 | t
           5 | Masters   |         2017 | Pune      |            3 |  24 | Male   | t            |                            2 | t
(5 rows)
'''

-- 2)

\d employee.employee; -- Ver columnas y tipos de datos

'''
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

SELECT education, city, age FROM employee.employee; -- Ver solo educación, ciudad y edad

SELECT education, city, age FROM employee.employee LIMIT 5; 

'''
 education |   city    | age 
-----------+-----------+-----
 Bachelors | Bangalore |  34
 Bachelors | Pune      |  28
 Bachelors | New Delhi |  38
 Masters   | Bangalore |  27
 Masters   | Pune      |  24
(5 rows)
'''

-- 3)

SELECT * FROM employee.employee WHERE age >= 30; -- Empleados mayores o iguales a 30 años

SELECT * FROM employee.employee WHERE age >= 30 LIMIT 5;

'''
 employee_id | education | joining_year |   city    | payment_tier | age | gender | ever_benched | experience_in_current_domain | leave_or_not 
-------------+-----------+--------------+-----------+--------------+-----+--------+--------------+------------------------------+--------------
           1 | Bachelors |         2017 | Bangalore |            3 |  34 | Male   | f            |                            0 | f
           3 | Bachelors |         2014 | New Delhi |            3 |  38 | Female | f            |                            2 | f
           7 | Bachelors |         2015 | New Delhi |            3 |  38 | Male   | f            |                            0 | f
           8 | Bachelors |         2016 | Bangalore |            3 |  34 | Female | f            |                            2 | t
          10 | Masters   |         2017 | New Delhi |            2 |  37 | Male   | f            |                            2 | f
(5 rows)
'''

SELECT COUNT(*) FROM employee.employee WHERE age >= 30; -- Total de empleados mayores a 30

'''
count 
-------
  1623
(1 row)
'''

-- 4)

SELECT * FROM employee.employee WHERE city = 'Bangalore'; -- búsquedas específicos

SELECT * FROM employee.employee WHERE city ILIKE '%GALO%'; -- ILIKE para búsquedas sin importar mayúsculas/minúsculas

SELECT * FROM employee.employee WHERE city ILIKE '%GALO%' LIMIT 5;

'''
 employee_id | education | joining_year |   city    | payment_tier | age | gender | ever_benched | experience_in_current_domain | leave_or_not 
-------------+-----------+--------------+-----------+--------------+-----+--------+--------------+------------------------------+--------------
           1 | Bachelors |         2017 | Bangalore |            3 |  34 | Male   | f            |                            0 | f
           4 | Masters   |         2016 | Bangalore |            3 |  27 | Male   | f            |                            5 | t
           6 | Bachelors |         2016 | Bangalore |            3 |  22 | Male   | f            |                            0 | f
           8 | Bachelors |         2016 | Bangalore |            3 |  34 | Female | f            |                            2 | t
          11 | Masters   |         2012 | Bangalore |            3 |  27 | Male   | f            |                            5 | t
(5 rows)
'''

SELECT COUNT(*) FROM employee.employee WHERE city ILIKE '%GALO%'; -- Total de empleados en Bangalore

'''
count 
-------
  2228
(1 row)
'''

-- 5)

SELECT * FROM employee.employee WHERE payment_tier = ( SELECT MAX(payment_tier) FROM employee.employee); -- Empleados con el nivel salarial más alto
SELECT COUNT(*) FROM employee.employee WHERE payment_tier = (SELECT MAX(payment_tier) FROM employee.employee);

'''
count 
-------
  3492
(1 row)
'''
