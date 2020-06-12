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
        :issue-types="DV_issueTypes"
        :issue-severities="DV_issueSeverities"
        :issue-statuses="DV_issueStatuses"
        @issue-created="issueCreated"
        @issue-updated="issueUpdated"
        class="issue-form-modal"
      />
    </div>
    <div v-else>
      <div class="d-flex justify-content-between">
        <div class="issue-filters ml-2 d-flex justify-content-between align-items-center" :class="{'w-70': _isallowed, 'w-100': !_isallowed }">
          <select
            name="Issue Type"
            class="form-control form-control-sm"
            v-model="filters.issueType"
            >
            <option selected value="">Filter by Issue Type</option>
            <option v-for="opt in DV_issueTypes" :value="opt.id">
              {{opt.name}}
            </option>
          </select>
          <select
            name="Issue Severity"
            class="form-control form-control-sm ml-2"
            v-model="filters.issueSeverity"
            >
            <option selected value="">Filter by Issue Severity</option>
            <option v-for="opt in DV_issueSeverities" :value="opt.id">
              {{opt.name}}
            </option>
          </select>
        </div>
        <button v-if="_isallowed" class="btn btn-sm btn-light" @click.stop="newIssue=true">Report an Issue</button>
      </div>
      <div class="mt-1">
        <hr>
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
    </div>
  </div>
</template>

<script>
  import http from './../../../common/http'
  import IssueForm from './issue_form'
  import IssueShow from './issue_show'

  export default {
    name: 'ProjectShow',
    props: ['facility'],
    components: { IssueForm, IssueShow },

    data() {
      return {
        loading: true,
        newIssue: false,
        DV_issueTypes: [],
        DV_issueSeverities: [],
        DV_issueStatuses: [],
        currentIssue: null,
        filters: {
          issueType: '',
          issueSeverity: ''
        }
      }
    },
    mounted() {
      var cb = () => this.loading = false
      this.fetchIssueTypes(cb)
    },
    methods: {
      fetchIssueTypes(cb) {
        http
          .get(`/api/issue_types.json`)
          .then((res) => {
            this.DV_issueTypes = res.data.issueTypes
            this.fetchIssueStatuses(cb)
          })
          .catch((err) => {
            console.error(err)
          })
      },
      fetchIssueStatuses(cb) {
        http
          .get(`/api/issue_statuses.json`)
          .then((res) => {
            this.DV_issueStatuses = res.data.issueStatuses
            this.fetchIssueSeverities(cb)
          })
          .catch((err) => {
            console.error(err)
          })
      },
      fetchIssueSeverities(cb) {
        http
          .get(`/api/issue_severities.json`)
          .then((res) => {
            this.DV_issueSeverities = res.data.issueSeverities
            return cb()
          })
          .catch((err) => {
            console.error(err)
          })
      },
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
          .delete(`/projects/${this.$route.params.projectId}/facilities/${this.facility.id}/issues/${issue.id}.json`)
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
      }
    },
    computed: {
      _isallowed() {
        return ["admin", "subscriber"].includes(this.$currentUser.role)
      },
      filteredIssues() {
        return _.filter(this.facility.issues, ((issue) => {
          let valid = true
          if (this.filters.issueType) valid = valid && issue.issueTypeId == this.filters.issueType
          if (this.filters.issueSeverity) valid = valid && issue.issueSeverityId == this.filters.issueSeverity
          return valid;
        }))
      }
    }
  }
</script>

<style lang="scss" scoped>

</style>
