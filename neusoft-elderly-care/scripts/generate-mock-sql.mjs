/**
 * 东软颐养中心 — 独立 Mock SQL 生成器
 * 用法: node scripts/generate-mock-sql.mjs
 * 输出: scripts/elderly_care_mock_full.sql
 */
import { readFileSync, writeFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, '..');
const OUTPUT = join(__dirname, 'elderly_care_mock_full.sql');
const BASE_DATE = new Date('2026-07-02T12:00:00+08:00');
const RANDOM_SEED = 20260702;

/** BCrypt hash for password "123456" (Spring Security compatible) */
const BCRYPT_123456 = '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/TU0532rSBHu';

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
  ['健康咨询', 3, '提供日常健康咨询服务'], ['文娱活动', 2, '组织文化娱乐活动'],
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

const BASE_CARE_ITEMS = [
  ['晨间护理', 1, '每日1次', '协助洗漱、整理床铺', 1],
  ['晚间护理', 1, '每日1次', '协助睡前洗漱', 2],
  ['测量血压', 2, '每日2次', '早晚各测量一次', 3],
  ['协助用餐', 2, '每日3次', '协助进食，观察饮食情况', 4],
  ['翻身护理', 3, '每2小时1次', '定时翻身，预防褥疮', 5],
  ['康复训练', 4, '每日1次', '专业康复训练', 6],
];

const ACTIVE_ELDERLY = 55;
const CHECKED_OUT_ELDERLY = 15;
const TOTAL_ELDERLY = ACTIVE_ELDERLY + CHECKED_OUT_ELDERLY;

/** Seeded PRNG (mulberry32) for reproducible output */
function createRng(seed) {
  let s = seed >>> 0;
  return () => {
    s += 0x6D2B79F5;
    let t = s;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

const rng = createRng(RANDOM_SEED);
function pick(arr) { return arr[Math.floor(rng() * arr.length)]; }
function randInt(min, max) { return min + Math.floor(rng() * (max - min + 1)); }
function pad2(n) { return String(n).padStart(2, '0'); }
function esc(s) { return String(s ?? '').replace(/\\/g, '\\\\').replace(/'/g, "''"); }

function genName(gender) {
  const surname = pick(SURNAMES);
  const given = gender === 1 ? pick(MALE_NAMES) : pick(FEMALE_NAMES);
  return surname + given;
}

function genIdCard(birthYear, regionCode, usedIdCards) {
  let idCard;
  do {
    const y = birthYear;
    const m = pad2(randInt(1, 12));
    const d = pad2(randInt(1, 28));
    const seq = String(randInt(100, 999));
    idCard = `${regionCode}${y}${m}${d}${seq}${randInt(0, 9)}`;
  } while (usedIdCards.has(idCard));
  usedIdCards.add(idCard);
  return idCard;
}

function genPhone() {
  const prefixes = ['138', '139', '136', '137', '158', '159', '188', '187', '150', '151'];
  return pick(prefixes) + String(randInt(10000000, 99999999));
}

function dateStr(offsetDays = 0) {
  const d = new Date(BASE_DATE);
  d.setDate(d.getDate() + offsetDays);
  return d.toISOString().slice(0, 10);
}

function datetimeStr(offsetDays = 0, hour = 8, minute = 0) {
  const d = new Date(BASE_DATE);
  d.setDate(d.getDate() + offsetDays);
  d.setHours(hour, minute, randInt(0, 59), 0);
  return d.toISOString().slice(0, 19).replace('T', ' ');
}

function extractDdl() {
  const raw = readFileSync(join(ROOT, 'database', 'elderly_care.sql'), 'utf8');
  const lines = raw.split('\n');
  const out = [];
  let inSeedSection = false;
  for (const line of lines) {
    if (line.includes('-- 初始数据')) {
      inSeedSection = true;
      continue;
    }
    if (inSeedSection) {
      if (line.startsWith('-- 创建统计视图') || line.startsWith('CREATE VIEW')) {
        inSeedSection = false;
        out.push(line);
        continue;
      }
      if (line.startsWith('-- 增量迁移')) {
        break;
      }
      continue;
    }
    if (line.includes('CREATE DATABASE IF NOT EXISTS')) {
      continue;
    }
    if (line.trim() === 'USE `elderly_care`;') {
      continue;
    }
    out.push(line);
  }
  return out.join('\n').trim();
}

function buildRooms() {
  const rooms = [];
  for (let floor = 1; floor <= 5; floor++) {
    for (let num = 1; num <= 5; num++) {
      const roomNo = `${floor}${pad2(num)}`;
      let roomType;
      let capacity;
      if (num === 1) {
        roomType = 1;
        capacity = 1;
      } else if (num <= 3) {
        roomType = 2;
        capacity = 2;
      } else {
        roomType = 3;
        capacity = 4;
      }
      const status = floor === 3 && num === 5 ? 2 : 1;
      const remark = roomType === 1 ? '豪华单人间' : roomType === 2 ? '标准双人间' : '经济多人间';
      rooms.push({ roomNo, floor, roomType, capacity, status, remark });
    }
  }
  return rooms;
}

function bedLabels(capacity) {
  if (capacity === 1) return ['A'];
  if (capacity === 2) return ['A', 'B'];
  return ['A', 'B', 'C', 'D'];
}

function pushMultiInsert(sql, table, columns, valueRows, ignore = false) {
  if (valueRows.length === 0) {
    return;
  }
  const keyword = ignore ? 'INSERT IGNORE INTO' : 'INSERT INTO';
  sql.push(`${keyword} ${table} (${columns}) VALUES`);
  valueRows.forEach((row, i) => {
    const tail = i === valueRows.length - 1 ? ';' : ',';
    sql.push(`${row}${tail}`);
  });
}

function buildMockData() {
  const sql = [];
  const stats = {};

  const rooms = buildRooms();
  const beds = [];
  let bedId = 1;
  rooms.forEach((room, roomIdx) => {
    const roomId = roomIdx + 1;
    bedLabels(room.capacity).forEach(bedNo => {
      beds.push({ id: bedId, roomId, bedNo, status: 0, elderlyId: null, roomStatus: room.status });
      bedId++;
    });
  });

  const availableBeds = beds.filter(b => b.roomStatus === 1);
  const usedIdCards = new Set();
  const elderlyList = [];

  for (let i = 0; i < TOTAL_ELDERLY; i++) {
    const gender = rng() < 0.55 ? 1 : 2;
    const age = randInt(68, 96);
    const birthYear = BASE_DATE.getFullYear() - age;
    const loc = pick(PROVINCES);
    const idCard = genIdCard(birthYear, loc.code, usedIdCards);
    const street = pick(STREETS);
    const detail = `${loc.district}${street}${randInt(1, 200)}号${randInt(1, 6)}单元${randInt(101, 2505)}室`;
    const isActive = i < ACTIVE_ELDERLY;
    const checkInOffset = -randInt(30, 730);
    elderlyList.push({
      id: i + 1,
      name: genName(gender),
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
      bedId: null,
      checkInDate: dateStr(checkInOffset),
      createTime: datetimeStr(checkInOffset),
      checkOutBedId: null,
      checkOutDate: isActive ? null : dateStr(-randInt(5, 60)),
      checkOutReason: isActive ? null : randInt(1, 4),
    });
  }

  const activeElderly = elderlyList.filter(e => e.status === 1);
  const checkedOutElderly = elderlyList.filter(e => e.status === 2);

  activeElderly.forEach((elderly, idx) => {
    const bed = availableBeds[idx];
    if (!bed) {
      throw new Error(`Not enough beds for active elderly: need ${ACTIVE_ELDERLY}, have ${availableBeds.length}`);
    }
    bed.status = 1;
    bed.elderlyId = elderly.id;
    elderly.bedId = bed.id;
  });

  checkedOutElderly.forEach((elderly, idx) => {
    const historicalBed = beds[beds.length - CHECKED_OUT_ELDERLY + idx];
    elderly.checkOutBedId = historicalBed.id;
  });

  const careItemCount = BASE_CARE_ITEMS.length + CARE_ITEMS_EXTRA.length;
  const serviceCount = SERVICES.length + 3;
  const mealCalendarCount = 21 * 3;
  const outingCount = 60;
  const careRecordCount = 75;
  const elderlyMealCount = 80;
  const subscriptionCount = 70;

  // --- Section 2: base seed ---
  sql.push('-- ============================================');
  sql.push('-- Section 2: 基础种子数据');
  sql.push('-- ============================================');
  sql.push('');
  sql.push('-- user (3)');
  sql.push(`INSERT INTO \`user\` (\`phone\`, \`password\`, \`real_name\`, \`age\`, \`gender\`, \`status\`) VALUES`);
  sql.push(`('13800138000', '${BCRYPT_123456}', '管理员', 35, 1, 1),`);
  sql.push(`('13900001001', '${BCRYPT_123456}', '王护理', 28, 2, 1),`);
  sql.push(`('13900001002', '${BCRYPT_123456}', '李护理', 32, 1, 1);`);
  stats.user = 3;

  sql.push('');
  sql.push('-- care_level (4)');
  sql.push('INSERT INTO `care_level` (`level_name`, `level_code`, `description`, `sort_order`) VALUES');
  sql.push("('一级护理', 'LEVEL_1', '基本生活护理', 1),");
  sql.push("('二级护理', 'LEVEL_2', '半护理，需部分协助', 2),");
  sql.push("('三级护理', 'LEVEL_3', '全护理，需全面照顾', 3),");
  sql.push("('特级护理', 'LEVEL_4', '特殊护理需求', 4);");
  stats.care_level = 4;

  sql.push('');
  sql.push(`-- care_item (${careItemCount})`);
  const allCareItems = [
    ...BASE_CARE_ITEMS.map(([name, levelId, freq, desc, sort]) => ({ name, levelId, freq, desc, sort })),
    ...CARE_ITEMS_EXTRA.map(([name, levelId, freq, desc], i) => ({ name, levelId, freq, desc, sort: 10 + i })),
  ];
  allCareItems.forEach((item) => {
    sql.push(`INSERT INTO care_item (item_name, care_level_id, frequency, description, sort_order) VALUES ('${esc(item.name)}', ${item.levelId}, '${esc(item.freq)}', '${esc(item.desc)}', ${item.sort});`);
  });
  stats.care_item = careItemCount;

  // --- Section 3: facilities ---
  sql.push('');
  sql.push('-- ============================================');
  sql.push('-- Section 3: 设施与扩展主数据');
  sql.push('-- ============================================');
  sql.push('');
  sql.push(`-- room (${rooms.length})`);
  pushMultiInsert(
    sql,
    'room',
    'room_no, room_type, floor, capacity, status, remark',
    rooms.map(r => `('${r.roomNo}', ${r.roomType}, ${r.floor}, ${r.capacity}, ${r.status}, '${esc(r.remark)}')`),
  );
  stats.room = rooms.length;

  sql.push('');
  sql.push(`-- bed (${beds.length})`);
  pushMultiInsert(
    sql,
    'bed',
    'room_id, bed_no, status',
    beds.map(b => `(${b.roomId}, '${b.bedNo}', 0)`),
  );
  stats.bed = beds.length;

  sql.push('');
  sql.push(`-- service (${serviceCount})`);
  const serviceRows = [...SERVICES];
  for (let i = 0; i < 3; i++) {
    const base = SERVICES[i];
    serviceRows.push([`${base[0]}（补充${i + 1}）`, base[1], base[2]]);
  }
  pushMultiInsert(
    sql,
    'service',
    'service_name, service_type, description, status',
    serviceRows.map(([name, type, desc]) => {
      const status = rng() < 0.92 ? 1 : 0;
      return `('${esc(name)}', ${type}, '${esc(desc)}', ${status})`;
    }),
  );
  stats.service = serviceRows.length;

  // --- Section 4: business data ---
  sql.push('');
  sql.push('-- ============================================');
  sql.push('-- Section 4: 核心业务 Mock 数据');
  sql.push('-- ============================================');
  sql.push('');
  sql.push(`-- elderly (${TOTAL_ELDERLY})`);
  pushMultiInsert(
    sql,
    'elderly',
    'name, phone, gender, age, id_card, country, province, city, address_detail, address, health_condition, allergy_info, emergency_contact, emergency_phone, care_level_id, status, check_in_date, create_time',
    elderlyList.map(e =>
      `('${esc(e.name)}', '${e.phone}', ${e.gender}, ${e.age}, '${e.idCard}', '中国', '${esc(e.province)}', '${esc(e.city)}', '${esc(e.addressDetail)}', '${esc(e.fullAddress)}', '${esc(e.health)}', '${esc(e.allergy)}', '${esc(e.emergencyContact)}', '${e.emergencyPhone}', ${e.careLevelId}, ${e.status}, '${e.checkInDate}', '${e.createTime}')`,
    ),
  );
  stats.elderly = TOTAL_ELDERLY;

  sql.push('');
  sql.push('-- Section 5: 床位分配与入住登记');
  activeElderly.forEach(elderly => {
    sql.push(`UPDATE bed SET status=1, elderly_id=${elderly.id} WHERE id=${elderly.bedId};`);
    sql.push(`UPDATE elderly SET bed_id=${elderly.bedId} WHERE id=${elderly.id};`);
    sql.push(`INSERT INTO check_in (elderly_id, bed_id, check_in_date, remark) VALUES (${elderly.id}, ${elderly.bedId}, '${elderly.checkInDate}', '正常入住登记');`);
  });
  stats.check_in = activeElderly.length;

  sql.push('');
  sql.push(`-- check_out (${checkedOutElderly.length})`);
  pushMultiInsert(
    sql,
    'check_out',
    'elderly_id, bed_id, check_out_date, check_out_reason, remark',
    checkedOutElderly.map(e =>
      `(${e.id}, ${e.checkOutBedId}, '${e.checkOutDate}', ${e.checkOutReason}, '历史退住记录')`,
    ),
  );
  stats.check_out = checkedOutElderly.length;

  sql.push('');
  sql.push(`-- outing (${outingCount})`);
  const dests = ['沈阳医大一院', '和平广场', '子女家中', '北陵公园', '太原街商圈', '辽宁省人民医院', '浑南奥体中心', '铁西万达'];
  const reasons = ['定期复查', '家庭聚会', '购买日用品', '散步休闲', '牙科检查', '取药', '参加社区活动', '探访亲友'];
  const outingRows = [];
  for (let i = 0; i < outingCount; i++) {
    const elderly = pick(elderlyList);
    const outingType = randInt(1, 3);
    const startOffset = -randInt(0, 90);
    const status = rng() < 0.35 ? 0 : 1;
    const start = datetimeStr(startOffset, randInt(8, 16));
    const expected = datetimeStr(startOffset, randInt(17, 20));
    const actual = status === 1 ? `'${datetimeStr(startOffset, randInt(17, 21))}'` : 'NULL';
    outingRows.push(`(${elderly.id}, ${outingType}, '${start}', '${expected}', ${actual}, '${esc(genName(randInt(1, 2)))}', '${genPhone()}', '${esc(pick(dests))}', '${esc(pick(reasons))}', ${status})`);
  }
  pushMultiInsert(
    sql,
    'outing',
    'elderly_id, outing_type, start_time, expected_return_time, actual_return_time, accompanier, accompanier_phone, destination, reason, status',
    outingRows,
  );
  stats.outing = outingCount;

  sql.push('');
  sql.push(`-- care_record (${careRecordCount})`);
  const careItemIds = Array.from({ length: careItemCount }, (_, i) => i + 1);
  const remarks = ['已完成，老人配合良好', '血压正常', '老人今日情绪稳定', '需继续观察', '老人拒绝，已跳过', '执行完毕，无异常', ''];
  const careRecordRows = [];
  for (let i = 0; i < careRecordCount; i++) {
    const elderly = pick(elderlyList);
    const careItemId = pick(careItemIds);
    const dayOffset = -randInt(0, 30);
    const recordDate = dateStr(dayOffset);
    const recordTime = datetimeStr(dayOffset, randInt(6, 20));
    const status = pick([0, 1, 1, 1, 2]);
    careRecordRows.push(`(${elderly.id}, ${careItemId}, '${recordDate}', '${recordTime}', ${status}, '${esc(pick(remarks))}')`);
  }
  pushMultiInsert(
    sql,
    'care_record',
    'elderly_id, care_item_id, record_date, record_time, status, remark',
    careRecordRows,
  );
  stats.care_record = careRecordCount;

  sql.push('');
  sql.push(`-- meal_calendar (${mealCalendarCount})`);
  const mealCalendarRows = [];
  for (let day = -20; day <= 0; day++) {
    const mealDate = dateStr(day);
    const meals = [
      [1, pick(MEAL_BREAKFAST), '低盐低油，富含膳食纤维'],
      [2, pick(MEAL_LUNCH), '蛋白质充足，搭配时令蔬菜'],
      [3, pick(MEAL_DINNER), '易消化，适合老年人口味'],
    ];
    meals.forEach(([type, content, nutrition]) => {
      mealCalendarRows.push(`('${mealDate}', ${type}, '${esc(content)}', '${esc(nutrition)}', '中心统一配餐')`);
    });
  }
  pushMultiInsert(
    sql,
    'meal_calendar',
    'meal_date, meal_type, menu_content, nutrition_info, remark',
    mealCalendarRows,
    true,
  );
  stats.meal_calendar = mealCalendarCount;

  sql.push('');
  sql.push(`-- meal_plan (${activeElderly.length})`);
  const restrictionsOpts = ['低盐饮食', '低糖饮食', '软食', '流食', '无特殊禁忌', '忌辛辣', '低嘌呤饮食', '高蛋白饮食'];
  const specialOpts = ['需切碎食物', '需喂食协助', '糖尿病餐', '无', '需鼻饲', '少油少盐'];
  const prefOpts = ['喜食清淡', '喜食软烂', '喜食面食', '喜食粥类', '无特殊偏好', '喜食鱼类', '喜食蔬菜'];
  pushMultiInsert(
    sql,
    'meal_plan',
    'elderly_id, dietary_restrictions, special_requirements, preference',
    activeElderly.map(e =>
      `(${e.id}, '${esc(pick(restrictionsOpts))}', '${esc(pick(specialOpts))}', '${esc(pick(prefOpts))}')`,
    ),
  );
  stats.meal_plan = activeElderly.length;

  sql.push('');
  sql.push(`-- elderly_meal (${elderlyMealCount}) — calendar_id 1~63 对应 meal_calendar 自增 ID`);
  const customMeals = ['低盐软食套餐', '糖尿病专用餐', '流质营养餐', '去海鲜定制餐'];
  const elderlyMealRows = [];
  for (let i = 0; i < elderlyMealCount; i++) {
    const elderly = pick(activeElderly);
    const calendarId = randInt(1, mealCalendarCount);
    const isCustom = rng() < 0.1 ? 1 : 0;
    const customContent = isCustom ? `'${esc(pick(customMeals))}'` : 'NULL';
    elderlyMealRows.push(`(${elderly.id}, ${calendarId}, ${isCustom}, ${customContent})`);
  }
  pushMultiInsert(
    sql,
    'elderly_meal',
    'elderly_id, calendar_id, is_custom, custom_content',
    elderlyMealRows,
  );
  stats.elderly_meal = elderlyMealCount;

  sql.push('');
  sql.push(`-- service_subscription (${subscriptionCount})`);
  const serviceIds = Array.from({ length: serviceRows.length }, (_, i) => i + 1);
  const subscriptionRows = [];
  for (let i = 0; i < subscriptionCount; i++) {
    const elderly = pick(elderlyList);
    const serviceId = pick(serviceIds);
    const startOffset = -randInt(30, 365);
    const endOffset = randInt(30, 730);
    const startDate = dateStr(startOffset);
    const endDate = dateStr(startOffset + endOffset);
    const status = rng() < 0.85 ? 1 : pick([2, 3]);
    subscriptionRows.push(`(${elderly.id}, ${serviceId}, '${startDate}', '${endDate}', ${status}, '老人及家属已确认')`);
  }
  pushMultiInsert(
    sql,
    'service_subscription',
    'elderly_id, service_id, start_date, end_date, status, remark',
    subscriptionRows,
  );
  stats.service_subscription = subscriptionCount;

  return { sql, stats };
}

function buildHeader(stats) {
  const statLines = Object.entries(stats).map(([k, v]) => `--   ${k.padEnd(22)} ${v}`).join('\n');
  return `-- ============================================
-- 东软颐养中心管理系统 — Mock 数据全量脚本
-- 生成时间基准: 2026-07-02
-- 随机种子: ${RANDOM_SEED}
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
${statLines}
--   合计                   ~${Object.values(stats).reduce((a, b) => a + b, 0)}
--
-- 重新生成:
--   node scripts/generate-mock-sql.mjs
-- ============================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS \`elderly_care\`;
CREATE DATABASE \`elderly_care\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE \`elderly_care\`;

`;
}

function main() {
  const ddl = extractDdl();
  const { sql: mockSql, stats } = buildMockData();

  const full = [
    buildHeader(stats),
    '-- ============================================',
    '-- Section 1: 数据库结构（表、外键、视图）',
    '-- ============================================',
    '',
    ddl,
    '',
    'START TRANSACTION;',
    '',
    ...mockSql,
    '',
    'COMMIT;',
    'SET FOREIGN_KEY_CHECKS = 1;',
    '',
    '-- 导入完成',
  ].join('\n');

  writeFileSync(OUTPUT, full, 'utf8');
  console.log(`✓ 已生成: ${OUTPUT}`);
  console.log('\n各表行数:');
  Object.entries(stats).forEach(([t, c]) => console.log(`  ${t.padEnd(22)} ${c}`));
  console.log(`  ${'合计'.padEnd(22)} ${Object.values(stats).reduce((a, b) => a + b, 0)}`);
}

main();
