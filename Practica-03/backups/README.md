# Schema Atlas ? Explorador EER

Aplicacion local para analizar `Respaldo_20261015.sql` y otros dumps MySQL. No instala dependencias ni ejecuta sentencias contra una base de datos.

## Uso

1. Abre `index.html` en un navegador moderno. El esquema del respaldo incluido esta precargado para uso sin servidor.
2. Usa **Abrir SQL** para analizar otro archivo. El contenido se procesa localmente en el navegador.
3. Arrastra entidades; usa la rueda para zoom y el fondo para desplazar. **Ajustar**, **Restablecer**, pantalla completa, busqueda y filtros estan en la barra.
4. Selecciona una tabla o atributo para abrir el inspector. Las columnas largas se expanden desde la tarjeta.
5. Exporta el diagrama como SVG o el inventario completo como JSON.

## Conteos

Los valores de las tarjetas y el total son filas `INSERT` presentes en el respaldo. No se presenta ese dato como conteo actual de una base conectada. El conteo actual permanece **No disponible**, y el boton de actualizar lo indica porque no hay conexion configurada.

## Esquema precargado

Base `db_test_7b`: 8 tablas, 53 columnas, 8 relaciones FK confirmadas, 3 vistas y 10,441 filas insertadas. Las tablas que no tienen sentencias `INSERT` en el dump aparecen con 0 filas en el respaldo.
