-- MySQL dump 10.17  Distrib 10.3.22-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: mgis_dev
-- ------------------------------------------------------
-- Server version	10.3.22-MariaDB-1ubuntu1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `active_admin_comments`
--

DROP TABLE IF EXISTS `active_admin_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_admin_comments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `namespace` varchar(255) DEFAULT NULL,
  `body` text DEFAULT NULL,
  `resource_type` varchar(255) DEFAULT NULL,
  `resource_id` bigint(20) DEFAULT NULL,
  `author_type` varchar(255) DEFAULT NULL,
  `author_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_active_admin_comments_on_resource_type_and_resource_id` (`resource_type`,`resource_id`),
  KEY `index_active_admin_comments_on_author_type_and_author_id` (`author_type`,`author_id`),
  KEY `index_active_admin_comments_on_namespace` (`namespace`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_admin_comments`
--

LOCK TABLES `active_admin_comments` WRITE;
/*!40000 ALTER TABLE `active_admin_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `active_admin_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `active_storage_attachments`
--

DROP TABLE IF EXISTS `active_storage_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_storage_attachments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `record_type` varchar(255) NOT NULL,
  `record_id` bigint(20) NOT NULL,
  `blob_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_active_storage_attachments_uniqueness` (`record_type`,`record_id`,`name`,`blob_id`),
  KEY `index_active_storage_attachments_on_blob_id` (`blob_id`),
  CONSTRAINT `fk_rails_c3b3935057` FOREIGN KEY (`blob_id`) REFERENCES `active_storage_blobs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_storage_attachments`
--

LOCK TABLES `active_storage_attachments` WRITE;
/*!40000 ALTER TABLE `active_storage_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `active_storage_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `active_storage_blobs`
--

DROP TABLE IF EXISTS `active_storage_blobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_storage_blobs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `content_type` varchar(255) DEFAULT NULL,
  `metadata` text DEFAULT NULL,
  `byte_size` bigint(20) NOT NULL,
  `checksum` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_active_storage_blobs_on_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_storage_blobs`
--

LOCK TABLES `active_storage_blobs` WRITE;
/*!40000 ALTER TABLE `active_storage_blobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `active_storage_blobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_users`
--

DROP TABLE IF EXISTS `admin_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) NOT NULL DEFAULT 0,
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) DEFAULT NULL,
  `last_sign_in_ip` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_admin_users_on_email` (`email`),
  UNIQUE KEY `index_admin_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_users`
--

LOCK TABLES `admin_users` WRITE;
/*!40000 ALTER TABLE `admin_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ar_internal_metadata`
--

DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ar_internal_metadata`
--

LOCK TABLES `ar_internal_metadata` WRITE;
/*!40000 ALTER TABLE `ar_internal_metadata` DISABLE KEYS */;
INSERT INTO `ar_internal_metadata` VALUES ('environment','development','2020-10-22 02:10:14','2020-10-22 02:10:14');
/*!40000 ALTER TABLE `ar_internal_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checklists`
--

DROP TABLE IF EXISTS `checklists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `checklists` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `listable_type` varchar(255) DEFAULT NULL,
  `listable_id` int(11) DEFAULT NULL,
  `checked` tinyint(1) DEFAULT NULL,
  `text` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `position` int(11) DEFAULT 0,
  `due_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_checklists_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_7b071befa6` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checklists`
--

LOCK TABLES `checklists` WRITE;
/*!40000 ALTER TABLE `checklists` DISABLE KEYS */;
INSERT INTO `checklists` VALUES (1,'Task',16,0,'Sample cheklist item','2020-11-02 12:52:33','2020-11-02 12:52:33',2,0,NULL),(2,'Issue',3,0,'Type Checklist Item Here','2020-11-03 00:49:15','2020-11-03 00:49:15',3,0,NULL),(3,'Task',67,NULL,'Clean sheets','2020-11-17 21:34:25','2020-11-17 21:34:25',2,0,NULL),(4,'Task',68,0,'Clean sheets','2020-11-17 21:34:41','2020-11-17 21:41:47',1,0,NULL),(16,'Task',46,0,'Example','2020-11-21 14:44:16','2020-12-11 22:19:49',NULL,2,NULL),(17,'Task',46,0,'This should be on top','2020-11-25 20:22:42','2020-12-15 17:23:56',11,0,NULL),(18,'Task',46,0,'LATEST ONE','2020-11-25 20:56:32','2020-12-11 22:19:57',NULL,1,NULL),(19,'Task',54,0,'LATEST ONE','2020-12-10 00:11:14','2020-12-19 00:33:18',NULL,0,'2020-12-31'),(20,'Task',54,0,'Sample cheklist item','2020-12-10 00:11:25','2020-12-19 00:33:18',NULL,1,'2021-03-23'),(24,'Issue',19,0,'LATEST ONE','2020-12-10 18:36:43','2020-12-10 21:34:54',NULL,0,NULL),(25,'Issue',19,0,'Example','2020-12-10 18:36:43','2020-12-10 21:34:54',NULL,2,NULL),(26,'Issue',13,0,'This should be on top','2020-12-10 18:51:33','2020-12-10 18:51:33',11,0,NULL),(27,'Issue',19,0,'Number 1','2020-12-10 20:44:39','2020-12-10 21:34:54',NULL,1,NULL),(29,'Task',62,0,'This should be on top','2020-12-17 14:59:16','2020-12-21 16:33:27',NULL,0,'2021-01-30'),(30,'Task',62,0,'Awesome!!','2020-12-17 14:59:16','2020-12-21 16:33:27',NULL,1,'2021-02-26'),(32,'Task',55,0,'This should be on top','2020-12-17 19:54:18','2020-12-17 19:54:18',NULL,0,NULL),(33,'Task',64,0,'LATEST ONE','2020-12-17 20:01:26','2020-12-18 18:24:31',NULL,0,'2021-01-29'),(34,'Task',69,0,'Test','2020-12-17 20:33:26','2020-12-17 20:33:26',NULL,0,NULL),(37,'Task',75,0,'Dec','2020-12-24 18:46:21','2020-12-24 18:46:21',NULL,0,NULL),(42,'Task',53,0,'4 second rule','2020-12-24 18:55:51','2020-12-24 18:55:51',NULL,0,NULL),(43,'Risk',2,0,'LATEST ONE','2020-12-31 04:18:38','2020-12-31 04:18:38',9,0,NULL),(44,'Task',53,0,'LATEST ONE','2021-01-05 16:24:37','2021-01-05 16:24:37',2,0,NULL);
/*!40000 ALTER TABLE `checklists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facilities`
--

DROP TABLE IF EXISTS `facilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `facilities` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `facility_name` varchar(255) NOT NULL DEFAULT '',
  `address` varchar(255) DEFAULT NULL,
  `point_of_contact` varchar(255) DEFAULT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL DEFAULT '',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `facility_group_id` bigint(20) DEFAULT NULL,
  `creator_id` bigint(20) DEFAULT NULL,
  `lat` varchar(255) DEFAULT NULL,
  `lng` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT 1,
  `country_code` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `index_facilities_on_facility_group_id` (`facility_group_id`),
  KEY `index_facilities_on_creator_id` (`creator_id`),
  CONSTRAINT `fk_rails_fb9279b915` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facilities`
--

LOCK TABLES `facilities` WRITE;
/*!40000 ALTER TABLE `facilities` DISABLE KEYS */;
INSERT INTO `facilities` VALUES (1,'Dev Station',NULL,'Juan Rivera','+16789009876','tes33t@test.com','2020-10-30 00:12:17','2020-10-30 00:12:17',1,1,NULL,NULL,1,NULL),(2,'Marlborough',NULL,'Juan Rivera','+15082010092','testw3e2@test.com','2020-10-30 00:26:30','2020-10-30 00:26:30',1,1,NULL,NULL,1,NULL),(3,'Another Example Fac',NULL,'Juan Rivera','+12023340987','test223@test.com','2020-10-30 00:29:45','2020-10-30 00:29:45',1,1,NULL,NULL,1,NULL),(4,'Boston MA Facility','1 Main St, Brooklyn, NY 11201, USA','Juan Rivera','+16789009822','test2@te33st.com','2020-10-30 00:30:40','2020-12-23 00:32:10',1,1,'40.70362919999999','-73.9904097',1,'US'),(5,'Mass Center','58 Cullinane Dr, Marlborough, MA 01752, USA','Juan Rivera','+15083332020','tes33t@tewwst.com','2020-10-30 00:32:03','2020-12-23 00:31:40',1,1,'42.3701825','-71.53857119999999',1,'US'),(6,'The Mask Depot','1 Maple Terrace, Marlborough, MA 01752, USA','Juan Rivera','+15082339896','test@te.com','2020-12-30 14:35:54','2020-12-30 14:35:54',2,1,'42.3457336','-71.5441586',1,'US');
/*!40000 ALTER TABLE `facilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facility_groups`
--

DROP TABLE IF EXISTS `facility_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `facility_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT 0,
  `region_type` int(11) DEFAULT 0,
  `center` varchar(255) DEFAULT '[]',
  `project_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_facility_groups_on_project_id` (`project_id`),
  CONSTRAINT `fk_rails_a31e48e525` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facility_groups`
--

LOCK TABLES `facility_groups` WRITE;
/*!40000 ALTER TABLE `facility_groups` DISABLE KEYS */;
INSERT INTO `facility_groups` VALUES (1,'Sample Region','2020-10-22 15:36:39','2020-11-10 18:00:02','SAMP',1,0,'[]',NULL),(2,'Sample Group','2020-12-09 01:00:54','2020-12-09 01:00:54','SAMP',1,0,'[]',NULL);
/*!40000 ALTER TABLE `facility_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facility_projects`
--

DROP TABLE IF EXISTS `facility_projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `facility_projects` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `facility_id` bigint(20) DEFAULT NULL,
  `project_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `due_date` date DEFAULT NULL,
  `status_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_facility_projects_on_facility_id` (`facility_id`),
  KEY `index_facility_projects_on_project_id` (`project_id`),
  KEY `index_facility_projects_on_status_id` (`status_id`),
  CONSTRAINT `fk_rails_0eac76af7e` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`id`),
  CONSTRAINT `fk_rails_b66aae6e2d` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`),
  CONSTRAINT `fk_rails_ed41de0103` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facility_projects`
--

LOCK TABLES `facility_projects` WRITE;
/*!40000 ALTER TABLE `facility_projects` DISABLE KEYS */;
INSERT INTO `facility_projects` VALUES (1,1,1,'2020-10-30 00:15:12','2020-10-30 00:15:12',NULL,NULL),(2,2,1,'2020-10-30 00:36:36','2020-10-30 00:36:36',NULL,NULL),(3,3,1,'2020-10-30 00:37:07','2020-10-30 00:37:07',NULL,NULL),(4,5,1,'2020-11-06 22:34:18','2020-11-06 22:34:18',NULL,NULL),(5,4,1,'2020-11-06 22:34:33','2020-11-06 22:34:33',NULL,NULL),(6,1,3,'2020-12-30 14:30:51','2020-12-30 14:30:51',NULL,NULL),(7,6,3,'2020-12-30 14:37:25','2020-12-30 14:37:25',NULL,NULL);
/*!40000 ALTER TABLE `facility_projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issue_severities`
--

DROP TABLE IF EXISTS `issue_severities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issue_severities` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_severities`
--

LOCK TABLES `issue_severities` WRITE;
/*!40000 ALTER TABLE `issue_severities` DISABLE KEYS */;
INSERT INTO `issue_severities` VALUES (1,'Extreme','2020-10-30 00:42:14','2020-10-30 00:42:14'),(2,'Health Priority','2020-10-30 00:42:29','2020-10-30 00:42:29');
/*!40000 ALTER TABLE `issue_severities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issue_stages`
--

DROP TABLE IF EXISTS `issue_stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issue_stages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `percentage` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_stages`
--

LOCK TABLES `issue_stages` WRITE;
/*!40000 ALTER TABLE `issue_stages` DISABLE KEYS */;
INSERT INTO `issue_stages` VALUES (1,'Phase I','2020-12-15 14:57:14','2020-12-15 14:57:14',0),(2,'Phase II','2020-12-15 14:57:29','2020-12-15 14:57:29',25),(3,'Phase III','2020-12-15 14:57:44','2020-12-15 14:57:44',50),(4,'Phase IV','2020-12-15 14:58:01','2020-12-15 14:58:01',75),(5,'Phase V','2020-12-15 14:58:31','2020-12-15 14:58:31',76);
/*!40000 ALTER TABLE `issue_stages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issue_types`
--

DROP TABLE IF EXISTS `issue_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issue_types` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_types`
--

LOCK TABLES `issue_types` WRITE;
/*!40000 ALTER TABLE `issue_types` DISABLE KEYS */;
INSERT INTO `issue_types` VALUES (1,'Test','2020-10-23 13:40:42','2020-10-23 13:40:55'),(2,'Another test','2020-10-23 13:41:05','2020-10-23 13:41:05');
/*!40000 ALTER TABLE `issue_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issue_users`
--

DROP TABLE IF EXISTS `issue_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issue_users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `issue_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_issue_users_on_user_id` (`user_id`),
  KEY `index_issue_users_on_issue_id` (`issue_id`),
  CONSTRAINT `fk_rails_a68dc2b01f` FOREIGN KEY (`issue_id`) REFERENCES `issues` (`id`),
  CONSTRAINT `fk_rails_b77bcdcb95` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_users`
--

LOCK TABLES `issue_users` WRITE;
/*!40000 ALTER TABLE `issue_users` DISABLE KEYS */;
INSERT INTO `issue_users` VALUES (10,4,6,'2020-11-04 20:35:21','2020-11-04 20:35:21'),(11,2,7,'2020-11-05 22:02:23','2020-11-05 22:02:23'),(13,2,13,'2020-12-10 18:51:33','2020-12-10 18:51:33'),(17,11,19,'2020-12-10 22:25:51','2020-12-10 22:25:51'),(18,4,13,'2020-12-17 17:54:54','2020-12-17 17:54:54'),(19,2,20,'2020-12-17 18:09:11','2020-12-17 18:09:11'),(20,6,16,'2020-12-17 21:15:55','2020-12-17 21:15:55');
/*!40000 ALTER TABLE `issue_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issues`
--

DROP TABLE IF EXISTS `issues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issues` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `issue_type_id` bigint(20) DEFAULT NULL,
  `issue_severity_id` bigint(20) DEFAULT NULL,
  `facility_project_id` bigint(20) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `progress` int(11) DEFAULT 0,
  `auto_calculate` tinyint(1) DEFAULT 1,
  `watched` tinyint(1) DEFAULT 0,
  `watched_at` datetime DEFAULT NULL,
  `issue_stage_id` bigint(20) DEFAULT NULL,
  `kanban_order` int(11) DEFAULT 0,
  `task_type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_issues_on_issue_type_id` (`issue_type_id`),
  KEY `index_issues_on_issue_severity_id` (`issue_severity_id`),
  KEY `index_issues_on_facility_project_id` (`facility_project_id`),
  KEY `index_issues_on_issue_stage_id` (`issue_stage_id`),
  CONSTRAINT `fk_rails_35466cac28` FOREIGN KEY (`issue_stage_id`) REFERENCES `issue_stages` (`id`),
  CONSTRAINT `fk_rails_500505dd6c` FOREIGN KEY (`issue_type_id`) REFERENCES `issue_types` (`id`),
  CONSTRAINT `fk_rails_be5361d9be` FOREIGN KEY (`facility_project_id`) REFERENCES `facility_projects` (`id`),
  CONSTRAINT `fk_rails_be6ee4770c` FOREIGN KEY (`issue_severity_id`) REFERENCES `issue_severities` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issues`
--

LOCK TABLES `issues` WRITE;
/*!40000 ALTER TABLE `issues` DISABLE KEYS */;
INSERT INTO `issues` VALUES (6,'Another Test Issue','Nothing to say here',1,1,3,'2020-11-22','2020-11-26','2020-11-04 20:35:21','2020-11-04 20:35:21',0,1,0,NULL,NULL,0,NULL),(7,'Pane still hangs','',2,2,3,'2020-11-01','2020-11-06','2020-11-05 22:02:23','2020-11-05 22:02:23',0,1,0,NULL,NULL,0,NULL),(13,'Another Test Issue','er',2,2,2,'2020-11-25','2020-11-28','2020-11-07 17:32:17','2020-12-04 17:47:14',21,0,0,'2020-12-04 17:47:14',NULL,0,NULL),(15,'Issue ABC','ewfsg',2,2,2,'2020-11-25','2020-12-19','2020-11-10 18:40:34','2020-12-18 17:17:08',0,1,0,'2020-12-03 22:36:20',NULL,0,NULL),(16,'Another Test Issue','',2,2,2,'2020-11-18','2020-11-28','2020-11-10 20:14:54','2020-11-10 20:14:54',0,1,0,NULL,NULL,0,NULL),(18,'Pagination','',2,2,2,'2020-11-23','2020-11-25','2020-11-16 21:40:56','2020-11-16 21:40:56',0,1,0,NULL,NULL,0,NULL),(19,'To have pagination','',2,1,2,'2020-11-01','2020-11-17','2020-11-16 21:41:22','2020-12-03 22:56:12',0,1,1,'2020-12-03 22:56:12',NULL,0,NULL),(20,'Checking if the On Watch Filter works','',1,2,2,'2020-12-01','2020-12-31','2020-12-04 17:24:02','2020-12-04 17:24:32',0,1,1,'2020-12-04 17:24:32',NULL,0,NULL),(21,'Asterisks for required fields','',1,2,2,'2020-12-27','2021-11-15','2020-12-18 20:51:07','2020-12-21 18:16:30',0,1,1,'2020-12-21 18:16:30',NULL,0,NULL);
/*!40000 ALTER TABLE `issues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notes`
--

DROP TABLE IF EXISTS `notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `noteable_type` varchar(255) DEFAULT NULL,
  `noteable_id` int(11) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `body` longtext DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_notes_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notes`
--

LOCK TABLES `notes` WRITE;
/*!40000 ALTER TABLE `notes` DISABLE KEYS */;
INSERT INTO `notes` VALUES (1,'Task',16,1,'Sample note 1','2020-11-02 12:52:33','2020-11-02 12:52:33'),(2,'Task',16,1,'Sample note 2','2020-11-02 12:52:33','2020-11-02 12:52:33'),(4,'Task',17,1,'Update 1','2020-11-04 16:42:41','2020-11-04 16:42:41'),(5,'Task',17,1,'Update 2','2020-11-04 16:43:21','2020-11-04 16:43:21'),(6,'Issue',5,1,'Test Note','2020-11-04 20:07:13','2020-11-04 20:07:13'),(7,'Issue',5,1,'Test note 2','2020-11-04 20:15:57','2020-11-04 20:15:57'),(8,'Issue',5,1,'This is a test note.  Houston, we have a problem.','2020-11-04 20:16:19','2020-11-04 20:34:22'),(9,'FacilityProject',3,1,'Example','2020-11-05 15:44:49','2020-11-05 15:44:49'),(10,'FacilityProject',3,1,'Note....ANother note here','2020-11-05 15:45:04','2020-11-05 15:45:04'),(11,'Task',20,1,'Test','2020-11-05 23:35:35','2020-11-05 23:35:35'),(12,'Task',20,1,'Test 2','2020-11-05 23:35:49','2020-11-05 23:35:49'),(13,'Task',20,1,'Test 3','2020-11-05 23:36:03','2020-11-05 23:36:03'),(14,'Task',20,1,'Test 4','2020-11-05 23:36:12','2020-11-05 23:36:12'),(15,'Task',20,1,'Another test','2020-11-05 23:37:20','2020-11-05 23:37:20'),(16,'Task',20,1,'Another test','2020-11-05 23:37:20','2020-11-05 23:37:20'),(17,'Task',34,1,'la;kdfslkndfknsdlknlksf','2020-11-06 19:09:56','2020-11-06 19:09:56'),(18,'Issue',10,1,'alskdfnl;kasfdnsdankdvs','2020-11-06 23:28:24','2020-11-06 23:28:24'),(21,'FacilityProject',4,1,'My saved note.','2020-11-12 20:35:47','2020-11-12 21:00:02'),(22,'Task',61,1,'We\'re in big trouble!','2020-11-14 19:46:36','2020-12-02 01:05:20'),(23,'Task',62,1,'wealgsnm:ALEFMD:LAWMGVF','2020-11-14 19:46:58','2020-11-14 19:46:58'),(24,'Task',64,1,'es.bfmg s:LEAR<WG:','2020-11-14 19:47:25','2020-11-14 19:47:25'),(25,'Task',65,1,'.asedj fnbl/dfm bsa dg/s /gva/w,g b/asm fg/ldfl wa;l,mfe;lw,fmf;le;flmwa;/ergreg','2020-11-14 19:47:51','2020-11-14 19:47:51'),(26,'Task',53,1,'dffffffffffffffffffffffffffffff','2020-11-16 17:22:05','2020-11-16 17:22:05'),(31,'Task',46,1,'dsgdgdgf','2020-11-16 17:23:16','2020-11-16 17:23:16'),(32,'Task',46,1,'dfghdfgbtrsgh','2020-11-16 17:23:27','2020-11-16 17:23:27'),(39,'Task',46,1,'This is the last note written by me.','2020-11-17 19:36:10','2020-11-17 19:36:10'),(41,'Task',46,1,'rtgesrgtrsg','2020-11-18 16:16:31','2020-11-18 16:16:31'),(42,'Task',46,1,'aewrgsrhg','2020-11-18 17:52:42','2020-11-18 17:52:42'),(43,'Task',46,1,'awegsdrge','2020-11-18 17:52:51','2020-11-18 17:52:51'),(44,'Issue',13,1,'Testing Last Update sorting','2020-12-03 23:46:36','2020-12-03 23:46:36'),(45,'Issue',16,1,'Testing sorting order.','2020-12-04 15:53:51','2020-12-04 15:53:51'),(47,'FacilityProject',4,2,'fesd','2020-12-23 16:24:13','2020-12-23 16:24:13'),(48,'FacilityProject',5,2,'Test','2020-12-23 16:40:40','2020-12-23 16:40:40'),(49,'Risk',2,1,'Test','2020-12-30 22:46:02','2020-12-30 22:46:02'),(50,'Risk',2,1,'Another Note','2020-12-30 22:50:48','2020-12-30 22:50:48'),(52,'Risk',2,1,'My Note comes here......','2020-12-30 23:56:06','2020-12-30 23:56:06');
/*!40000 ALTER TABLE `notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organizations`
--

DROP TABLE IF EXISTS `organizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organizations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organizations`
--

LOCK TABLES `organizations` WRITE;
/*!40000 ALTER TABLE `organizations` DISABLE KEYS */;
INSERT INTO `organizations` VALUES (1,'Org 1 Test','2020-10-28 22:06:20','2020-10-28 22:06:20'),(2,'Acme Org','2020-10-28 22:07:34','2020-10-28 22:07:34'),(3,'Another One Co.','2020-10-28 22:07:47','2020-10-28 22:07:47');
/*!40000 ALTER TABLE `organizations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `privileges`
--

DROP TABLE IF EXISTS `privileges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `privileges` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `overview` varchar(255) DEFAULT 'R',
  `tasks` varchar(255) DEFAULT 'R',
  `notes` varchar(255) DEFAULT 'R',
  `issues` varchar(255) DEFAULT 'R',
  `admin` varchar(255) DEFAULT '',
  `user_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `map_view` varchar(255) DEFAULT 'R',
  `gantt_view` varchar(255) DEFAULT 'R',
  `watch_view` varchar(255) DEFAULT 'R',
  `documents` varchar(255) DEFAULT 'R',
  `members` varchar(255) DEFAULT 'R',
  `facility_manager_view` varchar(255) DEFAULT 'R',
  `sheets_view` varchar(255) DEFAULT 'R',
  `kanban_view` varchar(255) DEFAULT 'R',
  `risks` varchar(255) DEFAULT 'R',
  PRIMARY KEY (`id`),
  KEY `index_privileges_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_fa4d6ee0e7` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `privileges`
--

LOCK TABLES `privileges` WRITE;
/*!40000 ALTER TABLE `privileges` DISABLE KEYS */;
INSERT INTO `privileges` VALUES (2,'RWD','RWD','RWD','RWD','RWD',2,'2020-10-28 13:24:44','2020-12-23 15:12:25','R','R','R','R','R','R','R','R','RWD'),(3,'R','R','R','R','',3,'2020-10-28 13:25:32','2020-10-28 13:25:32','R','R','R','R','R','R','R','R','R'),(4,'R','R','R','R','',4,'2020-10-28 13:26:36','2020-10-28 13:26:36','R','R','R','R','R','R','R','R','R'),(5,'R','R','R','R','',5,'2020-10-28 15:42:40','2020-10-28 15:42:40','R','R','R','R','R','R','R','R','R'),(6,'R','R','R','R','',6,'2020-11-02 14:32:56','2020-11-02 14:32:56','R','R','R','R','R','R','R','R','R'),(11,'R','R','R','R','',7,'2020-11-29 02:13:25','2020-11-29 02:13:25','R','R','R','R','R','R','R','R','R'),(12,'R','R','R','R','',8,'2020-11-29 02:14:08','2020-11-29 02:14:08','R','R','R','R','R','R','R','R','R'),(13,'R','R','R','R','',9,'2020-11-29 02:14:52','2020-11-29 02:14:52','R','R','R','R','R','R','R','R','R'),(14,'R','R','R','R','',10,'2020-11-29 02:15:31','2020-11-29 02:15:31','R','R','R','R','R','R','R','R','R'),(15,'R','R','R','R','',11,'2020-11-29 02:16:14','2020-11-29 02:16:14','R','R','R','R','R','R','R','R','R'),(17,'RWD','RWD','RWD','RWD','RWD',1,'2020-12-09 01:00:54','2020-12-09 01:00:54','RWD','RWD','RWD','RWD','RWD','R','R','R','R');
/*!40000 ALTER TABLE `privileges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_issue_severities`
--

DROP TABLE IF EXISTS `project_issue_severities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_issue_severities` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `issue_severity_id` bigint(20) DEFAULT NULL,
  `project_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_project_issue_severities_on_issue_severity_id` (`issue_severity_id`),
  KEY `index_project_issue_severities_on_project_id` (`project_id`),
  CONSTRAINT `fk_rails_823df13527` FOREIGN KEY (`issue_severity_id`) REFERENCES `issue_severities` (`id`),
  CONSTRAINT `fk_rails_f5e646feb4` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_issue_severities`
--

LOCK TABLES `project_issue_severities` WRITE;
/*!40000 ALTER TABLE `project_issue_severities` DISABLE KEYS */;
INSERT INTO `project_issue_severities` VALUES (1,1,1,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(2,2,1,'2020-12-08 14:48:24','2020-12-08 14:48:24'),(3,1,2,'2020-12-08 14:48:24','2020-12-08 14:48:24'),(4,2,2,'2020-12-08 14:48:24','2020-12-08 14:48:24'),(5,1,3,'2020-12-08 14:48:24','2020-12-08 14:48:24'),(6,2,3,'2020-12-08 14:48:24','2020-12-08 14:48:24'),(7,1,4,'2020-12-08 14:48:24','2020-12-08 14:48:24'),(8,2,4,'2020-12-08 14:48:24','2020-12-08 14:48:24');
/*!40000 ALTER TABLE `project_issue_severities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_issue_stages`
--

DROP TABLE IF EXISTS `project_issue_stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_issue_stages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `issue_stage_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_issue_stages`
--

LOCK TABLES `project_issue_stages` WRITE;
/*!40000 ALTER TABLE `project_issue_stages` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_issue_stages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_issue_types`
--

DROP TABLE IF EXISTS `project_issue_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_issue_types` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `issue_type_id` bigint(20) DEFAULT NULL,
  `project_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_project_issue_types_on_issue_type_id` (`issue_type_id`),
  KEY `index_project_issue_types_on_project_id` (`project_id`),
  CONSTRAINT `fk_rails_22e75f29b4` FOREIGN KEY (`issue_type_id`) REFERENCES `issue_types` (`id`),
  CONSTRAINT `fk_rails_d8d3bb6b35` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_issue_types`
--

LOCK TABLES `project_issue_types` WRITE;
/*!40000 ALTER TABLE `project_issue_types` DISABLE KEYS */;
INSERT INTO `project_issue_types` VALUES (1,1,1,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(2,2,1,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(3,1,2,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(4,2,2,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(5,1,3,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(6,2,3,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(7,1,4,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(8,2,4,'2020-12-08 14:48:23','2020-12-08 14:48:23');
/*!40000 ALTER TABLE `project_issue_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_risk_stages`
--

DROP TABLE IF EXISTS `project_risk_stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_risk_stages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `risk_stage_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_risk_stages`
--

LOCK TABLES `project_risk_stages` WRITE;
/*!40000 ALTER TABLE `project_risk_stages` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_risk_stages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_statuses`
--

DROP TABLE IF EXISTS `project_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_statuses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `status_id` bigint(20) DEFAULT NULL,
  `project_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_project_statuses_on_status_id` (`status_id`),
  KEY `index_project_statuses_on_project_id` (`project_id`),
  CONSTRAINT `fk_rails_3cf2a2e96d` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`),
  CONSTRAINT `fk_rails_b87eb0e304` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_statuses`
--

LOCK TABLES `project_statuses` WRITE;
/*!40000 ALTER TABLE `project_statuses` DISABLE KEYS */;
INSERT INTO `project_statuses` VALUES (1,1,1,'2020-12-22 18:09:23','2020-12-22 18:09:23'),(2,2,1,'2020-12-22 18:09:23','2020-12-22 18:09:23'),(3,3,1,'2020-12-22 18:09:23','2020-12-22 18:09:23'),(4,1,3,'2020-12-30 14:36:55','2020-12-30 14:36:55');
/*!40000 ALTER TABLE `project_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_task_stages`
--

DROP TABLE IF EXISTS `project_task_stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_task_stages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `task_stage_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_task_stages`
--

LOCK TABLES `project_task_stages` WRITE;
/*!40000 ALTER TABLE `project_task_stages` DISABLE KEYS */;
INSERT INTO `project_task_stages` VALUES (2,1,2,'2020-12-29 21:32:38','2020-12-29 21:32:38'),(10,1,1,'2020-12-30 01:01:32','2020-12-30 01:01:32'),(11,1,3,'2020-12-30 01:01:32','2020-12-30 01:01:32'),(12,1,4,'2020-12-30 01:01:32','2020-12-30 01:01:32'),(13,1,5,'2020-12-30 01:01:32','2020-12-30 01:01:32'),(14,3,2,'2020-12-30 14:36:55','2020-12-30 14:36:55');
/*!40000 ALTER TABLE `project_task_stages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_task_types`
--

DROP TABLE IF EXISTS `project_task_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_task_types` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_type_id` bigint(20) DEFAULT NULL,
  `project_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_project_task_types_on_task_type_id` (`task_type_id`),
  KEY `index_project_task_types_on_project_id` (`project_id`),
  CONSTRAINT `fk_rails_1f2a1640e6` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`),
  CONSTRAINT `fk_rails_970592b1ef` FOREIGN KEY (`task_type_id`) REFERENCES `task_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_task_types`
--

LOCK TABLES `project_task_types` WRITE;
/*!40000 ALTER TABLE `project_task_types` DISABLE KEYS */;
INSERT INTO `project_task_types` VALUES (1,1,1,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(2,2,1,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(3,3,1,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(4,1,2,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(5,2,2,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(6,3,2,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(7,1,3,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(8,2,3,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(9,3,3,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(10,1,4,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(11,2,4,'2020-12-08 14:48:23','2020-12-08 14:48:23'),(12,3,4,'2020-12-08 14:48:23','2020-12-08 14:48:23');
/*!40000 ALTER TABLE `project_task_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_types`
--

DROP TABLE IF EXISTS `project_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_types` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_types`
--

LOCK TABLES `project_types` WRITE;
/*!40000 ALTER TABLE `project_types` DISABLE KEYS */;
INSERT INTO `project_types` VALUES (1,'DevOps','2020-10-23 13:41:41','2020-10-23 13:41:41'),(2,'Enhancements','2020-10-28 14:26:29','2020-10-28 14:26:29');
/*!40000 ALTER TABLE `project_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_users`
--

DROP TABLE IF EXISTS `project_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `project_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_project_users_on_project_id` (`project_id`),
  KEY `index_project_users_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_1bf16ed5d0` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`),
  CONSTRAINT `fk_rails_996d73fecd` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_users`
--

LOCK TABLES `project_users` WRITE;
/*!40000 ALTER TABLE `project_users` DISABLE KEYS */;
INSERT INTO `project_users` VALUES (2,2,1,'2020-10-23 17:01:36','2020-10-23 17:01:36'),(4,4,1,'2020-10-26 19:36:34','2020-10-26 19:36:34'),(5,1,4,'2020-10-28 13:28:42','2020-10-28 13:28:42'),(6,1,3,'2020-10-28 13:28:52','2020-10-28 13:28:52'),(7,1,2,'2020-10-28 13:29:02','2020-10-28 13:29:02'),(8,1,6,'2020-11-02 14:33:12','2020-11-02 14:33:12'),(10,1,10,'2020-11-29 02:17:19','2020-11-29 02:17:19'),(11,1,9,'2020-11-29 02:17:26','2020-11-29 02:17:26'),(12,1,8,'2020-11-29 02:17:33','2020-11-29 02:17:33'),(13,1,7,'2020-11-29 02:17:42','2020-11-29 02:17:42'),(14,1,5,'2020-11-29 02:17:53','2020-11-29 02:17:53'),(19,1,1,'2020-12-30 01:01:32','2020-12-30 01:01:32'),(20,3,2,'2020-12-30 14:36:55','2020-12-30 14:36:55'),(21,3,7,'2020-12-30 14:36:55','2020-12-30 14:36:55'),(22,3,1,'2020-12-30 14:36:55','2020-12-30 14:36:55');
/*!40000 ALTER TABLE `project_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `projects` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  `project_type_id` bigint(20) DEFAULT NULL,
  `status` int(11) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_projects_on_uuid` (`uuid`),
  KEY `index_projects_on_project_type_id` (`project_type_id`),
  CONSTRAINT `fk_rails_d7ca4cafeb` FOREIGN KEY (`project_type_id`) REFERENCES `project_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
INSERT INTO `projects` VALUES (1,'DevOps','Blah','2020-10-23 13:42:09','2020-10-23 13:42:09','c0e19db4-8b5d-4183-9719-8e14db6429ac',1,1),(2,'Project 2','','2020-10-23 17:01:36','2020-10-23 17:01:36','bbada036-b5e9-49b2-932a-91ef4ef2e55e',1,1),(3,'Project 3','Another one','2020-10-23 17:03:06','2020-10-23 17:03:06','16c001cc-b42c-4f25-9e3e-d6661e14f448',1,1),(4,'Another Project','','2020-10-26 19:36:34','2020-10-26 19:36:34','07116a82-de68-4ca5-8be2-c8076358f784',1,1);
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `region_states`
--

DROP TABLE IF EXISTS `region_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `region_states` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `facility_group_id` bigint(20) DEFAULT NULL,
  `state_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_region_states_on_facility_group_id` (`facility_group_id`),
  KEY `index_region_states_on_state_id` (`state_id`),
  CONSTRAINT `fk_rails_3d95969824` FOREIGN KEY (`facility_group_id`) REFERENCES `facility_groups` (`id`),
  CONSTRAINT `fk_rails_440e5fbf9c` FOREIGN KEY (`state_id`) REFERENCES `states` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `region_states`
--

LOCK TABLES `region_states` WRITE;
/*!40000 ALTER TABLE `region_states` DISABLE KEYS */;
/*!40000 ALTER TABLE `region_states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `related_issues`
--

DROP TABLE IF EXISTS `related_issues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `related_issues` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `relatable_type` varchar(255) DEFAULT NULL,
  `relatable_id` int(11) DEFAULT NULL,
  `issue_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_related_issues_on_issue_id` (`issue_id`),
  CONSTRAINT `fk_rails_7bc934491d` FOREIGN KEY (`issue_id`) REFERENCES `issues` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `related_issues`
--

LOCK TABLES `related_issues` WRITE;
/*!40000 ALTER TABLE `related_issues` DISABLE KEYS */;
/*!40000 ALTER TABLE `related_issues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `related_risks`
--

DROP TABLE IF EXISTS `related_risks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `related_risks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `relatable_type` varchar(255) DEFAULT NULL,
  `relatable_id` int(11) DEFAULT NULL,
  `risk_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_related_risks_on_risk_id` (`risk_id`),
  CONSTRAINT `fk_rails_3edbf9c8c9` FOREIGN KEY (`risk_id`) REFERENCES `risks` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `related_risks`
--

LOCK TABLES `related_risks` WRITE;
/*!40000 ALTER TABLE `related_risks` DISABLE KEYS */;
/*!40000 ALTER TABLE `related_risks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `related_tasks`
--

DROP TABLE IF EXISTS `related_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `related_tasks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `relatable_type` varchar(255) DEFAULT NULL,
  `relatable_id` int(11) DEFAULT NULL,
  `task_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_related_tasks_on_task_id` (`task_id`),
  CONSTRAINT `fk_rails_bba8b7f644` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `related_tasks`
--

LOCK TABLES `related_tasks` WRITE;
/*!40000 ALTER TABLE `related_tasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `related_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `risk_stages`
--

DROP TABLE IF EXISTS `risk_stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `risk_stages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `percentage` int(11) DEFAULT 0,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `risk_stages`
--

LOCK TABLES `risk_stages` WRITE;
/*!40000 ALTER TABLE `risk_stages` DISABLE KEYS */;
INSERT INTO `risk_stages` VALUES (1,'High',40,'2021-01-05 22:09:29','2021-01-05 22:09:29');
/*!40000 ALTER TABLE `risk_stages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `risk_users`
--

DROP TABLE IF EXISTS `risk_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `risk_users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `risk_id` bigint(20) DEFAULT NULL,
  `timestamps` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_risk_users_on_user_id` (`user_id`),
  KEY `index_risk_users_on_risk_id` (`risk_id`),
  CONSTRAINT `fk_rails_32decc8a6e` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_67aff1904f` FOREIGN KEY (`risk_id`) REFERENCES `risks` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `risk_users`
--

LOCK TABLES `risk_users` WRITE;
/*!40000 ALTER TABLE `risk_users` DISABLE KEYS */;
INSERT INTO `risk_users` VALUES (9,8,2,NULL),(10,5,3,NULL),(11,6,2,NULL),(12,10,4,NULL);
/*!40000 ALTER TABLE `risk_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `risks`
--

DROP TABLE IF EXISTS `risks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `risks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `risk_description` text DEFAULT NULL,
  `impact_description` text DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `auto_calculate` tinyint(1) DEFAULT 1,
  `progress` int(11) DEFAULT 0,
  `probability` int(11) DEFAULT 1,
  `impact_level` int(11) DEFAULT 1,
  `priority_level` int(11) DEFAULT 1,
  `risk_approach` int(11) DEFAULT 0,
  `risk_approach_description` text DEFAULT NULL,
  `watched` tinyint(1) DEFAULT 0,
  `watched_at` datetime DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `facility_project_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `task_type_id` bigint(20) DEFAULT NULL,
  `text` varchar(255) DEFAULT NULL,
  `risk_id` bigint(20) DEFAULT NULL,
  `kanban_order` int(11) DEFAULT 0,
  `risk_stage_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_risks_on_user_id` (`user_id`),
  KEY `index_risks_on_facility_project_id` (`facility_project_id`),
  KEY `index_risks_on_task_type_id` (`task_type_id`),
  KEY `index_risks_on_risk_stage_id` (`risk_stage_id`),
  CONSTRAINT `fk_rails_06a747713d` FOREIGN KEY (`facility_project_id`) REFERENCES `facility_projects` (`id`),
  CONSTRAINT `fk_rails_4ca50b9b4a` FOREIGN KEY (`task_type_id`) REFERENCES `task_types` (`id`),
  CONSTRAINT `fk_rails_69bd83b255` FOREIGN KEY (`risk_stage_id`) REFERENCES `risk_stages` (`id`),
  CONSTRAINT `fk_rails_afb2ad6b53` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `risks`
--

LOCK TABLES `risks` WRITE;
/*!40000 ALTER TABLE `risks` DISABLE KEYS */;
INSERT INTO `risks` VALUES (1,'Test','','2020-12-07','2020-12-24',1,0,1,1,1,0,'',0,NULL,1,6,'2020-12-30 14:30:51','2021-01-06 15:05:14',1,'Foreign Intelligence Agents',NULL,0,NULL),(2,'Risk test 1','Test','2020-12-13','2021-01-29',1,0,1,1,1,0,'Test',0,NULL,1,2,'2020-12-30 15:25:30','2020-12-31 13:59:28',2,'High Risk ',NULL,0,NULL),(3,'Risk test 2','High','2020-12-27','2021-03-18',1,0,1,1,1,0,'IDK',0,NULL,1,2,'2020-12-30 15:26:44','2020-12-31 13:40:37',3,'Risky Business',NULL,0,NULL),(4,'Risk','Risk','2021-01-04','2021-05-15',1,0,1,1,1,0,'R',0,NULL,1,4,'2021-01-05 18:04:05','2021-01-06 18:10:13',2,'First Risk',NULL,0,NULL);
/*!40000 ALTER TABLE `risks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20191216191934'),('20191218035514'),('20191228080444'),('20191228105416'),('20191228110603'),('20191228112004'),('20191228112007'),('20200101130339'),('20200103122000'),('20200106131234'),('20200108090920'),('20200108131657'),('20200113133144'),('20200113133747'),('20200113134248'),('20200116100026'),('20200117020222'),('20200117101350'),('20200117133117'),('20200123020840'),('20200124135221'),('20200124175327'),('20200124175331'),('20200212101952'),('20200212114758'),('20200212114927'),('20200218092536'),('20200224133049'),('20200224143048'),('20200226083401'),('20200227094335'),('20200227094548'),('20200228102835'),('20200228103325'),('20200302115313'),('20200303035923'),('20200306141948'),('20200306142713'),('20200317134809'),('20200324123452'),('20200330121604'),('20200402074854'),('20200408152526'),('20200409064741'),('20200409072456'),('20200409082447'),('20200420151228'),('20200423123857'),('20200501042753'),('20200504185315'),('20200504195558'),('20200506041609'),('20200514064709'),('20200521144759'),('20200528085915'),('20200528085929'),('20200528085939'),('20200528085950'),('20200530100431'),('20200603080452'),('20200611091751'),('20200616081726'),('20200702121127'),('20200723134817'),('20200807100741'),('20200807100758'),('20200808070841'),('20200817092553'),('20200818085817'),('20200909095910'),('20200921072951'),('20200930081004'),('20201006210408'),('20201006212644'),('20201009064837'),('20201009065229'),('20201015082958'),('20201023114005'),('20201031015327'),('20201102162746'),('20201111142529'),('20201116143905'),('20201116143913'),('20201116145647'),('20201116160716'),('20201126075449'),('20201130074254'),('20201203215312'),('20201204141844'),('20201204150339'),('20201204151813'),('20201204151828'),('20201209154029'),('20201210141541'),('20201210141626'),('20201215142105'),('20201217175902'),('20201217182144'),('20201217202820'),('20201230130528'),('20201230163344'),('20201230221803'),('20201230221900'),('20201231031549'),('20210101112344');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `office365_key` text DEFAULT NULL,
  `office365_secret` text DEFAULT NULL,
  `google_map_key` text DEFAULT NULL,
  `google_oauth_key` text DEFAULT NULL,
  `google_oauth_secret` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `passwords_key` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES (1,'','','','','','2020-10-22 15:36:39','2020-10-26 16:36:08','{\"range\":\"12\",\"uppercase\":true,\"lowercase\":true,\"numbers\":true,\"special_chars\":true}');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sorts`
--

DROP TABLE IF EXISTS `sorts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sorts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `relation` varchar(255) DEFAULT NULL,
  `column` varchar(255) DEFAULT 'id',
  `order` varchar(255) DEFAULT 'asc',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sorts`
--

LOCK TABLES `sorts` WRITE;
/*!40000 ALTER TABLE `sorts` DISABLE KEYS */;
INSERT INTO `sorts` VALUES (1,'checklists','id','asc','2020-10-22 02:10:13','2020-10-22 02:10:13'),(2,'facilities','id','asc','2020-10-22 02:10:14','2020-10-22 02:10:14'),(3,'facility_groups','id','asc','2020-10-22 02:10:14','2020-10-22 02:10:14'),(4,'facility_projects','id','asc','2020-10-22 02:10:14','2020-10-22 02:10:14'),(5,'issue_severities','id','asc','2020-10-22 02:10:14','2020-10-22 02:10:14'),(6,'issue_types','id','asc','2020-10-22 02:10:14','2020-10-22 02:10:14'),(7,'issue_users','id','asc','2020-10-22 02:10:14','2020-10-22 02:10:14'),(8,'issues','id','asc','2020-10-22 02:10:14','2020-10-22 02:10:14'),(9,'notes','id','asc','2020-10-22 02:10:14','2020-10-22 02:10:14'),(10,'privileges','id','asc','2020-10-22 02:10:14','2020-10-22 02:10:14'),(11,'project_types','id','asc','2020-10-22 02:10:14','2020-10-22 02:10:14'),(12,'project_users','id','asc','2020-10-22 02:10:14','2020-10-22 02:10:14'),(13,'projects','name','desc','2020-10-22 02:10:14','2020-10-23 17:03:39'),(14,'region_states','id','asc','2020-10-22 02:10:14','2020-10-22 02:10:14'),(15,'statuses','id','asc','2020-10-22 02:10:14','2020-10-22 02:10:14'),(16,'task_types','id','asc','2020-10-22 02:10:14','2020-10-22 02:10:14'),(17,'tasks','id','asc','2020-10-22 02:10:14','2020-10-22 02:10:14'),(18,'users','id','asc','2020-10-22 02:10:14','2020-10-22 02:10:14'),(19,'task_stages','id','asc','2020-11-20 14:15:50','2020-11-20 14:15:50'),(20,'issue_stages','id','asc','2020-11-20 14:15:50','2020-11-20 14:15:50'),(21,'risk_milestones','id','asc','2020-12-17 14:44:12','2020-12-17 14:44:12'),(22,'risk_stages','name','desc','2021-01-06 17:32:03','2021-01-06 17:32:03');
/*!40000 ALTER TABLE `sorts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `states`
--

DROP TABLE IF EXISTS `states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `states` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `center` varchar(255) DEFAULT '[]',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `states`
--

LOCK TABLES `states` WRITE;
/*!40000 ALTER TABLE `states` DISABLE KEYS */;
/*!40000 ALTER TABLE `states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `statuses`
--

DROP TABLE IF EXISTS `statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `statuses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `color` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statuses`
--

LOCK TABLES `statuses` WRITE;
/*!40000 ALTER TABLE `statuses` DISABLE KEYS */;
INSERT INTO `statuses` VALUES (1,'COVID Treatement Center','2020-12-22 18:02:18','2020-12-22 18:02:18','#000000'),(2,'Public Treatment Center','2020-12-22 18:02:36','2020-12-22 18:02:36','#000000'),(3,'Military Treatment Center','2020-12-22 18:02:59','2020-12-22 18:02:59','#a81a1a');
/*!40000 ALTER TABLE `statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_stages`
--

DROP TABLE IF EXISTS `task_stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_stages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `percentage` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_stages`
--

LOCK TABLES `task_stages` WRITE;
/*!40000 ALTER TABLE `task_stages` DISABLE KEYS */;
INSERT INTO `task_stages` VALUES (1,'Crawl','2020-11-20 18:44:49','2020-12-29 14:37:52',20),(2,'Walk','2020-11-20 18:44:56','2020-11-20 18:44:56',0),(3,'Run','2020-11-20 18:45:02','2020-11-20 18:45:02',0),(4,'Fly','2020-11-20 18:45:13','2020-11-20 18:45:13',0),(5,'Transcend','2020-12-30 00:59:47','2020-12-30 00:59:47',0);
/*!40000 ALTER TABLE `task_stages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_types`
--

DROP TABLE IF EXISTS `task_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_types` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_types`
--

LOCK TABLES `task_types` WRITE;
/*!40000 ALTER TABLE `task_types` DISABLE KEYS */;
INSERT INTO `task_types` VALUES (1,'Deleting Tasks','2020-10-30 00:17:43','2020-10-30 00:17:43'),(2,'Another One','2020-11-18 23:04:34','2020-11-18 23:04:34'),(3,'New Task Category','2020-11-23 22:52:38','2020-11-23 22:52:38'),(4,'Software Upgrades','2020-12-15 15:25:43','2020-12-15 15:25:43');
/*!40000 ALTER TABLE `task_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_users`
--

DROP TABLE IF EXISTS `task_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `task_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_task_users_on_user_id` (`user_id`),
  KEY `index_task_users_on_task_id` (`task_id`),
  CONSTRAINT `fk_rails_0e90c6e6ce` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`),
  CONSTRAINT `fk_rails_62298b9246` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_users`
--

LOCK TABLES `task_users` WRITE;
/*!40000 ALTER TABLE `task_users` DISABLE KEYS */;
INSERT INTO `task_users` VALUES (31,6,46,'2020-12-15 17:21:30','2020-12-15 17:21:30'),(32,2,55,'2020-12-16 17:54:30','2020-12-16 17:54:30'),(35,2,64,'2020-12-16 17:54:53','2020-12-16 17:54:53'),(36,10,55,'2020-12-16 21:49:11','2020-12-16 21:49:11'),(37,2,62,'2020-12-17 15:12:33','2020-12-17 15:12:33'),(39,9,50,'2020-12-17 19:01:03','2020-12-17 19:01:03'),(40,6,62,'2020-12-17 21:53:45','2020-12-17 21:53:45'),(42,2,53,'2020-12-31 13:31:38','2020-12-31 13:31:38');
/*!40000 ALTER TABLE `task_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tasks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `text` varchar(255) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `progress` int(11) DEFAULT 0,
  `task_type_id` bigint(20) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `facility_project_id` bigint(20) DEFAULT NULL,
  `auto_calculate` tinyint(1) DEFAULT 1,
  `watched` tinyint(1) DEFAULT 0,
  `watched_at` datetime DEFAULT NULL,
  `task_stage_id` bigint(20) DEFAULT NULL,
  `kanban_order` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `index_tasks_on_task_type_id` (`task_type_id`),
  KEY `index_tasks_on_facility_project_id` (`facility_project_id`),
  KEY `index_tasks_on_task_stage_id` (`task_stage_id`),
  CONSTRAINT `fk_rails_99e49cf74e` FOREIGN KEY (`facility_project_id`) REFERENCES `facility_projects` (`id`),
  CONSTRAINT `fk_rails_e4591d235e` FOREIGN KEY (`task_stage_id`) REFERENCES `task_stages` (`id`),
  CONSTRAINT `fk_rails_f6eab2208f` FOREIGN KEY (`task_type_id`) REFERENCES `task_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
INSERT INTO `tasks` VALUES (16,'Testing Active Users','','2021-02-24','2020-10-30 13:15:08','2021-01-07 15:43:16',0,1,'2020-10-13',2,0,1,'2020-10-30 13:16:00',3,1),(39,'Make ALL Tables Sortable','','2020-12-18','2020-11-06 23:25:57','2020-12-02 00:11:52',0,1,'2020-11-26',2,1,0,NULL,NULL,0),(40,'Sample Task 1','safdv','2020-11-23','2020-11-09 15:19:09','2020-11-09 15:19:09',0,1,'2020-11-11',5,1,0,NULL,NULL,0),(41,'Sample Task 1','/;df','2020-11-21','2020-11-10 15:01:44','2020-11-10 15:01:44',0,1,'2020-11-18',5,1,0,NULL,NULL,0),(42,'Sample Task 2','','2020-11-26','2020-11-10 15:22:42','2020-11-10 15:22:42',0,1,'2020-11-18',4,1,0,NULL,NULL,0),(46,'Test Overdue Task MAYYBEEEE','','2021-01-08','2020-11-13 00:13:18','2020-12-28 21:17:25',0,1,'2020-11-01',2,0,1,'2020-12-03 22:56:03',NULL,0),(50,'BUY Bookshelves','','2020-11-26','2020-11-14 19:44:13','2020-12-28 22:38:50',0,1,'2020-11-16',2,1,1,'2020-12-28 22:38:50',NULL,0),(51,'Sample Task 2','','2020-11-28','2020-11-14 19:44:24','2020-11-14 19:44:24',0,1,'2020-11-24',2,1,0,NULL,NULL,0),(52,'ewkfnmar','','2020-11-27','2020-11-14 19:44:36','2020-11-17 14:49:47',0,1,'2020-11-22',2,1,1,'2020-11-17 14:49:47',NULL,0),(53,'Taking out the trashes','','2020-11-10','2020-11-14 19:44:49','2021-01-06 15:47:48',31,3,'2020-11-08',2,0,1,'2020-11-17 14:48:02',NULL,1),(54,'Re-installing Batteries','','2020-11-24','2020-11-14 19:45:00','2020-12-01 00:51:04',0,1,'2020-11-12',2,1,1,'2020-11-17 14:48:04',4,1),(55,'Testing Check Due Dates','','2020-11-30','2020-11-14 19:45:10','2020-12-17 19:54:18',0,1,'2020-11-09',2,1,0,'2020-12-03 22:56:34',NULL,0),(56,'eo','','2021-01-14','2020-11-14 19:45:22','2020-11-17 17:53:29',0,1,'2020-11-15',2,1,1,'2020-11-17 17:53:29',NULL,0),(57,'l.er','','2020-11-30','2020-11-14 19:45:33','2020-11-14 19:45:33',0,1,'2020-11-01',2,1,0,NULL,NULL,0),(58,'re','','2020-11-29','2020-11-14 19:45:44','2020-11-14 19:45:44',0,1,'2020-11-01',2,1,0,NULL,NULL,0),(59,'Sample Task 1','','2020-11-30','2020-11-14 19:45:53','2020-11-14 19:45:53',0,1,'2020-11-01',2,1,0,NULL,NULL,0),(60,'Delete this','waerkjl','2020-11-30','2020-11-14 19:46:14','2020-11-14 19:46:14',0,1,'2020-11-08',2,1,0,NULL,NULL,0),(61,'ewwegtf1234er5t','','2020-11-29','2020-11-14 19:46:36','2020-11-14 19:46:36',0,1,'2020-11-22',2,1,0,NULL,NULL,0),(62,'Computer Upgrades','','2020-12-21','2020-11-14 19:46:58','2021-01-07 15:43:16',0,1,'2020-11-02',2,0,1,'2020-12-04 21:44:26',3,0),(63,'ewrgtshd','','2020-11-30','2020-11-14 19:47:06','2020-11-14 19:47:06',0,1,'2020-11-08',2,1,0,NULL,NULL,0),(64,'LET THERE BE TASKS','ew,ramgtbn/','2020-11-30','2020-11-14 19:47:25','2020-12-28 21:16:48',0,1,'2020-11-08',2,1,0,NULL,NULL,0),(65,'waer.kgtsfh/lk mreaf','','2020-12-31','2020-11-14 19:47:51','2020-11-14 19:47:51',0,1,'2020-11-15',2,1,0,NULL,NULL,0),(66,'ewrgtfbsn;,\'mlr/ wem,af','','2020-11-30','2020-11-14 19:48:00','2020-11-14 19:48:00',0,1,'2020-11-01',2,1,0,NULL,NULL,0),(67,'qgtrs/ycbkl fdzs/l gv','','2020-11-30','2020-11-14 19:48:10','2020-11-14 19:48:10',0,1,'2020-11-15',2,1,0,NULL,NULL,0),(68,'Sticky Bars','','2020-11-27','2020-11-16 22:11:10','2020-11-18 15:05:48',0,1,'2020-11-24',2,1,0,NULL,NULL,0),(69,'Sample Task 2','','2020-11-27','2020-11-20 19:41:15','2020-12-18 19:31:44',0,2,'2020-11-16',1,1,1,'2020-12-18 19:31:44',1,1),(70,'ABCCCC','Check this out','2020-12-18','2020-11-24 12:13:34','2020-12-28 21:29:32',0,2,'2020-11-15',2,0,0,NULL,NULL,3),(71,'ON Watch','','2020-12-31','2020-12-04 16:53:21','2021-01-07 15:43:16',0,2,'2020-12-29',2,0,1,'2020-12-04 16:53:38',3,3),(72,'Another On Watch test','','2020-12-31','2020-12-04 21:25:33','2021-01-07 14:47:07',23,2,'2020-12-07',2,0,1,'2020-12-04 21:25:39',NULL,0),(74,'Kanban View','','2021-01-13','2020-12-18 21:39:17','2021-01-07 15:43:16',0,2,'2020-12-28',2,0,0,NULL,3,2),(75,'December Training Phase 3','','2021-03-18','2020-12-24 18:46:01','2020-12-24 18:46:01',0,2,'2020-12-20',2,1,0,NULL,NULL,0),(76,'State Sidebar','','2020-12-31','2020-12-28 21:29:59','2020-12-28 21:29:59',0,3,'2020-12-07',2,1,0,NULL,NULL,0);
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) NOT NULL DEFAULT 0,
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) DEFAULT NULL,
  `last_sign_in_ip` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `role` int(11) DEFAULT 0,
  `provider` varchar(255) DEFAULT NULL,
  `uid` varchar(255) DEFAULT NULL,
  `login` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT 1,
  `lat` varchar(255) DEFAULT NULL,
  `lng` varchar(255) DEFAULT NULL,
  `privileges` varchar(255) DEFAULT '',
  `country_code` varchar(255) DEFAULT '',
  `color` varchar(255) DEFAULT NULL,
  `organization_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`),
  KEY `index_users_on_organization_id` (`organization_id`),
  CONSTRAINT `fk_rails_d7b9ff90af` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin@example.com','$2a$11$0grWfE7KIzuK5LdmG8sBzueDNe7gzi0AM2CHD5haLlJMSIKG/escC',NULL,NULL,NULL,236,'2021-01-08 14:46:58','2021-01-07 14:41:15','::1','::1','2020-10-22 15:36:39','2021-01-08 14:46:58','Super','Admin','Mr.','','',1,NULL,NULL,NULL,1,'','','','US',NULL,2),(2,'admin1@example.com','$2a$11$JomS4hK0V73tpX3lL5y7su3XrTLW2vnTbLtlktf/KF9x/UaGPWyS2',NULL,NULL,NULL,16,'2021-01-07 14:40:50','2021-01-06 22:29:22','::1','::1','2020-10-28 13:24:44','2021-01-07 14:40:50','Joe','Bailey','Sales Rep.','+15085555555','',0,NULL,NULL,NULL,1,'','','','US',NULL,3),(3,'admin2@example.com','$2a$11$xME.pIsCjuPAiftmwuEXAOzjAQOHBeRqavNrP4IaJ4jWkiEijvmwi',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2020-10-28 13:25:32','2020-12-11 19:39:20','TEst','Test','HR Manager','+15082223456','',0,NULL,NULL,NULL,1,'','','','US',NULL,1),(4,'verylongemailaddress@example.com','$2a$11$.nTL7h4xzO7sHsZSl7ycY.PZehqzXm2JgiW72jUBid8icJkEPTkta',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2020-10-28 13:26:36','2020-11-28 16:12:22','Test','Aabacus','Project Manager','','',0,NULL,NULL,NULL,1,'','','','',NULL,3),(5,'admin7@example.com','$2a$11$qksS6a9MjvXK5.Rn/qoNkebZ6WfRVwFIPV20ikezrhxayeuahAUFq',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2020-10-28 15:42:40','2020-11-05 20:36:03','Juliett','Henry','Strategist','+16172439900','',0,NULL,NULL,NULL,1,'','','','US',NULL,1),(6,'admin565@example.com','$2a$11$GkScTXOJqy/9sfbvtHrQIOZ.7ZG8gW/uVAS4RV6aKZy7MY7yEWFuq',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2020-11-02 14:32:56','2020-12-11 23:37:27','Bob','Thornton','Ninja Master','+15082223456','',0,NULL,NULL,NULL,1,'','','','US',NULL,NULL),(7,'biodfsnjrgdfn@example.com','$2a$11$ODSXhpIkB1Xsq.LY/CbmVuLr2Q/1xfbwWSQX97gU6racJTPNBG0hK',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2020-11-29 02:13:25','2020-12-11 23:37:15','Joe','Thornton','COO','','',0,NULL,NULL,NULL,1,'','','','',NULL,NULL),(8,'fakeaccount@example.com','$2a$11$HwkzQ2cPETOnJ89whO1T1ug8y8ngaU8n5GckYSQc5YBKsNXE8H2G.',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2020-11-29 02:14:08','2020-12-11 23:37:05','Thomas','Santiago','Tester','','',0,NULL,NULL,NULL,1,'','','','',NULL,NULL),(9,'fackeaccount@gmail.com','$2a$11$MSWOG2MrJvOdHwZGezA0J.mCzg1KDD4ewD.KPZpx2ME9h.z9dbX36',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2020-11-29 02:14:52','2020-12-11 23:36:56','Juan','Rosario','Apprentice','','',0,NULL,NULL,NULL,1,'','','','',NULL,NULL),(10,'corey@example.com','$2a$11$OIu.M44vES/dcGbIndO5b.8fDPYNTjqeaTWukKhlIxXGGzimPvQ9.',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2020-11-29 02:15:31','2020-12-11 23:36:48','Corey','Smith','Junior Dev','','',0,NULL,NULL,NULL,1,'','','','',NULL,NULL),(11,'marysmith@example.com','$2a$11$AlKfjE1GmRfzqTzI18NhJ.f8vc.e2Ak/RBbLombq9x4R3H43Eto86',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2020-11-29 02:16:14','2020-12-15 21:18:17','Mary','Smith','Assistant Manager','','',0,NULL,NULL,NULL,0,'','','','',NULL,NULL);
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

-- Dump completed on 2021-01-08 13:48:34
