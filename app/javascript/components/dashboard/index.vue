<template>
  <div>
    <tabsbar :class="{'d-none': isProgramView }"></tabsbar>
    <filter-sidebar v-if="contentLoaded"></filter-sidebar>
    <router-view></router-view>
  </div>
</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex";
import Tabsbar from "./../shared/tabsbar";
import FilterSidebar from "./../shared/filter_sidebar";

export default {
  name: "Dashboard",
  components: {
    Tabsbar,
    FilterSidebar,
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
    ...mapGetters(["contentLoaded", "facilities", "getUnfilteredFacilities"]),
      isProgramView() {
      return this.$route.name.includes("ProgramView");  
      },
  },

  updated() {
    if (this.contentLoaded && this.getUnfilteredFacilities.length === 0) {
      this.setUnfilteredFacilities(this.facilities);
    }
  },
};
</script>
