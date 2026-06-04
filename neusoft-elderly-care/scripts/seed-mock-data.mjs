/**
 * 东软颐养中心 — Mock 数据种子脚本
 * 用法: node scripts/seed-mock-data.mjs
 */
import { execSync } from 'child_process';
import { writeFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __dirname = dirname(fileURLToPath(import.meta.url));
const MYSQL = 'mysql -u root -p123456 --default-character-set=utf8mb4 elderly_care';

const SURNAMES = '王李张刘陈杨赵黄周吴徐孙胡朱高林何郭马罗梁宋郑谢韩唐冯于董萧程曹袁邓许傅沈曾彭吕苏卢蒋蔡贾丁魏薛叶阎余潘杜戴夏钟汪田任姜范方石姚谭廖邹熊金陆郝孔白崔康毛邱秦江史顾侯邵孟龙万段雷钱汤尹黎易常武乔贺赖龚文'.split('');
const MALE_NAMES = '建国志强伟明德华永军建平国强文斌海涛云龙志明俊杰德明'.split('');
const FEMALE_NAMES = '秀英桂兰玉兰淑珍桂英秀兰丽华秀珍淑兰淑英秀梅丽娟桂芳'.split('');
const PROVINCES = [
  { province: '辽宁省', city: '沈阳市', district: '和平区', code: '210102' },
  { province: '辽宁省', city: '沈阳市', district: '沈河区', code: '210103' },
  { province: '辽宁省', city: '大连市', district: '中山区', code: '210202' },
  { province: '辽宁省', city: '鞍山市', district: '铁东区', code: '210302' },
  { province: '吉林省', city: '长春市', district: '朝阳区', code: '220104' },
];
const STREETS = ['青年大街', '文化路', '建设大路', '和平北街', '南京街', '三好街', '浑南中路', '沈辽路', '北陵大街', '望花街'];
const HEALTH = [
  '高血压，需每日监测血压', '2型糖尿病，饮食需控糖', '轻度认知障碍，需专人看护',
  '冠心病，行动略不便', '关节炎，上下楼梯需协助', '健康状况良好，生活可自理',
  '慢性支气管炎，冬季需注意保暖', '帕金森早期，需康复训练', '术后恢复中，需定期换药',
  '听力下降，需大声交流', '骨质疏松，防跌倒', '白内障术后，视力尚可',
];
const ALLERGIES = ['青霉素过敏', '海鲜过敏', '无', '花粉过敏', '牛奶不耐受', '无', '磺胺类药物过敏', '无'];
const MEAL_BREAKFAST = [
  '小米粥、水煮蛋、花卷、拌黄瓜', '豆浆、油条、茶叶蛋、咸菜', '牛奶、全麦面包、香蕉',
  '南瓜粥、蒸饺、凉拌木耳', '燕麦粥、煎蛋、清炒时蔬', '紫米粥、包子、豆腐乳',
];
const MEAL_LUNCH = [
  '红烧鲤鱼、清炒西兰花、米饭、紫菜蛋花汤', '土豆炖牛肉、蒜蓉菠菜、米饭、冬瓜汤',
  '清蒸鲈鱼、西红柿炒蛋、米饭、玉米排骨汤', '黄焖鸡、清炒油麦菜、米饭、番茄蛋汤',
  '软烂红烧肉、炖豆腐、米饭、银耳莲子羹', '滑溜里脊、素炒三丝、米饭、山药汤',
];
const MEAL_DINNER = [
  '蔬菜瘦肉粥、蒸南瓜、清炒小白菜', '面条、西红柿卤、拌海带丝', '馄饨、凉拌黄瓜',
  '杂粮饭、蒸蛋羹、清炒豆角', '山药粥、清炒时蔬、蒸红薯', '疙瘩汤、拌三丝',
];
const SERVICES = [
  ['每日健康巡检', 1, '护理员每日两次测量体温、血压'], ['房间清洁消毒', 1, '每周深度清洁两次'],
  ['洗衣服务', 1, '衣物清洗、熨烫、整理'], ['24小时呼叫响应', 1, '床头呼叫铃即时响应'],
  ['助浴服务', 2, '专业护理员协助洗浴'], ['理发修面', 2, '每月定期理发修面'],
  ['老年大学课程', 2, '书法、绘画、合唱等文娱活动'], ['生日关怀', 2, '生日当天赠送蛋糕和祝福'],
  ['陪同就医', 3, '专人陪同前往医院复诊'], ['康复理疗', 3, '物理治疗、按摩理疗'],
  ['心理咨询', 3, '专业心理咨询师定期访谈'], ['营养配餐指导', 3, '营养师定制膳食方案'],
  ['远程视频探视', 2, '协助家属视频连线'], ['口腔护理', 1, '每日口腔清洁护理'],
  ['翻身拍背', 1, '卧床老人定时翻身拍背'], ['吸氧服务', 3, '低流量吸氧监护'],
  ['血糖监测', 3, '每日三餐前后血糖记录'], ['用药提醒', 1, '按时发放并监督服药'],
  ['散步陪伴', 2, '天气适宜时陪同园区散步'], ['节令关怀', 2, '传统节日慰问与活动'],
];
const CARE_ITEMS_EXTRA = [
  ['口腔护理', 1, '每日2次', '协助刷牙、漱口'], ['指甲修剪', 1, '每周1次', '修剪手指甲、脚趾甲'],
  ['理发', 1, '每月1次', '基础理发服务'], ['换洗衣物', 1, '每日1次', '更换脏衣物'],
  ['房间整理', 1, '每日1次', '整理房间物品'], ['测量体温', 2, '每日2次', '早晚各测一次'],
  ['测量血糖', 2, '每日1次', '空腹血糖监测'], ['协助如厕', 2, '按需', '协助上厕所'],
  ['协助洗澡', 2, '每周2次', '协助洗浴'], ['皮肤检查', 2, '每日1次', '检查皮肤完整性'],
  ['饮水提醒', 2, '每日3次', '提醒适量饮水'], ['喂食', 3, '每日3次', '完全不能自理者喂食'],
  ['鼻饲护理', 3, '每日3次', '鼻饲管护理'], ['导尿管护理', 3, '每日2次', '导尿管清洁消毒'],
  ['压疮预防', 3, '每2小时1次', '翻身、按摩'], ['肢体按摩', 3, '每日2次', '促进血液循环'],
  ['被动运动', 3, '每日1次', '关节被动活动'], ['认知训练', 4, '每周3次', '记忆力、注意力训练'],
  ['语言训练', 4, '每周2次', '语言功能康复'], ['平衡训练', 4, '每周3次', '防跌倒训练'],
  ['步态训练', 4, '每周3次', '行走能力训练'], ['心理疏导', 4, '每周1次', '情绪支持与疏导'],
  ['疼痛评估', 2, '每日1次', '评估疼痛等级'], ['睡眠记录', 1, '每日1次', '记录睡眠质量'],
  ['排泄记录', 2, '每日1次', '记录大小便情况'], ['体重监测', 2, '每周1次', '监测体重变化'],
  ['血氧监测', 2, '每日1次', '指脉氧饱和度'], ['心电监测', 3, '每周1次', '心电图检查'],
  ['伤口换药', 3, '按需', '外科伤口护理'], ['胰岛素注射', 3, '每日1次', '协助胰岛素注射'],
  ['雾化吸入', 3, '每日2次', '呼吸道雾化治疗'], ['吸痰', 3, '按需', '气道吸痰护理'],
  ['临终关怀', 4, '持续', '生命末期舒适护理'], ['家属沟通', 1, '每周1次', '向家属反馈状况'],
  ['活动参与', 2, '每周2次', '组织参加文娱活动'], ['阳光浴', 2, '每周3次', '天气好时户外晒太阳'],
  ['足底按摩', 2, '每周2次', '促进血液循环'], ['耳部清洁', 1, '每周1次', '清洁外耳道'],
  ['眼部护理', 2, '每日1次', '清洁眼周'], ['会阴护理', 3, '每日1次', '会阴部清洁'],
  ['防坠床', 3, '持续', '床栏防护检查'], ['防走失', 2, '持续', '认知障碍者定位监护'],
  ['营养评估', 2, '每月1次', '评估营养状况'], ['跌倒风险评估', 2, '每月1次', 'Morse量表评估'],
  ['药物核对', 2, '每日1次', '核对用药清单'], ['陪同散步', 2, '每日1次', '园区散步30分钟'],
  ['读报陪聊', 2, '每周3次', '读书读报、聊天陪伴'],
];

function pick(arr) { return arr[Math.floor(Math.random() * arr.length)]; }
function randInt(min, max) { return min + Math.floor(Math.random() * (max - min + 1)); }
function pad2(n) { return String(n).padStart(2, '0'); }
function esc(s) { return String(s ?? '').replace(/\\/g, '\\\\').replace(/'/g, "''"); }

function genName(gender) {
  const surname = pick(SURNAMES);
  const given = gender === 1 ? pick(MALE_NAMES) : pick(FEMALE_NAMES);
  return surname + given;
}

function genIdCard(birthYear, regionCode) {
  const y = birthYear;
  const m = pad2(randInt(1, 12));
  const d = pad2(randInt(1, 28));
  const seq = String(randInt(100, 999));
  return `${regionCode}${y}${m}${d}${seq}${randInt(0, 9)}`;
}

function genPhone() {
  const prefixes = ['138', '139', '136', '137', '158', '159', '188', '187', '150', '151'];
  return pick(prefixes) + String(randInt(10000000, 99999999));
}

function dateStr(offsetDays = 0) {
  const d = new Date();
  d.setDate(d.getDate() + offsetDays);
  return d.toISOString().slice(0, 10);
}

function datetimeStr(offsetDays = 0, hour = 8, minute = 0) {
  const d = new Date();
  d.setDate(d.getDate() + offsetDays);
  d.setHours(hour, minute, randInt(0, 59), 0);
  return d.toISOString().slice(0, 19).replace('T', ' ');
}

function buildSql() {
  const sql = [];
  sql.push('SET NAMES utf8mb4;');
  sql.push('SET FOREIGN_KEY_CHECKS = 0;');
  sql.push('START TRANSACTION;');

  // --- 护理内容补至 50 条 ---
  sql.push('-- care_item');
  CARE_ITEMS_EXTRA.forEach(([name, levelId, freq, desc], i) => {
    sql.push(`INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('${esc(name)}', ${levelId}, '${esc(freq)}', '${esc(desc)}', ${10 + i});`);
  });

  // --- 房间 50 间 ---
  sql.push('-- room');
  const roomSpecs = [];
  for (let floor = 1; floor <= 5; floor++) {
    for (let num = 1; num <= 10; num++) {
      const roomNo = `${floor}${pad2(num)}`;
      if (['101', '102', '201', '202'].includes(roomNo)) continue;
      const roomType = num <= 2 ? 1 : num <= 7 ? 2 : 3;
      const capacity = roomType === 1 ? 1 : roomType === 2 ? 2 : 4;
      const status = Math.random() < 0.05 ? 2 : 1;
      const remark = roomType === 1 ? '豪华单人间' : roomType === 2 ? '标准双人间' : '经济多人间';
      roomSpecs.push({ roomNo, floor, roomType, capacity, status, remark });
    }
  }
  roomSpecs.slice(0, 46).forEach(r => {
    sql.push(`INSERT INTO room (room_no, room_type, floor, capacity, status, remark) VALUES ('${r.roomNo}', ${r.roomType}, ${r.floor}, ${r.capacity}, ${r.status}, '${esc(r.remark)}');`);
  });

  // --- 床位：为新房间生成 ---
  sql.push('-- bed (new rooms)');
  sql.push(`SET @bed_start_id = (SELECT IFNULL(MAX(id), 0) FROM bed);`);
  sql.push(`SET @room_start_id = (SELECT IFNULL(MIN(id), 0) FROM room WHERE room_no NOT IN ('101','102','201','202'));`);
  // 用子查询批量插入较复杂，改为逐房间生成占位，执行后通过变量关联
  // 改为：先插入房间，脚本第二部分用 SELECT 查 room id

  // --- 服务补至 50 条 ---
  sql.push('-- service');
  for (let i = 0; i < 46; i++) {
    const base = SERVICES[i % SERVICES.length];
    const suffix = i >= SERVICES.length ? `（${Math.floor(i / SERVICES.length) + 1}）` : '';
    const status = Math.random() < 0.92 ? 1 : 0;
    sql.push(`INSERT INTO service (service_name, service_type, description, status) VALUES ('${esc(base[0] + suffix)}', ${base[1]}, '${esc(base[2])}', ${status});`);
  }

  sql.push('COMMIT;');
  sql.push('SET FOREIGN_KEY_CHECKS = 1;');
  return sql.join('\n');
}

function buildSqlPhase2(roomRows, bedRows, elderlyRows) {
  const sql = [];
  sql.push('SET NAMES utf8mb4;');
  sql.push('SET FOREIGN_KEY_CHECKS = 0;');
  sql.push('START TRANSACTION;');

  // 床位
  sql.push('-- bed');
  bedRows.forEach(b => {
    sql.push(`INSERT INTO bed (room_id, bed_no, status) VALUES (${b.roomId}, '${b.bedNo}', 0);`);
  });

  // 老人 80 人
  sql.push('-- elderly');
  elderlyRows.forEach((e, idx) => {
    sql.push(`INSERT INTO elderly (name, phone, gender, age, id_card, country, province, city, address_detail, address, health_condition, allergy_info, emergency_contact, emergency_phone, care_level_id, status, check_in_date, create_time) VALUES ('${esc(e.name)}', '${e.phone}', ${e.gender}, ${e.age}, '${e.idCard}', '中国', '${esc(e.province)}', '${esc(e.city)}', '${esc(e.addressDetail)}', '${esc(e.fullAddress)}', '${esc(e.health)}', '${esc(e.allergy)}', '${esc(e.emergencyContact)}', '${e.emergencyPhone}', ${e.careLevelId}, ${e.status}, '${e.checkInDate}', '${e.createTime}');`);
  });

  sql.push('COMMIT;');
  sql.push('SET FOREIGN_KEY_CHECKS = 1;');
  return sql.join('\n');
}

function runSql(content) {
  const tmp = join(__dirname, '_seed_tmp.sql');
  writeFileSync(tmp, content, 'utf8');
  try {
    execSync(`${MYSQL} < "${tmp}"`, { stdio: 'pipe', shell: true, encoding: 'utf8' });
    return true;
  } catch (e) {
    console.error(e.stderr || e.message);
    return false;
  }
}

function query(sql) {
  try {
    const out = execSync(`mysql -u root -p123456 --default-character-set=utf8mb4 elderly_care -N -e "${sql.replace(/"/g, '\\"')}"`, { encoding: 'utf8' });
    return out.trim();
  } catch (e) {
    console.error('Query failed:', sql, e.stderr?.toString());
    return '';
  }
}

function queryRows(sql) {
  const oneLine = sql.replace(/\s+/g, ' ').trim();
  const out = query(oneLine);
  if (!out) return [];
  return out.split('\n').map(line => line.split('\t'));
}

console.log('=== 东软颐养中心 Mock 数据种子 ===\n');

// Phase 1
console.log('[1/4] 插入护理内容、房间、服务...');
if (!runSql(buildSql())) process.exit(1);

// 读取房间，生成床位
const rooms = queryRows('SELECT id, room_no, capacity, status FROM room ORDER BY id');
const existingBedCount = parseInt(query('SELECT COUNT(*) FROM bed') || '0', 10);
const bedRows = [];
rooms.forEach(([id, roomNo, capacity]) => {
  const labels = capacity == 1 ? ['A'] : capacity == 2 ? ['A', 'B'] : ['A', 'B', 'C', 'D'];
  labels.forEach(label => {
    // 检查是否已有（旧种子数据）
    const exists = query(`SELECT COUNT(*) FROM bed WHERE room_id=${id} AND bed_no='${label}'`);
    if (exists === '0') bedRows.push({ roomId: parseInt(id, 10), bedNo: label });
  });
});

// 生成 80 位老人
const elderlyRows = [];
const usedIdCards = new Set();
for (let i = 0; i < 80; i++) {
  const gender = Math.random() < 0.55 ? 1 : 2;
  const age = randInt(68, 96);
  const birthYear = new Date().getFullYear() - age;
  const loc = pick(PROVINCES);
  let idCard;
  do { idCard = genIdCard(birthYear, loc.code); } while (usedIdCards.has(idCard));
  usedIdCards.add(idCard);
  const name = genName(gender);
  const street = pick(STREETS);
  const detail = `${loc.district}${street}${randInt(1, 200)}号${randInt(1, 6)}单元${randInt(101, 2505)}室`;
  const isActive = i < 65;
  elderlyRows.push({
    name,
    phone: genPhone(),
    gender,
    age,
    idCard,
    province: loc.province,
    city: loc.city,
    addressDetail: detail,
    fullAddress: `中国${loc.province}${loc.city}${detail}`,
    health: pick(HEALTH),
    allergy: pick(ALLERGIES),
    emergencyContact: genName(randInt(1, 2)),
    emergencyPhone: genPhone(),
    careLevelId: randInt(1, 4),
    status: isActive ? 1 : 2,
    checkInDate: dateStr(-randInt(30, 800)),
    createTime: datetimeStr(-randInt(30, 800)),
  });
}

console.log(`[2/4] 插入 ${bedRows.length} 个床位、80 位老人...`);
if (!runSql(buildSqlPhase2(rooms, bedRows, elderlyRows))) process.exit(1);

// Phase 3: 分配床位、入住/退住、业务数据
console.log('[3/4] 分配床位并写入业务数据...');
const phase3 = [];
phase3.push('SET NAMES utf8mb4;');
phase3.push('SET FOREIGN_KEY_CHECKS = 0;');
phase3.push('START TRANSACTION;');

// 可用床位（房间非维修）
const availableBeds = queryRows('SELECT b.id, b.room_id FROM bed b JOIN room r ON b.room_id = r.id WHERE b.status = 0 AND r.status = 1 ORDER BY b.id LIMIT 65');
const activeElderly = queryRows('SELECT id, check_in_date FROM elderly WHERE status = 1 ORDER BY id LIMIT 65');

availableBeds.forEach(([bedId], idx) => {
  if (!activeElderly[idx]) return;
  const [elderlyId, checkInDate] = activeElderly[idx];
  phase3.push(`UPDATE bed SET status=1, elderly_id=${elderlyId} WHERE id=${bedId};`);
  phase3.push(`UPDATE elderly SET bed_id=${bedId} WHERE id=${elderlyId};`);
  phase3.push(`INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (${elderlyId}, ${bedId}, '${checkInDate}', '正常入住登记');`);
});

// 退住记录
const checkedOut = queryRows('SELECT id, check_in_date FROM elderly WHERE status = 2 ORDER BY id');
const firstBedId = query('SELECT id FROM bed ORDER BY id LIMIT 1') || '1';
checkedOut.forEach(([elderlyId]) => {
  const outDate = dateStr(-randInt(5, 60));
  const reason = randInt(1, 4);
  phase3.push(`INSERT INTO check_out (elderly_id, bed_id, check_out_date, check_out_reason, remark) VALUES (${elderlyId}, ${firstBedId}, '${outDate}', ${reason}, '历史退住记录');`);
});

// 外出 70 条
phase3.push('-- outing');
const allElderlyIds = queryRows('SELECT id FROM elderly ORDER BY id').map(r => r[0]);
for (let i = 0; i < 70; i++) {
  const elderlyId = pick(allElderlyIds);
  const outingType = randInt(1, 3);
  const startOffset = -randInt(0, 90);
  const status = Math.random() < 0.35 ? 0 : 1;
  const dests = ['沈阳医大一院', '和平广场', '子女家中', '北陵公园', '太原街商圈', '辽宁省人民医院', '浑南奥体中心', '铁西万达'];
  const reasons = ['定期复查', '家庭聚会', '购买日用品', '散步休闲', '牙科检查', '取药', '参加社区活动', '探访亲友'];
  const start = datetimeStr(startOffset, randInt(8, 16));
  const expected = datetimeStr(startOffset, randInt(17, 20));
  const actual = status === 1 ? `'${datetimeStr(startOffset, randInt(17, 21))}'` : 'NULL';
  phase3.push(`INSERT INTO outing (elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status) VALUES (${elderlyId}, ${outingType}, '${start}', '${expected}', ${actual}, '${esc(genName(randInt(1,2)))}', '${genPhone()}', '${esc(pick(dests))}', '${esc(pick(reasons))}', ${status});`);
}

// 护理记录 80 条
phase3.push('-- care_record');
const careItems = queryRows('SELECT id FROM care_item ORDER BY id').map(r => r[0]);
for (let i = 0; i < 80; i++) {
  const elderlyId = pick(allElderlyIds);
  const careItemId = pick(careItems);
  const dayOffset = -randInt(0, 30);
  const recordDate = dateStr(dayOffset);
  const recordTime = datetimeStr(dayOffset, randInt(6, 20));
  const status = pick([0, 1, 1, 1, 2]);
  const remarks = ['已完成，老人配合良好', '血压正常', '老人今日情绪稳定', '需继续观察', '老人拒绝，已跳过', '执行完毕，无异常', ''];
  phase3.push(`INSERT INTO care_record (elderly_id, care_item_id, record_date, record_time, status, remark) VALUES (${elderlyId}, ${careItemId}, '${recordDate}', '${recordTime}', ${status}, '${esc(pick(remarks))}');`);
}

// 膳食日历 90 条（近30天 x 3餐）
phase3.push('-- meal_calendar');
for (let day = -29; day <= 0; day++) {
  const mealDate = dateStr(day);
  const meals = [
    [1, pick(MEAL_BREAKFAST), '低盐低油，富含膳食纤维'],
    [2, pick(MEAL_LUNCH), '蛋白质充足，搭配时令蔬菜'],
    [3, pick(MEAL_DINNER), '易消化，适合老年人口味'],
  ];
  meals.forEach(([type, content, nutrition]) => {
    phase3.push(`INSERT IGNORE INTO meal_calendar (meal_date, meal_type, menu_content, nutrition_info, remark) VALUES ('${mealDate}', ${type}, '${esc(content)}', '${esc(nutrition)}', '中心统一配餐');`);
  });
}

// 膳食计划 65 条（在住老人）
phase3.push('-- meal_plan');
activeElderly.forEach(([elderlyId]) => {
  const restrictions = pick(['低盐饮食', '低糖饮食', '软食', '流食', '无特殊禁忌', '忌辛辣', '低嘌呤饮食', '高蛋白饮食']);
  const special = pick(['需切碎食物', '需喂食协助', '糖尿病餐', '无', '需鼻饲', '少油少盐', '无']);
  const pref = pick(['喜食清淡', '喜食软烂', '喜食面食', '喜食粥类', '无特殊偏好', '喜食鱼类', '喜食蔬菜']);
  phase3.push(`INSERT INTO meal_plan (elderly_id, dietary_restrictions, special_requirements, preference) VALUES (${elderlyId}, '${esc(restrictions)}', '${esc(special)}', '${esc(pref)}');`);
});

// 服务订阅 80 条
phase3.push('-- service_subscription');
const serviceIds = queryRows('SELECT id FROM service WHERE status = 1 ORDER BY id').map(r => r[0]);
for (let i = 0; i < 80; i++) {
  const elderlyId = pick(allElderlyIds);
  const serviceId = pick(serviceIds);
  const startOffset = -randInt(30, 365);
  const endOffset = randInt(30, 730);
  const startDate = dateStr(startOffset);
  const endDate = dateStr(startOffset + endOffset);
  const status = Math.random() < 0.85 ? 1 : pick([2, 3]);
  phase3.push(`INSERT INTO service_subscription (elderly_id, service_id, start_date, end_date, status, remark) VALUES (${elderlyId}, ${serviceId}, '${startDate}', '${endDate}', ${status}, '老人及家属已确认');`);
}

phase3.push('COMMIT;');
phase3.push('SET FOREIGN_KEY_CHECKS = 1;');

if (!runSql(phase3.join('\n'))) process.exit(1);

// 统计
console.log('\n[4/4] 数据统计:');
const counts = queryRows(`
  SELECT 'room', COUNT(*) FROM room UNION ALL
  SELECT 'bed', COUNT(*) FROM bed UNION ALL
  SELECT 'elderly', COUNT(*) FROM elderly UNION ALL
  SELECT 'check_in', COUNT(*) FROM check_in UNION ALL
  SELECT 'check_out', COUNT(*) FROM check_out UNION ALL
  SELECT 'outing', COUNT(*) FROM outing UNION ALL
  SELECT 'care_item', COUNT(*) FROM care_item UNION ALL
  SELECT 'care_record', COUNT(*) FROM care_record UNION ALL
  SELECT 'meal_calendar', COUNT(*) FROM meal_calendar UNION ALL
  SELECT 'meal_plan', COUNT(*) FROM meal_plan UNION ALL
  SELECT 'service', COUNT(*) FROM service UNION ALL
  SELECT 'service_subscription', COUNT(*) FROM service_subscription
`);
counts.forEach(([t, c]) => console.log(`  ${t.padEnd(22)} ${c}`));
console.log('\n✓ Mock 数据导入完成！请刷新前端页面查看。');
