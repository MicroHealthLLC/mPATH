import PortfolioView from "./../components/views/portfolio/PortfolioView";
import PortfolioTaskForm from "./../components/views/portfolio/PortfolioTaskForm";
import PortfolioIssueForm from "./../components/views/portfolio/PortfolioIssueForm";
import PortfolioRiskForm from "./../components/views/portfolio/PortfolioRiskForm";

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
      },
     },
     {
      name: "PortfolioIssueForm",
      path: "/program/:programId/project/:projectId/issues/:issueId",
      component: PortfolioIssueForm,   
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
      },
     },
     {
      name: "PortfolioRiskForm",
      path: "/program/:programId/project/:projectId/risks/:riskId",
      component: PortfolioRiskForm,   
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
