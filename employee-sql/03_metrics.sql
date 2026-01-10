/*
EJERCICIO 3 – Métricas generales de la organización

Contexto:
La gerencia solicita indicadores generales que permitan tener una visión
global de la empresa. Estas métricas sirven como base para reportes
ejecutivos y ayudan a contextualizar análisis más avanzados.

Preguntas:

11. Calcular la cantidad total de empleados registrados.
12. Determinar cómo se distribuyen los empleados por ciudad.
13. Calcular la edad promedio de la plantilla.
14. Identificar la edad mínima y máxima entre todos los empleados.
15. Calcular el promedio de años de experiencia por ciudad.
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

-- 11)

-- Cantidad total de empleados registrados

SELECT * FROM employee.employee;
SELECT COUNT(*) FROM employee.employee;

'''
 count 
-------
  4653
(1 row)
'''

-- 12) 

-- Distribución por ciudad

SELECT city FROM employee.employee -- Visualizar lo diferentes grupos de ciudades registrados
GROUP BY city;

SELECT DISTINCT city 
FROM employee.employee;

'''
   city    
-----------
 Bangalore
 Pune
 New Delhi
(3 rows)
'''

SELECT city AS distribution_by_city --Visualizar la distribución completa
FROM employee.employee
ORDER by city;

SELECT city, COUNT(*) AS distribution_by_city
FROM employee.employee
GROUP BY city
ORDER BY city ASC;

'''
   city    | distribution_by_city 
-----------+----------------------
 Bangalore |                 2228
 New Delhi |                 1157
 Pune      |                 1268
(3 rows)
'''

-- 13)
-- Edad promedio de la plantilla.

SELECT AVG(age)::NUMERIC(10) FROM employee.employee;
SELECT ROUND(AVG(age)) FROM employee.employee;
'''
 avg 
-----
  29
(1 row)
'''

-- 14)
-- Edad mínima y máxima entre todos los empleados.

SELECT MAX(age) AS maximum_age, MIN(age) AS minimum_age
FROM employee.employee;

'''
 maximum_age | minimum_age 
-------------+-------------
          41 |          22
(1 row)
'''

-- 15)
-- Promedio de años de experiencia por ciudad.

SELECT city, ROUND(AVG(experience_in_current_domain)) AS average_experience
FROM employee.employee
GROUP BY city;
   city    | average_experience 
-----------+--------------------
 Bangalore |                  3
 Pune      |                  3
 New Delhi |                  3
(3 rows)
