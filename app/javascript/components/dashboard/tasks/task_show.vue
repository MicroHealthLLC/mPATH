<template>
  <div v-if="!loading" class="mx-3 pb-2">
    <div class="row">
      <div class="col-md-9">
        <div class="font-sm d-flex mb-1">
          <span class="fbody-icon"><i class="fas fa-check"></i></span>
          {{task.text}}
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
        <div class="t_actions my-2" :class="{'justify-content-end': !withActions}">
          <span v-if="withActions && _isallowed('write')" class="edit-action" @click.prevent="$emit('edit-task', task)">
            <i class="fas fa-edit"></i>
          </span>
          <span v-if="withActions && _isallowed('delete')" class="delete-action" @click.prevent="deleteTask">
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
</template>

<script>
  export default {
    name: 'TaskShow',
    props: {
      withActions: {
        type: Boolean,
        default: true
      },
      task: Object
    },
    data() {
      return {
        loading: true,
        DV_task: {}
      }
    },
    mounted() {
      if (this.task) {
        this.loading = false
        this.DV_task = this.task
      }
    },
    methods: {
      deleteTask() {
        var confirm = window.confirm(`Are you sure, you want to delete "${this.DV_task.text}"?`)
        if (!confirm) return;
        this.$emit('delete-task', this.DV_task)
      },
      toggleWatched() {
        this.DV_task = {...this.DV_task, watched: !this.DV_task.watched}
        this.$emit('toggle-watched', this.DV_task)
      }
    },
    computed: {
      _isallowed() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.tasks[salut]
      }
    },
    watch: {
      task: {
        handler: function(value) {
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
</style>

