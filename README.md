Este repositorio contiene una serie de ejercicios prácticos de **SQL** 
basados en datasets reales.

Todo corre sobre **PostgreSQL** levantado con **Docker**. 
Este espacio es para practicar queries, explorar datos y 
mejorar mis habilidad usando SQL.

## Datasets

Los datasets utilizados provienen de **Kaggle**:

- **Employee Dataset**  
  https://www.kaggle.com/datasets/tawfikelmetwally/employee-dataset

- **Hospital Dataset**  
  https://www.kaggle.com/datasets/blueblushed/hospital-dataset-for-practice

- **Financial Transactions / Fraud Dataset**  
  https://www.kaggle.com/datasets/computingvictor/transactions-fraud-datasets

- **NYC Yellow Taxi Trip Records (January 2024)**  
  https://www.kaggle.com/datasets/ibrahimqasimi/nyc-yellow-taxi-trip-records-january-2024

- **Students Performance Dataset**  
  https://www.kaggle.com/datasets/spscientist/students-performance-in-exams

Cada dataset trabaja con **schemas independientes**.

```
        List of schemas
   Name    |       Owner       
-----------+-------------------
 employee  | postgres
 financial | postgres
 hospital  | postgres
 public    | pg_database_owner
 students  | postgres
 taxi      | postgres
(6 rows)
```

## Estructura del repositorio

```
dataset/
├── docker/ # PostgreSQL + pgAdmin
├── employee-sql/
├── financial-transaction-sql/
├── hospital-sql/
├── students-performance-sql/
├── taxi-trip-records-sql/
└── README.md
```

## Docker

El proyecto utiliza Docker para levantar PostgreSQL y pgAdmin.

- PostgreSQL corre en el puerto **5433**
- pgAdmin está disponible en **http://localhost:81**

Para levantar el entorno:

```bash
cd docker
docker compose up -d
```

## Objetivo final
- Practicar SQL
- Trabajar con datasets reales
- Mejorar lógica de análisis de datos
- Uso de docker para un entorno aislado y reproducible