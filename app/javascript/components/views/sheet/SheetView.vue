<template>
  <div
    v-loading="!contentLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    class="row"
    element-loading-background="rgba(0, 0, 0, 0.8)"
  >
    <div class="col-md-2">
      <ProjectSidebar
        :current-facility-group="currentFacilityGroup"
        :current-contract-group="currentContractGroup"
        :current-vehicle-group="currentVehicleGroup"
        :expanded="C_expanded"
        :current-facility="currentFacility"
        :current-contract="currentContract"
        :current-vehicle="currentVehicle"
        @on-expand-facility-group="expandFacilityGroup"
        @on-expand-facility="showFacility"
        @on-expand-contract="showContract"
        @on-expand-vehicle="showVehicle"
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
              $route.name !== 'SheetLessonForm' &&
              $route.name !== 'ContractTaskForm' &&
              $route.name !== 'ContractIssueForm' &&
              $route.name !== 'ContractRiskForm' &&
              $route.name !== 'ContractNoteForm' &&
              $route.name !== 'ContractLessonForm' &&
              $route.name !== 'VehicleTaskForm' &&
              $route.name !== 'VehicleIssueForm' &&
              $route.name !== 'VehicleRiskForm' &&
              $route.name !== 'VehicleNoteForm' &&
              $route.name !== 'VehicleLessonForm'
          "
          class="d-flex align-items-center my-1 ml-1"
        >
          <!-- <span class="fbody-icon"><i class="fas fa-suitcase"></i></span> -->
          <h5
            class="f-head mb-0"
            v-if="currentContract && $route.params.contractId"
          >
            <i class="far fa-file-contract mh-orange-text"></i>
            {{ currentContract.name || "Loading..." }}
          </h5>
          <h5
            class="f-head mb-0"
            v-if="currentVehicle && $route.params.vehicleId"
          >
            <i class="far fa-car text-info"></i>
            {{ currentVehicle.name || "Loading..." }}
          </h5>
          <h5
            class="f-head mb-0"
            v-if="currentFacility && $route.params.projectId"
          >
            <i class="fal fa-clipboard-list mh-green-text"></i>
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
                $route.name !== 'SheetLessonForm' &&
                $route.name !== 'ContractTaskForm' &&
                $route.name !== 'ContractIssueForm' &&
                $route.name !== 'ContractRiskForm' &&
                $route.name !== 'ContractNoteForm' &&
                $route.name !== 'ContractLessonForm'&&
                $route.name !== 'VehicleTaskForm' &&
                $route.name !== 'VehicleIssueForm' &&
                $route.name !== 'VehicleRiskForm' &&
                $route.name !== 'VehicleNoteForm' &&
                $route.name !== 'VehicleLessonForm'
            "
          />
        </div>
        <div class="pr-3">
          <router-view
            :key="$route.path"
            :facility="currentFacility"
            :contract="currentContract"
            :vehicle="currentVehicle"
            :facilityGroup="currentFacilityGroup"
            :contractGroup="currentContractGroup"
            :vehicleGroup="currentVehicleGroup"
          ></router-view>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex";
import ProjectSidebar from "../../shared/ProjectSidebar.vue";
import ProjectTabs from "../../shared/ProjectTabs.vue";
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
      currentVehicle: {},
      facGroupId: null,
      currentContractGroup: {},
      currentVehicleGroup: {},
      currentFacilityGroup: {},
      expanded: {
        id: "",
      },
    };
  },
  methods: {
    ...mapActions([]),
    ...mapMutations(["SET_EXPANDED_GROUP"]),
    expandFacilityGroup(group) {
      if (group && this.getExpandedGroup !== group.id) {
        this.SET_EXPANDED_GROUP(group.id);
        this.currentFacilityGroup = group;
        this.currentContractGroup = group;
        this.currentVehicleGroup = group;
      } else {
        this.SET_EXPANDED_GROUP("");
        this.currentFacilityGroup = {};
        this.currentContractGroup = {};
        this.currentVehicleGroup = {};
        // this.currentFacility = this.facilityGroupFacilities(group)[0] || {};
      }
    },
    log(e) {
      // console.log(e)
    },
    expandContractGroup(group) {
      if (group && this.getExpandedGroup !== group.id) {
        this.SET_EXPANDED_GROUP(group.id);
        this.currentContractGroup = group;
      } else {
        this.SET_EXPANDED_GROUP("");
        this.currentContractGroup = {};
        //  this.currentContract = this.facilityGroupFacilities(group)[0] || {};
      }
    },
    expandVehicleGroup(group) {
      if (group && this.getExpandedGroup !== group.id) {
        this.SET_EXPANDED_GROUP(group.id);
        this.currentVehicleGroup = group;
      } else {
        this.SET_EXPANDED_GROUP("");
        this.currentVehicleGroup = {};
        //  this.currentContract = this.facilityGroupFacilities(group)[0] || {};
      }
    },
    showFacility(facility) {
      this.currentFacility = facility;
    },
    showContract(contract) {
      this.currentContract = contract;
    },
    showVehicle(vehicle) {
      this.currentVehicle = vehicle;
    },
    changeTab(tab) {
      // console.log(tab);
      this.$router.push(tab.path);
    },
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "contractsLoaded",
      "vehiclesLoaded",
      "currentProject",
      "facilities",
      "projectContracts",
      "projectVehicles",
      "getExpandedGroup",
      "facilityGroupFacilities",
      "facilityGroups",
      "getPreviousRoute",
      "getUnfilteredFacilities",
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
  mounted() {
    console.log(this.$route.params)
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
    console.log(this.$route.params)
    // this.fetchContracts()
    if (this.contentLoaded && this.$route.params.projectId) {
      this.currentFacility = this.facilities.find(
        (facility) => facility.facilityId == this.$route.params.projectId
      );
    }
    if (this.contentLoaded && this.$route.params.contractId) {
      this.currentContract = this.projectContracts.find(
        (c) => c.projectContractId == this.$route.params.contractId
      );
    }
    if (this.contentLoaded && this.$route.params.vehicleId) {
      this.currentVehicle = this.projectVehicles.find(
        (c) => c.projectContractVehicleId == this.$route.params.vehicleId

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
        } else if (this.$route.params.contractId) {
          this.currentContract = this.projectContracts.find(
            (c) => c.projectContractId == this.$route.params.contractId
          );
          // console.log(this.currentContract)
        } else if (this.$route.params.vehicleId) {
          this.currentVehicle = this.projectVehicles.find(
            (c) => c.id == this.$route.params.vehicleId
          );
        }
      },
    },
    currentFacility: {
      handler() {
        if (this.$route.params.projectId) {
          this.currentFacility = this.currentProject.facilities.find(
            (facility) => facility.facilityId == this.$route.params.projectId
          );
          this.currentFacilityGroup = this.facilityGroups.find(
            (group) => group.id == this.currentFacility.facility.facilityGroupId
          );
        }
      },
    },
    currentContract: {
      handler() {
        if (this.$route.params.contractId) {
          this.currentContract = this.projectContracts.find(
            (c) => c.projectContractId == this.$route.params.contractId
          );
          // console.log(this.currentContract)
          this.currentContractGroup = this.facilityGroups.find(
            (group) => group.id == this.currentContract.facilityGroup.id
          );
        }
      },
    },
    currentVehicle: {
      handler() {
        if (this.$route.params.vehicleId) {
          this.currentVehicle = this.projectVehicles.find(
            (c) => c.projectContractVehicleId == this.$route.params.vehicleId
          );
          // console.log(this.currentContract)
          this.currentVehicleGroup = this.facilityGroups.find(
            (group) => group.id == this.currentVehicle.facilityGroup.id
          );
        }
      },
    },
    "$route.path": {
      handler() {
        if (this.$route.params.projectId) {
          this.currentFacility = this.facilities.find(
            (facility) => facility.id == this.$route.params.projectId
          );
        }
        if (this.$route.params.contractId) {
          // console.log(this.currentContract)
          this.currentContract = this.projectContracts.find(
            (c) => c.projectContractId == this.$route.params.contractId
          );
        }
        if (this.$route.params.vehicleId) {
          // console.log(this.currentContract)
          this.currentVehicle = this.projectVehicles.find(
            (c) => c.projectContractVehicleId == this.$route.params.vehicleId
          );
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
