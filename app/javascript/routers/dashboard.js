import DashboardWrap from '../components/dashboard/dashboard_wrap.vue'

export default new VueRouter({
  routes: [
    {
      path: '/',
      component: DashboardWrap
    }
  ],
  hashbang: false,
  mode    : 'history',
  base    : '/dashboard',
  scrollBehavior () {
    return { x: 0, y: 0 }
  }
})
