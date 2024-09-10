-- Crear tipos ENUM
CREATE TYPE sexo AS ENUM ('H', 'M');
CREATE TYPE tipo_asignatura4 AS ENUM ('básica', 'obligatoria', 'optativa');


-- Crear tabla departamento
CREATE TABLE departamento (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Crear tabla alumno
CREATE TABLE alumno (
    id SERIAL PRIMARY KEY,
    nif VARCHAR(9),
    nombre VARCHAR(25) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    ciudad VARCHAR(25) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    telefono VARCHAR(9),
    fecha_nacimiento DATE NOT NULL,
    sexo sexo NOT NULL
);

-- Crear tabla profesor
CREATE TABLE profesor (
    id_profesor SERIAL PRIMARY KEY,
    nif varchar(25),
    nombre varchar(25) NOT NULL,
    apellido1 varchar(50) NOT NULL,
    apellido2 varchar(50),
    ciudad varchar(25) NOT NULL,
    direccion varchar(50) NOT null    ,
    telefono varchar(9),
    fecha_nacimiento date NOT NULL,
    sexo sexo  NOT NULL,
    id_departamento INT NOT NULL,
    FOREIGN KEY (id_departamento) REFERENCES departamento(id)
);

-- Crear tabla grado
CREATE TABLE grado (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Crear tabla curso escolar
CREATE TABLE curso_escolar (
    id SERIAL PRIMARY KEY,
    anyo_inicio INTEGER NOT NULL,
    anyo_fin INTEGER NOT NULL
);

-- Crear tabla asignatura
CREATE TABLE asignatura (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    creditos FLOAT NOT NULL,
    tipo tipo_asignatura4 NOT NULL,
    curso SMALLINT NOT NULL,
    cuatrimestre SMALLINT NOT NULL,
    id_profesor INT,
    id_grado INT NOT NULL,
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    FOREIGN KEY (id_grado) REFERENCES grado(id)
);

-- Crear tabla alumno se matricula asignatura
CREATE TABLE alumno_se_matricula_asignatura (
    id_alumno INT NOT NULL,
    id_asignatura INT NOT NULL,
    id_curso_escolar INT NOT NULL,
    PRIMARY KEY (id_alumno, id_asignatura, id_curso_escolar),
    FOREIGN KEY (id_alumno) REFERENCES alumno(id),
    FOREIGN KEY (id_asignatura) REFERENCES asignatura(id),
    FOREIGN KEY (id_curso_escolar) REFERENCES curso_escolar(id)
);

SELECT tablename  FROM pg_catalog.pg_tables where schemaname = 'public';

-- ################### Consultas sobre una tabla ###################

-- 1. Devuelve un listado con el primer apellido, segundo apellido y el nombre de todos los alumnos. El listado deberá estar ordenado alfabéticamente de menor a mayor por el primer apellido, segundo apellido y nombre.

SELECT apellido1, apellido2, nombre
FROM alumno
ORDER BY apellido1 ASC, apellido2 ASC, nombre ASC;

-- 2. Averigua el nombre y los dos apellidos de los alumnos que no han dado de alta su número de teléfono en la base de datos.

SELECT nombre, apellido1, apellido2
FROM alumno
WHERE telefono IS NULL;

-- 3. Devuelve el listado de los alumnos que nacieron en 1999.

SELECT nombre, apellido1, apellido2
FROM alumno
WHERE EXTRACT(YEAR FROM fecha_nacimiento) = 1999;

-- 4. Devuelve el listado de profesores que no han dado de alta su número de teléfono en la base de datos y además su nif termina en K.

SELECT nombre, apellido1, apellido2
FROM profesor
WHERE telefono IS NULL
AND nif LIKE '%K';

-- 5. Devuelve el listado de las asignaturas que se imparten en el primer cuatrimestre, en el tercer curso del grado que tiene el identificador 7.

SELECT nombre
FROM asignatura
WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;

-- ################### Consultas multitabla (Composición interna) ###################

-- 1. Devuelve un listado con los datos de todas las alumnas que se han matriculado alguna vez en el Grado en Ingeniería Informática (Plan 2015).

SELECT a.nombre, a.apellido1, a.apellido2, a.nif
FROM alumno a
JOIN alumno_se_matricula_asignatura am ON a.id = am.id_alumno
JOIN asignatura asig ON am.id_asignatura = asig.id
JOIN grado g ON asig.id_grado = g.id
WHERE a.sexo = 'M' AND g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

-- 2. Devuelve un listado con todas las asignaturas ofertadas en el Grado en Ingeniería Informática (Plan 2015).

SELECT asig.nombre
FROM asignatura asig
JOIN grado g ON asig.id_grado = g.id
WHERE g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

-- 3. Devuelve un listado de los profesores junto con el nombre del departamento al que están vinculados. El listado debe devolver cuatro columnas, primer apellido, segundo apellido, nombre y nombre del departamento. 
--    El resultado estará ordenado alfabéticamente de menor a mayor por los apellidos y el nombre.

SELECT p.apellido1, p.apellido2, p.nombre, d.nombre AS departamento
FROM profesor p
JOIN departamento d ON p.id_departamento = d.id
ORDER BY p.apellido1 ASC, p.apellido2 ASC, p.nombre ASC;

-- 4. Devuelve un listado con el nombre de las asignaturas, año de inicio y año de fin del curso escolar del alumno con nif 26902806M.

SELECT asig.nombre, ce.anyo_inicio, ce.anyo_fin
FROM alumno a
JOIN alumno_se_matricula_asignatura am ON a.id = am.id_alumno
JOIN asignatura asig ON am.id_asignatura = asig.id
JOIN curso_escolar ce ON am.id_curso_escolar = ce.id
WHERE a.nif = '26902806M';

-- 5. Devuelve un listado con el nombre de todos los departamentos que tienen profesores que imparten alguna asignatura en el Grado en Ingeniería Informática (Plan 2015).

SELECT DISTINCT d.nombre
FROM departamento d
JOIN profesor p ON d.id = p.id_departamento
JOIN asignatura asig ON p.id_profesor = asig.id_profesor
JOIN grado g ON asig.id_grado = g.id
WHERE g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

-- 6. Devuelve un listado con todos los alumnos que se han matriculado en alguna asignatura durante el curso escolar 2018/2019.

SELECT DISTINCT a.nombre, a.apellido1, a.apellido2
FROM alumno a
JOIN alumno_se_matricula_asignatura am ON a.id = am.id_alumno
JOIN curso_escolar ce ON am.id_curso_escolar = ce.id
WHERE ce.anyo_inicio = 2018 AND ce.anyo_fin = 2019;

-- ################### Consultas multitabla (Composición externa) ###################

-- 1. Devuelve un listado con los nombres de todos los profesores y los departamentos que tienen vinculados. El listado también debe mostrar aquellos profesores que no tienen ningún departamento asociado. El listado debe devolver 
-- cuatro columnas, nombre del departamento, primer apellido, segundo apellido y nombre del profesor. El resultado estará ordenado alfabéticamente de menor a mayor por el nombre del departamento, apellidos y el nombre.

SELECT d.nombre AS departamento, p.apellido1, p.apellido2, p.nombre AS profesor
FROM profesor p
LEFT JOIN departamento d ON p.id_departamento = d.id
ORDER BY d.nombre ASC, p.apellido1 ASC, p.apellido2 ASC, p.nombre ASC;

-- 2. Devuelve un listado con los profesores que no están asociados a un departamento.

SELECT p.nombre, p.apellido1, p.apellido2
FROM profesor p
LEFT JOIN departamento d ON p.id_departamento = d.id
WHERE d.id IS NULL;

-- 3. Devuelve un listado con los departamentos que no tienen profesores asociados.

SELECT d.nombre
FROM departamento d
LEFT JOIN profesor p ON d.id = p.id_departamento
WHERE p.id_profesor IS NULL;

-- 4. Devuelve un listado con los profesores que no imparten ninguna asignatura.

SELECT p.nombre, p.apellido1, p.apellido2
FROM profesor p
LEFT JOIN asignatura asig ON p.id_profesor = asig.id_profesor
WHERE asig.id_profesor IS NULL;

-- 5. Devuelve un listado con las asignaturas que no tienen un profesor asignado.

SELECT asig.nombre
FROM asignatura asig
LEFT JOIN profesor p ON asig.id_profesor = p.id_profesor
WHERE p.id_profesor IS NULL;

-- 6. Devuelve un listado con todos los departamentos que tienen alguna asignatura que no se haya impartido en ningún curso escolar. El resultado debe mostrar el nombre del departamento y el nombre de la asignatura que no se haya impartido nunca.

SELECT d.nombre AS departamento, asig.nombre AS asignatura
FROM departamento d
LEFT JOIN profesor p ON d.id = p.id_departamento
INNER JOIN asignatura asig ON p.id_profesor = asig.id_profesor
LEFT JOIN alumno_se_matricula_asignatura am ON asig.id = am.id_asignatura
WHERE am.id_asignatura IS NULL;

-- ################### Consultas resumen ###################

-- 1. Devuelve el número total de alumnas que hay.

SELECT COUNT(*) AS total_alumnas
FROM alumno
WHERE sexo = 'M';

-- 2. Calcula cuántos alumnos nacieron en 1999.

SELECT COUNT(*) AS alumnos_nacidos_1999
FROM alumno
WHERE EXTRACT(YEAR FROM fecha_nacimiento) = 1999;

-- 3. Calcula cuántos profesores hay en cada departamento. El resultado sólo debe mostrar dos columnas, una con el nombre del departamento y otra con el número de profesores que hay en ese departamento. 
-- El resultado sólo debe incluir los departamentos que tienen profesores asociados y deberá estar ordenado de mayor a menor por el número de profesores.

SELECT d.nombre AS departamento, COUNT(p.id_profesor) AS numero_profesores
FROM departamento d
JOIN profesor p ON d.id = p.id_departamento
GROUP BY d.nombre
ORDER BY numero_profesores DESC;

-- 4. Devuelve un listado con todos los departamentos y el número de profesores que hay en cada uno de ellos. Tenga en cuenta que pueden existir departamentos que no tienen profesores asociados. 
-- Estos departamentos también tienen que aparecer en el listado.

SELECT d.nombre AS departamento, COUNT(p.id_profesor) AS numero_profesores
FROM departamento d
LEFT JOIN profesor p ON d.id = p.id_departamento
GROUP BY d.nombre
ORDER BY numero_profesores DESC;

-- 5. Devuelve un listado con el nombre de todos los grados existentes en la base de datos y el número de asignaturas que tiene cada uno. Tenga en cuenta que pueden existir grados que no tienen asignaturas asociadas. 
-- Estos grados también tienen que aparecer en el listado. El resultado deberá estar ordenado de mayor a menor por el número de asignaturas.

SELECT g.nombre AS grado, COUNT(asig.id) AS numero_asignaturas
FROM grado g
LEFT JOIN asignatura asig ON g.id = asig.id_grado
GROUP BY g.nombre
ORDER BY numero_asignaturas DESC;

-- 6. Devuelve un listado con el nombre de todos los grados existentes en la base de datos y el número de asignaturas que tiene cada uno, de los grados que tengan más de 40 asignaturas asociadas.

SELECT g.nombre AS grado, COUNT(asig.id) AS numero_asignaturas
FROM grado g
LEFT JOIN asignatura asig ON g.id = asig.id_grado
GROUP BY g.nombre
HAVING COUNT(asig.id) > 40
ORDER BY numero_asignaturas DESC;

-- 7. Devuelve un listado que muestre el nombre de los grados y la suma del número total de créditos que hay para cada tipo de asignatura. El resultado debe tener tres columnas: nombre del grado, tipo de asignatura y la suma
-- de los créditos de todas las asignaturas que hay de ese tipo. Ordene el resultado de mayor a menor por el número total de crédidos.

SELECT g.nombre AS grado, asig.tipo AS tipo_asignatura, SUM(asig.creditos) AS total_creditos
FROM grado g
JOIN asignatura asig ON g.id = asig.id_grado
GROUP BY g.nombre, asig.tipo
ORDER BY total_creditos DESC;

-- 8. Devuelve un listado que muestre cuántos alumnos se han matriculado de alguna asignatura en cada uno de los cursos escolares. El resultado deberá mostrar dos columnas, una columna con el año de inicio del curso escolar y
-- otra con el número de alumnos matriculados.

SELECT ce.anyo_inicio, COUNT(DISTINCT am.id_alumno) AS numero_alumnos_matriculados
FROM curso_escolar ce
JOIN alumno_se_matricula_asignatura am ON ce.id = am.id_curso_escolar
GROUP BY ce.anyo_inicio
ORDER BY ce.anyo_inicio ASC;

-- 9. Devuelve un listado con el número de asignaturas que imparte cada profesor. El listado debe tener en cuenta aquellos profesores que no imparten ninguna asignatura. El resultado mostrará cinco columnas: id, nombre, primer apellido, segundo apellido y número de asignaturas.
-- El resultado estará ordenado de mayor a menor por el número de asignaturas.

SELECT p.id_profesor, p.nombre, p.apellido1, p.apellido2, COUNT(asig.id) AS numero_asignaturas
FROM profesor p
LEFT JOIN asignatura asig ON p.id_profesor = asig.id_profesor
GROUP BY p.id_profesor, p.nombre, p.apellido1, p.apellido2
ORDER BY numero_asignaturas DESC;

-- ################### Subconsultas ###################

-- 1. Devuelve todos los datos del alumno más joven.

SELECT *
FROM alumno
WHERE fecha_nacimiento = (SELECT MAX(fecha_nacimiento) FROM alumno);

-- 2. Devuelve un listado con los profesores que no están asociados a un departamento.

SELECT *
FROM profesor
WHERE id_departamento IS NULL;

-- 3. Devuelve un listado con los departamentos que no tienen profesores asociados.

SELECT *
FROM departamento
WHERE id NOT IN (SELECT id_departamento FROM profesor);

-- 4. Devuelve un listado con los profesores que tienen un departamento asociado y que no imparten ninguna asignatura.

SELECT *
FROM profesor
WHERE id_departamento IS NOT NULL
AND id_profesor NOT IN (SELECT id_profesor FROM asignatura);

-- 5. Devuelve un listado con las asignaturas que no tienen un profesor asignado.

SELECT *
FROM asignatura
WHERE id_profesor IS NULL;

-- 6. Devuelve un listado con todos los departamentos que no han impartido asignaturas en ningún curso escolar.

SELECT *
FROM departamento
WHERE id NOT IN (
    SELECT p.id_departamento
    FROM profesor p
    JOIN asignatura asig ON p.id_profesor = asig.id_profesor
    JOIN alumno_se_matricula_asignatura am ON asig.id = am.id_asignatura);


-- REALIZADO POR PAULA MUÑOZ
