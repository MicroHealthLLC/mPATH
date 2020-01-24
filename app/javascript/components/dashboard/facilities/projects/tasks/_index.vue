<template>
  <div id="tasks-index" class="mt-3">
    <div class="new-tasks-btn mb-3">
      <a class="btn fav-btn" href="javascript:;" @click.prevent.stop="addNewTask">Add Task</a>
    </div>  
    <ul class="list-group">
      <li class="list-group-item" v-for="task in DV_project.tasks" :key="DV_project+'-'+task.id">
        <div class="row">
          <div class="col-md-9">
            <div>text: {{task.text}}</div>
            <div class="row d-flex">
              <div class="col-md-6">type: {{task.taskType}}</div>
              <div class="col-md-6">due: {{task.dueDate}}</div>
            </div>
          </div>
          <div class="col-md-3">
            <div class="progress">
              <div class="progress-bar bg-info" :style="`width: ${task.progress}%`">{{task.progress}}%</div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-md-9">
            <p>{{task.notes || 'Notes'}}</p>
          </div>
          <div class="col-md-3">
            <div>
              <span><i class="far fa-file-alt"></i></span>
              <span class="ml-2"><i class="far fa-file-alt"></i></span>
            </div>
          </div>
        </div>
      </li>
    </ul>

    <sweet-modal 
      ref="taskForm" 
      overlay-theme="dark"
      @close="DV_taskForm = false"
    >
      <task-form
        v-if="DV_taskForm"
        :facility="facility"
        :project="project"
        @task-created="taskCreated"
        class="task-form-modal"
      ></task-form>
    </sweet-modal>
  </div>
</template>

<script>
  import {SweetModal} from 'sweet-modal-vue'
  import TaskForm     from './_form'
  export default {
    name: 'TasksIndex',
    props: ['facility', 'project'],
    components: {TaskForm, SweetModal},
    data() {
      return {
        DV_taskForm: false,
        DV_project: this.project
      }
    },
    methods: {
      addNewTask() {
        this.DV_taskForm = true
        this.$refs.taskForm.open()
      },
      taskCreated() {
        this.DV_taskForm = false
        this.$refs.taskForm.close()
        this.$emit('refresh-project')
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
  }
</style>
