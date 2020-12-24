<template>
  <div id="tasks-index" class="mt-3" data-cy="task_list">
    <div v-if="_isallowed('read')">
      <div class="d-flex align-item-center justify-content-between w-100">
        <div class="input-group w-100">
          <div class="input-group-prepend d-inline">
            <span class="input-group-text" id="search-addon"><i class="fa fa-search"></i></span>
          </div>
          <input type="search" style="height:30px" class="form-control form-control-sm" placeholder="Search Tasks.." aria-label="Search" aria-describedby="search-addon" v-model="tasksQuery" data-cy="search_tasks" />
        </div>
        <div class="d-flex simple-select w-100 font-sm ml-1">
          <multiselect v-model="C_taskTypeFilter" style="min-height:30px" track-by="name" label="name" placeholder="Filter by Task Category" :options="taskTypes" :searchable="false" :multiple="true" select-label="Select" deselect-label="Remove">
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
      </div>
      <div class="d-flex align-item-center font-sm justify-content-between my-1 w-100">
        <div class="simple-select w-100 mr-1">
          <multiselect v-model="C_taskIssueProgressStatusFilter" :options="getTaskIssueProgressStatusOptions" track-by="name" label="name" :multiple="true" select-label="Select" deselect-label="Remove" :searchable="false" :close-on-select="true" :show-labels="false" placeholder="Filter by Task Status" data-cy="task_status_list">
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <div class="simple-select w-100 enum-select">
          <multiselect v-model="C_taskIssueOverdueFilter" style="width:100%" track-by="name" label="name" placeholder="Task and Issue Overdue" :options="getTaskIssueOverdueOptions" :searchable="false" :multiple="true" select-label="Select" deselect-label="Remove">
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
      </div>
      <div class="mb-3 d-flex font-sm">
        <button v-if="_isallowed('write')" class="btn btn-sm btn-primary mr-2 addTaskBtn" @click.prevent="addNewTask"><i class="fas fa-plus-circle mr-2" data-cy="new_task"></i>
          Add Task
        </button>
        <button @click.prevent="download" class="btn btn-sm btn-dark mr-1 export2pdf">
          <font-awesome-icon icon="file-pdf" class="mr-2" />
          Export to PDF
        </button>
        <div class="form-check-inline font-sm ml-auto mr-0">
          <label class="form-check-label">
            <input type="checkbox" class="form-check-input" v-model="C_myTasks"> <i class="fas fa-user mr-1"></i>My Tasks
          </label>
          <label v-if="viewPermit('watch_view', 'read')" class="form-check-label ml-2">
            <input type="checkbox" class="form-check-input" v-model="C_onWatchTasks"> <i class="fas fa-eye mr-1"></i>On Watch
          </label>
        </div>
      </div>
      <div v-if="filteredTasks.length > 0">
        <hr />
        <task-show v-for="(task, i) in filteredTasks" id="taskHover" :class="{'b_border': !!filteredTasks[i+1]}" :key="task.id" :task="task" :from-view="from" @edit-task="editTask"></task-show>
      </div>
      <div v-else>
        <br />
        <h6 class="text-danger mt-4 ml-1">No tasks found..</h6>
      </div>
    </div>
    <p v-else class="text-danger mx-2"> You don't have permissions to read!</p>
    <table style="display:none" class="table table-sm table-bordered" ref="table" id="taskList1">
      <thead>
        <tr>
          <th></th>
          <th>Task</th>
          <th>Task Category</th>
          <th>Facility</th>
          <th>Start Date</th>
          <th>Due Date</th>
          <th>Assigned Users</th>
          <th>Progress</th>
          <th>Overdue</th>
          <th>Last Update</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(task, i) in filteredTasks">
          <td class="text-center">{{i+1}}</td>
          <td>{{task.text}}</td>
          <td>{{task.taskType}}</td>
          <td>{{task.facilityName}}</td>
          <td>{{formatDate(task.startDate)}}</td>
          <td>{{formatDate(task.dueDate)}}</td>
          <td class="ten" v-if="(task.users.length) > 0">{{JSON.stringify(task.users.map(users => (users.fullName))).replace(/]|[['"]/g, '')}}</td>
          <td class="ten" v-else></td>
          <td>{{task.progress + "%"}}</td>
          <td v-if="(task.dueDate) <= now">
            <h5>X</h5>
          </td>
          <td v-else></td>
          <td v-if="(task.notes.length) > 0">
            By: {{ task.notes[0].user.fullName}} on
            {{moment(task.notes[0].createdAt).format('DD MMM YYYY, h:mm a')}}: {{task.notes[0].body}}
          </td>
          <td v-else>No Updates</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
<script>
import { mapGetters, mapMutations } from "vuex"
import { jsPDF } from "jspdf"
import 'jspdf-autotable'
import TaskShow from "./task_show"
import { library } from '@fortawesome/fontawesome-svg-core'
import { faFilePdf } from '@fortawesome/free-solid-svg-icons'
library.add(faFilePdf)
import * as Moment from 'moment'
import { extendMoment } from 'moment-range'
const moment = extendMoment(Moment)

export default {
  name: 'TasksIndex',
  components: {
    TaskShow
  },
  props: ['facility', 'from'],
  data() {
    return {
      viewList: 'active',
      listOptions: ['active', 'all', 'completed'],
      now: new Date().toISOString(),
      tasksQuery: ''
    }
  },
  methods: {
    ...mapMutations([
      'setTaskIssueProgressStatusFilter',
      'setTaskIssueOverdueFilter',
      'setTaskTypeFilter',
      'setMyActionsFilter',
      'setOnWatchFilter',
      'setTaskForManager'
    ]),
    addNewTask() {
      if (this.from == "manager_view") {
        this.setTaskForManager({ key: 'task', value: {} })
      } else {
        this.$emit('show-hide')
      }
    },
    editTask(task) {
      this.$emit('show-hide', task)
    },
    download() {
      const doc = new jsPDF("l")
      const html = this.$refs.table.innerHTML
      doc.autoTable({ html: "#taskList1" })
      doc.text(150, 285, "Task List")
      doc.save("Task_List.pdf")
    },
  },
  computed: {
    ...mapGetters([
      'getTaskIssueProgressStatusOptions',
      'getTaskIssueProgressStatusFilter',
      'taskIssueProgressFilter',
      'getTaskIssueOverdueOptions',
      'taskIssueOverdueFilter',
      'taskTypeFilter',
      'noteDateFilter',
      'taskIssueDueDateFilter',
      'myActionsFilter',
      'onWatchFilter',
      'taskUserFilter',
      'taskTypes',
      'viewPermit',
      'taskStageFilter'
    ]),
    _isallowed() {
      return salut => this.$currentUser.role == "superadmin" || this.$permissions.tasks[salut]
    },
    filteredTasks() {
      let typeIds = _.map(this.C_taskTypeFilter, 'id')
      let stageIds = _.map(this.taskStageFilter, 'id')
      const search_query = this.exists(this.tasksQuery.trim()) ? new RegExp(_.escapeRegExp(this.tasksQuery.trim().toLowerCase()), 'i') : null
      let noteDates = this.noteDateFilter
      let taskIssueDueDates = this.taskIssueDueDateFilter
      let taskIssueOverdue = this.taskIssueOverdueFilter
      let taskIssueProgress = this.taskIssueProgressFilter
      let taskIssueProgressStatus = this.getTaskIssueProgressStatusFilter
      
      let tasks = _.sortBy(_.filter(this.facility.tasks, (task) => {
        let valid = Boolean(task && task.hasOwnProperty('progress'))
        if (this.C_myTasks || this.taskUserFilter) {
          let userIds = [..._.map(task.checklists, 'userId'), ...task.userIds]
          if (this.C_myTasks) valid = valid && userIds.includes(this.$currentUser.id)
          if (this.taskUserFilter && this.taskUserFilter.length > 0) valid = valid && userIds.some(u => _.map(this.taskUserFilter, 'id').indexOf(u) !== -1)
        }
        if (this.C_onWatchTasks) {
          valid = valid && task.watched
        }
        if (stageIds.length > 0) valid = valid && stageIds.includes(task.taskStageId)
        if (typeIds.length > 0) valid = valid && typeIds.includes(task.taskTypeId)

        if (noteDates && noteDates[0] && noteDates[1]) {
          var startDate = moment(noteDates[0], "YYYY-MM-DD")
          var endDate = moment(noteDates[1], "YYYY-MM-DD")
          var _notesCreatedAt = _.map(task.notes, 'createdAt')
          var is_valid = task.notes.length > 0
          for (var createdAt of _notesCreatedAt) {
            var nDate = moment(createdAt, "YYYY-MM-DD")
            is_valid = nDate.isBetween(startDate, endDate, 'days', true)
            if (is_valid) break
          }
          valid = is_valid
        }

        if (taskIssueDueDates && taskIssueDueDates[0] && taskIssueDueDates[1]) {
          var startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD")
          var endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD")

          var is_valid = true
          var nDate = moment(task.dueDate, "YYYY-MM-DD")
          is_valid = nDate.isBetween(startDate, endDate, 'days', true)
          valid = is_valid
        }

        if (taskIssueOverdue) {
          var overdueFilterNames = _.map(taskIssueOverdue, 'name')
          if (overdueFilterNames.includes("overdue")) {
            valid = (task.isOverdue == true)
          }
          if (overdueFilterNames.includes("not overdue")) {
            valid = (task.isOverdue == false)
          }
          if (overdueFilterNames.includes("overdue") && overdueFilterNames.includes("not overdue")) {
            valid = true
          }
        }
        if (taskIssueProgress && taskIssueProgress[0]) {
          var min = taskIssueProgress[0].value.split("-")[0]
          var max = taskIssueProgress[0].value.split("-")[1]
          valid = valid && (task.progress >= min && task.progress <= max)
        }

        if (taskIssueProgressStatus) {
          var taskIssueProgressStatusNames = _.map(taskIssueProgressStatus, 'name')
          valid = valid && taskIssueProgressStatusNames.includes(task.progressStatus)
        }

        if (search_query) valid = valid && search_query.test(task.text)

        return valid
      }), ['dueDate'])

      return tasks
    },
    C_taskIssueProgressStatusFilter: {
      get() {
        if (this.getTaskIssueProgressStatusFilter.length < 1) {
          this.setTaskIssueProgressStatusFilter([{ id: 'active', name: 'active' }])
        }
        return this.getTaskIssueProgressStatusFilter
      },
      set(value) {
        this.setTaskIssueProgressStatusFilter(value)
      }
    },
    C_taskIssueOverdueFilter: {
      get() {
        return this.taskIssueOverdueFilter
      },
      set(value) {
        this.setTaskIssueOverdueFilter(value)
      }
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
        if (value) this.setMyActionsFilter([...this.myActionsFilter, { name: "My Tasks", value: "tasks" }])
        else this.setMyActionsFilter(this.myActionsFilter.filter(f => f.value !== "tasks"))
      }
    },
    C_onWatchTasks: {
      get() {
        return _.map(this.onWatchFilter, 'value').includes('tasks')
      },
      set(value) {
        if (value) this.setOnWatchFilter([...this.onWatchFilter, { name: "On Watch Tasks", value: "tasks" }])
        else this.setOnWatchFilter(this.onWatchFilter.filter(f => f.value !== "tasks"))
      }
    }
  }
}
</script>
<style lang="scss" scoped>
#tasks-index {
  height: 465px;
  background-color: #ffffff;
  z-index: 100;
}

.new-tasks-btn {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19), 0 3px 3px rgba(56, 56, 56, 0.23);
}

#total {
  float: right;
  margin-right: 0;
  text-align: right;
}

.multiselect {
  border: #1d2124 !important;
}

#taskHover:hover {
  cursor: pointer;
  background-color: rgba(91, 192, 222, 0.3);
  border-left: solid rgb(91, 192, 222);
}

tfoot {
  text-align: right !important;
}

input[type=search] {
  color: #383838;
  text-align: left;
  cursor: pointer;
  display: block;
}

.addTaskBtn,
.export2pdf {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19), 0 3px 3px rgba(56, 56, 56, 0.23);
}

.myTasks {
  float: right !important;
  margin-top: 5px;
}

#taskHover {
  box-shadow: 0.5px 0.5px 1px 1px rgba(56, 56, 56, 0.29), 0 2px 2px rgba(56, 56, 56, 0.23);
}
</style>