/*
EJERCICIO 6 – Uso de Common Table Expressions (CTE)
Contexto:
A medida que las consultas se vuelven más complejas, la legibilidad y
mantenibilidad del SQL se vuelve crítica. Las CTEs permiten estructurar
mejor las consultas y reutilizar cálculos intermedios.
Preguntas:
26. Calcular la tasa de abandono de empleados por ciudad utilizando un CTE.
27. Clasificar a los empleados en Junior, Mid y Senior según sus años
de experiencia.
28. Construir un ranking de ciudades ordenado por tasa de abandono.
29. Comparar la tasa de abandono entre empleados hombres y mujeres.
30. Generar un resumen de métricas clave para un dashboard de RRHH
utilizando CTEs.
*/
-- 26)
-- Tasa de abandono de empleados por ciudad utilizando un CTE.
WiTH abandoned_by_city AS
     (
         SELECT
             city,
             ROUND(COUNT(*) FILTER(WHERE leave_or_not = true)::DECIMAL / COUNT(*) * 100, 2) AS abandoned_city_porcentage
         FROM
             employee.employee
         GROUP BY
             city)
SELECT
    *
FROM
    abandoned_by_city
ORDER BY
    abandoned_city_porcentage DESC;

'''   
city    | abandoned_city_porcentage
-----------+--------------------------- 
Pune      |                     50.39 
New Delhi |                     31.63 
Bangalore |                     26.71
(3 rows)
'''
-- 27)
-- Empleados en Junior, Mid y Senior según sus años de experiencia.

SELECT
    employee_id,
    experience_in_current_domain,
    CASE
    WHEN
        experience_in_current_domain < 3
    THEN
        'JUNIOR'
    WHEN
        experience_in_current_domain < 6
    THEN
        'MID'
    ELSE
        'SENIOR'
    END AS classification_by_year
FROM
    employee.employee;
SELECT
    experience_in_current_domain AS years_of_experience,
    COUNT(*) total_clasification   ,
    CASE
    WHEN
        experience_in_current_domain < 3
    THEN
        'JUNIOR'
    WHEN
        experience_in_current_domain < 6
    THEN
        'MID'
    ELSE
        'SENIOR'
    END AS classification_by_year
FROM
    employee.employee
GROUP BY
    experience_in_current_domain
ORDER BY
    years_of_experience DESC;

-- 28. Construir un ranking de ciudades ordenado por tasa de abandono.

WITH dropout_rate_ranking AS
     (
         SELECT
             city,
             COUNT(*) FILTER (WHERE leave_or_not = true) AS total_dropouts,
             ROUND(COUNT(*) FILTER (WHERE leave_or_not = true)::DECIMAL / COUNT(*) * 100, 2) AS dropout_rate_percentage
         FROM
             employee.employee
         GROUP BY
             city)
SELECT
    RANK() OVER
        (
            ORDER BY
                dropout_rate_percentage DESC
        )
    AS ranking,
    city,
    total_dropouts,
    dropout_rate_percentage
FROM
    dropout_rate_ranking;

''' 
ranking |   city    | total_dropouts | dropout_rate_percentage
---------+-----------+----------------+-------------------------       
1 | Pune      |            639 |                   50.39       
2 | New Delhi |            366 |                   31.63       
3 | Bangalore |            595 |                   26.71
(3 rows)
''' 

-- 29. Comparar la tasa de abandono entre empleados hombres y mujeres.

WITH gender_dropout AS (
    SELECT
        gender,
        COUNT(*) AS total_gender,
        COUNT(*) FILTER (WHERE leave_or_not = true) AS total_dropouts
    FROM employee.employee
    GROUP BY gender
)
SELECT
    gender,
    total_gender,
    total_dropouts,
    ROUND(total_dropouts * 100.0 / total_gender, 2) 
    AS dropout_rate_percentage
FROM gender_dropout
ORDER BY dropout_rate_percentage DESC;


-- 30. Generar un resumen de métricas clave para un dashboard de RRHH utilizando CTEs.

WITH base_metrics AS (
    SELECT
        COUNT(*) AS total_employees,
        COUNT(*) FILTER (WHERE leave_or_not = true) AS total_dropouts
    FROM employee.employee
),
city_with_highest_dropout AS (
    SELECT
        city,
        ROUND(
            COUNT(*) FILTER (WHERE leave_or_not = true)::DECIMAL / COUNT(*) * 100, 2) 
            AS dropout_rate
    FROM employee.employee
    GROUP BY city
    ORDER BY dropout_rate DESC
    LIMIT 1
),
gender_distribution AS (
    SELECT
        gender,
        COUNT(*) AS total
    FROM employee.employee
    GROUP BY gender
)
SELECT
    bm.total_employees,
    bm.total_dropouts,
    ROUND(bm.total_dropouts * 100.0 / bm.total_employees, 2) AS overall_dropout_rate,
    c.city AS highest_dropout_city,
    c.dropout_rate AS highest_city_dropout_rate
FROM base_metrics bm
CROSS JOIN city_with_highest_dropout c;
