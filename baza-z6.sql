/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.4.13-MariaDB, for linux-systemd (x86_64)
--
-- Host: localhost    Database: srv126086_z6
-- ------------------------------------------------------
-- Server version	11.4.13-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `z6_break_ins`
--

DROP TABLE IF EXISTS `z6_break_ins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `z6_break_ins` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(128) NOT NULL,
  `ipaddress` varchar(45) NOT NULL,
  `datetime` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_time` (`username`,`datetime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `z6_break_ins`
--

LOCK TABLES `z6_break_ins` WRITE;
/*!40000 ALTER TABLE `z6_break_ins` DISABLE KEYS */;
/*!40000 ALTER TABLE `z6_break_ins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `z6_domeny`
--

DROP TABLE IF EXISTS `z6_domeny`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `z6_domeny` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `host` text NOT NULL,
  `port` int(11) NOT NULL,
  `user_id` smallint(6) NOT NULL,
  `errors` int(11) NOT NULL DEFAULT 0,
  `total_errors` int(11) NOT NULL DEFAULT 0,
  `failure` datetime DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `detail` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `service_owner` (`user_id`,`host`(190),`port`),
  CONSTRAINT `z6_domeny_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `z6_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `z6_domeny`
--

LOCK TABLES `z6_domeny` WRITE;
/*!40000 ALTER TABLE `z6_domeny` DISABLE KEYS */;
INSERT INTO `z6_domeny` VALUES
(1,'srv126086.seohost.com.pl',80,1,0,0,NULL,'2026-10-23 15:48:20','ok','Połączenie TCP poprawne.'),
(2,'srv126086.seohost.com.pl',443,1,0,0,NULL,'2026-10-23 15:48:20','ok','Połączenie TCP poprawne.'),
(3,'nieistniejacy.invalid',80,1,26,26,'2026-10-12 12:56:28','2026-10-23 15:48:20','failure','Nieistniejąca domena testowa.'),
(8,'example.invalid',443,1,14,14,'2026-10-12 13:02:30','2026-10-23 15:48:20','failure','Nieistniejąca domena testowa.'),
(9,'srv126086.seohost.com.pl',443,2,0,0,NULL,'2026-10-23 15:48:20','ok','Połączenie TCP poprawne.'),
(10,'przydzial.invalid',443,28,4,4,'2026-10-12 13:04:56','2026-10-23 15:48:20','failure','Nieistniejąca domena testowa.'),
(13,'grad.pl',443,31,1,1,'2026-10-23 15:48:20','2026-10-23 15:48:20','failure','Nie można rozwiązać nazwy DNS.'),
(14,'pbs.edu.pl',443,31,0,0,NULL,'2026-10-23 15:48:20','ok','Połączenie TCP poprawne.'),
(15,'qurka.vodna',443,31,13,13,'2026-10-15 10:54:06','2026-10-23 15:48:20','failure','Nie można rozwiązać nazwy DNS.');
/*!40000 ALTER TABLE `z6_domeny` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `z6_goscieportalu`
--

DROP TABLE IF EXISTS `z6_goscieportalu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `z6_goscieportalu` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ipaddress` varchar(45) NOT NULL,
  `datetime` datetime NOT NULL,
  `event_type` varchar(16) NOT NULL DEFAULT 'visit',
  `page` varchar(200) NOT NULL,
  `username` varchar(128) DEFAULT NULL,
  `user_agent` varchar(1024) NOT NULL,
  `browser` varchar(120) DEFAULT NULL,
  `operating_system` varchar(120) DEFAULT NULL,
  `screen_width` int(10) unsigned DEFAULT NULL,
  `screen_height` int(10) unsigned DEFAULT NULL,
  `window_width` int(10) unsigned DEFAULT NULL,
  `window_height` int(10) unsigned DEFAULT NULL,
  `color_depth` tinyint(3) unsigned DEFAULT NULL,
  `cookies_enabled` tinyint(4) DEFAULT NULL,
  `java_enabled` tinyint(4) DEFAULT NULL,
  `language` varchar(35) DEFAULT NULL,
  `pixel_ratio` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `visit_ip` (`ipaddress`),
  KEY `visit_time` (`datetime`),
  KEY `visit_event` (`event_type`)
) ENGINE=InnoDB AUTO_INCREMENT=808 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `z6_goscieportalu`
--

LOCK TABLES `z6_goscieportalu` WRITE;
/*!40000 ALTER TABLE `z6_goscieportalu` DISABLE KEYS */;
INSERT INTO `z6_goscieportalu` VALUES
(1,'91.236.131.92','2026-10-19 12:18:24','visit','/z6/index3.php',NULL,'curl/7.76.1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(2,'93.159.60.249','2026-10-19 12:18:48','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(3,'93.159.60.249','2026-10-19 12:18:51','login','/z6/weryfikuj3.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(4,'93.159.60.249','2026-10-19 12:18:51','visit','/z6/index4.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(5,'93.159.60.249','2026-10-19 12:18:57','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(6,'93.159.60.249','2026-10-19 12:18:58','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(7,'93.159.60.249','2026-10-19 12:19:02','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(8,'93.159.60.249','2026-10-19 12:19:11','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(9,'93.159.60.249','2026-10-19 12:19:13','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(10,'93.159.60.249','2026-10-19 12:19:15','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(11,'93.159.60.249','2026-10-19 12:19:49','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(12,'93.159.60.249','2026-10-19 12:19:53','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(13,'93.159.60.249','2026-10-19 12:20:05','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(14,'93.159.60.249','2026-10-19 12:20:07','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(15,'93.159.60.249','2026-10-19 12:20:21','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(16,'93.159.60.249','2026-10-19 12:20:54','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(17,'93.159.60.249','2026-10-19 12:20:57','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(18,'93.159.60.249','2026-10-19 12:21:09','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(19,'93.159.60.249','2026-10-19 12:22:18','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(20,'93.159.60.249','2026-10-19 12:22:20','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(21,'93.159.60.249','2026-10-19 12:22:38','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(22,'93.159.60.249','2026-10-19 12:22:44','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(23,'93.159.60.249','2026-10-19 12:22:46','visit','/z6/select.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(24,'93.159.60.249','2026-10-19 12:22:52','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(25,'93.159.60.249','2026-10-19 12:22:54','visit','/z6/select.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(26,'91.236.131.92','2026-10-19 12:24:11','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(27,'91.236.131.92','2026-10-19 12:24:11','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(30,'93.159.60.249','2026-10-19 12:24:31','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(31,'91.236.131.92','2026-10-19 12:24:35','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(32,'91.236.131.92','2026-10-19 12:24:36','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(38,'91.236.131.92','2026-10-19 12:24:36','visit','/z6/rejestruj.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(39,'91.236.131.92','2026-10-19 12:24:36','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(45,'91.236.131.92','2026-10-19 12:24:37','visit','/z6/rejestruj.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(46,'91.236.131.92','2026-10-19 12:24:37','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(76,'91.236.131.92','2026-10-19 12:24:44','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(77,'91.236.131.92','2026-10-19 12:24:44','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(78,'91.236.131.92','2026-10-19 12:24:44','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(79,'93.159.60.249','2026-10-19 12:26:20','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(80,'93.159.60.249','2026-10-19 12:26:24','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(81,'93.159.60.249','2026-10-19 12:26:29','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(82,'93.159.60.249','2026-10-19 12:26:31','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(83,'93.159.60.249','2026-10-19 12:26:34','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(84,'93.159.60.249','2026-10-19 12:26:35','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(85,'93.159.60.249','2026-10-19 12:26:42','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(86,'91.236.131.92','2026-10-19 12:26:50','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36','Chrome Headless 156.0.0.0','Linux',1280,900,1280,900,24,1,0,'en-US',1.00),
(91,'93.159.60.249','2026-10-19 12:26:57','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(92,'91.236.131.92','2026-10-19 12:27:39','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36','Chrome Headless 156.0.0.0','Linux',1280,900,1280,900,24,1,0,'en-US',1.00),
(93,'93.159.60.249','2026-10-19 12:27:39','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(98,'91.236.131.92','2026-10-19 12:27:40','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36','Chrome Headless 156.0.0.0','Linux',390,900,390,900,24,1,0,'en-US',1.00),
(99,'93.159.60.249','2026-10-19 12:27:43','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(100,'93.159.60.249','2026-10-19 12:27:49','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(101,'93.159.60.249','2026-10-19 12:27:51','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(102,'93.159.60.249','2026-10-19 12:27:52','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(103,'93.159.60.249','2026-10-19 12:28:03','visit','/z6/song.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(104,'93.159.60.249','2026-10-19 12:29:47','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(105,'93.159.60.249','2026-10-19 12:30:02','visit','/z6/select.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(106,'93.159.60.249','2026-10-19 12:30:04','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(107,'93.159.60.249','2026-10-19 12:30:05','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(108,'93.159.60.249','2026-10-19 12:30:09','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(109,'91.236.131.92','2026-10-19 12:30:20','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36','Chrome Headless 156.0.0.0','Linux',1280,900,1280,900,24,1,0,'en-US',1.00),
(114,'91.236.131.92','2026-10-19 12:30:21','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36','Chrome Headless 156.0.0.0','Linux',390,844,390,844,24,1,0,'en-US',1.00),
(115,'93.159.60.249','2026-10-19 12:31:13','visit','/z6/song.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(116,'93.159.60.249','2026-10-19 12:31:42','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(117,'93.159.60.249','2026-10-19 12:33:48','visit','/z6/select.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(118,'93.159.60.249','2026-10-19 12:33:49','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(119,'93.159.60.249','2026-10-19 12:33:50','visit','/z6/select.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(120,'93.159.60.249','2026-10-19 12:34:14','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(121,'93.159.60.249','2026-10-19 12:34:19','visit','/z6/song.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(122,'93.159.60.249','2026-10-19 12:34:45','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(123,'93.159.60.249','2026-10-19 12:34:47','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(124,'93.159.60.249','2026-10-19 12:37:30','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(125,'93.159.60.249','2026-10-19 12:39:32','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(126,'93.159.60.249','2026-10-19 12:42:28','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(127,'93.159.60.249','2026-10-19 12:43:45','visit','/z6/song.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(128,'93.159.60.249','2026-10-19 12:44:20','visit','/z6/song_edit.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(129,'93.159.60.249','2026-10-19 12:44:26','visit','/z6/song.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(130,'93.159.60.249','2026-10-19 12:44:44','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(131,'93.159.60.249','2026-10-19 12:45:01','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(132,'93.159.60.249','2026-10-19 12:45:04','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(133,'93.159.60.249','2026-10-19 12:45:18','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(134,'93.159.60.249','2026-10-19 12:45:19','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(135,'93.159.60.249','2026-10-19 12:45:40','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(136,'93.159.60.249','2026-10-19 12:45:41','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(137,'93.159.60.249','2026-10-19 12:46:07','visit','/z6/song.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(138,'93.159.60.249','2026-10-19 12:46:16','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(139,'93.159.60.249','2026-10-19 12:46:24','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(140,'93.159.60.249','2026-10-19 12:46:27','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(141,'93.159.60.249','2026-10-19 12:46:29','visit','/z6/song.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(142,'91.236.131.92','2026-10-19 12:46:50','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(143,'91.236.131.92','2026-10-19 12:46:50','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(146,'91.236.131.92','2026-10-19 12:46:50','visit','/z6/rejestruj.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(147,'91.236.131.92','2026-10-19 12:46:50','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(150,'91.236.131.92','2026-10-19 12:46:52','visit','/z6/rejestruj.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(151,'91.236.131.92','2026-10-19 12:46:52','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(191,'91.236.131.92','2026-10-19 12:47:43','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(192,'91.236.131.92','2026-10-19 12:47:43','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(195,'91.236.131.92','2026-10-19 12:47:43','visit','/z6/rejestruj.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(196,'91.236.131.92','2026-10-19 12:47:44','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(199,'91.236.131.92','2026-10-19 12:47:44','visit','/z6/rejestruj.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(200,'91.236.131.92','2026-10-19 12:47:44','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(240,'93.159.60.249','2026-10-19 12:48:14','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(241,'93.159.60.249','2026-10-19 12:48:16','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(242,'91.236.131.92','2026-10-19 12:48:53','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(243,'91.236.131.92','2026-10-19 12:48:53','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(246,'91.236.131.92','2026-10-19 12:48:54','visit','/z6/rejestruj.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(247,'91.236.131.92','2026-10-19 12:48:54','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(250,'91.236.131.92','2026-10-19 12:48:54','visit','/z6/rejestruj.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(251,'91.236.131.92','2026-10-19 12:48:54','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(291,'91.236.131.92','2026-10-19 12:49:01','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(292,'91.236.131.92','2026-10-19 12:49:01','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(293,'91.236.131.92','2026-10-19 12:49:01','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(294,'93.159.60.249','2026-10-19 12:49:19','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(295,'93.159.60.249','2026-10-19 12:49:36','visit','/z6/song.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(296,'93.159.60.249','2026-10-19 12:49:39','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(297,'93.159.60.249','2026-10-19 12:49:44','visit','/z6/song.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(298,'93.159.60.249','2026-10-19 12:49:45','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(299,'93.159.60.249','2026-10-19 12:50:53','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(300,'93.159.60.249','2026-10-19 12:50:54','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(301,'93.159.60.249','2026-10-19 12:51:10','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(302,'91.236.131.92','2026-10-19 12:51:51','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(303,'91.236.131.92','2026-10-19 12:51:51','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(306,'91.236.131.92','2026-10-19 12:51:52','visit','/z6/rejestruj.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(307,'91.236.131.92','2026-10-19 12:51:52','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(310,'91.236.131.92','2026-10-19 12:51:52','visit','/z6/rejestruj.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(311,'91.236.131.92','2026-10-19 12:51:52','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(338,'91.236.131.92','2026-10-19 12:52:09','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(339,'91.236.131.92','2026-10-19 12:52:09','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(342,'91.236.131.92','2026-10-19 12:52:10','visit','/z6/rejestruj.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(343,'91.236.131.92','2026-10-19 12:52:10','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(346,'91.236.131.92','2026-10-19 12:52:11','visit','/z6/rejestruj.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(347,'91.236.131.92','2026-10-19 12:52:11','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(389,'91.236.131.92','2026-10-19 12:52:18','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(390,'91.236.131.92','2026-10-19 12:52:18','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(391,'91.236.131.92','2026-10-19 12:52:18','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(392,'93.159.60.249','2026-10-19 12:52:58','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(393,'93.159.60.249','2026-10-19 12:53:35','visit','/z6/drive.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(394,'93.159.60.249','2026-10-19 12:54:10','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(395,'93.159.60.249','2026-10-19 12:54:33','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(396,'93.159.60.249','2026-10-19 12:54:35','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(397,'93.159.60.249','2026-10-19 12:55:01','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(398,'93.159.60.249','2026-10-19 12:55:03','visit','/z6/select.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(399,'93.159.60.249','2026-10-19 12:55:04','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(400,'93.159.60.249','2026-10-19 12:55:14','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(401,'93.159.60.249','2026-10-19 12:55:14','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(402,'91.236.131.92','2026-10-19 12:55:30','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(403,'91.236.131.92','2026-10-19 12:55:30','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(407,'93.159.60.249','2026-10-19 12:55:49','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(408,'93.159.60.249','2026-10-19 12:55:52','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(409,'93.159.60.249','2026-10-19 12:55:54','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(410,'91.236.131.92','2026-10-19 12:55:56','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(411,'91.236.131.92','2026-10-19 12:55:56','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(415,'93.159.60.249','2026-10-19 12:55:59','visit','/z6/song.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(416,'93.159.60.249','2026-10-19 12:56:16','visit','/z6/index.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(417,'93.159.60.249','2026-10-19 12:56:20','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(418,'93.159.60.249','2026-10-19 12:56:23','visit','/z6/video_playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(419,'93.159.60.249','2026-10-19 12:56:25','visit','/z6/video_playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(420,'93.159.60.249','2026-10-19 12:56:32','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(421,'91.236.131.92','2026-10-19 12:56:36','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(422,'91.236.131.92','2026-10-19 12:56:36','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(424,'93.159.60.249','2026-10-19 12:56:36','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(427,'93.159.60.249','2026-10-19 12:56:39','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(428,'93.159.60.249','2026-10-19 12:56:40','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(429,'91.236.131.92','2026-10-19 12:57:32','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(430,'91.236.131.92','2026-10-19 12:57:32','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(434,'93.159.60.249','2026-10-19 12:57:56','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(435,'93.159.60.249','2026-10-19 12:58:13','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(436,'93.159.60.249','2026-10-19 12:58:20','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(437,'93.159.60.249','2026-10-19 12:58:26','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(438,'93.159.60.249','2026-10-19 12:58:28','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(439,'91.236.131.92','2026-10-19 12:58:32','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(440,'91.236.131.92','2026-10-19 12:58:32','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(444,'93.159.60.249','2026-10-19 12:58:33','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(445,'91.236.131.92','2026-10-19 12:59:45','visit','/z6/index3.php',NULL,'curl/7.76.1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(446,'93.159.60.249','2026-10-19 12:59:53','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(447,'91.236.131.92','2026-10-19 13:00:46','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(448,'91.236.131.92','2026-10-19 13:00:46','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(453,'93.159.60.249','2026-10-19 13:01:39','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(454,'93.159.60.249','2026-10-19 13:01:39','visit','/z6/video_playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(455,'93.159.60.249','2026-10-19 13:01:40','visit','/z6/video_playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(456,'93.159.60.249','2026-10-19 13:01:42','visit','/z6/video_playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(457,'93.159.60.249','2026-10-19 13:01:43','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(458,'91.236.131.92','2026-10-19 13:01:53','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(459,'91.236.131.92','2026-10-19 13:01:53','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(464,'91.236.131.92','2026-10-19 13:01:53','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36','Chrome Headless 156.0.0.0','Linux',1280,720,1280,720,24,1,0,'en-US',1.00),
(465,'91.236.131.92','2026-10-19 13:01:53','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(466,'91.236.131.92','2026-10-19 13:01:53','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(472,'91.236.131.92','2026-10-19 13:02:20','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(473,'91.236.131.92','2026-10-19 13:02:20','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(477,'93.159.60.249','2026-10-19 13:02:53','visit','/z6/video_playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(478,'93.159.60.249','2026-10-19 13:02:54','visit','/z6/video_playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(479,'93.159.60.249','2026-10-19 13:02:55','visit','/z6/film_select.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(480,'93.159.60.249','2026-10-19 13:02:55','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(481,'91.236.131.92','2026-10-19 13:03:06','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(482,'91.236.131.92','2026-10-19 13:03:06','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(486,'91.236.131.92','2026-10-19 13:04:17','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(487,'91.236.131.92','2026-10-19 13:04:17','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(491,'91.236.131.92','2026-10-19 13:04:59','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(492,'91.236.131.92','2026-10-19 13:04:59','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(497,'91.236.131.92','2026-10-19 13:05:01','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36','Chrome Headless 156.0.0.0','Linux',1280,720,1280,720,24,1,0,'en-US',1.00),
(498,'91.236.131.92','2026-10-19 13:05:01','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(499,'91.236.131.92','2026-10-19 13:05:01','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(505,'93.159.60.249','2026-10-19 13:05:21','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(506,'93.159.60.249','2026-10-19 13:05:37','visit','/z6/video_playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(507,'93.159.60.249','2026-10-19 13:05:38','visit','/z6/video_playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(508,'93.159.60.249','2026-10-19 13:05:39','visit','/z6/video_playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(509,'93.159.60.249','2026-10-19 13:06:11','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(510,'93.159.60.249','2026-10-19 13:06:12','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(511,'91.236.131.92','2026-10-19 13:06:53','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(512,'91.236.131.92','2026-10-19 13:06:53','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(517,'91.236.131.92','2026-10-19 13:06:55','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36','Chrome Headless 156.0.0.0','Linux',1280,720,1280,720,24,1,0,'en-US',1.00),
(518,'91.236.131.92','2026-10-19 13:06:55','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(519,'91.236.131.92','2026-10-19 13:06:55','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(524,'91.236.131.92','2026-10-19 13:07:24','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(525,'91.236.131.92','2026-10-19 13:07:24','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(530,'91.236.131.92','2026-10-19 13:07:25','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36','Chrome Headless 156.0.0.0','Linux',1280,720,1280,720,24,1,0,'en-US',1.00),
(531,'91.236.131.92','2026-10-19 13:07:25','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(532,'91.236.131.92','2026-10-19 13:07:25','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(538,'93.159.60.249','2026-10-19 13:08:26','visit','/z6/film_select.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(539,'91.236.131.92','2026-10-19 13:09:04','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(540,'91.236.131.92','2026-10-19 13:09:04','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(545,'93.159.60.249','2026-10-19 13:09:13','visit','/z6/video_playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(546,'93.159.60.249','2026-10-19 13:09:17','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(547,'93.159.60.249','2026-10-19 13:09:23','visit','/z6/film.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(548,'91.236.131.92','2026-10-19 13:09:33','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(549,'91.236.131.92','2026-10-19 13:09:34','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(556,'93.159.60.249','2026-10-19 13:10:11','visit','/z6/film.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(557,'91.236.131.92','2026-10-19 13:12:43','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(558,'91.236.131.92','2026-10-19 13:12:43','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(566,'93.159.60.249','2026-10-19 13:13:26','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(567,'93.159.60.249','2026-10-19 13:13:28','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(568,'93.159.60.249','2026-10-19 13:13:29','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(569,'93.159.60.249','2026-10-19 13:13:32','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(570,'93.159.60.249','2026-10-19 13:14:00','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(571,'93.159.60.249','2026-10-19 13:14:02','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(572,'93.159.60.249','2026-10-19 13:14:03','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(573,'93.159.60.249','2026-10-19 13:14:04','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(574,'93.159.60.249','2026-10-19 13:14:36','visit','/z6/film.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(575,'93.159.60.249','2026-10-19 13:14:46','visit','/z6/film.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(576,'93.159.60.249','2026-10-19 13:15:14','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(577,'93.159.60.249','2026-10-19 13:16:26','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(578,'93.159.60.249','2026-10-19 13:16:27','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(579,'93.159.60.249','2026-10-19 13:16:29','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(580,'93.159.60.249','2026-10-19 13:16:33','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(581,'93.159.60.249','2026-10-19 13:16:35','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(582,'91.236.131.92','2026-10-19 13:16:36','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(583,'91.236.131.92','2026-10-19 13:16:36','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(584,'93.159.60.249','2026-10-19 13:16:36','visit','/z6/select.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(591,'93.159.60.249','2026-10-19 13:16:37','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(592,'93.159.60.249','2026-10-19 13:16:38','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(593,'93.159.60.249','2026-10-19 13:16:39','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(594,'93.159.60.249','2026-10-19 13:16:40','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(595,'93.159.60.249','2026-10-19 13:16:41','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(596,'93.159.60.249','2026-10-19 13:16:42','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(597,'93.159.60.249','2026-10-19 13:16:47','visit','/z6/film.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(598,'93.159.60.249','2026-10-19 13:17:14','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(599,'93.159.60.249','2026-10-19 13:17:19','visit','/z6/film.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(600,'93.159.60.249','2026-10-19 17:55:56','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Mobile Safari/537.36','Chrome 155.0.0.0','Android 10',384,854,384,718,24,1,0,'pl-PL',2.81),
(601,'93.159.60.249','2026-10-19 17:56:06','login','/z6/weryfikuj3.php','admin','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Mobile Safari/537.36','Chrome 155.0.0.0','Android 10',384,854,384,718,24,1,0,'pl-PL',2.81),
(602,'93.159.60.249','2026-10-19 17:56:06','visit','/z6/index4.php','admin','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Mobile Safari/537.36','Chrome 155.0.0.0','Android 10',384,854,384,718,24,1,0,'pl-PL',2.81),
(603,'93.159.60.249','2026-10-19 17:56:25','visit','/z6/index4.php','admin','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Mobile Safari/537.36','Chrome 155.0.0.0','Android 10',384,854,384,718,24,1,0,'pl-PL',2.81),
(604,'93.159.60.249','2026-10-19 17:56:30','visit','/z6/index.php','admin','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Mobile Safari/537.36','Chrome 155.0.0.0','Android 10',384,854,384,718,24,1,0,'pl-PL',2.81),
(605,'93.159.60.249','2026-10-19 17:56:32','visit','/z6/music.php','admin','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Mobile Safari/537.36','Chrome 155.0.0.0','Android 10',384,854,384,718,24,1,0,'pl-PL',2.81),
(606,'93.159.60.249','2026-10-19 17:56:34','visit','/z6/music.php','admin','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Mobile Safari/537.36','Chrome 155.0.0.0','Android 10',384,854,384,718,24,1,0,'pl-PL',2.81),
(607,'93.159.60.249','2026-10-19 17:56:36','visit','/z6/music.php','admin','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Mobile Safari/537.36','Chrome 155.0.0.0','Android 10',384,854,384,718,24,1,0,'pl-PL',2.81),
(608,'93.159.60.249','2026-10-19 18:02:20','visit','/z6/music.php','admin','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Mobile Safari/537.36','Chrome 155.0.0.0','Android 10',384,854,384,718,24,1,0,'pl-PL',2.81),
(609,'91.236.131.92','2026-10-19 18:13:10','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(610,'91.236.131.92','2026-10-19 18:13:10','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(617,'91.236.131.92','2026-10-19 18:14:08','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(618,'91.236.131.92','2026-10-19 18:14:08','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(632,'31.0.33.203','2026-10-20 14:24:27','visit','/z6/index3.php',NULL,'Mozilla/5.0 (X11; Linux x86_64; rv:157.0) Gecko/20100101 Firefox/157.0','Firefox 157.0','Linux',1920,1080,1496,858,24,1,0,'pl',1.00),
(633,'31.0.33.203','2026-10-20 14:24:31','login','/z6/weryfikuj3.php','grad','Mozilla/5.0 (X11; Linux x86_64; rv:157.0) Gecko/20100101 Firefox/157.0','Firefox 157.0','Linux',1920,1080,1496,858,24,1,0,'pl',1.00),
(634,'31.0.33.203','2026-10-20 14:24:31','visit','/z6/index4.php','grad','Mozilla/5.0 (X11; Linux x86_64; rv:157.0) Gecko/20100101 Firefox/157.0','Firefox 157.0','Linux',1920,1080,1496,858,24,1,0,'pl',1.00),
(635,'31.0.33.203','2026-10-20 14:24:33','visit','/z6/account_edit.php','grad','Mozilla/5.0 (X11; Linux x86_64; rv:157.0) Gecko/20100101 Firefox/157.0','Firefox 157.0','Linux',1920,1080,1496,858,24,1,0,'pl',1.00),
(636,'31.0.33.203','2026-10-20 14:24:39','visit','/z6/select.php','grad','Mozilla/5.0 (X11; Linux x86_64; rv:157.0) Gecko/20100101 Firefox/157.0','Firefox 157.0','Linux',1920,1080,1496,858,24,1,0,'pl',1.00),
(637,'31.0.33.203','2026-10-20 14:24:42','visit','/z6/films.php','grad','Mozilla/5.0 (X11; Linux x86_64; rv:157.0) Gecko/20100101 Firefox/157.0','Firefox 157.0','Linux',1920,1080,1496,858,24,1,0,'pl',1.00),
(638,'46.239.135.19','2026-10-20 14:27:36','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(639,'46.239.135.19','2026-10-20 14:27:41','login','/z6/weryfikuj3.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(640,'46.239.135.19','2026-10-20 14:27:41','visit','/z6/index4.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(641,'46.239.135.19','2026-10-20 14:27:45','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(642,'46.239.135.19','2026-10-20 14:27:47','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(643,'46.239.135.19','2026-10-20 14:27:50','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(651,'91.236.131.92','2026-10-21 18:14:46','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(659,'91.236.131.92','2026-10-21 18:18:07','visit','/z6/index3.php',NULL,'Playwright/1.64.0 (x64; linux unknown) node/22.23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(660,'93.159.60.249','2026-10-21 21:04:54','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(661,'93.159.60.249','2026-10-21 21:05:00','login','/z6/weryfikuj3.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(662,'93.159.60.249','2026-10-21 21:05:00','visit','/z6/index4.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(663,'93.159.60.249','2026-10-21 21:05:15','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(664,'93.159.60.249','2026-10-21 21:05:18','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(665,'93.159.60.249','2026-10-22 07:05:11','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(666,'93.159.60.249','2026-10-22 07:05:16','login','/z6/weryfikuj3.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(667,'93.159.60.249','2026-10-22 07:05:16','visit','/z6/index4.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(668,'93.159.60.249','2026-10-22 07:05:23','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(669,'93.159.60.249','2026-10-22 07:05:28','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(670,'93.159.60.249','2026-10-22 07:07:18','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(671,'93.159.60.249','2026-10-22 07:07:21','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(672,'93.159.60.249','2026-10-22 07:26:23','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(673,'93.159.60.249','2026-10-22 09:37:29','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(674,'93.159.60.249','2026-10-22 09:37:31','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(675,'93.159.60.249','2026-10-22 10:35:40','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(676,'93.159.60.249','2026-10-22 10:35:41','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(677,'93.159.60.249','2026-10-22 10:35:52','login','/z6/weryfikuj3.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(678,'93.159.60.249','2026-10-22 10:35:52','visit','/z6/index4.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(679,'93.159.60.249','2026-10-22 10:36:03','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(680,'93.159.60.249','2026-10-22 10:36:04','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(681,'89.230.149.188','2026-10-23 15:46:01','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(682,'89.230.149.188','2026-10-23 15:46:15','login','/z6/weryfikuj3.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(683,'89.230.149.188','2026-10-23 15:46:15','visit','/z6/index4.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(684,'89.230.149.188','2026-10-23 15:46:29','visit','/z6/index1.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(685,'89.230.149.188','2026-10-23 15:46:38','visit','/z6/index4.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(686,'89.230.149.188','2026-10-23 15:46:40','visit','/z6/account_edit.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(687,'89.230.149.188','2026-10-23 15:46:44','visit','/z6/index11.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(688,'89.230.149.188','2026-10-23 15:47:31','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(689,'89.230.149.188','2026-10-23 15:47:32','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(690,'89.230.149.188','2026-10-23 15:47:34','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(691,'89.230.149.188','2026-10-23 15:47:35','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(692,'89.230.149.188','2026-10-23 15:48:06','visit','/z6/index13.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(693,'89.230.149.188','2026-10-23 15:48:17','visit','/z6/index14.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(694,'89.230.149.188','2026-10-23 15:48:20','visit','/z6/monitor.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(695,'89.230.149.188','2026-10-23 15:48:30','visit','/z6/drive.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(696,'89.230.149.188','2026-10-23 15:48:48','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(697,'89.230.149.188','2026-10-23 15:49:02','visit','/z6/song.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(698,'89.230.149.188','2026-10-23 15:49:14','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(699,'89.230.149.188','2026-10-23 15:49:16','visit','/z6/film.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(700,'89.230.149.188','2026-10-23 15:49:34','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(701,'89.230.149.188','2026-10-23 15:50:20','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(702,'89.230.149.188','2026-10-23 15:50:24','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(703,'89.230.149.188','2026-10-23 15:50:25','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(704,'89.230.149.188','2026-10-23 15:50:41','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(705,'89.230.149.188','2026-10-23 15:50:43','visit','/z6/select.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(706,'89.230.149.188','2026-10-23 15:50:48','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(707,'89.230.149.188','2026-10-23 15:50:53','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(708,'89.230.149.188','2026-10-23 15:51:06','visit','/z6/tasks.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1920,1080,1920,893,24,1,0,'pl',1.00),
(709,'89.230.149.188','2026-10-23 17:12:30','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1949,1101,1949,833,24,1,0,'pl',0.70),
(710,'89.230.149.188','2026-10-23 17:12:34','login','/z6/weryfikuj3.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1949,1101,1949,833,24,1,0,'pl',0.70),
(711,'89.230.149.188','2026-10-23 17:12:34','visit','/z6/index4.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1949,1101,1949,833,24,1,0,'pl',0.70),
(712,'89.230.149.188','2026-10-23 17:12:42','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1949,1101,1949,833,24,1,0,'pl',0.70),
(713,'89.230.149.188','2026-10-23 17:13:17','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1949,1101,1949,833,24,1,0,'pl',0.70),
(714,'89.230.149.188','2026-10-23 17:13:21','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1949,1101,1949,833,24,1,0,'pl',0.70),
(715,'89.230.149.188','2026-10-23 17:13:27','visit','/z6/song.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1949,1101,1949,833,24,1,0,'pl',0.70),
(716,'89.230.149.188','2026-10-23 17:17:38','visit','/z6/playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1949,1101,1949,833,24,1,0,'pl',0.70),
(717,'89.230.149.188','2026-10-23 17:17:40','visit','/z6/playlist.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1949,1101,1949,833,24,1,0,'pl',0.70),
(718,'5.185.208.237','2026-10-24 09:25:13','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(719,'5.185.208.237','2026-10-24 09:25:16','login','/z6/weryfikuj3.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(720,'5.185.208.237','2026-10-24 09:25:16','visit','/z6/index4.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(721,'5.185.208.237','2026-10-24 09:25:22','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(722,'5.185.208.237','2026-10-24 09:25:23','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(723,'89.230.149.188','2026-10-25 12:49:22','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(724,'89.230.149.188','2026-10-25 12:49:29','login','/z6/weryfikuj3.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(725,'89.230.149.188','2026-10-25 12:49:29','visit','/z6/index4.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(726,'89.230.149.188','2026-10-25 12:49:45','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(727,'89.230.149.188','2026-10-25 12:49:48','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(728,'46.239.135.42','2026-10-27 13:53:23','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(729,'31.0.32.3','2026-10-27 13:55:05','login','/z6/weryfikuj3.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(730,'31.0.32.3','2026-10-27 13:55:05','visit','/z6/index4.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(731,'31.0.32.3','2026-10-27 13:55:17','visit','/z6/drive.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(732,'31.0.32.3','2026-10-27 13:55:30','visit','/z6/cloud_logins.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(733,'31.0.32.3','2026-10-27 13:55:34','visit','/z6/cloud_security.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(734,'31.0.32.3','2026-10-27 13:55:44','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(735,'31.0.32.3','2026-10-27 13:56:25','visit','/z6/films.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(736,'31.0.32.3','2026-10-27 13:57:12','visit','/z6/video_playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(737,'31.0.32.3','2026-10-27 13:57:12','visit','/z6/video_playlists.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(738,'31.0.32.3','2026-10-27 13:57:25','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(739,'46.239.135.42','2026-10-27 13:58:50','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(740,'46.239.135.42','2026-10-27 13:58:55','login','/z6/weryfikuj3.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(741,'46.239.135.42','2026-10-27 13:58:55','visit','/z6/index4.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(742,'46.239.135.42','2026-10-27 13:59:03','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(743,'46.239.135.42','2026-10-27 13:59:06','visit','/z6/index12.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(744,'46.239.135.42','2026-10-27 13:59:54','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(745,'46.239.135.42','2026-10-27 13:59:55','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(746,'46.239.135.42','2026-10-27 13:59:55','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(747,'82.146.252.25','2026-10-28 20:09:33','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1536,864,1536,731,24,1,0,'pl',1.25),
(748,'82.146.252.25','2026-10-28 20:09:41','login_failed','/z6/weryfikuj3.php','user11','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1536,864,1536,731,24,1,0,'pl',1.25),
(749,'82.146.252.25','2026-10-28 20:09:41','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1536,864,1536,731,24,1,0,'pl',1.25),
(750,'82.146.252.25','2026-10-28 20:09:44','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1536,864,1536,731,24,1,0,'pl',1.25),
(751,'82.146.252.25','2026-10-28 20:09:53','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1536,864,1536,731,24,1,0,'pl',1.25),
(752,'82.146.252.25','2026-10-28 20:09:55','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1536,864,1536,731,24,1,0,'pl',1.25),
(753,'82.146.252.25','2026-10-28 20:09:56','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1536,864,1536,731,24,1,0,'pl',1.25),
(754,'82.146.252.25','2026-10-28 20:10:01','login','/z6/weryfikuj3.php','user11','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1536,864,1536,731,24,1,0,'pl',1.25),
(755,'82.146.252.25','2026-10-28 20:10:01','visit','/z6/index4.php','user11','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1536,864,1536,731,24,1,0,'pl',1.25),
(756,'82.146.252.25','2026-10-28 20:10:08','visit','/z6/films.php','user11','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1536,864,1536,731,24,1,0,'pl',1.25),
(757,'82.146.252.25','2026-10-28 20:10:25','visit','/z6/film.php','user11','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1536,864,1536,731,24,1,0,'pl',1.25),
(758,'82.146.252.25','2026-10-28 20:11:24','visit','/z6/films.php','user11','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1536,864,1536,731,24,1,0,'pl',1.25),
(759,'82.146.252.25','2026-10-28 20:11:33','visit','/z6/music.php','user11','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1536,864,1536,731,24,1,0,'pl',1.25),
(760,'82.146.252.25','2026-10-28 20:13:13','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1536,864,1536,731,24,1,0,'pl',1.25),
(761,'82.146.252.25','2026-10-28 20:13:13','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(762,'82.146.252.25','2026-10-28 20:13:13','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(763,'93.159.60.249','2026-10-29 09:50:39','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:159.0) Gecko/20100101 Firefox/159.0','Firefox 159.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(764,'93.159.60.249','2026-10-29 09:50:42','login','/z6/weryfikuj3.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:159.0) Gecko/20100101 Firefox/159.0','Firefox 159.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(765,'93.159.60.249','2026-10-29 09:50:42','visit','/z6/index4.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:159.0) Gecko/20100101 Firefox/159.0','Firefox 159.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(766,'93.159.60.249','2026-10-29 09:50:46','visit','/z6/music.php','admin','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:159.0) Gecko/20100101 Firefox/159.0','Firefox 159.0','Windows 10',2208,1242,2208,974,24,1,0,'pl',0.87),
(767,'79.162.7.84','2026-10-29 11:29:03','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(768,'79.162.7.84','2026-10-29 11:29:05','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(769,'79.162.7.84','2026-10-29 11:29:10','visit','/z6/rejestruj.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(770,'79.162.7.84','2026-10-29 11:29:17','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(771,'79.162.7.84','2026-10-29 11:29:21','login','/z6/weryfikuj3.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(772,'79.162.7.84','2026-10-29 11:29:21','visit','/z6/index4.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(773,'79.162.7.84','2026-10-29 11:29:27','visit','/z6/music.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(774,'79.162.7.84','2026-10-29 11:29:32','visit','/z6/select.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(775,'79.162.7.84','2026-10-29 11:29:52','visit','/z6/song.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(776,'79.162.7.84','2026-10-29 11:30:07','visit','/z6/playlists.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(777,'79.162.7.84','2026-10-29 11:30:21','visit','/z6/playlist.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(778,'79.162.7.84','2026-10-29 11:30:27','visit','/z6/playlist.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(779,'79.162.7.84','2026-10-29 11:30:34','visit','/z6/playlist.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(780,'79.162.7.84','2026-10-29 11:30:47','visit','/z6/playlists.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(781,'79.162.7.84','2026-10-29 11:30:50','visit','/z6/playlist.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(782,'79.162.7.84','2026-10-29 11:31:15','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(783,'79.162.7.84','2026-10-29 11:31:15','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(784,'79.162.7.84','2026-10-29 11:31:15','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(785,'79.162.7.84','2026-10-29 11:31:26','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(786,'79.162.7.84','2026-10-29 11:31:30','login','/z6/weryfikuj3.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(787,'79.162.7.84','2026-10-29 11:31:30','visit','/z6/index4.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(788,'79.162.7.84','2026-10-29 11:31:33','visit','/z6/film_select.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(789,'79.162.7.84','2026-10-29 11:31:55','visit','/z6/film.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(790,'79.162.7.84','2026-10-29 11:32:00','visit','/z6/video_playlists.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(791,'79.162.7.84','2026-10-29 11:32:18','visit','/z6/video_playlist.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(792,'79.162.7.84','2026-10-29 11:32:23','visit','/z6/video_playlist.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(793,'79.162.7.84','2026-10-29 11:32:35','visit','/z6/video_playlist.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(794,'79.162.7.84','2026-10-29 11:32:41','visit','/z6/video_playlists.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(795,'79.162.7.84','2026-10-29 11:32:43','visit','/z6/video_playlist.php','grad2','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(796,'79.162.7.84','2026-10-29 11:33:14','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(797,'79.162.7.84','2026-10-29 11:33:14','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(798,'79.162.7.84','2026-10-29 11:33:14','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(799,'79.162.7.84','2026-10-29 11:40:23','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(800,'79.162.7.84','2026-10-29 11:40:26','login','/z6/weryfikuj3.php','grad','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(801,'79.162.7.84','2026-10-29 11:40:26','visit','/z6/index4.php','grad','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(802,'79.162.7.84','2026-10-29 11:40:33','visit','/z6/video_playlists.php','grad','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(803,'79.162.7.84','2026-10-29 11:40:38','visit','/z6/video_playlists.php','grad','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(804,'79.162.7.84','2026-10-29 11:40:41','visit','/z6/video_playlist.php','grad','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(805,'79.162.7.84','2026-10-29 11:41:02','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36','Chrome 156.0.0.0','Windows 10',1707,1067,1707,932,24,1,0,'en-US',1.50),
(806,'82.146.252.25','2026-10-29 16:15:02','visit','/z6/index3.php',NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0','Firefox 158.0','Windows 10',1536,864,1536,731,24,1,0,'pl',1.25),
(807,'91.236.131.92','2026-10-29 16:18:28','visit','/z6/index3.php',NULL,'curl/7.76.1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `z6_goscieportalu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `z6_login_attempts`
--

DROP TABLE IF EXISTS `z6_login_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `z6_login_attempts` (
  `form_id` tinyint(3) unsigned NOT NULL,
  `login_key` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `locked_until` bigint(20) unsigned NOT NULL DEFAULT 0,
  `updated_at` bigint(20) unsigned NOT NULL,
  `failures` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`form_id`,`login_key`),
  KEY `attempts_updated` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `z6_login_attempts`
--

LOCK TABLES `z6_login_attempts` WRITE;
/*!40000 ALTER TABLE `z6_login_attempts` DISABLE KEYS */;
INSERT INTO `z6_login_attempts` VALUES
(43,'1d952313323fb996675b64cd9da45f030da552dab09a226eaa9d710a9ca18911',0,1792606687,0),
(43,'81115e31e22a5801b197750ec12d7a51ad693aa017ecc8bca033cbd500a928b6',0,1793218200,0),
(43,'8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918',0,1793267442,0),
(43,'90ddece3c6bd7fffe83af4d6da7d1d47bdd3bc4b8c55e4fb6014a6197da2199e',0,1793274026,0),
(43,'ce8e4d7ff327c058d382395f2a178635ed833e6b7b31c75ebf53d6b5cb8db0f1',0,1792606486,0),
(43,'d2efe1fb5744a3a0aa18fd24cc82f7cab113d7e72984ce010e49b8e225718193',0,1793273490,0);
/*!40000 ALTER TABLE `z6_login_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `z6_musictype`
--

DROP TABLE IF EXISTS `z6_musictype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `z6_musictype` (
  `idmt` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`idmt`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `z6_musictype`
--

LOCK TABLES `z6_musictype` WRITE;
/*!40000 ALTER TABLE `z6_musictype` DISABLE KEYS */;
INSERT INTO `z6_musictype` VALUES
(10,'classic'),
(7,'country'),
(4,'electronic dance'),
(3,'hip-hop'),
(11,'inny'),
(9,'jazz'),
(6,'latin'),
(8,'metal'),
(1,'pop'),
(5,'R&B'),
(2,'rock');
/*!40000 ALTER TABLE `z6_musictype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `z6_player_state`
--

DROP TABLE IF EXISTS `z6_player_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `z6_player_state` (
  `idu` smallint(6) NOT NULL,
  `state` mediumtext NOT NULL,
  PRIMARY KEY (`idu`),
  CONSTRAINT `z6_player_user` FOREIGN KEY (`idu`) REFERENCES `z6_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `z6_player_state`
--

LOCK TABLES `z6_player_state` WRITE;
/*!40000 ALTER TABLE `z6_player_state` DISABLE KEYS */;
INSERT INTO `z6_player_state` VALUES (28,'{"queue":[{"id":4,"title":"Human Nature","musician":"Michael Jackson","url":"song_file.php?id=4"}],"index":0,"time":0,"playing":false,"shuffle":false,"repeat":0,"volume":0.14,"muted":false}'),(76,'{"queue":[{"id":41,"title":"sdfsdfsdf","musician":"sddf sdf","url":"song_file.php?id=41"}],"index":0,"time":2.950097,"playing":false,"shuffle":false,"repeat":0,"volume":0.75,"muted":false}');
/*!40000 ALTER TABLE `z6_player_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `z6_playlistdatabase`
--

DROP TABLE IF EXISTS `z6_playlistdatabase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `z6_playlistdatabase` (
  `idpldb` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `idpl` int(10) unsigned NOT NULL,
  `ids` int(10) unsigned NOT NULL,
  PRIMARY KEY (`idpldb`),
  UNIQUE KEY `playlist_song` (`idpl`,`ids`),
  KEY `z6_playlist_song` (`ids`),
  CONSTRAINT `z6_playlist_item` FOREIGN KEY (`idpl`) REFERENCES `z6_playlistname` (`idpl`) ON DELETE CASCADE,
  CONSTRAINT `z6_playlist_song` FOREIGN KEY (`ids`) REFERENCES `z6_song` (`ids`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `z6_playlistdatabase`
--

LOCK TABLES `z6_playlistdatabase` WRITE;
/*!40000 ALTER TABLE `z6_playlistdatabase` DISABLE KEYS */;
INSERT INTO `z6_playlistdatabase` VALUES (4,1,4),(48,13,41);
/*!40000 ALTER TABLE `z6_playlistdatabase` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `z6_playlistname`
--

DROP TABLE IF EXISTS `z6_playlistname`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `z6_playlistname` (
  `idpl` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `idu` smallint(6) NOT NULL,
  `name` text NOT NULL,
  `public` tinyint(1) NOT NULL DEFAULT 0,
  `datetime` datetime NOT NULL DEFAULT current_timestamp(),
  `coverfilename` text DEFAULT NULL,
  PRIMARY KEY (`idpl`),
  KEY `playlist_owner` (`idu`),
  KEY `playlist_public` (`public`),
  CONSTRAINT `z6_playlist_user` FOREIGN KEY (`idu`) REFERENCES `z6_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `z6_playlistname`
--

LOCK TABLES `z6_playlistname` WRITE;
/*!40000 ALTER TABLE `z6_playlistname` DISABLE KEYS */;
INSERT INTO `z6_playlistname` VALUES
(1,28,'This Is It (Live)',1,'2026-10-19 12:19:01','admin/2210f7f8a8a760bd60f69245c14db8a3.jpg'),
(2,28,'History (Live)',1,'2026-10-19 12:19:03','admin/74c4804d5df8ae0d5d6c39630286ef84.jpg'),
(13,76,'gradtest1',1,'2026-10-29 11:30:21','grad2/45a82bb2bc928e9c400eb7c32f348a3e.jpg');
/*!40000 ALTER TABLE `z6_playlistname` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `z6_settings`
--

DROP TABLE IF EXISTS `z6_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `z6_settings` (
  `name` varchar(40) NOT NULL,
  `value` varchar(100) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `z6_settings`
--

LOCK TABLES `z6_settings` WRITE;
/*!40000 ALTER TABLE `z6_settings` DISABLE KEYS */;
INSERT INTO `z6_settings` VALUES
('poland_only','0');
/*!40000 ALTER TABLE `z6_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `z6_song`
--

DROP TABLE IF EXISTS `z6_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `z6_song` (
  `ids` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `musician` text NOT NULL,
  `album` text DEFAULT NULL,
  `datetime` datetime NOT NULL DEFAULT current_timestamp(),
  `idu` smallint(6) NOT NULL,
  `filename` text NOT NULL,
  `lyrics` text DEFAULT NULL,
  `idmt` smallint(5) unsigned NOT NULL,
  `coverfilename` text DEFAULT NULL,
  PRIMARY KEY (`ids`),
  KEY `song_owner` (`idu`),
  KEY `song_genre` (`idmt`),
  CONSTRAINT `z6_song_type` FOREIGN KEY (`idmt`) REFERENCES `z6_musictype` (`idmt`),
  CONSTRAINT `z6_song_user` FOREIGN KEY (`idu`) REFERENCES `z6_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `z6_song`
--

LOCK TABLES `z6_song` WRITE;
/*!40000 ALTER TABLE `z6_song` DISABLE KEYS */;
INSERT INTO `z6_song` VALUES (4,'Human Nature','Michael Jackson','This Is It','2026-10-19 12:19:02',28,'admin/1f9322fc2539d05b61bb1e4393a01804.mp3','',1,'admin/9c89b67dacd553dabd654af075ad64af.jpg'),(41,'sdfsdfsdf','sddf sdf','sdf sdf','2026-10-29 11:29:52',76,'grad2/808bf151abe78d0f764aa2668f076e23.mp3','s dfsd fsd fsd sdf',8,NULL);
/*!40000 ALTER TABLE `z6_song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `z6_users`
--

DROP TABLE IF EXISTS `z6_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `z6_users` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `username` varchar(128) NOT NULL,
  `password` varchar(128) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `worker` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_username_unique` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `z6_users`
--

LOCK TABLES `z6_users` WRITE;
/*!40000 ALTER TABLE `z6_users` DISABLE KEYS */;
INSERT INTO `z6_users` VALUES
(1,'user1','pass1',NULL,1),
(2,'user2','pass2',NULL,1),
(14,'test123','test1234',NULL,0),
(27,'Dawid24p','Q@wertyuiop','d037b6414fced8bd7de7b13c06bf364fdad2b3b610a6d61cb74ddc5b8316c7da.png',0),
(28,'admin','admin','003792dc4ae8a2de5a44f1d8fde5473c605ec05dae40bb5b956fc0181ff048ee.png',0),
(31,'grad','grad',NULL,0),
(74,'user11','$2y$10$R757MKNEfOr/oAKXMco7uOJh34IMYQRe945K8msBTeG2vcvE1v6/m',NULL,0),
(76,'grad2','$2y$10$YOciW19WmQnnhlmjWXNmpO1tYVeTIqxdInvxVvITuJi//YW4YLLvG',NULL,0);
/*!40000 ALTER TABLE `z6_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `z6v_film`
--

DROP TABLE IF EXISTS `z6v_film`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `z6v_film` (
  `idf` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `director` text NOT NULL,
  `datetime` datetime NOT NULL DEFAULT current_timestamp(),
  `idu` smallint(6) NOT NULL,
  `filename` text NOT NULL,
  `subtitles` text DEFAULT NULL,
  `idft` smallint(5) unsigned NOT NULL,
  `coverfilename` text DEFAULT NULL,
  `duration_seconds` int(10) unsigned DEFAULT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`idf`),
  KEY `song_owner` (`idu`),
  KEY `song_genre` (`idft`),
  CONSTRAINT `z6v_film_type` FOREIGN KEY (`idft`) REFERENCES `z6v_filmtype` (`idft`),
  CONSTRAINT `z6v_film_user` FOREIGN KEY (`idu`) REFERENCES `z6_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `z6v_film`
--

LOCK TABLES `z6v_film` WRITE;
/*!40000 ALTER TABLE `z6v_film` DISABLE KEYS */;
INSERT INTO `z6v_film` VALUES
(16,'Live Aid','Nie podano','2026-10-19 13:01:52',28,'admin/114b4b00971b475ce72cd2c9f5bb0255.mp4','',9,'admin/50cd2b98871161c0c0ec9a7d48128e86.jpg',1481,'Nagranie koncertowe Live Aid.'),
(17,'sdfsf fsd','sdf sdf','2026-10-29 11:31:55',76,'grad2/a592a8928f66d0b3d56f5a0ddee10dac.mp4','s dfs dfsd fsdf ',9,'grad2/95a2b4e42179e55defb524792b5ba017.jpg',13,'s dfs dfs dfs');
/*!40000 ALTER TABLE `z6v_film` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `z6v_filmtype`
--

DROP TABLE IF EXISTS `z6v_filmtype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `z6v_filmtype` (
  `idft` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`idft`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `z6v_filmtype`
--

LOCK TABLES `z6v_filmtype` WRITE;
/*!40000 ALTER TABLE `z6v_filmtype` DISABLE KEYS */;
INSERT INTO `z6v_filmtype` VALUES
(10,'animowany'),
(1,'dokument'),
(7,'familijny'),
(4,'film akcji'),
(6,'horror'),
(11,'inny'),
(9,'koncert'),
(8,'przyrodniczy'),
(3,'publicystyka'),
(2,'reportaż'),
(5,'sci-fi');
/*!40000 ALTER TABLE `z6v_filmtype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `z6v_playlistdatabase`
--

DROP TABLE IF EXISTS `z6v_playlistdatabase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `z6v_playlistdatabase` (
  `idpldb` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `idpl` int(10) unsigned NOT NULL,
  `idf` int(10) unsigned NOT NULL,
  PRIMARY KEY (`idpldb`),
  UNIQUE KEY `playlist_song` (`idpl`,`idf`),
  KEY `z6_playlist_song` (`idf`),
  CONSTRAINT `z6v_playlist_item` FOREIGN KEY (`idpl`) REFERENCES `z6v_playlistname` (`idpl`) ON DELETE CASCADE,
  CONSTRAINT `z6v_playlist_song` FOREIGN KEY (`idf`) REFERENCES `z6v_film` (`idf`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `z6v_playlistdatabase`
--

LOCK TABLES `z6v_playlistdatabase` WRITE;
/*!40000 ALTER TABLE `z6v_playlistdatabase` DISABLE KEYS */;
INSERT INTO `z6v_playlistdatabase` VALUES
(26,31,16),
(29,37,16),
(28,37,17);
/*!40000 ALTER TABLE `z6v_playlistdatabase` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `z6v_playlistname`
--

DROP TABLE IF EXISTS `z6v_playlistname`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `z6v_playlistname` (
  `idpl` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `idu` smallint(6) NOT NULL,
  `name` text NOT NULL,
  `public` tinyint(1) NOT NULL DEFAULT 0,
  `datetime` datetime NOT NULL DEFAULT current_timestamp(),
  `coverfilename` text DEFAULT NULL,
  PRIMARY KEY (`idpl`),
  KEY `playlist_owner` (`idu`),
  KEY `playlist_public` (`public`),
  CONSTRAINT `z6v_playlist_user` FOREIGN KEY (`idu`) REFERENCES `z6_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `z6v_playlistname`
--

LOCK TABLES `z6v_playlistname` WRITE;
/*!40000 ALTER TABLE `z6v_playlistname` DISABLE KEYS */;
INSERT INTO `z6v_playlistname` VALUES
(31,28,'Koncerty',1,'2026-10-19 13:06:36','admin/50cd2b98871161c0c0ec9a7d48128e86.jpg'),
(37,76,'grad2',1,'2026-10-29 11:32:18','grad2/0454e88f1a3ab32e3e153b7daac68804.jpg');
/*!40000 ALTER TABLE `z6v_playlistname` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `z6v_watch_progress`
--

DROP TABLE IF EXISTS `z6v_watch_progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `z6v_watch_progress` (
  `idu` smallint(6) NOT NULL,
  `idf` int(10) unsigned NOT NULL,
  `position_seconds` decimal(12,3) NOT NULL DEFAULT 0.000,
  `completed` tinyint(4) NOT NULL DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`idu`,`idf`),
  KEY `z6v_watch_film` (`idf`),
  CONSTRAINT `z6v_watch_film` FOREIGN KEY (`idf`) REFERENCES `z6v_film` (`idf`) ON DELETE CASCADE,
  CONSTRAINT `z6v_watch_user` FOREIGN KEY (`idu`) REFERENCES `z6_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `z6v_watch_progress`
--

LOCK TABLES `z6v_watch_progress` WRITE;
/*!40000 ALTER TABLE `z6v_watch_progress` DISABLE KEYS */;
INSERT INTO `z6v_watch_progress` VALUES
(28,16,0.621,0,'2026-10-23 15:49:34'),
(74,16,1403.886,0,'2026-10-28 20:11:24');
/*!40000 ALTER TABLE `z6v_watch_progress` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-10-29 17:20:31
