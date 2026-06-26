<template>
  <div class="page">
    <div class="page-header">
      <h2>护理记录</h2>
      <el-button type="primary" @click="handleAdd">新增记录</el-button>
    </div>

    <el-card>
      <el-form :inline="true">
        <el-form-item label="老人">
          <el-select
            v-model="selectedElderlyId"
            placeholder="全部老人"
            clearable
            filterable
            style="width: 200px"
            @change="handleFilterChange"
          >
            <el-option
              v-for="item in elderlyList"
              :key="item.id"
              :label="formatElderlyLabel(item)"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="日期">
          <el-date-picker
            v-model="selectedDate"
            type="date"
            placeholder="选择日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            clearable
            @change="handleFilterChange"
          />
        </el-form-item>
      </el-form>

      <el-table :data="tableData" v-loading="loading" border>
        <el-table-column prop="elderlyName" label="老人姓名" min-width="100" />
        <el-table-column prop="itemName" label="护理项目" min-width="120" />
        <el-table-column prop="levelName" label="护理级别" min-width="100" show-overflow-tooltip />
        <el-table-column label="记录日期" width="120">
          <template #default="{ row }">
            {{ formatRecordDate(row.recordDate) }}
          </template>
        </el-table-column>
        <el-table-column label="记录时间" width="170">
          <template #default="{ row }">
            {{ formatRecordTime(row.recordTime) }}
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : row.status === 2 ? 'info' : 'warning'">
              {{ row.status === 1 ? '已执行' : row.status === 2 ? '跳过' : '待执行' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" min-width="120" show-overflow-tooltip />
        <el-table-column label="操作" width="200" fixed="right">
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

    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="500px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="老人" prop="elderlyId">
          <el-select v-model="form.elderlyId" placeholder="请选择" filterable style="width: 100%">
            <el-option
              v-for="item in elderlyList"
              :key="item.id"
              :label="formatElderlyLabel(item)"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="护理项目" prop="careItemId">
          <el-select v-model="form.careItemId" placeholder="请选择" filterable style="width: 100%">
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
            <el-radio :value="0">待执行</el-radio>
            <el-radio :value="1">已执行</el-radio>
            <el-radio :value="2">跳过</el-radio>
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
import { runWithMessage } from '../../utils/message'
import dayjs from 'dayjs'
import customParseFormat from 'dayjs/plugin/customParseFormat'

dayjs.extend(customParseFormat)

const loading = ref(false)
const tableData = ref([])
const elderlyList = ref([])
const careItemList = ref([])
const selectedElderlyId = ref(undefined)
const selectedDate = ref('')
const pageNum = ref(1)
const total = ref(0)
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

const rules = {
  elderlyId: [{ required: true, message: '请选择老人', trigger: 'change' }],
  careItemId: [{ required: true, message: '请选择护理项目', trigger: 'change' }]
}

const formatElderlyLabel = (item) => {
  return item.phone ? `${item.name}（${item.phone}）` : item.name
}

const formatRecordDate = (value) => {
  if (!value) return '-'
  const str = String(value)
  if (/^\d{4}-\d{2}-\d{2}$/.test(str)) return str
  const parsed = dayjs(str, ['YYYY-MM-DD', 'YYYY-MM-DD HH:mm:ss', 'YYYY-MM-DDTHH:mm:ss'], true)
  return parsed.isValid() ? parsed.format('YYYY-MM-DD') : '-'
}

const formatRecordTime = (value) => {
  if (!value) return '-'
  const str = String(value)
  if (/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/.test(str)) return str
  const parsed = dayjs(str, ['YYYY-MM-DD HH:mm:ss', 'YYYY-MM-DDTHH:mm:ss'], true)
  return parsed.isValid() ? parsed.format('YYYY-MM-DD HH:mm:ss') : formatRecordDate(value)
}

const buildQueryParams = () => {
  const params = {
    pageNum: pageNum.value,
    pageSize: 10
  }
  if (selectedElderlyId.value !== undefined && selectedElderlyId.value !== null) {
    params.elderlyId = selectedElderlyId.value
  }
  if (selectedDate.value) {
    params.recordDate = selectedDate.value
  }
  return params
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await careRecordApi.page(buildQueryParams())
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

const loadCareItem = async () => {
  const res = await careApi.itemList()
  if (res.code === 200) {
    careItemList.value = res.data
  }
}

const handleFilterChange = () => {
  pageNum.value = 1
  loadData()
}

const handleAdd = () => {
  isAdd.value = true
  dialogTitle.value = '新增护理记录'
  Object.assign(form, {
    id: null,
    elderlyId: selectedElderlyId.value ?? null,
    careItemId: null,
    recordDate: '',
    recordTime: '',
    status: 0,
    remark: ''
  })
  dialogVisible.value = true
}

const handleEdit = (row) => {
  isAdd.value = false
  dialogTitle.value = '编辑护理记录'
  Object.assign(form, {
    id: row.id,
    elderlyId: row.elderlyId,
    careItemId: row.careItemId,
    recordDate: row.recordDate,
    recordTime: row.recordTime,
    status: row.status ?? 0,
    remark: row.remark ?? ''
  })
  dialogVisible.value = true
}

const handleSubmit = async () => {
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) return

  try {
    const payload = {
      id: form.id,
      elderlyId: form.elderlyId,
      careItemId: form.careItemId,
      status: form.status,
      remark: form.remark
    }
    if (!isAdd.value) {
      payload.recordDate = form.recordDate
      payload.recordTime = form.recordTime
    }

    const res = isAdd.value
      ? await careRecordApi.save(payload)
      : await careRecordApi.update(payload)

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

const handleDelete = (row) => {
  ElMessageBox.confirm('确认删除？', '提示', { type: 'warning' }).then(() => {
    runWithMessage(() => careRecordApi.delete(row.id), '删除成功', loadData)
  })
}

onMounted(() => {
  loadElderly()
  loadCareItem()
  loadData()
})
</script>

<style scoped>
.pagination {
  margin-top: 16px;
  justify-content: flex-end;
}
</style>
