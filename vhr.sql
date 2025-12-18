/*
SQLyog Ultimate v12.08 (32 bit)
MySQL - 8.0.18 : Database - vhr
*********************************************************************
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

/*Table structure for table `adjustsalary` */

DROP TABLE IF EXISTS `adjustsalary`;

CREATE TABLE `adjustsalary` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `eid` char(18) DEFAULT NULL,
                                `asDate` date DEFAULT NULL COMMENT '调薪日期',
                                `beforeSalary` int(11) DEFAULT NULL COMMENT '调前薪资',
                                `afterSalary` int(11) DEFAULT NULL COMMENT '调后薪资',
                                `reason` varchar(255) DEFAULT NULL COMMENT '调薪原因',
                                `remark` varchar(255) DEFAULT NULL COMMENT '备注',
                                PRIMARY KEY (`id`),
                                KEY `pid` (`eid`),
                                CONSTRAINT `adjustsalary_ibfk_1` FOREIGN KEY (`eid`) REFERENCES `employee` (`idCard`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `adjustsalary` */

/*Table structure for table `appraise` */

DROP TABLE IF EXISTS `appraise`;

CREATE TABLE `appraise` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `eid` char(18) DEFAULT NULL,
                            `appDate` date DEFAULT NULL COMMENT '考评日期',
                            `appResult` varchar(32) DEFAULT NULL COMMENT '考评结果',
                            `appContent` varchar(255) DEFAULT NULL COMMENT '考评内容',
                            `remark` varchar(255) DEFAULT NULL COMMENT '备注',
                            PRIMARY KEY (`id`),
                            KEY `pid` (`eid`),
                            CONSTRAINT `appraise_ibfk_1` FOREIGN KEY (`eid`) REFERENCES `employee` (`idCard`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
DROP TABLE IF EXISTS `mail_send_log`;

CREATE TABLE `mail_send_log` (
                                 `msgId` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
                                 `empId` char(18) DEFAULT NULL,
                                 `status` int(11) DEFAULT '0' COMMENT '0发送中，1发送成功，2发送失败',
                                 `routeKey` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
                                 `exchange` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
                                 `count` int(11) DEFAULT NULL COMMENT '重试次数',
                                 `tryTime` date DEFAULT NULL COMMENT '第一次重试时间',
                                 `createTime` date DEFAULT NULL,
                                 `updateTime` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*Data for the table `appraise` */

/*Table structure for table `department` */

DROP TABLE IF EXISTS `department`;

CREATE TABLE `department` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `name` varchar(32) DEFAULT NULL COMMENT '部门名称',
                              `parentId` int(11) DEFAULT NULL,
                              `depPath` varchar(255) DEFAULT NULL,
                              `enabled` tinyint(1) DEFAULT '1',
                              `isParent` tinyint(1) DEFAULT '0',
                              PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8;

/*Data for the table `department` */

insert into `department` (`id`, `name`, `parentId`, `depPath`, `enabled`, `isParent`) values('1','总裁办','-1','.1','1','1');
insert into `department` (`id`, `name`, `parentId`, `depPath`, `enabled`, `isParent`) values('109','财务管理中心','1','.1.109','1','0');
insert into `department` (`id`, `name`, `parentId`, `depPath`, `enabled`, `isParent`) values('111','销售管理中心','1','.1.111','1','0');
insert into `department` (`id`, `name`, `parentId`, `depPath`, `enabled`, `isParent`) values('112','财务管理中心','1','.1.112','1','0');
insert into `department` (`id`, `name`, `parentId`, `depPath`, `enabled`, `isParent`) values('113','人力行政管理中心','1','.1.113','1','0');
insert into `department` (`id`, `name`, `parentId`, `depPath`, `enabled`, `isParent`) values('114','营销管理中心','1','.1.114','1','0');
insert into `department` (`id`, `name`, `parentId`, `depPath`, `enabled`, `isParent`) values('115','技术管理中心','1','.1.115','1','0');
/*Table structure for table `employee` */

DROP TABLE IF EXISTS `employee`;

CREATE TABLE `employee` (
                            `name` varchar(10) DEFAULT NULL COMMENT '员工姓名',
                            `gender` char(4) DEFAULT NULL COMMENT '性别',
                            `birthday` date DEFAULT NULL COMMENT '出生日期',
                            `idCard` char(18) NOT NULL COMMENT '身份证号',
                            `wedlock` enum('已婚','未婚','离异') DEFAULT NULL COMMENT '婚姻状况',
                            `nationId` int(8) DEFAULT NULL COMMENT '民族',
                            `nativePlace` varchar(100) DEFAULT NULL COMMENT '籍贯',
                            `politicId` int(8) DEFAULT NULL COMMENT '政治面貌',
                            `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
                            `phone` varchar(11) DEFAULT NULL COMMENT '电话号码',
                            `address` varchar(64) DEFAULT NULL COMMENT '联系地址',
                            `departmentId` int(11) DEFAULT NULL COMMENT '所属部门',
                            `jobLevelId` int(11) DEFAULT NULL COMMENT '职称ID',
                            `posId` int(11) DEFAULT NULL COMMENT '职位ID',
                            `engageForm` varchar(8) DEFAULT NULL COMMENT '聘用形式',
                            `tiptopDegree` enum('博士','硕士','本科','大专','高中','初中','小学','其他') DEFAULT NULL COMMENT '最高学历',
                            `specialty` varchar(32) DEFAULT NULL COMMENT '所属专业',
                            `school` varchar(32) DEFAULT NULL COMMENT '毕业院校',
                            `beginDate` date DEFAULT NULL COMMENT '入职日期',
                            `workState` enum('在职','离职') DEFAULT '在职' COMMENT '在职状态',
                            `workID` char(8) DEFAULT NULL COMMENT '工号',
                            `contractTerm` double DEFAULT NULL COMMENT '合同期限',
                            `conversionTime` date DEFAULT NULL COMMENT '转正日期',
                            `notWorkDate` date DEFAULT NULL COMMENT '离职日期',
                            `beginContract` date DEFAULT NULL COMMENT '合同起始日期',
                            `endContract` date DEFAULT NULL COMMENT '合同终止日期',
                            `workAge` int(11) DEFAULT NULL COMMENT '工龄',
                            `age` int(11) DEFAULT NULL COMMENT '年龄',
                            `idCardStartDate` date DEFAULT NULL COMMENT '身份证开始日期',
                            `idCardEndDate` date DEFAULT NULL COMMENT '身份证终止日期',
                            `hukouType` varchar(32) DEFAULT NULL COMMENT '户口类别',
                            `hukouLocation` varchar(255) DEFAULT NULL COMMENT '户口所在地',
                            `emergencyContact` varchar(32) DEFAULT NULL COMMENT '紧急联系人',
                            `emergencyContactPhone` varchar(32) DEFAULT NULL COMMENT '紧急联系电话',
                            `fertilityStatus` varchar(32) DEFAULT NULL COMMENT '生育状况',
                            `childrenInfo` varchar(255) DEFAULT NULL COMMENT '子女信息',
                            `graduationDate` date DEFAULT NULL COMMENT '毕业时间',
                            `certificate` varchar(255) DEFAULT NULL COMMENT '专业资格证书',
                            `trainingHistory` text COMMENT '培训经历',
                            `previousCompany` varchar(255) DEFAULT NULL COMMENT '原工作单位',
                            `previousPosition` varchar(255) DEFAULT NULL COMMENT '原职位',
                            `previousStartEnd` varchar(64) DEFAULT NULL COMMENT '入职/离职时间',
                            `pastPerformance` text COMMENT '过往工作业绩',
                            `previousResignationReason` varchar(255) DEFAULT NULL COMMENT '原离职原因',
                            `reference` varchar(32) DEFAULT NULL COMMENT '证明人',
                            `referencePhone` varchar(32) DEFAULT NULL COMMENT '证明人联系方式',
                            `assessmentResult` varchar(255) DEFAULT NULL COMMENT '入职前测评结果',
                            `probation` int(11) DEFAULT NULL COMMENT '试用期(月)',
                            `conversionScore` int(11) DEFAULT NULL COMMENT '转正评分',
                            `workLocation` varchar(255) DEFAULT NULL COMMENT '工作地点',
                            `rewardsPunishments` text COMMENT '奖惩记录',
                            `resignationReason` varchar(255) DEFAULT NULL COMMENT '离职原因',
                            PRIMARY KEY (`idCard`),
                            KEY `departmentId` (`departmentId`),
                            KEY `jobId` (`jobLevelId`),
                            KEY `dutyId` (`posId`),
                            KEY `nationId` (`nationId`),
                            KEY `politicId` (`politicId`),
                            KEY `workID_key` (`workID`),
                            CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`departmentId`) REFERENCES `department` (`id`),
                            CONSTRAINT `employee_ibfk_2` FOREIGN KEY (`jobLevelId`) REFERENCES `joblevel` (`id`),
                            CONSTRAINT `employee_ibfk_3` FOREIGN KEY (`posId`) REFERENCES `position` (`id`),
                            CONSTRAINT `employee_ibfk_4` FOREIGN KEY (`nationId`) REFERENCES `nation` (`id`),
                            CONSTRAINT `employee_ibfk_5` FOREIGN KEY (`politicId`) REFERENCES `politicsstatus` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `employee` */

/*insert  into `employee`(`name`,`gender`,`birthday`,`idCard`,`wedlock`,`nationId`,`nativePlace`,`politicId`,`email`,`phone`,`address`,`departmentId`,`jobLevelId`,`posId`,`engageForm`,`tiptopDegree`,`specialty`,`school`,`beginDate`,`workState`,`workID`,`contractTerm`,`conversionTime`,`notWorkDate`,`beginContract`,`endContract`,`workAge`) values ('江南一点雨','男','1990-01-01','610122199001011256','已婚',1,'陕西',13,'laowang@qq.com','18565558897','深圳市南山区',5,9,29,'劳务合同','本科','信息管理与信息系统','深圳大学','2018-01-01','在职','00000001',2,'2018-04-01',NULL,'2018-01-01','2020-01-01',NULL),('陈静','女','1989-02-01','421288198902011234','已婚',1,'海南',1,'chenjing@qq.com','18795556693','海南省海口市美兰区',91,12,29,'劳动合同','高中','市场营销','武汉大学','2015-06-09','在职','00000002',3,'2015-09-10',NULL,'2015-06-09','2018-06-08',NULL),('赵琳浩','男','1993-03-04','610122199303041456','未婚',1,'陕西',3,'zhao@qq.com','15698887795','陕西省西安市莲湖区',91,12,33,'劳动合同','博士','电子工程','哈尔滨理工大学','2018-01-01','在职','00000003',3.5,'2018-04-01',NULL,'2018-01-01','2021-07-14',NULL),('鹿存亮','男','1990-01-03','610122199001031456','已婚',1,'陕西',3,'zhao@qq.com','15612347795','陕西省西安市莲湖区',92,12,34,'劳动合同','高中','电子工程','哈尔滨理工大学','2018-01-01','在职','00000004',3.5,'2018-04-01',NULL,'2018-01-01','2021-07-14',NULL),('姚森','男','1991-02-05','610122199102058952','已婚',1,'河南',3,'yaosen@qq.com','14785559936','河南洛阳人民大道58号',92,15,34,'劳动合同','硕士','室内装修设计','西北大学','2017-01-02','在职','00000005',7,'2017-04-02',NULL,'2017-01-02','2024-01-17',NULL),('云星','女','1993-01-05','610122199301054789','已婚',1,'陕西西安',1,'yunxing@qq.com','15644442252','陕西西安新城区',92,16,34,'劳务合同','硕士','通信工程','西安电子科技学校','2018-01-01','在职','00000006',5.25,'2018-04-01',NULL,'2018-01-01','2023-04-13',NULL),('贾旭明','男','1993-11-11','610122199311111234','已婚',1,'广东广州',4,'jiaxuming@qq.com','15644441234','广东省广州市天河区冼村路',78,15,33,'劳务合同','初中','通信工程','西北大学','2018-01-01','在职','00000007',5.25,'2018-04-01',NULL,'2018-01-01','2023-04-13',NULL);*/

/*Table structure for table `employeeec` */

DROP TABLE IF EXISTS `employeeec`;

CREATE TABLE `employeeec` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `eid` char(18) DEFAULT NULL COMMENT '员工编号',
                              `ecDate` date DEFAULT NULL COMMENT '奖罚日期',
                              `ecReason` varchar(255) DEFAULT NULL COMMENT '奖罚原因',
                              `ecPoint` int(11) DEFAULT NULL COMMENT '奖罚分',
                              `ecType` int(11) DEFAULT NULL COMMENT '奖罚类别，0：奖，1：罚',
                              `remark` varchar(255) DEFAULT NULL COMMENT '备注',
                              PRIMARY KEY (`id`),
                              KEY `pid` (`eid`),
                              CONSTRAINT `employeeec_ibfk_1` FOREIGN KEY (`eid`) REFERENCES `employee` (`idCard`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `employeeec` */

/*Table structure for table `employeeremove` */

DROP TABLE IF EXISTS `employeeremove`;

CREATE TABLE `employeeremove` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `eid` char(18) DEFAULT NULL,
                                  `afterDepId` int(11) DEFAULT NULL COMMENT '调动后部门',
                                  `afterJobId` int(11) DEFAULT NULL COMMENT '调动后职位',
                                  `removeDate` date DEFAULT NULL COMMENT '调动日期',
                                  `reason` varchar(255) DEFAULT NULL COMMENT '调动原因',
                                  `remark` varchar(255) DEFAULT NULL,
                                  PRIMARY KEY (`id`),
                                  KEY `pid` (`eid`),
                                  CONSTRAINT `employeeremove_ibfk_1` FOREIGN KEY (`eid`) REFERENCES `employee` (`idCard`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `employeeremove` */

/*Table structure for table `employeetrain` */

DROP TABLE IF EXISTS `employeetrain`;

CREATE TABLE `employeetrain` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `eid` char(18) DEFAULT NULL COMMENT '员工编号',
                                 `trainDate` date DEFAULT NULL COMMENT '培训日期',
                                 `trainContent` varchar(255) DEFAULT NULL COMMENT '培训内容',
                                 `remark` varchar(255) DEFAULT NULL COMMENT '备注',
                                 PRIMARY KEY (`id`),
                                 KEY `pid` (`eid`),
                                 CONSTRAINT `employeetrain_ibfk_1` FOREIGN KEY (`eid`) REFERENCES `employee` (`idCard`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `employeetrain` */

/*Table structure for table `empsalary` */

DROP TABLE IF EXISTS `empsalary`;

CREATE TABLE `empsalary` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `eid` char(18) DEFAULT NULL,
                             `sid` int(11) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             UNIQUE KEY `eid` (`eid`),
                             KEY `empsalary_ibfk_2` (`sid`),
                             CONSTRAINT `empsalary_ibfk_1` FOREIGN KEY (`eid`) REFERENCES `employee` (`idCard`) ON DELETE CASCADE ON UPDATE CASCADE,
                             CONSTRAINT `empsalary_ibfk_2` FOREIGN KEY (`sid`) REFERENCES `salary` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;

/*Data for the table `empsalary` */

insert  into `empsalary`(`id`,`eid`,`sid`) values (6,'610122199001031456',10),(10,'610122199102058952',9),(11,'610122199301054789',13),(12,'610122199311111234',13),(22,'610122199303041456',13),(24,'421288198902011234',9),(25,'610122199001011256',13);

/*Table structure for table `hr` */

DROP TABLE IF EXISTS `hr`;

CREATE TABLE `hr` (
                      `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'hrID',
                      `name` varchar(32) DEFAULT NULL COMMENT '姓名',
                      `phone` char(11) DEFAULT NULL COMMENT '手机号码',
                      `telephone` varchar(16) DEFAULT NULL COMMENT '住宅电话',
                      `address` varchar(64) DEFAULT NULL COMMENT '联系地址',
                      `enabled` tinyint(1) DEFAULT '1',
                      `username` varchar(255) DEFAULT NULL COMMENT '用户名',
                      `password` varchar(255) DEFAULT NULL COMMENT '密码',
                      `userface` varchar(255) DEFAULT NULL,
                      `remark` varchar(255) DEFAULT NULL,
                      PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

/*Data for the table `hr` */

insert  into `hr`(`id`,`name`,`phone`,`telephone`,`address`,`enabled`,`username`,`password`,`userface`,`remark`) values (3,'系统管理员','18568887789','029-82881234','深圳南山',1,'admin','$2a$10$ySG2lkvjFHY5O0./CPIE1OI8VJsuKYEzOYzqIa7AJR6sEgSzUFOAm','http://bpic.588ku.com/element_pic/01/40/00/64573ce2edc0728.jpg',NULL),(5,'李白','18568123489','029-82123434','海口美兰',1,'libai','$2a$10$oE39aG10kB/rFu2vQeCJTu/V/v4n6DRR0f8WyXRiAYvBpmadoOBE.','https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1514093920321&di=913e88c23f382933ef430024afd9128a&imgtype=0&src=http%3A%2F%2Fp.3761.com%2Fpic%2F9771429316733.jpg',NULL),(10,'韩愈','18568123666','029-82111555','广州番禺',1,'hanyu','$2a$10$oE39aG10kB/rFu2vQeCJTu/V/v4n6DRR0f8WyXRiAYvBpmadoOBE.','https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517070040185&di=be0375e0c3db6c311b837b28c208f318&imgtype=0&src=http%3A%2F%2Fimg2.soyoung.com%2Fpost%2F20150213%2F6%2F20150213141918532.jpg',NULL),(11,'柳宗元','18568123377','029-82111333','广州天河',1,'liuzongyuan','$2a$10$oE39aG10kB/rFu2vQeCJTu/V/v4n6DRR0f8WyXRiAYvBpmadoOBE.','https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1515233756&di=0856d923a0a37a87fd26604a2c871370&imgtype=jpg&er=1&src=http%3A%2F%2Fwww.qqzhi.com%2Fuploadpic%2F2014-09-27%2F041716704.jpg',NULL),(12,'曾巩','18568128888','029-82111222','广州越秀',1,'zenggong','$2a$10$oE39aG10kB/rFu2vQeCJTu/V/v4n6DRR0f8WyXRiAYvBpmadoOBE.','https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517070040185&di=be0375e0c3db6c311b837b28c208f318&imgtype=0&src=http%3A%2F%2Fimg2.soyoung.com%2Fpost%2F20150213%2F6%2F20150213141918532.jpg',NULL);

/*Table structure for table `hr_role` */

DROP TABLE IF EXISTS `hr_role`;

CREATE TABLE `hr_role` (
                           `id` int(11) NOT NULL AUTO_INCREMENT,
                           `hrid` int(11) DEFAULT NULL,
                           `rid` int(11) DEFAULT NULL,
                           PRIMARY KEY (`id`),
                           KEY `rid` (`rid`),
                           KEY `hr_role_ibfk_1` (`hrid`),
                           CONSTRAINT `hr_role_ibfk_1` FOREIGN KEY (`hrid`) REFERENCES `hr` (`id`) ON DELETE CASCADE,
                           CONSTRAINT `hr_role_ibfk_2` FOREIGN KEY (`rid`) REFERENCES `role` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8;

/*Data for the table `hr_role` */

insert  into `hr_role`(`id`,`hrid`,`rid`) values (1,3,6),(35,12,4),(36,12,3),(37,12,2),(43,11,3),(44,11,2),(45,11,4),(46,11,5),(48,10,3),(49,10,4),(72,5,1),(73,5,2),(74,5,3);

/*Table structure for table `joblevel` */

DROP TABLE IF EXISTS `joblevel`;

CREATE TABLE `joblevel` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `name` varchar(32) DEFAULT NULL COMMENT '职称名称',
                            `titleLevel` enum('正高级','副高级','中级','初级','员级') DEFAULT NULL,
                            `createDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                            `enabled` tinyint(1) DEFAULT '1',
                            PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

/*Data for the table `joblevel` */

insert into `joblevel` (`id`, `name`, `titleLevel`, `createDate`, `enabled`) values('9','教授','正高级','2018-01-11 00:00:00','1');
insert into `joblevel` (`id`, `name`, `titleLevel`, `createDate`, `enabled`) values('10','副教授','副高级','2018-01-11 21:19:20','1');
insert into `joblevel` (`id`, `name`, `titleLevel`, `createDate`, `enabled`) values('12','助教','初级','2018-01-11 21:35:39','1');
insert into `joblevel` (`id`, `name`, `titleLevel`, `createDate`, `enabled`) values('13','讲师','中级','2018-01-11 00:00:00','0');
insert into `joblevel` (`id`, `name`, `titleLevel`, `createDate`, `enabled`) values('14','初级工程师','初级','2018-01-14 00:00:00','1');
insert into `joblevel` (`id`, `name`, `titleLevel`, `createDate`, `enabled`) values('15','中级工程师','中级','2018-01-14 00:00:00','1');
insert into `joblevel` (`id`, `name`, `titleLevel`, `createDate`, `enabled`) values('16','高级工程师','副高级','2018-01-14 16:19:14','1');
insert into `joblevel` (`id`, `name`, `titleLevel`, `createDate`, `enabled`) values('17','骨灰级工程师','正高级','2018-01-14 16:19:24','1');
insert into `joblevel` (`id`, `name`, `titleLevel`, `createDate`, `enabled`) values('18','高级讲师','副高级','2025-12-18 17:03:47','1');
/*Table structure for table `menu` */

DROP TABLE IF EXISTS `menu`;

CREATE TABLE `menu` (
                        `id` int(11) NOT NULL AUTO_INCREMENT,
                        `url` varchar(64) DEFAULT NULL,
                        `path` varchar(64) DEFAULT NULL,
                        `component` varchar(64) DEFAULT NULL,
                        `name` varchar(64) DEFAULT NULL,
                        `iconCls` varchar(64) DEFAULT NULL,
                        `keepAlive` tinyint(1) DEFAULT NULL,
                        `requireAuth` tinyint(1) DEFAULT NULL,
                        `parentId` int(11) DEFAULT NULL,
                        `enabled` tinyint(1) DEFAULT '1',
                        PRIMARY KEY (`id`),
                        KEY `parentId` (`parentId`),
                        CONSTRAINT `menu_ibfk_1` FOREIGN KEY (`parentId`) REFERENCES `menu` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;

/*Data for the table `menu` */

insert  into `menu`(`id`,`url`,`path`,`component`,`name`,`iconCls`,`keepAlive`,`requireAuth`,`parentId`,`enabled`) values (1,'/',NULL,NULL,'所有',NULL,NULL,NULL,NULL,1),(2,'/','/home','Home','员工资料','fa fa-user-circle-o',NULL,1,1,1),(3,'/','/home','Home','人事管理','fa fa-address-card-o',NULL,1,1,1),(4,'/','/home','Home','薪资管理','fa fa-money',NULL,1,1,1),(5,'/','/home','Home','统计管理','fa fa-bar-chart',NULL,1,1,1),(6,'/','/home','Home','系统管理','fa fa-windows',NULL,1,1,1),(7,'/employee/basic/**','/emp/basic','EmpBasic','基本资料',NULL,NULL,1,2,1),(8,'/employee/advanced/**','/emp/adv','EmpAdv','高级资料',NULL,NULL,1,2,1),(9,'/personnel/emp/**','/per/emp','PerEmp','员工资料',NULL,NULL,1,3,1),(10,'/personnel/ec/**','/per/ec','PerEc','员工奖惩',NULL,NULL,1,3,1),(11,'/personnel/train/**','/per/train','PerTrain','员工培训',NULL,NULL,1,3,1),(12,'/personnel/salary/**','/per/salary','PerSalary','员工调薪',NULL,NULL,1,3,1),(13,'/personnel/remove/**','/per/mv','PerMv','员工调动',NULL,NULL,1,3,1),(14,'/salary/sob/**','/sal/sob','SalSob','工资账套管理',NULL,NULL,1,4,1),(15,'/salary/sobcfg/**','/sal/sobcfg','SalSobCfg','员工账套设置',NULL,NULL,1,4,1),(16,'/salary/table/**','/sal/table','SalTable','工资表管理',NULL,NULL,1,4,1),(17,'/salary/month/**','/sal/month','SalMonth','月末处理',NULL,NULL,1,4,1),(18,'/salary/search/**','/sal/search','SalSearch','工资表查询',NULL,NULL,1,4,1),(19,'/statistics/all/**','/sta/all','StaAll','综合信息统计',NULL,NULL,1,5,1),(20,'/statistics/score/**','/sta/score','StaScore','员工积分统计',NULL,NULL,1,5,1),(21,'/statistics/personnel/**','/sta/pers','StaPers','人事信息统计',NULL,NULL,1,5,1),(22,'/statistics/recored/**','/sta/record','StaRecord','人事记录统计',NULL,NULL,1,5,1),(23,'/system/basic/**','/sys/basic','SysBasic','基础信息设置',NULL,NULL,1,6,1),(24,'/system/cfg/**','/sys/cfg','SysCfg','系统管理',NULL,NULL,1,6,1),(25,'/system/log/**','/sys/log','SysLog','操作日志管理',NULL,NULL,1,6,1),(26,'/system/hr/**','/sys/hr','SysHr','操作员管理',NULL,NULL,1,6,1),(27,'/system/data/**','/sys/data','SysData','备份恢复数据库',NULL,NULL,1,6,1),(28,'/system/init/**','/sys/init','SysInit','初始化数据库',NULL,NULL,1,6,1);

/*Table structure for table `menu_role` */

DROP TABLE IF EXISTS `menu_role`;

CREATE TABLE `menu_role` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `mid` int(11) DEFAULT NULL,
                             `rid` int(11) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             KEY `mid` (`mid`),
                             KEY `rid` (`rid`),
                             CONSTRAINT `menu_role_ibfk_1` FOREIGN KEY (`mid`) REFERENCES `menu` (`id`),
                             CONSTRAINT `menu_role_ibfk_2` FOREIGN KEY (`rid`) REFERENCES `role` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=283 DEFAULT CHARSET=utf8;

/*Data for the table `menu_role` */

insert  into `menu_role`(`id`,`mid`,`rid`) values (161,7,3),(162,7,6),(163,9,6),(164,10,6),(165,11,6),(166,12,6),(167,13,6),(168,14,6),(169,15,6),(170,16,6),(171,17,6),(172,18,6),(173,19,6),(174,20,6),(175,21,6),(176,22,6),(177,23,6),(178,25,6),(179,26,6),(180,27,6),(181,28,6),(182,24,6),(247,7,4),(248,8,4),(249,11,4),(250,7,2),(251,8,2),(252,9,2),(253,10,2),(254,12,2),(255,13,2),(256,7,1),(257,8,1),(258,9,1),(259,10,1),(260,11,1),(261,12,1),(262,13,1),(263,14,1),(264,15,1),(265,16,1),(266,17,1),(267,18,1),(268,19,1),(269,20,1),(270,21,1),(271,22,1),(272,23,1),(273,24,1),(274,25,1),(275,26,1),(276,27,1),(277,28,1),(280,7,14),(281,8,14),(282,9,14);

/*Table structure for table `msgcontent` */

DROP TABLE IF EXISTS `msgcontent`;

CREATE TABLE `msgcontent` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `title` varchar(64) DEFAULT NULL,
                              `message` varchar(255) DEFAULT NULL,
                              `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                              `idCard` char(18) DEFAULT NULL,
                              PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `msgcontent` */

insert  into `msgcontent`(`id`,`title`,`message`,`createDate`) values (14,'2222222222','11111111111111111','2018-02-02 20:46:19'),(15,'22222222','3333333333333333333333','2018-02-02 21:45:57'),(16,'通知标题1','通知内容1','2018-02-03 11:41:39'),(17,'通知标题2','通知内容2','2018-02-03 11:52:37'),(18,'通知标题3','通知内容3','2018-02-03 12:19:41');

/*Table structure for table `nation` */

DROP TABLE IF EXISTS `nation`;

CREATE TABLE `nation` (
                          `id` int(11) NOT NULL AUTO_INCREMENT,
                          `name` varchar(32) DEFAULT NULL,
                          PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;

/*Data for the table `nation` */

insert  into `nation`(`id`,`name`) values (1,'汉族'),(2,'蒙古族'),(3,'回族'),(4,'藏族'),(5,'维吾尔族'),(6,'苗族'),(7,'彝族'),(8,'壮族'),(9,'布依族'),(10,'朝鲜族'),(11,'满族'),(12,'侗族'),(13,'瑶族'),(14,'白族'),(15,'土家族'),(16,'哈尼族'),(17,'哈萨克族'),(18,'傣族'),(19,'黎族'),(20,'傈僳族'),(21,'佤族'),(22,'畲族'),(23,'高山族'),(24,'拉祜族'),(25,'水族'),(26,'东乡族'),(27,'纳西族'),(28,'景颇族'),(29,'柯尔克孜族'),(30,'土族'),(31,'达斡尔族'),(32,'仫佬族'),(33,'羌族'),(34,'布朗族'),(35,'撒拉族'),(36,'毛难族'),(37,'仡佬族'),(38,'锡伯族'),(39,'阿昌族'),(40,'普米族'),(41,'塔吉克族'),(42,'怒族'),(43,'乌孜别克族'),(44,'俄罗斯族'),(45,'鄂温克族'),(46,'崩龙族'),(47,'保安族'),(48,'裕固族'),(49,'京族'),(50,'塔塔尔族'),(51,'独龙族'),(52,'鄂伦春族'),(53,'赫哲族'),(54,'门巴族'),(55,'珞巴族'),(56,'基诺族');

/*Table structure for table `oplog` */

DROP TABLE IF EXISTS `oplog`;

CREATE TABLE `oplog` (
                         `id` int(11) NOT NULL AUTO_INCREMENT,
                         `addDate` date DEFAULT NULL COMMENT '添加日期',
                         `operate` varchar(255) DEFAULT NULL COMMENT '操作内容',
                         `hrid` int(11) DEFAULT NULL COMMENT '操作员ID',
                         PRIMARY KEY (`id`),
                         KEY `hrid` (`hrid`),
                         CONSTRAINT `oplog_ibfk_1` FOREIGN KEY (`hrid`) REFERENCES `hr` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `oplog` */

/*Table structure for table `politicsstatus` */

DROP TABLE IF EXISTS `politicsstatus`;

CREATE TABLE `politicsstatus` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `name` varchar(32) DEFAULT NULL,
                                  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

/*Data for the table `politicsstatus` */

insert into `politicsstatus` (`id`, `name`) values('1','中共党员');
insert into `politicsstatus` (`id`, `name`) values('2','中共预备党员');
insert into `politicsstatus` (`id`, `name`) values('3','共青团员');
insert into `politicsstatus` (`id`, `name`) values('4','民革党员');
insert into `politicsstatus` (`id`, `name`) values('5','民盟盟员');
insert into `politicsstatus` (`id`, `name`) values('6','民建会员');
insert into `politicsstatus` (`id`, `name`) values('7','民进会员');
insert into `politicsstatus` (`id`, `name`) values('8','农工党党员');
insert into `politicsstatus` (`id`, `name`) values('9','致公党党员');
insert into `politicsstatus` (`id`, `name`) values('10','九三学社社员');
insert into `politicsstatus` (`id`, `name`) values('11','台盟盟员');
insert into `politicsstatus` (`id`, `name`) values('12','无党派民主人士');
insert into `politicsstatus` (`id`, `name`) values('13','普通公民');
insert into `politicsstatus` (`id`, `name`) values('14','群众');

/*Table structure for table `position` */

DROP TABLE IF EXISTS `position`;

CREATE TABLE `position` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `name` varchar(32) DEFAULT NULL COMMENT '职位',
                            `createDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                            `enabled` tinyint(1) DEFAULT '1',
                            PRIMARY KEY (`id`),
                            UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

/*Data for the table `position` */

insert into `position` (`id`, `name`, `createDate`, `enabled`) values('37','董事长/总裁','2025-12-18 17:02:08','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('38','总裁助理','2025-12-18 17:02:39','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('39','外部法律顾问','2025-12-18 17:02:48','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('40','执行副总裁','2025-12-18 17:03:13','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('42','销售总监','2025-12-18 17:04:10','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('43','高级经理','2025-12-18 17:04:17','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('44','人力总监','2025-12-18 17:04:28','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('45','销售副总监','2025-12-18 17:04:45','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('46','客服总监','2025-12-18 17:04:54','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('48','招聘经理','2025-12-18 17:05:25','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('49','招聘主管','2025-12-18 17:05:32','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('50','招聘专员','2025-12-18 17:05:39','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('51','高级销售经理','2025-12-18 17:05:50','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('52','客服副总监','2025-12-18 17:06:05','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('53','高级客服经理','2025-12-18 17:06:13','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('54','客服主管','2025-12-18 17:06:22','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('55','高级客服专员','2025-12-18 17:06:28','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('56','客服专员','2025-12-18 17:06:34','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('58','财务总监','2025-12-18 17:06:51','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('59','投融资总监','2025-12-18 17:07:00','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('60','会计核算经理','2025-12-18 17:25:09','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('61','出纳主管','2025-12-18 17:25:19','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('62','会计','2025-12-18 17:25:26','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('63','出纳','2025-12-18 17:25:35','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('64','投融资助理','2025-12-18 17:26:22','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('65','人力行政总监','2025-12-18 17:26:40','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('66','人力行政经理','2025-12-18 17:26:54','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('67','人力专员','2025-12-18 17:26:59','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('68','人力行政专员','2025-12-18 17:27:05','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('69','行政专员','2025-12-18 17:27:18','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('70','营销总监','2025-12-18 17:27:41','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('71','新媒体运营师','2025-12-18 17:27:48','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('72','技术副总监','2025-12-18 17:27:55','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('73','运维工程师','2025-12-18 17:28:25','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('74','Java工程师','2025-12-18 17:28:30','1');

/*Table structure for table `role` */

DROP TABLE IF EXISTS `role`;

CREATE TABLE `role` (
                        `id` int(11) NOT NULL AUTO_INCREMENT,
                        `name` varchar(64) DEFAULT NULL,
                        `nameZh` varchar(64) DEFAULT NULL COMMENT '角色名称',
                        PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

/*Data for the table `role` */

insert  into `role`(`id`,`name`,`nameZh`) values (1,'ROLE_manager','部门经理'),(2,'ROLE_personnel','人事专员'),(3,'ROLE_recruiter','招聘主管'),(4,'ROLE_train','培训主管'),(5,'ROLE_performance','薪酬绩效主管'),(6,'ROLE_admin','系统管理员'),(13,'ROLE_test2','测试角色2'),(14,'ROLE_test1','测试角色1'),(17,'ROLE_test3','测试角色3'),(18,'ROLE_test4','测试角色4'),(19,'ROLE_test4','测试角色4'),(20,'ROLE_test5','测试角色5'),(21,'ROLE_test6','测试角色6');

/*Table structure for table `salary` */

DROP TABLE IF EXISTS `salary`;

CREATE TABLE `salary` (
                          `id` int(11) NOT NULL AUTO_INCREMENT,
                          `basicSalary` int(11) DEFAULT NULL COMMENT '基本工资',
                          `bonus` int(11) DEFAULT NULL COMMENT '奖金',
                          `lunchSalary` int(11) DEFAULT NULL COMMENT '午餐补助',
                          `trafficSalary` int(11) DEFAULT NULL COMMENT '交通补助',
                          `allSalary` int(11) DEFAULT NULL COMMENT '应发工资',
                          `pensionBase` int(11) DEFAULT NULL COMMENT '养老金基数',
                          `pensionPer` float DEFAULT NULL COMMENT '养老金比率',
                          `createDate` timestamp NULL DEFAULT NULL COMMENT '启用时间',
                          `medicalBase` int(11) DEFAULT NULL COMMENT '医疗基数',
                          `medicalPer` float DEFAULT NULL COMMENT '医疗保险比率',
                          `accumulationFundBase` int(11) DEFAULT NULL COMMENT '公积金基数',
                          `accumulationFundPer` float DEFAULT NULL COMMENT '公积金比率',
                          `name` varchar(32) DEFAULT NULL,
                          PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

/*Data for the table `salary` */

insert  into `salary`(`id`,`basicSalary`,`bonus`,`lunchSalary`,`trafficSalary`,`allSalary`,`pensionBase`,`pensionPer`,`createDate`,`medicalBase`,`medicalPer`,`accumulationFundBase`,`accumulationFundPer`,`name`) values (9,9000,4000,800,500,NULL,2000,0.07,'2018-01-24 00:00:00',2000,0.07,2000,0.07,'市场部工资账套'),(10,2000,2000,400,1000,NULL,2000,0.07,'2018-01-01 00:00:00',2000,0.07,2000,0.07,'人事部工资账套'),(13,20000,3000,500,500,NULL,4000,0.07,'2018-01-25 00:00:00',4000,0.07,4000,0.07,'运维部工资账套');

/*Table structure for table `sysmsg` */

DROP TABLE IF EXISTS `sysmsg`;

CREATE TABLE `sysmsg` (
                          `id` int(11) NOT NULL AUTO_INCREMENT,
                          `mid` int(11) DEFAULT NULL COMMENT '消息id',
                          `type` int(11) DEFAULT '0' COMMENT '0表示群发消息',
                          `hrid` int(11) DEFAULT NULL COMMENT '这条消息是给谁的',
                          `state` int(11) DEFAULT '0' COMMENT '0 未读 1 已读',
                          PRIMARY KEY (`id`),
                          KEY `hrid` (`hrid`),
                          KEY `sysmsg_ibfk_1` (`mid`),
                          CONSTRAINT `sysmsg_ibfk_1` FOREIGN KEY (`mid`) REFERENCES `msgcontent` (`id`),
                          CONSTRAINT `sysmsg_ibfk_2` FOREIGN KEY (`hrid`) REFERENCES `hr` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8;

/*Data for the table `sysmsg` */

insert  into `sysmsg`(`id`,`mid`,`type`,`hrid`,`state`) values (57,14,0,3,1),(58,14,0,5,1),(59,14,0,10,1),(60,14,0,11,0),(61,14,0,12,0),(62,15,0,3,1),(63,15,0,5,1),(64,15,0,10,1),(65,15,0,11,0),(66,15,0,12,0),(67,16,0,3,1),(68,16,0,5,1),(69,16,0,10,1),(70,16,0,11,0),(71,16,0,12,0),(72,17,0,3,1),(73,17,0,5,1),(74,17,0,10,1),(75,17,0,11,0),(76,17,0,12,0),(77,18,0,3,1),(78,18,0,5,0),(79,18,0,10,0),(80,18,0,11,0),(81,18,0,12,0);

/* Procedure structure for procedure `addDep` */

/*!50003 DROP PROCEDURE IF EXISTS  `addDep` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `addDep`(in depName varchar(32) character set utf8,in parentId int,in enabled boolean,out result int,out result2 int)
begin
    declare did int;
    declare pDepPath varchar(64);
    insert into department set name=depName,parentId=parentId,enabled=enabled;
    select row_count() into result;
    select last_insert_id() into did;
    set result2=did;
    select depPath into pDepPath from department where id=parentId;
    update department set depPath=concat(pDepPath,'.',did) where id=did;
    update department set isParent=true where id=parentId;
end */$$
DELIMITER ;

/* Procedure structure for procedure `deleteDep` */

/*!50003 DROP PROCEDURE IF EXISTS  `deleteDep` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteDep`(in did int,out result int)
begin
    declare ecount int;
    declare pid int;
    declare pcount int;
    declare a int;
    select count(*) into a from department where id=did and isParent=false;
    if a=0 then set result=-2;
    else
        select count(*) into ecount from employee where departmentId=did;
        if ecount>0 then set result=-1;
        else
            select parentId into pid from department where id=did;
            delete from department where id=did and isParent=false;
            select row_count() into result;
            select count(*) into pcount from department where parentId=pid;
            if pcount=0 then update department set isParent=false where id=pid;
            end if;
        end if;
    end if;
end */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
