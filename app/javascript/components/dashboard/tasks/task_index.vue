<template>
  <div id="tasks-index" class="mt-3" data-cy="task_list">
    <div v-if="_isallowed('read')">
          <div class="input-group w-100">
             <div class="input-group-prepend">
             <span class="input-group-text" id="search-addon"><i class="fa fa-search"></i></span>
            </div>
            <input type="search" 
            class="form-control form-control-sm" 
            placeholder="Search tasks.." 
            aria-label="Search" 
            aria-describedby="search-addon" 
            v-model="tasksQuery">
          </div>
      <div class="d-flex align-item-center justify-content-between my-2 100">        
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
        <div class="simple-select w-100 enum-select">
          <multiselect
            v-model="viewList" 
            style="width:100%"          
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
      </div>
      <div class="mb-3 mr-2 font-sm">          
         <button v-if="_isallowed('write')" 
          class="btn btn-sm btn-primary mr-2"
          @click.prevent="addNewTask"><i class="fas fa-plus-circle mr-2" data-cy="new_task"></i>
          Add Task
          </button>
          <button
          @click.prevent="download"     
          class="btn btn-sm btn-dark mr-1">
          <font-awesome-icon icon="file-pdf" />
          Export to PDF
          </button>
          <!-- <button
            disabled 
            class="btn btn-sm btn-outline-dark">
            Export to Excel
          </button>  -->
          <div class="form-check-inline font-sm myTasks mt-1 mr-0">             
          <label class="form-check-label ml-4 mr-3">
            <input type="checkbox" class="form-check-input" v-model="C_myTasks">  <i class="fas fa-user mr-1"></i>My Tasks
          </label>
          <label v-if="viewPermit('watch_view', 'read')" class="form-check-label ml-3">
            <input type="checkbox" class="form-check-input" v-model="C_onWatchTasks"> <i class="fas fa-eye mr-1"></i>On Watch
          </label> 
          </div>    
      </div>
      
      <div v-if="filteredTasks.length > 0">        
        <hr/>
        <task-show
          v-for="(task, i) in filteredTasks"
          id="taskHover"
          href="#"
          :class="{'b_border': !!filteredTasks[i+1]}"
          :key="task.id"
          :task="task"
          :from-view="from"
          @edit-task="editTask"
        >{{ task.text }}</task-show>
      </div>
      <div v-else>
        <br/>
        <h6 class="text-danger mt-4 ml-1">No tasks found..</h6>
      </div>
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
    </table>
  </div>
</template>

<script>
  import {mapGetters, mapMutations} from "vuex"
  import {jsPDF} from "jspdf"
  import 'jspdf-autotable'
  import TaskShow from "./task_show"
  import { library } from '@fortawesome/fontawesome-svg-core'
  import { faFilePdf } from '@fortawesome/free-solid-svg-icons'
  library.add(faFilePdf)
  import * as Moment from 'moment'
  import {extendMoment} from 'moment-range'
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
        listOptions: ['active','all', 'completed'],
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
        'noteDateFilter',
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
          if (stageIds.length > 0) valid = valid && stageIds.includes(task.taskStageId)
          if (typeIds.length > 0) valid = valid && typeIds.includes(task.taskTypeId)
          
          if(noteDates[0] && noteDates[1]){
            var range = moment.range(noteDates[0], noteDates[1])
            var _notesCreatedAt = _.map(task.notes, 'createdAt')
            var is_valid = task.notes.length > 0
            for(var createdAt of _notesCreatedAt){
              is_valid = range.contains(new Date(createdAt))
              if(is_valid) break
            }            
            valid = is_valid
          }

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

<style lang="scss" scoped>
  #tasks-index {
    height: 465px;
    background-color: #ffffff;
    z-index: 100;
  }
  .new-tasks-btn { 
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
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
 .myTasks {
   float: right !important;
   margin-top: 5px;
 }
</style>
