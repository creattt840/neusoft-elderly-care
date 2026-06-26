<template>
  <div class="page">
    <div class="page-header">
      <h2>床位管理</h2>
      <el-button type="primary" @click="handleAdd">新增床位</el-button>
    </div>

    <el-card>
      <el-table :data="tableData" v-loading="loading" border>
        <el-table-column prop="roomNo" label="所属房间" width="100" />
        <el-table-column prop="bedNo" label="床位号" width="90" />
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusTagType(row)">
              {{ getStatusLabel(row) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="入住老人" min-width="100">
          <template #default="{ row }">
            {{ isOccupied(row) ? row.elderlyName : '-' }}
          </template>
        </el-table-column>
        <el-table-column label="性别" width="70">
          <template #default="{ row }">
            {{ isOccupied(row) ? formatGender(row.elderlyGender) : '-' }}
          </template>
        </el-table-column>
        <el-table-column label="年龄" width="70">
          <template #default="{ row }">
            {{ isOccupied(row) ? row.elderlyAge : '-' }}
          </template>
        </el-table-column>
        <el-table-column label="紧急联系人" width="110">
          <template #default="{ row }">
            {{ isOccupied(row) ? (row.elderlyEmergencyContact || '-') : '-' }}
          </template>
        </el-table-column>
        <el-table-column label="紧急电话" width="120">
          <template #default="{ row }">
            {{ isOccupied(row) ? (row.elderlyEmergencyPhone || '-') : '-' }}
          </template>
        </el-table-column>
        <el-table-column label="入住时间" width="120">
          <template #default="{ row }">
            {{ isOccupied(row) ? formatCheckInDate(row.checkInDate) : '-' }}
          </template>
        </el-table-column>
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
        <el-form-item label="所属房间" prop="roomId">
          <el-select v-model="form.roomId" placeholder="请选择">
            <el-option
              v-for="item in roomList"
              :key="item.id"
              :label="formatRoomLabel(item)"
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
import dayjs from 'dayjs'
import { bedApi, roomApi } from '../../api/elderly'
import { runWithMessage } from '../../utils/message'

const loading = ref(false)
const tableData = ref([])
const roomList = ref([])
const pageNum = ref(1)
const total = ref(0)
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

const isRoomMaintaining = (row) => Number(row.roomStatus) === 2

const isOccupied = (row) => !isRoomMaintaining(row) && Number(row.status) === 1

const getStatusLabel = (row) => {
  if (isRoomMaintaining(row)) return '维修中'
  return Number(row.status) === 1 ? '已入住' : '空闲'
}

const getStatusTagType = (row) => {
  if (isRoomMaintaining(row)) return 'danger'
  return Number(row.status) === 1 ? 'info' : 'success'
}

const formatGender = (gender) => {
  return Number(gender) === 1 ? '男' : Number(gender) === 2 ? '女' : '-'
}

const formatCheckInDate = (date) => {
  if (!date) return '-'
  return dayjs(date).format('YYYY-MM-DD')
}

const formatRoomLabel = (room) => {
  const suffix = Number(room.status) === 2 ? '（维修中）' : ''
  return `${room.roomNo}${suffix}`
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await bedApi.page({
      pageNum: pageNum.value,
      pageSize: 10
    })
    if (res.code === 200) {
      tableData.value = res.data.list
      total.value = res.data.total
    }
  } finally {
    loading.value = false
  }
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
  Object.assign(form, {
    id: row.id,
    roomId: row.roomId,
    bedNo: row.bedNo
  })
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
  ElMessageBox.confirm('确认删除该床位？', '提示', { type: 'warning' }).then(() => {
    runWithMessage(() => bedApi.delete(row.id), '删除成功', loadData)
  })
}

onMounted(() => {
  loadData()
  loadRooms()
})
</script>

<style scoped>
.pagination {
  margin-top: 20px;
  justify-content: flex-end;
}
</style>
