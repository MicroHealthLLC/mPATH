<template>
  <div>
    <div v-if="!loading" class="m-3 pb-2">
      <div class="row">
        <div class="col-md-9">
          <div class="font-sm d-flex mb-1">
            <span class="fbody-icon"><i class="fas fa-check"></i></span>
            {{task.text}}
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
          <div class="row d-flex mb-1">
            <div class="font-sm col">
              <span class="fbody-icon"><i class="fas fa-tasks"></i></span>
              {{task.taskType}}
            </div>
          </div>
          <div class="row">
            <div class="font-sm col-md-6">
              <span class="fbody-icon"><i class="fas fa-calendar-alt"></i></span>
              {{formatDate(task.startDate)}}
            </div>
            <div class="font-sm col-md-6">
              <span class="fbody-icon"><i class="fas fa-calendar-alt"></i></span>
              {{formatDate(task.dueDate)}}
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="t_actions my-2">
            <span v-if="_isallowed('write')" class="edit-action" @click.prevent="editTask">
              <i class="fas fa-edit"></i>
            </span>
            <span v-if="_isallowed('delete')" class="delete-action" @click.prevent="deleteTask">
              <i class="fas fa-trash-alt"></i>
            </span>
            <span v-if="_isallowed('write')" class="watch_action" @click.prevent="toggleWatched">
              <span v-show="DV_task.watched" class="check_box"><i class="far fa-check-square"></i></span>
              <span v-show="!DV_task.watched" class="empty_box"><i class="far fa-square"></i></span>
              <span class="text-danger"><i class="fa fa-exclamation"></i></span>
            </span>
          </div>
          <div class="progress pg-content" :class="{'progress-0': task.progress <= 0}">
            <div class="progress-bar bg-info" :style="`width: ${task.progress}%`">{{task.progress}}%</div>
          </div>
        </div>
      </div>
    </div>

    <sweet-modal
      class="task_form_modal"
      ref="taskFormModal"
      :hide-close-button="true"
      :blocking="true"
      >
      <div v-if="has_task" class="w-100">
        <div class="modal_close_btn" @click="onCloseForm">
          <i class="fa fa-times"></i>
        </div>
        <task-form
          :facility="facility"
          :task="DV_task"
          title="Edit Task"
          @task-updated="updatedTask"
        ></task-form>
      </div>
    </sweet-modal>
  </div>
</template>

<script>
  import {mapGetters, mapMutations, mapActions} from "vuex"
  import TaskForm from "./task_form"
  import {SweetModal} from 'sweet-modal-vue'

  export default {
    name: 'TaskShow',
    components: {TaskForm, SweetModal},
    props: {
      fromView: {
        type: String,
        default: 'map_view'
      },
      task: Object
    },
    data() {
      return {
        loading: true,
        DV_task: {},
        has_task: false
      }
    },
    mounted() {
      if (this.task) {
        this.loading = false
        this.DV_task = this.task
      }
    },
    methods: {
      ...mapMutations([
        'updateTasksHash',
      ]),
      ...mapActions([
        'taskDeleted'
      ]),
      deleteTask() {
        var confirm = window.confirm(`Are you sure, you want to delete "${this.DV_task.text}"?`)
        if (!confirm) {return}
        this.taskDeleted(this.DV_task)
      },
      editTask() {
        if (this.fromView == 'map_view') {
          this.$emit('edit-task', this.DV_task)
        } else {
          this.has_task = Object.entries(this.DV_task).length > 0
          this.$refs.taskFormModal && this.$refs.taskFormModal.open()
        }
      },
      onCloseForm() {
        this.$refs.taskFormModal && this.$refs.taskFormModal.close()
        this.has_task = false
      },
      toggleWatched() {
        this.DV_task = {...this.DV_task, watched: !this.DV_task.watched}
        this.$emit('toggle-watched', this.DV_task)
      },
      updatedTask(task) {
        this.onCloseForm()
        this.DV_task = Object.assign({}, task)
        this.updateTasksHash({task: this.DV_task})
      }
    },
    computed: {
      ...mapGetters([
        'facilities',
        'facilityGroups'
      ]),
      _isallowed() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.tasks[salut]
      },
      is_overdue() {
        return this.DV_task.progress !== 100 && new Date(this.DV_task.dueDate).getTime() < new Date().getTime()
      },
      facility() {
        return this.facilities.find(f => f.id == this.DV_task.facilityId)
      },
      facilityGroup() {
        return this.facilityGroups.find(f => f.id == this.facility.facilityGroupId)
      }
    },
    watch: {
      task: {
        handler(value) {
          this.DV_task = Object.assign({}, value)
        },
        deep: true
      }
    }
  }
</script>

<style lang="scss" scoped>
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
  .pg-content {
    width: 100%;
    height: 20px;
    font-weight: bold;
  }
  .task_form_modal.sweet-modal-overlay {
    z-index: 10000001;
  }
  .task_form_modal.sweet-modal-overlay /deep/ .sweet-modal {
    min-width: 30vw;
    /*margin-top: 65px;*/
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

