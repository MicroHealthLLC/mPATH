<template>
  <div id="notes-index" data-cy="note_list" class="mt-5 pl-1" :load="log(weekOfArr)">
    <span :load="log(fridayDayOfWeek)" >
      <div class="form-group w-100 mr-1 row">
      
        <div class="col-3">
          <label class="font-sm mb-0">Project Task Users</label>
           <el-select 
              v-model="addedUser" 
              class="w-75 mr-2" 
              track-by="id" 
              value-key="id" 
              clearable
              placeholder="Search and select a User" 
              filterable
              >
            <el-option 
              v-for="item in filteredActiveProjectUsers" 
              :value="item" 
              :key="item.id" 
              :label="item.fullName"
              >
            </el-option>
          </el-select>
          <el-button 
            v-tooltip="`Add User`" 
            :disabled="!addedUser.id" 
            size="small" 
            class="calendarBtn" 
            type="primary"
            @click="addTab(editableTabsValue)"
            >
            <i class="fas fa-user-plus text-light"> </i>
          </el-button>
        </div>

        <div class="col-3">
          <label class="font-sm mb-0">Search Tasks</label>
          <el-input 
            type="search" 
            placeholder="Filter by Task" 
            aria-label="Search" 
            aria-describedby="search-addon"
            v-model="tasksQuery" 
            data-cy="search_tasks"
            >
            <el-button slot="prepend" icon="el-icon-search"></el-button>
          </el-input>
        </div>

        <div class="col-2 mt-1 pr-0">
          <label class="font-sm mb-0 d-flex">Week Of Begin:</label>
          <el-select 
            v-model="weekBegin" 
            class="mr-1 d-flex" 
            track-by="id" 
            value-key="id"         
            placeholder="Select Week of Begin" 
            filterable
            >
            <el-option 
              v-for="item, i in weekOfBegin" 
              :value="item" 
              :key="i" 
              :label="item"
              >
            </el-option>
          </el-select>
        </div>

        <div class="col-2 mt-1 pl-0">
          <label class="font-sm mb-0 d-flex">Week Of End:</label>
          <el-select 
            v-model="weekEnd" 
            class="d-flex" 
            track-by="id" 
            value-key="id"
            placeholder="Select Week of End" 
            filterable
          >
          <el-option 
            v-for="item, i in weekOfEnd" 
            :value="item" 
            :key="i" 
            :label="item"
            >
          </el-option>
          </el-select>
        </div>

        <div class="col-1 mt-4 pl-0">
          <i v-show="!weekEnd && !weekBegin" class="fa-sharp fa-circle-xmark" style="color:#d3d3d3"
            v-tooltip="`Clear Week Of filter(s)`"></i>
          <i v-show="weekEnd || weekBegin" class="fa-sharp fa-light fa-circle-xmark cursor"
            v-tooltip="`Clear Week Of filter(s)`" @click="clearWeekFilters"></i>
        </div>
        
        <div class="col-1 mt-4 px-0">
          <el-switch 
            v-model="taskProgressFilter" 
            active-text="Active Tasks" 
            inactive-text="All Tasks*"
          >
          </el-switch>
          <div v-show="false">
            <label class="font-sm mb-0">Task Due Date Range</label>
            <v2-date-picker v-model="C_taskIssueDueDateFilter" placeholder="Select Date Range" class="datepicker"
              @open="datePicker = true" range />
          </div>
        </div>
      </div>
    </span>

    <el-tabs type="border-card" v-model="editableTabsValue"  closable @tab-remove="removeTab">
      <el-tab-pane label="Summary" class="is-active">
        <el-table 
          v-if="tableData && tableData.length > 0 && matrixDates && matrixDates.length > 0"
          :data="tableData" 
          height="450"
          class="crudRow mt-4" 
          :header-row-style="{ textAlign: 'center' }"
          >
          <el-table-column prop="plannedEffort" label="Planned Effort" width="125" header-align="center">
        
          </el-table-column>
          <el-table-column prop="actualEffort" label="Actual Effort" width="125" header-align="center">
            <template slot-scope="scope">
           {{ calculateTotalActualEffort(scope.row.id) }}
           </template>
          </el-table-column>
          <el-table-column prop="text" label="Tasks" width="250" header-align="center">

          </el-table-column>
          <el-table-column label="Week of" header-align="center" v-if="uniqueMatrixDates && uniqueMatrixDates.length > 0">
          <el-table-column 
            v-for="(weekof, i) in uniqueMatrixDates" 
            :key="`${weekof}-${i}-${forceRerender}`" 
            :label='weekof' 
            width="120" 
            header-align="center"
          >
              <template slot="header">
                <div class="text-center">
                  <span>{{ weekof }}</span>                
                </div>
              </template>
              <template slot-scope="scope">
                <span v-if="!editMode || columnIndex !== i">
                  {{ getWeekOfEffort(scope.row.tasks, scope.row, weekof) }}
                </span>
                <span v-else>
                  <input 
                    @change="changeValues($event, weekof, scope.row, scope.row.id, scope.row.tasks
                      .filter(t => t.id == scope.row.id)
                      .map(t => t.efforts)
                      .flat()
                      .filter(t => t.date_of_week == weekof))"
                    :value="getWeekOfEffort(scope.row.tasks, scope.row, weekof)"
                    :name="weekof" 
                    type="text" 
                    class="form-control" 
                  />
                </span>
              </template>
            </el-table-column>
          </el-table-column>
        </el-table>

        <div v-else>
          You currently have no Tasks or *Excluded Tasks in this Project. Please add a task or adjust the <em>Week of End </em> filter.
        </div>
      </el-tab-pane>

      <el-tab-pane v-for="(item) in efforts" :key="item.id" :label="item.full_name" :name="item.id.toString()">
        
        <el-table 
          v-if="tableData && tableData.length > 0  && matrixDates && matrixDates.length > 0" 
          :data="tableData" 
          height="450" 
          id="crudRow"
          class="crudRow mt-4" 
          :header-row-style="{ textAlign: 'center' }"
          >
          <el-table-column prop="plannedEffort" label="Planned Effort" width="125" header-align="center">
          </el-table-column>
          <el-table-column prop="actualEffort" label="Actual Effort" width="125" header-align="center">
            <template slot-scope="scope">
            {{ calculateActualEffort(item.tasks, scope.row.id) }}
          </template>       
          </el-table-column>
          <el-table-column prop="text" label="Tasks" width="250" header-align="center">

          </el-table-column>
          <!-- Column of individual users -->
          <el-table-column label="Week of" header-align="center">
            <el-table-column v-for="(weekof, i) in uniqueMatrixDates" :key="`${weekof}-${i}-${forceRerender}`"  :label='weekof' width="120">
              <template slot="header">
                <div class="text-center">
                  <span :log="(editingColumn)">{{ weekof }}</span>
                  <br/>
                  <span v-if="editingColumn === i">                 
                    <i class="far fa-save mx-1 text-primary"  @click.prevent="saveEffortColumn(i)" v-tooltip="`Save`"></i>                
                    <i class="fas fa-ban text-danger" v-tooltip="`Cancel`" @click.prevent="cancelEdits(i)" ></i>    
                  </span>   
                  <span v-else>          
                    <i class="fas fa-pencil-alt text-primary" v-tooltip="`Edit Effort`" @click.prevent="editToggle(i)"></i>
                  </span>              
                </div>
              </template>
              <template slot-scope="scope">
                <span v-if="editingColumn !== i">
                  {{ getWeekOfEffort(item.tasks, scope.row, weekof) }}
                </span>
                <span v-if="editingColumn === i">
                  <input 
                    @change="changeValues($event, weekof, item, scope.row.id, item.tasks
                      .filter(t => t.id == scope.row.id)
                      .map(t => t.efforts)
                      .flat()
                      .filter(t => t.date_of_week == weekof))"
                    :value="getWeekOfEffort(item.tasks, scope.row, weekof, item)"
                    :name="weekof" 
                    type="text" 
                    class="form-control" 
                  />
                </span>
              </template>
            </el-table-column>
          </el-table-column>

          <!-- <el-table-column label="Actions" width="110" align="center">
            <template slot-scope="scope">
              <el-button size="mini" type="default" v-tooltip="`Cancel`" v-if="scope.$index == rowIndex"
                @click.prevent="cancelEdits(scope.$index, scope.row)" class="bg-secondary text-light  px-2">
                <i class="fas fa-ban"></i>
              </el-button>
              <el-button size="mini" type="default" v-tooltip="`Add/Edit Effort`" class="bg-light px-2"
                v-if="scope.$index !== rowIndex" @click.prevent="editToggle(scope.$index, scope.row, rowIndex, item)"> <i
                  class="fa-light fa-calendar-pen text-primary"></i>
              </el-button>
              <el-button type="default" size="mini" @click.prevent="saveEffortRow(scope.$index, scope.row, item.id, item.tasks, weekof)"
                v-tooltip="`Save`" class="bg-primary text-light  px-2" :disabled="rowId && rowId !== scope.row.id">
                <i class="far fa-save"></i>
              </el-button>
            </template>
          </el-table-column> -->

        </el-table>
        
        
        <div v-else>
          You currently have no Tasks in this Project or the Task due date has passed. Please add a task or adjust the <em>Week of End</em> filter.
        </div>
  

      </el-tab-pane>
    </el-tabs>
    <span class="float-right"><small>*Excludes <em>Ongoing:Closed, On Hold, Planned,</em> and <em>Draft</em> Tasks</small> </span>
    <el-dialog
        title="Confirm Removal"
        :visible.sync="isRemoveModalVisible"
        width="30%"
        @close="handleCloseRemoveModal"
      >
      <span>
        <h5>
          Are you sure you want to delete this user from this project's Task User list?
        </h5>
      </span>
      
        <span slot="footer" class="dialog-footer">
          <el-button @click="isRemoveModalVisible = false">Cancel</el-button>
          <el-button type="primary" @click="confirmRemoveTab">Confirm</el-button>
        </span>
      </el-dialog>
  </div>
</template>

<script>
import { mapMutations, mapGetters, mapActions } from "vuex"
export default {
  name: 'SheetEffort',
  props: ['facility', 'from'],
  data() {
    return {
      tabIndex: this.editableTabsValue,
      userTasksDialog: false,
      loading: false,
      tasksQuery: '',
      weekBegin: '',
      weekEnd: '',
      effortIds:[],
      effortHours: [],
      rowIndex: null,
      updatedEffort: null,
      taskProgressFilter: true,
      hasEffort: true,
      editColValue: '',
      columnIndex: null,
      addedUser: [],
      hover: false,
      rowId: null,
      matrixDates: [],
      addedHrs: [],
      gFunk: '',
      userId: null, 
      editMode: false,
      newNote: false,
      myNotesCheckbox: false,
      notesQuery: '',
      Week: [],
      DV_facility: Object.assign({}, this.facility),
      isRemoveModalVisible: false,
      tabToRemove: null, 
      editingColumn: null,
      effortChanges: new Map(),
      forceRerender: 0,
      saveCounter: 0, // Counter to track the number of save operations
      totalSaves: 0, // Total number of save operations initiated
    }
  },
  methods: {
    ...mapMutations([
      "SET_EFFORT",
      "SET_EFFORT_STATUS",
      "SET_EFFORTS_STATUS",
      "TOGGLE_EFFORT_LOADED",
      "setTaskIssueDueDateFilter"
    ]),
    ...mapActions([
      "createEffort",
      "updateEffort",
      "fetchEfforts",
      "updateUserStatus",
      "fetchCurrentProject"
    ]),
    log(e) {
      // console.log("Editing col: ", e)
      // console.log(e)
    },      
   changeValues(event, weekOf, user, rowId, effort) {
    console.log('changeValues called with:', { event, weekOf, user, rowId, effort });
    this.userId = user.id;

    let hours = {
      h: event.target.value,
      id: effort && effort[0] ? effort[0].id : null,
      weekof: weekOf,
      taskId: rowId
    };

    // Use a Map to store changes, with a unique key for each task and week
    if (!this.effortChanges) {
    this.effortChanges = new Map();
   }
    const key = `${rowId}-${weekOf}`;
    this.effortChanges.set(key, hours);

    console.log('Updated effortChanges:', this.effortChanges);
  },
  toggleRemovedEfforts(userId, removedStatus) {
      this.effortsData.forEach(user => {
        if (user.id === userId) {
          user.tasks.forEach(task => {
            task.efforts.forEach(effort => {
              effort.removed = removedStatus;
            });
          });
        }
      });
  },
  handleCloseRemoveModal() {
    this.tabToRemove = null; // Reset the tab to remove
  },
  removeTab(name) {
    // Here, you would add your logic to mark the user's efforts as removed and remove the tab
    console.log(`Confirmed removal of tab with id: ${name}`);
    // Example: this.markEffortsAsRemoved(this.tabToRemove);
    // Actual removal logic here...
    this.isRemoveModalVisible = true; // Close the modal
    this.tabToRemove = name; // Reset the tab to remove
  },
    handleChange(e) {
      console.log("hadnleChange:")
      console.log(e)
    }, 
    getWeekOfEffort(_tasks, _row, _weekof, user) {
    if (!_tasks || !Array.isArray(_tasks)) {
      return 0;
    }
    
    let hour = _tasks.filter(t => t.id == _row.id)
              .map(t => t.efforts)
              .flat()
              .filter(t => t.date_of_week == _weekof)
              .map(t => t.hours)[0] || 0;
    
    return hour;
  },
  
 calculateTotalActualEffort(taskId) {    
  if (!this.efforts || this.efforts.length === 0) {
    console.log('No efforts data available');
    return 0;
  }
  const total = this.efforts.reduce((totalEffort, user) => {  
  const userTaskEffort = this.calculateActualEffort(user.tasks, taskId); 
  return totalEffort + userTaskEffort;
}, 0); 
  return total;
},
calculateActualEffort(userTasks, taskId) {     
  if (!userTasks || userTasks.length === 0) {   
    return 0;
  }
  const task = userTasks.find(t => t.id === taskId);          
  if (!task || !task.efforts) {    
    return 0;
  }
  const total = task.efforts.reduce((total, effort) => {
    return total + (parseFloat(effort.hours) || 0);
  }, 0);  
  return total;
},
    calculateHours(_userTime, _row, _weekof) {
      let hour = _userTime
        .filter(t => t && t.id && t.id == _row.id)
        .map(t => t.efforts)
        .flat()
        .filter(t => t.date_of_week == _weekof)
        .map(t => t.hours).map(Number).reduce((a, b) => a + (b || 0), 0)
        // console.log("calculateHours", hour)
      return hour;
    },
    clearWeekFilters() {
  // Reset weekBegin and weekEnd
  this.weekBegin = '';
  this.weekEnd = '';

  // Get today's date
  let today = new Date();
  let dayOfWeek = today.getDay();

  // Calculate the current Friday's date
  let currentFriday = new Date(today);
  if (dayOfWeek !== 5) {
    let daysUntilFriday = (5 - dayOfWeek + 7) % 7;
    currentFriday.setDate(today.getDate() + daysUntilFriday);
  }

  // Reset matrixDates to only include the current Friday
  this.matrixDates = [moment(currentFriday).format("DD MMM YY")];

  console.log('Cleared week filters. Current matrixDates:', this.matrixDates);

  // Trigger a re-render
  this.$nextTick(() => {
    // Ensure no duplicates in matrixDates
    this.matrixDates = [...new Set(this.matrixDates)];
    this.forceRerender += 1;
    console.log('Re-render triggered. Current matrixDates:', this.matrixDates);
  });
},
 openUserTasksReport() {
      this.userTasksDialog = true;
    },
  saveEffortColumn(columnIndex) {
    this.totalSaves++;
    console.log('saveEffortColumn called with columnIndex:', columnIndex);
    const weekOf = this.matrixDates[columnIndex];
    console.log('Week of:', weekOf);

    const effortsToSave = [];

    this.effortChanges.forEach((change, key) => {
      if (change.weekof === weekOf) {
        effortsToSave.push({
          effortData: {
            id: change.id,
            taskId: change.taskId,
            userId: this.userId,
            hours: change.h,
            week: weekOf,
            programId: this.$route.params.programId,
            projectId: this.$route.params.projectId
          }
        });
      }
    });

    console.log('Efforts to save:', effortsToSave);

    effortsToSave.forEach(effortData => {
      console.log('Effort data to save:', effortData);
      if (effortData.effortData.id) {
        console.log('Updating effort:', effortData);
        this.updateEffort(effortData);
      } else {
        console.log('Creating effort:', effortData);
        this.createEffort(effortData);
      }
    });

    this.editingColumn = null;
    if (this.effortChanges) {
    this.effortChanges.clear();
  } else {
    this.effortChanges = new Map();
  }
  }, 
  async addTab() {
   if (!this.addedUser || !this.addedUser.id) {
    console.error('No user selected');
    return;
  }

  // Check if the user is already in the efforts array
  const existingTab = this.efforts.find(tab => tab.id === this.addedUser.id);
  if (existingTab) {
    console.warn('User already has a tab');
    this.editableTabsValue = existingTab.id.toString();
    this.addedUser = {};
    return;
  }

  const newTab = {
    full_name: this.addedUser.fullName,
    name: this.efforts.length.toString(),
    content: 'New Tab content',
    id: this.addedUser.id,
    tasks: []
  };

  this.efforts.push(newTab);
  this.editableTabsValue = newTab.id.toString();

  // Fetch efforts only for the added user
  // await this.fetchEfforts({
  //   programId: this.$route.params.programId,
  //   projectId: this.$route.params.projectId,
  //   userId: this.addedUser.id
  // });

  // Update the tasks for the newly added tab
  const updatedTab = this.efforts.find(tab => tab.id === this.addedUser.id);
  if (updatedTab) {
    updatedTab.tasks = this.efforts.find(effort => effort.id === this.addedUser.id)?.tasks || [];
  }

  this.addedUser = {};
}, 
  async confirmRemoveTab() {
    let name = this.tabToRemove;    
    // Find the index of the tab to remove
    const tabIndex = this.efforts.findIndex(tab => tab.id.toString() === name);  
    if (tabIndex === -1) return; // Tab not found

    // Get the user associated with the tab
    const removedUser = this.efforts[tabIndex];
    // Update the active tab if the removed tab is the active tab
    if (this.editableTabsValue === name) {
      const nextTab = this.efforts[tabIndex + 1] || this.efforts[tabIndex - 1];
      if (nextTab) {
        this.editableTabsValue = nextTab.id.toString();
      } else {
        this.editableTabsValue = 'summary'; // Default to summary tab if no other tabs are available
      }
    }
    // Remove the tab from the efforts array
    this.efforts.splice(tabIndex, 1);
    // Add the user back to the filteredActiveProjectUsers array
    const userIndex = this.filteredActiveProjectUsers.findIndex(user => user.id === removedUser.id);
    if (userIndex === -1) {
      this.filteredActiveProjectUsers.push(removedUser);
      
    } 
    this.tabToRemove = null;
    this.isRemoveModalVisible = false; 
    try {
      await this.updateUserStatus({ userId: removedUser.id, status: 'inactive' });

    } catch (error) {
      console.error('Failed to update user status:', error);
    }
   
  },
    handleClick(tab, event) {
      console.log(tab)
      console.log(event)
    },
    editToggle(columnIndex) {
          this.editingColumn = columnIndex;
        this.forceRerender += 1;
      },

      cancelEdits(columnIndex) {
        this.editingColumn = null;
        this.effortChanges.clear();
        this.forceRerender += 1;
      },

    timeEdit(index, row, weekof, weekofIndex, effort) {
      this.columnIndex = weekofIndex

      this.updatedEffort = effort
    },
    cancelTimeEdit() {
      this.columnIndex = null
    },
      
  },
  computed: {
    ...mapGetters([
      'myActionsFilter',
      "efforts",
      "effort",
      "facilities",
      "currentProject",
      "taskIssueDueDateFilter",
      "effortStatus",
      "effortsStatus",
      "effortsLoaded",
      "activeProjectUsers"
    ]),
    uniqueMatrixDates() {
      return [...new Set(this.matrixDates)];
    },
    C_taskIssueDueDateFilter: {
      get() {
        if (!this.taskIssueDueDateFilter) return this.taskIssueDueDateFilter
        return this.taskIssueDueDateFilter.map(d => d ? new Date(d) : d)
      },
      set(value) {
        this.setTaskIssueDueDateFilter(value)
      }
    },
    userTime() {
      if (this.efforts && this.efforts.length > 0) {
        let time = this.efforts.map(t => t.tasks).flat()
        return time
      }
    },
    tableData() {
      let project = this.facilities.find((facility) => facility.facilityId == this.$route.params.projectId)
     
     
      if (project && project.tasks && project.tasks.length > 0) {
        let tasks = project.tasks.filter(t => !t.onHold && !t.draft && !t.planned)
          .filter((task) => {
            if (this.taskProgressFilter) {
               return task.progress < 100;
            } else return true;
          })
          .filter((task) => {
            if (this.tasksQuery !== "") {
              return (
                task.text.toLowerCase().match(this.tasksQuery.toLowerCase())
              );
            } else return true;
            // Filtering 7 Task States
          });

        return tasks
      }
    },
    totalActualEffortByTask() {
    const totalEffort = {};
    
    this.tableData.forEach(row => {
      if (row.tasks) {
        totalEffort[row.id] = row.tasks.reduce((sum, task) => {
          if (task.efforts) {
            return sum + task.efforts.reduce((effortSum, effort) => 
              effortSum + (parseFloat(effort.hours) || 0), 0);
          }
          return sum;
        }, 0);
      } else {
        totalEffort[row.id] = 0;
      }
    });

    return totalEffort;
  },
    filteredActiveProjectUsers() {
      if (this.efforts && this.activeProjectUsers && this.efforts.length > 0) {
        return this.activeProjectUsers
        .filter(t => t.status !== 'inactive')
        .filter(t => !this.efforts
          .map(f => f.id).includes(t.id))
      } else {
        return this.activeProjectUsers.filter(t => t.status !== 'inactive')
      }
    },
    fridayDayOfWeek() {
      let date = new Date();
      let friday = 5;
      let resultDate = new Date(date.getTime());
      resultDate.setDate(date.getDate() + (7 + friday - date.getDay()) % 7);
      return resultDate;
    },
    weekOfArr(){       
          let oneYearOut = new Date(this.fridayDayOfWeek);
          let end = oneYearOut.setDate(oneYearOut.getDate());    
          let start = this.fridayDayOfWeek;      
          let loop = new Date(start);  

          if(this.weekBegin){      
            start = this.weekBegin  
            loop = new Date(start)      
            this.matrixDates = [] 
          }

          if(this.weekEnd ){           
            end = new Date(this.weekEnd) 
            this.matrixDates = []    
            if (!this.weekBegin)  {
              end = end.setDate(end.getDate() + 7);       
            }             
          }
       
          while(loop <= end){
          this.matrixDates.push(moment(loop).format("DD MMM YY"))         
          let newDate = loop.setDate(loop.getDate() + 7);         
          loop = new Date(newDate);   
          } 
          if (this.weekEnd  && !this.weekBegin && this.fridayDayOfWeek )  {
            let friYAY;
            let fri = new Date(this.fridayDayOfWeek) 
            friYAY = fri.setDate(fri.getDate() - 7);         
            this.matrixDates.unshift(moment(friYAY).format("DD MMM YY"))    
          }    
    },  
    lastDueDate(){
        if(this.facility && this.facility.tasks && this.facility.tasks.length > 0){
          let taskDueDates = this.facility.tasks.filter(t => t && t.dueDate !== null).map(t => new Date(t.dueDate))         
          let latestTaskDate = taskDueDates.sort((date1, date2) => new Date(date1).setHours(0, 0, 0, 0) - new Date(date2).setHours(0, 0, 0, 0))[taskDueDates.length - 1]       
                        
          if(taskDueDates.length == 1 ){
            latestTaskDate = new Date(taskDueDates[0])
          }
          let start = this.fridayDayOfWeek       
          let end = latestTaskDate.setDate(latestTaskDate.getDate() + 7);
          let loop = new Date(start);         
          while(loop <= end){
          this.matrixDates.push(moment(loop).format("DD MMM YY"))         
          let newDate = loop.setDate(loop.getDate() + 7);     
          loop = new Date(newDate);        
          }           
          return  this.matrixDates[this.matrixDates.length - 1] 
       }  
    },
    weekOfBegin(){
        if(this.facility && this.facility.tasks && this.facility.tasks.length > 0){
          let arr = []        
          let pastBeginDate =  new Date("01/06/2023")
          let end1 = this.fridayDayOfWeek;  
          let loop1 = new Date(pastBeginDate);         
          while(loop1 <= end1){        
            arr.push(moment(loop1).format("DD MMM YY"))   
            // console.log(arr)        
            let newDate1 = loop1.setDate(loop1.getDate() + 7);
            loop1 = new Date(newDate1);
          }      
          return arr   
         }        
      },
   weekOfEnd(){
      if (this.facility && this.facility.tasks && this.facility.tasks.length > 0) {
    let arr = [];
    
    // Calculate the Friday of the current week
    const getCurrentFriday = () => {
      let today = new Date();
      let dayOfWeek = today.getDay();
      let daysUntilFriday = 5 - dayOfWeek;
      if (daysUntilFriday < 0) daysUntilFriday += 7; // If today is Saturday or Sunday
      let currentFriday = new Date(today);
      currentFriday.setDate(today.getDate() + daysUntilFriday);
      return currentFriday;
    };

    let currentFriday = getCurrentFriday();
    let loopDate = new Date(this.fridayDayOfWeek);

    while (loopDate <= currentFriday) {
      arr.push(moment(loopDate).format("DD MMM YY"));
      loopDate.setDate(loopDate.getDate() + 7);
      loopDate = new Date(loopDate);
    }

    return arr;
  }
},
      // weekOfEnd(){
      //   if(this.facility && this.facility.tasks && this.facility.tasks.length > 0){
      //     let arr = []
      //     let oneYearOut = new Date(this.fridayDayOfWeek)
      //     let end1 = oneYearOut.setDate(oneYearOut.getDate())       
      //     let pastBeginDate =  this.fridayDayOfWeek.setDate(this.fridayDayOfWeek.getDate() + 7)
      //     let loop1 = new Date(pastBeginDate);         
      //     while(loop1 <= end1){        
      //       arr.push(moment(loop1).format("DD MMM YY"))   
      //       // console.log(arr)        
      //       let newDate1 = loop1.setDate(loop1.getDate() + 7);
      //       loop1 = new Date(newDate1);
      //     }      
      //     return arr   
      //    }        
      // },    
  },
  mounted() {
    this.fetchEfforts(this.$route.params)
    this.fetchCurrentProject(this.$route.params.programId)
  },
  watch: {
   effortStatus: {
      //Need to add weekOfArr value here to handle data better than the current load property within the template
      
      handler() {
 
        if (this.effortStatus == 200) {
          console.log('effort status OK');
          this.saveCounter++; // Increment the save counter

          // Check if all save operations are completed
          if (this.saveCounter === this.totalSaves) {
            this.$message({
              message: `Task Effort successfully saved.`,
              type: "success",
              showClose: true,
            });

            // Reset the counters
            this.saveCounter = 0;
            this.totalSaves = 0;

            this.effortIds = [];
            this.effortHours = [];
            this.addedHrs = [];
            this.editColValue = null;
            this.columnIndex = null;
            this.updatedEffort = null;
            this.SET_EFFORT_STATUS(0);
            this.SET_EFFORTS_STATUS(0);
            this.fetchCurrentProject(this.$route.params.programId);
            this.fetchEfforts(this.$route.params);
          }
        }
      },
      immediate: true,
    },
  editingColumn(newVal, oldVal) {
    console.log('editingColumn changed from', oldVal, 'to', newVal);
   },
  //  matrixDates: {
  //   handler(newVal) {
  //     console.log('matrixDates changed:', newVal);
  //   },
  //   deep: true
  // },
  facility: {
    handler: function (value) {
      this.DV_facility = Object.assign({}, value)
      this.loading = true
    }, deep: true
  }
  }
}
</script>

<style lang="scss" scoped>

.calendarBtn {
  transition: all .2s ease-in-out;
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}

#tab-0 {
  background-color: rgb(234, 234, 185) !important;
}

input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

/* Firefox */
input[type=number] {
  -moz-appearance: textfield;
}

.editCol {

  input::-webkit-outer-spin-button,
  input::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }

  .cursor {
    cursor: pointer;
  }

  /* Firefox */
  input[type=number] {
    -moz-appearance: textfield;
  }

  width: 70% !important;
}

.el-table .cell {
  word-break: break-all;
}

.el-table thead {
  color: #383838 !important;
}

#search-addon {
  background-color: #ededed !important;
}

#notes-index {
  height: 500px;
}

input[type=search] {
  color: #383838;
  text-align: left;
  cursor: pointer;
  display: block;
}

.addNote {
  box-shadow: 0 5px 10px rgba(56, 56, 56, 0.19), 0 1px 1px rgba(56, 56, 56, 0.23);
}

.notes {
  padding: 8px;
  box-shadow: 0 5px 10px rgba(56, 56, 56, 0.19), 0 1px 1px rgba(56, 56, 56, 0.23);
  z-index: 100;
}

#notesHover:hover {
  box-shadow: 0.5px 0.5px 1px 1px rgba(56, 56, 56, 0.29), 0 2px 2px rgba(56, 56, 56, 0.23);
  background-color: rgba(91, 192, 222, 0.3);
  border-left: solid rgb(91, 192, 222);
}

.notes-container {
  position: relative;
  overflow: auto;
  height: 61vh;
}

.filters-wrapper {
  float: right;
  margin-top: -50px;
}

@media screen and (max-width: 1500px) { 
  .filters-wrapper {
    width: 65% !important;
  }
}

.calendarBtn {
  transition: all .2s ease-in-out;
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}

#tab-0 {
  background-color: rgb(234, 234, 185) !important;
}

input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

/* Firefox */
input[type=number] {
  -moz-appearance: textfield;
}
.btn.el-icon-close{
  border-radius: 50%;
  background-color: lightgray;
}

.editCol {

  input::-webkit-outer-spin-button,
  input::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }

  .cursor {
    cursor: pointer;
  }

  /* Firefox */
  input[type=number] {
    -moz-appearance: textfield;
  }

  width: 70% !important;
}

.el-table .cell {
  word-break: break-word;
}
.el-table thead {
  color: #383838 !important;
}

#search-addon {
  background-color: #ededed !important;
}

#notes-index {
  height: 500px;
}

input[type=search] {
  color: #383838;
  text-align: left;
  cursor: pointer;
  display: block;
}

.addNote {
  box-shadow: 0 5px 10px rgba(56, 56, 56, 0.19), 0 1px 1px rgba(56, 56, 56, 0.23);
}

.notes {
  padding: 8px;
  box-shadow: 0 5px 10px rgba(56, 56, 56, 0.19), 0 1px 1px rgba(56, 56, 56, 0.23);
  z-index: 100;
}

#notesHover:hover {
  box-shadow: 0.5px 0.5px 1px 1px rgba(56, 56, 56, 0.29), 0 2px 2px rgba(56, 56, 56, 0.23);
  background-color: rgba(91, 192, 222, 0.3);
  border-left: solid rgb(91, 192, 222);
}

.notes-container {
  position: relative;
  overflow: auto;
  height: 61vh;
}

.filters-wrapper {
  float: right;
  margin-top: -50px;
}

@media screen and (max-width: 1500px) {
  .filters-wrapper {
    width: 65% !important;
  }
}

</style>