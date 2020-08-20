<template>
  <div id="tasks-index" class="mt-3">
    <div v-if="_isallowed('read')">
      <div class="d-flex align-item-center justify-content-between mb-3 mx-2">
        <div class="simple-select w-100">
          <multiselect
            v-model="C_taskTypeFilter"
            track-by="name"
            label="name"
            placeholder="Filter by Task Type"
            :options="taskTypes"
            :searchable="false"
            :multiple="true"
            select-label="Select"
            deselect-label="Remove"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <button v-if="_isallowed('write')" class="new-tasks-btn btn btn-sm btn-light ml-2" @click.prevent="addNewTask">Add Task</button>
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
        <div class="form-check-inline ml-5">
          <label class="form-check-label">
            <input type="checkbox" class="form-check-input" v-model="C_myTasks">My Tasks
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
                <span v-if="_isallowed('write')" class="mr-3 edit-action" @click.prevent="editTask(task)">
                  <i class="fas fa-edit"></i>
                </span>
                <span v-if="_isallowed('delete')" class="delete-action" @click.prevent="deleteTask(task)">
                  <i class="fas fa-trash-alt"></i>
                </span>
              </div>
              <div class="progress pg-content" :class="{'progress-0': task.progress <= 0}">
                <div class="progress-bar bg-info" :style="`width: ${task.progress}%`">{{task.progress}}%</div>
              </div>
            </div>
          </div>
        </li>
      </ul>
      <p v-else class="text-danger m-3">No tasks found..</p>
    </div>
    <p v-else class="text-danger mx-2"> You don't have permissions to read!</p>
  </div>
</template>

<script>
  import {mapGetters, mapMutations} from "vuex"
  export default {
    name: 'TasksIndex',
    props: ['facility', 'project', 'taskTypes'],
    data() {
      return {
        DV_project: this.project,
        viewList: 'active'
      }
    },
    methods: {
      ...mapMutations([
        'setTaskTypeFilter',
        'setMyActionsFilter'
      ]),
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
      ...mapGetters([
        'taskTypeFilter',
        'myActionsFilter'
      ]),
      _isallowed() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.tasks[salut]
      },
      filteredTasks() {
        var typeIds = _.map(this.C_taskTypeFilter, 'id')
        var tasks = _.sortBy(_.filter(this.facility.tasks, (task) => {
          var valid = Boolean(task && task.hasOwnProperty('progress'))
          if (this.C_myTasks) {
            var userIds = [..._.map(task.checklists, 'userId'), ...task.userIds]
            valid  = valid && userIds.includes(this.$currentUser.id)
          }
          if (typeIds.length > 0) valid = valid && typeIds.includes(task.taskTypeId)
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

        return tasks
      },
      C_taskTypeFilter: {
        get() {
          return this.taskTypeFilter
        },
        set(value) {
          this.setTaskTypeFilter(value)
        }
      },
      C_myTasks: {
        get() {
          return _.map(this.myActionsFilter, 'value').includes('tasks')
        },
        set(value) {
          if (value) this.setMyActionsFilter([...this.myActionsFilter, {name: "My Tasks", value: "tasks"}])
          else this.setMyActionsFilter(this.myActionsFilter.filter(f => f.value !== "tasks"))
        }
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
    height: max-content;
    width: 20%;
  }
  .t_actions span {
    font-size: 13px;
  }
  .pg-content {
    width: 100%;
    height: 20px;
    font-weight: bold;
  }
</style>
