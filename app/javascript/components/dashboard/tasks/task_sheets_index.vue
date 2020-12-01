<template>
  <div id="tasks-index" class="my-4">
    <div v-if="_isallowed('read')">
      <div class="d-flex align-item-center justify-content-between mb-2">
        <div class="simple-select mr-1 d-flex" style="width:38%">
        <i class="fas fa-filter filter mr-1"></i>
          <multiselect
            v-model="C_taskTypeFilter"
            track-by="name"
            label="name"
            placeholder="Filter by Task Category"
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
        <div class="simple-select d-flex" style="width:35%">
        <multiselect
          v-model="viewList"
          :options="listOptions"
          :searchable="false"
          :close-on-select="false"
          :show-labels="false"
          placeholder="Filter by Task Status"
          >
          <template slot="singleLabel">
            <div class="d-flex">
              <span class='select__tag-name'>{{viewList}}</span>
            </div>
          </template>
        </multiselect>
        </div>
        <div class="input-group w-25 mx-2">
          <input type="text" class="form-control form-control-sm" placeholder="Search tasks.." aria-label="Search" aria-describedby="search-addon" v-model="tasksQuery">
        </div>
        <div class="form-check-inline mr-0" style="width:26%">
          <label class="form-check-label mx-2">
            <input type="checkbox" class="form-check-input" v-model="C_myTasks">
            <i class="fas fa-user mr-1"></i>My Tasks
          </label>
          <label v-if="viewPermit('watch_view', 'read')" class="form-check-label ml-2">
            <input type="checkbox" class="form-check-input" v-model="C_onWatchTasks">
            <i class="fas fa-eye mr-1"></i>On Watch
          </label>
        </div>
      </div>
      <button v-if="_isallowed('write')"
        class="new-tasks-btn addBtns btn mr-3 btn-sm btn-primary"
        @click.prevent="addNewTask">
        <i class="fas fa-plus-circle mr-2"></i>
        Add Task
      </button>
      <div v-if="filteredTasks.length > 0">
        <button
          @click="download"
          id="printBtn"
          class="btn btn-sm btn-outline-dark exportBtn">
          Export to PDF
        </button>
        <button
          disabled
          id="printBtn"
          class="btn btn-sm btn-outline-dark">
          Export to Excel
        </button>
        <label class="form-check-label text-primary float-right mr-2">
          <h5>Total: {{filteredTasks.length}}</h5>
        </label>
        <div style="margin-bottom:100px">
          <table class="table table-sm table-bordered table-striped mt-3 stickyTableHeader">
            <colgroup>
              <col class="twenty" />
              <col class="ten" />
              <col class="eight" />
              <col class="eight" />
              <col class="ten" />
              <col class="eight" />
              <col class="eight" />
              <col class="eight" />
              <col class="twenty" />
            </colgroup>
            <tr style="background-color:#ededed">
              <th>Task</th>
              <th>Task Category</th>
              <th>Start Date</th>
              <th>Due Date</th>
              <th>Assigned Users</th>
              <th>Progress</th>
              <th>Overdue</th>
              <th>On Watch</th>
              <th>Last Update</th>
            </tr>
          </table>
          <paginate name="filteredTasks" :list="filteredTasks" class="paginate-list pl-0" :per="15">
            <task-sheets
              v-for="(task, i) in paginated('filteredTasks')"
              class="taskHover"
              href="#"
              :class="{'b_border': !!filteredTasks[i+1]}"
              :key="task.id"
              :task="task"
              :from-view="from"
              @edit-task="editTask"
              @toggle-watched="toggleWatched"
            />
          </paginate>
          <div class="floatRight pagination mr-3 my-3">
            <paginate-links for="filteredTasks" :show-step-links="true" :limit="4"></paginate-links>
          </div>
        </div>
      </div>
      <h6 v-else class="text-danger alt-text">No tasks found..</h6>
    </div>
    <p v-else class="text-danger mx-2"> You don't have permissions to read!</p>
    <table
      class="table table-sm table-bordered table-striped"
      ref="table" id="taskSheetsList1"
      style="display:none"
      >
      <thead>
        <tr style="background-color:#ededed">
          <th>Task</th>
          <th>Task Category</th>
          <th>Facility</th>
          <th>Start Date</th>
          <th>Due Date</th>
          <th>Assigned Users</th>
          <th>Progress</th>
          <th>Overdue</th>
          <th>On Watch</th>
          <th>Last Update</th>
        </tr>
      </thead>
      <tbody>
        <tr  v-for="(task, i) in filteredTasks">
          <td>{{task.text}}</td>
          <td>{{task.taskType}}</td>
          <td>{{task.facilityName}}</td>
          <td>{{formatDate(task.startDate)}}</td>
          <td>{{formatDate(task.dueDate)}}</td>
          <td>{{task.users.join(', ')}}</td>
          <td>{{task.progress + "%"}}</td>
          <td v-if="(task.dueDate) <= now"><h5>X</h5></td>
          <td v-else></td>
          <td v-if="(task.watched) == true"><h5>X</h5></td>
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
  import {mapGetters, mapMutations} from "vuex"
  import {jsPDF} from "jspdf"
  import 'jspdf-autotable'
  import moment from 'moment'
  import TaskSheets from "./task_sheets"
  Vue.prototype.moment = moment

  export default {
    name: 'TasksSheetsIndex',
    components: {
      TaskSheets
    },
    props: ['facility', 'from'],
    data() {
      return {
        viewList:'active',
        listOptions: ['active','all', 'completed'],
        paginate: ['filteredTasks'],
        tasks: Object,
        now: new Date().toISOString(),
        tasksQuery: ''
      }
    },
    methods: {
      ...mapMutations([
        'setTaskTypeFilter',
        'setMyActionsFilter',
        'setOnWatchFilter',
        'setTaskForManager'
      ]),
      addNewTask() {
        if (this.from == "manager_view") {
          this.setTaskForManager({key: 'task', value: {}})
        } else {
          this.$emit('show-hide')
        }
      },
      editTask(task) {
        this.$emit('show-hide', task)
      },
      toggleWatched(task) {
        this.$emit('toggle-watch-task', task)
      },
      download() {
        const doc = new jsPDF("l")
        const html =  this.$refs.table.innerHTML
        doc.autoTable({html: "#taskSheetsList1"})
        doc.save("Task_List.pdf")
      },
    },
    computed: {
      ...mapGetters([
        'taskTypeFilter',
        'taskStageFilter',
        'myActionsFilter',
        'onWatchFilter',
        'taskUserFilter',
        'taskTypes',
        'viewPermit'
      ]),
      _isallowed() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.tasks[salut]
      },
      filteredTasks() {
        let typeIds = _.map(this.C_taskTypeFilter, 'id')
        let stageIds = _.map(this.taskStageFilter, 'id')
        const search_query = this.exists(this.tasksQuery.trim()) ? new RegExp(_.escapeRegExp(this.tasksQuery.trim().toLowerCase()), 'i') : null

        let tasks = _.sortBy(_.filter(this.facility.tasks, (task) => {
          let valid = Boolean(task && task.hasOwnProperty('progress'))
          if (this.C_myTasks || this.taskUserFilter) {
            let userIds = [..._.map(task.checklists, 'userId'), ...task.userIds]
            if (this.C_myTasks) valid = valid && userIds.includes(this.$currentUser.id)
            if (this.taskUserFilter && this.taskUserFilter.length > 0) valid = valid && userIds.some(u => _.map(this.taskUserFilter, 'id').indexOf(u) !== -1)
          }
          if (this.C_onWatchTasks) {
            valid  = valid && task.watched
          }
          if (typeIds.length > 0) valid = valid && typeIds.includes(task.taskTypeId)
          if (stageIds.length > 0) valid = valid && stageIds.includes(task.taskStageId)
          if (search_query) valid = valid && search_query.test(task.text)

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
      },
      C_onWatchTasks: {
        get() {
          return _.map(this.onWatchFilter, 'value').includes('tasks')
        },
        set(value) {
          if (value) this.setOnWatchFilter([...this.onWatchFilter, {name: "On Watch Tasks", value: "tasks"}])
          else this.setOnWatchFilter(this.onWatchFilter.filter(f => f.value !== "tasks"))
        }
      }
    }
  }
</script>

<style lang="scss">
  #tasks-index {
    background-color: #ffffff;
    z-index: 100;
    height: 500px
  }
  .new-tasks-btn {
    height: max-content;
    width: 100px;
  }
  .addBtns {
    position: absolute;
  }
  .alt-text {
    position: relative;
    margin-top: 50px;
    margin-left: 2px;
  }
  #printBtn {
    font-size: .80rem;
  }
  #printBtn, .addBtns, .paginate-links.filteredTasks {
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
  }
  .exportBtn {
    margin-left: 130px;
  }
  #total {
    margin-right: 18px;
    line-height: 3 !important;
  }
  .filter {
    color: #ced4da !important;
    border: solid #ced4da .8px !important;
    padding: 4px;
    font-size: 2rem;
    border-radius: 4px;
    padding: 4px;
  }
  .taskHover:hover {
    cursor: pointer;
    background-color: rgba(91, 192, 222, 0.3);
    border-left: solid rgb(91, 192, 222);
  }
  table {
    table-layout: fixed;
    width: 100%;
    position: relative;
    margin-bottom: 0 !important;
  }
  .stickyTableHeader {
    position: sticky;
    position: -webkit-sticky;
    justify-content: center;
    z-index: 10;
    left: 15;
    top: 0;
    width: 100%;
  }
  .eight {
    width: 8%;
  }
  .ten {
    width: 10%;
  }
  .twenty {
    width: 20%;
  }
  .floatRight {
    text-align: right;
    right: 0px;
  }
  .pagination {
    margin-bottom: 50px !important;
  }
  .paginate-links.filteredTasks {
    list-style: none !important;
    user-select: none;
    a {
      width: 30px;
      height: 36px;
      margin-right: 1px;
      background-color: white;
      color: #383838;
      padding: 10px 24px;
      padding-bottom: 10px !important;
      cursor: pointer;
    }
    a:hover {
      background-color: #ededed
    }
    li.active a {
      font-weight: bold;
      background-color: rgba(211, 211, 211, 10%);
    }
    a.active  {
      background-color: rgba(211, 211, 211, 10%);
    }
    li.next:before {
      content: ' | ';
      margin-right: 13px;
      color: #ddd;
    }
    li.disabled a {
      color: #ccc;
      cursor: no-drop;
    }
    li {
      display: inline !important;
      margin-bottom: 20px !important;
    }
  }
</style>
