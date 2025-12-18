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
/*
SQLyog Community v13.1.7 (64 bit)
MySQL - 5.7.44-log
*********************************************************************
*/
/*!40101 SET NAMES utf8 */;

insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('郝茗','女',NULL,'110102198902250026','未婚','1','北京市西城区西便门外大街西里新10楼5门102号','14','jeney9051@hotmail.com',NULL,'北京市朝阳区','1','19','37','劳动合同','硕士','国际财务管理','英国SURREY大学','2017-12-18','在职','00000025',NULL,NULL,NULL,NULL,NULL,NULL,'36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('刘梦曦','女',NULL,'110103198804261828','离异','1','北京市朝阳区黄厂南里1号院10号楼1单元2001号','14','cheesemolly@163.com',NULL,'北京市朝阳区富力又一城A2-1-2001','1','19','37','劳动合同','本科','音乐编辑','中国传媒大学南广学院','2021-09-22','在职','00000007',NULL,NULL,NULL,NULL,NULL,NULL,'37',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('窦晓晔','女',NULL,'110105198206249469','离异','1','北京市朝阳区西坝河东里83楼1103号','14','douqian@sina.com',NULL,'北京市朝阳区西坝河东里83楼1103号','1','19','37','劳动合同','大专','会计学','北京工业大学','2020-07-06','在职','00000028',NULL,NULL,NULL,NULL,NULL,NULL,'43',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('倪润鑫','男',NULL,'110105198703303112','未婚','1','北京市朝阳区小红门乡小红门273号','14','n13031015775@163.com',NULL,'北京市朝阳区小红门乡小红门273号','1','19','37','劳动合同','本科','工商管理','北京工业大学','2022-12-02','在职','00000054',NULL,NULL,NULL,NULL,NULL,NULL,'38',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('杨爽','女',NULL,'110105199006115348','已婚','1','北京市朝阳区武圣东里49楼1104号','14','434412553@qq.com',NULL,'北京市朝阳区石佛营东里118楼1201','1','19','37','劳动合同','本科','食品科学与工程','北京农学院','2025-08-06','在职','00000033',NULL,NULL,NULL,NULL,NULL,NULL,'35',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('肖韦','男',NULL,'110111198305131834','已婚','1','北京市房山区良乡镇鸿顺园小区10号楼6单元101号','14','XW13901379447@163.com',NULL,'北京市通州区华业东方玫瑰','1','19','37','劳动合同','大专','金融','中央广播电视大学','2020-09-14','在职','00000031',NULL,NULL,NULL,NULL,NULL,NULL,'42',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('李旺','男',NULL,'110223199009275679','已婚','1','北京市通州区潞城镇大东各庄村7号','14',NULL,NULL,'北京市通州区潞城镇大东各庄村7号','1','19','37','劳动合同','大专','公路运输与管理','北京交通大学','2024-04-01','在职','00000050',NULL,NULL,NULL,NULL,NULL,NULL,'35',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('李然','女',NULL,'110226199709081129','未婚','1','北京市平谷区东高村镇赵家务大街南98号','3',NULL,NULL,'北京市平谷区东高村镇赵家务大街南98号','1','19','37','劳动合同','大专','人力资源管理','北京劳动保障职业学校','2019-11-25','在职','00000032',NULL,NULL,NULL,NULL,NULL,NULL,'28',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('褚建新','女',NULL,'110227198312146424','已婚','1','北京市怀柔区慕田峪办事处慕田峪村47号','14',NULL,'13810294752','北京市朝阳区常营民族家园69号101','1','19','37','劳动合同','本科','社会工作','北方工业大学','2012-12-10','在职','00000029',NULL,NULL,NULL,NULL,NULL,NULL,'42',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('张辉','女',NULL,'110227198607211529','未婚','1','北京市怀柔区庙城镇高两河村392号1门','14','106023676@qq.com',NULL,'北京市怀柔区庙城镇高两河村392号1门','1','19','37','劳动合同','本科','劳动与社会保障','北京物资学院','2024-05-13','在职','00000030',NULL,NULL,NULL,NULL,NULL,NULL,'39',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('李青虹','女',NULL,'120101197901202082','已婚','1','天津市河东区晨光道晨光楼16号楼401','14','amy.li@renshiren.com',NULL,NULL,'1','19','37','劳动合同','大专','工商管理专业','天津财经大学','2011-06-01','在职','00000027',NULL,NULL,NULL,NULL,NULL,NULL,'46',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('高辉','男',NULL,'120101198110251536','已婚','1','天津市南开区万德庄大街龙德里1号楼3门503号','14','tony.gao@renshiren.com',NULL,NULL,'1','19','37','劳动合同','本科','工商管理','英国赫特福德大学','2008-10-16','在职','00000001',NULL,NULL,NULL,NULL,NULL,NULL,'44',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('王雅晶','女',NULL,'120102198512020665','未婚','1','天津市河东区卫国道2号内13栋506号','14','gesanghua85@163.com',NULL,'北京市朝阳区苹果社区','1','19','37','劳动合同','硕士','Awuntsry Finance','Bentley University','2023-04-03','在职','00000010',NULL,NULL,NULL,NULL,NULL,NULL,'40',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('安毅','男',NULL,'120102199307052611','未婚','1','天津市河东区大直沽中路9号内1号楼5门202号','14',NULL,NULL,'天津市河西区景兴里','1','19','37','劳动合同','本科','德语系','天津外国语学院','2024-03-19','在职','00000003',NULL,NULL,NULL,NULL,NULL,NULL,'32',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('石鑫','女',NULL,'120103199101124524','已婚','1','天津市河西区尖山路光明里26门301号','14','847457161@qq.com',NULL,'天津市津南区林城佳苑','1','19','37','劳动合同','大专','人力资源管理','天津中德职业技术学院','2024-06-03','在职','00000017',NULL,NULL,NULL,NULL,NULL,NULL,'34',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('罗卓佳','女',NULL,'120103199302182624','未婚','1','天津市河西区紫金山西路宾水东里45门409号','14','zhuojia.luo@renshiren.com',NULL,NULL,'1','19','37','劳动合同','本科','英语（国际商务）','天津外国语大学滨海外事学院','2021-10-25','在职','00000037',NULL,NULL,NULL,NULL,NULL,NULL,'32',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('田净','女',NULL,'120104197902283880','已婚','1','天津市南开区西湖道西湖里10-2-101','14','vivien.tian@renshiren.com',NULL,NULL,'1','19','37','劳动合同','本科','人力资源','天津大学','2014-02-01','在职','00000036',NULL,NULL,NULL,NULL,NULL,NULL,'46',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('徐菲菲','女',NULL,'120104198703033242','未婚','1','天津市西青区东姜井德雅佳园4-102','14','xuff@renshiren.com',NULL,NULL,'1','19','37','劳动合同','本科','英语','天津市外国语滨海外事学院 ','2016-12-01','在职','00000015',NULL,NULL,NULL,NULL,NULL,NULL,'38',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('王帅','女',NULL,'12010419890304152X','未婚','1','天津市南开区广开四马路瑞德里','14','bella.wang@renshiren.com',NULL,NULL,'1','19','37','劳动合同','大专','计算机多媒体','天津职业大学','2017-08-29','在职','00000034',NULL,NULL,NULL,NULL,NULL,NULL,'36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('武培培','女',NULL,'120106198211126525','已婚','1','天津市河西区宾水道育贤里21-58-204','14','yuki.wu@renshiren.com',NULL,NULL,'1','19','37','劳动合同','本科','人力资源','南开大学','2010-11-01','在职','00000035',NULL,NULL,NULL,NULL,NULL,NULL,'43',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('迟姝雯','女',NULL,'120109198705071527','已婚','1','天津市南开区三元村大街雅环里1号楼1门102号','14','568420460@qq.com',NULL,'天津市南开区三元村大街雅环里1号楼1门102号','1','19','37','劳动合同','本科','法律','天津南开大学','2024-08-01','在职','00000039',NULL,NULL,NULL,NULL,NULL,NULL,'38',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('王虹','女',NULL,'120113198902170027','未婚','1','天津市北辰区果园新村街东升里7号楼4门308号','14','460481497@qq.com',NULL,NULL,'1','19','37','劳动合同','大专','电子商务','天津城市职业学院','2022-07-25','在职','00000038',NULL,NULL,NULL,NULL,NULL,NULL,'36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('周喆林','男',NULL,'120222199602064616','已婚','1','北京市丰台区蒲黄榆一里6楼北门6号','14','961589324@qq.com',NULL,'北京市丰台区蒲黄榆一里6楼北门6号','1','19','37','劳动合同','本科','工商管理','北京科技大学','2024-03-12','在职','00000055',NULL,NULL,NULL,NULL,NULL,NULL,'29',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('李联欢','女',NULL,'130102198112020641','离异','1','河北省石家庄市槐底派出所','14','805680374@qq.com',NULL,NULL,'1','19','37','劳动合同','本科','会计学','河北经贸大学','2017-11-01','在职','00000005',NULL,NULL,NULL,NULL,NULL,NULL,'44',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('徐丹','女',NULL,'130102198203072121','已婚','1','河北省石家庄市新华区中华北大街186号中华绿园18栋1单元101号','14','444206452@qq.com',NULL,'河北省石家庄市新华区中华北大街186号中华绿园15-6-201','1','19','37','劳动合同','大专','应用英语','北京语言大学','2022-04-01','在职','00000045',NULL,NULL,NULL,NULL,NULL,NULL,'43',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('蔡朝','女',NULL,'130102198706091228','已婚','1','河北省石家庄市长安区广安大街29号51栋平房5号','14','994563286@qq.com',NULL,NULL,'1','19','37','劳动合同','本科','人力资源管理','河北地质大学','2019-05-15','在职','00000042',NULL,NULL,NULL,NULL,NULL,NULL,'38',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('张惠','女',NULL,'130103198312211828','已婚','1','石家庄市桥东区平安南大街105号29栋1单元402号','14','1252256971@qq.com',NULL,NULL,'1','19','37','劳动合同','本科','英语','河北经贸大学','2019-08-13','在职','00000018',NULL,NULL,NULL,NULL,NULL,NULL,'41',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('宋朋涛','男',NULL,'130104198608231832','未婚','1','广东省珠海市斗门区井岸镇新堂路6号2栋4单元201房（珠海市恒涛物业管理有限公司）（集体户口）','14','18633099123@163.com',NULL,'石家庄市长安区谈固东街紫鑫苑4-2-1201','1','19','37','劳动合同','大专','计算机网络技术','江西先锋软件职业技术学院','2020-04-01','在职','00000059',NULL,NULL,NULL,NULL,NULL,NULL,'39',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('任育旻','女',NULL,'130126199210100026','未婚','1','河北省石家庄市灵寿县城关派出所灵寿镇南合村正中街西3排2号','14','852730990@qq.com',NULL,'石家庄市长安区光华生活小区1-1-603','1','19','37','劳动合同','大专','物流管理','邯郸职业技术学院','2022-03-03','在职','00000044',NULL,NULL,NULL,NULL,NULL,NULL,'33',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('刘伟娜','女',NULL,'130130198310271527','已婚','1','河北省石家庄市裕华区湘江道150号7栋2单元501号','3','237833796@qq.com',NULL,NULL,'1','19','37','劳动合同','大专','工商企业管理','河北科技大学','2019-07-08','在职','00000004',NULL,NULL,NULL,NULL,NULL,NULL,'42',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('肖倩倩','女',NULL,'13013119861217004X','已婚','1','河北省石家庄市新华区北合街48号9栋2单元303号','14','41353724@qq.com',NULL,'石家庄市新华区十三所东区1-1-104','1','19','37','劳动合同','大专','物流管理','河北师范大学公共管理学院','2023-08-24','在职','00000052',NULL,NULL,NULL,NULL,NULL,NULL,'38',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('徐世佳','女',NULL,'130132200108101623','未婚','1','河北省石家庄市元氏县南因派出所南因镇褚固村光明路107号','14','3468769958@qq.com',NULL,'河北省石家庄市裕华区塔南路与谈固南大街交叉口位同新村南区2号楼4单元601','1','19','37','劳动合同','大专','经济管理学院-电子商务','石家庄财经职业学院','2024-04-07','在职','00000053',NULL,NULL,NULL,NULL,NULL,NULL,'24',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('刘小南','女',NULL,'130281199008113720','已婚','1','河北省遵化适当玉珍上马家峪村西寺沟14排4号','14','993928287@qq.com',NULL,'河北省廊坊市香河县安平镇共青社小区8号楼2单元302','1','19','37','劳动合同','大专','药物制剂技术','河北化工医药职业技术学院','2019-02-25','在职','00000011',NULL,NULL,NULL,NULL,NULL,NULL,'35',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('张雨薇','女',NULL,'13040319951224182X','未婚','1','河北省石家庄市长安区翟营南大街9号1栋1单元913号','14','569154098@qq.com',NULL,'石家庄市长安区翟营大街9号中铁大厦B座9A8','1','19','37','劳动合同','本科','公共事业管理','北京中医药大学东方学院','2022-11-15','在职','00000046',NULL,NULL,NULL,NULL,NULL,NULL,'29',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('王龙天','男',NULL,'130424200211231836','未婚','1','河北省邯郸市成安县道东堡镇大姚堡村2组54号','14','1481412174@qq.com',NULL,'北京市通州区张家湾镇太玉园西区1号楼1单元502室','1','19','37','劳动合同','大专','计算机应用','河北省成安县综合职业技术学校','2024-04-01','在职','00000060',NULL,NULL,NULL,NULL,NULL,NULL,'23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('杨伟','男',NULL,'130531198409180033','未婚','1','河北省邢台市广宗县广宗镇兴广路67号','14',NULL,NULL,'北京市安居路6号院3号楼3单元1101','1','19','37','劳动合同','大专','科学教育','邢台学院','2025-02-24','在职','00000056',NULL,NULL,NULL,NULL,NULL,NULL,'41',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('耿伟娜','女',NULL,'130627199201160645','已婚','1','河北省保定市唐县王京所王京镇拔茄村','14','326144684@qq.com',NULL,'石家庄市珠峰国际花园27-2-3101','1','19','37','劳动合同','大专','财政专业','石家庄信息工程职业学院','2021-09-02','在职','00000043',NULL,NULL,NULL,NULL,NULL,NULL,'33',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('许颖','女',NULL,'130635198511264429','已婚','1','河北省石家庄市裕华区塔南路169号','14','625156473@qq.com',NULL,'石家庄长安区紫晶悦城17-1-1-2603','1','19','37','劳动合同','本科','人力资源管理','河北师范大学汇华学院','2019-11-21','在职','00000041',NULL,NULL,NULL,NULL,NULL,NULL,'40',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('刘红莲','女',NULL,'130682198107050343','已婚','1','石家庄市长安区','14','1207064178@qq.com',NULL,NULL,'1','19','37','劳动合同','本科','汉语言文学','河北大学','2019-03-01','在职','00000009',NULL,NULL,NULL,NULL,NULL,NULL,'44',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('薛珍妮','女',NULL,'130725199611080827','未婚','1','河北省张家口市尚义县大青沟镇魏家村自然村228号','14',NULL,NULL,'朝阳区十八里店南桥前祁庄151号公寓312','1','19','37','劳动合同','大专','会展策划与管理','邯郸职业技术学院','2025-02-24','在职','00000051',NULL,NULL,NULL,NULL,NULL,NULL,'29',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('刘艳','女',NULL,'130729200003101920','未婚','1','河北省张家口市万全区北新屯乡刘虎庄村小南坪1巷7号','14','1486310982@qq.com',NULL,'北京市通州区次渠北小区乐乎公寓4号楼A6单元309','1','19','37','劳动合同','本科','财务管理','河北金融学院','2025-04-25','在职','00000012',NULL,NULL,NULL,NULL,NULL,NULL,'25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('付海岩','女',NULL,'130824199002260047','已婚','1','河北省石家庄市裕华区','14','479822268@qq.com',NULL,NULL,'1','19','37','劳动合同','本科','信息管理与信息系统','石家庄铁道大学四方学院','2017-10-16','在职','00000040',NULL,NULL,NULL,NULL,NULL,NULL,'35',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('王丽娜','女',NULL,'130826199001011244','已婚','1','河北省承德市丰宁满族自治县大滩镇大下营村2组48号','14','374801707@qq.com',NULL,'北京市丰台区万丰路305亿潼隆之家','1','19','37','劳动合同','大专','绿色食品工程','中国环境管理干部学院','2019-04-22','在职','00000006',NULL,NULL,NULL,NULL,NULL,NULL,'35',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('段沣涵','男',NULL,'130923200009303411','未婚','1','北京市海淀区田村路40号院平房6栋9号','3','1023673524@qq.com',NULL,'北京市房山区良乡伟业嘉园西里23号楼','1','19','37','劳动合同','本科','会计学','中央财经大学','2024-10-28','在职','00000014',NULL,NULL,NULL,NULL,NULL,NULL,'25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('王冬辰','女',NULL,'131082199209291028','未婚','1','河北省三河市皇庄镇一村46号','14','502162497@qq.com',NULL,'河北省廊坊市燕郊开发区福成六期','1','19','37','劳动合同','大专','人力资源管理','河北民族师范学院','2024-12-16','在职','00000057',NULL,NULL,NULL,NULL,NULL,NULL,'33',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('王旭','女',NULL,'131128200101261241','未婚','1','河北省衡水市阜城县古城镇王台庄村17号','14','2939088937@qq.com',NULL,'天津市河西区下瓦房街道福至里小区4甲806','1','19','37','劳动合同','大专','审计','秦皇岛职业技术学院','2023-05-22','在职','00000016',NULL,NULL,NULL,NULL,NULL,NULL,'24',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('祝梦瑶','女',NULL,'131182199701271227','未婚','1','河北省深州市北溪村乡东留曹村20号','14',NULL,NULL,'北京市朝阳区八里庄街道甘露家园','1','19','37','劳动合同','本科','人力资源管理','西安石油大学','2021-11-22','在职','00000026',NULL,NULL,NULL,NULL,NULL,NULL,'28',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('郭志强','男',NULL,'140212199311293938','未婚','1','山西省大同市新荣区花园屯乡前井村238号2户','3','gzq-spiyit52@126.com',NULL,'河北省廊坊市三河市燕郊镇雷捷时代广场二期5-1-2903','1','19','37','劳动合同','本科','计算机科学与技术','运城学院','2016-09-09','在职','00000021',NULL,NULL,NULL,NULL,NULL,NULL,'32',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('白靖','女',NULL,'140928200101010025','未婚','1','山西省五寨县前所乡南坪村南巷17号','14','2801356718@qq.com',NULL,'北京市朝阳区和平里街道胜古南里25号楼','1','19','37','劳动合同','大专','行政管理','国家开放大学','2025-07-30','在职','00000008',NULL,NULL,NULL,NULL,NULL,NULL,'24',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('魏志浩','男',NULL,'142733199801223917','未婚','1','山西省垣曲县英言乡席家坪村沙河组051号','14','1350658766@qq.com',NULL,'北京市通州北关三元村9号楼602','1','19','37','劳动合同','本科','计算机科学与技术','山西应用科技学院','2020-12-02','在职','00000022',NULL,NULL,NULL,NULL,NULL,NULL,'27',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('陈猛','男',NULL,'210921199808205211','未婚','1','辽宁省阜新蒙古族自治县苍土乡下洼子村满有营子123号','14',NULL,NULL,'河北省石家庄市长安区金谈固月坛园14号楼3单元203','1','19','37','劳动合同','大专','计算机应用','辽宁林业职业技术学院','2025-02-24','在职','00000061',NULL,NULL,NULL,NULL,NULL,NULL,'27',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('刘伟','男',NULL,'231026198212242735','已婚','1','吉林省四平市铁东区解放街光辉委六组','14','liuwei2000285@163.com',NULL,'北京市通州区葛布店南里99号','1','19','37','劳动合同','本科','财务管理','哈尔滨学院','2018-12-10','在职','00000002',NULL,NULL,NULL,NULL,NULL,NULL,'42',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('陈力','男',NULL,'310108198804033314','未婚','1','上海市宝山区新二路999弄38号102室','14','li.chen@renshiren.com',NULL,'上海市宝山区新二路999弄38号102室','1','19','37','劳动合同','大专','工商管理','江南大学','2019-12-30','在职','00000063',NULL,NULL,NULL,NULL,NULL,NULL,'37',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('王贝聿','男',NULL,'310108199211142632','已婚','1','上海市浦东新区巨峰路176弄18号601室','14','401990065@qq.com',NULL,'上海市浦东新区巨峰路176弄18号601室','1','19','37','劳动合同','大专','市政工程','上海城市管理学院','2025-06-16','在职','00000064',NULL,NULL,NULL,NULL,NULL,NULL,'33',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('陈其毓','男',NULL,'310115198802200418','已婚','1','上海市浦东新区张江镇川北公路3078号403室','14','1012294956@qq.com',NULL,'上海市张杨路2999弄21号302','1','19','37','劳动合同','本科','工商管理','英国桑德兰大学','2019-12-23','在职','00000048',NULL,NULL,NULL,NULL,NULL,NULL,'37',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('郁磊','男',NULL,'310230199412112731','已婚','1','上海市崇明区建设镇大同村蟠龙1511','14','527506897@qq.com',NULL,'上海市崇明区建设镇大同村蟠龙1511','1','19','37','劳动合同','大专','工商企业管理','上海开放大学','2020-06-23','在职','00000062',NULL,NULL,NULL,NULL,NULL,NULL,'31',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('冯淑娟','女',NULL,'330781198412260044','已婚','1','浙江省宁波市鄞州区下应街道万科桂语里20幢1302室','14','164560543@qq.com',NULL,'浙江省宁波市鄞州区下应街道万科桂语里20幢1302室','1','19','37','劳动合同','本科','会计学','绍兴文理学院','2020-03-12','在职','00000020',NULL,NULL,NULL,NULL,NULL,NULL,'40',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('刘晓红','女',NULL,'370785198309249325','已婚','1','山东省潍坊市高密市密水街道姜家屯村77号','14','824823@163.com',NULL,'燕郊神威北路美林湾小区','1','19','37','劳动合同','大专','经贸韩语','青岛滨海学院','2018-08-03','在职','00000049',NULL,NULL,NULL,NULL,NULL,NULL,'42',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('程新玲','女',NULL,'410802198906300069','已婚','1','河南省焦作市解放区卫校西街2号院','14','xinling.cheng@renshiren.com',NULL,NULL,'1','19','37','劳动合同','本科','会计学','黄淮学院','2019-05-21','在职','00000019',NULL,NULL,NULL,NULL,NULL,NULL,'36',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('董文文','女',NULL,'412727199508278423','已婚','1','河南省淮阳县城关回族镇团结行政村孙庄三组020号','14','614004343@qq.com',NULL,'北京市朝阳区朝丰家园8号院1号楼3-1103','1','19','37','劳动合同','本科','会计学','北京科技大学','2021-05-27','在职','00000013',NULL,NULL,NULL,NULL,NULL,NULL,'30',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('胡茜','女',NULL,'420981200008265225','未婚','1','武汉市新洲区阳逻街汉施路武生院1号','14','2248590510@qq.com',NULL,'北京市海淀区万寿路42号翠微南里14号','1','19','37','劳动合同','大专','财务管理','武汉生物工程学院','2025-04-07','在职','00000058',NULL,NULL,NULL,NULL,NULL,NULL,'25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('谢杨芳','男',NULL,'430481199303105450','已婚','1','湖南省来阳市仁义乡湾头村5组','3',NULL,NULL,'深圳市龙华区壹城中心','1','19','37','劳动合同','本科','人力资源管理','湖南城市学院','2019-10-28','在职','00000047',NULL,NULL,NULL,NULL,NULL,NULL,'32',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('杨玲','女',NULL,'510922198508023806','已婚','1','四川省成都市武侯区致民路34号1栋1单元1406号','14','49922834@qq.com',NULL,'成都市高新区泰和二街333号中海翠屏湾7栋一单元1704 ','1','19','37','劳动合同','硕士','工商管理','西南交通大学','2024-09-03','在职','00000024',NULL,NULL,NULL,NULL,NULL,NULL,'40',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `jobLevelId`, `posId`, `engageForm`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `workID`, `contractTerm`, `conversionTime`, `notWorkDate`, `beginContract`, `endContract`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('熊国泽','男',NULL,'513701199202066613','已婚','1','四川省巴中市恩阳区上八庙镇双山子村341号','14','vvdwang@icloud.com',NULL,'北京市海淀区万寿路下许宿舍8号楼3单元','1','19','37','劳动合同','大专','机电一体化','西南石油大学','2021-05-10','在职','00000023',NULL,NULL,NULL,NULL,NULL,NULL,'33',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

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
insert into `joblevel` (`id`, `name`, `titleLevel`, `createDate`, `enabled`) values('19','暂无',NULL,'2025-12-18 17:03:47','1');/*Table structure for table `menu` */
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
