# 统计模块 API

**Base URL**：`/api/statistics`

**需要认证**：是（所有接口）

本模块为首页仪表盘及数据概览提供统计接口。

---

## 1. 首页仪表盘统计

**GET** `/api/statistics/dashboard`

### 响应 data

| 字段 | 类型 | 说明 |
|------|------|------|
| activeElderlyCount | Long | 在住老人数 |
| checkedOutElderlyCount | Long | 退住老人数 |
| totalBedCount | Long | 床位总数 |
| availableBedCount | Long | 空闲床位数 |
| occupiedBedCount | Long | 已入住床位数 |

### 响应示例

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "activeElderlyCount": 45,
    "checkedOutElderlyCount": 12,
    "totalBedCount": 60,
    "availableBedCount": 15,
    "occupiedBedCount": 45
  }
}
```

---

## 2. 入住记录

**GET** `/api/statistics/check-in-records`

### 查询参数

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| range | String | 否 | today | 时间范围：`today`-今日，`week`-近7天，`month`-近30天 |

### 响应 data：ResidenceRecordVO[]

**ResidenceRecordVO 字段**

| 字段 | 类型 | 说明 |
|------|------|------|
| roomNo | String | 房间号 |
| bedNo | String | 床位号 |
| elderlyName | String | 老人姓名 |
| age | Integer | 年龄 |
| recordDate | String | 入住日期 |
| recordTime | String | 入住时间 |

### 响应示例

```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "roomNo": "A101",
      "bedNo": "A",
      "elderlyName": "王大爷",
      "age": 78,
      "recordDate": "2026-06-03",
      "recordTime": "2026-06-03 10:30:00"
    }
  ]
}
```

---

## 3. 退住记录

**GET** `/api/statistics/check-out-records`

### 查询参数

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| range | String | 否 | today | 时间范围：`today` / `week` / `month` |

### 响应 data：ResidenceRecordVO[]

字段含义同入住记录。

---

## 4. 最近外出中记录

**GET** `/api/statistics/recent-active-outings`

### 查询参数

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| limit | Integer | 否 | 10 | 返回条数上限 |

### 响应 data：OutingVO[]

返回当前外出中（`status=0`）的记录，按时间倒序。

**OutingVO 主要字段**

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 记录 ID |
| elderlyName | String | 老人姓名 |
| outingType | Integer | 外出类型 |
| startTime | String | 外出时间 |
| expectedReturnTime | String | 预计返回 |
| destination | String | 目的地 |
| status | Integer | 0-外出中 |

### 响应示例

```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": 5,
      "elderlyId": 3,
      "elderlyName": "李奶奶",
      "elderlyPhone": "13800001234",
      "outingType": 3,
      "startTime": "2026-06-03 08:00:00",
      "expectedReturnTime": "2026-06-03 12:00:00",
      "actualReturnTime": null,
      "destination": "市人民医院",
      "reason": "复查",
      "status": 0,
      "createTime": "2026-06-03 07:50:00"
    }
  ]
}
```
