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

<p> 11. Devuelve un listado de todos los pedidos que fueron rechazados en 2009.</p>

```sql
SELECT codigo_pedido, fecha_pedido, codigo_cliente FROM pedido
WHERE estado = 'Rechazado' AND EXTRACT(YEAR FROM fecha_pedido) = 2009;

+---------------+--------------+----------------+
| codigo_pedido | fecha_pedido | codigo_cliente |
+---------------+--------------+----------------+
|            14 | 2009-01-02   |              7 |
|            21 | 2009-01-09   |              9 |
|            25 | 2009-02-02   |              1 |
|            26 | 2009-02-06   |              3 |
|            40 | 2009-03-09   |             19 |
|            46 | 2009-04-03   |             23 |
|            65 | 2009-02-02   |              1 |
|            66 | 2009-02-06   |              3 |
|            74 | 2009-01-14   |             15 |
|            81 | 2009-01-18   |             28 |
|           101 | 2009-03-07   |             16 |
|           105 | 2009-02-14   |             30 |
|           120 | 2009-03-07   |             16 |
|           125 | 2009-02-14   |             30 |
+---------------+--------------+----------------+
(14 rows)
```

<p> 12. Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de cualquier año.</p>

```sql
SELECT codigo_pedido, fecha_pedido, codigo_cliente from pedido where extract(month from fecha_pedido)='01';

+---------------+--------------+----------------+
| codigo_pedido | fecha_pedido | codigo_cliente |
+---------------+--------------+----------------+
|             1 | 2006-01-17   |              5 |
|             4 | 2009-01-20   |              5 |
|            10 | 2009-01-15   |              3 |
|            11 | 2009-01-20   |              1 |
|            12 | 2009-01-22   |              1 |
|            13 | 2009-01-12   |              7 |
|            14 | 2009-01-02   |              7 |
|            15 | 2009-01-09   |              7 |
|            16 | 2009-01-06   |              7 |
|            17 | 2009-01-08   |              7 |
|            18 | 2009-01-05   |              9 |
|            19 | 2009-01-18   |              9 |
|            20 | 2009-01-20   |              9 |
|            21 | 2009-01-09   |              9 |
|            22 | 2009-01-11   |              9 |
|            32 | 2007-01-07   |              4 |
|            54 | 2009-01-11   |             14 |
|            57 | 2009-01-05   |             13 |
|            58 | 2009-01-24   |              3 |
|            61 | 2009-01-15   |              3 |
|            62 | 2009-01-20   |              1 |
|            63 | 2009-01-22   |              1 |
|            64 | 2009-01-24   |              1 |
|            74 | 2009-01-14   |             15 |
|            75 | 2009-01-11   |             15 |
|            77 | 2009-01-03   |             15 |
|            79 | 2009-01-12   |             28 |
|            80 | 2009-01-25   |             28 |
|            81 | 2009-01-18   |             28 |
|            82 | 2009-01-20   |             28 |
|            83 | 2009-01-24   |             28 |
|            95 | 2008-01-04   |             35 |
|            98 | 2009-01-08   |             35 |
|           100 | 2009-01-10   |             16 |
|           103 | 2009-01-15   |             30 |
|           114 | 2009-01-15   |             36 |
|           119 | 2009-01-10   |             16 |
|           123 | 2009-01-15   |             30 |
+---------------+--------------+----------------+
(38 rows)
```

<p> 13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. Ordene el resultado de mayor a menor.</p>

```sql
SELECT codigo_cliente, total FROM pago WHERE EXTRACT(YEAR FROM fecha_pago) = 2008
AND forma_pago = 'Paypal' ORDER BY total DESC;

+----------------+-------+
| codigo_cliente | total |
+----------------+-------+
(0 rows)
```

<p> 14. Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en cuenta que no deben aparecer formas de pago repetidas.</p>

```sql
select distinct forma_pago from pago;

+---------------+
|  forma_pago   |
+---------------+
| Cheque        |
| Transferencia |
| PayPal        |
+---------------+
(3 rows)
```
<p> 15. Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más de 100 unidades en stock. El listado deberá estar ordenado por su precio de venta, mostrando en primer lugar los de mayor precio.</p>

```sql
SELECT nombre, cantidad_en_stock, precio_venta FROM producto  WHERE gama = 'Ornamentales'
AND cantidad_en_stock > 100 ORDER BY precio_venta DESC;

+----------------------------------------------+-------------------+--------------+
|                    nombre                    | cantidad_en_stock | precio_venta |
+----------------------------------------------+-------------------+--------------+
| Forsytia Intermedia \"Lynwood\"              |               120 |         7.00 |
| Hibiscus Syriacus  \"Diana\" -Blanco Puro    |               120 |         7.00 |
| Hibiscus Syriacus  \"Helene\" -Blanco-C.rojo |               120 |         7.00 |
| Hibiscus Syriacus \"Pink Giant\" Rosa        |               120 |         7.00 |
| Prunus pisardii                              |               120 |         5.00 |
| Viburnum Tinus \"Eve Price\"                 |               120 |         5.00 |
| Weigelia \"Bristol Ruby\"                    |               120 |         5.00 |
| Escallonia (Mix)                             |               120 |         5.00 |
| Evonimus Emerald Gayeti                      |               120 |         5.00 |
| Evonimus Pulchellus                          |               120 |         5.00 |
| Lonicera Nitida                              |               120 |         5.00 |
| Laurus Nobilis Arbusto - Ramificado Bajo     |               120 |         5.00 |
| Lonicera Nitida \"Maigrum\"                  |               120 |         5.00 |
| Lonicera Pileata                             |               120 |         5.00 |
| Philadelphus \"Virginal\"                    |               120 |         5.00 |
+----------------------------------------------+-------------------+--------------+
(15 rows)

```
<p> 16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo representante de ventas tenga el código de empleado 11 o 30.</p>

```sql
select * from cliente where ciudad = 'Madrid' and (codigo_empleado_rep_ventas = '11'
or codigo_empleado_rep_ventas = '30');

+-----------------------------+-----------------+-----------+--------+----------------------------+
|       nombre_cliente        | nombre_contacto | telefono  | ciudad | codigo_empleado_rep_ventas | 
+-----------------------------+-----------------+-----------+--------+----------------------------+
| Beragua                     | Jose            | 654987321 | Madrid |                         11 |
| Club Golf Puerta del hierro | Paco            | 62456810  | Madrid |                         11 |
| Naturagua                   | Guillermo       | 689234750 | Madrid |                         11 |
| DaraDistribuciones          | David           | 675598001 | Madrid |                         11 |
| Madrileña de riegos         | Jose            | 655983045 | Madrid |                         11 |
| Jardin de Flores            | Javier          | 654865643 | Madrid |                         30 |
| Naturajardin                | Victoria        | 612343529 | Madrid |                         30 |
+-----------------------------+-----------------+-----------+--------+----------------------------+
(7 rows)
```
