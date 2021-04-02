import MapView from './../components/dashboard/map_view'
import GanttChartView from './../components/dashboard/gantt_view'
import MembersView from './../components/dashboard/members_view'
// import SheetView from './../components/dashboard/sheets'
import KanbanView from './../components/dashboard/kanban_view'

import SheetView from './../components/views/SheetView'
import ProjectRollup from './../components/shared/ProjectRollup'
import SheetOverview from './../components/views/SheetOverview';
import SheetTasks from './../components/views/SheetTasks';
import SheetTaskForm from './../components/views/SheetTaskForm'
import SheetIssues from "./../components/views/SheetIssues";
import SheetRisks from "./../components/views/SheetRisks";
import SheetNotes from "./../components/views/SheetNotes"

export default new VueRouter({
  routes: [
    {
      name: "MapView",
      path: "/programs/:programId/",
      component: MapView,
    },
    {
      name: "MapView",
      path: "/programs/:programId/map",
      component: MapView,
    },
    {
      name: "GanttChartView",
      path: "/programs/:programId/gantt_chart",
      component: GanttChartView,
    },
    {
      name: "TeamMembersView",
      path: "/programs/:programId/member_list",
      component: MembersView,
    },
    {
      name: "SheetView",
      path: "/programs/:programId/sheet",
      component: SheetView,
      children: [
        // Rollup
        {
          name: "SheetProjectRollup",
          path: "",
          component: ProjectRollup,
        },
        // Project Overview tab
        {
          name: "SheetProjectOverview",
          path: "projects/:projectId",
          component: SheetOverview,
        },
        // Project Tasks
        {
          name: "SheetProjectTasks",
          path: "projects/:projectId/tasks",
          component: SheetTasks,
        },
        // Task Form
        {
          name: "SheetProjectTaskForm",
          path: "projects/:projectId/tasks/:taskId",
          component: SheetTaskForm
        },
        // Project Issues
        {
          name: "SheetProjectIssues",
          path: "projects/:projectId/issues",
          component: SheetIssues,
        },
        // Issue Form
        // Project Risks
        {
          name: "SheetProjectRisks",
          path: "projects/:projectId/risks",
          component: SheetRisks,
        },
        // Risk Form
        // Project Notes
        {
          name: "SheetProjectNotes",
          path: "projects/:projectId/notes",
          component: SheetNotes
        }
        // Note
      ],
    },
    {
      name: "KanbanView",
      path: "/programs/:programId/kanban",
      component: KanbanView,
    },
  ],
  hashbang: false,
  mode: "history",
  base: "/",
  scrollBehavior() {
    return { x: 0, y: 0 };
  },
});
