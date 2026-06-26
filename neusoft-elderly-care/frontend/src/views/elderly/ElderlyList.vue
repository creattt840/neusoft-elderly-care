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

          <el-select

            v-model="searchForm.status"

            placeholder="请选择状态"

            clearable

            style="width: 120px"

          >

            <el-option

              v-for="item in statusOptions"

              :key="item.value"

              :label="item.label"

              :value="item.value"

            />

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

        <el-table-column label="家庭住址" min-width="180" show-overflow-tooltip>

          <template #default="{ row }">

            {{ formatFullAddress(row) }}

          </template>

        </el-table-column>

        <el-table-column label="入住时间" width="120">

          <template #default="{ row }">

            {{ formatCheckInDate(row.checkInDate) }}

          </template>

        </el-table-column>

        <el-table-column label="床位" width="140">

          <template #default="{ row }">

            <span v-if="row.roomNo && row.bedNo">{{ row.roomNo }} - {{ row.bedNo }}</span>

            <span v-else-if="row.bedId">床位#{{ row.bedId }}</span>

            <span v-else>-</span>

          </template>

        </el-table-column>

        <el-table-column prop="status" label="状态" width="100">

          <template #default="{ row }">

            <el-tag :type="Number(row.status) === 1 ? 'success' : 'info'">

              {{ Number(row.status) === 1 ? '在住' : '退住' }}

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



    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="640px">

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

        <el-form-item label="所在地区" prop="addressRegion">

          <el-cascader

            v-model="form.addressRegion"

            :options="regionOptions"

            placeholder="请选择国家/省/市"

            style="width: 100%"

            clearable

          />

        </el-form-item>

        <el-form-item label="详细地址" prop="addressDetail">

          <el-input v-model="form.addressDetail" placeholder="街道、小区、门牌号等" />

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

        <el-form-item v-if="isAdd || form.status === 1" label="分配床位">

          <el-select v-model="form.bedId" placeholder="请选择" clearable>

            <el-option

              v-for="item in availableBeds"

              :key="item.id"

              :label="formatBedLabel(item)"

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

import dayjs from 'dayjs'

import { elderlyApi, careApi, bedApi } from '../../api/elderly'
import { runWithMessage } from '../../utils/message'

import {

  regionOptions,

  formatFullAddress,

  buildAddressPayload,

  parseAddressRegion

} from '../../data/regions'



const loading = ref(false)

const tableData = ref([])

const pageNum = ref(1)

const pageSize = ref(10)

const total = ref(0)



const searchForm = reactive({

  name: '',

  status: undefined

})



const statusOptions = [

  { label: '在住', value: 1 },

  { label: '退住', value: 2 }

]



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

  addressRegion: [],

  addressDetail: '',

  healthCondition: '',

  allergyInfo: '',

  emergencyContact: '',

  emergencyPhone: '',

  careLevelId: null,

  bedId: null,

  status: null

})



const rules = {

  name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],

  gender: [{ required: true, message: '请选择性别', trigger: 'change' }],

  addressRegion: [{ required: true, message: '请选择所在地区', trigger: 'change' }],

  addressDetail: [{ required: true, message: '请输入详细地址', trigger: 'blur' }]

}



const formatCheckInDate = (date) => {

  if (!date) return '-'

  return dayjs(date).format('YYYY-MM-DD')

}



const buildQueryParams = () => {

  const params = {

    pageNum: pageNum.value,

    pageSize: pageSize.value

  }

  if (searchForm.name?.trim()) {

    params.name = searchForm.name.trim()

  }

  if (searchForm.status !== undefined && searchForm.status !== null && searchForm.status !== '') {

    params.status = Number(searchForm.status)

  }

  return params

}



const buildSubmitPayload = () => {

  const address = buildAddressPayload(form.addressRegion, form.addressDetail)

  return {

    id: form.id,

    name: form.name,

    gender: form.gender,

    age: form.age,

    phone: form.phone,

    idCard: form.idCard,

    ...address,

    healthCondition: form.healthCondition,

    allergyInfo: form.allergyInfo,

    emergencyContact: form.emergencyContact,

    emergencyPhone: form.emergencyPhone,

    careLevelId: form.careLevelId,

    bedId: form.bedId,

    status: form.status

  }

}



const resetForm = () => {

  Object.assign(form, {

    id: null,

    name: '',

    gender: 1,

    age: 70,

    phone: '',

    idCard: '',

    addressRegion: [],

    addressDetail: '',

    healthCondition: '',

    allergyInfo: '',

    emergencyContact: '',

    emergencyPhone: '',

    careLevelId: null,

    bedId: null,

    status: null

  })

}



const fillFormFromRow = (row) => {

  Object.assign(form, {

    id: row.id,

    name: row.name,

    gender: row.gender,

    age: row.age,

    phone: row.phone,

    idCard: row.idCard,

    addressRegion: parseAddressRegion(row),

    addressDetail: row.addressDetail || (!row.country && row.address ? row.address : ''),

    healthCondition: row.healthCondition,

    allergyInfo: row.allergyInfo,

    emergencyContact: row.emergencyContact,

    emergencyPhone: row.emergencyPhone,

    careLevelId: row.careLevelId,

    bedId: row.bedId,

    status: row.status

  })

}



const loadData = async () => {

  loading.value = true

  try {

    const res = await elderlyApi.list(buildQueryParams())

    if (res.code === 200) {

      tableData.value = res.data.list

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



const loadAvailableBeds = async (elderlyId = null) => {

  const res = elderlyId

    ? await elderlyApi.availableBeds(elderlyId)

    : await bedApi.available()

  if (res.code === 200) {

    availableBeds.value = res.data

  }

}



const formatBedLabel = (bed) => {

  const roomLabel = bed.roomNo || `房间${bed.roomId}`

  return `${roomLabel} - 床位${bed.bedNo}`

}



const handleSearch = () => {

  pageNum.value = 1

  loadData()

}



const resetSearch = () => {

  searchForm.name = ''

  searchForm.status = undefined

  handleSearch()

}



const handleAdd = async () => {

  isAdd.value = true

  dialogTitle.value = '新增老人'

  resetForm()

  await loadAvailableBeds()

  dialogVisible.value = true

}



const handleEdit = async (row) => {

  isAdd.value = false

  dialogTitle.value = '编辑老人'

  fillFormFromRow(row)

  await loadAvailableBeds(row.id)

  dialogVisible.value = true

}



const handleSubmit = async () => {

  await formRef.value.validate()

  submitLoading.value = true

  try {

    const payload = buildSubmitPayload()

    if (isAdd.value) {

      await elderlyApi.checkIn(payload, form.bedId)

    } else {

      await elderlyApi.update(payload)

    }

    ElMessage.success('保存成功')

    dialogVisible.value = false

    loadData()

  } finally {

    submitLoading.value = false

  }

}



const handleDelete = (row) => {

  const message = Number(row.status) === 1

    ? '该老人当前在住，删除后将自动释放床位，确认删除？'

    : '确认删除该老人信息？'

  ElMessageBox.confirm(message, '提示', {

    type: 'warning'

  }).then(() => {
    runWithMessage(() => elderlyApi.delete(row.id), '删除成功', loadData)
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




