<!--  NOTE: This file is used in Sheets view as overview tab -->
<template>
  <div id="facility-show"  data-cy="facility_sheets" class="px-3"  v-loading="!contentLoaded" >
    <div  class="position-sticky" >
      <div class="d-flex align-items-center my-2">
        <span class="fbody-icon"><i class="fas fa-building"></i></span>
        <h4 class="f-head mb-0">{{DV_facility.facilityName}}</h4>
      </div>
      <div class="facility-tab mb-2">
        <custom-tabs :current-tab="currentTab" :tabs="tabs" @on-change-tab="onChangeTab" class="custom-tab"/>
      </div>
      <div>
        <div v-if="currentTab == 'overview'">
          <div v-if="_isallowed('read')" class="container-fluid px-0 mx-0">
            <!-- <div v-if="extras"><h3>Project Overview</h3></div> -->
            <!-- <div v-if="isMapView" class="container-fluid px-0 mx-0">
            <h1> LOOK AT ME</h1>

            </div> -->

          <div class="row row-1 mt-2">
          <div class="col-md-8 pr-0">
            <div class="box-card my-el-card p-3" style="position:relative">               

             <div class="row">
                <div class="col-5 font-weight-bold">                
                  <p>Project Group:</p>
                  <p>Completion Date: </p>               
                  <p>Status:
                    <span>
                      <small v-if="!DV_facility.statusId && _isallowed('write')" 
                             class="ml-2 d-inline text-danger" style="position:absolute;font-size:60%">
                             Must be updated before you can enter a Completion Date!
                      </small>
                   </span>
                  </p>                    
                            
                </div>

                <div class="col-7">            
                 <p class="badge badge-secondary badge-pill font-weight-light"> {{facilityGroup.name}}</p>
                 <div class="simple-select">
                  <v2-date-picker
                    v-model="DV_facility.dueDate"
                    value-type="YYYY-MM-DD"
                    format="DD MMM YYYY"
                    class="w-100 vue2-datepicker"
                    @input="onChange"
                    placeholder="DD MM YYYY"
                    :disabled="!_isallowed('write') || !DV_facility.statusId"
                  />
                 </div>
                               
                   <div class="mt-2">                
                     <el-select 
                      v-model="selectedStatus"  
                      track-by="id" 
                      class="w-100"                     
                      :disabled="!_isallowed('write')"                                                                       
                      placeholder="Select Project Status"
                      filterable
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
               <button v-if="_isallowed('write') && DV_updated" class="btn btn-secondary mt-1 btn-sm apply-btn w-100" @click="updateFacility" :disabled="!DV_updated">Apply</button>             
               </div>     
             </div>  

        <div class="col-md-4 pr-3" data-cy="date_set_filter">         
          <el-card class="box-card" style="background-color:#fff">
            <div class="row">
              <div class="col">
                 <h5 class="d-inline">Progress</h5>               
                <hr>
                <p class="text-center">               
                    <span :class="{'progress-0': DV_facility.progress <= 0}">                
                     <el-progress type="circle" :percentage="DV_facility.progress"></el-progress>
                    </span>
                </p>
              </div>             
            </div>                           
         </el-card>     
       </div> 


         <!-- <div class="col-md-3 col-lg-3 col-sm-6" data-cy="date_set_filter">         
          <el-card class="box-card" style="background-color: #41b883; color:#fff">
            <div class="row">
              <div class="col">
                 <h5 class="d-inline">Filters</h5>               
                 <hr style="background-color: #fff; color:#fff">
              </div>             
            </div>

            <div v-for="filterArray in getAllFilterNames">              
                <span v-if="getFilterValue(filterArray[0])">                                         
                            <span><b class="mr-1">{{filterArray[1]}}:</b> {{getFilterValue(filterArray[0])}} </span>                    
                </span>            
            </div>                    
         </el-card>     
       </div> 

       <div class="col-md-2 col-lg-2 col-sm-6 pl-0" data-cy="date_set_filter">         
          <el-card class="box-card" style="background-color: #fafafa">
            <div class="row">
              <div class="col">
                 <h5 class="d-inline">Contact</h5>               
                 <hr class="mb-0 pb-0">
              </div>             
            </div>
              <div class="row">
                <div class="col font-sm">  
              <p class="mt-1">
                <span class="fbody-icon"><i class="far fa-id-badge"></i></span>
                <span>{{DV_facility.pointOfContact || 'N/A'}}</span>
              </p>      
              <p class="mt-0">
                <span class="fbody-icon"><i class="fas fa-map-marker"></i></span>
                <span>{{DV_facility.address || 'N/A'}}</span>
              </p>           
              <p class="my-0">
                <span class="fbody-icon"><i class="fas fa-phone"></i></span>
                <span>{{DV_facility.phoneNumber || 'N/A'}}</span>
              </p>
              <p class="my-0">
                <span class="fbody-icon"><i class="far fa-envelope"></i></span>
                <span>{{DV_facility.email || 'N/A'}}</span>
              </p>                    
                </div>
              </div>
                       
         </el-card>     
       </div>  -->
      </div> 
<!-- SECOND ROW WITH TASKS ISSUES & RISKS -->

<!-- Row 2, col-1 for Tasks Card -->
    <div class="row row-2 mt-2 task-issue-risk-row">

      <div class="col-md-6 pr-1" data-cy="facility_tasks">
         <el-card class="box-card" style="background-color:#fff">

            <div class="row">
              <div class="col"> 
                 <h5 class="d-inline"> <b>TASKS</b></h5>   
                 <h5 class="d-inline"> <b class="float-right badge badge-secondary badge-pill">{{filteredTasks.length}}</b></h5>                   
                <hr> 
              </div>             
            </div>
         
              <div class="row">
                  <div class="col">
                    <span>Complete</span>
                    <span class="badge badge-secondary badge-pill">{{taskVariation.completed.count}}</span>
                  </div>
                  <div class="col">
                    <span class="w-100 progress pg-content" :class="{'progress-0': taskVariation.completed.percentage <= 0}">
                      <div class="progress-bar bg-info" :style="`width: ${taskVariation.completed.percentage}%`">{{taskVariation.completed.percentage}} %</div>
                    </span>
                  </div>
              </div>  
              <div class="row">
                   <div class="col">
                      <span>Overdue</span>
                      <span class="badge badge-secondary badge-pill">{{taskVariation.overdue.count}}</span>
                   </div>
                   <div class="col">
                      <span class="w-100 progress pg-content" :class="{'progress-0': taskVariation.overdue.percentage <= 0}">
                        <div class="progress-bar bg-info" :style="`width: ${taskVariation.overdue.percentage}%`">{{taskVariation.overdue.percentage}} %</div>
                      </span>
                   </div>
                </div>       

        <div v-if="taskStats.length > 0" data-cy="task_categories">
                
          <el-collapse>
            <el-collapse-item title="Details" name="1">
                <div class="row mt-4 mb-1">
                 <div class="col text-center">
                      CATEGORIES 
                  </div>                
              </div>
              <div class="row font-sm" v-for="task in taskStats">           
                    <div class="col">
                      <span> {{task.name}}</span>
                      <span class="badge badge-secondary badge-pill">{{task.count}}</span>
                    </div>

                    <div class="col">
                      <span class="w-100 progress pg-content" :class="{ 'progress-0': task.progress <= 0 }">
                        <div class="progress-bar bg-info" :style="`width: ${task.progress}%`">{{task.progress}} %</div>
                      </span>
                    </div>
              </div>  
             </el-collapse-item>
          </el-collapse>   
          </div>

        </el-card>  
       </div>  
    


        <div class="col-md-6 mb-2 pl-1" data-cy="issues_summary">          
         <el-card class="box-card" style="background-color:#fff">
            <div class="row">
              <div class="col">
                 <h5 class="d-inline"> <b>ISSUES</b></h5>   
                 <h5 class="d-inline"> <b class="float-right badge badge-secondary badge-pill" >{{filteredIssues.length}}</b></h5>   
                <hr>
              </div>             
            </div>
                  
              <div class="row">
                    <div class="col">
                      <span>Complete</span>
                      <span class="badge badge-secondary badge-pill">{{issueVariation.completed.count}}</span>
                    </div>
                    <div class="col">
                      <span class="w-100 progress pg-content" :class="{'progress-0': issueVariation.completed.percentage <= 0}">
                      <div class="progress-bar bg-info" :style="`width: ${issueVariation.completed.percentage}%`">{{issueVariation.completed.percentage}} %</div>
                     </span>
                    </div>
              </div>     
              <div class="row">
                    <div class="col">
                      <span>Overdue</span>
                      <span class="badge badge-secondary badge-pill">{{issueVariation.overdue.count}}</span>
                    </div>
                    <div class="col">
                      <span class="w-100 progress pg-content" :class="{'progress-0': issueVariation.overdue.percentage <= 0}">
                        <div class="progress-bar bg-info" :style="`width: ${issueVariation.overdue.percentage}%`">{{issueVariation.overdue.percentage}} %</div>
                      </span>
                    </div>
              </div>

 <div v-if="filteredIssues.length" data-cy="issue_types" >
    <el-collapse>
      <el-collapse-item title="Details" name="1">          
              <div v-if="contentLoaded">
                <div class="row">
                  <div class="col mt-1 mb-2 text-center">
                   CATEGORIES
                  </div>
                </div>
                <div class="row"  v-for="(issue, index) in issueTaskCATEGORIES" :key="index">
                  <div class="col">
                    <span> {{issue.name}}</span>
                    <span class="badge badge-secondary badge-pill">{{issue.count}}</span>
                  </div>
                  <div class="col">
                    <span class="w-100 progress pg-content" :class="{'progress-0': issue.progress <= 0}">
                      <div class="progress-bar bg-info" :style="`width: ${issue.progress}%`">{{issue.progress}} %</div>
                    </span>
                  </div>
                </div>
              </div>             

             <div class="row">
               <div class="col mt-3 mb-1 text-center">
                       ISSUE TYPES 
               </div>                  
            </div>
            
             <div class="row mb-1 font-sm" v-for="issue in issueStats" :key="issue.id">          
                  <div class="col">
                    <span> {{issue.name}}</span>
                    <span class="badge badge-secondary badge-pill">{{issue.count}}</span>
                  </div>
                  <div class="col">
                    <span class="w-100 progress pg-content" :class="{'progress-0': issue.progress <= 0}">
                      <div class="progress-bar bg-info" :style="`width: ${issue.progress}%`">{{issue.progress}} %</div>
                    </span>
                  </div>
            </div>

      </el-collapse-item>
    </el-collapse>
 </div>
          <!-- TASK CATEGORIES FOR ISSUE INSIDE COLLAPSIBLE SECTION -->
         

         </el-card>     
       </div>  
</div>

<!-- Row 2, col-3 for Risks Card -->
<div class="row">
    <div class="col-md-12 mb-3" data-cy="facility_group_summary">               
         <el-card class="box-card" style="background-color:#fff">
            <div class="row">
              <div class="col">
                 <h5 class="d-inline"> <b>RISKS</b></h5>   
                 <h5 v-if="contentLoaded" class="d-inline"> <b class="float-right badge badge-secondary badge-pill" >{{filteredRisks.length}}</b></h5>   
                <hr>
              </div>             
            </div>

              <div v-if="contentLoaded">    
               <div class="row">
                    <div class="col">
                      <span>Complete</span>
                      <span class="badge badge-secondary badge-pill">{{riskVariation.completed.count}}</span>
                    </div>
                    <div class="col">
                      <span class="w-100 progress pg-content" :class="{'progress-0': riskVariation.completed.percentage <= 0}">
                      <div class="progress-bar bg-info" :style="`width: ${riskVariation.completed.percentage}%`">{{riskVariation.completed.percentage}} %</div>
                     </span>
                    </div>
              </div>     
              <div class="row">
                    <div class="col">
                      <span>Overdue</span>
                      <span class="badge badge-secondary badge-pill">{{riskVariation.overdue.count}}</span>
                    </div>
                    <div class="col">
                      <span class="w-100 progress pg-content" :class="{'progress-0': riskVariation.overdue.percentage <= 0}">
                        <div class="progress-bar bg-info" :style="`width: ${riskVariation.overdue.percentage}%`">{{riskVariation.overdue.percentage}} %</div>
                      </span>
                    </div>
              </div>





<!-- RISK CATEGORIES INSIDE COLLAPSIBLE SECTION -->
 <div v-if="filteredRisks.length" >
      <el-collapse>           
        <el-collapse-item title="Details" name="1">  
                     <div  class="row">
               <div class="col mt-3 mb-1 text-center">
                       CATEGORIES
               </div>                  
            </div>
             <div v-for="risk in currentRiskTypes" >
             <div class="row" v-if="risk._display">          
                  <div class="col">
                    <span> {{risk.name}}</span>
                    <span class="badge badge-secondary badge-pill">{{risk.length}}</span>
                  </div>
                  <div class="col">
                    <span class="w-100 progress pg-content" :class="{'progress-0': risk.progress <= 0}">
                      <div class="progress-bar bg-info" :style="`width: ${risk.progress}%`">{{risk.progress}} %</div>
                    </span>
                  </div>
            </div>
            </div> 

              <div class="row mt-3">
                  <div class="col text-center">
                   RISK PRIORITY LEVELS
                  </div>
              </div>            
            <div class="row font-sm">
                <div class="col text-center"> 
                  <p class="mb-2 grey2">Very Low </p>                
                  <p class="mb-2 green">Low </p>               
                  <p class="mb-2 yellow">Moderate </p>                         
                </div>
                <div class="col">  
                  <span class="my-2 badge w-50 badge-secondary badge-pill d-block">{{riskPriorityLevels.grey}}</span>
                  <span class="my-2 badge w-50 badge-secondary badge-pill d-block">{{riskPriorityLevels.green}}</span>
                  <span class="my-2 badge w-50 badge-secondary badge-pill d-block">{{riskPriorityLevels.yellow}}</span>                 
                </div>
                 <div class="col text-center">                
                  <p class="mb-2 orange">High</p>
                  <p class="mb-2 red">Extreme </p>                                        
                </div>
                <div class="col">                
                  <span class="my-2 badge w-50 badge-secondary badge-pill d-block">{{riskPriorityLevels.orange}}</span>
                 <span class="my-2 badge w-50 badge-secondary badge-pill d-block">{{riskPriorityLevels.red}}</span> 
                                       
                </div>
            </div>
          
  </el-collapse-item>
              </el-collapse>

 </div>
          
             
           

   

            </div>             

              
           </el-card>     
          </div> 
        </div>           
            </div>
              <div v-else class="text-danger mx-2 my-4">You don't have permission to read!</div>
          </div>
        
        </div>

        <div v-if="currentTab == 'notes'">
          <notes-index
            :facility="DV_facility"
            :from="from"
            @refresh-facility="refreshFacility"
          ></notes-index>
        </div>
        <div v-if="currentTab == 'tasks'">
          <detail-show
            :facility="DV_facility"
            :from="from"
            @refresh-facility="refreshFacility"
          ></detail-show>
        </div>
        <div v-if="currentTab == 'issues'">
          <issue-index
            :facility="DV_facility"
            :from="from"
            @refresh-facility="refreshFacility"
          ></issue-index>
        </div>
        <div v-if="currentTab == 'risks'">
          <risk-index
            :facility="DV_facility"
            :from="from"
            @refresh-facility="refreshFacility"
          ></risk-index>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import http from './../../../common/http'
  import DetailShow from './detail_show'
  import NotesIndex from './../notes/notes_index'
  import IssueIndex from './../issues/issue_index'
  import RiskIndex from './../risks/risk_index'
  import CustomTabs from './../../shared/custom-tabs'
  import Loader from './../../shared/loader'
  import {mapGetters, mapMutations, mapActions} from 'vuex'
  import {API_BASE_PATH} from './../../../mixins/utils'

  import MessageDialogService from "../../../services/message_dialog_service";

export default {
    name: 'FacilitiesShow',
    components: {
      DetailShow,
      NotesIndex,
      IssueIndex,
      RiskIndex,
      CustomTabs,
      Loader
    },
    props: {
      facility: {
        default: null,
        type: Object
      },
      facilityGroup: {
        default: null,
        type: Object
      },
      extras: {
        default: true,
        type: Boolean
      },
      from: {
        default: "",
        type: String
      }
    },
    data() {
      return {
        loading: true,
        DV_updated: false,
        notesQuery: '',
        DV_facility: Object.assign({}, this.facility),
        _selected: null,
        currentTab: 'overview',
        tabs: [
          {
            label: 'Overview',
            key: 'overview',
            closable: false
          },
          {
            label: 'Tasks',
            key: 'tasks',
            closable: false
          },
          {
            label: 'Issues',
            key: 'issues',
            closable: false
          },     
            {
            label: 'Risks',
            key: 'risks',
            closable: false
          },                
          {
            label: 'Notes',
            key: 'notes',
            closable: false
          },         
        ]
      }
    },
    mounted() {
      if (this.from == "manager_view") {
        this.loadFacility(this.facility)
      } else {
        this.getFacility()
      }

      if(Vue.prototype.$preferences.sub_navigation_menu){
        this.currentTab = Vue.prototype.$preferences.sub_navigation_menu
      }

    },
    methods: {
      ...mapMutations([
        'setTaskTypeFilter',
        'updateFacilityHash',
        'nullifyTasksForManager'
      ]),
      ...mapActions([
        'fetchFacility'
      ]),
      //TODO: change the method name of isAllowed
      _isallowed(salut) {
        return this.checkPrivileges("facility_show", salut, this.$route)

        // var programId = this.$route.params.programId;
        // var projectId = this.$route.params.projectId
        // let fPrivilege = this.$projectPrivileges[programId][projectId]
        // let permissionHash = {"write": "W", "read": "R", "delete": "D"}
        // let s = permissionHash[salut]
        // return  fPrivilege.tasks.includes(s); 
      },
      onChangeTab(tab) {
        this.currentTab = tab ? tab.key : 'overview'
      },
      loadFacility(facility) {
        this.DV_facility = Object.assign({}, facility)
        this._selected = this.statuses.find(s => s.id == this.DV_facility.statusId)
        this.loading = false
      },
      getFacility() {
        this.fetchFacility({projectId: this.currentProject.id, facilityId: this.DV_facility.id}).then(facility => {
          this.loadFacility(facility)
        }).catch((err) => {
          console.error(err)
        })
      },
      updateFacility(e) {
        if (e.target) e.target.blur()
        if (!this._isallowed('write') || !this.DV_updated) return
        this.DV_updated = false
        let data = {facility: {statusId: this.DV_facility.statusId, dueDate: this.DV_facility.dueDate}}
        http
          .put(`${API_BASE_PATH}/programs/${this.currentProject.id}/projects/${this.DV_facility.id}.json`, data)
          .then((res) => {
            this.DV_facility = {...res.data.facility, ...res.data.facility.facility}
            if (this.from == "manager_view") this.updateFacilityHash(this.DV_facility)
            this.$emit('facility-update', this.DV_facility)
            MessageDialogService.showDialog({
              response: res
            })
          })
          .catch((err) => {
            console.error(err);
          })
      },
      refreshFacility() {
        this.loading = true
        this.getFacility()
      },
      isBlockedStatus(status) {
        return status && status.name.toLowerCase().includes('complete') && this.DV_facility.progress < 100
      },
      onChange() {
        this.$nextTick(() => {
          this.DV_updated = true
        })
      }
    },
    computed: {
      ...mapGetters([
        'getTaskIssueUserFilter',
        'filterDataForAdvancedFilter',
        'riskPriorityLevelFilter',
        'getRiskPriorityLevelFilter',
        'taskTypes',
        'getAllFilterNames',
        'getFilterValue',
        'contentLoaded',
        'currentProject',
        'taskTypeFilter',
        'issueTypeFilter',
        'issueSeverityFilter',
        'taskUserFilter',
        'taskStageFilter',
        'issueStageFilter',
        'issueUserFilter',
        'statuses',
        'myActionsFilter',
        'onWatchFilter'
      ]),
      selectedStatus: {
        get () {
          return this.$data._selected || this.DV_facility.statusId
        },
        set (value) {       
          this.$data._selected = value
          // console.log(value)
          if (value) {
            this.$nextTick(() => {
              this.DV_updated = true
            })
            this.DV_facility.statusId = value
          }        
        }
      },
      C_taskTypeFilter: {
        get() {
          return this.taskTypeFilter
        },
        set(value) {
          this.setTaskTypeFilter(value)
        }
      },
      C_myTasks: {
        get() {
          return _.map(this.myActionsFilter, 'value').includes('tasks')
        }
      },
      C_myIssues: {
        get() {
          return _.map(this.myActionsFilter, 'value').includes('issues')
        }
      },
      C_onWatchTasks: {
        get() {
          return _.map(this.onWatchFilter, 'value').includes('tasks')
        }
      },
      C_onWatchIssues: {
        get() {
          return _.map(this.onWatchFilter, 'value').includes('issues')
        }
      },
      filteredTasks() {
        let typeIds = _.map(this.taskTypeFilter, 'id')
        let stageIds = _.map(this.taskStageFilter, 'id')
        let taskIssueUsers = this.getTaskIssueUserFilter

        return _.filter(this.DV_facility.tasks, (resource) => {
          let valid = true
          let userIds = [..._.map(resource.checklists, 'userId'), ...resource.userIds]

          if (taskIssueUsers.length > 0) {  
            if(taskIssueUsers.length > 0){
              valid = valid && userIds.some(u => _.map(taskIssueUsers, 'id').indexOf(u) !== -1)
            }
          }
          //TODO: For performance, send the whole tasks array instead of one by one
          valid = valid && this.filterDataForAdvancedFilter([resource], 'facilityShowTasks')

          if (stageIds.length > 0) valid = valid && stageIds.includes(resource.taskStageId)
          if (typeIds.length > 0) valid = valid && typeIds.includes(resource.taskTypeId)
          return valid
        })
      },
      taskStats() {
        let tasks = new Array
        let group = _.groupBy(this.filteredTasks, 'taskType')
        for (let type in group) {
          tasks.push({
            name: type,
            count: group[type].length,
            progress: Number((_.meanBy(group[type], 'progress') || 0).toFixed(0))
          })
        }
        return tasks
      },
      taskVariation() {
        let completed = _.filter(this.filteredTasks, (t) => t && t.progress && t.progress == 100)
        let completed_percent = this.getAverage(completed.length, this.filteredTasks.length)
        let overdue = _.filter(this.filteredTasks, (t) => t && t.isOverdue)
        let overdue_percent = this.getAverage(overdue.length, this.filteredTasks.length)

        return {
          completed: {count: completed.length, percentage: Math.round( completed_percent ) },
          overdue: {count: overdue.length, percentage: Math.round(  overdue_percent ) },
        }
      },
      filteredIssues() {
        let taskTypeIds = _.map(this.taskTypeFilter, 'id')
        let typeIds = _.map(this.issueTypeFilter, 'id')
        let severityIds = _.map(this.issueSeverityFilter, 'id')
        let stageIds = _.map(this.issueStageFilter, 'id')
        let taskIssueUsers = this.getTaskIssueUserFilter

        return _.filter(this.facility.issues, ((resource) => {
          let valid = true
          let userIds = [..._.map(resource.checklists, 'userId'), ...resource.userIds]

          if (taskIssueUsers.length > 0) {  
            if(taskIssueUsers.length > 0){
              valid = valid && userIds.some(u => _.map(taskIssueUsers, 'id').indexOf(u) !== -1)
            }
          }
          //TODO: For performance, send the whole tasks array instead of one by one
          valid = valid && this.filterDataForAdvancedFilter([resource], 'facilityShowIssues')

          if (taskTypeIds.length > 0) valid = valid && taskTypeIds.includes(resource.taskTypeId)
          if (typeIds.length > 0) valid = valid && typeIds.includes(resource.issueTypeId)
          if (severityIds.length > 0) valid = valid && severityIds.includes(resource.issueSeverityId)
          if (stageIds.length > 0) valid = valid && stageIds.includes(resource.issueStageId)
          return valid
        }))
      },
      issueTaskCATEGORIES() {
        let issues = new Array
        let group = _.groupBy(this.filteredIssues, 'taskTypeName')
        for (let type in group) {
          if(!type || type == "null") continue;
          issues.push({
            name: type,
            count: group[type].length,
            progress: Number((_.meanBy(group[type], 'progress') || 0).toFixed(0))
          })
        }
        return issues
      },
      issueStats() {
        let issues = new Array
        let group = _.groupBy(this.filteredIssues, 'issueType')
        for (let type in group) {
          issues.push({
            name: type,
            count: group[type].length,
            progress: Number((_.meanBy(group[type], 'progress') || 0).toFixed(0))
          })
        }
        return issues
      },
      issueVariation() {
        let completed = _.filter(this.filteredIssues, (t) => t && t.progress && t.progress == 100)
        let completed_percent = this.getAverage(completed.length, this.filteredIssues.length)
        let overdue = _.filter(this.filteredIssues, (t) => t && t.isOverdue)
        let overdue_percent = this.getAverage(overdue.length, this.filteredIssues.length)

        return {
          completed: {count: completed.length, percentage: Math.round( completed_percent )},
          overdue: {count: overdue.length, percentage: Math.round( overdue_percent )},
        }
      },
    filteredRisks() {
        let typeIds = _.map(this.taskTypeFilter, 'id')
        let riskPriorityLevelIds = _.map(this.getRiskPriorityLevelFilter, 'id')
        let stageIds = _.map(this.riskStageFilter, 'id')    
        let riskApproachIds = _.map(this.C_riskApproachFilter, 'id')
        let taskIssueUsers = this.getTaskIssueUserFilter

        
        if (riskPriorityLevelIds ){         
          // console.log(riskPriorityLevelIds)
        }
        return _.filter(this.DV_facility.risks, (resource) => {
          let valid = true
          let userIds = [..._.map(resource.checklists, 'userId'), ...resource.userIds]

          if (taskIssueUsers.length > 0) {  
            if(taskIssueUsers.length > 0){
              valid = valid && userIds.some(u => _.map(taskIssueUsers, 'id').indexOf(u) !== -1)
            }
          }
          //TODO: For performance, send the whole tasks array instead of one by one
          valid = valid && this.filterDataForAdvancedFilter([resource], 'facilityShowTasks')

          if (stageIds.length > 0) valid = valid && stageIds.includes(resource.riskStageId)
          if (typeIds.length > 0) valid = valid && typeIds.includes(resource.taskTypeId)        
          if (riskApproachIds.length > 0) valid = valid && riskApproachIds.includes(resource.riskApproach)
          return valid
        })
      },
       riskPriorityLevels() {
        let grey = _.filter(this.filteredRisks, (t) => t && t.priorityLevelName && t.priorityLevelName == "Very Low")
        let green = _.filter(this.filteredRisks, (t) => t && t.priorityLevelName && t.priorityLevelName == "Low")
        let yellow = _.filter(this.filteredRisks, (t) => t && t.priorityLevelName && t.priorityLevelName == "Moderate")
        let orange = _.filter(this.filteredRisks, (t) => t && t.priorityLevelName && t.priorityLevelName == "High")
        let red  = _.filter(this.filteredRisks, (t) => t && t.priorityLevelName && t.priorityLevelName == "Extreme")
         return {
            grey: grey.length,
            green: green.length,
            yellow: yellow.length,
            orange: orange.length,
            red: red.length
          }
       },    
       riskVariation() {
        let completed = _.filter(this.filteredRisks, (t) => t && t.progress && t.progress == 100)
        let completed_percent = this.getAverage(completed.length, this.filteredRisks.length)
        let overdue = _.filter(this.filteredRisks, (t) => t && t.isOverdue)
        let overdue_percent = this.getAverage(overdue.length, this.filteredRisks.length)
        return {
          completed: {count: completed.length, percentage: Math.round( completed_percent )},
          overdue: {count: overdue.length, percentage: Math.round( overdue_percent )},
        }
     },
     currentRiskTypes() {
        let names = this.taskTypeFilter && this.taskTypeFilter.length && _.map(this.taskTypeFilter, 'name')
        let taskTypes = new Array
        for (let type of this.taskTypes) {
          let risks = _.filter(this.filteredRisks, t => t.taskTypeId == type.id)
          taskTypes.push(
            {
              name: type.name,
              _display: risks.length > 0 && (names ? names.includes(type.name) : true),
              length: risks.length,
              progress: Number(_.meanBy(risks, 'progress').toFixed(0))
            }
        )
      }
      return taskTypes
    },
    },
    watch: {
      facility: {
        handler(value) {
          this.DV_facility = Object.assign({}, value)
          this._selected = this.statuses.find(s => s.id == this.DV_facility.statusId)
          this.loading = false
          this.DV_updated = false
          if (this.from != "manager_view") {
            this.loading = true
            this.getFacility()
          }
        }, deep: true
      },
      "DV_facility.statusId"(value) {
        if (!value) this.DV_facility.dueDate = null
      },   
      currentTab(value) {
        this.nullifyTasksForManager()
      }
    }
  }
</script>

<style lang="scss" scoped>
  .f-head {
    word-break: break-word;
    text-overflow: ellipsis;
  }
  .f-notes {
    border: 1px solid #ccc;
    padding: 5px 10px;
    border-radius: 5px;
    overflow: auto;
    min-height: 20vh;
    max-height: 34vh;
  }
  .f-show-btn {
    font-size: 12px;
    font-style: italic;
    display: flex;
    flex-direction: row-reverse;
  }
  .custom-tab {
    background-color: #ededed !important;
    width: auto;
    text-transform: uppercase;
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
  }
  .apply-btn, .red, .orange, .green, .grey, .grey2, .yellow {
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
  }
  .pg-content {
    width: 100%;
    height: 20px;
    font-size: 14px;
    font-weight: bold;
  }
  .vue-tabs {
    margin-top: 15px;
  }
  .vdp-datepicker {
    width: 100%;
  }
  .search-tab {
    width: 80%;
  }
  .displayNone {
    display: none !important;
  }
  .fa-building {
    font-size: large !important;
    color: #383838 !important;

  }
  .close-sidebar-btn {
    z-index: 800;
    cursor: pointer;
    display: flex;
    position: absolute;
    left: 0;
    top: 0;
    background: #fff;
    padding: 5px;
  }
  .my-el-card {
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, .10);
  }
  .vue2-datepicker ::v-deep .mx-input:disabled {
    color: #555;
    background-color: #fff;
  }

  .simple-select ::v-deep .multiselect {
    .multiselect__placeholder {    
      text-overflow: ellipsis;
    }
  }
 .fac-sum {
   border-radius: 2px;
   padding:8px;
   margin-bottom: 8px;
   background-color: #fff;
   box-shadow: 0 5px 5px rgba(0,0,0,0.19), 0 3px 3px rgba(0,0,0,0.23);
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
    background-color: rgb(92,184,92);
  }
  .red {
    background-color: #d9534f;
  }
  .red, .orange, .green, .grey {
    color:white;
    border-radius: 3px;
  }
  .grey2 {
    border-radius: 3px;
  }
  .custom-tab {
    background-color: #ededed !important;
    text-transform: uppercase;
    width:auto;
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
  }
  .pg-content {
    width: 100%;
    height: 20px;
    font-size: 14px;
    font-weight: bold;
  }
  .vue-tabs {
    margin-top: 15px;
  }
  .vdp-datepicker {
    width: 100%;
  }
  .search-tab {
    width: 80%;
  }
  .displayNone {
    display: none !important;
  }
  .close-sidebar-btn {
    z-index: 800;
    cursor: pointer;
    display: flex;
    position: absolute;
    left: 0;
    top: 0;
    background: #fff;
    padding: 5px;
  }
  .vue2-datepicker ::v-deep .mx-input:disabled {
    color: #555;
    background-color: #fff;
  }
  .simple-select ::v-deep .multiselect {
    .multiselect__placeholder {
      color: #dc3545;
      text-overflow: ellipsis;
    }
  }
   .fac-sum {
      border-radius: 2px;
      padding:8px;
      margin-bottom: 8px;
      background-color: #fff;
      box-shadow: 0 5px 5px rgba(0,0,0,0.19), 0 3px 3px rgba(0,0,0,0.23);
  }

</style>


