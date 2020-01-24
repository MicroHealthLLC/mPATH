import DashboardWrap  from '../components/dashboard/dashboard_wrap'

export default new VueRouter({
  routes: [
    {
      name: 'ProjectDashboard',
      path: '/projects/:projectId',
      component: DashboardWrap
    }
  ],
  hashbang: false,
  mode    : 'history',
  base    : '/',
  scrollBehavior () {
    return { x: 0, y: 0 }
  }
})
