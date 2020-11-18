<template>
  <div id="tasks-index" class="mt-3">
    <div v-if="_isallowed('read')">
      <div class="d-flex align-item-center justify-content-between mb-3 mx-2">
        <div class="simple-select w-100">
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
        <button v-if="_isallowed('write')" class="new-tasks-btn btn btn-sm btn-light ml-2" @click.prevent="addNewTask">Add Task</button>
      </div>
      <div class="mx-2 my-3 d-flex font-sm">
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
        <hr/>
        <task-show
          v-for="(task, i) in filteredTasks"
          id="taskHover"
          href="#"
          :class="{'b_border': !!filteredTasks[i+1]}"
          :key="task.id"
          :load="log(task)"
          :task="task"
          :from-view="from"
          @edit-task="editTask"
          @toggle-watched="toggleWatched"
        >{{ task.text }}</task-show>
      </div>
      <p v-else class="text-danger m-3">No tasks found..</p>
    </div>
    <p v-else class="text-danger mx-2"> You don't have permissions to read!</p>

    <table style="display:none"
      class="table table-sm table-bordered"
      ref="table" id="taskList1"
      >
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
          <td>{{task.users.join(', ')}}</td>
          <td>{{task.progress + "%"}}</td>
          <td v-if="(task.dueDate) <= now"><h5>X</h5></td>
          <td v-else></td>
          <td v-if="(task.notes.length) > 0">
            By: {{ task.notes[0].user.fullName}} on 
            {{moment(task.notes[0].createdAt).format('DD MMM YYYY, h:mm a')}}: {{task.notes[0].body}} 
          </td>
          <td v-else>No Updates</td>
        </tr>
      </tbody>
      <!-- <tfoot>
       <tr><td> Task List </td></tr>
      </tfoot> -->
    </table>
  </div>

</template>

<script>
  import TaskShow from "./task_show"
  import {mapGetters, mapMutations} from "vuex"
  import  {jsPDF} from "jspdf";
  import 'jspdf-autotable';

  export default {
    name: 'TasksIndex',
    components: {TaskShow},
    props: ['facility', 'from'],
    data() {
      return {
        viewList: 'active', 
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
        doc.autoTable({html: "#taskList1"})    
        doc.text(150,285, "Task List")
        doc.save("Task_List.pdf")
      },
    },
    computed: {
      ...mapGetters([
        'taskTypeFilter',
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

<style lang="scss" scoped>
  #tasks-index {
    height: 465px;
    background-color: #ffffff;
    z-index: 100;
  }
  .new-tasks-btn {
    height: max-content;
    width: 20%;
  }
  #taskHover:hover {
    cursor: pointer;
    background-color: rgba(91, 192, 222, 0.3);
    border-left: solid rgb(91, 192, 222);
  }
  tfoot {
    text-align: right !important;
  }

  // #taskHover:focus-within, #taskHover:active, #taskHover:visited {
  // cursor: pointer;
  // background-color: black !important;
  // border-left: solid rgb(91, 192, 222);
  // }

</style>
