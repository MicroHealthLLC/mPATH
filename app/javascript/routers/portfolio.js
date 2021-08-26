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
      path: "/portfolio/program/:programId/project/:projectId/task/:taskId",
      component: PortfolioTaskForm,   
     },
  ],
  hashbang: false,
  mode: "history",
  base: "/",
  scrollBehavior() {
    return { x: 0, y: 0 };
  },
});
