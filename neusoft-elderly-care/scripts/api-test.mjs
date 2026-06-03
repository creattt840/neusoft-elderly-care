const BASE = 'http://localhost:8080';
const today = new Date().toISOString().slice(0, 10);
const ts = Date.now();

const results = [];
const ids = {};

async function req(method, path, body, query) {
  const url = new URL(path, BASE);
  if (query) Object.entries(query).forEach(([k, v]) => url.searchParams.set(k, String(v)));
  const opts = { method, headers: {} };
  if (body !== undefined && body !== null && method !== 'GET' && method !== 'HEAD') {
    opts.headers['Content-Type'] = 'application/json';
    opts.body = JSON.stringify(body);
  }
  const res = await fetch(url, opts);
  let json;
  try {
    json = await res.json();
  } catch {
    json = { code: -1, message: `HTTP ${res.status} non-JSON` };
  }
  return { http: res.status, ...json };
}

function record(name, method, path, r, note = '') {
  const ok = r.code === 200;
  results.push({ name, method, path, ok, code: r.code, message: r.message || '', note });
  return r;
}

async function run() {
  // === Auth ===
  const regPhone = `139${String(ts).slice(-8)}`;
  record('注册', 'POST', '/api/auth/register', await req('POST', '/api/auth/register', {
    phone: regPhone, password: '123456', realName: 'API测试用户', age: 28, gender: 1
  }));
  const login = await req('POST', '/api/auth/login', { phone: regPhone, password: '123456' });
  record('登录(新用户)', 'POST', '/api/auth/login', login);
  const loginDefault = await req('POST', '/api/auth/login', { phone: '13800138000', password: '123456' });
  record('登录(默认账号)', 'POST', '/api/auth/login', loginDefault, loginDefault.code === 200 ? '' : '种子密码哈希可能无效');

  // === Statistics & Elderly reads ===
  record('统计-仪表盘', 'GET', '/api/statistics/dashboard', await req('GET', '/api/statistics/dashboard'));
  record('老人-分页', 'GET', '/api/elderly/page', await req('GET', '/api/elderly/page', null, { pageNum: 1, pageSize: 10 }));
  record('老人-统计', 'GET', '/api/elderly/statistics', await req('GET', '/api/elderly/statistics'));

  // === Room ===
  const rooms = await req('GET', '/api/room/list');
  record('房间-列表', 'GET', '/api/room/list', rooms);
  record('房间-分页', 'GET', '/api/room/page', await req('GET', '/api/room/page'));
  const roomId = rooms.data?.[0]?.id ?? 1;
  record('房间-详情', 'GET', `/api/room/${roomId}`, await req('GET', `/api/room/${roomId}`));

  const newRoom = await req('POST', '/api/room', { roomNo: `T${ts}`, roomType: 2, floor: 9, capacity: 2, status: 1, remark: 'api-test' });
  record('房间-新增', 'POST', '/api/room', newRoom);
  ids.room = newRoom.data === true ? null : null;
  const roomList2 = await req('GET', '/api/room/list');
  ids.room = roomList2.data?.find(r => r.roomNo === `T${ts}`)?.id;
  if (ids.room) {
    record('房间-更新', 'PUT', '/api/room', await req('PUT', '/api/room', { id: ids.room, roomNo: `T${ts}`, roomType: 2, floor: 9, capacity: 2, status: 1, remark: 'api-test-upd' }));
  }

  // === Bed ===
  record('床位-列表', 'GET', '/api/bed/list', await req('GET', '/api/bed/list'));
  const avail = await req('GET', '/api/bed/available');
  record('床位-可用', 'GET', '/api/bed/available', avail);
  record('床位-分页', 'GET', '/api/bed/page', await req('GET', '/api/bed/page'));
  record('床位-按房间', 'GET', `/api/bed/room/${roomId}`, await req('GET', `/api/bed/room/${roomId}`));

  if (ids.room) {
    const newBed = await req('POST', '/api/bed', { roomId: ids.room, bedNo: 'Z', status: 0 });
    record('床位-新增', 'POST', '/api/bed', newBed);
    const beds = await req('GET', `/api/bed/room/${ids.room}`);
    ids.bed = beds.data?.find(b => b.bedNo === 'Z')?.id;
    if (ids.bed) {
      record('床位-更新', 'PUT', '/api/bed', await req('PUT', '/api/bed', { id: ids.bed, roomId: ids.room, bedNo: 'Z', status: 0 }));
    }
  }
  ids.checkInBed = avail.data?.[0]?.id;

  // === Care level/item ===
  const levels = await req('GET', '/api/care/level/list');
  record('护理级别-列表', 'GET', '/api/care/level/list', levels);
  const levelId = levels.data?.[0]?.id ?? 1;
  record('护理内容-列表', 'GET', '/api/care/item/list', await req('GET', '/api/care/item/list'));
  record('护理内容-按级别', 'GET', '/api/care/item/list?careLevelId', await req('GET', '/api/care/item/list', null, { careLevelId: levelId }));

  const newLevel = await req('POST', '/api/care/level', { levelName: `测试级${ts}`, levelCode: `T${ts}`, description: 'api', sortOrder: 99 });
  record('护理级别-新增', 'POST', '/api/care/level', newLevel);
  const lv2 = await req('GET', '/api/care/level/list');
  ids.careLevel = lv2.data?.find(l => l.levelCode === `T${ts}`)?.id;
  if (ids.careLevel) {
    record('护理级别-更新', 'PUT', '/api/care/level', await req('PUT', '/api/care/level', { id: ids.careLevel, levelName: `测试级${ts}U`, levelCode: `T${ts}`, description: 'api-u', sortOrder: 99 }));
    const newItem = await req('POST', '/api/care/item', { itemName: `测试项${ts}`, careLevelId: ids.careLevel, frequency: '每日1次', description: 'api', sortOrder: 1 });
    record('护理内容-新增', 'POST', '/api/care/item', newItem);
    const items = await req('GET', '/api/care/item/list', null, { careLevelId: ids.careLevel });
    ids.careItem = items.data?.[0]?.id;
    if (ids.careItem) {
      record('护理内容-更新', 'PUT', '/api/care/item', await req('PUT', '/api/care/item', { id: ids.careItem, itemName: `测试项${ts}U`, careLevelId: ids.careLevel, frequency: '每日2次', description: 'api-u', sortOrder: 1 }));
    }
  }

  // === Service ===
  const services = await req('GET', '/api/service/list');
  record('服务-列表', 'GET', '/api/service/list', services);
  record('服务-按类型', 'GET', '/api/service/list?type=3', await req('GET', '/api/service/list', null, { type: 3 }));
  const newSvc = await req('POST', '/api/service', { serviceName: `测试服务${ts}`, serviceType: 3, description: 'api', status: 1 });
  record('服务-新增', 'POST', '/api/service', newSvc);
  const svc2 = await req('GET', '/api/service/list');
  ids.service = svc2.data?.find(s => s.serviceName === `测试服务${ts}`)?.id;
  if (ids.service) {
    record('服务-更新', 'PUT', '/api/service', await req('PUT', '/api/service', { id: ids.service, serviceName: `测试服务${ts}U`, serviceType: 3, description: 'api-u', status: 1 }));
  }

  // === Meal calendar ===
  record('膳食日历-按日', 'GET', '/api/meal/calendar/list', await req('GET', '/api/meal/calendar/list', null, { date: today }));
  record('膳食日历-按周', 'GET', '/api/meal/calendar/week', await req('GET', '/api/meal/calendar/week', null, { startDate: today, endDate: today }));
  const newCal = await req('POST', '/api/meal/calendar', { mealDate: today, mealType: 1, menuContent: `测试餐${ts}`, nutritionInfo: '均衡', remark: 'api' });
  record('膳食日历-新增', 'POST', '/api/meal/calendar', newCal);
  const cals = await req('GET', '/api/meal/calendar/list', null, { date: today });
  ids.mealCal = cals.data?.find(c => c.menuContent === `测试餐${ts}`)?.id;
  if (ids.mealCal) {
    record('膳食日历-更新', 'PUT', '/api/meal/calendar', await req('PUT', '/api/meal/calendar', { id: ids.mealCal, mealDate: today, mealType: 1, menuContent: `测试餐${ts}U`, nutritionInfo: '均衡', remark: 'api-u' }));
  }

  // === Elderly CRUD + check-in/out ===
  const newElder = await req('POST', '/api/elderly', {
    name: `测试老人${ts}`, phone: `138${String(ts).slice(-8)}`, gender: 1, age: 75,
    idCard: '110101199001011234', careLevelId: levelId, status: 0
  });
  record('老人-新增', 'POST', '/api/elderly', newElder);
  const elPage = await req('GET', '/api/elderly/page');
  ids.elderly = elPage.data?.records?.find(e => e.name === `测试老人${ts}`)?.id;
  if (ids.elderly) {
    record('老人-详情', 'GET', `/api/elderly/${ids.elderly}`, await req('GET', `/api/elderly/${ids.elderly}`));
    record('老人-更新', 'PUT', '/api/elderly', await req('PUT', '/api/elderly', { id: ids.elderly, name: `测试老人${ts}U`, phone: `138${String(ts).slice(-8)}`, gender: 1, age: 76, careLevelId: levelId, status: 0 }));
  }

  if (ids.checkInBed) {
    const checkIn = await req('POST', '/api/elderly/check-in', {
      name: `入住老人${ts}`, phone: `137${String(ts).slice(-8)}`, gender: 2, age: 80, careLevelId: levelId
    }, { bedId: ids.checkInBed });
    record('老人-入住', 'POST', '/api/elderly/check-in', checkIn);
    const avail2 = await req('GET', '/api/bed/available');
    const occupied = (await req('GET', '/api/elderly/page')).data?.records?.find(e => e.name === `入住老人${ts}`);
    ids.elderlyIn = occupied?.id;
    if (ids.elderlyIn) {
      record('老人-详情(入住后)', 'GET', `/api/elderly/${ids.elderlyIn}`, await req('GET', `/api/elderly/${ids.elderlyIn}`));
      // meal plan & subscription need elderlyId
      record('膳食计划-查询', 'GET', `/api/meal/plan/${ids.elderlyIn}`, await req('GET', `/api/meal/plan/${ids.elderlyIn}`));
      const plan = await req('POST', '/api/meal/plan', { elderlyId: ids.elderlyIn, breakfast: '粥', lunch: '饭', dinner: '面', remark: 'api' });
      record('膳食计划-新增', 'POST', '/api/meal/plan', plan);
      const planGet = await req('GET', `/api/meal/plan/${ids.elderlyIn}`);
      if (planGet.data?.id) {
        record('膳食计划-更新', 'PUT', '/api/meal/plan', await req('PUT', '/api/meal/plan', { ...planGet.data, breakfast: '粥U' }));
      }
      record('服务订阅-查询', 'GET', `/api/service/subscription/${ids.elderlyIn}`, await req('GET', `/api/service/subscription/${ids.elderlyIn}`));
      const svcId = services.data?.[0]?.id ?? 1;
      const sub = await req('POST', '/api/service/subscription', { elderlyId: ids.elderlyIn, serviceId: svcId, status: 1 });
      record('服务订阅-新增', 'POST', '/api/service/subscription', sub);
      const subs = await req('GET', `/api/service/subscription/${ids.elderlyIn}`);
      ids.subscription = subs.data?.[subs.data.length - 1]?.id;
      if (ids.subscription) {
        record('服务订阅-更新', 'PUT', '/api/service/subscription', await req('PUT', '/api/service/subscription', { id: ids.subscription, elderlyId: ids.elderlyIn, serviceId: svcId, status: 1 }));
      }
      // outing
      const outing = await req('POST', '/api/outing', {
        elderlyId: ids.elderlyIn, outingType: 1, startTime: `${today}T09:00:00`,
        expectedReturnTime: `${today}T18:00:00`, accompanier: '张三', accompanierPhone: '13900001111',
        destination: '医院', reason: '复查', status: 0
      });
      record('外出-新增', 'POST', '/api/outing', outing);
      const outingList = await req('GET', '/api/outing/active');
      ids.outing = outingList.data?.find(o => o.elderlyId === ids.elderlyIn)?.id;
      record('外出-列表', 'GET', '/api/outing/list', await req('GET', '/api/outing/list'));
      record('外出-进行中', 'GET', '/api/outing/active', outingList);
      record('外出-分页', 'GET', '/api/outing/page', await req('GET', '/api/outing/page'));
      if (ids.outing) {
        record('外出-详情', 'GET', `/api/outing/${ids.outing}`, await req('GET', `/api/outing/${ids.outing}`));
        record('外出-更新', 'PUT', '/api/outing', await req('PUT', '/api/outing', { id: ids.outing, elderlyId: ids.elderlyIn, outingType: 1, destination: '医院U', reason: '复查U', status: 0 }));
        record('外出-返回', 'POST', `/api/outing/return/${ids.outing}`, await req('POST', `/api/outing/return/${ids.outing}`));
      }
      // care record
      const careItemId = (await req('GET', '/api/care/item/list', null, { careLevelId: levelId })).data?.[0]?.id ?? 1;
      record('护理记录-列表', 'GET', '/api/care-record/list', await req('GET', '/api/care-record/list'));
      record('护理记录-按老人', 'GET', '/api/care-record/list?elderlyId', await req('GET', '/api/care-record/list', null, { elderlyId: ids.elderlyIn }));
      record('护理记录-按日期', 'GET', '/api/care-record/date', await req('GET', '/api/care-record/date', null, { date: today }));
      record('护理记录-分页', 'GET', '/api/care-record/page', await req('GET', '/api/care-record/page'));
      const cr = await req('POST', '/api/care-record', { elderlyId: ids.elderlyIn, careItemId: careItemId, recordDate: today, status: 1, remark: 'api' });
      record('护理记录-新增', 'POST', '/api/care-record', cr);
      const crList = await req('GET', '/api/care-record/list', null, { elderlyId: ids.elderlyIn });
      ids.careRecord = crList.data?.[crList.data.length - 1]?.id;
      if (ids.careRecord) {
        record('护理记录-更新', 'PUT', '/api/care-record', await req('PUT', '/api/care-record', { id: ids.careRecord, elderlyId: ids.elderlyIn, careItemId: careItemId, recordDate: today, status: 1, remark: 'api-u' }));
      }
      record('老人-退住', 'POST', `/api/elderly/check-out/${ids.elderlyIn}`, await req('POST', `/api/elderly/check-out/${ids.elderlyIn}`));
    }
  }

  // === Cleanup deletes (reverse order) ===
  if (ids.careRecord) record('护理记录-删除', 'DELETE', `/api/care-record/${ids.careRecord}`, await req('DELETE', `/api/care-record/${ids.careRecord}`));
  if (ids.outing) record('外出-删除', 'DELETE', `/api/outing/${ids.outing}`, await req('DELETE', `/api/outing/${ids.outing}`));
  if (ids.subscription) record('服务订阅-删除', 'DELETE', `/api/service/subscription/${ids.subscription}`, await req('DELETE', `/api/service/subscription/${ids.subscription}`));
  if (ids.elderly) record('老人-删除', 'DELETE', `/api/elderly/${ids.elderly}`, await req('DELETE', `/api/elderly/${ids.elderly}`));
  if (ids.elderlyIn) record('老人-删除(入住)', 'DELETE', `/api/elderly/${ids.elderlyIn}`, await req('DELETE', `/api/elderly/${ids.elderlyIn}`));
  if (ids.mealCal) record('膳食日历-删除', 'DELETE', `/api/meal/calendar/${ids.mealCal}`, await req('DELETE', `/api/meal/calendar/${ids.mealCal}`));
  if (ids.careItem) record('护理内容-删除', 'DELETE', `/api/care/item/${ids.careItem}`, await req('DELETE', `/api/care/item/${ids.careItem}`));
  if (ids.careLevel) record('护理级别-删除', 'DELETE', `/api/care/level/${ids.careLevel}`, await req('DELETE', `/api/care/level/${ids.careLevel}`));
  if (ids.service) record('服务-删除', 'DELETE', `/api/service/${ids.service}`, await req('DELETE', `/api/service/${ids.service}`));
  if (ids.bed) record('床位-删除', 'DELETE', `/api/bed/${ids.bed}`, await req('DELETE', `/api/bed/${ids.bed}`));
  if (ids.room) record('房间-删除', 'DELETE', `/api/room/${ids.room}`, await req('DELETE', `/api/room/${ids.room}`));

  const passed = results.filter(r => r.ok).length;
  const failed = results.filter(r => !r.ok);
  console.log('\n========== API 测试报告 ==========');
  console.log(`总计: ${results.length}  通过: ${passed}  失败: ${failed.length}\n`);
  console.log('方法\t状态\t接口\t说明');
  console.log('----\t----\t----\t----');
  for (const r of results) {
    console.log(`${r.method}\t${r.ok ? 'PASS' : 'FAIL'}\t${r.path}\t${r.ok ? (r.note || r.message) : r.message}${r.note && !r.ok ? ' ' + r.note : ''}`);
  }
  if (failed.length) {
    console.log('\n--- 失败明细 ---');
    failed.forEach(f => console.log(`[${f.method}] ${f.path} => code=${f.code} msg=${f.message} ${f.note}`));
  }
  process.exit(failed.length > 0 ? 1 : 0);
}

run().catch(e => { console.error(e); process.exit(2); });
