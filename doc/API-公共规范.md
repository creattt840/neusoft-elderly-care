# API 公共规范

## 统一响应结构

所有接口返回 `Result<T>` 包装：

```json
{
  "code": 200,
  "message": "success",
  "data": { }
}
```

| 字段 | 类型 | 说明 |
|------|------|------|
| code | Integer | 状态码，200 表示成功 |
| message | String | 提示信息 |
| data | T | 业务数据，无数据时为 `null` |

## 状态码说明

| code | HTTP Status | 说明 |
|------|-------------|------|
| 200 | 200 | 请求成功 |
| 400 | 200 | 参数校验失败或业务规则错误 |
| 401 | 401 | 未登录或 Token 已过期 |
| 500 | 200 | 系统内部错误 |

> 注意：业务错误（400/500）通常 HTTP 状态码仍为 200，需根据响应体 `code` 判断；认证失败时 HTTP 状态码为 401。

## 认证机制

- **方案**：Redis Token + 拦截器（`AuthInterceptor`）
- **Token 存储 Key**：`elderly:login:token:{token}` → `userId`
- **过期时间**：24 小时（配置项 `auth.token-expire-hours`）
- **请求头**：`Authorization: Bearer {token}`

### 免认证接口

| 方法 | 路径 |
|------|------|
| POST | `/api/auth/login` |
| POST | `/api/auth/register` |

## 分页结构

分页接口返回 `PageResult<T>`：

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "total": 100,
    "list": [],
    "pageNum": 1,
    "pageSize": 10,
    "pages": 10
  }
}
```

| 字段 | 类型 | 说明 |
|------|------|------|
| total | Long | 总记录数 |
| list | Array | 当前页数据列表 |
| pageNum | Long | 当前页码（从 1 开始） |
| pageSize | Long | 每页条数 |
| pages | Long | 总页数 |

### 通用分页参数

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| pageNum | Integer | 否 | 1 | 页码 |
| pageSize | Integer | 否 | 10 | 每页条数 |

## 常用枚举值

### 性别 gender

| 值 | 说明 |
|----|------|
| 1 | 男 |
| 2 | 女 |

### 老人状态 elderly.status

| 值 | 说明 |
|----|------|
| 1 | 在住 |
| 0 | 退住 |

### 房间类型 roomType

| 值 | 说明 |
|----|------|
| 1 | 单人间 |
| 2 | 双人间 |
| 3 | 多人间 |

### 房间状态 room.status

| 值 | 说明 |
|----|------|
| 1 | 可用 |
| 2 | 维修中 |

### 床位状态 bed.status

| 值 | 说明 |
|----|------|
| 0 | 空闲 |
| 1 | 已入住 |

### 外出类型 outingType

| 值 | 说明 |
|----|------|
| 1 | 临时外出 |
| 2 | 长期外出 |
| 3 | 外出就医 |

### 外出状态 outing.status

| 值 | 说明 |
|----|------|
| 0 | 外出中 |
| 1 | 已返回 |

### 餐次 mealType

| 值 | 说明 |
|----|------|
| 1 | 早餐 |
| 2 | 午餐 |
| 3 | 晚餐 |

### 护理记录状态 careRecord.status

| 值 | 说明 |
|----|------|
| 0 | 待执行 |
| 1 | 已执行 |
| 2 | 跳过 |

### 服务类型 serviceType

| 值 | 说明 |
|----|------|
| 1 | 基础服务 |
| 2 | 增值服务 |
| 3 | 医疗服务 |

### 服务状态 service.status

| 值 | 说明 |
|----|------|
| 1 | 启用 |
| 0 | 停用 |

## 错误响应示例

### 参数校验失败（400）

```json
{
  "code": 400,
  "message": "phone: 手机号不能为空",
  "data": null
}
```

### 未登录（401）

```json
{
  "code": 401,
  "message": "未登录，请先登录",
  "data": null
}
```

### Token 过期（401）

```json
{
  "code": 401,
  "message": "登录已过期，请重新登录",
  "data": null
}
```

### 业务异常（400）

```json
{
  "code": 400,
  "message": "床位已被占用",
  "data": null
}
```
