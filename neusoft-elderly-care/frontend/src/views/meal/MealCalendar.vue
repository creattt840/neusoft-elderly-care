<template>
  <div class="page">
    <div class="page-header">
      <h2>膳食日历</h2>
    </div>

    <el-card>
      <el-calendar v-model="currentDate">
        <template #date-cell="{ data }">
          <div class="calendar-cell" @click="handleCellClick(data.day)">
            <span class="day-num">{{ data.day.split('-')[2] }}</span>
            <div class="meal-list">
              <div
                v-for="meal in getMealsByDate(data.day)"
                :key="meal.id"
                class="meal-item"
                :class="`meal-type-${meal.mealType}`"
              >
                <span class="meal-label">{{ mealTypeName(meal.mealType) }}</span>
                <span class="meal-content" :title="meal.menuContent">{{ meal.menuContent }}</span>
              </div>
            </div>
          </div>
        </template>
      </el-calendar>
    </el-card>

    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="600px" @closed="handleDialogClosed">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="日期">
          <el-input :model-value="form.mealDate" disabled />
        </el-form-item>
        <el-form-item label="餐次" prop="mealType">
          <el-select
            v-model="form.mealType"
            placeholder="请选择餐次"
            style="width: 100%"
            @change="handleMealTypeChange"
          >
            <el-option
              v-for="item in mealTypeOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="菜单内容" prop="menuContent">
          <el-input
            v-model="form.menuContent"
            type="textarea"
            rows="3"
            placeholder="请输入菜单内容，如：小米粥、鸡蛋、馒头"
          />
        </el-form-item>
        <el-form-item label="营养信息">
          <el-input v-model="form.nutritionInfo" type="textarea" placeholder="如：热量 500kcal，蛋白质 20g" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button v-if="!isAdd && form.id" type="danger" @click="handleDelete">删除</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { mealApi } from '../../api/elderly'
import dayjs from 'dayjs'

const currentDate = ref(new Date())
const tableData = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const isAdd = ref(false)
const formRef = ref()

const mealTypeOptions = [
  { value: 1, label: '早餐' },
  { value: 2, label: '午餐' },
  { value: 3, label: '晚餐' }
]

const form = reactive({
  id: null,
  mealDate: '',
  mealType: 1,
  menuContent: '',
  nutritionInfo: '',
  remark: ''
})

const rules = {
  mealType: [{ required: true, message: '请选择餐次', trigger: 'change' }],
  menuContent: [{ required: true, message: '请输入菜单内容', trigger: 'blur' }]
}

const formatMealDate = (value) => {
  if (!value) return ''
  const str = String(value)
  if (/^\d{4}-\d{2}-\d{2}/.test(str)) return str.slice(0, 10)
  return dayjs(value).format('YYYY-MM-DD')
}

const getMealByDateAndType = (dateStr, mealType) => {
  return tableData.value.find(item =>
    formatMealDate(item.mealDate) === dateStr && Number(item.mealType) === Number(mealType)
  )
}

const loadData = async () => {
  const base = dayjs(currentDate.value)
  const startDate = base.startOf('month').format('YYYY-MM-DD')
  const endDate = base.endOf('month').format('YYYY-MM-DD')
  const res = await mealApi.calendarWeek(startDate, endDate)
  if (res.code === 200) {
    tableData.value = res.data
  }
}

const getMealsByDate = (dateStr) => {
  return tableData.value
    .filter(item => formatMealDate(item.mealDate) === dateStr)
    .sort((a, b) => Number(a.mealType) - Number(b.mealType))
}

const mealTypeName = (type) => {
  return Number(type) === 1 ? '早' : Number(type) === 2 ? '午' : '晚'
}

const findFirstAvailableMealType = (dateStr) => {
  const available = mealTypeOptions.find(item => !getMealByDateAndType(dateStr, item.value))
  return available ? available.value : 1
}

const fillFormByDateAndType = (dateStr, mealType) => {
  const existing = getMealByDateAndType(dateStr, mealType)
  if (existing) {
    isAdd.value = false
    Object.assign(form, {
      id: existing.id,
      mealDate: dateStr,
      mealType: Number(existing.mealType),
      menuContent: existing.menuContent || '',
      nutritionInfo: existing.nutritionInfo || '',
      remark: existing.remark || ''
    })
  } else {
    isAdd.value = true
    Object.assign(form, {
      id: null,
      mealDate: dateStr,
      mealType: Number(mealType),
      menuContent: '',
      nutritionInfo: '',
      remark: ''
    })
  }
}

const handleCellClick = (dateStr) => {
  dialogTitle.value = `菜单管理 - ${dateStr}`
  const meals = getMealsByDate(dateStr)
  const defaultType = meals.length ? Number(meals[0].mealType) : findFirstAvailableMealType(dateStr)
  fillFormByDateAndType(dateStr, defaultType)
  dialogVisible.value = true
}

const handleMealTypeChange = (mealType) => {
  if (!form.mealDate) return
  fillFormByDateAndType(formatMealDate(form.mealDate), mealType)
}

const handleSubmit = async () => {
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) return

  try {
    const data = {
      id: form.id,
      mealDate: formatMealDate(form.mealDate),
      mealType: form.mealType,
      menuContent: form.menuContent,
      nutritionInfo: form.nutritionInfo,
      remark: form.remark
    }
    const res = isAdd.value
      ? await mealApi.saveCalendar(data)
      : await mealApi.updateCalendar(data)

    if (res.code !== 200) {
      ElMessage.error(res.message || '保存失败')
      return
    }
    ElMessage.success('保存成功')
    dialogVisible.value = false
    loadData()
  } catch {
    ElMessage.error('保存失败')
  }
}

const handleDelete = () => {
  ElMessageBox.confirm('确认删除该餐次菜单？', '提示', { type: 'warning' }).then(async () => {
    const res = await mealApi.deleteCalendar(form.id)
    if (res.code !== 200) {
      ElMessage.error(res.message || '删除失败')
      return
    }
    ElMessage.success('删除成功')
    dialogVisible.value = false
    loadData()
  })
}

const handleDialogClosed = () => {
  formRef.value?.resetFields()
}

watch(currentDate, loadData)

onMounted(() => {
  loadData()
})
</script>

<style scoped>
:deep(.el-calendar-table .el-calendar-day) {
  height: 110px;
  padding: 4px;
  vertical-align: top;
}

:deep(.el-calendar-table td.is-selected .el-calendar-day) {
  background-color: var(--el-color-primary-light-9);
}

.calendar-cell {
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  cursor: pointer;
  border-radius: 4px;
  transition: background-color 0.2s;
}

.calendar-cell:hover {
  background-color: var(--el-fill-color-light);
}

.day-num {
  font-weight: 600;
  font-size: 14px;
  line-height: 1.2;
  margin-bottom: 4px;
}

.meal-list {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 3px;
  overflow: hidden;
}

.meal-item {
  display: flex;
  align-items: flex-start;
  gap: 4px;
  font-size: 11px;
  line-height: 1.35;
  padding: 2px 4px;
  border-radius: 3px;
  overflow: hidden;
}

.meal-label {
  flex-shrink: 0;
  font-weight: 600;
}

.meal-content {
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  word-break: break-all;
}

.meal-type-1 {
  background: #ecf5ff;
  color: #409eff;
}

.meal-type-2 {
  background: #f0f9eb;
  color: #67c23a;
}

.meal-type-3 {
  background: #fdf6ec;
  color: #e6a23c;
}
</style>
