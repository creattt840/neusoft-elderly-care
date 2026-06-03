<template>
  <div class="dashboard">
    <header class="page-header">
      <div class="header-bg">
        <div class="header-orb header-orb-1"></div>
        <div class="header-orb header-orb-2"></div>
      </div>
      <div class="header-text">
        <p class="header-date">{{ todayText }}</p>
        <h1 class="page-title">
          {{ greeting }}，{{ userStore.user.realName || '管理员' }}
        </h1>
        <p class="page-desc">今日颐养中心运营数据一览</p>
      </div>
      <div class="header-badge">
        <el-icon><Sunny /></el-icon>
        <span>系统运行正常</span>
      </div>
    </header>

    <el-row :gutter="20" class="stat-row">
      <el-col :xs="24" :sm="12" :lg="6" v-for="item in statCards" :key="item.key">
        <div class="stat-card" :class="item.theme">
          <div class="stat-card-inner">
            <div class="stat-icon-wrap">
              <el-icon :size="26"><component :is="item.icon" /></el-icon>
            </div>
            <div class="stat-body">
              <span class="stat-label">{{ item.title }}</span>
              <span class="stat-value">{{ statistics[item.key] ?? 0 }}</span>
            </div>
          </div>
          <div class="stat-accent"></div>
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="20" class="content-row">
      <el-col :xs="24" :lg="12">
        <div class="panel">
          <div class="panel-header">
            <div class="panel-title">
              <el-icon><Grid /></el-icon>
              <span>快捷操作</span>
            </div>
          </div>
          <div class="quick-grid">
            <div
              v-for="action in quickActions"
              :key="action.path"
              class="quick-item"
              @click="$router.push(action.path)"
            >
              <div class="quick-icon" :style="{ background: action.bg }">
                <el-icon :size="22"><component :is="action.icon" /></el-icon>
              </div>
              <span class="quick-label">{{ action.label }}</span>
            </div>
          </div>
        </div>

        <div class="panel section-panel">
          <div class="panel-header panel-header-split">
            <div class="panel-title">
              <el-icon><Document /></el-icon>
              <span>入住 / 退住记录</span>
            </div>
            <div class="header-controls">
              <el-radio-group v-model="recordType" size="small" @change="loadResidenceRecords">
                <el-radio-button value="checkIn">入住</el-radio-button>
                <el-radio-button value="checkOut">退住</el-radio-button>
              </el-radio-group>
              <el-radio-group v-model="timeRange" size="small" @change="loadResidenceRecords">
                <el-radio-button value="today">今天</el-radio-button>
                <el-radio-button value="week">一周</el-radio-button>
                <el-radio-button value="month">一月</el-radio-button>
              </el-radio-group>
            </div>
          </div>
          <el-table
            :data="residenceRecords"
            v-loading="recordsLoading"
            stripe
            size="small"
            max-height="300"
            class="data-table"
          >
            <el-table-column prop="roomNo" label="房间" width="72" />
            <el-table-column prop="bedNo" label="床位" width="64" />
            <el-table-column prop="elderlyName" label="姓名" min-width="80" />
            <el-table-column prop="age" label="年龄" width="56" align="center" />
            <el-table-column :label="recordType === 'checkIn' ? '入住时间' : '退住时间'" min-width="150">
              <template #default="{ row }">
                <span class="time-cell">{{ formatRecordTime(row.recordTime) }}</span>
              </template>
            </el-table-column>
            <template #empty>
              <div class="table-empty">
                <el-icon :size="32"><Document /></el-icon>
                <span>暂无记录</span>
              </div>
            </template>
          </el-table>
        </div>
      </el-col>

      <el-col :xs="24" :lg="12">
        <div class="panel welcome-panel">
          <div class="welcome-inner">
            <div class="welcome-icon">
              <el-icon :size="28"><FirstAidKit /></el-icon>
            </div>
            <div>
              <h3>东软颐养中心管理系统</h3>
              <p>致力于为长者提供安全、舒适、有尊严的颐养服务。通过数字化管理提升护理效率与服务质量。</p>
              <el-tag type="success" effect="plain" size="small">v1.0.0</el-tag>
            </div>
          </div>
        </div>

        <div class="panel section-panel">
          <div class="panel-header">
            <div class="panel-title">
              <el-icon><Position /></el-icon>
              <span>外出中的老人</span>
              <el-tag size="small" type="warning" effect="light" round>最近 10 条</el-tag>
            </div>
          </div>
          <el-table
            :data="activeOutings"
            v-loading="outingsLoading"
            stripe
            size="small"
            max-height="300"
            class="data-table"
          >
            <el-table-column prop="elderlyName" label="姓名" min-width="90" />
            <el-table-column label="类型" width="96">
              <template #default="{ row }">
                <el-tag size="small" :type="outingTagType(row.outingType)" effect="light">
                  {{ formatOutingType(row.outingType) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="destination" label="目的地" min-width="120" show-overflow-tooltip />
            <template #empty>
              <div class="table-empty">
                <el-icon :size="32"><CircleCheck /></el-icon>
                <span>暂无外出中的老人</span>
              </div>
            </template>
          </el-table>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import {
  User, HomeFilled, FirstAidKit, Position, Sunny, Grid,
  Document, CircleCheck, Food, Setting
} from '@element-plus/icons-vue'
import { statisticsApi } from '../../api/elderly'
import { useUserStore } from '../../stores/user'
import dayjs from 'dayjs'
import 'dayjs/locale/zh-cn'

dayjs.locale('zh-cn')

const userStore = useUserStore()
const statistics = ref({})
const recordType = ref('checkIn')
const timeRange = ref('today')
const residenceRecords = ref([])
const activeOutings = ref([])
const recordsLoading = ref(false)
const outingsLoading = ref(false)

const todayText = computed(() => dayjs().format('YYYY年M月D日 dddd'))

const greeting = computed(() => {
  const hour = dayjs().hour()
  if (hour < 12) return '上午好'
  if (hour < 18) return '下午好'
  return '晚上好'
})

const statCards = [
  { key: 'activeElderlyCount', title: '在住老人', icon: User, theme: 'theme-teal' },
  { key: 'availableBedCount', title: '空闲床位', icon: HomeFilled, theme: 'theme-green' },
  { key: 'occupiedBedCount', title: '已住床位', icon: FirstAidKit, theme: 'theme-amber' },
  { key: 'checkedOutElderlyCount', title: '退住老人', icon: Position, theme: 'theme-rose' }
]

const quickActions = [
  { label: '老人管理', path: '/elderly', icon: User, bg: 'linear-gradient(135deg,#2d7a72,#3d9a90)' },
  { label: '床位管理', path: '/bed', icon: HomeFilled, bg: 'linear-gradient(135deg,#52a86a,#6bc48a)' },
  { label: '外出登记', path: '/outing', icon: Position, bg: 'linear-gradient(135deg,#e8a838,#f0c060)' },
  { label: '护理记录', path: '/care/record', icon: FirstAidKit, bg: 'linear-gradient(135deg,#5b8def,#7aa8f5)' },
  { label: '膳食计划', path: '/meal/plan', icon: Food, bg: 'linear-gradient(135deg,#c97b5a,#e09a7a)' },
  { label: '服务关注', path: '/service', icon: Setting, bg: 'linear-gradient(135deg,#7b6fad,#9d8fcc)' }
]

const loadStatistics = async () => {
  const res = await statisticsApi.dashboard()
  if (res.code === 200) {
    statistics.value = res.data
  }
}

const loadResidenceRecords = async () => {
  recordsLoading.value = true
  try {
    const api = recordType.value === 'checkIn'
      ? statisticsApi.checkInRecords
      : statisticsApi.checkOutRecords
    const res = await api(timeRange.value)
    if (res.code === 200) {
      residenceRecords.value = res.data
    }
  } finally {
    recordsLoading.value = false
  }
}

const loadActiveOutings = async () => {
  outingsLoading.value = true
  try {
    const res = await statisticsApi.recentActiveOutings(10)
    if (res.code === 200) {
      activeOutings.value = res.data
    }
  } finally {
    outingsLoading.value = false
  }
}

const formatOutingType = (type) => {
  return Number(type) === 1 ? '临时外出' : Number(type) === 2 ? '长期外出' : '外出就医'
}

const outingTagType = (type) => {
  return Number(type) === 1 ? 'warning' : Number(type) === 2 ? 'info' : 'danger'
}

const formatRecordTime = (value) => {
  if (!value) return '-'
  const str = String(value)
  if (/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/.test(str)) return str
  const parsed = dayjs(str)
  return parsed.isValid() ? parsed.format('YYYY-MM-DD HH:mm:ss') : '-'
}

onMounted(() => {
  loadStatistics()
  loadResidenceRecords()
  loadActiveOutings()
})
</script>

<style scoped>
.dashboard {
  --teal: #2d7a72;
  --cream: #faf8f5;
  font-family: 'Noto Sans SC', sans-serif;
}

.page-header {
  position: relative;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 28px;
  padding: 28px 32px;
  background: linear-gradient(135deg, #1a4f4a 0%, #2d7a72 55%, #358f85 100%);
  border-radius: 16px;
  border: none;
  box-shadow: 0 8px 32px rgba(26, 79, 74, 0.22);
  overflow: hidden;
}

.header-bg {
  position: absolute;
  inset: 0;
  pointer-events: none;
}

.header-orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(50px);
}

.header-orb-1 {
  width: 200px;
  height: 200px;
  background: #e8a838;
  opacity: 0.25;
  top: -60px;
  right: 15%;
}

.header-orb-2 {
  width: 160px;
  height: 160px;
  background: #7ecfc6;
  opacity: 0.2;
  bottom: -50px;
  left: 30%;
}

.header-text {
  position: relative;
  z-index: 1;
}

.header-date {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.72);
  margin: 0 0 8px;
}

.page-title {
  font-family: 'Noto Serif SC', serif;
  font-size: 26px;
  font-weight: 600;
  color: #fff;
  margin: 0 0 8px;
  letter-spacing: 0.5px;
}

.page-desc {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.78);
  margin: 0;
}

.header-badge {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(8px);
  border: 1px solid rgba(255, 255, 255, 0.22);
  border-radius: 20px;
  color: #fff;
  font-size: 13px;
  font-weight: 500;
  flex-shrink: 0;
}

.header-badge .el-icon {
  color: #f0c060;
}

.stat-row {
  margin-bottom: 4px;
}

.stat-card {
  position: relative;
  background: #fff;
  border-radius: 16px;
  padding: 20px;
  margin-bottom: 20px;
  overflow: hidden;
  border: 1px solid rgba(0, 0, 0, 0.04);
  box-shadow: 0 2px 12px rgba(26, 79, 74, 0.06);
  transition: transform 0.25s, box-shadow 0.25s;
}

.stat-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 28px rgba(26, 79, 74, 0.1);
}

.stat-card-inner {
  display: flex;
  align-items: center;
  gap: 16px;
}

.stat-icon-wrap {
  width: 52px;
  height: 52px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
}

.theme-teal .stat-icon-wrap { background: linear-gradient(135deg, #2d7a72, #3d9a90); }
.theme-teal .stat-accent { background: #2d7a72; }
.theme-green .stat-icon-wrap { background: linear-gradient(135deg, #52a86a, #6bc48a); }
.theme-green .stat-accent { background: #52a86a; }
.theme-amber .stat-icon-wrap { background: linear-gradient(135deg, #e8a838, #f0c060); }
.theme-amber .stat-accent { background: #e8a838; }
.theme-rose .stat-icon-wrap { background: linear-gradient(135deg, #d97070, #e89090); }
.theme-rose .stat-accent { background: #d97070; }

.stat-accent {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 3px;
  opacity: 0.6;
}

.stat-label {
  display: block;
  font-size: 13px;
  color: #9aa8a6;
  margin-bottom: 4px;
}

.stat-value {
  font-size: 32px;
  font-weight: 700;
  color: #1a2e2c;
  line-height: 1.1;
  font-variant-numeric: tabular-nums;
}

.panel {
  background: #fff;
  border-radius: 16px;
  border: 1px solid rgba(0, 0, 0, 0.04);
  box-shadow: 0 2px 12px rgba(26, 79, 74, 0.05);
  margin-bottom: 20px;
  overflow: hidden;
}

.panel-header {
  padding: 16px 20px;
  border-bottom: 1px solid #f0f2f1;
}

.panel-header-split {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}

.panel-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 15px;
  font-weight: 600;
  color: #1a2e2c;
}

.panel-title .el-icon {
  color: var(--teal);
}

.header-controls {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.quick-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
  padding: 20px;
}

.quick-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  padding: 18px 12px;
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.2s, transform 0.2s;
  border: 1px solid transparent;
}

.quick-item:hover {
  background: #f5faf9;
  border-color: rgba(45, 122, 114, 0.12);
  transform: translateY(-2px);
}

.quick-icon {
  width: 44px;
  height: 44px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
}

.quick-label {
  font-size: 13px;
  color: #4a5a58;
  font-weight: 500;
}

.welcome-panel {
  background: linear-gradient(135deg, #1a4f4a 0%, #2d7a72 100%);
  border: none;
}

.welcome-inner {
  display: flex;
  gap: 20px;
  padding: 24px;
  color: #fff;
}

.welcome-icon {
  width: 56px;
  height: 56px;
  border-radius: 14px;
  background: rgba(255, 255, 255, 0.15);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.welcome-inner h3 {
  font-family: 'Noto Serif SC', serif;
  font-size: 18px;
  margin: 0 0 10px;
  font-weight: 600;
}

.welcome-inner p {
  font-size: 13px;
  line-height: 1.7;
  opacity: 0.88;
  margin: 0 0 12px;
}

.data-table {
  padding: 0 4px 4px;
}

.data-table :deep(.el-table__header th) {
  background: #f8faf9 !important;
  color: #6a7a78;
  font-weight: 600;
}

.time-cell {
  font-size: 12px;
  color: #5a6a68;
  font-variant-numeric: tabular-nums;
}

.table-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 32px 0;
  color: #b0bab8;
  font-size: 13px;
}

.content-row {
  margin-top: 4px;
}

@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    gap: 16px;
  }
  .quick-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}
</style>
