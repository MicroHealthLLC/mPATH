<template>
  <div v-if="!loading" class="mt-4 issues-index">
    <div v-if="newIssue && from != 'manager_view'">
      <!-- <button
        class="btn btn-sm btn-link float-right"
        style="margin-top:-20px"
        @click.prevent.stop="newIssue=false"
        >
        back
      </button> -->
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
        <div class="d-flex w-100">
          <div class="simple-select w-100 mr-2">
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
          <div class="simple-select w-100 mr-2">
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
        <button v-if="_isallowed('write')" class="new-issue-btn btn btn-sm btn-light" @click.prevent="reportNew">Add Issue</button>
      </div>
      <div class="mx-2 mt-3 d-flex font-sm">
        <div class="form-check-inline mr-2">
          <label class="form-check-label">
            <input type="radio" class="form-check-input" v-model="viewList" value="active" name="listoption">Active
          </label>
        </div>
        <div class="form-check-inline mr-2">
          <label class="form-check-label">
            <input type="radio" class="form-check-input" v-model="viewList" value="completed" name="listoption">Completed
          </label>
        </div>
        <div class="form-check-inline mr-2">
          <label class="form-check-label">
            <input type="radio" class="form-check-input" v-model="viewList" name="listoption" value="all">All
          </label>
        </div>
        <div class="form-check-inline ml-auto mr-0">
          <label class="form-check-label">
            <input type="checkbox" class="form-check-input" v-model="C_myIssues">My Issue
          </label>
          <label v-if="viewPermit('watch_view', 'read')" class="form-check-label ml-2">
            <input type="checkbox" class="form-check-input" v-model="C_onWatchIssues">On Watch
          </label>
          <label class="form-check-label ml-2 text-primary">
            Total: {{filteredIssues.length}}
          </label>
        </div>
      </div>
      <div class="mt-1">
        <hr>
        <div v-if="_isallowed('read')">
          <div v-if="filteredIssues.length > 0">
            <button
            @click="download"
            id="printBtn"
            class="btn btn-sm btn-dark m-2"
            style="font-size:.70rem" >
            EXPORT TO PDF
          </button>
           <button
            disabled
            id="printBtn"
            class="btn btn-sm btn-outline-dark ml-1 mt-2 mb-2"
            style="font-size:.70rem" >
            EXPORT TO EXCEL
          </button>
          <hr/>
            <issue-show
              v-for="(issue, i) in filteredIssues"
              id="issueHover"
              :class="{'b_border': !!filteredIssues[i+1]}"
              :key="issue.id"
              :load="log(issue)"
              :issue="issue"
              :from-view="from"
              @issue-edited="issueEdited"
              @toggle-watch-issue="toggleWatched"
            />
          </div>
          <p v-else class="text-danger ml-2">No issues found..</p>
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
            <td>{{issue.users.join(', ')}}</td>
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
  import IssueForm from './issue_form'
  import IssueShow from './issue_show'
  import  {jsPDF} from "jspdf";
  import 'jspdf-autotable';
  import {mapGetters, mapMutations} from 'vuex'

  export default {
    name: 'IssueIndex',
    props: ['facility', 'from'],
    components: {IssueForm, IssueShow},

    data() {
      return {
        loading: true,
        newIssue: false,
        viewList: 'active',
        currentIssue: null, 
        now: new Date().toISOString()     
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
      log(issues) {
        console.log(issues)
      },
      download() {
        const doc = new jsPDF("l")
        const html =  this.$refs.table.innerHTML
        doc.autoTable({html: "#issueList1"})
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
        var typeIds = _.map(this.C_issueTypeFilter, 'id')
        var severityIds = _.map(this.C_issueSeverityFilter, 'id')
        var issues = _.sortBy(_.filter(this.facility.issues, ((issue) => {
          let valid = Boolean(issue && issue.hasOwnProperty('progress'))
          if (this.C_myIssues || this.issueUserFilter) {
            var userIds = [..._.map(issue.checklists, 'userId'), ...issue.userIds]
            if (this.C_myIssues) valid = valid && userIds.includes(this.$currentUser.id)
            if (this.issueUserFilter && this.issueUserFilter.length > 0) valid = valid && userIds.some(u => _.map(this.issueUserFilter, 'id').indexOf(u) !== -1)
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

<style lang="scss" scoped>
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
</style>
