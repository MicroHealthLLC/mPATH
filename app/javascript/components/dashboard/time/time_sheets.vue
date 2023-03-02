<template>
  <div id="notes-index" data-cy="note_list" class="mt-5 pl-1" :load="log(weekOfArr)">      
    <span :load="log(editableTabsValue)">
      <div class="form-group w-100 mr-1 row">
              <!-- <label class="font-md mb-0"><i class="fa-solid fa-user-plus text-light"> </i> </label> -->
              
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
              @click="addTab(editableTabsValue)">   
              <i class="fa-solid fa-user-plus text-light"> </i> 
              </el-button>    

              </div>
             
             
              <div class="col-4">
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
                 
              <div class="col-4 mt-4">
               <el-switch
                v-model="taskProgressFilter"
                active-text="Incomplete Tasks"
                inactive-text="All Tasks">
              </el-switch>
              <!-- <el-switch
                v-model="hasTimesheet"
                active-text="Effort Only"
                inactive-text="All">
              </el-switch> -->
                <div  v-show="false">
              <label class="font-sm mb-0">Task Due Date Range</label>
              <v2-date-picker v-model="C_taskIssueDueDateFilter" placeholder="Select Date Range" class="datepicker" @open="datePicker=true" range />
             </div>
              </div>     
            </div>
           </span>

 <el-tabs type="border-card"  v-model="editableTabsValue" >   
     
    
    <el-tab-pane label="Summary" class="is-active">   
      <el-table
      v-if="tableData && matrixDates && matrixDates.length > 0"
      :data="tableData"
      height="450"
      class="crudRow mt-4"
      :header-row-style="{textAlign: 'center'}"
    >
    <el-table-column
      fixed
      prop="plannedEffort"
      label="Planned Effort"
      width="80"
      header-align="center"
    >
    </el-table-column>
    <el-table-column
      fixed
      prop="actualEffort"
      label="Actual Effort"
      width="80"
      header-align="center"
    >
    </el-table-column>
    <el-table-column
      fixed
      prop="text"
      label="Tasks"
      width="250"
      header-align="center"
    >
   
    </el-table-column>
    <el-table-column label="Week of" header-align="center">
      <el-table-column 
      v-for="weekof, i in matrixDates" 
      :key="i" 
      :label='weekof'
      width="90"
      >
     <template slot-scope="scope">  
      <span v-if="userTime && userTime.length > 0">
          {{ 
          userTime
          .filter(t => t && t.id && t.id == scope.row.id) 
          .map(t => t.timesheets)
          .flat()
          .filter(t => t.date_of_week == weekof)    
          .map(t => t.hours).map(Number).reduce((a,b) => a + (b || 0), 0)            
          }}           
      </span>
     </template>              
      </el-table-column>
    </el-table-column>
      </el-table>
      <div v-else>
        You currently have no Tasks in this Project or the Task due date has passed. Please add a task or ensure the due date is a future date.
      </div>
      </el-tab-pane>
      <el-tab-pane
        v-for="(item, index) in timesheets"
        :key="item.id"
        :label="item.full_name"
        :name="index"
      >
      <el-table
      v-if="tableData && matrixDates && matrixDates.length > 0"
      :data="tableData"
      height="450"
      class="crudRow mt-4"
      :header-row-style="{textAlign: 'center'}"
    >
    <el-table-column
      fixed
      prop="plannedEffort"
      label="Planned Effort"
      width="80"
      header-align="center"
    >
    </el-table-column>
    <el-table-column
      fixed    
      prop="actualEffort"  
      label="Actual Effort"
      width="80"
      header-align="center"
    >

    <template slot-scope="scope">        
      <span v-if="item.tasks && item.tasks.filter(t => t.id == scope.row.id )
          .map(t => t.timesheets)      
          .flat()
          .map(t => t.hours).map(Number).reduce((a,b) => a + (b || 0), 0) " >
         {{ item.tasks.filter(t => t.id == scope.row.id )
          .map(t => t.timesheets)      
          .flat()
          .map(t => t.hours).map(Number).reduce((a,b) => a + (b || 0), 0) 
          }}    
      </span>
      <span v-else>
         {{ 0
          }}    
      </span>
    
       </template>   
    </el-table-column>
    <el-table-column
      fixed
      prop="text"
      label="Tasks"
      width="250"
      header-align="center"
    >
   
    </el-table-column>
    <!-- Column of individual users -->
    <el-table-column label="Week of" header-align="center">
      <el-table-column 
        v-for="weekof, weekofIndex in matrixDates" 
        :key="weekofIndex" 
        :label='weekof'  
        width="90">
     <template slot-scope="scope">  
      <span v-if="rowId == scope.row.id">
        <span v-if="item.tasks && item.tasks.length > 0 && item.tasks.filter(t => t.id == scope.row.id )
          .map(t => t.timesheets)
          .flat()
          .filter(t => t.date_of_week == weekof)    
          .map(t => t.hours)[0] ">     
          
          <!-- IF edit dateOfWeek, display input field with v-model that will capture the  -->
       
          <!-- <el-input 
            v-if="editMode"
            type="text" 
            :name="weekof"           
            v-model="item.tasks.filter(t => t.id == scope.row.id )
             .map(t => t.timesheets)
             .flat()
             .filter(t => t.date_of_week == weekof)    
             .map(t => t.hours)[0]          
            "
            :id="weekof"
            >
           </el-input>    -->

           <i class="fa-light fa-calendar-pen text-primary "  
           v-tooltip="`Edit Effort`" 
           @click="timeEdit(
            scope.$index, 
            scope.row, 
            weekof, 
            weekofIndex,
            item.tasks
            .filter(t => t.id == scope.row.id )
            .map(t => t.timesheets)
            .flat()
            .filter(t => t.date_of_week == weekof)           
            )"></i>
           <!-- <i class="fas fa-ban" v-tooltip="`Cancel`"  v-if="columnIndex == weekofIndex" @click="cancelTimeEdit"></i> -->

          <el-input 
            v-if="editMode && weekofIndex == columnIndex"
            type="text" 
            class="editCol"       
            :name="weekof"           
             v-model="editColValue"
            :id="weekof"
            >
           </el-input>    

           
          <span v-else>
          {{ 
          item.tasks.filter(t => t.id == scope.row.id )
          .map(t => t.timesheets)
          .flat()
          .filter(t => t.date_of_week == weekof)    
          .map(t => t.hours)[0] 
          }} 
          </span> 

      </span>   
          <el-input 
          v-else
            type="text" 
            :name="weekof"           
            v-model="input[weekofIndex]"
            :id="weekof"
            >
           </el-input>
      </span>
      <span v-if="item.tasks && item.tasks.length > 0 && rowId !== scope.row.id">       
        {{ 
          item.tasks.filter(t => t.id == scope.row.id )
          .map(t => t.timesheets)
          .flat()
          .filter(t => t.date_of_week == weekof)    
          .map(t => t.hours)[0]          
          }}   
      </span>   
      <span v-if="!item.tasks && rowId !== scope.row.id">         
      </span>  
      <span>
      </span>
       </template>              
      </el-table-column>
       </el-table-column>            
      <el-table-column
        label="Actions"
        width="110"     
        fixed="right"
        align="center"
        >
          <template slot-scope="scope">
              <el-button 
              size="mini"
              type="default" 
              v-tooltip="`Cancel`"       
              v-if="scope.$index == rowIndex"
              @click.prevent="cancelEdits(scope.$index, scope.row)"  
              class="bg-secondary text-light  px-2">
            <i class="fas fa-ban"></i>
              </el-button>
            <el-button
              size="mini"
              type="default"
              v-tooltip="`Add Effort`" 
              class="bg-light px-2"    
              v-if="scope.$index !== rowIndex"       
              @click.prevent="editToggle(scope.$index, scope.row)"> <i class="fa-light fa-calendar-pen text-primary"></i>
              </el-button>            
              <el-button
              type="default"
              size="mini"
              @click.prevent="saveTimesheetRow(scope.$index, scope.row, item.id )"           
              v-tooltip="`Save`" 
              class="bg-primary text-light  px-2">           
            <i class="far fa-save"></i>
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <div v-else>
        You currently have no Tasks in this Project or the Task due date has passed. Please add a task or ensure the due date is a future date.
      </div>
      </el-tab-pane>
      <!-- <el-button type="primary"   @click="editToggle(scope.$index, scope.row)" class="calendarBtn"  circle>
        <i class="fa-light fa-calendar-pen text-light"></i>
      </el-button> -->
     
    </el-tabs>

   
  </div>

</template>

<script>
  import { mapMutations, mapGetters, mapActions } from "vuex"

  export default {
    name: 'SheetTime',
    props: ['facility', 'from'],
    data() {
      return {       
        tabIndex: this.editableTabsValue,
        userTasksDialog : false, 
        loading: true,
        tasksQuery: '',
        rowIndex: null, 
        updatedTimesheet: null, 
        taskProgressFilter: true, 
        hasTimesheet: true, 
        editColValue: '',
        columnIndex: null, 
        addedUser: [],
        hover: false,
        rowId: null, 
        matrixDates: [],
        input: [],
        editMode: false, 
        newNote: false,
        myNotesCheckbox: false,
        notesQuery: '',
        Week: [],
        DV_facility: Object.assign({}, this.facility),
      
      //PROJECT  
      }
    },
    methods: {
      ...mapMutations([
      "SET_TIMESHEET",
      "SET_TIMESHEET_STATUS",
      "SET_TIMESHEETS_STATUS",
      "TOGGLE_TIMESHEET_LOADED",
      "setTaskIssueDueDateFilter"
      ]),
      ...mapActions([
      "createTimesheet",
      "updateTimesheet",
      "fetchTimesheets",
      "fetchCurrentProject"
    ]),
    log(e){
      // console.log("Timesheets Vue: ")
      // console.log(e)
    },
    openUserTasksReport() {
      this.userTasksDialog = true;
    },
    saveTimesheetRow(index, rows, userId){ 

      this.rowIndex = null;
      this.rowId = null;
      
      // IF EDITING, UPDATE TIMESHEET
      if(this.updatedTimesheet && this.updatedTimesheet !== null){
        let t = this.updatedTimesheet
        let timeSheetData = {
          timesheetData: {
            hours: this.editColValue,           
            taskId: t[0].resource_id,
            userId: userId,   
            id: t[0].id, 
            week:t[0].date_of_week, 
            programId: this.$route.params.programId,
            projectId: this.$route.params.projectId
         },
        };
        console.log("update") 
        console.log(this.updatedTimesheet)
        console.log(timeSheetData)
        console.log(this.editColValue)
    this.updateTimesheet({...timeSheetData})

      //ELSE, CREATE NEW TIMESHEET

      }
      if(this.input.length > 0) {
        for (var i = 0; i < this.input.length; i++) {
        if(this.matrixDates[i] && this.input[i] ){
           console.log(this.matrixDates[i])
           console.log(this.input[i])
         let timeSheetData = {
          timesheetData: {
            hours: this.input[i],
            week: this.matrixDates[i],
            taskId: rows.id,
            userId: userId,   
            programId: this.$route.params.programId,
            projectId: this.$route.params.projectId
         },
        };
        console.log("create") 
         console.log(timeSheetData) 
         console.log(this.editColValue)
         this.createTimesheet({...timeSheetData})     
    

        } 
      }   
    } 
    
    }, 
      addTab(targetName) {
        let newTabName = this.timesheets.length;
        if (this.timesheets.length == 1){    
            newTabName = 1
            this.editableTabsValue = newTabName;
        }
        this.timesheets.push({
          full_name: this.addedUser.fullName,
          name: newTabName,
          content: 'New Tab content',
          id: this.addedUser.id 
        });
        this.addedUser = []
      },
      handleClick(tab, event){
        console.log(tab)
        console.log(event)
      },
      editToggle(index, row ){
        this.editMode = true;
        this.editColValue = null;
        this.rowIndex = index
        console.log(row);   
        this.rowId = row.id
      },
     timeEdit(index, row, weekof, weekofIndex, timeSheet ){
        this.columnIndex = weekofIndex 
        console.log(timeSheet);  
        this.updatedTimesheet =  timeSheet 
      },    
      cancelTimeEdit() {
        this.columnIndex = null
      },
      cancelEdits() {
        this.editMode = false; 
        this.rowIndex = null;
        this.rowId = null;  
        this.input = [];
        this.columnIndex = null
      },

    },
    computed: {
      ...mapGetters([
        'myActionsFilter',
        "timesheets",
        "currentProject",
        "taskIssueDueDateFilter",
        "timeSheetStatus",
        "timeSheetsStatus",
        "timeSheetsLoaded",  
        "activeProjectUsers"  
      ]),
      C_taskIssueDueDateFilter: {
      get() {
        if (!this.taskIssueDueDateFilter) return this.taskIssueDueDateFilter
        return this.taskIssueDueDateFilter.map(d => d ? new Date(d) : d)
      },
      set(value) {
        this.setTaskIssueDueDateFilter(value)
      }
     },
     userTime(){
        if(this.timesheets && this.timesheets.length > 0){
          let time = this.timesheets.map(t => t.tasks).flat()        
          // .filter((task) => {
          //     if (this.hasTimesheet && task.timesheets && task.timesheets.length > 0) {                  
          //       return task.timesheets.length > 0;
          //     } else return true;
          //   })     
          //   console.log(time)
            return time   
        }
      },
      tableData() {
          if (this.facility && this.facility.tasks && this.facility.tasks.length > 0){
            let tasks = this.facility.tasks

            .filter((task) => {
              if (this.taskProgressFilter) {    
                console.log(task)      
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
      filteredActiveProjectUsers(){
        if(this.timesheets && this.activeProjectUsers && this.timesheets.length > 0){
           return this.activeProjectUsers.filter( t => !this.timesheets.map(f => f.id).includes(t.id))
        } else {
          return this.activeProjectUsers
        }
      },
      weekOfArr(){
        if(this.facility && this.facility.tasks && this.facility.tasks.length > 0){
          // let taskStartDates = this.facility.tasks.map(t => new Date(t.startDate))  
          let taskDueDates = this.facility.tasks.map(t => new Date(t.dueDate))  
        
          // let earliestTaskDate = taskStartDates.sort((date1, date2) => new Date(date1).setHours(0, 0, 0, 0) - new Date(date2).setHours(0, 0, 0, 0))[0]
          let latestTaskDate = taskDueDates.sort((date1, date2) => new Date(date1).setHours(0, 0, 0, 0) - new Date(date2).setHours(0, 0, 0, 0))[taskDueDates.length - 1]

          var start = new Date("01/06/2023");          
          var end = latestTaskDate;  

          var loop = new Date(start);
          while(loop <= end){

            console.log(moment(loop).format("DD MMM YY") );    
            this.matrixDates.push(moment(loop).format("DD MMM YY"))
            console.log("MAtrix Dates:  ")
          console.log( this.matrixDates)
        
            var newDate = loop.setDate(loop.getDate() + 7);
            loop = new Date(newDate);
          }     
        }     
      },
      filteredNotes() {
        const resp = this.exists(this.notesQuery.trim()) ? new RegExp(_.escapeRegExp(this.notesQuery.trim().toLowerCase()), 'i') : null
        return _.filter(this.DV_facility.notes, n => {
          let valid = this.C_myNotes ? this.$currentUser.id == n.userId : true
          if (resp) valid = valid && resp.test(n.body)
          return valid
        })
      },     
    },
    mounted() {
     this.fetchTimesheets(this.$route.params)
    //  this.fetchCurrentProject(this.$route.params.programId)
    },
    watch: {
      timesheets(){
        if(this.timesheets){
          console.log('UserTime: ')
          console.log(this.userTime)
          console.log('Current projec: ')
          console.log(this.currentProject)
        }
      },
     timeSheetStatus: {
      //Need to add weekOfArr value here to handle data better than the current load property within the template
      handler() {
        if (this.timeSheetStatus == 200) {
          console.log('timeSheet status OK')
          this.$message({
            message: `Task Effort successfully saved.`,
            type: "success",
            showClose: true,
          });
          this.input = [];
          this.editColValue = null;
          this.columnIndex = null;
          this.updatedTimesheet = null, 
          this.SET_TIMESHEET_STATUS(0);
          this.SET_TIMESHEETS_STATUS(0)
          this.fetchTimesheets(this.$route.params)
          this.fetchCurrentProject(this.$route.params.programId)
        }
      },
      
    },      
      matrixDates(){
        if(this.matrixDates){
          console.log("Matrix Dates in Watch: ")
          console.log(this.matrixDates)
        }        
      },
     input(){
        if(this.input && this.input.length > 0){
          console.log('input array:')
          console.log(this.input)
        }
      },
      facility: {
        handler: function(value) {
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
/deep/ #tab-0 {
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
.editCol{
  input::-webkit-outer-spin-button,
  input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

/* Firefox */
input[type=number] {
  -moz-appearance: textfield;
}
  width: 70% !important;
}
/deep/ .el-table .cell {
    word-break: break-word;
}
/deep/ .el-table thead {
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
  .addNote{
    box-shadow: 0 5px 10px rgba(56,56, 56,0.19), 0 1px 1px rgba(56,56,56,0.23);
  }
  .notes{
    padding:8px;
    box-shadow: 0 5px 10px rgba(56,56, 56,0.19), 0 1px 1px rgba(56,56,56,0.23);
    z-index: 100;
  }
  #notesHover:hover {
    box-shadow: 0.5px 0.5px 1px 1px rgba(56,56, 56,0.29), 0 2px 2px rgba(56,56,56,0.23);
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
  // notes-rows creates a scroallable div within a container, preventing the need to scroll beyond the viewport height
  // .notes-rows {
  //   overflow-y: scroll;
  //   box-shadow: 0.5px 0.5px 1px 1px rgba(56,56, 56,0.29), 0 2px 2px rgba(56,56,56,0.23);
  //   max-height: 59vh;
  //   border-top: solid 4px #ededed;
  //   padding-top: 8px;  
  // }
  
</style>
