/* ============================================================
   CREACIÓN DE USUARIOS REMOTOS
   ============================================================ */

/* Eliminar usuarios si ya existen */
DROP USER IF EXISTS 'marco.ramirez'@'%';
DROP USER IF EXISTS 'jorge.gonzalez'@'%';
DROP USER IF EXISTS 'osmar.ortega'@'%';
DROP USER IF EXISTS 'obed.vargas'@'%';

/* Crear usuarios */
CREATE USER 'marco.ramirez'@'%' IDENTIFIED BY 'qwerty123';
CREATE USER 'jorge.gonzalez'@'%' IDENTIFIED BY '240456';
CREATE USER 'osmar.ortega'@'%' IDENTIFIED BY '240036';
CREATE USER 'dorian.barrios'@'%' IDENTIFIED BY '240065';
CREATE USER 'obed.vargas'@'%' IDENTIFIED BY '240145';


/* ============================================================
   ASIGNAR PRIVILEGIOS DE SUPER USUARIO
   ============================================================ */

GRANT ALL PRIVILEGES ON *.* 
TO 'jorge.gonzalez'@'%';


/* ============================================================
   PRIVILEGIOS DE SELECCIÓN, INSERCIÓN, ACTUALIZACIÓN Y
   ELIMINACIÓN
   ============================================================ */

GRANT SELECT, INSERT, UPDATE, DELETE 
ON db_test_7b.* 
TO 'osmar.ortega'@'%';


/* ============================================================
   CREACIÓN DE ROLES PARA EL SISTEMA ECOMMERCE
   ============================================================ */

/* Eliminar roles si ya existen */

DROP ROLE IF EXISTS 'admin';
DROP ROLE IF EXISTS 'seller';
DROP ROLE IF EXISTS 'buyer';
DROP ROLE IF EXISTS 'support';
DROP ROLE IF EXISTS 'common';
DROP ROLE IF EXISTS 'user_not_registered';

/* Crear roles */
CREATE ROLE IF NOT EXISTS 'superadmin';
CREATE ROLE 'admin';
CREATE ROLE 'seller';
CREATE ROLE 'buyer';
CREATE ROLE 'support';
CREATE ROLE 'common';
CREATE ROLE 'user_not_registered';


/* ============================================================
   ASIGNAR PRIVILEGIOS A LOS ROLES
   ============================================================ */

/* SUPERADMIN*/
GRANT ALL PRIVILEGES
ON db_test_7b.*
TO 'superadmin';


/* ADMIN */
GRANT ALL PRIVILEGES 
ON db_test_7b.* 
TO 'admin';


/* SELLER */
GRANT SELECT, INSERT, UPDATE, DELETE 
ON db_test_7b.* 
TO 'seller';


/* BUYER */
GRANT SELECT, INSERT 
ON db_test_7b.* 
TO 'buyer';


/* SUPPORT */
GRANT SELECT, INSERT, UPDATE 
ON db_test_7b.* 
TO 'support';


/* COMMON */
GRANT SELECT 
ON db_test_7b.* 
TO 'common';


/* USER NOT REGISTERED */
GRANT SELECT 
ON db_test_7b.* 
TO 'user_not_registered';


/* ============================================================
   ASIGNAR ROLES A LOS USUARIOS
   ============================================================ */
/*Jorge = superadmin*/
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

GRANT 'seller' 
TO 'dorian.barrios'@'%';

/* PERMISOS ESPECÍFICOS PARA ROLES */
GRANT SELECT, INSERT, UPDATE ON db_test_7b.tb_users TO 'support';
GRANT SELECT, INSERT, UPDATE ON db_test_7b.tb_products TO 'support';

GRANT SELECT, INSERT, UPDATE, DELETE ON db_test_7b.tb_products TO 'seller';


/* ============================================================
   ESTABLECER ROLES POR DEFECTO
   ============================================================ */

SET DEFAULT ROLE 'admin' 
TO 'marco.ramirez'@'%';

SET DEFAULT ROLE 'support' 
TO 'obed.vargas'@'%';

SET DEFAULT ROLE 'seller' 
TO 'osmar.ortega'@'%';

SET DEFAULT ROLE 'seller' 
TO 'dorian.barrios'@'%';


/* ============================================================
   ACTUALIZAR PRIVILEGIOS
   ============================================================ */
SELECT "Los usuarios han sido creados correctamente" AS mensaje;

FLUSH PRIVILEGES;