
<template>
  <div id="tasks-index" class="mt-3">
    <div v-if="_isallowed('read')">
      <div class="d-flex align-item-center justify-content-between mb-3 mx-2">
        <div class="simple-select w-100 mr-1">
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
        <button v-if="_isallowed('write')"
          class="new-tasks-btn btn btn-sm btn-primary"
          @click.prevent="addNewTask">
          <i class="fas fa-plus-circle"></i>
          Add Task
        </button>
      </div>
      <div class="m-1 d-flex">
        <div class="form-check-inline mr-2">
          <label class="form-check-label">
            <input type="radio" class="form-check-input" v-model="viewList" value="active" name="listoption">Active
          </label>
        </div>
        <div class="form-check-inline mr-2">
          <label class="form-check-label">
            <input type="radio" class="form-check-input" v-model="viewList" value="completed" name="listoption">Completed
          </label>
        </div>
        <div class="form-check-inline mr-2">
          <label class="form-check-label">
            <input type="radio" class="form-check-input" v-model="viewList" name="listoption" value="all">All
          </label>
        </div>
        <div class="form-check-inline ml-auto mr-0">
          <label class="form-check-label">
            <input type="checkbox" class="form-check-input" v-model="C_myTasks">My Tasks
          </label>
          <label v-if="viewPermit('watch_view', 'read')" class="form-check-label ml-2">
            <input type="checkbox" class="form-check-input" v-model="C_onWatchTasks">On Watch
          </label>
          <label class="form-check-label ml-2 text-primary">
            Total: {{filteredTasks.length}}
          </label>
        </div>
      </div>
      <div v-if="filteredTasks.length > 0">
        <button
          @click="download"
          id="printBtn"
          class="btn btn-sm btn-dark m-2"
          style="font-size:.70rem" >
          EXPORT TO PDF
        </button>
        <button
          disabled
          id="printBtn"
          class="btn btn-sm btn-outline-dark ml-1 mt-2 mb-2"
          style="font-size:.70rem" >
          EXPORT TO EXCEL
        </button>
        <div style="margin-bottom:50px">
          <table class="table table-sm table-bordered table-striped mt-2">
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
              :load="log(task)"
              :task="task"
              :from-view="from"
              @edit-task="editTask"
              @toggle-watched="toggleWatched"
            />
          </paginate>
          <div class="floatRight mt-3 mr-3">
            <paginate-links for="filteredTasks" :show-step-links="true" :limit="4"></paginate-links>
          </div>
        </div>
      </div>
      <p v-else class="text-danger m-3">No tasks found..</p>
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
          <td v-if="(task.notes.length) > 0">{{task.notes[0].body}}</td>
          <td v-else>No Updates</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
  import TaskSheets from "./task_sheets"
  import {mapGetters, mapMutations} from "vuex"
  import VuePaginate from 'vue-paginate'
  import {jsPDF} from "jspdf"
  import 'jspdf-autotable'
  Vue.use(VuePaginate)

  export default {
    name: 'TasksSheetsIndex',
    components: {TaskSheets},
    props: ['facility', 'from'],
    data() {
      return {
        viewList: 'active',
        paginate: ['filteredTasks'],
        tasks: Object,
        now: new Date().toISOString()
      }
    },
    methods: {
      ...mapMutations([
        'setTaskTypeFilter',
        'setMyActionsFilter',
        'setOnWatchFilter',
        'setTaskForManager'
      ]),
      log(task) {
        console.log(task)
      },
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
        'myActionsFilter',
        'onWatchFilter',
        'taskTypes',
        'viewPermit'
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
          if (this.C_onWatchTasks) {
            valid  = valid && task.watched
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
    height: 465px;
    background-color: #ffffff;
    z-index: 100;
  }
  .new-tasks-btn {
    height: max-content;
    width: 20%;
  }
  .taskHover:hover {
    cursor: pointer;
    background-color: rgba(91, 192, 222, 0.3);
    border-left: solid rgb(91, 192, 222);
  }
  table {
    table-layout: fixed;
    width: 100%;
    margin-bottom: 0 !important;
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
    position: absolute;
    right: 0px;
  }
  .paginate-links.filteredTasks {
    list-style: none !important;
    user-select: none;
    a {
      width: 30px;
      height: 36px;
      margin-right: 1px;
      border-radius: 4px;
      background-color: #ededed;
      box-shadow: 0 5px 10px rgba(56,56, 56,0.19), 0 6px 6px rgba(56,56,56,0.23);
      color: #383838;
      padding: 10px 24px;
      padding-bottom: 10px !important;
      cursor: pointer;
    }
    a:hover {
      background-color: rgba(91, 192, 222, 0.3);
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
