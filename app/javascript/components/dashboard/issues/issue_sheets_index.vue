<template>
  <div v-if="!loading" class="mt-4 issues-index" data-cy="issue_sheet_index">
    <div v-if="newIssue && from != 'manager_view'">
      <issue-form
        :facility="facility"
        :issue="currentIssue"
        @on-close-form="newIssue=false"
        @issue-created="issueCreated"
        @issue-updated="issueUpdated"
        class="issue-form-modal"
      />
    </div>
     <div v-else>      
      <div class="d-flex align-item-center">
        <div class="input-group mb-2 mr-1 task-search-bar" style="width:280px">
          <div class="input-group-prepend">
            <span class="input-group-text" id="search-addon"><i class="fa fa-search"></i></span>
          </div>
          <input type="search" 
            class="form-control form-control-sm" 
            placeholder="Search Issues" 
            aria-label="Search" 
            aria-describedby="search-addon" 
            v-model="issuesQuery"
            data-cy="search_issues"
            >
        </div>
        <div class="simple-select mr-1 justify-content-start">
            <multiselect
              v-model="C_taskTypeFilter"    
              style="width:325px"        
              track-by="name"
              label="name"
              placeholder="Filter by Task Category"
              :options="taskTypes"
              :searchable="false"
              :multiple="true"
              select-label="Select"
              deselect-label="Remove"
              >
              <template slot="singleLabel" slot-scope="{option}">
                <div class="d-flex">
                  <span class='select__tag-name'>{{option.name}}</span>
                </div>
              </template>
            </multiselect>
          </div>
        <div class="simple-select justify-content-start">
          <multiselect
            v-model="viewList"
            style="width:325px"
            :options="listOptions"           
            :searchable="false"
            :close-on-select="false"
            :show-labels="false"
            placeholder="Filter by Issue Status"
            data-cy="issue_status_list"
          >
            <template slot="singleLabel">
              <div class="d-flex">
                <span class='select__tag-name'>{{viewList}}</span>
              </div>
            </template>
          </multiselect>
        </div>  
        <div class="form-check-inline font-sm ml-auto">
          <label class="form-check-label mx-2">
            <input type="checkbox" class="form-check-input" v-model="C_myIssues">
            <i class="fas fa-user mr-1"></i>My Issues
          </label>
          <label v-if="viewPermit('watch_view', 'read')" class="form-check-label">
            <input type="checkbox" class="form-check-input" v-model="C_onWatchIssues">
            <i class="fas fa-eye mr-1"></i>On Watch
          </label>
         </div> 
       </div>
      <div class="d-flex align-item-center justify-content-start w-100">          
       <div class="simple-select mr-1 d-inline">        
          <multiselect
            v-model="C_issueTypeFilter"
            track-by="name"
            style="width:280px"
            label="name"
            class="issueTypeMs"
            placeholder="Filter by Issue Type"
            :options="issueTypes"
            :searchable="false"
            :multiple="true"
            select-label="Select"
            deselect-label="Remove"
          >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <div class="simple-select mr-1 d-flex">
          <multiselect
            v-model="C_issueSeverityFilter"
            track-by="name"
            style="width:325px"
            label="name"
            placeholder="Filter by Issue Severity"
            :options="issueSeverities"
            :searchable="false"
            :multiple="true"
            select-label="Select"
            deselect-label="Remove"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>  
         <div class="simple-select mr-1 d-flex">        
          <multiselect
            v-model="C_taskIssueOverdueFilter"
            track-by="name"
             style="width:325px"
            label="name"           
            placeholder="Task and Issue Overdue"
            :options="C_taskIssueOverdueOptions"
            :searchable="false"
            :multiple="false"
            select-label="Select"
            deselect-label="Remove"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>   
    </div>
  
      <div class="mt-2">
        <button v-if="_isallowed('write')"
          class="new-issue-btn btn btn-sm mr-2 btn-primary addBtns"
          @click.prevent="reportNew" data-cy="add_issue">
          <i class="fas fa-plus-circle mr-2"></i>
          Add Issue
        </button>
        <button
         @click.prevent="download"
         id="printBtn"
         class="btn btn-sm btn-dark exportBtn">
         <font-awesome-icon icon="file-pdf" />
         Export to PDF
        </button>            
       <label class="form-check-label text-primary float-right mr-2" data-cy="issue_total">
        <h5>Total: {{filteredIssues.length}}</h5>
       </label>
        <div v-if="_isallowed('read')">
          <div v-if="filteredIssues.length > 0">      
            <div style="margin-bottom:50px" data-cy="issues_table">
              <table class="table table-sm table-bordered stickyTableHeader mt-3">
                <colgroup>
                  <col class="oneFive" />
                  <col class="ten" />
                  <col class="nine" />
                  <col class="eight" />
                  <col class="eight" />
                  <col class="ten" />
                  <col class="nine" />
                  <col class="nine" />
                  <col class="nine" />
                  <col class="oneFive" />
                </colgroup>
                <tr style="background-color:#ededed">
                  <th class="sort-th" @click="sort('title')">Issue<i class="fas fa-sort scroll"></i></th>
                  <th class="sort-th" @click="sort('issueType')">Issue Type <i class="fas fa-sort scroll"></i> </th>
                  <th class="sort-th" @click="sort('issueSeverity')">Issue Severity<i class="fas fa-sort scroll ml-2"></i></th>
                  <th class="sort-th" @click="sort('startDate')">Start Date<i class="fas fa-sort scroll"></i></th>
                  <th class="sort-th" @click="sort('dueDate')">Due<br/>Date<i class="fas fa-sort scroll" ></i></th>
                  <th class="sort-th" @click="sort('responsibleUserNames')">Assigned Users<i class="fas fa-sort scroll"></i></th>
                  <th class="sort-th" @click="sort('progress')">Progress<i class="fas fa-sort scroll"></i></th>
                  <th class="sort-th" @click="sort('dueDate')">Overdue<i class="fas fa-sort scroll"></i></th>
                  <th class="sort-th" @click="sort('watched')">Onwatch<i class="fas fa-sort scroll"></i></th>
                  <th class="sort-th" @click="sort('notes')">Last Update<i class="fas fa-sort scroll"></i></th>               
                </tr>
              </table>            
                <issue-sheets
                  v-for="(issue, i) in sortedIssues"      
                  id="issueHover"
                  :class="{'b_border': !!filteredIssues[i+1]}"
                  :key="issue.id"
                  :issue="issue"
                  :from-view="from"
                  @issue-edited="issueEdited"
                  @toggle-watch-issue="toggleWatched"
                />
              <div class="float-right mb-4">
                <button class="btn btn-sm page-btns" @click="prevPage"><i class="fas fa-angle-left"></i></button> 
                  <button class="btn btn-sm page-btns" id="page-count">Page {{ currentPage }} of {{ Math.ceil(this.filteredIssues.length / pageSize) }}  </button> 
                <button class="btn btn-sm page-btns" @click="nextPage"><i class="fas fa-angle-right"></i></button>          
              </div>             
            </div>
          </div>
          <h6 v-if="filteredIssues.length == 0" class="text-danger" id="altText" data-cy="no_issue_found">No issues found..</h6>
        </div>
        <p v-else class="text-danger mx-2"> You don't have permissions to read!</p>
      </div>
    </div>
    <div>
      <table
        class="table table-sm table-bordered table-striped"
        ref="table" id="issueSheetsList1"
        style="display:none">
        <thead>
          <tr style="background-color:#ededed">
            <th>Issue</th>
            <th>Issue Type</th>
            <th>Facility</th>
            <th>Issue Severity</th>
            <th>Start Date</th>
            <th>Due Date</th>
            <th>Assigned Users</th>
            <th>Progress</th>
            <th>Overdue</th>
            <th>On Watch</th>
            <th>Last Update</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(issue, i) in filteredIssues">
            <td>{{issue.title}}</td>
            <td>{{issue.issueType}}</td>
            <td>{{issue.facilityName}}</td>
            <td>{{issue.issueSeverity}}</td>
            <td>{{formatDate(issue.startDate)}}</td>
            <td>{{formatDate(issue.dueDate)}}</td>
            <td v-if="(issue.responsibleUserNames.length) > 0">{{ issue.responsibleUserNames }}</td>
            <td v-else></td>
            <td>{{issue.progress + "%"}}</td>
            <td v-if="(issue.dueDate) <= now"><h5>X</h5></td>
            <td v-else></td>
            <td v-if="(issue.watched) <= now"><h5>X</h5></td>
            <td v-else></td>
            <td v-if="(issue.notes.length) > 0">
               By: {{ issue.notes[0].user.fullName}} on
              {{moment(issue.notes[0].createdAt).format('DD MMM YYYY, h:mm a')}}: {{issue.notes[0].body}}
            </td>
            <td v-else>No Updates</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
  import http from './../../../common/http'
  import {jsPDF} from "jspdf"
  import 'jspdf-autotable'
  import {mapGetters, mapMutations} from 'vuex'
  import IssueForm from './issue_form'
  import IssueSheets from './issue_sheets'
  import { library } from '@fortawesome/fontawesome-svg-core'
  import { faFilePdf } from '@fortawesome/free-solid-svg-icons'
  library.add(faFilePdf)
  import * as Moment from 'moment'
  import {extendMoment} from 'moment-range'
  const moment = extendMoment(Moment)
  export default {
    name: 'IssueSheetsIndex',
    props: ['facility', 'from'],
    components: {
      IssueForm,
      IssueSheets
    },
    data() {
      return {
        listOptions: ['active','all', 'completed'],
        loading: true,
        newIssue: false,
        viewList: 'active',
        currentIssue: null,
        now: new Date().toISOString(),
        issuesQuery: '',
        pageSize:15,
        currentPage:1,
        currentSort:'title',
        currentSortDir:'asc',
      }
    },
    mounted() {
      this.loading = false
    },
    methods: {
      ...mapMutations([
        'setTaskIssueOverdueFilter',
        'setIssueTypeFilter',
        'setIssueSeverityFilter',
        'setTaskTypeFilter',
        'setMyActionsFilter',
        'updateFacilityHash',
        'setTaskForManager',
        'setOnWatchFilter'
      ]),
      sort:function(s) {
      //if s == current sort, reverse
      if(s === this.currentSort) {
        this.currentSortDir = this.currentSortDir==='asc'?'desc':'asc';
      }
        this.currentSort = s;
      },
      nextPage:function() {
        if((this.currentPage*this.pageSize) < this.filteredIssues.length) this.currentPage++;
      },
      prevPage:function() {
        if(this.currentPage > 1) this.currentPage--;
      },
      issueCreated(issue) {
        this.facility.issues.unshift(issue)
        this.newIssue = false
        this.$emit('refresh-facility')
      },
      issueUpdated(issue, refresh=true) {
        let index = this.facility.issues.findIndex((t) => t.id == issue.id)
        if (index > -1) Vue.set(this.facility.issues, index, issue)
        if (refresh) {
          this.newIssue = false
          this.$emit('refresh-facility')
        } else {
          this.updateFacilityHash(this.facility)
        }
      },
      toggleWatched(issue) {
        http
          .put(`/projects/${this.currentProject.id}/facilities/${this.facility.id}/issues/${issue.id}.json`, {issue: issue})
          .then((res) => {
            this.issueUpdated(res.data.issue, false)
          })
          .catch((err) => console.log(err))
      },
      download() {
        const doc = new jsPDF("l")
        const html =  this.$refs.table.innerHTML
        doc.autoTable({html: "#issueSheetsList1"})
        doc.save("Issue_Log.pdf")
      },
      issueEdited(issue) {
        this.currentIssue = issue
        this.newIssue = true
      },
      reportNew() {
        if (this.from == "manager_view") {
          this.setTaskForManager({key: 'issue', value: {}})
        } else {
          this.currentIssue = null
          this.newIssue = true
        }
      }
   },
    computed: {
      ...mapGetters([
        'getTaskIssueOverdueOptions',
        'taskIssueOverdueFilter',
        'noteDateFilter',
        'taskIssueDueDateFilter',
        'currentProject',
        'issueTypes',
        'taskTypes',
        'issueSeverities',
        'issueTypeFilter',
        'issueSeverityFilter',
        'issueStageFilter',
        'taskTypeFilter',
        'issueUserFilter',
        'myActionsFilter',
        'managerView',
        'onWatchFilter',
        'viewPermit'
      ]),
      _isallowed() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.issues[salut]
      },
      filteredIssues() {
        let typeIds = _.map(this.C_issueTypeFilter, 'id')
        let taskTypeIds = _.map(this.C_taskTypeFilter, 'id')
        let severityIds = _.map(this.C_issueSeverityFilter, 'id')
        let stageIds = _.map(this.issueStageFilter, 'id')
        const search_query = this.exists(this.issuesQuery.trim()) ? new RegExp(_.escapeRegExp(this.issuesQuery.trim().toLowerCase()), 'i') : null
        let noteDates = this.noteDateFilter
        let taskIssueDueDates = this.taskIssueDueDateFilter
        let taskIssueOverdue = this.taskIssueOverdueFilter
        let issues = _.sortBy(_.filter(this.facility.issues, ((issue) => {
          let valid = Boolean(issue && issue.hasOwnProperty('progress'))
          if (this.C_myIssues || this.issueUserFilter) {
            let userIds = [..._.map(issue.checklists, 'userId'), ...issue.userIds]
            if (this.C_myIssues) valid = valid && userIds.includes(this.$currentUser.id)
            if (this.issueUserFilter && this.issueUserFilter.length > 0) valid = valid && userIds.some(u => _.map(this.issueUserFilter, 'id').indexOf(u) !== -1)
          }
          if (this.C_onWatchIssues) {
            valid  = valid && issue.watched
          }
          if (typeIds.length > 0) valid = valid && typeIds.includes(issue.issueTypeId)
          if (taskTypeIds.length > 0) valid = valid && taskTypeIds.includes(issue.taskTypeId)
          if (severityIds.length > 0) valid = valid && severityIds.includes(issue.issueSeverityId)
          if (stageIds.length > 0) valid = valid && stageIds.includes(issue.issueStageId)
          if(noteDates && noteDates[0] && noteDates[1]){
            var startDate = moment(noteDates[0], "YYYY-MM-DD")
            var endDate = moment(noteDates[1], "YYYY-MM-DD")
            var _notesCreatedAt = _.map(issue.notes, 'createdAt')
            var is_valid = issue.notes.length > 0
            for(var createdAt of _notesCreatedAt){
              var nDate = moment(createdAt, "YYYY-MM-DD")
              is_valid = nDate.isBetween(startDate, endDate, 'days', true)
              if(is_valid) break
            }
            valid = is_valid
          }
          if(taskIssueDueDates && taskIssueDueDates[0] && taskIssueDueDates[1]){
            var startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD")
            var endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD")
            var is_valid = true
            var nDate = moment(issue.dueDate, "YYYY-MM-DD")
            is_valid = nDate.isBetween(startDate, endDate, 'days', true)
            valid = is_valid
          }
          if(taskIssueOverdue && taskIssueOverdue[0] && taskIssueOverdue[0].name == "overdue"){
            valid = (issue.isOverdue == true)
          }
          if(taskIssueOverdue && taskIssueOverdue[0] &&  taskIssueOverdue[0].name == "not overdue"){
            valid = (issue.isOverdue == false)
          }
          if (search_query) valid = valid && search_query.test(issue.title)
          switch (this.viewList) {
            case "active": {
              valid = valid && issue.progress < 100
              break
            }
            case "completed": {
              valid = valid && issue.progress == 100
              break
            }
            default: {
              break
            }
          }
          return valid;
        })), ['dueDate'])
        return issues
      },
      C_taskIssueOverdueFilter: {
        get() {
          if(!this.taskIssueOverdueFilter){
            this.setTaskIssueOverdueFilter([{id: 'all', name: 'all'}])
          }
          return this.taskIssueOverdueFilter       
        },
        set(value) {
          if(!value){
            this.setTaskIssueOverdueFilter([{id: 'all', name: 'all'}])
          }else{
            this.setTaskIssueOverdueFilter([value])
          }
        }
      },
      C_taskIssueOverdueOptions() {
        return this.getTaskIssueOverdueOptions()
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
          if (value) this.setMyActionsFilter([...this.myActionsFilter, {name: "My Issues", value: "issues"}])
          else this.setMyActionsFilter(this.myActionsFilter.filter(f => f.value !== "issues"))
        }
      },
      C_onWatchIssues: {
        get() {
          return _.map(this.onWatchFilter, 'value').includes('issues')
        },
        set(value) {
          if (value) this.setOnWatchFilter([...this.onWatchFilter, {name: "On Watch Issues", value: "issues"}])
          else this.setOnWatchFilter(this.onWatchFilter.filter(f => f.value !== "issues"))
        }
      },
      sortedIssues:function() {
          return this.filteredIssues.sort((a,b) => {
          let modifier = 1;
          if(this.currentSortDir === 'desc') modifier = -1;
          if(a[this.currentSort] < b[this.currentSort]) return -1 * modifier;
          if(a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
          return 0;
           }).filter((row, index) => {
          let start = (this.currentPage-1)*this.pageSize;
          let end = this.currentPage*this.pageSize;
          if(index >= start && index < end) return true;
          return this.end
        });
      },
    }
  }
</script>

<style lang="scss">
  table {
    table-layout: fixed ;
    width: 100% ;
    margin-bottom: 0 !important;
  }
  .eight {
    width: 8%;
  }
  .nine {
    width: 9%;
  }
  .ten {
    width: 10%;
  }
  .oneFive {
    width: 15%;
  }
  th {
    font-size: .70rem !important;
  }
  .floatRight {
    text-align: right;
    right: 0px;
  }
  .issues-index {
    height: 465px;
  }
  .new-issue-btn {
    height: max-content;
    width: 100px;
  }
  #altText {
    position: absolute;
    margin-top: 50px
  }
  #issueHover:hover {
    cursor: pointer;
    background-color: rgba(91, 192, 222, 0.3);
    border-left: solid rgb(91, 192, 222);
  }
  .floatRight {
    text-align: right;
    position: absolute;
    right: 0px
  }
  .multiselect__tags {
    min-height: 25px !important;
  }
    .page-btns {
    width: 30px;
    border: none !important;
    height: 36px;
    margin-right: 1px;
    background-color: white;
    box-shadow: 0 5px 10px rgba(56,56, 56,0.19), 0 6px 6px rgba(56,56,56,0.23);
    color: #383838;
    padding: 10px 24px;
    padding-bottom: 10px !important;
    cursor: pointer;
 }
  .page-btns:hover {
    background-color: #ededed
  }
  .page-btns.active  {
    background-color: rgba(211, 211, 211, 10%);
    border:none !important;
 }
   #page-count {
    width: auto !important;
    cursor: default;
  }
  .my-issues {
    float: right !important;
    right: 0;
  }
</style>