<template>
  <div id="tasks-index" class="mt-3">
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
          <div class="form-check-inline mr-0" style="width:26%">
          <!-- <label class="form-check-label mx-2">
            <input type="checkbox" class="form-check-input" v-model="C_myTasks">
            <i class="fas fa-user mr-1"></i>My Tasks
          </label> -->
          <label v-if="viewPermit('watch_view', 'read')" class="form-check-label ml-2">
            <input type="checkbox" class="form-check-input" v-model="C_onWatchTasks">
            <i class="fas fa-eye mr-1"></i>On Watch
          </label>         
        </div>     
      </div>
        <button v-if="_isallowed('write')"
          class="new-tasks-btn addBtns btn mr-3 btn-sm btn-primary"
          @click.prevent="addNewTask">
          <i class="fas fa-plus-circle"></i>
          Add Task
        </button>
    
      <div v-if="filteredTasks.length > 0">      
        <button
          @click="download"
          id="printBtn"
          class="btn btn-sm btn-dark exportBtn">       
          EXPORT TO PDF
        </button>
        <button
          disabled
          id="printBtn"
          class="btn btn-sm btn-outline-dark">           
          EXPORT TO EXCEL
        </button>       
        <label class="form-check-label text-primary floatRight">
            <h5 id="total">Total: {{filteredTasks.length}}</h5>
        </label>
      
        <div style="margin-bottom:50px">
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
          <div class="floatRight mt-3 mr-3">
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
  import TaskSheets from "./task_sheets"
  import {mapGetters, mapMutations} from "vuex"
  import VuePaginate from 'vue-paginate'
  import {jsPDF} from "jspdf"
  import 'jspdf-autotable'
  import moment from 'moment'  
  
  Vue.prototype.moment = moment
  Vue.use(VuePaginate)
  export default {
    name: 'TasksSheetsIndex',
    components: {TaskSheets},
    props: ['facility', 'from'],
    data() {
      return {           
        viewList:'active',
        listOptions: ['active','all', 'completed'],        
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
  .addBtns {
    position: absolute;
  }
  .alt-text {
    position: relative; 
    margin-top: 50px;  
    margin-left: 2px; 
  }
  #printBtn {
    font-size: .80rem
  }
  .exportBtn {
    margin-left: 275px;
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
    margin-bottom: -2.5rem;
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
  // h5#total {
  //   margin-right: 20px;
  //   line-height: 3.2 !important;
  // }
  .paginate-links.filteredTasks {
    list-style: none !important;
    user-select: none;
    a {
      width: 30px;
      height: 36px;
      margin-right: 1px;    
      background-color: white;
      box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
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
