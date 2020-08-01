-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: proyectozeus
-- ------------------------------------------------------
-- Server version	8.0.19

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
-- Table structure for table `calificaciones`
--

DROP TABLE IF EXISTS `calificaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `calificaciones` (
  `idcalificaciones` int NOT NULL,
  `idUsuarioCalificador` int NOT NULL,
  `idUsuarioCalificado` int NOT NULL,
  `idPedido` int NOT NULL,
  `Nota` float NOT NULL,
  `Comentarios` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idcalificaciones`,`idUsuarioCalificador`,`idUsuarioCalificado`),
  UNIQUE KEY `idcalificaciones_UNIQUE` (`idcalificaciones`),
  KEY `fk_idPedido_idx` (`idPedido`),
  KEY `fk_idUsuario_idx` (`idUsuarioCalificado`),
  KEY `fk_idUsuario2_idx` (`idUsuarioCalificador`),
  CONSTRAINT `fk_idPedido` FOREIGN KEY (`idPedido`) REFERENCES `pedidos` (`idPedido`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calificaciones`
--

LOCK TABLES `calificaciones` WRITE;
/*!40000 ALTER TABLE `calificaciones` DISABLE KEYS */;
INSERT INTO `calificaciones` VALUES (1,2,19,2,8,'Buen Servicio'),(2,2,19,3,5,'Mal Servicio'),(3,2,16,1,9.5,'Excelente'),(4,2,19,4,9,'Excelente'),(5,2,19,4,7,'Mas o menos'),(6,2,19,2,6,'Meh'),(7,2,16,1,7.5,'Mas o menos'),(8,9,16,1,9.5,'Excelente'),(9,9,16,1,8.5,'Bueno');
/*!40000 ALTER TABLE `calificaciones` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `calificaciones_AFTER_INSERT` AFTER INSERT ON `calificaciones` FOR EACH ROW BEGIN
UPDATE viajeros
SET Calificacion =  (Select avg(nota) from proyectozeus.calificaciones
where idUsuarioCalificado = new.idUsuarioCalificado)
WHERE idUsuario = new.idUsuarioCalificado;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `calificaciones_view`
--

DROP TABLE IF EXISTS `calificaciones_view`;
/*!50001 DROP VIEW IF EXISTS `calificaciones_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `calificaciones_view` AS SELECT 
 1 AS `idCalificacion`,
 1 AS `UserCalificador`,
 1 AS `UserCalificado`,
 1 AS `idPedido`,
 1 AS `Nota`,
 1 AS `Comentarios`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `idPedido` int NOT NULL,
  `idUsuario` int NOT NULL,
  `idViajero` int NOT NULL,
  `idViaje` int NOT NULL,
  `Nombre del articulo` varchar(45) NOT NULL,
  `Estado del pedido` varchar(20) NOT NULL COMMENT '''Denegado'', ''Aceptado'', ''Pagado'', ''Entregado'', ''Anulado''',
  `Precio (USD)` decimal(12,2) NOT NULL,
  `Peso (lb)` double NOT NULL,
  `Categoria` varchar(45) NOT NULL,
  `Cantidad` int NOT NULL,
  `Otras especificaciones` varchar(45) DEFAULT NULL,
  `URL` varchar(650) NOT NULL,
  `Pais` varchar(45) NOT NULL,
  `Fecha estimada de entrega` date NOT NULL,
  `Total` decimal(12,2) NOT NULL,
  PRIMARY KEY (`idPedido`),
  UNIQUE KEY `idPedido_UNIQUE` (`idPedido`),
  KEY `fk_pedidos_usuarios1_idx` (`idUsuario`),
  KEY `fk_pedidos_viajesinfo1_idx` (`idViaje`),
  KEY `fk_pedidos_Viajeros2_idx` (`idViajero`),
  CONSTRAINT `fk_pedidos_usuarios1` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`idUsuario`) ON DELETE CASCADE,
  CONSTRAINT `fk_pedidos_Viajeros2` FOREIGN KEY (`idViajero`) REFERENCES `viajeros` (`idViajero`) ON DELETE CASCADE,
  CONSTRAINT `fk_pedidos_viajesinfo1` FOREIGN KEY (`idViaje`) REFERENCES `viajes` (`idviaje`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,2,4,1,'Reloj Bulova','Entregado',500.00,0.5,'Joyería Accesorios',1,'Negro','www.fossil.com','','2020-12-12',0.25),(2,10,5,2,'Zapatos adidas','Entregado',80.00,4,'Ropa y Calzado',2,'Blancos','www.adidas.com','Argentina','2021-04-04',176.00),(3,9,5,3,'Camisa Polo','Entregado',100.00,2,'Ropa y Calzado',1,'none','www.ralphlauren.com','Estados Unidos','2021-07-07',106.00),(4,10,5,2,'Lentes','Entregado',50.00,0.5,'Joyería y Accesorios',1,'none','www.lentes.com','Argentina','2021-07-07',52.00);
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `pedidos_AFTER_UPDATE` AFTER UPDATE ON `pedidos` FOR EACH ROW BEGIN
IF new.`Estado del pedido` = 'Entregado' THEN
UPDATE viajeros
set CantidadPedidos = CantidadPedidos +1
WHERE idViajero = new.idViajero;
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `solicitudes`
--

DROP TABLE IF EXISTS `solicitudes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `solicitudes` (
  `idSolicitud` int NOT NULL AUTO_INCREMENT,
  `Usuario` varchar(45) NOT NULL,
  `nombre_completo` varchar(150) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `contraseña` varchar(150) NOT NULL,
  `FechaNacimiento` date NOT NULL,
  `telefono` varchar(150) NOT NULL,
  `MotivosViaje` varchar(150) NOT NULL COMMENT '''Casual'', ''Negocios/Trabajo''',
  `FrecuenciaViaje` varchar(20) NOT NULL COMMENT '''Alta'', ''Intermedia'', ''Baja''',
  `EstadoSolicitud` varchar(30) NOT NULL COMMENT '''Denegada'', ''Pendiente'', ''Aprobada''',
  `pais` varchar(150) NOT NULL,
  `Foto` varchar(45) NOT NULL,
  PRIMARY KEY (`idSolicitud`),
  UNIQUE KEY `idSolicitud_UNIQUE` (`idSolicitud`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='IF (proyectozeus.solicitudes.EstadoSolicitud = ''Aprobada'') THEN END IF;';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solicitudes`
--

LOCK TABLES `solicitudes` WRITE;
/*!40000 ALTER TABLE `solicitudes` DISABLE KEYS */;
INSERT INTO `solicitudes` VALUES (1,'RM','Rodrigo','ro@gmail.com','rodrigo123','1999-01-01','78787878','Placer','Alta','Aprobada','El Salvador','imagen.jpg'),(2,'AS','Andrés','andres@hotmail.com','andres123','1999-01-01','77777777','Negocios','Alta','Aprobada','China','foto.jpg'),(3,'FE','Fernando','fer@gmail.com','fer123','1999-01-01','75757575','Negocios','Intermedia','Aprobada','Suecia','pic.jpg'),(4,'AA','Luis','luis@gmail.com','luis123','1999-01-01','67676767','Placer','Alta','Aprobada','Dinamarca','profilepic.jpg'),(5,'RAMR','Rodrigo M','ro-martinez11@hotmail.com','rodrigo124','2020-07-21','76082312','Placer','Alta','Aprobada','El Salvador','foto.jpg'),(6,'Hector54','Hector','hector@gmail.com','hector123','1989-06-06','76082312','Otro','Baja','Aprobada','El Salvador','hector.jpg'),(7,'Pollo87','Pollo M','pollo@hotmail.com','pollo123','1970-05-04','7969696','Otro','Intermedia','Denegada','Guatemala','pollo.png'),(8,'Davirr06','David Rivas','davidr@gmail.com','david123','1999-09-23','76757556','Negocios','Alta','Aprobada','El Salvador','david.jpg'),(9,'BichoCR7','El Bicho','CR7@hotmail.com','cristiano123','1985-02-05','76082312','Negocios','Alta','Aprobada','Portugal','cristiano.png'),(10,'Sol1','Solicitud 1','sol1@gmail.com','solicitud1','2020-07-25','76757556','Placer','Intermedia','Denegada','El Salvador','solicitud1.jpg'),(11,'request19','Request 2','requ2@hotmail.com','requ2','2020-07-07','76757556','Negocios','Alta','Aprobada','El Salvador','request2.jpg'),(12,'Adriantlson','Adrián Rodríguez','adirantl@gmail.com','adrian123','1989-06-07','76757556','Placer','Intermedia','Aprobada','El Salvador','Adrian.jpg'),(13,'lopez00','Diego López','lopez@hotmail.com','lopez123','2019-10-30','76757556','Placer','Intermedia','Denegada','El Salvador','lopez.jpg');
/*!40000 ALTER TABLE `solicitudes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `solicitudes_AFTER_UPDATE` AFTER UPDATE ON `solicitudes` FOR EACH ROW BEGIN
IF new.EstadoSolicitud = 'Aprobada' then
 INSERT INTO usuarios(idUsuario, Usuario, nombre_completo, correo, contraseña, FechaNacimiento, telefono, pais, idTipo, Foto)
 VALUES('0', new.Usuario, new.nombre_completo, new.correo, new.contraseña, new.FechaNacimiento, new.telefono, new.pais, '3', new.Foto);
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tipos de usuarios`
--

DROP TABLE IF EXISTS `tipos de usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos de usuarios` (
  `idTipo` int NOT NULL AUTO_INCREMENT,
  `Tipo de Usuario` varchar(45) NOT NULL,
  PRIMARY KEY (`idTipo`),
  UNIQUE KEY `idTipo_UNIQUE` (`idTipo`),
  UNIQUE KEY `Admin_UNIQUE` (`Tipo de Usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos de usuarios`
--

LOCK TABLES `tipos de usuarios` WRITE;
/*!40000 ALTER TABLE `tipos de usuarios` DISABLE KEYS */;
INSERT INTO `tipos de usuarios` VALUES (1,'Admin'),(2,'Cliente'),(3,'Viajero');
/*!40000 ALTER TABLE `tipos de usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `idUsuario` int NOT NULL AUTO_INCREMENT,
  `Usuario` varchar(45) NOT NULL,
  `nombre_completo` varchar(150) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `contraseña` varchar(150) NOT NULL,
  `FechaNacimiento` date NOT NULL,
  `telefono` varchar(150) NOT NULL,
  `pais` varchar(150) NOT NULL,
  `idTipo` int NOT NULL,
  `Foto` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idUsuario`),
  UNIQUE KEY `idUsuario_UNIQUE` (`idUsuario`),
  KEY `fk_usuarios_tipos de usuarios_idx` (`idTipo`),
  CONSTRAINT `fk_usuarios_tipos de usuarios` FOREIGN KEY (`idTipo`) REFERENCES `tipos de usuarios` (`idTipo`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'RodriM10','Rodrigo Martinez','ro-martinez11@hotmail.com','rodrigo123','1999-09-02','676574-456745','El Salvador',1,NULL),(2,'usuario','UsuarioEjemplo','usuario@gmail.com','user123','2000-01-01','25213412','Guatemala',2,NULL),(6,'e','e','e@gmail.com','asdas','1999-01-01','2131231','e',2,NULL),(9,'intento','Intento 1','rod@gmail.com','1232','2020-07-19','21412421','España',2,NULL),(10,'intento2','Intento 2','rodrigo@hotmail.com','12312','2020-07-08','21412421','España',2,NULL),(13,'RM','Rodrigo','ro@gmail.com','rodrigo123','1999-01-01','78787878','El Salvador',3,NULL),(14,'AA','Luis','luis@gmail.com','luis123','1999-01-01','67676767','Dinamarca',3,NULL),(15,'FE','Fernando','fer@gmail.com','fer123','1999-01-01','75757575','Suecia',3,NULL),(16,'AA','Luis','luis@gmail.com','luis123','1999-01-01','67676767','Dinamarca',3,NULL),(17,'aa','qqq','@ggg','al123','1999-01-01','252345','España',2,NULL),(19,'AS','Andrés','andres@hotmail.com','andres123','1999-01-01','77777777','China',3,'foto.jpg'),(21,'Hector54','Hector','hector@gmail.com','hector123','1989-06-06','76082312','El Salvador',3,'hector.jpg'),(22,'RAMR','Rodrigo M','ro-martinez11@hotmail.com','rodrigo124','2020-07-21','76082312','El Salvador',3,'foto.jpg'),(23,'Davirr06','David Rivas','davidr@gmail.com','david123','1999-09-23','76757556','El Salvador',3,'david.jpg'),(24,'BichoCR7','El Bicho','CR7@hotmail.com','cristiano123','1985-02-05','76082312','Portugal',3,'cristiano.png'),(25,'Pollo87','Pollo M','pollo@hotmail.com','pollo123','1970-05-04','7969696','Guatemala',3,'pollo.png');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `usuarios_AFTER_INSERT` AFTER INSERT ON `usuarios` FOR EACH ROW BEGIN
IF new.idTipo = '3' THEN
INSERT INTO viajeros(idViajero, idUsuario, Usuario, nombre_completo, correo, contraseña, telefono, pais, Foto)
 VALUES('0', new.idUsuario, new.Usuario, new.nombre_completo, new.correo, new.contraseña, new.telefono, new.pais, new.Foto);

END IF;
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `usuarios_BEFORE_DELETE` BEFORE DELETE ON `usuarios` FOR EACH ROW BEGIN
DELETE FROM proyectozeus.viajeros WHERE viajeros.idUsuario = old.idUsuario;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `viajeros`
--

DROP TABLE IF EXISTS `viajeros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `viajeros` (
  `idViajero` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NOT NULL,
  `Usuario` varchar(45) NOT NULL,
  `nombre_completo` varchar(100) NOT NULL,
  `CantidadViajes` int NOT NULL DEFAULT '0',
  `CantidadPedidos` int NOT NULL DEFAULT '0',
  `Calificacion` float NOT NULL DEFAULT '0',
  `correo` varchar(45) NOT NULL,
  `contraseña` varchar(45) NOT NULL,
  `telefono` varchar(45) NOT NULL,
  `pais` varchar(45) NOT NULL,
  `Foto` varchar(45) NOT NULL,
  PRIMARY KEY (`idViajero`,`idUsuario`),
  UNIQUE KEY `idViajero_UNIQUE` (`idViajero`),
  UNIQUE KEY `idUsuario_UNIQUE` (`idUsuario`),
  CONSTRAINT `fk_viajeros_usuarios2` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viajeros`
--

LOCK TABLES `viajeros` WRITE;
/*!40000 ALTER TABLE `viajeros` DISABLE KEYS */;
INSERT INTO `viajeros` VALUES (4,16,'AA','Luis',0,1,8.75,'luis@gmail.com','luis123','67676767','Dinamarca',''),(5,19,'AS','Andrés',3,2,7,'andres@hotmail.com','andres123','77777777','China','foto.jpg'),(6,21,'Hector54','Hector',0,0,0,'hector@gmail.com','hector123','76082312','El Salvador','hector.jpg'),(7,22,'RAMR','Rodrigo M',0,0,0,'ro-martinez11@hotmail.com','rodrigo124','76082312','El Salvador','foto.jpg'),(8,23,'Davirr06','David Rivas',0,0,0,'davidr@gmail.com','david123','76757556','El Salvador','david.jpg'),(9,24,'BichoCR7','El Bicho',0,0,0,'CR7@hotmail.com','cristiano123','76082312','Portugal','cristiano.png'),(10,25,'Pollo87','Pollo M',0,0,0,'pollo@hotmail.com','pollo123','7969696','Guatemala','pollo.png');
/*!40000 ALTER TABLE `viajeros` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `viajes`
--

DROP TABLE IF EXISTS `viajes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `viajes` (
  `idviaje` int NOT NULL AUTO_INCREMENT,
  `idViajero` int NOT NULL,
  `fecha de inicio` date NOT NULL,
  `fecha de regreso` date NOT NULL,
  `Activo` varchar(45) NOT NULL COMMENT '''Sí'', ''No''',
  `Pais Destino` varchar(45) NOT NULL,
  `direccion de estadia` varchar(170) NOT NULL,
  `cobro por libra` decimal(12,2) NOT NULL,
  `telefono` int NOT NULL,
  `imagen referencia` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`idviaje`),
  UNIQUE KEY `idviaje_UNIQUE` (`idviaje`),
  KEY `fk_Viajes_Viajeros1_idx` (`idViajero`),
  CONSTRAINT `fk_Viajes_Viajeros1` FOREIGN KEY (`idViajero`) REFERENCES `viajeros` (`idViajero`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viajes`
--

LOCK TABLES `viajes` WRITE;
/*!40000 ALTER TABLE `viajes` DISABLE KEYS */;
INSERT INTO `viajes` VALUES (1,4,'2021-01-01','2021-02-02','Sí','España','Madrid',0.50,7676766,'madrid.jpg'),(2,5,'2021-03-03','2021-04-04','No','Argentina','Buenos Aires',2.00,5214233,'argentina.jpg'),(3,5,'2021-06-06','2021-07-07','Sí','Estados Unidos','Washington DC',3.00,4123412,'washington.jpg');
/*!40000 ALTER TABLE `viajes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `viajes_AFTER_INSERT` AFTER INSERT ON `viajes` FOR EACH ROW BEGIN
UPDATE viajeros
set CantidadViajes = CantidadViajes +1
WHERE idViajero = new.idViajero;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `viajes_view`
--

DROP TABLE IF EXISTS `viajes_view`;
/*!50001 DROP VIEW IF EXISTS `viajes_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `viajes_view` AS SELECT 
 1 AS `idViaje`,
 1 AS `idViajero`,
 1 AS `Viajero`,
 1 AS `Inicio de Viaje`,
 1 AS `Regreso de Viaje`,
 1 AS `Activo`,
 1 AS `Pais`,
 1 AS `Cobro`,
 1 AS `Teléfono`,
 1 AS `Foto`,
 1 AS `CantidadViajes`,
 1 AS `CantidadPedidos`,
 1 AS `Calificacion`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'proyectozeus'
--

--
-- Dumping routines for database 'proyectozeus'
--

--
-- Final view structure for view `calificaciones_view`
--

/*!50001 DROP VIEW IF EXISTS `calificaciones_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `calificaciones_view` (`idCalificacion`,`UserCalificador`,`UserCalificado`,`idPedido`,`Nota`,`Comentarios`) AS select `a`.`idcalificaciones` AS `idCalificacion`,`b`.`Usuario` AS `UserCalificador`,`c`.`nombre_completo` AS `UserCalificado`,`a`.`idPedido` AS `idPedido`,`a`.`Nota` AS `Nota`,`a`.`Comentarios` AS `Comentarios` from ((`calificaciones` `a` join `usuarios` `b` on((`a`.`idUsuarioCalificador` = `b`.`idUsuario`))) join `viajeros` `c` on((`a`.`idUsuarioCalificado` = `c`.`idUsuario`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `viajes_view`
--

/*!50001 DROP VIEW IF EXISTS `viajes_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `viajes_view` (`idViaje`,`idViajero`,`Viajero`,`Inicio de Viaje`,`Regreso de Viaje`,`Activo`,`Pais`,`Cobro`,`Teléfono`,`Foto`,`CantidadViajes`,`CantidadPedidos`,`Calificacion`) AS select `a`.`idviaje` AS `idViaje`,`b`.`idViajero` AS `idViajero`,`b`.`nombre_completo` AS `Viajero`,`a`.`fecha de inicio` AS `Inicio de Viaje`,`a`.`fecha de regreso` AS `Regreso de viaje`,`a`.`Activo` AS `Activo`,`a`.`Pais Destino` AS `Pais`,`a`.`cobro por libra` AS `Cobro`,`a`.`telefono` AS `Telefono`,`b`.`Foto` AS `Foto`,`b`.`CantidadViajes` AS `CantidadViajes`,`b`.`CantidadPedidos` AS `CantidadPedidos`,`b`.`Calificacion` AS `Calificacion` from (`viajes` `a` join `viajeros` `b` on((`a`.`idViajero` = `b`.`idViajero`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-07-30 10:28:37
