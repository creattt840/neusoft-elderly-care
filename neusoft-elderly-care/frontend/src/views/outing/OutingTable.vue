<template>
  <el-table :data="data" border>
    <el-table-column prop="elderlyId" label="老人ID" width="80" />
    <el-table-column prop="outingType" label="类型" width="100">
      <template #default="{ row }">
        {{ row.outingType === 1 ? '临时外出' : row.outingType === 2 ? '长期外出' : '外出就医' }}
      </template>
    </el-table-column>
    <el-table-column prop="startTime" label="开始时间" width="160" />
    <el-table-column prop="expectedReturnTime" label="预计返回" width="160" />
    <el-table-column prop="accompanier" label="陪同人" width="100" />
    <el-table-column prop="destination" label="目的地" />
    <el-table-column prop="status" label="状态" width="100">
      <template #default="{ row }">
        <el-tag :type="row.status === 0 ? 'warning' : 'success'">
          {{ row.status === 0 ? '外出中' : '已返回' }}
        </el-tag>
      </template>
    </el-table-column>
    <el-table-column label="操作" width="150" fixed="right">
      <template #default="{ row }">
        <el-button
          v-if="row.status === 0"
          type="success"
          size="small"
          @click="handleReturn(row)"
        >
          确认返回
        </el-button>
        <el-button type="danger" size="small" @click="handleDelete(row)">删除</el-button>
      </template>
    </el-table-column>
  </el-table>
</template>

<script setup>
import { ElMessage, ElMessageBox } from 'element-plus'
import { outingApi } from '../../api/elderly'

const props = defineProps({
  data: Array
})

const emit = defineEmits(['refresh'])

const handleReturn = (row) => {
  ElMessageBox.confirm('确认老人已返回？', '提示').then(async () => {
    await outingApi.returnOuting(row.id)
    ElMessage.success('已确认返回')
    emit('refresh')
  })
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确认删除该记录？', '提示', { type: 'warning' }).then(async () => {
    await outingApi.delete(row.id)
    ElMessage.success('删除成功')
    emit('refresh')
  })
}
</script>
