# 东软颐养中心管理系统

## 项目简介

东软颐养中心管理系统是一个为养老服务机构设计的综合管理平台，采用前后端分离架构。

## 技术栈

- **后端**: Spring Boot 3.2 + MyBatis-Plus + MySQL + JWT
- **前端**: Vue 3 + Element-Plus + Pinia + Axios

## 项目结构

```
neusoft-elderly-care/
├── backend/          # Spring Boot 后端
│   ├── src/main/java/com/neusoft/elderly/
│   │   ├── config/   # 配置类
│   │   ├── controller/  # 控制器
│   │   ├── entity/   # 实体类
│   │   ├── mapper/   # Mapper接口
│   │   └── service/  # 服务类
│   └── pom.xml
├── frontend/         # Vue3 前端
│   ├── src/
│   │   ├── api/      # API接口
│   │   ├── components/  # 组件
│   │   ├── router/   # 路由
│   │   ├── stores/   # Pinia状态
│   │   └── views/    # 页面
│   └── package.json
└── database/         # 数据库脚本
    └── elderly_care.sql
```

## 功能模块

1. **用户管理** - 注册、登录
2. **客户管理** - 老人信息管理、入住/退住登记
3. **床位管理** - 房间、床位设置
4. **外出登记** - 老人外出记录管理
5. **护理管理** - 护理级别、护理内容、护理记录
6. **膳食管理** - 膳食日历、个性化膳食计划
7. **服务关注** - 服务项目管理
8. **统计报表** - 首页数据概览

## 快速启动

### 1. 数据库
```bash
mysql -u root -p < database/elderly_care.sql
```

### 2. 后端
```bash
cd backend
mvn clean install
mvn spring-boot:run
```

### 3. 前端
```bash
cd frontend
npm install
npm run dev
```

## 默认账号

- 手机号: 13800138000
- 密码: 123456

## 开发团队

东软教育 - 颐养中心项目组
