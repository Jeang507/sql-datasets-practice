/*
EJERCICIO 2 – Filtrado y segmentación de empleados

Contexto:
El área de Recursos Humanos necesita segmentar a los empleados para análisis
más específicos. El objetivo es identificar grupos particulares de interés
según edad, experiencia, ubicación geográfica y nivel salarial, con el fin
de entender mejor la composición de la fuerza laboral.

Preguntas:

6. Identificar empleados menores de 30 años que se encuentren en el nivel
   salarial más alto (PaymentTier = 3).
7. Obtener los empleados que trabajan en las ciudades de Pune o New Delhi.
8. Listar empleados con un nivel de experiencia intermedio
   (entre 1 y 5 años en su dominio actual).
9. Identificar empleados que fueron benchados y posteriormente abandonaron
   la empresa.
10. Ordenar los empleados por edad de forma descendente para identificar
    rápidamente a los más veteranos.
*/

\d employee.employee;

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

-- 1)

-- Cantidad total de empleados menores a 30 años
SELECT COUNT(*) FROM employee.employee
WHERE age < 30;

'''
 count 
-------
  3030
(1 row)
'''

/* Cantidad total de empleados que se encuentran en el nivel
salarial más alto*/

SELECT COUNT(*)
FROM employee.employee
WHERE payment_tier = 3;

SELECT COUNT(*) FROM employee.employee 
WHERE payment_tier = (SELECT MAX(payment_tier)
FROM employee.employee);

'''
 count 
-------
  3492
(1 row)
'''

/* Cantidad total de empleados menores de 30 años que se encuentren 
en el nivel salarial más alto*/

SELECT COUNT(*)
FROM employee.employee
WHERE age < 30 AND payment_tier = 3;

SELECT COUNT(*) FROM employee.employee
WHERE age < 30 AND payment_tier = (SELECT MAX(payment_tier) 
FROM employee.employee);

'''
 count 
-------
  2270
(1 row)
'''
/* Visualizar empleados menores de 30 años que se encuentren en el nivel 
salarial más alto*/

SELECT * FROM employee.employee
WHERE age < 30 AND payment_tier = (SELECT MAX(payment_tier) 
FROM employee.employee);

-- 7)

SELECT COUNT(*) FROM employee.employee
WHERE city = 'Pune' OR city = 'New Delhi';

SELECT COUNT(*) FROM employee.employee
WHERE city IN ('Pune', 'New Delhi');

'''
 count 
-------
  2425
(1 row)
'''

SELECT * FROM employee.employee -- Empleados que trabajan en las ciudades de Pune o New Delhi.
WHERE city = 'Pune' OR city = 'New Delhi';

SELECT * FROM employee.employee
WHERE city IN ('Pune', 'New Delhi');

--8) 

/* Lista de empleados con un nivel de experiencia intermedio
(entre 1 y 5 años en su dominio actual).*/

SELECT * FROM employee.employee
WHERE experience_in_current_domain BETWEEN 1 AND 5; -- Utilizando operador BETWEEN

SELECT * FROM employee.employee
WHERE experience_in_current_domain >= 1 -- Comparación explicita
AND experience_in_current_domain <= 5;

SELECT COUNT(*) FROM employee.employee -- Contar la cantidad total
WHERE experience_in_current_domain BETWEEN 1 AND 5;
'''
 count 
-------
  4281
(1 row)
'''

--9) 

/* Empleados que fueron benchados y posteriormente abandonaron
   la empresa.*/

SELECT * FROM employee.employee
WHERE ever_benched = 't'
AND leave_or_not = 't';

SELECT *
FROM employee.employee WHERE ever_benched = true
AND leave_or_not = true;

SELECT COUNT(*) FROM employee.employee
WHERE ever_benched = 't'
AND leave_or_not = 't';

SELECT COUNT(*) FROM employee.employee
WHERE ever_benched = true
AND leave_or_not = true;

'''
 count 
-------
   217
(1 row)
'''

-- 10)
/*Empleado ordenaods por edad de forma descendente para identificar
    rápidamente a los más veteranos.*/

SELECT * FROM employee.employee
ORDER BY age DESC;






