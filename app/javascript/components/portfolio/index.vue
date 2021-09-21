<template>
  <div
    >   
    <!-- <tabsbar></tabsbar> -->
    <portfolio-filter-sidebar></portfolio-filter-sidebar>
    <router-view></router-view>
  </div>
</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex";
// import Tabsbar from "./../shared/tabsbar";
import PortfolioFilterSidebar from "./portfolio_filter_sidebar.vue"

export default {
  name: "Portfolio",
  components: {
    // Tabsbar,
    PortfolioFilterSidebar,
  },
  mounted() {
    // let id = this.$route.params.programId;
    // this.fetchDashboardData({ id });
    // Prevent right-click context-menu from appearing accross whole app
    window.oncontextmenu = (e) => {
      if (e.target.nodeName !== "INPUT" && e.target.nodeName !== "TEXTAREA") {
        e.preventDefault();
      }
    };
  },
  methods: {
    ...mapActions(["fetchDashboardData"]),
    ...mapMutations(["setUnfilteredFacilities"]),
  },
  computed: {
    ...mapGetters(["facilities", "portfolioTasksLoaded", "", "getUnfilteredFacilities", 'portfolioCountsLoaded']),
  },
  updated() {
    if (this.contentLoaded && this.getUnfilteredFacilities.length === 0) {
      this.setUnfilteredFacilities(this.facilities);
    }
  },
};
</script>

<style scoped lang="scss">
// .vh100{
//   height: 100vh;
//   width: 100vw;
// }
</style>