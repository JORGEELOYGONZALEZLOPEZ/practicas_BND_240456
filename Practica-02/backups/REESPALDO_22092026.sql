CREATE DATABASE  IF NOT EXISTS `db_test_7b` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_test_7b`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: db_test_7b
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tb_logs`
--

DROP TABLE IF EXISTS `tb_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_logs` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `table_name` varchar(80) NOT NULL,
  `table_operation` enum('create','Read','update','Delete') DEFAULT NULL,
  `db_user` varchar(80) NOT NULL,
  `operation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `operation_description` text NOT NULL,
  `operation_status` bit(1) DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_logs`
--

LOCK TABLES `tb_logs` WRITE;
/*!40000 ALTER TABLE `tb_logs` DISABLE KEYS */;
INSERT INTO `tb_logs` VALUES (1,'tb_users','create','root@localhost','2026-09-17 11:02:42','Nuevo usuario registrado ID: 13 - Nick: osmarortega',_binary ''),(2,'tb_users','create','root@localhost','2026-09-17 11:04:30','Nuevo usuario registrado ID: 14 - Nick: obedvargas',_binary ''),(3,'tb_users','create','root@localhost','2026-09-17 11:04:56','Nuevo usuario registrado ID: 15 - Nick: yanetgarrido',_binary ''),(4,'tb_users','update','root@localhost','2026-09-17 11:10:36','Usuario actualizado. ID=13 -> Nuevo email=osmar.ortega@email.com, Nuevo nick=osmar, last_update=2026-09-17 11:10:36',_binary ''),(5,'tb_users','update','root@localhost','2026-09-17 11:11:18','Usuario actualizado. ID=13 -> Nuevo email=osmar.ortega@email.com, Nuevo nick=osmar, last_update=2026-09-17 11:11:18',_binary ''),(6,'tb_users','Delete','root@localhost','2026-09-17 11:11:18','Usuario eliminado ID: 15 - Nick: yanetgarrido',_binary ''),(7,'tb_products','create','root@localhost','2026-09-17 11:18:53','Producto creado ID: 1 - SKU: PROD-001 - Nombre: Laptop Gaming',_binary ''),(8,'tb_products','create','root@localhost','2026-09-17 11:32:08','Producto creado ID: 2 - SKU: PROD-002 - Nombre: SOPORTE LAPTOP',_binary ''),(9,'tb_products','create','root@localhost','2026-09-17 13:22:54','Producto creado ID: 3 - SKU: PROD-003 - Nombre: Audífonos Bluetooth',_binary ''),(10,'tb_products','create','root@localhost','2026-09-17 13:22:54','Producto creado ID: 4 - SKU: PROD-004 - Nombre: Teclado Mecánico',_binary ''),(11,'tb_products','create','root@localhost','2026-09-17 13:22:54','Producto creado ID: 5 - SKU: PROD-005 - Nombre: Mouse Gamer',_binary ''),(12,'tb_products','create','root@localhost','2026-09-17 13:22:54','Producto creado ID: 6 - SKU: PROD-006 - Nombre: Monitor 24 Pulgadas',_binary ''),(13,'tb_products','create','root@localhost','2026-09-17 13:22:54','Producto creado ID: 7 - SKU: PROD-007 - Nombre: Bocina Bluetooth',_binary ''),(14,'tb_users','create','osmar.ortega@PC-05','2026-09-17 13:29:06','Nuevo usuario registrado ID: 16 - Nick: gaelo1',_binary ''),(15,'tb_users','create','osmar.ortega@PC-05','2026-09-17 13:29:06','Nuevo usuario registrado ID: 17 - Nick: osmaro2',_binary ''),(16,'tb_products','update','root@localhost','2026-09-17 13:33:59','Producto modificado ID: 1 - Nombre: Laptop Gaming -> Laptop Gaming - Precio: $1250.00 -> $1250.00',_binary '\0'),(17,'tb_products','update','root@localhost','2026-09-17 13:34:39','Producto modificado ID: 1 - Nombre: Laptop Gaming -> Laptop Gaming - Precio: $1250.00 -> $1250.00',_binary ''),(18,'tb_products','create','osmar.ortega@PC-05','2026-09-17 13:36:43','Producto creado ID: 8 - SKU: PROD-008 - Nombre: Tablet Samsung Galaxy Tab',_binary ''),(19,'tb_products','create','osmar.ortega@PC-05','2026-09-17 13:36:43','Producto creado ID: 9 - SKU: PROD-009 - Nombre: Smartwatch Xiaomi',_binary ''),(20,'tb_products','create','osmar.ortega@PC-05','2026-09-17 13:36:43','Producto creado ID: 10 - SKU: PROD-010 - Nombre: Cámara Web HD',_binary ''),(21,'tb_products','create','osmar.ortega@PC-05','2026-09-17 13:36:43','Producto creado ID: 11 - SKU: PROD-011 - Nombre: Disco Duro Externo 1TB',_binary ''),(22,'tb_products','create','osmar.ortega@PC-05','2026-09-17 13:36:43','Producto creado ID: 12 - SKU: PROD-012 - Nombre: Cargador USB-C',_binary ''),(23,'tb_products','update','root@localhost','2026-09-17 13:37:55','Producto modificado ID: 1 - Nombre: Laptop Gaming -> Laptop Gaming - Precio: $1250.00 -> $1250.00',_binary '\0');
/*!40000 ALTER TABLE `tb_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_products`
--

DROP TABLE IF EXISTS `tb_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_products` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `SKU` varchar(50) NOT NULL,
  `name` varchar(250) NOT NULL,
  `description` text,
  `current_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `current_stock` int unsigned NOT NULL DEFAULT '0',
  `status` bit(1) DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SKU` (`SKU`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_products`
--

LOCK TABLES `tb_products` WRITE;
/*!40000 ALTER TABLE `tb_products` DISABLE KEYS */;
INSERT INTO `tb_products` VALUES (1,'PROD-001','Laptop Gaming','i7 16GB RAM',1250.00,10,_binary '\0','2026-09-17 11:18:53','2026-09-17 13:37:55'),(2,'PROD-002','SOPORTE LAPTOP','16 PULGADAS',120.00,20,_binary '','2026-09-17 11:32:08','2026-09-17 11:32:08'),(3,'PROD-003','Audífonos Bluetooth','Audífonos inalámbricos con conexión Bluetooth',850.00,20,_binary '','2026-09-17 13:22:54','2026-09-17 13:22:54'),(4,'PROD-004','Teclado Mecánico','Teclado mecánico para computadora',1200.00,15,_binary '','2026-09-17 13:22:54','2026-09-17 13:22:54'),(5,'PROD-005','Mouse Gamer','Mouse óptico para videojuegos',650.00,25,_binary '','2026-09-17 13:22:54','2026-09-17 13:22:54'),(6,'PROD-006','Monitor 24 Pulgadas','Monitor LED de 24 pulgadas para computadora',3200.00,12,_binary '','2026-09-17 13:22:54','2026-09-17 13:22:54'),(7,'PROD-007','Bocina Bluetooth','Bocina portátil inalámbrica con conexión Bluetooth',1100.00,18,_binary '','2026-09-17 13:22:54','2026-09-17 13:22:54'),(8,'PROD-008','Tablet Samsung Galaxy Tab','Tablet Samsung para uso escolar y entretenimiento',6800.00,15,_binary '','2026-09-17 13:36:43','2026-09-17 13:36:43'),(9,'PROD-009','Smartwatch Xiaomi','Reloj inteligente con monitoreo de actividad',1800.00,20,_binary '','2026-09-17 13:36:43','2026-09-17 13:36:43'),(10,'PROD-010','Cámara Web HD','Cámara web HD para videollamadas y clases virtuales',950.00,12,_binary '','2026-09-17 13:36:43','2026-09-17 13:36:43'),(11,'PROD-011','Disco Duro Externo 1TB','Disco duro externo de 1 TB para almacenamiento',1450.00,10,_binary '','2026-09-17 13:36:43','2026-09-17 13:36:43'),(12,'PROD-012','Cargador USB-C','Cargador rápido con conexión USB-C',450.00,30,_binary '','2026-09-17 13:36:43','2026-09-17 13:36:43');
/*!40000 ALTER TABLE `tb_products` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_products_after_insert` AFTER INSERT ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name, 
        table_operation, 
        db_user, 
        operation_date, 
        operation_description, 
        operation_status
    )
    VALUES (
        'tb_products', 
        'create', 
        USER(), 
        NOW(), 
        CONCAT('Producto creado ID: ', NEW.ID, ' - SKU: ', NEW.SKU, ' - Nombre: ', NEW.name), 
        NEW.status
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_products_after_update` AFTER UPDATE ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name, 
        table_operation, 
        db_user, 
        operation_date, 
        operation_description, 
        operation_status
    )
    VALUES (
        'tb_products', 
        'update', 
        USER(), 
        NOW(), 
        CONCAT('Producto modificado ID: ', NEW.ID, ' - Nombre: ', OLD.name, ' -> ', NEW.name, ' - Precio: $', OLD.current_price, ' -> $', NEW.current_price), 
        NEW.status
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_products_after_delete` AFTER DELETE ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name, 
        table_operation, 
        db_user, 
        operation_date, 
        operation_description, 
        operation_status
    )
    VALUES (
        'tb_products', 
        'Delete', 
        USER(), 
        NOW(), 
        CONCAT('Producto eliminado ID: ', OLD.ID, ' - SKU: ', OLD.SKU, ' - Nombre: ', OLD.name), 
        OLD.status
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_users`
--

DROP TABLE IF EXISTS `tb_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_users` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `nick` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `status` bit(1) DEFAULT b'1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nick` (`nick`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_users`
--

LOCK TABLES `tb_users` WRITE;
/*!40000 ALTER TABLE `tb_users` DISABLE KEYS */;
INSERT INTO `tb_users` VALUES (4,'240456@utxicotepec.edu.mx','Alumno-JorgeEloyGonLop','ea3af61554c1e19ec62ba6c8029ca257','2026-09-10 10:20:48',NULL,NULL,_binary ''),(6,'susu@utxicotepec.edu.mx','su','ea3af61554c1e19ec62ba6c8029ca257','2026-09-10 10:22:21',NULL,NULL,_binary ''),(7,'asusena@gmail.com','Susy','3fbe25fcdf9d2cfc835ce09a9b9e382c','2026-09-10 10:24:18',NULL,NULL,_binary ''),(8,'samo@manor.com','same','85d068bd10c2f41173ad19e23e2ba3d1','2026-09-10 11:59:08',NULL,NULL,_binary ''),(9,'naib.subedar@manor.com','Naib','c311bf168705c9d827ea8c188d356e21','2026-09-10 12:35:11',NULL,NULL,_binary ''),(10,'aesop.carl@manor.com','Aesop','85d068bd10c2f41173ad19e23e2ba3d1','2026-09-10 12:35:18',NULL,NULL,_binary ''),(13,'osmar.ortega@email.com','osmar','secret123','2026-09-17 11:02:42','2026-09-17 11:11:18',NULL,_binary ''),(14,'obed.vargas@email.com','obedvargas','secret123','2026-09-17 11:04:30',NULL,NULL,_binary ''),(16,'gaelo@gmail.com','gaelo1','123456','2026-09-17 13:29:06','2026-09-17 13:29:06',NULL,_binary ''),(17,'osmaro@gmail.com','osmaro2','123456','2026-09-17 13:29:06','2026-09-17 13:29:06',NULL,_binary '');
/*!40000 ALTER TABLE `tb_users` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_users_after_insert` AFTER INSERT ON `tb_users` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name, 
        table_operation, 
        db_user, 
        operation_date, 
        operation_description, 
        operation_status
    )
    VALUES (
        'tb_users', 
        'create', 
        USER(), 
        NOW(), 
        CONCAT('Nuevo usuario registrado ID: ', NEW.ID, ' - Nick: ', NEW.nick), 
        NEW.status
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_users_after_update` AFTER UPDATE ON `tb_users` FOR EACH ROW BEGIN
    INSERT INTO tb_logs(
        table_name,
        table_operation,
        db_user,
        operation_description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_users',
        'update',
        USER(),
        CONCAT(
            'Usuario actualizado. ID=', OLD.ID,
            ' -> Nuevo email=', NEW.email,
            ', Nuevo nick=', NEW.nick,
            ', last_update=', IFNULL(NEW.last_update, 'NULL')
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_users_after_delete` AFTER DELETE ON `tb_users` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name, 
        table_operation, 
        db_user, 
        operation_date, 
        operation_description, 
        operation_status
    )
    VALUES (
        'tb_users', 
        'Delete', 
        USER(), 
        NOW(), 
        CONCAT('Usuario eliminado ID: ', OLD.ID, ' - Nick: ', OLD.nick), 
        OLD.status
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'db_test_7b'
--

--
-- Dumping routines for database 'db_test_7b'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_restore_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_restore_product`(
    IN p_product_id INT UNSIGNED
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM tb_products
        WHERE ID = p_product_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El producto especificado no existe';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM tb_products
        WHERE ID = p_product_id
          AND status = b'1'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El producto ya se encuentra activo';
    END IF;

    UPDATE tb_products
    SET status = b'1'
    WHERE ID = p_product_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_soft_delete_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_soft_delete_product`(
    IN p_product_id INT UNSIGNED
)
BEGIN

    /* Validar que el producto exista */
    IF NOT EXISTS (
        SELECT 1
        FROM tb_products
        WHERE ID = p_product_id
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El producto especificado no existe';
    END IF;

    /* Validar que el producto no esté eliminado */
    IF EXISTS (
        SELECT 1
        FROM tb_products
        WHERE ID = p_product_id
            AND status = b'0'
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El producto ya se encuentra eliminado';
    END IF;

    /* Soft Delete */
    UPDATE tb_products
    SET status = b'0'
    WHERE ID = p_product_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-22  9:07:08
