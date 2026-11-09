# Schema Atlas · Explorador EER

Visor local e interactivo para `db_test_7b`, precargado desde `Respaldo20261108.sql`. No instala dependencias ni ejecuta SQL en una base de datos.

## Uso

Abre `index.html` en un navegador moderno. El esquema precargado funciona sin servidor; **Abrir SQL** analiza otro respaldo localmente. Arrastra tablas, usa la rueda para zoom, arrastra el fondo para desplazar y elige **Ajustar** para encuadrar el diagrama. Haz clic en una tabla o columna para abrir el inspector. **Resumen JSON** exporta el inventario y **Exportar SVG** genera el diagrama.

Las tarjetas muestran conteos al corte. `tb_logs` usa el valor actual indicado de 1,407; su respaldo contiene más filas históricas y declara `AUTO_INCREMENT=5353`. Para el resto, el conteo se calcula a partir de filas INSERT del respaldo. No hay conexión en vivo a MySQL.

El dump define 25 tablas, 34 relaciones de clave foránea y 73 triggers. Los destinos `tb_carts_log` y `tb_cancellations_log` son referenciados desde triggers, pero no tienen definición `CREATE TABLE` en este archivo y por eso no se presentan como entidades declaradas.
