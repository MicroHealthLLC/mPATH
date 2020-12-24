<template>
  <div v-if="!loading" class="mt-4 issues-index" data-cy="issue_list">
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

    <div class="d-flex align-item-center justify-content-between w-100">
        <div class="input-group w-100">
            <div class="input-group-prepend d-inline">
              <span class="input-group-text" id="search-addon"><i class="fa fa-search"></i></span>
            </div>
            <input type="search"
                style="height:30px"
                class="form-control form-control-sm"
                placeholder="Search Issues"
                aria-label="Search"
                aria-describedby="search-addon"
                v-model="issuesQuery"
                data-cy="search_issues">
         </div>
          <div class="simple-select w-100 ml-1 font-sm">
            <multiselect
              v-model="C_taskTypeFilter"
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
     </div>
      <div class="d-flex font-sm w-100">        
        <div class="simple-select enum-select w-100">
          <multiselect
            v-model="viewList"
            style="width:100%"
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
         <div class="simple-select w-100 ml-1">
            <multiselect
              v-model="C_taskIssueOverdueFilter"
              track-by="name"
              label="name"            
              placeholder="Task and Issue Overdue"
              :options="getTaskIssueOverdueOptions"
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
      </div>

         <div class="d-flex align-item-center justify-content-between w-100">
          <div class="simple-select w-100 mr-1">
            <multiselect
              v-model="C_issueTypeFilter"
              track-by="name"
              label="name"
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
          <div class="simple-select w-100">
            <multiselect
              v-model="C_issueSeverityFilter"
              track-by="name"
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
      </div>
      <div class="mt-1">
        <button v-if="_isallowed('write')"
           class="btn btn-md btn-primary addIssueBtn mr-3"
           @click.prevent="addNewIssue"><font-awesome-icon icon="plus-circle" data-cy="new_issue" /> 
          Add Issue
          </button>
         <button
           v-tooltip="`Export to PDF`"
           @click.prevent="exportToPdf"
           class="btn btn-md mr-1 exportBtns text-light">
           <font-awesome-icon icon="file-pdf" />        
         </button>
         <button
          v-tooltip="`Export to Excel`"
          @click.prevent="exportToExcel('table', 'Issue Log')"
          class="btn btn-md exportBtns text-light">
          <font-awesome-icon icon="file-excel"/>         
        </button>
       <div class="form-check-inline font-sm myIssues mt-2 mr-0">
          <label class="form-check-label mr-2">
            <input type="checkbox" class="form-check-input" v-model="C_myIssues">
            <i class="fas fa-user mr-1"></i>My Issues
          </label>
          <label v-if="viewPermit('watch_view', 'read')" class="form-check-label ml-2">
            <input type="checkbox" class="form-check-input" v-model="C_onWatchIssues">
            <i class="fas fa-eye mr-1"></i>On Watch
          </label>
        </div>
        <div v-if="_isallowed('read')">
          <div v-if="filteredIssues.length > 0">
            <!-- <button
              disabled
              id="printBtn"
              class="btn btn-sm btn-outline-dark ml-2">
              Export to Excel
            </button> -->
            <hr/>
            <issue-show
              v-for="(issue, i) in filteredIssues"
              id="issueHover"
              :class="{'b_border': !!filteredIssues[i+1]}"
              :key="issue.id"
              :issue="issue"
              :from-view="from"
              @issue-edited="issueEdited"
            />
          </div>
          <div v-else>
            <br/>
            <h6 class="text-danger ml-1 mt-4">No issues found..</h6>
          </div>
        </div>
        <p v-else class="text-danger mx-2"> You don't have permissions to read!</p>
      </div>
    </div>
    <table style="display:none"
      class="table table-sm table-bordered"
      ref="table" id="issueList1"
      >
      <thead>
        <tr>
          <th></th>
          <th>Issue</th>
          <th>Issue Type</th>
          <th>Facility</th>
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
        <tr v-for="(issue, i) in filteredIssues">
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
          <td v-if="(issue.notes.length) > 0">
            By: {{ issue.notes[0].user.fullName}} on
            {{moment(issue.notes[0].createdAt).format('DD MMM YYYY, h:mm a')}}: {{issue.notes[0].body}}
          </td>
          <td v-else>No Updates</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
  import http from './../../../common/http'
  import {jsPDF} from "jspdf"
  import 'jspdf-autotable'
  import {mapGetters, mapMutations} from 'vuex'
  import IssueForm from './issue_form'
  import IssueShow from './issue_show'
  import { library } from '@fortawesome/fontawesome-svg-core'
  import { faFilePdf } from '@fortawesome/free-solid-svg-icons'
  library.add(faFilePdf)
  import * as Moment from 'moment'
  import {extendMoment} from 'moment-range'
  const moment = extendMoment(Moment)

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
        viewList: 'active',
        listOptions: ['active','all', 'completed'],
        currentIssue: null,
        now: new Date().toISOString(),
        issuesQuery: '',
        uri :'data:application/vnd.ms-excel;base64,',
        template:'<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="https://www.w3.org/TR/2018/SPSD-html401-20180327/"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
        base64: function(s){ return window.btoa(unescape(encodeURIComponent(s))) },
        format: function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) }
      }
    },
    mounted() {
      this.loading = false
    },
    methods: {
      ...mapMutations([
        'setTaskIssueOverdueFilter',
        'setIssueTypeFilter',
        'setTaskTypeFilter',
        'setIssueSeverityFilter',
        'setMyActionsFilter',
        'updateFacilityHash',
        'setTaskForManager',
        'setOnWatchFilter'
      ]),
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
      issueDeleted(issue) {
        http
          .delete(`/projects/${this.currentProject.id}/facilities/${this.facility.id}/issues/${issue.id}.json`)
          .then((res) => {
            let issues = [...this.facility.issues]
            _.remove(issues, (t) => t.id == issue.id)
            this.$emit('refresh-facility')
          })
          .catch((err) => console.log(err))
      },
      exportToPdf() {
        const doc = new jsPDF("l")
        const html =  this.$refs.table.innerHTML
        doc.autoTable({html: "#issueList1"})
        doc.save("Issue_Log.pdf")
      },
      exportToExcel(table, name){      
      if (!table.nodeType) table = this.$refs.table
      var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML}
      window.location.href = this.uri + this.base64(this.format(this.template, ctx))
      },
      issueEdited(issue) {
        this.currentIssue = issue
        this.newIssue = true
      },
      addNewIssue() {
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
        'taskTypeFilter',
        'issueSeverityFilter',
        'issueUserFilter',
        'myActionsFilter',
        'managerView',
        'onWatchFilter',
        'issueStageFilter',
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

          if(taskIssueOverdue){
            var overdueFilterNames = _.map(taskIssueOverdue, 'name')
            if(overdueFilterNames.includes("overdue")){
              valid = (issue.isOverdue == true)
            }
            if(overdueFilterNames.includes("not overdue")){
              valid = (issue.isOverdue == false)
            }
            if(overdueFilterNames.includes("overdue") && overdueFilterNames.includes("not overdue")){
              valid = true
            }
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
      }
    }
  }
</script>

<style lang="scss" scoped>
  .issues-index {
    height: 465px;
  }
  .addIssueBtn, .exportBtns {
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
 }
  .exportBtns { 
    transition: all .2s ease-in-out; 
    background-color: #41b883; 
  }
  .exportBtns:hover { transform: scale(1.06); }

  #issueHover:hover {
    cursor: pointer;
    box-shadow: 0.5px 0.5px 1px 1px rgba(56,56, 56,0.29), 0 2px 2px rgba(56,56,56,0.23);
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
    float:right;
    margin-top: 5px;
  }
   #issueHover {
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
  }
</style>
