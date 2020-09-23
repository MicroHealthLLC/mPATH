<template>
  <div v-if="!loading" class="issues_show mx-3 pb-2">
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
        <div class="t_actions my-2" :class="{'justify-content-end': !withActions}">
          <span v-if="withActions && _isallowed('write')" class="font-sm edit-action" @click="$emit('issue-edited', issue)">
            <i class="fas fa-edit"></i>
          </span>
          <span v-if="withActions && _isallowed('delete')" class="font-sm delete-action" @click.stop="deleteIssue">
            <i class="fas fa-trash-alt"></i>
          </span>
          <span v-if="_isallowed('write')" class="watch_action" @click.prevent="toggleWatched">
            <span v-show="DV_issue.watched" class="check_box"><i class="far fa-check-square"></i></span>
            <span v-show="!DV_issue.watched" class="empty_box"><i class="far fa-square"></i></span>
            <span class="text-danger"><i class="fa fa-exclamation"></i></span>
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
    props: {
      withActions: {
        type: Boolean,
        default: true
      },
      facility: Object,
      issue: Object
    },
    data() {
      return {
        show: true,
        loading: true,
        DV_issue: {}
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
      },
      toggleWatched() {
        this.DV_issue = {...this.DV_issue, watched: !this.DV_issue.watched}
        this.$emit('toggle-watch-issue', this.DV_issue)
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
    /*border-bottom: 1px solid #ccc;*/
  }
  .t_actions {
    display: flex;
    align-items: center;
    justify-content: space-between;
    span {
      font-size: 13px;
    }
    .empty_box,
    .check_box {
      font-size: 16px;
    }
  }
</style>
