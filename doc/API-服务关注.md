# 服务关注 API

**Base URL**：`/api/service`

**需要认证**：是（所有接口）

本模块包含 **服务项目** 与 **老人订阅** 两组接口。

---

## 服务项目

### 1. 服务列表

**GET** `/api/service/list`

### 查询参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| type | Integer | 否 | 服务类型：1-基础，2-增值，3-医疗 |

### 响应 data：ServiceInfoVO[]

**ServiceInfoVO 字段**

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 服务 ID |
| serviceName | String | 服务名称 |
| serviceType | Integer | 1-基础服务，2-增值服务，3-医疗服务 |
| description | String | 服务描述 |
| status | Integer | 1-启用，0-停用 |
| createTime | String | 创建时间 |

---

### 2. 新增服务

**POST** `/api/service`

### 请求体：ServiceInfo

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| serviceName | String | 是 | 服务名称 |
| serviceType | Integer | 是 | 服务类型 |
| description | String | 否 | 描述 |
| status | Integer | 否 | 状态，默认 1 |

### 请求示例

```json
{
  "serviceName": "健康监测",
  "serviceType": 1,
  "description": "每日血压、血糖监测",
  "status": 1
}
```

### 响应 data：Boolean

---

### 3. 更新服务

**PUT** `/api/service`

### 请求体：ServiceInfo（需含 id）

### 响应 data：Boolean

---

### 4. 删除服务

**DELETE** `/api/service/{id}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| id | Long | 服务 ID |

### 响应 data：Boolean

---

## 老人订阅

### 5. 查询老人订阅列表

**GET** `/api/service/subscription/{elderlyId}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| elderlyId | Long | 老人 ID |

### 响应 data：ServiceSubscriptionVO[]

**ServiceSubscriptionVO 字段**

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 订阅 ID |
| elderlyId | Long | 老人 ID |
| elderlyName | String | 老人姓名 |
| serviceId | Long | 服务 ID |
| serviceName | String | 服务名称 |
| startDate | String | 开始日期 |
| endDate | String | 结束日期 |
| status | Integer | 订阅状态 |
| remark | String | 备注 |
| createTime | String | 创建时间 |

---

### 6. 新增订阅

**POST** `/api/service/subscription`

### 请求体：ServiceSubscription

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| elderlyId | Long | 是 | 老人 ID |
| serviceId | Long | 是 | 服务 ID |
| startDate | String | 否 | 开始日期 |
| endDate | String | 否 | 结束日期 |
| status | Integer | 否 | 状态 |
| remark | String | 否 | 备注 |

### 请求示例

```json
{
  "elderlyId": 1,
  "serviceId": 2,
  "startDate": "2026-06-01",
  "endDate": "2026-12-31",
  "status": 1,
  "remark": "年度订阅"
}
```

### 响应 data：Boolean

---

### 7. 更新订阅

**PUT** `/api/service/subscription`

### 请求体：ServiceSubscription（需含 id）

### 响应 data：Boolean

---

### 8. 取消订阅（删除）

**DELETE** `/api/service/subscription/{id}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| id | Long | 订阅 ID |

### 响应 data：Boolean
