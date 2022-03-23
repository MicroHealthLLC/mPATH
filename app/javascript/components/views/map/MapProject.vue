
<template>
<!-- THIS FILE HAS BEEN DEPRECATED AND REPLACED WITH SheetProject component.
  If not required, delete this file after 1FEB2022.  -JR -->
 <div id="facility-sheets" data-cy="facility_sheets">
    <div v-if="contentLoaded" class="position-sticky">
      <div>
        <div>
          <div v-if="_isallowed('read')" class="container-fluid px-0 mx-1">            
       
                 <div class="row row-1 mt-2">
    
              <div class="col-10 px-3">
                <div class="box-card my-el-card p-3" style="position:relative">
                  <div class="row">
                    <div class="col-7">
                      <p>PROJECT GROUP:</p>
                      <p>COMPLETION DATE:</p>
                      <p>
                        STATUS:
                        <span>
                          <small
                            v-if="!facility.statusId && _isallowed('write')"
                            class="ml-2 d-inline text-danger"
                            style="position:absolute"
                          >
                            Must be updated before you can enter a Completion
                            Date!
                          </small>
                        </span>
                      </p>
                    </div>

                    <div class="col-5">
                      <p
                       v-if="facility && facility.facility"
                        class="badge badge-secondary badge-pill font-weight-light"
                      >
                        {{ facility.facility.facilityGroupName }}
                      </p>
                      <div class="simple-select">
                        <v2-date-picker
                          v-model="dueDate"
                          value-type="YYYY-MM-DD"
                          format="DD MMM YYYY"
                          class="w-100 vue2-datepicker"
                          @input="onChange"
                          placeholder="DD MM YYYY"
                          :disabled="!_isallowed('write') || !facility.statusId"
                        />
                      </div>

                      <div class="el-dropdown-wrapper my-2">
                        <el-select
                          v-model="statusId"
                          track-by="id"
                          class="w-100"
                          @change="onChange"
                          :disabled="!_isallowed('write')"
                          placeholder="Select Project Status"
                        >
                          <el-option
                            v-for="item in statuses"
                            :label="item.name"
                            :key="item.id"
                            :value="item.id"
                          >
                          </el-option>
                        </el-select>
                      </div>
                    </div>
                  </div>
                  <button
                    v-if="_isallowed('write') && DV_updated"
                    class="btn btn-secondary mt-2 btn-sm apply-btn w-100"
                    @click="updateFacility"
                    :disabled="!DV_updated"
                  >
                    Apply
                  </button>
                </div>
              </div>  
              <div
               v-if="project"
                class="col-10 px-3"
                data-cy="date_set_filter"
              >
                <el-card class="box-card" style="background-color: #fafafa">
                  <div class="row">
                    <div class="col pb-0">
                      <h5 class="d-inline" style="font-weight: 600">CONTACT</h5>                     
                    </div>
                  </div>
                  <div class="row">
                    <div class="col font-sm">
                      <p class="mt-1 mb-0">
                        <span class="fbody-icon mr-2"
                          ><i class="far fa-id-badge"></i
                        ></span>
                        <!-- <span v-if="facility && facility.facility.pointOfContact">
                          {{ facility.facility.pointOfContact }}
                        </span> -->
                        <span class="d-inline">
                          <el-input
                            v-model="project.pointOfContact"
                            placeholder="Enter Point of Contact name"
                            name="Poc"
                            class="w-75"
                          />
                        </span>
                      </p>
                      <p class="mt-1 mb-0" v-if="project && project.address">
                        <span class="fbody-icon"
                          ><i class="fas fa-map-marker"></i
                        ></span>
                        <span>{{ project.address || "N/A" }}</span>
                      </p>
                      <p class="mt-1 mb-0">
                        <span class="fbody-icon mr-1"
                          ><i class="fas fa-phone"></i
                        ></span>
                        <!-- <span v-if="facility && facility.facility.phoneNumber !== null">
                          {{ facility.facility.phoneNumber }}
                        </span> -->
                         <span class="d-inline">
                          <el-input
                            v-model="project.phoneNumber"
                            placeholder="Enter Point of Contact phone number"
                            name="phoneNo"
                            class="w-75"
                          />
                        </span>
                      </p>
                      <p class="mt-1">
                        <span class="fbody-icon"
                          ><i class="far fa-envelope"></i
                        ></span>
                        <!-- <span  v-if=" facility && facility.facility.email">
                          {{ facility.facility.email  }}
                        </span> -->
                         <span class="d-inline">
                          <el-input
                            v-model="project.email"
                            placeholder="Enter Point of Contact email"
                            name="email"
                            class="w-75"
                          />
                        </span>


                      </p>
                    </div>
                  </div>                
                    <button 
                      :disabled="!project.pointOfContact"
                      :class="{'d-none': edit}"
                     class="btn btn-sm bg-primary text-light px-2 py-0 updateBtn"
                     @click.prevent="updateContactInfo">Save</button>
                     <button 
                      :class="{'d-none': !edit}"
                     class="btn btn-sm bg-dark text-light px-2 py-0 updateBtn"
                     @click.prevent="editBtn">Update</button>
                    <!-- <button class="btn btn-sm mh-blue text-light px-2 py-0 updateBtn" @click.prevent="updateContactInfo">Edit</button> -->
                
                </el-card>
              </div>
             </div>
                     
          </div>
          <div v-else class="text-danger mx-2 my-4">
            You don't have permission to read!
          </div>
        </div>
      </div>
    </div>
    <div v-else></div>
  </div>
</template>

<script>
import axios from "axios";
import http from "../../../common/http";
import { mapGetters, mapMutations, mapActions } from "vuex";
import Loader from "../../shared/loader";
import FormTabs from "../../shared/FormTabs.vue";
import {API_BASE_PATH} from './../../../mixins/utils'

export default {
  name: "MapProject",
  components: {
    Loader,
    FormTabs
  },
  props: ["facility"],
  data() {
    return {
      dueDate: "",
      edit: true,
      statusId: 0,
      loading: true,
      DV_updated: false,
      notesQuery: "",
      today: new Date().toISOString().slice(0, 10),
      _selected: null,
      _categories: null,
    };
  },
  mounted() {
    if (Vue.prototype.$preferences.sub_navigation_menu) {
      this.currentTab = Vue.prototype.$preferences.sub_navigation_menu;
    }
    if (this.contentLoaded) {
      this.dueDate = this.facility.dueDate;
      this.statusId = this.facility.statusId;
    }
  },
  methods: {
    ...mapActions(["fetchCurrentProject"]),
    ...mapMutations(["setTaskTypeFilter", "updateFacilityHash", "setContactInfoForm"]),
    updateFacility(e) {
      if (e.target) e.target.blur();
      if (!this._isallowed("write") || !this.DV_updated) return;
      this.DV_updated = false;
      let data = {
        statusId: this.statusId,
        dueDate: this.dueDate,
      };
      // Used to update state
      let updatedFacility = Object.assign(this.facility, {
        statusId: this.statusId,
        dueDate: this.dueDate,
        projectStatus: this.statuses.find(
          (status) => status.id === this.statusId
        ).name,
      });

      http
        .put(
          `${API_BASE_PATH}/programs/${this.currentProject.id}/projects/${this.$route.params.projectId}.json`,
          data
        )
        .then((res) => {
          this.updateFacilityHash(updatedFacility);
          if (res.status === 200) {
            this.$message({
              message: `${res.data.facility.facilityName} was saved successfully.`,
              type: "success",
              showClose: true,
            });
          }
        })
        .catch((err) => {
          console.error(err);
        });
    },
      editBtn(){
      this.edit = false
    },
    updateContactInfo() {
      let formData = new FormData();
          formData.append("facility[point_of_contact]", this.project.pointOfContact);  
          formData.append("facility[phone_number]", this.project.phoneNumber);
          formData.append("facility[email]",this.project.email);
    
      // formData.append("commit", "Update Project");
      // let url = `/admin/facilities/${this.$route.params.projectId}`;
      let url = `${API_BASE_PATH}/programs/${this.$route.params.programId}/projects/${this.$route.params.projectId}`; 
      let method = "PUT";
      axios({
        method: method,
        url: url,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      }).then((response) => {
        if (response.status === 200) {
          this.$message({
            message: `Edits has been saved successfully.`,
            type: "success",
            showClose: true,
          });
          this.fetchCurrentProject(this.$route.params.programId)
          this.edit = true
        }
      });
    },
    isBlockedStatus(status) {
      return (
        status &&
        status.name.toLowerCase().includes("complete") &&
        this.facility.progress < 100
      );
    },
    onChange() {
      this.$nextTick(() => {
        this.DV_updated = true;
      });
    },
   _isallowed(salut) {
    var programId = this.$route.params.programId;
    var projectId = this.$route.params.projectId
    let fPrivilege = this.$projectPrivileges[programId][projectId]
    let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    let s = permissionHash[salut]
    return  fPrivilege.overview.includes(s);      
    },
  },
  computed: {
    ...mapGetters([
      "getTaskIssueUserFilter",
      "filterDataForAdvancedFilter",
      "taskTypes",
      "contentLoaded",
      "currentProject",
      "projectLessons",
      "taskTypeFilter",
      "issueTypeFilter",
      "riskStageFilter",
      "issueSeverityFilter",
      "getRiskPriorityLevelFilter",
      "taskStageFilter",
      "issueStageFilter",
      "riskStageFilter",
      "statuses",
      "myActionsFilter",
      "onWatchFilter",
      "facilities",
    ]),
    selectedStatus: {
      get() {
        return this.facility.statusId;
      },
      set(value) {
        this.$data._selected = value;

        if (value) {
          this.$nextTick(() => {
            this.DV_updated = true;
          });
          this.facility.statusId = value;
        }
      },
    },
    project(){
      if (this.facility){
        return this.facility.facility
      }
    },
    C_taskTypeFilter: {
      get() {
        return this.taskTypeFilter;
      },
      set(value) {
        this.setTaskTypeFilter(value);
      },
    },
    C_myTasks: {
      get() {
        return _.map(this.myActionsFilter, "value").includes("tasks");
      },
    },
    C_myIssues: {
      get() {
        return _.map(this.myActionsFilter, "value").includes("issues");
      },
    },
    C_onWatchTasks: {
      get() {
        return _.map(this.onWatchFilter, "value").includes("tasks");
      },
    },
    C_onWatchIssues: {
      get() {
        return _.map(this.onWatchFilter, "value").includes("issues");
      },
    },
    viableTasksForProgressTotal(){
      return this.filteredTasks.filter(t => t.draft == false && t.onHold == false  && t.ongoing == false )
    },
     viableIssuesForProgressTotal(){
      return this.filteredIssues.filter(issue => issue.draft == false && issue.onHold == false)
    },
     viableRisksForProgressTotal(){
      return this.filteredRisks.filter(r => r.draft == false && r.onHold == false  && r.ongoing == false )
    },
   allTasksProgress() {
      let task = new Array();
      let group = _.groupBy(this.viableTasksForProgressTotal, "id");
      for (let ids in group) {
        task.push({
          id: ids,  
          // text: text,      
          progress: Number((_.meanBy(group[ids], "progress") || 0).toFixed(0)),
        });
      }
      let total = task.map(t => t.progress);
      let count = task.map(t => t).length;

      let sum = total.reduce(( accumulator, currentValue ) => accumulator + currentValue, 0)

     let roundedSum = Math.round(sum)
     let final = roundedSum / count
    
       if (isNaN(final)) {
        return 0
      } else return final 
    },
  },
  watch: {
    contentLoaded: {
      handler() {
        this.dueDate = this.facility.dueDate;
        this.statusId = this.facility.statusId;
      },
    },
  },
};
</script>

<style lang="scss" scoped>
.apply-btn,
.red,
.orange,
.green,
.grey,
.grey2,
.yellow {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.pg-content {
  width: 100%;
  height: 20px;
  font-size: 14px;
  font-weight: bold;
}
.vue2-datepicker /deep/ .mx-input:disabled {
  color: #555;
  background-color: #fff;
}
.simple-select /deep/ .multiselect {
  .multiselect__placeholder {
    text-overflow: ellipsis;
  }
}
.grey {
  background-color: lightgray;
}
.grey2 {
  background-color: #ededed;
}
.yellow {
  background-color: yellow;
}
.orange {
  background-color: #f0ad4e;
}
.green {
  background-color: rgb(92, 184, 92);
}
.red {
  background-color: #d9534f;
}
.red,
.orange,
.green,
.grey {
  color: white;
  border-radius: 3px;
}
.grey2 {
  border-radius: 3px;
}
.risk-card-title {
  font-size: 1rem;
}
.font-12 {
  font-size: 12px;
}
.underline {
  text-decoration: underline;
}
.smallerFont {
  font-size: 10px;
}
/deep/.el-collapse-item__header, /deep/.el-collapse-item__wrap  {
  border-bottom: none !important;
}

/deep/.el-card__body {
    padding-bottom: 0 !important;
}
/deep/.el-collapse-item__header {
  font-size: 2rem;
  }

/deep/.el-collapse-item__arrow, /deep/.el-icon-arrow-right {
  display: none;
}
.giantNumber {
  font-size: 2.75rem;
}

.lessonsCard {
  /deep/.el-card__body{
    min-height: 161px;
  }
}
.hide {
  visibility: hidden;
}
.relative {
  position: relative;
}
.absolute {
  position: absolute;
  top:7%;
  left:0;
}

.progressLabel {
  position: absolute;
}
.pill {
  position: absolute;
  top: 10%;
  right: 3%;
}

.filterDiv {
  position: absolute;
  top: -8%;
  right: 9.5%;
  width: 40%;
  border-radius: 4px; 
  border: .5px solid lightgray;
  overflow-y: auto;

}
.filterLabel {
  position: fixed;
}
.my-el-card {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}
.updateBtn{
  position: absolute;
  right: 24px;
  bottom: 20px
}
.filterCol {
  height: 70px;
}

</style>

