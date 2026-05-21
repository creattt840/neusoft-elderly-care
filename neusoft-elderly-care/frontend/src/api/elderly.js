import api from './index'

export const authApi = {
  login: (data) => api.post('/auth/login', data),
  register: (data) => api.post('/auth/register', data)
}

export const elderlyApi = {
  list: (params) => api.get('/elderly/page', { params }),
  getById: (id) => api.get(`/elderly/${id}`),
  save: (data) => api.post('/elderly', data),
  update: (data) => api.put('/elderly', data),
  delete: (id) => api.delete(`/elderly/${id}`),
  checkIn: (data, bedId) => api.post('/elderly/check-in', data, { params: { bedId } }),
  checkOut: (id) => api.post(`/elderly/check-out/${id}`),
  statistics: () => api.get('/elderly/statistics')
}

export const roomApi = {
  list: () => api.get('/room/list'),
  page: (params) => api.get('/room/page', { params }),
  save: (data) => api.post('/room', data),
  update: (data) => api.put('/room', data),
  delete: (id) => api.delete(`/room/${id}`)
}

export const bedApi = {
  list: () => api.get('/bed/list'),
  available: () => api.get('/bed/available'),
  getByRoomId: (roomId) => api.get(`/bed/room/${roomId}`),
  save: (data) => api.post('/bed', data),
  update: (data) => api.put('/bed', data),
  delete: (id) => api.delete(`/bed/${id}`)
}

export const outingApi = {
  list: () => api.get('/outing/list'),
  active: () => api.get('/outing/active'),
  page: (params) => api.get('/outing/page', { params }),
  save: (data) => api.post('/outing', data),
  update: (data) => api.put('/outing', data),
  returnOuting: (id) => api.post(`/outing/return/${id}`),
  delete: (id) => api.delete(`/outing/${id}`)
}

export const careApi = {
  // 护理级别
  levelList: () => api.get('/care/level/list'),
  saveLevel: (data) => api.post('/care/level', data),
  updateLevel: (data) => api.put('/care/level', data),
  deleteLevel: (id) => api.delete(`/care/level/${id}`),
  // 护理内容
  itemList: (careLevelId) => api.get('/care/item/list', { params: { careLevelId } }),
  saveItem: (data) => api.post('/care/item', data),
  updateItem: (data) => api.put('/care/item', data),
  deleteItem: (id) => api.delete(`/care/item/${id}`)
}

export const careRecordApi = {
  list: (elderlyId) => api.get('/care-record/list', { params: { elderlyId } }),
  page: (params) => api.get('/care-record/page', { params }),
  save: (data) => api.post('/care-record', data),
  update: (data) => api.put('/care-record', data),
  delete: (id) => api.delete(`/care-record/${id}`)
}

export const mealApi = {
  // 膳食日历
  calendarList: (date) => api.get('/meal/calendar/list', { params: { date } }),
  calendarWeek: (startDate, endDate) => api.get('/meal/calendar/week', { params: { startDate, endDate } }),
  saveCalendar: (data) => api.post('/meal/calendar', data),
  updateCalendar: (data) => api.put('/meal/calendar', data),
  deleteCalendar: (id) => api.delete(`/meal/calendar/${id}`),
  // 膳食计划
  planByElderly: (elderlyId) => api.get(`/meal/plan/${elderlyId}`),
  savePlan: (data) => api.post('/meal/plan', data),
  updatePlan: (data) => api.put('/meal/plan', data)
}

export const serviceApi = {
  list: (type) => api.get('/service/list', { params: { type } }),
  save: (data) => api.post('/service', data),
  update: (data) => api.put('/service', data),
  delete: (id) => api.delete(`/service/${id}`),
  subscription: (elderlyId) => api.get(`/service/subscription/${elderlyId}`),
  subscribe: (data) => api.post('/service/subscription', data),
  updateSubscription: (data) => api.put('/service/subscription', data),
  cancelSubscription: (id) => api.delete(`/service/subscription/${id}`)
}

export const statisticsApi = {
  dashboard: () => api.get('/statistics/dashboard')
}
