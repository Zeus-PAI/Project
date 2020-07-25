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
  `Precio (USD)` decimal(12,2) NOT NULL,
  `Peso (lb)` double NOT NULL,
  `Categoria` varchar(45) NOT NULL,
  `Cantidad` int NOT NULL,
  `Otras especificaciones` varchar(45) DEFAULT NULL,
  `Dimensiones (cm)` varchar(45) DEFAULT NULL,
  `URL` varchar(650) NOT NULL,
  `Con empaque` varchar(45) NOT NULL,
  `Fecha estimada de entrega` date NOT NULL,
  `Estado del pedido` varchar(20) NOT NULL,
  `Total` decimal(12,2) NOT NULL,
  PRIMARY KEY (`idPedido`),
  UNIQUE KEY `idPedido_UNIQUE` (`idPedido`),
  KEY `fk_pedidos_usuarios1_idx` (`idUsuario`),
  KEY `fk_pedidos_viajesinfo1_idx` (`idViaje`),
  KEY `fk_pedidos_Viajeros2_idx` (`idViajero`),
  CONSTRAINT `fk_pedidos_usuarios1` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`idUsuario`),
  CONSTRAINT `fk_pedidos_Viajeros2` FOREIGN KEY (`idViajero`) REFERENCES `viajeros` (`idViajero`),
  CONSTRAINT `fk_pedidos_viajesinfo1` FOREIGN KEY (`idViaje`) REFERENCES `viajes` (`idviaje`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,2,1,1,'NMD Adidas',140.50,1.5,'Calzado',1,'Negro','10x15','adidas.com/NMD','Sí','2020-09-02','Pendiente',143.50),(2,2,1,1,'Reloj Fossil',135.00,0.5,'Joyería',2,'Brazalete metálico','30x2','amazon.com/fossil','No','2020-10-20','Aceptado',271.00),(3,2,2,2,'Computadora Dell',900.00,3,'Tecnología',1,NULL,'25x25','bestbuy.com/Dell','Sí','2020-01-31','Pagado',901.50);
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='IF (proyectozeus.solicitudes.EstadoSolicitud = ''Aprobada'') THEN END IF;';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solicitudes`
--

LOCK TABLES `solicitudes` WRITE;
/*!40000 ALTER TABLE `solicitudes` DISABLE KEYS */;
INSERT INTO `solicitudes` VALUES (1,'RM','Rodrigo','ro@gmail.com','rodrigo123','1999-01-01','78787878','Placer','Alta','Aprobada','El Salvador','imagen.jpg'),(2,'AS','Andrés','andres@hotmail.com','andres123','1999-01-01','77777777','Negocios','Alta','Aprobada','China','foto.jpg'),(3,'FE','Fernando','fer@gmail.com','fer123','1999-01-01','75757575','Negocios','Intermedia','Aprobada','Suecia','pic.jpg'),(4,'AA','Luis','luis@gmail.com','luis123','1999-01-01','67676767','Placer','Alta','Aprobada','Dinamarca','profilepic.jpg'),(5,'RAMR','Rodrigo M','ro-martinez11@hotmail.com','rodrigo124','2020-07-21','76082312','Placer','Alta','Aprobada','El Salvador','foto.jpg'),(6,'Hector54','Hector','hector@gmail.com','hector123','1989-06-06','76082312','Otro','Baja','Aprobada','El Salvador','hector.jpg');
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
IF old.EstadoSolicitud != 'Aprobada' then
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'RodriM10','Rodrigo Martinez','ro-martinez11@hotmail.com','rodrigo123','1999-09-02','676574-456745','El Salvador',1,NULL),(2,'usuario','UsuarioEjemplo','usuario@gmail.com','user123','2000-01-01','25213412','Guatemala',2,NULL),(3,'viajero','ViajeroEjemplo','viajero@hotmail.com','viajero123','1990-01-06','12401240','Honduras',3,NULL),(4,'otro','OtroViajero','viajero2@gmail.com','viajero1234','1991-11-24','2341342341','Panamá',3,NULL),(6,'e','e','e@gmail.com','asdas','1999-01-01','2131231','e',2,NULL),(9,'intento','Intento 1','rod@gmail.com','1232','2020-07-19','21412421','España',2,NULL),(10,'intento2','Intento 2','rodrigo@hotmail.com','12312','2020-07-08','21412421','España',2,NULL),(11,'','','','','0000-00-00','','',3,NULL),(12,'','','','','0000-00-00','','',3,NULL),(13,'RM','Rodrigo','ro@gmail.com','rodrigo123','1999-01-01','78787878','El Salvador',3,NULL),(14,'AA','Luis','luis@gmail.com','luis123','1999-01-01','67676767','Dinamarca',3,NULL),(15,'FE','Fernando','fer@gmail.com','fer123','1999-01-01','75757575','Suecia',3,NULL),(16,'AA','Luis','luis@gmail.com','luis123','1999-01-01','67676767','Dinamarca',3,NULL),(17,'aa','qqq','@ggg','al123','1999-01-01','252345','España',2,NULL),(19,'AS','Andrés','andres@hotmail.com','andres123','1999-01-01','77777777','China',3,'foto.jpg'),(20,'Messi10','Leo Messi','messi10@gmail.com','messi123','1987-06-24','76555567','Argentina',2,'messi.jpg'),(21,'Hector54','Hector','hector@gmail.com','hector123','1989-06-06','76082312','El Salvador',3,'hector.jpg');
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

--
-- Table structure for table `viajeros`
--

DROP TABLE IF EXISTS `viajeros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `viajeros` (
  `idViajero` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NOT NULL,
  `CantidadViajes` int NOT NULL DEFAULT '0',
  `CantidadPedidos` int NOT NULL DEFAULT '0',
  `Calificacion` float NOT NULL DEFAULT '0',
  `Usuario` varchar(45) NOT NULL,
  `nombre_completo` varchar(100) NOT NULL,
  `correo` varchar(45) NOT NULL,
  `contraseña` varchar(45) NOT NULL,
  `telefono` varchar(45) NOT NULL,
  `pais` varchar(45) NOT NULL,
  `Foto` varchar(45) NOT NULL,
  PRIMARY KEY (`idViajero`,`idUsuario`),
  UNIQUE KEY `idViajero_UNIQUE` (`idViajero`),
  UNIQUE KEY `idUsuario_UNIQUE` (`idUsuario`),
  CONSTRAINT `fk_viajeros_usuarios2` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viajeros`
--

LOCK TABLES `viajeros` WRITE;
/*!40000 ALTER TABLE `viajeros` DISABLE KEYS */;
INSERT INTO `viajeros` VALUES (1,3,1,1,7.9,'','','','','','',''),(2,4,1,1,6.5,'','','','','','',''),(4,16,0,0,10,'AA','Luis','luis@gmail.com','luis123','67676767','Dinamarca',''),(5,19,0,0,0,'AS','Andrés','andres@hotmail.com','andres123','77777777','China','foto.jpg'),(6,21,0,0,0,'Hector54','Hector','hector@gmail.com','hector123','76082312','El Salvador','hector.jpg');
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
  `fecha de llegada` date NOT NULL,
  `fecha de regreso` date NOT NULL,
  `Pais Destino` varchar(45) NOT NULL,
  `direccion de estadia` varchar(170) NOT NULL,
  `cobro por libra` decimal(12,2) NOT NULL,
  `telefono` int NOT NULL,
  `imagen referencia` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`idviaje`),
  UNIQUE KEY `idviaje_UNIQUE` (`idviaje`),
  KEY `fk_Viajes_Viajeros1_idx` (`idViajero`),
  CONSTRAINT `fk_Viajes_Viajeros1` FOREIGN KEY (`idViajero`) REFERENCES `viajeros` (`idViajero`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viajes`
--

LOCK TABLES `viajes` WRITE;
/*!40000 ALTER TABLE `viajes` DISABLE KEYS */;
INSERT INTO `viajes` VALUES (1,1,'2020-07-25','2020-10-21','España','Avenida de España, 18, Fuenlabrada, Fuenlabrada, España',2.00,6452242,'fotohotel.jpg'),(2,2,'2021-01-11','2021-02-02','Inglaterra','4 Stanhope Place, Marble Arch, London',0.50,625242,'londreshotel.jpg');
/*!40000 ALTER TABLE `viajes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'proyectozeus'
--

--
-- Dumping routines for database 'proyectozeus'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-07-24 22:19:59
