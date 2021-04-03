import ProjectMapView from './../components/dashboard/map_view'
import GanttChartView from './../components/dashboard/gantt_view'
import MembersView from './../components/dashboard/members_view'
import CalendarView from './../components/dashboard/calendar_view'
import Sheets from './../components/dashboard/sheets'
import KanbanView from './../components/dashboard/kanban_view'

export default new VueRouter({
  routes: [
    {
      name: 'ProjectMapView',
      path: '/projects/:projectId/',
      component: ProjectMapView
    },
    {
      name: 'CalendarView',
      path: '/projects/:projectId/calendar_view',
      component: CalendarView
    },
    {
      name: 'ProjectMapView',
      path: '/projects/:projectId/map',
      component: ProjectMapView
    },
    {
      name: 'ProjectGanttChart',
      path: '/projects/:projectId/gantt_chart',
      component: GanttChartView
    },
    {
      name: 'TeamMembersView',
      path: '/projects/:projectId/member_list',
      component: MembersView
    },
    {
      name: 'ProjectSheets',
      path: '/projects/:projectId/sheet',
      component: Sheets
    },
    {
      name: 'ProjectKanbanView',
      path: '/projects/:projectId/kanban',
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
