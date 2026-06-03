<template>
  <div class="login-page">
    <div class="login-brand">
      <div class="brand-bg">
        <div class="orb orb-1"></div>
        <div class="orb orb-2"></div>
        <div class="orb orb-3"></div>
      </div>
      <div class="brand-content">
        <div class="brand-logo">
          <el-icon :size="36"><FirstAidKit /></el-icon>
        </div>
        <h1 class="brand-title">东软颐养中心</h1>
        <p class="brand-subtitle">智慧养老 · 温情照护 · 专业管理</p>
        <ul class="brand-features">
          <li><el-icon><CircleCheck /></el-icon> 老人档案与入住管理</li>
          <li><el-icon><CircleCheck /></el-icon> 护理记录与膳食计划</li>
          <li><el-icon><CircleCheck /></el-icon> 床位资源实时统计</li>
        </ul>
      </div>
    </div>

    <div class="login-panel">
      <div class="login-form-wrap">
        <div class="form-header">
          <h2>欢迎回来</h2>
          <p>请登录您的管理账号</p>
        </div>

        <el-form :model="form" :rules="rules" ref="formRef" class="login-form" @keyup.enter="handleLogin">
          <el-form-item prop="phone">
            <el-input
              v-model="form.phone"
              placeholder="请输入手机号"
              size="large"
              :prefix-icon="Iphone"
            />
          </el-form-item>
          <el-form-item prop="password">
            <el-input
              v-model="form.password"
              type="password"
              placeholder="请输入密码"
              size="large"
              show-password
              :prefix-icon="Lock"
            />
          </el-form-item>
          <el-button
            type="primary"
            class="login-btn"
            size="large"
            :loading="loading"
            @click="handleLogin"
          >
            登 录
          </el-button>
          <div class="form-footer">
            <span>还没有账号？</span>
            <el-button link type="primary" @click="$router.push('/register')">立即注册</el-button>
          </div>
        </el-form>
      </div>
      <p class="copyright">© 2026 东软颐养中心 · 管理系统 v1.0</p>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { FirstAidKit, CircleCheck, Iphone, Lock } from '@element-plus/icons-vue'
import { authApi } from '../../api/elderly'
import { useUserStore } from '../../stores/user'

const router = useRouter()
const userStore = useUserStore()
const formRef = ref()
const loading = ref(false)

const form = reactive({
  phone: '',
  password: ''
})

const rules = {
  phone: [{ required: true, message: '请输入手机号', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

const handleLogin = async () => {
  await formRef.value.validate()
  loading.value = true
  try {
    const res = await authApi.login(form)
    if (res.code === 200) {
      userStore.setToken(res.data.token)
      userStore.setUser(res.data.user)
      ElMessage.success('登录成功')
      router.push('/')
    } else {
      ElMessage.error(res.message)
    }
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-page {
  --teal-deep: #1a4f4a;
  --teal: #2d7a72;
  --teal-light: #3d9a90;
  --cream: #faf8f5;
  --warm: #e8a838;
  min-height: 100vh;
  display: flex;
  font-family: 'Noto Sans SC', sans-serif;
}

.login-brand {
  flex: 1;
  position: relative;
  background: linear-gradient(145deg, var(--teal-deep) 0%, var(--teal) 55%, #358f85 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  padding: 48px;
}

.brand-bg {
  position: absolute;
  inset: 0;
  pointer-events: none;
}

.orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(60px);
  opacity: 0.35;
}

.orb-1 {
  width: 320px;
  height: 320px;
  background: var(--warm);
  top: -80px;
  right: -60px;
  animation: float 8s ease-in-out infinite;
}

.orb-2 {
  width: 240px;
  height: 240px;
  background: #7ecfc6;
  bottom: 10%;
  left: -40px;
  animation: float 10s ease-in-out infinite reverse;
}

.orb-3 {
  width: 180px;
  height: 180px;
  background: #fff;
  bottom: 30%;
  right: 20%;
  opacity: 0.12;
  animation: float 12s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translate(0, 0); }
  50% { transform: translate(20px, -20px); }
}

.brand-content {
  position: relative;
  z-index: 1;
  max-width: 420px;
  color: #fff;
  animation: fadeUp 0.8s ease-out;
}

.brand-logo {
  width: 72px;
  height: 72px;
  border-radius: 20px;
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(8px);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 28px;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.brand-title {
  font-family: 'Noto Serif SC', serif;
  font-size: 36px;
  font-weight: 700;
  margin: 0 0 12px;
  letter-spacing: 2px;
}

.brand-subtitle {
  font-size: 16px;
  opacity: 0.85;
  margin: 0 0 40px;
  letter-spacing: 1px;
}

.brand-features {
  list-style: none;
  padding: 0;
  margin: 0;
}

.brand-features li {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 15px;
  opacity: 0.9;
  margin-bottom: 16px;
}

.brand-features .el-icon {
  color: var(--warm);
  font-size: 18px;
}

.login-panel {
  width: 480px;
  min-width: 400px;
  background: var(--cream);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 48px 40px;
  position: relative;
}

.login-form-wrap {
  width: 100%;
  max-width: 360px;
  animation: fadeUp 0.8s ease-out 0.15s both;
}

.form-header {
  margin-bottom: 36px;
}

.form-header h2 {
  font-family: 'Noto Serif SC', serif;
  font-size: 28px;
  font-weight: 600;
  color: #1a2e2c;
  margin: 0 0 8px;
}

.form-header p {
  color: #7a8a88;
  font-size: 14px;
  margin: 0;
}

.login-form :deep(.el-input__wrapper) {
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(26, 79, 74, 0.06);
  padding: 4px 12px;
  transition: box-shadow 0.2s;
}

.login-form :deep(.el-input__wrapper:hover),
.login-form :deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 2px rgba(45, 122, 114, 0.2);
}

.login-form :deep(.el-form-item) {
  margin-bottom: 22px;
}

.login-btn {
  width: 100%;
  height: 48px;
  border-radius: 12px;
  font-size: 16px;
  font-weight: 600;
  letter-spacing: 4px;
  margin-top: 8px;
  background: linear-gradient(135deg, var(--teal) 0%, var(--teal-light) 100%);
  border: none;
  transition: transform 0.2s, box-shadow 0.2s;
}

.login-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 8px 24px rgba(45, 122, 114, 0.35);
}

.form-footer {
  text-align: center;
  margin-top: 24px;
  font-size: 14px;
  color: #7a8a88;
}

.copyright {
  position: absolute;
  bottom: 24px;
  font-size: 12px;
  color: #b0bab8;
  margin: 0;
}

@keyframes fadeUp {
  from {
    opacity: 0;
    transform: translateY(24px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (max-width: 900px) {
  .login-page {
    flex-direction: column;
  }
  .login-brand {
    min-height: 280px;
    padding: 32px 24px;
  }
  .brand-title {
    font-size: 28px;
  }
  .brand-features {
    display: none;
  }
  .login-panel {
    width: 100%;
    min-width: unset;
    flex: 1;
    padding: 32px 24px 64px;
  }
}
</style>
