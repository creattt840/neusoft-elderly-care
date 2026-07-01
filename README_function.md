# 东软颐养中心管理系统

<p align="center">
  <img src="https://img.shields.io/badge/Spring%20Boot-3.1.12-green" alt="Spring Boot">
  <img src="https://img.shields.io/badge/Vue-3.4-blue" alt="Vue">
  <img src="https://img.shields.io/badge/MySQL-8.0-orange" alt="MySQL">
  <img src="https://img.shields.io/badge/MyBatis--Plus-3.5.7-red" alt="MyBatis-Plus">
</p>

## 项目简介

东软颐养中心管理系统是一个为养老服务机构设计的综合管理平台，采用前后端分离架构，提供老人管理、床位管理、护理管理、膳食管理、服务管理等核心功能。

---

## 系统架构图

### 整体架构（交互链）

```mermaid
flowchart TB
    subgraph 客户端层
        A[Vue3 + Element-Plus 前端]
    end

    subgraph 网关层
        B[Nginx 反向代理]
    end

    subgraph 服务层
        C[Spring Boot 后端服务]
        D[Redis Token 认证]
        E[AuthInterceptor 拦截器]
    end

    subgraph 数据层
        F[MySQL 数据库]
        G[Redis 会话存储]
    end

    A <-->|HTTP/REST API| B
    B <-->|转发请求| C
    C <-->|Token 校验| D
    C -->|拦截 /api/**| E
    C <-->|JDBC/MyBatis-Plus| F
    C <-->|存储/校验 Token| G
```

---

## 技术栈架构

```mermaid
flowchart LR
    subgraph 前端技术栈
        direction TB
        Vue3[Vue 3.4]
        Element[Element-Plus]
        Pinia[Pinia 状态管理]
        Axios[Axios 请求]
        VueRouter[Vue Router]
    end

    subgraph 后端技术栈
        direction TB
        Boot[Spring Boot 3.1]
        Security[Spring Security]
        Redis[Redis Token]
        Interceptor[AuthInterceptor]
        MyBatis[MyBatis-Plus 3.5]
        Valid[Jakarta Validation]
    end

    subgraph 数据存储
        direction TB
        MySQL[MySQL 8.0]
        RedisDB[Redis 7.x]
        MyBatisORM[ORM 映射]
    end

    Vue3 --> Element
    Vue3 --> Pinia
    Vue3 --> VueRouter
    Vue3 --> Axios

    Boot --> Security
    Boot --> Redis
    Boot --> Interceptor
    Boot --> MyBatis
    Boot --> Valid

    MyBatis --> MyBatisORM
    MyBatisORM --> MySQL
    Redis --> RedisDB

    Axios -.->|HTTP API| Boot
```

---

## 功能架构（功能网）

```mermaid
mindmap
  root((东软颐养中心<br/>管理系统))
    用户认证
      用户注册
      用户登录
      Redis Token 会话
      退出登录
    客户管理
      老人信息管理
      入住登记
      退住登记
      外出登记
      床位分配
    房间管理
      房间管理
      床位管理
      床位状态
    护理模块
      护理级别定义
      护理内容配置
      护理记录
    膳食管理
      膳食日历
      膳食计划
      个性化定制
    服务管理
      服务项目
      服务订阅
    统计报表
      数据概览
      入住统计
```

---

## 数据库 ER 图（逻辑树）

```mermaid
erDiagram
    USER ||--o{ ELDERLY : manages
    ELDERLY ||--o{ CHECK_IN : has
    ELDERLY ||--o{ CHECK_OUT : has
    ELDERLY ||--o{ OUTING : has
    ELDERLY ||--o{ CARE_RECORD : receives
    ELDERLY ||--o{ MEAL_PLAN : has
    ELDERLY ||--o{ SERVICE_SUBSCRIPTION : subscribes

    ROOM ||--|{ BED : contains
    BED ||--o| ELDERLY : occupied_by
    CARE_LEVEL ||--o{ CARE_ITEM : contains
    CARE_ITEM ||--o{ CARE_RECORD : recorded_in
    MEAL_CALENDAR ||--o{ ELDERLY_MEAL : assigned_to

    USER {
        bigint id PK
        varchar phone UK
        varchar password
        varchar real_name
        int age
        tinyint gender
        tinyint status
    }

    ELDERLY {
        bigint id PK
        varchar name
        varchar phone
        tinyint gender
        int age
        varchar id_card UK
        text health_condition
        bigint care_level_id FK
        bigint bed_id FK
        tinyint status
    }

    ROOM {
        bigint id PK
        varchar room_no UK
        tinyint room_type
        int floor
        int capacity
        tinyint status
    }

    BED {
        bigint id PK
        bigint room_id FK
        varchar bed_no
        tinyint status
        bigint elderly_id FK
    }

    CHECK_IN {
        bigint id PK
        bigint elderly_id FK
        bigint bed_id FK
        date check_in_date
    }

    CHECK_OUT {
        bigint id PK
        bigint elderly_id FK
        bigint bed_id FK
        date check_out_date
        tinyint check_out_reason
    }

    OUTING {
        bigint id PK
        bigint elderly_id FK
        tinyint outing_type
        datetime start_time
        datetime expected_return_time
        datetime actual_return_time
        tinyint status
    }

    CARE_LEVEL {
        bigint id PK
        varchar level_name
        varchar level_code UK
        text description
    }

    CARE_ITEM {
        bigint id PK
        varchar item_name
        bigint care_level_id FK
        varchar frequency
    }

    CARE_RECORD {
        bigint id PK
        bigint elderly_id FK
        bigint care_item_id FK
        date record_date
        tinyint status
    }

    MEAL_CALENDAR {
        bigint id PK
        date meal_date
        tinyint meal_type
        text menu_content
    }

    MEAL_PLAN {
        bigint id PK
        bigint elderly_id FK
        varchar dietary_restrictions
        varchar preference
    }

    SERVICE {
        bigint id PK
        varchar service_name
        tinyint service_type
        tinyint status
    }

    SERVICE_SUBSCRIPTION {
        bigint id PK
        bigint elderly_id FK
        bigint service_id FK
        date start_date
        date end_date
        tinyint status
    }
```

---

## 核心业务流程

### 老人入住流程

```mermaid
sequenceDiagram
    actor User as 操作人员
    participant FE as 前端 Vue
    participant API as 后端 API
    participant Service as ElderlyService
    participant DB as MySQL

    User->>FE: 填写入住信息
    FE->>API: POST /api/elderly/check-in
    API->>Service: checkIn(elderly, bedId)

    Service->>DB: 查询床位是否存在
    DB-->>Service: 返回床位信息

    alt 床位不存在
        Service-->>API: 抛出异常：床位不存在
        API-->>FE: 返回 400 错误
        FE-->>User: 提示床位不存在
    else 床位已被占用
        Service-->>API: 抛出异常：床位已被占用
        API-->>FE: 返回 400 错误
        FE-->>User: 提示床位已被占用
    else 床位可用
        Service->>DB: 插入老人信息
        Service->>DB: 更新床位状态为已入住
        Service->>DB: 记录入住登记
        Service-->>API: 返回成功
        API-->>FE: 返回成功
        FE-->>User: 提示入住成功
    end
```

### 用户登录认证流程

```mermaid
sequenceDiagram
    actor User as 用户
    participant FE as 前端 Vue
    participant API as AuthController
    participant Token as TokenService
    participant Redis as Redis
    participant DB as MySQL

    User->>FE: 输入手机号/密码
    FE->>API: POST /api/auth/login

    API->>API: @Valid 参数校验
    alt 参数校验失败
        API-->>FE: 返回 400 校验错误
        FE-->>User: 提示参数错误
    end

    API->>DB: 查询用户信息
    DB-->>API: 返回用户数据

    alt 用户不存在或密码错误
        API-->>FE: 返回错误：手机号或密码错误
        FE-->>User: 提示登录失败
    else 账号已禁用
        API-->>FE: 返回错误：账号已禁用
        FE-->>User: 提示账号状态异常
    else 验证成功
        API->>Token: createToken(userId)
        Token->>Redis: SET elderly:login:token:{token} = userId (24h)
        Redis-->>Token: OK
        Token-->>API: 返回 Token
        API->>API: convertToVO(user) 脱敏处理
        API-->>FE: 返回 {token, user}
        FE->>FE: 存储 token 到 localStorage
        FE->>FE: 跳转首页
        FE-->>User: 登录成功
    end
```

### API 请求认证流程

```mermaid
sequenceDiagram
    participant FE as 前端 Axios
    participant Interceptor as AuthInterceptor
    participant Redis as Redis
    participant API as Controller

    FE->>Interceptor: 请求 /api/** (Authorization: Bearer token)
    Interceptor->>Redis: GET elderly:login:token:{token}
    alt Token 不存在或已过期
        Redis-->>Interceptor: null
        Interceptor-->>FE: 401 未登录或登录已过期
    else Token 有效
        Redis-->>Interceptor: userId
        Interceptor->>Interceptor: UserContext.setUserId(userId)
        Interceptor->>API: 放行请求
        API-->>FE: 返回业务数据
    end
```

---

## API 接口架构

```mermaid
flowchart TB
    subgraph 认证模块
        AUTH_REG[/api/auth/register\nPOST - 注册/]
        AUTH_LOGIN[/api/auth/login\nPOST - 登录/]
        AUTH_LOGOUT[/api/auth/logout\nPOST - 退出/]
    end

    subgraph 老人管理
        ELD_LIST[/api/elderly/page\nGET - 老人列表/]
        ELD_SAVE[/api/elderly\nPOST - 新增老人/]
        ELD_CHECKIN[/api/elderly/check-in\nPOST - 入住登记/]
        ELD_CHECKOUT[/api/elderly/check-out\nPOST - 退住登记/]
    end

    subgraph 房间床位
        ROOM_LIST[/api/room/list\nGET - 房间列表/]
        BED_LIST[/api/bed/list\nGET - 床位列表/]
        BED_AVAIL[/api/bed/available\nGET - 空闲床位/]
    end

    subgraph 护理管理
        CARE_LEVEL[/api/care/level/list\nGET - 护理级别/]
        CARE_ITEM[/api/care/item/list\nGET - 护理内容/]
        CARE_REC[/api/care-record/list\nGET - 护理记录/]
    end

    subgraph 膳食管理
        MEAL_CAL[/api/meal/calendar/list\nGET - 膳食日历/]
        MEAL_PLAN[/api/meal/plan/{id}\nGET - 膳食计划/]
    end

    subgraph 服务管理
        SVC_LIST[/api/service/list\nGET - 服务项目/]
        SVC_SUB[/api/service/subscription\nPOST - 服务订阅/]
    end

    subgraph 统计报表
        STAT_DASH[/api/statistics/dashboard\nGET - 数据概览/]
    end
```

---

## 项目结构

```mermaid
flowchart TB
    subgraph 项目根目录
        README[README.md]
        CODE_REVIEW[CODE_REVIEW_REPORT.md]
        DB[database/]
        BE[backend/]
        FE[frontend/]
    end

    subgraph 数据库脚本
        DB_SQL[elderly_care.sql]
    end

    subgraph 后端代码
        direction TB
        BE_JAVA[src/main/java/]
        BE_RES[src/main/resources/]
        BE_POM[pom.xml]
    end

    subgraph Java源代码
        direction TB
        CONTROLLER[controller/]
        SERVICE[service/]
        MAPPER[mapper/]
        ENTITY[entity/]
        DTO[dto/]
        VO[vo/]
        CONFIG[config/]
        COMMON[common/]
    end

    subgraph 前端代码
        direction TB
        FE_SRC[src/]
        FE_PKG[package.json]
        FE_VITE[vite.config.js]
    end

    subgraph 前端源码
        direction TB
        VIEWS[views/]
        COMPONENTS[components/]
        API[api/]
        STORES[stores/]
        ROUTER[router/]
    end

    DB --> DB_SQL
    BE --> BE_JAVA
    BE --> BE_RES
    BE --> BE_POM

    BE_JAVA --> CONTROLLER
    BE_JAVA --> SERVICE
    BE_JAVA --> MAPPER
    BE_JAVA --> ENTITY
    BE_JAVA --> DTO
    BE_JAVA --> VO
    BE_JAVA --> CONFIG
    BE_JAVA --> COMMON

    FE --> FE_SRC
    FE --> FE_PKG
    FE --> FE_VITE

    FE_SRC --> VIEWS
    FE_SRC --> COMPONENTS
    FE_SRC --> API
    FE_SRC --> STORES
    FE_SRC --> ROUTER
```

---

## 快速启动

### 1. 数据库
```bash
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS elderly_care DEFAULT CHARACTER SET utf8mb4;"
mysql -u root -p elderly_care < database/elderly_care.sql
```

### 2. Redis
```bash
docker run -d -p 6379:6379 --name redis redis
```

### 3. 后端
```bash
cd backend
mvn clean install
mvn spring-boot:run
```

### 4. 前端
```bash
cd frontend
npm install
npm run dev
```

---

## 默认账号

- **手机号**: 13800138000
- **密码**: 123456

---

## 功能清单

| 模块 | 功能 | 状态 |
|------|------|------|
| 用户认证 | 注册、登录、退出、Redis Token（24h） | ✅ |
| 老人管理 | 增删改查、入住/退住 | ✅ |
| 房间管理 | 房间、床位管理 | ✅ |
| 外出登记 | 外出登记、返回确认 | ✅ |
| 护理模块 | 级别、内容、记录 | ✅ |
| 膳食管理 | 日历、计划 | ✅ |
| 服务管理 | 项目、订阅 | ✅ |
| 统计报表 | 数据概览 | ✅ |

---

## 开发团队

东软教育 - 颐养中心项目组

---

## 许可证

MIT License
