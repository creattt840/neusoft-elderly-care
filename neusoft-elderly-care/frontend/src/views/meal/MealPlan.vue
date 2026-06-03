<template>
  <div class="page">
    <div class="page-header">
      <h2>膳食计划</h2>
      <el-button type="primary" @click="handleAdd">新增计划</el-button>
    </div>

    <el-card>
      <el-form :inline="true" @submit.prevent>
        <el-form-item label="关键词">
          <el-input
            v-model="keyword"
            placeholder="老人姓名/饮食禁忌/特殊需求/口味偏好"
            clearable
            style="width: 280px"
            @keyup.enter="handleSearch"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>

      <el-table :data="tableData" v-loading="loading" border>
        <el-table-column prop="elderlyName" label="老人姓名" min-width="100" />
        <el-table-column prop="dietaryRestrictions" label="饮食禁忌" min-width="160" show-overflow-tooltip />
        <el-table-column prop="specialRequirements" label="特殊需求" min-width="160" show-overflow-tooltip />
        <el-table-column prop="preference" label="口味偏好" min-width="160" show-overflow-tooltip />
        <el-table-column label="操作" width="160" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        v-model:current-page="pageNum"
        :page-size="10"
        :total="total"
        layout="total, prev, pager, next, jumper"
        background
        class="pagination"
        @current-change="loadData"
      />
    </el-card>

    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="600px" @closed="handleDialogClosed">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="老人" prop="elderlyId">
          <el-select
            v-model="form.elderlyId"
            placeholder="请选择老人"
            filterable
            :disabled="!isAdd"
            style="width: 100%"
          >
            <el-option
              v-for="item in availableElderlyList"
              :key="item.id"
              :label="formatElderlyLabel(item)"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="饮食禁忌">
          <el-input v-model="form.dietaryRestrictions" type="textarea" placeholder="如：糖尿病饮食、低盐饮食" />
        </el-form-item>
        <el-form-item label="特殊需求">
          <el-input v-model="form.specialRequirements" type="textarea" placeholder="如：流质饮食、半流质饮食" />
        </el-form-item>
        <el-form-item label="口味偏好">
          <el-input v-model="form.preference" type="textarea" placeholder="如：喜欢甜食、不吃辣" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { mealApi, elderlyApi } from '../../api/elderly'

const loading = ref(false)
const tableData = ref([])
const elderlyList = ref([])
const assignedElderlyIds = ref([])
const keyword = ref('')
const pageNum = ref(1)
const total = ref(0)
const dialogVisible = ref(false)
const dialogTitle = ref('')
const isAdd = ref(false)
const formRef = ref()

const form = reactive({
  id: null,
  elderlyId: null,
  dietaryRestrictions: '',
  specialRequirements: '',
  preference: ''
})

const rules = {
  elderlyId: [{ required: true, message: '请选择老人', trigger: 'change' }]
}

const formatElderlyLabel = (item) => {
  return item.phone ? `${item.name}（${item.phone}）` : item.name
}

const availableElderlyList = computed(() => {
  if (!isAdd.value) {
    return elderlyList.value.filter(item => item.id === form.elderlyId)
  }
  return elderlyList.value.filter(item => !assignedElderlyIds.value.includes(item.id))
})

const loadData = async () => {
  loading.value = true
  try {
    const res = await mealApi.planPage({
      pageNum: pageNum.value,
      pageSize: 10,
      keyword: keyword.value || undefined
    })
    if (res.code === 200) {
      tableData.value = res.data.list
      total.value = res.data.total
    }
  } finally {
    loading.value = false
  }
}

const loadElderly = async () => {
  const res = await elderlyApi.list({ pageNum: 1, pageSize: 1000 })
  if (res.code === 200) {
    elderlyList.value = res.data.list
  }
}

const loadAssignedElderlyIds = async () => {
  const res = await mealApi.assignedElderlyIds()
  if (res.code === 200) {
    assignedElderlyIds.value = res.data
  }
}

const handleSearch = () => {
  pageNum.value = 1
  loadData()
}

const handleReset = () => {
  keyword.value = ''
  pageNum.value = 1
  loadData()
}

const handleAdd = async () => {
  await loadAssignedElderlyIds()
  if (availableElderlyList.value.length === 0) {
    ElMessage.warning('所有老人均已添加膳食计划')
    return
  }
  isAdd.value = true
  dialogTitle.value = '新增计划'
  Object.assign(form, {
    id: null,
    elderlyId: null,
    dietaryRestrictions: '',
    specialRequirements: '',
    preference: ''
  })
  dialogVisible.value = true
}

const handleEdit = (row) => {
  isAdd.value = false
  dialogTitle.value = '编辑计划'
  Object.assign(form, {
    id: row.id,
    elderlyId: row.elderlyId,
    dietaryRestrictions: row.dietaryRestrictions || '',
    specialRequirements: row.specialRequirements || '',
    preference: row.preference || ''
  })
  dialogVisible.value = true
}

const handleSubmit = async () => {
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) return

  try {
    const data = { ...form }
    const res = isAdd.value
      ? await mealApi.savePlan(data)
      : await mealApi.updatePlan(data)

    if (res.code !== 200) {
      ElMessage.error(res.message || '保存失败')
      return
    }
    ElMessage.success('保存成功')
    dialogVisible.value = false
    loadAssignedElderlyIds()
    loadData()
  } catch {
    ElMessage.error('保存失败')
  }
}

const handleDelete = (row) => {
  ElMessageBox.confirm(`确认删除 ${row.elderlyName} 的膳食计划？`, '提示', { type: 'warning' }).then(async () => {
    const res = await mealApi.deletePlan(row.id)
    if (res.code !== 200) {
      ElMessage.error(res.message || '删除失败')
      return
    }
    ElMessage.success('删除成功')
    loadAssignedElderlyIds()
    loadData()
  })
}

const handleDialogClosed = () => {
  formRef.value?.resetFields()
}

onMounted(() => {
  loadElderly()
  loadAssignedElderlyIds()
  loadData()
})
</script>

<style scoped>
.pagination {
  margin-top: 16px;
  justify-content: flex-end;
}
</style>
