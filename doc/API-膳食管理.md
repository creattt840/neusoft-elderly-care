# 膳食管理 API

**Base URL**：`/api/meal`

**需要认证**：是（所有接口）

本模块包含 **膳食日历** 与 **膳食计划** 两组接口。

---

## 膳食日历

### 1. 按日期查询膳食

**GET** `/api/meal/calendar/list`

### 查询参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| date | String | 是 | 日期，格式 `yyyy-MM-dd` |

### 响应 data：MealCalendarVO[]

**MealCalendarVO 字段**

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 记录 ID |
| mealDate | String | 日期 |
| mealType | Integer | 1-早餐，2-午餐，3-晚餐 |
| menuContent | String | 菜单内容 |
| nutritionInfo | String | 营养信息 |
| remark | String | 备注 |
| createTime | String | 创建时间 |

---

### 2. 按日期范围查询膳食

**GET** `/api/meal/calendar/week`

### 查询参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| startDate | String | 是 | 开始日期，格式 `yyyy-MM-dd` |
| endDate | String | 是 | 结束日期，格式 `yyyy-MM-dd` |

### 响应 data：MealCalendarVO[]

> 前端膳食日历页使用该接口加载整月/整周数据。

---

### 3. 新增膳食日历

**POST** `/api/meal/calendar`

### 请求体：MealCalendar

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| mealDate | String | 是 | 日期 |
| mealType | Integer | 是 | 餐次 |
| menuContent | String | 是 | 菜单内容 |
| nutritionInfo | String | 否 | 营养信息 |
| remark | String | 否 | 备注 |

### 请求示例

```json
{
  "mealDate": "2026-06-03",
  "mealType": 1,
  "menuContent": "小米粥、鸡蛋、包子",
  "nutritionInfo": "低盐低脂",
  "remark": ""
}
```

### 响应 data：Boolean

---

### 4. 更新膳食日历

**PUT** `/api/meal/calendar`

### 请求体：MealCalendar（需含 id）

### 响应 data：Boolean

---

### 5. 删除膳食日历

**DELETE** `/api/meal/calendar/{id}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| id | Long | 记录 ID |

### 响应 data：Boolean

---

## 膳食计划

### 6. 分页查询膳食计划

**GET** `/api/meal/plan/page`

### 查询参数

| 参数 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| pageNum | Integer | 否 | 1 | 页码 |
| pageSize | Integer | 否 | 10 | 每页条数 |
| keyword | String | 否 | - | 按老人姓名搜索 |

### 响应 data：PageResult\<MealPlanVO\>

**MealPlanVO 字段**

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 计划 ID |
| elderlyId | Long | 老人 ID |
| elderlyName | String | 老人姓名 |
| dietaryRestrictions | String | 饮食禁忌 |
| specialRequirements | String | 特殊需求 |
| preference | String | 饮食偏好 |
| createTime | String | 创建时间 |
| updateTime | String | 更新时间 |

---

### 7. 已分配膳食计划的老人 ID 列表

**GET** `/api/meal/plan/assigned-elderly-ids`

用于新增计划时排除已有计划的老人。

### 响应 data：Long[]

### 响应示例

```json
{
  "code": 200,
  "message": "success",
  "data": [1, 3, 5]
}
```

---

### 8. 按老人 ID 查询膳食计划

**GET** `/api/meal/plan/{elderlyId}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| elderlyId | Long | 老人 ID |

### 响应 data：MealPlanVO

---

### 9. 新增膳食计划

**POST** `/api/meal/plan`

### 请求体：MealPlan

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| elderlyId | Long | 是 | 老人 ID |
| dietaryRestrictions | String | 否 | 饮食禁忌 |
| specialRequirements | String | 否 | 特殊需求 |
| preference | String | 否 | 饮食偏好 |

### 请求示例

```json
{
  "elderlyId": 2,
  "dietaryRestrictions": "低盐、低糖",
  "specialRequirements": "需软食",
  "preference": "喜食清淡"
}
```

### 响应 data：Boolean

---

### 10. 更新膳食计划

**PUT** `/api/meal/plan`

### 请求体：MealPlan（需含 id）

### 响应 data：Boolean

---

### 11. 删除膳食计划

**DELETE** `/api/meal/plan/{id}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| id | Long | 计划 ID |

### 响应 data：Boolean
