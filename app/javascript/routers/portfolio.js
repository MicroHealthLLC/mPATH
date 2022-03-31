import PortfolioView from "./../components/views/portfolio/PortfolioView";
import PortfolioTaskForm from "./../components/views/portfolio/PortfolioTaskForm";
import PortfolioIssueForm from "./../components/views/portfolio/PortfolioIssueForm";
import PortfolioRiskForm from "./../components/views/portfolio/PortfolioRiskForm";
import PortfolioLessonForm from "./../components/views/portfolio/PortfolioLessonForm";
import ContractsView from "./../components/views/portfolio/contracts/PortfolioContracts";

export default new VueRouter({
  routes: [
     {
      name: "PortfolioView",
      // path: "/api/v1/portfolio/programs",    
      path: "/portfolio",    
      component: PortfolioView,
     },
     {
      name: "PortfolioContracts",
      // path: "/api/v1/portfolio/programs",    
      path: "/portfolio/contracts",    
      component: ContractsView,
     },
     {
      name: "PortfolioTaskForm",
      path: "/portfolio/program/:programId/project/:projectId/task/:id",
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
      path: "/portfolio/program/:programId/project/:projectId/issue/:id",
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
      path: "/portfolio/program/:programId/project/:projectId/risk/:id",
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
     {
      name: "PortfolioLessonForm",
      path: "/portfolio/program/:programId/project/:projectId/lesson/:id",
      component: PortfolioLessonForm,   
     },
  ],
  hashbang: false,
  mode: "history",
  base: "/",
  scrollBehavior() {
    return { x: 0, y: 0 };
  },
});
