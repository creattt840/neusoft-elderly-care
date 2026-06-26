import { ElMessage } from 'element-plus'

/**
 * 执行异步操作并统一处理成功/失败提示
 */
export async function runWithMessage(task, successMessage, onSuccess) {
  try {
    await task()
    if (successMessage) {
      ElMessage.success(successMessage)
    }
    onSuccess?.()
  } catch (error) {
    ElMessage.error(error.message || '操作失败')
  }
}
