<template>
  <div
    v-loading="!portfolioTasksLoaded"
    element-loading-text="Fetching Portfolio Viewer data. Please wait..."
    :class="[!portfolioTasksLoaded ? 'vh100': '']"
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)">   
    <!-- <tabsbar></tabsbar> -->
    <!-- <filter-sidebar v-if="contentLoaded"></filter-sidebar> -->
    <router-view></router-view>
  </div>
</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex";
// import Tabsbar from "./../shared/tabsbar";
// import FilterSidebar from "./../shared/filter_sidebar";

export default {
  name: "Portfolio",
  components: {
    // Tabsbar,
    // FilterSidebar,
  },
  mounted() {
    let id = this.$route.params.programId;
    this.fetchDashboardData({ id });
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
    ...mapGetters(["facilities", "portfolioTasksLoaded","getUnfilteredFacilities"]),
  },
  updated() {
    if (this.contentLoaded && this.getUnfilteredFacilities.length === 0) {
      this.setUnfilteredFacilities(this.facilities);
    }
  },
};
</script>

<style scoped lang="scss">
.vh100{
  height: 100vh;
  width: 100vw;
}
</style>