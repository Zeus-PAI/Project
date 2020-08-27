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
  `idcalificaciones` int NOT NULL AUTO_INCREMENT,
  `idUsuarioCalificador` int NOT NULL,
  `idUsuarioCalificado` int NOT NULL,
  `idPedido` int NOT NULL,
  `Nota` float NOT NULL,
  `Comentarios` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idcalificaciones`,`idUsuarioCalificador`,`idUsuarioCalificado`),
  UNIQUE KEY `idcalificaciones_UNIQUE` (`idcalificaciones`),
  KEY `fk_idUsuario_idx` (`idUsuarioCalificado`),
  KEY `fk_idUsuario2_idx` (`idUsuarioCalificador`),
  KEY `fk_pedidos_idx` (`idPedido`),
  CONSTRAINT `fk_pedidos` FOREIGN KEY (`idPedido`) REFERENCES `pedidos` (`idPedido`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calificaciones`
--

LOCK TABLES `calificaciones` WRITE;
/*!40000 ALTER TABLE `calificaciones` DISABLE KEYS */;
INSERT INTO `calificaciones` VALUES (1,2,19,2,8,'Buen Servicio'),(2,2,19,3,5,'Mal Servicio'),(4,2,19,4,9,'Excelente'),(5,2,19,4,7,'Mas o menos'),(6,2,19,2,6,'Meh'),(9,6,19,5,7.5,'Bueno'),(10,10,5,4,5.5,'aaa'),(11,10,6,9,8,'Bueno'),(12,10,5,2,7,'Nada mal'),(13,10,21,10,8,'Bueno'),(14,2,33,17,4.5,'Muy Malo Vicent'),(15,19,10,2,9,'Buen Muchacho'),(16,10,19,13,8,'Buen Trabajo'),(17,10,19,13,9,'Excelente'),(18,10,19,12,5,'Mal servicio'),(19,44,21,28,9,'Excelente'),(20,44,21,29,10,'El mejor servicio'),(21,21,44,29,9.5,'Buen muchacho'),(22,21,44,28,8,'bueno'),(23,21,44,28,7,'Bien');
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
if (SELECT idViajero FROM proyectozeus.viajeros where idUsuario = new.idUsuarioCalificador) is null then
UPDATE viajeros
SET Calificacion =  (Select avg(nota) from proyectozeus.calificaciones
where idUsuarioCalificado = new.idUsuarioCalificado)
WHERE idUsuario = new.idUsuarioCalificado;
UPDATE usuarios
SET Calificacion =  (Select avg(nota) from proyectozeus.calificaciones
where idUsuarioCalificado = new.idUsuarioCalificado)
WHERE idUsuario = new.idUsuarioCalificado;

end if;
Update pedidos
Set Calificado = Calificado +1
Where idPedido = new.idPedido;

if (SELECT idViajero FROM proyectozeus.viajeros where idUsuario = new.idUsuarioCalificador) is not null then
UPDATE usuarios
SET Calificacion =  (Select avg(nota) from proyectozeus.calificaciones
where idUsuarioCalificado = new.idUsuarioCalificado)
WHERE idUsuario = new.idUsuarioCalificado;
end if;
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
 1 AS `idUserCalificador`,
 1 AS `idUserCalificado`,
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
  `idPedido` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NOT NULL,
  `idViajero` int NOT NULL,
  `idViaje` int NOT NULL,
  `NombreArticulo` varchar(100) NOT NULL,
  `EstadoPedido` varchar(20) NOT NULL COMMENT '''Denegado'', ''Aceptado'', ''Pagado'', ''Entregado'', ''Anulado''',
  `Precio` decimal(12,2) NOT NULL,
  `Peso` double NOT NULL,
  `Categoria` varchar(45) NOT NULL,
  `Cantidad` int NOT NULL,
  `Especificaciones` varchar(45) DEFAULT NULL,
  `URL` varchar(650) NOT NULL,
  `Pais` varchar(45) NOT NULL,
  `FechaPedido` date DEFAULT NULL,
  `FechaEntrega` date NOT NULL,
  `Total` decimal(12,2) NOT NULL,
  `Calificado` int NOT NULL DEFAULT '0' COMMENT '''0'', ''1''',
  PRIMARY KEY (`idPedido`),
  UNIQUE KEY `idPedido_UNIQUE` (`idPedido`),
  KEY `fk_pedidos_usuarios1_idx` (`idUsuario`),
  KEY `fk_pedidos_viajesinfo1_idx` (`idViaje`),
  KEY `fk_pedidos_Viajeros2_idx` (`idViajero`),
  CONSTRAINT `fk_pedidos_usuarios1` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`idUsuario`) ON DELETE CASCADE,
  CONSTRAINT `fk_pedidos_Viajeros2` FOREIGN KEY (`idViajero`) REFERENCES `viajeros` (`idViajero`) ON DELETE CASCADE,
  CONSTRAINT `fk_pedidos_viajesinfo1` FOREIGN KEY (`idViaje`) REFERENCES `viajes` (`idviaje`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (2,10,5,2,'Zapatos adidas','Entregado',80.00,4,'Ropa y Calzado',2,'Blancos','www.adidas.com','Argentina','2020-07-07','2021-04-04',176.00,1),(3,9,5,3,'Camisa Polo','Entregado',100.00,2,'Ropa y Calzado',1,'none','www.ralphlauren.com','Estados Unidos','0000-00-00','2021-07-07',106.00,0),(4,10,5,2,'Lentes','Comprado',50.00,0.5,'Joyería y Accesorios',1,'none','www.lentes.com','Argentina','2020-07-09','2021-07-07',52.00,1),(5,6,5,4,'Raqueta de Tennis','Rechazado',30.00,3,'deportivo',1,'Verde','www.tennis.com','Francia','0000-00-00','2021-09-09',42.00,1),(6,17,6,6,'Camisa Alemania','Entregado',80.00,1,'deportivo',3,'Talla S','www.diemannschaft.com','Qatar','0000-00-00','2022-12-31',99.50,0),(7,17,6,6,'Juguete','Anulado',40.00,3,'otro',1,'Negro con piezas especiales','www.juguete.com','Qatar','0000-00-00','2022-12-31',50.00,0),(8,17,5,3,'Dados','Anulado',3.00,1,'otro',1,'Negros','www.dados.com','Estados Unidos','0000-00-00','2021-07-07',5.00,0),(9,10,6,6,'Cámara Nikon','Anulado',600.00,3,'tecnologia',1,'Plateada','www.nikon.com','Argentina','0000-00-00','2022-12-31',620.00,1),(10,10,6,6,'Camisa Mundial','Pendiente',50.00,2,'deportivo',2,'Talla S','www.mundial.com','Qatar','0000-00-00','2022-12-31',100.00,1),(11,17,5,5,'iPhone','Pendiente',1000.00,1,'tecnologia',1,'negro de 16 GB','www.apple.com','Inglaterra','0000-00-00','2020-12-30',1000.00,0),(12,10,5,4,'Reloj','Pendiente',48.00,1,'joyeria',1,'plateado','www.reloj.com','Francia','0000-00-00','2021-09-09',0.00,1),(13,10,5,4,'Carro','Pendiente',5000.00,200,'otro',1,'rojo','www.carro.com','España','0000-00-00','2021-01-01',100.00,1),(14,2,5,4,'Póster','Rechazado',4.00,3,'otro',4,'Negro','www.poster.com','Francia','0000-00-00','2021-09-09',40.00,0),(15,2,6,6,'Lentes Ray Ban','Pendiente',99.99,0.75,'joyeria',1,'Blancos','www.rayban.com','Qatar','0000-00-00','2022-12-31',104.87,0),(16,2,5,3,'Pintura','Entregado',3.00,0.5,'hogar',2,'','www.pintura.com','Estados Unidos','0000-00-00','2021-07-07',9.00,0),(17,2,14,8,'El Bicho','Entregado',2.00,166,'otro',4,'','www.elbicho.com','Estados Unidos','0000-00-00','2020-08-08',1004.00,1),(18,10,14,8,'MacBook','Comprado',2.50,0,'none',2,'','','Estados Unidos','0000-00-00','2020-08-08',5.00,0),(19,10,14,8,'iPhone 11','Pendiente',999.99,3.75,'tecnologia',3,'','www.apple.com','Estados Unidos','0000-00-00','2020-08-08',3016.85,0),(20,10,14,8,'Blusa GoldGirl','Pendiente',26.00,2,'ropa',3,'Gold Girl La mejor marca <3','www.goldgirllamejor.com','Estados Unidos','0000-00-00','2020-08-08',87.00,0),(21,10,14,8,'iPad','Pendiente',1000.00,2.5,'tecnologia',1,'Negra o plateada','www.apple.com','Estados Unidos','0000-00-00','2020-08-08',1003.75,0),(22,10,14,8,'iPad','Pendiente',1000.00,2.5,'tecnologia',1,'Negra o plateada','www.apple.com','Estados Unidos','0000-00-00','2020-08-08',1003.75,0),(23,10,14,8,'Camisa','Pendiente',20.00,1,'Ropa y Calzado',1,'none','www.camisa.com','Estados Unidos','2020-08-07','2020-08-08',100.00,0),(24,10,14,8,'Camisetas','Pendiente',30.00,1,'Ropa y Calzado',2,'Talla 32','www.levis.com','Estados Unidos','2020-01-01','2020-12-12',1000.00,0),(25,10,14,8,'FF','Pendiente',30.00,1.5,'Ropa',4,'none','www.com','a',NULL,'2020-01-01',111.00,0),(26,10,14,8,'Jeans Levis','Pendiente',2.00,2,'ropa',3,'Talla S','www.levis.com','Estados Unidos',NULL,'2020-08-08',15.00,0),(27,10,14,8,'Samsung A1000','Aceptado',1000.00,1.5,'tecnologia',1,'Negro','www.samsung.com','Estados Unidos','2020-08-24','2020-08-08',1002.25,0),(28,44,6,6,'iPad','Entregado',1200.00,4,'tecnologia',1,'de 64 GB, plateada','www.apple.com','Qatar','2020-08-27','2022-12-31',1226.00,2),(29,44,6,6,'iPhone 11','Entregado',1198.00,4.5,'tecnologia',1,'de 64 GB, plateado','www.apple.com','Qatar','2020-08-27','2022-12-31',1227.25,1),(30,44,6,6,'Zapatos Nike','Pendiente',200.00,3,'ropa',1,'Rojos talla 9.5','www.nike.com','Qatar','2020-08-27','2022-12-31',219.50,0);
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
IF new.Calificado = old.Calificado then
IF new.`EstadoPedido` = 'Entregado' THEN
UPDATE viajeros
set CantidadPedidos = CantidadPedidos +1
WHERE idViajero = new.idViajero;

UPDATE usuarios
set CantidadPedidos = CantidadPedidos +1
WHERE idUsuario = new.idUsuario;

UPDATE usuarios
set CantidadPedidos = CantidadPedidos +1
WHERE idUsuario =  (SELECT idUsuario FROM proyectozeus.viajeros where idViajero = new.idViajero);
END IF;
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `pedidos_view`
--

DROP TABLE IF EXISTS `pedidos_view`;
/*!50001 DROP VIEW IF EXISTS `pedidos_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `pedidos_view` AS SELECT 
 1 AS `idPedido`,
 1 AS `idUsuario`,
 1 AS `UsuarioCliente`,
 1 AS `idViajero`,
 1 AS `Viajero`,
 1 AS `idViaje`,
 1 AS `Artículo`,
 1 AS `Estado`,
 1 AS `Precio`,
 1 AS `Peso`,
 1 AS `Cantidad`,
 1 AS `Especificaciones`,
 1 AS `URL`,
 1 AS `Pais`,
 1 AS `FechaPedido`,
 1 AS `FechaEntrega`,
 1 AS `Total`,
 1 AS `Calificado`*/;
SET character_set_client = @saved_cs_client;

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
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='IF (proyectozeus.solicitudes.EstadoSolicitud = ''Aprobada'') THEN END IF;';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solicitudes`
--

LOCK TABLES `solicitudes` WRITE;
/*!40000 ALTER TABLE `solicitudes` DISABLE KEYS */;
INSERT INTO `solicitudes` VALUES (1,'RM','Rodrigo','ro@gmail.com','rodrigo123','1999-01-01','78787878','Placer','Alta','Aprobada','El Salvador','imagen.jpg'),(2,'AS','Andrés','andres@hotmail.com','andres123','1999-01-01','77777777','Negocios','Alta','Aprobada','China','foto.jpg'),(3,'FE','Fernando','fer@gmail.com','fer123','1999-01-01','75757575','Negocios','Intermedia','Aprobada','Suecia','pic.jpg'),(4,'AA','Luis','luis@gmail.com','luis123','1999-01-01','67676767','Placer','Alta','Aprobada','Dinamarca','profilepic.jpg'),(5,'RAMR','Rodrigo M','ro-martinez11@hotmail.com','rodrigo124','2020-07-21','76082312','Placer','Alta','Aprobada','El Salvador','foto.jpg'),(6,'Hector54','Hector','hector@gmail.com','hector123','1989-06-06','76082312','Otro','Baja','Aprobada','El Salvador','hector.jpg'),(7,'Pollo87','Pollo M','pollo@hotmail.com','pollo123','1970-05-04','7969696','Otro','Intermedia','Denegada','Guatemala','pollo.png'),(8,'Davirr06','David Rivas','davidr@gmail.com','david123','1999-09-23','76757556','Negocios','Alta','Aprobada','El Salvador','david.jpg'),(9,'BichoCR7','El Bicho','CR7@hotmail.com','cristiano123','1985-02-05','76082312','Negocios','Alta','Aprobada','Portugal','cristiano.png'),(10,'Sol1','Solicitud 1','sol1@gmail.com','solicitud1','2020-07-25','76757556','Placer','Intermedia','Denegada','El Salvador','solicitud1.jpg'),(11,'request19','Request 2','requ2@hotmail.com','requ2','2020-07-07','76757556','Negocios','Alta','Aprobada','El Salvador','request2.jpg'),(12,'Adriantlson','Adrián Rodríguez','adirantl@gmail.com','adrian123','1989-06-07','76757556','Placer','Intermedia','Aprobada','El Salvador','Adrian.jpg'),(13,'lopez00','Diego López','lopez@hotmail.com','lopez123','2019-10-30','76757556','Placer','Intermedia','Denegada','El Salvador','lopez.jpg'),(14,'Halaand9','Haaland','haaland@dortmund.com','haaland','2020-08-03','76757556','Negocios','Alta','Aprobada','Noruega','5.png'),(15,'Palasí84','Vicent','vicentpalasi@gmail.com','palasi123','1919-01-27','227777777','Negocios','Intermedia','Aprobada','España','Logo 2020.png'),(16,'ConnorJohn','John Connor','johnconnor@terminator.com','john123','2020-08-09','77334455','none','none','Pendiente','Armenia','foto.jpg'),(17,'LoganPaul100','Logan Paul','loganpaul@gmail.com','logan123','2020-07-30','22834212','none','none','Pendiente','España','cristiano.png'),(18,'Barto28','Josep Bartomeu','bartomeu@dimision.com','barto123','1965-07-07','73091211','Negocios','Alta','Aprobada','España','barto.jpg'),(19,'Floren18','Florentino Pérez','floren@madrid.com','florentino123','1988-12-16','453452','Negocios','Alta','Denegada','México','barto.jpg'),(40,'Wick14','John Wick','wickjohng@gmail.com','john123','1999-12-27','545443','Placer','Alta','Pendiente','Estados Unidos','pexels-photo-1310522.jpeg'),(41,'Neymar11','Neymar','neymar10@gmail.com','neymar123','1992-02-05','5423223','Negocios','Alta','Aprobada','Brasil','neymar.jpeg'),(42,'Fuentes16','Edgardo Fuentes','fuentes@gmail.com','fuentes123','1992-02-02','76942312','Otro','Intermedia','Aprobada','El Salvador','neymar.jpeg');
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
  `CantidadPedidos` int DEFAULT '0',
  `Calificacion` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`idUsuario`),
  UNIQUE KEY `idUsuario_UNIQUE` (`idUsuario`),
  KEY `fk_usuarios_tipos de usuarios_idx` (`idTipo`),
  CONSTRAINT `fk_usuarios_tipos de usuarios` FOREIGN KEY (`idTipo`) REFERENCES `tipos de usuarios` (`idTipo`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'RodriM10','Rodrigo Martinez','ro-martinez11@hotmail.com','rodrigo123','1999-09-02','676574-456745','El Salvador',1,'blankpic.png',NULL,NULL),(2,'usuario','UsuarioEjemplo','usuario@gmail.com','user123','2000-01-01','25213412','Guatemala',2,'ronaldo.jpg',0,NULL),(6,'e','e','e@gmail.com','asdas','1999-01-01','2131231','e',2,'ronaldo.jpg',0,NULL),(9,'intento','Intento 1','rod@gmail.com','1232','2020-07-19','21412421','España',2,'blankpic.png',0,NULL),(10,'Daniel7','Intento 2','rodrigo@hotmail.com','12312','2020-07-08','21412421','España',2,'ronaldo.jpg',1,9.00),(13,'RM','Rodrigo','ro@gmail.com','rodrigo123','1999-01-01','78787878','El Salvador',3,'blankpic.png',0,NULL),(15,'FE','Fernando','fer@gmail.com','fer123','1999-01-01','75757575','Suecia',3,'blankpic.png',0,NULL),(17,'aa','qqq','@ggg','al123','1999-01-01','252345','España',2,'blankpic.png',0,NULL),(19,'AS','Andrés','andres@hotmail.com','andres123','1999-01-01','77777777','China',3,'foto.jpg',6,7.17),(21,'Hector54','Hector','hector@gmail.com','hector123','1989-06-06','76082312','El Salvador',3,'hector.jpg',9,9.00),(24,'BichoCR9','El Bichardo','CR9@hotmail.com','cristiano1234','1985-02-05','76082312','Portugal',3,'david.jpg',0,NULL),(28,'Messi10','Leo Messi','messi10@gmail.com','messi10','2020-08-03','76757556','Argentina',2,'blankpic.png',0,NULL),(29,'Messi10','Leo Messi','messi10@gmail.com','messi10','2020-08-03','76757556','Argentina',2,'blankpic.png',0,NULL),(31,'rod1','Rodrigo M','rod@g','rod10','2020-08-03','77777777','Portugal',2,'blankpic.png',0,NULL),(33,'Palacios85','Fernando Palacios','ferpalacios@gmail.com','palacios123','1919-01-27','227777777','España',3,'Logo 2020.png',1,NULL),(34,'Bichoaaa','El Bicho','bicho@gmail.com','bicho','2020-08-05','76082312','Portugal',2,'squad.jpg',0,NULL),(35,'Comprador10','Comprador','comprador@hotmail.com','comprador','2020-08-05','076757556','Austria',2,'champions.jpg',0,NULL),(36,'Comprador10','Comprador','comprador@hotmail.com','comprador','2020-08-05','076757556','Austria',2,'champions.jpg',0,NULL),(37,'Example1','Example','ex@gmail.com','example','2020-07-28','076757556','Bahamas',2,'blankpic.png',0,NULL),(38,'ro-martinez11@hotmail.com','Rodrigo M','sol1@gmail.com','rodrigo','2020-07-28','76757556','El Salvador',2,'blankpic.png',0,NULL),(39,'RodrigoMRTNZ1019_','Rodrigo Andrés Martínez','ro-martinez11@hotmail.com','rodrigo123','1999-09-02','76082312','El Salvador',2,'blankpic.png',0,NULL),(40,'MillerTime11','Dennis Miller','miller@hotmail.com','miller123','1953-06-09','76757556','Estados Unidos',2,'blankpic.png',0,NULL),(41,'Suarez9_','Luis Suárez','suarez@gmail.com','suarez123','1987-01-24','78789999','Uruguay',2,'cristiano.png',0,NULL),(42,'ConnorJohn','John Connor','johnconnor@terminator.com','john123','1999-06-15','77554433','Estados Unidos',2,'blankpic.png',0,NULL),(43,'ConnorJohn','John Connor','johnconnor@terminator.com','john123','1999-06-15','77554433','Estados Unidos',2,'blankpic.png',0,NULL),(44,'MiguelF11','Miguel Fernández','miguel@gmail.com','miguel123','1999-10-02','7788223','El Salvador',2,'ronaldo.jpg',6,8.17),(45,'RodR10','Rodrigo Rosales','rodri@gmail.com','rodrigo123','1999-09-02','79062312','El Salvador',2,'',0,NULL);
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
  `Calificacion` decimal(10,2) DEFAULT NULL,
  `correo` varchar(45) NOT NULL,
  `contraseña` varchar(45) NOT NULL,
  `telefono` varchar(45) NOT NULL,
  `pais` varchar(45) NOT NULL,
  `Foto` varchar(45) NOT NULL,
  PRIMARY KEY (`idViajero`,`idUsuario`),
  UNIQUE KEY `idViajero_UNIQUE` (`idViajero`),
  UNIQUE KEY `idUsuario_UNIQUE` (`idUsuario`),
  CONSTRAINT `fk_viajeros_usuarios2` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viajeros`
--

LOCK TABLES `viajeros` WRITE;
/*!40000 ALTER TABLE `viajeros` DISABLE KEYS */;
INSERT INTO `viajeros` VALUES (5,19,'AS','Andrés',5,6,7.17,'andres@hotmail.com','andres123','77777777','China','foto.jpg'),(6,21,'Hector54','Hector',1,9,9.00,'hector@gmail.com','hector123','76082312','El Salvador','hector.jpg'),(9,24,'BichoCR9','El Bicho',0,0,0.00,'CR9@hotmail.com','cristiano1234','76082312','Portugal','david.jpg'),(14,33,'Palacios85','Fernando Palacios',3,1,4.50,'ferpalacios@gmail.com','palacios123','227777777','España','Logo 2020.png');
/*!40000 ALTER TABLE `viajeros` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `viajeros_AFTER_UPDATE` AFTER UPDATE ON `viajeros` FOR EACH ROW BEGIN
Update usuarios
SET Usuario = new.Usuario, correo = new.correo, contraseña = new.contraseña, telefono = new.telefono, pais = new.pais, Foto = new.Foto WHERE idUsuario = new.idUsuario;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viajes`
--

LOCK TABLES `viajes` WRITE;
/*!40000 ALTER TABLE `viajes` DISABLE KEYS */;
INSERT INTO `viajes` VALUES (2,5,'2021-03-03','2021-04-04','No','Argentina','Buenos Aires',2.00,5214233,'argentina.jpg'),(3,5,'2021-06-06','2021-07-07','Sí','Estados Unidos','Washington DC',3.00,4123412,'washington.jpg'),(4,5,'2021-08-08','2021-09-09','Sí','Francia','París',2.00,70607065,'paris.jpg'),(5,5,'2020-11-21','2020-12-30','Sí','Inglaterra','Londres',4.50,7565555,'londres.jpg'),(6,6,'2022-11-01','2022-12-31','Sí','Qatar','estadio Qatar',6.50,77778888,'estadio.jpg'),(8,14,'2020-08-03','2020-08-08','Sí','Estados Unidos','Dirección',1.50,76757556,''),(9,14,'2020-08-27','2020-12-25','No','Italia','Turín',5.50,77334455,''),(10,14,'2020-07-26','2020-09-28','Sí','China','Wuhan',3.50,78789999,'london.jpg');
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
 1 AS `Direccion de Estadia`,
 1 AS `PaisOrigen`,
 1 AS `Cobro`,
 1 AS `Teléfono`,
 1 AS `Foto`,
 1 AS `CantidadViajes`,
 1 AS `CantidadPedidos`,
 1 AS `Calificacion`,
 1 AS `imagenReferencia`*/;
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
/*!50001 VIEW `calificaciones_view` (`idCalificacion`,`idUserCalificador`,`idUserCalificado`,`UserCalificador`,`UserCalificado`,`idPedido`,`Nota`,`Comentarios`) AS select `a`.`idcalificaciones` AS `idCalificacion`,`a`.`idUsuarioCalificador` AS `idUserCalificador`,`a`.`idUsuarioCalificado` AS `idUserCalificado`,`b`.`Usuario` AS `UserCalificador`,(select `usuarios`.`Usuario` from `usuarios` where (`usuarios`.`idUsuario` = `a`.`idUsuarioCalificado`)) AS `UserCalificado`,`a`.`idPedido` AS `idPedido`,`a`.`Nota` AS `Nota`,`a`.`Comentarios` AS `Comentarios` from (`calificaciones` `a` join `usuarios` `b` on((`a`.`idUsuarioCalificador` = `b`.`idUsuario`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pedidos_view`
--

/*!50001 DROP VIEW IF EXISTS `pedidos_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `pedidos_view` (`idPedido`,`idUsuario`,`UsuarioCliente`,`idViajero`,`Viajero`,`idViaje`,`Artículo`,`Estado`,`Precio`,`Peso`,`Cantidad`,`Especificaciones`,`URL`,`Pais`,`FechaPedido`,`FechaEntrega`,`Total`,`Calificado`) AS select `a`.`idPedido` AS `idPedido`,`b`.`idUsuario` AS `idUsuario`,`b`.`Usuario` AS `UsuarioCliente`,`c`.`idViajero` AS `idViajero`,`c`.`nombre_completo` AS `Viajero`,`d`.`idviaje` AS `idViaje`,`a`.`NombreArticulo` AS `Articulo`,`a`.`EstadoPedido` AS `Estado`,`a`.`Precio` AS `Precio`,`a`.`Peso` AS `Peso`,`a`.`Cantidad` AS `Cantidad`,`a`.`Especificaciones` AS `Especificaciones`,`a`.`URL` AS `URL`,`a`.`Pais` AS `Pais`,`a`.`FechaPedido` AS `FechaPedido`,`a`.`FechaEntrega` AS `FechaEntrega`,`a`.`Total` AS `Total`,`a`.`Calificado` AS `Calificado` from (((`pedidos` `a` join `usuarios` `b` on((`a`.`idUsuario` = `b`.`idUsuario`))) join `viajeros` `c` on((`a`.`idViajero` = `c`.`idViajero`))) join `viajes` `d` on((`a`.`idViaje` = `d`.`idviaje`))) */;
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
/*!50001 VIEW `viajes_view` (`idViaje`,`idViajero`,`Viajero`,`Inicio de Viaje`,`Regreso de Viaje`,`Activo`,`Pais`,`Direccion de Estadia`,`PaisOrigen`,`Cobro`,`Teléfono`,`Foto`,`CantidadViajes`,`CantidadPedidos`,`Calificacion`,`imagenReferencia`) AS select `a`.`idviaje` AS `idViaje`,`b`.`idViajero` AS `idViajero`,`b`.`nombre_completo` AS `Viajero`,`a`.`fecha de inicio` AS `Inicio de Viaje`,`a`.`fecha de regreso` AS `Regreso de viaje`,`a`.`Activo` AS `Activo`,`a`.`Pais Destino` AS `Pais`,`a`.`direccion de estadia` AS `Direccion de Estadia`,`b`.`pais` AS `PaisOrigen`,`a`.`cobro por libra` AS `Cobro`,`a`.`telefono` AS `Telefono`,`b`.`Foto` AS `Foto`,`b`.`CantidadViajes` AS `CantidadViajes`,`b`.`CantidadPedidos` AS `CantidadPedidos`,`b`.`Calificacion` AS `Calificacion`,`a`.`imagen referencia` AS `imagenReferencia` from (`viajes` `a` join `viajeros` `b` on((`a`.`idViajero` = `b`.`idViajero`))) */;
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

-- Dump completed on 2020-08-27 16:21:40
