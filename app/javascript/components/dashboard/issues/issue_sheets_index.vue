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
        <div class="simple-select mr-1 d-flex" style="width:35%">  
            <i class="fas fa-filter filter mr-1"></i>       
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
          <div class="simple-select mr-1" style="width:25%">
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
          <div class="simple-select mr-1 d-flex" style="width:20%">
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
          <div class="form-check-inline ml-2 mr-0">
            <label class="form-check-label mr-2">
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
            class="new-issue-btn btn btn-sm btn-primary mr-3 addBtns"
            @click.prevent="reportNew">
            <i class="fas fa-plus-circle"></i>
             Add Issue
           </button>      
        <div v-if="_isallowed('read')">   
          <div v-if="filteredIssues.length > 0"> 
            <div class="exportBtns">          
            <button
              @click="download"
              id="printBtn"
              class="btn btn-sm btn-dark mx-2">
              EXPORT TO PDF
            </button>
            <button
              disabled
              id="printBtn"
              class="btn btn-sm btn-outline-dark">
              EXPORT TO EXCEL
            </button>           
            <label class="form-check-label text-primary floatRight">
              <h5 class="total">Total: {{filteredIssues.length}}</h5>
            </label>    
            </div>      
            <div style="margin-bottom:50px">
              <table class="table table-sm table-bordered stickyTableHeader mt-2">                 
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
                    <th>Issue</th>
                    <th>Issue Type</th>
                    <th>Issue Severity</th>
                    <th>Start Date</th>
                    <th>Due Date</th>
                    <th>Assigned Users</th>
                    <th>Progress</th>
                    <th>Overdue</th>
                    <th>On Watch</th>
                    <th>Last Update</th>
                  </tr>           
              </table>
              <paginate name="filteredIssues" :list="filteredIssues" class="paginate-list pl-0" :per="15">
                <issue-sheets
                  v-for="(issue, i) in paginated('filteredIssues')"
                  id="issueHover"
                  :class="{'b_border': !!filteredIssues[i+1]}"
                  :key="issue.id"              
                  :issue="issue"
                  :from-view="from"
                  @issue-edited="issueEdited"
                  @toggle-watch-issue="toggleWatched"
                />
              </paginate>
              <div class="floatRight mt-3 mr-3">
                <paginate-links for="filteredIssues" :show-step-links="true" :limit="4"></paginate-links>
              </div>
            </div>
          </div>
          <p v-else class="text-danger ml-2">No issues found..</p>
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
  import IssueForm from './issue_form'
  import IssueSheets from './issue_sheets'
  import  {jsPDF} from "jspdf";
  import 'jspdf-autotable';
  import {mapGetters, mapMutations} from 'vuex'
  import moment from 'moment'
  Vue.prototype.moment = moment

  export default {
    name: 'IssueSheetsIndex',
    props: ['facility', 'from'],
    components: {IssueForm, IssueSheets},
    data() {
      return {
        viewList:'',
        listOptions: ['active','all', 'completed'],   
        loading: true,
        newIssue: false,
        viewList: 'active',
        currentIssue: null,
        now: new Date().toISOString(),
        paginate: ['filteredIssues']
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
      issueCreated(issue) {
        this.facility.issues.unshift(issue)
        this.newIssue = false
        this.$emit('refresh-facility')
      },
      issueUpdated(issue, refresh=true) {
        var index = this.facility.issues.findIndex((t) => t.id == issue.id)
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
            var issues = [...this.facility.issues]
            _.remove(issues, (t) => t.id == issue.id)
            this.$emit('refresh-facility')
          })
          .catch((err) => console.log(err))
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
        'myActionsFilter',
        'managerView',
        'onWatchFilter',
        'viewPermit'
      ]),
      _isallowed() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.issues[salut]
      },
      filteredIssues() {
        var typeIds = _.map(this.C_issueTypeFilter, 'id')
        var severityIds = _.map(this.C_issueSeverityFilter, 'id')
        var issues = _.sortBy(_.filter(this.facility.issues, ((issue) => {
          let valid = Boolean(issue && issue.hasOwnProperty('progress'))
          if (this.C_myIssues) {
            var userIds = [..._.map(issue.checklists, 'userId'), ...issue.userIds]
            valid  = valid && userIds.includes(this.$currentUser.id)
          }
          if (this.C_onWatchIssues) {
            valid  = valid && issue.watched
          }
          if (typeIds.length > 0) valid = valid && typeIds.includes(issue.issueTypeId)
          if (severityIds.length > 0) valid = valid && severityIds.includes(issue.issueSeverityId)
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
      }
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
    width: 20%;
    height: max-content;
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
  .paginate-links.filteredIssues {
    list-style: none !important;
    user-select: none;
    a {
      width: 30px;
      height: 36px;
      margin-right: 1px;    
      background-color: white;
      box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
      color: #383838;
      padding: 10px 24px;
      padding-bottom: 10px !important;
      cursor: pointer;
    }
    a:hover {
      background-color: #ededed;
    }
    li.active a {
      font-weight: bold;
      background-color: rgba(211, 211, 211, 10%);
    }
    a.active  {
      background-color: rgba(211, 211, 211, 10%);
    }
    li.next:before {
      content: ' | ';
      margin-right: 13px;
      color: #ddd;
    }
    li.disabled a {
      color: #ccc;
      cursor: no-drop;
    }
    li {
      display: inline !important;
      float: left;
      margin-bottom: 20px !important;
    }
  }

</style>
