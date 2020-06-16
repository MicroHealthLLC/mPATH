<template>
  <div id="tasks-index" class="mt-3">
    <div class="d-flex align-item-center justify-content-between mb-3">
      <div class="task-filters mx-2" :class="{'w-75': _isallowed, 'w-100': !_isallowed }">
        <select
          name="Task Type"
          class="form-control form-control-sm"
          v-model="filters.taskType"
          >
          <option selected value="">Filter by Task Type</option>
          <option v-for="opt in taskTypes" :value="opt.id">
            {{opt.name}}
          </option>
        </select>
      </div>
      <div v-if="permitted" class="new-tasks-btn mr-2">
        <a class="btn btn-sm btn-light" href="javascript:;" @click.prevent.stop="addNewTask">Add Task</a>
      </div>
    </div>
    <div class="m-3">
      <div class="form-check-inline">
        <label class="form-check-label">
          <input type="radio" class="form-check-input" v-model="viewList" value="active" name="listoption">Active
        </label>
      </div>
      <div class="form-check-inline">
        <label class="form-check-label">
          <input type="radio" class="form-check-input" v-model="viewList" value="completed" name="listoption">Completed
        </label>
      </div>
      <div class="form-check-inline">
        <label class="form-check-label">
          <input type="radio" class="form-check-input" v-model="viewList" name="listoption" value="all">All
        </label>
      </div>
    </div>
    <ul v-if="filteredTasks.length > 0" class="list-group mx-2 rounded-lg">
      <li
        class="list-group-item mb-2"
        v-for="task in filteredTasks"
        :key="task.id"
        >
        <div class="row">
          <div class="col-md-9">
            <div class="font-sm d-flex">
              <span class="fbody-icon"><i class="fas fa-check"></i></span>
              {{task.text}}
            </div>
            <div class="row d-flex">
              <div class="font-sm col">
                <span class="fbody-icon"><i class="fas fa-tasks"></i></span>
                {{task.taskType}}
              </div>
            </div>
            <div class="row">
              <div class="font-sm col-md-6">
                <span class="fbody-icon"><i class="fas fa-calendar-alt"></i></span>
                {{new Date(task.startDate).toLocaleDateString()}}
              </div>
              <div class="font-sm col-md-6">
                <span class="fbody-icon"><i class="fas fa-calendar-alt"></i></span>
                {{new Date(task.dueDate).toLocaleDateString()}}
              </div>
            </div>
          </div>
          <div class="col-md-3">
            <div v-if="permitted" class="crud-actions my-2">
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
        <!-- <div class="row">
          <div class="font-sm d-flex col-md-8">
            <span class="fbody-icon"><i class="fas fa-file-alt"></i></span>
            <p>{{task.notes || 'Description'}}</p>
          </div>
          <div class="col-md-4 mt-2">
            <span v-for="file in task.attachFiles">
              <span class="fbody-icon" v-tooltip.bottom="`${file.name}`" @click="downloadFile(file)">
                <i class="fas fa-file-alt"></i>
              </span>
            </span>
          </div>
        </div> -->
      </li>
    </ul>
    <p v-else class="text-danger m-3">No tasks found..</p>
  </div>
</template>

<script>
  export default {
    name: 'TasksIndex',
    props: ['facility', 'project', 'taskTypes'],

    data() {
      return {
        DV_project: this.project,
        filters: {
          taskType: ''
        },
        viewList: 'active'
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
        var confirm = window.confirm(`Are you sure, you want to delete "${task.text}"?`)
        if (!confirm) return;

        this.$emit('delete-task', task)
      }
    },
    computed: {
      permitted() {
        if (this.$currentUser.role === 'admin') return true
        if (this.$currentUser.role === 'subscriber' &&
          !(_.keys(this.$currentUser.abilities.cannot.manage).includes('Task'))
        ) return true

        return false
      },
      _isallowed() {
        return ["admin", "subscriber"].includes(this.$currentUser.role)
      },
      filteredTasks() {
        var tasks = _.sortBy(_.filter(this.facility.tasks, (task) => {
          var valid = Boolean(task && task.hasOwnProperty('progress'))
          if (this.filters.taskType) valid = valid && task.taskTypeId == this.filters.taskType
          switch (this.viewList) {
            case "active": {
              valid = valid && task.progress < 100
              break
            }
            case "completed": {
              valid = valid && task.progress == 100
              break
            }
            default: {
              break
            }
          }
          return valid
        }), ['dueDate'])

        var futureTasks = _.filter(tasks, (t => new Date(t.dueDate) >= new Date))
        var pastTasks = _.filter(tasks, (t => new Date(t.dueDate) < new Date))
        return [...futureTasks, ...pastTasks]
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
