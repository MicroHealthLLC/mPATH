import ProjectMapView from './../components/dashboard/project_map_view'
import GanttChart from './../components/dashboard/gantt_chart'

export default new VueRouter({
  routes: [
    {
      name: 'ProjectMapView',
      path: '/projects/:projectId',
      component: ProjectMapView
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
