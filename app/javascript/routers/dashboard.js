import DashboardWrap from './../components/dashboard/dashboard_wrap'
import GanttChart from './../components/dashboard/gantt_chart'

export default new VueRouter({
  routes: [
    {
      name: 'ProjectDashboard',
      path: '/projects/:projectId',
      component: DashboardWrap
    },
    {
      name: 'ProjectGanttChart',
      path: '/projects/:projectId/gantt_chart',
      component: GanttChart
    }
  ],
  hashbang: false,
  mode: 'history',
  base: '/',
  scrollBehavior () {
    return {x: 0, y: 0}
  }
})
