<template>
  <div
    v-loading="!contentLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)"
    class="row"
  >
    <div class="col-md-2">
      <ProjectSidebar
        :current-facility-group="currentFacilityGroup"
        :expanded="C_expanded"
        :current-facility="currentFacility"
        @on-expand-facility-group="expandFacilityGroup"
        @on-expand-facility="showFacility"
      />
    </div>
    <div class="col-md-10">
      <div class="right-panel">
         <div v-if="
              $route.name === 'KanbanTasks' ||
              $route.name === 'KanbanIssues' ||
              $route.name === 'KanbanRisks'
       
       " class="d-flex align-items-center ml-1">
           <i class="fal fa-clipboard-list mh-green-text pr-2"></i>
          <h5 class="f-head my-1 mb-0">
            {{ currentFacility.facilityName || "Loading..." }}
          </h5>   
       </div> 
        <div
          v-if="
            $route.name === 'KanbanProjectSelected' ||
              $route.name === 'KanbanTasks' ||
              $route.name === 'KanbanIssues' ||
              $route.name === 'KanbanRisks'
          "
          class="tabs mt-0 ml-1 mr-3 p-2"
        >
        
          <router-link
            :to="
              `/programs/${$route.params.programId}/kanban/projects/${$route.params.projectId}/tasks`
            "
            class="tab mr-2"
            :class="{ active: $route.path.includes('tasks') }"
            data-cy="task_link"
            >Tasks</router-link
          >
          <router-link
            :to="
              `/programs/${$route.params.programId}/kanban/projects/${$route.params.projectId}/issues`
            "
            class="tab mr-2"
            :class="{ active: $route.path.includes('issues') }"
            data-cy="issue_link"
            >Issues</router-link
          >
          <router-link
            :to="
              `/programs/${$route.params.programId}/kanban/projects/${$route.params.projectId}/risks`
            "
            class="tab"
            :class="{ active: $route.path.includes('risks') }"
            data-cy="risk_link"
            >Risks</router-link
          >
        </div>
        <div class="pr-3">
          <router-view
            :key="$route.path"
            :facility="currentFacility"
            :facilityGroup="currentFacilityGroup"
          ></router-view>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapMutations } from "vuex";
import ProjectSidebar from "../../shared/ProjectSidebar.vue";

export default {
  name: "KanbanView",
  components: {
    ProjectSidebar,
  },
  data() {
    return {
      currentFacility: {},
      currentFacilityGroup: {},     
    };
  },
  methods: {
    ...mapMutations([
      "SET_EXPANDED_GROUP"
     ]), 
   expandFacilityGroup(group) {      
     if (group.id == this.getExpandedGroup) {
         this.SET_EXPANDED_GROUP('')
       } else {
       this.SET_EXPANDED_GROUP(group.id)
        this.currentFacilityGroup = group;
        // this.currentFacility = this.facilityGroupFacilities(group)[0] || {};     
      }
    },
    showFacility(facility) {
      this.currentFacility = facility;
    },
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "facilities",
      "getExpandedGroup",
      "facilityGroupFacilities",
      "facilityGroups",
    ]),
   C_expanded: {
      get() {
        return this.getExpandedGroup;
      },
      set(value) {
        // console.log(`expanded setter value: ${value}`)
        this.SET_EXPANDED_GROUP(value);
      },
    },
  },
  beforeMount() {
    if (this.contentLoaded && this.$route.params.projectId) {
      this.currentFacility = this.facilities.find(
        (facility) => facility.facilityId == this.$route.params.projectId
      );
    }
  },
  watch: {
    contentLoaded: {
      handler() {
        if (this.$route.params.projectId) {
          this.currentFacility = this.facilities.find(
            (facility) => facility.facilityId == this.$route.params.projectId
          );
        }
      },
    },
    currentFacility: {
      handler() {
        if(this.currentFacility){
            this.currentFacilityGroup = this.facilityGroups.find(
          (group) => group.id == this.currentFacility.facility.facilityGroupId
        );
       }
      }      
    },
    facilities: {
      handler() {
        this.currentFacility = this.facilities.find(
          (facility) => facility.facilityId == this.$route.params.projectId
        );
      },
    },
  },
};
</script>

<style scoped lang="scss">
.fa-building {
  font-size: large !important;
  color: #383838 !important;
}
.tabs {
  background-color: #ededed;
  border-top: solid 0.3px #ededed;
  display: flex;
  width: min-content;
  box-shadow: 0 2.5px 2.5px rgba(0, 0, 0, 0.19), 0 3px 3px rgba(0, 0, 0, 0.23);
  .tab {
    cursor: pointer;
    border-radius: 0.1rem;
    padding: 7px 10px;
    font-weight: 500;
    letter-spacing: 1;
    transition: auto;
    font-size: 75%;
  }
  .active {
    color: #fff !important;
    background-color: #383838 !important;
  }
}
a {
  color: unset;
  text-decoration: unset;
}
.right-panel {
  height: calc(100vh - 100px);
  overflow-y: auto;
}
</style>
