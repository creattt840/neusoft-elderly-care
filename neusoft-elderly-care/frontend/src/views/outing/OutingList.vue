<template>
  <div class="page">
    <div class="page-header">
      <h2>外出登记</h2>
      <el-button type="primary" @click="handleAdd">登记外出</el-button>
    </div>

    <el-card v-loading="loading">
      <el-tabs v-model="activeTab" @tab-change="handleTabChange">
        <el-tab-pane label="全部记录" name="all">
          <outing-table :data="tableData" @refresh="loadData" />
        </el-tab-pane>
        <el-tab-pane label="外出中" name="active">
          <outing-table :data="tableData" @refresh="loadData" />
        </el-tab-pane>
        <el-tab-pane label="已返回" name="returned">
          <outing-table :data="tableData" @refresh="loadData" />
        </el-tab-pane>
      </el-tabs>

      <el-pagination
        v-model:current-page="pageNum"
        :page-size="pageSize"
        :total="total"
        layout="total, prev, pager, next, jumper"
        background
        class="pagination"
        @current-change="loadData"
      />
    </el-card>

    <el-dialog title="登记外出" v-model="dialogVisible" width="600px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="外出老人" prop="elderlyId">
          <el-select v-model="form.elderlyId" placeholder="请选择">
            <el-option
              v-for="item in elderlyList"
              :key="item.id"
              :label="item.name"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="外出类型" prop="outingType">
          <el-select v-model="form.outingType" placeholder="请选择">
            <el-option label="临时外出" :value="1" />
            <el-option label="长期外出" :value="2" />
            <el-option label="外出就医" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="开始时间" prop="startTime">
          <el-date-picker
            v-model="form.startTime"
            type="datetime"
            placeholder="选择日期时间"
          />
        </el-form-item>
        <el-form-item label="预计返回" prop="expectedReturnTime">
          <el-date-picker
            v-model="form.expectedReturnTime"
            type="datetime"
            placeholder="选择日期时间"
          />
        </el-form-item>
        <el-form-item label="陪同人">
          <el-input v-model="form.accompanier" />
        </el-form-item>
        <el-form-item label="陪同电话">
          <el-input v-model="form.accompanierPhone" />
        </el-form-item>
        <el-form-item label="目的地">
          <el-input v-model="form.destination" />
        </el-form-item>
        <el-form-item label="外出原因">
          <el-input v-model="form.reason" type="textarea" />
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
import { outingApi, elderlyApi } from '../../api/elderly'
import OutingTable from './OutingTable.vue'

const activeTab = ref('all')
const loading = ref(false)
const tableData = ref([])
const pageNum = ref(1)
const pageSize = 10
const total = ref(0)
const elderlyList = ref([])
const dialogVisible = ref(false)
const formRef = ref()

const form = reactive({
  elderlyId: null,
  outingType: 1,
  startTime: '',
  expectedReturnTime: '',
  accompanier: '',
  accompanierPhone: '',
  destination: '',
  reason: ''
})

const rules = {
  elderlyId: [{ required: true, message: '请选择老人', trigger: 'change' }],
  outingType: [{ required: true, message: '请选择类型', trigger: 'change' }],
  startTime: [{ required: true, message: '请选择开始时间', trigger: 'change' }]
}

const getStatusParam = () => {
  if (activeTab.value === 'active') return 0
  if (activeTab.value === 'returned') return 1
  return undefined
}

const loadData = async () => {
  loading.value = true
  try {
    const params = { pageNum: pageNum.value, pageSize }
    const status = getStatusParam()
    if (status !== undefined) {
      params.status = status
    }
    const res = await outingApi.page(params)
    if (res.code === 200) {
      tableData.value = res.data.list
      total.value = res.data.total
    }
  } finally {
    loading.value = false
  }
}

const handleTabChange = () => {
  pageNum.value = 1
  loadData()
}

const loadElderly = async () => {
  const res = await elderlyApi.list({ pageNum: 1, pageSize: 1000, status: 1 })
  if (res.code === 200) {
    elderlyList.value = res.data.list
  }
}

const handleAdd = async () => {
  await loadElderly()
  Object.assign(form, {
    elderlyId: null, outingType: 1, startTime: '', expectedReturnTime: '',
    accompanier: '', accompanierPhone: '', destination: '', reason: ''
  })
  dialogVisible.value = true
}

const handleSubmit = async () => {
  await formRef.value.validate()
  await outingApi.save(form)
  ElMessage.success('登记成功')
  dialogVisible.value = false
  loadData()
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.pagination {
  margin-top: 20px;
  justify-content: flex-end;
}
</style>
