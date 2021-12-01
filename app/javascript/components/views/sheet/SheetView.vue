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
        :current-contract-group="currentContractGroup"
        :expanded="expanded"
        :cexpanded="c_expanded"
        :current-facility="currentFacility"
        :current-contract="currentContract"
        @on-expand-facility-group="expandFacilityGroup"
        @on-expand-contract-group="expandContractGroup"
        @on-expand-facility="showFacility"
        @on-expand-contract="showContract"
      />
    </div>
    <div class="col-md-10">
      <div class="right-panel">
        <div
          v-if="
            $route.name !== 'SheetRollup' &&
              $route.name !== 'SheetTaskForm' &&
              $route.name !== 'SheetIssueForm' &&
              $route.name !== 'SheetRiskForm' &&
              $route.name !== 'SheetNoteForm' &&
              $route.name !== 'SheetLessonForm'
          "
          class="d-flex align-items-center my-1 ml-1"
        >
          <span class="fbody-icon"><i class="fas fa-suitcase"></i></span>
          <h5 class="f-head mb-0" v-if="currentContract && $route.params.contractId">
            {{ currentContract.nickname || "Loading..." }}
          </h5>
           <h5 class="f-head mb-0"  v-if="currentFacility && $route.params.projectId">
            {{ currentFacility.facilityName || "Loading..." }}
          </h5>
        </div>
        <div class="pr-3 ml-1">
          <ProjectTabs
            v-if="
              $route.name !== 'SheetRollup' &&
                $route.name !== 'SheetTaskForm' &&
                $route.name !== 'SheetIssueForm' &&
                $route.name !== 'SheetRiskForm' &&
                $route.name !== 'SheetNoteForm' &&
                $route.name !== 'SheetLessonForm'
            "
          />
        </div>
        <div class="pr-3">
          <router-view
            :key="$route.path"
            :facility="currentFacility"
            :contractClass="currentContract"
            :facilityGroup="currentFacilityGroup"
            :contractGroup="currentContractGroup"
          ></router-view>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import ProjectSidebar from "../../shared/ProjectSidebar";
import ProjectTabs from "../../shared/ProjectTabs";
export default {
  name: "SheetView",
  components: {
    ProjectSidebar,
    ProjectTabs,
  },
  data() {
    return {
      currentFacility: {},
      currentContract: {},
      facGroupId:null,
      currentContractGroup: {},
      currentFacilityGroup: {},
      expanded: {
        id: "",
      },
      c_expanded: {
        id: "",
      },
    };
  },
  methods: {
     ...mapActions(["fetchContracts"]),
    expandFacilityGroup(group) {
      if (group.id == this.expanded.id) {
        this.expanded.id = "";
      } else {
        this.expanded.id = group.id;
        this.currentFacilityGroup = group;
        this.currentFacility = this.facilityGroupFacilities(group)[0] || {};     
      }
    },
     expandContractGroup(group) {
      if (group.id == this.c_expanded.id) {
        this.c_expanded.id = "";
      } else {
        this.c_expanded.id = group.id;
       this.currentContractGroup = group;
       this.currentContract = this.facilityGroupFacilities(group)[0] || {};
      }
    },
    // log(e){
    //   console.log(e)
    // },
    showFacility(facility) {
      this.currentFacility = facility;
    },
    showContract(contract) {
      this.currentContract = contract;
    },
    changeTab(tab) {
      // console.log(tab);
      this.$router.push(tab.path);
    },
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "currentProject",
      "facilities",
      "contracts",
      "facilityGroupFacilities",
      "facilityGroups",
      "getPreviousRoute",
      "getUnfilteredFacilities",
    ]),
   
  },
  mounted() {
    // Display notification when leaving map view to another page and conditions met
  
    if (
      this.getPreviousRoute.includes("Map") &&
      this.facilities.length !== this.getUnfilteredFacilities.length
    ) {
      this.$notify.info({
        title: "Filter Set",
        message:
          "A filter was set based on the map boundary. Reset the Map Boundary Filter in the Advanced Filters tab.",
        offset: 150,
        position: "bottom-left",
      });
    }
  },
  beforeMount() {
   this.fetchContracts()  
    if (this.contentLoaded && this.$route.params.projectId) {
      this.currentFacility = this.facilities.find(
        (facility) => facility.facilityId == this.$route.params.projectId
      );
    }
     if (this.contentLoaded && this.$route.params.contractId) {
 
      this.currentContract = this.contracts[0].find(
        (c) => c.id == this.$route.params.contractId
      );
    }
  },
  watch: {
    contentLoaded: {
      handler() {
        if (this.$route.params.projectId) {
          this.currentFacility = this.facilities.find(
            (facility) => facility.id == this.$route.params.projectId
          );
        }
         else if (this.$route.params.contractId) {
          this.currentContract = this.contracts[0].find(
            (c) => c.id == this.$route.params.contractId
          );
        }
      },
    },
  currentFacility: {
    handler() {
     if (this.currentFacility && this.currentFacility.facility) { 
        this.facGroupId = this.currentFacility.facility.facilityGroupId
      } else if (this.currentFacility && !this.currentFacility.facility && this.currentFacility.contractTypeId) {
        this.facGroupId = this.currentFacility.facilityGroupId 
      } 
      this.currentFacilityGroup = this.facilityGroups.find(
        (group) => group.id == this.facGroupId 
      );        
      this.expanded.id = this.currentFacilityGroup.id;
    },
    },
    currentContract: {
      handler() {
      if (!this.$route.params.projectId && this.$route.params.contractId) {
        this.currentContractGroup = this.facilityGroups.find(
          (group) => group.id == this.currentContract.facilityGroupId
        );
      }
       this.c_expanded.id =  this.currentFacilityGroup.id;
      },
    },
    "$route.path": {
      handler() {
        if (this.$route.params.projectId) {
          this.currentFacility = this.facilities.find(facility => facility.id == this.$route.params.projectId);
         }
         if (this.$route.params.contractId) {
           this.currentContract = this.contracts[0].find(c => c.id == this.$route.params.contractId);
       }
      },
    },
  },
};
</script>

<style scoped>
.fa-building {
  font-size: large !important;
  color: #383838 !important;
}
.right-panel {
  height: calc(100vh - 100px);
  overflow-y: auto;
  overflow-x: hidden;
}
</style>