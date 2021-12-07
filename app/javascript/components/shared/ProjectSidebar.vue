<template>
  <div id="facility_sidebar" class="pl-0" data-cy="facility_list">
    <div class="stick">
      <div
        @click="deselectProject"
        id="program_name"
        class="programNameDiv smallCaps pl-2 pr-1"
      >
        {{ programName }}
      </div>
    </div>
    <h4 class="mt-4 text-info text-center" v-if="title">{{ title }}</h4>
    <div class="mb-3 ml-2" style="margin-top:1.8rem">
      <div v-if="contentLoaded" >
        <div
          v-for="(group, index) in sortedGroups"
          :key="index + 'a'"    
          class="my-2 px-2 container"
        >
          <div
            class="d-flex row expandable"
            @click="expandFacilityGroup(group)"
            :class="{ active: group.id == currentFacilityGroup.id }"
            data-cy="facility_groups"
            :key="index"
          >

          <div class="col-8 py-0 pr-0">
           <span class="d-flex">
            <span v-show="expanded.id != group.id">
              <i class="fa fa-angle-right font-sm mr-2 clickable"></i>
            </span>
            <span v-show="expanded.id == group.id">
              <i class="fa fa-angle-down font-md mr-2 clickable"></i>
            </span>
           <p class="clickable groupName">{{ group.name }}</p>
           </span>
         </div>

           <div class="col py-0 text-right">
           <span class="badge badge-secondary badge-pill pill">{{ group.facilities.length}}</span>
         
         </div>
             
          </div>
         <div v-show="expanded.id == group.id" class="ml-2">
              <div
              v-for="facility in facilityGroupFacilities(group)"            
              :key="facility.id"
            >
              <router-link
                :to="
                  `/programs/${$route.params.programId}/${tab}/projects/${facility.id}${pathTab}`
                "
              >
                <div
                  class="d-flex align-items-center expandable fac-name"
                  @click="showFacility(facility)"
                  :class="{ active: facility.id == $route.params.projectId }"
                >
                  <p class="facility-header" data-cy="facilities">
                      <i class="fal fa-clipboard-list mr-1 mh-green-text"></i>  {{ facility.facility.facilityName }}
                  </p>
                </div>
              </router-link>
              </div>
               <div v-show="isSheetsView" v-for="c in currentProject.contracts.filter(t => t.facilityGroupId == group.id)" :key="c.id + 'a'">
              
              <router-link               
                :to="
                  `/programs/${$route.params.programId}/${tab}/contracts/${c.id}/contract`
                "
              >
                <div
                  class="d-flex align-items-center expandable fac-name"
                  @click="showFacility(c)"
                  :class="{ active: c.id == $route.params.contractId }"
                >
                  <p class="facility-header" data-cy="facilities">
                  <i class="far fa-file-contract mr-1 mh-orange-text"></i>   {{ c.nickname }}
                  </p>
                </div>
              </router-link>
         
            </div>           
          </div>
        </div>
      </div>
           <div v-else>
        <loader type="code"></loader>
        <loader type="code"></loader>
        <loader type="code"></loader>
      </div>
    </div>
     <!-- <router-link  >  -->
      <button class="btn btn-sm btn-light program-settings-btn"  @click.prevent="toggleAdminView" style="cursor: pointer">
       <h6> <i class="far fa-cog"></i> Program Settings </h6>
      </button>  
      <!-- </router-link> -->
  </div>
</template>

<script>
import { mapGetters, mapMutations } from "vuex";
import Loader from "./loader";

export default {
  name: "ProjectSidebar",
  components: {
    Loader,
  },
  props: ["title", "currentFacility", "currentFacilityGroup", "expanded", "currentContract"],
   data() {
      return {
        value: ''
      }
    },
  computed: {
    ...mapGetters([
      "contentLoaded",
      'getShowAdminBtn',
      "currentProject",
      "facilities",
      "facilityGroups",
      "filteredFacilities",
      'getProjectGroupFilter',
      "filteredFacilityGroups",
      "facilityGroupFacilities",
    ]),
    programName() {
      if (
        this.contentLoaded &&
        (this.currentProject !== null || this.currentProject !== undefined)
      ) {
        return this.currentProject.name;
      }
    },
    isSheetsView() {
      return this.$route.name.includes("Sheet");
    },
  groups(){
      let group = (array, key ) => {
        return array.reduce((result, currentValue) => {
      // If an array already present for key, push it to the array. Else create an array and push the object
      (result[currentValue[key]] = result[currentValue[key]] || []).push(
      currentValue
        );
        // Return the current iteration `result` value, this will be taken as next iteration `result` value and accumulate
        return result;
      }, {}); // empty object is the initial value for result object
      };
      return group(this.facilities, "facilityGroupName")
    },
   C_projectGroupFilter: {
      get() {
        return this.getProjectGroupFilter;
      },
      set(value) {
        // console.log(value)
        this.setProjectGroupFilter(value);
      },
    },
    sortedGroups() {
      // Sort groups by name
      return this.facilityGroups.sort((a, b) =>
        a.name.localeCompare(b.name)
      );
    },
    tab() {
      let url = this.$route.path;

      if (url.includes("sheet")) {
        return "sheet";
      }
      if (url.includes("calendar")) {
        return "calendar";
      } else {
        return "kanban";
      }
    },
    pathTab() {
      let url = this.$route.path;
      if (url.includes("tasks")) {
        return "/tasks";
      }  if (url.includes("issues")) {
        return "/issues";
      }  if (url.includes("analytics")) {
        return "/analytics";
      } if (url.includes("project")) {
        return "/project";
      }  if (url.includes("risks")) {
        return "/risks";
      } if (url.includes("lessons")) {
        return "/lessons";
      } if (url.includes("notes")) {
        return "/notes";
      } if (url.includes("kanban")) {
        return "/tasks";
      } if (url.includes("calendar")) {
        return "/tasks";
      } else {
        return "/analytics";
      }
    },
  },
  methods: {
   ...mapMutations(['setProjectGroupFilter', 'setShowAdminBtn']), 
     expandFacilityGroup(group) {
       if (this.currentContract && this.currentFacility == {}) {
         group = this.currentContract.facility_group_id
       }
      this.$emit("on-expand-facility-group", group);
    },
    toggleAdminView() {
        // this.setShowAdminBtn(!this.getShowAdminBtn);
         this.$router.push(
        `/programs/${this.$route.params.programId}/settings`
        );

      },
    handleClose(done) {
        this.$confirm('Are you sure to close this dialog?')
          .then(_ => {
            done();
          })
          .catch(_ => {});
    },
    showFacility(c) {
      this.$emit("on-expand-facility", c);
    },
    deselectProject(e) {
      if (e.target.id === "program_name") {
        this.$router.push(
          `/programs/${this.$route.params.programId}/${this.tab}`
        );
      }
    },
  },
 
  mounted() {
     // Expand the project tree if there is only one project group on tab transition
    if (
      this.filteredFacilityGroups.length === 1 &&
      this.contentLoaded &&
      (!this.$route.params.projectId || !this.$route.params.contractId)
    ) {
      this.expandFacilityGroup(this.filteredFacilityGroups[0]);
    }
  },
  watch: {
    contentLoaded: {
      handler() {
        if (this.currentFacilityGroup){
          this.expanded.id = this.currentFacilityGroup.id
        }
         if (this.currentContract) {
           this.expanded.id = this.currentContract.facility_group_id
        }
        // Expand the project tree if there is only one project group on refresh
        if (
          this.filteredFacilityGroups.length === 1 &&
          (!this.$route.params.projectId || !this.$route.params.contractId )
        ) {
          this.expandFacilityGroup(this.filteredFacilityGroups[0]);
        }
      },
    },

  },
};
</script>

<style lang="scss" scoped>
.program-settings-btn{
  position: absolute;
  bottom: 25px;
  left: 25%;
  z-index: 1140;
}
/deep/.el-dialog__title {
  padding: 5px 10px;
  background-color: #DD9036;
  color: white;
  font-size: 16px;
  font-weight: lighter;
  border-radius: .25rem;

}
// /deep/.el-dialog__body {
//     padding: 10px 20px;
//  }
.saveBtns {
  box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23); 
}
#facility_sidebar {
  background: #ededed;
  max-height: calc(100vh - 94px);
  height: calc(100vh - 94px);
  overflow-y: auto;
  .facility-header {
    padding: 0 8px;
    cursor: pointer;
    &:hover {
      font-weight: bold;
    }
  }
  .programNameDiv {
    box-shadow: 0 2.5px 2.5px rgba(0, 0, 0, 0.19), 0 3px 3px rgba(0, 0, 0, 0.23);
    cursor: pointer;
    &.active {
      background-color: red !important;
      color: #007bff;
    }
  }
  .programNameDiv:hover {
    background-color: rgba(211, 211, 211, 10%);
  }
  .fac-name {
    border-bottom: solid lightgray 0.5px;
    border-radius: 2px;
    margin: 1px;
    cursor: pointer;
  }
  .groupName{
    overflow: hidden;
    white-space: nowrap; /* Don't forget this one */
    text-overflow: ellipsis;
    font-size: 1.15rem;
  }
  .programNameBtn {
    &.active {
      background-color: red !important;
      color: #007bff;
    }
  }
  .programName {
    position: absolute;
    top: 0;
    width: 100%;
  }
  .fac-name:hover {
    background-color: rgba(91, 192, 222, 0.3);
    cursor: pointer;
  }
  .fac-name {
    &.active {
      background-color: rgba(211, 211, 211, 10%);
      color: #007bff;
    }
    &.active,
    &:hover {
      h5,
      h6 {
        font-weight: 900 !important;
      }
    }
  }

  .smallCaps {
    font-variant: small-caps;
    // position: sticky;
    // position: -webkit-sticky;
    // top: 0;
  }
  a {
    color: unset;
    &:hover {
      color: unset;
      text-decoration: unset;
    }
  }
}
</style>
