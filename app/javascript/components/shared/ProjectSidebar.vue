<template>
  <div id="facility_sidebar" class="pl-0" data-cy="facility_list" >
    <div class="stick">
      <div
        @click="deselectProject"
        id="program_name"
        class="programNameDiv smallCaps pl-2 pr-3"
      >
        {{ programName }}
      </div>
    </div>
    <h4 class="mt-4 text-info text-center" v-if="title">{{ title }}</h4>
    <div class="mb-3 pb-4 ml-2" style="margin-top:1.8rem">
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
            <span v-show="getExpandedGroup != group.id">
              <i class="fa fa-angle-right font-sm mr-2 clickable"></i>
            </span>
            <span v-show="getExpandedGroup == group.id">
              <i class="fa fa-angle-down font-md mr-2 clickable"></i>
            </span>
           <p class="clickable groupName expandText">{{ group.name }}</p>
           </span>
         </div>

           <div class="col py-0 text-right"  v-if="_isallowedProjectCounts(group, 'read')">
            <span class="badge badge-secondary badge-pill pill" v-if="isContractsView">{{ 
              facilityGroupFacilities(group).projects.a.length +  
              facilityGroupFacilities(group).contracts.b.length
              }}
            </span>

             <span class="badge badge-secondary badge-pill pill">
                {{ facilityGroupFacilities(group).projects.a.length }}
            </span> 
         </div>
             
          </div>
          <!-- <span    :load="log(facilityGroupFacilities(group))"> </span> -->
         <div v-show="getExpandedGroup == group.id" class="ml-2">
              <div
              v-for="facility in facilityGroupFacilities(group).projects.a"            
              :key="facility.id"  
              
            >
              <router-link
                :to="
                  `/programs/${$route.params.programId}/${tab}/projects/${facility.id}${pathTab}`
                "
              >
                <div
                  class="d-flex align-items-center expandable fac-name"
                   v-if="_isallowedProjects(facility, 'read')"
                  @click="showFacility(facility)"
                  :class="{ active: facility.id == $route.params.projectId }"
                >
                  <p class="facility-header" data-cy="facilities">
                      <i class="fal fa-clipboard-list mr-1 mh-green-text"></i>  {{ facility.facilityName }}
                  </p>
                </div>
              </router-link>
              </div>
               <div                          
                v-for="c in projectContracts.filter(t => t.facilityGroup && t.facilityGroup.id == group.id)" 
                 v-show="isContractsView"    
                :key="c.projectContractId + 'a'"
                >              
              <router-link               
                :to="
                  `/programs/${$route.params.programId}/${tab}/contracts/${c.projectContractId}${pathTab}`
                "
              >
                <div
                  v-if="_isallowedContracts(c, 'read')"
                  class="d-flex align-items-center expandable fac-name"
                  @click="showFacility(c)"
                  :class="{ active: c.projectContractId == $route.params.contractId }"
                >
                <p class="facility-header" data-cy="facilities">
                  <i class="far fa-file-contract mr-1 mh-orange-text"></i>   {{ c.name }}
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
      <button v-if="_isallowedProgramSettings('read')" class="btn btn-sm btn-light program-settings-btn" @click.prevent="toggleAdminView" style="cursor: pointer">
       <h6> <i class="far fa-cog"></i> Program Settings </h6>
      </button>  
      <!-- </router-link> -->
  </div>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
import Loader from "./loader";

export default {
  name: "ProjectSidebar",
  components: {
    Loader,
  },
  props: ["title", "currentFacility", "currentFacilityGroup", "currentContract", "currentContractGroup"],
   data() {
      return {
        value: '',
        totalGroupContract: 0,
        filteredGroupSize: null, 
        projectCount: 0
        
      }
    },
  computed: {
    ...mapGetters([
      "contentLoaded",
      'getShowAdminBtn',
      "currentProject",
      "getExpandedGroup",
      "facilities",
      'contracts',
      'projectContracts',
      "facilityGroups",
      'filteredContracts',
      "filteredFacilities",
      'getProjectGroupFilter',
      "filteredFacilityGroups",
      "facilityGroupFacilities",
       "facilityGroupContracts",
    ]),
   isContractsView() {
     return this.$route.name.includes("Sheet") || this.$route.name.includes("Contract")
    },
    programName() {
      if (
        this.contentLoaded &&
        (this.currentProject !== null || this.currentProject !== undefined)
      ) {
        return this.currentProject.name;
      }
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
      } if (url.includes("issues")) {
        return "/issues";
      } if (url.includes("analytics")) {
        return "/analytics";
      } if (this.$route.name === "ContractRisks") {
        return "/risks";
      } if (this.$route.name === "SheetRisks") {
        return "/risks";
      } if (url.includes("lessons")) {
        return "/lessons";
      } if (url.includes("notes")) {
        return "/notes";
      } if (url.includes("kanban")) {
        return "/tasks";
      } if (url.includes("calendar")) {
        return "/tasks";
      } else return "/"
    },
  },
  methods: {
   ...mapMutations(['setProjectGroupFilter', 'setShowAdminBtn', 'SET_EXPANDED_GROUP']), 
   ...mapActions(["createContract", "updateContract"]),
     expandFacilityGroup(group) {
       if (this.currentContract && this.currentFacility == {}) {
         group = this.currentContract.facilityGroup.id
       }
      this.$emit("on-expand-facility-group", group);

    },
    // log(e){
    //       console.log(e)

    // },
    _isallowedContracts(c, salut) {
      // console.log(this.$route)
        return this.checkPrivileges("ProjectSidebar", salut, this.$route, {method: "isallowedContracts", contract_id: c.projectContractId})
    },
    _isallowedProjects(c, salut) {
        return this.checkPrivileges("ProjectSidebar", salut, this.$route, {method: "isallowedProject", facility_project_id: c.facilityProjectId})
    },
    _isallowedProjectCounts(c, salut) {
      if (c) {
        let group = this.sortedGroups.map(t => t)
       console.log(this.facilityGroupFacilities(group).projects.a)
          // console.log(group)
      }


      //  this.checkPrivileges("ProjectSidebar", salut, this.$route, {method: "isallowedProject", facility_project_id: c.map(t => t.facilityProjectId)})
    },
    _isallowedProgramSettings(salut) {
        return this.checkPrivileges("ProjectSidebar", salut, this.$route, {method: "isallowedProgramSettings"})
    },
    toggleAdminView() {
      window.location.pathname = `/programs/${this.$route.params.programId}/settings`
        // this.setShowAdminBtn(!this.getShowAdminBtn);
        //  this.$router.push(
        // `/programs/${this.$route.params.programId}/settings`
        // );

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
        this.SET_EXPANDED_GROUP("")
        this.$router.push(
          `/programs/${this.$route.params.programId}/${this.tab}`
        );
      }
    },
  },
 
  mounted() {
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
        if (this.currentFacility && !this.$route.params.contractId && this.currentFacilityGroup ){             
          this.SET_EXPANDED_GROUP(this.currentFacilityGroup.id)
        }
         if (this.currentContract && !this.$route.params.projectId && this.currentContractGroup) {
           console.log(this.currentContract)
             console.log(this.currentContractGroup)
          this.SET_EXPANDED_GROUP(this.currentContractGroup.id)
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
  
  .stick {
    position: fixed;
    z-index: 1;
    color:#fff;
    max-width: 15%;
    background-color: #DD9036;
  }
  .stick:hover {
    background-color: #8f510b;
  }
  .programNameDiv {
    box-shadow: 0 2.5px 2.5px rgba(0, 0, 0, 0.19), 0 3px 3px rgba(0, 0, 0, 0.23);
    line-height: 1.2;
   display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;  
  overflow: hidden;
  &:hover
  {
    display: -webkit-box;
    -webkit-line-clamp: unset;
  }
    cursor: pointer;
    &.active {
      background-color: red !important;
      color: #007bff;
    }
  }
  .programNameDiv:hover {
    background-color: #8f510b;
  }
  .fac-name {
    border-bottom: solid lightgray 0.5px;
    border-radius: 2px;
    margin: 1px;
    cursor: pointer;
  }
  .groupName{
    overflow: hidden;
    // white-space: nowrap; /* Don't forget this one */
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
  .expandText {
    text-overflow: ellipsis;
    overflow : hidden;
    // white-space: nowrap;

  }
}
</style>
