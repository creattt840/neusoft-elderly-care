<template>
  <div class="page">
    <div class="page-header">
      <h2>护理级别</h2>
      <el-button type="primary" @click="handleAdd">新增级别</el-button>
    </div>

    <el-card>
      <el-table :data="tableData" v-loading="loading" border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="levelName" label="级别名称" />
        <el-table-column prop="levelCode" label="编码" />
        <el-table-column prop="description" label="描述" />
        <el-table-column prop="sortOrder" label="排序" width="80" />
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
        <el-form-item label="级别名称">
          <el-input v-model="form.levelName" />
        </el-form-item>
        <el-form-item label="编码">
          <el-input v-model="form.levelCode" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="form.description" type="textarea" />
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="form.sortOrder" :min="0" />
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
import { careApi } from '../../api/elderly'

const loading = ref(false)
const tableData = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const isAdd = ref(false)
const formRef = ref()

const form = reactive({
  id: null,
  levelName: '',
  levelCode: '',
  description: '',
  sortOrder: 0
})

const loadData = async () => {
  loading.value = true
  const res = await careApi.levelList()
  if (res.code === 200) {
    tableData.value = res.data
  }
  loading.value = false
}

const handleAdd = () => {
  isAdd.value = true
  dialogTitle.value = '新增护理级别'
  Object.assign(form, { id: null, levelName: '', levelCode: '', description: '', sortOrder: 0 })
  dialogVisible.value = true
}

const handleEdit = (row) => {
  isAdd.value = false
  dialogTitle.value = '编辑护理级别'
  Object.assign(form, row)
  dialogVisible.value = true
}

const handleSubmit = async () => {
  if (isAdd.value) {
    await careApi.saveLevel(form)
  } else {
    await careApi.updateLevel(form)
  }
  ElMessage.success('保存成功')
  dialogVisible.value = false
  loadData()
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确认删除？', '提示', { type: 'warning' }).then(async () => {
    await careApi.deleteLevel(row.id)
    ElMessage.success('删除成功')
    loadData()
  })
}

onMounted(() => {
  loadData()
})
</script>

