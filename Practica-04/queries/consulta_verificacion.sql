USE db_test_7b;

-- 1. Cuantas tablas existen en la base de datos db_test_7b?
SHOW TABLES;
-- =========================================================================
-- CONSULTAS DE VERIFICACIÓN Y AUDITORÍA - PRÁCTICA 04 (db_test_7b)
-- =========================================================================

-- 1. Vista consolidada: muestra el resumen general de eventos, usuario ejecutor y rango de fechas por caso
SELECT * FROM vw_practica04_resumen;

-- 2. Caso de Prueba 1: Compra Exitosa, sin modificaciones (Ejecutor: app_web)
SELECT * FROM vw_practica04_caso_1 ORDER BY fecha_evento;

-- 3. Caso de Prueba 2: Compra con detalles en el último pago y con reclamación y reenvío (Ejecutor: jorge.gonzalez / superadmin)
SELECT * FROM vw_practica04_caso_2 ORDER BY fecha_evento;

-- 4. Caso de Prueba 3: Compra exitosa con cancelación parcial, ajuste y reembolso parcial (Ejecutor: jorge.gonzalez / superadmin)
SELECT * FROM vw_practica04_caso_3 ORDER BY fecha_evento;

-- 5. Caso de Prueba 4: Compra exitosa del mismo proveedor con entrega en el punto de recolección (Ejecutor: jorge.gonzalez / superadmin)
SELECT * FROM vw_practica04_caso_4 ORDER BY fecha_evento;

-- 6. Caso de Prueba 5: Compra fallida por falta de inventario (Ejecutor: jorge.gonzalez / superadmin)
SELECT * FROM vw_practica04_caso_5 ORDER BY fecha_evento;