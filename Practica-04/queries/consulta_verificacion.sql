USE db_test_7b;

-- 1. Cuantas tablas existen en la base de datos db_test_7b?
SHOW TABLES;
-- 1. caso 1 completo 
SELECT * FROM vw_practica04_caso_1 ORDER BY fecha_evento;

-- Consultar la vista del Caso 2 igual que en tu imagen de referencia:
SELECT * FROM vw_practica04_caso_2 ORDER BY fecha_evento;