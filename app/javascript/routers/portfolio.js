import PortfolioView from "./../components/views/portfolio/PortfolioView";
import PortfolioTaskForm from "./../components/views/portfolio/PortfolioTaskForm";

export default new VueRouter({
  routes: [
     {
      name: "PortfolioView",
      // path: "/api/v1/portfolio/programs",    
      path: "/portfolio",    
      component: PortfolioView,
     },
     {
      name: "PortfolioTaskForm",
      path: "/program/:programId/project/:projectId/tasks/:taskId",
      component: PortfolioTaskForm,   
      beforeEnter: (to, from, next) => {
        var programId = to.params.programId;
        var projectId = to.params.projectId;
        var fPrivilege = _.filter(
          Vue.prototype.$projectPrivileges,
          (f) => f.program_id == programId && f.project_id == projectId
        )[0];
        if (!fPrivilege) {
          next();
          return;
        }
        // if (
        //   fPrivilege["overview"].hide &&
        //   fPrivilege["tasks"].hide &&
        //   fPrivilege["issues"].hide &&
        //   fPrivilege["risks"].hide &&
        //   fPrivilege["notes"].hide
        // ) {
        //   alert(
        //     "You don't have access to see any tabs. Please contact administrator"
        //   );
        // }
        // if (!fPrivilege["tasks"].hide) {
        //   next();
        // } else if (!fPrivilege["overview"].hide) {
        //   next({
        //     name: "SheetOverview",
        //     params: { programId: programId, projectId: projectId },
        //   });
        // } else if (!fPrivilege["issues"].hide) {
        //   next({
        //     name: "SheetIssues",
        //     params: { programId: programId, projectId: projectId },
        //   });
        // } else if (!fPrivilege["risks"].hide) {
        //   next({
        //     name: "SheetRisks",
        //     params: { programId: programId, projectId: projectId },
        //   });
        // } else if (!fPrivilege["notes"].hide) {
        //   next({
        //     name: "SheetNotes",
        //     params: { programId: programId, projectId: projectId },
        //   });
        // }
      },
     },
  ],
  hashbang: false,
  mode: "history",
  base: "/",
  scrollBehavior() {
    return { x: 0, y: 0 };
  },
});
