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
-- Table structure for table `accountable_users`
--

DROP TABLE IF EXISTS `accountable_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accountable_users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `project_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_accountable_users_on_user_id` (`user_id`),
  KEY `index_accountable_users_on_project_id` (`project_id`),
  CONSTRAINT `fk_rails_364834428b` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_d1fb2622ca` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accountable_users`
--

LOCK TABLES `accountable_users` WRITE;
/*!40000 ALTER TABLE `accountable_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `accountable_users` ENABLE KEYS */;
UNLOCK TABLES;

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
  KEY `index_active_storage_attachments_on_record_id` (`record_id`),
  CONSTRAINT `fk_rails_c3b3935057` FOREIGN KEY (`blob_id`) REFERENCES `active_storage_blobs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_storage_attachments`
--

LOCK TABLES `active_storage_attachments` WRITE;
/*!40000 ALTER TABLE `active_storage_attachments` DISABLE KEYS */;
INSERT INTO `active_storage_attachments` VALUES (1,'task_files','Task',29,1,'2021-03-08 16:35:06'),(7,'task_files','Task',26,7,'2021-03-22 18:43:15'),(8,'risk_files','Risk',31,8,'2021-03-22 18:43:42'),(9,'risk_files','Risk',22,9,'2021-03-22 18:54:32'),(10,'risk_files','Risk',22,10,'2021-03-22 18:58:46'),(11,'risk_files','Risk',22,11,'2021-03-22 20:01:02'),(16,'risk_files','Risk',22,16,'2021-03-23 17:32:15'),(17,'risk_files','Risk',22,17,'2021-03-23 17:36:58'),(21,'risk_files','Risk',22,21,'2021-03-23 17:47:45'),(24,'risk_files','Risk',22,24,'2021-03-23 18:56:56'),(25,'risk_files','Risk',22,25,'2021-03-23 19:00:12'),(28,'risk_files','Risk',22,28,'2021-03-23 19:47:49'),(29,'risk_files','Risk',22,29,'2021-03-23 19:57:36'),(30,'risk_files','Risk',22,30,'2021-03-23 20:05:23'),(31,'risk_files','Risk',22,31,'2021-03-23 20:15:45'),(32,'risk_files','Risk',22,32,'2021-03-23 20:22:01'),(33,'risk_files','Risk',22,33,'2021-03-23 21:39:12'),(34,'risk_files','Risk',22,34,'2021-03-23 21:42:17'),(37,'risk_files','Risk',31,37,'2021-03-23 22:05:50'),(39,'risk_files','Risk',31,39,'2021-03-23 22:07:25'),(40,'risk_files','Risk',22,40,'2021-03-23 22:17:27'),(41,'risk_files','Risk',22,41,'2021-03-23 22:18:19'),(42,'risk_files','Risk',22,42,'2021-03-23 22:18:38'),(43,'risk_files','Risk',31,43,'2021-03-23 22:20:56'),(44,'risk_files','Risk',31,44,'2021-03-23 22:21:08'),(45,'risk_files','Risk',31,45,'2021-03-23 22:21:08'),(46,'risk_files','Risk',31,46,'2021-03-23 22:21:08'),(47,'risk_files','Risk',31,47,'2021-03-23 22:21:59'),(48,'risk_files','Risk',31,48,'2021-03-23 22:21:59'),(49,'risk_files','Risk',31,49,'2021-03-23 22:21:59'),(50,'risk_files','Risk',31,50,'2021-03-23 22:21:59'),(51,'risk_files','Risk',31,51,'2021-03-23 22:22:04'),(52,'risk_files','Risk',22,52,'2021-03-23 22:26:39'),(53,'risk_files','Risk',22,53,'2021-03-23 22:26:48'),(54,'risk_files','Risk',22,54,'2021-03-23 22:28:03'),(55,'risk_files','Risk',22,55,'2021-03-23 23:45:30'),(56,'risk_files','Risk',22,56,'2021-03-23 23:45:45'),(57,'risk_files','Risk',22,57,'2021-03-23 23:56:04'),(58,'risk_files','Risk',22,58,'2021-03-23 23:56:04'),(60,'task_files','Task',15,60,'2021-03-24 00:04:37'),(61,'task_files','Task',15,61,'2021-03-24 00:19:59'),(62,'issue_files','Issue',8,62,'2021-03-24 00:24:50'),(63,'issue_files','Issue',8,63,'2021-03-24 00:27:20'),(64,'issue_files','Issue',8,64,'2021-03-24 00:27:21'),(65,'issue_files','Issue',8,65,'2021-03-24 00:27:57'),(66,'issue_files','Issue',8,66,'2021-03-24 00:27:57'),(67,'issue_files','Issue',8,67,'2021-03-24 00:29:16'),(74,'risk_files','Risk',22,74,'2021-03-24 07:04:14'),(76,'risk_files','Risk',22,76,'2021-03-24 07:08:27'),(84,'issue_files','Issue',8,84,'2021-03-24 07:39:36'),(85,'issue_files','Issue',8,85,'2021-03-24 07:39:37'),(88,'task_files','Task',15,88,'2021-03-24 07:43:06'),(89,'task_files','Task',15,89,'2021-03-24 07:43:06'),(92,'risk_files','Risk',22,92,'2021-03-24 20:46:26'),(93,'issue_files','Issue',8,93,'2021-03-24 21:03:50'),(95,'issue_files','Issue',8,95,'2021-03-25 01:07:51'),(97,'issue_files','Issue',2,97,'2021-03-25 01:44:18'),(100,'task_files','Task',15,100,'2021-03-25 14:25:46'),(101,'task_files','Task',15,101,'2021-03-25 14:25:46'),(103,'issue_files','Issue',8,103,'2021-03-25 15:13:14'),(105,'task_files','Task',15,105,'2021-03-25 15:14:14'),(106,'issue_files','Issue',8,106,'2021-03-25 15:14:35'),(107,'risk_files','Risk',22,107,'2021-03-25 15:14:49'),(108,'task_files','Task',26,108,'2021-03-26 14:57:48'),(109,'task_files','Task',26,109,'2021-03-26 15:24:41'),(110,'task_files','Task',26,110,'2021-03-26 15:25:17'),(111,'task_files','Task',26,111,'2021-03-26 15:27:15'),(112,'task_files','Task',26,112,'2021-03-26 15:28:57'),(114,'issue_files','Issue',8,114,'2021-03-26 15:33:41'),(115,'risk_files','Risk',22,115,'2021-03-26 15:33:57'),(116,'task_files','Task',26,116,'2021-03-26 15:35:36'),(117,'issue_files','Issue',15,117,'2021-03-26 15:35:49'),(118,'risk_files','Risk',11,118,'2021-03-26 15:36:07');
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
  `service_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_active_storage_blobs_on_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_storage_blobs`
--

LOCK TABLES `active_storage_blobs` WRITE;
/*!40000 ALTER TABLE `active_storage_blobs` DISABLE KEYS */;
INSERT INTO `active_storage_blobs` VALUES (1,'MRqLfigjDZpUKP1QVxpNEyZw','Commands for mGis dev pull.PNG','image/png','{\"identified\":true,\"analyzed\":true}',53548,'+29wwi//dHciaWyppfpQog==','2021-03-08 16:35:06','local'),(6,'peiYksU3YbdAgnsa1we8RNd3','Commands for mGis dev pull.PNG','image/png','{\"identified\":true,\"analyzed\":true}',53548,'+29wwi//dHciaWyppfpQog==','2021-03-08 20:33:42','local'),(7,'BfZmCZ6VHD7mebx84sd2RPVc','Finished_without Status.PNG','image/png','{\"identified\":true,\"analyzed\":true}',103392,'k3u0017ExjxVnqpA80tFIw==','2021-03-22 18:43:15','local'),(8,'pS6eGSb2B8QPGv8oP5covZZB','Finished_without Status.PNG','image/png','{\"identified\":true,\"analyzed\":true}',103392,'k3u0017ExjxVnqpA80tFIw==','2021-03-22 18:43:42','local'),(9,'EGJYFXsrHpzyjbahHvzjf3Bh','Finished_without Status.PNG','image/png','{\"identified\":true,\"analyzed\":true}',103392,'k3u0017ExjxVnqpA80tFIw==','2021-03-22 18:54:32','local'),(10,'mgfPhb7maVAUr19EawaRLnS4','Draft Portfolio Page.PNG','image/png','{\"identified\":true,\"analyzed\":true}',116142,'/VeRpYV4NcbE7FwRByWIfw==','2021-03-22 18:58:46','local'),(11,'f5odzPhyyisntnPcEZF4Paxr','Capture.PNG','image/png','{\"identified\":true,\"analyzed\":true}',144514,'xq3jdvom6/VhO3gEf85GdA==','2021-03-22 20:01:02','local'),(13,'VQVPPvqzqwrUN8CvrPyzvddr','risk_form_bug.PNG','image/png','{\"identified\":true,\"analyzed\":true}',232321,'80YJXwSyhl+RFlll94NK7A==','2021-03-23 13:54:26','local'),(16,'pQqRh4rJXKWaHDhPq2kHmXbi','https://stackoverflow.com/questions/44046642/vuex-unknown-getter-user','text/plain','{\"identified\":true,\"analyzed\":true}',69,'0PAQY5Z/+edbm3GB7Zd1uA==','2021-03-23 17:32:15','local'),(17,'t3GPCpc3tQ6TMSeEjcHZ7oDu','https://stackoverflow.com/questions/44046642/vuex-unknown-getter-user','text/plain','{\"identified\":true,\"analyzed\":true}',69,'0PAQY5Z/+edbm3GB7Zd1uA==','2021-03-23 17:36:58','local'),(21,'rKRrYM3twtG3prFo7nBA6rCP','https://stackoverflow.com/questions/44046642/vuex-unknown-getter-user','text/plain','{\"identified\":true,\"analyzed\":true}',69,'0PAQY5Z/+edbm3GB7Zd1uA==','2021-03-23 17:47:45','local'),(24,'LmDyaAU9Q2qcE3m1Hwbjcv2E','https://github.com/MicroHealthLLC/mGis/issues/2114','text/plain','{\"identified\":true,\"analyzed\":true}',50,'Prwx48uh6ieEWm1Ud0ZYZw==','2021-03-23 18:56:56','local'),(25,'MQCM49BJtYP1n6TLyqGs95tG','https://github.com/MicroHealthLLC/mGis/issues/2114','text/plain','{\"identified\":true,\"analyzed\":true}',50,'Prwx48uh6ieEWm1Ud0ZYZw==','2021-03-23 19:00:12','local'),(28,'uVuHSYVJYbyxGn57t7hAdJ4y','debug.log','text/x-log','{\"identified\":true,\"analyzed\":true}',696,'BMc12kCR85Q78JV3HBsNMA==','2021-03-23 19:47:49','local'),(29,'4BmG4knSwAPdgVqrP152H9Mp','https://github.com/MicroHealthLLC/mGis/blob/release/app/javascript/components/dashboard/risks/risk_form.vue','text/plain','{\"identified\":true,\"analyzed\":true}',107,'eU6PdBC/teOzA5p8mG3+2w==','2021-03-23 19:57:36','local'),(30,'7Lo8SGsppRsmT1fLt5QxzHTY','https://www.google.com/','text/plain','{\"identified\":true,\"analyzed\":true}',23,'11J3zf/vmVpGrlm9rvHbhg==','2021-03-23 20:05:23','local'),(31,'uU5wqg5RmY7rp6h47X73dHGy','risk_form_bug.PNG','image/png','{\"identified\":true,\"analyzed\":true}',232321,'80YJXwSyhl+RFlll94NK7A==','2021-03-23 20:15:45','local'),(32,'RGwGwucdeeGYuejQkkY8ZuE6','https://github.com/MicroHealthLLC/mGis','text/plain','{\"identified\":true,\"analyzed\":true}',38,'JYBGVryjCcZQ354aDee4mQ==','2021-03-23 20:22:01','local'),(33,'sAM6Y5cNa4sL5J3qBAea72a7','Upadating form_add file_devtools errors.PNG','image/png','{\"identified\":true,\"analyzed\":true}',49672,'IQ9BE9KhGdPrKRkVT4N9Eg==','2021-03-23 21:39:12','local'),(34,'iZNe7ipxJkwiR4FkFB1CwMwu','Updating form_add file.PNG','image/png','{\"identified\":true,\"analyzed\":true}',47669,'UosmWj8k81R1JY4dRDtWsQ==','2021-03-23 21:42:17','local'),(37,'FDZ9AwoeiFqy7d5SfvvNtPBw','https://medium.com/@DylanAttal/repeat-a-string-in-javascript-9e46c990475e','text/plain','{\"identified\":true,\"analyzed\":true}',73,'YmQ/fMtWlrkebsUbC+VM4Q==','2021-03-23 22:05:50','local'),(39,'UV8ofTBn8gvMZfiP3e7DiQdJ','https://time.microhealthllc.com/DeltekTC/welcome.msv','text/plain','{\"identified\":true,\"analyzed\":true}',52,'rNfk9eOHNDxWRMtSwU2Dmg==','2021-03-23 22:07:25','local'),(40,'AdpCDJbgzinxjZF1K4wF5pCD','Capture.PNG','image/png','{\"identified\":true,\"analyzed\":true}',144514,'xq3jdvom6/VhO3gEf85GdA==','2021-03-23 22:17:27','local'),(41,'77npHEgrBrssxWzJ5g5RKj5B','Draft Portfolio Page.PNG','image/png','{\"identified\":true,\"analyzed\":true}',116142,'/VeRpYV4NcbE7FwRByWIfw==','2021-03-23 22:18:19','local'),(42,'mcpfzZTV8XRS9W3Hn1URrB9h','https://time.microhealthllc.com/DeltekTC/welcome.msv','text/plain','{\"identified\":true,\"analyzed\":true}',52,'rNfk9eOHNDxWRMtSwU2Dmg==','2021-03-23 22:18:38','local'),(43,'G1F6W84x9vHMsk6kY4BMtMRX','https://time.microhealthllc.com/DeltekTC/welcome.msv','text/plain','{\"identified\":true,\"analyzed\":true}',52,'rNfk9eOHNDxWRMtSwU2Dmg==','2021-03-23 22:20:56','local'),(44,'zoAk363WNTC5dm7EsCJBRXn3','Draft Portfolio Page.PNG','image/png','{\"identified\":true,\"analyzed\":true}',116142,'/VeRpYV4NcbE7FwRByWIfw==','2021-03-23 22:21:08','local'),(45,'QjnxW8xPV8kVwAPUukrg65qj','Capture.PNG','image/png','{\"identified\":true,\"analyzed\":true}',144514,'xq3jdvom6/VhO3gEf85GdA==','2021-03-23 22:21:08','local'),(46,'At6rPZbDD4BM9mh56xgsqBCP','Finished_without Status.PNG','image/png','{\"identified\":true,\"analyzed\":true}',103392,'k3u0017ExjxVnqpA80tFIw==','2021-03-23 22:21:08','local'),(47,'4nJi2cgQVmNFvgmCRZjRNWgf','Finished_without Status.PNG','image/png','{\"identified\":true,\"analyzed\":true}',103392,'k3u0017ExjxVnqpA80tFIw==','2021-03-23 22:21:59','local'),(48,'2gsAQp9fM7PGQtVvcyktgZKq','Capture.PNG','image/png','{\"identified\":true,\"analyzed\":true}',144514,'xq3jdvom6/VhO3gEf85GdA==','2021-03-23 22:21:59','local'),(49,'m8K91XSzkU6SBidc3ZsxivXL','Finished_without Status.PNG','image/png','{\"identified\":true,\"analyzed\":true}',103392,'k3u0017ExjxVnqpA80tFIw==','2021-03-23 22:21:59','local'),(50,'HTnxwjVkfiuDGymwvxja5ttD','https://time.microhealthllc.com/DeltekTC/welcome.msv','text/plain','{\"identified\":true,\"analyzed\":true}',52,'rNfk9eOHNDxWRMtSwU2Dmg==','2021-03-23 22:21:59','local'),(51,'hDPqgVeyHhp5FcCrt4n5qG4r','https://time.microhealthllc.com/DeltekTC/welcome.msv','text/plain','{\"identified\":true,\"analyzed\":true}',52,'rNfk9eOHNDxWRMtSwU2Dmg==','2021-03-23 22:22:04','local'),(52,'xEtL4KMc6cYxmRgqR7HQtG7b','Draft Portfolio Page.PNG','image/png','{\"identified\":true,\"analyzed\":true}',116142,'/VeRpYV4NcbE7FwRByWIfw==','2021-03-23 22:26:39','local'),(53,'dNwEJpvjCt5ysEwUTKBJdF8p','Capture.PNG','image/png','{\"identified\":true,\"analyzed\":true}',144514,'xq3jdvom6/VhO3gEf85GdA==','2021-03-23 22:26:48','local'),(54,'eTH6opX9jkUPXmR7u2SziBRF','Draft Portfolio Page.PNG','image/png','{\"identified\":true,\"analyzed\":true}',116142,'/VeRpYV4NcbE7FwRByWIfw==','2021-03-23 22:28:03','local'),(55,'7s6BHYTAmQjRKdFHzpuY4vrG','Fake User.docx','application/vnd.openxmlformats-officedocument.wordprocessingml.document','{\"identified\":true,\"analyzed\":true}',15920,'uSdwEceEGakHVIuEyjy1GA==','2021-03-23 23:45:30','local'),(56,'p6znHHPp7zbaHKqrktuvyrGj','Warnings from prod push_1.PNG','image/png','{\"identified\":true,\"analyzed\":true}',40181,'FjXfpL/L2b2mvU//iZ2buA==','2021-03-23 23:45:45','local'),(57,'k698qq4AdGzb6MQuhdeHzc7g','prod commands.PNG','image/png','{\"identified\":true,\"analyzed\":true}',31592,'A+aW2DEuq4Xmy9XXYeufng==','2021-03-23 23:56:04','local'),(58,'mcXqbvV6JUAX2rU2ndKUTN7v','https://opensource.com/article/19/7/create-pull-request-github','text/plain','{\"identified\":true,\"analyzed\":true}',62,'qvWLtbn36IoHtaXl6sB60A==','2021-03-23 23:56:04','local'),(60,'JfYa3QGry1rEdF6z2Tm1DkPH','https://opensource.com/article/19/7/create-pull-request-github','text/plain','{\"identified\":true,\"analyzed\":true}',62,'qvWLtbn36IoHtaXl6sB60A==','2021-03-24 00:04:37','local'),(61,'EiKdnGZxVYNd1hdY25K6piYf','https://opensource.com/article/19/7/create-pull-request-github','text/plain','{\"identified\":true,\"analyzed\":true}',62,'qvWLtbn36IoHtaXl6sB60A==','2021-03-24 00:19:59','local'),(62,'W3DuaScY9WehTLffJSmT6akS','https://opensource.com/article/19/7/create-pull-request-github','text/plain','{\"identified\":true,\"analyzed\":true}',62,'qvWLtbn36IoHtaXl6sB60A==','2021-03-24 00:24:50','local'),(63,'8Z97SdUPibCcbEYrLZdNc55s','risk_form_bug.PNG','image/png','{\"identified\":true,\"analyzed\":true}',232321,'80YJXwSyhl+RFlll94NK7A==','2021-03-24 00:27:20','local'),(64,'ax3ffG6nGsQt4My3aLLewTpr','filters_carmax.PNG','image/png','{\"identified\":true,\"analyzed\":true}',1124399,'zuF9rX/e9WbKNdGrmUt0Ng==','2021-03-24 00:27:21','local'),(65,'wCTqJnxHYzKwavL91o2gVpWP','filters_carmax.PNG','image/png','{\"identified\":true,\"analyzed\":true}',1124399,'zuF9rX/e9WbKNdGrmUt0Ng==','2021-03-24 00:27:57','local'),(66,'UTJNgahr7geCUjgL9vwb86gA','Helpful MySQL commands.docx','application/vnd.openxmlformats-officedocument.wordprocessingml.document','{\"identified\":true,\"analyzed\":true}',12858,'N93bSFFpxJDUTc4M8EpPBQ==','2021-03-24 00:27:57','local'),(67,'Fbx3fmRCtEocYKqN6kaQLBpK','https://time.microhealthllc.com/DeltekTC/welcome.msv','text/plain','{\"identified\":true,\"analyzed\":true}',52,'rNfk9eOHNDxWRMtSwU2Dmg==','2021-03-24 00:29:16','local'),(68,'i86rm4fjL55hezpP4YCJG1mj','https://time.microhealthllc.com/DeltekTC/welcome.msv','text/plain','{\"identified\":true,\"analyzed\":true}',52,'rNfk9eOHNDxWRMtSwU2Dmg==','2021-03-24 00:31:10','local'),(69,'88VdckWDxHFX3qTtiiji4o4i','https://time.microhealthllc.com/DeltekTC/welcome.msv','text/plain','{\"identified\":true,\"analyzed\":true}',52,'rNfk9eOHNDxWRMtSwU2Dmg==','2021-03-24 00:31:16','local'),(70,'jbne4syejjDMVGD8vuJ59uMm','https://time.microhealthllc.com/DeltekTC/welcome.msv','text/plain','{\"identified\":true,\"analyzed\":true}',52,'rNfk9eOHNDxWRMtSwU2Dmg==','2021-03-24 00:31:24','local'),(71,'aSNWZGs6Hec5fyrQG7e77wRy','Helpful MySQL commands.docx','application/vnd.openxmlformats-officedocument.wordprocessingml.document','{\"identified\":true,\"analyzed\":true}',12858,'N93bSFFpxJDUTc4M8EpPBQ==','2021-03-24 00:31:50','local'),(72,'NRtgSmNBpA5Fd4z82ki5VpkF','Dev Priorities.docx','application/vnd.openxmlformats-officedocument.wordprocessingml.document','{\"identified\":true,\"analyzed\":true}',16712,'8K3rYJHRa5nxP9Vb0KlawA==','2021-03-24 00:32:03','local'),(73,'G2j6bviVxq6vN9GWswC1BYYf','prod commands.PNG','image/png','{\"identified\":true,\"analyzed\":true}',31592,'A+aW2DEuq4Xmy9XXYeufng==','2021-03-24 00:32:15','local'),(74,'BuoPXjuDQ6zaaaN49czh5HCt','https://codingbee.net/ruby/rvm-installing-a-version-of-ruby','text/plain','{\"identified\":true,\"analyzed\":true}',59,'EypUj4PGB9W1qhZg0hZ6sA==','2021-03-24 07:04:14','local'),(76,'rgj4ZkHxWMgQcVPVTeSxGv2v','Draft_How to Run mGis locally.docx','application/vnd.openxmlformats-officedocument.wordprocessingml.document','{\"identified\":true,\"analyzed\":true}',948994,'yW/zhSgLId/xnSwQGSw/iQ==','2021-03-24 07:08:27','local'),(84,'txqYLWEPWWTcdqBpZtmWyWba','Export Buttons_black.PNG','image/png','{\"identified\":true,\"analyzed\":true}',90527,'mOpmHj/EN5pueZ0EaPr7KA==','2021-03-24 07:39:36','local'),(85,'bPBMa4M1obU7LZPB2owDSZoU','https://opensource.com/article/19/7/create-pull-request-github','text/plain','{\"identified\":true,\"analyzed\":true}',62,'qvWLtbn36IoHtaXl6sB60A==','2021-03-24 07:39:37','local'),(88,'NPTzN9KUQQn9M4FCGzpWMHTd','https://codingbee.net/ruby/rvm-installing-a-version-of-ruby','text/plain','{\"identified\":true,\"analyzed\":true}',59,'EypUj4PGB9W1qhZg0hZ6sA==','2021-03-24 07:43:06','local'),(89,'HsxUYhTsQ7bFBHzdVabUV4PV','https://codingbee.net/ruby/rvm-installing-a-version-of-ruby','text/plain','{\"identified\":true,\"analyzed\":true}',59,'EypUj4PGB9W1qhZg0hZ6sA==','2021-03-24 07:43:06','local'),(92,'9gDTjo4K3qoCiVYgPRApP2H9','https://github.com/MicroHealthLLC/mGis/pull/2170','text/plain','{\"identified\":true,\"analyzed\":true}',48,'uN2mgmqhbS378PWSRMVacA==','2021-03-24 20:46:26','local'),(93,'3LYkgCdN5wg3P2o14uzoSV7o','https://github.com/MicroHealthLLC/mGis/issues/2159','text/plain','{\"identified\":true,\"analyzed\":true}',50,'BFbtG94Eb12csdlWMpvICA==','2021-03-24 21:03:50','local'),(95,'Wp6LzGykdVdSka1feqGpmCwR','Updating form_add file.PNG','image/png','{\"identified\":true,\"analyzed\":true}',47669,'UosmWj8k81R1JY4dRDtWsQ==','2021-03-25 01:07:51','local'),(97,'FDm5hberT4ndVxsg8Ju1UfFo','Upadating form_add file_devtools errors.PNG','image/png','{\"identified\":true,\"analyzed\":true}',49672,'IQ9BE9KhGdPrKRkVT4N9Eg==','2021-03-25 01:44:18','local'),(100,'LHiFk5xsYMtsKWuMQkoW4sUS','Updating form_add file.PNG','image/png','{\"identified\":true,\"analyzed\":true}',47669,'UosmWj8k81R1JY4dRDtWsQ==','2021-03-25 14:25:46','local'),(101,'na1eju2er72z8B19n7UeATTu','Upadating form_add file_devtools errors.PNG','image/png','{\"identified\":true,\"analyzed\":true}',49672,'IQ9BE9KhGdPrKRkVT4N9Eg==','2021-03-25 14:25:46','local'),(103,'vcvQPATECccPVjJjVTTUgijD','Updating form_add file.PNG','image/png','{\"identified\":true,\"analyzed\":true}',47669,'UosmWj8k81R1JY4dRDtWsQ==','2021-03-25 15:13:14','local'),(105,'sL9VTjeQHpZorGcWcddphpyW','https://stackoverflow.com/','text/plain','{\"identified\":true,\"analyzed\":true}',26,'bDYtMFBfmjP+U1fJsIe7wA==','2021-03-25 15:14:14','local'),(106,'hKzz7r3kJ4JRjqYpSSKjqyKy','https://stackoverflow.com','text/plain','{\"identified\":true,\"analyzed\":true}',25,'f0yRlUC+bsgc032eYdpsNw==','2021-03-25 15:14:35','local'),(107,'8erMBNFDnLqdc4u5RMro2JRt','https://stackoverflow.com/questions','text/plain','{\"identified\":true,\"analyzed\":true}',35,'fGZ3C7dyR8MbWNVh/Uj3ug==','2021-03-25 15:14:49','local'),(108,'UHfGSBxjsVXt8bzpSGBcGzZS','https://microhealth.sharepoint.com/:x:/r/sites/InformationTechnology/_layouts/15/Doc.aspx?sourcedoc=%7BD36CB532-20A3-4DD4-946B-47A58B024052%7D&file=Release%20plan%20project%20list_apr_21.xlsx&action=default&mobileredirect=true','text/plain','{\"identified\":true,\"analyzed\":true}',226,'29Ele4LuW8FyMxbU1iRLOg==','2021-03-26 14:57:48','local'),(109,'G8BykiTWDSFJMJxK6Hbm9MdJ','https://time.microhealthllc.com/DeltekTC/welcome.msv','text/plain','{\"identified\":true,\"analyzed\":true}',52,'rNfk9eOHNDxWRMtSwU2Dmg==','2021-03-26 15:24:41','local'),(110,'LDRzG65E9j2iroqPUUKSt7DM','https://github.com/MicroHealthLLC/mGis/issues/2174','text/plain','{\"identified\":true,\"analyzed\":true}',50,'XnTxNFSyil9uo/VIv/E9rQ==','2021-03-26 15:25:17','local'),(111,'gvSAmruPZfGJRVt8YF9v8bCh','https://microhealth.sharepoint.com/:x:/r/sites/InformationTechnology/_layouts/15/Doc.aspx?sourcedoc=%7BD36CB532-20A3-4DD4-946B-47A58B024052%7D&file=Release%20plan%20project%20list_apr_21.xlsx&action=default&mobileredirect=true','text/plain','{\"identified\":true,\"analyzed\":true}',226,'29Ele4LuW8FyMxbU1iRLOg==','2021-03-26 15:27:15','local'),(112,'yaxZpqoz3VzqA5aorvZnkoaV','https://microhealth.sharepoint.com/:x:/r/sites/InformationTechnology/_layouts/15/Doc.aspx?sourcedoc=%7BD36CB532-20A3-4DD4-946B-47A58B024052%7D&file=Release%20plan%20project%20list_apr_21.xlsx&action=default&mobileredirect=true','text/plain','{\"identified\":true,\"analyzed\":true}',226,'29Ele4LuW8FyMxbU1iRLOg==','2021-03-26 15:28:57','local'),(114,'YF9Djt9nLJNnfDeZbtnkcWqd','https://microhealth.sharepoint.com/:x:/r/sites/InformationTechnology/_layouts/15/Doc.aspx?sourcedoc=%7BD36CB532-20A3-4DD4-946B-47A58B024052%7D&file=Release%20plan%20project%20list_apr_21.xlsx&action=default&mobileredirect=true','text/plain','{\"identified\":true,\"analyzed\":true}',226,'29Ele4LuW8FyMxbU1iRLOg==','2021-03-26 15:33:41','local'),(115,'pAmj36kFU5owF87JuhEijPXN','https://microhealth.sharepoint.com/:x:/r/sites/InformationTechnology/_layouts/15/Doc.aspx?sourcedoc=%7BD36CB532-20A3-4DD4-946B-47A58B024052%7D&file=Release%20plan%20project%20list_apr_21.xlsx&action=default&mobileredirect=true','text/plain','{\"identified\":true,\"analyzed\":true}',226,'29Ele4LuW8FyMxbU1iRLOg==','2021-03-26 15:33:57','local'),(116,'LXZrxj6p2rWkBb8hyvgpotvv','https://microhealth.sharepoint.com/:x:/r/sites/InformationTechnology/_layouts/15/Doc.aspx?sourcedoc=%7BD36CB532-20A3-4DD4-946B-47A58B024052%7D&file=Release%20plan%20project%20list_apr_21.xlsx&action=default&mobileredirect=true','text/plain','{\"identified\":true,\"analyzed\":true}',226,'29Ele4LuW8FyMxbU1iRLOg==','2021-03-26 15:35:36','local'),(117,'PsKas9RjpS3iMQEJGVmrpo91','https://microhealth.sharepoint.com/:x:/r/sites/InformationTechnology/_layouts/15/Doc.aspx?sourcedoc=%7BD36CB532-20A3-4DD4-946B-47A58B024052%7D&file=Release%20plan%20project%20list_apr_21.xlsx&action=default&mobileredirect=true','text/plain','{\"identified\":true,\"analyzed\":true}',226,'29Ele4LuW8FyMxbU1iRLOg==','2021-03-26 15:35:49','local'),(118,'LuywSL812Xf2PUJE8aZmQ4FV','https://microhealth.sharepoint.com/:x:/r/sites/InformationTechnology/_layouts/15/Doc.aspx?sourcedoc=%7BD36CB532-20A3-4DD4-946B-47A58B024052%7D&file=Release%20plan%20project%20list_apr_21.xlsx&action=default&mobileredirect=true','text/plain','{\"identified\":true,\"analyzed\":true}',226,'29Ele4LuW8FyMxbU1iRLOg==','2021-03-26 15:36:07','local');
/*!40000 ALTER TABLE `active_storage_blobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `active_storage_variant_records`
--

DROP TABLE IF EXISTS `active_storage_variant_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_storage_variant_records` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `blob_id` bigint(20) NOT NULL,
  `variation_digest` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_active_storage_variant_records_uniqueness` (`blob_id`,`variation_digest`),
  CONSTRAINT `fk_rails_993965df05` FOREIGN KEY (`blob_id`) REFERENCES `active_storage_blobs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_storage_variant_records`
--

LOCK TABLES `active_storage_variant_records` WRITE;
/*!40000 ALTER TABLE `active_storage_variant_records` DISABLE KEYS */;
/*!40000 ALTER TABLE `active_storage_variant_records` ENABLE KEYS */;
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
INSERT INTO `ar_internal_metadata` VALUES ('environment','development','2021-01-27 15:50:33','2021-01-27 15:50:33');
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
  KEY `index_checklists_on_listable_type` (`listable_type`),
  KEY `index_checklists_on_listable_id` (`listable_id`),
  KEY `index_checklists_on_position` (`position`),
  CONSTRAINT `fk_rails_7b071befa6` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checklists`
--

LOCK TABLES `checklists` WRITE;
/*!40000 ALTER TABLE `checklists` DISABLE KEYS */;
INSERT INTO `checklists` VALUES (1,'Risk',11,1,'LATEST ONE','2021-02-12 16:43:41','2021-02-12 16:52:22',6,0,NULL),(2,'Task',11,0,'LATEST ONE','2021-02-19 01:22:08','2021-02-19 01:22:08',NULL,0,NULL),(3,'Task',4,0,'Test','2021-02-19 01:22:37','2021-02-20 04:24:41',2,0,NULL),(4,'Task',4,0,'Example','2021-02-19 15:25:29','2021-02-19 15:25:29',4,1,NULL),(5,'Task',4,0,'Curtis is going to love this!!','2021-02-19 18:39:38','2021-02-20 04:24:41',NULL,2,NULL),(6,'Task',12,0,'dwgsgddgs','2021-02-22 21:11:34','2021-02-22 21:11:34',NULL,0,NULL),(7,'Task',14,0,'ertyryr','2021-02-22 21:29:57','2021-02-22 21:29:57',NULL,0,NULL),(8,'Task',15,0,'Item one','2021-02-23 14:39:40','2021-03-22 17:04:00',NULL,0,'2021-06-25'),(23,'Task',1,0,'LOOK','2021-02-23 17:00:49','2021-02-23 17:00:49',NULL,0,NULL),(24,'Task',1,0,'LOOK','2021-02-23 17:00:52','2021-02-23 17:00:52',NULL,0,NULL),(25,'Task',1,0,'LOOK','2021-02-23 17:00:55','2021-02-23 17:00:55',NULL,0,NULL),(26,'Task',16,0,'ddf','2021-02-24 20:12:36','2021-02-26 18:47:05',NULL,0,'2021-02-25'),(36,'Issue',8,0,'LATEST ONE','2021-02-26 02:37:57','2021-02-26 02:37:57',4,0,'2021-02-18'),(37,'Risk',22,0,'This is a check item','2021-02-26 14:34:15','2021-03-22 17:31:54',NULL,0,NULL),(38,'Task',29,0,'Hi','2021-03-08 16:36:34','2021-03-08 16:36:34',NULL,0,'2021-03-24'),(39,'Task',30,1,'LATEST ONE','2021-03-09 23:23:39','2021-03-09 23:23:39',NULL,0,NULL),(40,'Task',26,0,'Item 1','2021-03-10 14:54:01','2021-03-10 14:54:01',NULL,0,'2021-03-31'),(41,'Task',26,0,'Item 2','2021-03-10 14:54:01','2021-03-10 14:54:01',NULL,1,'2021-08-12'),(42,'Task',26,0,'Item 3','2021-03-10 14:54:01','2021-03-10 14:54:01',NULL,2,'2021-06-30'),(43,'Risk',19,0,'cv','2021-03-19 17:38:33','2021-03-19 17:38:33',NULL,0,NULL),(44,'Risk',19,0,'cv','2021-03-19 17:38:33','2021-03-19 17:38:33',NULL,1,NULL),(47,'Task',33,1,'LATEST ONE','2021-05-06 20:49:37','2021-05-07 16:18:36',NULL,0,'2021-05-25'),(48,'Task',52,0,'LATEST ONE','2021-05-13 14:53:50','2021-05-13 15:00:05',5,0,'2021-06-25'),(49,'Task',52,1,'Sample cheklist item','2021-05-13 14:55:34','2021-05-13 14:58:53',NULL,1,'2021-07-22'),(50,'Issue',12,0,'LATEST ONE','2021-05-13 20:53:20','2021-05-13 20:53:20',7,0,'2021-05-18'),(51,'Risk',33,0,'Example','2021-05-13 20:59:48','2021-05-13 20:59:48',6,0,NULL);
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
  KEY `index_facilities_on_status` (`status`),
  CONSTRAINT `fk_rails_fb9279b915` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facilities`
--

LOCK TABLES `facilities` WRITE;
/*!40000 ALTER TABLE `facilities` DISABLE KEYS */;
INSERT INTO `facilities` VALUES (1,'Training','567 Sudbury Rd, Stow, MA 01775, USA','Juan Rivera','+15085555555','kneflnk@test.com','2021-01-27 21:38:25','2021-01-27 21:38:25',1,1,'42.3940785','-71.4825537',1,'US'),(2,'Another Project','56 Adams St, Norwood, NJ 07648, USA','Juan Rivera','+16789009876','tesdddfsegwrht@test.com','2021-01-29 18:26:26','2021-01-29 18:26:26',1,1,'41.001208','-73.968976',1,'US'),(3,'Project: March 2021 A Very Long Project Name to Assess Spacing','29 Burlington Mall Road, Burlington, MA 01803, USA','Juan Rivera','+16789009876','anotherbogus@email.com','2021-03-09 21:26:08','2021-03-11 16:54:07',3,1,'42.487281','-71.201426',1,'US'),(4,'Project: March 2021(b)','45 S Main St, Concord, NH 03301, USA','Juan Rivera','+16789009876','testets@test.com','2021-03-09 21:26:57','2021-03-09 21:26:57',2,1,'43.2020697','-71.5342821',1,'US');
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
  `progress` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `index_facility_groups_on_project_id` (`project_id`),
  CONSTRAINT `fk_rails_a31e48e525` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facility_groups`
--

LOCK TABLES `facility_groups` WRITE;
/*!40000 ALTER TABLE `facility_groups` DISABLE KEYS */;
INSERT INTO `facility_groups` VALUES (1,'Sample Group','2021-01-27 21:31:17','2021-01-27 21:31:17','SAMP',1,0,'[]',NULL,0),(2,'Military Medical Group of Boston','2021-03-09 21:01:34','2021-03-09 21:01:41','',1,0,'[]',NULL,0),(3,'Super Group','2021-03-09 21:01:57','2021-03-09 21:01:57','',1,0,'[]',NULL,0),(4,'Another Group','2021-03-09 21:02:06','2021-03-09 21:02:11','',1,0,'[]',NULL,0);
/*!40000 ALTER TABLE `facility_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facility_privileges`
--

DROP TABLE IF EXISTS `facility_privileges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `facility_privileges` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `overview` varchar(255) DEFAULT '---\n- R\n',
  `tasks` varchar(255) DEFAULT '---\n- R\n',
  `notes` varchar(255) DEFAULT '---\n- R\n',
  `issues` varchar(255) DEFAULT '---\n- R\n',
  `admin` varchar(255) DEFAULT '---\n- R\n',
  `risks` varchar(255) DEFAULT '---\n- R\n',
  `user_id` int(11) DEFAULT NULL,
  `facility_project_id` int(11) DEFAULT NULL,
  `facility_id` int(11) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `group_number` int(11) DEFAULT 0,
  `facility_project_ids` varchar(255) DEFAULT '--- []\n',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facility_privileges`
--

LOCK TABLES `facility_privileges` WRITE;
/*!40000 ALTER TABLE `facility_privileges` DISABLE KEYS */;
INSERT INTO `facility_privileges` VALUES (3,'---\n- \'\'\n- R\n- W\n','---\n- \'\'\n- R\n- W\n','---\n- \'\'\n- R\n','---\n- \'\'\n- R\n- W\n','---\n- \'\'\n- R\n- W\n','---\n- \'\'\n- R\n',7,1,1,'2021-05-11 17:30:17.994222','2021-05-11 17:30:18.001254',NULL,0,'--- []\n');
/*!40000 ALTER TABLE `facility_privileges` ENABLE KEYS */;
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
  `progress` int(11) DEFAULT 0,
  `color` varchar(255) DEFAULT '#ff0000',
  PRIMARY KEY (`id`),
  KEY `index_facility_projects_on_facility_id` (`facility_id`),
  KEY `index_facility_projects_on_project_id` (`project_id`),
  KEY `index_facility_projects_on_status_id` (`status_id`),
  CONSTRAINT `fk_rails_0eac76af7e` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`id`),
  CONSTRAINT `fk_rails_b66aae6e2d` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`),
  CONSTRAINT `fk_rails_ed41de0103` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facility_projects`
--

LOCK TABLES `facility_projects` WRITE;
/*!40000 ALTER TABLE `facility_projects` DISABLE KEYS */;
INSERT INTO `facility_projects` VALUES (1,1,1,'2021-01-27 21:44:38','2021-05-20 20:41:39','2022-12-29',3,14,'#ff0000'),(2,1,2,'2021-01-27 21:47:29','2021-02-22 23:28:14',NULL,1,0,'#ff0000'),(4,2,2,'2021-01-29 18:26:44','2021-02-22 23:28:14',NULL,1,0,'#ff0000'),(5,2,1,'2021-02-04 13:50:57','2021-05-13 15:00:05',NULL,2,25,'#ff0000'),(6,1,3,'2021-03-09 21:00:25','2021-03-09 21:00:25',NULL,1,0,'#ff0000'),(7,2,3,'2021-03-09 21:00:25','2021-03-09 21:00:25',NULL,1,0,'#ff0000'),(8,1,4,'2021-03-09 21:01:17','2021-03-09 21:01:17',NULL,1,0,'#ff0000'),(9,2,4,'2021-03-09 21:01:17','2021-03-09 21:01:17',NULL,1,0,'#ff0000'),(10,1,5,'2021-03-09 21:13:51','2021-03-09 21:13:51',NULL,1,0,'#ff0000'),(11,2,5,'2021-03-09 21:13:51','2021-03-09 21:13:51',NULL,1,0,'#ff0000'),(12,1,6,'2021-03-09 21:14:48','2021-03-09 21:14:48',NULL,1,0,'#ff0000'),(13,2,6,'2021-03-09 21:14:48','2021-03-09 21:14:48',NULL,1,0,'#ff0000'),(14,1,7,'2021-03-09 21:25:01','2021-05-06 14:58:31',NULL,1,28,'#ff0000'),(15,2,7,'2021-03-09 21:25:01','2021-03-09 21:25:01',NULL,1,0,'#ff0000'),(16,4,1,'2021-03-09 21:27:16','2021-03-25 21:23:37',NULL,1,0,'#ff0000'),(17,4,2,'2021-03-09 21:27:16','2021-03-09 21:27:16',NULL,1,0,'#ff0000'),(18,4,3,'2021-03-09 21:27:16','2021-03-09 21:27:16',NULL,1,0,'#ff0000'),(19,4,4,'2021-03-09 21:27:16','2021-03-09 21:27:16',NULL,1,0,'#ff0000'),(20,4,5,'2021-03-09 21:27:16','2021-03-09 21:27:16',NULL,1,0,'#ff0000'),(21,3,1,'2021-03-09 21:27:25','2021-05-07 22:22:08',NULL,1,0,'#ff0000'),(22,3,2,'2021-03-09 21:27:25','2021-03-09 21:27:25',NULL,1,0,'#ff0000'),(23,3,3,'2021-03-09 21:27:25','2021-03-09 21:27:25',NULL,1,0,'#ff0000'),(24,3,4,'2021-03-09 21:27:25','2021-03-09 21:27:25',NULL,1,0,'#ff0000'),(25,3,5,'2021-03-09 21:27:25','2021-03-09 21:27:25',NULL,1,0,'#ff0000'),(26,3,6,'2021-03-09 21:27:25','2021-03-09 21:27:25',NULL,1,0,'#ff0000'),(27,3,7,'2021-03-09 21:27:25','2021-05-08 11:15:28',NULL,1,18,'#ff0000');
/*!40000 ALTER TABLE `facility_projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorite_filters`
--

DROP TABLE IF EXISTS `favorite_filters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `favorite_filters` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT 0,
  `shared` tinyint(1) DEFAULT NULL,
  `private` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite_filters`
--

LOCK TABLES `favorite_filters` WRITE;
/*!40000 ALTER TABLE `favorite_filters` DISABLE KEYS */;
INSERT INTO `favorite_filters` VALUES (8,'TEST',1,1,0,1,NULL,'2021-04-27 15:46:38','2021-04-27 15:48:02');
/*!40000 ALTER TABLE `favorite_filters` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_severities`
--

LOCK TABLES `issue_severities` WRITE;
/*!40000 ALTER TABLE `issue_severities` DISABLE KEYS */;
INSERT INTO `issue_severities` VALUES (1,'Grave Danger','2021-01-27 21:42:17','2021-01-27 21:42:17'),(2,'Another Issue Severity','2021-01-27 21:42:37','2021-01-27 21:42:37'),(3,'Issue Severity five','2021-01-27 21:42:50','2021-01-27 21:42:50'),(4,'Another Issue Severity Ten','2021-01-27 21:43:03','2021-01-27 21:43:03');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_stages`
--

LOCK TABLES `issue_stages` WRITE;
/*!40000 ALTER TABLE `issue_stages` DISABLE KEYS */;
INSERT INTO `issue_stages` VALUES (1,'Phase I','2021-01-27 21:41:11','2021-01-27 21:41:11',0),(2,'Phase II','2021-01-27 21:41:23','2021-01-27 21:41:23',0),(3,'Phase III','2021-01-27 21:41:33','2021-01-27 21:41:33',0),(4,'Phase IV','2021-01-27 21:41:42','2021-01-27 21:41:42',0),(5,'Phase V','2021-03-08 15:18:00','2021-03-08 15:18:15',0),(6,'Phase VI','2021-03-08 15:18:25','2021-03-08 15:18:25',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_types`
--

LOCK TABLES `issue_types` WRITE;
/*!40000 ALTER TABLE `issue_types` DISABLE KEYS */;
INSERT INTO `issue_types` VALUES (1,'Serious','2021-01-27 21:40:18','2021-01-27 21:40:18'),(2,'Urgent','2021-01-27 21:40:29','2021-01-27 21:40:29'),(3,'Showstopper','2021-01-27 21:40:40','2021-01-27 21:40:40'),(4,'Minor','2021-01-27 21:40:57','2021-01-27 21:40:57');
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
  `user_type` varchar(255) DEFAULT 'responsible',
  PRIMARY KEY (`id`),
  KEY `index_issue_users_on_user_id` (`user_id`),
  KEY `index_issue_users_on_issue_id` (`issue_id`),
  KEY `index_issue_users_on_user_type` (`user_type`),
  CONSTRAINT `fk_rails_a68dc2b01f` FOREIGN KEY (`issue_id`) REFERENCES `issues` (`id`),
  CONSTRAINT `fk_rails_b77bcdcb95` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issue_users`
--

LOCK TABLES `issue_users` WRITE;
/*!40000 ALTER TABLE `issue_users` DISABLE KEYS */;
INSERT INTO `issue_users` VALUES (5,2,6,'2021-02-05 22:49:07','2021-02-05 22:49:07','consulted'),(10,3,6,'2021-03-05 01:56:27','2021-03-05 01:56:27','consulted'),(14,4,13,'2021-03-08 16:01:32','2021-03-08 16:01:32','informed'),(15,2,13,'2021-03-08 16:01:32','2021-03-08 16:01:32','informed'),(16,1,13,'2021-03-08 16:01:32','2021-03-08 16:01:32','informed'),(27,5,12,'2021-03-19 16:06:42','2021-03-19 16:06:42','accountable'),(29,5,18,'2021-03-23 14:06:34','2021-03-23 14:06:34','accountable'),(30,2,18,'2021-03-23 14:06:34','2021-03-23 14:06:34','responsible'),(31,4,18,'2021-03-23 14:06:34','2021-03-23 14:06:34','informed'),(32,3,18,'2021-03-23 14:06:34','2021-03-23 14:06:34','informed'),(33,2,18,'2021-03-23 14:06:34','2021-03-23 14:06:34','informed'),(34,1,18,'2021-03-23 14:06:34','2021-03-23 14:06:34','informed'),(35,1,8,'2021-04-05 17:35:25','2021-04-05 17:35:25','accountable'),(39,2,8,'2021-05-06 21:22:07','2021-05-06 21:22:07','responsible'),(40,2,3,'2021-05-06 21:27:36','2021-05-06 21:27:36','responsible'),(41,2,3,'2021-05-06 21:27:53','2021-05-06 21:27:53','accountable'),(42,1,6,'2021-05-07 16:06:07','2021-05-07 16:06:07','responsible');
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
  KEY `index_issues_on_task_type_id` (`task_type_id`),
  CONSTRAINT `fk_rails_35466cac28` FOREIGN KEY (`issue_stage_id`) REFERENCES `issue_stages` (`id`),
  CONSTRAINT `fk_rails_500505dd6c` FOREIGN KEY (`issue_type_id`) REFERENCES `issue_types` (`id`),
  CONSTRAINT `fk_rails_be5361d9be` FOREIGN KEY (`facility_project_id`) REFERENCES `facility_projects` (`id`),
  CONSTRAINT `fk_rails_be6ee4770c` FOREIGN KEY (`issue_severity_id`) REFERENCES `issue_severities` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `issues`
--

LOCK TABLES `issues` WRITE;
/*!40000 ALTER TABLE `issues` DISABLE KEYS */;
INSERT INTO `issues` VALUES (2,'PROFEASSAONASD','',2,2,1,'2021-01-11','2021-07-22','2021-01-28 21:44:45','2021-05-07 16:05:18',100,0,0,'2021-05-07 16:05:18',NULL,1,2),(3,'MAP VIEW EDIT ','     key = key.replace(/[^ -~]/g,\'\');',3,1,1,'2021-02-09','2021-02-09','2021-02-02 03:25:04','2021-05-17 20:42:27',50,0,0,'2021-05-06 21:27:36',NULL,0,2),(4,'Issue ABCDEFSFKLNSF','',3,2,1,'2021-02-01','2021-08-19','2021-02-02 03:25:56','2021-05-10 17:25:43',0,0,0,NULL,1,0,2),(5,'Test Issue 2','f',3,3,1,'2021-02-11','2021-09-17','2021-02-02 03:26:21','2021-03-01 22:38:07',0,0,0,NULL,NULL,0,1),(6,'SOLUTION','',2,3,1,'2021-02-22','2022-03-19','2021-02-02 03:26:56','2021-05-07 16:15:52',100,0,0,'2021-05-07 16:15:52',NULL,0,2),(7,'Test Issue','ge',3,3,4,'2021-03-01','2021-02-28','2021-02-03 22:34:17','2021-05-08 10:49:09',0,0,0,NULL,4,0,1),(8,'ALAN  THANK YOU  ','deliberate',1,3,1,'2021-02-16','2021-02-27','2021-02-22 18:59:43','2021-05-06 21:26:37',100,0,0,'2021-05-06 21:26:37',NULL,0,NULL),(9,'Test Issue','ewf',2,2,1,'2021-02-15','2021-02-27','2021-02-22 19:01:05','2021-04-05 20:05:56',75,0,0,NULL,NULL,0,2),(11,'LATE IN THE DAY','',3,1,1,'2021-02-23','2021-07-16','2021-02-22 21:16:10','2021-02-22 21:16:10',0,1,0,NULL,NULL,0,NULL),(12,'Feb 2328567890','w',3,2,1,'2021-02-16','2021-06-17','2021-02-23 18:37:14','2021-04-27 19:54:47',0,1,0,NULL,NULL,0,1),(13,'NEW MODAL FORM','f',2,3,1,'2021-03-17','2021-06-25','2021-03-08 15:58:33','2021-05-06 13:54:38',25,0,0,NULL,NULL,0,1),(15,'Test Issuesss','',2,2,5,'2021-03-01','2021-12-31','2021-03-10 14:58:29','2021-05-12 21:32:40',0,0,0,NULL,3,0,NULL),(16,'Issue 1','',3,1,16,'2021-03-10','2021-08-20','2021-03-11 14:48:32','2021-03-11 14:48:32',0,1,0,NULL,NULL,0,1),(17,'Issue ABCDEF','',3,3,11,'2021-03-21','2021-10-21','2021-03-11 15:32:13','2021-03-11 15:32:13',0,1,0,NULL,NULL,0,NULL),(18,'Proper Filtering','',1,2,16,'2021-03-18','2024-01-18','2021-03-23 14:06:33','2021-03-23 14:06:33',0,1,0,NULL,4,0,NULL),(19,'Issue to Test Steps','',3,3,5,'2021-03-01','2021-09-30','2021-03-31 15:36:20','2021-03-31 15:36:20',0,1,0,NULL,3,1,1),(20,'Progress Bar ','',2,3,21,'2021-03-19','2021-10-29','2021-03-31 19:48:29','2021-03-31 20:07:52',100,0,0,NULL,1,0,NULL),(21,'April 28th','',1,2,1,'2021-04-20','2021-09-23','2021-04-28 18:58:19','2021-05-07 15:19:41',100,0,0,'2021-05-07 15:19:41',NULL,0,NULL),(22,'May 1sy','',1,3,1,'2021-04-01','2021-09-28','2021-04-28 19:03:49','2021-04-28 19:03:49',0,1,0,NULL,NULL,0,NULL),(23,'Test Issues','d',3,1,27,'2021-05-15','2021-05-25','2021-05-06 01:08:03','2021-05-06 03:18:28',0,0,0,NULL,5,0,1);
/*!40000 ALTER TABLE `issues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lesson_details`
--

DROP TABLE IF EXISTS `lesson_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lesson_details` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `finding` text DEFAULT NULL,
  `recommendation` text DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `lesson_id` int(11) DEFAULT NULL,
  `detail_type` int(11) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lesson_details`
--

LOCK TABLES `lesson_details` WRITE;
/*!40000 ALTER TABLE `lesson_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `lesson_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lesson_projects`
--

DROP TABLE IF EXISTS `lesson_projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lesson_projects` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `lesson_id` int(11) DEFAULT NULL,
  `facility_project_id` int(11) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lesson_projects`
--

LOCK TABLES `lesson_projects` WRITE;
/*!40000 ALTER TABLE `lesson_projects` DISABLE KEYS */;
INSERT INTO `lesson_projects` VALUES (1,1,5,'2021-05-03 16:25:09.130634','2021-05-03 16:25:09.130634');
/*!40000 ALTER TABLE `lesson_projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lesson_stages`
--

DROP TABLE IF EXISTS `lesson_stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lesson_stages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lesson_stages`
--

LOCK TABLES `lesson_stages` WRITE;
/*!40000 ALTER TABLE `lesson_stages` DISABLE KEYS */;
/*!40000 ALTER TABLE `lesson_stages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lesson_users`
--

DROP TABLE IF EXISTS `lesson_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lesson_users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `lesson_id` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_lesson_users_on_user_id` (`user_id`),
  KEY `index_lesson_users_on_lesson_id` (`lesson_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lesson_users`
--

LOCK TABLES `lesson_users` WRITE;
/*!40000 ALTER TABLE `lesson_users` DISABLE KEYS */;
INSERT INTO `lesson_users` VALUES (1,7,1,'2021-04-22 17:36:45.186381','2021-04-22 17:36:45.186381'),(6,7,5,'2021-05-03 16:31:13.029467','2021-05-03 16:31:13.029467');
/*!40000 ALTER TABLE `lesson_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lessons`
--

DROP TABLE IF EXISTS `lessons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lessons` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `stage` varchar(255) DEFAULT NULL,
  `task_type_id` int(11) DEFAULT NULL,
  `task_id` int(11) DEFAULT NULL,
  `risk_id` int(11) DEFAULT NULL,
  `issue_id` int(11) DEFAULT NULL,
  `issue_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `lesson_stage_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lessons`
--

LOCK TABLES `lessons` WRITE;
/*!40000 ALTER TABLE `lessons` DISABLE KEYS */;
INSERT INTO `lessons` VALUES (1,'New Lesson','Test','2021-04-30 04:00:00',NULL,1,NULL,NULL,2,1,1,1,'2021-04-22 17:36:45.179336','2021-04-23 17:16:32.968240',NULL),(5,'New Lesson','Test','2021-04-30 04:00:00',NULL,1,NULL,NULL,2,1,1,1,'2021-05-03 16:31:13.026149','2021-05-03 16:31:13.026149',NULL),(6,'Does this worK?','sf','2021-05-19 04:00:00',NULL,1,NULL,NULL,NULL,1,1,7,'2021-05-04 17:42:04.326605','2021-05-04 17:42:04.326605',0);
/*!40000 ALTER TABLE `lessons` ENABLE KEYS */;
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
  KEY `index_notes_on_user_id` (`user_id`),
  KEY `index_notes_on_noteable_type` (`noteable_type`),
  KEY `index_notes_on_noteable_id` (`noteable_id`),
  KEY `index_notes_on_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=133 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notes`
--

LOCK TABLES `notes` WRITE;
/*!40000 ALTER TABLE `notes` DISABLE KEYS */;
INSERT INTO `notes` VALUES (3,'FacilityProject',1,1,'WANCK!','2021-02-07 11:13:07','2021-04-28 19:47:05'),(4,'FacilityProject',5,1,'TEST NOTE SAVEDSS','2021-02-07 11:13:36','2021-04-27 00:09:06'),(5,'FacilityProject',5,1,'HHHHHHHHHHHHH','2021-02-07 11:14:20','2021-02-07 11:14:20'),(6,'FacilityProject',5,1,'fgeeggege','2021-02-07 11:25:22','2021-02-07 11:25:22'),(7,'FacilityProject',5,1,'ddddd','2021-02-07 11:33:28','2021-02-07 11:33:28'),(8,'FacilityProject',1,1,'BEFORE AND AFTER IS AWESOME','2021-02-07 11:48:57','2021-04-28 17:49:32'),(9,'FacilityProject',5,1,'NNNN','2021-02-07 11:49:15','2021-02-07 11:49:15'),(10,'FacilityProject',5,1,'NNNNNNNN','2021-02-07 11:50:11','2021-02-07 11:50:11'),(11,'FacilityProject',1,1,'NNNTTTT SURRR','2021-02-07 11:50:56','2021-04-27 20:26:37'),(12,'FacilityProject',5,1,'PACK','2021-02-07 11:52:04','2021-02-07 11:53:08'),(13,'FacilityProject',1,1,'THE NOTES TAB WORKS NOW','2021-02-07 11:57:38','2021-02-07 11:57:38'),(15,'FacilityProject',1,1,'BOP','2021-02-07 12:01:52','2021-02-07 12:02:07'),(16,'FacilityProject',5,1,'afs','2021-02-07 12:20:55','2021-02-07 12:20:55'),(17,'FacilityProject',5,1,'RIHWFNF','2021-02-07 12:21:23','2021-02-07 12:21:23'),(18,'FacilityProject',1,1,'NNNO','2021-02-07 12:23:10','2021-02-07 12:23:10'),(19,'FacilityProject',5,1,'sdfga','2021-02-07 12:23:26','2021-02-07 12:23:26'),(20,'FacilityProject',1,1,'gfdgf','2021-02-07 12:27:11','2021-02-07 12:27:11'),(21,'FacilityProject',5,1,'GHGGGG','2021-02-07 12:27:19','2021-02-07 12:27:19'),(22,'FacilityProject',5,1,'ggggggggggggggggggggg','2021-02-07 12:29:42','2021-02-07 12:29:42'),(23,'FacilityProject',1,1,'fdg','2021-02-07 23:46:57','2021-02-07 23:46:57'),(24,'FacilityProject',1,1,'A test from PR.','2021-02-08 00:04:44','2021-02-08 00:04:44'),(25,'FacilityProject',1,1,'SOU','2021-02-08 00:13:53','2021-02-08 00:14:14'),(26,'FacilityProject',1,1,'ANOTHER CANNED MEAL','2021-02-08 00:14:22','2021-02-08 00:14:33'),(27,'FacilityProject',1,1,'THIS WORKS NOW!!','2021-02-08 00:43:12','2021-02-08 00:43:12'),(28,'FacilityProject',1,6,'This is Jose\'s note','2021-02-11 16:36:16','2021-02-11 16:36:16'),(29,'FacilityProject',1,6,'This is another one of Jose\'s note','2021-02-11 16:36:40','2021-02-11 16:36:40'),(30,'FacilityProject',1,1,'Another one of my notes.','2021-02-11 20:47:17','2021-02-11 20:47:17'),(31,'Task',4,1,'My update.','2021-02-11 20:47:52','2021-02-11 20:47:52'),(32,'Issue',6,1,'My awesome update.','2021-02-11 21:37:18','2021-02-11 21:37:18'),(33,'Risk',11,1,'LKFNSLKN','2021-02-11 23:51:59','2021-02-11 23:51:59'),(34,'Risk',11,1,'we','2021-02-11 23:52:18','2021-02-11 23:52:18'),(35,'FacilityProject',1,1,'NOTE UPDATESSSSED','2021-02-13 19:59:29','2021-04-27 18:41:31'),(40,'Risk',19,1,'Update made.','2021-02-19 00:57:40','2021-02-19 00:57:40'),(41,'Task',11,1,'My update.','2021-02-19 01:06:40','2021-02-19 01:06:40'),(42,'Task',12,1,'My update.','2021-02-19 01:06:47','2021-02-19 01:06:47'),(46,'Task',15,6,'Just one update','2021-02-23 15:27:23','2021-02-23 15:27:23'),(47,'Task',15,6,'JUs one','2021-02-23 15:27:55','2021-02-23 15:27:55'),(48,'Task',15,6,'JUs one','2021-02-23 15:28:04','2021-02-23 15:28:04'),(49,'Task',15,6,'JUs one','2021-02-23 15:28:09','2021-02-23 15:28:09'),(51,'Task',15,1,'NOW','2021-02-23 21:44:38','2021-02-23 21:44:38'),(52,'Task',22,1,'UPDATE','2021-02-23 22:21:55','2021-02-23 22:21:55'),(53,'Risk',22,6,'NN','2021-02-23 22:28:46','2021-02-23 22:28:46'),(54,'Risk',22,6,'NN','2021-02-23 22:28:49','2021-02-23 22:28:49'),(55,'Risk',22,6,'NN','2021-02-23 22:28:53','2021-02-23 22:28:53'),(56,'Risk',22,6,'NOWNOW','2021-02-23 22:32:08','2021-02-23 22:32:08'),(57,'Risk',22,6,'ME ME','2021-02-23 22:33:52','2021-02-23 22:33:52'),(58,'Issue',8,6,'NOW','2021-02-23 22:36:34','2021-02-23 22:36:34'),(59,'Risk',31,1,'Save this.','2021-03-19 17:10:43','2021-03-19 17:10:43'),(60,'Risk',26,1,'Update one of one','2021-03-23 17:54:33','2021-03-23 17:54:33'),(62,'Issue',3,1,'Testing last update sorting. ','2021-04-01 15:08:47','2021-04-01 15:08:47'),(63,'Task',15,1,'New update','2021-04-01 19:44:28','2021-04-01 19:44:28'),(64,'Risk',16,1,'Sorting by date','2021-04-01 19:46:38','2021-04-01 19:46:38'),(68,'Lesson',1,1,'Test','2021-04-23 17:16:32','2021-04-23 17:16:32'),(69,'Lesson',1,1,'Another test','2021-04-23 17:19:05','2021-04-23 17:19:05'),(70,'Task',33,1,'amf','2021-04-23 19:59:55','2021-04-23 19:59:55'),(71,'FacilityProject',1,1,'28Apr N','2021-04-28 14:16:56','2021-04-28 14:26:24'),(72,'FacilityProject',4,1,'TEst note 28Apr','2021-04-28 18:33:54','2021-04-28 18:33:54'),(73,'FacilityProject',1,1,'Check me out','2021-04-28 18:34:56','2021-04-28 18:34:56'),(74,'FacilityProject',1,1,'THI IS SFOPEFINF','2021-04-28 18:38:48','2021-04-28 18:38:48'),(75,'FacilityProject',1,1,'Check this out','2021-04-28 18:51:24','2021-04-28 18:51:24'),(76,'FacilityProject',1,1,'This should be on top.','2021-04-28 18:54:46','2021-04-28 18:54:46'),(77,'FacilityProject',1,1,'What about now','2021-04-28 18:56:10','2021-04-28 18:56:10'),(78,'FacilityProject',1,1,'May 1st','2021-04-28 19:04:18','2021-04-28 19:04:18'),(79,'FacilityProject',1,1,'SAev this','2021-04-28 19:07:43','2021-04-28 19:07:43'),(80,'FacilityProject',1,1,'Noteable ID','2021-04-28 19:09:06','2021-04-28 19:09:06'),(81,'FacilityProject',1,1,'WHo this','2021-04-28 19:17:01','2021-04-28 19:17:01'),(82,'FacilityProject',1,1,'What','2021-04-28 19:20:00','2021-04-28 19:20:00'),(83,'FacilityProject',1,1,'WHa\'ts uop oaterw','2021-04-28 19:21:35','2021-04-28 19:21:35'),(84,'FacilityProject',1,1,'HEHEHEHE','2021-04-28 19:21:46','2021-04-28 19:21:46'),(85,'FacilityProject',1,1,'Laughing','2021-04-28 19:24:08','2021-04-28 19:24:08'),(86,'FacilityProject',1,1,'Burpees ARe good','2021-04-28 19:26:54','2021-04-28 19:29:41'),(87,'FacilityProject',1,1,'What about this','2021-04-28 19:29:24','2021-04-28 19:29:24'),(88,'FacilityProject',1,1,'Run fast!','2021-04-28 19:31:21','2021-04-28 19:31:21'),(89,'FacilityProject',1,1,'Run slow','2021-04-28 19:33:32','2021-04-28 19:33:32'),(90,'FacilityProject',1,1,'JUmp','2021-04-28 19:36:34','2021-04-28 19:36:34'),(91,'FacilityProject',1,1,'Toch','2021-04-28 19:37:20','2021-04-28 19:37:20'),(92,'FacilityProject',1,1,'What about now','2021-04-28 19:41:02','2021-04-28 19:41:02'),(93,'FacilityProject',1,1,'It works now  :) Or doesn\'t it\n','2021-04-28 19:41:26','2021-04-28 19:41:37'),(94,'FacilityProject',1,1,'This works','2021-04-28 19:46:32','2021-04-28 19:46:32'),(95,'FacilityProject',1,1,'This works here too.','2021-04-28 19:46:52','2021-04-28 19:46:52'),(96,'FacilityProject',1,1,'Boo','2021-04-28 19:50:53','2021-04-28 19:50:53'),(97,'FacilityProject',1,1,'Hi','2021-04-28 19:52:10','2021-04-28 19:52:10'),(98,'Task',38,1,'Awaiting feedback and guidance from MEooD IT on FMH domain and URL​.  NeOOOed to identify adsjn a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-14 20:58:40','2021-05-17 14:31:16'),(99,'Task',14,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL​.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-14 20:59:42','2021-05-14 20:59:42'),(100,'Issue',12,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL​.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-17 16:36:57','2021-05-17 16:36:57'),(101,'Issue',3,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL​.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-17 16:38:49','2021-05-17 16:38:49'),(102,'Risk',3,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL​.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-17 16:49:48','2021-05-17 16:49:48'),(103,'Issue',9,1,'et','2021-05-17 17:09:44','2021-05-17 17:09:44'),(104,'Issue',9,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL​.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-17 17:10:49','2021-05-17 17:10:49'),(105,'Issue',3,1,'TEST','2021-05-17 17:39:23','2021-05-17 17:39:23'),(106,'Issue',3,1,'ANOTHER ONE','2021-05-17 17:41:02','2021-05-17 17:41:02'),(107,'Issue',3,1,'PLEASE','2021-05-17 17:42:08','2021-05-17 17:42:08'),(108,'Issue',3,1,'Update Test','2021-05-17 17:46:09','2021-05-17 17:46:09'),(109,'Issue',3,1,'JJJJJ','2021-05-17 20:23:25','2021-05-17 20:23:25'),(110,'Issue',3,1,'KKKKK','2021-05-17 20:27:35','2021-05-17 20:27:35'),(111,'Issue',3,1,'dsfssf','2021-05-17 20:36:58','2021-05-17 20:36:58'),(112,'Issue',3,1,'KKKKKSFKNFNF','2021-05-17 20:38:35','2021-05-17 20:38:35'),(113,'Issue',3,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL​.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-17 20:40:27','2021-05-17 20:40:27'),(114,'Issue',3,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL​.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-17 20:42:51','2021-05-17 20:42:51'),(115,'Issue',22,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL​.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-17 20:43:14','2021-05-17 20:43:14'),(116,'Issue',3,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL​.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-17 20:54:55','2021-05-17 20:55:31'),(117,'Issue',5,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL​.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-17 21:25:36','2021-05-17 21:25:36'),(118,'Task',7,1,'waiting feedback and guidance from MED IT on FMH domain and URL.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-18 16:57:37','2021-05-18 20:09:23'),(119,'Task',7,1,'Let\'s see','2021-05-18 17:29:41','2021-05-18 17:29:41'),(120,'Task',7,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-18 17:30:19','2021-05-18 20:09:23'),(121,'Task',16,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL​.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-18 17:42:38','2021-05-18 17:42:38'),(122,'Task',8,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL​.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-18 17:57:28','2021-05-18 17:57:28'),(123,'Task',7,1,'LLLLE','2021-05-18 18:06:01','2021-05-18 18:06:01'),(124,'Task',35,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL​.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-18 18:26:58','2021-05-18 18:26:58'),(125,'Task',7,1,'ME','2021-05-18 18:39:16','2021-05-18 18:39:16'),(126,'Task',7,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-18 19:34:43','2021-05-18 20:09:23'),(127,'Task',7,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-18 19:36:15','2021-05-18 20:09:23'),(128,'Task',7,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-18 19:37:55','2021-05-18 20:09:23'),(129,'Task',7,1,'waiting feedback and guidance from MED IT on FMH domain and URL.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-18 19:45:00','2021-05-18 20:09:23'),(130,'Task',7,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-18 19:59:07','2021-05-18 20:09:23'),(131,'Task',40,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL​.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-18 19:59:45','2021-05-18 19:59:45'),(132,'Task',7,1,'Awaiting feedback and guidance from MED IT on FMH domain and URL.  Need to identify a domain that is available and easy to remember for patients and then acquire the domain.','2021-05-18 20:09:23','2021-05-18 20:09:23');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organizations`
--

LOCK TABLES `organizations` WRITE;
/*!40000 ALTER TABLE `organizations` DISABLE KEYS */;
INSERT INTO `organizations` VALUES (1,'Acme Org','2021-01-27 21:50:58','2021-01-27 21:50:58'),(2,'Acme Org 2','2021-01-27 21:51:09','2021-01-27 21:51:09');
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
  `calendar_view` varchar(255) DEFAULT 'R',
  `lessons` varchar(255) DEFAULT 'R',
  PRIMARY KEY (`id`),
  KEY `index_privileges_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_fa4d6ee0e7` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `privileges`
--

LOCK TABLES `privileges` WRITE;
/*!40000 ALTER TABLE `privileges` DISABLE KEYS */;
INSERT INTO `privileges` VALUES (1,'RWD','RWD','RWD','RWD','RWD',2,'2021-01-27 21:36:09','2021-01-27 21:36:09','R','R','R','R','R','R','R','R','RWD','R','R'),(2,'RWD','RWD','RWD','RWD','WRD',1,'2021-01-27 21:50:35','2021-01-27 21:50:35','R','R','R','R','R','R','R','R','RWD','R','R'),(3,'R','R','R','R','',3,'2021-01-28 23:04:46','2021-01-28 23:04:46','R','R','R','R','R','R','R','R','R','R','R'),(4,'R','R','R','R','',4,'2021-01-28 23:06:21','2021-01-28 23:06:21','R','R','R','R','R','R','R','R','R','R','R'),(5,'R','R','R','R','R',5,'2021-01-29 14:43:34','2021-01-29 14:43:34','R','R','R','R','R','R','R','R','R','R','R'),(6,'R','R','R','R','R',6,'2021-01-29 14:44:23','2021-04-16 17:38:54','R','R','R','R','R','R','R','R','R','R','R'),(7,'R','R','R','R','',7,'2021-04-08 19:31:06','2021-04-08 19:31:06','R','R','R','R','R','R','R','R','R','R','R');
/*!40000 ALTER TABLE `privileges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `progress_lists`
--

DROP TABLE IF EXISTS `progress_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `progress_lists` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `body` text DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `checklist_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_progress_lists_on_user_id` (`user_id`),
  KEY `index_progress_lists_on_checklist_id` (`checklist_id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `progress_lists`
--

LOCK TABLES `progress_lists` WRITE;
/*!40000 ALTER TABLE `progress_lists` DISABLE KEYS */;
INSERT INTO `progress_lists` VALUES (1,'This should be on top',1,2,'2021-02-19 01:22:08','2021-02-19 01:22:08'),(4,'THIS SHOULD BE THE 19th',1,3,'2021-02-19 02:46:49','2021-02-19 19:08:38'),(5,'LATEST ONE',1,3,'2021-02-19 02:47:31','2021-02-19 02:47:31'),(6,'Number 1',1,3,'2021-02-19 15:23:36','2021-02-19 15:23:36'),(7,'Checklist Update',1,4,'2021-02-19 15:31:46','2021-02-19 15:31:46'),(8,'dfgdfgdfgdggd',1,3,'2021-02-19 15:43:00','2021-02-19 15:43:00'),(9,'srkjgdbdsfkg',1,4,'2021-02-19 19:08:38','2021-02-19 19:08:38'),(10,'3:07pm',1,3,'2021-02-19 20:07:33','2021-02-19 22:09:11'),(11,'bbbbb',1,3,'2021-02-19 20:25:28','2021-02-19 20:25:28'),(12,'Red Border',1,3,'2021-02-19 22:08:39','2021-02-19 22:08:39'),(13,'sdkvjnvkx',1,6,'2021-02-22 21:11:34','2021-02-22 21:11:34'),(14,'sggdsdgds',1,7,'2021-02-22 21:29:57','2021-02-22 21:29:57'),(15,'sdgvlknfdlkfd',1,8,'2021-02-23 14:39:40','2021-02-23 14:39:40'),(24,'One update',1,8,'2021-02-23 14:45:52','2021-02-23 14:45:52'),(25,'ANother update',1,8,'2021-02-23 14:46:17','2021-02-23 14:46:17'),(26,'A fourth up',1,8,'2021-02-23 14:46:36','2021-02-23 14:47:46'),(27,'A Fifth UPDATE',1,8,'2021-02-23 14:47:46','2021-02-23 14:47:46'),(28,'dgsz',1,8,'2021-02-23 14:59:33','2021-02-23 14:59:33'),(29,'zsdg',1,8,'2021-02-23 14:59:33','2021-02-23 14:59:33'),(30,'LOOK',1,8,'2021-02-23 14:59:33','2021-02-23 15:14:16'),(31,'LATEST ONE',1,8,'2021-02-23 15:13:09','2021-02-23 15:13:09'),(32,'Another one',6,8,'2021-02-23 15:17:20','2021-02-23 15:17:20'),(33,'BOO',6,8,'2021-02-23 15:18:47','2021-02-23 15:18:47'),(34,'BOO',6,8,'2021-02-23 15:18:52','2021-02-23 15:18:52'),(35,'BOO',6,8,'2021-02-23 15:18:56','2021-02-23 15:18:56'),(36,'TEST',6,8,'2021-02-23 15:20:04','2021-02-23 15:20:04'),(37,'TEST',6,8,'2021-02-23 15:20:11','2021-02-23 15:20:11'),(38,'TEST',6,8,'2021-02-23 15:20:12','2021-02-23 15:20:12'),(39,'EDIT TEST',6,8,'2021-02-23 15:20:37','2021-02-23 15:20:37'),(43,'HOT',6,8,'2021-02-23 15:21:22','2021-02-23 15:21:22'),(65,'Check ME OUT',1,8,'2021-02-23 20:51:01','2021-02-23 20:56:02'),(66,'TIME!!',1,8,'2021-02-23 20:59:34','2021-02-23 20:59:34'),(67,'It work',1,8,'2021-02-23 21:16:39','2021-02-23 21:17:58'),(68,'LOOK',1,8,'2021-02-23 21:17:58','2021-02-23 21:17:58'),(69,'skldjfbksdfj',1,8,'2021-02-23 21:21:14','2021-02-23 21:21:14'),(70,'ME',1,8,'2021-02-23 21:43:58','2021-02-23 21:43:58'),(73,'Me',6,8,'2021-02-24 01:20:19','2021-02-24 01:20:19'),(74,'You ',6,8,'2021-02-24 01:20:19','2021-02-24 01:20:19'),(75,'Him',6,8,'2021-02-24 01:20:19','2021-02-24 01:20:19'),(79,'LATEST ONE',1,36,'2021-02-26 03:22:54','2021-02-26 03:22:54'),(80,'Another item',1,36,'2021-02-26 03:23:07','2021-02-26 03:23:07'),(81,'Bppp',1,36,'2021-02-26 03:23:32','2021-02-26 03:23:32'),(82,'Test',1,37,'2021-02-26 14:34:32','2021-02-26 14:34:32'),(83,'One more',1,37,'2021-02-26 14:36:20','2021-02-26 14:36:20'),(84,'Another updates',1,37,'2021-02-26 14:36:31','2021-02-26 14:37:00'),(85,'This should be on topssss',1,36,'2021-02-26 14:37:37','2021-02-26 14:37:45'),(86,'Test',1,26,'2021-02-26 18:41:08','2021-02-26 18:41:08'),(87,'LATEST ONE',1,50,'2021-05-13 20:53:20','2021-05-13 20:53:20'),(88,'dsf',1,51,'2021-05-13 20:59:48','2021-05-13 20:59:48');
/*!40000 ALTER TABLE `progress_lists` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_issue_severities`
--

LOCK TABLES `project_issue_severities` WRITE;
/*!40000 ALTER TABLE `project_issue_severities` DISABLE KEYS */;
INSERT INTO `project_issue_severities` VALUES (1,1,1,'2021-01-27 21:46:43','2021-01-27 21:46:43'),(2,2,1,'2021-01-27 21:46:44','2021-01-27 21:46:44'),(3,3,1,'2021-01-27 21:46:44','2021-01-27 21:46:44'),(4,4,1,'2021-01-27 21:46:44','2021-01-27 21:46:44'),(5,1,2,'2021-01-27 21:47:29','2021-01-27 21:47:29'),(6,2,2,'2021-01-27 21:47:29','2021-01-27 21:47:29'),(7,3,2,'2021-01-27 21:47:30','2021-01-27 21:47:30'),(8,4,2,'2021-01-27 21:47:30','2021-01-27 21:47:30'),(9,1,3,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(10,2,3,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(11,3,3,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(12,4,3,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(13,1,4,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(14,2,4,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(15,3,4,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(16,4,4,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(17,1,5,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(18,2,5,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(19,3,5,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(20,4,5,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(21,1,6,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(22,2,6,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(23,3,6,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(24,4,6,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(25,1,7,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(26,2,7,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(27,3,7,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(28,4,7,'2021-03-09 21:25:01','2021-03-09 21:25:01');
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
  PRIMARY KEY (`id`),
  KEY `index_project_issue_stages_on_project_id` (`project_id`),
  KEY `index_project_issue_stages_on_issue_stage_id` (`issue_stage_id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_issue_stages`
--

LOCK TABLES `project_issue_stages` WRITE;
/*!40000 ALTER TABLE `project_issue_stages` DISABLE KEYS */;
INSERT INTO `project_issue_stages` VALUES (1,1,1,'2021-01-27 21:46:44','2021-01-27 21:46:44'),(2,1,2,'2021-01-27 21:46:44','2021-01-27 21:46:44'),(3,1,3,'2021-01-27 21:46:44','2021-01-27 21:46:44'),(4,1,4,'2021-01-27 21:46:44','2021-01-27 21:46:44'),(5,2,1,'2021-01-27 21:47:30','2021-01-27 21:47:30'),(6,2,2,'2021-01-27 21:47:30','2021-01-27 21:47:30'),(7,2,3,'2021-01-27 21:47:30','2021-01-27 21:47:30'),(8,2,4,'2021-01-27 21:47:30','2021-01-27 21:47:30'),(9,3,1,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(10,3,2,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(11,3,3,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(12,3,4,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(13,3,5,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(14,3,6,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(15,4,1,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(16,4,2,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(17,4,3,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(18,4,4,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(19,4,5,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(20,4,6,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(21,5,1,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(22,5,2,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(23,5,3,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(24,5,4,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(25,5,5,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(26,5,6,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(27,6,1,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(28,6,2,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(29,6,3,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(30,6,4,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(31,6,5,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(32,6,6,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(33,7,1,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(34,7,2,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(35,7,3,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(36,7,4,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(37,7,5,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(38,7,6,'2021-03-09 21:25:01','2021-03-09 21:25:01');
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
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_issue_types`
--

LOCK TABLES `project_issue_types` WRITE;
/*!40000 ALTER TABLE `project_issue_types` DISABLE KEYS */;
INSERT INTO `project_issue_types` VALUES (1,1,1,'2021-01-27 21:46:43','2021-01-27 21:46:43'),(2,2,1,'2021-01-27 21:46:43','2021-01-27 21:46:43'),(3,3,1,'2021-01-27 21:46:43','2021-01-27 21:46:43'),(4,4,1,'2021-01-27 21:46:43','2021-01-27 21:46:43'),(5,1,2,'2021-01-27 21:47:29','2021-01-27 21:47:29'),(6,2,2,'2021-01-27 21:47:29','2021-01-27 21:47:29'),(7,3,2,'2021-01-27 21:47:29','2021-01-27 21:47:29'),(8,4,2,'2021-01-27 21:47:29','2021-01-27 21:47:29'),(9,1,3,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(10,2,3,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(11,3,3,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(12,4,3,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(13,1,4,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(14,2,4,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(15,3,4,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(16,4,4,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(17,1,5,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(18,2,5,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(19,3,5,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(20,4,5,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(21,1,6,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(22,2,6,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(23,3,6,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(24,4,6,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(25,1,7,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(26,2,7,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(27,3,7,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(28,4,7,'2021-03-09 21:25:01','2021-03-09 21:25:01');
/*!40000 ALTER TABLE `project_issue_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_lesson_stages`
--

DROP TABLE IF EXISTS `project_lesson_stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_lesson_stages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `lesson_stage_id` int(11) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_lesson_stages`
--

LOCK TABLES `project_lesson_stages` WRITE;
/*!40000 ALTER TABLE `project_lesson_stages` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_lesson_stages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_privileges`
--

DROP TABLE IF EXISTS `project_privileges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_privileges` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `overview` varchar(255) DEFAULT '---\n- R\n',
  `tasks` varchar(255) DEFAULT '---\n- R\n',
  `notes` varchar(255) DEFAULT '---\n- R\n',
  `issues` varchar(255) DEFAULT '---\n- R\n',
  `admin` varchar(255) DEFAULT NULL,
  `risks` varchar(255) DEFAULT '---\n- R\n',
  `lessons` varchar(255) DEFAULT '---\n- R\n',
  `user_id` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `project_ids` varchar(255) DEFAULT '--- []\n',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_privileges`
--

LOCK TABLES `project_privileges` WRITE;
/*!40000 ALTER TABLE `project_privileges` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_privileges` ENABLE KEYS */;
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
  PRIMARY KEY (`id`),
  KEY `index_project_risk_stages_on_project_id` (`project_id`),
  KEY `index_project_risk_stages_on_risk_stage_id` (`risk_stage_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_risk_stages`
--

LOCK TABLES `project_risk_stages` WRITE;
/*!40000 ALTER TABLE `project_risk_stages` DISABLE KEYS */;
INSERT INTO `project_risk_stages` VALUES (1,1,1,'2021-01-27 21:46:44','2021-01-27 21:46:44'),(2,1,2,'2021-01-27 21:46:44','2021-01-27 21:46:44'),(3,1,3,'2021-01-27 21:46:44','2021-01-27 21:46:44'),(4,2,1,'2021-01-27 21:47:30','2021-01-27 21:47:30'),(5,2,2,'2021-01-27 21:47:30','2021-01-27 21:47:30'),(6,2,3,'2021-01-27 21:47:30','2021-01-27 21:47:30'),(7,3,1,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(8,3,2,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(9,3,3,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(10,4,1,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(11,4,2,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(12,4,3,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(13,5,1,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(14,5,2,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(15,5,3,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(16,6,1,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(17,6,2,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(18,6,3,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(19,7,1,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(20,7,2,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(21,7,3,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(22,1,4,'2021-03-31 15:11:29','2021-03-31 15:11:29');
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
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_statuses`
--

LOCK TABLES `project_statuses` WRITE;
/*!40000 ALTER TABLE `project_statuses` DISABLE KEYS */;
INSERT INTO `project_statuses` VALUES (1,1,1,'2021-01-27 22:12:48','2021-01-27 22:12:48'),(2,2,1,'2021-01-27 22:12:48','2021-01-27 22:12:48'),(3,3,1,'2021-01-27 22:12:48','2021-01-27 22:12:48'),(4,4,1,'2021-01-27 22:12:48','2021-01-27 22:12:48'),(5,1,2,'2021-01-27 22:13:07','2021-01-27 22:13:07'),(6,2,2,'2021-01-27 22:13:07','2021-01-27 22:13:07'),(7,3,2,'2021-01-27 22:13:07','2021-01-27 22:13:07'),(8,4,2,'2021-01-27 22:13:07','2021-01-27 22:13:07'),(9,1,4,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(10,2,4,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(11,3,4,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(12,4,4,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(13,1,5,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(14,2,5,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(15,3,5,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(16,4,5,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(17,1,6,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(18,2,6,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(19,3,6,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(20,4,6,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(21,2,7,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(22,4,7,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(23,1,3,'2021-03-09 23:25:24','2021-03-09 23:25:24'),(24,2,3,'2021-03-09 23:25:24','2021-03-09 23:25:24'),(25,3,3,'2021-03-09 23:25:24','2021-03-09 23:25:24'),(26,4,3,'2021-03-09 23:25:24','2021-03-09 23:25:24'),(27,1,7,'2021-05-05 13:53:12','2021-05-05 13:53:12');
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
  PRIMARY KEY (`id`),
  KEY `index_project_task_stages_on_project_id` (`project_id`),
  KEY `index_project_task_stages_on_task_stage_id` (`task_stage_id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_task_stages`
--

LOCK TABLES `project_task_stages` WRITE;
/*!40000 ALTER TABLE `project_task_stages` DISABLE KEYS */;
INSERT INTO `project_task_stages` VALUES (2,1,2,'2021-01-27 21:46:44','2021-01-27 21:46:44'),(3,1,3,'2021-01-27 21:46:44','2021-01-27 21:46:44'),(4,1,4,'2021-01-27 21:46:44','2021-01-27 21:46:44'),(5,2,1,'2021-01-27 21:47:30','2021-01-27 21:47:30'),(6,2,2,'2021-01-27 21:47:30','2021-01-27 21:47:30'),(7,2,3,'2021-01-27 21:47:30','2021-01-27 21:47:30'),(8,2,4,'2021-01-27 21:47:30','2021-01-27 21:47:30'),(9,3,1,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(10,3,2,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(11,3,3,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(12,3,4,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(13,4,1,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(14,4,2,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(15,4,3,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(16,4,4,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(17,5,1,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(18,5,2,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(19,5,3,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(20,5,4,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(21,6,2,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(22,6,3,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(23,6,4,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(28,1,5,'2021-03-31 15:11:03','2021-03-31 15:11:03'),(29,1,6,'2021-03-31 15:11:03','2021-03-31 15:11:03'),(30,1,7,'2021-03-31 15:11:03','2021-03-31 15:11:03'),(31,1,8,'2021-03-31 15:17:34','2021-03-31 15:17:34'),(32,1,9,'2021-03-31 15:17:34','2021-03-31 15:17:34'),(33,1,10,'2021-03-31 15:17:34','2021-03-31 15:17:34'),(39,7,1,'2021-05-05 16:51:55','2021-05-05 16:51:55'),(40,7,2,'2021-05-05 16:51:55','2021-05-05 16:51:55'),(41,7,3,'2021-05-05 16:51:55','2021-05-05 16:51:55'),(42,7,4,'2021-05-05 16:51:55','2021-05-05 16:51:55'),(43,7,6,'2021-05-05 16:54:50','2021-05-05 16:54:50'),(44,7,7,'2021-05-05 16:54:50','2021-05-05 16:54:50');
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_task_types`
--

LOCK TABLES `project_task_types` WRITE;
/*!40000 ALTER TABLE `project_task_types` DISABLE KEYS */;
INSERT INTO `project_task_types` VALUES (1,1,1,'2021-01-27 21:46:43','2021-01-27 21:46:43'),(2,2,1,'2021-01-27 21:46:43','2021-01-27 21:46:43'),(3,1,2,'2021-01-27 21:47:29','2021-01-27 21:47:29'),(4,2,2,'2021-01-27 21:47:29','2021-01-27 21:47:29'),(5,1,3,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(6,2,3,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(7,1,4,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(8,2,4,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(9,1,5,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(10,2,5,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(11,1,6,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(12,2,6,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(13,1,7,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(14,2,7,'2021-03-09 21:25:01','2021-03-09 21:25:01');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_types`
--

LOCK TABLES `project_types` WRITE;
/*!40000 ALTER TABLE `project_types` DISABLE KEYS */;
INSERT INTO `project_types` VALUES (1,'Enhancements','2021-01-27 21:36:31','2021-01-27 21:36:31');
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
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_users`
--

LOCK TABLES `project_users` WRITE;
/*!40000 ALTER TABLE `project_users` DISABLE KEYS */;
INSERT INTO `project_users` VALUES (2,1,2,'2021-01-27 21:37:18','2021-01-27 21:37:18'),(5,2,2,'2021-01-27 21:47:30','2021-01-27 21:47:30'),(11,1,5,'2021-01-29 14:45:27','2021-01-29 14:45:27'),(17,3,2,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(18,3,3,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(19,3,4,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(20,3,5,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(21,3,6,'2021-03-09 21:00:25','2021-03-09 21:00:25'),(22,4,1,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(23,4,2,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(24,4,3,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(25,4,5,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(26,4,6,'2021-03-09 21:01:17','2021-03-09 21:01:17'),(27,5,1,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(28,5,2,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(29,5,4,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(30,5,5,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(31,5,6,'2021-03-09 21:13:51','2021-03-09 21:13:51'),(32,6,1,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(33,6,3,'2021-03-09 21:14:48','2021-03-09 21:14:48'),(35,7,2,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(36,7,3,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(37,7,5,'2021-03-09 21:25:01','2021-03-09 21:25:01'),(38,3,1,'2021-03-09 23:25:24','2021-03-09 23:25:24'),(43,1,7,'2021-04-08 19:31:35','2021-04-08 19:31:35'),(44,2,7,'2021-04-08 19:31:35','2021-04-08 19:31:35'),(45,3,7,'2021-04-08 19:31:35','2021-04-08 19:31:35'),(46,4,7,'2021-04-08 19:31:35','2021-04-08 19:31:35'),(47,5,7,'2021-04-08 19:31:35','2021-04-08 19:31:35'),(48,6,7,'2021-04-08 19:31:35','2021-04-08 19:31:35'),(49,7,7,'2021-04-08 19:31:35','2021-04-08 19:31:35'),(51,1,6,'2021-04-19 15:34:50','2021-04-19 15:34:50'),(52,1,1,'2021-04-23 13:05:37','2021-04-23 13:05:37'),(58,7,1,'2021-05-05 16:54:50','2021-05-05 16:54:50'),(61,2,1,'2021-05-11 14:47:35','2021-05-11 14:47:35');
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
  `progress` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_projects_on_uuid` (`uuid`),
  KEY `index_projects_on_project_type_id` (`project_type_id`),
  CONSTRAINT `fk_rails_d7ca4cafeb` FOREIGN KEY (`project_type_id`) REFERENCES `project_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
INSERT INTO `projects` VALUES (1,'Program One','','2021-01-27 21:37:17','2021-05-20 20:41:39','43d37009-7975-40a0-94f0-79d8e8b353cd',1,1,14),(2,'Program Two With A Very Long Title','','2021-01-27 21:47:29','2021-05-11 14:47:35','615b0f32-087c-4ff8-9e20-da72454e17b1',1,1,50),(3,'Program Three','','2021-03-09 21:00:25','2021-03-09 21:00:25','b1f08e9d-452d-4cdc-ab6b-d359584008af',1,1,0),(4,'Program Four','','2021-03-09 21:01:17','2021-03-09 21:01:17','74219063-4f94-4144-98b5-66b21301cc23',1,1,0),(5,'Program Five','','2021-03-09 21:13:51','2021-03-09 21:13:51','889bc1ab-fe47-4426-b72f-7b20c1fa781b',1,1,0),(6,'Program Six','','2021-03-09 21:14:48','2021-03-09 21:14:48','bcac72fb-b0cf-4cd9-bfd8-8d54ab172e7a',1,1,0),(7,'Program Seven With A Very Long Title','','2021-03-09 21:25:01','2021-05-08 11:15:28','fc55ea56-18d8-412b-b518-c7e608256e05',1,1,19);
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `query_filters`
--

DROP TABLE IF EXISTS `query_filters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `query_filters` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `filter_key` varchar(255) DEFAULT NULL,
  `filter_value` text DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `favorite_filter_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_query_filters_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `query_filters`
--

LOCK TABLES `query_filters` WRITE;
/*!40000 ALTER TABLE `query_filters` DISABLE KEYS */;
INSERT INTO `query_filters` VALUES (27,'Flags','getAdvancedFilter','--- \'[{\"id\":\"active\",\"name\":\"Active\"}]\'\n',1,'2021-04-27 15:46:38','2021-04-27 15:46:38',1,8);
/*!40000 ALTER TABLE `query_filters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rails_settings`
--

DROP TABLE IF EXISTS `rails_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rails_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `var` varchar(255) NOT NULL,
  `value` text DEFAULT NULL,
  `target_type` varchar(255) NOT NULL,
  `target_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_rails_settings_on_target_type_and_target_id_and_var` (`target_type`,`target_id`,`var`),
  KEY `index_rails_settings_on_target_type_and_target_id` (`target_type`,`target_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rails_settings`
--

LOCK TABLES `rails_settings` WRITE;
/*!40000 ALTER TABLE `rails_settings` DISABLE KEYS */;
INSERT INTO `rails_settings` VALUES (1,'preferences','---\n:navigation_menu: sheet\n:sub_navigation_menu: overview\n:project_id: \n:project_group_id: \nnavigation_menu: map\nsub_navigation_menu: \'\'\nproject_id: \'\'\nproject_group_id: 1\nprogram_id: \'\'\n','User',1,'2021-02-12 17:50:52','2021-04-28 20:49:37'),(2,'preferences','---\n:navigation_menu: sheet\n:sub_navigation_menu: overview\n:project_id: \n:project_group_id: \n','User',6,'2021-02-17 17:37:26','2021-02-17 17:37:26');
/*!40000 ALTER TABLE `rails_settings` ENABLE KEYS */;
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
  KEY `index_related_issues_on_relatable_type` (`relatable_type`),
  KEY `index_related_issues_on_relatable_id` (`relatable_id`),
  CONSTRAINT `fk_rails_7bc934491d` FOREIGN KEY (`issue_id`) REFERENCES `issues` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `related_issues`
--

LOCK TABLES `related_issues` WRITE;
/*!40000 ALTER TABLE `related_issues` DISABLE KEYS */;
INSERT INTO `related_issues` VALUES (1,'Issue',6,3,'2021-02-16 22:50:38','2021-02-16 22:50:38'),(2,'Task',5,6,'2021-02-16 22:50:38','2021-02-16 22:50:38'),(3,'Issue',3,6,'2021-02-16 22:50:38','2021-02-16 22:50:38'),(7,'Risk',11,6,'2021-02-16 23:02:43','2021-02-16 23:02:43'),(8,'Risk',5,6,'2021-02-16 23:02:43','2021-02-16 23:02:43'),(10,'Task',17,3,'2021-03-18 14:51:07','2021-03-18 14:51:07'),(14,'Risk',22,13,'2021-03-18 15:59:42','2021-03-18 15:59:42'),(15,'Risk',22,9,'2021-03-18 15:59:42','2021-03-18 15:59:42'),(16,'Risk',22,8,'2021-03-18 15:59:42','2021-03-18 15:59:42'),(35,'Task',17,4,'2021-05-06 13:54:24','2021-05-06 13:54:24');
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
  KEY `index_related_risks_on_relatable_type` (`relatable_type`),
  KEY `index_related_risks_on_relatable_id` (`relatable_id`),
  CONSTRAINT `fk_rails_3edbf9c8c9` FOREIGN KEY (`risk_id`) REFERENCES `risks` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `related_risks`
--

LOCK TABLES `related_risks` WRITE;
/*!40000 ALTER TABLE `related_risks` DISABLE KEYS */;
INSERT INTO `related_risks` VALUES (13,'Task',17,20,'2021-03-18 14:51:07','2021-03-18 14:51:07'),(14,'Task',17,11,'2021-03-18 14:51:07','2021-03-18 14:51:07'),(16,'Task',15,20,'2021-03-18 14:51:54','2021-03-18 14:51:54'),(17,'Task',15,11,'2021-03-18 14:51:54','2021-03-18 14:51:54'),(18,'Risk',22,29,'2021-03-18 15:59:42','2021-03-18 15:59:42'),(19,'Risk',22,20,'2021-03-18 15:59:42','2021-03-18 15:59:42'),(26,'Risk',29,22,'2021-03-18 15:59:42','2021-03-18 15:59:42'),(27,'Risk',20,22,'2021-03-18 15:59:42','2021-03-18 15:59:42'),(39,'Issue',6,11,'2021-03-26 15:36:07','2021-03-26 15:36:07'),(45,'Task',21,22,'2021-05-07 16:24:02','2021-05-07 16:24:02'),(46,'Task',10,22,'2021-05-07 16:24:02','2021-05-07 16:24:02');
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
  KEY `index_related_tasks_on_relatable_type` (`relatable_type`),
  KEY `index_related_tasks_on_relatable_id` (`relatable_id`),
  CONSTRAINT `fk_rails_bba8b7f644` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `related_tasks`
--

LOCK TABLES `related_tasks` WRITE;
/*!40000 ALTER TABLE `related_tasks` DISABLE KEYS */;
INSERT INTO `related_tasks` VALUES (9,'Task',17,2,'2021-03-18 14:51:07','2021-03-18 14:51:07'),(10,'Task',17,4,'2021-03-18 14:51:07','2021-03-18 14:51:07'),(11,'Task',17,7,'2021-03-18 14:51:07','2021-03-18 14:51:07'),(12,'Task',2,17,'2021-03-18 14:51:07','2021-03-18 14:51:07'),(13,'Task',4,17,'2021-03-18 14:51:07','2021-03-18 14:51:07'),(14,'Task',7,17,'2021-03-18 14:51:07','2021-03-18 14:51:07'),(15,'Issue',3,17,'2021-03-18 14:51:07','2021-03-18 14:51:07'),(16,'Issue',4,17,'2021-03-18 14:51:07','2021-03-18 14:51:07'),(17,'Risk',20,17,'2021-03-18 14:51:07','2021-03-18 14:51:07'),(18,'Risk',11,17,'2021-03-18 14:51:07','2021-03-18 14:51:07'),(19,'Task',15,16,'2021-03-18 14:51:53','2021-03-18 14:51:53'),(20,'Task',15,18,'2021-03-18 14:51:53','2021-03-18 14:51:53'),(21,'Task',16,15,'2021-03-18 14:51:54','2021-03-18 14:51:54'),(22,'Task',18,15,'2021-03-18 14:51:54','2021-03-18 14:51:54'),(25,'Risk',26,15,'2021-03-18 14:51:54','2021-03-18 14:51:54'),(26,'Risk',20,15,'2021-03-18 14:51:54','2021-03-18 14:51:54'),(27,'Risk',11,15,'2021-03-18 14:51:54','2021-03-18 14:51:54'),(28,'Risk',22,10,'2021-03-18 15:59:42','2021-03-18 15:59:42'),(29,'Risk',22,21,'2021-03-18 15:59:42','2021-03-18 15:59:42'),(46,'Issue',8,15,'2021-05-13 20:33:53','2021-05-13 20:33:53');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `risk_stages`
--

LOCK TABLES `risk_stages` WRITE;
/*!40000 ALTER TABLE `risk_stages` DISABLE KEYS */;
INSERT INTO `risk_stages` VALUES (1,'Crawl',25,'2021-01-27 21:43:17','2021-03-30 14:43:45'),(2,'Walk',40,'2021-01-27 21:43:26','2021-03-30 14:43:56'),(3,'Run',60,'2021-01-27 21:43:36','2021-03-30 14:44:07'),(4,'Fly',100,'2021-03-29 20:28:33','2021-03-29 20:28:33');
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
  `user_type` varchar(255) DEFAULT 'responsible',
  PRIMARY KEY (`id`),
  KEY `index_risk_users_on_user_id` (`user_id`),
  KEY `index_risk_users_on_risk_id` (`risk_id`),
  KEY `index_risk_users_on_user_type` (`user_type`),
  CONSTRAINT `fk_rails_32decc8a6e` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_67aff1904f` FOREIGN KEY (`risk_id`) REFERENCES `risks` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=267 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `risk_users`
--

LOCK TABLES `risk_users` WRITE;
/*!40000 ALTER TABLE `risk_users` DISABLE KEYS */;
INSERT INTO `risk_users` VALUES (79,2,11,NULL,'responsible'),(94,1,11,NULL,'approver'),(111,3,5,NULL,'approver'),(131,1,4,NULL,'responsible'),(143,3,20,NULL,'responsible'),(172,3,21,NULL,'responsible'),(175,6,4,NULL,'approver'),(181,3,24,NULL,'responsible'),(184,2,24,NULL,'consulted'),(195,4,25,NULL,'responsible'),(196,1,25,NULL,'approver'),(197,1,21,NULL,'approver'),(198,1,20,NULL,'approver'),(199,1,24,NULL,'approver'),(203,3,29,NULL,'responsible'),(204,3,30,NULL,'responsible'),(208,4,29,NULL,'informed'),(209,5,29,NULL,'informed'),(210,1,29,NULL,'informed'),(226,2,32,NULL,'responsible'),(227,2,24,NULL,'accountable'),(229,2,3,NULL,'responsible'),(232,7,22,NULL,'accountable'),(234,7,26,NULL,'accountable'),(243,2,16,NULL,'responsible'),(244,1,16,NULL,'approver'),(245,5,22,NULL,'responsible'),(246,1,22,NULL,'approver'),(265,1,33,NULL,'approver'),(266,2,31,NULL,'responsible');
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
  `type` text DEFAULT NULL,
  `probability_description` text DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `approval_time` varchar(255) DEFAULT NULL,
  `approved` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_risks_on_user_id` (`user_id`),
  KEY `index_risks_on_facility_project_id` (`facility_project_id`),
  KEY `index_risks_on_task_type_id` (`task_type_id`),
  KEY `index_risks_on_risk_stage_id` (`risk_stage_id`),
  KEY `index_risks_on_due_date` (`due_date`),
  CONSTRAINT `fk_rails_06a747713d` FOREIGN KEY (`facility_project_id`) REFERENCES `facility_projects` (`id`),
  CONSTRAINT `fk_rails_4ca50b9b4a` FOREIGN KEY (`task_type_id`) REFERENCES `task_types` (`id`),
  CONSTRAINT `fk_rails_69bd83b255` FOREIGN KEY (`risk_stage_id`) REFERENCES `risk_stages` (`id`),
  CONSTRAINT `fk_rails_afb2ad6b53` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `risks`
--

LOCK TABLES `risks` WRITE;
/*!40000 ALTER TABLE `risks` DISABLE KEYS */;
INSERT INTO `risks` VALUES (3,'e','e','2021-01-13','2021-01-18',0,0,4,1,4,0,'e',1,'2021-02-13 20:37:26',1,1,'2021-01-27 21:57:32','2021-04-28 19:51:09',2,'RiskY BEST FRIENDS WEDDINGS',0,NULL,'4 - Likely','1 - Negligible',NULL,'nm',NULL,'Super Admin on 4/28/2021, 3:51:09 PM',1),(4,'e','e','2021-01-18','2021-03-24',0,0,4,2,8,0,'s',0,'2021-02-22 23:34:30',1,1,'2021-01-27 21:58:18','2021-03-01 22:49:17',1,'WHAT DID YOU SAYYYYY!!!',0,NULL,'4 - Likely','2 - Minor',NULL,'d',NULL,' ',NULL),(5,'s','s','2021-01-21','2021-10-21',0,0,5,5,25,1,'Description goes here. ',0,NULL,1,1,'2021-01-27 21:58:50','2021-03-03 18:23:28',2,'Risk 56',0,NULL,'5 - Almost Certain','5 - Catastrophic',NULL,'df',NULL,'2/17/2021, 12:37:15 PM',NULL),(11,'This is where the Risk description goes.','This is where we put the impact description.','2021-01-13','2021-01-31',0,60,5,4,20,0,'This is the Risk Approach description',0,NULL,1,1,'2021-01-29 17:45:53','2021-04-22 20:33:07',2,'Disgruntled Employer',0,NULL,'5 - Almost Certain','4 - Major',NULL,'jkhfhju',NULL,'Super Admin on 4/22/2021, 4:33:06 PM',NULL),(16,'d','','2020-10-22','2021-10-29',0,40,1,1,1,2,'d',0,NULL,1,1,'2021-02-16 18:02:17','2021-04-28 19:55:24',2,'Add Clear Stages Buttoned Up',1,4,'1 - Rare','1 - Negligible',NULL,'',NULL,'Super Admin on 4/28/2021, 3:55:23 PM',1),(19,'w','f','2021-02-25','2021-08-27',0,100,1,1,1,0,'f',0,NULL,1,1,'2021-02-17 17:18:46','2021-03-19 17:38:33',2,'RAP Issue',0,NULL,'1 - Rare','1 - Negligible',NULL,'r',NULL,' ',NULL),(20,'w','e','2021-02-09','2021-02-28',0,0,1,1,1,0,'e',1,'2021-02-22 15:05:53',6,1,'2021-02-17 18:13:30','2021-03-01 22:43:16',2,'TO KILL A MOC',0,NULL,'1 - Rare','1 - Negligible',NULL,'we',NULL,' ',NULL),(21,'wetf','fw','2021-02-17','2021-07-28',1,0,1,1,1,1,'wr',0,'2021-02-22 01:06:19',1,1,'2021-02-17 22:05:15','2021-03-01 22:41:00',2,'WHATDS',0,NULL,'1 - Rare','1 - Negligible',NULL,'ef',NULL,' ',NULL),(22,'This is a risk description.','d','2021-02-25','2021-07-16',0,100,4,4,16,1,'d',0,'2021-05-07 16:48:28',1,1,'2021-02-18 02:56:46','2021-05-10 17:00:21',1,'New Files Tab',0,4,'4 - Likely','4 - Major',NULL,'s',NULL,'Super Admin on 5/10/2021, 1:00:21 PM',1),(24,'g','wq','2021-02-17','2021-11-27',0,0,1,1,1,0,'w',0,'2021-02-19 21:22:31',6,1,'2021-02-18 17:20:27','2021-03-01 22:48:43',1,'thia ia AWER',0,NULL,'1 - Rare','1 - Negligible',NULL,'w',NULL,' ',NULL),(25,'d','ef','2021-02-12','2021-08-19',1,0,1,1,1,0,'eft',0,NULL,1,1,'2021-02-18 20:56:44','2021-03-01 22:50:08',1,'WOWOOWOWOW',0,NULL,'1 - Rare','1 - Negligible',NULL,'er',NULL,'',NULL),(26,'d','d','2021-02-15','2021-07-01',0,0,1,1,1,0,'d',0,NULL,1,1,'2021-02-22 23:35:43','2021-03-01 22:48:54',2,'TACO NIGHT',0,NULL,'1 - Rare','1 - Negligible',NULL,'d',NULL,'',NULL),(29,'f','df','2021-02-19','2021-05-07',1,0,1,1,1,0,'wef',0,NULL,1,1,'2021-02-22 23:37:35','2021-03-05 18:21:56',1,'POWERFUL SHOES',0,NULL,'1 - Rare','1 - Negligible',NULL,'wef',NULL,'',NULL),(30,'e','e','2021-02-15','2021-02-24',1,0,1,1,1,0,'e',0,NULL,6,1,'2021-02-23 18:54:19','2021-03-05 18:43:12',1,'This Isn\'t Working',0,NULL,'1 - Rare','1 - Negligible',NULL,'e',NULL,'',NULL),(31,'f','f','2021-03-23','2021-09-16',0,40,1,1,1,0,'f',1,'2021-05-10 20:25:30',1,1,'2021-03-08 15:59:21','2021-05-10 20:25:33',2,'New Modal Form',0,2,'1 - Rare','1 - Negligible',NULL,'f',NULL,'',NULL),(32,'B','v','2021-03-11','2021-11-26',1,0,1,1,1,0,'v',0,NULL,1,5,'2021-03-31 07:50:05','2021-04-27 00:02:09',1,'Create Risk w/Staged',0,1,'1 - Rare','1 - Negligible',NULL,'v',NULL,'',NULL),(33,'R','c','2021-04-15','2021-04-29',1,0,1,1,1,0,'n',0,NULL,1,1,'2021-04-16 16:54:20','2021-05-21 14:12:51',1,'Calendar Risk CRUD Test TO See How Long',0,NULL,'1 - Rare','1 - Negligible',NULL,'c',NULL,'',NULL),(34,'d','f','2021-04-28','2021-04-30',1,0,1,1,1,0,'f',0,NULL,1,1,'2021-04-16 16:59:46','2021-04-16 16:59:46',1,'Live Calendar CRUD test',0,NULL,'1 - Rare','1 - Negligible',NULL,'f',NULL,'',NULL),(35,'D','f','2021-04-13','2021-08-13',1,0,1,1,1,0,'d',0,NULL,1,1,'2021-04-21 22:46:18','2021-04-21 22:46:18',1,'This should Work',0,NULL,'1 - Rare','1 - Negligible',NULL,'f',NULL,'',NULL),(36,'d','dd','2021-04-06','2021-10-22',1,0,1,1,1,0,'dddd',0,NULL,1,1,'2021-04-21 22:56:16','2021-04-21 22:56:16',2,'Saves okay',0,NULL,'1 - Rare','1 - Negligible',NULL,'dd',NULL,'',NULL),(37,'d','d','2021-04-08','2021-08-19',1,0,1,1,1,0,'',0,NULL,1,1,'2021-04-21 22:57:39','2021-04-21 22:57:39',1,'Number 36',0,NULL,'1 - Rare','1 - Negligible',NULL,'d',NULL,'',NULL),(38,'d','','2021-04-06','2021-10-01',1,0,1,1,1,0,'',0,NULL,1,1,'2021-04-21 23:02:00','2021-04-21 23:02:00',1,'Number 81',0,NULL,'1 - Rare','1 - Negligible',NULL,'',NULL,'',NULL),(40,'d','','2021-04-19','2021-04-20',1,0,1,1,1,0,'',0,NULL,1,1,'2021-04-29 14:53:21','2021-04-29 14:53:21',1,'Fixing Disabled Dates',0,NULL,'1 - Rare','1 - Negligible',NULL,'',NULL,'',NULL),(41,'e','','2021-05-12','2021-05-27',0,25,1,1,1,0,'',0,NULL,1,27,'2021-05-05 14:16:41','2021-05-06 16:37:22',1,'Risk Steps',1,1,'1 - Rare','1 - Negligible',NULL,'',NULL,'',NULL),(42,'d','','2021-05-23','2021-10-15',0,25,1,1,1,0,'',0,NULL,1,27,'2021-05-05 15:22:52','2021-05-06 16:37:17',1,'Test Steps',0,1,'1 - Rare','1 - Negligible',NULL,'',NULL,'',NULL),(43,'f','','2021-05-19','2021-05-31',0,25,1,1,1,0,'',0,NULL,1,27,'2021-05-06 03:04:46','2021-05-06 16:37:28',1,'5 De Mayo',1,1,'1 - Rare','1 - Negligible',NULL,'',NULL,'',NULL);
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
INSERT INTO `schema_migrations` VALUES ('20191216191934'),('20191218035514'),('20191228080444'),('20191228105416'),('20191228110603'),('20191228112004'),('20191228112007'),('20200101130339'),('20200103122000'),('20200106131234'),('20200108090920'),('20200108131657'),('20200113133144'),('20200113133747'),('20200113134248'),('20200116100026'),('20200117020222'),('20200117101350'),('20200117133117'),('20200123020840'),('20200124135221'),('20200124175327'),('20200124175331'),('20200212101952'),('20200212114758'),('20200212114927'),('20200218092536'),('20200224133049'),('20200224143048'),('20200226083401'),('20200227094335'),('20200227094548'),('20200228102835'),('20200228103325'),('20200302115313'),('20200303035923'),('20200306141948'),('20200306142713'),('20200317134809'),('20200324123452'),('20200330121604'),('20200402074854'),('20200408152526'),('20200409064741'),('20200409072456'),('20200409082447'),('20200420151228'),('20200423123857'),('20200501042753'),('20200504185315'),('20200504195558'),('20200506041609'),('20200514064709'),('20200521144759'),('20200528085915'),('20200528085929'),('20200528085939'),('20200528085950'),('20200530100431'),('20200603080452'),('20200611091751'),('20200616081726'),('20200702121127'),('20200723134817'),('20200807100741'),('20200807100758'),('20200808070841'),('20200817092553'),('20200818085817'),('20200909095910'),('20200921072951'),('20200930081004'),('20201006210408'),('20201006212644'),('20201009064837'),('20201009065229'),('20201015082958'),('20201023114005'),('20201031015327'),('20201102162746'),('20201111142529'),('20201116143905'),('20201116143913'),('20201116145647'),('20201116160716'),('20201126075449'),('20201130074254'),('20201203215312'),('20201204141844'),('20201204150339'),('20201204151813'),('20201204151828'),('20201209154029'),('20201210141541'),('20201210141626'),('20201215142105'),('20201217175902'),('20201217182144'),('20201217202820'),('20201230130528'),('20201230163344'),('20201230221803'),('20201230221900'),('20201231031549'),('20210101112344'),('20210121191808'),('20210122022456'),('20210203050442'),('20210203212756'),('20210204214149'),('20210204220147'),('20210204220816'),('20210209180637'),('20210212162238'),('20210212162700'),('20210212202135'),('20210216140650'),('20210224182901'),('20210302181029'),('20210302181030'),('20210308155824'),('20210312214237'),('20210315132429'),('20210315132430'),('20210317174756'),('20210325162913'),('20210329191207'),('20210401200944'),('20210401201418'),('20210402145421'),('20210402150145'),('20210408173137'),('20210408173138'),('20210412174000'),('20210414201345'),('20210416170721'),('20210416173023'),('20210416194036'),('20210416194211'),('20210416195539'),('20210416203740'),('20210416210508'),('20210419213115'),('20210420204037'),('20210421055825'),('20210423201422'),('20210426164242'),('20210426164358'),('20210503185350'),('20210503185518'),('20210503185839'),('20210504174424'),('20210506001407'),('20210506005711'),('20210506005750'),('20210508095738'),('20210508100034'),('20210508100146'),('20210512220200'),('20210513213916'),('20210516103622'),('20210516105724'),('20210516113209'),('20210516211340');
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
INSERT INTO `settings` VALUES (1,NULL,NULL,'AIzaSyCAE5VIs52m1DN5Acuk9NudjSEKYmQwmi0',NULL,NULL,'2021-01-27 21:31:17','2021-01-27 21:31:17',NULL);
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
  PRIMARY KEY (`id`),
  KEY `index_sorts_on_relation` (`relation`),
  KEY `index_sorts_on_column` (`column`),
  KEY `index_sorts_on_order` (`order`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sorts`
--

LOCK TABLES `sorts` WRITE;
/*!40000 ALTER TABLE `sorts` DISABLE KEYS */;
INSERT INTO `sorts` VALUES (1,'checklists','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(2,'facilities','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(3,'facility_groups','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(4,'facility_projects','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(5,'issue_severities','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(6,'issue_types','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(7,'issue_users','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(8,'issues','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(9,'notes','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(10,'privileges','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(11,'project_types','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(12,'project_users','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(13,'projects','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(14,'region_states','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(15,'statuses','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(16,'task_types','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(17,'tasks','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(18,'users','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(19,'task_stages','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(20,'issue_stages','id','asc','2021-01-27 15:50:32','2021-01-27 15:50:32'),(21,'risk_milestones','id','asc','2021-01-27 15:50:33','2021-01-27 15:50:33');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statuses`
--

LOCK TABLES `statuses` WRITE;
/*!40000 ALTER TABLE `statuses` DISABLE KEYS */;
INSERT INTO `statuses` VALUES (1,'Not Started','2021-01-27 21:47:55','2021-01-27 21:47:55','#000000'),(2,'Recently Started','2021-01-27 21:48:14','2021-01-27 21:48:14','#781212'),(3,'Making Progress','2021-01-27 21:48:37','2021-01-27 21:48:37','#3da81f'),(4,'Concerns Identified','2021-01-27 21:49:00','2021-01-27 21:49:00','#ba1212');
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_stages`
--

LOCK TABLES `task_stages` WRITE;
/*!40000 ALTER TABLE `task_stages` DISABLE KEYS */;
INSERT INTO `task_stages` VALUES (1,'Crawl','2021-01-27 21:39:33','2021-03-29 19:50:51',28),(2,'Walk','2021-01-27 21:39:42','2021-01-27 21:39:42',0),(3,'Run','2021-01-27 21:39:52','2021-01-27 21:39:52',0),(4,'Fly','2021-01-27 21:40:00','2021-01-27 21:40:00',0),(5,'Transcend','2021-03-31 15:05:55','2021-03-31 15:05:55',92),(6,'Another Stage','2021-03-31 15:06:38','2021-03-31 15:06:38',0),(7,'Responsiveness Testing','2021-03-31 15:07:08','2021-03-31 15:07:08',0),(8,'Stage 8','2021-03-31 15:16:18','2021-05-05 14:51:58',0),(9,'Stage 9','2021-03-31 15:16:50','2021-05-05 14:52:06',0),(10,'Stage 10','2021-03-31 15:17:01','2021-05-05 14:11:58',99);
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
  `progress` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_types`
--

LOCK TABLES `task_types` WRITE;
/*!40000 ALTER TABLE `task_types` DISABLE KEYS */;
INSERT INTO `task_types` VALUES (1,'New Task Category','2021-01-27 21:39:04','2021-01-27 21:39:04',0),(2,'Another Task Category','2021-01-27 21:39:19','2021-01-27 21:39:19',0),(3,'Third Category','2021-03-16 15:19:40','2021-03-16 15:19:40',0),(4,'Fourth Category','2021-03-16 15:19:48','2021-03-16 15:19:48',0);
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
  `user_type` varchar(255) DEFAULT 'responsible',
  PRIMARY KEY (`id`),
  KEY `index_task_users_on_user_id` (`user_id`),
  KEY `index_task_users_on_task_id` (`task_id`),
  KEY `index_task_users_on_user_type` (`user_type`),
  CONSTRAINT `fk_rails_0e90c6e6ce` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`),
  CONSTRAINT `fk_rails_62298b9246` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_users`
--

LOCK TABLES `task_users` WRITE;
/*!40000 ALTER TABLE `task_users` DISABLE KEYS */;
INSERT INTO `task_users` VALUES (1,2,2,'2021-01-28 21:42:18','2021-01-28 21:42:18','responsible'),(9,5,4,'2021-02-11 17:40:41','2021-02-11 17:40:41','accountable'),(11,5,5,'2021-02-11 20:34:56','2021-02-11 20:34:56','informed'),(14,6,11,'2021-02-19 01:06:40','2021-02-19 01:06:40','responsible'),(15,5,11,'2021-02-19 01:06:40','2021-02-19 01:06:40','accountable'),(16,3,11,'2021-02-19 01:06:40','2021-02-19 01:06:40','consulted'),(17,4,11,'2021-02-19 01:06:40','2021-02-19 01:06:40','informed'),(19,5,12,'2021-02-19 01:06:47','2021-02-19 01:06:47','accountable'),(24,2,16,'2021-02-24 20:12:36','2021-02-24 20:12:36','informed'),(25,6,16,'2021-02-24 20:13:19','2021-02-24 20:13:19','consulted'),(26,1,16,'2021-02-24 20:13:19','2021-02-24 20:13:19','consulted'),(28,5,16,'2021-02-24 20:13:19','2021-02-24 20:13:19','consulted'),(29,2,16,'2021-02-24 20:13:19','2021-02-24 20:13:19','consulted'),(46,6,11,'2021-03-04 15:15:25','2021-03-04 15:15:25','informed'),(47,5,11,'2021-03-04 15:15:25','2021-03-04 15:15:25','informed'),(63,4,17,'2021-03-08 17:41:31','2021-03-08 17:41:31','accountable'),(70,5,7,'2021-03-08 19:32:47','2021-03-08 19:32:47','accountable'),(83,1,20,'2021-03-17 20:35:40','2021-03-17 20:35:40','responsible'),(90,1,25,'2021-03-17 23:16:45','2021-03-17 23:16:45','responsible'),(92,6,29,'2021-03-18 14:22:28','2021-03-18 14:22:28','responsible'),(93,2,24,'2021-03-18 14:23:17','2021-03-18 14:23:17','responsible'),(123,3,17,'2021-03-19 15:57:32','2021-03-19 15:57:32','responsible'),(125,6,28,'2021-03-19 16:02:56','2021-03-19 16:02:56','responsible'),(139,2,34,'2021-04-07 15:00:05','2021-04-07 15:00:05','responsible'),(140,2,15,'2021-04-07 15:07:19','2021-04-07 15:07:19','consulted'),(143,2,33,'2021-04-08 15:43:12','2021-04-08 15:43:12','accountable'),(144,2,19,'2021-04-08 16:44:28','2021-04-08 16:44:28','accountable'),(145,1,19,'2021-04-08 16:44:28','2021-04-08 16:44:28','responsible'),(146,1,8,'2021-04-08 16:44:40','2021-04-08 16:44:40','accountable'),(147,2,8,'2021-04-08 16:44:40','2021-04-08 16:44:40','responsible'),(148,1,10,'2021-04-08 16:44:48','2021-04-08 16:44:48','accountable'),(149,2,10,'2021-04-08 16:44:48','2021-04-08 16:44:48','responsible'),(150,2,27,'2021-04-08 16:45:25','2021-04-08 16:45:25','accountable');
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
  `calendar_start_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tasks_on_task_type_id` (`task_type_id`),
  KEY `index_tasks_on_facility_project_id` (`facility_project_id`),
  KEY `index_tasks_on_task_stage_id` (`task_stage_id`),
  KEY `index_tasks_on_due_date` (`due_date`),
  CONSTRAINT `fk_rails_99e49cf74e` FOREIGN KEY (`facility_project_id`) REFERENCES `facility_projects` (`id`),
  CONSTRAINT `fk_rails_e4591d235e` FOREIGN KEY (`task_stage_id`) REFERENCES `task_stages` (`id`),
  CONSTRAINT `fk_rails_f6eab2208f` FOREIGN KEY (`task_type_id`) REFERENCES `task_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
INSERT INTO `tasks` VALUES (1,'Task 232','','2021-05-27','2021-01-27 21:44:38','2021-04-14 17:56:16',0,1,'2020-11-09',1,0,1,'2021-02-26 21:34:05',NULL,0,NULL),(2,'THE NAME IS JUAN ','','2021-06-30','2021-01-28 21:42:18','2021-04-15 17:43:28',0,1,'2021-01-18',1,0,1,'2021-02-27 12:52:21',NULL,0,NULL),(4,'Task 5758','scdvsvfvxcxcv','2021-07-14','2021-01-29 15:58:19','2021-04-14 17:56:31',0,2,'2021-01-12',1,0,0,'2021-02-20 04:11:11',NULL,0,NULL),(5,'Calendar Task #423','d','2021-06-16','2021-01-29 16:26:57','2021-04-14 17:58:03',0,1,'2021-01-20',1,1,0,'2021-02-12 17:33:22',NULL,0,NULL),(7,'STRIPES AND STARS AND WHEAT BIER','S','2021-02-09','2021-02-05 22:49:37','2021-03-03 18:21:44',0,2,'2021-02-10',1,0,0,'2021-03-02 16:29:17',NULL,0,NULL),(8,'TT','ew','2021-02-27','2021-02-13 20:51:43','2021-04-05 18:38:34',25,2,'2021-02-17',1,0,1,'2021-02-22 15:10:04',NULL,0,NULL),(9,'Calendar Task #23','','2021-07-16','2021-02-13 20:52:44','2021-04-14 17:57:47',0,1,'2020-09-23',1,0,0,NULL,NULL,0,NULL),(10,'Sample Task 1 - Copy','ew','2021-02-27','2021-02-13 20:53:45','2021-03-01 22:24:32',0,2,'2021-02-17',1,0,0,NULL,NULL,0,NULL),(11,'ULTRA NOT OK','we','2021-07-14','2021-02-19 01:06:40','2021-03-01 22:22:24',0,2,'2021-01-12',1,1,1,'2021-02-20 03:58:57',NULL,1,NULL),(12,'Board Meeting','we','2021-07-14','2021-02-19 01:06:47','2021-05-07 16:19:24',100,2,'2021-01-12',1,0,0,'2021-05-07 16:19:24',NULL,0,NULL),(14,'Calendar Task #1','sdg','2021-05-13','2021-02-20 22:37:14','2021-04-14 17:56:47',0,1,'2021-02-25',1,1,0,NULL,NULL,0,NULL),(15,'Edit Calendar Function','ewg','2021-10-28','2021-02-22 18:55:39','2021-05-12 14:49:55',0,1,'2021-02-22',1,0,0,'2021-02-22 20:52:00',NULL,0,'2021-04-27 04:00:00'),(16,'TSK W','','2021-02-25','2021-02-22 19:40:20','2021-02-23 22:01:43',0,1,'2021-02-16',1,1,0,'2021-02-23 22:01:38',NULL,0,NULL),(17,'FINAL CHALLENGES','we the people','2021-02-27','2021-02-22 19:51:56','2021-03-19 12:36:43',0,2,'2021-02-16',1,0,0,NULL,NULL,0,NULL),(18,'Calendar Task #4232','','2021-02-26','2021-02-22 20:34:34','2021-04-14 17:58:34',0,1,'2021-02-10',1,1,0,NULL,NULL,0,NULL),(19,'NEW TASK ADDED TODAY','f','2021-02-27','2021-02-22 21:51:07','2021-03-01 22:15:27',0,1,'2021-02-17',1,1,0,NULL,NULL,0,NULL),(20,'LEMMINGS','','2021-06-25','2021-02-23 02:23:59','2021-03-01 22:26:28',0,1,'2021-02-02',1,1,0,NULL,NULL,0,NULL),(21,'CLOSEDDD','','2021-02-26','2021-02-23 03:12:12','2021-03-10 15:41:29',100,2,'2021-02-19',1,0,0,NULL,NULL,0,NULL),(22,'Calendar Task #134','f','2021-07-22','2021-02-23 18:36:40','2021-04-27 17:47:19',0,2,'2021-02-17',1,0,0,NULL,NULL,0,NULL),(24,'State Facility Bar','','2021-07-15','2021-02-23 22:06:23','2021-02-23 22:06:23',0,1,'2021-02-10',1,1,0,NULL,NULL,0,NULL),(25,'MMM','','2021-05-21','2021-03-03 18:25:38','2021-03-05 16:19:08',0,1,'2021-03-23',1,0,0,NULL,NULL,0,NULL),(26,'Task in Another Project','Sample','2021-09-23','2021-03-05 18:00:15','2021-05-07 21:40:13',0,2,'2021-03-23',5,0,0,NULL,8,0,NULL),(27,'TESTED AND WORKS','w','2021-06-25','2021-03-05 19:08:57','2021-03-08 15:57:22',0,1,'2021-03-23',1,0,0,NULL,NULL,0,NULL),(28,'FRIDAY SAVINGS ','','2021-03-23','2021-03-06 16:55:12','2021-05-07 21:34:58',0,1,'2021-03-15',1,0,0,NULL,7,0,NULL),(29,'New Task Modal Works','','2021-08-13','2021-03-08 16:00:11','2021-04-27 17:48:07',0,1,'2021-03-22',1,0,0,NULL,NULL,0,NULL),(30,'Program Two\'s First Task ','','2021-09-29','2021-03-09 22:31:34','2021-03-16 15:21:01',100,4,'2021-03-04',2,1,0,NULL,2,0,NULL),(31,'Sample Task 1','','2021-11-26','2021-03-10 16:17:44','2021-05-06 23:59:06',0,1,'2021-03-03',4,0,0,NULL,2,0,NULL),(33,'Add Stage Component','','2021-09-01','2021-03-31 14:29:30','2021-05-07 16:18:36',100,1,'2021-03-26',1,1,0,'2021-05-07 16:16:59',5,0,'2021-04-01 04:00:00'),(34,'Progress Bar','','2021-08-21','2021-03-31 19:50:10','2021-05-07 22:22:08',0,2,'2021-03-26',21,0,0,NULL,3,0,NULL),(35,'First Calendar CRUD','','2021-05-31','2021-04-15 15:04:11','2021-04-15 15:04:11',0,1,'2021-04-14',1,1,0,NULL,NULL,0,NULL),(36,'Sheet CRUD Test','','2021-09-30','2021-04-15 15:05:55','2021-04-27 17:47:50',0,1,'2021-04-27',1,1,0,NULL,NULL,0,NULL),(37,'Second Calendar CRUD Test','','2021-08-21','2021-04-15 15:07:13','2021-04-15 15:07:13',0,1,'2021-04-25',1,1,0,NULL,NULL,0,NULL),(38,'April 15th CRUD Tested','','2021-04-28','2021-04-15 17:31:41','2021-05-10 16:59:38',0,1,'2021-04-14',1,0,0,NULL,9,0,NULL),(39,'Live Calendar CRUD Test','','2021-04-28','2021-04-15 17:35:18','2021-05-06 13:47:42',0,1,'2021-04-08',1,1,0,NULL,NULL,0,NULL),(40,'Live CRUD OIL','','2022-02-16','2021-04-15 18:04:16','2021-05-08 10:33:48',92,1,'2022-02-08',1,0,0,NULL,5,0,NULL),(41,'Dogecoin','','2021-06-25','2021-04-16 14:19:06','2021-05-07 23:04:43',0,2,'2021-04-27',1,0,0,NULL,6,0,NULL),(42,'TEST STEPS','f','2021-12-17','2021-05-05 14:09:28','2021-05-08 11:15:18',28,2,'2021-05-18',27,0,0,NULL,1,1,NULL),(43,'DAY S','d','2021-10-01','2021-05-06 03:19:22','2021-05-06 03:22:47',0,2,'2021-05-21',27,0,0,NULL,NULL,0,NULL),(44,'FINAL CHALLENGES','f','2021-09-23','2021-05-06 03:23:19','2021-05-08 11:15:18',28,1,'2021-05-27',27,0,0,NULL,1,0,NULL),(45,'d','r','2021-10-13','2021-05-06 03:26:07','2021-05-06 03:44:25',92,2,'2021-05-19',27,0,0,NULL,5,0,NULL),(46,'Add Stage Component','f','2021-09-16','2021-05-06 03:28:27','2021-05-06 16:33:42',0,2,'2021-05-20',27,0,0,NULL,6,0,NULL),(47,'CREATE NEW TASKER','d','2021-08-20','2021-05-06 03:33:04','2021-05-06 03:36:47',0,1,'2021-05-20',27,0,0,NULL,NULL,0,NULL),(48,'First Task in Super Group jlkwebr,','ewr','2021-10-28','2021-05-06 03:39:59','2021-05-08 11:15:02',0,1,'2021-05-04',27,0,0,NULL,2,0,NULL),(49,'fg','g','2021-05-31','2021-05-06 03:48:45','2021-05-06 14:58:31',28,1,'2021-05-14',14,0,0,NULL,1,0,NULL),(50,'Create one Kanban','d','2021-11-26','2021-05-06 16:24:57','2021-05-08 11:15:28',0,1,'2021-05-13',27,0,0,NULL,2,1,NULL),(51,'This actually does work','f','2021-05-26','2021-05-12 14:50:43','2021-05-12 14:50:43',0,1,'2021-05-25',1,1,0,NULL,6,1,NULL),(52,'May 13th','Test','2021-08-25','2021-05-13 14:50:10','2021-05-13 15:00:05',50,1,'2021-05-21',5,1,0,NULL,6,0,NULL),(53,'May 2021 Event','','2021-05-18','2021-05-19 17:40:42','2021-05-21 14:05:08',0,1,'2021-05-11',1,0,1,'2021-05-20 20:05:56',3,0,NULL),(54,'Calendar View May Event','','2021-05-25','2021-05-20 17:52:38','2021-05-20 20:41:39',100,1,'2021-05-11',1,0,0,'2021-05-20 20:41:39',NULL,0,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin@example.com','$2a$11$2hTqv1Vjok/wUAKUntUgr.IGJoOvyMg6EAqFf76z604O56cs63Mme',NULL,NULL,NULL,241,'2021-05-21 13:43:53','2021-05-21 00:26:47','::1','::1','2021-01-27 21:31:17','2021-05-21 13:43:53','Super','Admin','Mr.','','',1,NULL,NULL,NULL,1,'','','#<Privilege:0x00007fffe29facb0>','US',NULL,NULL),(2,'team@example.com','$2a$11$TKx.EJFHbuN2ropfdADJteUy6faHQSUabGVyG64ATvOZqhEmDI/7C',NULL,NULL,NULL,1,'2021-01-27 21:49:56','2021-01-27 21:49:56','::1','::1','2021-01-27 21:36:09','2021-04-08 15:17:07','Joe','Bailey','Manager','+15085963665','58 Clarke Dr, Marlborough, MA 01752, USA',0,NULL,NULL,NULL,1,'42.3430839','-71.5169885','','US',NULL,NULL),(3,'admin1234@example.com','$2a$11$KNoayPNklKcLNkK1s/VLFut3fka0B8xI4GoBdqr5EQlmEIWDtPa52',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2021-01-28 23:04:46','2021-04-08 15:15:49','Michael ','Smith','Technician','+15085555590','3454 Galway Rd, Ballston Spa, NY 12020, USA',0,NULL,NULL,NULL,1,'43.02527','-73.919263','','US',NULL,1),(4,'verylongemailaddress@example.com','$2a$11$tl5mNSE37QcRulNyqDUvsu77eGZNCTgBa24ACy8u93mwryjNbkolW',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2021-01-28 23:06:21','2021-04-08 15:15:34','Anthony','Miles','Project Manager','+15085551234','68 Folly Mill Rd, Seabrook, NH 03874, USA',0,NULL,NULL,NULL,1,'42.8794795','-70.8762409','','US',NULL,1),(5,'jjames@example.com','$2a$11$Czi5vClAUAQAbUblb7rV.eHSTjcfsV5/SgCbETueGwT1Ch5wiGt6C',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2021-01-29 14:43:34','2021-01-29 14:43:34','Joseph','James','HR Specialiist','+15085555566','25 E Main St, New Rochelle, NY 10801, USA',0,NULL,NULL,NULL,1,'40.9200141','-73.7658504','','US',NULL,1),(6,'jnieves2020@example.com','$2a$11$6EuKT186z43XXumBOyb0M.BFcWjFZg/990lBULp6/yK3Co56MFL8m',NULL,NULL,NULL,20,'2021-05-06 21:33:54','2021-04-19 15:35:21','::1','::1','2021-01-29 14:44:23','2021-05-06 21:33:54','Jose','Nieves','IT Specialist','+16179992233','346 Turnpike Rd, Westborough, MA 01581, USA',0,NULL,NULL,NULL,1,'42.279883','-71.6591','','US',NULL,1),(7,'adddmin@example.com','$2a$11$WT5f/7wGzPKXkiJnygHG2eQVeUN7hrlQKN8EZ0VBxhmZyJ34.XfhO',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2021-04-08 19:31:06','2021-04-08 19:31:06','Adam','Bosworth','Developer','','',0,NULL,NULL,NULL,1,'','','','',NULL,NULL);
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

-- Dump completed on 2021-05-21 17:11:07
