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
INSERT INTO `ar_internal_metadata` VALUES ('environment','development','2021-01-27 16:07:09','2021-01-27 16:07:09');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checklists`
--

LOCK TABLES `checklists` WRITE;
/*!40000 ALTER TABLE `checklists` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facilities`
--

LOCK TABLES `facilities` WRITE;
/*!40000 ALTER TABLE `facilities` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facility_groups`
--

LOCK TABLES `facility_groups` WRITE;
/*!40000 ALTER TABLE `facility_groups` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facility_projects`
--

LOCK TABLES `facility_projects` WRITE;
/*!40000 ALTER TABLE `facility_projects` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_severities`
--

LOCK TABLES `issue_severities` WRITE;
/*!40000 ALTER TABLE `issue_severities` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_stages`
--

LOCK TABLES `issue_stages` WRITE;
/*!40000 ALTER TABLE `issue_stages` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_types`
--

LOCK TABLES `issue_types` WRITE;
/*!40000 ALTER TABLE `issue_types` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_users`
--

LOCK TABLES `issue_users` WRITE;
/*!40000 ALTER TABLE `issue_users` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issues`
--

LOCK TABLES `issues` WRITE;
/*!40000 ALTER TABLE `issues` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notes`
--

LOCK TABLES `notes` WRITE;
/*!40000 ALTER TABLE `notes` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organizations`
--

LOCK TABLES `organizations` WRITE;
/*!40000 ALTER TABLE `organizations` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `privileges`
--

LOCK TABLES `privileges` WRITE;
/*!40000 ALTER TABLE `privileges` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_issue_severities`
--

LOCK TABLES `project_issue_severities` WRITE;
/*!40000 ALTER TABLE `project_issue_severities` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_issue_types`
--

LOCK TABLES `project_issue_types` WRITE;
/*!40000 ALTER TABLE `project_issue_types` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_statuses`
--

LOCK TABLES `project_statuses` WRITE;
/*!40000 ALTER TABLE `project_statuses` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_task_stages`
--

LOCK TABLES `project_task_stages` WRITE;
/*!40000 ALTER TABLE `project_task_stages` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_task_types`
--

LOCK TABLES `project_task_types` WRITE;
/*!40000 ALTER TABLE `project_task_types` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_types`
--

LOCK TABLES `project_types` WRITE;
/*!40000 ALTER TABLE `project_types` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_users`
--

LOCK TABLES `project_users` WRITE;
/*!40000 ALTER TABLE `project_users` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `risk_stages`
--

LOCK TABLES `risk_stages` WRITE;
/*!40000 ALTER TABLE `risk_stages` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `risk_users`
--

LOCK TABLES `risk_users` WRITE;
/*!40000 ALTER TABLE `risk_users` DISABLE KEYS */;
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
  `kanban_order` int(11) DEFAULT 0,
  `risk_stage_id` bigint(20) DEFAULT NULL,
  `probability_name` varchar(255) DEFAULT NULL,
  `impact_level_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_risks_on_user_id` (`user_id`),
  KEY `index_risks_on_facility_project_id` (`facility_project_id`),
  KEY `index_risks_on_task_type_id` (`task_type_id`),
  KEY `index_risks_on_risk_stage_id` (`risk_stage_id`),
  CONSTRAINT `fk_rails_06a747713d` FOREIGN KEY (`facility_project_id`) REFERENCES `facility_projects` (`id`),
  CONSTRAINT `fk_rails_4ca50b9b4a` FOREIGN KEY (`task_type_id`) REFERENCES `task_types` (`id`),
  CONSTRAINT `fk_rails_69bd83b255` FOREIGN KEY (`risk_stage_id`) REFERENCES `risk_stages` (`id`),
  CONSTRAINT `fk_rails_afb2ad6b53` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `risks`
--

LOCK TABLES `risks` WRITE;
/*!40000 ALTER TABLE `risks` DISABLE KEYS */;
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
INSERT INTO `schema_migrations` VALUES ('20191216191934'),('20191218035514'),('20191228080444'),('20191228105416'),('20191228110603'),('20191228112004'),('20191228112007'),('20200101130339'),('20200103122000'),('20200106131234'),('20200108090920'),('20200108131657'),('20200113133144'),('20200113133747'),('20200113134248'),('20200116100026'),('20200117020222'),('20200117101350'),('20200117133117'),('20200123020840'),('20200124135221'),('20200124175327'),('20200124175331'),('20200212101952'),('20200212114758'),('20200212114927'),('20200218092536'),('20200224133049'),('20200224143048'),('20200226083401'),('20200227094335'),('20200227094548'),('20200228102835'),('20200228103325'),('20200302115313'),('20200303035923'),('20200306141948'),('20200306142713'),('20200317134809'),('20200324123452'),('20200330121604'),('20200402074854'),('20200408152526'),('20200409064741'),('20200409072456'),('20200409082447'),('20200420151228'),('20200423123857'),('20200501042753'),('20200504185315'),('20200504195558'),('20200506041609'),('20200514064709'),('20200521144759'),('20200528085915'),('20200528085929'),('20200528085939'),('20200528085950'),('20200530100431'),('20200603080452'),('20200611091751'),('20200616081726'),('20200702121127'),('20200723134817'),('20200807100741'),('20200807100758'),('20200808070841'),('20200817092553'),('20200818085817'),('20200909095910'),('20200921072951'),('20200930081004'),('20201006210408'),('20201006212644'),('20201009064837'),('20201009065229'),('20201015082958'),('20201023114005'),('20201031015327'),('20201102162746'),('20201111142529'),('20201116143905'),('20201116143913'),('20201116145647'),('20201116160716'),('20201126075449'),('20201130074254'),('20201203215312'),('20201204141844'),('20201204150339'),('20201204151813'),('20201204151828'),('20201209154029'),('20201210141541'),('20201210141626'),('20201215142105'),('20201217175902'),('20201217182144'),('20201217202820'),('20201230130528'),('20201230163344'),('20201230221803'),('20201230221900'),('20201231031549'),('20210101112344'),('20210121191808'),('20210122022456');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sorts`
--

LOCK TABLES `sorts` WRITE;
/*!40000 ALTER TABLE `sorts` DISABLE KEYS */;
INSERT INTO `sorts` VALUES (1,'checklists','id','asc','2021-01-27 16:07:07','2021-01-27 16:07:07'),(2,'facilities','id','asc','2021-01-27 16:07:07','2021-01-27 16:07:07'),(3,'facility_groups','id','asc','2021-01-27 16:07:07','2021-01-27 16:07:07'),(4,'facility_projects','id','asc','2021-01-27 16:07:07','2021-01-27 16:07:07'),(5,'issue_severities','id','asc','2021-01-27 16:07:07','2021-01-27 16:07:07'),(6,'issue_types','id','asc','2021-01-27 16:07:07','2021-01-27 16:07:07'),(7,'issue_users','id','asc','2021-01-27 16:07:07','2021-01-27 16:07:07'),(8,'issues','id','asc','2021-01-27 16:07:07','2021-01-27 16:07:07'),(9,'notes','id','asc','2021-01-27 16:07:07','2021-01-27 16:07:07'),(10,'privileges','id','asc','2021-01-27 16:07:07','2021-01-27 16:07:07'),(11,'project_types','id','asc','2021-01-27 16:07:07','2021-01-27 16:07:07'),(12,'project_users','id','asc','2021-01-27 16:07:07','2021-01-27 16:07:07'),(13,'projects','id','asc','2021-01-27 16:07:07','2021-01-27 16:07:07'),(14,'region_states','id','asc','2021-01-27 16:07:07','2021-01-27 16:07:07'),(15,'statuses','id','asc','2021-01-27 16:07:07','2021-01-27 16:07:07'),(16,'task_types','id','asc','2021-01-27 16:07:07','2021-01-27 16:07:07'),(17,'tasks','id','asc','2021-01-27 16:07:07','2021-01-27 16:07:07'),(18,'users','id','asc','2021-01-27 16:07:07','2021-01-27 16:07:07'),(19,'task_stages','id','asc','2021-01-27 16:07:08','2021-01-27 16:07:08'),(20,'issue_stages','id','asc','2021-01-27 16:07:08','2021-01-27 16:07:08'),(21,'risk_milestones','id','asc','2021-01-27 16:07:09','2021-01-27 16:07:09');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statuses`
--

LOCK TABLES `statuses` WRITE;
/*!40000 ALTER TABLE `statuses` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_stages`
--

LOCK TABLES `task_stages` WRITE;
/*!40000 ALTER TABLE `task_stages` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_types`
--

LOCK TABLES `task_types` WRITE;
/*!40000 ALTER TABLE `task_types` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_users`
--

LOCK TABLES `task_users` WRITE;
/*!40000 ALTER TABLE `task_users` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
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

-- Dump completed on 2021-01-27 11:09:25
