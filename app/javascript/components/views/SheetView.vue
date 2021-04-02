<template>
  <div class="row">
    <div class="col-md-2">
      <ProjectSidebar
        :current-facility-group="currentFacilityGroup"
        :expanded="expanded"
        :current-facility="currentFacility"
        @on-expand-facility-group="expandFacilityGroup"
        @on-expand-facility="showFacility"
      />
    </div>
    <div class="col-md-10">
      <ProjectTabs v-if="$route.name !== 'SheetProjectRollup'" />
      <router-view :key="$route.path" :facility="currentFacility"></router-view>
    </div>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import ProjectSidebar from "../shared/ProjectSidebar";
import ProjectTabs from "../shared/ProjectTabs";

export default {
  name: "SheetView",
  components: {
    ProjectSidebar,
    ProjectTabs,
  },
  data() {
    return {
      currentFacility: {},
      currentFacilityGroup: {},
      expanded: {
        id: "",
      },
    };
  },
  methods: {
    expandFacilityGroup(group) {
      if (group.id == this.expanded.id) {
        this.expanded.id = "";
      } else {
        this.expanded.id = group.id;
        this.currentFacilityGroup = group;
        this.currentFacility = this.facilityGroupFacilities(group)[0] || {};
      }
    },
    showFacility(facility) {
      this.currentFacility = facility;
    },
    changeTab(tab) {
      console.log(tab);
      this.$router.push(tab.path);
    },
  },
  computed: {
    ...mapGetters(["facilityGroupFacilities"]),
  },
  mounted() {
    console.log(this.$route.name);
  },
};
</script>

<style></style>
