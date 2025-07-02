-- =====================================================
-- Gol y Cambio - Database Initialization Script
-- =====================================================
-- This script creates the complete database schema and 
-- populates it with essential data for the handball 
-- analysis system to be ready for use.
-- =====================================================

-- Set SQL mode and disable checks for faster execution
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;

-- =====================================================
-- 1. CREATE TABLES
-- =====================================================

-- Users table
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Categories table
CREATE TABLE IF NOT EXISTS `categorias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Positions table
CREATE TABLE IF NOT EXISTS `posiciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `color` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Event categories table
CREATE TABLE IF NOT EXISTS `categorias_evento` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Event types table
CREATE TABLE IF NOT EXISTS `tipo_evento` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Teams table
CREATE TABLE IF NOT EXISTS `equipos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `tipo` enum('masculino','femenino','mixto') NOT NULL DEFAULT 'mixto',
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_equipos_user_id` (`user_id`),
  CONSTRAINT `fk_equipos_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Players table
CREATE TABLE IF NOT EXISTS `jugadores` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Seasons table
CREATE TABLE IF NOT EXISTS `temporada` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_user_proyecto_nombre` (`user_id`,`nombre`),
  CONSTRAINT `temporada_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Leagues table
CREATE TABLE IF NOT EXISTS `liga` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Team-League relationship table
CREATE TABLE IF NOT EXISTS `equipo_liga` (
  `id` int NOT NULL AUTO_INCREMENT,
  `equipo_id` int NOT NULL,
  `liga_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_equipo_liga` (`equipo_id`,`liga_id`),
  KEY `equipo_liga_ibfk_liga` (`liga_id`),
  CONSTRAINT `equipo_liga_ibfk_equipo` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `equipo_liga_ibfk_liga` FOREIGN KEY (`liga_id`) REFERENCES `liga` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Matches table
CREATE TABLE IF NOT EXISTS `partidos` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Videos table
CREATE TABLE IF NOT EXISTS `videos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `partido_id` int NOT NULL,
  `filename` varchar(255) NOT NULL,
  `uploaded_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `duracion_segundos` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_partido_id` (`partido_id`),
  CONSTRAINT `videos_ibfk_1` FOREIGN KEY (`partido_id`) REFERENCES `partidos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Custom events table
CREATE TABLE IF NOT EXISTS `evento_personalizado` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Events table
CREATE TABLE IF NOT EXISTS `eventos` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Called players table
CREATE TABLE IF NOT EXISTS `convocados` (
  `id` int NOT NULL AUTO_INCREMENT,
  `partido_id` int NOT NULL,
  `jugador_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_partido_jugador` (`partido_id`,`jugador_id`),
  KEY `idx_jugador_id` (`jugador_id`),
  CONSTRAINT `convocados_ibfk_1` FOREIGN KEY (`partido_id`) REFERENCES `partidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `convocados_ibfk_2` FOREIGN KEY (`jugador_id`) REFERENCES `jugadores` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Players on court table
CREATE TABLE IF NOT EXISTS `jugadores_en_pista` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Selected events for video table
CREATE TABLE IF NOT EXISTS `eventos_seleccionados_video` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- =====================================================
-- 2. CREATE VIEWS
-- =====================================================

-- View for called players
CREATE OR REPLACE VIEW `vista_convocados` AS 
SELECT 
  `j`.`id` AS `jugador_id`,
  `j`.`nombre` AS `jugador_nombre`,
  `j`.`apellido` AS `jugador_apellido`,
  `j`.`dorsal` AS `jugador_dorsal`,
  `j`.`rol` AS `jugador_rol`,
  `c`.`partido_id` AS `partido_id`,
  `j`.`equipo_id` AS `equipo_id`,
  `e`.`nombre` AS `equipo_nombre`,
  (CASE 
    WHEN (`p`.`equipo_local_id` = `j`.`equipo_id`) THEN 'local' 
    WHEN (`p`.`equipo_visitante_id` = `j`.`equipo_id`) THEN 'visitante' 
    ELSE 'otro' 
  END) AS `tipo_equipo` 
FROM (((`convocados` `c` 
  JOIN `jugadores` `j` ON((`c`.`jugador_id` = `j`.`id`))) 
  JOIN `partidos` `p` ON((`c`.`partido_id` = `p`.`id`))) 
  JOIN `equipos` `e` ON((`j`.`equipo_id` = `e`.`id`)));

-- View for player statistics per match
CREATE OR REPLACE VIEW `v_estadisticas_jugador_partido` AS 
SELECT 
  `p`.`id` AS `partido_id`,
  `p`.`fecha_hora` AS `fecha_partido`,
  `e_local`.`nombre` AS `equipo_local`,
  `e_visitante`.`nombre` AS `equipo_visitante`,
  `j`.`id` AS `jugador_id`,
  CONCAT(`j`.`nombre`,' ',`j`.`apellido`,IFNULL(CONCAT(' (#',`j`.`dorsal`,')'),'')) AS `jugador`,
  `eq`.`nombre` AS `equipo_jugador`,
  CONCAT(SUM((CASE WHEN ((`te`.`id` = 37) AND (`ev`.`resultado_tiro` = 'gol')) THEN 1 ELSE 0 END)),'/',SUM((CASE WHEN (`te`.`id` = 37) THEN 1 ELSE 0 END))) AS `tiros_campo`,
  CONCAT(SUM((CASE WHEN (`te`.`id` = 13) THEN 1 ELSE 0 END)),'/',SUM((CASE WHEN (`te`.`id` = 13) THEN 1 ELSE 0 END))) AS `tiros_7m`,
  SUM((CASE WHEN (`te`.`id` = 30) THEN 1 ELSE 0 END)) AS `perdidas`,
  SUM((CASE WHEN (`te`.`id` = 31) THEN 1 ELSE 0 END)) AS `recuperaciones`,
  SUM((CASE WHEN (`te`.`id` = 4) THEN 1 ELSE 0 END)) AS `faltas_cometidas`,
  SUM((CASE WHEN (`te`.`id` = 5) THEN 1 ELSE 0 END)) AS `faltas_recibidas`,
  SUM((CASE WHEN (`te`.`id` = 32) THEN 1 ELSE 0 END)) AS `asistencias` 
FROM ((((((`eventos` `ev` 
  JOIN `tipo_evento` `te` ON((`ev`.`tipo_evento_id` = `te`.`id`))) 
  JOIN `partidos` `p` ON((`ev`.`partido_id` = `p`.`id`))) 
  JOIN `equipos` `e_local` ON((`p`.`equipo_local_id` = `e_local`.`id`))) 
  JOIN `equipos` `e_visitante` ON((`p`.`equipo_visitante_id` = `e_visitante`.`id`))) 
  JOIN `jugadores` `j` ON((`ev`.`jugador_id` = `j`.`id`))) 
  JOIN `equipos` `eq` ON((`j`.`equipo_id` = `eq`.`id`))) 
WHERE (`ev`.`jugador_id` IS NOT NULL) 
GROUP BY `p`.`id`,`j`.`id` 
ORDER BY `p`.`fecha_hora` DESC,`eq`.`nombre`,`jugador`,`asistencias`;

-- =====================================================
-- 3. INSERT INITIAL DATA
-- =====================================================

-- Insert categories
INSERT INTO `categorias` (`id`, `nombre`, `descripcion`) VALUES
(1, 'Benjamines', 'Categoría para niños y niñas de hasta 10 años.'),
(2, 'Alevines', 'Categoría para niños y niñas de 11 y 12 años.'),
(3, 'Infantiles', 'Categoría para jugadores de 13 y 14 años.'),
(4, 'Cadetes', 'Categoría para jugadores de 15 y 16 años.'),
(5, 'Juveniles', 'Categoría para jugadores de 17 y 18 años.'),
(6, 'Senior', 'Categoría para mayores de 18 años.');

-- Insert positions
INSERT INTO `posiciones` (`id`, `nombre`, `color`) VALUES
(1, 'portero', '#1E90FF'),
(2, 'lateral', '#FF8C00'),
(3, 'central', '#FFD700'),
(4, 'pivote', '#DC143C'),
(5, 'extremo', '#32CD32');

-- Insert event categories
INSERT INTO `categorias_evento` (`id`, `nombre`) VALUES
(1, 'Tiro'),
(2, 'Falta'),
(3, 'Sanción'),
(4, 'Sustitución'),
(5, 'Global'),
(6, 'Táctica'),
(7, '7 Metros'),
(8, 'Paradas'),
(9, 'Perdidas'),
(10, 'Defensa'),
(11, 'Asistencias');

-- Insert event types
INSERT INTO `tipo_evento` (`id`, `nombre`, `es_equipo`, `es_global`, `es_jugador`, `categoria_evento_id`) VALUES
(4, 'Falta cometida', 0, 0, 1, 2),
(5, 'Exclusión 2 minutos', 0, 0, 1, 3),
(6, 'Entra en pista', 0, 0, 1, 4),
(7, 'Sale de pista', 0, 0, 1, 4),
(8, 'Inicio primer tiempo', 0, 1, 0, 5),
(9, 'Fin primer tiempo', 0, 1, 0, 5),
(10, 'Tiempo muerto', 1, 0, 0, 6),
(11, 'Fin sanción 2 minutos', 0, 0, 1, 3),
(12, 'Falta Recibida', 0, 0, 1, 2),
(13, 'Gol 7 metros', 0, 0, 1, 7),
(14, 'Tiro fallido 7 metros', 0, 0, 1, 7),
(15, 'Tiro parado 7 metros', 0, 0, 1, 7),
(16, 'Comete 7 metros', 0, 0, 1, 2),
(17, 'Inicio segunda parte', 0, 1, 0, 5),
(18, 'Fin segunda parte', 0, 1, 0, 5),
(19, 'Inicio prórroga', 0, 1, 0, 5),
(20, 'Fin prórroga', 0, 1, 0, 5),
(23, 'Final del partido', 0, 1, 0, 5),
(28, 'Parada', 0, 0, 1, 8),
(29, 'Parada 7 metros', 0, 0, 1, 8),
(30, 'Pérdida', 0, 0, 1, 9),
(31, 'Recuperación', 0, 0, 1, 10),
(32, 'Asistencia de gol', 0, 0, 0, 11),
(33, 'Tarjeta Roja', 0, 0, 1, 3),
(34, 'Tarjeta Amarilla', 0, 0, 1, 3),
(35, 'Porteria Vacia (7 J.)', 1, 0, 0, 6),
(36, 'Porteria Vacia (6 J.)', 1, 0, 0, 6),
(37, 'Tiro', 0, 0, 1, 1),
(38, 'Tiro bloqueado', 0, 0, 1, 10),
(39, 'Sustitucion ilegal', 0, 0, 1, 3),
(40, 'Asistencia para Fly', 0, 0, 1, 11);

-- Create demo user (password: demo123)
INSERT INTO `users` (`id`, `username`, `password`) VALUES
(1, 'demo', 'sha256$demo$5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8');

-- =====================================================
-- 4. RESTORE SETTINGS
-- =====================================================

-- Restore SQL settings
SET FOREIGN_KEY_CHECKS = 1;
SET UNIQUE_CHECKS = 1;

-- =====================================================
-- INITIALIZATION COMPLETE
-- =====================================================
-- Database is now ready for the Gol y Cambio system
-- Default user: demo / demo123
-- =====================================================
