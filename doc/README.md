# 东软颐养中心管理系统 — API 接口文档

> 版本：v1.0  
> 基础地址：`http://localhost:8080`  
> 数据格式：`application/json`  
> 时间格式：`yyyy-MM-dd HH:mm:ss`（日期字段为 `yyyy-MM-dd`）

## 文档索引

| 模块 | 说明 | 文档 |
|------|------|------|
| 公共规范 | 统一响应、认证、分页、错误码 | [API-公共规范.md](./API-公共规范.md) |
| 认证模块 | 注册、登录、退出 | [API-认证模块.md](./API-认证模块.md) |
| 老人管理 | 老人 CRUD、入住/退住、统计 | [API-老人管理.md](./API-老人管理.md) |
| 房间管理 | 房间 CRUD | [API-房间管理.md](./API-房间管理.md) |
| 床位管理 | 床位 CRUD、可用床位查询 | [API-床位管理.md](./API-床位管理.md) |
| 外出登记 | 外出 CRUD、确认返回 | [API-外出登记.md](./API-外出登记.md) |
| 护理管理 | 护理级别、护理内容 | [API-护理管理.md](./API-护理管理.md) |
| 护理记录 | 护理记录 CRUD | [API-护理记录.md](./API-护理记录.md) |
| 膳食管理 | 膳食日历、膳食计划 | [API-膳食管理.md](./API-膳食管理.md) |
| 服务关注 | 服务项目、老人订阅 | [API-服务关注.md](./API-服务关注.md) |
| 统计模块 | 首页仪表盘、入住退住记录 | [API-统计模块.md](./API-统计模块.md) |

## 快速开始

### 1. 登录获取 Token

```http
POST /api/auth/login
Content-Type: application/json

{
  "phone": "13800138000",
  "password": "123456"
}
```

响应 `data.token` 即为访问令牌，默认有效期 **24 小时**（Redis 存储）。

### 2. 携带 Token 访问业务接口

除 `/api/auth/login`、`/api/auth/register` 外，所有 `/api/**` 接口均需在请求头携带：

```http
Authorization: Bearer {token}
```

### 3. 默认测试账号

| 字段 | 值 |
|------|-----|
| 手机号 | 13800138000 |
| 密码 | 123456 |

## 接口总览

```
/api/auth          认证（3）
/api/elderly       老人管理（9）
/api/room          房间管理（6）
/api/bed           床位管理（7）
/api/outing        外出登记（8）
/api/care          护理级别/内容（9）
/api/care-record   护理记录（6）
/api/meal          膳食日历/计划（11）
/api/service       服务/订阅（8）
/api/statistics    统计（4）
```

共计 **71** 个接口。
