# 颐养中心管理系统

[![GitHub](https://img.shields.io/badge/GitHub-neusoft--elderly--care-blue)](https://github.com/creattt840/neusoft-elderly-care)

## 项目简介

东软颐养中心管理系统是一个面向养老服务机构的综合管理平台，采用前后端分离架构，覆盖老人档案、床位资源、护理记录、膳食计划、外出登记与数据统计等核心业务。

## 技术栈

| 层级 | 技术 |
|------|------|
| 后端 | Spring Boot 3.1、MyBatis-Plus、MySQL 8、Redis |
| 前端 | Vue 3、Element Plus、Pinia、Axios、Vite |
| 认证 | Redis Token + Spring MVC 拦截器（24 小时过期） |

## 项目结构

```
nursing-management-system/
├── README.md
└── neusoft-elderly-care/
    ├── backend/              # Spring Boot 后端
    │   └── src/main/java/com/neusoft/elderly/
    │       ├── config/       # 配置（拦截器、MyBatis 等）
    │       ├── controller/   # REST 控制器
    │       ├── entity/       # 实体类
    │       ├── vo/           # 视图对象
    │       ├── service/      # 业务逻辑
    │       └── mapper/       # 数据访问
    ├── frontend/             # Vue 3 前端
    │   └── src/
    │       ├── api/          # 接口封装
    │       ├── components/   # 公共组件
    │       ├── router/       # 路由
    │       ├── stores/       # Pinia 状态
    │       ├── styles/       # 全局主题
    │       └── views/        # 页面
    ├── database/             # 数据库初始化脚本
    │   └── elderly_care.sql
    └── scripts/              # 辅助脚本
```

## 功能模块

| 模块 | 说明 |
|------|------|
| 用户认证 | 注册、登录、退出（Redis Token 会话） |
| 客户管理 | 老人信息 CRUD、入住/退住登记 |
| 房间床位 | 房间与床位资源管理 |
| 外出登记 | 外出记录、确认返回 |
| 护理管理 | 护理级别、护理内容、护理记录 |
| 膳食管理 | 膳食日历、个性化膳食计划 |
| 服务关注 | 服务项目与老人订阅 |
| 统计报表 | 首页仪表盘、入住/退住/外出统计 |

## 快速启动

### 环境要求

- JDK 17+
- Maven 3.8+
- Node.js 18+
- MySQL 8.0+
- Redis 6+

### 1. 初始化数据库

```bash
mysql -u root -p < neusoft-elderly-care/database/elderly_care.sql
```

### 2. 启动 Redis

```bash
# Docker（推荐）
docker run -d -p 6379:6379 --name redis redis
```

### 3. 启动后端

```bash
cd neusoft-elderly-care/backend
mvn clean install
mvn spring-boot:run
```

后端默认地址：`http://localhost:8080`

### 4. 启动前端

```bash
cd neusoft-elderly-care/frontend
npm install
npm run dev
```

前端默认地址：`http://localhost:3000`

## 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `MYSQL_HOST` | localhost | MySQL 主机 |
| `MYSQL_PORT` | 3306 | MySQL 端口 |
| `MYSQL_DB` | elderly_care | 数据库名 |
| `MYSQL_USER` | root | 数据库用户 |
| `MYSQL_PASSWORD` | 123456 | 数据库密码 |
| `REDIS_HOST` | localhost | Redis 主机 |
| `REDIS_PORT` | 6379 | Redis 端口 |
| `REDIS_PASSWORD` | （空） | Redis 密码 |
| `AUTH_TOKEN_EXPIRE_HOURS` | 24 | Token 过期时间（小时） |

## 认证说明

登录成功后，后端生成 UUID Token 并存入 Redis，前端在请求头携带：

```
Authorization: Bearer {token}
```

| 组件 | 说明 |
|------|------|
| `TokenService` | 创建 / 校验 / 删除 Redis 中的 Token |
| `AuthInterceptor` | 拦截 `/api/**`，排除 `/api/auth/login` 与 `/api/auth/register` |
| `UserContext` | 当前请求登录用户 ID（ThreadLocal） |

## API 概览

所有接口前缀为 `/api`，统一返回 `{ code, message, data }` 结构，分页数据使用 `PageResult`（字段：`total`、`list`、`pageNum`、`pageSize`、`pages`）。

| 模块 | 路径前缀 |
|------|----------|
| 认证 | `/api/auth` |
| 老人管理 | `/api/elderly` |
| 房间管理 | `/api/room` |
| 床位管理 | `/api/bed` |
| 外出登记 | `/api/outing` |
| 护理管理 | `/api/care` |
| 护理记录 | `/api/care-record` |
| 膳食管理 | `/api/meal` |
| 服务关注 | `/api/service` |
| 统计 | `/api/statistics` |

## 默认账号

| 字段 | 值 |
|------|-----|
| 手机号 | 13800138000 |
| 密码 | 123456 |

## 开发团队

东软教育 — 颐养中心项目组
