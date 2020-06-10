<template>
  <div v-if="!loading" class="issues_show m-3">
    <div v-if="show">
      <div v-if="_isallowed" class="crud-actions mx-3 float-right">
        <span class="mr-2 font-sm edit-action" @click="$emit('issue-edited', issue)">
          <i class="fas fa-edit"></i>
        </span>
        <span class="font-sm delete-action" @click.stop="deleteIssue">
          <i class="fas fa-trash-alt"></i>
        </span>
      </div>
      <div class="row">
        <div class="col-md-12">
          <div class="font-sm d-flex">
            <span class="fbody-icon"><i class="fas fa-check"></i></span>
            {{issue.title}}
          </div>
          <div class="row d-flex">
            <div class="font-sm col">
              <span class="fbody-icon"><i class="fas fa-tasks"></i></span>
              {{issue.issueType}}
            </div>
          </div>
          <div class="row d-flex">
            <div class="font-sm col">
              <span class="fbody-icon"><i class="fas fa-tasks"></i></span>
              {{issue.issueSeverity}}
            </div>
          </div>
          <div class="row d-flex">
            <div class="font-sm col">
              <span class="fbody-icon"><i class="fas fa-tasks"></i></span>
              {{issue.issueStatus}}
            </div>
          </div>
          <div class="row">
            <div class="font-sm col-md-6">
              <span class="fbody-icon"><i class="fas fa-calendar-alt"></i></span>
              {{new Date(issue.startDate).toLocaleDateString()}}
            </div>
            <div class="font-sm col-md-6">
              <span class="fbody-icon"><i class="fas fa-calendar-alt"></i></span>
              {{new Date(issue.dueDate).toLocaleDateString()}}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import http from './../../../common/http'
  import IssueForm from './issue_form'

  export default {
    props: ['facility', 'issue'],
    components: {IssueForm},
    data() {
      return {
        show: true,
        loading: true,
        DV_issue: null
      }
    },
    mounted() {
      if (this.issue) {
        this.loading = false
        this.DV_issue = this.issue
      }
    },
    methods: {
      deleteIssue() {
        var confirm = window.confirm(`Are you sure, you want to delete this issue?`)
        if (!confirm) return;
        this.$emit('issue-deleted', this.issue)
      }
    },
    computed: {
      _isallowed() {
        return ["admin", "subscriber"].includes(this.$currentUser.role)
      }
    },
    watch: {
      issue: {
        handler: function(value) {
          this.DV_issue = value
        },
        deep: true
      }
    }
  }
</script>

<style scoped lang="scss">
  .issues_show {
    border-bottom: 1px solid #ccc;
  }
  .issues_input {
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 15px;
  }
  .issue_body {
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 10px;
    word-break: break-word;
    max-height: 200px;
    overflow-y: auto;
  }
  .file-icon {
    cursor: pointer;
    font-size: 15px;
    color: gray;
    margin-right: 10px;
  }
</style>
