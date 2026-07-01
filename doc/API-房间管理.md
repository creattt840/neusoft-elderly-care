# 房间管理 API

**Base URL**：`/api/room`

**需要认证**：是（所有接口）

---

## 1. 房间列表（全量）

**GET** `/api/room/list`

### 响应 data：RoomVO[]

**RoomVO 字段**

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 房间 ID |
| roomNo | String | 房间号 |
| roomType | Integer | 1-单人间，2-双人间，3-多人间 |
| floor | Integer | 楼层 |
| capacity | Integer | 容纳床位数 |
| status | Integer | 1-可用，2-维修中 |
| remark | String | 备注 |
| createTime | String | 创建时间 |

---

## 2. 分页查询房间

**GET** `/api/room/page`

### 查询参数

| 参数 | 类型 | 必填 | 默认值 |
|------|------|------|--------|
| pageNum | Integer | 否 | 1 |
| pageSize | Integer | 否 | 10 |

### 响应 data：PageResult\<RoomVO\>

---

## 3. 获取房间详情

**GET** `/api/room/{id}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| id | Long | 房间 ID |

### 响应 data：RoomVO

---

## 4. 新增房间

**POST** `/api/room`

### 请求体：Room

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| roomNo | String | 是 | 房间号 |
| roomType | Integer | 是 | 房间类型 |
| floor | Integer | 否 | 楼层 |
| capacity | Integer | 否 | 床位数 |
| status | Integer | 否 | 状态，默认 1 |
| remark | String | 否 | 备注 |

### 请求示例

```json
{
  "roomNo": "A101",
  "roomType": 2,
  "floor": 1,
  "capacity": 2,
  "status": 1,
  "remark": "南向双人间"
}
```

### 响应 data：Boolean

---

## 5. 更新房间

**PUT** `/api/room`

### 请求体：Room（需含 id）

### 响应 data：Boolean

---

## 6. 删除房间

**DELETE** `/api/room/{id}`

### 路径参数

| 参数 | 类型 | 说明 |
|------|------|------|
| id | Long | 房间 ID |

### 响应 data：Boolean
