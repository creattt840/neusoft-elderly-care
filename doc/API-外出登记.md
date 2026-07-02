# 外出登记 API

**Base URL**：`/api/outing`

**需要认证**：是（所有接口）

---

## 1. 外出记录列表（全量）

**GET** `/api/outing/list`

### 响应 data：OutingVO[]

**OutingVO 字段**

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 记录 ID |
| elderlyId | Long | 老人 ID |
| elderlyName | String | 老人姓名 |
| elderlyPhone | String | 老人电话 |
| outingType | Integer | 1-临时外出，2-长期外出，3-外出就医 |
| startTime | String | 外出开始时间 |
| expectedReturnTime | String | 预计返回时间 |
| actualReturnTime | String | 实际返回时间 |
| accompanier | String | 陪同人 |
| accompanierPhone | String | 陪同人电话 |
| destination | String | 目的地 |
| reason | String | 外出原因 |
| status | Integer | 0-外出中，1-已返回 |
| createTime | String | 创建时间 |

---

## 2. 外出中记录列表

**GET** `/api/outing/active`

返回 `status=0` 的外出记录。

### 响应 data：OutingVO[]

---

## 3. 分页查询外出记录

**GET** `/api/outing/page`

### 查询参数

| 参数 | 类型 | 必填 | 默认值 |
|------|------|------|--------|
| pageNum | Integer | 否 | 1 |
| pageSize | Integer | 否 | 10 |

### 响应 data：PageResult\<OutingVO\>

---

## 4. 获取外出记录详情

**GET** `/api/outing/{id}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| id | Long | 记录 ID |

### 响应 data：OutingVO

---

## 5. 登记外出

**POST** `/api/outing`

### 请求体：Outing

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| elderlyId | Long | 是 | 老人 ID |
| outingType | Integer | 是 | 外出类型 |
| startTime | String | 是 | 开始时间 |
| expectedReturnTime | String | 否 | 预计返回时间 |
| accompanier | String | 否 | 陪同人 |
| accompanierPhone | String | 否 | 陪同人电话 |
| destination | String | 否 | 目的地 |
| reason | String | 否 | 外出原因 |

### 请求示例

```json
{
  "elderlyId": 1,
  "outingType": 1,
  "startTime": "2026-06-03 09:00:00",
  "expectedReturnTime": "2026-06-03 17:00:00",
  "accompanier": "李四",
  "accompanierPhone": "13900001111",
  "destination": "市中心医院",
  "reason": "定期体检"
}
```

### 响应 data：Boolean

> 新建记录默认 `status=0`（外出中）。

---

## 6. 更新外出记录

**PUT** `/api/outing`

### 请求体：Outing（需含 id）

### 响应 data：Boolean

---

## 7. 确认返回

**POST** `/api/outing/return/{id}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| id | Long | 外出记录 ID |

### 响应 data：Boolean

> 将记录状态更新为已返回（`status=1`），并记录实际返回时间。

---

## 8. 删除外出记录

**DELETE** `/api/outing/{id}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| id | Long | 记录 ID |

### 响应 data：Boolean
