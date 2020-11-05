<template>
  <div>
    <div v-if="C_editForManager" class="blur_show text-center">
      <div class="text-danger d-flex align-items-center">
        <p class="mr-2 mb-0">Details</p>
        <i class="fas fa-long-arrow-alt-right"></i>
      </div>
    </div>
    <div v-if="!loading" class="issues_show mx-3 mb-3 mt-0 py-4 edit-action" :class="{'hide-to-edit': C_editForManager}" @click="editIssue">
      <div v-if="show">
        <div class="row">
          <div class="col-md-9">
            <div>
              <div class="mb-1 d-flex font-sm">
                <span class="fbody-icon"><i class="fas fa-check"></i></span>
                {{issue.title}}
                <span v-show="is_overdue" v-tooltip="`overdue`" class="warning-icon ml-2"><i class="fa fa-exclamation-triangle"></i></span>
              </div>

              <div class="row mb-1 d-flex" v-if="fromView == 'watch_view'">
                <div class="font-sm col">
                  <span class="fbody-icon"><i class="fa fa-bookmark"></i></span>
                  {{facility.facilityName}}
                </div>
                <div class="font-sm col">
                  <span class="fbody-icon"><i class="fa fa-object-group"></i></span>
                  {{facilityGroup.name}}
                </div>
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
            <div class="t_actions my-2">            
              <span v-if="_isallowed('delete')" class="font-sm delete-action" @click.stop="deleteIssue">
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

        <div v-if="fromView == 'watch_view'" class="mt-3 font-sm row">
          <div class="col-6">
            <div class="text-info">Related Tasks: </div>
            <ol class="pl-4">
              <li v-for="subTask in DV_issue.subTasks">
                <span class="btn btn-link btn-sm p-0 clickable" @click="openSubTask(subTask)">{{getTask(subTask).text}}</span>
              </li>
            </ol>
          </div>
          <div class="col-6">
            <div class="text-info">Related Issues: </div>
            <ol class="pl-4">
              <li v-for="subIssue in DV_issue.subIssues">
                <span class="btn btn-link btn-sm p-0 clickable" @click="openSubIssue(subIssue)">{{getIssue(subIssue).title}}</span>
              </li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <sweet-modal
      class="issue_form_modal"
      ref="issueFormModal"
      :hide-close-button="true"
      :blocking="true"
      >
      <div v-if="has_issue" class="w-100">
        <div class="modal_close_btn" @click="onCloseForm">
          <i class="fa fa-times"></i>
        </div>
        <task-form
          v-if="Object.entries(DV_edit_task).length"
          :facility="facility"
          :task="DV_edit_task"
          title="Edit Task"
          @task-updated="updateRelatedTaskIssue"
        ></task-form>

        <issue-form
          v-if="Object.entries(DV_edit_issue).length"
          :facility="facility"
          :issue="DV_edit_issue"
          @issue-updated="updateRelatedTaskIssue"
        ></issue-form>
      </div>
    </sweet-modal>
  </div>
</template>

<script>
  import {mapGetters, mapMutations, mapActions} from "vuex"
  import IssueForm from "./issue_form"
  import TaskForm from "./../tasks/task_form"
  import {SweetModal} from 'sweet-modal-vue'

  export default {
    name: 'IssueShow',
    components: {IssueForm, SweetModal, TaskForm},
    props: {
      fromView: {
        type: String,
        default: 'map_view'
      },
      issue: Object
    },
    data() {
      return {
        show: true,
        loading: true,
        DV_issue: {},
        DV_edit_task: {},
        DV_edit_issue: {},
        has_issue: false
      }
    },
    mounted() {
      if (this.issue) {
        this.loading = false
        this.DV_issue = this.issue
      }
    },
    methods: {
      ...mapMutations([
        'updateIssuesHash',
        'setTaskForManager'
      ]),
      ...mapActions([
        'issueDeleted',
        'taskUpdated'
      ]),
      editIssue() {
        if (this.fromView == 'map_view') {
          this.$emit('issue-edited', this.issue)
        }
        else if (this.fromView == 'manager_view') {
          this.setTaskForManager({key: 'issue', value: this.DV_issue})
        }
        else {
          this.DV_edit_issue = this.DV_issue
          this.has_issue = Object.entries(this.DV_issue).length > 0
          this.$refs.issueFormModal && this.$refs.issueFormModal.open()
        }
      },
      deleteIssue() {
        var confirm = window.confirm(`Are you sure, you want to delete this issue?`)
        if (!confirm) {return}
        this.issueDeleted(this.DV_issue)
      },
      openSubTask(subTask) {
        let task = this.currentTasks.find(t => t.id == subTask.id)
        if (!task) return
        this.has_issue = Object.entries(task).length > 0
        this.DV_edit_task = task
        this.$refs.issueFormModal && this.$refs.issueFormModal.open()
      },
      openSubIssue(subIssue) {
        let issue = this.currentIssues.find(t => t.id == subIssue.id)
        if (!issue) return
        this.has_issue = Object.entries(issue).length > 0
        this.DV_edit_issue = issue
        this.$refs.issueFormModal && this.$refs.issueFormModal.open()
      },
      onCloseForm() {
        this.$refs.issueFormModal && this.$refs.issueFormModal.close()
        this.has_issue = false
        this.DV_edit_task = {}
        this.DV_edit_issue = {}
      },
      toggleWatched() {
        if (this.DV_issue.watched) {
          var confirm = window.confirm(`Are you sure, you want to remove this issue from on-watch?`)
          if (!confirm) {return}
        }
        this.DV_issue = {...this.DV_issue, watched: !this.DV_issue.watched}
        this.$emit('toggle-watch-issue', this.DV_issue)
      },
      updateRelatedTaskIssue(task) {
        this.taskUpdated({facilityId: task.facilityId, projectId: task.projectId, cb: () => this.onCloseForm()})
      },
      getTask(task) {
        return this.currentTasks.find(t => t.id == task.id) || {}
      },
      getIssue(issue) {
        return this.currentIssues.find(t => t.id == issue.id) || {}
      }
    },
    computed: {
      ...mapGetters([
        'facilities',
        'facilityGroups',
        'managerView',
        'currentTasks',
        'currentIssues'
      ]),
      _isallowed() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.issues[salut]
      },
      is_overdue() {
        return this.DV_issue.progress !== 100 && new Date(this.DV_issue.dueDate).getTime() < new Date().getTime()
      },
      facility() {
        return this.facilities.find(f => f.id == this.DV_issue.facilityId)
      },
      facilityGroup() {
        return this.facilityGroups.find(f => f.id == this.facility.facilityGroupId)
      },
      C_editForManager() {
        return this.managerView.issue && this.managerView.issue.id == this.DV_issue.id
      }
    },
    watch: {
      issue: {
        handler: function(value) {
          this.DV_issue = Object.assign({}, value)
        }, deep: true
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
  .issue_form_modal.sweet-modal-overlay {
    z-index: 10000001;
  }
  .issue_form_modal.sweet-modal-overlay /deep/ .sweet-modal {
    min-width: 30vw;
    max-height: 80vh;
    .sweet-content {
      padding-top: 30px;
      text-align: unset;
    }
    .modal_close_btn {
      display: flex;
      position: absolute;
      top: 20px;
      right: 30px;
      font-size: 20px;
      cursor: pointer;
    }
  }
</style>
