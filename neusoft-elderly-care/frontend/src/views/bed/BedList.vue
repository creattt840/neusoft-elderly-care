<template>
  <div class="page">
    <div class="page-header">
      <h2>床位管理</h2>
      <el-button type="primary" @click="handleAdd">新增床位</el-button>
    </div>

    <el-card>
      <el-table :data="tableData" v-loading="loading" border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="roomId" label="所属房间" width="120" />
        <el-table-column prop="bedNo" label="床位号" width="100" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 0 ? 'success' : 'info'">
              {{ row.status === 0 ? '空闲' : '已入住' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="500px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="所属房间" prop="roomId">
          <el-select v-model="form.roomId" placeholder="请选择">
            <el-option
              v-for="item in roomList"
              :key="item.id"
              :label="item.roomNo"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="床位号" prop="bedNo">
          <el-input v-model="form.bedNo" placeholder="如：A、B、1、2" />
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
import { bedApi, roomApi } from '../../api/elderly'

const loading = ref(false)
const tableData = ref([])
const roomList = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const isAdd = ref(false)
const formRef = ref()

const form = reactive({
  id: null,
  roomId: null,
  bedNo: ''
})

const rules = {
  roomId: [{ required: true, message: '请选择房间', trigger: 'change' }],
  bedNo: [{ required: true, message: '请输入床位号', trigger: 'blur' }]
}

const loadData = async () => {
  loading.value = true
  const res = await bedApi.list()
  if (res.code === 200) {
    tableData.value = res.data
  }
  loading.value = false
}

const loadRooms = async () => {
  const res = await roomApi.list()
  if (res.code === 200) {
    roomList.value = res.data
  }
}

const handleAdd = () => {
  isAdd.value = true
  dialogTitle.value = '新增床位'
  Object.assign(form, { id: null, roomId: null, bedNo: '' })
  dialogVisible.value = true
}

const handleEdit = (row) => {
  isAdd.value = false
  dialogTitle.value = '编辑床位'
  Object.assign(form, row)
  dialogVisible.value = true
}

const handleSubmit = async () => {
  await formRef.value.validate()
  if (isAdd.value) {
    await bedApi.save(form)
  } else {
    await bedApi.update(form)
  }
  ElMessage.success('保存成功')
  dialogVisible.value = false
  loadData()
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确认删除该床位？', '提示', { type: 'warning' }).then(async () => {
    await bedApi.delete(row.id)
    ElMessage.success('删除成功')
    loadData()
  })
}

onMounted(() => {
  loadData()
  loadRooms()
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
