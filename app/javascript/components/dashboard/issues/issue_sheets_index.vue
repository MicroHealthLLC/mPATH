<template>
  <div v-if="!loading" class="mt-4 issues-index">
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
      <div class="d-flex align-item-center justify-content-between">
        <div class="input-group mb-2 mr-1 task-search-bar">
          <div class="input-group-prepend">
            <span class="input-group-text" id="search-addon"><i class="fa fa-search"></i></span>
          </div>
          <input type="search" 
            class="form-control form-control-sm" 
            placeholder="Search Issues" 
            aria-label="Search" 
            aria-describedby="search-addon" 
            v-model="issuesQuery">
        </div>
        <div class="simple-select mr-1 d-flex" style="width:20%">        
          <multiselect
            v-model="C_issueTypeFilter"
            track-by="name"
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
        <div class="simple-select mr-1" style="width:20%">
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
        <div class="simple-select mr-1 d-flex" style="width:17%">
          <multiselect
            v-model="viewList"
            :options="listOptions"
            :searchable="false"
            :close-on-select="false"
            :show-labels="false"
            placeholder="Filter by Issue Status"
          >
            <template slot="singleLabel">
              <div class="d-flex">
                <span class='select__tag-name'>{{viewList}}</span>
              </div>
            </template>
          </multiselect>
        </div>        
        <div class="form-check-inline font-sm">
          <label class="form-check-label mr-1">
            <input type="checkbox" class="form-check-input" v-model="C_myIssues">
            <i class="fas fa-user mr-1"></i>My Issue
          </label>
          <label v-if="viewPermit('watch_view', 'read')" class="form-check-label">
            <input type="checkbox" class="form-check-input" v-model="C_onWatchIssues">
            <i class="fas fa-eye mr-1"></i>On Watch
          </label>
        </div>
      </div>
      <div class="mt-2">
        <button v-if="_isallowed('write')"
          class="new-issue-btn btn btn-sm mr-2 btn-primary addBtns"
          @click.prevent="reportNew">
          <i class="fas fa-plus-circle mr-2"></i>
          Add Issue
        </button>
        <button
         @click.prevent="download"
         id="printBtn"
         class="btn btn-sm btn-dark exportBtn">
         Export to PDF
        </button>            
       <label class="form-check-label text-primary float-right mr-2">
        <h5>Total: {{filteredIssues.length}}</h5>
       </label>
        <div v-if="_isallowed('read')">
          <div v-if="filteredIssues.length > 0">      
            <div style="margin-bottom:50px">
              <table class="table table-sm table-bordered stickyTableHeader mt-3">
                <colgroup>
                  <col class="seventeen" />
                  <col class="ten" />
                  <col class="nine" />
                  <col class="eight" />
                  <col class="eight" />
                  <col class="ten" />
                  <col class="eight" />
                  <col class="seven" />
                  <col class="six" />
                  <col class="seventeen" />
                </colgroup>
                <tr style="background-color:#ededed; font-size:.90rem">
                  <th class="sort-th" @click="sort('title')">Issue<i class="fas fa-sort scroll"></i></th>
                  <th class="sort-th" @click="sort('issueType')">Issue Type <i class="fas fa-sort scroll"></i> </th>
                  <th class="sort-th" @click="sort('issueSeverity')">Issue Severity<i class="fas fa-sort scroll ml-2"></i></th>
                  <th class="sort-th" @click="sort('startDate')">Start Date<i class="fas fa-sort scroll"></i></th>
                  <th class="sort-th" @click="sort('dueDate')">Due Date<i class="fas fa-sort scroll" ></i></th>
                  <th class="sort-th" @click="sort('users')">Assigned Users<i class="fas fa-sort scroll"></i></th>
                  <th class="sort-th" @click="sort('progress')">Progress<i class="fas fa-sort scroll"></i></th>
                  <th>Overdue</th>
                  <th>Onwatch</th>
                  <th>Last Update</th>               
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
          <h6 v-if="filteredIssues.length == 0" class="text-danger" id="altText">No issues found..</h6>
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
            <td>{{issue.users.join(', ')}}</td>
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
  import moment from 'moment'
  Vue.prototype.moment = moment

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
        pageSize:5,
        currentPage:1,
        currentSort:'text',
        currentSortDir:'asc',

      }
    },
    mounted() {
      this.loading = false
    },
    methods: {
      ...mapMutations([
        'setIssueTypeFilter',
        'setIssueSeverityFilter',
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
        'currentProject',
        'issueTypes',
        'issueSeverities',
        'issueTypeFilter',
        'issueSeverityFilter',
        'issueStageFilter',
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
        let severityIds = _.map(this.C_issueSeverityFilter, 'id')
        let stageIds = _.map(this.issueStageFilter, 'id')
        const search_query = this.exists(this.issuesQuery.trim()) ? new RegExp(_.escapeRegExp(this.issuesQuery.trim().toLowerCase()), 'i') : null
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
          if (severityIds.length > 0) valid = valid && severityIds.includes(issue.issueSeverityId)
          if (stageIds.length > 0) valid = valid && stageIds.includes(issue.issueStageId)
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
      C_issueTypeFilter: {
        get() {
          return this.issueTypeFilter
        },
        set(value) {
          this.setIssueTypeFilter(value)
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
  .five {
    width: 5%;
  }
  .six {
    width: 6%;
  }
  .seven {
    width: 7%;
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
  .seventeen {
    width: 17%;
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

</style>
