import MapView from "./../components/dashboard/map_view";
import GanttChartView from "./../components/dashboard/gantt_view";
import MembersView from "./../components/dashboard/members_view";


import SheetView from "./../components/views/sheet/SheetView";
import ProjectRollup from "./../components/shared/ProjectRollup";
import SheetOverview from "./../components/views/sheet/SheetOverview";
import SheetTasks from "./../components/views/sheet/SheetTasks";
import SheetTaskForm from "./../components/views/sheet/SheetTaskForm";
import SheetIssues from "./../components/views/sheet/SheetIssues";
import SheetIssueForm from "./../components/views/sheet/SheetIssueForm";
import SheetRisks from "./../components/views/sheet/SheetRisks";
import SheetRiskForm from "./../components/views/sheet/SheetRiskForm";
import SheetNotes from "./../components/views/sheet/SheetNotes";
import SheetNoteForm from "./../components/views/sheet/SheetNoteForm";

import KanbanView from "./../components/views/kanban/KanbanView";
import KanbanDefault from "./../components/views/kanban/KanbanDefault";
import KanbanTasks from "./../components/views/kanban/KanbanTasks";
import KanbanIssues from "./../components/views/kanban/KanbanIssues";
import KanbanRisks from "./../components/views/kanban/KanbanRisks";

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
          component: SheetTaskForm,
        },
        // Project Issues
        {
          name: "SheetProjectIssues",
          path: "projects/:projectId/issues",
          component: SheetIssues,
        },
        // Issue Form
        {
          name: "SheetProjectIssueForm",
          path: "projects/:projectId/issues/:issueId",
          component: SheetIssueForm,
        },
        // Project Risks
        {
          name: "SheetProjectRisks",
          path: "projects/:projectId/risks",
          component: SheetRisks,
        },
        // Risk Form
        {
          name: "SheetProjectRiskForm",
          path: "projects/:projectId/risks/:riskId",
          component: SheetRiskForm,
        },
        // Project Notes
        {
          name: "SheetProjectNotes",
          path: "projects/:projectId/notes",
          component: SheetNotes,
        },
        // Note Form
        {
          name: "SheetProjectNoteForm",
          path: "projects/:projectId/notes/:noteId",
          component: SheetNoteForm,
        },
      ],
    },
    {
      name: "KanbanView",
      path: "/programs/:programId/kanban",
      component: KanbanView,
      children: [
        {
          name: "KanbanDefault",
          path: "",
          component: KanbanDefault,
        },
        {
          name: "KanbanDefault",
          path: "projects/:projectId",
          component: KanbanDefault,
        },
        {
          name: "KanbanTasks",
          path: "projects/:projectId/tasks",
          component: KanbanTasks,
        },
        {
          name: "KanbanIssues",
          path: "projects/:projectId/issues",
          component: KanbanIssues,
        },
        {
          name: "KanbanRisks",
          path: "projects/:projectId/risks",
          component: KanbanRisks,
        },
      ],
    },
  ],
  hashbang: false,
  mode: "history",
  base: "/",
  scrollBehavior() {
    return { x: 0, y: 0 };
  },
});
