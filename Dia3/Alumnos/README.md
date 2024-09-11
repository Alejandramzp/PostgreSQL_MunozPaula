<p align= "center"><img  width="20%" src= "https://upload.wikimedia.org/wikipedia/commons/2/29/Postgresql_elephant.svg">
<img  width="40%" src= "https://i.imgur.com/DLaHH38.jpeg"></p>



<h1 align= "center"> Base de Datos de Alumnos</h1> 

<h2 align= "center">Consultas sobre una tabla</h2>

<p>1. Devuelve un listado con el primer apellido, segundo apellido y el nombre de todos los alumnos. El listado deberá estar ordenado alfabéticamente de menor a mayor por el primer apellido, segundo apellido y nombre.</p>

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



<p> -  Sin usar funciones específicas para obtener el año </p>



