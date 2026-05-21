<template>
  <div class="page">
    <div class="page-header">
      <h2>老人管理</h2>
      <el-button type="primary" @click="handleAdd">新增老人</el-button>
    </div>

    <el-card>
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="姓名">
          <el-input v-model="searchForm.name" placeholder="请输入姓名" clearable />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" clearable>
            <el-option label="在住" :value="1" />
            <el-option label="退住" :value="2" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>

      <el-table :data="tableData" v-loading="loading" border>
        <el-table-column prop="name" label="姓名" width="100" />
        <el-table-column prop="gender" label="性别" width="80">
          <template #default="{ row }">
            {{ row.gender === 1 ? '男' : '女' }}
          </template>
        </el-table-column>
        <el-table-column prop="age" label="年龄" width="80" />
        <el-table-column prop="phone" label="手机号" width="120" />
        <el-table-column prop="idCard" label="身份证号" width="180" />
        <el-table-column prop="emergencyContact" label="紧急联系人" width="120" />
        <el-table-column prop="emergencyPhone" label="紧急电话" width="120" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'info'">
              {{ row.status === 1 ? '在住' : '退住' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="250" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" size="small" @click="handleDelete(row)">删除</el-button>
            <el-button v-if="row.status === 1" type="warning" size="small" @click="handleCheckOut(row)">退住</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        v-model:current-page="pageNum"
        v-model:page-size="pageSize"
        :total="total"
        @current-change="loadData"
        layout="total, prev, pager, next"
        style="margin-top: 20px;"
      />
    </el-card>

    <!-- 新增/编辑对话框 -->
    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="600px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="姓名" prop="name">
          <el-input v-model="form.name" />
        </el-form-item>
        <el-form-item label="性别" prop="gender">
          <el-radio-group v-model="form.gender">
            <el-radio :label="1">男</el-radio>
            <el-radio :label="2">女</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="年龄" prop="age">
          <el-input-number v-model="form.age" :min="1" :max="150" />
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="form.phone" />
        </el-form-item>
        <el-form-item label="身份证号">
          <el-input v-model="form.idCard" />
        </el-form-item>
        <el-form-item label="家庭住址">
          <el-input v-model="form.address" type="textarea" />
        </el-form-item>
        <el-form-item label="健康状况">
          <el-input v-model="form.healthCondition" type="textarea" />
        </el-form-item>
        <el-form-item label="过敏信息">
          <el-input v-model="form.allergyInfo" type="textarea" />
        </el-form-item>
        <el-form-item label="紧急联系人">
          <el-input v-model="form.emergencyContact" />
        </el-form-item>
        <el-form-item label="紧急电话">
          <el-input v-model="form.emergencyPhone" />
        </el-form-item>
        <el-form-item label="护理级别">
          <el-select v-model="form.careLevelId" placeholder="请选择">
            <el-option
              v-for="item in careLevelList"
              :key="item.id"
              :label="item.levelName"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item v-if="isAdd" label="分配床位">
          <el-select v-model="form.bedId" placeholder="请选择">
            <el-option
              v-for="item in availableBeds"
              :key="item.id"
              :label="'房间' + item.roomId + ' - 床位' + item.bedNo"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitLoading">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { elderlyApi, careApi, bedApi } from '../../api/elderly'

const loading = ref(false)
const tableData = ref([])
const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)

const searchForm = reactive({
  name: '',
  status: null
})

const dialogVisible = ref(false)
const dialogTitle = ref('')
const isAdd = ref(false)
const formRef = ref()
const submitLoading = ref(false)
const careLevelList = ref([])
const availableBeds = ref([])

const form = reactive({
  id: null,
  name: '',
  gender: 1,
  age: 70,
  phone: '',
  idCard: '',
  address: '',
  healthCondition: '',
  allergyInfo: '',
  emergencyContact: '',
  emergencyPhone: '',
  careLevelId: null,
  bedId: null
})

const rules = {
  name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  gender: [{ required: true, message: '请选择性别', trigger: 'change' }]
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await elderlyApi.list({
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      ...searchForm
    })
    if (res.code === 200) {
      tableData.value = res.data.records
      total.value = res.data.total
    }
  } finally {
    loading.value = false
  }
}

const loadCareLevel = async () => {
  const res = await careApi.levelList()
  if (res.code === 200) {
    careLevelList.value = res.data
  }
}

const loadAvailableBeds = async () => {
  const res = await bedApi.available()
  if (res.code === 200) {
    availableBeds.value = res.data
  }
}

const handleSearch = () => {
  pageNum.value = 1
  loadData()
}

const resetSearch = () => {
  searchForm.name = ''
  searchForm.status = null
  handleSearch()
}

const handleAdd = async () => {
  isAdd.value = true
  dialogTitle.value = '新增老人'
  Object.assign(form, {
    id: null, name: '', gender: 1, age: 70, phone: '', idCard: '',
    address: '', healthCondition: '', allergyInfo: '',
    emergencyContact: '', emergencyPhone: '', careLevelId: null, bedId: null
  })
  await loadAvailableBeds()
  dialogVisible.value = true
}

const handleEdit = (row) => {
  isAdd.value = false
  dialogTitle.value = '编辑老人'
  Object.assign(form, row)
  dialogVisible.value = true
}

const handleSubmit = async () => {
  await formRef.value.validate()
  submitLoading.value = true
  try {
    if (isAdd.value) {
      await elderlyApi.checkIn(form, form.bedId)
    } else {
      await elderlyApi.update(form)
    }
    ElMessage.success('保存成功')
    dialogVisible.value = false
    loadData()
  } finally {
    submitLoading.value = false
  }
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确认删除该老人信息？', '提示', {
    type: 'warning'
  }).then(async () => {
    await elderlyApi.delete(row.id)
    ElMessage.success('删除成功')
    loadData()
  })
}

const handleCheckOut = (row) => {
  ElMessageBox.confirm('确认办理退住？', '提示', {
    type: 'warning'
  }).then(async () => {
    await elderlyApi.checkOut(row.id)
    ElMessage.success('退住成功')
    loadData()
  })
}

onMounted(() => {
  loadData()
  loadCareLevel()
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
