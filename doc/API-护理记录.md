# 护理记录 API

**Base URL**：`/api/care-record`

**需要认证**：是（所有接口）

---

## 1. 护理记录列表

**GET** `/api/care-record/list`

### 查询参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| elderlyId | Long | 否 | 按老人 ID 筛选 |

### 响应 data：CareRecordVO[]

**CareRecordVO 字段**

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 记录 ID |
| elderlyId | Long | 老人 ID |
| elderlyName | String | 老人姓名 |
| careItemId | Long | 护理项目 ID |
| itemName | String | 护理项目名称 |
| levelName | String | 护理级别名称 |
| recordDate | String | 记录日期（yyyy-MM-dd） |
| recordTime | String | 执行时间 |
| status | Integer | 0-待执行，1-已执行，2-跳过 |
| remark | String | 备注 |
| createTime | String | 创建时间 |

---

## 2. 按日期查询护理记录

**GET** `/api/care-record/date`

### 查询参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| date | String | 是 | 日期，格式 `yyyy-MM-dd` |

### 响应 data：CareRecordVO[]

---

## 3. 分页查询护理记录

**GET** `/api/care-record/page`

### 查询参数

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| pageNum | Integer | 否 | 1 | 页码 |
| pageSize | Integer | 否 | 10 | 每页条数 |
| elderlyId | Long | 否 | - | 老人 ID |
| recordDate | String | 否 | - | 记录日期，格式 `yyyy-MM-dd` |

### 响应 data：PageResult\<CareRecordVO\>

---

## 4. 新增护理记录

**POST** `/api/care-record`

### 请求体：CareRecord

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| elderlyId | Long | 是 | 老人 ID |
| careItemId | Long | 是 | 护理项目 ID |
| recordDate | String | 是 | 记录日期，格式 `yyyy-MM-dd` |
| recordTime | String | 否 | 执行时间 |
| status | Integer | 否 | 状态，默认 0 |
| remark | String | 否 | 备注 |

### 请求示例

```json
{
  "elderlyId": 1,
  "careItemId": 3,
  "recordDate": "2026-06-03",
  "recordTime": "2026-06-03 08:30:00",
  "status": 1,
  "remark": "血压正常"
}
```

### 响应 data：Boolean

---

## 5. 更新护理记录

**PUT** `/api/care-record`

### 请求体：CareRecord（需含 id）

### 响应 data：Boolean

---

## 6. 删除护理记录

**DELETE** `/api/care-record/{id}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| id | Long | 记录 ID |

### 响应 data：Boolean
