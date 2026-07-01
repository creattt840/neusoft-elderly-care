# 老人管理 API

**Base URL**：`/api/elderly`

**需要认证**：是（所有接口）

---

## 1. 分页查询老人列表

**GET** `/api/elderly/page`

### 查询参数

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| pageNum | Integer | 否 | 1 | 页码 |
| pageSize | Integer | 否 | 10 | 每页条数 |
| name | String | 否 | - | 姓名模糊搜索 |
| status | Integer | 否 | - | 状态：1-在住，0-退住 |

### 响应 data：PageResult\<ElderlyVO\>

**ElderlyVO 字段**

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 老人 ID |
| name | String | 姓名 |
| phone | String | 手机号 |
| gender | Integer | 性别 |
| age | Integer | 年龄 |
| idCard | String | 身份证号 |
| address | String | 地址（兼容字段） |
| country | String | 国家 |
| province | String | 省份 |
| city | String | 城市 |
| addressDetail | String | 详细地址 |
| healthCondition | String | 健康状况 |
| allergyInfo | String | 过敏信息 |
| emergencyContact | String | 紧急联系人 |
| emergencyPhone | String | 紧急联系电话 |
| careLevelId | Long | 护理级别 ID |
| bedId | Long | 床位 ID |
| status | Integer | 状态 |
| checkInDate | String | 入住日期 |
| createTime | String | 创建时间 |
| updateTime | String | 更新时间 |
| bedNo | String | 床位号（展示） |
| roomNo | String | 房间号（展示） |

---

## 2. 老人数量统计

**GET** `/api/elderly/statistics`

### 响应 data

| 字段 | 类型 | 说明 |
|------|------|------|
| activeCount | Long | 在住老人数 |
| checkedOutCount | Long | 退住老人数 |

### 响应示例

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "activeCount": 45,
    "checkedOutCount": 12
  }
}
```

---

## 3. 获取老人详情

**GET** `/api/elderly/{id}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| id | Long | 老人 ID |

### 响应 data：ElderlyVO

---

## 4. 获取老人可分配床位（编辑时用）

**GET** `/api/elderly/{id}/available-beds`

返回该老人当前床位 + 所有空闲床位列表。

### 响应 data：BedVO[]

**BedVO 主要字段**

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 床位 ID |
| roomId | Long | 房间 ID |
| bedNo | String | 床位号 |
| status | Integer | 0-空闲，1-已入住 |
| roomNo | String | 房间号 |
| elderlyName | String | 入住老人姓名 |

---

## 5. 新增老人

**POST** `/api/elderly`

### 请求体：Elderly

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| name | String | 是 | 姓名 |
| phone | String | 否 | 手机号 |
| gender | Integer | 否 | 性别 |
| age | Integer | 否 | 年龄 |
| idCard | String | 否 | 身份证号 |
| country/province/city/addressDetail | String | 否 | 地址 |
| healthCondition | String | 否 | 健康状况 |
| allergyInfo | String | 否 | 过敏信息 |
| emergencyContact | String | 否 | 紧急联系人 |
| emergencyPhone | String | 否 | 紧急电话 |
| careLevelId | Long | 否 | 护理级别 ID |
| bedId | Long | 否 | 床位 ID |
| status | Integer | 否 | 状态 |

### 响应 data：Boolean

---

## 6. 更新老人

**PUT** `/api/elderly`

### 请求体：Elderly（需含 id）

### 响应 data：Boolean

> 业务逻辑包含床位变更校验，若目标床位已被占用将返回 400 错误。

---

## 7. 删除老人

**DELETE** `/api/elderly/{id}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| id | Long | 老人 ID |

### 响应 data：Boolean

---

## 8. 入住登记

**POST** `/api/elderly/check-in?bedId={bedId}`

### 查询参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| bedId | Long | 是 | 分配床位 ID |

### 请求体：Elderly

入住老人基本信息（同新增字段）。

### 响应 data：Boolean

### 业务规则

- 床位必须存在且空闲
- 成功后老人 `status=1`，床位 `status=1`，记录入住日期

### 错误示例

```json
{ "code": 400, "message": "床位已被占用", "data": null }
```

---

## 9. 退住登记

**POST** `/api/elderly/check-out/{id}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| id | Long | 老人 ID |

### 响应 data：Boolean

> 退住后释放床位，老人 `status=0`。
