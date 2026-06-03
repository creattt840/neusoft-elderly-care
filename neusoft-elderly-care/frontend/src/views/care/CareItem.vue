<template>
  <div class="page">
    <div class="page-header">
      <h2>护理内容</h2>
      <el-button type="primary" @click="handleAdd">新增内容</el-button>
    </div>

    <el-card>
      <el-form :inline="true">
        <el-form-item label="护理级别">
          <el-select
            v-model="selectedLevelId"
            placeholder="全部级别"
            clearable
            style="width: 200px"
            @change="handleFilterChange"
          >
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
        <el-table-column prop="itemName" label="项目名称" min-width="120" />
        <el-table-column prop="levelName" label="所属级别" min-width="120" show-overflow-tooltip />
        <el-table-column prop="frequency" label="执行频率" width="120" />
        <el-table-column prop="description" label="描述" min-width="160" show-overflow-tooltip />
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
      <el-form :model="form" ref="formRef" label-width="100px">
        <el-form-item label="项目名称">
          <el-input v-model="form.itemName" />
        </el-form-item>
        <el-form-item label="所属级别">
          <el-select v-model="form.careLevelId" placeholder="请选择" style="width: 100%">
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
const selectedLevelId = ref(undefined)
const pageNum = ref(1)
const total = ref(0)
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

const buildQueryParams = () => {
  const params = {
    pageNum: pageNum.value,
    pageSize: 10
  }
  if (selectedLevelId.value !== undefined && selectedLevelId.value !== null) {
    params.careLevelId = selectedLevelId.value
  }
  return params
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await careApi.itemPage(buildQueryParams())
    if (res.code === 200) {
      tableData.value = res.data.list
      total.value = res.data.total
    }
  } finally {
    loading.value = false
  }
}

const loadLevel = async () => {
  const res = await careApi.levelList()
  if (res.code === 200) {
    levelList.value = res.data
  }
}

const handleFilterChange = () => {
  pageNum.value = 1
  loadData()
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
  loadLevel()
  loadData()
})
</script>

<style scoped>
.pagination {
  margin-top: 16px;
  justify-content: flex-end;
}
</style>
