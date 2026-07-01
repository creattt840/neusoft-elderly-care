# 床位管理 API

**Base URL**：`/api/bed`

**需要认证**：是（所有接口）

---

## 1. 床位列表（全量）

**GET** `/api/bed/list`

### 响应 data：BedVO[]

**BedVO 字段**

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 床位 ID |
| roomId | Long | 所属房间 ID |
| bedNo | String | 床位号 |
| status | Integer | 0-空闲，1-已入住 |
| elderlyId | Long | 入住老人 ID |
| roomNo | String | 房间号 |
| roomStatus | Integer | 房间状态 |
| elderlyName | String | 入住老人姓名 |
| elderlyGender | Integer | 老人性别 |
| elderlyAge | Integer | 老人年龄 |
| elderlyEmergencyContact | String | 紧急联系人 |
| elderlyEmergencyPhone | String | 紧急电话 |
| checkInDate | String | 入住日期 |

---

## 2. 可用床位列表

**GET** `/api/bed/available`

返回所有空闲且所属房间非维修中的床位。

### 响应 data：BedVO[]

---

## 3. 按房间查询床位

**GET** `/api/bed/room/{roomId}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| roomId | Long | 房间 ID |

### 响应 data：BedVO[]

---

## 4. 分页查询床位

**GET** `/api/bed/page`

### 查询参数

| 参数 | 类型 | 必填 | 默认值 |
|------|------|------|--------|
| pageNum | Integer | 否 | 1 |
| pageSize | Integer | 否 | 10 |

### 响应 data：PageResult\<BedVO\>

---

## 5. 新增床位

**POST** `/api/bed`

### 请求体：Bed

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| roomId | Long | 是 | 所属房间 ID |
| bedNo | String | 是 | 床位号 |
| status | Integer | 否 | 状态，默认 0 |

### 请求示例

```json
{
  "roomId": 1,
  "bedNo": "A",
  "status": 0
}
```

### 响应 data：Boolean

---

## 6. 更新床位

**PUT** `/api/bed`

### 请求体：Bed（需含 id）

### 响应 data：Boolean

---

## 7. 删除床位

**DELETE** `/api/bed/{id}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| id | Long | 床位 ID |

### 响应 data：Boolean
