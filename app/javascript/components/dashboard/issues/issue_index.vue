<template>
  <div v-if="!loading" class="mt-3 issues-index px-0" data-cy="issue_list">
    <div v-if="newIssue && from != 'manager_view'">
      <issue-form :facility="facility" :issue="currentIssue" @on-close-form="newIssue=false" @issue-created="issueCreated" @issue-updated="issueUpdated" class="issue-form-modal" />
    </div>
    <div v-else>
      <div class="d-flex align-item-center justify-content-between w-100 mb-3">
        <div class="input-group w-100 mr-1">
          <el-input type="search" style="height:30px" placeholder="Enter Search Criteria" aria-label="Search" aria-describedby="search-addon" v-model="issuesQuery" data-cy="search_issues">
            <el-button slot="prepend" icon="el-icon-search"></el-button>
          </el-input>
        </div>        
     
        <div class="w-100" style="position:relative">  
 
  <el-collapse class="issuesFilter w-100"  style="position:absolute">
  <el-collapse-item name="1">
    <template slot="title" class="text-right">     
    <i class="fas fa-sliders-h d-inline mr-2"></i>
    MORE ISSUE FILTERS
    </template>
    <div class="mr-1 w-100 d-unset p-2">
    <label class="mb-0">Process Area</label>
    <el-select 
      v-model="C_taskTypeFilter"                    
      class="w-100" 
      track-by="name" 
      value-key="id"
      multiple                                                                                                                                               
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

      <label class="mb-0">Issue Types</label>
      <el-select
        v-model="C_issueTypeFilter"
        class="w-100 mr-1 mb-1"
        track-by="name"
        value-key="id"
        multiple
        placeholder="Filter by Issue Types"
      >
      <el-option
        v-for="item in issueTypes"
        :value="item"
        :key="item.id"
        :label="item.name"
        >
      </el-option>
      </el-select>
       <label class="mb-0">Issue Severity</label>
      <el-select
        v-model="C_issueSeverityFilter"
        class="w-100"
        track-by="name"
        value-key="id"
        multiple
        placeholder="Filter by Issue Severities"
      >
      <el-option
        v-for="item in issueSeverities"
        :value="item"
        :key="item.id"
        :label="item.name"
        >
      </el-option>
      </el-select>
    </div>
        </el-collapse-item>
      </el-collapse>  
            
    </div>
 </div>
     
      <div class="mb-3">
          <span class="d-inline">
        <button v-if="_isallowed('write')" class="btn btn-md btn-primary float-left addIssueBtn mr-2" @click.prevent="addNewIssue">
          <font-awesome-icon icon="plus-circle" data-cy="new_issue" />
          Add Issue
        </button>
        <span class="d-inline-block tagCol pl-1">

           <div class="pr-3 text-center d-inline-block icons" :class="[getHideComplete == true ? 'light':'']" @click.prevent="toggleComplete" >                              
                   <span v-tooltip="`COMPLETE`" class="d-block">
                    <i class="fas fa-clipboard-check" :class="[getHideComplete == true ? 'light':'text-success']"></i>
                    </span>      
               
                   <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{variation.completed.count}}</h6>  
                  </div>
                 <div class="pr-3 text-center d-inline-block icons" :class="[getHideInprogress == true ? 'light':'']" @click.prevent="toggleInprogress">                              
                   <span v-tooltip="`IN PROGRESS`"  class="d-block">
                    <i class="far fa-tasks" :class="[getHideInprogress == true ? 'light':'text-primary']"></i>
                    </span>      
                
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.inProgress.count }}</h6>
                  </div>
                   <div class="pr-3 text-center d-inline-block icons" :class="[getHidePlanned == true ? 'light':'']" @click.prevent="togglePlanned">                              
                   <span v-tooltip="`PLANNED`"  class="d-block">
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
                    
                  <div class="pr-3 text-center d-inline-block icons" :class="[getHideOnhold == true ? 'light':'']"  @click.prevent="toggleOnhold"  >                              
                   <span v-tooltip="`ON HOLD`" class="d-block">
                    <i class="fas fa-pause-circle" :class="[getHideOnhold == true ? 'light':'text-primary']"></i>
                    </span>      
        
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.onHold.count }}</h6>
                  </div>
                  <div class="pr-3 text-center d-inline-block icons"  :class="[getHideDraft == true ? 'light':'']"  @click.prevent="toggleDraft" >                              
                   <span  v-tooltip="`DRAFT`" class="d-block">
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
                   <span v-tooltip="`BRIEFINGS`"  class="d-block">
                    <i class="fas fa-presentation" :class="[getHideBriefed == true ? 'text-primary':'']"></i>
                    </span>      
                   <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.briefings.count }}</h6>
                  </div>  

                   <div class="d-inline-block mx-0">
                   <v-checkbox     
                    v-model="C_showCountToggle"     
                      class="d-inline-block"  
                      @click.prevent="showCounts"   
                    v-tooltip="`Show Counts`"
                  ></v-checkbox>
                 </div>
            </span>          
     </span>

          <div class="float-right">
        <button v-tooltip="`Export to PDF`" @click.prevent="exportToPdf" class="btn btn-md mr-1 exportBtns text-light">
          <font-awesome-icon icon="file-pdf" />
        </button>
        <button v-tooltip="`Export to Excel`" @click.prevent="exportToExcel('table', 'Issue Log')" class="btn btn-md exportBtns text-light">
          <font-awesome-icon icon="file-excel" />
        </button>
          </div>
        <div v-if="_isallowed('read')">
          <div v-if="filteredIssues.filtered.issues.length > 0">
          
            <hr />
            <issue-show v-for="(issue, i) in filteredIssues.filtered.issues" id="issueHover" :class="{'b_border': !!filteredIssues.filtered.issues[i+1]}" :key="issue.id" :issue="issue" :from-view="from" @issue-edited="issueEdited" />
          </div>
          <div v-else>
            <br />
            <h6 class="text-danger ml-1 mt-4">No issues found..</h6>
          </div>
        </div>
        <p v-else class="text-danger mx-2"> You don't have permissions to read!</p>
      </div>
    </div>
    <table style="display:none" class="table table-sm table-bordered" ref="table" id="issueList1">
      <thead>
        <tr>
          <th></th>
          <th>Issue</th>
          <th>Issue Type</th>
          <th>Project</th>
          <th>Issue Severity</th>
          <th>Start Date</th>
          <th>Due Date</th>
          <th>Assigned Users</th>
          <th>Progress</th>
          <th>Overdue</th>
          <th>Last Update</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(issue, i) in filteredIssues.filtered.issues" :key="i">
          <td class="text-center">{{i+1}}</td>
          <td>{{issue.title}}</td>
          <td>{{issue.issueType}}</td>
          <td>{{issue.facilityName}}</td>
          <td>{{issue.issueSeverity}}</td>
          <td>{{formatDate(issue.startDate)}}</td>
          <td>{{formatDate(issue.dueDate)}}</td>
          <td v-if="(issue.users.length) > 0">{{JSON.stringify(issue.users.map(users => (users.fullName))).replace(/]|[['"]/g, '')}}</td>
          <td v-else></td>
          <td>{{issue.progress + "%"}}</td>
          <td v-if="(issue.dueDate) <= now">X</td>
          <td v-else></td>
         <td v-if="issue.notes.length > 0">       
          <span  class="toolTip" v-tooltip="('By: ' + issue.lastUpdate.user.fullName)" > 
          {{ moment(issue.lastUpdate.createdAt).format('DD MMM YYYY, h:mm a')}} <br>         
          </span> 
          <span>
            {{issue.lastUpdate.body}}
          </span>         
        </td>  
         <td v-else >No Updates</td> 
        </tr>
      </tbody>
    </table>
  </div>
</template>
<script>
import http from './../../../common/http'
import { jsPDF } from "jspdf"
import 'jspdf-autotable'
import { mapGetters, mapMutations } from 'vuex'
import IssueForm from './issue_form'
import IssueShow from './issue_show'
import { library } from '@fortawesome/fontawesome-svg-core'
import { faFilePdf } from '@fortawesome/free-solid-svg-icons'
library.add(faFilePdf)
import * as Moment from 'moment'
import { extendMoment } from 'moment-range'
const moment = extendMoment(Moment)
import {API_BASE_PATH} from './../../../mixins/utils'

export default {
  name: 'IssueIndex',
  props: ['facility', 'from'],
  components: {
    IssueForm,
    IssueShow
  },
  data() {
    return {
      loading: true,
      newIssue: false,
      currentIssue: null,
      now: new Date().toISOString(),
      issuesQuery: '',
      uri: 'data:application/vnd.ms-excel;base64,',
      template: '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="https://www.w3.org/TR/2018/SPSD-html401-20180327/"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
      base64: function(s) { return window.btoa(unescape(encodeURIComponent(s))) },
      format: function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) }
    }
  },
  mounted() {
    this.loading = false
  },
  methods: {
    ...mapMutations([
      'setAdvancedFilter',
      'setTaskIssueProgressStatusFilter',
      'setTaskIssueOverdueFilter',
      'setIssueTypeFilter',
      'setTaskTypeFilter',
      'setIssueSeverityFilter',
      'setMyActionsFilter',
      'updateFacilityHash',
      'setTaskForManager',
      'setOnWatchFilter',
       'setShowCount',
      // 7 States
      'setHideComplete',
      'setHideInprogress',
      'setHidePlanned',
      'setHideOverdue',
      'setHideOnhold',
      'setHideDraft',
      // 3 Tags
      'setHideWatched',
      'setHideImportant',
      'setHideBriefed',
    ]),
    //TODO: change the method name of isAllowed
    _isallowed(salut) {
      var programId = this.$route.params.programId;
      var projectId = this.$route.params.projectId
      let fPrivilege = this.$projectPrivileges[programId][projectId]
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return  fPrivilege.issues.includes(s); 
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
    toggleOnhold(){
      this.setHideOnhold(!this.getHideOnhold)    
    },
    toggleOverdue(){
      this.setHideOverdue(!this.getHideOverdue)    
    },
    showCounts(){
      this.setShowCount(!this.getShowCount)       
    },
    issueCreated(issue) {
      this.facility.issues.unshift(issue)
      this.newIssue = false
      this.$emit('refresh-facility')
    },
    issueUpdated(issue, refresh = true) {
      let index = this.facility.issues.findIndex((t) => t.id == issue.id)
      if (index > -1) Vue.set(this.facility.issues, index, issue)
      if (refresh) {
        this.newIssue = false
        this.$emit('refresh-facility')
      } else {
        this.updateFacilityHash(this.facility)
      }
    },
    issueDeleted(issue) {
      http
        .delete(`#{API_BASE_PATH}/programs/${this.currentProject.id}/projects/${this.facility.id}/issues/${issue.id}.json`)
        .then((res) => {
            let issues = [...this.facility.issues]
            _.remove(issues, (t) => t.id == issue.id)
            this.$emit('refresh-facility')
          }).catch((err) => console.log(err))
    },
    exportToPdf() {
      const doc = new jsPDF("l")
      const html = this.$refs.table.innerHTML
      doc.autoTable({ html: "#issueList1" })
      doc.save("Issue_Log.pdf")
    },
    exportToExcel(table, name) {
      if (!table.nodeType) table = this.$refs.table
      var ctx = { worksheet: name || 'Worksheet', table: table.innerHTML }
      var link = document.createElement('a');
      link.setAttribute('href', this.uri + this.base64(this.format(this.template, ctx)));
      link.setAttribute('download', 'Issue_Log.xls');
      link.click();
    },
    issueEdited(issue) {
      this.currentIssue = issue
      this.newIssue = true
    },
    addNewIssue() {
      this.setTaskForManager({key: 'issue', value: {}})
      // Route to new issue form page
      this.$router.push(
        `/programs/${this.$route.params.programId}/map/projects/${this.$route.params.projectId}/issues/new`
      );
    }
  },
computed: {
  ...mapGetters([
    // 'getAdvancedFilterOptions',
    'filterDataForAdvancedFilter',
    'getTaskIssueUserFilter',
    'getAdvancedFilter',
    'getTaskIssueTabFilterOptions',
    'getTaskIssueProgressStatusOptions',
    'getTaskIssueProgressStatusFilter',
    'taskIssueProgressFilter',
    'getTaskIssueOverdueOptions',
    'taskIssueOverdueFilter',
    'noteDateFilter',
    'taskIssueDueDateFilter',
    'currentProject',
    'issueTypes',
    'taskTypes',
    'issueSeverities',
    'issueTypeFilter',
    'taskTypeFilter',
    'issueSeverityFilter',
    'issueUserFilter',
    'myActionsFilter',
    'managerView',
    'onWatchFilter',
    'issueStageFilter',
    'viewPermit',
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
  filteredIssues() {
    let typeIds = _.map(this.C_issueTypeFilter, 'id')
    let taskTypeIds = _.map(this.C_taskTypeFilter, 'id')
    let severityIds = _.map(this.C_issueSeverityFilter, 'id')
    let stageIds = _.map(this.issueStageFilter, 'id')
    const search_query = this.exists(this.issuesQuery.trim()) ? new RegExp(_.escapeRegExp(this.issuesQuery.trim().toLowerCase()), 'i') : null
    let noteDates = this.noteDateFilter
    let taskIssueDueDates = this.taskIssueDueDateFilter
    let taskIssueProgress = this.taskIssueProgressFilter

    let taskIssueUsers = this.getTaskIssueUserFilter
    var filterDataForAdvancedFilterFunction = this.filterDataForAdvancedFilter

    let issues = _.sortBy(_.filter(this.facility.issues, ((resource) => {
      let valid = Boolean(resource && resource.hasOwnProperty('progress'))

      let userIds = [..._.map(resource.checklists, 'userId'), ...resource.userIds]

      if (taskIssueUsers.length > 0) {  
        if(taskIssueUsers.length > 0){
          valid = valid && userIds.some(u => _.map(taskIssueUsers, 'id').indexOf(u) !== -1)
        }
      }

      //TODO: For performance, send the whole tasks array instead of one by one
      valid = valid && filterDataForAdvancedFilterFunction([resource], 'facilityManagerIssues')

      if (typeIds.length > 0) valid = valid && typeIds.includes(resource.issueTypeId)
      if (taskTypeIds.length > 0) valid = valid && taskTypeIds.includes(resource.taskTypeId)
      if (severityIds.length > 0) valid = valid && severityIds.includes(resource.issueSeverityId)
      if (stageIds.length > 0) valid = valid && stageIds.includes(resource.issueStageId)

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

      if (search_query) valid = valid && search_query.test(resource.title) || 
        valid && search_query.test(resource.issueType) || 
        valid && search_query.test(resource.issueSeverity) || 
         valid && search_query.test(resource.taskTypeName) ||
        valid && search_query.test(resource.userNames)


      return valid;
    })), ['dueDate'])

     return {
       unfiltered: {
          issues
            },
       filtered: {
         issues:  issues.filter(t => {
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
        } if (this.getHideWatched && !this.getHideBriefed && this.getHideImportant) {
          return t.watched + t.important
        } if (this.getHideWatched && this.getHideBriefed && !this.getHideImportant) {          
           return  t.watched + t.reportable
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
      this.filteredIssues.unfiltered.issues,
        (t) => t && t.planned == true
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let drafts = _.filter(
      this.filteredIssues.unfiltered.issues,
        (t) => t && t.draft == true
      );  
      let important = _.filter(
      this.filteredIssues.unfiltered.issues,
        (t) => t && t.important == true
      ); 
        let briefings = _.filter(
      this.filteredIssues.unfiltered.issues,
        (t) => t && t.reportable == true
      );
      let watched = _.filter(
      this.filteredIssues.unfiltered.issues,
        (t) => t && t.watched == true
      );
              
      let completed = _.filter(
      this.filteredIssues.unfiltered.issues,
        (t) => t && t.completed == true
      );
    let inProgress = _.filter(
      this.filteredIssues.unfiltered.issues,
        (t) => t && t.inProgress == true
      );
     let onHold = _.filter(this.filteredIssues.unfiltered.issues, (t) => t && t.onHold == true );
     let overdue = _.filter(this.filteredIssues.unfiltered.issues, (t) => t.isOverdue == true);

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
          count: inProgress.length - planned.length,
          // percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          // percentage: Math.round(overdue_percent),
        },       
      };
    },
  C_facilityManagerIssueFilter: {
    get() {
      return this.getAdvancedFilter
    },
    set(value) {
      this.setAdvancedFilter(value)
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
  C_issueTypeFilter: {
    get() {
      return this.issueTypeFilter
    },
    set(value) {
      this.setIssueTypeFilter(value)
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
  C_issueSeverityFilter: {
    get() {
      return this.issueSeverityFilter
    },
    set(value) {
      this.setIssueSeverityFilter(value)
    }
  },
  C_myIssues: {
    get() {
      return _.map(this.myActionsFilter, 'value').includes('issues')
    },
    set(value) {
      if (value) this.setMyActionsFilter([...this.myActionsFilter, { name: "My Issues", value: "issues" }])
      else this.setMyActionsFilter(this.myActionsFilter.filter(f => f.value !== "issues"))
    }
  }
}
}
</script>
<style lang="scss" scoped>
.issues-index {
  height: 465px;
}

.addIssueBtn,
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

#issueHover:hover {
  cursor: pointer;
  background-color: rgba(91, 192, 222, 0.3);
  border-left: solid rgb(91, 192, 222);
}

.alt-text {
  position: relative;
  padding-top: 80px !important;
}

input[type=search] {
  color: #383838;
  text-align: left;
  cursor: pointer;
  display: block;
}

.myIssues {
  float: right;
  margin-top: 5px;
}

#issueHover {
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

.hideLabels {
  font-weight: 600;
}

/deep/.v-input__control {
  display: block !important;
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