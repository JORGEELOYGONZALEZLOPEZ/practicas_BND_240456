# Práctica 04: simulación de compra

## Contenido

- `00_preparar_base.sql`: migración aditiva y datos de catálogo que faltan.
- `01_caso_1_compra_exitosa.sql`: registro, cinco productos, débito, pago y entrega.
- `02_caso_2_ultimo_pago_rechazado.sql`: diez productos, seis pagos, rechazo final, reclamación y reenvío.
- `03_caso_3_cancelacion_y_reembolso.sql`: tres productos de una categoría, cancelación y reembolso parcial.
- `04_caso_4_recoleccion.sql`: tres productos, intento de entrega fallido y recolección.
- `05_caso_5_sin_inventario.sql`: pedido sin stock y liberación del cupón.
- `99_verificar_resultados.sql`: consultas para revisar lo ejecutado.

## Orden de ejecución

1. Restaura `Practica-04/Backups/Respaldo20261113.sql` en una instancia de pruebas MySQL 8.
2. Ejecuta una sola vez `00_preparar_base.sql` conectado a `db_test_7b`.
3. Ejecuta los casos `01` a `05`. Cada archivo genera usuarios, vendedor y datos nuevos de prueba.
4. Ejecuta `99_verificar_resultados.sql`.

Los archivos de esta carpeta se ejecutan en MySQL Workbench, seleccionando el esquema `db_test_7b` y usando **Execute SQL Script**. Requieren una cuenta administradora: los scripts crean usuarios de aplicación y registros simulados.

## Decisiones de simulación

- Se respeta el caso 2 literalmente: se entrega el pedido aunque el sexto pago quede rechazado.
- En el caso 3 se guarda Spin como método del usuario, pero el cobro se registra como `Cash`, que es el medio indicado en el paso de pago.
- En el caso 4 se guarda SPEI como método del usuario, pero el cobro se registra como `Cash`, que es el medio indicado en el paso de pago.
- La migración agrega `buyer_ID` a `tb_buyer_orders`, campos de parcialidades/fallo a `tb_payments`, punto de recolección a `tb_shipments` y tablas de cupones.
- También corrige el registro de transacciones para que el rechazo guarde su motivo y un reembolso parcial guarde el importe reembolsado.
- Los datos de tarjeta son ficticios. Solo se conserva `last_four`; nunca se almacena el número completo.
- El caso 5 restaura el stock del producto al terminar la simulación.

## Precauciones

- Ejecuta todo únicamente en una copia de pruebas, no en producción.
- `00_preparar_base.sql` es una migración de una sola ejecución sobre el respaldo original. No la vuelvas a ejecutar sobre una base ya migrada.
- Los casos 1 a 4 descuentan inventario y los datos generados permanecen en la base. Si vuelves a correrlos, crean nuevas compras.
- `remote_users_privileges_creation.sql` elimina y recrea cuentas MySQL existentes. No es necesario para ejecutar estos casos con una cuenta administradora; si lo utilizas para practicar roles, hazlo solo en una instancia desechable y cambia las contraseñas de ejemplo.
- La base no implementa aislamiento por comprador en sus privilegios MySQL. Estos scripts son una simulación administrativa, no una API de comercio lista para producción.
