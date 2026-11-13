# Schema Atlas · Explorador EER

Visor local del esquema MySQL de `../backups/Respaldo_20261015.sql`. El archivo se analiza en el navegador; **no se ejecutan sus sentencias** ni se realiza conexión a una base de datos.

## Abrir

Desde `Practica-03`, inicia un servidor HTTP estático, por ejemplo:

```powershell
python -m http.server 8000
```

Abre `http://localhost:8000/eer/`. El visor intenta cargar inicialmente `backups/Respaldo_20261015.sql`. Si el navegador bloquea la carga local, usa **Abrir SQL** y selecciona el archivo del respaldo. No requiere paquetes ni instalación.

También puedes abrir `index.html` directamente y cargar el respaldo manualmente. La carga automática requiere HTTP por las restricciones de seguridad del navegador.

## Uso

- Arrastra las tarjetas para reorganizar el esquema. Arrastra el fondo para desplazarte y usa la rueda o los botones para acercar y alejar.
- Usa **Ajustar** para encuadrar el diagrama y **Restablecer** para recuperar su distribución inicial.
- Busca tablas, columnas y tipos de datos desde la barra global. Selecciona una tabla para abrir el inspector; sus pestañas muestran columnas, relaciones, índices y DDL.
- **Resumen JSON** descarga el inventario analizado. **Exportar SVG** exporta el diagrama.
- **Actualizar conteos** comunica que no hay una conexión configurada; no realiza una conexión implícita.

## Conteos y fidelidad

La tarjeta muestra filas `INSERT` encontradas en el dump, no el conteo actual de una instancia MySQL. El panel separa ambos valores y marca el conteo actual como no disponible. El conteo del respaldo es una lectura sintáctica de las filas insertadas; no contempla sentencias `UPDATE`, `DELETE`, triggers ejecutados, ni el estado posterior de una base conectada. Las tablas incluidas en un bloque de datos sin filas `INSERT` se muestran con cero filas en ese respaldo.

Las relaciones se crean exclusivamente a partir de restricciones `FOREIGN KEY` analizadas; se conserva su tabla y columnas de destino, nulabilidad y unicidad cuando el esquema la declara. No se fabrican relaciones sugeridas. El analizador maneja identificadores entre backticks, cadenas, comentarios de MySQL, claves compuestas y delimitadores de rutinas. Revisa las advertencias del reporte cuando el dump contenga sintaxis u objetos que no pueda interpretar.

## Validación local

Con Node.js, ejecuta desde la raíz del repositorio:

```powershell
node Practica-03/eer/check-schema.cjs
```

El script analiza el dump del proyecto y muestra un resumen legible del esquema detectado.
