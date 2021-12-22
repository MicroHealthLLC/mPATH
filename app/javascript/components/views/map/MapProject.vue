
<template>
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
import {API_BASE_PATH} from './../../../mixins/utils'

export default {
  name: "MapProject",
  components: {
    Loader,
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
     this.fetchProjectLessons(this.$route.params);
    if (Vue.prototype.$preferences.sub_navigation_menu) {
      this.currentTab = Vue.prototype.$preferences.sub_navigation_menu;
    }
    if (this.contentLoaded) {
      this.dueDate = this.facility.dueDate;
      this.statusId = this.facility.statusId;
    }
  },
  methods: {
    ...mapActions(["fetchProjectLessons"]),
    ...mapMutations(["setTaskTypeFilter", "updateFacilityHash"]),
    updateFacility(e) {
      if (e.target) e.target.blur();
      if (!this._isallowed("write") || !this.DV_updated) return;
      this.DV_updated = false;
      let data = {
        facility: {
          statusId: this.statusId,
          dueDate: this.dueDate,
        },
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
    allRisksProgress() {
      let risk = new Array();
      let group = _.groupBy(this.viableRisksForProgressTotal, "id");
      for (let ids in group) {
        risk.push({
          id: ids,  
          // text: text,      
          progress: Number((_.meanBy(group[ids], "progress") || 0).toFixed(0)),
        });
      }
      let total = risk.map(r => r.progress);
      let count = risk.map(r => r).length;

      let sum = total.reduce(( accumulator, currentValue ) => accumulator + currentValue, 0)
      let roundedSum = Math.round(sum)

       let final = roundedSum / count
    
       if (isNaN(final)) {
        return 0
      } else return final 
  
    },
    allIssuesProgress() {
      let issue = new Array();
      let group = _.groupBy(this.viableIssuesForProgressTotal, "id");
      for (let ids in group) {
        issue.push({
          id: ids,  
          // text: text,      
          progress: Number((_.meanBy(group[ids], "progress") || 0).toFixed(0)),
        });
      }
      let total = issue.map(iss => iss.progress);
      let count = issue.map(iss => iss).length;
      
      let sum = total.reduce(( accumulator, currentValue ) => accumulator + currentValue, 0)
      let roundedSum = Math.round(sum)
      let final = roundedSum / count
      if (isNaN(final)) {
        return 0
      } else return final 
    },
    projectTotalProgress(){
      let sum = this.allTasksProgress + this.allRisksProgress + this.allIssuesProgress
      let total = sum / 3
      return Math.round(total)
    },  
    filteredTasks() {
      let typeIds = _.map(this.taskTypeFilter, "id");
      let stageIds = _.map(this.taskStageFilter, "id");
      let taskIssueUsers = this.getTaskIssueUserFilter;

      return _.filter(this.facility.tasks, (resource) => {
        let valid = true;
        let userIds = [
          ..._.map(resource.checklists, "userId"),
          ...resource.userIds,
        ];

        if (taskIssueUsers.length > 0) {
          if (taskIssueUsers.length > 0) {
            valid =
              valid &&
              userIds.some(
                (u) => _.map(taskIssueUsers, "id").indexOf(u) !== -1
              );
          }
        }
        //TODO: For performance, send the whole tasks array instead of one by one
        valid =
          valid &&
          this.filterDataForAdvancedFilter([resource], "facilityShowTasks");

        if (stageIds.length > 0)
          valid = valid && stageIds.includes(resource.taskStageId);
        if (typeIds.length > 0)
          valid = valid && typeIds.includes(resource.taskTypeId);
        return valid;
      });
    },
    taskStats() {
      let tasks = new Array();
      let group = _.groupBy(this.filteredTasks, "taskType");
      for (let type in group) {
        tasks.push({
          name: type,
          count: group[type].length,
          progress: Number((_.meanBy(group[type], "progress") || 0).toFixed(0)),
        });
      }
      return tasks;
    },
    // TODO: Move this calculation to back-end so that statistics can be available for other devices
  taskVariation() {
      let planned = _.filter(
        this.filteredTasks,
        (t) => t && t.planned == true 
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let taskDrafts = _.filter(
        this.filteredTasks,
        (t) => t && t.draft == true   
      );      
      let completed = _.filter(
        this.filteredTasks,
        (t) => t && t.completed == true
      );
      let completed_percent = this.getAverage(
        completed.length,
        this.filteredTasks.length
      );
      let inProgress = _.filter(
        this.filteredTasks,
        (t) => t && t.inProgress == true
      );
     let onHoldT = _.filter(
        this.filteredTasks,
        (t) => t && t.onHold == true 
      );
      let inProgress_percent = this.getAverage(
        inProgress.length,
        this.filteredTasks.length
      );
      let overdue = _.filter(this.filteredTasks, (t) => t && t.isOverdue);
      let overdue_percent = this.getAverage(
        overdue.length,
        this.filteredTasks.length
      );
      let ongoing = _.filter(this.filteredTasks, (t) => t && t.ongoing );
      let ongoingClosed = _.filter(this.filteredTasks, (t) => t && t.closed );
      return {
        planned: {
          count: planned.length, 
          plannedTs: planned            
        },
        onHoldT: {
          count: onHoldT.length,          
        },
        taskDrafts: {
          count: taskDrafts.length,          
        },
        completed: {
          count: completed.length,
          percentage: Math.round(completed_percent),
        },
      
        inProgress: {
          count: inProgress.length - planned.length,
          percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          percentage: Math.round(overdue_percent),
        },
        ongoingClosed: {
          count: ongoingClosed.length,         
        },
        ongoing,       
    
      };
    },
    filteredIssues() {
      let taskTypeIds = _.map(this.taskTypeFilter, "id");
      let typeIds = _.map(this.issueTypeFilter, "id");
      let severityIds = _.map(this.issueSeverityFilter, "id");
      let stageIds = _.map(this.issueStageFilter, "id");
      let taskIssueUsers = this.getTaskIssueUserFilter;

      return _.filter(this.facility.issues, (resource) => {
        let valid = true;
        let userIds = [
          ..._.map(resource.checklists, "userId"),
          ...resource.userIds,
        ];

        if (taskIssueUsers.length > 0) {
          if (taskIssueUsers.length > 0) {
            valid =
              valid &&
              userIds.some(
                (u) => _.map(taskIssueUsers, "id").indexOf(u) !== -1
              );
          }
        }
        //TODO: For performance, send the whole tasks array instead of one by one
        valid =
          valid &&
          this.filterDataForAdvancedFilter([resource], "facilityShowIssues");

        if (taskTypeIds.length > 0)
          valid = valid && taskTypeIds.includes(resource.taskTypeId);
        if (typeIds.length > 0)
          valid = valid && typeIds.includes(resource.issueTypeId);
        if (severityIds.length > 0)
          valid = valid && severityIds.includes(resource.issueSeverityId);
        if (stageIds.length > 0)
          valid = valid && stageIds.includes(resource.issueStageId);
        return valid;
      });
    },
    issueStats() {
      let issues = new Array();
      let group = _.groupBy(this.filteredIssues, "issueType");
      for (let type in group) {
        issues.push({
          name: type,
          count: group[type].length,
          progress: Number((_.meanBy(group[type], "progress") || 0).toFixed(0)),
        });
      }
      return issues;
    },
    issueTaskCATEGORIES() {
      let issues = new Array();
      let group = _.groupBy(this.filteredIssues, "taskTypeName");
      for (let type in group) {
        if (!type || type == "null") continue;
        issues.push({
          name: type,
          count: group[type].length,
          progress: Number((_.meanBy(group[type], "progress") || 0).toFixed(0)),
        });
      }
      return issues;
    },
    // TODO: Move this calculation to back-end so that statistics can be available for other devices
    issueVariation() {
     let planned = _.filter(
        this.filteredIssues,
        (t) => t.planned == true  
      );     
      let issueDrafts = _.filter(
        this.filteredIssues,
         (t) => t && t.draft == true 
      );      
      let completed = _.filter(
        this.filteredIssues,
        (t) => t && t.completed == true
      );
      let completed_percent = this.getAverage(
        completed.length,
        this.filteredIssues.length
      ); 
       let inProgress = _.filter(
        this.filteredIssues,
        (t) => t && t.inProgress == true 
        );
      let onHoldI = _.filter(
        this.filteredIssues,
        (t) => t && t.onHold == true 
      );
      let inProgress_percent = this.getAverage(
        inProgress.length,
        this.filteredIssues.length
      );
      let overdue = _.filter(this.filteredIssues, (t) => t && t.isOverdue);
      let overdue_percent = this.getAverage(
        overdue.length,
        this.filteredIssues.length
      );
      return {
        planned: {
          count: planned.length,          
        },
        onHoldI: {
          count: onHoldI.length,          
        },
        issueDrafts: {
          count: issueDrafts.length,          
        },
        completed: {
          count: completed.length,
          percentage: Math.round(completed_percent),
        },
        inProgress: {
          count: inProgress.length,
          percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          percentage: Math.round(overdue_percent),
        },
      };
    },
    filteredRisks() {
      let typeIds = _.map(this.taskTypeFilter, "id");
      let riskPriorityLevelIds = _.map(this.getRiskPriorityLevelFilter, "id");
      let stageIds = _.map(this.riskStageFilter, "id");
      let riskApproachIds = _.map(this.C_riskApproachFilter, "id");
      let taskIssueUsers = this.getTaskIssueUserFilter;

      return _.filter(this.facility.risks, (resource) => {
        let valid = true;
        let userIds = [
          ..._.map(resource.checklists, "userId"),
          ...resource.userIds,
        ];

        if (taskIssueUsers.length > 0) {
          if (taskIssueUsers.length > 0) {
            valid =
              valid &&
              userIds.some(
                (u) => _.map(taskIssueUsers, "id").indexOf(u) !== -1
              );
          }
        }
        //TODO: For performance, send the whole tasks array instead of one by one
        valid =
          valid &&
          this.filterDataForAdvancedFilter([resource], "facilityShowTasks");

        if (stageIds.length > 0)
          valid = valid && stageIds.includes(resource.riskStageId);
        if (typeIds.length > 0)
          valid = valid && typeIds.includes(resource.taskTypeId);
        if (riskApproachIds.length > 0)
          valid = valid && riskApproachIds.includes(resource.riskApproach);
        return valid;
      });
    },
    riskPriorityLevels() {
      let grey = _.filter(
        this.filteredRisks,
        (t) => t && t.priorityLevelName && t.priorityLevelName == "Very Low"
      );
      let green = _.filter(
        this.filteredRisks,
        (t) => t && t.priorityLevelName && t.priorityLevelName == "Low"
      );
      let yellow = _.filter(
        this.filteredRisks,
        (t) => t && t.priorityLevelName && t.priorityLevelName == "Moderate"
      );
      let orange = _.filter(
        this.filteredRisks,
        (t) => t && t.priorityLevelName && t.priorityLevelName == "High"
      );
      let red = _.filter(
        this.filteredRisks,
        (t) => t && t.priorityLevelName && t.priorityLevelName == "Extreme"
      );
      return {
        grey: grey.length,
        green: green.length,
        yellow: yellow.length,
        orange: orange.length,
        red: red.length,
      };
    },
    // TODO: Move this calculation to back-end so that statistics can be available for other devices
   riskVariation() {
     let planned = _.filter(
        this.filteredRisks,
        (t) => t && t.planned == true     
      );  
      let riskDrafts = _.filter(
        this.filteredRisks,
        (t) => t && t.draft == true  
      ); 
      let completed = _.filter(
        this.filteredRisks,
        (t) => t && t.completed == true
      );
      let inProgress = _.filter(
        this.filteredRisks,
        (t) => t && t.inProgress == true 
      );
      let onHoldR = _.filter(
        this.filteredRisks,
        (t) => t && t.onHold == true 
      );  
 
      let completed_percent = this.getAverage(
        completed.length,
        this.filteredRisks.length
      );
      let inProgress_percent = this.getAverage(
        inProgress.length,
        this.filteredRisks.length
      );
      let overdue = _.filter(this.filteredRisks, (t) => t && t.isOverdue);
      let overdue_percent = this.getAverage(
        overdue.length,
        this.filteredRisks.length
      );
      let ongoing = _.filter(this.filteredRisks, (t) => t && t.ongoing);
      let ongoingClosed = _.filter(this.filteredRisks, (t) => t && t.closed);
      return {
        planned: {
          count: planned.length,          
        },
        onHoldR: {
          count: onHoldR.length,          
        },
        riskDrafts: {
          count: riskDrafts.length,          
        },
        completed: {
          count: completed.length,
          percentage: Math.round(completed_percent),
        },
        inProgress: {
          count: inProgress.length,
          percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          percentage: Math.round(overdue_percent),
        },
        ongoingClosed: {
          count: ongoingClosed.length,         
        },
        ongoing
      };
    },
    currentRiskTypes() {
      let names =
        this.taskTypeFilter &&
        this.taskTypeFilter.length &&
        _.map(this.taskTypeFilter, "name");
      let taskTypes = new Array();
      for (let type of this.taskTypes) {
        let risks = _.filter(
          this.filteredRisks,
          (t) => t.taskTypeId == type.id
        );
        taskTypes.push({
          name: type.name,
          _display:
            risks.length > 0 && (names ? names.includes(type.name) : true),
          length: risks.length,
          progress: Number(_.meanBy(risks, "progress").toFixed(0)),
        });
      }
      return taskTypes;
    },
    lessonVariation() {
      let completes = this.projectLessons.filter(l => !l.draft )
       let drafts = this.projectLessons.filter(l => l.draft)
      return {
        completes,
        drafts
      }
    },
    lessonStats() {
      let lessons = new Array();
      let group = _.groupBy(this.projectLessons, "category");
      for (let type in group) {
        lessons.push({
          name: type,
          count: group[type].length,
        });
      }
      return lessons;
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

