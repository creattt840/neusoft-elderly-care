# 护理管理 API

**Base URL**：`/api/care`

**需要认证**：是（所有接口）

本模块包含 **护理级别** 与 **护理内容** 两组接口。

---

## 护理级别

### 1. 护理级别列表

**GET** `/api/care/level/list`

### 响应 data：CareLevelVO[]

**CareLevelVO 字段**

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 级别 ID |
| levelName | String | 级别名称 |
| levelCode | String | 级别编码 |
| description | String | 描述 |
| sortOrder | Integer | 排序 |
| createTime | String | 创建时间 |

---

### 2. 新增护理级别

**POST** `/api/care/level`

### 请求体：CareLevel

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| levelName | String | 是 | 级别名称 |
| levelCode | String | 否 | 级别编码 |
| description | String | 否 | 描述 |
| sortOrder | Integer | 否 | 排序 |

### 请求示例

```json
{
  "levelName": "一级护理",
  "levelCode": "L1",
  "description": "生活基本自理",
  "sortOrder": 1
}
```

### 响应 data：Boolean

---

### 3. 更新护理级别

**PUT** `/api/care/level`

### 请求体：CareLevel（需含 id）

### 响应 data：Boolean

---

### 4. 删除护理级别

**DELETE** `/api/care/level/{id}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| id | Long | 级别 ID |

### 响应 data：Boolean

---

## 护理内容

### 5. 分页查询护理内容

**GET** `/api/care/item/page`

### 查询参数

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| pageNum | Integer | 否 | 1 | 页码 |
| pageSize | Integer | 否 | 10 | 每页条数 |
| careLevelId | Long | 否 | - | 按护理级别筛选 |

### 响应 data：PageResult\<CareItemVO\>

**CareItemVO 字段**

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 内容 ID |
| itemName | String | 护理项目名称 |
| careLevelId | Long | 护理级别 ID |
| levelName | String | 护理级别名称 |
| frequency | String | 执行频率 |
| description | String | 描述 |
| sortOrder | Integer | 排序 |
| createTime | String | 创建时间 |

---

### 6. 护理内容列表

**GET** `/api/care/item/list`

### 查询参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| careLevelId | Long | 否 | 按护理级别筛选，不传则返回全部 |

### 响应 data：CareItemVO[]

---

### 7. 新增护理内容

**POST** `/api/care/item`

### 请求体：CareItem

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| itemName | String | 是 | 项目名称 |
| careLevelId | Long | 是 | 护理级别 ID |
| frequency | String | 否 | 执行频率，如「每日一次」 |
| description | String | 否 | 描述 |
| sortOrder | Integer | 否 | 排序 |

### 请求示例

```json
{
  "itemName": "测量血压",
  "careLevelId": 1,
  "frequency": "每日两次",
  "description": "早晚各测一次",
  "sortOrder": 1
}
```

### 响应 data：Boolean

---

### 8. 更新护理内容

**PUT** `/api/care/item`

### 请求体：CareItem（需含 id）

### 响应 data：Boolean

---

### 9. 删除护理内容

**DELETE** `/api/care/item/{id}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| id | Long | 内容 ID |

### 响应 data：Boolean
