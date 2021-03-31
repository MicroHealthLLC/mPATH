import MapView from './../components/dashboard/map_view'
import GanttChartView from './../components/dashboard/gantt_view'
import MembersView from './../components/dashboard/members_view'
import SheetView from './../components/dashboard/sheets'
import KanbanView from './../components/dashboard/kanban_view'

export default new VueRouter({
  routes: [
    {
      name: 'MapView',
      path: '/programs/:programId/',
      component: MapView
    },
    {
      name: 'MapView',
      path: '/programs/:programId/map',
      component: MapView
    },
    {
      name: 'GanttChartView',
      path: '/programs/:programId/gantt_chart',
      component: GanttChartView
    },
    {
      name: 'TeamMembersView',
      path: '/programs/:programId/member_list',
      component: MembersView
    },
    {
      name: 'SheetView',
      path: '/programs/:programId/sheet',
      component: SheetView
    },
    {
      name: 'KanbanView',
      path: '/programs/:programId/kanban',
      component: KanbanView
    }
  ],
  hashbang: false,
  mode: 'history',
  base: '/',
  scrollBehavior () {
    return {x: 0, y: 0}
  }
})
