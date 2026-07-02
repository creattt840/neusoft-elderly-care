-- ============================================
-- 东软颐养中心管理系统 — Mock 数据全量脚本
-- 生成时间基准: 2026-07-02
-- 随机种子: 20260702
--
-- 【警告】本脚本会 DROP 并重建 elderly_care 数据库，请勿在生产环境执行！
--
-- 用法:
--   mysql -u root -p < scripts/elderly_care_mock_full.sql
--
-- 默认登录账号:
--   手机号: 13800138000
--   密码:   123456
--
-- 预期数据量:
--   user                   3
--   care_level             4
--   care_item              53
--   room                   25
--   bed                    65
--   service                25
--   elderly                70
--   check_in               55
--   check_out              15
--   outing                 60
--   care_record            75
--   meal_calendar          63
--   meal_plan              55
--   elderly_meal           80
--   service_subscription   70
--   合计                   ~718
--
-- 重新生成:
--   node scripts/generate-mock-sql.mjs
-- ============================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS `elderly_care`;
CREATE DATABASE `elderly_care` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `elderly_care`;


-- ============================================
-- Section 1: 数据库结构（表、外键、视图）
-- ============================================

-- ============================================
-- 东软颐养中心管理系统 - 数据库脚本
-- 版本: 1.0.0
-- ============================================

-- 创建数据库

-- 1. 系统用户表
CREATE TABLE `user` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    `phone` VARCHAR(20) NOT NULL UNIQUE COMMENT '手机号（登录账号）',
    `password` VARCHAR(100) NOT NULL COMMENT '登录密码（加密存储）',
    `real_name` VARCHAR(50) NOT NULL COMMENT '真实姓名',
    `age` INT COMMENT '年龄',
    `gender` TINYINT DEFAULT 1 COMMENT '性别：1男 2女',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0禁用 1启用',
    `last_login_time` DATETIME COMMENT '最后登录时间',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统用户表';

-- 2. 房间表
CREATE TABLE `room` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `room_no` VARCHAR(20) NOT NULL UNIQUE COMMENT '房间号',
    `room_type` TINYINT DEFAULT 1 COMMENT '房间类型：1单人间 2双人间 3多人间',
    `floor` INT COMMENT '楼层',
    `capacity` INT DEFAULT 1 COMMENT '容纳床位数',
    `status` TINYINT DEFAULT 1 COMMENT '状态：1可用 2维修中',
    `remark` VARCHAR(200) COMMENT '备注',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_room_no` (`room_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='房间表';

-- 3. 床位表
CREATE TABLE `bed` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `room_id` BIGINT NOT NULL COMMENT '所属房间ID',
    `bed_no` VARCHAR(20) NOT NULL COMMENT '床位号',
    `status` TINYINT DEFAULT 0 COMMENT '状态：0空闲 1已入住',
    `elderly_id` BIGINT COMMENT '入住老人ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `uk_room_bed` (`room_id`, `bed_no`),
    INDEX `idx_elderly` (`elderly_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='床位表';

-- 4. 老人信息表
CREATE TABLE `elderly` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL COMMENT '姓名',
    `phone` VARCHAR(20) COMMENT '手机号',
    `gender` TINYINT DEFAULT 1 COMMENT '性别：1男 2女',
    `age` INT COMMENT '年龄',
    `id_card` VARCHAR(18) UNIQUE COMMENT '身份证号',
    `address` VARCHAR(200) COMMENT '家庭住址（完整）',
    `country` VARCHAR(50) COMMENT '国家',
    `province` VARCHAR(50) COMMENT '省份',
    `city` VARCHAR(50) COMMENT '城市',
    `address_detail` VARCHAR(200) COMMENT '详细地址',
    `health_condition` TEXT COMMENT '健康状况',
    `allergy_info` VARCHAR(500) COMMENT '过敏信息',
    `emergency_contact` VARCHAR(50) COMMENT '紧急联系人',
    `emergency_phone` VARCHAR(20) COMMENT '紧急联系电话',
    `care_level_id` BIGINT COMMENT '护理级别ID',
    `bed_id` BIGINT COMMENT '当前床位ID',
    `status` TINYINT DEFAULT 1 COMMENT '状态：1在住 2退住',
    `check_in_date` DATE COMMENT '入住日期',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_name` (`name`),
    INDEX `idx_phone` (`phone`),
    INDEX `idx_bed` (`bed_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='老人信息表';

-- 5. 入住登记表
CREATE TABLE `check_in` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `elderly_id` BIGINT NOT NULL COMMENT '老人ID',
    `bed_id` BIGINT NOT NULL COMMENT '床位ID',
    `check_in_date` DATE NOT NULL COMMENT '入住日期',
    `remark` TEXT COMMENT '备注',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='入住登记表';

-- 6. 退住登记表
CREATE TABLE `check_out` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `elderly_id` BIGINT NOT NULL COMMENT '老人ID',
    `bed_id` BIGINT NOT NULL COMMENT '床位ID',
    `check_out_date` DATE NOT NULL COMMENT '退住日期',
    `check_out_reason` TINYINT COMMENT '退住原因：1正常退住 2转院 3病故 4其他',
    `remark` TEXT COMMENT '备注',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='退住登记表';

-- 7. 外出登记表
CREATE TABLE `outing` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `elderly_id` BIGINT NOT NULL COMMENT '老人ID',
    `outing_type` TINYINT COMMENT '外出类型：1临时外出 2长期外出 3外出就医',
    `start_time` DATETIME NOT NULL COMMENT '开始时间',
    `expected_return_time` DATETIME COMMENT '预计返回时间',
    `actual_return_time` DATETIME COMMENT '实际返回时间',
    `accompanier` VARCHAR(50) COMMENT '陪同人',
    `accompanier_phone` VARCHAR(20) COMMENT '陪同人电话',
    `destination` VARCHAR(200) COMMENT '目的地',
    `reason` VARCHAR(500) COMMENT '外出原因',
    `status` TINYINT DEFAULT 0 COMMENT '状态：0外出中 1已返回',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='外出登记表';

-- 8. 护理级别表
CREATE TABLE `care_level` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `level_name` VARCHAR(50) NOT NULL COMMENT '级别名称',
    `level_code` VARCHAR(20) UNIQUE COMMENT '级别编码',
    `description` TEXT COMMENT '级别描述',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_sort` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='护理级别表';

-- 9. 护理内容表
CREATE TABLE `care_item` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `item_name` VARCHAR(100) NOT NULL COMMENT '护理项目名称',
    `care_level_id` BIGINT COMMENT '所属护理级别ID',
    `frequency` VARCHAR(50) COMMENT '执行频率',
    `description` TEXT COMMENT '护理内容描述',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='护理内容表';

-- 10. 护理记录表
CREATE TABLE `care_record` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `elderly_id` BIGINT NOT NULL COMMENT '老人ID',
    `care_item_id` BIGINT NOT NULL COMMENT '护理项目ID',
    `record_date` DATE COMMENT '记录日期',
    `record_time` DATETIME COMMENT '记录时间',
    `status` TINYINT DEFAULT 0 COMMENT '状态：0待执行 1已执行 2跳过',
    `remark` TEXT COMMENT '备注',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='护理记录表';

-- 11. 膳食计划表（个性化）
CREATE TABLE `meal_plan` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `elderly_id` BIGINT NOT NULL COMMENT '老人ID',
    `dietary_restrictions` VARCHAR(500) COMMENT '饮食禁忌',
    `special_requirements` VARCHAR(500) COMMENT '特殊需求',
    `preference` VARCHAR(500) COMMENT '口味偏好',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='膳食计划表';

-- 12. 膳食日历表
CREATE TABLE `meal_calendar` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `meal_date` DATE NOT NULL COMMENT '日期',
    `meal_type` TINYINT NOT NULL COMMENT '餐次：1早餐 2午餐 3晚餐',
    `menu_content` TEXT NOT NULL COMMENT '菜单内容',
    `nutrition_info` TEXT COMMENT '营养信息',
    `remark` VARCHAR(500) COMMENT '备注',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `uk_date_type` (`meal_date`, `meal_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='膳食日历表';

-- 13. 老人膳食分配表
CREATE TABLE `elderly_meal` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `elderly_id` BIGINT NOT NULL COMMENT '老人ID',
    `calendar_id` BIGINT NOT NULL COMMENT '膳食日历ID',
    `is_custom` TINYINT DEFAULT 0 COMMENT '是否个性化：0否 1是',
    `custom_content` TEXT COMMENT '个性化内容',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='老人膳食分配表';

-- 14. 服务项目表
CREATE TABLE `service` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `service_name` VARCHAR(100) NOT NULL COMMENT '服务名称',
    `service_type` TINYINT COMMENT '服务类型：1基础服务 2增值服务 3医疗服务',
    `description` TEXT COMMENT '服务描述',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0停用 1启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_type` (`service_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='服务项目表';

-- 15. 服务关注表
CREATE TABLE `service_subscription` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `elderly_id` BIGINT NOT NULL COMMENT '老人ID',
    `service_id` BIGINT NOT NULL COMMENT '服务ID',
    `start_date` DATE COMMENT '开始日期',
    `end_date` DATE COMMENT '结束日期',
    `status` TINYINT DEFAULT 1 COMMENT '状态：1生效中 2已过期 3已取消',
    `remark` TEXT COMMENT '备注',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='服务关注表';

-- 添加外键约束
ALTER TABLE `bed` ADD FOREIGN KEY (`room_id`) REFERENCES `room`(`id`);
ALTER TABLE `elderly` ADD FOREIGN KEY (`care_level_id`) REFERENCES `care_level`(`id`);
ALTER TABLE `elderly` ADD FOREIGN KEY (`bed_id`) REFERENCES `bed`(`id`);
ALTER TABLE `check_in` ADD FOREIGN KEY (`elderly_id`) REFERENCES `elderly`(`id`);
ALTER TABLE `check_in` ADD FOREIGN KEY (`bed_id`) REFERENCES `bed`(`id`);
ALTER TABLE `check_out` ADD FOREIGN KEY (`elderly_id`) REFERENCES `elderly`(`id`);
ALTER TABLE `check_out` ADD FOREIGN KEY (`bed_id`) REFERENCES `bed`(`id`);
ALTER TABLE `outing` ADD FOREIGN KEY (`elderly_id`) REFERENCES `elderly`(`id`);
ALTER TABLE `care_item` ADD FOREIGN KEY (`care_level_id`) REFERENCES `care_level`(`id`);
ALTER TABLE `care_record` ADD FOREIGN KEY (`elderly_id`) REFERENCES `elderly`(`id`);
ALTER TABLE `care_record` ADD FOREIGN KEY (`care_item_id`) REFERENCES `care_item`(`id`);
ALTER TABLE `meal_plan` ADD FOREIGN KEY (`elderly_id`) REFERENCES `elderly`(`id`);
ALTER TABLE `elderly_meal` ADD FOREIGN KEY (`elderly_id`) REFERENCES `elderly`(`id`);
ALTER TABLE `elderly_meal` ADD FOREIGN KEY (`calendar_id`) REFERENCES `meal_calendar`(`id`);
ALTER TABLE `service_subscription` ADD FOREIGN KEY (`elderly_id`) REFERENCES `elderly`(`id`);
ALTER TABLE `service_subscription` ADD FOREIGN KEY (`service_id`) REFERENCES `service`(`id`);

-- ============================================
-- 创建统计视图
CREATE VIEW `v_elderly_statistics` AS
SELECT
    COUNT(*) as total_elderly,
    SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) as active_elderly,
    SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END) as checked_out_elderly,
    SUM(CASE WHEN gender = 1 THEN 1 ELSE 0 END) as male_count,
    SUM(CASE WHEN gender = 2 THEN 1 ELSE 0 END) as female_count
FROM elderly;

CREATE VIEW `v_bed_statistics` AS
SELECT
    COUNT(*) as total_beds,
    SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) as available_beds,
    SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) as occupied_beds
FROM bed;

-- 增量迁移（已有库执行）
-- ALTER TABLE `elderly` ADD COLUMN `country` VARCHAR(50) COMMENT '国家' AFTER `address`;
-- ALTER TABLE `elderly` ADD COLUMN `province` VARCHAR(50) COMMENT '省份' AFTER `country`;
-- ALTER TABLE `elderly` ADD COLUMN `city` VARCHAR(50) COMMENT '城市' AFTER `province`;
-- ALTER TABLE `elderly` ADD COLUMN `address_detail` VARCHAR(200) COMMENT '详细地址' AFTER `city`;

START TRANSACTION;

-- ============================================
-- Section 2: 基础种子数据
-- ============================================

-- user (3)
INSERT INTO `user` (`phone`, `password`, `real_name`, `age`, `gender`, `status`) VALUES
('13800138000', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/TU0532rSBHu', '管理员', 35, 1, 1),
('13900001001', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/TU0532rSBHu', '王护理', 28, 2, 1),
('13900001002', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/TU0532rSBHu', '李护理', 32, 1, 1);

-- care_level (4)
INSERT INTO `care_level` (`level_name`, `level_code`, `description`, `sort_order`) VALUES
('一级护理', 'LEVEL_1', '基本生活护理', 1),
('二级护理', 'LEVEL_2', '半护理，需部分协助', 2),
('三级护理', 'LEVEL_3', '全护理，需全面照顾', 3),
('特级护理', 'LEVEL_4', '特殊护理需求', 4);

-- care_item (53)
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('晨间护理', 1, '每日1次', '协助洗漱、整理床铺', 1);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('晚间护理', 1, '每日1次', '协助睡前洗漱', 2);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('测量血压', 2, '每日2次', '早晚各测量一次', 3);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('协助用餐', 2, '每日3次', '协助进食，观察饮食情况', 4);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('翻身护理', 3, '每2小时1次', '定时翻身，预防褥疮', 5);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('康复训练', 4, '每日1次', '专业康复训练', 6);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('口腔护理', 1, '每日2次', '协助刷牙、漱口', 10);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('指甲修剪', 1, '每周1次', '修剪手指甲、脚趾甲', 11);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('理发', 1, '每月1次', '基础理发服务', 12);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('换洗衣物', 1, '每日1次', '更换脏衣物', 13);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('房间整理', 1, '每日1次', '整理房间物品', 14);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('测量体温', 2, '每日2次', '早晚各测一次', 15);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('测量血糖', 2, '每日1次', '空腹血糖监测', 16);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('协助如厕', 2, '按需', '协助上厕所', 17);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('协助洗澡', 2, '每周2次', '协助洗浴', 18);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('皮肤检查', 2, '每日1次', '检查皮肤完整性', 19);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('饮水提醒', 2, '每日3次', '提醒适量饮水', 20);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('喂食', 3, '每日3次', '完全不能自理者喂食', 21);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('鼻饲护理', 3, '每日3次', '鼻饲管护理', 22);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('导尿管护理', 3, '每日2次', '导尿管清洁消毒', 23);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('压疮预防', 3, '每2小时1次', '翻身、按摩', 24);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('肢体按摩', 3, '每日2次', '促进血液循环', 25);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('被动运动', 3, '每日1次', '关节被动活动', 26);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('认知训练', 4, '每周3次', '记忆力、注意力训练', 27);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('语言训练', 4, '每周2次', '语言功能康复', 28);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('平衡训练', 4, '每周3次', '防跌倒训练', 29);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('步态训练', 4, '每周3次', '行走能力训练', 30);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('心理疏导', 4, '每周1次', '情绪支持与疏导', 31);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('疼痛评估', 2, '每日1次', '评估疼痛等级', 32);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('睡眠记录', 1, '每日1次', '记录睡眠质量', 33);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('排泄记录', 2, '每日1次', '记录大小便情况', 34);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('体重监测', 2, '每周1次', '监测体重变化', 35);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('血氧监测', 2, '每日1次', '指脉氧饱和度', 36);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('心电监测', 3, '每周1次', '心电图检查', 37);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('伤口换药', 3, '按需', '外科伤口护理', 38);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('胰岛素注射', 3, '每日1次', '协助胰岛素注射', 39);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('雾化吸入', 3, '每日2次', '呼吸道雾化治疗', 40);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('吸痰', 3, '按需', '气道吸痰护理', 41);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('临终关怀', 4, '持续', '生命末期舒适护理', 42);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('家属沟通', 1, '每周1次', '向家属反馈状况', 43);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('活动参与', 2, '每周2次', '组织参加文娱活动', 44);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('阳光浴', 2, '每周3次', '天气好时户外晒太阳', 45);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('足底按摩', 2, '每周2次', '促进血液循环', 46);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('耳部清洁', 1, '每周1次', '清洁外耳道', 47);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('眼部护理', 2, '每日1次', '清洁眼周', 48);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('会阴护理', 3, '每日1次', '会阴部清洁', 49);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('防坠床', 3, '持续', '床栏防护检查', 50);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('防走失', 2, '持续', '认知障碍者定位监护', 51);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('营养评估', 2, '每月1次', '评估营养状况', 52);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('跌倒风险评估', 2, '每月1次', 'Morse量表评估', 53);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('药物核对', 2, '每日1次', '核对用药清单', 54);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('陪同散步', 2, '每日1次', '园区散步30分钟', 55);
INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('读报陪聊', 2, '每周3次', '读书读报、聊天陪伴', 56);

-- ============================================
-- Section 3: 设施与扩展主数据
-- ============================================

-- room (25)
INSERT INTO room (room_no, room_type, floor, capacity, status, remark) VALUES
('101', 1, 1, 1, 1, '豪华单人间'),
('102', 2, 1, 2, 1, '标准双人间'),
('103', 2, 1, 2, 1, '标准双人间'),
('104', 3, 1, 4, 1, '经济多人间'),
('105', 3, 1, 4, 1, '经济多人间'),
('201', 1, 2, 1, 1, '豪华单人间'),
('202', 2, 2, 2, 1, '标准双人间'),
('203', 2, 2, 2, 1, '标准双人间'),
('204', 3, 2, 4, 1, '经济多人间'),
('205', 3, 2, 4, 1, '经济多人间'),
('301', 1, 3, 1, 1, '豪华单人间'),
('302', 2, 3, 2, 1, '标准双人间'),
('303', 2, 3, 2, 1, '标准双人间'),
('304', 3, 3, 4, 1, '经济多人间'),
('305', 3, 3, 4, 2, '经济多人间'),
('401', 1, 4, 1, 1, '豪华单人间'),
('402', 2, 4, 2, 1, '标准双人间'),
('403', 2, 4, 2, 1, '标准双人间'),
('404', 3, 4, 4, 1, '经济多人间'),
('405', 3, 4, 4, 1, '经济多人间'),
('501', 1, 5, 1, 1, '豪华单人间'),
('502', 2, 5, 2, 1, '标准双人间'),
('503', 2, 5, 2, 1, '标准双人间'),
('504', 3, 5, 4, 1, '经济多人间'),
('505', 3, 5, 4, 1, '经济多人间');

-- bed (65)
INSERT INTO bed (room_id, bed_no, status) VALUES
(1, 'A', 0),
(2, 'A', 0),
(2, 'B', 0),
(3, 'A', 0),
(3, 'B', 0),
(4, 'A', 0),
(4, 'B', 0),
(4, 'C', 0),
(4, 'D', 0),
(5, 'A', 0),
(5, 'B', 0),
(5, 'C', 0),
(5, 'D', 0),
(6, 'A', 0),
(7, 'A', 0),
(7, 'B', 0),
(8, 'A', 0),
(8, 'B', 0),
(9, 'A', 0),
(9, 'B', 0),
(9, 'C', 0),
(9, 'D', 0),
(10, 'A', 0),
(10, 'B', 0),
(10, 'C', 0),
(10, 'D', 0),
(11, 'A', 0),
(12, 'A', 0),
(12, 'B', 0),
(13, 'A', 0),
(13, 'B', 0),
(14, 'A', 0),
(14, 'B', 0),
(14, 'C', 0),
(14, 'D', 0),
(15, 'A', 0),
(15, 'B', 0),
(15, 'C', 0),
(15, 'D', 0),
(16, 'A', 0),
(17, 'A', 0),
(17, 'B', 0),
(18, 'A', 0),
(18, 'B', 0),
(19, 'A', 0),
(19, 'B', 0),
(19, 'C', 0),
(19, 'D', 0),
(20, 'A', 0),
(20, 'B', 0),
(20, 'C', 0),
(20, 'D', 0),
(21, 'A', 0),
(22, 'A', 0),
(22, 'B', 0),
(23, 'A', 0),
(23, 'B', 0),
(24, 'A', 0),
(24, 'B', 0),
(24, 'C', 0),
(24, 'D', 0),
(25, 'A', 0),
(25, 'B', 0),
(25, 'C', 0),
(25, 'D', 0);

-- service (25)
INSERT INTO service (service_name, service_type, description, status) VALUES
('每日健康巡检', 1, '护理员每日两次测量体温、血压', 1),
('房间清洁消毒', 1, '每周深度清洁两次', 1),
('洗衣服务', 1, '衣物清洗、熨烫、整理', 1),
('24小时呼叫响应', 1, '床头呼叫铃即时响应', 1),
('助浴服务', 2, '专业护理员协助洗浴', 1),
('理发修面', 2, '每月定期理发修面', 1),
('老年大学课程', 2, '书法、绘画、合唱等文娱活动', 0),
('生日关怀', 2, '生日当天赠送蛋糕和祝福', 1),
('陪同就医', 3, '专人陪同前往医院复诊', 1),
('康复理疗', 3, '物理治疗、按摩理疗', 1),
('心理咨询', 3, '专业心理咨询师定期访谈', 1),
('营养配餐指导', 3, '营养师定制膳食方案', 1),
('远程视频探视', 2, '协助家属视频连线', 1),
('口腔护理', 1, '每日口腔清洁护理', 1),
('翻身拍背', 1, '卧床老人定时翻身拍背', 1),
('吸氧服务', 3, '低流量吸氧监护', 1),
('血糖监测', 3, '每日三餐前后血糖记录', 1),
('用药提醒', 1, '按时发放并监督服药', 1),
('散步陪伴', 2, '天气适宜时陪同园区散步', 1),
('节令关怀', 2, '传统节日慰问与活动', 1),
('健康咨询', 3, '提供日常健康咨询服务', 1),
('文娱活动', 2, '组织文化娱乐活动', 1),
('每日健康巡检（补充1）', 1, '护理员每日两次测量体温、血压', 0),
('房间清洁消毒（补充2）', 1, '每周深度清洁两次', 0),
('洗衣服务（补充3）', 1, '衣物清洗、熨烫、整理', 1);

-- ============================================
-- Section 4: 核心业务 Mock 数据
-- ============================================

-- elderly (70)
INSERT INTO elderly (name, phone, gender, age, id_card, country, province, city, address_detail, address, health_condition, allergy_info, emergency_contact, emergency_phone, care_level_id, status, check_in_date, create_time) VALUES
('罗军', '13991667475', 1, 82, '210302194404209050', '中国', '辽宁省', '鞍山市', '铁东区浑南中路138号5单元944室', '中国辽宁省鞍山市铁东区浑南中路138号5单元944室', '听力下降，需大声交流', '无', '戴秀', '13726113511', 3, 1, '2025-04-18', '2025-04-18 00:00:17'),
('陆玉', '13665861570', 2, 81, '210102194501265342', '中国', '辽宁省', '沈阳市', '和平区三好街99号3单元512室', '中国辽宁省沈阳市和平区三好街99号3单元512室', '听力下降，需大声交流', '海鲜过敏', '白强', '13633515403', 4, 1, '2025-08-18', '2025-08-18 00:00:30'),
('孙桂', '13694588181', 2, 69, '210302195706083287', '中国', '辽宁省', '鞍山市', '铁东区北陵大街79号1单元1396室', '中国辽宁省鞍山市铁东区北陵大街79号1单元1396室', '轻度认知障碍，需专人看护', '磺胺类药物过敏', '文龙', '15881184004', 2, 1, '2024-08-24', '2024-08-24 00:00:23'),
('宋明', '15098955738', 1, 76, '220104195010123062', '中国', '吉林省', '长春市', '朝阳区建设大路20号3单元1133室', '中国吉林省长春市朝阳区建设大路20号3单元1133室', '关节炎，上下楼梯需协助', '青霉素过敏', '林建', '18810156634', 2, 1, '2025-04-19', '2025-04-19 00:00:15'),
('冯兰', '13745854761', 2, 80, '220104194612257492', '中国', '吉林省', '长春市', '朝阳区沈辽路197号5单元226室', '中国吉林省长春市朝阳区沈辽路197号5单元226室', '帕金森早期，需康复训练', '无', '蔡英', '18857038727', 3, 1, '2025-09-08', '2025-09-08 00:00:02'),
('周永', '15040374466', 1, 72, '210302195402176001', '中国', '辽宁省', '鞍山市', '铁东区三好街4号6单元1922室', '中国辽宁省鞍山市铁东区三好街4号6单元1922室', '白内障术后，视力尚可', '无', '卢兰', '15941652410', 2, 1, '2024-12-17', '2024-12-17 00:00:06'),
('沈英', '15152629047', 2, 81, '220104194504098133', '中国', '吉林省', '长春市', '朝阳区文化路100号2单元2008室', '中国吉林省长春市朝阳区文化路100号2单元2008室', '高血压，需每日监测血压', '海鲜过敏', '史文', '15817582468', 3, 1, '2026-05-13', '2026-05-13 00:00:48'),
('魏建', '15159386437', 1, 76, '210103195002222556', '中国', '辽宁省', '沈阳市', '沈河区北陵大街76号5单元154室', '中国辽宁省沈阳市沈河区北陵大街76号5单元154室', '健康状况良好，生活可自理', '青霉素过敏', '贺娟', '15972616068', 4, 1, '2024-11-07', '2024-11-07 00:00:45'),
('黎秀', '15997197381', 2, 89, '210102193705089740', '中国', '辽宁省', '沈阳市', '和平区三好街98号2单元144室', '中国辽宁省沈阳市和平区三好街98号2单元144室', '慢性支气管炎，冬季需注意保暖', '无', '蔡云', '13972593763', 1, 1, '2025-03-16', '2025-03-16 00:00:29'),
('吕珍', '18734817900', 2, 94, '220104193202244417', '中国', '吉林省', '长春市', '朝阳区和平北街85号5单元1731室', '中国吉林省长春市朝阳区和平北街85号5单元1731室', '2型糖尿病，饮食需控糖', '牛奶不耐受', '于珍', '15875312698', 3, 1, '2025-09-09', '2025-09-09 00:00:52'),
('文英', '15825190402', 2, 69, '210103195703152957', '中国', '辽宁省', '沈阳市', '沈河区青年大街34号6单元604室', '中国辽宁省沈阳市沈河区青年大街34号6单元604室', '骨质疏松，防跌倒', '无', '罗明', '15875374832', 2, 1, '2024-11-08', '2024-11-08 00:00:12'),
('赵龙', '18734957917', 1, 79, '210102194712108404', '中国', '辽宁省', '沈阳市', '和平区建设大路108号5单元2430室', '中国辽宁省沈阳市和平区建设大路108号5单元2430室', '2型糖尿病，饮食需控糖', '无', '傅英', '13929898190', 1, 1, '2025-01-07', '2025-01-07 00:00:38'),
('丁淑', '13786359548', 2, 87, '210202193902065235', '中国', '辽宁省', '大连市', '中山区建设大路121号5单元684室', '中国辽宁省大连市中山区建设大路121号5单元684室', '听力下降，需大声交流', '海鲜过敏', '孟明', '13736553796', 4, 1, '2026-01-24', '2026-01-24 00:00:40'),
('许强', '18764394426', 1, 69, '210102195705108338', '中国', '辽宁省', '沈阳市', '和平区青年大街197号6单元2091室', '中国辽宁省沈阳市和平区青年大街197号6单元2091室', '听力下降，需大声交流', '无', '姚伟', '15928377843', 2, 1, '2025-10-21', '2025-10-21 00:00:36'),
('夏桂', '18782948122', 2, 86, '210202194001233901', '中国', '辽宁省', '大连市', '中山区三好街19号5单元1777室', '中国辽宁省大连市中山区三好街19号5单元1777室', '轻度认知障碍，需专人看护', '无', '常华', '15939069454', 1, 1, '2024-11-29', '2024-11-29 00:00:24'),
('李德', '13984568975', 1, 73, '210302195312179355', '中国', '辽宁省', '鞍山市', '铁东区青年大街181号2单元1380室', '中国辽宁省鞍山市铁东区青年大街181号2单元1380室', '听力下降，需大声交流', '青霉素过敏', '黄涛', '18723595179', 1, 1, '2025-07-05', '2025-07-05 00:00:13'),
('唐桂', '13926241142', 2, 82, '210202194411229257', '中国', '辽宁省', '大连市', '中山区文化路16号4单元1667室', '中国辽宁省大连市中山区文化路16号4单元1667室', '帕金森早期，需康复训练', '无', '龚娟', '13785820559', 4, 1, '2025-02-01', '2025-02-01 00:00:01'),
('林秀', '13734133106', 2, 72, '210103195407046495', '中国', '辽宁省', '沈阳市', '沈河区和平北街35号4单元1629室', '中国辽宁省沈阳市沈河区和平北街35号4单元1629室', '高血压，需每日监测血压', '无', '梁强', '13780744395', 4, 1, '2026-01-26', '2026-01-26 00:00:07'),
('曾建', '15083611448', 1, 86, '210103194003285165', '中国', '辽宁省', '沈阳市', '沈河区文化路110号5单元1714室', '中国辽宁省沈阳市沈河区文化路110号5单元1714室', '骨质疏松，防跌倒', '青霉素过敏', '戴英', '15899320176', 4, 1, '2026-02-24', '2026-02-24 00:00:14'),
('万明', '18812529842', 1, 87, '210302193907059217', '中国', '辽宁省', '鞍山市', '铁东区青年大街142号4单元316室', '中国辽宁省鞍山市铁东区青年大街142号4单元316室', '冠心病，行动略不便', '花粉过敏', '杜秀', '18878104873', 4, 1, '2024-07-09', '2024-07-09 00:00:52'),
('邵德', '15044763492', 1, 73, '210302195312142520', '中国', '辽宁省', '鞍山市', '铁东区望花街179号4单元873室', '中国辽宁省鞍山市铁东区望花街179号4单元873室', '术后恢复中，需定期换药', '无', '邵海', '15963050355', 2, 1, '2025-09-08', '2025-09-08 00:00:22'),
('康志', '18884719338', 1, 95, '210102193105193586', '中国', '辽宁省', '沈阳市', '和平区浑南中路9号5单元130室', '中国辽宁省沈阳市和平区浑南中路9号5单元130室', '慢性支气管炎，冬季需注意保暖', '海鲜过敏', '田丽', '13989720598', 4, 1, '2024-09-04', '2024-09-04 00:00:34'),
('贺梅', '15170930372', 2, 70, '210103195602021674', '中国', '辽宁省', '沈阳市', '沈河区望花街170号3单元2170室', '中国辽宁省沈阳市沈河区望花街170号3单元2170室', '2型糖尿病，饮食需控糖', '青霉素过敏', '常龙', '13613865603', 3, 1, '2025-09-20', '2025-09-20 00:00:57'),
('邓永', '15878936714', 1, 73, '220104195312026927', '中国', '吉林省', '长春市', '朝阳区浑南中路72号6单元2102室', '中国吉林省长春市朝阳区浑南中路72号6单元2102室', '2型糖尿病，饮食需控糖', '花粉过敏', '蒋娟', '13931022590', 4, 1, '2026-03-12', '2026-03-12 00:00:42'),
('唐玉', '15163218677', 2, 90, '210302193608236507', '中国', '辽宁省', '鞍山市', '铁东区浑南中路71号3单元311室', '中国辽宁省鞍山市铁东区浑南中路71号3单元311室', '冠心病，行动略不便', '无', '钱珍', '15887853697', 2, 1, '2024-07-11', '2024-07-11 00:00:58'),
('李玉', '15180459025', 2, 94, '210202193204261446', '中国', '辽宁省', '大连市', '中山区文化路170号6单元564室', '中国辽宁省大连市中山区文化路170号6单元564室', '高血压，需每日监测血压', '无', '顾强', '13864185894', 2, 1, '2026-05-24', '2026-05-24 00:00:59'),
('罗德', '13772125156', 1, 80, '220104194608196304', '中国', '吉林省', '长春市', '朝阳区建设大路39号5单元1332室', '中国吉林省长春市朝阳区建设大路39号5单元1332室', '术后恢复中，需定期换药', '无', '萧军', '13936018644', 1, 1, '2026-05-22', '2026-05-22 00:00:54'),
('汪明', '15115328656', 1, 77, '210202194904099566', '中国', '辽宁省', '大连市', '中山区文化路89号3单元1882室', '中国辽宁省大连市中山区文化路89号3单元1882室', '听力下降，需大声交流', '无', '邱兰', '18757558193', 4, 1, '2024-07-05', '2024-07-05 00:00:19'),
('余兰', '13654846092', 2, 84, '210102194205084037', '中国', '辽宁省', '沈阳市', '和平区文化路52号5单元1570室', '中国辽宁省沈阳市和平区文化路52号5单元1570室', '白内障术后，视力尚可', '海鲜过敏', '黎国', '18774040554', 1, 1, '2024-12-02', '2024-12-02 00:00:38'),
('江强', '13823649205', 1, 95, '210102193108027963', '中国', '辽宁省', '沈阳市', '和平区浑南中路167号5单元2444室', '中国辽宁省沈阳市和平区浑南中路167号5单元2444室', '关节炎，上下楼梯需协助', '花粉过敏', '龚建', '18756950537', 4, 1, '2026-04-19', '2026-04-19 00:00:08'),
('叶强', '18780236685', 1, 90, '220104193601073108', '中国', '吉林省', '长春市', '朝阳区三好街2号6单元2356室', '中国吉林省长春市朝阳区三好街2号6单元2356室', '冠心病，行动略不便', '无', '谭兰', '15035979625', 3, 1, '2024-10-29', '2024-10-29 00:00:58'),
('廖英', '13745230578', 2, 80, '210103194609178663', '中国', '辽宁省', '沈阳市', '沈河区文化路12号1单元1520室', '中国辽宁省沈阳市沈河区文化路12号1单元1520室', '骨质疏松，防跌倒', '海鲜过敏', '顾桂', '13638783093', 1, 1, '2024-10-28', '2024-10-28 00:00:46'),
('乔明', '15848555177', 1, 80, '210102194607287886', '中国', '辽宁省', '沈阳市', '和平区文化路34号3单元936室', '中国辽宁省沈阳市和平区文化路34号3单元936室', '轻度认知障碍，需专人看护', '花粉过敏', '龙强', '13891926981', 3, 1, '2025-06-11', '2025-06-11 00:00:21'),
('宋平', '13695321502', 1, 89, '210103193711215749', '中国', '辽宁省', '沈阳市', '沈河区文化路115号1单元2467室', '中国辽宁省沈阳市沈河区文化路115号1单元2467室', '轻度认知障碍，需专人看护', '无', '方建', '13859828765', 4, 1, '2025-09-28', '2025-09-28 00:00:36'),
('侯兰', '13666825487', 2, 79, '210302194704142050', '中国', '辽宁省', '鞍山市', '铁东区三好街1号2单元2156室', '中国辽宁省鞍山市铁东区三好街1号2单元2156室', '术后恢复中，需定期换药', '海鲜过敏', '熊平', '13735292315', 2, 1, '2024-11-18', '2024-11-18 00:00:18'),
('薛云', '18889203981', 1, 69, '210102195712209927', '中国', '辽宁省', '沈阳市', '和平区望花街172号4单元239室', '中国辽宁省沈阳市和平区望花街172号4单元239室', '2型糖尿病，饮食需控糖', '无', '蒋涛', '15055073629', 1, 1, '2026-02-19', '2026-02-19 00:00:09'),
('雷娟', '15943484725', 2, 78, '210302194803183509', '中国', '辽宁省', '鞍山市', '铁东区浑南中路24号5单元223室', '中国辽宁省鞍山市铁东区浑南中路24号5单元223室', '冠心病，行动略不便', '磺胺类药物过敏', '曾明', '18796212327', 4, 1, '2024-09-22', '2024-09-22 00:00:40'),
('姜英', '13937019229', 2, 93, '220104193303233283', '中国', '吉林省', '长春市', '朝阳区沈辽路122号4单元659室', '中国吉林省长春市朝阳区沈辽路122号4单元659室', '听力下降，需大声交流', '青霉素过敏', '赵建', '15015890774', 4, 1, '2024-12-04', '2024-12-04 00:00:36'),
('罗珍', '15123261216', 2, 83, '210302194307154671', '中国', '辽宁省', '鞍山市', '铁东区建设大路126号4单元111室', '中国辽宁省鞍山市铁东区建设大路126号4单元111室', '帕金森早期，需康复训练', '无', '石强', '15143411293', 3, 1, '2024-08-21', '2024-08-21 00:00:40'),
('潘德', '18824093825', 1, 74, '210202195211057112', '中国', '辽宁省', '大连市', '中山区南京街31号6单元1606室', '中国辽宁省大连市中山区南京街31号6单元1606室', '听力下降，需大声交流', '花粉过敏', '史珍', '13760392978', 4, 1, '2025-09-16', '2025-09-16 00:00:38'),
('杨桂', '15986665133', 2, 74, '210102195212159062', '中国', '辽宁省', '沈阳市', '和平区青年大街137号5单元2460室', '中国辽宁省沈阳市和平区青年大街137号5单元2460室', '2型糖尿病，饮食需控糖', '磺胺类药物过敏', '钟德', '15876673542', 2, 1, '2026-05-09', '2026-05-09 00:00:38'),
('林芳', '15041564933', 2, 75, '210302195106141068', '中国', '辽宁省', '鞍山市', '铁东区和平北街105号3单元1854室', '中国辽宁省鞍山市铁东区和平北街105号3单元1854室', '2型糖尿病，饮食需控糖', '无', '戴丽', '18714755793', 4, 1, '2024-08-05', '2024-08-05 00:00:23'),
('周德', '13976379521', 1, 84, '210103194205062358', '中国', '辽宁省', '沈阳市', '沈河区望花街129号1单元679室', '中国辽宁省沈阳市沈河区望花街129号1单元679室', '高血压，需每日监测血压', '牛奶不耐受', '冯珍', '15063269318', 2, 1, '2026-04-30', '2026-04-30 00:00:35'),
('乔龙', '15140802052', 1, 80, '220104194602185599', '中国', '吉林省', '长春市', '朝阳区青年大街173号3单元1811室', '中国吉林省长春市朝阳区青年大街173号3单元1811室', '术后恢复中，需定期换药', '无', '叶英', '13753718736', 2, 1, '2026-01-19', '2026-01-19 00:00:46'),
('侯海', '13643716080', 1, 86, '210102194007234010', '中国', '辽宁省', '沈阳市', '和平区浑南中路123号6单元2097室', '中国辽宁省沈阳市和平区浑南中路123号6单元2097室', '帕金森早期，需康复训练', '海鲜过敏', '傅淑', '13942773100', 3, 1, '2024-11-24', '2024-11-24 00:00:37'),
('侯秀', '15199732029', 2, 86, '210102194008057050', '中国', '辽宁省', '沈阳市', '和平区北陵大街179号5单元1864室', '中国辽宁省沈阳市和平区北陵大街179号5单元1864室', '术后恢复中，需定期换药', '无', '陆华', '13784826722', 3, 1, '2025-12-11', '2025-12-11 00:00:19'),
('吕娟', '13929350066', 2, 83, '210103194310246819', '中国', '辽宁省', '沈阳市', '沈河区三好街189号6单元256室', '中国辽宁省沈阳市沈河区三好街189号6单元256室', '帕金森早期，需康复训练', '牛奶不耐受', '孟国', '13970757874', 2, 1, '2024-12-03', '2024-12-03 00:00:59'),
('段淑', '15994742312', 2, 82, '210202194409235317', '中国', '辽宁省', '大连市', '中山区三好街118号2单元1917室', '中国辽宁省大连市中山区三好街118号2单元1917室', '听力下降，需大声交流', '海鲜过敏', '侯丽', '18854566011', 2, 1, '2024-12-09', '2024-12-09 00:00:19'),
('陈明', '15051546102', 1, 90, '210302193612199964', '中国', '辽宁省', '鞍山市', '铁东区文化路1号2单元768室', '中国辽宁省鞍山市铁东区文化路1号2单元768室', '轻度认知障碍，需专人看护', '牛奶不耐受', '雷平', '15820397424', 4, 1, '2024-10-16', '2024-10-16 00:00:21'),
('胡桂', '15971366584', 2, 92, '210103193409163759', '中国', '辽宁省', '沈阳市', '沈河区沈辽路74号3单元609室', '中国辽宁省沈阳市沈河区沈辽路74号3单元609室', '慢性支气管炎，冬季需注意保暖', '花粉过敏', '陆兰', '15858804089', 2, 1, '2024-11-20', '2024-11-20 00:00:22'),
('任英', '13938785361', 2, 89, '220104193708192754', '中国', '吉林省', '长春市', '朝阳区青年大街39号2单元1509室', '中国吉林省长春市朝阳区青年大街39号2单元1509室', '冠心病，行动略不便', '海鲜过敏', '苏文', '13829118050', 2, 1, '2025-07-19', '2025-07-19 00:00:09'),
('潘斌', '13918181751', 1, 81, '210302194501254606', '中国', '辽宁省', '鞍山市', '铁东区南京街147号3单元763室', '中国辽宁省鞍山市铁东区南京街147号3单元763室', '冠心病，行动略不便', '无', '孔丽', '13735360910', 1, 1, '2024-10-05', '2024-10-05 00:00:03'),
('白淑', '15846885992', 2, 92, '220104193411285124', '中国', '吉林省', '长春市', '朝阳区沈辽路75号3单元361室', '中国吉林省长春市朝阳区沈辽路75号3单元361室', '轻度认知障碍，需专人看护', '牛奶不耐受', '侯华', '13839778295', 4, 1, '2025-12-19', '2025-12-19 00:00:17'),
('邓杰', '15144636859', 1, 77, '210103194904211544', '中国', '辽宁省', '沈阳市', '沈河区沈辽路170号2单元1544室', '中国辽宁省沈阳市沈河区沈辽路170号2单元1544室', '骨质疏松，防跌倒', '青霉素过敏', '戴珍', '18860105920', 3, 1, '2026-05-29', '2026-05-29 00:00:31'),
('黎斌', '13843394656', 1, 93, '210103193308152100', '中国', '辽宁省', '沈阳市', '沈河区北陵大街13号1单元1405室', '中国辽宁省沈阳市沈河区北陵大街13号1单元1405室', '术后恢复中，需定期换药', '海鲜过敏', '熊国', '15012885317', 1, 1, '2025-12-31', '2025-12-31 00:00:48'),
('余国', '18710871987', 1, 71, '210103195502206002', '中国', '辽宁省', '沈阳市', '沈河区青年大街4号3单元2050室', '中国辽宁省沈阳市沈河区青年大街4号3单元2050室', '冠心病，行动略不便', '无', '余华', '18842745958', 4, 2, '2024-10-06', '2024-10-06 00:00:29'),
('郭明', '15814243800', 1, 95, '210103193105182365', '中国', '辽宁省', '沈阳市', '沈河区南京街199号2单元1565室', '中国辽宁省沈阳市沈河区南京街199号2单元1565室', '术后恢复中，需定期换药', '无', '邹桂', '15118262288', 1, 2, '2026-04-27', '2026-04-27 00:00:34'),
('陆明', '18769190800', 1, 79, '210202194701284395', '中国', '辽宁省', '大连市', '中山区文化路164号4单元1737室', '中国辽宁省大连市中山区文化路164号4单元1737室', '慢性支气管炎，冬季需注意保暖', '无', '毛龙', '15839663487', 1, 2, '2025-12-27', '2025-12-27 00:00:48'),
('黄建', '13772772024', 1, 95, '210302193109107458', '中国', '辽宁省', '鞍山市', '铁东区沈辽路72号1单元621室', '中国辽宁省鞍山市铁东区沈辽路72号1单元621室', '冠心病，行动略不便', '花粉过敏', '潘秀', '13714394728', 4, 2, '2025-11-13', '2025-11-13 00:00:31'),
('罗俊', '13663351937', 1, 80, '220104194602135617', '中国', '吉林省', '长春市', '朝阳区青年大街126号2单元833室', '中国吉林省长春市朝阳区青年大街126号2单元833室', '慢性支气管炎，冬季需注意保暖', '无', '许华', '18729159614', 4, 2, '2024-07-27', '2024-07-27 00:00:18'),
('谭明', '15816673395', 1, 87, '210103193910104336', '中国', '辽宁省', '沈阳市', '沈河区北陵大街162号4单元1713室', '中国辽宁省沈阳市沈河区北陵大街162号4单元1713室', '骨质疏松，防跌倒', '花粉过敏', '姜桂', '15845726117', 1, 2, '2024-07-29', '2024-07-29 00:00:42'),
('汤云', '15899043767', 1, 85, '210103194102042278', '中国', '辽宁省', '沈阳市', '沈河区三好街145号6单元1152室', '中国辽宁省沈阳市沈河区三好街145号6单元1152室', '帕金森早期，需康复训练', '无', '傅华', '18890634583', 1, 2, '2025-07-06', '2025-07-06 00:00:39'),
('杨强', '18874548302', 1, 81, '210103194504077364', '中国', '辽宁省', '沈阳市', '沈河区青年大街82号1单元1330室', '中国辽宁省沈阳市沈河区青年大街82号1单元1330室', '冠心病，行动略不便', '无', '毛龙', '13662041547', 1, 2, '2025-02-11', '2025-02-11 00:00:41'),
('万志', '13784785998', 1, 74, '210102195203121866', '中国', '辽宁省', '沈阳市', '和平区三好街41号5单元1162室', '中国辽宁省沈阳市和平区三好街41号5单元1162室', '慢性支气管炎，冬季需注意保暖', '海鲜过敏', '谭秀', '15967691147', 4, 2, '2025-03-21', '2025-03-21 00:00:27'),
('姚建', '18812454472', 1, 78, '210202194812033137', '中国', '辽宁省', '大连市', '中山区北陵大街89号6单元552室', '中国辽宁省大连市中山区北陵大街89号6单元552室', '2型糖尿病，饮食需控糖', '牛奶不耐受', '魏涛', '13683469960', 3, 2, '2025-01-10', '2025-01-10 00:00:39'),
('钟龙', '18819174813', 1, 94, '220104193206061471', '中国', '吉林省', '长春市', '朝阳区南京街38号4单元1425室', '中国吉林省长春市朝阳区南京街38号4单元1425室', '白内障术后，视力尚可', '牛奶不耐受', '田平', '18860709750', 2, 2, '2024-12-24', '2024-12-24 00:00:01'),
('汪桂', '15888677715', 2, 78, '210102194812244297', '中国', '辽宁省', '沈阳市', '和平区和平北街88号6单元2300室', '中国辽宁省沈阳市和平区和平北街88号6单元2300室', '白内障术后，视力尚可', '青霉素过敏', '孙兰', '18754878904', 3, 2, '2024-09-27', '2024-09-27 00:00:45'),
('胡丽', '13948302336', 2, 92, '210202193408259335', '中国', '辽宁省', '大连市', '中山区望花街30号3单元1052室', '中国辽宁省大连市中山区望花街30号3单元1052室', '2型糖尿病，饮食需控糖', '无', '余建', '15887212066', 2, 2, '2025-06-05', '2025-06-05 00:00:36'),
('胡国', '13775495128', 1, 93, '210302193310146471', '中国', '辽宁省', '鞍山市', '铁东区望花街109号3单元1110室', '中国辽宁省鞍山市铁东区望花街109号3单元1110室', '轻度认知障碍，需专人看护', '磺胺类药物过敏', '周斌', '15816438749', 2, 2, '2025-10-17', '2025-10-17 00:00:37'),
('邵桂', '13785090384', 2, 85, '210102194111171713', '中国', '辽宁省', '沈阳市', '和平区青年大街135号1单元968室', '中国辽宁省沈阳市和平区青年大街135号1单元968室', '帕金森早期，需康复训练', '青霉素过敏', '乔桂', '15931165364', 2, 2, '2025-12-18', '2025-12-18 00:00:19');

-- Section 5: 床位分配与入住登记
UPDATE bed SET status=1, elderly_id=1 WHERE id=1;
UPDATE elderly SET bed_id=1 WHERE id=1;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (1, 1, '2025-04-18', '正常入住登记');
UPDATE bed SET status=1, elderly_id=2 WHERE id=2;
UPDATE elderly SET bed_id=2 WHERE id=2;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (2, 2, '2025-08-18', '正常入住登记');
UPDATE bed SET status=1, elderly_id=3 WHERE id=3;
UPDATE elderly SET bed_id=3 WHERE id=3;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (3, 3, '2024-08-24', '正常入住登记');
UPDATE bed SET status=1, elderly_id=4 WHERE id=4;
UPDATE elderly SET bed_id=4 WHERE id=4;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (4, 4, '2025-04-19', '正常入住登记');
UPDATE bed SET status=1, elderly_id=5 WHERE id=5;
UPDATE elderly SET bed_id=5 WHERE id=5;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (5, 5, '2025-09-08', '正常入住登记');
UPDATE bed SET status=1, elderly_id=6 WHERE id=6;
UPDATE elderly SET bed_id=6 WHERE id=6;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (6, 6, '2024-12-17', '正常入住登记');
UPDATE bed SET status=1, elderly_id=7 WHERE id=7;
UPDATE elderly SET bed_id=7 WHERE id=7;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (7, 7, '2026-05-13', '正常入住登记');
UPDATE bed SET status=1, elderly_id=8 WHERE id=8;
UPDATE elderly SET bed_id=8 WHERE id=8;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (8, 8, '2024-11-07', '正常入住登记');
UPDATE bed SET status=1, elderly_id=9 WHERE id=9;
UPDATE elderly SET bed_id=9 WHERE id=9;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (9, 9, '2025-03-16', '正常入住登记');
UPDATE bed SET status=1, elderly_id=10 WHERE id=10;
UPDATE elderly SET bed_id=10 WHERE id=10;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (10, 10, '2025-09-09', '正常入住登记');
UPDATE bed SET status=1, elderly_id=11 WHERE id=11;
UPDATE elderly SET bed_id=11 WHERE id=11;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (11, 11, '2024-11-08', '正常入住登记');
UPDATE bed SET status=1, elderly_id=12 WHERE id=12;
UPDATE elderly SET bed_id=12 WHERE id=12;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (12, 12, '2025-01-07', '正常入住登记');
UPDATE bed SET status=1, elderly_id=13 WHERE id=13;
UPDATE elderly SET bed_id=13 WHERE id=13;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (13, 13, '2026-01-24', '正常入住登记');
UPDATE bed SET status=1, elderly_id=14 WHERE id=14;
UPDATE elderly SET bed_id=14 WHERE id=14;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (14, 14, '2025-10-21', '正常入住登记');
UPDATE bed SET status=1, elderly_id=15 WHERE id=15;
UPDATE elderly SET bed_id=15 WHERE id=15;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (15, 15, '2024-11-29', '正常入住登记');
UPDATE bed SET status=1, elderly_id=16 WHERE id=16;
UPDATE elderly SET bed_id=16 WHERE id=16;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (16, 16, '2025-07-05', '正常入住登记');
UPDATE bed SET status=1, elderly_id=17 WHERE id=17;
UPDATE elderly SET bed_id=17 WHERE id=17;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (17, 17, '2025-02-01', '正常入住登记');
UPDATE bed SET status=1, elderly_id=18 WHERE id=18;
UPDATE elderly SET bed_id=18 WHERE id=18;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (18, 18, '2026-01-26', '正常入住登记');
UPDATE bed SET status=1, elderly_id=19 WHERE id=19;
UPDATE elderly SET bed_id=19 WHERE id=19;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (19, 19, '2026-02-24', '正常入住登记');
UPDATE bed SET status=1, elderly_id=20 WHERE id=20;
UPDATE elderly SET bed_id=20 WHERE id=20;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (20, 20, '2024-07-09', '正常入住登记');
UPDATE bed SET status=1, elderly_id=21 WHERE id=21;
UPDATE elderly SET bed_id=21 WHERE id=21;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (21, 21, '2025-09-08', '正常入住登记');
UPDATE bed SET status=1, elderly_id=22 WHERE id=22;
UPDATE elderly SET bed_id=22 WHERE id=22;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (22, 22, '2024-09-04', '正常入住登记');
UPDATE bed SET status=1, elderly_id=23 WHERE id=23;
UPDATE elderly SET bed_id=23 WHERE id=23;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (23, 23, '2025-09-20', '正常入住登记');
UPDATE bed SET status=1, elderly_id=24 WHERE id=24;
UPDATE elderly SET bed_id=24 WHERE id=24;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (24, 24, '2026-03-12', '正常入住登记');
UPDATE bed SET status=1, elderly_id=25 WHERE id=25;
UPDATE elderly SET bed_id=25 WHERE id=25;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (25, 25, '2024-07-11', '正常入住登记');
UPDATE bed SET status=1, elderly_id=26 WHERE id=26;
UPDATE elderly SET bed_id=26 WHERE id=26;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (26, 26, '2026-05-24', '正常入住登记');
UPDATE bed SET status=1, elderly_id=27 WHERE id=27;
UPDATE elderly SET bed_id=27 WHERE id=27;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (27, 27, '2026-05-22', '正常入住登记');
UPDATE bed SET status=1, elderly_id=28 WHERE id=28;
UPDATE elderly SET bed_id=28 WHERE id=28;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (28, 28, '2024-07-05', '正常入住登记');
UPDATE bed SET status=1, elderly_id=29 WHERE id=29;
UPDATE elderly SET bed_id=29 WHERE id=29;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (29, 29, '2024-12-02', '正常入住登记');
UPDATE bed SET status=1, elderly_id=30 WHERE id=30;
UPDATE elderly SET bed_id=30 WHERE id=30;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (30, 30, '2026-04-19', '正常入住登记');
UPDATE bed SET status=1, elderly_id=31 WHERE id=31;
UPDATE elderly SET bed_id=31 WHERE id=31;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (31, 31, '2024-10-29', '正常入住登记');
UPDATE bed SET status=1, elderly_id=32 WHERE id=32;
UPDATE elderly SET bed_id=32 WHERE id=32;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (32, 32, '2024-10-28', '正常入住登记');
UPDATE bed SET status=1, elderly_id=33 WHERE id=33;
UPDATE elderly SET bed_id=33 WHERE id=33;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (33, 33, '2025-06-11', '正常入住登记');
UPDATE bed SET status=1, elderly_id=34 WHERE id=34;
UPDATE elderly SET bed_id=34 WHERE id=34;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (34, 34, '2025-09-28', '正常入住登记');
UPDATE bed SET status=1, elderly_id=35 WHERE id=35;
UPDATE elderly SET bed_id=35 WHERE id=35;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (35, 35, '2024-11-18', '正常入住登记');
UPDATE bed SET status=1, elderly_id=36 WHERE id=40;
UPDATE elderly SET bed_id=40 WHERE id=36;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (36, 40, '2026-02-19', '正常入住登记');
UPDATE bed SET status=1, elderly_id=37 WHERE id=41;
UPDATE elderly SET bed_id=41 WHERE id=37;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (37, 41, '2024-09-22', '正常入住登记');
UPDATE bed SET status=1, elderly_id=38 WHERE id=42;
UPDATE elderly SET bed_id=42 WHERE id=38;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (38, 42, '2024-12-04', '正常入住登记');
UPDATE bed SET status=1, elderly_id=39 WHERE id=43;
UPDATE elderly SET bed_id=43 WHERE id=39;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (39, 43, '2024-08-21', '正常入住登记');
UPDATE bed SET status=1, elderly_id=40 WHERE id=44;
UPDATE elderly SET bed_id=44 WHERE id=40;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (40, 44, '2025-09-16', '正常入住登记');
UPDATE bed SET status=1, elderly_id=41 WHERE id=45;
UPDATE elderly SET bed_id=45 WHERE id=41;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (41, 45, '2026-05-09', '正常入住登记');
UPDATE bed SET status=1, elderly_id=42 WHERE id=46;
UPDATE elderly SET bed_id=46 WHERE id=42;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (42, 46, '2024-08-05', '正常入住登记');
UPDATE bed SET status=1, elderly_id=43 WHERE id=47;
UPDATE elderly SET bed_id=47 WHERE id=43;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (43, 47, '2026-04-30', '正常入住登记');
UPDATE bed SET status=1, elderly_id=44 WHERE id=48;
UPDATE elderly SET bed_id=48 WHERE id=44;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (44, 48, '2026-01-19', '正常入住登记');
UPDATE bed SET status=1, elderly_id=45 WHERE id=49;
UPDATE elderly SET bed_id=49 WHERE id=45;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (45, 49, '2024-11-24', '正常入住登记');
UPDATE bed SET status=1, elderly_id=46 WHERE id=50;
UPDATE elderly SET bed_id=50 WHERE id=46;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (46, 50, '2025-12-11', '正常入住登记');
UPDATE bed SET status=1, elderly_id=47 WHERE id=51;
UPDATE elderly SET bed_id=51 WHERE id=47;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (47, 51, '2024-12-03', '正常入住登记');
UPDATE bed SET status=1, elderly_id=48 WHERE id=52;
UPDATE elderly SET bed_id=52 WHERE id=48;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (48, 52, '2024-12-09', '正常入住登记');
UPDATE bed SET status=1, elderly_id=49 WHERE id=53;
UPDATE elderly SET bed_id=53 WHERE id=49;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (49, 53, '2024-10-16', '正常入住登记');
UPDATE bed SET status=1, elderly_id=50 WHERE id=54;
UPDATE elderly SET bed_id=54 WHERE id=50;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (50, 54, '2024-11-20', '正常入住登记');
UPDATE bed SET status=1, elderly_id=51 WHERE id=55;
UPDATE elderly SET bed_id=55 WHERE id=51;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (51, 55, '2025-07-19', '正常入住登记');
UPDATE bed SET status=1, elderly_id=52 WHERE id=56;
UPDATE elderly SET bed_id=56 WHERE id=52;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (52, 56, '2024-10-05', '正常入住登记');
UPDATE bed SET status=1, elderly_id=53 WHERE id=57;
UPDATE elderly SET bed_id=57 WHERE id=53;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (53, 57, '2025-12-19', '正常入住登记');
UPDATE bed SET status=1, elderly_id=54 WHERE id=58;
UPDATE elderly SET bed_id=58 WHERE id=54;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (54, 58, '2026-05-29', '正常入住登记');
UPDATE bed SET status=1, elderly_id=55 WHERE id=59;
UPDATE elderly SET bed_id=59 WHERE id=55;
INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (55, 59, '2025-12-31', '正常入住登记');

-- check_out (15)
INSERT INTO check_out (elderly_id, bed_id, check_out_date, check_out_reason, remark) VALUES
(56, 51, '2026-05-29', 2, '历史退住记录'),
(57, 52, '2026-06-18', 4, '历史退住记录'),
(58, 53, '2026-05-12', 2, '历史退住记录'),
(59, 54, '2026-06-22', 4, '历史退住记录'),
(60, 55, '2026-05-29', 1, '历史退住记录'),
(61, 56, '2026-05-16', 3, '历史退住记录'),
(62, 57, '2026-05-26', 3, '历史退住记录'),
(63, 58, '2026-06-13', 2, '历史退住记录'),
(64, 59, '2026-05-14', 1, '历史退住记录'),
(65, 60, '2026-05-24', 4, '历史退住记录'),
(66, 61, '2026-06-04', 3, '历史退住记录'),
(67, 62, '2026-05-03', 3, '历史退住记录'),
(68, 63, '2026-06-23', 4, '历史退住记录'),
(69, 64, '2026-06-16', 2, '历史退住记录'),
(70, 65, '2026-06-07', 2, '历史退住记录');

-- outing (60)
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES
(17, 2, '2026-04-09 08:00:47', '2026-04-09 09:00:46', '2026-04-09 11:00:47', '袁志', '18873157658', '浑南奥体中心', '家庭聚会', 1),
(57, 3, '2026-06-22 05:00:31', '2026-06-22 12:00:26', '2026-06-22 12:00:42', '马娟', '13696794633', '太原街商圈', '探访亲友', 1),
(4, 2, '2026-04-16 07:00:09', '2026-04-16 12:00:22', '2026-04-16 09:00:28', '武珍', '15023731277', '沈阳医大一院', '家庭聚会', 1),
(31, 3, '2026-04-20 04:00:03', '2026-04-20 11:00:23', '2026-04-20 12:00:11', '何涛', '15921633967', '沈阳医大一院', '家庭聚会', 1),
(46, 3, '2026-05-24 07:00:01', '2026-05-24 11:00:46', NULL, '李杰', '15120078417', '太原街商圈', '家庭聚会', 0),
(31, 2, '2026-05-05 01:00:15', '2026-05-05 09:00:00', NULL, '丁淑', '13915942746', '铁西万达', '探访亲友', 0),
(51, 3, '2026-04-20 04:00:46', '2026-04-20 12:00:10', '2026-04-20 11:00:17', '孙华', '13828723104', '北陵公园', '散步休闲', 1),
(9, 3, '2026-06-16 05:00:56', '2026-06-16 09:00:41', '2026-06-16 12:00:15', '顾秀', '15028558753', '浑南奥体中心', '探访亲友', 1),
(27, 1, '2026-04-15 07:00:15', '2026-04-15 11:00:55', '2026-04-15 09:00:57', '罗龙', '18774234825', '沈阳医大一院', '取药', 1),
(65, 2, '2026-05-17 02:00:39', '2026-05-17 09:00:51', '2026-05-17 10:00:01', '贺志', '18778071826', '辽宁省人民医院', '定期复查', 1),
(10, 2, '2026-04-18 01:00:15', '2026-04-18 10:00:20', '2026-04-18 10:00:24', '卢国', '15941794087', '太原街商圈', '家庭聚会', 1),
(17, 2, '2026-05-23 07:00:06', '2026-05-23 12:00:09', '2026-05-23 09:00:34', '易娟', '18840120778', '辽宁省人民医院', '牙科检查', 1),
(20, 1, '2026-04-04 07:00:54', '2026-04-04 09:00:36', NULL, '魏秀', '15827056062', '沈阳医大一院', '购买日用品', 0),
(65, 3, '2026-04-16 00:00:17', '2026-04-16 12:00:13', '2026-04-16 11:00:09', '杜秀', '18869244298', '辽宁省人民医院', '取药', 1),
(41, 1, '2026-05-07 03:00:13', '2026-05-07 11:00:33', '2026-05-07 13:00:08', '林军', '18885379614', '浑南奥体中心', '家庭聚会', 1),
(1, 1, '2026-05-27 08:00:34', '2026-05-27 09:00:15', NULL, '乔丽', '18783252771', '太原街商圈', '定期复查', 0),
(56, 1, '2026-04-29 08:00:56', '2026-04-29 11:00:18', '2026-04-29 09:00:05', '秦兰', '13688423622', '北陵公园', '牙科检查', 1),
(25, 1, '2026-06-17 05:00:07', '2026-06-17 11:00:35', NULL, '沈娟', '15850981566', '子女家中', '定期复查', 0),
(64, 1, '2026-04-11 08:00:26', '2026-04-11 10:00:10', '2026-04-11 13:00:43', '黄淑', '15939696819', '辽宁省人民医院', '取药', 1),
(13, 2, '2026-06-04 06:00:57', '2026-06-04 11:00:33', NULL, '石秀', '13996697092', '浑南奥体中心', '家庭聚会', 0),
(39, 3, '2026-05-12 05:00:04', '2026-05-12 09:00:57', '2026-05-12 10:00:20', '邵建', '13974067498', '子女家中', '牙科检查', 1),
(25, 2, '2026-06-23 06:00:50', '2026-06-23 11:00:24', '2026-06-23 10:00:09', '江丽', '18718479588', '太原街商圈', '购买日用品', 1),
(56, 3, '2026-05-04 01:00:38', '2026-05-04 11:00:51', '2026-05-04 11:00:23', '孙珍', '15072669102', '铁西万达', '探访亲友', 1),
(2, 2, '2026-06-25 01:00:19', '2026-06-25 10:00:25', '2026-06-25 13:00:23', '杜秀', '15075845612', '辽宁省人民医院', '家庭聚会', 1),
(10, 1, '2026-05-31 02:00:39', '2026-05-31 09:00:11', '2026-05-31 10:00:26', '康秀', '15056161957', '子女家中', '参加社区活动', 1),
(36, 2, '2026-04-20 06:00:52', '2026-04-20 12:00:47', '2026-04-20 10:00:47', '傅平', '13879350945', '铁西万达', '家庭聚会', 1),
(21, 2, '2026-04-03 06:00:03', '2026-04-03 12:00:59', '2026-04-03 11:00:22', '邵平', '15056234343', '辽宁省人民医院', '探访亲友', 1),
(36, 2, '2026-05-30 03:00:59', '2026-05-30 10:00:15', '2026-05-30 09:00:57', '武德', '13822513369', '子女家中', '取药', 1),
(49, 3, '2026-04-11 04:00:54', '2026-04-11 11:00:21', '2026-04-11 12:00:05', '马秀', '18878296187', '北陵公园', '取药', 1),
(51, 2, '2026-06-29 06:00:24', '2026-06-29 12:00:54', '2026-06-29 12:00:09', '曹明', '15896468322', '太原街商圈', '牙科检查', 1),
(2, 2, '2026-05-06 05:00:07', '2026-05-06 10:00:41', '2026-05-06 13:00:04', '孟兰', '13926552577', '子女家中', '购买日用品', 1),
(21, 1, '2026-06-12 01:00:38', '2026-06-12 11:00:54', '2026-06-12 10:00:17', '蔡志', '13643950729', '太原街商圈', '牙科检查', 1),
(5, 1, '2026-04-27 05:00:58', '2026-04-27 12:00:17', '2026-04-27 10:00:15', '邱玉', '15014966837', '辽宁省人民医院', '取药', 1),
(21, 1, '2026-05-29 07:00:11', '2026-05-29 11:00:17', '2026-05-29 11:00:38', '郑淑', '15078586379', '和平广场', '参加社区活动', 1),
(66, 1, '2026-06-22 08:00:05', '2026-06-22 09:00:01', '2026-06-22 10:00:26', '李斌', '18856666370', '子女家中', '定期复查', 1),
(27, 1, '2026-04-28 01:00:23', '2026-04-28 12:00:47', '2026-04-28 10:00:24', '郝杰', '18852850937', '和平广场', '探访亲友', 1),
(11, 1, '2026-06-24 07:00:23', '2026-06-24 11:00:54', '2026-06-24 10:00:30', '汪秀', '15043678163', '铁西万达', '探访亲友', 1),
(49, 3, '2026-06-13 02:00:53', '2026-06-13 09:00:45', '2026-06-13 11:00:55', '曾丽', '13814349117', '太原街商圈', '购买日用品', 1),
(31, 2, '2026-06-15 08:00:27', '2026-06-15 09:00:18', '2026-06-15 10:00:19', '田国', '15929381848', '北陵公园', '取药', 1),
(62, 3, '2026-05-24 02:00:19', '2026-05-24 12:00:30', '2026-05-24 10:00:10', '赖玉', '15949449193', '铁西万达', '购买日用品', 1),
(65, 3, '2026-04-07 01:00:33', '2026-04-07 11:00:15', '2026-04-07 11:00:06', '董国', '15848269614', '铁西万达', '家庭聚会', 1),
(67, 1, '2026-04-04 06:00:55', '2026-04-04 11:00:28', '2026-04-04 12:00:05', '尹芳', '15860390802', '子女家中', '取药', 1),
(43, 3, '2026-05-19 04:00:23', '2026-05-19 10:00:50', '2026-05-19 13:00:56', '常兰', '15946279091', '子女家中', '牙科检查', 1),
(5, 1, '2026-04-27 06:00:25', '2026-04-27 09:00:48', NULL, '蔡华', '15855710808', '浑南奥体中心', '散步休闲', 0),
(22, 3, '2026-04-15 00:00:11', '2026-04-15 11:00:22', '2026-04-15 12:00:46', '金珍', '15997228801', '辽宁省人民医院', '定期复查', 1),
(12, 1, '2026-04-28 06:00:05', '2026-04-28 09:00:25', '2026-04-28 10:00:48', '金俊', '18856257871', '和平广场', '探访亲友', 1),
(15, 2, '2026-05-01 02:00:18', '2026-05-01 11:00:07', NULL, '许丽', '13689854616', '太原街商圈', '定期复查', 0),
(32, 3, '2026-05-26 05:00:26', '2026-05-26 09:00:43', '2026-05-26 12:00:57', '姚涛', '15864055670', '铁西万达', '购买日用品', 1),
(13, 3, '2026-04-11 01:00:39', '2026-04-11 09:00:32', '2026-04-11 09:00:03', '雷建', '13940090845', '浑南奥体中心', '探访亲友', 1),
(46, 2, '2026-04-16 01:00:14', '2026-04-16 11:00:21', '2026-04-16 11:00:14', '范德', '15945949040', '浑南奥体中心', '参加社区活动', 1),
(65, 3, '2026-05-04 02:00:04', '2026-05-04 11:00:48', '2026-05-04 09:00:15', '朱海', '13798132048', '子女家中', '取药', 1),
(23, 3, '2026-05-05 01:00:59', '2026-05-05 09:00:51', NULL, '邓丽', '15018620016', '和平广场', '定期复查', 0),
(37, 2, '2026-04-11 06:00:56', '2026-04-11 09:00:38', '2026-04-11 09:00:16', '袁杰', '18736986306', '太原街商圈', '购买日用品', 1),
(14, 3, '2026-06-04 05:00:23', '2026-06-04 12:00:46', '2026-06-04 09:00:11', '姜建', '18752475422', '浑南奥体中心', '购买日用品', 1),
(67, 2, '2026-04-23 07:00:34', '2026-04-23 10:00:25', '2026-04-23 11:00:12', '叶桂', '15016203605', '辽宁省人民医院', '牙科检查', 1),
(16, 1, '2026-05-03 08:00:08', '2026-05-03 09:00:31', '2026-05-03 12:00:41', '戴伟', '18753870597', '子女家中', '定期复查', 1),
(28, 3, '2026-06-22 06:00:21', '2026-06-22 11:00:00', NULL, '朱俊', '13752676218', '铁西万达', '取药', 0),
(15, 2, '2026-04-15 06:00:57', '2026-04-15 10:00:34', '2026-04-15 12:00:39', '郭平', '15189942933', '太原街商圈', '购买日用品', 1),
(21, 2, '2026-04-20 06:00:56', '2026-04-20 09:00:11', NULL, '郭珍', '18845420120', '铁西万达', '牙科检查', 0),
(38, 3, '2026-05-01 04:00:28', '2026-05-01 11:00:48', NULL, '罗建', '13634238342', '辽宁省人民医院', '家庭聚会', 0);

-- care_record (75)
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES
(1, 27, '2026-06-25', '2026-06-25 10:00:45', 2, '执行完毕，无异常'),
(45, 5, '2026-06-16', '2026-06-16 10:00:32', 1, '已完成，老人配合良好'),
(14, 23, '2026-06-24', '2026-06-24 08:00:41', 1, '需继续观察'),
(61, 25, '2026-07-01', '2026-06-30 23:00:52', 1, '血压正常'),
(11, 44, '2026-06-29', '2026-06-29 05:00:17', 1, '老人拒绝，已跳过'),
(16, 52, '2026-06-09', '2026-06-09 06:00:06', 0, '需继续观察'),
(2, 11, '2026-06-08', '2026-06-08 02:00:28', 1, '已完成，老人配合良好'),
(41, 50, '2026-06-08', '2026-06-08 12:00:09', 1, '血压正常'),
(5, 41, '2026-06-23', '2026-06-22 23:00:37', 1, '老人拒绝，已跳过'),
(45, 19, '2026-06-29', '2026-06-29 02:00:45', 1, '已完成，老人配合良好'),
(50, 42, '2026-06-23', '2026-06-23 05:00:12', 0, '老人今日情绪稳定'),
(32, 40, '2026-06-29', '2026-06-29 04:00:24', 0, '需继续观察'),
(33, 17, '2026-06-09', '2026-06-09 12:00:19', 0, '血压正常'),
(58, 16, '2026-06-19', '2026-06-19 05:00:43', 0, '需继续观察'),
(14, 48, '2026-07-01', '2026-07-01 05:00:53', 1, '血压正常'),
(12, 34, '2026-06-14', '2026-06-13 23:00:37', 1, '已完成，老人配合良好'),
(13, 53, '2026-06-09', '2026-06-09 05:00:57', 1, '已完成，老人配合良好'),
(13, 24, '2026-06-16', '2026-06-16 03:00:24', 1, ''),
(35, 33, '2026-06-16', '2026-06-16 02:00:17', 1, ''),
(22, 7, '2026-06-12', '2026-06-12 07:00:54', 1, '老人今日情绪稳定'),
(67, 28, '2026-06-17', '2026-06-17 11:00:52', 2, '老人拒绝，已跳过'),
(48, 19, '2026-06-23', '2026-06-23 04:00:18', 1, '老人拒绝，已跳过'),
(56, 3, '2026-06-06', '2026-06-06 02:00:49', 1, '血压正常'),
(37, 31, '2026-06-04', '2026-06-03 22:00:46', 2, '执行完毕，无异常'),
(57, 1, '2026-06-25', '2026-06-25 04:00:24', 2, '老人今日情绪稳定'),
(7, 35, '2026-06-08', '2026-06-08 04:00:38', 1, '已完成，老人配合良好'),
(56, 21, '2026-06-15', '2026-06-15 04:00:52', 1, '需继续观察'),
(51, 25, '2026-07-02', '2026-07-01 23:00:23', 2, ''),
(46, 6, '2026-06-12', '2026-06-12 03:00:25', 2, '老人今日情绪稳定'),
(64, 16, '2026-06-24', '2026-06-24 03:00:11', 1, '老人拒绝，已跳过'),
(2, 47, '2026-06-11', '2026-06-11 08:00:03', 1, '老人拒绝，已跳过'),
(35, 29, '2026-06-26', '2026-06-26 07:00:47', 2, '血压正常'),
(64, 6, '2026-06-17', '2026-06-17 09:00:58', 1, '血压正常'),
(6, 17, '2026-06-11', '2026-06-11 09:00:46', 0, '已完成，老人配合良好'),
(56, 24, '2026-06-08', '2026-06-08 01:00:56', 0, '已完成，老人配合良好'),
(55, 24, '2026-06-11', '2026-06-11 00:00:13', 1, '执行完毕，无异常'),
(7, 9, '2026-06-23', '2026-06-23 07:00:35', 1, '老人今日情绪稳定'),
(31, 24, '2026-06-29', '2026-06-29 01:00:30', 1, '老人今日情绪稳定'),
(15, 15, '2026-06-04', '2026-06-04 06:00:24', 1, '老人今日情绪稳定'),
(45, 52, '2026-06-18', '2026-06-18 08:00:49', 1, '执行完毕，无异常'),
(40, 40, '2026-06-20', '2026-06-19 23:00:16', 1, ''),
(46, 3, '2026-06-26', '2026-06-26 04:00:04', 2, '已完成，老人配合良好'),
(67, 53, '2026-06-29', '2026-06-29 10:00:30', 2, ''),
(31, 24, '2026-06-12', '2026-06-12 05:00:45', 0, '执行完毕，无异常'),
(63, 9, '2026-07-02', '2026-07-02 04:00:06', 1, ''),
(64, 18, '2026-06-07', '2026-06-07 10:00:24', 2, '血压正常'),
(42, 10, '2026-06-21', '2026-06-21 07:00:46', 1, '已完成，老人配合良好'),
(67, 45, '2026-06-10', '2026-06-10 04:00:05', 1, '老人今日情绪稳定'),
(61, 21, '2026-06-15', '2026-06-15 02:00:00', 0, '血压正常'),
(30, 30, '2026-06-17', '2026-06-16 23:00:28', 1, '老人今日情绪稳定'),
(60, 15, '2026-06-20', '2026-06-20 05:00:21', 1, '执行完毕，无异常'),
(44, 24, '2026-06-30', '2026-06-29 23:00:21', 1, '执行完毕，无异常'),
(18, 46, '2026-06-22', '2026-06-22 07:00:51', 2, '血压正常'),
(41, 28, '2026-06-23', '2026-06-23 12:00:30', 1, '需继续观察'),
(51, 51, '2026-06-17', '2026-06-17 03:00:38', 1, ''),
(7, 16, '2026-06-11', '2026-06-11 03:00:25', 1, '老人拒绝，已跳过'),
(24, 6, '2026-07-01', '2026-07-01 12:00:48', 0, '需继续观察'),
(27, 23, '2026-06-09', '2026-06-09 07:00:00', 1, '需继续观察'),
(46, 6, '2026-06-10', '2026-06-10 11:00:49', 1, ''),
(62, 16, '2026-06-17', '2026-06-17 03:00:57', 2, '血压正常'),
(65, 17, '2026-06-02', '2026-06-02 06:00:26', 0, '血压正常'),
(34, 47, '2026-06-05', '2026-06-05 10:00:03', 1, '老人拒绝，已跳过'),
(20, 7, '2026-06-07', '2026-06-07 01:00:03', 0, '老人今日情绪稳定'),
(68, 22, '2026-06-07', '2026-06-07 04:00:29', 0, '已完成，老人配合良好'),
(27, 18, '2026-06-23', '2026-06-23 07:00:47', 1, '已完成，老人配合良好'),
(61, 15, '2026-06-09', '2026-06-09 12:00:15', 1, '已完成，老人配合良好'),
(50, 11, '2026-06-22', '2026-06-22 01:00:12', 1, '老人拒绝，已跳过'),
(5, 35, '2026-06-27', '2026-06-27 12:00:36', 1, '老人拒绝，已跳过'),
(58, 31, '2026-06-09', '2026-06-09 03:00:42', 1, '血压正常'),
(58, 44, '2026-06-29', '2026-06-28 23:00:10', 1, '老人今日情绪稳定'),
(67, 47, '2026-06-07', '2026-06-07 01:00:18', 1, '已完成，老人配合良好'),
(60, 39, '2026-06-24', '2026-06-24 06:00:46', 1, '已完成，老人配合良好'),
(47, 6, '2026-06-12', '2026-06-12 10:00:10', 1, ''),
(40, 1, '2026-07-01', '2026-07-01 08:00:14', 1, '老人拒绝，已跳过'),
(16, 32, '2026-06-08', '2026-06-08 11:00:23', 2, '老人今日情绪稳定');

-- meal_calendar (63)
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES
('2026-06-12', 1, '豆浆、油条、茶叶蛋、咸菜', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-12', 2, '软烂红烧肉、炖豆腐、米饭、银耳莲子羹', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-12', 3, '山药粥、清炒时蔬、蒸红薯', '易消化，适合老年人口味', '中心统一配餐'),
('2026-06-13', 1, '牛奶、全麦面包、香蕉', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-13', 2, '滑溜里脊、素炒三丝、米饭、山药汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-13', 3, '杂粮饭、蒸蛋羹、清炒豆角', '易消化，适合老年人口味', '中心统一配餐'),
('2026-06-14', 1, '燕麦粥、煎蛋、清炒时蔬', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-14', 2, '土豆炖牛肉、蒜蓉菠菜、米饭、冬瓜汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-14', 3, '蔬菜瘦肉粥、蒸南瓜、清炒小白菜', '易消化，适合老年人口味', '中心统一配餐'),
('2026-06-15', 1, '燕麦粥、煎蛋、清炒时蔬', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-15', 2, '软烂红烧肉、炖豆腐、米饭、银耳莲子羹', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-15', 3, '疙瘩汤、拌三丝', '易消化，适合老年人口味', '中心统一配餐'),
('2026-06-16', 1, '南瓜粥、蒸饺、凉拌木耳', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-16', 2, '清蒸鲈鱼、西红柿炒蛋、米饭、玉米排骨汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-16', 3, '蔬菜瘦肉粥、蒸南瓜、清炒小白菜', '易消化，适合老年人口味', '中心统一配餐'),
('2026-06-17', 1, '南瓜粥、蒸饺、凉拌木耳', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-17', 2, '软烂红烧肉、炖豆腐、米饭、银耳莲子羹', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-17', 3, '山药粥、清炒时蔬、蒸红薯', '易消化，适合老年人口味', '中心统一配餐'),
('2026-06-18', 1, '豆浆、油条、茶叶蛋、咸菜', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-18', 2, '软烂红烧肉、炖豆腐、米饭、银耳莲子羹', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-18', 3, '疙瘩汤、拌三丝', '易消化，适合老年人口味', '中心统一配餐'),
('2026-06-19', 1, '南瓜粥、蒸饺、凉拌木耳', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-19', 2, '清蒸鲈鱼、西红柿炒蛋、米饭、玉米排骨汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-19', 3, '蔬菜瘦肉粥、蒸南瓜、清炒小白菜', '易消化，适合老年人口味', '中心统一配餐'),
('2026-06-20', 1, '小米粥、水煮蛋、花卷、拌黄瓜', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-20', 2, '滑溜里脊、素炒三丝、米饭、山药汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-20', 3, '馄饨、凉拌黄瓜', '易消化，适合老年人口味', '中心统一配餐'),
('2026-06-21', 1, '小米粥、水煮蛋、花卷、拌黄瓜', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-21', 2, '滑溜里脊、素炒三丝、米饭、山药汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-21', 3, '蔬菜瘦肉粥、蒸南瓜、清炒小白菜', '易消化，适合老年人口味', '中心统一配餐'),
('2026-06-22', 1, '豆浆、油条、茶叶蛋、咸菜', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-22', 2, '红烧鲤鱼、清炒西兰花、米饭、紫菜蛋花汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-22', 3, '馄饨、凉拌黄瓜', '易消化，适合老年人口味', '中心统一配餐'),
('2026-06-23', 1, '小米粥、水煮蛋、花卷、拌黄瓜', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-23', 2, '红烧鲤鱼、清炒西兰花、米饭、紫菜蛋花汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-23', 3, '蔬菜瘦肉粥、蒸南瓜、清炒小白菜', '易消化，适合老年人口味', '中心统一配餐'),
('2026-06-24', 1, '牛奶、全麦面包、香蕉', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-24', 2, '黄焖鸡、清炒油麦菜、米饭、番茄蛋汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-24', 3, '蔬菜瘦肉粥、蒸南瓜、清炒小白菜', '易消化，适合老年人口味', '中心统一配餐'),
('2026-06-25', 1, '小米粥、水煮蛋、花卷、拌黄瓜', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-25', 2, '软烂红烧肉、炖豆腐、米饭、银耳莲子羹', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-25', 3, '馄饨、凉拌黄瓜', '易消化，适合老年人口味', '中心统一配餐'),
('2026-06-26', 1, '燕麦粥、煎蛋、清炒时蔬', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-26', 2, '滑溜里脊、素炒三丝、米饭、山药汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-26', 3, '杂粮饭、蒸蛋羹、清炒豆角', '易消化，适合老年人口味', '中心统一配餐'),
('2026-06-27', 1, '豆浆、油条、茶叶蛋、咸菜', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-27', 2, '红烧鲤鱼、清炒西兰花、米饭、紫菜蛋花汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-27', 3, '面条、西红柿卤、拌海带丝', '易消化，适合老年人口味', '中心统一配餐'),
('2026-06-28', 1, '小米粥、水煮蛋、花卷、拌黄瓜', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-28', 2, '土豆炖牛肉、蒜蓉菠菜、米饭、冬瓜汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-28', 3, '山药粥、清炒时蔬、蒸红薯', '易消化，适合老年人口味', '中心统一配餐'),
('2026-06-29', 1, '小米粥、水煮蛋、花卷、拌黄瓜', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-29', 2, '土豆炖牛肉、蒜蓉菠菜、米饭、冬瓜汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-29', 3, '面条、西红柿卤、拌海带丝', '易消化，适合老年人口味', '中心统一配餐'),
('2026-06-30', 1, '小米粥、水煮蛋、花卷、拌黄瓜', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-06-30', 2, '黄焖鸡、清炒油麦菜、米饭、番茄蛋汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-06-30', 3, '疙瘩汤、拌三丝', '易消化，适合老年人口味', '中心统一配餐'),
('2026-07-01', 1, '小米粥、水煮蛋、花卷、拌黄瓜', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-07-01', 2, '黄焖鸡、清炒油麦菜、米饭、番茄蛋汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-07-01', 3, '蔬菜瘦肉粥、蒸南瓜、清炒小白菜', '易消化，适合老年人口味', '中心统一配餐'),
('2026-07-02', 1, '豆浆、油条、茶叶蛋、咸菜', '低盐低油，富含膳食纤维', '中心统一配餐'),
('2026-07-02', 2, '红烧鲤鱼、清炒西兰花、米饭、紫菜蛋花汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐'),
('2026-07-02', 3, '杂粮饭、蒸蛋羹、清炒豆角', '易消化，适合老年人口味', '中心统一配餐');

-- meal_plan (55)
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES
(1, '低糖饮食', '需切碎食物', '喜食粥类'),
(2, '流食', '需喂食协助', '喜食清淡'),
(3, '流食', '需鼻饲', '喜食鱼类'),
(4, '流食', '需切碎食物', '喜食清淡'),
(5, '低糖饮食', '无', '喜食软烂'),
(6, '忌辛辣', '需鼻饲', '喜食面食'),
(7, '无特殊禁忌', '无', '喜食清淡'),
(8, '低嘌呤饮食', '少油少盐', '喜食清淡'),
(9, '低糖饮食', '需喂食协助', '喜食面食'),
(10, '低嘌呤饮食', '无', '无特殊偏好'),
(11, '流食', '需喂食协助', '喜食软烂'),
(12, '低盐饮食', '糖尿病餐', '喜食蔬菜'),
(13, '无特殊禁忌', '需鼻饲', '喜食蔬菜'),
(14, '无特殊禁忌', '需切碎食物', '喜食鱼类'),
(15, '无特殊禁忌', '需喂食协助', '喜食软烂'),
(16, '低糖饮食', '糖尿病餐', '喜食粥类'),
(17, '无特殊禁忌', '需切碎食物', '喜食鱼类'),
(18, '低嘌呤饮食', '需切碎食物', '喜食鱼类'),
(19, '无特殊禁忌', '需鼻饲', '喜食软烂'),
(20, '软食', '糖尿病餐', '喜食粥类'),
(21, '软食', '需鼻饲', '喜食面食'),
(22, '低糖饮食', '无', '喜食面食'),
(23, '低糖饮食', '需切碎食物', '喜食粥类'),
(24, '流食', '需喂食协助', '喜食软烂'),
(25, '低糖饮食', '需切碎食物', '喜食粥类'),
(26, '忌辛辣', '需鼻饲', '喜食软烂'),
(27, '软食', '需鼻饲', '喜食面食'),
(28, '低盐饮食', '需鼻饲', '喜食面食'),
(29, '流食', '糖尿病餐', '喜食软烂'),
(30, '高蛋白饮食', '糖尿病餐', '喜食清淡'),
(31, '低盐饮食', '需切碎食物', '喜食鱼类'),
(32, '软食', '需鼻饲', '喜食软烂'),
(33, '低嘌呤饮食', '需切碎食物', '无特殊偏好'),
(34, '无特殊禁忌', '糖尿病餐', '喜食粥类'),
(35, '低盐饮食', '少油少盐', '喜食粥类'),
(36, '软食', '需喂食协助', '喜食面食'),
(37, '无特殊禁忌', '无', '喜食蔬菜'),
(38, '无特殊禁忌', '糖尿病餐', '喜食软烂'),
(39, '软食', '少油少盐', '喜食鱼类'),
(40, '低盐饮食', '无', '喜食软烂'),
(41, '无特殊禁忌', '需喂食协助', '喜食软烂'),
(42, '低盐饮食', '糖尿病餐', '喜食鱼类'),
(43, '高蛋白饮食', '需喂食协助', '喜食清淡'),
(44, '无特殊禁忌', '需喂食协助', '无特殊偏好'),
(45, '低盐饮食', '需喂食协助', '喜食清淡'),
(46, '无特殊禁忌', '需喂食协助', '无特殊偏好'),
(47, '低嘌呤饮食', '需喂食协助', '喜食鱼类'),
(48, '低盐饮食', '无', '喜食软烂'),
(49, '流食', '少油少盐', '喜食清淡'),
(50, '软食', '无', '喜食蔬菜'),
(51, '无特殊禁忌', '需切碎食物', '无特殊偏好'),
(52, '高蛋白饮食', '需喂食协助', '无特殊偏好'),
(53, '流食', '少油少盐', '喜食软烂'),
(54, '流食', '需切碎食物', '喜食软烂'),
(55, '流食', '需切碎食物', '喜食清淡');

-- elderly_meal (80) — calendar_id 1~63 对应 meal_calendar 自增 ID
INSERT INTO elderly_meal (elderly_id, calendar_id, is_custom, custom_content) VALUES
(21, 21, 0, NULL),
(28, 13, 1, '低盐软食套餐'),
(45, 35, 0, NULL),
(26, 57, 1, '糖尿病专用餐'),
(45, 13, 1, '流质营养餐'),
(34, 21, 0, NULL),
(31, 34, 0, NULL),
(26, 18, 0, NULL),
(16, 52, 0, NULL),
(17, 28, 0, NULL),
(50, 6, 0, NULL),
(5, 19, 0, NULL),
(39, 5, 0, NULL),
(25, 13, 0, NULL),
(11, 59, 0, NULL),
(43, 17, 0, NULL),
(12, 63, 0, NULL),
(6, 30, 0, NULL),
(12, 2, 0, NULL),
(55, 51, 1, '流质营养餐'),
(8, 36, 0, NULL),
(2, 3, 0, NULL),
(42, 51, 0, NULL),
(11, 1, 0, NULL),
(38, 36, 0, NULL),
(27, 38, 0, NULL),
(39, 61, 0, NULL),
(12, 61, 0, NULL),
(12, 42, 0, NULL),
(39, 43, 1, '去海鲜定制餐'),
(17, 61, 0, NULL),
(42, 52, 0, NULL),
(21, 15, 0, NULL),
(42, 31, 0, NULL),
(2, 4, 0, NULL),
(10, 34, 1, '糖尿病专用餐'),
(29, 54, 0, NULL),
(19, 1, 0, NULL),
(51, 19, 0, NULL),
(43, 62, 0, NULL),
(5, 1, 0, NULL),
(4, 13, 0, NULL),
(4, 39, 0, NULL),
(4, 56, 0, NULL),
(16, 29, 0, NULL),
(38, 20, 0, NULL),
(30, 14, 0, NULL),
(20, 5, 1, '去海鲜定制餐'),
(44, 61, 0, NULL),
(16, 48, 0, NULL),
(22, 53, 0, NULL),
(40, 23, 0, NULL),
(2, 27, 0, NULL),
(43, 9, 1, '流质营养餐'),
(33, 9, 1, '去海鲜定制餐'),
(32, 41, 0, NULL),
(42, 27, 0, NULL),
(51, 17, 0, NULL),
(15, 53, 0, NULL),
(53, 3, 0, NULL),
(24, 40, 0, NULL),
(34, 58, 0, NULL),
(52, 21, 0, NULL),
(9, 48, 1, '去海鲜定制餐'),
(46, 35, 0, NULL),
(32, 25, 0, NULL),
(18, 34, 0, NULL),
(44, 36, 0, NULL),
(50, 37, 0, NULL),
(39, 26, 0, NULL),
(27, 6, 0, NULL),
(28, 40, 0, NULL),
(44, 61, 0, NULL),
(16, 49, 0, NULL),
(48, 49, 0, NULL),
(45, 43, 1, '流质营养餐'),
(21, 9, 0, NULL),
(36, 39, 0, NULL),
(16, 4, 0, NULL),
(46, 56, 0, NULL);

-- service_subscription (70)
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES
(3, 18, '2025-08-21', '2027-04-03', 1, '老人及家属已确认'),
(39, 3, '2025-12-17', '2027-11-04', 1, '老人及家属已确认'),
(26, 19, '2025-07-10', '2026-01-14', 1, '老人及家属已确认'),
(19, 6, '2025-12-28', '2027-09-25', 1, '老人及家属已确认'),
(13, 24, '2025-10-23', '2027-05-14', 1, '老人及家属已确认'),
(62, 17, '2026-04-03', '2028-03-12', 2, '老人及家属已确认'),
(46, 4, '2026-04-30', '2027-07-04', 1, '老人及家属已确认'),
(35, 7, '2025-08-19', '2027-01-31', 1, '老人及家属已确认'),
(66, 15, '2026-03-18', '2027-06-09', 1, '老人及家属已确认'),
(67, 21, '2025-12-06', '2026-06-20', 1, '老人及家属已确认'),
(55, 14, '2026-01-25', '2027-11-16', 1, '老人及家属已确认'),
(21, 24, '2025-10-17', '2027-03-26', 1, '老人及家属已确认'),
(12, 23, '2025-10-10', '2027-06-21', 1, '老人及家属已确认'),
(16, 22, '2025-07-21', '2026-03-19', 1, '老人及家属已确认'),
(55, 11, '2025-10-16', '2026-02-15', 1, '老人及家属已确认'),
(14, 2, '2026-01-22', '2026-05-30', 1, '老人及家属已确认'),
(68, 9, '2026-04-06', '2028-02-09', 1, '老人及家属已确认'),
(59, 16, '2025-07-04', '2027-06-27', 1, '老人及家属已确认'),
(44, 3, '2025-09-23', '2027-04-10', 3, '老人及家属已确认'),
(23, 15, '2025-11-29', '2026-03-29', 1, '老人及家属已确认'),
(57, 14, '2026-04-27', '2026-06-29', 1, '老人及家属已确认'),
(3, 5, '2026-02-10', '2026-12-28', 1, '老人及家属已确认'),
(7, 11, '2026-05-30', '2027-01-25', 1, '老人及家属已确认'),
(16, 9, '2025-08-06', '2027-03-12', 1, '老人及家属已确认'),
(13, 5, '2026-04-08', '2027-08-26', 1, '老人及家属已确认'),
(60, 16, '2025-07-23', '2026-05-23', 1, '老人及家属已确认'),
(10, 1, '2025-08-11', '2027-02-10', 2, '老人及家属已确认'),
(58, 1, '2025-11-28', '2027-11-22', 2, '老人及家属已确认'),
(44, 7, '2026-01-20', '2027-02-02', 1, '老人及家属已确认'),
(45, 14, '2025-07-21', '2025-11-01', 1, '老人及家属已确认'),
(27, 19, '2026-05-14', '2026-08-26', 1, '老人及家属已确认'),
(38, 25, '2025-10-19', '2026-10-05', 1, '老人及家属已确认'),
(31, 6, '2025-07-14', '2027-02-10', 1, '老人及家属已确认'),
(38, 8, '2025-09-28', '2026-05-20', 1, '老人及家属已确认'),
(54, 20, '2026-04-05', '2026-09-20', 1, '老人及家属已确认'),
(10, 25, '2025-10-05', '2026-02-02', 1, '老人及家属已确认'),
(56, 14, '2026-05-21', '2026-10-24', 1, '老人及家属已确认'),
(20, 8, '2025-09-15', '2026-01-02', 1, '老人及家属已确认'),
(44, 23, '2025-10-21', '2027-06-25', 1, '老人及家属已确认'),
(20, 18, '2025-08-30', '2026-06-09', 1, '老人及家属已确认'),
(48, 21, '2026-03-16', '2027-09-30', 1, '老人及家属已确认'),
(42, 14, '2026-03-15', '2027-05-12', 1, '老人及家属已确认'),
(60, 3, '2025-12-11', '2026-04-11', 1, '老人及家属已确认'),
(51, 10, '2025-08-03', '2027-02-28', 1, '老人及家属已确认'),
(28, 15, '2025-10-31', '2025-12-13', 1, '老人及家属已确认'),
(48, 24, '2026-02-04', '2026-06-26', 1, '老人及家属已确认'),
(41, 7, '2025-07-03', '2027-05-04', 1, '老人及家属已确认'),
(60, 22, '2025-11-29', '2027-09-07', 1, '老人及家属已确认'),
(53, 12, '2025-12-10', '2026-03-15', 1, '老人及家属已确认'),
(54, 22, '2025-11-21', '2027-02-17', 1, '老人及家属已确认'),
(19, 13, '2026-01-09', '2026-10-24', 1, '老人及家属已确认'),
(13, 18, '2026-01-03', '2027-07-19', 1, '老人及家属已确认'),
(68, 10, '2026-03-30', '2027-03-30', 1, '老人及家属已确认'),
(65, 3, '2026-03-30', '2027-08-08', 1, '老人及家属已确认'),
(57, 17, '2025-12-30', '2027-03-07', 1, '老人及家属已确认'),
(12, 2, '2025-08-15', '2027-03-28', 1, '老人及家属已确认'),
(63, 9, '2025-07-21', '2026-08-08', 1, '老人及家属已确认'),
(6, 2, '2025-07-04', '2026-04-18', 1, '老人及家属已确认'),
(43, 17, '2025-07-31', '2026-12-07', 1, '老人及家属已确认'),
(58, 18, '2026-01-06', '2026-12-02', 1, '老人及家属已确认'),
(20, 16, '2026-04-12', '2028-01-22', 2, '老人及家属已确认'),
(2, 7, '2026-04-06', '2028-03-05', 1, '老人及家属已确认'),
(32, 23, '2025-09-14', '2026-05-10', 1, '老人及家属已确认'),
(7, 2, '2025-08-02', '2027-05-09', 1, '老人及家属已确认'),
(36, 8, '2025-10-29', '2027-10-11', 1, '老人及家属已确认'),
(58, 9, '2026-04-21', '2027-08-31', 2, '老人及家属已确认'),
(16, 18, '2025-10-05', '2026-02-08', 1, '老人及家属已确认'),
(28, 5, '2025-12-29', '2027-10-09', 1, '老人及家属已确认'),
(57, 20, '2026-05-31', '2027-04-22', 1, '老人及家属已确认'),
(32, 25, '2025-12-19', '2026-12-14', 1, '老人及家属已确认');

COMMIT;
SET FOREIGN_KEY_CHECKS = 1;

-- 导入完成