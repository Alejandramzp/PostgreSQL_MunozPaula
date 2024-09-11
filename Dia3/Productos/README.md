<p align= "center"><img  width="20%" src= "https://upload.wikimedia.org/wikipedia/commons/2/29/Postgresql_elephant.svg">
<img  width="45%" src= "https://i.imgur.com/xNsz2Qs.jpeg"></p>

<h1 align= "center">🐛 Base de Datos de Productos 🐛</h1> 

<h2 align= "center">Consultas sobre una tabla</h2>

<p> 1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.</p>

```sql
SELECT codigo_oficina, ciudad from oficina;

+----------------+----------------------+
| codigo_oficina |        ciudad        |
+----------------+----------------------+
| BCN-ES         | Barcelona            |
| BOS-USA        | Boston               |
| LON-UK         | Londres              |
| MAD-ES         | Madrid               |
| PAR-FR         | Paris                |
| SFC-USA        | San Francisco        |
| SYD-AU         | Sydney               |
| TAL-ES         | Talavera de la Reina |
| TOK-JP         | Tokyo                |
+----------------+----------------------+
(9 rows)
```

<p> 2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España.</p>

```sql
SELECT ciudad,telefono from oficina where pais = 'España';

+----------------------+----------------+
|        ciudad        |     telefono   | 
+----------------------+----------------+
| Barcelona            | +34 93 3561182 |
| Madrid               | +34 91 7514487 |
| Talavera de la Reina | +34 925 867231 |
+----------------------+----------------+
(3 rows)
```

<p> 3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.</p>

```sql
SELECT nombre, apellido1, apellido2, email from empleado where codigo_jefe = '7';

+---------+-----------+-----------+--------------------------+
| nombre  | apellido1 | apellido2 |          email           |       
+---------+-----------+-----------+--------------------------+
| Mariano | López     | Murcia    | mlopez@jardineria.es     |
| Lucio   | Campoamor | Martín    | lcampoamor@jardineria.es |
| Hilario | Rodriguez | Huertas   | hrodriguez@jardineria.es |
+---------+-----------+-----------+--------------------------+
(3 rows)
```

<p> 4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa. </p>

```sql
SELECT puesto, nombre, apellido1, apellido2, email from empleado where codigo_jefe is null;

+------------------+--------+-----------+-----------+----------------------+
|      puesto      | nombre | apellido1 | apellido2 |        email         |
+------------------+--------+-----------+-----------+----------------------+
| Director General | Marcos | Magaña    | Perez     | marcos@jardineria.es |
+------------------+--------+-----------+-----------+----------------------+
(1 row)
```

<p> 5. Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.</p>

```sql
SELECT nombre, apellido1, apellido2, puesto from empleado where puesto != 'Representante Ventas';

+----------+------------+-----------+-----------------------+
|  nombre  | apellido1  | apellido2 |        puesto         |
+----------+------------+-----------+-----------------------+
| Marcos   | Magaña     | Perez     | Director General      |
| Ruben    | López      | Martinez  | Subdirector Marketing |
| Alberto  | Soria      | Carrasco  | Subdirector Ventas    |
| Maria    | Solís      | Jerez     | Secretaria            |
| Carlos   | Soria      | Jimenez   | Director Oficina      |
| Emmanuel | Magaña     | Perez     | Director Oficina      |
| Francois | Fignon     |           | Director Oficina      |
| Michael  | Bolton     |           | Director Oficina      |
| Hilary   | Washington |           | Director Oficina      |
| Nei      | Nishikori  |           | Director Oficina      |
| Amy      | Johnson    |           | Director Oficina      |
| Kevin    | Fallmer    |           | Director Oficina      |
+----------+------------+-----------+-----------------------+
(12 rows)
```

<p> 6. Devuelve un listado con el nombre de todos los clientes españoles.</p>

```sql
SELECT nombre_cliente from cliente where pais = 'Spain';

+--------------------------------+
|         nombre_cliente         |  
+--------------------------------+
| Lasas S.A.                     |
| Beragua                        |
| Club Golf Puerta del hierro    |
| Naturagua                      |
| DaraDistribuciones             |
| Madrileña de riegos            |
| Lasas S.A.                     |
| Camunas Jardines S.L.          |
| Dardena S.A.                   |
| Jardin de Flores               |
| Flores Marivi                  |
| Flowers, S.A                   |
| Naturajardin                   |
| Golf S.A.                      |
| Americh Golf Management SL     |
| Aloha                          |
| El Prat                        |
| Sotogrande                     |
| Vivero Humanes                 |
| Fuenla City                    |
| Jardines y Mansiones Cactus SL |
| Jardinerías Matías SL          |
| Agrojardin                     |
| Top Campo                      |
| Jardineria Sara                |
| Campohermoso                   |
| Flores S.L.                    |
+--------------------------------+
(27 rows)
```

<p> 7.Devuelve un listado con los distintos estados por los que puede pasar un pedido. </p>

```sql
SELECT distinct estado from pedido;

+-----------+
|  estado   |
+-----------+
| Entregado |
| Pendiente |
| Rechazado |
+-----------+
(3 rows)
```

<p> 8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008</p>
<p> -  EXTRACT de PostgreSQL </p>

```sql
SELECT distinct codigo_cliente from pago where EXTRACT(year from fecha_pago) = 2008;

+----------------+
| codigo_cliente | 
+----------------+
|              1 |
|             13 |
|             14 |
|             26 |
+----------------+
(4 rows)
```
<p> -  DATE_TRUNC de PostgreSQL  </p>

```sql
SELECT distinct codigo_cliente from pago where DATE_TRUNC('year', fecha_pago) = DATE '2008-01-01';

+----------------+
| codigo_cliente | 
+----------------+
|              1 |
|             13 |
|             14 |
|             26 |
+----------------+
(4 rows)
```
<p> -  Sin usar funciones específicas para obtener el año </p>

```sql
SELECT distinct codigo_cliente from pago where EXTRACT(year from fecha_pago) = 2008;

+----------------+
| codigo_cliente | 
+----------------+
|              1 |
|             13 |
|             14 |
|             26 |
+----------------+
(4 rows)
```

<p> 9. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo.</p>

```sql
Select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega from pedido where fecha_esperada < fecha_entrega;

+---------------+----------------+----------------+---------------+
| codigo_pedido | codigo_cliente | fecha_esperada | fecha_entrega |
+---------------+----------------+----------------+---------------+
|             9 |              1 | 2008-12-27     | 2008-12-28    |
|            13 |              7 | 2009-01-14     | 2009-01-15    |
|            16 |              7 | 2009-01-07     | 2009-01-15    |
|            17 |              7 | 2009-01-09     | 2009-01-11    |
|            18 |              9 | 2009-01-06     | 2009-01-07    |
|            22 |              9 | 2009-01-11     | 2009-01-13    |
|            28 |              3 | 2009-02-17     | 2009-02-20    |
|            31 |             13 | 2008-09-30     | 2008-10-04    |
|            32 |              4 | 2007-01-19     | 2007-01-27    |
|            38 |             19 | 2009-03-06     | 2009-03-07    |
|            39 |             19 | 2009-03-07     | 2009-03-09    |
|            40 |             19 | 2009-03-10     | 2009-03-13    |
|            42 |             19 | 2009-03-23     | 2009-03-27    |
|            43 |             23 | 2009-03-26     | 2009-03-28    |
|            44 |             23 | 2009-03-27     | 2009-03-30    |
|            45 |             23 | 2009-03-04     | 2009-03-07    |
|            46 |             23 | 2009-03-04     | 2009-03-05    |
|            49 |             26 | 2008-07-22     | 2008-07-30    |
|            55 |             14 | 2009-01-10     | 2009-01-11    |
|            60 |              1 | 2008-12-27     | 2008-12-28    |
|            68 |              3 | 2009-02-17     | 2009-02-20    |
|            92 |             27 | 2009-04-30     | 2009-05-03    |
|            96 |             35 | 2008-04-12     | 2008-04-13    |
|           103 |             30 | 2009-01-20     | 2009-01-24    |
|           106 |             30 | 2009-05-15     | 2009-05-20    |
|           112 |             36 | 2009-04-06     | 2009-05-07    |
|           113 |             36 | 2008-11-09     | 2009-01-09    |
|           114 |             36 | 2009-01-29     | 2009-01-31    |
|           115 |             36 | 2009-01-26     | 2009-02-27    |
|           123 |             30 | 2009-01-20     | 2009-01-24    |
|           126 |             30 | 2009-05-15     | 2009-05-20    |
|           128 |             38 | 2008-12-10     | 2008-12-29    |
+---------------+----------------+----------------+---------------+
(32 rows)
```

<p> 10. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.</p>

<p> - ADDDATE </p>

```sql
Select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
from pedido where fecha_entrega <= fecha_esperada - INTERVAL '2 days';

+---------------+----------------+----------------+---------------+
| codigo_pedido | codigo_cliente | fecha_esperada | fecha_entrega | 
+---------------+----------------+----------------+---------------+
|             2 |              5 | 2007-10-28     | 2007-10-26    |
|            24 |             14 | 2008-07-31     | 2008-07-25    |
|            30 |             13 | 2008-09-03     | 2008-08-31    |
|            36 |             14 | 2008-12-15     | 2008-12-10    |
|            53 |             13 | 2008-11-15     | 2008-11-09    |
|            89 |             35 | 2007-12-13     | 2007-12-10    |
|            91 |             27 | 2009-03-29     | 2009-03-27    |
|            93 |             27 | 2009-05-30     | 2009-05-17    |
+---------------+----------------+----------------+---------------+
(8 rows)
```
<p> -  DATEDIFF </p>

```sql
Select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
from pedido where (fecha_esperada - fecha_entrega) >=2;

+---------------+----------------+----------------+---------------+
| codigo_pedido | codigo_cliente | fecha_esperada | fecha_entrega | 
+---------------+----------------+----------------+---------------+
|             2 |              5 | 2007-10-28     | 2007-10-26    |
|            24 |             14 | 2008-07-31     | 2008-07-25    |
|            30 |             13 | 2008-09-03     | 2008-08-31    |
|            36 |             14 | 2008-12-15     | 2008-12-10    |
|            53 |             13 | 2008-11-15     | 2008-11-09    |
|            89 |             35 | 2007-12-13     | 2007-12-10    |
|            91 |             27 | 2009-03-29     | 2009-03-27    |
|            93 |             27 | 2009-05-30     | 2009-05-17    |
+---------------+----------------+----------------+---------------+
(8 rows)
```
