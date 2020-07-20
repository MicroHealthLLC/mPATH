<template>
  <div class="mt-4">
    <div v-if="showProject">
      <div>
        <task-index
          v-if="currentProject"
          :project="currentProject"
          :facility="facility"
          :task-types="taskTypes"
          @show-hide="projectShowHide"
          @delete-task="taskDeleted"
        />
      </div>
    </div>
    <div v-else>
      <button
        class="btn btn-sm btn-link float-right"
        style="margin-top:-20px"
        @click.prevent.stop="showProject=true"
        >
        back
      </button>
      <task-form
        :facility="facility"
        :project="currentProject"
        :task="currentTask"
        :task-types="taskTypes"
        :title="taskFormTitle"
        @task-created="taskCreated"
        @task-updated="taskUpdated"
        class="task-form-modal"
      />
    </div>
  </div>
</template>

<script>
  import TaskForm from './../tasks/task_form'
  import TaskIndex from './../tasks/task_index'
  import http from './../../../common/http'
  import {mapGetters} from 'vuex'

  export default {
    name: 'ProjectShow',
    props: ['facility'],
    components: {TaskIndex, TaskForm},
    data() {
      return {
        loading: true,
        DV_facility: {},
        currentTask: null,
        showProject: true
      }
    },
    mounted() {
      if (this.facility) this.DV_facility = this.facility
    },
    methods: {
      taskCreated(task) {
        this.DV_facility.tasks.unshift(task)
        this.showProject = true
        this.$emit('refresh-facility')
      },
      taskUpdated(task) {
        var index = this.DV_facility.tasks.findIndex((t) => t.id == task.id)
        this.DV_facility.tasks[index] = task
        this.showProject = true
        this.$emit('refresh-facility')
      },
      taskDeleted(task) {
        http
          .delete(`/projects/${this.currentProject.id}/facilities/${this.DV_facility.id}/tasks/${task.id}.json`)
          .then((res) => {
            var tasks = [...this.DV_facility.tasks]
            _.remove(tasks, (t) => t.id == task.id)
            this.$emit('refresh-facility')
          })
          .catch((err) => console.log(err))
      },
      projectShowHide(task=null) {
        this.currentTask = task
        this.showProject = false;
      }
    },
    computed: {
      ...mapGetters([
        'currentProject',
        'taskTypes'
      ]),
      taskFormTitle() {
        return this.currentTask ? "Edit Task" : "Add a new Task"
      }
    },
    watch: {
      showProject(value) {
        if (value) {
          this.currentTask = null
        }
      },
      facility: {
        handler: function(value) {
          this.DV_facility = Object.assign({}, value)
        },
        deep: true
      }
    }
  }
</script>

<style lang="scss" scoped>
  .f-notes {
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 10px;
    height: 20vh;
    overflow: scroll;
  }
  .project-name {
    font-size: 15px;
  }
  .facility-name {
    font-size: 17px;
  }
  .progress {
    position: relative;
    left: 55px;
    bottom: 20px;
    max-width: 80%;
  }
  .progress-icon {
    left: 22px;
    position: relative;
  }
  .progress-wrapper {
    position: inherit;
  }
</style>
