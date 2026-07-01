# 认证模块 API

**Base URL**：`/api/auth`

> 登录、注册接口无需 Token；退出登录需要 Token。

---

## 1. 用户注册

**POST** `/api/auth/register`

### 请求体 UserRegisterDTO

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| phone | String | 是 | 手机号，格式 `1[3-9]xxxxxxxxx` |
| password | String | 是 | 密码，6-20 位 |
| realName | String | 是 | 真实姓名，最长 50 字符 |
| age | Integer | 否 | 年龄 |
| gender | Integer | 否 | 性别：1-男，2-女 |

### 请求示例

```json
{
  "phone": "13900139000",
  "password": "123456",
  "realName": "张三",
  "age": 30,
  "gender": 1
}
```

### 响应 data：UserVO

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 用户 ID |
| phone | String | 手机号 |
| realName | String | 真实姓名 |
| age | Integer | 年龄 |
| gender | Integer | 性别 |
| status | Integer | 账号状态 |
| lastLoginTime | String | 最后登录时间 |
| createTime | String | 创建时间 |
| updateTime | String | 更新时间 |

### 响应示例

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 2,
    "phone": "13900139000",
    "realName": "张三",
    "age": 30,
    "gender": 1,
    "status": 1,
    "lastLoginTime": null,
    "createTime": "2026-06-03 10:00:00",
    "updateTime": "2026-06-03 10:00:00"
  }
}
```

---

## 2. 用户登录

**POST** `/api/auth/login`

### 请求体 UserLoginDTO

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| phone | String | 是 | 手机号 |
| password | String | 是 | 密码 |

### 请求示例

```json
{
  "phone": "13800138000",
  "password": "123456"
}
```

### 响应 data

| 字段 | 类型 | 说明 |
|------|------|------|
| token | String | 访问令牌，24 小时有效 |
| user | UserVO | 用户信息（见上表） |

### 响应示例

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "token": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "user": {
      "id": 1,
      "phone": "13800138000",
      "realName": "管理员",
      "age": 35,
      "gender": 1,
      "status": 1,
      "lastLoginTime": "2026-06-03 09:30:00",
      "createTime": "2026-01-01 00:00:00",
      "updateTime": "2026-06-03 09:30:00"
    }
  }
}
```

---

## 3. 退出登录

**POST** `/api/auth/logout`

**需要认证**：是

### 请求头

```http
Authorization: Bearer {token}
```

### 请求体

无

### 响应示例

```json
{
  "code": 200,
  "message": "success",
  "data": null
}
```

> 退出后 Redis 中对应 Token 将被删除，后续请求需重新登录。
