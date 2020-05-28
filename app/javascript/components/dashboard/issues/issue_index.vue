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
      issues index
    </div>

  </div>
</template>

<script>
  import http from './../../../common/http'
  import IssueForm from './issue_form'

  export default {
    name: 'ProjectShow',
    props: ['facility'],
    components: { IssueForm },

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
      this.fetchIssueTypes()
      this.fetchIssueStatuses()
      this.fetchIssueSeverities()
      this.loading = false
    },
    methods: {
      fetchIssueTypes() {
        http
          .get(`/api/issue_types.json`)
          .then((res) => {
            this.DV_issueStatuses = res.data.DV_issueStatuses
          })
          .catch((err) => {
            console.error(err)
          })
      },
      fetchIssueStatuses() {
        http
          .get(`/api/issue_statuses.json`)
          .then((res) => {
            this.DV_issueTypes = res.data.issueTypes
          })
          .catch((err) => {
            console.error(err)
          })
      },
      fetchIssueSeverities() {
        http
          .get(`/api/issue_severities.json`)
          .then((res) => {
            this.DV_issueSeverities = res.data.issueSeverities
          })
          .catch((err) => {
            console.error(err)
          })
      },
      issueCreated(issue) {
        this.DV_facility.issues.unshift(issue)
        this.showProject = true
        this.$emit('refresh-facility')
      },
      issueUpdated(issue) {
        var index = this.DV_facility.issues.findIndex((t) => t.id == issue.id)
        this.DV_facility.issues[index] = issue
        this.showProject = true
        this.$emit('refresh-facility')
      },
      issueDeleted(issue) {
        http
          .delete(`/projects/${this.$route.params.projectId}/facilities/${this.DV_facility.id}/issues/${issue.id}.json`)
          .then((res) => {
            var issues = [...this.DV_facility.issues]
            _.remove(issues, (t) => t.id == issue.id)
            this.$emit('refresh-facility')
          })
          .catch((err) => console.log(err))
      }
    },
    computed: {

    }
  }
</script>

<style lang="scss" scoped>

</style>
