<template>
  <div id="tasks-index" class="my-4" data-cy="task_sheet_index">
    <div v-if="_isallowed('read')">
      <div class="d-flex align-item-center justify-content-between mb-2">
        <div class="input-group w-90 task-search-bar">
             <div class="input-group-prepend">
             <span class="input-group-text" id="search-addon"><i class="fa fa-search"></i></span>
            </div>
            <input type="search"
            class="form-control form-control-sm"
            placeholder="Search Tasks"
            aria-label="Search"
            aria-describedby="search-addon"
            v-model="tasksQuery">
          </div>
        <div class="simple-select mx-1 d-flex" style="width:35%">

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
        <div class="simple-select d-flex mr-2" style="width:30%">
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

        <div class="form-check-inline font-sm mr-0" style="width:20%">
          <label class="form-check-label mx-2">
            <input type="checkbox" class="form-check-input" v-model="C_myTasks">
            <i class="fas fa-user mr-1"></i>My Tasks
          </label>
          <label v-if="viewPermit('watch_view', 'read')" class="form-check-label">
            <input type="checkbox" class="form-check-input" v-model="C_onWatchTasks">
            <i class="fas fa-eye mr-1"></i>On Watch
          </label>
        </div>
      </div>
      <button v-if="_isallowed('write')"
        class="new-tasks-btn addBtns btn mr-2 btn-sm btn-primary"
        @click.prevent="addNewTask"
        data-cy="add_task"
      >
        <i class="fas fa-plus-circle mr-2"></i>
        Add Task
      </button>
      <button
        @click="download"
        id="printBtn"
        class="btn btn-sm btn-dark exportBtn">
        <font-awesome-icon icon="file-pdf" />
        Export to PDF
      </button>
      <label class="form-check-label text-primary float-right mr-2" data-cy="task_total">
        <h5>Total: {{filteredTasks.length}}</h5>
      </label>
      <div v-if="filteredTasks.length > 0">
        <div style="margin-bottom:100px" data-cy="tasks_table">
          <table class="table table-sm table-bordered table-striped mt-3 stickyTableHeader">
            <colgroup>
              <col class="sixteen" />
              <col class="ten" />
              <col class="eight" />
              <col class="eight" />
              <col class="ten" />
              <col class="ten" />
              <col class="ten" />
              <col class="eight" />
              <col class="twenty" />
            </colgroup>
            <tr style="background-color:#ededed;">
              <th class="sort-th" @click="sort('text')">Task<i class="fas fa-sort scroll"></i></th>
              <th class="sort-th" @click="sort('taskType')">Task Category <i class="fas fa-sort scroll"></i> </th>
              <th class="sort-th" @click="sort('startDate')">Start Date<i class="fas fa-sort scroll ml-2"></i></th>
              <th class="sort-th" @click="sort('dueDate')">Due<br/>Date<i class="fas fa-sort scroll"></i></th>
              <th class="sort-th" @click="sort('users')">Assigned Users<i class="fas fa-sort scroll" ></i></th>
              <th class="sort-th" @click="sort('progress')">Progress<i class="fas fa-sort scroll"></i></th>
              <th class="sort-th" @click="sort('dueDate')">Overdue<i class="fas fa-sort scroll"></i></th>
              <th class="sort-th" @click="sort('watched')">On Watch<i class="fas fa-sort scroll"></i></th>
              <th class="sort-th" @click="sort('notes')">Last Update<i class="fas fa-sort scroll"></i></th>
            </tr>
          </table>
             <task-sheets
              v-for="(task, i) in sortedTasks"
              class="taskHover"
              href="#"
              :class="{'b_border': !!filteredTasks[i+1]}"
              :key="task.id"
              :task="task"
              :from-view="from"
              @edit-task="editTask"
              @toggle-watched="toggleWatched"
            />
          <div class="float-right mb-4">
          <button class="btn btn-sm page-btns" @click="prevPage"><i class="fas fa-angle-left"></i></button>
          <button class="btn btn-sm page-btns" id="page-count">Page {{ currentPage }} of {{ Math.ceil(this.filteredTasks.length / pageSize) }} </button>
          <button class="btn btn-sm page-btns" @click="nextPage"><i class="fas fa-angle-right"></i></button>
           </div>
        </div>
      </div>
      <h6 v-else class="text-danger alt-text" data-cy="no_task_found">No tasks found..</h6>
    </div>
    <p v-else class="text-danger mx-2"> You don't have permissions to read!</p>
      <!-- debug: sort={{currentSort}}, dir={{currentSortDir}}, page={{currentPage}}  sum={{pageSize}} -->
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
          <td class="ten" v-if="(task.users.length) > 0">{{JSON.stringify(task.users.map(users => (users.fullName))).replace(/]|[['"]/g, '')}}</td>
          <td class="ten" v-else></td>
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
  // import moment from 'moment'
  import TaskSheets from "./task_sheets"
  import { library } from '@fortawesome/fontawesome-svg-core'
  import { faFilePdf } from '@fortawesome/free-solid-svg-icons'
  library.add(faFilePdf)
  // Vue.prototype.moment = moment
  
  import * as Moment from 'moment'
  import {extendMoment} from 'moment-range'
  const moment = extendMoment(Moment)

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
        tasks: Object,
        now: new Date().toISOString(),
        tasksQuery: '',
        pageSize:15,
        currentPage:1,
        currentSort:'text',
        currentSortDir:'asc',
     }
    },
    methods: {
      ...mapMutations([
        'setTaskTypeFilter',
        'setMyActionsFilter',
        'setOnWatchFilter',
        'setTaskForManager'
      ]),
      sort:function(s) {
      //if s == current sort, reverse
      if(s === this.currentSort) {
        this.currentSortDir = this.currentSortDir==='asc'?'desc':'asc';
      }
        this.currentSort = s;
      },
      nextPage:function() {
        if((this.currentPage*this.pageSize) < this.filteredTasks.length) this.currentPage++;
      },
      prevPage:function() {
        if(this.currentPage > 1) this.currentPage--;
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
        'noteDateFilter',
        'taskIssueDueDateFilter',
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
        let noteDates = this.noteDateFilter
        let taskIssueDueDates = this.taskIssueDueDateFilter

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

          if(noteDates && noteDates[0] && noteDates[1]){
            var startDate = moment(noteDates[0], "YYYY-MM-DD")
            var endDate = moment(noteDates[1], "YYYY-MM-DD")
            var _notesCreatedAt = _.map(task.notes, 'createdAt')
            var is_valid = task.notes.length > 0
            for(var createdAt of _notesCreatedAt){
              var nDate = moment(createdAt, "YYYY-MM-DD")
              is_valid = nDate.isBetween(startDate, endDate, 'days', true)
              if(is_valid) break
            }            
            valid = is_valid
          }

          if(taskIssueDueDates && taskIssueDueDates[0] && taskIssueDueDates[1]){
            var startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD")
            var endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD")
            
            var is_valid = true
            var nDate = moment(task.dueDate, "YYYY-MM-DD")
            is_valid = nDate.isBetween(startDate, endDate, 'days', true)                        
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
      },
      sortedTasks:function() {
          return this.filteredTasks.sort((a,b) => {
          let modifier = 1;
          if(this.currentSortDir === 'desc') modifier = -1;
          if(a[this.currentSort] < b[this.currentSort]) return -1 * modifier;
          if(a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
          return 0;
           }).filter((row, index) => {
          let start = (this.currentPage-1)*this.pageSize;
          let end = this.currentPage*this.pageSize;
          if(index >= start && index < end) return true;
          return this.end
        });
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
  .scroll {
    cursor:pointer !important;
    top: 35%;
    right: 5px;
    position:absolute;
    font-size: 1.1rem;
    color: #383838 !important;
    padding-left:4px !important
  }
  .task-search-bar {
    height: 31px;
    width: 310px;
    border-radius: 5px;
  }
  .sort-th {
    font-size: .80rem !important;
    text-align: center;
    position: relative;
    vertical-align: middle !important;
  }
  input[type=search] {
    color: #383838;
    text-align: left;
    cursor: pointer;
    display: block;
 }
  .new-tasks-btn {
    height: max-content;
    width: 100px;
  }
   .page-btns {
    width: 20px;
    line-height: 1 !important;
    border: none !important;
    height: 25px;
    margin-right: 1px;
    background-color: white;
    box-shadow: 0 5px 10px rgba(56,56, 56,0.19), 0 6px 6px rgba(56,56,56,0.23);
    color: #383838;
    cursor: pointer;
 }
  .page-btns:hover {
    background-color: #ededed;
  }
  #page-count {
    width: auto !important;
    cursor: default;
  }
  .page-btns.active  {
    background-color: rgba(211, 211, 211, 10%);
    border:none !important;
 }
  .alt-text {
    position: relative;
    margin-top: 50px;
    margin-left: 2px;
  }
  #printBtn, .addBtns {
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
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
  .sixteen {
    width: 16%;
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
</style>
