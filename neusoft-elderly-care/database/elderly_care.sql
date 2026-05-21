-- ============================================
-- 东软颐养中心管理系统 - 数据库脚本
-- 版本: 1.0.0
-- ============================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `elderly_care` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `elderly_care`;

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
    `address` VARCHAR(200) COMMENT '家庭住址',
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
-- 初始数据
-- ============================================

-- 插入测试用户（密码：123456，加密后）
INSERT INTO `user` (`phone`, `password`, `real_name`, `age`, `gender`, `status`) VALUES
('13800138000', '$2a$10$N.zMDVrgQGXDjBzLGmP7qO4lF7RzQ5Z7Xz3j1q2w3e4r5t6y7u8i9o0p', '管理员', 30, 1, 1);

-- 插入护理级别
INSERT INTO `care_level` (`level_name`, `level_code`, `description`, `sort_order`) VALUES
('一级护理', 'LEVEL_1', '基本生活护理', 1),
('二级护理', 'LEVEL_2', '半护理，需部分协助', 2),
('三级护理', 'LEVEL_3', '全护理，需全面照顾', 3),
('特级护理', 'LEVEL_4', '特殊护理需求', 4);

-- 插入护理内容
INSERT INTO `care_item` (`item_name`, `care_level_id`, `frequency`, `description`, `sort_order`) VALUES
('晨间护理', 1, '每日1次', '协助洗漱、整理床铺', 1),
('晚间护理', 1, '每日1次', '协助睡前洗漱', 2),
('测量血压', 2, '每日2次', '早晚各测量一次', 3),
('协助用餐', 2, '每日3次', '协助进食，观察饮食情况', 4),
('翻身护理', 3, '每2小时1次', '定时翻身，预防褥疮', 5),
('康复训练', 4, '每日1次', '专业康复训练', 6);

-- 插入测试房间
INSERT INTO `room` (`room_no`, `room_type`, `floor`, `capacity`, `status`, `remark`) VALUES
('101', 2, 1, 2, 1, '标准双人间'),
('102', 2, 1, 2, 1, '标准双人间'),
('201', 1, 2, 1, 1, '豪华单人间'),
('202', 3, 2, 4, 1, '多人间');

-- 插入测试床位
INSERT INTO `bed` (`room_id`, `bed_no`, `status`) VALUES
(1, 'A', 0), (1, 'B', 0),
(2, 'A', 0), (2, 'B', 0),
(3, 'A', 0),
(4, 'A', 0), (4, 'B', 0), (4, 'C', 0), (4, 'D', 0);

-- 插入测试服务
INSERT INTO `service` (`service_name`, `service_type`, `description`, `status`) VALUES
('健康咨询', 3, '提供日常健康咨询服务', 1),
('康复理疗', 3, '专业康复理疗服务', 1),
('文娱活动', 2, '组织文化娱乐活动', 1),
('心理咨询', 3, '心理疏导和咨询服务', 1);

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
