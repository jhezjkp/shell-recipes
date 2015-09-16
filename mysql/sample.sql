CREATE DATABASE IF NOT EXISTS `db` DEFAULT CHARSET=utf8;

use `db`;

DROP TABLE IF EXISTS `student`;

CREATE TABLE `student` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `age` smallint(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

INSERT INTO `student` VALUES (1,'lily',20),(2,'小明',100);
