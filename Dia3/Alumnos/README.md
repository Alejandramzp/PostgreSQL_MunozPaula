<p align= "center"><img  width="20%" src= "https://upload.wikimedia.org/wikipedia/commons/2/29/Postgresql_elephant.svg">
<img  width="40%" src= "https://i.imgur.com/DLaHH38.jpeg"></p>

<h1 align= "center"> Base de Datos de Alumnos</h1> 

<h2 align= "center">Consultas sobre una tabla</h2>

<p> 1. Devuelve un listado con el primer apellido, segundo apellido y el nombre de todos los alumnos. El listado deberá estar ordenado alfabéticamente de menor a mayor por el primer apellido, segundo apellido y nombre.</p>

```sql
SELECT apellido1, apellido2, nombre
FROM alumno
ORDER BY apellido1 ASC, apellido2 ASC, nombre ASC;

+-----------+-----------+----------+
| apellido1 | apellido2 |  nombre  |
+-----------+-----------+----------+
| Domínguez | Guerrero  | Antonio  |
| Gea       | Ruiz      | Sonia    |
| Gutiérrez | López     | Juan     |
| Heller    | Pagac     | Pedro    |
| Herman    | Pacocha   | Daniel   |
| Hernández | Martínez  | Irene    |
| Herzog    | Tremblay  | Ramón    |
| Koss      | Bayer     | José     |
| Lakin     | Yundt     | Inma     |
| Saez      | Vega      | Juan     |
| Sánchez   | Pérez     | Salvador |
| Strosin   | Turcotte  | Ismael   | 
+-----------+-----------+----------+
(12 rows)
```

<p> 2. Averigua el nombre y los dos apellidos de los alumnos que no han dado de alta su número de teléfono en la base de datos. </p>

```sql
SELECT nombre, apellido1, apellido2
FROM alumno
WHERE telefono IS NULL;

+--------+-----------+-----------+
| nombre | apellido1 | apellido2 |
+--------+-----------+-----------+
| Pedro  | Heller    | Pagac     |
| Ismael | Strosin   | Turcotte  |
+--------+-----------+-----------+
(2 rows)
```
<p> 3. Devuelve el listado de los alumnos que nacieron en 1999.</p>

```sql
SELECT nombre, apellido1, apellido2
FROM alumno
WHERE EXTRACT(YEAR FROM fecha_nacimiento) = 1999;

+---------+-----------+-----------+
| nombre  | apellido1 | apellido2 |
+---------+-----------+-----------+
| Ismael  | Strosin   | Turcotte  |
| Antonio | Domínguez | Guerrero  |
+---------+-----------+-----------+
(2 rows)
```

<p> 4. Devuelve el listado de profesores que no han dado de alta su número de teléfono en la base de datos y además su nif termina en K.</p>

```sql
SELECT nombre, apellido1, apellido2
FROM profesor
WHERE telefono IS NULL
AND nif LIKE '%K';

+-----------+-----------+-----------+
|  nombre   | apellido1 | apellido2 |
+-----------+-----------+-----------+
| Antonio   | Fahey     | Considine |
| Guillermo | Ruecker   | Upton     |
+-----------+-----------+-----------+
(2 rows)
```

<p> 5. Devuelve el listado de las asignaturas que se imparten en el primer cuatrimestre, en el tercer curso del grado que tiene el identificador 7.</p>

```sql
SELECT nombre
FROM asignatura
WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;

+-------------------------------------------+
|                 nombre                    |
+-------------------------------------------+
| Bases moleculares del desarrollo vegetal  |
| Fisiología animal                         |
| Metabolismo y biosíntesis de biomoléculas |
| Operaciones de separación                 |
| Patología molecular de plantas            |
| Técnicas instrumentales básicas           |
+-------------------------------------------+
(6 rows)
```
<h2 align= "center">Consultas multitabla (Composición interna)</h2>

<p> 1. Devuelve un listado con los datos de todas las alumnas que se han matriculado alguna vez en el Grado en Ingeniería Informática (Plan 2015).</p>

```sql
SELECT a.nombre, a.apellido1, a.apellido2, a.nif
FROM alumno a
JOIN alumno_se_matricula_asignatura am ON a.id = am.id_alumno
JOIN asignatura asig ON am.id_asignatura = asig.id
JOIN grado g ON asig.id_grado = g.id
WHERE a.sexo = 'M' AND g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

+--------+-----------+-----------+-----+
| nombre | apellido1 | apellido2 | nif |
+--------+-----------+-----------+-----+
(0 rows)
```

<p> 2. Devuelve un listado con todas las asignaturas ofertadas en el Grado en Ingeniería Informática (Plan 2015).</p>

```sql
SELECT asig.nombre
FROM asignatura asig
JOIN grado g ON asig.id_grado = g.id
WHERE g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

+------------------------------------------------------------------------+
|                                 nombre                                 |
+------------------------------------------------------------------------+
| Álgegra lineal y matemática discreta                                   |
| Cálculo                                                                |
| Física para informática                                                |
| Introducción a la programación                                         |
| Organización y gestión de empresas                                     |
| Estadística                                                            |
| Estructura y tecnología de computadores                                |
| Fundamentos de electrónica                                             |
| Lógica y algorítmica                                                   |
| Metodología de la programación                                         |
| Arquitectura de Computadores                                           |
| Estructura de Datos y Algoritmos I                                     |
| Ingeniería del Software                                                |
| Sistemas Inteligentes                                                  |
| Sistemas Operativos                                                    |
| Bases de Datos                                                         |
| Estructura de Datos y Algoritmos II                                    |
| Fundamentos de Redes de Computadores                                   |
| Planificación y Gestión de Proyectos Informáticos                      |
| Programación de Servicios Software                                     |
| Desarrollo de interfaces de usuario                                    |
| Ingeniería de Requisitos                                               |
| Integración de las Tecnologías de la Información en las Organizaciones |
| Modelado y Diseño del Software 1                                       |
| Multiprocesadores                                                      |
| Seguridad y cumplimiento normativo                                     |
| Sistema de Información para las Organizaciones                         |
| Tecnologías web                                                        |
| Teoría de códigos y criptografía                                       |
| Administración de bases de datos                                       |
| Herramientas y Métodos de Ingeniería del Software                      |
| Informática industrial y robótica                                      |
| Ingeniería de Sistemas de Información                                  |
| Modelado y Diseño del Software 2                                       |
| Negocio Electrónico                                                    |
| Periféricos e interfaces                                               |
| Sistemas de tiempo real                                                |
| Tecnologías de acceso a red                                            |
| Tratamiento digital de imágenes                                        |
| Administración de redes y sistemas operativos                          |
| Almacenes de Datos                                                     |
| Fiabilidad y Gestión de Riesgos                                        |
| Líneas de Productos Software                                           | 
| Procesos de Ingeniería del Software 1                                  |
| Tecnologías multimedia                                                 |
| Análisis y planificación de las TI                                     |
| Desarrollo Rápido de Aplicaciones                                      |
| Gestión de la Calidad y de la Innovación Tecnológica                   |
| Inteligencia del Negocio                                               |
| Procesos de Ingeniería del Software 2                                  |
| Seguridad Informática                                                  |
+------------------------------------------------------------------------+
(51 rows)
```

<p> 3. Devuelve un listado de los profesores junto con el nombre del departamento al que están vinculados. El listado debe devolver cuatro columnas, primer apellido, segundo apellido, nombre y nombre del departamento. El resultado estará ordenado alfabéticamente de menor a mayor por los apellidos y el nombre.</p>

```sql
SELECT p.apellido1, p.apellido2, p.nombre, d.nombre AS departamento
FROM profesor p
JOIN departamento d ON p.id_departamento = d.id
ORDER BY p.apellido1 ASC, p.apellido2 ASC, p.nombre ASC;

+------------+------------+-----------+--------------------+
| apellido1  | apellido2  |  nombre   |    departamento    |  
+------------+------------+-----------+--------------------+
| Domínguez  | Hernández  | María     | Matemáticas        |
| Fahey      | Considine  | Antonio   | Economía y Empresa |
| Guerrero   | Martínez   | Juan      | Informática        |
| Hamill     | Kozey      | Manolo    | Informática        |
| Kohler     | Schoen     | Alejandro | Matemáticas        |
| Lemke      | Rutherford | Cristina  | Economía y Empresa |
| Monahan    | Murray     | Micaela   | Agronomía          |
| Ramirez    | Gea        | Zoe       | Informática        |
| Ruecker    | Upton      | Guillermo | Educación          |
| Sánchez    | Ruiz       | Pepe      | Informática        |
| Schmidt    | Fisher     | David     | Matemáticas        |
| Schowalter | Muller     | Francesca | Química y Física   |
| Spencer    | Lakin      | Esther    | Educación          |
| Stiedemann | Morissette | Alfredo   | Química y Física   |
| Streich    | Hirthe     | Carmen    | Educación          |
+------------+------------+-----------+--------------------+
(15 rows)
```

<p> 4. Devuelve un listado con el nombre de las asignaturas, año de inicio y año de fin del curso escolar del alumno con nif 26902806M.</p>

```sql
SELECT asig.nombre, ce.anyo_inicio, ce.anyo_fin
FROM alumno a
JOIN alumno_se_matricula_asignatura am ON a.id = am.id_alumno
JOIN asignatura asig ON am.id_asignatura = asig.id
JOIN curso_escolar ce ON am.id_curso_escolar = ce.id
WHERE a.nif = '26902806M';

+--------------------------------------+-------------+----------+
|               nombre                 | anyo_inicio | anyo_fin |
+--------------------------------------+-------------+----------+
| Álgegra lineal y matemática discreta |        2014 |     2015 |
| Cálculo                              |        2014 |     2015 |
| Física para informática              |        2014 |     2015 |
+--------------------------------------+-------------+----------+
(3 rows)
```

<p> 5. Devuelve un listado con el nombre de todos los departamentos que tienen profesores que imparten alguna asignatura en el Grado en Ingeniería Informática (Plan 2015).</p>

```sql
SELECT DISTINCT d.nombre
FROM departamento d
JOIN profesor p ON d.id = p.id_departamento
JOIN asignatura asig ON p.id_profesor = asig.id_profesor
JOIN grado g ON asig.id_grado = g.id
WHERE g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

+-------------+
|   nombre    |
+-------------+
| Informática |
+-------------+
(1 row)
```

<p> 6. Devuelve un listado con todos los alumnos que se han matriculado en alguna asignatura durante el curso escolar 2018/2019.</p>

```sql
SELECT DISTINCT a.nombre, a.apellido1, a.apellido2
FROM alumno a
JOIN alumno_se_matricula_asignatura am ON a.id = am.id_alumno
JOIN curso_escolar ce ON am.id_curso_escolar = ce.id
WHERE ce.anyo_inicio = 2018 AND ce.anyo_fin = 2019;

+--------+-----------+-----------+
| nombre | apellido1 | apellido2 |
+--------+-----------+-----------+
(0 rows)
```
