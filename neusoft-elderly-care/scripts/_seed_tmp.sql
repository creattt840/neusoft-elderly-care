SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
START TRANSACTION;
INSERT INTO check_out (elderly_id, bed_id, check_out_date, check_out_reason, remark) VALUES (66, 0, '2026-04-19', 2, '历史退住记录');
INSERT INTO check_out (elderly_id, bed_id, check_out_date, check_out_reason, remark) VALUES (67, 0, '2026-05-11', 4, '历史退住记录');
INSERT INTO check_out (elderly_id, bed_id, check_out_date, check_out_reason, remark) VALUES (68, 0, '2026-04-18', 3, '历史退住记录');
INSERT INTO check_out (elderly_id, bed_id, check_out_date, check_out_reason, remark) VALUES (69, 0, '2026-04-07', 3, '历史退住记录');
INSERT INTO check_out (elderly_id, bed_id, check_out_date, check_out_reason, remark) VALUES (70, 0, '2026-04-12', 4, '历史退住记录');
INSERT INTO check_out (elderly_id, bed_id, check_out_date, check_out_reason, remark) VALUES (71, 0, '2026-05-09', 3, '历史退住记录');
INSERT INTO check_out (elderly_id, bed_id, check_out_date, check_out_reason, remark) VALUES (72, 0, '2026-04-20', 2, '历史退住记录');
INSERT INTO check_out (elderly_id, bed_id, check_out_date, check_out_reason, remark) VALUES (73, 0, '2026-05-30', 2, '历史退住记录');
INSERT INTO check_out (elderly_id, bed_id, check_out_date, check_out_reason, remark) VALUES (74, 0, '2026-05-06', 2, '历史退住记录');
INSERT INTO check_out (elderly_id, bed_id, check_out_date, check_out_reason, remark) VALUES (75, 0, '2026-04-11', 2, '历史退住记录');
INSERT INTO check_out (elderly_id, bed_id, check_out_date, check_out_reason, remark) VALUES (76, 0, '2026-04-20', 1, '历史退住记录');
INSERT INTO check_out (elderly_id, bed_id, check_out_date, check_out_reason, remark) VALUES (77, 0, '2026-05-21', 4, '历史退住记录');
INSERT INTO check_out (elderly_id, bed_id, check_out_date, check_out_reason, remark) VALUES (78, 0, '2026-05-17', 4, '历史退住记录');
INSERT INTO check_out (elderly_id, bed_id, check_out_date, check_out_reason, remark) VALUES (79, 0, '2026-04-06', 1, '历史退住记录');
INSERT INTO check_out (elderly_id, bed_id, check_out_date, check_out_reason, remark) VALUES (80, 0, '2026-04-22', 3, '历史退住记录');
-- outing
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (7, 3, '2026-03-27 02:00:36', '2026-03-27 12:00:56', NULL, '邹桂', '13949496294', '北陵公园', '牙科检查', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (58, 3, '2026-05-28 01:00:55', '2026-05-28 11:00:42', '2026-05-28 09:00:41', '潘兰', '15980412111', '沈阳医大一院', '散步休闲', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (9, 2, '2026-04-29 06:00:44', '2026-04-29 09:00:28', '2026-04-29 13:00:03', '康德', '13844012527', '太原街商圈', '探访亲友', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (5, 2, '2026-05-09 02:00:48', '2026-05-09 10:00:32', '2026-05-09 11:00:25', '邹建', '18852189416', '和平广场', '参加社区活动', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (70, 1, '2026-03-19 05:00:26', '2026-03-19 12:00:14', NULL, '武军', '15811831445', '辽宁省人民医院', '家庭聚会', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (80, 1, '2026-03-18 05:00:55', '2026-03-18 11:00:05', '2026-03-18 13:00:28', '雷明', '13649296085', '辽宁省人民医院', '定期复查', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (63, 3, '2026-04-23 01:00:03', '2026-04-23 10:00:57', '2026-04-23 13:00:59', '徐杰', '13825920989', '和平广场', '定期复查', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (23, 2, '2026-05-03 00:00:50', '2026-05-03 12:00:06', '2026-05-03 12:00:35', '邱志', '15127773098', '铁西万达', '参加社区活动', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (33, 3, '2026-05-15 05:00:09', '2026-05-15 12:00:46', '2026-05-15 10:00:57', '叶秀', '15962046060', '子女家中', '探访亲友', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (58, 3, '2026-05-19 03:00:45', '2026-05-19 09:00:57', NULL, '傅建', '15138846630', '沈阳医大一院', '参加社区活动', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (48, 2, '2026-05-18 05:00:35', '2026-05-18 12:00:54', '2026-05-18 10:00:45', '孙兰', '15864739860', '子女家中', '牙科检查', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (3, 3, '2026-05-27 04:00:15', '2026-05-27 11:00:04', NULL, '黄兰', '18723103511', '辽宁省人民医院', '取药', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (17, 3, '2026-04-12 04:00:25', '2026-04-12 10:00:46', NULL, '郝秀', '13643793572', '子女家中', '家庭聚会', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (67, 3, '2026-05-05 03:00:17', '2026-05-05 11:00:32', '2026-05-05 11:00:42', '武明', '15937630700', '浑南奥体中心', '定期复查', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (38, 1, '2026-05-06 08:00:19', '2026-05-06 12:00:42', NULL, '姚志', '15892148587', '沈阳医大一院', '散步休闲', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (59, 1, '2026-04-07 01:00:26', '2026-04-07 11:00:37', '2026-04-07 09:00:23', '龚梅', '15822417829', '太原街商圈', '牙科检查', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (29, 2, '2026-05-12 05:00:06', '2026-05-12 11:00:52', '2026-05-12 11:00:09', '董芳', '13642291628', '子女家中', '参加社区活动', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (69, 3, '2026-04-15 07:00:20', '2026-04-15 12:00:10', NULL, '唐斌', '18764475094', '浑南奥体中心', '参加社区活动', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (44, 2, '2026-05-30 00:00:30', '2026-05-30 11:00:06', '2026-05-30 12:00:34', '戴丽', '18722749790', '铁西万达', '探访亲友', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (2, 2, '2026-03-15 00:00:05', '2026-03-15 12:00:55', NULL, '贺珍', '15010216622', '太原街商圈', '定期复查', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (70, 2, '2026-05-23 06:00:18', '2026-05-23 12:00:17', '2026-05-23 12:00:44', '邓兰', '15898861532', '和平广场', '散步休闲', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (55, 2, '2026-05-11 00:00:27', '2026-05-11 12:00:18', NULL, '傅珍', '18869805453', '辽宁省人民医院', '牙科检查', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (25, 1, '2026-04-10 01:00:33', '2026-04-10 09:00:33', '2026-04-10 09:00:29', '顾永', '18753206788', '辽宁省人民医院', '取药', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (46, 2, '2026-04-08 01:00:30', '2026-04-08 12:00:37', '2026-04-08 11:00:17', '雷明', '15838920950', '铁西万达', '参加社区活动', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (74, 3, '2026-05-27 03:00:08', '2026-05-27 09:00:50', NULL, '夏强', '13948396287', '浑南奥体中心', '探访亲友', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (50, 2, '2026-05-07 04:00:38', '2026-05-07 12:00:46', '2026-05-07 11:00:56', '丁桂', '15128406028', '浑南奥体中心', '家庭聚会', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (78, 2, '2026-03-28 08:00:17', '2026-03-28 11:00:02', NULL, '贺涛', '15079990492', '辽宁省人民医院', '取药', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (57, 3, '2026-05-07 07:00:24', '2026-05-07 12:00:25', '2026-05-07 13:00:57', '夏英', '13732390452', '铁西万达', '探访亲友', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (37, 1, '2026-04-11 04:00:35', '2026-04-11 09:00:55', '2026-04-11 13:00:45', '吴珍', '13611555214', '和平广场', '家庭聚会', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (13, 2, '2026-03-19 07:00:47', '2026-03-19 12:00:13', NULL, '程杰', '13654123267', '子女家中', '取药', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (61, 1, '2026-05-08 08:00:41', '2026-05-08 10:00:42', '2026-05-08 13:00:33', '雷英', '15161657461', '辽宁省人民医院', '购买日用品', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (23, 3, '2026-03-08 03:00:24', '2026-03-08 09:00:13', '2026-03-08 10:00:15', '朱兰', '13751930834', '辽宁省人民医院', '散步休闲', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (8, 1, '2026-03-12 04:00:47', '2026-03-12 11:00:40', '2026-03-12 13:00:42', '高桂', '13755464912', '辽宁省人民医院', '牙科检查', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (49, 3, '2026-03-21 06:00:45', '2026-03-21 10:00:29', NULL, '夏志', '13882169476', '沈阳医大一院', '取药', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (50, 1, '2026-05-21 03:00:07', '2026-05-21 10:00:08', NULL, '白娟', '15839872811', '和平广场', '购买日用品', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (49, 3, '2026-05-08 03:00:12', '2026-05-08 11:00:39', NULL, '龚德', '15150105788', '铁西万达', '购买日用品', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (54, 3, '2026-06-02 07:00:44', '2026-06-02 10:00:30', NULL, '叶军', '15859128967', '辽宁省人民医院', '探访亲友', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (22, 2, '2026-03-23 05:00:22', '2026-03-23 09:00:48', '2026-03-23 11:00:03', '阎淑', '15990575992', '和平广场', '购买日用品', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (5, 1, '2026-03-08 03:00:09', '2026-03-08 11:00:49', '2026-03-08 10:00:33', '秦玉', '15872431761', '沈阳医大一院', '定期复查', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (73, 3, '2026-04-21 06:00:54', '2026-04-21 10:00:34', NULL, '熊伟', '15848341181', '北陵公园', '购买日用品', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (59, 2, '2026-05-17 06:00:29', '2026-05-17 11:00:53', '2026-05-17 09:00:43', '张国', '18739697349', '太原街商圈', '探访亲友', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (78, 1, '2026-03-26 04:00:54', '2026-03-26 09:00:48', '2026-03-26 13:00:42', '江珍', '13642447050', '子女家中', '参加社区活动', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (71, 2, '2026-04-14 06:00:58', '2026-04-14 09:00:38', '2026-04-14 10:00:44', '郑国', '13882251713', '子女家中', '探访亲友', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (44, 3, '2026-04-22 03:00:32', '2026-04-22 12:00:51', '2026-04-22 10:00:08', '龚秀', '13878854524', '太原街商圈', '探访亲友', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (29, 1, '2026-05-04 00:00:34', '2026-05-04 11:00:34', NULL, '叶杰', '15017536334', '铁西万达', '牙科检查', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (62, 2, '2026-03-28 01:00:57', '2026-03-28 10:00:24', '2026-03-28 10:00:08', '程俊', '18794023364', '辽宁省人民医院', '取药', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (32, 2, '2026-03-28 07:00:16', '2026-03-28 10:00:22', '2026-03-28 13:00:47', '顾明', '15958055088', '铁西万达', '购买日用品', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (63, 3, '2026-04-08 00:00:03', '2026-04-08 11:00:46', '2026-04-08 13:00:45', '钟珍', '13731642413', '和平广场', '定期复查', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (54, 1, '2026-05-03 05:00:52', '2026-05-03 12:00:36', NULL, '邵英', '13712486836', '太原街商圈', '散步休闲', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (66, 2, '2026-05-15 05:00:34', '2026-05-15 09:00:23', '2026-05-15 10:00:46', '尹建', '15015171307', '和平广场', '取药', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (38, 2, '2026-05-27 01:00:43', '2026-05-27 10:00:08', '2026-05-27 11:00:15', '林淑', '18811078291', '北陵公园', '定期复查', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (60, 2, '2026-04-06 02:00:52', '2026-04-06 09:00:44', '2026-04-06 11:00:45', '蒋玉', '13877218427', '沈阳医大一院', '家庭聚会', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (33, 2, '2026-04-17 06:00:44', '2026-04-17 10:00:03', '2026-04-17 09:00:59', '邵桂', '15191658397', '铁西万达', '定期复查', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (20, 1, '2026-05-16 01:00:44', '2026-05-16 10:00:05', '2026-05-16 10:00:37', '赖伟', '13898511296', '浑南奥体中心', '探访亲友', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (17, 2, '2026-06-04 06:00:04', '2026-06-04 12:00:45', '2026-06-04 12:00:02', '邓国', '15869469999', '铁西万达', '散步休闲', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (15, 2, '2026-04-13 07:00:42', '2026-04-13 09:00:45', '2026-04-13 11:00:54', '邱俊', '13619393638', '和平广场', '取药', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (23, 1, '2026-04-19 00:00:38', '2026-04-19 10:00:55', NULL, '于淑', '13774761825', '辽宁省人民医院', '家庭聚会', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (42, 2, '2026-03-18 02:00:54', '2026-03-18 10:00:15', NULL, '文杰', '15976169547', '铁西万达', '探访亲友', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (31, 3, '2026-03-17 08:00:33', '2026-03-17 10:00:37', '2026-03-17 09:00:59', '赵斌', '15976061033', '和平广场', '探访亲友', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (49, 3, '2026-03-15 05:00:15', '2026-03-15 10:00:57', NULL, '姚丽', '15836763910', '浑南奥体中心', '购买日用品', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (47, 2, '2026-05-13 01:00:48', '2026-05-13 09:00:12', NULL, '范秀', '13696188315', '太原街商圈', '探访亲友', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (59, 2, '2026-04-26 08:00:40', '2026-04-26 11:00:28', '2026-04-26 09:00:23', '秦丽', '18782132162', '浑南奥体中心', '散步休闲', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (59, 1, '2026-04-28 02:00:33', '2026-04-28 10:00:50', '2026-04-28 09:00:28', '周娟', '15966832005', '子女家中', '牙科检查', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (26, 3, '2026-03-24 08:00:24', '2026-03-24 12:00:14', '2026-03-24 10:00:53', '姜芳', '18892764447', '浑南奥体中心', '参加社区活动', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (61, 2, '2026-04-02 01:00:06', '2026-04-02 12:00:29', '2026-04-02 10:00:07', '郭丽', '15950925415', '铁西万达', '牙科检查', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (57, 2, '2026-05-01 08:00:38', '2026-05-01 10:00:16', '2026-05-01 10:00:31', '徐玉', '18720657998', '子女家中', '探访亲友', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (9, 1, '2026-03-19 00:00:38', '2026-03-19 11:00:35', NULL, '康龙', '13985631044', '沈阳医大一院', '家庭聚会', 0);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (27, 1, '2026-05-02 08:00:32', '2026-05-02 12:00:34', '2026-05-02 11:00:54', '钟斌', '15986911526', '和平广场', '购买日用品', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (28, 1, '2026-05-01 01:00:52', '2026-05-01 10:00:01', '2026-05-01 11:00:22', '周华', '13939780770', '铁西万达', '购买日用品', 1);
INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (75, 1, '2026-05-22 04:00:28', '2026-05-22 09:00:40', '2026-05-22 12:00:30', '曹明', '13655636907', '浑南奥体中心', '定期复查', 1);
-- care_record
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (51, 22, '2026-06-01', '2026-06-01 04:00:24', 0, '');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (12, 18, '2026-05-23', '2026-05-23 08:00:14', 1, '老人今日情绪稳定');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (11, 37, '2026-05-08', '2026-05-08 06:00:19', 1, '老人今日情绪稳定');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (62, 52, '2026-06-01', '2026-06-01 02:00:16', 1, '');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (31, 8, '2026-05-15', '2026-05-14 23:00:26', 2, '血压正常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (62, 17, '2026-05-12', '2026-05-12 02:00:30', 1, '已完成，老人配合良好');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (11, 1, '2026-05-26', '2026-05-26 02:00:09', 1, '已完成，老人配合良好');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (29, 8, '2026-05-22', '2026-05-22 06:00:48', 0, '需继续观察');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (1, 18, '2026-05-22', '2026-05-22 00:00:27', 1, '老人拒绝，已跳过');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (21, 27, '2026-05-09', '2026-05-09 07:00:26', 1, '');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (39, 50, '2026-06-02', '2026-06-02 09:00:40', 1, '');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (15, 21, '2026-05-13', '2026-05-13 02:00:48', 2, '执行完毕，无异常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (27, 6, '2026-05-27', '2026-05-27 04:00:47', 2, '需继续观察');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (9, 17, '2026-05-27', '2026-05-27 04:00:25', 1, '老人拒绝，已跳过');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (11, 48, '2026-06-04', '2026-06-03 22:00:31', 1, '');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (76, 22, '2026-06-01', '2026-06-01 02:00:15', 1, '老人拒绝，已跳过');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (1, 47, '2026-05-09', '2026-05-09 03:00:19', 1, '血压正常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (7, 11, '2026-05-23', '2026-05-23 06:00:40', 1, '已完成，老人配合良好');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (25, 33, '2026-05-31', '2026-05-31 10:00:16', 1, '');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (68, 31, '2026-05-21', '2026-05-21 11:00:19', 2, '执行完毕，无异常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (3, 3, '2026-05-20', '2026-05-19 23:00:31', 2, '');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (27, 37, '2026-05-16', '2026-05-16 12:00:50', 0, '已完成，老人配合良好');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (75, 42, '2026-05-12', '2026-05-12 06:00:37', 1, '需继续观察');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (46, 12, '2026-05-17', '2026-05-17 09:00:05', 1, '需继续观察');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (73, 18, '2026-05-20', '2026-05-20 07:00:04', 1, '需继续观察');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (42, 38, '2026-05-11', '2026-05-10 23:00:23', 1, '血压正常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (32, 42, '2026-05-21', '2026-05-21 01:00:54', 1, '需继续观察');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (6, 40, '2026-06-04', '2026-06-04 08:00:39', 1, '老人拒绝，已跳过');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (1, 9, '2026-05-20', '2026-05-20 11:00:53', 1, '执行完毕，无异常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (16, 7, '2026-05-23', '2026-05-23 01:00:16', 1, '老人今日情绪稳定');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (16, 48, '2026-05-23', '2026-05-23 12:00:08', 1, '执行完毕，无异常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (75, 35, '2026-05-05', '2026-05-05 02:00:02', 1, '需继续观察');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (49, 44, '2026-05-10', '2026-05-10 09:00:12', 2, '执行完毕，无异常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (32, 38, '2026-05-27', '2026-05-27 12:00:04', 0, '血压正常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (37, 44, '2026-05-23', '2026-05-23 08:00:22', 0, '执行完毕，无异常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (39, 21, '2026-05-22', '2026-05-21 23:00:32', 1, '执行完毕，无异常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (20, 5, '2026-05-29', '2026-05-29 07:00:41', 0, '血压正常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (42, 43, '2026-05-12', '2026-05-11 22:00:55', 0, '已完成，老人配合良好');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (51, 43, '2026-05-18', '2026-05-18 09:00:54', 1, '老人今日情绪稳定');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (50, 52, '2026-05-15', '2026-05-15 12:00:12', 1, '需继续观察');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (63, 22, '2026-05-29', '2026-05-28 23:00:46', 0, '已完成，老人配合良好');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (65, 7, '2026-06-03', '2026-06-03 04:00:53', 2, '');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (1, 22, '2026-06-01', '2026-06-01 09:00:02', 1, '已完成，老人配合良好');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (60, 31, '2026-06-03', '2026-06-03 01:00:32', 2, '老人拒绝，已跳过');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (65, 18, '2026-05-08', '2026-05-08 10:00:36', 1, '');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (66, 14, '2026-05-27', '2026-05-27 02:00:57', 2, '已完成，老人配合良好');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (37, 3, '2026-05-31', '2026-05-31 10:00:02', 1, '老人今日情绪稳定');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (45, 24, '2026-05-16', '2026-05-16 11:00:47', 0, '老人今日情绪稳定');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (39, 6, '2026-05-16', '2026-05-16 09:00:27', 1, '老人今日情绪稳定');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (74, 40, '2026-06-03', '2026-06-03 10:00:14', 1, '需继续观察');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (31, 49, '2026-05-26', '2026-05-26 06:00:31', 1, '');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (49, 41, '2026-05-20', '2026-05-20 09:00:24', 1, '需继续观察');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (74, 33, '2026-05-18', '2026-05-18 01:00:02', 1, '执行完毕，无异常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (61, 12, '2026-05-26', '2026-05-26 11:00:52', 1, '执行完毕，无异常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (39, 32, '2026-06-01', '2026-05-31 23:00:10', 2, '老人拒绝，已跳过');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (45, 32, '2026-05-21', '2026-05-21 02:00:38', 1, '');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (23, 45, '2026-05-17', '2026-05-17 01:00:26', 2, '老人今日情绪稳定');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (15, 50, '2026-05-18', '2026-05-18 09:00:58', 0, '血压正常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (47, 19, '2026-05-14', '2026-05-14 05:00:31', 1, '需继续观察');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (59, 7, '2026-05-29', '2026-05-29 02:00:53', 0, '血压正常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (64, 14, '2026-05-21', '2026-05-21 04:00:08', 2, '老人今日情绪稳定');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (60, 47, '2026-05-29', '2026-05-29 00:00:09', 1, '血压正常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (24, 40, '2026-05-31', '2026-05-31 01:00:21', 2, '老人今日情绪稳定');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (10, 42, '2026-05-28', '2026-05-28 04:00:56', 1, '执行完毕，无异常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (28, 31, '2026-06-01', '2026-06-01 06:00:55', 1, '老人今日情绪稳定');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (61, 50, '2026-05-05', '2026-05-05 08:00:33', 1, '已完成，老人配合良好');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (10, 11, '2026-05-09', '2026-05-09 06:00:45', 1, '');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (14, 26, '2026-05-19', '2026-05-18 22:00:31', 0, '老人今日情绪稳定');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (2, 28, '2026-05-12', '2026-05-12 10:00:55', 2, '老人拒绝，已跳过');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (51, 11, '2026-05-27', '2026-05-27 06:00:59', 0, '执行完毕，无异常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (11, 40, '2026-05-13', '2026-05-13 10:00:17', 1, '');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (1, 16, '2026-05-17', '2026-05-17 09:00:38', 0, '血压正常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (54, 11, '2026-05-20', '2026-05-20 01:00:30', 0, '执行完毕，无异常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (10, 26, '2026-05-21', '2026-05-21 07:00:56', 0, '血压正常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (52, 32, '2026-05-30', '2026-05-29 22:00:58', 0, '执行完毕，无异常');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (29, 32, '2026-05-21', '2026-05-21 08:00:56', 1, '已完成，老人配合良好');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (48, 45, '2026-06-02', '2026-06-02 01:00:46', 1, '');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (53, 22, '2026-05-08', '2026-05-08 04:00:14', 1, '老人拒绝，已跳过');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (27, 41, '2026-05-10', '2026-05-10 05:00:14', 0, '已完成，老人配合良好');
INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (64, 52, '2026-05-12', '2026-05-12 00:00:49', 0, '血压正常');
-- meal_calendar
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-06', 1, '紫米粥、包子、豆腐乳', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-06', 2, '清蒸鲈鱼、西红柿炒蛋、米饭、玉米排骨汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-06', 3, '馄饨、凉拌黄瓜', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-07', 1, '豆浆、油条、茶叶蛋、咸菜', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-07', 2, '清蒸鲈鱼、西红柿炒蛋、米饭、玉米排骨汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-07', 3, '疙瘩汤、拌三丝', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-08', 1, '燕麦粥、煎蛋、清炒时蔬', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-08', 2, '软烂红烧肉、炖豆腐、米饭、银耳莲子羹', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-08', 3, '馄饨、凉拌黄瓜', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-09', 1, '豆浆、油条、茶叶蛋、咸菜', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-09', 2, '清蒸鲈鱼、西红柿炒蛋、米饭、玉米排骨汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-09', 3, '杂粮饭、蒸蛋羹、清炒豆角', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-10', 1, '燕麦粥、煎蛋、清炒时蔬', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-10', 2, '软烂红烧肉、炖豆腐、米饭、银耳莲子羹', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-10', 3, '蔬菜瘦肉粥、蒸南瓜、清炒小白菜', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-11', 1, '小米粥、水煮蛋、花卷、拌黄瓜', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-11', 2, '滑溜里脊、素炒三丝、米饭、山药汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-11', 3, '疙瘩汤、拌三丝', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-12', 1, '小米粥、水煮蛋、花卷、拌黄瓜', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-12', 2, '红烧鲤鱼、清炒西兰花、米饭、紫菜蛋花汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-12', 3, '面条、西红柿卤、拌海带丝', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-13', 1, '豆浆、油条、茶叶蛋、咸菜', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-13', 2, '清蒸鲈鱼、西红柿炒蛋、米饭、玉米排骨汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-13', 3, '疙瘩汤、拌三丝', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-14', 1, '南瓜粥、蒸饺、凉拌木耳', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-14', 2, '土豆炖牛肉、蒜蓉菠菜、米饭、冬瓜汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-14', 3, '杂粮饭、蒸蛋羹、清炒豆角', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-15', 1, '南瓜粥、蒸饺、凉拌木耳', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-15', 2, '清蒸鲈鱼、西红柿炒蛋、米饭、玉米排骨汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-15', 3, '馄饨、凉拌黄瓜', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-16', 1, '南瓜粥、蒸饺、凉拌木耳', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-16', 2, '软烂红烧肉、炖豆腐、米饭、银耳莲子羹', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-16', 3, '蔬菜瘦肉粥、蒸南瓜、清炒小白菜', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-17', 1, '豆浆、油条、茶叶蛋、咸菜', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-17', 2, '黄焖鸡、清炒油麦菜、米饭、番茄蛋汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-17', 3, '面条、西红柿卤、拌海带丝', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-18', 1, '紫米粥、包子、豆腐乳', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-18', 2, '土豆炖牛肉、蒜蓉菠菜、米饭、冬瓜汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-18', 3, '蔬菜瘦肉粥、蒸南瓜、清炒小白菜', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-19', 1, '豆浆、油条、茶叶蛋、咸菜', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-19', 2, '滑溜里脊、素炒三丝、米饭、山药汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-19', 3, '馄饨、凉拌黄瓜', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-20', 1, '豆浆、油条、茶叶蛋、咸菜', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-20', 2, '红烧鲤鱼、清炒西兰花、米饭、紫菜蛋花汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-20', 3, '蔬菜瘦肉粥、蒸南瓜、清炒小白菜', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-21', 1, '小米粥、水煮蛋、花卷、拌黄瓜', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-21', 2, '土豆炖牛肉、蒜蓉菠菜、米饭、冬瓜汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-21', 3, '疙瘩汤、拌三丝', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-22', 1, '燕麦粥、煎蛋、清炒时蔬', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-22', 2, '滑溜里脊、素炒三丝、米饭、山药汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-22', 3, '蔬菜瘦肉粥、蒸南瓜、清炒小白菜', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-23', 1, '牛奶、全麦面包、香蕉', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-23', 2, '清蒸鲈鱼、西红柿炒蛋、米饭、玉米排骨汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-23', 3, '山药粥、清炒时蔬、蒸红薯', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-24', 1, '南瓜粥、蒸饺、凉拌木耳', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-24', 2, '软烂红烧肉、炖豆腐、米饭、银耳莲子羹', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-24', 3, '杂粮饭、蒸蛋羹、清炒豆角', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-25', 1, '南瓜粥、蒸饺、凉拌木耳', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-25', 2, '红烧鲤鱼、清炒西兰花、米饭、紫菜蛋花汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-25', 3, '疙瘩汤、拌三丝', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-26', 1, '南瓜粥、蒸饺、凉拌木耳', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-26', 2, '软烂红烧肉、炖豆腐、米饭、银耳莲子羹', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-26', 3, '馄饨、凉拌黄瓜', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-27', 1, '紫米粥、包子、豆腐乳', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-27', 2, '滑溜里脊、素炒三丝、米饭、山药汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-27', 3, '疙瘩汤、拌三丝', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-28', 1, '牛奶、全麦面包、香蕉', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-28', 2, '清蒸鲈鱼、西红柿炒蛋、米饭、玉米排骨汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-28', 3, '杂粮饭、蒸蛋羹、清炒豆角', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-29', 1, '南瓜粥、蒸饺、凉拌木耳', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-29', 2, '红烧鲤鱼、清炒西兰花、米饭、紫菜蛋花汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-29', 3, '杂粮饭、蒸蛋羹、清炒豆角', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-30', 1, '南瓜粥、蒸饺、凉拌木耳', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-30', 2, '红烧鲤鱼、清炒西兰花、米饭、紫菜蛋花汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-30', 3, '山药粥、清炒时蔬、蒸红薯', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-31', 1, '燕麦粥、煎蛋、清炒时蔬', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-31', 2, '清蒸鲈鱼、西红柿炒蛋、米饭、玉米排骨汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-05-31', 3, '蔬菜瘦肉粥、蒸南瓜、清炒小白菜', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-06-01', 1, '豆浆、油条、茶叶蛋、咸菜', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-06-01', 2, '软烂红烧肉、炖豆腐、米饭、银耳莲子羹', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-06-01', 3, '蔬菜瘦肉粥、蒸南瓜、清炒小白菜', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-06-02', 1, '小米粥、水煮蛋、花卷、拌黄瓜', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-06-02', 2, '滑溜里脊、素炒三丝、米饭、山药汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-06-02', 3, '馄饨、凉拌黄瓜', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-06-03', 1, '小米粥、水煮蛋、花卷、拌黄瓜', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-06-03', 2, '红烧鲤鱼、清炒西兰花、米饭、紫菜蛋花汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-06-03', 3, '馄饨、凉拌黄瓜', '易消化，适合老年人口味', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-06-04', 1, '豆浆、油条、茶叶蛋、咸菜', '低盐低油，富含膳食纤维', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-06-04', 2, '土豆炖牛肉、蒜蓉菠菜、米饭、冬瓜汤', '蛋白质充足，搭配时令蔬菜', '中心统一配餐');
INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('2026-06-04', 3, '杂粮饭、蒸蛋羹、清炒豆角', '易消化，适合老年人口味', '中心统一配餐');
-- meal_plan
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (1, '低嘌呤饮食', '糖尿病餐', '喜食鱼类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (2, '流食', '少油少盐', '喜食清淡');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (3, '忌辛辣', '无', '喜食软烂');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (4, '忌辛辣', '少油少盐', '喜食清淡');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (5, '高蛋白饮食', '糖尿病餐', '喜食粥类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (6, '忌辛辣', '无', '无特殊偏好');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (7, '高蛋白饮食', '无', '喜食粥类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (8, '高蛋白饮食', '糖尿病餐', '喜食粥类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (9, '低糖饮食', '少油少盐', '喜食鱼类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (10, '低盐饮食', '需切碎食物', '喜食软烂');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (11, '无特殊禁忌', '无', '喜食鱼类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (12, '流食', '无', '无特殊偏好');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (13, '软食', '糖尿病餐', '喜食蔬菜');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (14, '软食', '少油少盐', '喜食粥类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (15, '高蛋白饮食', '无', '喜食面食');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (16, '无特殊禁忌', '需切碎食物', '喜食清淡');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (17, '低盐饮食', '需鼻饲', '喜食软烂');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (18, '高蛋白饮食', '无', '喜食蔬菜');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (19, '高蛋白饮食', '糖尿病餐', '喜食软烂');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (20, '软食', '糖尿病餐', '喜食蔬菜');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (21, '软食', '少油少盐', '喜食面食');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (22, '忌辛辣', '无', '喜食粥类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (23, '无特殊禁忌', '少油少盐', '喜食软烂');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (24, '软食', '需鼻饲', '喜食鱼类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (25, '低糖饮食', '少油少盐', '无特殊偏好');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (26, '无特殊禁忌', '糖尿病餐', '喜食粥类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (27, '低糖饮食', '需喂食协助', '喜食清淡');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (28, '低盐饮食', '需鼻饲', '无特殊偏好');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (29, '忌辛辣', '无', '喜食粥类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (30, '软食', '需喂食协助', '喜食清淡');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (31, '低盐饮食', '需鼻饲', '喜食鱼类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (32, '低嘌呤饮食', '需喂食协助', '喜食清淡');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (33, '软食', '需鼻饲', '喜食鱼类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (34, '软食', '需切碎食物', '喜食面食');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (35, '低嘌呤饮食', '需喂食协助', '喜食清淡');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (36, '低盐饮食', '需喂食协助', '喜食软烂');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (37, '高蛋白饮食', '少油少盐', '喜食蔬菜');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (38, '忌辛辣', '需切碎食物', '喜食蔬菜');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (39, '软食', '需鼻饲', '喜食清淡');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (40, '忌辛辣', '少油少盐', '喜食面食');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (41, '低嘌呤饮食', '少油少盐', '喜食清淡');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (42, '软食', '少油少盐', '喜食软烂');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (43, '高蛋白饮食', '无', '喜食清淡');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (44, '软食', '需喂食协助', '喜食蔬菜');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (45, '无特殊禁忌', '少油少盐', '无特殊偏好');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (46, '忌辛辣', '需鼻饲', '喜食清淡');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (47, '低嘌呤饮食', '糖尿病餐', '喜食面食');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (48, '无特殊禁忌', '无', '喜食鱼类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (49, '无特殊禁忌', '需切碎食物', '喜食面食');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (50, '低嘌呤饮食', '需切碎食物', '喜食软烂');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (51, '软食', '需切碎食物', '喜食粥类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (52, '流食', '无', '喜食粥类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (53, '软食', '无', '喜食粥类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (54, '低嘌呤饮食', '少油少盐', '无特殊偏好');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (55, '流食', '需切碎食物', '喜食粥类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (56, '低盐饮食', '需鼻饲', '喜食鱼类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (57, '低糖饮食', '无', '喜食软烂');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (58, '无特殊禁忌', '糖尿病餐', '喜食清淡');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (59, '忌辛辣', '需喂食协助', '喜食蔬菜');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (60, '流食', '需喂食协助', '喜食粥类');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (61, '无特殊禁忌', '无', '喜食软烂');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (62, '流食', '需切碎食物', '喜食面食');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (63, '无特殊禁忌', '需鼻饲', '喜食蔬菜');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (64, '低盐饮食', '少油少盐', '无特殊偏好');
INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (65, '高蛋白饮食', '无', '喜食粥类');
-- service_subscription
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (4, 7, '2025-12-09', '2026-09-25', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (26, 1, '2026-04-24', '2027-02-13', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (8, 3, '2025-11-10', '2027-08-05', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (59, 26, '2025-08-02', '2026-10-11', 2, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (76, 24, '2026-01-30', '2026-09-02', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (67, 48, '2025-10-09', '2027-03-27', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (21, 25, '2025-10-14', '2027-08-19', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (77, 3, '2025-12-14', '2027-05-04', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (44, 6, '2025-11-01', '2027-04-08', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (31, 23, '2026-01-26', '2027-07-08', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (7, 35, '2025-08-14', '2026-03-15', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (35, 43, '2025-12-19', '2027-03-26', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (8, 31, '2025-08-27', '2027-04-08', 2, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (28, 48, '2026-03-14', '2027-02-12', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (28, 6, '2026-05-04', '2027-09-29', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (57, 13, '2026-02-23', '2026-05-09', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (19, 50, '2025-08-04', '2026-06-25', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (47, 8, '2026-04-04', '2027-11-28', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (20, 2, '2025-08-08', '2026-06-24', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (36, 11, '2025-10-27', '2026-03-05', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (12, 15, '2026-04-05', '2027-12-05', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (69, 20, '2026-05-03', '2026-11-12', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (50, 34, '2025-12-31', '2027-02-28', 2, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (29, 13, '2026-04-17', '2027-03-08', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (45, 28, '2025-07-30', '2026-01-10', 3, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (15, 8, '2026-02-26', '2027-10-19', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (33, 18, '2025-11-29', '2026-03-24', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (3, 34, '2025-12-20', '2026-11-03', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (7, 2, '2026-01-15', '2027-11-06', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (39, 36, '2026-03-02', '2027-05-23', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (11, 5, '2026-04-20', '2026-06-26', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (72, 43, '2026-04-21', '2026-12-22', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (21, 16, '2026-01-10', '2026-08-22', 2, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (29, 33, '2025-12-02', '2027-08-13', 2, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (2, 18, '2025-08-16', '2026-11-18', 3, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (12, 22, '2026-03-17', '2027-09-26', 2, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (77, 41, '2026-01-21', '2027-08-24', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (26, 23, '2026-01-03', '2027-03-05', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (63, 39, '2025-12-30', '2026-09-22', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (42, 36, '2025-12-07', '2027-05-03', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (58, 22, '2025-07-17', '2026-06-04', 2, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (60, 36, '2025-08-01', '2026-06-13', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (67, 38, '2026-03-17', '2027-11-01', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (42, 11, '2025-11-16', '2026-12-24', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (8, 42, '2026-01-01', '2027-01-14', 3, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (32, 27, '2026-02-12', '2027-09-20', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (77, 38, '2026-03-31', '2026-08-21', 2, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (22, 4, '2026-02-19', '2027-10-19', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (19, 1, '2026-01-15', '2026-07-06', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (77, 23, '2025-11-19', '2027-06-23', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (23, 2, '2026-01-01', '2027-02-24', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (12, 8, '2025-07-25', '2027-01-20', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (23, 47, '2026-04-14', '2027-07-03', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (76, 1, '2025-08-20', '2026-02-02', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (31, 30, '2025-09-14', '2027-02-15', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (24, 14, '2025-09-14', '2025-11-15', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (27, 17, '2026-02-08', '2026-03-28', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (47, 19, '2025-07-27', '2027-03-27', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (15, 24, '2025-11-27', '2027-05-13', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (23, 25, '2025-06-15', '2027-02-27', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (7, 38, '2025-10-03', '2027-08-08', 2, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (61, 18, '2025-12-24', '2027-02-03', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (20, 6, '2025-11-17', '2027-04-17', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (69, 18, '2025-10-27', '2027-03-04', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (57, 27, '2025-12-25', '2027-08-02', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (48, 42, '2026-01-17', '2027-07-22', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (63, 22, '2025-11-27', '2027-03-03', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (36, 8, '2025-09-10', '2025-11-05', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (61, 24, '2025-12-25', '2026-03-06', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (14, 23, '2026-03-06', '2027-09-13', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (14, 30, '2025-08-06', '2027-02-02', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (29, 43, '2026-03-09', '2026-10-13', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (36, 31, '2026-01-01', '2026-09-26', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (75, 17, '2025-11-07', '2026-12-03', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (16, 20, '2025-11-13', '2026-08-27', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (15, 19, '2026-01-29', '2027-07-24', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (5, 43, '2025-12-30', '2026-03-31', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (68, 45, '2026-03-09', '2026-07-28', 3, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (63, 47, '2026-02-10', '2027-11-30', 1, '老人及家属已确认');
INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (77, 48, '2025-08-19', '2026-07-22', 1, '老人及家属已确认');
COMMIT;
SET FOREIGN_KEY_CHECKS = 1;