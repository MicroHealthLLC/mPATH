import PortfolioView from "./../components/views/portfolio/PortfolioView";

export default new VueRouter({
  routes: [
     {
      name: "PortfolioView",
      path: "/api/v1/portfolio/programs",    
      // path: "/portfolio",    
      component: PortfolioView,
    }
  ],
  hashbang: false,
  mode: "history",
  base: "/",
  scrollBehavior() {
    return { x: 0, y: 0 };
  },
});
