<template>
  <div class="page">
    <el-page-header @back="$router.back()" title="老人详情" />

    <el-card v-if="elderly">
      <template #header>
        <span>基本信息</span>
      </template>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="姓名">{{ elderly.name }}</el-descriptions-item>
        <el-descriptions-item label="性别">{{ elderly.gender === 1 ? '男' : '女' }}</el-descriptions-item>
        <el-descriptions-item label="年龄">{{ elderly.age }}</el-descriptions-item>
        <el-descriptions-item label="手机号">{{ elderly.phone }}</el-descriptions-item>
        <el-descriptions-item label="身份证号">{{ elderly.idCard }}</el-descriptions-item>
        <el-descriptions-item label="入住时间">{{ formatCheckInDate(elderly.checkInDate) }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="elderly.status === 1 ? 'success' : 'info'">
            {{ elderly.status === 1 ? '在住' : '退住' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="床位">
          <span v-if="elderly.roomNo && elderly.bedNo">{{ elderly.roomNo }} - {{ elderly.bedNo }}</span>
          <span v-else>-</span>
        </el-descriptions-item>
        <el-descriptions-item label="家庭住址" :span="2">{{ formatFullAddress(elderly) }}</el-descriptions-item>
        <el-descriptions-item label="健康状况" :span="2">{{ elderly.healthCondition }}</el-descriptions-item>
        <el-descriptions-item label="过敏信息" :span="2">{{ elderly.allergyInfo }}</el-descriptions-item>
        <el-descriptions-item label="紧急联系人">{{ elderly.emergencyContact }}</el-descriptions-item>
        <el-descriptions-item label="紧急电话">{{ elderly.emergencyPhone }}</el-descriptions-item>
      </el-descriptions>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import dayjs from 'dayjs'
import { elderlyApi } from '../../api/elderly'
import { formatFullAddress } from '../../data/regions'

const route = useRoute()
const elderly = ref(null)

const formatCheckInDate = (date) => {
  if (!date) return '-'
  return dayjs(date).format('YYYY-MM-DD')
}

const loadData = async () => {
  const res = await elderlyApi.getById(route.params.id)
  if (res.code === 200) {
    elderly.value = res.data
  }
}

onMounted(() => {
  loadData()
})
</script>
