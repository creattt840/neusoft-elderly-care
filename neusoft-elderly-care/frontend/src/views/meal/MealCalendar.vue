<template>
  <div class="page">
    <div class="page-header">
      <h2>膳食日历</h2>
      <el-button type="primary" @click="handleAdd">新增菜单</el-button>
    </div>

    <el-card>
      <el-calendar v-model="currentDate">
        <template #date-cell="{ data }">
          <div class="calendar-cell">
            <span>{{ data.day.split('-')[2] }}</span>
            <div v-if="getMealsByDate(data.day).length" class="meal-tags">
              <el-tag v-for="meal in getMealsByDate(data.day)" :key="meal.id" size="small" :type="getMealType(meal.mealType)">
                {{ mealTypeName(meal.mealType) }}
              </el-tag>
            </div>
          </div>
        </template>
      </el-calendar>
    </el-card>

    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="600px">
      <el-form :model="form" ref="formRef" label-width="100px">
        <el-form-item label="日期">
          <el-date-picker v-model="form.mealDate" type="date" placeholder="选择日期" />
        </el-form-item>
        <el-form-item label="餐次">
          <el-radio-group v-model="form.mealType">
            <el-radio :label="1">早餐</el-radio>
            <el-radio :label="2">午餐</el-radio>
            <el-radio :label="3">晚餐</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="菜单内容">
          <el-input v-model="form.menuContent" type="textarea" rows="3" placeholder="请输入菜单内容，如：小米粥、鸡蛋、馒头" />
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
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { mealApi } from '../../api/elderly'
import dayjs from 'dayjs'

const currentDate = ref(new Date())
const loading = ref(false)
const tableData = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const isAdd = ref(false)
const formRef = ref()

const form = reactive({
  id: null,
  mealDate: '',
  mealType: 1,
  menuContent: '',
  nutritionInfo: '',
  remark: ''
})

const loadData = async () => {
  const date = dayjs(currentDate.value).format('YYYY-MM-DD')
  const res = await mealApi.calendarList(date)
  if (res.code === 200) {
    tableData.value = res.data
  }
}

const getMealsByDate = (dateStr) => {
  return tableData.value.filter(item => dayjs(item.mealDate).format('YYYY-MM-DD') === dateStr)
}

const getMealType = (type) => {
  return type === 1 ? 'primary' : type === 2 ? 'success' : 'warning'
}

const mealTypeName = (type) => {
  return type === 1 ? '早' : type === 2 ? '午' : '晚'
}

const handleAdd = () => {
  isAdd.value = true
  dialogTitle.value = '新增菜单'
  Object.assign(form, {
    id: null, mealDate: new Date(), mealType: 1,
    menuContent: '', nutritionInfo: '', remark: ''
  })
  dialogVisible.value = true
}

const handleSubmit = async () => {
  const data = { ...form, mealDate: dayjs(form.mealDate).format('YYYY-MM-DD') }
  if (isAdd.value) {
    await mealApi.saveCalendar(data)
  } else {
    await mealApi.updateCalendar(data)
  }
  ElMessage.success('保存成功')
  dialogVisible.value = false
  loadData()
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.calendar-cell {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.meal-tags {
  margin-top: 5px;
  display: flex;
  gap: 2px;
}
</style>
