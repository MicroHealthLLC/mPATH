<template>
  <div id="notes-index" data-cy="note_list" class="mt-5 pl-1" :load="log(weekOfArr)">      
    <span :load="log(editableTabsValue)">
      <div class="form-group w-100 mr-1 row">
              <!-- <label class="font-md mb-0"><i class="fa-solid fa-user-plus text-light"> </i> </label> -->
              
              <div class="col-3" >
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
                clearable
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
                clearable
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
            
             <div class="col-1 mt-4 pl-0" >       
                <i  v-show="!weekEnd && !weekBegin"  class="fa-sharp fa-circle-xmark" style="color:#d3d3d3" v-tooltip="`Clear Week Of filter(s)`"></i>                 
                <i v-show="weekEnd || weekBegin" class="fa-sharp fa-light fa-circle-xmark cursor" v-tooltip="`Clear Week Of filter(s)`" @click="clearWeekFilters"></i>                       
              </div>     
         
              <div class="col-1 mt-4 px-0">
               <el-switch
                v-model="taskProgressFilter"
                active-text="Active Tasks"
                inactive-text="All Tasks*">
              </el-switch>
              <!-- <el-switch
                v-model="hasEffort"
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
      prop="plannedEffort"
      label="Planned Effort"
      width="80"
      header-align="center"
    >
    </el-table-column>
    <el-table-column
      prop="actualEffort"
      label="Actual Effort"
      width="80"
      header-align="center"
    >
    </el-table-column>
    <el-table-column
      prop="text"
      label="Tasks"
      width="250"
      header-align="center"
    >
   
    </el-table-column>
    <el-table-column label="Week of" header-align="center"  v-if="matrixDates && matrixDates.length > 0">
      <el-table-column 
      v-for="weekof, i in matrixDates" 
      :key="i" 
      :label='weekof'
      width="120"
      >
     <template slot-scope="scope">  
      <span v-if="userTime && userTime.length > 0 &&  userTime
          .filter(t => t && t.id && t.id == scope.row.id) 
          .map(t => t.efforts)
          .flat()
          .filter(t => t.date_of_week == weekof)    
          .map(t => t.hours).map(Number).reduce((a,b) => a + (b || 0), 0)  !== 0">
          {{ 
          userTime
          .filter(t => t && t.id && t.id == scope.row.id) 
          .map(t => t.efforts)
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
        v-for="(item, index) in efforts"
        :key="item.id"
        :label="item.full_name"
        :name="index"
      >
      <el-table
      v-if="tableData && matrixDates && matrixDates.length > 0"
      :data="tableData"
      height="450"
      id="crudRow"
      class="crudRow mt-4"
      :header-row-style="{textAlign: 'center'}"
    >
    <el-table-column
     
      prop="plannedEffort"
      label="Planned Effort"
      width="80"
      header-align="center"
    >
    </el-table-column>
    <el-table-column
    
      prop="actualEffort"  
      label="Actual Effort"
      width="80"
      header-align="center"
    >

    <template slot-scope="scope">        
      <span v-if="item.tasks && item.tasks.filter(t => t.id == scope.row.id )
          .map(t => t.efforts)      
          .flat()
          .map(t => t.hours).map(Number).reduce((a,b) => a + (b || 0), 0) " >
         {{ item.tasks.filter(t => t.id == scope.row.id )
          .map(t => t.efforts)      
          .flat()
          .map(t => t.hours).map(Number).reduce((a,b) => a + (b || 0), 0) 
          }}    
      </span>
      <span v-else>
         {{ 
          }}    
      </span>
    
       </template>   
    </el-table-column>
    <el-table-column    
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
        width="120">
     <template slot-scope="scope">  


        <!-- DEFAULT VIEW MODE  -->
        <span v-if="item.tasks && item.tasks.length > 0 && rowId !== scope.row.id">       
        {{ 
          item.tasks.filter(t => t.id == scope.row.id )
          .map(t => t.efforts)
          .flat()
          .filter(t => t.date_of_week == weekof)    
          .map(t => t.hours)[0]          
          }}   
      </span>   
      <span v-if="!item.tasks && rowId !== scope.row.id">         
      </span>  


      <!-- IF ENTER/EDIT BUTTON IS CLICKED, THIS IS THE EDIT MODE -->
      <span v-if="rowId == scope.row.id">
        <span v-if="item.tasks && item.tasks.length > 0 && item.tasks.filter(t => t.id == scope.row.id )
          .map(t => t.efforts)
          .flat()
          .filter(t => t.date_of_week == weekof)    
          .map(t => t.hours)[0] ">     
          
    
             <!-- <i class="fa-light fa-calendar-pen text-primary "  
           v-tooltip="`Edit Effort`" 
           @click="timeEdit(
            scope.$index, 
            scope.row, 
            weekof, 
            weekofIndex,
            item.tasks
            .filter(t => t.id == scope.row.id )
            .map(t => t.efforts)
            .flat()
            .filter(t => t.date_of_week == weekof)           
            )"></i>  -->
           <el-input                 
            type="text" 
            class="editCol" 
            v-model="item.tasks.filter(t => t.id == scope.row.id )
             .map(t => t.efforts)
             .flat()
             .filter(t => t.date_of_week == weekof)    
             .map(t => t.hours)[0]        
            "        
            >
           </el-input>    
           <!-- <el-input                 
            type="text" 
            :name="weekof"    
            class="editCol" 
            v-model="editedValues.filter(t => t.date_of_week == weekof)[0].hours     
            "        
            >
           </el-input>    -->
                   
   <!-- CREATE MODE IF ENTER/EDIT BUTTON IS CLICKED -->

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

      
    
    
       </template>              
      </el-table-column>
       </el-table-column>            
      <el-table-column
        label="Actions"
        width="110"     
      
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
              @click.prevent="editToggle(scope.$index, scope.row, rowIndex, item)"> <i class="fa-light fa-calendar-pen text-primary"></i>
              </el-button>            
              <el-button
              type="default"
              size="mini"
              @click.prevent="saveEffortRow(scope.$index, scope.row, item.id )"           
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
    <span class="float-right"><small>*Excludes <em>On Hold, Planned,</em> and <em>Draft</em> Tasks</small> </span>

   
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
        userTasksDialog : false, 
        loading: false,
        tasksQuery: '',
        weekBegin: '',
        weekEnd: '',
        // lastDueDate: '',
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
        editedValues: [],
        input: [],
        gFunk:'',
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
      "fetchCurrentProject"
    ]),
    log(e){
      console.log("Dates ")
      console.log(this.weekOfFilter)
    },
    handleChange(e){
      console.log("hadnleChange:")
      console.log(e)
    },
    clearWeekFilters(){   
      this.matrixDates = [];
      let taskDueDates = this.facility.tasks.filter(t => t && t.dueDate !== null).map(t => new Date(t.dueDate))         
      let latestTaskDate = taskDueDates.sort((date1, date2) => new Date(date1).setHours(0, 0, 0, 0) - new Date(date2).setHours(0, 0, 0, 0))[taskDueDates.length - 1]       
                    
      if(taskDueDates.length == 1 ){
        latestTaskDate = new Date(taskDueDates[0])
      }
      let start = this.fridayDayOfWeek       
      let end = latestTaskDate.setDate(latestTaskDate.getDate() + 7);

      let loop = new Date(start);    
      loop = loop.setDate(loop.getDate() - 7); 
      this.weekBegin  = "";
      this.weekEnd = "";   
      
      while(loop <= end){
      this.matrixDates.push(moment(loop).format("DD MMM YY"))         
      let newDate = loop.setDate(loop.getDate() + 7);
      loop = new Date(newDate);
      }             
    },
    openUserTasksReport() {
      this.userTasksDialog = true;
    },
    saveEffortRow(index, rows, userId){ 

      this.rowIndex = null;
      this.rowId = null;
      
      // IF EDITING, UPDATE EFFORT
      if(this.editColValue){
        //Line 502 is not the original condition
        let t = this.updatedEffort
        let effortData = {
          effortData: {
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
        console.log(this.updatedEffort)
        console.log(effortData)
        console.log(this.editColValue)
    this.updateEffort({...effortData})

      //ELSE, CREATE NEW EFFORT

      }
      if(this.input.length > 0) {
        for (var i = 0; i < this.input.length; i++) {
        if(this.matrixDates[i] && this.input[i] ){
           console.log(this.matrixDates[i])
           console.log(this.input[i])
         let effortData = {
          effortData: {
            hours: this.input[i],
            week: this.matrixDates[i],
            taskId: rows.id,
            userId: userId,   
            programId: this.$route.params.programId,
            projectId: this.$route.params.projectId
         },
        };
        console.log("create") 
         console.log(effortData) 
         console.log(this.editColValue)
         this.createEffort({...effortData})     
    

        } 
      }   
    } 
    
    }, 
      addTab(targetName) {
        let newTabName = this.efforts.length;
        if (this.efforts.length == 1){    
            newTabName = 1
            this.editableTabsValue = newTabName;
        }
        this.efforts.push({
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
      editToggle(index, row, weekIndex, item ){
        this.editMode = true;
        this.editColValue = null;
        this.rowIndex = index
        console.log(row);  
        console.log(this.rowIndex); 
        let hoursArr = item.tasks.filter(t => t.id == row.id).map(t => t.efforts).flat()
        console.log(hoursArr.map(t => t.hours));
        this.editedValues = hoursArr.filter(t => t.id).filter(t => this.matrixDates.includes(t.date_of_week))
        console.log(this.editedValues);
        console.log(item.tasks.filter(t => t.id == row.id).map(t => t.efforts).flat())
        console.log(item.tasks.filter(t => t.id == row.id)[0].id); ;  
        this.rowId = row.id
      },
     timeEdit(index, row, weekof, weekofIndex, effort ){
        this.columnIndex = weekofIndex 
        console.log(effort);  
        this.updatedEffort =  effort 
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
        if(this.efforts && this.efforts.length > 0){
          let time = this.efforts.map(t => t.tasks).flat()   
          return time   
        }
      },
      tableData() {
         let project = this.facilities.find((facility) => facility.facilityId == this.$route.params.projectId)     
          if (project && project.tasks && project.tasks.length > 0){
            let tasks = project.tasks.filter( t => !t.onHold && !t.draft && !t.planned)
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
        if(this.efforts && this.activeProjectUsers && this.efforts.length > 0){
           return this.activeProjectUsers.filter( t => !this.efforts.map(f => f.id).includes(t.id))
        } else {
          return this.activeProjectUsers
        }
      },
      fridayDayOfWeek( ) {
        let date = new Date();
        let friday = 5; 
        let resultDate = new Date(date.getTime());
        resultDate.setDate(date.getDate() + (7 + friday - date.getDay()) % 7);
        return resultDate;
      },     
      weekOfArr(){
        if(this.facility && this.facility.tasks && this.facility.tasks.length > 0){
          let taskDueDates = this.facility.tasks.filter(t => t && t.dueDate !== null).map(t => new Date(t.dueDate))         
          let latestTaskDate = taskDueDates.sort((date1, date2) => new Date(date1).setHours(0, 0, 0, 0) - new Date(date2).setHours(0, 0, 0, 0))[taskDueDates.length - 1]       
                        
          if(taskDueDates.length == 1 ){
            latestTaskDate = new Date(taskDueDates[0])
          }
          let start = this.fridayDayOfWeek       
          let end = latestTaskDate.setDate(latestTaskDate.getDate() + 7);
          // console.log(this.facility.tasks.filter(t => t && t.dueDate !== null))   
          // console.log(latestTaskDate)   
          // console.log(  this.lastDueDate )   
          let loop = new Date(start);     

          if(this.weekBegin){    
            console.log("YES")    
            start = this.weekBegin  
            loop = new Date(start)      
            this.matrixDates = []                  

          }

          if(this.weekEnd ){     
            end = new Date(this.weekEnd)                   
          }
       
          while(loop <= end){
          this.matrixDates.push(moment(loop).format("DD MMM YY"))         
          let newDate = loop.setDate(loop.getDate() + 7);
          loop = new Date(newDate);
          }        
               
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
      // weekOfArr(){
      //   if(this.facility && this.facility.tasks && this.facility.tasks.length > 0){
      //     let taskDueDates = this.facility.tasks.map(t => new Date(t.dueDate))         
      //     let latestTaskDate = taskDueDates.sort((date1, date2) => new Date(date1).setHours(0, 0, 0, 0) - new Date(date2).setHours(0, 0, 0, 0))[taskDueDates.length - 1]       
                        
      //     if(taskDueDates.length == 1 ){
      //       console.log(taskDueDates[0])   
      //       latestTaskDate = new Date(taskDueDates[0])
      //     }
      //     // let start = this.fridayDayOfWeek;     

      //     let start = new Date("01/06/2023");  
      //     // let start = this.fridayDayOfWeek 
      //     // let start = f.setDate(f.getDate() - 7);    
      
      //     let end = latestTaskDate.setDate(latestTaskDate.getDate() + 7);  
      //     // let end = this.fridayDayOfWeek;  
   
      //     let loop = new Date(start);
      //     // if (this.weekOfString !== "") {
      //     //  start = new Date(this.weekOfString)
      //     // }  
      //     while(loop <= end){  
      //       this.matrixDates.push(moment(loop).format("DD MMM YY"))
      //       let newDate = loop.setDate(loop.getDate() + 7);
      //       loop = new Date(newDate);
      //     }            
      //  }  
      // },
      // WIP WeekOf filter to choose what date to focus table on 
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
        if(this.facility && this.facility.tasks && this.facility.tasks.length > 0){
          let arr = []
          let taskDueDates = this.facility.tasks.map(t => new Date(t.dueDate))  
          let latestTaskDate = taskDueDates.sort((date1, date2) => new Date(date1).setHours(0, 0, 0, 0) - new Date(date2).setHours(0, 0, 0, 0))[taskDueDates.length - 1]
          let pastBeginDate =  this.fridayDayOfWeek.setDate(this.fridayDayOfWeek.getDate() + 7)
          let end1 = latestTaskDate.setDate(latestTaskDate.getDate() + 42);  
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
          console.log('effort status OK')
          this.$message({
            message: `Task Effort successfully saved.`,
            type: "success",
            showClose: true,
          });
   
          this.input = [];
          this.editColValue = null;
          this.columnIndex = null;
          this.updatedEffort = null, 
          this.SET_EFFORT_STATUS(0);
          this.SET_EFFORTS_STATUS(0)          
          this.fetchCurrentProject(this.$route.params.programId)
          this.fetchEfforts(this.$route.params)       
        }
      },      
     },  
     editedValues(){
      if(this.editedValues && this.editedValues.length > 0){
        console.log('Edited Values:')
          console.log(this.editedValues)
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
.cursor{
  cursor: pointer;
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
