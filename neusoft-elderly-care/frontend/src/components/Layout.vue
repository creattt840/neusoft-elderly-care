<template>
  <el-container class="layout-container">
    <el-aside width="200px" class="aside">
      <div class="logo">
        <el-icon><FirstAidKit /></el-icon>
        <span>颐养中心</span>
      </div>
      <el-menu
        :default-active="$route.path"
        router
        background-color="#304156"
        text-color="#bfcbd9"
        active-text-color="#409EFF"
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

    <el-container>
      <el-header class="header">
        <div class="header-right">
          <el-dropdown @command="handleCommand">
            <span class="user-info">
              {{ userStore.user.realName }}
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
import { useRouter } from 'vue-router'
import { useUserStore } from '../stores/user'

const router = useRouter()
const userStore = useUserStore()

const handleCommand = (command) => {
  if (command === 'logout') {
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
  background-color: #304156;
}

.logo {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 18px;
  font-weight: bold;
  border-bottom: 1px solid #1f2d3d;
}

.logo .el-icon {
  font-size: 24px;
  margin-right: 10px;
}

.header {
  background-color: #fff;
  box-shadow: 0 1px 4px rgba(0,21,41,.08);
  display: flex;
  align-items: center;
  justify-content: flex-end;
}

.user-info {
  cursor: pointer;
  color: #606266;
}

.main {
  background-color: #f0f2f5;
  padding: 20px;
}
</style>
