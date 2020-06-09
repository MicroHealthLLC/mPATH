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
      <div class="d-flex justify-content-end">
        <button v-if="_isallowed" class="btn btn-sm btn-light" @click.stop="newIssue=true">Report an Issue</button>
      </div>
      <div class="mt-1">
        <issue-show
          v-if="facility.issues.length > 0"
          v-for="issue in facility.issues"
          :key="issue.id"
          :issue="issue"
          :facility="facility"
          @issue-edited="issueEdited"
          @issue-deleted="issueDeleted"
        />
        <p v-else class="text-danger">No issues listed..</p>
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
        currentIssue: null
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
      }
    }
  }
</script>

<style lang="scss" scoped>

</style>
