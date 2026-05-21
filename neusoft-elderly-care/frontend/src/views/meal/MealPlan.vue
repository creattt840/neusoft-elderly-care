<template>
  <div class="page">
    <div class="page-header">
      <h2>膳食计划</h2>
    </div>

    <el-card>
      <el-form :inline="true">
        <el-form-item label="选择老人">
          <el-select v-model="selectedElderlyId" placeholder="请选择" @change="loadPlan">
            <el-option
              v-for="item in elderlyList"
              :key="item.id"
              :label="item.name"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
      </el-form>

      <el-empty v-if="!planData.id && !isEdit" description="请选择老人查看或添加膳食计划">
        <el-button type="primary" @click="startEdit" :disabled="!selectedElderlyId">添加计划</el-button>
      </el-empty>

      <template v-else>
        <el-descriptions v-if="!isEdit" :column="1" border>
          <el-descriptions-item label="饮食禁忌">{{ planData.dietaryRestrictions || '无' }}</el-descriptions-item>
          <el-descriptions-item label="特殊需求">{{ planData.specialRequirements || '无' }}</el-descriptions-item>
          <el-descriptions-item label="口味偏好">{{ planData.preference || '无' }}</el-descriptions-item>
          <el-descriptions-item>
            <el-button type="primary" @click="startEdit">编辑计划</el-button>
          </el-descriptions-item>
        </el-descriptions>

        <el-form v-else :model="form" label-width="100px">
          <el-form-item label="饮食禁忌">
            <el-input v-model="form.dietaryRestrictions" type="textarea" placeholder="如：糖尿病饮食、低盐饮食" />
          </el-form-item>
          <el-form-item label="特殊需求">
            <el-input v-model="form.specialRequirements" type="textarea" placeholder="如：流质饮食、半流质饮食" />
          </el-form-item>
          <el-form-item label="口味偏好">
            <el-input v-model="form.preference" type="textarea" placeholder="如：喜欢甜食、不吃辣" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="handleSubmit">保存</el-button>
            <el-button @click="isEdit = false">取消</el-button>
          </el-form-item>
        </el-form>
      </template>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { mealApi, elderlyApi } from '../../api/elderly'

const elderlyList = ref([])
const selectedElderlyId = ref(null)
const planData = ref({})
const isEdit = ref(false)

const form = reactive({
  id: null,
  elderlyId: null,
  dietaryRestrictions: '',
  specialRequirements: '',
  preference: ''
})

const loadElderly = async () => {
  const res = await elderlyApi.list({ pageNum: 1, pageSize: 1000 })
  if (res.code === 200) {
    elderlyList.value = res.data.records
  }
}

const loadPlan = async () => {
  if (!selectedElderlyId.value) return
  const res = await mealApi.planByElderly(selectedElderlyId.value)
  if (res.code === 200 && res.data) {
    planData.value = res.data
    Object.assign(form, res.data)
    isEdit.value = false
  } else {
    planData.value = {}
    isEdit.value = false
  }
}

const startEdit = () => {
  Object.assign(form, {
    id: planData.value.id || null,
    elderlyId: selectedElderlyId.value,
    dietaryRestrictions: planData.value.dietaryRestrictions || '',
    specialRequirements: planData.value.specialRequirements || '',
    preference: planData.value.preference || ''
  })
  isEdit.value = true
}

const handleSubmit = async () => {
  const data = { ...form, elderlyId: selectedElderlyId.value }
  if (form.id) {
    await mealApi.updatePlan(data)
  } else {
    await mealApi.savePlan(data)
  }
  ElMessage.success('保存成功')
  isEdit.value = false
  loadPlan()
}

onMounted(() => {
  loadElderly()
})
</script>

<style scoped>
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
</style>
