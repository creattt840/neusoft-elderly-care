<template>
  <el-container class="layout-container">
    <el-aside width="220px" class="aside">
      <div class="logo">
        <div class="logo-icon">
          <el-icon><FirstAidKit /></el-icon>
        </div>
        <div class="logo-text">
          <span class="logo-title">颐养中心</span>
          <span class="logo-sub">管理系统</span>
        </div>
      </div>
      <el-menu
        :default-active="$route.path"
        router
        class="side-menu"
        background-color="transparent"
        text-color="rgba(255,255,255,0.75)"
        active-text-color="#fff"
      >
        <el-menu-item index="/">
          <el-icon><HomeFilled /></el-icon>
          <span>首页概览</span>
        </el-menu-item>

        <el-sub-menu index="/elderly">
          <template #title>
            <el-icon><User /></el-icon>
            <span>客户管理</span>
          </template>
          <el-menu-item index="/elderly">老人列表</el-menu-item>
          <el-menu-item index="/room">房间管理</el-menu-item>
          <el-menu-item index="/bed">床位管理</el-menu-item>
        </el-sub-menu>

        <el-menu-item index="/outing">
          <el-icon><Position /></el-icon>
          <span>外出登记</span>
        </el-menu-item>

        <el-sub-menu index="/care">
          <template #title>
            <el-icon><FirstAidKit /></el-icon>
            <span>护理管理</span>
          </template>
          <el-menu-item index="/care/level">护理级别</el-menu-item>
          <el-menu-item index="/care/item">护理内容</el-menu-item>
          <el-menu-item index="/care/record">护理记录</el-menu-item>
        </el-sub-menu>

        <el-sub-menu index="/meal">
          <template #title>
            <el-icon><Food /></el-icon>
            <span>膳食管理</span>
          </template>
          <el-menu-item index="/meal/calendar">膳食日历</el-menu-item>
          <el-menu-item index="/meal/plan">膳食计划</el-menu-item>
        </el-sub-menu>

        <el-menu-item index="/service">
          <el-icon><Service /></el-icon>
          <span>服务关注</span>
        </el-menu-item>
      </el-menu>
    </el-aside>

    <el-container class="main-wrap">
      <el-header class="header">
        <div class="header-left">
          <span class="breadcrumb-hint">东软颐养中心</span>
        </div>
        <div class="header-right">
          <el-dropdown @command="handleCommand">
            <span class="user-info">
              <span class="user-avatar">{{ avatarText }}</span>
              <span class="user-name">{{ userStore.user.realName || '管理员' }}</span>
              <el-icon><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>
      <el-main class="main">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '../stores/user'
import { authApi } from '../api/elderly'

const router = useRouter()
const userStore = useUserStore()

const avatarText = computed(() => {
  const name = userStore.user.realName || '管'
  return name.charAt(0)
})

const handleCommand = async (command) => {
  if (command === 'logout') {
    try {
      await authApi.logout()
    } catch (e) {
      // ignore
    }
    userStore.logout()
    router.push('/login')
  }
}
</script>

<style scoped>
.layout-container {
  height: 100vh;
}

.aside {
  background: linear-gradient(180deg, #1a4f4a 0%, #1e5853 40%, #163d39 100%);
  display: flex;
  flex-direction: column;
  box-shadow: 4px 0 24px rgba(26, 79, 74, 0.15);
}

.logo {
  height: 72px;
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 0 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.logo-icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.12);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #f0c060;
  font-size: 22px;
}

.logo-text {
  display: flex;
  flex-direction: column;
}

.logo-title {
  color: #fff;
  font-family: 'Noto Serif SC', serif;
  font-size: 17px;
  font-weight: 600;
  letter-spacing: 1px;
  line-height: 1.3;
}

.logo-sub {
  color: rgba(255, 255, 255, 0.55);
  font-size: 11px;
  letter-spacing: 2px;
}

.side-menu {
  border-right: none;
  padding: 12px 10px;
  flex: 1;
  overflow-y: auto;
}

.side-menu :deep(.el-menu-item),
.side-menu :deep(.el-sub-menu__title) {
  border-radius: 10px;
  margin-bottom: 4px;
  height: 44px;
}

.side-menu :deep(.el-menu-item.is-active) {
  background: rgba(255, 255, 255, 0.15) !important;
  font-weight: 600;
}

.side-menu :deep(.el-menu-item:hover),
.side-menu :deep(.el-sub-menu__title:hover) {
  background: rgba(255, 255, 255, 0.08) !important;
}

.side-menu :deep(.el-sub-menu .el-menu-item) {
  padding-left: 52px !important;
  min-width: unset;
}

.main-wrap {
  background: var(--color-bg);
}

.header {
  height: 60px;
  background: #fff;
  border-bottom: 1px solid rgba(45, 122, 114, 0.08);
  box-shadow: 0 1px 8px rgba(26, 79, 74, 0.04);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
}

.breadcrumb-hint {
  font-size: 13px;
  color: var(--color-text-muted);
  letter-spacing: 0.5px;
}

.user-info {
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 10px;
  color: var(--color-text);
  font-size: 14px;
}

.user-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: linear-gradient(135deg, #2d7a72, #3d9a90);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: 600;
}

.user-name {
  font-weight: 500;
}

.main {
  background: var(--color-bg);
  padding: 24px;
  overflow-y: auto;
}
</style>
