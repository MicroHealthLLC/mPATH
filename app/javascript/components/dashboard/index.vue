<template>
  <div>
    <tabsbar :class="{'d-none': isProgramView }"></tabsbar>
    <filter-sidebar v-if="contentLoaded" :class="{'d-none': isProgramView }"></filter-sidebar>
    <!-- <settings-sidebar v-if="contentLoaded" :class="{'d-none': isProgramView }"></settings-sidebar> -->
    <router-view></router-view>
  </div>
</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex";
import Tabsbar from "./../shared/tabsbar";
import FilterSidebar from "./../shared/filter_sidebar";
import SettingsSidebar from "../views/settings/SettingsSidebar.vue";

export default {
  name: "Dashboard",
  components: {
    Tabsbar,
    FilterSidebar,
    SettingsSidebar
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
      return this.$route.name.includes("ProgramView") ||
             this.$route.name.includes("ProgramTaskForm") ||
             this.$route.name.includes("ProgramRiskForm") ||
             this.$route.name.includes("ProgramIssueForm") ||
             this.$route.name.includes("ProgramLessonForm") ;;  
      },
  },

  updated() {
    if (this.contentLoaded && this.getUnfilteredFacilities.length === 0) {
      this.setUnfilteredFacilities(this.facilities);
    }
  },
};
</script>
