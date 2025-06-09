-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: gol_y_cambio_v2
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `categorias_evento`
--

DROP TABLE IF EXISTS `categorias_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias_evento` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `convocados`
--

DROP TABLE IF EXISTS `convocados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `convocados` (
  `id` int NOT NULL AUTO_INCREMENT,
  `partido_id` int NOT NULL,
  `jugador_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_partido_jugador` (`partido_id`,`jugador_id`),
  KEY `idx_jugador_id` (`jugador_id`),
  CONSTRAINT `convocados_ibfk_1` FOREIGN KEY (`partido_id`) REFERENCES `partidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `convocados_ibfk_2` FOREIGN KEY (`jugador_id`) REFERENCES `jugadores` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=375 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `equipo_liga`
--

DROP TABLE IF EXISTS `equipo_liga`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipo_liga` (
  `id` int NOT NULL AUTO_INCREMENT,
  `equipo_id` int NOT NULL,
  `liga_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_equipo_liga` (`equipo_id`,`liga_id`),
  KEY `equipo_liga_ibfk_liga` (`liga_id`),
  CONSTRAINT `equipo_liga_ibfk_equipo` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `equipo_liga_ibfk_liga` FOREIGN KEY (`liga_id`) REFERENCES `liga` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `equipos`
--

DROP TABLE IF EXISTS `equipos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `tipo` enum('masculino','femenino','mixto') NOT NULL DEFAULT 'mixto',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_equipo_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `evento_personalizado`
--

DROP TABLE IF EXISTS `evento_personalizado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evento_personalizado` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `categoria_evento_id` int NOT NULL,
  `es_equipo` tinyint(1) DEFAULT '0',
  `es_global` tinyint(1) DEFAULT '0',
  `es_jugador` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `estadistica_tipo` enum('gol','falta','perdida','recuperacion') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_evento_personalizado_usuario` (`user_id`,`nombre`),
  KEY `categoria_evento_id` (`categoria_evento_id`),
  CONSTRAINT `evento_personalizado_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `evento_personalizado_ibfk_2` FOREIGN KEY (`categoria_evento_id`) REFERENCES `categorias_evento` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eventos`
--

DROP TABLE IF EXISTS `eventos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eventos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `video_id` int NOT NULL,
  `tiempo_seg` int NOT NULL,
  `tipo_evento_id` int DEFAULT NULL,
  `partido_id` int NOT NULL,
  `equipo_id` int DEFAULT NULL,
  `jugador_id` int DEFAULT NULL,
  `descripcion` text,
  `evento_personalizado_id` int DEFAULT NULL,
  `zona_tiro` varchar(20) DEFAULT NULL,
  `resultado_tiro` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_video_id` (`video_id`),
  KEY `idx_tipo_evento_id` (`tipo_evento_id`),
  KEY `idx_partido_id` (`partido_id`),
  KEY `idx_equipo_id` (`equipo_id`),
  KEY `idx_jugador_id` (`jugador_id`),
  KEY `fk_eventos_evento_personalizado` (`evento_personalizado_id`),
  CONSTRAINT `eventos_ibfk_equipo` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`) ON DELETE SET NULL,
  CONSTRAINT `eventos_ibfk_jugador` FOREIGN KEY (`jugador_id`) REFERENCES `jugadores` (`id`) ON DELETE SET NULL,
  CONSTRAINT `eventos_ibfk_partido` FOREIGN KEY (`partido_id`) REFERENCES `partidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `eventos_ibfk_tipo_evento` FOREIGN KEY (`tipo_evento_id`) REFERENCES `tipo_evento` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `eventos_ibfk_video` FOREIGN KEY (`video_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_eventos_evento_personalizado` FOREIGN KEY (`evento_personalizado_id`) REFERENCES `evento_personalizado` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ck_un_solo_tipo_evento` CHECK ((((`tipo_evento_id` is not null) and (`evento_personalizado_id` is null)) or ((`tipo_evento_id` is null) and (`evento_personalizado_id` is not null))))
) ENGINE=InnoDB AUTO_INCREMENT=220 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `eventos_seleccionados_video`
--

DROP TABLE IF EXISTS `eventos_seleccionados_video`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eventos_seleccionados_video` (
  `id` int NOT NULL AUTO_INCREMENT,
  `video_id` int NOT NULL,
  `user_id` int NOT NULL,
  `tipo_evento_id` int DEFAULT NULL,
  `evento_personalizado_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_video_evento_usuario` (`video_id`,`user_id`,`tipo_evento_id`,`evento_personalizado_id`),
  KEY `fk_esv_user` (`user_id`),
  KEY `fk_esv_tipo_evento` (`tipo_evento_id`),
  KEY `fk_esv_evento_personalizado` (`evento_personalizado_id`),
  CONSTRAINT `fk_esv_evento_personalizado` FOREIGN KEY (`evento_personalizado_id`) REFERENCES `evento_personalizado` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_esv_tipo_evento` FOREIGN KEY (`tipo_evento_id`) REFERENCES `tipo_evento` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_esv_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_esv_video` FOREIGN KEY (`video_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `eventos_seleccionados_video_chk_1` CHECK ((((`tipo_evento_id` is not null) and (`evento_personalizado_id` is null)) or ((`tipo_evento_id` is null) and (`evento_personalizado_id` is not null))))
) ENGINE=InnoDB AUTO_INCREMENT=423 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jugadores`
--

DROP TABLE IF EXISTS `jugadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jugadores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `dorsal` int DEFAULT NULL,
  `rol` enum('jugador','entrenador') NOT NULL DEFAULT 'jugador',
  `equipo_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `es_capitan` tinyint(1) DEFAULT '0',
  `posicion_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `equipo_id` (`equipo_id`),
  KEY `fk_posicion` (`posicion_id`),
  CONSTRAINT `fk_posicion` FOREIGN KEY (`posicion_id`) REFERENCES `posiciones` (`id`) ON DELETE SET NULL,
  CONSTRAINT `jugadores_ibfk_1` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jugadores_en_pista`
--

DROP TABLE IF EXISTS `jugadores_en_pista`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jugadores_en_pista` (
  `id` int NOT NULL AUTO_INCREMENT,
  `partido_id` int NOT NULL,
  `jugador_id` int NOT NULL,
  `equipo_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_jugador_pista_entrada` (`partido_id`,`jugador_id`),
  KEY `jugador_id` (`jugador_id`),
  KEY `equipo_id` (`equipo_id`),
  CONSTRAINT `jugadores_en_pista_ibfk_1` FOREIGN KEY (`partido_id`) REFERENCES `partidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `jugadores_en_pista_ibfk_2` FOREIGN KEY (`jugador_id`) REFERENCES `jugadores` (`id`) ON DELETE CASCADE,
  CONSTRAINT `jugadores_en_pista_ibfk_3` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `liga`
--

DROP TABLE IF EXISTS `liga`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `liga` (
  `id` int NOT NULL AUTO_INCREMENT,
  `temporada_id` int NOT NULL,
  `categoria_id` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_temporada_liga_nombre` (`temporada_id`,`nombre`),
  KEY `liga_ibfk_categoria` (`categoria_id`),
  CONSTRAINT `liga_ibfk_categoria` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `liga_ibfk_temporada` FOREIGN KEY (`temporada_id`) REFERENCES `temporada` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `partidos`
--

DROP TABLE IF EXISTS `partidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `partidos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `liga_id` int NOT NULL,
  `fecha_hora` datetime NOT NULL,
  `equipo_local_id` int DEFAULT NULL,
  `equipo_visitante_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `goles_local` int DEFAULT NULL,
  `goles_visitante` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_equipo_local_id` (`equipo_local_id`),
  KEY `idx_equipo_visitante_id` (`equipo_visitante_id`),
  KEY `partidos_ibfk_liga` (`liga_id`),
  CONSTRAINT `partidos_ibfk_2` FOREIGN KEY (`equipo_local_id`) REFERENCES `equipos` (`id`) ON DELETE SET NULL,
  CONSTRAINT `partidos_ibfk_3` FOREIGN KEY (`equipo_visitante_id`) REFERENCES `equipos` (`id`) ON DELETE SET NULL,
  CONSTRAINT `partidos_ibfk_liga` FOREIGN KEY (`liga_id`) REFERENCES `liga` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `posiciones`
--

DROP TABLE IF EXISTS `posiciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posiciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `color` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `temporada`
--

DROP TABLE IF EXISTS `temporada`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temporada` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_user_proyecto_nombre` (`user_id`,`nombre`),
  CONSTRAINT `temporada_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tipo_evento`
--

DROP TABLE IF EXISTS `tipo_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_evento` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `es_equipo` tinyint(1) NOT NULL DEFAULT '0',
  `es_global` tinyint(1) NOT NULL DEFAULT '0',
  `es_jugador` tinyint(1) NOT NULL DEFAULT '0',
  `categoria_evento_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_nombre` (`nombre`),
  KEY `fk_categoria_evento` (`categoria_evento_id`),
  CONSTRAINT `fk_categoria_evento` FOREIGN KEY (`categoria_evento_id`) REFERENCES `categorias_evento` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `v_estadisticas_jugador_partido`
--

DROP TABLE IF EXISTS `v_estadisticas_jugador_partido`;
/*!50001 DROP VIEW IF EXISTS `v_estadisticas_jugador_partido`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_estadisticas_jugador_partido` AS SELECT 
 1 AS `partido_id`,
 1 AS `fecha_partido`,
 1 AS `equipo_local`,
 1 AS `equipo_visitante`,
 1 AS `jugador_id`,
 1 AS `jugador`,
 1 AS `equipo_jugador`,
 1 AS `tiros_campo`,
 1 AS `tiros_7m`,
 1 AS `perdidas`,
 1 AS `recuperaciones`,
 1 AS `faltas_cometidas`,
 1 AS `faltas_recibidas`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `videos`
--

DROP TABLE IF EXISTS `videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `videos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `partido_id` int NOT NULL,
  `filename` varchar(255) NOT NULL,
  `uploaded_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `duracion_segundos` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_partido_id` (`partido_id`),
  CONSTRAINT `videos_ibfk_1` FOREIGN KEY (`partido_id`) REFERENCES `partidos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `vista_convocados`
--

DROP TABLE IF EXISTS `vista_convocados`;
/*!50001 DROP VIEW IF EXISTS `vista_convocados`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_convocados` AS SELECT 
 1 AS `jugador_id`,
 1 AS `jugador_nombre`,
 1 AS `jugador_apellido`,
 1 AS `jugador_dorsal`,
 1 AS `jugador_rol`,
 1 AS `partido_id`,
 1 AS `equipo_id`,
 1 AS `equipo_nombre`,
 1 AS `tipo_equipo`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_estadisticas_jugador_partido`
--

/*!50001 DROP VIEW IF EXISTS `v_estadisticas_jugador_partido`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_estadisticas_jugador_partido` AS select `p`.`id` AS `partido_id`,`p`.`fecha_hora` AS `fecha_partido`,`e_local`.`nombre` AS `equipo_local`,`e_visitante`.`nombre` AS `equipo_visitante`,`j`.`id` AS `jugador_id`,concat(`j`.`nombre`,' ',`j`.`apellido`,ifnull(concat(' (#',`j`.`dorsal`,')'),'')) AS `jugador`,`eq`.`nombre` AS `equipo_jugador`,concat(sum((case when (`te`.`nombre` = 'Gol') then 1 else 0 end)),'/',sum((case when (`te`.`nombre` in ('Gol','Tiro fallido','Tiro parado')) then 1 else 0 end))) AS `tiros_campo`,concat(sum((case when (`te`.`nombre` = 'Gol 7 metros') then 1 else 0 end)),'/',sum((case when (`te`.`nombre` in ('Gol 7 metros','Tiro fallido 7 metros','Tiro parado 7 metros')) then 1 else 0 end))) AS `tiros_7m`,sum((case when (`te`.`nombre` = 'Pérdida') then 1 else 0 end)) AS `perdidas`,sum((case when (`te`.`nombre` = 'Recuperación') then 1 else 0 end)) AS `recuperaciones`,sum((case when (`te`.`nombre` = 'Falta cometida') then 1 else 0 end)) AS `faltas_cometidas`,sum((case when (`te`.`nombre` = 'Falta recibida') then 1 else 0 end)) AS `faltas_recibidas` from ((((((`eventos` `ev` join `tipo_evento` `te` on((`ev`.`tipo_evento_id` = `te`.`id`))) join `partidos` `p` on((`ev`.`partido_id` = `p`.`id`))) join `equipos` `e_local` on((`p`.`equipo_local_id` = `e_local`.`id`))) join `equipos` `e_visitante` on((`p`.`equipo_visitante_id` = `e_visitante`.`id`))) join `jugadores` `j` on((`ev`.`jugador_id` = `j`.`id`))) join `equipos` `eq` on((`j`.`equipo_id` = `eq`.`id`))) group by `p`.`id`,`j`.`id` order by `p`.`fecha_hora` desc,`eq`.`nombre`,`jugador` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_convocados`
--

/*!50001 DROP VIEW IF EXISTS `vista_convocados`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_convocados` AS select `j`.`id` AS `jugador_id`,`j`.`nombre` AS `jugador_nombre`,`j`.`apellido` AS `jugador_apellido`,`j`.`dorsal` AS `jugador_dorsal`,`j`.`rol` AS `jugador_rol`,`c`.`partido_id` AS `partido_id`,`j`.`equipo_id` AS `equipo_id`,`e`.`nombre` AS `equipo_nombre`,(case when (`p`.`equipo_local_id` = `j`.`equipo_id`) then 'local' when (`p`.`equipo_visitante_id` = `j`.`equipo_id`) then 'visitante' else 'otro' end) AS `tipo_equipo` from (((`convocados` `c` join `jugadores` `j` on((`c`.`jugador_id` = `j`.`id`))) join `partidos` `p` on((`c`.`partido_id` = `p`.`id`))) join `equipos` `e` on((`j`.`equipo_id` = `e`.`id`))) */;
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

-- Dump completed on 2025-06-06 12:00:19
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: gol_y_cambio_v2
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (1,'Benjamines','Categoría para niños y niñas de hasta 10 años.','2025-01-08 16:49:15'),(2,'Alevines','Categoría para niños y niñas de 11 y 12 años.','2025-01-08 16:49:15'),(3,'Infantiles','Categoría para jugadores de 13 y 14 años.','2025-01-08 16:49:15'),(4,'Cadetes','Categoría para jugadores de 15 y 16 años.','2025-01-08 16:49:15'),(5,'Juveniles','Categoría para jugadores de 17 y 18 años.','2025-01-08 16:49:15'),(6,'Senior','Categoría para mayores de 18 años.','2025-01-08 16:49:15');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `categorias_evento`
--

LOCK TABLES `categorias_evento` WRITE;
/*!40000 ALTER TABLE `categorias_evento` DISABLE KEYS */;
INSERT INTO `categorias_evento` VALUES (7,'7 Metros'),(11,'Asistencias'),(10,'Defensa'),(2,'Falta'),(5,'Global'),(8,'Paradas'),(9,'Perdidas'),(3,'Sanción'),(4,'Sustitución'),(6,'Táctica'),(1,'Tiro');
/*!40000 ALTER TABLE `categorias_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tipo_evento`
--

LOCK TABLES `tipo_evento` WRITE;
/*!40000 ALTER TABLE `tipo_evento` DISABLE KEYS */;
INSERT INTO `tipo_evento` VALUES (4,'Falta cometida',0,0,1,2),(5,'Exclusión 2 minutos',0,0,1,3),(6,'Entra en pista',0,0,1,4),(7,'Sale de pista',0,0,1,4),(8,'Inicio primer tiempo',0,1,0,5),(9,'Fin primer tiempo',0,1,0,5),(10,'Tiempo muerto',1,0,0,6),(11,'Fin sanción 2 minutos',0,0,1,3),(12,'Falta Recibida',0,0,1,2),(13,'Gol 7 metros',0,0,1,7),(14,'Tiro fallido 7 metros',0,0,1,7),(15,'Tiro parado 7 metros',0,0,1,7),(16,'Comete 7 metros',0,0,1,2),(17,'Inicio segunda parte',0,1,0,5),(18,'Fin segunda parte',0,1,0,5),(19,'Inicio prórroga',0,1,0,5),(20,'Fin prórroga',0,1,0,5),(23,'Final del partido',0,1,0,5),(28,'Parada',0,0,1,8),(29,'Parada 7 metros',0,0,1,8),(30,'Pérdida',0,0,1,9),(31,'Recuperación',0,0,1,10),(32,'Asistencia de gol',0,0,0,11),(33,'Tarjeta Roja',0,0,1,3),(34,'Tarjeta Amarilla',0,0,1,3),(35,'Porteria Vacia (7 J.)',1,0,0,6),(36,'Porteria Vacia (6 J.)',1,0,0,6),(37,'Tiro',0,0,1,1),(38,'Tiro bloqueado',0,0,1,10),(39,'Sustitucion ilegal',0,0,1,3),(40,'Asistencia para Fly',0,0,1,11);
/*!40000 ALTER TABLE `tipo_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'merino','sha256$p8XwPn3K7kAkhCi3$706df36f13d917e3764c3b0db0d613ac1a6a3479ec7c28a83ed6586131635dba','2024-12-05 13:24:50'),(8,'merino1','sha256$8UdtLTew3FDb7HPA$0913719a79d0342fe69664bed3e67b23e3ff304075eae6eebca03b2a7581c8e0','2025-04-01 20:56:02'),(9,'test1','sha256$NSpOe5aRqVObXX64$41d4b3ac8c59ee655311de2bd7c348d3679a1c4d69b3d595518424c30a0ee3b1','2025-05-16 11:36:29'),(10,'TEST2','sha256$zoAx4mEAaopLBwtA$832b30796da381c7f536050ca42103917ea05dfb2e8889f62f4c7fe5cc87cdff','2025-05-27 09:57:25');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;


LOCK TABLES `posiciones` WRITE;
/*!40000 ALTER TABLE `posiciones` DISABLE KEYS */;
INSERT INTO `posiciones` VALUES (1,'portero','#1E90FF'),(2,'lateral','#FF8C00'),(3,'central','#FFD700'),(4,'pivote','#DC143C'),(5,'extremo','#32CD32');
/*!40000 ALTER TABLE `posiciones` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-06 12:03:18


-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: gol_y_cambio_v2
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (1,'Benjamines','Categoría para niños y niñas de hasta 10 años.','2025-01-08 16:49:15'),(2,'Alevines','Categoría para niños y niñas de 11 y 12 años.','2025-01-08 16:49:15'),(3,'Infantiles','Categoría para jugadores de 13 y 14 años.','2025-01-08 16:49:15'),(4,'Cadetes','Categoría para jugadores de 15 y 16 años.','2025-01-08 16:49:15'),(5,'Juveniles','Categoría para jugadores de 17 y 18 años.','2025-01-08 16:49:15'),(6,'Senior','Categoría para mayores de 18 años.','2025-01-08 16:49:15');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `categorias_evento`
--

LOCK TABLES `categorias_evento` WRITE;
/*!40000 ALTER TABLE `categorias_evento` DISABLE KEYS */;
INSERT INTO `categorias_evento` VALUES (7,'7 Metros'),(11,'Asistencias'),(10,'Defensa'),(2,'Falta'),(5,'Global'),(8,'Paradas'),(9,'Perdidas'),(3,'Sanción'),(4,'Sustitución'),(6,'Táctica'),(1,'Tiro');
/*!40000 ALTER TABLE `categorias_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tipo_evento`
--

LOCK TABLES `tipo_evento` WRITE;
/*!40000 ALTER TABLE `tipo_evento` DISABLE KEYS */;
INSERT INTO `tipo_evento` VALUES (4,'Falta cometida',0,0,1,2),(5,'Exclusión 2 minutos',0,0,1,3),(6,'Entra en pista',0,0,1,4),(7,'Sale de pista',0,0,1,4),(8,'Inicio primer tiempo',0,1,0,5),(9,'Fin primer tiempo',0,1,0,5),(10,'Tiempo muerto',1,0,0,6),(11,'Fin sanción 2 minutos',0,0,1,3),(12,'Falta Recibida',0,0,1,2),(13,'Gol 7 metros',0,0,1,7),(14,'Tiro fallido 7 metros',0,0,1,7),(15,'Tiro parado 7 metros',0,0,1,7),(16,'Comete 7 metros',0,0,1,2),(17,'Inicio segunda parte',0,1,0,5),(18,'Fin segunda parte',0,1,0,5),(19,'Inicio prórroga',0,1,0,5),(20,'Fin prórroga',0,1,0,5),(23,'Final del partido',0,1,0,5),(28,'Parada',0,0,1,8),(29,'Parada 7 metros',0,0,1,8),(30,'Pérdida',0,0,1,9),(31,'Recuperación',0,0,1,10),(32,'Asistencia de gol',0,0,0,11),(33,'Tarjeta Roja',0,0,1,3),(34,'Tarjeta Amarilla',0,0,1,3),(35,'Porteria Vacia (7 J.)',1,0,0,6),(36,'Porteria Vacia (6 J.)',1,0,0,6),(37,'Tiro',0,0,1,1),(38,'Tiro bloqueado',0,0,1,10),(39,'Sustitucion ilegal',0,0,1,3),(40,'Asistencia para Fly',0,0,1,11);
/*!40000 ALTER TABLE `tipo_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'merino','sha256$p8XwPn3K7kAkhCi3$706df36f13d917e3764c3b0db0d613ac1a6a3479ec7c28a83ed6586131635dba','2024-12-05 13:24:50'),(8,'merino1','sha256$8UdtLTew3FDb7HPA$0913719a79d0342fe69664bed3e67b23e3ff304075eae6eebca03b2a7581c8e0','2025-04-01 20:56:02'),(9,'test1','sha256$NSpOe5aRqVObXX64$41d4b3ac8c59ee655311de2bd7c348d3679a1c4d69b3d595518424c30a0ee3b1','2025-05-16 11:36:29'),(10,'TEST2','sha256$zoAx4mEAaopLBwtA$832b30796da381c7f536050ca42103917ea05dfb2e8889f62f4c7fe5cc87cdff','2025-05-27 09:57:25');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-06 12:03:18

