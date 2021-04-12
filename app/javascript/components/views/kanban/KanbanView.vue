<template>
  <div v-if="contentLoaded" class="row">
    <div class="col-md-2">
      <ProjectSidebar
        :current-facility-group="currentFacilityGroup"
        :expanded="expanded"
        :current-facility="currentFacility"
        @on-expand-facility-group="expandFacilityGroup"
        @on-expand-facility="showFacility"
      />
    </div>
    <div class="col-md-10 pr-4">
      <div
        v-if="
          $route.name === 'KanbanProjectSelected' ||
            $route.name === 'KanbanTasks' ||
            $route.name === 'KanbanTaskForm' ||
            $route.name === 'KanbanIssues' ||
            $route.name === 'KanbanIssueForm' ||
            $route.name === 'KanbanRisks' ||
            $route.name === 'KanbanRiskForm'
        "
      >
        <router-link
          :to="
            `/programs/${$route.params.programId}/kanban/projects/${$route.params.projectId}/tasks`
          "
          class="mr-2"
          >Tasks</router-link
        >
        <router-link
          :to="
            `/programs/${$route.params.programId}/kanban/projects/${$route.params.projectId}/issues`
          "
          class="mr-2"
          >Issues</router-link
        >
        <router-link
          :to="
            `/programs/${$route.params.programId}/kanban/projects/${$route.params.projectId}/risks`
          "
          >Risks</router-link
        >
      </div>

      <router-view
        :key="$route.path"
        :facility="currentFacility"
        :facilityGroup="currentFacilityGroup"
      ></router-view>
    </div>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import ProjectSidebar from "../../shared/ProjectSidebar";

export default {
  name: "KanbanView",
  components: {
    ProjectSidebar,
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
        // this.currentFacility = this.facilityGroupFacilities(group)[0] || {};
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
    ...mapGetters([
      "contentLoaded",
      "currentProject",
      "facilityGroupFacilities",
      "facilityGroups",
    ]),
  },
  watch: {
    contentLoaded: {
      handler() {
        if (this.$route.params.projectId) {
          this.currentFacility = this.currentProject.facilities.find(
            (facility) => facility.facilityId == this.$route.params.projectId
          );
        }
      },
    },
    currentFacility: {
      handler() {
        this.currentFacilityGroup = this.facilityGroups.find(
          (group) => group.id == this.currentFacility.facility.facilityGroupId
        );

        this.expanded.id = this.currentFacilityGroup.id;
      },
    },
  },
};
</script>

<style>
.fa-building {
  font-size: large !important;
  color: #383838 !important;
}
</style>
