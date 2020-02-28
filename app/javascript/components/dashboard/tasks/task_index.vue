<template>
  <div id="tasks-index" class="mt-3" >
    <div class="new-tasks-btn mb-3 mx-4">
      <a class="btn fav-btn" href="javascript:;" @click.prevent.stop="addNewTask">Add Task</a>
    </div>
    <ul class="list-group mx-4 rounded-lg">
      <li
        class="list-group-item mb-2"
        v-for="task in facility.tasks"
        :key="task.id"
      >
        <div class="row">
          <div class="col-md-9">
            <div class="text d-flex">
              <span class="fbody-icon"><i class="fas fa-check"></i></span>
              {{task.text}}
            </div>
            <div class="row d-flex">
              <div class="type col-md-6">
                <span class="fbody-icon"><i class="fas fa-tasks"></i></span>
                {{task.taskType}}
              </div>
              <div class="date col-md-6">
                <span class="fbody-icon"><i class="fas fa-calendar-alt"></i></span>
                {{task.dueDate}}
              </div>
            </div>
          </div>
          <div class="col-md-3">
            <div class="crud-actions my-2">
              <span class="mr-3 edit-action" @click.prevent="editTask(task)">
                <i class="fas fa-edit"></i>
              </span>
              <span class="delete-action" @click.prevent="deleteTask(task)">
                <i class="fas fa-trash-alt"></i>
              </span>
            </div>
            <div class="progress pg-content" :class="{'progress-0': task.progress <= 0}">
              <div class="progress-bar bg-info" :style="`width: ${task.progress}%`">{{task.progress}}%</div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="note d-flex col-md-9">
            <span class="fbody-icon"><i class="fas fa-file-alt"></i></span>
            <p>{{task.notes || 'Notes'}}</p>
          </div>
          <div class="col-md-3 mt-2">
            <span v-for="file in task.attachFiles">
              <span class="fbody-icon">
                <i class="fas fa-file-alt" @click.prevent="downloadFile(file)"></i>
              </span>
            </span>
          </div>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
  export default {
    name: 'TasksIndex',
    props: ['facility', 'project'],

    data() {
      return {
        DV_project: this.project
      }
    },
    methods: {
      addNewTask() {
        this.$emit('show-hide')
      },
      editTask(task) {
        this.$emit('show-hide', task)
      },
      deleteTask(task) {
        this.$emit('delete-task', task)
      },
      downloadFile(file) {
        // debugger
      }
    },
    watch: {
      project: {
        handler: function(value) {
          this.DV_project = value
        },
        deep: true
      }
    }
  }
</script>

<style lang="scss" scoped>
  .new-tasks-btn {
    display: flex;
    justify-content: flex-end;
    margin-top: 30px;
  }
  .text,
  .type,
  .date,
  .note,
  .crud-actions span {
    font-size: 13px;
  }
  .progress-0 {
    .progress-bar {
      margin-left: 1vw;
      color: #6c757d !important;
    }
  }
  .pg-content {
    width: 100%;
    height: 20px;
    font-weight: bold;
  }
</style>
