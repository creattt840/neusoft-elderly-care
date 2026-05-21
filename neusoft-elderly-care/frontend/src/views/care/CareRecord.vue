<template>
  <div class="page">
    <div class="page-header">
      <h2>护理记录</h2>
      <el-button type="primary" @click="handleAdd">新增记录</el-button>
    </div>

    <el-card>
      <el-form :inline="true">
        <el-form-item label="老人">
          <el-select v-model="selectedElderlyId" placeholder="请选择" clearable @change="loadData">
            <el-option
              v-for="item in elderlyList"
              :key="item.id"
              :label="item.name"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="日期">
          <el-date-picker
            v-model="selectedDate"
            type="date"
            placeholder="选择日期"
            @change="loadData"
          />
        </el-form-item>
      </el-form>

      <el-table :data="tableData" v-loading="loading" border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="elderlyId" label="老人ID" width="80" />
        <el-table-column prop="careItemId" label="护理项目ID" width="100" />
        <el-table-column prop="recordDate" label="记录日期" width="120" />
        <el-table-column prop="recordTime" label="记录时间" width="160" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : row.status === 2 ? 'info' : 'warning'">
              {{ row.status === 1 ? '已执行' : row.status === 2 ? '跳过' : '待执行' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="500px">
      <el-form :model="form" ref="formRef" label-width="100px">
        <el-form-item label="老人">
          <el-select v-model="form.elderlyId" placeholder="请选择">
            <el-option
              v-for="item in elderlyList"
              :key="item.id"
              :label="item.name"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="护理项目">
          <el-select v-model="form.careItemId" placeholder="请选择">
            <el-option
              v-for="item in careItemList"
              :key="item.id"
              :label="item.itemName"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="form.status">
            <el-radio :label="0">待执行</el-radio>
            <el-radio :label="1">已执行</el-radio>
            <el-radio :label="2">跳过</el-radio>
          </el-radio-group>
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
import { ElMessage, ElMessageBox } from 'element-plus'
import { careRecordApi, elderlyApi, careApi } from '../../api/elderly'
import dayjs from 'dayjs'

const loading = ref(false)
const tableData = ref([])
const elderlyList = ref([])
const careItemList = ref([])
const selectedElderlyId = ref(null)
const selectedDate = ref('')
const dialogVisible = ref(false)
const dialogTitle = ref('')
const isAdd = ref(false)
const formRef = ref()

const form = reactive({
  id: null,
  elderlyId: null,
  careItemId: null,
  recordDate: '',
  recordTime: '',
  status: 0,
  remark: ''
})

const loadData = async () => {
  loading.value = true
  let res
  if (selectedElderlyId.value) {
    res = await careRecordApi.list(selectedElderlyId.value)
  } else {
    res = await careRecordApi.list()
  }
  if (res.code === 200) {
    tableData.value = res.data
  }
  loading.value = false
}

const loadElderly = async () => {
  const res = await elderlyApi.list({ pageNum: 1, pageSize: 1000 })
  if (res.code === 200) {
    elderlyList.value = res.data.records
  }
}

const loadCareItem = async () => {
  const res = await careApi.itemList()
  if (res.code === 200) {
    careItemList.value = res.data
  }
}

const handleAdd = () => {
  isAdd.value = true
  dialogTitle.value = '新增护理记录'
  Object.assign(form, {
    id: null, elderlyId: null, careItemId: null, recordDate: dayjs().format('YYYY-MM-DD'),
    recordTime: dayjs().format('YYYY-MM-DD HH:mm:ss'), status: 0, remark: ''
  })
  dialogVisible.value = true
}

const handleEdit = (row) => {
  isAdd.value = false
  dialogTitle.value = '编辑护理记录'
  Object.assign(form, row)
  dialogVisible.value = true
}

const handleSubmit = async () => {
  if (isAdd.value) {
    await careRecordApi.save(form)
  } else {
    await careRecordApi.update(form)
  }
  ElMessage.success('保存成功')
  dialogVisible.value = false
  loadData()
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确认删除？', '提示', { type: 'warning' }).then(async () => {
    await careRecordApi.delete(row.id)
    ElMessage.success('删除成功')
    loadData()
  })
}

onMounted(() => {
  loadData()
  loadElderly()
  loadCareItem()
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
