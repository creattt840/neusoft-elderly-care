<template>
  <div class="dashboard">
    <h1 class="page-title">首页概览</h1>

    <el-row :gutter="20">
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-icon" style="background: #409EFF;">
            <el-icon><User /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-title">在住老人</div>
            <div class="stat-value">{{ statistics.activeElderlyCount || 0 }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-icon" style="background: #67C23A;">
            <el-icon><HomeFilled /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-title">空闲床位</div>
            <div class="stat-value">{{ statistics.availableBedCount || 0 }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-icon" style="background: #E6A23C;">
            <el-icon><FirstAidKit /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-title">已住床位</div>
            <div class="stat-value">{{ statistics.occupiedBedCount || 0 }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-icon" style="background: #F56C6C;">
            <el-icon><Position /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-title">退住老人</div>
            <div class="stat-value">{{ statistics.checkedOutElderlyCount || 0 }}</div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="12">
        <el-card>
          <template #header>
            <span>快捷操作</span>
          </template>
          <div class="quick-actions">
            <el-button type="primary" @click="$router.push('/elderly')">老人管理</el-button>
            <el-button type="success" @click="$router.push('/bed')">床位管理</el-button>
            <el-button type="warning" @click="$router.push('/outing')">外出登记</el-button>
            <el-button type="info" @click="$router.push('/care/record')">护理记录</el-button>
          </div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card>
          <template #header>
            <span>系统公告</span>
          </template>
          <div class="notice">
            <p>欢迎使用东软颐养中心管理系统</p>
            <p>系统版本：v1.0.0</p>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { statisticsApi } from '../../api/elderly'

const statistics = ref({})

const loadStatistics = async () => {
  const res = await statisticsApi.dashboard()
  if (res.code === 200) {
    statistics.value = res.data
  }
}

onMounted(() => {
  loadStatistics()
})
</script>

<style scoped>
.page-title {
  margin-bottom: 20px;
  font-size: 24px;
  color: #303133;
}

.stat-card {
  display: flex;
  align-items: center;
  padding: 10px;
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 28px;
  margin-right: 15px;
}

.stat-info {
  flex: 1;
}

.stat-title {
  font-size: 14px;
  color: #909399;
  margin-bottom: 8px;
}

.stat-value {
  font-size: 28px;
  font-weight: bold;
  color: #303133;
}

.quick-actions {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.notice {
  color: #606266;
  line-height: 1.8;
}
</style>
