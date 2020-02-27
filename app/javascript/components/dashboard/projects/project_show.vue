<template>
  <div v-if="!loading" class="mt-4">
    <div v-if="showProject">
      <div>
        <h4 class="facility-name mt-3 text-center">{{facility.facilityName}}</h4>
        <div class="mt-3 d-flex mx-4">
          <span class="fbody-icon"><i class="fas fa-check"></i></span>
          <h5 class="project-name font-weight-normal text-secondary ml-2">{{ DV_project.name }}</h5>
        </div>
        <div class="mt-3 d-flex mx-4 align-items-center mb-3">
          <span class="fbody-icon">
            <i class="fas fa-exclamation-circle"></i>
          </span>
          <div>{{DV_project.projectType}}</div>
          <div class=" ml-2 badge badge-pill" :class="{ 'badge-success':
            DV_project.status == 'completed', 'badge-warning': DV_project.status == 'pending' }">
            {{DV_project.status}}
          </div>
        </div>
        <!-- <div class="progress-wrapper mt-3">
          <i class="fas fa-spinner progress-icon"></i>
          <div class="progress ">
            <div class="progress-bar bg-info" role="progressbar" style="width: 50%" aria-valuemax="100">60%</div>
          </div>
        </div> -->
        <div class="mt-3 mx-4">
          <span class="font-italic text-secondary">Notes:</span>
          <p class="f-notes text-muted">
            {{DV_project.description || 'No description'}}
          </p>
        </div>
      </div>
      <div>
        <task-index
          v-if="DV_project"
          :project="DV_project"
          :facility="facility"
          @refresh-project="refreshProject"
          @show-hide="projectShowHide"
          @delete-task="taskDeleted"
        />
      </div>
    </div>
    <div v-else>
      <button
        class="btn btn-link float-right"
        style="margin-top:-30px"
        @click.prevent.stop="showProject=true"
      >
        back
      </button>
      <task-form
        :facility="facility"
        :project="DV_project"
        :task="currentTask"
        :task-types="DV_taskTypes"
        :title="taskFormTitle"
        @task-created="taskCreated"
        @task-updated="taskUpdated"
        class="task-form-modal"
      />
    </div>
  </div>
</template>

<script>
  import TaskForm  from './../tasks/task_form'
  import TaskIndex from './../tasks/task_index'
  import http      from './../../../common/http'

  export default {
    name: 'ProjectShow',
    props: ['facility'],
    components: { TaskIndex, TaskForm },

    data() {
      return {
        loading: true,
        DV_project: {},
        DV_facility: {},
        DV_taskTypes: [],
        currentTask: null,
        showProject: true
      }
    },
    mounted() {
      this.fetchProject()
      this.fetchTaskTypes()
      if (this.facility) this.DV_facility = this.facility
    },
    methods: {
      fetchProject() {
        http
          .get(`/projects/${this.$route.params.projectId}.json`)
          .then((res) => {
            this.DV_project = res.data.project
            this.fetchTaskTypes()
          })
          .catch((err) => {
            console.error(err)
          })
      },
      fetchTaskTypes() {
        http
          .get(`/task_types.json`)
          .then((res) => {
            this.DV_taskTypes = res.data.taskTypes
            this.loading = false
          })
          .catch((err) => {
            console.error(err)
          })
      },
      taskCreated(task) {
        this.DV_facility.tasks.unshift(task)
        this.showProject = true
      },
      taskUpdated(task) {
        var index = this.DV_facility.tasks.findIndex((t) => t.id == task.id)
        this.DV_facility.tasks[index] = task
        this.showProject = true
      },
      taskDeleted(task) {
        http
          .delete(`/projects/${this.$route.params.projectId}/facilities/${this.DV_facility.id}/tasks/${task.id}.json`)
          .then((res) => {
            var tasks = [...this.DV_facility.tasks]
            _.remove(tasks, (t) => t.id == task.id)
            this.DV_facility.tasks = tasks
            this.$forceUpdate()
          })
          .catch((err) => console.log(err))
      },
      refreshProject() {
        this.loading = true
        this.fetchProject()
      },
      projectShowHide(task=null) {
        this.currentTask = task
        this.showProject = false;
      }
    },
    computed: {
      taskFormTitle() {
        return this.currentTask ? "Edit Task" : "Add a new Task"
      }
    },
    watch: {
      showProject(value) {
        if (value) {
          this.currentTask = null
        }
      }
    }
  }
</script>

<style lang="scss" scoped>
  .f-notes {
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 10px;
    height: 17vh;
  }
  .project-name {
    font-size: 15px;
  }
  .facility-name {
    font-size: 17px;
  }
  .progress {
    position: relative;
    left: 57px;
    bottom: 20px;
    max-width: 80%;
  }
  .progress-icon {
    left: 22px;
    position: relative;
  }
  .progress-wrapper {
    position: inherite;
  }
</style>
