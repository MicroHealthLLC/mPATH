<template>
  <div v-if="!loading" class="issues_show m-3 pb-2">
    <div v-if="show" class="row">
      <div class="col-md-9">
        <div>
          <div class="mb-1 d-flex">
            <span class="fbody-icon"><i class="fas fa-check"></i></span>
            {{issue.title}}
          </div>
          <div class="row mb-1 d-flex">
            <div class="font-sm col">
              <span class="fbody-icon"><i class="fas fa-tasks"></i></span>
              {{issue.issueType}}
            </div>
            <div class="font-sm col">
              <span class="fbody-icon"><i class="fas fa-tasks"></i></span>
              {{issue.issueSeverity}}
            </div>
          </div>
          <div class="row mb-1">
            <div class="font-sm col-md-6">
              <span class="fbody-icon"><i class="fas fa-calendar-alt"></i></span>
              {{formatDate(issue.startDate)}}
            </div>
            <div class="font-sm col-md-6">
              <span class="fbody-icon"><i class="fas fa-calendar-alt"></i></span>
              {{formatDate(issue.dueDate)}}
            </div>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="crud-actions mx-3">
          <span v-if="_isallowed('write')" class="mr-2 font-sm edit-action" @click="$emit('issue-edited', issue)">
            <i class="fas fa-edit"></i>
          </span>
          <span v-if="_isallowed('delete')" class="font-sm delete-action" @click.stop="deleteIssue">
            <i class="fas fa-trash-alt"></i>
          </span>
        </div>
        <div class="row my-3 d-flex">
          <div class="font-sm col">
            <div class="progress pg-content" :class="{'progress-0': issue.progress <= 0}">
              <div class="progress-bar bg-info" :style="`width: ${issue.progress}%`">{{issue.progress}}%</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'IssueShow',
    props: ['facility', 'issue'],
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
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.issues[salut]
      },
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
