<template>
  <div class="page">
    <div class="page-header">
      <h2>房间管理</h2>
      <el-button type="primary" @click="handleAdd">新增房间</el-button>
    </div>

    <el-card>
      <el-table :data="tableData" v-loading="loading" border>
        <el-table-column prop="roomNo" label="房间号" width="100" />
        <el-table-column prop="roomType" label="房间类型" width="120">
          <template #default="{ row }">
            {{ row.roomType === 1 ? '单人间' : row.roomType === 2 ? '双人间' : '多人间' }}
          </template>
        </el-table-column>
        <el-table-column prop="floor" label="楼层" width="80" />
        <el-table-column prop="capacity" label="容纳人数" width="100" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'">
              {{ row.status === 1 ? '可用' : '维修中' }}
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
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="房间号" prop="roomNo">
          <el-input v-model="form.roomNo" />
        </el-form-item>
        <el-form-item label="房间类型" prop="roomType">
          <el-select v-model="form.roomType" placeholder="请选择">
            <el-option label="单人间" :value="1" />
            <el-option label="双人间" :value="2" />
            <el-option label="多人间" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="楼层" prop="floor">
          <el-input-number v-model="form.floor" :min="1" :max="20" />
        </el-form-item>
        <el-form-item label="容纳人数">
          <el-input-number v-model="form.capacity" :min="1" :max="10" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="form.status">
            <el-radio :label="1">可用</el-radio>
            <el-radio :label="2">维修中</el-radio>
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
import { roomApi } from '../../api/elderly'

const loading = ref(false)
const tableData = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const isAdd = ref(false)
const formRef = ref()

const form = reactive({
  id: null,
  roomNo: '',
  roomType: 1,
  floor: 1,
  capacity: 1,
  status: 1,
  remark: ''
})

const rules = {
  roomNo: [{ required: true, message: '请输入房间号', trigger: 'blur' }],
  roomType: [{ required: true, message: '请选择房间类型', trigger: 'change' }]
}

const loadData = async () => {
  loading.value = true
  const res = await roomApi.list()
  if (res.code === 200) {
    tableData.value = res.data
  }
  loading.value = false
}

const handleAdd = () => {
  isAdd.value = true
  dialogTitle.value = '新增房间'
  Object.assign(form, {
    id: null, roomNo: '', roomType: 1, floor: 1, capacity: 1, status: 1, remark: ''
  })
  dialogVisible.value = true
}

const handleEdit = (row) => {
  isAdd.value = false
  dialogTitle.value = '编辑房间'
  Object.assign(form, row)
  dialogVisible.value = true
}

const handleSubmit = async () => {
  await formRef.value.validate()
  if (isAdd.value) {
    await roomApi.save(form)
  } else {
    await roomApi.update(form)
  }
  ElMessage.success('保存成功')
  dialogVisible.value = false
  loadData()
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确认删除该房间？', '提示', { type: 'warning' }).then(async () => {
    await roomApi.delete(row.id)
    ElMessage.success('删除成功')
    loadData()
  })
}

onMounted(() => {
  loadData()
})
</script>

