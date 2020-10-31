<template>
  <div id="tasks-index" class="mt-3">
    <div v-if="_isallowed('read')">
      <div class="d-flex align-item-center justify-content-between mb-3 mx-2">
        <div class="simple-select w-100">
          <multiselect
            v-model="C_taskTypeFilter"
            track-by="name"
            label="name"
            placeholder="Filter by Milestones"
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
      <div class="m-3 d-flex">
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
        <div class="form-check-inline ml-auto mr-0">
          <label class="form-check-label">
            <input type="checkbox" class="form-check-input" v-model="C_myTasks">My Tasks
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
            class="btn btn-sm btn-outline-dark m-2" 
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
        <task-show           
          v-for="(task, i) in filteredTasks"        
          :class="{'b_border': !!filteredTasks[i+1]}"
          :key="task.id"
          :load="log(task)"
          :task="task"          
          :from-view="from"
          @edit-task="$emit('show-hide', task)"
          @toggle-watched="toggleWatched"
        >{{ task.text }}</task-show>
      </div>              
      <p v-else class="text-danger m-3">No tasks found..</p>
    </div>
    <p v-else class="text-danger mx-2"> You don't have permissions to read!</p>    
     <table style="display:none" 
            class="table table-sm table-bordered" 
            ref="table" id="taskList1" 
            v-for="(task, i) in filteredTasks">             
         
          <thead>                    
            <tr>  
              <!-- <th>Facility: {{task.facilityName}}  </th>           -->
              <th></th>  
              <th>Task</th>      
              <th>Start Date</th>  
              <th>Due Date</th>                 
            </tr>
          </thead>
          <tbody>
          
            <tr>
              <td class="text-center">{{i+1}}</td>
              <td>{{task.text}}</td>    
              <td>{{task.startDate}}</td>   
              <td>{{task.dueDate}}</td>              
            </tr>
          
          </tbody>
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
        viewList: 'active'
      }
    },
    methods: {
      
      ...mapMutations([
        'setTaskTypeFilter',
        'setMyActionsFilter',
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
      toggleWatched(task) {
        this.$emit('toggle-watch-task', task)   
    },
      download(){   
      const doc = new jsPDF()   
      const html =  this.$refs.table.innerHTML 
      doc.autoTable({html: "#taskList1"})
      doc.save("Task_List.pdf")           
      },
    },
    
    computed: {
      ...mapGetters([
        'taskTypeFilter',
        'myActionsFilter',
        'taskTypes'
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
    }
  }
</script>

<style lang="scss" scoped>
  .new-tasks-btn {
    height: max-content;
    width: 20%;
  }
</style>
