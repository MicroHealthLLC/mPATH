<template>
  <div v-if="!loading" class="mt-4">
    <div v-if="newIssue">
      <button
        class="btn btn-sm btn-link float-right"
        style="margin-top:-20px"
        @click.prevent.stop="newIssue=false"
        >
        back
      </button>
      <issue-form
        :facility="facility"
        :issue="currentIssue"
        :issue-types="issueTypes"
        :issue-severities="issueSeverities"
        @issue-created="issueCreated"
        @issue-updated="issueUpdated"
        class="issue-form-modal"
      />
    </div>
    <div v-else>
      <div class="d-flex justify-content-between">
        <div class="issue-filters ml-2 d-flex justify-content-between align-items-center" :class="{'w-70': _isallowed('write'), 'w-100': !_isallowed('write') }">
          <select
            name="Issue Type"
            class="form-control form-control-sm"
            v-model="filters.issueType"
            >
            <option selected value="">Filter by Issue Type</option>
            <option v-for="opt in issueTypes" :value="opt.id">
              {{opt.name}}
            </option>
          </select>
          <select
            name="Issue Severity"
            class="form-control form-control-sm ml-2"
            v-model="filters.issueSeverity"
            >
            <option selected value="">Filter by Issue Severity</option>
            <option v-for="opt in issueSeverities" :value="opt.id">
              {{opt.name}}
            </option>
          </select>
        </div>
        <button v-if="_isallowed('write')" class="btn btn-sm btn-light" @click.stop="reportNew">Report an Issue</button>
      </div>
      <div class="m-3">
        <div class="form-check-inline">
          <label class="form-check-label">
            <input type="radio" class="form-check-input" v-model="viewList" value="active" name="listoption">Active
          </label>
        </div>
        <div class="form-check-inline">
          <label class="form-check-label">
            <input type="radio" class="form-check-input" v-model="viewList" value="completed" name="listoption">Completed
          </label>
        </div>
        <div class="form-check-inline">
          <label class="form-check-label">
            <input type="radio" class="form-check-input" v-model="viewList" name="listoption" value="all">All
          </label>
        </div>
      </div>
      <div class="mt-1">
        <hr>
        <div v-if="_isallowed('read')">
          <div v-if="filteredIssues.length > 0">
            <issue-show
              v-for="issue in filteredIssues"
              :key="issue.id"
              :issue="issue"
              :facility="facility"
              @issue-edited="issueEdited"
              @issue-deleted="issueDeleted"
            />
          </div>
          <p v-else class="text-danger ml-2">No issues found..</p>
        </div>
        <p v-else class="text-danger mx-2"> You don't have permissions to read!</p>
      </div>
    </div>
  </div>
</template>

<script>
  import http from './../../../common/http'
  import IssueForm from './issue_form'
  import IssueShow from './issue_show'
  import {mapGetters} from 'vuex'

  export default {
    name: 'ProjectShow',
    props: ['facility'],
    components: {IssueForm, IssueShow},

    data() {
      return {
        loading: true,
        newIssue: false,
        viewList: 'active',
        currentIssue: null,
        filters: {
          issueType: '',
          issueSeverity: ''
        }
      }
    },
    mounted() {
      this.loading= false
    },
    methods: {
      issueCreated(issue) {
        this.facility.issues.unshift(issue)
        this.newIssue = false
        this.$emit('refresh-facility')
      },
      issueUpdated(issue) {
        var index = this.facility.issues.findIndex((t) => t.id == issue.id)
        this.facility.issues[index] = issue
        this.newIssue = false
        this.$emit('refresh-facility')
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
      issueEdited(issue) {
        this.currentIssue = issue
        this.newIssue = true
      },
      reportNew() {
        this.currentIssue = null
        this.newIssue = true
      }
    },
    computed: {
      ...mapGetters([
        'currentProject',
        'issueTypes',
        'issueSeverities',
      ]),
      _isallowed() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.issues[salut]
      },
      filteredIssues() {
        var issues = _.sortBy(_.filter(this.facility.issues, ((issue) => {
          let valid = Boolean(issue && issue.hasOwnProperty('progress'))
          if (this.filters.issueType) valid = valid && issue.issueTypeId == this.filters.issueType
          if (this.filters.issueSeverity) valid = valid && issue.issueSeverityId == this.filters.issueSeverity
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
      }
    }
  }
</script>

<style lang="scss" scoped>

</style>
