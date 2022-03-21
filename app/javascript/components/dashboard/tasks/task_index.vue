<template>
  <div id="tasks-index" class="mt-3" data-cy="task_list">
    <div v-if="_isallowed('read')">

       <div class="d-flex align-item-center justify-content-between w-100 mb-3">        
        <div class="input-group w-100">        
          <el-input
            type="search"
            style="height:30px"
            placeholder="Enter Search Criteria" 
            aria-label="Search" 
            aria-describedby="search-addon" 
            v-model="tasksQuery" 
            data-cy="search_tasks">
            <el-button slot="prepend" icon="el-icon-search"></el-button>
          </el-input>
        </div>
        <!-- <div class="ml-1 d-flex">
          <label class="font-sm mb-0"><span style="visibility:hidden">|</span></label> 
        <span class="filterToggleWrapper mr-1 pt-1 px-2" v-if="_isallowed('write')" @click.prevent="toggleAdvancedFilter" v-tooltip="`Advanced Filters`">
           <i class="fas fa-sliders-h"></i>      
        </span>    
         </div> -->
        <div class="ml-1 font-sm w-100">
          <el-select 
           v-model="C_taskTypeFilter"                        
           class="w-100" 
           track-by="name" 
           value-key="id"
           multiple                                                                                                                                               
           clearable
           placeholder="Select Process Area"
           >
          <el-option 
            v-for="item in taskTypes"                                                     
            :value="item"   
            :key="item.id"
            :label="item.name"                                                  
            >
          </el-option>
          </el-select>      
         </div>
       </div>

     <div class="mb-3">
        <span class="d-inline">
        <button v-if="_isallowed('write')" class="btn btn-md btn-primary mr-2 float-left addTaskBtn" @click.prevent="addNewTask">
          <font-awesome-icon icon="plus-circle" data-cy="new_task" />
          Add Task
        </button>
         <span class="d-inline-block tagCol pl-1">
                 <div class="pr-3 text-center d-inline-block icons" :class="[getHideComplete == true ? 'light':'']" @click.prevent="toggleComplete" >                              
                   <span class="d-block" v-tooltip="`COMPLETE`" >
                    <i class="fas fa-clipboard-check" :class="[getHideComplete == true ? 'light':'text-success']"></i>
                    </span>      
               
                   <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{variation.completed.count}}</h6>  
                  </div>
                 <div class="pr-3 text-center d-inline-block icons" :class="[getHideInprogress == true ? 'light':'']" @click.prevent="toggleInprogress">                              
                   <span v-tooltip="`IN PROGRESS`" class="d-block">
                    <i class="far fa-tasks" :class="[getHideInprogress == true ? 'light':'text-primary']"></i>
                    </span>      
                
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.inProgress.count }}</h6>
                  </div>
                   <div class="pr-3 text-center d-inline-block icons" :class="[getHidePlanned == true ? 'light':'']" @click.prevent="togglePlanned">                              
                   <span v-tooltip="`PLANNED`" class="d-block">
                    <i class="fas fa-calendar-check"  :class="[getHidePlanned == true ? 'light':'text-info']"></i>
                    </span>      
                
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.planned.count }}</h6>
                  </div>
                  <div class="pr-3 text-center d-inline-block icons" :class="[getHideOverdue == true ? 'light':'']" @click.prevent="toggleOverdue" >                              
                   <span v-tooltip="`OVERDUE`" class="d-block">
                    <i class="fas fa-calendar" :class="[getHideOverdue == true ? 'light':'text-danger']"></i>
                    </span>      
                
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.overdue.count }}</h6>
                  </div>
                    <div class="pr-3 text-center d-inline-block icons" :class="[getHideOngoing == true ? 'light':'']" @click.prevent="toggleOngoing" >                              
                   <span v-tooltip="`ONGOING`"  class="d-block">
                    <i class="fas fa-retweet" :class="[getHideOngoing == true ? 'light':'text-success']"></i>
                    </span>      
              
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.ongoing.count }}
                       <span
                       v-tooltip="`Ongoing: Closed`"
                       v-if="variation.ongoingClosed.count > 0"
                       style="color:lightgray"
                       >({{variation.ongoingClosed.count}})
                    </span></h6>
                  </div>
  
                  <div class="pr-3 text-center d-inline-block icons" :class="[getHideOnhold == true ? 'light':'']"  @click.prevent="toggleOnhold"  >                              
                   <span v-tooltip="`ON HOLD`"  class="d-block">
                    <i class="fas fa-pause-circle" :class="[getHideOnhold == true ? 'light':'text-primary']"></i>
                    </span>      
        
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.onHold.count }}</h6>
                  </div>
                  <div class="pr-3 text-center d-inline-block icons"  :class="[getHideDraft == true ? 'light':'']"  @click.prevent="toggleDraft" >                              
                   <span v-tooltip="`DRAFT`" class="d-block">
                    <i class="fas fa-pencil-alt"  :class="[getHideDraft == true ? 'light':'text-warning']"></i>
                    </span>      
         
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.drafts.count }}</h6>
                  </div>
                
  
         
      
                  <div class="pr-3 text-center d-inline-block icons" :class="[getHideWatched == true ? '':'light']" @click.prevent="toggleWatched"  >                              
                   <span v-tooltip="`ON WATCH`"  class="d-block">
                    <i class="fas fa-eye"></i>
                    </span>      
          
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.watched.count }}</h6>
                  </div>
  
                  <div class="pr-3 text-center d-inline-block icons" :class="[getHideImportant == true ? '':'light']" @click.prevent="toggleImportant">                              
                   <span v-tooltip="`IMPORTANT`" class="d-block">
                    <i class="fas fa-star" :class="[getHideImportant == true ? 'text-warning':'light']"></i>
                    </span>      
          
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.important.count }}</h6>
                  </div>
                  <div class="pr-2 text-center d-inline-block icons" :class="[getHideBriefed == true ? '':'light']" @click.prevent="toggleBriefed">                              
                   <span v-tooltip="`BRIEFINGS`" class="d-block">
                    <i class="fas fa-presentation" :class="[getHideBriefed == true ? 'text-primary':'']"></i>
                    </span>      
                   <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.briefings.count }}</h6>
                  </div>  

                   <div class="d-inline-block mx-0">
             <!-- <v-app id="app"> -->
             <v-checkbox     
           v-model="C_showCountToggle"     
            class="d-inline-block"  
            @click.prevent="showCounts"   
           v-tooltip="`Show Counts`"
          ></v-checkbox>
             <!-- </v-app> -->

          </div>
            </span>
            
            
     </span>
     <div class="float-right">
        <button v-tooltip="`Export to PDF`" @click.prevent="exportToPdf" class="btn btn-md mr-1 exportBtns text-light">
          <font-awesome-icon icon="file-pdf" />
        </button>
        <button v-tooltip="`Export to Excel`" @click.prevent="exportToExcel('table', 'Task List')" class="btn btn-md exportBtns text-light">
          <font-awesome-icon icon="file-excel" />
        </button>
     </div>
      </div>
      <div v-if="filteredTasks.filtered.tasks.length > 0">
        <hr />
        <task-show v-for="(task, i) in filteredTasks.filtered.tasks" id="taskHover" :class="{'b_border': !!filteredTasks.filtered.tasks.length[i+1]}" :key="task.id" :task="task" :from-view="from" @edit-task="editTask"></task-show>
      </div>
      <div v-else>
        <br />
        <h6 class="text-danger mt-2 ml-1">No tasks found..</h6>
      </div>
    </div>
       <div v-else class="text-danger mx-2 mt-5">
        <h5> <i>Sorry, you don't have read-permissions for this tab! Please click on any available tab.</i></h5>
      </div>
    <table style="display:none" class="table table-sm table-bordered" ref="table" id="taskList1">
      <thead>
        <tr>
          <th></th>
          <th>Task</th>
          <th>Process Area</th>
          <th>Project</th>
          <th>Start Date</th>
          <th>Due Date</th>
          <th>Assigned Users</th>
          <th>Progress</th>
          <th>Overdue</th>
          <th>Last Update</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(task, i) in filteredTasks.filtered.tasks" :key="i">
          <td class="text-center">{{i+1}}</td>
          <td>{{task.text}}</td>
          <td>{{task.taskType}}</td>
          <td>{{task.facilityName}}</td>
          <td>{{formatDate(task.startDate)}}</td>
          <td>{{formatDate(task.dueDate)}}</td>
          <td class="ten" v-if="(task.users.length) > 0">{{JSON.stringify(task.users.map(users => (users.fullName))).replace(/]|[['"]/g, '')}}</td>
          <td class="ten" v-else></td>
          <td>{{task.progress + "%"}}</td>
          <td v-if="(task.dueDate) <= now">
            <h5>X</h5>
          </td>
          <td v-else></td>
          <td v-if="task.notes.length > 0">       
          <span  class="toolTip" v-tooltip="('By: ' + task.lastUpdate.user.fullName)" > 
          {{ moment(task.lastUpdate.createdAt).format('DD MMM YYYY, h:mm a')}} <br>         
          </span> 
          <span>
            {{task.lastUpdate.body}}
          </span>         
           </td>  
          <td v-else >No Updates</td>      
        </tr>
      </tbody>
    </table>
  </div>
</template>
<script>
import { mapGetters, mapMutations } from "vuex"
import { jsPDF } from "jspdf"
import 'jspdf-autotable'
import TaskShow from "./task_show"
import { library } from '@fortawesome/fontawesome-svg-core'
import { faFilePdf, faFileExcel, faPlusCircle } from '@fortawesome/free-solid-svg-icons'
library.add(faFilePdf, faFileExcel, faPlusCircle)
import * as Moment from 'moment'
import { extendMoment } from 'moment-range'
const moment = extendMoment(Moment)

export default {
  name: 'TasksIndex',
  components: {
    TaskShow
  },
  props: ['facility', 'from', "contract"],
  data() {
    return {
      viewList: 'active',
      listOptions: ['active', 'all', 'completed'],
      now: new Date().toISOString(),
      tasksQuery: '',
      uri: 'data:application/vnd.ms-excel;base64,',
      template: '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="https://www.w3.org/TR/2018/SPSD-html401-20180327/"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
      base64: function(s) { return window.btoa(unescape(encodeURIComponent(s))) },
      format: function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) }
    }
  },
  methods: {
    ...mapMutations([
      'setAdvancedFilter',
      'setTaskIssueProgressStatusFilter',
      'setTaskIssueOverdueFilter',
      'setTaskTypeFilter',
      'setMyActionsFilter',
      'setOnWatchFilter',
      'setTaskForManager',
      'setShowCount',
      'setShowAdvancedFilter',
      // 7 States
      'setHideComplete',
      'setHideInprogress',
      'setHidePlanned',
      'setHideOverdue',
      'setHideOngoing',
      'setHideOnhold',
        'setHideDraft',
      // 3 Tags
      'setHideWatched',
      'setHideImportant',
      'setHideBriefed',
    ]),
    _isallowed(salut) {
                    return this.checkPrivileges("task_index", salut, this.$route)

       if (this.$route.params.contractId) {
          // return this.defaultPrivileges
          let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
          let permissionHash = {"write": "W", "read": "R", "delete": "D"}
          let s = permissionHash[salut]
          return fPrivilege.tasks.includes(s);
        } else {
          let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
          let permissionHash = {"write": "W", "read": "R", "delete": "D"}
          let s = permissionHash[salut]
          return fPrivilege.tasks.includes(s); 
        }
     },
    toggleAdvancedFilter() {
        this.setShowAdvancedFilter(!this.getShowAdvancedFilter);
      },
    addNewTask() {
      this.setTaskForManager({key: 'task', value: {}})
      // Route to new task form page
      this.$router.push(
        `/programs/${this.$route.params.programId}/map/projects/${this.$route.params.projectId}/tasks/new`
      );
    },
    // log(e){
    //   console.log("task " + e)
    // },
    editTask(task) {
      this.$emit('show-hide', task)
    },
    exportToPdf() {
      const doc = new jsPDF("l")
      const html = this.$refs.table.innerHTML
      doc.autoTable({ html: "#taskList1" })
      doc.text(150, 285, "Task List")
      doc.save("Task_List.pdf")
    },
    toggleWatched(){
      this.setHideWatched(!this.getHideWatched)    
    },
    toggleImportant(){
      this.setHideImportant(!this.getHideImportant)    
    },
    toggleBriefed(){
        this.setHideBriefed(!this.getHideBriefed)    
    },
    toggleComplete(){
      this.setHideComplete(!this.getHideComplete)    
    },
    toggleDraft(){
      this.setHideDraft(!this.getHideDraft)    
    },
    togglePlanned(){
        this.setHidePlanned(!this.getHidePlanned)    
    },
    toggleInprogress(){
      this.setHideInprogress(!this.getHideInprogress)    
    },
    toggleOngoing(){
        this.setHideOngoing(!this.getHideOngoing)    
    },
    toggleOnhold(){
        this.setHideOnhold(!this.getHideOnhold)    
    },
    toggleOverdue(){
    //  this.setAdvancedFilter({id: 'overdue', name: 'Overdue', value: "overdue", filterCategoryId: 'overDueFilter', filterCategoryName: 'Action Overdue'}) 
      this.setHideOverdue(!this.getHideOverdue)    
    },
    showCounts(){
      this.setShowCount(!this.getShowCount)       
    },
    exportToExcel(table, name) {
      if (!table.nodeType) table = this.$refs.table
      var ctx = { worksheet: name || 'Worksheet', table: table.innerHTML }
      var link = document.createElement('a');
      link.setAttribute('href', this.uri + this.base64(this.format(this.template, ctx)));
      link.setAttribute('download', 'Task_List.xls');
      link.click();
    }
},
computed: {
  ...mapGetters([
    // 'getAdvancedFilterOptions',
    'filterDataForAdvancedFilter',
    'getFilteredResources',
    'getTaskIssueUserFilter',
    'getAdvancedFilter',
    'getTaskIssueTabFilterOptions',
    'getTaskIssueProgressStatusOptions',
    'getTaskIssueProgressStatusFilter',
    'taskIssueProgressFilter',
    'getTaskIssueOverdueOptions',
    'taskIssueOverdueFilter',
    'taskTypeFilter',
    'noteDateFilter',
    'getShowAdvancedFilter',
    'taskIssueDueDateFilter',
    'myActionsFilter',
    'onWatchFilter',
    'taskUserFilter',
    'taskTypes',
    'viewPermit',
    'taskStageFilter',
    'getShowCount',
    // 7 States
    'getHideComplete',
    'getHideInprogress',
    'getHidePlanned',
    'getHideOngoing',
    'getHideOnhold',
    'getHideDraft',
    'getHideOverdue',
    // 3 Tags
    'getHideWatched',
    'getHideImportant',
    'getHideBriefed',
  ]),
  filteredTasks() {
    let typeIds = _.map(this.C_taskTypeFilter, 'id')
    let stageIds = _.map(this.taskStageFilter, 'id')
    const search_query = this.exists(this.tasksQuery.trim()) ? new RegExp(_.escapeRegExp(this.tasksQuery.trim().toLowerCase()), 'i') : null
    let noteDates = this.noteDateFilter
    let taskIssueDueDates = this.taskIssueDueDateFilter
    
    let taskIssueProgress = this.taskIssueProgressFilter

    let taskIssueUsers = this.getTaskIssueUserFilter
    var filterDataForAdvancedFilterFunction = this.filterDataForAdvancedFilter
    
    let tasks = _.sortBy(_.filter(this.object.tasks, (resource) => {
      let valid = Boolean(resource && resource.hasOwnProperty('progress'))

      let userIds = [..._.map(resource.checklists, 'userId'), ...resource.userIds]

      if(taskIssueUsers.length > 0){
        valid = valid && userIds.some(u => _.map(taskIssueUsers, 'id').indexOf(u) !== -1)
      }

      //TODO: For performance, send the whole tasks array instead of one by one
      valid = valid && filterDataForAdvancedFilterFunction([resource], 'facilityManagerTasks')

      if (stageIds.length > 0) valid = valid && stageIds.includes(resource.taskStageId)
      if (typeIds.length > 0) valid = valid && typeIds.includes(resource.taskTypeId)

      if (noteDates && noteDates[0] && noteDates[1]) {
        var startDate = moment(noteDates[0], "YYYY-MM-DD")
        var endDate = moment(noteDates[1], "YYYY-MM-DD")
        var _notesCreatedAt = _.map(resource.notes, 'createdAt')
        var is_valid = resource.notes.length > 0
        for (var createdAt of _notesCreatedAt) {
          var nDate = moment(createdAt, "YYYY-MM-DD")
          is_valid = nDate.isBetween(startDate, endDate, 'days', true)
          if (is_valid) break
        }
        valid = valid && is_valid
      }

      if (taskIssueDueDates && taskIssueDueDates[0] && taskIssueDueDates[1]) {
        var startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD")
        var endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD")

        var is_valid = true
        var nDate = moment(resource.dueDate, "YYYY-MM-DD")
        is_valid = nDate.isBetween(startDate, endDate, 'days', true)
        valid = valid && is_valid
      }

      if (taskIssueProgress && taskIssueProgress[0]) {
        var min = taskIssueProgress[0].value.split("-")[0]
        var max = taskIssueProgress[0].value.split("-")[1]
        valid = valid && (resource.progress >= min && resource.progress <= max)
      }

      if (search_query) valid = valid && search_query.test(resource.text) || 
      valid && search_query.test(resource.taskType) || 
      valid && search_query.test(resource.userNames)

      return valid
    }), ['dueDate'])
 
      return {
       unfiltered: {
            tasks
            },
       filtered: {
         tasks:  tasks.filter(t => {
        if (this.getHideOverdue == true) {          
         return t.isOverdue == false
       } else return true

      }).filter(t => {
      if (this.getHideComplete == true) { 
        return !t.completed
      } else return true

      }).filter(t => {
      if (this.getHidePlanned == true) { 
        return t.planned == false
      } else return true

      }).filter(t => {
      if (this.getHideOnhold == true) { 
        return t.onHold == false
      } else return true

      }).filter(t => {
      if (this.getHideInprogress == true) { 
        return t.inProgress == false
      } else return true

      }).filter(t => {
       if (this.getHideDraft == true){
         return t.draft == false
       } else return true   


      }).filter(t => {
      if (this.getHideOngoing == true) {
        return t.ongoing == false
      } else return true       

      }).filter(t => {
        if (this.getHideBriefed && !this.getHideWatched && !this.getHideImportant ) {
        return t.reportable
      }
      if (this.getHideBriefed && this.getHideWatched && !this.getHideImportant) {          
          return t.reportable + t.watched

      } if (this.getHideBriefed && this.getHideWatched && this.getHideImportant) {          
          return t.reportable + t.watched + t.important
      } else return true

      }).filter(t => {
        // This and last 2 filters are for Filtered Tags
         if (this.getHideWatched && !this.getHideBriefed && !this.getHideImportant) {
           return t.watched
        } if (this.getHideWatched && this.getHideBriefed && !this.getHideImportant) {          
           return  t.watched + t.reportable
        } if (this.getHideWatched && !this.getHideBriefed && this.getHideImportant) {
           return t.watched + t.important
        } if (this.getHideWatched && this.getHideBriefed && this.getHideImportant) {          
           return  t.watched + t.reportable + t.important
        } else return true          
       
      }).filter(t => {
         if (this.getHideImportant && !this.getHideBriefed && !this.getHideWatched) {
          return t.important
        } if (this.getHideImportant && this.getHideBriefed && !this.getHideWatched) {
          return t.important + t.reportable
       } if (this.getHideImportant && this.getHideBriefed && this.getHideWatched) {
          return t.important + t.reportable + t.watched
        } else return true           
       }),  
        }
       }     
   },
    variation() {
    let planned = _.filter(
      this.filteredTasks.unfiltered.tasks,
        (t) => t && t.planned == true
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let drafts = _.filter(
     this.filteredTasks.unfiltered.tasks,
        (t) => t && t.draft == true
      );  
      let ongoingClosed = _.filter(
      this.filteredTasks.unfiltered.tasks,
        (t) => t && t.closed
      ); 
      let important = _.filter(
      this.filteredTasks.unfiltered.tasks,
        (t) => t && t.important == true
      ); 
        let briefings = _.filter(
       this.filteredTasks.unfiltered.tasks,
        (t) => t && t.reportable == true
      );
      let watched = _.filter(
     this.filteredTasks.unfiltered.tasks,
        (t) => t && t.watched == true
      );
              
      let completed = _.filter(
      this.filteredTasks.unfiltered.tasks,
        (t) => t && t.completed == true
      );
    let inProgress = _.filter(
      this.filteredTasks.unfiltered.tasks,
        (t) => t && t.inProgress == true
      );
     let onHold = _.filter( this.filteredTasks.unfiltered.tasks, (t) => t && t.onHold == true );
     let ongoing = _.filter( this.filteredTasks.unfiltered.tasks, (t) => t && t.ongoing == true );
     let overdue = _.filter( this.filteredTasks.unfiltered.tasks,(t) => t.isOverdue == true);

      return {
        planned: {
          count: planned.length, 
          plannedTs: planned            
        },
        important: {
          count: important.length,             
        },
        briefings: {
          count: briefings.length,          
        },
        watched: {
          count: watched.length,          
        },
        onHold: {
          count: onHold.length,          
        },
        drafts: {
          count: drafts.length,          
        },
        completed: {
          count: completed.length,
          // percentage: Math.round(completed_percent),
        },      
        inProgress: {
          count: inProgress.length,
          // percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          // percentage: Math.round(overdue_percent),
        },
        ongoing: {
          count: ongoing.length
        },    
        ongoingClosed: {
          count: ongoingClosed.length
        },      
      };
    },
   object(){
      if (this.$route.params.contractId) {
        return this.contract
      } else return this.facility
     },
  C_facilityManagerTaskFilter: {
    get() {
      return this.getAdvancedFilter
    },
    set(value) {
      this.setAdvancedFilter(value)
    }
  },
  C_taskIssueProgressStatusFilter: {
    get() {
      if (this.getTaskIssueProgressStatusFilter.length < 1) {
        this.setTaskIssueProgressStatusFilter([{ id: 'active', name: 'active' }])
      }
      return this.getTaskIssueProgressStatusFilter
    },
    set(value) {
      this.setTaskIssueProgressStatusFilter(value)
    }
  },
  C_taskIssueOverdueFilter: {
    get() {
      return this.taskIssueOverdueFilter
    },
    set(value) {
      this.setTaskIssueOverdueFilter(value)
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
  C_showCountToggle: {                  
    get() {
      return this.getShowCount                
    },
    set(value) {
      this.setShowCount(value) ||  this.setShowCount(!this.getShowCount)
    }
        
  },
  C_myTasks: {
    get() {
      return _.map(this.myActionsFilter, 'value').includes('tasks')
    },
    set(value) {
      if (value) this.setMyActionsFilter([...this.myActionsFilter, { name: "My Tasks", value: "tasks" }])
      else this.setMyActionsFilter(this.myActionsFilter.filter(f => f.value !== "tasks"))
    }
  }
}
}
</script>
<style lang="scss" scoped>
#tasks-index {
  height: 465px;
  background-color: #ffffff;
  z-index: 100;
}

.new-tasks-btn {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19), 0 3px 3px rgba(56, 56, 56, 0.23);
}

#total {
  float: right;
  margin-right: 0;
  text-align: right;
}

.multiselect {
  border: #1d2124 !important;
}

#taskHover:hover {
  cursor: pointer;
  background-color: rgba(91, 192, 222, 0.3);
  border-left: solid rgb(91, 192, 222);
}

tfoot {
  text-align: right !important;
}

.flags {
  // background-color: #dc3545;
  // color:white;  
  background-color: lightgray;
  color: black; 
  margin-left:86%;
  padding: 1px 2px;
  font-size: .65rem;
  border-top-right-radius: 4px;
  border-top-left-radius: 4px;  
}

input[type=search] {
  color: #383838;
  text-align: left;
  cursor: pointer;
  display: block;
}

.addTaskBtn,
.exportBtns {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19), 0 3px 3px rgba(56, 56, 56, 0.23);
}

.exportBtns {
  transition: all .2s ease-in-out;
  background-color: #41b883;
}

.exportBtns:hover {
  transform: scale(1.06);
}

.myTasks {
  float: right !important;
  margin-top: 5px;
}

#taskHover {
 box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19), 0 3px 3px rgba(56, 56, 56, 0.23);
}

.displayNone {
  display: none;
}
.filters-wrapper {
  float: right;
  margin-top: -85px;  
}
.tagCol {
  border-radius: 4px;
  border: .5px solid lightgray;
  h6 {
  margin-bottom: 0;
 }
}

i, .icons {
  cursor: pointer;
  -webkit-touch-callout: none;
  -webkit-user-select: none;
  -khtml-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}
.statesCol {
  border-radius: 4px; 
  border: .5px solid lightgray;

}

/deep/.v-input__slot {
  display: inline;
  .v-label {
   font-family: 'FuturaPTBook';
  //  font-weight: 600;
   color: #007bff !important;
  }
}
/deep/.v-input__control {
  display: block !important;
}
.hideLabels {
  font-weight: 600;
}
/deep/.v-input--checkbox{
  margin-top: 0;
}

@media screen and (max-width: 1500px) {
  .filters-wrapper {
    width: 65% !important;
  } 
}

@media screen and (max-width: 1550px) {
  .hideLabels {
    display: none !important;
  }
}
</style>
