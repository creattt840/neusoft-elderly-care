<template>
  <div class="page">
    <div class="page-header">
      <h2>护理内容</h2>
      <el-button type="primary" @click="handleAdd">新增内容</el-button>
    </div>

    <el-card>
      <el-form :inline="true">
        <el-form-item label="护理级别">
          <el-select v-model="selectedLevelId" placeholder="请选择" clearable @change="loadData">
            <el-option
              v-for="item in levelList"
              :key="item.id"
              :label="item.levelName"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
      </el-form>

      <el-table :data="tableData" v-loading="loading" border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="itemName" label="项目名称" />
        <el-table-column prop="careLevelId" label="所属级别">
          <template #default="{ row }">
            {{ getLevelName(row.careLevelId) }}
          </template>
        </el-table-column>
        <el-table-column prop="frequency" label="执行频率" />
        <el-table-column prop="description" label="描述" />
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
        <el-form-item label="项目名称">
          <el-input v-model="form.itemName" />
        </el-form-item>
        <el-form-item label="所属级别">
          <el-select v-model="form.careLevelId" placeholder="请选择">
            <el-option
              v-for="item in levelList"
              :key="item.id"
              :label="item.levelName"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="执行频率">
          <el-input v-model="form.frequency" placeholder="如：每日1次" />
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
const levelList = ref([])
const selectedLevelId = ref(null)
const dialogVisible = ref(false)
const dialogTitle = ref('')
const isAdd = ref(false)
const formRef = ref()

const form = reactive({
  id: null,
  itemName: '',
  careLevelId: null,
  frequency: '',
  description: '',
  sortOrder: 0
})

const loadData = async () => {
  loading.value = true
  const res = await careApi.itemList(selectedLevelId.value)
  if (res.code === 200) {
    tableData.value = res.data
  }
  loading.value = false
}

const loadLevel = async () => {
  const res = await careApi.levelList()
  if (res.code === 200) {
    levelList.value = res.data
  }
}

const getLevelName = (id) => {
  const level = levelList.value.find(item => item.id === id)
  return level ? level.levelName : '-'
}

const handleAdd = () => {
  isAdd.value = true
  dialogTitle.value = '新增护理内容'
  Object.assign(form, { id: null, itemName: '', careLevelId: null, frequency: '', description: '', sortOrder: 0 })
  dialogVisible.value = true
}

const handleEdit = (row) => {
  isAdd.value = false
  dialogTitle.value = '编辑护理内容'
  Object.assign(form, row)
  dialogVisible.value = true
}

const handleSubmit = async () => {
  if (isAdd.value) {
    await careApi.saveItem(form)
  } else {
    await careApi.updateItem(form)
  }
  ElMessage.success('保存成功')
  dialogVisible.value = false
  loadData()
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确认删除？', '提示', { type: 'warning' }).then(async () => {
    await careApi.deleteItem(row.id)
    ElMessage.success('删除成功')
    loadData()
  })
}

onMounted(() => {
  loadData()
  loadLevel()
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
