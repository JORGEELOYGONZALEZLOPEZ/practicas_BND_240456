/* ============================================================
   CREACIÓN DE USUARIOS REMOTOS
   ============================================================ */

/* Eliminar usuarios si ya existen */
DROP USER IF EXISTS 'marco.ramirez'@'%';
DROP USER IF EXISTS 'jorge.gonzalez'@'%';
DROP USER IF EXISTS 'osmar.ortega'@'%';
DROP USER IF EXISTS 'obed.vargas'@'%';
DROP USER IF EXISTS 'dorian.barrios'@'%';
DROP USER IF EXISTS 'app_web'@'%';
DROP USER IF EXISTS 'app_mobile'@'%';

/* Crear usuarios remotos */
CREATE USER IF NOT EXISTS 'marco.ramirez'@'%' IDENTIFIED BY 'qwerty123';
CREATE USER IF NOT EXISTS 'jorge.gonzalez'@'%' IDENTIFIED BY '240456';
CREATE USER IF NOT EXISTS 'osmar.ortega'@'%' IDENTIFIED BY '240036';
CREATE USER IF NOT EXISTS 'dorian.barrios'@'%' IDENTIFIED BY '240065';
CREATE USER IF NOT EXISTS 'obed.vargas'@'%' IDENTIFIED BY '240145';

/* Users Middleware */
CREATE USER IF NOT EXISTS 'app_web'@'%' IDENTIFIED BY 'web123';
CREATE USER IF NOT EXISTS 'app_mobile'@'%' IDENTIFIED BY 'mobile890';


/* ============================================================
   CREACIÓN DE ROLES PARA EL SISTEMA ECOMMERCE
   ============================================================ */

/* Eliminar roles si ya existen */
DROP ROLE IF EXISTS 'superadmin';
DROP ROLE IF EXISTS 'admin';
DROP ROLE IF EXISTS 'seller';
DROP ROLE IF EXISTS 'buyer';
DROP ROLE IF EXISTS 'support';
DROP ROLE IF EXISTS 'common';
DROP ROLE IF EXISTS 'user_not_registered';

/* Crear roles */
CREATE ROLE IF NOT EXISTS 'superadmin';
CREATE ROLE IF NOT EXISTS 'admin';
CREATE ROLE IF NOT EXISTS 'seller';
CREATE ROLE IF NOT EXISTS 'buyer';
CREATE ROLE IF NOT EXISTS 'support';
CREATE ROLE IF NOT EXISTS 'common';
CREATE ROLE IF NOT EXISTS 'user_not_registered';


/* ============================================================
   ASIGNAR PRIVILEGIOS A LOS ROLES
   ============================================================ */

/* SUPERADMIN */
GRANT ALL PRIVILEGES
ON *.*
TO 'superadmin';

/* ADMIN */
GRANT ALL PRIVILEGES 
ON db_test_7b.* 
TO 'admin';

/* SELLER */
GRANT SELECT, INSERT, UPDATE, DELETE
ON db_test_7b.tb_products
TO 'seller';

/* BUYER */

/* SUPPORT */
GRANT SELECT, UPDATE 
ON db_test_7b.* 
TO 'support';

GRANT INSERT
ON db_test_7b.tbc_categories TO 'support';

GRANT INSERT
ON db_test_7b.tb_users TO 'support';

GRANT INSERT 
ON db_test_7b.tb_products TO 'support';

/* COMMON */
GRANT SELECT 
ON db_test_7b.* 
TO 'common';

/* USER NOT REGISTERED */
GRANT INSERT
ON db_test_7b.tb_users
TO 'user_not_registered';

GRANT INSERT
ON db_test_7b.tb_people
TO 'user_not_registered';

GRANT EXECUTE ON
PROCEDURE db_test_7b.sp_register_new_user
TO 'user_not_registered';


/* ============================================================
   ASIGNAR ROLES A LOS USUARIOS
   ============================================================ */

/* Jorge = superadmin */
GRANT 'superadmin' 
TO 'jorge.gonzalez'@'%';

/* MARCO = ADMIN */
GRANT 'admin' 
TO 'marco.ramirez'@'%';

/* OBED = SUPPORT */
GRANT 'support' 
TO 'obed.vargas'@'%';

/* OSMAR = SELLER */
GRANT 'seller' 
TO 'osmar.ortega'@'%';

/* DORIAN = SELLER */
GRANT 'seller' 
TO 'dorian.barrios'@'%';

/* ASIGNAR ROLES A LAS CREDENCIALES DE LA CONEXION PARA LAS APPS */
GRANT 'user_not_registered' 
TO 'app_web'@'%';

GRANT 'user_not_registered' 
TO 'app_mobile'@'%';


/* ============================================================
   ESTABLECER ROLES POR DEFECTO
   ============================================================ */

SET DEFAULT ROLE 'superadmin' 
TO 'jorge.gonzalez'@'%';

SET DEFAULT ROLE 'admin' 
TO 'marco.ramirez'@'%';

SET DEFAULT ROLE 'support' 
TO 'obed.vargas'@'%';

SET DEFAULT ROLE 'seller' 
TO 'osmar.ortega'@'%';

SET DEFAULT ROLE 'seller' 
TO 'dorian.barrios'@'%';

SET DEFAULT ROLE 'user_not_registered'
TO 'app_web'@'%';

SET DEFAULT ROLE 'user_not_registered'
TO 'app_mobile'@'%';


/* ============================================================
   ACTUALIZAR PRIVILEGIOS Y CONFIRMACIÓN
   ============================================================ */

FLUSH PRIVILEGES;

SELECT "Los usuarios y roles han sido creados correctamente" AS mensaje;