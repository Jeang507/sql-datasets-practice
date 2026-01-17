/*
EJERCICIO 7 – Análisis aplicado para toma de decisiones

Contexto:
La empresa busca utilizar los datos disponibles para apoyar decisiones
estratégicas relacionadas con retención de talento, compensación y
planificación de recursos humanos.

Preguntas:

31. Analizar si existe relación entre haber sido benchado y la decisión
    de abandonar la empresa.
32. Identificar la ciudad con mayor riesgo de rotación de empleados.
33. Evaluar si el nivel salarial influye en la permanencia de los empleados.
34. Identificar la combinación de ciudad y nivel educativo con mayor
    tasa de abandono.
35. Analizar si los empleados más jóvenes presentan mayor rotación que
    los empleados de mayor edad.
36. Evaluar el impacto de la experiencia en la rotación de empleados.
37. Identificar las ciudades donde debería priorizarse la inversión
    en estrategias de retención.
38. Determinar el perfil de empleado con mayor riesgo de salida.
39. Definir métricas clave para un dashboard de RRHH.
40. Diseñar una vista SQL que consolide indicadores para análisis recurrentes.
*/

--31) 

/* Relación entre haber sido benchado y la decisión
    de abandonar la empresa.*/

WITH abandonment_by_bench AS (
        SELECT
        ever_benched,
        COUNT(*) AS total_employees,
        COUNT(*) FILTER (WHERE leave_or_not = true) AS abandoned_employees,
        ROUND(COUNT(*) FILTER (WHERE leave_or_not = true)::DECIMAL / COUNT(*) * 100 , 2) 
        AS abandonment_rate_porcentage
        FROM employee.employee
        GROUP BY ever_benched
) SELECT * FROM abandonment_by_bench;

-- 32)

-- La ciudad con mayor riesgo de rotación de empleados.

WITH employee_turnover AS (
        SELECT city, 
        COUNT(*) AS total_employees,
        COUNT(*) FILTER (where leave_or_not = true)
        AS abandoned_employees,
        ROUND(COUNT(*) FILTER (where leave_or_not = true)::DECIMAL / COUNT(*) * 100, 2)
        AS employee_turnover_porcentage
        FROM employee.employee
        GROUP BY city
        ORDER BY employee_turnover_porcentage DESC
    ) SELECT * FROM employee_turnover;
        

-- 33)

-- Nivel salarial en la permanencia de los empleados.

WITH employee_retention AS (
        SELECT payment_tier, 
        COUNT(*) AS total_employees,
        COUNT(*) FILTER (where leave_or_not = true)
        AS abandoned_employees,
        ROUND(COUNT(*) FILTER (where leave_or_not = false)::DECIMAL / COUNT(*) * 100, 2)
        AS employee_retention_porcentage
        FROM employee.employee
        GROUP BY payment_tier
    ) SELECT * FROM employee_retention
    ORDER BY employee_retention_porcentage DESC;

-- 34) 

/* Combinación de ciudad y nivel educativo con mayor
    tasa de abandono.*/

WITH dropout_rate_by_city_and_education AS (
        SELECT 
        city,
        education, 
        COUNT(*) AS total_employees,
        COUNT(*) FILTER (WHERE leave_or_not = true) 
        AS abandoned_employees,
        ROUND(COUNT(*) FILTER (WHERE leave_or_not = true)::DECIMAL / COUNT(*) * 100, 2)
        AS dropout_rate_porcentage 
        FROM employee.employee
        GROUP BY city, education
        ) SELECT * FROM dropout_rate_by_city_and_education
        ORDER BY dropout_rate_porcentage DESC;

-- 35) 

/* Empleados más jóvenes presentan mayor rotación que
    los empleados de mayor edad.*/

WITH turnover_by_age_group as (
    SELECT CASE 
    WHEN age BETWEEN 18 AND 30 THEN 'Empleados jóvenes'
    ELSE 'Empleados mayores'
    END AS age_group,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE leave_or_not = true) AS abandoned_employees,
    ROUND(COUNT(*) FILTER (WHERE leave_or_not = true)::DECIMAL / COUNT(*) * 100, 2)
    AS turnover_rate_percentage
    FROM employee.employee
    GROUP BY age_group
    ) SELECT * FROM turnover_by_age_group
    ORDER BY turnover_rate_percentage DESC;

-- 36) 

-- Impacto de la experiencia en la rotación de empleados.

WITH turnove_by_experience AS (
    SELECT experience_in_current_domain,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE leave_or_not = true) 
    AS abandoned_employees,
    ROUND(COUNT(*) FILTER (WHERE leave_or_not = true)::DECIMAL / COUNT(*) * 100, 2)
    AS turnove_by_experience_porcentage
    FROM employee.employee
    GROUP BY experience_in_current_domain
    ) SELECT * FROM turnove_by_experience
    ORDER BY turnove_by_experience_porcentage DESC;

-- Expieriencia por grupo

WITH turnover_by_experience AS (
    SELECT CASE 
    WHEN experience_in_current_domain <= 2 THEN 'Low experience'
    WHEN experience_in_current_domain BETWEEN 3 AND 5 THEN 'Medium experience'
    ELSE 'High experience'
    END AS experience_level,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE leave_or_not = true) 
    AS abandoned_employees,
    ROUND(COUNT(*) FILTER (WHERE leave_or_not = true)::DECIMAL / COUNT(*) * 100, 2)
    AS turnover_rate_percentage
    FROM employee.employee
    GROUP BY experience_level
    ) SELECT * FROM turnover_by_experience
    ORDER BY turnover_rate_percentage DESC;

-- 37)

/* Ciudades donde debería priorizarse la inversión
    en estrategias de retención.*/

WITH retention_strategies AS (
    SELECT city,
    COUNT (*) AS total_employees,
    COUNT(*) FILTER (WHERE leave_or_not = true) 
    AS abandoned_employees,
    ROUND(COUNT(*) FILTER (WHERE leave_or_not = true)::DECIMAL / COUNT(*) * 100, 2)
    AS dropout_rate_percentage
    FROM employee.employee
    GROUP BY city
    ) SELECT * FROM retention_strategies
    ORDER BY dropout_rate_percentage DESC, total_employees DESC;

-- 38)

-- Perfil de empleado con mayor riesgo de salida.

WITH employee_risk_profile AS (
    SELECT 
    CASE
    WHEN age BETWEEN 18 AND 30 THEN 'Joven'
    ELSE 'Mayor'
    END AS age_group,
    payment_tier,
    CASE
    WHEN experience_in_current_domain <= 2 THEN 'Baja experiencia'
    WHEN experience_in_current_domain BETWEEN 3 AND 5 THEN 'Experiencia media'
    ELSE 'Alta experiencia'
    END AS experience_group,
    city,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE leave_or_not = true) AS abandoned_employees,
    ROUND(COUNT(*) FILTER (WHERE leave_or_not = true)::DECIMAL / COUNT(*) * 100, 2) AS dropout_rate_percentage
    FROM employee.employee
    GROUP BY
    age_group,
    payment_tier,
    experience_group,
    city
    ) SELECT * 
    FROM employee_risk_profile
    ORDER BY dropout_rate_percentage DESC;

-- 39)

-- Métricas clave para un dashboard de RRHH.

- Tasa global de rotación
- Tasa global de retención
- Total de empleados
- Total de empleados que abandonaron
- Rotación por ciudad
- Rotación por nivel salarial
- Rotación por grupo etario
- Rotación por nivel de experiencia
- Rotación por nivel educativo
- Rotación de empleados benchados vs no benchados
- Ciudades con mayor riesgo de rotación
- Perfiles de empleados con mayor riesgo de salida
- Segmentos prioritarios para inversión en retención

-- 40) 

-- Vista SQL para análisis recurrentes.

CREATE VIEW hr_turnover_dashboard AS
SELECT
    city,
    payment_tier,
    CASE
        WHEN age BETWEEN 18 AND 30 THEN 'Joven'
        ELSE 'Mayor'
    END AS age_group,
    CASE
        WHEN experience_in_current_domain <= 2 THEN 'Baja experiencia'
        WHEN experience_in_current_domain BETWEEN 3 AND 5 THEN 'Experiencia media'
        ELSE 'Alta experiencia'
    END AS experience_group,
    COUNT(*) AS total_employees,
    COUNT(*) FILTER (WHERE leave_or_not = true) AS abandoned_employees,
    ROUND(COUNT(*) FILTER (WHERE leave_or_not = true)::DECIMAL / COUNT(*) * 100, 2) 
    AS turnover_rate_percentage
FROM employee.employee
GROUP BY
    city,
    payment_tier,
    age_group,
    experience_group;
