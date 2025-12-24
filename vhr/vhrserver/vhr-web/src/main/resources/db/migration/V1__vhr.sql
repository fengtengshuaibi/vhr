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
                                `eid` char(18) DEFAULT NULL COMMENT '员工ID',
                                `asDate` date DEFAULT NULL COMMENT '调薪日期',
                                `beforeSalary` int(11) DEFAULT NULL COMMENT '调前薪资',
                                `afterSalary` int(11) DEFAULT NULL COMMENT '调后薪资',
                                `reason` varchar(255) DEFAULT NULL COMMENT '调薪原因',
                                `remark` varchar(255) DEFAULT NULL COMMENT '备注',
                                PRIMARY KEY (`id`),
                                KEY `pid` (`eid`),
                                CONSTRAINT `adjustsalary_ibfk_1` FOREIGN KEY (`eid`) REFERENCES `employee` (`idCard`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='员工调薪表';

/*Data for the table `adjustsalary` */

/*Table structure for table `appraise` */

DROP TABLE IF EXISTS `appraise`;

CREATE TABLE `appraise` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `eid` char(18) DEFAULT NULL COMMENT '员工ID',
                            `appDate` date DEFAULT NULL COMMENT '考评日期',
                            `appResult` varchar(32) DEFAULT NULL COMMENT '考评结果',
                            `appContent` varchar(255) DEFAULT NULL COMMENT '考评内容',
                            `remark` varchar(255) DEFAULT NULL COMMENT '备注',
                            PRIMARY KEY (`id`),
                            KEY `pid` (`eid`),
                            CONSTRAINT `appraise_ibfk_1` FOREIGN KEY (`eid`) REFERENCES `employee` (`idCard`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='员工考评表';
DROP TABLE IF EXISTS `mail_send_log`;

CREATE TABLE `mail_send_log` (
                                 `msgId` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '消息ID',
                                 `empId` char(18) DEFAULT NULL COMMENT '员工ID',
                                 `status` int(11) DEFAULT '0' COMMENT '0发送中，1发送成功，2发送失败',
                                 `routeKey` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '路由键',
                                 `exchange` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '交换机',
                                 `count` int(11) DEFAULT NULL COMMENT '重试次数',
                                 `tryTime` date DEFAULT NULL COMMENT '第一次重试时间',
                                 `createTime` date DEFAULT NULL COMMENT '创建时间',
                                 `updateTime` date DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='邮件发送日志表';
/*Data for the table `appraise` */

/*Table structure for table `company` */

DROP TABLE IF EXISTS `company`;

CREATE TABLE `company` (
                           `id` int(11) NOT NULL AUTO_INCREMENT,
                           `name` varchar(255) DEFAULT NULL COMMENT '公司名称',
                           `departmentIds` varchar(255) DEFAULT NULL COMMENT '部门ID集合',
                           `posIds` varchar(255) DEFAULT NULL COMMENT '职位ID集合',
                           PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='公司表';

/*Table structure for table `contract` */

DROP TABLE IF EXISTS `contract`;

CREATE TABLE `contract` (
                            `idCard` char(18) NOT NULL COMMENT '身份证号',
                            `employmentType` varchar(32) DEFAULT NULL COMMENT '用工形式',
                            `contractType` varchar(32) DEFAULT NULL COMMENT '合同类型',
                            `firstSignDate` date DEFAULT NULL COMMENT '首次签订日期',
                            `firstSignTerm` double(4,1) DEFAULT NULL COMMENT '首次签订期限(年)',
                            `secondSignDate` date DEFAULT NULL COMMENT '第二次签订日期',
                            `secondSignTerm` double(4,1) DEFAULT NULL COMMENT '第二次签订期限(年)',
                            `thirdSignDate` date DEFAULT NULL COMMENT '第三次签订日期',
                            `signCount` int(11) DEFAULT NULL COMMENT '签订次数',
                            `endDate` date DEFAULT NULL COMMENT '劳动合同截止日期',
                            `attachments` varchar(1024) DEFAULT NULL COMMENT '附件名称，逗号分割',
                            PRIMARY KEY (`idCard`),
                            CONSTRAINT `contract_ibfk_1` FOREIGN KEY (`idCard`) REFERENCES `employee` (`idCard`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='合同表';

/*Table structure for table `department` */

DROP TABLE IF EXISTS `department`;

CREATE TABLE `department` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `name` varchar(32) DEFAULT NULL COMMENT '部门名称',
                              `parentId` int(11) DEFAULT NULL COMMENT '父部门ID',
                              `depPath` varchar(255) DEFAULT NULL COMMENT '部门路径',
                              `enabled` tinyint(1) DEFAULT '1' COMMENT '是否启用',
                              `isParent` tinyint(1) DEFAULT '0' COMMENT '是否为父部门',
                              PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8 COMMENT='部门表';

/*Data for the table `department` */

insert into `department` (`id`, `name`, `parentId`, `depPath`, `enabled`, `isParent`) values('1','人事人','-1','.1','1','1');
insert into `department` (`id`, `name`, `parentId`, `depPath`, `enabled`, `isParent`) values('109','财务管理中心','1','.1.109','1','0');
insert into `department` (`id`, `name`, `parentId`, `depPath`, `enabled`, `isParent`) values('111','销售管理中心','1','.1.111','1','0');
insert into `department` (`id`, `name`, `parentId`, `depPath`, `enabled`, `isParent`) values('112','财务管理中心','1','.1.112','1','0');
insert into `department` (`id`, `name`, `parentId`, `depPath`, `enabled`, `isParent`) values('113','人力行政管理中心','1','.1.113','1','0');
insert into `department` (`id`, `name`, `parentId`, `depPath`, `enabled`, `isParent`) values('114','营销管理中心','1','.1.114','1','0');
insert into `department` (`id`, `name`, `parentId`, `depPath`, `enabled`, `isParent`) values('115','技术管理中心','1','.1.115','1','0');
insert into `department` (`id`, `name`, `parentId`, `depPath`, `enabled`, `isParent`) values('116','总裁办','1','.1.116','1','0');
/*Table structure for table `employee` */

DROP TABLE IF EXISTS `employee`;

CREATE TABLE `employee` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
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
                            `posId` int(11) DEFAULT NULL COMMENT '职位ID',
                            `tiptopDegree` enum('博士','硕士','本科','大专','高中','初中','小学','其他') DEFAULT NULL COMMENT '最高学历',
                            `specialty` varchar(32) DEFAULT NULL COMMENT '所属专业',
                            `school` varchar(32) DEFAULT NULL COMMENT '毕业院校',
                            `beginDate` date DEFAULT NULL COMMENT '入职日期',
                            `workState` enum('在职','离职') DEFAULT '在职' COMMENT '在职状态',
                            `conversionTime` date DEFAULT NULL COMMENT '转正日期',
                            `notWorkDate` date DEFAULT NULL COMMENT '离职日期',
                            `workAge` double(4,1) DEFAULT NULL COMMENT '工龄',
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
                            UNIQUE KEY `id` (`id`),
                            KEY `departmentId` (`departmentId`),
                            KEY `dutyId` (`posId`),
                            KEY `nationId` (`nationId`),
                            KEY `politicId` (`politicId`),
                            CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`departmentId`) REFERENCES `department` (`id`),
                            CONSTRAINT `employee_ibfk_3` FOREIGN KEY (`posId`) REFERENCES `position` (`id`),
                            CONSTRAINT `employee_ibfk_4` FOREIGN KEY (`nationId`) REFERENCES `nation` (`id`),
                            CONSTRAINT `employee_ibfk_5` FOREIGN KEY (`politicId`) REFERENCES `politicsstatus` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='员工表';
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('郝茗','女','1989-02-25','110102198902250026','未婚','1',NULL,'14','jeney9051@hotmail.com','13810555666','北京市朝阳区','1','1','硕士','国际财务管理','英国SURREY大学',NULL,NULL,NULL,NULL,'8.0','36',NULL,NULL,'本市城镇','北京市西城区西便门外大街西里新10楼5门102号','徐萍','13901182286',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('刘梦曦','女','1988-04-26','110103198804261828','离异','1',NULL,'14','cheesemolly@163.com','13911861845','北京市朝阳区富力又一城A2-1-2001','1','1','本科','音乐编辑','中国传媒大学南广学院',NULL,NULL,NULL,NULL,'4.2','37',NULL,NULL,'本市城镇','北京市朝阳区黄厂南里1号院10号楼1单元2001号','孙女士','13801094266',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('窦晓晔','女','1982-06-24','110105198206249469','离异','1',NULL,'14','douqian@sina.com','13651322008','北京市朝阳区西坝河东里83楼1103号','1','1','大专','会计学','北京工业大学',NULL,NULL,NULL,NULL,'5.5','43',NULL,NULL,'本市城镇','北京市朝阳区西坝河东里83楼1103号','姚莉莉','13683598940',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('倪润鑫','男','1987-03-30','110105198703303112','未婚','1',NULL,'14','n13031015775@163.com','13031015775','北京市朝阳区小红门乡小红门273号','1','1','本科','工商管理','北京工业大学',NULL,NULL,NULL,NULL,'3.0','38',NULL,NULL,'本市城镇','北京市朝阳区小红门乡小红门273号','倪润红','13552015589',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('杨爽','女','1990-06-11','110105199006115348','已婚','1',NULL,'14','434412553@qq.com','15210293728','北京市朝阳区石佛营东里118楼1201','1','1','本科','食品科学与工程','北京农学院',NULL,NULL,NULL,NULL,'0.4','35',NULL,NULL,'本市城镇','北京市朝阳区武圣东里49楼1104号','杜亚军','13501067387',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('肖韦','男','1983-05-13','110111198305131834','已婚','1',NULL,'14','XW13901379447@163.com','13901379447','北京市通州区华业东方玫瑰','1','1','大专','金融','中央广播电视大学',NULL,NULL,NULL,NULL,'5.3','42',NULL,NULL,'本市城镇','北京市房山区良乡镇鸿顺园小区10号楼6单元101号','卢嘉宾','13701171877',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('李旺','男','1990-09-27','110223199009275679','已婚','1',NULL,'14',NULL,'15210333483','北京市通州区潞城镇大东各庄村7号','1','1','大专','公路运输与管理','北京交通大学',NULL,NULL,NULL,NULL,'1.8','35',NULL,NULL,'本市城镇','北京市通州区潞城镇大东各庄村7号','柏晓丽','15901172251',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('李然','女','1997-09-08','110226199709081129','未婚','1',NULL,'3',NULL,'18310918851','北京市平谷区东高村镇赵家务大街南98号','1','1','大专','人力资源管理','北京劳动保障职业学校',NULL,NULL,NULL,NULL,'6.0','28',NULL,NULL,'本市农业','北京市平谷区东高村镇赵家务大街南98号','李红银','18701265298',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('褚建新','女','1983-12-14','110227198312146424','已婚','1',NULL,'14',NULL,'13810294752','北京市朝阳区常营民族家园69号101','1','1','本科','社会工作','北方工业大学',NULL,NULL,NULL,NULL,'13.0','42',NULL,NULL,'本市城镇','北京市怀柔区慕田峪办事处慕田峪村47号','孙国兰','13436960661',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('张辉','女','1986-07-21','110227198607211529','未婚','1',NULL,'14','106023676@qq.com','18600542140','北京市怀柔区庙城镇高两河村392号1门','1','1','本科','劳动与社会保障','北京物资学院',NULL,NULL,NULL,NULL,'1.7','39',NULL,NULL,'本市城镇','北京市怀柔区庙城镇高两河村392号1门','张广田','13552999664',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('李青虹','女','1979-01-20','120101197901202082','已婚','1',NULL,'14','amy.li@renshiren.com','18622405082',NULL,'1','1','大专','工商管理专业','天津财经大学',NULL,NULL,NULL,NULL,'14.6','46',NULL,NULL,'本市城镇','天津市河东区晨光道晨光楼16号楼401','李青萍','13820862521',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2',NULL,'天津',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('高辉','男','1981-10-25','120101198110251536','已婚','1',NULL,'14','tony.gao@renshiren.com','18611333191',NULL,'1','1','本科','工商管理','英国赫特福德大学',NULL,NULL,NULL,NULL,'17.2','44',NULL,NULL,'外埠城镇','天津市南开区万德庄大街龙德里1号楼3门503号',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('王雅晶','女','1985-12-02','120102198512020665','未婚','1',NULL,'14','gesanghua85@163.com','13820673125','北京市朝阳区苹果社区','1','1','硕士','Awuntsry Finance','Bentley University',NULL,NULL,NULL,NULL,'2.8','40',NULL,NULL,'外埠城镇','天津市河东区卫国道2号内13栋506号','王爱如','13821392677',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('安毅','男','1993-07-05','120102199307052611','未婚','1',NULL,'14',NULL,'15022346640','天津市河西区景兴里','1','1','本科','德语系','天津外国语学院',NULL,NULL,NULL,NULL,'1.9','32',NULL,NULL,'外埠城镇','天津市河东区大直沽中路9号内1号楼5门202号','张玉芝','15522037318',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('石鑫','女','1991-01-12','120103199101124524','已婚','1',NULL,'14','847457161@qq.com','13602086204','天津市津南区林城佳苑','1','1','大专','人力资源管理','天津中德职业技术学院',NULL,NULL,NULL,NULL,'1.6','34',NULL,NULL,'本市城镇','天津市河西区尖山路光明里26门301号','张超','13602086204',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'天津',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('罗卓佳','女','1993-02-18','120103199302182624','未婚','1',NULL,'14','zhuojia.luo@renshiren.com','13612020210',NULL,'1','1','本科','英语（国际商务）','天津外国语大学滨海外事学院',NULL,NULL,NULL,NULL,'4.1','32',NULL,NULL,'本市城镇','天津市河西区紫金山西路宾水东里45门409号','张平','18522141364',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'天津',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('田净','女','1979-02-28','120104197902283880','已婚','1',NULL,'14','vivien.tian@renshiren.com','15822703812',NULL,'1','1','本科','人力资源','天津大学',NULL,NULL,NULL,NULL,'11.1','46',NULL,NULL,'本市城镇','天津市南开区西湖道西湖里10-2-101','田洁','13820888172',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2',NULL,'天津',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('徐菲菲','女','1987-03-03','120104198703033242','未婚','1',NULL,'14','xuff@renshiren.com','15822272949',NULL,'1','1','本科','英语','天津市外国语滨海外事学院 ',NULL,NULL,NULL,NULL,'9.0','38',NULL,NULL,'本市城镇','天津市西青区东姜井德雅佳园4-102','姜金凤','13302183125',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2',NULL,'天津',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('王帅','女','1989-03-04','12010419890304152X','未婚','1',NULL,'14','bella.wang@renshiren.com','15900398072',NULL,'1','1','大专','计算机多媒体','天津职业大学',NULL,NULL,NULL,NULL,'8.3','36',NULL,NULL,'本市城镇','天津市南开区广开四马路瑞德里','王春荣','13602072270',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2',NULL,'天津',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('武培培','女','1982-11-12','120106198211126525','已婚','1',NULL,'14','yuki.wu@renshiren.com','18622195620',NULL,'1','1','本科','人力资源','南开大学',NULL,NULL,NULL,NULL,'15.1','43',NULL,NULL,'本市城镇','天津市河西区宾水道育贤里21-58-204','李微辰 ','13672015036',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2',NULL,'天津',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('迟姝雯','女','1987-05-07','120109198705071527','已婚','1',NULL,'14','568420460@qq.com','13702084452','天津市南开区三元村大街雅环里1号楼1门102号','1','1','本科','法律','天津南开大学',NULL,NULL,NULL,NULL,'1.4','38',NULL,NULL,'本市城镇','天津市南开区三元村大街雅环里1号楼1门102号','李涛','13207563547',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'天津',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('王虹','女','1989-02-17','120113198902170027','未婚','1',NULL,'14','460481497@qq.com','13702137243',NULL,'1','1','大专','电子商务','天津城市职业学院',NULL,NULL,NULL,NULL,'3.4','36',NULL,NULL,'本市城镇','天津市北辰区果园新村街东升里7号楼4门308号','王玉玲','13612038131',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'天津',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('周喆林','男','1996-02-06','120222199602064616','已婚','1',NULL,'14','961589324@qq.com','13401090309','北京市丰台区蒲黄榆一里6楼北门6号','1','1','本科','工商管理','北京科技大学',NULL,NULL,NULL,NULL,'1.9','29',NULL,NULL,'本市城镇','北京市丰台区蒲黄榆一里6楼北门6号','周伟','13910781622',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('李联欢','女','1981-12-02','130102198112020641','离异','1',NULL,'14','805680374@qq.com','15533671631',NULL,'1','1','本科','会计学','河北经贸大学',NULL,NULL,NULL,NULL,'8.1','44',NULL,NULL,'外埠城镇','河北省石家庄市槐底派出所','李昌','15531166797',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('徐丹','女','1982-03-07','130102198203072121','已婚','1',NULL,'14','444206452@qq.com','15200002591','河北省石家庄市新华区中华北大街186号中华绿园15-6-201','1','1','大专','应用英语','北京语言大学',NULL,NULL,NULL,NULL,'3.8','43',NULL,NULL,'本市城镇','河北省石家庄市新华区中华北大街186号中华绿园18栋1单元101号','梁楷','15200000591',NULL,NULL,NULL,'一级企业人力资源管理师',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'石家庄',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('蔡朝','女','1987-06-09','130102198706091228','已婚','1',NULL,'14','994563286@qq.com','18931102420',NULL,'1','1','本科','人力资源管理','河北地质大学',NULL,NULL,NULL,NULL,'6.7','38',NULL,NULL,'本市城镇','河北省石家庄市长安区广安大街29号51栋平房5号','张宝京','15027457952',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3',NULL,'石家庄',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('张惠','女','1983-12-21','130103198312211828','已婚','1',NULL,'14','1252256971@qq.com','13931869662',NULL,'1','1','本科','英语','河北经贸大学',NULL,NULL,NULL,NULL,'6.4','41',NULL,NULL,'本市城镇','石家庄市桥东区平安南大街105号29栋1单元402号','孙铁','15512123333',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3',NULL,'石家庄',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('宋朋涛','男','1986-08-23','130104198608231832','未婚','1',NULL,'14','18633099123@163.com','18633095678','石家庄市长安区谈固东街紫鑫苑4-2-1201','1','1','大专','计算机网络技术','江西先锋软件职业技术学院',NULL,NULL,NULL,NULL,'5.8','39',NULL,NULL,'外埠城镇','广东省珠海市斗门区井岸镇新堂路6号2栋4单元201房（珠海市恒涛物业管理有限公司）（集体户口）','张钟丹','18031191217',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'石家庄',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('任育旻','女','1992-10-10','130126199210100026','未婚','1',NULL,'14','852730990@qq.com','15127134557','石家庄市长安区光华生活小区1-1-603','1','1','大专','物流管理','邯郸职业技术学院',NULL,NULL,NULL,NULL,'3.9','33',NULL,NULL,'本埠农业','河北省石家庄市灵寿县城关派出所灵寿镇南合村正中街西3排2号','申女士','18942650410',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'石家庄',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('刘伟娜','女','1983-10-27','130130198310271527','已婚','1',NULL,'3','237833796@qq.com','18903395059',NULL,'1','1','大专','工商企业管理','河北科技大学',NULL,NULL,NULL,NULL,'6.5','42',NULL,NULL,'本市城镇','河北省石家庄市裕华区湘江道150号7栋2单元501号','郑同会','13393218068',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3',NULL,'石家庄',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('肖倩倩','女','1986-12-17','13013119861217004X','已婚','1',NULL,'14','41353724@qq.com','18830185862','石家庄市新华区十三所东区1-1-104','1','1','大专','物流管理','河北师范大学公共管理学院',NULL,NULL,NULL,NULL,'2.3','38',NULL,NULL,'本市城镇','河北省石家庄市新华区北合街48号9栋2单元303号','李康','18931160068',NULL,NULL,NULL,'二级企业人力资源管理师',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'石家庄',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('徐世佳','女','2001-08-10','130132200108101623','未婚','1',NULL,'14','3468769958@qq.com','18631160194','河北省石家庄市裕华区塔南路与谈固南大街交叉口位同新村南区2号楼4单元601','1','1','大专','经济管理学院-电子商务','石家庄财经职业学院',NULL,NULL,NULL,NULL,'1.8','24',NULL,NULL,'本埠农业','河北省石家庄市元氏县南因派出所南因镇褚固村光明路107号','张立娟','15373056615\n13780219443',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'石家庄',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('刘小南','女','1990-08-11','130281199008113720','已婚','1',NULL,'14','993928287@qq.com','15701587853','河北省廊坊市香河县安平镇共青社小区8号楼2单元302','1','1','大专','药物制剂技术','河北化工医药职业技术学院',NULL,NULL,NULL,NULL,'6.9','35',NULL,NULL,'外埠农村','河北省遵化适当玉珍上马家峪村西寺沟14排4号','莫立春','18618190165',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('张雨薇','女','1995-12-24','13040319951224182X','未婚','1',NULL,'14','569154098@qq.com','13832331106','石家庄市长安区翟营大街9号中铁大厦B座9A8','1','1','本科','公共事业管理','北京中医药大学东方学院',NULL,NULL,NULL,NULL,'3.1','29',NULL,NULL,'本市城镇','河北省石家庄市长安区翟营南大街9号1栋1单元913号','王鸿','15188873837',NULL,NULL,NULL,'三级企业人力资源管理师',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'石家庄',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('王龙天','男','2002-11-23','130424200211231836','未婚','1',NULL,'14','1481412174@qq.com','17274817759','北京市通州区张家湾镇太玉园西区1号楼1单元502室','1','1','大专','计算机应用','河北省成安县综合职业技术学校',NULL,NULL,NULL,NULL,'1.8','23',NULL,NULL,'外埠农村','河北省邯郸市成安县道东堡镇大姚堡村2组54号','王俊梅','13363061951',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'石家庄',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('杨伟','男','1984-09-18','130531198409180033','未婚','1',NULL,'14',NULL,'13661007477','北京市安居路6号院3号楼3单元1101','1','1','大专','科学教育','邢台学院',NULL,NULL,NULL,NULL,'0.9','41',NULL,NULL,'外埠农业','河北省邢台市广宗县广宗镇兴广路67号','杨松','13932918823',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('耿伟娜','女','1992-01-16','130627199201160645','已婚','1',NULL,'14','326144684@qq.com','13331340893','石家庄市珠峰国际花园27-2-3101','1','1','大专','财政专业','石家庄信息工程职业学院',NULL,NULL,NULL,NULL,'4.3','33',NULL,NULL,'外埠农业','河北省保定市唐县王京所王京镇拔茄村','李玉龙','13739779650',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'石家庄',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('许颖','女','1985-11-26','130635198511264429','已婚','1',NULL,'14','625156473@qq.com','15931671085','石家庄长安区紫晶悦城17-1-1-2603','1','1','本科','人力资源管理','河北师范大学汇华学院',NULL,NULL,NULL,NULL,'6.0','40',NULL,NULL,'本市城镇','河北省石家庄市裕华区塔南路169号','樊海华','13292830325',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3',NULL,'石家庄',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('刘红莲','女','1981-07-05','130682198107050343','已婚','1',NULL,'14','1207064178@qq.com','17332370837',NULL,'1','1','本科','汉语言文学','河北大学',NULL,NULL,NULL,NULL,'6.9','44',NULL,NULL,'本市城镇','石家庄市长安区','赫威','18032091717',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3',NULL,'石家庄',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('薛珍妮','女','1996-11-08','130725199611080827','未婚','1',NULL,'14',NULL,'17710216391','朝阳区十八里店南桥前祁庄151号公寓312','1','1','大专','会展策划与管理','邯郸职业技术学院',NULL,NULL,NULL,NULL,'0.9','29',NULL,NULL,'外埠农业','河北省张家口市尚义县大青沟镇魏家村自然村228号','薛秀军','15832369561',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('刘艳','女','2000-03-10','130729200003101920','未婚','1',NULL,'14','1486310982@qq.com','19564487220','北京市通州区次渠北小区乐乎公寓4号楼A6单元309','1','1','本科','财务管理','河北金融学院',NULL,NULL,NULL,NULL,'0.7','25',NULL,NULL,'外埠农业','河北省张家口市万全区北新屯乡刘虎庄村小南坪1巷7号','刘富军','13366159185',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('付海岩','女','1990-02-26','130824199002260047','已婚','1',NULL,'14','479822268@qq.com','18132633871',NULL,'1','1','本科','信息管理与信息系统','石家庄铁道大学四方学院',NULL,NULL,NULL,NULL,'8.2','35',NULL,NULL,'本市城镇','河北省石家庄市裕华区','任亚朋','18713188290',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3',NULL,'石家庄',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('王丽娜','女','1990-01-01','130826199001011244','已婚','1',NULL,'14','374801707@qq.com','15010862429','北京市丰台区万丰路305亿潼隆之家','1','1','大专','绿色食品工程','中国环境管理干部学院',NULL,NULL,NULL,NULL,'6.7','35',NULL,NULL,'外埠农村','河北省承德市丰宁满族自治县大滩镇大下营村2组48号','王登飞','15832885490',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('段沣涵','男','2000-09-30','130923200009303411','未婚','1',NULL,'3','1023673524@qq.com','18519652808','北京市房山区良乡伟业嘉园西里23号楼','1','1','本科','会计学','中央财经大学',NULL,NULL,NULL,NULL,'1.1','25',NULL,NULL,'本市城镇','北京市海淀区田村路40号院平房6栋9号','段春园','15611033021',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('王冬辰','女','1992-09-29','131082199209291028','未婚','1',NULL,'14','502162497@qq.com','18500076492','河北省廊坊市燕郊开发区福成六期','1','1','大专','人力资源管理','河北民族师范学院',NULL,NULL,NULL,NULL,'1.0','33',NULL,NULL,'外埠农业','河北省三河市皇庄镇一村46号','辛淑菊','18731665810',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('王旭','女','2001-01-26','131128200101261241','未婚','1',NULL,'14','2939088937@qq.com','16603370262','天津市河西区下瓦房街道福至里小区4甲806','1','1','大专','审计','秦皇岛职业技术学院',NULL,NULL,NULL,NULL,'2.6','24',NULL,NULL,'外埠农业','河北省衡水市阜城县古城镇王台庄村17号','王海亭','13663543279',NULL,NULL,NULL,'初级会计',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'天津',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('祝梦瑶','女','1997-01-27','131182199701271227','未婚','1',NULL,'14',NULL,'18829513485','北京市朝阳区八里庄街道甘露家园','1','1','本科','人力资源管理','西安石油大学',NULL,NULL,NULL,NULL,'4.0','28',NULL,NULL,'外埠农业','河北省深州市北溪村乡东留曹村20号','祝振涛','15127853890',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('郭志强','男','1993-11-29','140212199311293938','未婚','1',NULL,'3','gzq-spiyit52@126.com','15652902525','河北省廊坊市三河市燕郊镇雷捷时代广场二期5-1-2903','1','1','本科','计算机科学与技术','运城学院',NULL,NULL,NULL,NULL,'9.3','32',NULL,NULL,'外埠农村','山西省大同市新荣区花园屯乡前井村238号2户','郭女士','13734223690',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('白靖','女','2001-01-01','140928200101010025','未婚','1',NULL,'14','2801356718@qq.com','18532638107','北京市朝阳区和平里街道胜古南里25号楼','1','1','大专','行政管理','国家开放大学',NULL,NULL,NULL,NULL,'0.4','24',NULL,NULL,'外埠农业','山西省五寨县前所乡南坪村南巷17号','白贵珍','18835098301',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('魏志浩','男','1998-01-22','142733199801223917','未婚','1',NULL,'14','1350658766@qq.com','15501215667','北京市通州北关三元村9号楼602','1','1','本科','计算机科学与技术','山西应用科技学院',NULL,NULL,NULL,NULL,'5.0','27',NULL,NULL,'外埠农业','山西省垣曲县英言乡席家坪村沙河组051号','魏永军','15835961250',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('陈猛','男','1998-08-20','210921199808205211','未婚','1',NULL,'14',NULL,'13840472451','河北省石家庄市长安区金谈固月坛园14号楼3单元203','1','1','大专','计算机应用','辽宁林业职业技术学院',NULL,NULL,NULL,NULL,'0.9','27',NULL,NULL,'外埠农业','辽宁省阜新蒙古族自治县苍土乡下洼子村满有营子123号','陈永兴','15124010708',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'石家庄',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('刘伟','男','1982-12-24','231026198212242735','已婚','1',NULL,'14','liuwei2000285@163.com','15810253715','北京市通州区葛布店南里99号','1','1','本科','财务管理','哈尔滨学院',NULL,NULL,NULL,NULL,'7.0','42',NULL,NULL,'外埠城镇','吉林省四平市铁东区解放街光辉委六组','王楠','15011487817',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('陈力','男','1988-04-03','310108198804033314','未婚','1',NULL,'14','li.chen@renshiren.com','13774233800','上海市宝山区新二路999弄38号102室','1','1','大专','工商管理','江南大学',NULL,NULL,NULL,NULL,'5.1','37',NULL,NULL,'本市城镇','上海市宝山区新二路999弄38号102室','卞玉琴','15000633256',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'上海',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('王贝聿','男','1992-11-14','310108199211142632','已婚','1',NULL,'14','401990065@qq.com','13761996360','上海市浦东新区巨峰路176弄18号601室','1','1','大专','市政工程','上海城市管理学院',NULL,NULL,NULL,NULL,'0.6','33',NULL,NULL,'本市城镇','上海市浦东新区巨峰路176弄18号601室','华丽雯','13788925011',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'上海',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('陈其毓','男','1988-02-20','310115198802200418','已婚','1',NULL,'14','1012294956@qq.com','13817042092','上海市张杨路2999弄21号302','1','1','本科','工商管理','英国桑德兰大学',NULL,NULL,NULL,NULL,'5.1','37',NULL,NULL,'本市城镇','上海市浦东新区张江镇川北公路3078号403室','陈雄','13901754953',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'上海',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('郁磊','男','1994-12-11','310230199412112731','已婚','1',NULL,'14','527506897@qq.com','18721989531','上海市崇明区建设镇大同村蟠龙1511','1','1','大专','工商企业管理','上海开放大学',NULL,NULL,NULL,NULL,'5.5','31',NULL,NULL,'本市农业','上海市崇明区建设镇大同村蟠龙1511','赵表','13761816874',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'上海',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('冯淑娟','女','1984-12-26','330781198412260044','已婚','1',NULL,'14','164560543@qq.com','18005748813','浙江省宁波市鄞州区下应街道万科桂语里20幢1302室','1','1','本科','会计学','绍兴文理学院',NULL,NULL,NULL,NULL,'5.9','40',NULL,NULL,'本市城镇','浙江省宁波市鄞州区下应街道万科桂语里20幢1302室','黄杰敏','13989329781',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'宁波',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('刘晓红','女','1983-09-24','370785198309249325','已婚','1',NULL,'14','824823@163.com','18600964675','燕郊神威北路美林湾小区','1','1','大专','经贸韩语','青岛滨海学院',NULL,NULL,NULL,NULL,'7.4','42',NULL,NULL,'外埠城镇','山东省潍坊市高密市密水街道姜家屯村77号','刘先生','18600514399',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('程新玲','女','1989-06-30','410802198906300069','已婚','1',NULL,'14','xinling.cheng@renshiren.com','15514089918',NULL,'1','1','本科','会计学','黄淮学院',NULL,NULL,NULL,NULL,'6.6','36',NULL,NULL,'外地城镇','河南省焦作市解放区卫校西街2号院','赵康','15216780968',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3',NULL,'上海',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('董文文','女','1995-08-27','412727199508278423','已婚','1',NULL,'14','614004343@qq.com','15201121056','北京市朝阳区朝丰家园8号院1号楼3-1103','1','1','本科','会计学','北京科技大学',NULL,NULL,NULL,NULL,'4.6','30',NULL,NULL,'外埠农业','河南省淮阳县城关回族镇团结行政村孙庄三组020号','陈浩','13436564583',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('胡茜','女','2000-08-26','420981200008265225','未婚','1',NULL,'14','2248590510@qq.com','17671861677','北京市海淀区万寿路42号翠微南里14号','1','1','大专','财务管理','武汉生物工程学院',NULL,NULL,NULL,NULL,'0.8','25',NULL,NULL,'外埠城镇','武汉市新洲区阳逻街汉施路武生院1号','胡光耀','18621681586',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'3',NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('谢杨芳','男','1993-03-10','430481199303105450','已婚','1',NULL,'3',NULL,'17841391664','深圳市龙华区壹城中心','1','1','本科','人力资源管理','湖南城市学院',NULL,NULL,NULL,NULL,'6.1','32',NULL,NULL,'外埠城镇','湖南省来阳市仁义乡湾头村5组','谢小金','18273723719',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'深圳',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('杨玲','女','1985-08-02','510922198508023806','已婚','1',NULL,'14','49922834@qq.com','18190890826','成都市高新区泰和二街333号中海翠屏湾7栋一单元1704 ','1','1','硕士','工商管理','西南交通大学',NULL,NULL,NULL,NULL,'1.3','40',NULL,NULL,'本市城镇','四川省成都市武侯区致民路34号1栋1单元1406号','钟颖新','18980715385',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'北京',NULL,NULL);
insert into `employee` (`name`, `gender`, `birthday`, `idCard`, `wedlock`, `nationId`, `nativePlace`, `politicId`, `email`, `phone`, `address`, `departmentId`, `posId`, `tiptopDegree`, `specialty`, `school`, `beginDate`, `workState`, `conversionTime`, `notWorkDate`, `workAge`, `age`, `idCardStartDate`, `idCardEndDate`, `hukouType`, `hukouLocation`, `emergencyContact`, `emergencyContactPhone`, `fertilityStatus`, `childrenInfo`, `graduationDate`, `certificate`, `trainingHistory`, `previousCompany`, `previousPosition`, `previousStartEnd`, `pastPerformance`, `previousResignationReason`, `reference`, `referencePhone`, `assessmentResult`, `probation`, `conversionScore`, `workLocation`, `rewardsPunishments`, `resignationReason`) values('熊国泽','男','1992-02-06','513701199202066613','已婚','1',NULL,'14','vvdwang@icloud.com','18511178311','北京市海淀区万寿路下许宿舍8号楼3单元','1','1','大专','机电一体化','西南石油大学',NULL,NULL,NULL,NULL,'4.7','33',NULL,NULL,'外埠农业','四川省巴中市恩阳区上八庙镇双山子村341号','魏丹君','18600902090',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,'北京',NULL,NULL);


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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='员工奖惩表';

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='员工调动表';

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='员工培训表';

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
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8 COMMENT='员工薪资表';

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
                      `employee_id` CHAR(18) DEFAULT NULL COMMENT '员工身份证号',
                      PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='操作员表';

/*Data for the table `hr` */

insert  into `hr`(`id`,`name`,`phone`,`telephone`,`address`,`enabled`,`username`,`password`,`userface`,`remark`) values (3,'系统管理员','18568887789','029-82881234','深圳南山',1,'admin','$2a$10$ySG2lkvjFHY5O0./CPIE1OI8VJsuKYEzOYzqIa7AJR6sEgSzUFOAm','http://bpic.588ku.com/element_pic/01/40/00/64573ce2edc0728.jpg',NULL),(5,'李白','18568123489','029-82123434','海口美兰',1,'libai','$2a$10$oE39aG10kB/rFu2vQeCJTu/V/v4n6DRR0f8WyXRiAYvBpmadoOBE.','http://bpic.588ku.com/element_pic/01/40/00/64573ce2edc0728.jpg',NULL),(10,'韩愈','18568123666','029-82111555','广州番禺',1,'hanyu','$2a$10$oE39aG10kB/rFu2vQeCJTu/V/v4n6DRR0f8WyXRiAYvBpmadoOBE.','http://bpic.588ku.com/element_pic/01/40/00/64573ce2edc0728.jpg',NULL),(11,'柳宗元','18568123377','029-82111333','广州天河',1,'liuzongyuan','$2a$10$oE39aG10kB/rFu2vQeCJTu/V/v4n6DRR0f8WyXRiAYvBpmadoOBE.','http://bpic.588ku.com/element_pic/01/40/00/64573ce2edc0728.jpg',NULL),(12,'曾巩','18568128888','029-82111222','广州越秀',1,'zenggong','$2a$10$oE39aG10kB/rFu2vQeCJTu/V/v4n6DRR0f8WyXRiAYvBpmadoOBE.','http://bpic.588ku.com/element_pic/01/40/00/64573ce2edc0728.jpg',NULL);

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
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8 COMMENT='操作员角色关联表';

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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COMMENT='职称表';

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
insert into `joblevel` (`id`, `name`, `titleLevel`, `createDate`, `enabled`) values('19','暂无',NULL,'2025-12-18 17:03:47','1');
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
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COMMENT='菜单表';

/*Data for the table `menu` */

INSERT INTO `menu` (`id`, `url`, `path`, `component`, `name`, `iconCls`, `keepAlive`, `requireAuth`, `parentId`, `enabled`) VALUES
(1, '/', NULL, NULL, '所有', NULL, NULL, NULL, NULL, 1),
(2, '/', '/home', 'Home', '员工资料', 'fa fa-user-circle-o', NULL, 1, 1, 1),
(3, '/', '/home', 'Home', '人事管理', 'fa fa-address-card-o', NULL, 1, 1, 1),
(4, '/', '/home', 'Home', '薪资管理', 'fa fa-money', NULL, 1, 1, 1),
(5, '/', '/home', 'Home', '统计管理', 'fa fa-bar-chart', NULL, 1, 1, 1),
(6, '/', '/home', 'Home', '系统管理', 'fa fa-windows', NULL, 1, 1, 1),
(7, '/employee/basic/**', '/emp/basic', 'EmpBasic', '基本资料', NULL, NULL, 1, 2, 1),
(8, '/employee/advanced/**', '/emp/adv', 'EmpAdv', '高级资料', NULL, NULL, 1, 2, 1),
(9, '/personnel/emp/**', '/per/emp', 'PerEmp', '员工花名册', NULL, NULL, 1, 3, 1),
(10, '/personnel/ec/**', '/per/ec', 'PerEc', '员工奖惩', NULL, NULL, 1, 3, 1),
(11, '/train/**', '/train', 'Home', '培训管理', 'fa fa-graduation-cap', NULL, 1, 1, 1),
(12, '/personnel/salary/**', '/per/salary', 'PerSalary', '员工调薪', NULL, NULL, 1, 3, 1),
(13, '/personnel/remove/**', '/per/mv', 'PerMv', '员工调动', NULL, NULL, 1, 3, 1),
(14, '/salary/sob/**', '/sal/sob', 'SalSob', '工资账套管理', NULL, NULL, 1, 4, 1),
(15, '/salary/sobcfg/**', '/sal/sobcfg', 'SalSobCfg', '员工账套设置', NULL, NULL, 1, 4, 1),
(16, '/salary/table/**', '/sal/table', 'SalTable', '工资表管理', NULL, NULL, 1, 4, 1),
(17, '/salary/month/**', '/sal/month', 'SalMonth', '月末处理', NULL, NULL, 1, 4, 1),
(18, '/salary/search/**', '/sal/search', 'SalSearch', '工资表查询', NULL, NULL, 1, 4, 1),
(19, '/statistics/all/**', '/sta/all', 'StaAll', '综合信息统计', NULL, NULL, 1, 5, 1),
(20, '/statistics/score/**', '/sta/score', 'StaScore', '员工积分统计', NULL, NULL, 1, 5, 1),
(21, '/statistics/personnel/**', '/sta/pers', 'StaPers', '人事信息统计', NULL, NULL, 1, 5, 1),
(22, '/statistics/recored/**', '/sta/record', 'StaRecord', '人事记录统计', NULL, NULL, 1, 5, 1),
(23, '/system/basic/**', '/sys/basic', 'SysBasic', '基础信息设置', NULL, NULL, 1, 6, 1),
(24, '/system/cfg/**', '/sys/cfg', 'SysCfg', '菜单管理', NULL, NULL, 1, 6, 1),
(25, '/system/log/**', '/sys/log', 'SysLog', '操作日志管理', NULL, NULL, 1, 6, 1),
(26, '/system/hr/**', '/sys/hr', 'SysHr', '操作员管理', NULL, NULL, 1, 6, 1),
(27, '/system/data/**', '/sys/data', 'SysData', '备份恢复数据库', NULL, NULL, 1, 6, 1),
(28, '/system/init/**', '/sys/init', 'SysInit', '初始化数据库', NULL, NULL, 1, 6, 1),
(29, '/personnel/train/**', '/per/train', 'PerTrain', '员工培训', NULL, NULL, 1, 3, 1),
(30, '/personnel/performance/**', '/per/per', 'PerPerformance', '绩效管理', NULL, NULL, 1, 3, 1),
(31, '/personnel/score/**', '/per/score', 'PerScore', '内部管理评分', NULL, NULL, 1, 3, 1),
(32, '/statistics/performance/**', '/sta/performance', 'StaPerformance', '普通员工绩效统计', NULL, NULL, 1, 5, 1),
(33, '/statistics/executive/**', '/sta/executive', 'StaExecutive', '高管绩效统计', NULL, NULL, 1, 5, 1),
(34, '/train/course/**', '/train/course', 'PerTrainAdd', '课程库', NULL, NULL, 1, 11, 1),
(35, '/train/stats/**', '/train/stats', 'PerTrainStats', '培训统计', NULL, NULL, 1, 11, 1),
(36, '/', '/home', 'Home', '在线学习', 'fa fa-graduation-cap', NULL, 1, 1, 1),
(37, '/emp/train/learn/**', '/emp/train/learn', 'EmpTrainLearn', '课程学习', NULL, NULL, 1, 36, 1),
(38, '/emp/train/find/**', '/emp/train/find', 'EmpTrainFind', '课程查找', NULL, NULL, 1, 36, 1);
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
) ENGINE=InnoDB AUTO_INCREMENT=283 DEFAULT CHARSET=utf8 COMMENT='菜单角色关联表';

/*Data for the table `menu_role` */

INSERT INTO `menu_role` (`mid`, `rid`) VALUES
(7,3),(7,6),(9,6),(10,6),(12,6),(13,6),(14,6),(15,6),(16,6),(17,6),(18,6),(19,6),(20,6),(21,6),(22,6),(23,6),(25,6),(26,6),(27,6),(28,6),(24,6),
(7,4),(8,4),(7,2),(8,2),(9,2),(10,2),(12,2),(13,2),(7,1),(8,1),(9,1),(10,1),(12,1),(13,1),(14,1),(15,1),(16,1),(17,1),(18,1),(19,1),(20,1),(21,1),(22,1),(23,1),(24,1),(25,1),(26,1),(27,1),(28,1),
(7,14),(8,14),(9,14),(29,6),(30,6),(31,6),(32,6),(33,6),
(34, 1), (34, 6),
(35, 1), (35, 6),
(37, 1), (37, 6),
(38, 1), (38, 6);
/*Table structure for table `msgcontent` */

DROP TABLE IF EXISTS `msgcontent`;

CREATE TABLE `msgcontent` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `title` varchar(64) DEFAULT NULL,
                              `message` varchar(255) DEFAULT NULL,
                              `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                              `idCard` char(18) DEFAULT NULL,
                              PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='消息内容表';

/*Data for the table `msgcontent` */

insert  into `msgcontent`(`id`,`title`,`message`,`createDate`) values (14,'2222222222','11111111111111111','2018-02-02 20:46:19'),(15,'22222222','3333333333333333333333','2018-02-02 21:45:57'),(16,'通知标题1','通知内容1','2018-02-03 11:41:39'),(17,'通知标题2','通知内容2','2018-02-03 11:52:37'),(18,'通知标题3','通知内容3','2018-02-03 12:19:41');

/*Table structure for table `nation` */

DROP TABLE IF EXISTS `nation`;

CREATE TABLE `nation` (
                          `id` int(11) NOT NULL AUTO_INCREMENT,
                          `name` varchar(32) DEFAULT NULL,
                          PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8 COMMENT='民族表';

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='操作日志表';

/*Data for the table `oplog` */

/*Table structure for table `politicsstatus` */

DROP TABLE IF EXISTS `politicsstatus`;

CREATE TABLE `politicsstatus` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `name` varchar(32) DEFAULT NULL,
                                  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='政治面貌表';

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
                            `reportTo` char(18) DEFAULT NULL COMMENT '汇报上级身份证',
                            PRIMARY KEY (`id`),
                            UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COMMENT='职位表';

/*Data for the table `position` */

insert into `position` (`id`, `name`, `createDate`, `enabled`) values('1','董事长/总裁','2025-12-18 17:02:08','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('2','总裁助理','2025-12-18 17:02:39','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('3','外部法律顾问','2025-12-18 17:02:48','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('4','执行副总裁','2025-12-18 17:03:13','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('5','销售总监','2025-12-18 17:04:10','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('6','高级经理','2025-12-18 17:04:17','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('7','人力总监','2025-12-18 17:04:28','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('8','销售副总监','2025-12-18 17:04:45','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('9','客服总监','2025-12-18 17:04:54','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('10','招聘经理','2025-12-18 17:05:25','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('11','招聘主管','2025-12-18 17:05:32','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('12','招聘专员','2025-12-18 17:05:39','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('13','高级销售经理','2025-12-18 17:05:50','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('14','客服副总监','2025-12-18 17:06:05','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('15','高级客服经理','2025-12-18 17:06:13','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('16','客服主管','2025-12-18 17:06:22','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('17','高级客服专员','2025-12-18 17:06:28','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('18','客服专员','2025-12-18 17:06:34','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('19','财务总监','2025-12-18 17:06:51','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('20','投融资总监','2025-12-18 17:07:00','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('21','会计核算经理','2025-12-18 17:25:09','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('22','出纳主管','2025-12-18 17:25:19','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('23','会计','2025-12-18 17:25:26','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('24','出纳','2025-12-18 17:25:35','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('25','投融资助理','2025-12-18 17:26:22','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('26','人力行政总监','2025-12-18 17:26:40','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('27','人力行政经理','2025-12-18 17:26:54','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('28','人力专员','2025-12-18 17:26:59','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('29','人力行政专员','2025-12-18 17:27:05','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('30','行政专员','2025-12-18 17:27:18','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('31','营销总监','2025-12-18 17:27:41','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('32','新媒体运营师','2025-12-18 17:27:48','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('33','技术副总监','2025-12-18 17:27:55','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('34','运维工程师','2025-12-18 17:28:25','1');
insert into `position` (`id`, `name`, `createDate`, `enabled`) values('35','Java工程师','2025-12-18 17:28:30','1');

/*Table structure for table `role` */

DROP TABLE IF EXISTS `role`;

CREATE TABLE `role` (
                        `id` int(11) NOT NULL AUTO_INCREMENT,
                        `name` varchar(64) DEFAULT NULL,
                        `nameZh` varchar(64) DEFAULT NULL COMMENT '角色名称',
                        PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COMMENT='角色表';

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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COMMENT='工资账套表';

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
                          CONSTRAINT `sysmsg_ibfk_1` FOREIGN KEY (`mid`) REFERENCES `msgcontent` (`id`),
                          CONSTRAINT `sysmsg_ibfk_2` FOREIGN KEY (`hrid`) REFERENCES `hr` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8 COMMENT='系统消息表';

/*Table structure for table `per_employee_performance` */
DROP TABLE IF EXISTS `per_employee_performance`;
CREATE TABLE `per_employee_performance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eid` char(18) DEFAULT NULL COMMENT '员工ID',
  `year` int(11) DEFAULT NULL COMMENT '年份',
  `month1` decimal(10,2) DEFAULT NULL COMMENT '1月绩效',
  `month2` decimal(10,2) DEFAULT NULL COMMENT '2月绩效',
  `month3` decimal(10,2) DEFAULT NULL COMMENT '3月绩效',
  `month4` decimal(10,2) DEFAULT NULL COMMENT '4月绩效',
  `month5` decimal(10,2) DEFAULT NULL COMMENT '5月绩效',
  `month6` decimal(10,2) DEFAULT NULL COMMENT '6月绩效',
  `month7` decimal(10,2) DEFAULT NULL COMMENT '7月绩效',
  `month8` decimal(10,2) DEFAULT NULL COMMENT '8月绩效',
  `month9` decimal(10,2) DEFAULT NULL COMMENT '9月绩效',
  `month10` decimal(10,2) DEFAULT NULL COMMENT '10月绩效',
  `month11` decimal(10,2) DEFAULT NULL COMMENT '11月绩效',
  `month12` decimal(10,2) DEFAULT NULL COMMENT '12月绩效',
  `createDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updateDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_eid_year` (`eid`,`year`),
  CONSTRAINT `fk_ep_eid` FOREIGN KEY (`eid`) REFERENCES `employee` (`idCard`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='员工绩效表';

/*Table structure for table `per_executive_performance` */
DROP TABLE IF EXISTS `per_executive_performance`;
CREATE TABLE `per_executive_performance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eid` char(18) DEFAULT NULL COMMENT '员工ID',
  `year` int(11) DEFAULT NULL COMMENT '年份',
  `quarter1` decimal(10,2) DEFAULT NULL COMMENT '第一季度绩效',
  `quarter2` decimal(10,2) DEFAULT NULL COMMENT '第二季度绩效',
  `quarter3` decimal(10,2) DEFAULT NULL COMMENT '第三季度绩效',
  `quarter4` decimal(10,2) DEFAULT NULL COMMENT '第四季度绩效',
  `createDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updateDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_ep_eid_year` (`eid`,`year`),
  CONSTRAINT `fk_exp_eid` FOREIGN KEY (`eid`) REFERENCES `employee` (`idCard`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='高管绩效表';

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
DROP TABLE IF EXISTS `menu_masking_config`;
CREATE TABLE `menu_masking_config` (
                                       `id` int(11) NOT NULL AUTO_INCREMENT,
                                       `menu_id` int(11) DEFAULT NULL,
                                       `field_name` varchar(64) DEFAULT NULL,
                                       `masking_type` varchar(32) DEFAULT NULL COMMENT 'NAME, IDCARD, ALL',
                                       `enabled` tinyint(1) DEFAULT '1',
                                       PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='菜单数据脱敏配置表';

UPDATE `menu` SET `name`='菜单管理' WHERE `id`=24;

CREATE TABLE `course` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `name` varchar(255) DEFAULT NULL COMMENT '课程名称',
  `description` varchar(500) DEFAULT NULL COMMENT '课程描述',
  `cover_url` varchar(255) DEFAULT NULL COMMENT '封面图片URL',
  `video_url` varchar(255) DEFAULT NULL COMMENT '视频文件URL',
  `category` varchar(50) DEFAULT NULL COMMENT '课程分类',
  `type` varchar(20) DEFAULT NULL COMMENT '课程类型(必修/选修)',
  `department_id` int(11) DEFAULT NULL COMMENT '所属部门ID(仅必修课)',
  `has_exam` tinyint(1) DEFAULT 0 COMMENT '是否有考试(0:无, 1:有)',
  `exam_limit` int(11) DEFAULT 0 COMMENT '考试次数限制',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `status` int(11) DEFAULT 1 COMMENT '状态(1:启用)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='课程表';

CREATE TABLE `course_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '题目ID',
  `course_id` int(11) DEFAULT NULL COMMENT '关联课程ID',
  `type` varchar(20) DEFAULT NULL COMMENT '题目类型(单选/多选/填空)',
  `content` varchar(500) DEFAULT NULL COMMENT '题目内容',
  `options` text COMMENT '选项JSON',
  `correct_answer` varchar(255) DEFAULT NULL COMMENT '正确答案',
  `score` int(11) DEFAULT 0 COMMENT '分值',
  PRIMARY KEY (`id`),
  KEY `fk_course_question_course` (`course_id`),
  CONSTRAINT `fk_course_question_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='课程题库表';

CREATE TABLE `employee_course` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `employee_id` char(18) DEFAULT NULL COMMENT '员工身份证号',
  `course_id` int(11) DEFAULT NULL COMMENT '课程ID',
  `status` varchar(20) DEFAULT 'Learning' COMMENT '学习状态(Learning/Finished)',
  `video_progress` int(11) DEFAULT 0 COMMENT '视频观看进度(秒)',
  `is_video_finished` tinyint(1) DEFAULT 0 COMMENT '视频是否看完(0:否, 1:是)',
  `study_hours` double(5,1) DEFAULT 0.0 COMMENT '学习时长(小时)',
  `exam_score` int(11) DEFAULT NULL COMMENT '考试得分',
  `exam_attempts` int(11) DEFAULT 0 COMMENT '已考次数',
  `is_passed` tinyint(1) DEFAULT 0 COMMENT '是否通过(0:否, 1:是)',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `fk_emp_course_emp` (`employee_id`),
  KEY `fk_emp_course_course` (`course_id`),
  CONSTRAINT `fk_emp_course_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='员工选课/学习记录表';


