import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '../stores/user'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/user/Login.vue')
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('../views/user/Register.vue')
  },
  {
    path: '/',
    name: 'Layout',
    component: () => import('../components/Layout.vue'),
    meta: { requiresAuth: true },
    children: [
      {
        path: '',
        name: 'Dashboard',
        component: () => import('../views/dashboard/Dashboard.vue')
      },
      {
        path: 'elderly',
        name: 'Elderly',
        component: () => import('../views/elderly/ElderlyList.vue')
      },
      {
        path: 'elderly/detail/:id',
        name: 'ElderlyDetail',
        component: () => import('../views/elderly/ElderlyDetail.vue')
      },
      {
        path: 'room',
        name: 'Room',
        component: () => import('../views/room/RoomList.vue')
      },
      {
        path: 'bed',
        name: 'Bed',
        component: () => import('../views/bed/BedList.vue')
      },
      {
        path: 'outing',
        name: 'Outing',
        component: () => import('../views/outing/OutingList.vue')
      },
      {
        path: 'care/level',
        name: 'CareLevel',
        component: () => import('../views/care/CareLevel.vue')
      },
      {
        path: 'care/item',
        name: 'CareItem',
        component: () => import('../views/care/CareItem.vue')
      },
      {
        path: 'care/record',
        name: 'CareRecord',
        component: () => import('../views/care/CareRecord.vue')
      },
      {
        path: 'meal/calendar',
        name: 'MealCalendar',
        component: () => import('../views/meal/MealCalendar.vue')
      },
      {
        path: 'meal/plan',
        name: 'MealPlan',
        component: () => import('../views/meal/MealPlan.vue')
      },
      {
        path: 'service',
        name: 'Service',
        component: () => import('../views/service/ServiceList.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const userStore = useUserStore()
  if (to.meta.requiresAuth && !userStore.token) {
    next('/login')
  } else {
    next()
  }
})

export default router
