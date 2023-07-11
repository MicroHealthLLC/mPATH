<!--  NOTE: This File is used in Map view right side bard -->
<!-- In Select Date of Week Filter, if date is future, render column with projected_dates -->

<template>
  <div class="container-fluid m-2" data-cy="facility_rollup" :load="log(weekOfArr)">
       <el-alert  
       v-if="overdueTasks && overdueTasks.value7 && overdueTasks.value7.length > 0"
        type="warning"
        class="pt-0 pb-2"
        show-icon >
       <template slot="title">
        You have {{  overdueTasks.value7.length}} Task(s) due within the next 7 days:  <em>{{ overdueTasks.value7.map(t => t.text).join(", ") }}</em>  
       </template>
       </el-alert>
   <!-- <el-tabs type="border-card" @tab-click="handleClick">
  <el-tab-pane label="Program Rollup" class="p-3"> -->
    <!-- FIRST ROW:  PROGRAM NAME AND COUNT -->   
    <div class="row pt-3 pb-2">
      <div class="col-6 py-1 pl-0">
        <span v-if="contentLoaded"  :load="log(showProjectedHours)">
          <h4 v-if="isMapView" class="d-inline mr-2 programName">{{ currentProject.name }}</h4>          
          <h3 v-else class="d-inline mr-2 programName">{{ currentProject.name }}</h3>        
        </span>     
        
       
      </div>
      <div class="col-6 py-1 pl-0">
        <span v-if="contentLoaded" class="float-right mt-1">
          <router-link :to="ProgramView" > 
          <button                
            class="btn  btn-sm mh-orange text-light programViewerBtn allCaps" data-cy=program_viewer_btn>
            {{ currentProject.name }} DATA VIEWER
          </button>   
          </router-link>     
        <span               
        class="btn btn-sm profile-btns allCaps pl-2" >
         TASK EFFORT REPORTS 
        <i class="fas fa-clipboard mh-green-text grow pl-3 pr-1"  v-tooltip="`BY PROJECTS`" @click="openProjectGroup"></i>
        <i class="fas fa-users mh-blue-text grow pr-2"  v-tooltip="`BY USERS`"  @click="openUserTasksReport"></i>
        <!-- <i class="fas fa-print text-dark grow" @click="printTaskReport"></i> -->
        </span>    
               
      <!-- PROGRAM LEVEL TASK EFFORT REPORT BEGINS -->
      <el-dialog
        :visible.sync="dialog2Visible"
        append-to-body
        center   
      >
     <h4 class="centerLogo">{{ currentProject.name }}'s 
     <button                
        class="btn mh-orange text-light allCaps profile-btns py-1" data-cy=program_viewer_btn>
       Task Effort Report
      </button>
    </h4>   
   <!-- WIP:  Adding Filters to Program Task Effort Report   -->
     <div class="row my-2">
        <div class="col-3">
          <h6 class="mb-1 d-flex">Select Week Of Date</h6>
        <el-select
        v-model="programDateOfWeekFilter"
        class="w-100"            
        clearable
        placeholder="Search and select Week of Date" 
        filterable
      >
        <el-option
          v-for="item in matrixDates"
          :value="item"
          :key="item"
          :label="item"
        >
        </el-option> 
      </el-select>    
        </div>   
        <div class="col-3" v-show="false"> 
          <h6 class="mb-1 d-flex">Select Users </h6>
        <el-select
        v-model="filteredUsers"
        multiple
        class="w-100 mr-2"
        track-by="id"
        value-key="id"             
        clearable
        placeholder="Search and select Program users with entered effort" 
        filterable
      >
        <el-option
          v-for="item in effortUsers"
          :value="item"
          :key="item.id"
          :label="item.full_name"
        >
        </el-option> 
      </el-select>
     
        </div>
     
      </div> 
      <button 
        @click="printProgramEffortReport(currentProject.name, programDateOfWeekFilter)"   
        v-tooltip="`Export to PDF`"            
        class="btn btn-sm profile-btns text-light  allCaps pl-2  mb-2" > <i class="fas fa-print text-dark grow" ></i> 
      </button> 
    <div class="taskUserInfo col-11 mt-2" >
      <span class="mt-2"><h6><b class="mr-1">Week of:</b>{{ programDateOfWeekFilter }}</h6></span> 
      <span><h6><b class="mr-1">Date of Report:</b>{{ moment().format("DD MMM YY") }} </h6></span>  

     <table
      class="table table-sm table-bordered mt-3"
      >
      <thead>        
        <tr style="background-color:#ededed">
          <th style="width:28%; font-size: 1rem">Project</th>
          <th style="width:28%; font-size: 1rem">Task</th>    
          <th style="font-size: 1rem">Planned Effort<br>for Entire Task</th>
          <th style="font-size: 1rem">Actual Effort<br>for Entire Task</th>
          <th style="font-size: 1rem">Actual Effort<br>for This Week</th>
          <th style="font-size: 1rem">Progress</th>
        </tr>
      </thead>
      <tbody v-for="(task, i) in programTaskEffort
        .filter(t => t  && t.tasks.length > 0 && t.tasks)" :key="i" class="mb-2"
        >
       <tr class="mb-2" style="line-height: 3;">
        <td class="updates">{{task.facility_name}}</td>
        <td class="updates">            
          <span class="a" v-for="each, i in task.tasks.filter(g => g && g.on_hold == false)" :key="i">           
          {{ each.text }}  <br>    
          </span>         
        </td>          
        <td class="updates text-center">            
          <span class="a" v-for="each, i in task.tasks.filter(g => g && g.on_hold == false)" :key="i">           
             {{  each.planned_effort }}<br>                  
          </span>          
        </td>
        <td class="updates text-center">            
          <span class="a" v-for="each, i in task.tasks.filter(g => g && g.on_hold == false)" :key="i">           
            {{ each.actual_effort }} <br>    
          </span>          
        </td>       
        <td class="updates text-center">            
          <span class="a" v-for="each, i in task.tasks.filter(g => g && g.on_hold == false)" :key="i">           
            {{ each.efforts_actual_effort }} <br>    
          </span>          
        </td>       
        <td class="updates text-center">            
          <span class="a" v-for="each, i in task.tasks.filter(g => g && g.on_hold == false)" :key="i">           
         {{ each.progress }}<br>        
          </span>          
        </td>    
      </tr>  
      <!-- Second Table Row for Effort Totals per project -->
      <tr class="py-2">
       <td >     
      </td> 
      <td class="text-right">      
        <span class="bold">Project Efforts Totals: </span>
      </td>         
      <td class="text-center">     
       <b class="bold" >{{ task.tasks.filter(g => g && g.on_hold == false).map(t => t.planned_effort).map(Number).reduce((a,b) => a + (b || 0), 0).toFixed(2) }}</b>
      </td> 
      <td class="text-center">     
        <b class="bold"> {{task.tasks.filter(g => g && g.on_hold == false).map(t => t.actual_effort).map(Number).reduce((a,b) => a + (b || 0), 0).toFixed(2) }}</b>
      </td> 
      <td class="text-center">     
        <b class="bold"> {{ task.tasks.filter(g => g && g.on_hold == false).map(t => t.efforts_actual_effort).map(Number).reduce((a,b) => a + (b || 0), 0).toFixed(2) }}</b>
      </td> 
      <td>        
      </td>
      </tr>        
    </tbody>  
    <tr class="py-2">
       <td >     
      </td> 
      <td class="text-right">     
        <b class="bold" >PROGRAM EFFORT TOTAL: </b>  
      </td> 
      <td class="text-center">     
        <span class="bold">
        {{ programTaskEffort.filter(t => t  && t.tasks.length > 0) 
              .filter(t => t.tasks && t.tasks.length > 0).map(t => t.tasks)            
              .flat()
              .filter(g => g && g.on_hold == false)
              .map(t => t.planned_effort).map(Number).reduce((a,b) => a + (b || 0), 0).toFixed(2) 
        }}</span>  
      </td> 
      <td class="text-center">     
        <b class="bold">
        {{ programTaskEffort.filter(t => t  && t.tasks.length > 0) 
              .filter(t => t.tasks && t.tasks.length > 0).map(t => t.tasks)
              .flat()
              .filter(g => g && g.on_hold == false)
              .map(t => t.actual_effort).map(Number).reduce((a,b) => a + (b || 0), 0).toFixed(2)
        }}</b>  
      
      </td> 
      <td class="text-center">     
        <b class="bold">
        {{ programTaskEffort.filter(t => t  && t.tasks.length > 0) 
              .filter(t => t.tasks && t.tasks.length > 0).map(t => t.tasks)
              .flat()
              .filter(g => g && g.on_hold == false)
              .map(t => t.efforts_actual_effort).map(Number).reduce((a,b) => a + (b || 0), 0).toFixed(2)
        }}</b>  
      
      </td> 
      <td></td>  
    
      </tr>  
    </table>
    <span class="centerLogo" >
        <img
          class="my-2"
          style="width: 147px;cursor:pointer"
          id="img1"
          :src="require('../../../assets/images/microhealthllc.png')"
        />
      </span>

</div>
    

    <table
      class="table table-sm table-bordered mt-3"
      ref="table1" id="taskSheetsList1"
      style="display: none;"
      >
      <thead>        
        <tr style="background-color:#ededed">
          <th>Project</th>
          <th>Task</th> 
          <th class="text-center">Planned Effort<br>for Entire Task</th>
          <th class="text-center">Actual Effort<br>for Entire Task</th>
          <th class="text-center">Actual Effort<br>for This Week</th>
          <th class="text-center">Progress</th>
        </tr>
      </thead>
      <tbody v-for="(task, i) in programTaskEffort.filter(t => t  && t.tasks.length > 0)" :key="i" class="mb-2">
       <tr class="mb-2">
        <td class="updates">{{task.facility_name}}</td>
        <td class="updates">            
          <span class="a" v-for="each, i in task.tasks.filter(g => g && g.on_hold == false)" :key="i">           
          {{ each.text }}  <br>    
          </span>         
        </td>      
        <td class="updates text-center">            
          <span class="a" v-for="each, i in task.tasks.filter(g => g && g.on_hold == false)" :key="i">           
             {{  each.planned_effort }}<br>                  
          </span>          
        </td>
        <td class="updates text-center">            
          <span class="a" v-for="each, i in task.tasks.filter(g => g && g.on_hold == false)" :key="i">           
            {{  each.actual_effort }} <br>    
          </span>          
        </td>       
        <td class="updates text-center">            
          <span class="a" v-for="each, i in task.tasks.filter(g => g && g.on_hold == false)" :key="i">           
            {{  each.efforts_actual_effort }} <br>    
          </span>          
        </td>       
        <td class="updates text-center">            
          <span class="a" v-for="each, i in task.tasks.filter(g => g && g.on_hold == false)" :key="i">           
         {{ each.progress }}<br>      
          </span>          
        </td>          
      </tr>  
      <!-- Second Table Row for Effort Totals per project -->
      <tr class="py-2">
       <td >     
      </td>  
      <td class="text-right">     
        <em class="bold float-left">Project Efforts Totals: </em>   
      </td> 
      <td class="text-center">    
        <em class="bold" >{{ task.tasks.filter(g => g && g.on_hold == false).map(t => t.planned_effort).map(Number).reduce((a,b) => a + (b || 0), 0).toFixed(2)  }}</em>
      </td> 
      <td class="text-center">     
        <em class="bold"> {{ task.tasks.filter(g => g && g.on_hold == false).map(t => t.actual_effort).map(Number).reduce((a,b) => a + (b || 0), 0).toFixed(2)  }}</em>
      </td> 
      <td class="text-center">     
        <em class="bold"> {{ task.tasks.filter(g => g && g.on_hold == false).map(t => t.efforts_actual_effort).map(Number).reduce((a,b) => a + (b || 0), 0).toFixed(2)  }}</em>
      </td> 
      <td>      
      </td>     
      </tr>        
    </tbody>   
    <tr class="py-2">
       <td >     
      </td> 
      <td>  
        <em class="text-dark float-left"> PROGRAM EFFORT TOTAL</em>  
      </td>    
      <td class="text-center">
        <em class="text-dark ">
        {{ programTaskEffort.filter(t => t  && t.tasks.length > 0) 
              .filter(t => t.tasks && t.tasks.length > 0)
              .map(t => t.tasks)
              .flat()
              .filter(g => g && g.on_hold == false)
              .map(t => t.planned_effort).map(Number).reduce((a,b) => a + (b || 0), 0).toFixed(2)
        }}</em>  
      </td> 
      <td class="text-center">
        <em class="text-dark">
        {{ programTaskEffort.filter(t => t  && t.tasks.length > 0) 
              .filter(t => t.tasks && t.tasks.length > 0).map(t => t.tasks)
              .flat()
              .filter(g => g && g.on_hold == false)
              .map(t => t.actual_effort).map(Number).reduce((a,b) => a + (b || 0), 0).toFixed(2) 
        }}</em>        
      </td> 
      <td class="text-center">
        <em class="text-dark">
        {{ programTaskEffort.filter(t => t  && t.tasks.length > 0) 
              .filter(t => t.tasks && t.tasks.length > 0).map(t => t.tasks)
              .flat()
              .filter(g => g && g.on_hold == false)
              .map(t => t.efforts_actual_effort).map(Number).reduce((a,b) => a + (b || 0), 0).toFixed(2)
        }}</em>        
      </td> 
      <td>     
      </td>      
      </tr>   
    </table> 
  
      </el-dialog>
      <!-- PROGRAM LEVEL TASK EFFORT REPORT ENDS -->


      <!-- USER TASK EFFORT REPORT BEGINS -->
  
      <el-dialog
        :visible.sync="reportCenterModal"
        append-to-body
        class="reportCenter"
        center   
      >
     <h4 class="centerLogo mb-5">{{ currentProject.name }}'s
      <button                
        class="btn mh-orange text-light profile-btns allCaps py-1" data-cy=program_viewer_btn>
        User Task Effort Reports
      </button>  
      </h4>   
      <hr class="my-3">
      <div class="row mt-3">
        <div class="col">
          <h6 class="mb-1 d-flex">Select Week Of Date</h6>
        <el-select
        v-model="dateOfWeekFilter"
        class="w-75 mr-2"            
        clearable
        placeholder="Search and select Week of Date" 
        filterable
      >
        <el-option
          v-for="item in matrixDates"
          :value="item"
          :key="item"
          :label="item"
        >
        </el-option> 
      </el-select> 
   
        </div>  
        <div class="col"> 
          <h6 class="mb-1 d-flex">Select Users </h6>
        <el-select
        v-model="filteredUsers"
        multiple
        class="w-75 mr-2"
        track-by="id"
        value-key="id"             
        clearable
        placeholder="Search and select Program users with entered effort" 
        filterable
      >
        <el-option
          v-for="item in effortUsers"
          :value="item"
          :key="item.id"
          :label="item.full_name"
        >
        </el-option> 
      </el-select> 

        </div>
        <div class="col-2 px-0 mt4">
        <el-switch
        v-model="showProjectedHours"
        active-text="Show Projected Effort"
       >
      </el-switch>

      <!-- 
       WHERE PROJECTED HOURS TOGGLE NEEDS TO BE APPLIED 
      Values asterisk in bottom left, 
      Columnd header
      Print Out
      Watch property
      In row logic -->
      </div>

      </div> 
     
      <div class="row mb-5">
        <div class="col">
          <!-- <button                
           @click="viewTaskEffortReport"
            class="btn btn-sm mh-green profile-btns text-light allCaps pl-2 mr-2" >
           View Reports      
            <i class="fas fa-binoculars text-light grow"></i> 
          </button>     -->


        <!-- <button                
            class="btn btn-sm mh-orange profile-btns text-light allCaps pl-2" >
            CREATE REPORT
          
            <i class="fas fa-print text-light grow" @click="printTaskReport"></i> 
          </button>     -->


        </div>
      </div>
   
  <div v-if="tableData && tableData.length > 0" class="ml-1" :load="log(programTaskEffort)">
  <div class="mb-2">
  <button 
    v-tooltip="`Export to PDF`"   
    @click="printAllReports(dateOfWeekFilter, tableData, showProjectedHours)"               
    class="btn btn-md p-2 orange mb-2"> 
    <i class="fas fa-print pr-2" ></i>  
    PRINT ALL
  </button>  
  </div>
    <br/>
  
    <div 
     class="taskUserInfo mb-4 col-11" 
     v-for="user, userIndex in tableData.filter(t => t.facilities.map(t => t.tasks.length > 0)) "      
     :key="user.id"      
     >
     <!-- <button 
        v-tooltip="`Print All`"   
        @click="printAllUsers"
         class="btn btn-sm profile-btns text-light  allCaps pl-2  mb-2" > <i class="fas fa-print text-dark grow" ></i>  
      </button> -->
      <button 
        v-tooltip="`Export to PDF`"   
        @click="printTaskReport(userIndex,
         dateOfWeekFilter, 
         user.full_name, 
         user.title, 
         dateOfWeekFilter, 
         showProjectedHours
         )"               
        class="btn btn-sm profile-btns text-light  allCaps pl-2  mb-2" > <i class="fas fa-print text-dark grow" ></i>  
      </button>   
     
      <span class="mt-2"><h6><b class="mr-1">Week of:</b>{{ dateOfWeekFilter }}</h6></span> 
      <span><h6><b class="mr-1">Date of Report:</b>{{ moment().format("DD MMM YY") }} </h6></span>     
      <span><h6><b class="mr-1">Name of Staff:</b> {{ user.full_name }} </h6> </span> 
      <span><h6><b class="mr-1">Position:</b>{{ user.title }} </h6></span> 
       
      <table 
      class="table table-sm table-bordered mt-3"  
      style="">     
      <thead>        
        <tr style="background-color:#ededed">
          <th style="width:15%; font-size: 1rem">Project</th>
          <th style="width:14%; font-size: 1rem">Task</th>
          <th style="width:22%; font-size: 1rem">Last Update</th>
          <th style="width:14%; font-size: 1rem">Planned Effort <br>for Entire Task</th>
          <th  style="width:12%; font-size: 1rem"> 
            <span v-if="dateOfWeekFilter == 'ALL WEEKS' && showProjectedHours">
              Actual (Projected) <br> Effort for User
            </span>              
            <span v-else>
            Actual Effort for<br> User This Week
            </span>  
                   
          </th>
          <th style="width:12%; font-size: 1rem">%Completion <br>(if applicable)</th>
        </tr>
      </thead>
      <tbody v-for="(task, i) in user.facilities.filter(t => t  && t.tasks.length > 0)" :key="i" class="mb-2">
       <tr class="mb-1" style="line-height: 3;" v-if="task">
        <!-- Col 1 -->
        <td class="updates">{{ task.facility_name }}
        </td>
        <!-- Col 2 -->
        <td class="updates">
          <span v-for="each, i in task.tasks.filter(t => t.efforts.length > 0)" :key="i">
          {{ each.text }}<br>
        </span>
        </td>
         <!-- Col 3 -->
        <td class="updates">
        <span v-for="each, i in task.tasks.filter(t => t.efforts.length > 0)" :key="i">
         <span v-if="each.last_update && each.last_update.body"> {{ each.last_update.body }}</span>  <br>
        </span>       
        </td>
        <!-- Col 4 -->
        <td class="text-center">
          <span v-for="each, i in task.tasks" :key="i">
          {{ each.planned_effort }}<br>
        </span>
      
        </td>   
         
        <!-- Col 5 -->
      
       <td class="text-center">
          <span v-for="each, i in task.tasks.filter(t => t.efforts.length > 0)" :key="i">
          <span>
            {{ each.efforts.filter(t => !t.projected || fridayDayOfWeek == t.date_of_week ).map(t => t.hours).map(Number).reduce((a,b) => a + (b || 0), 0) }}
          </span>

          <span v-if="dateOfWeekFilter == 'ALL WEEKS' && showProjectedHours">
            ({{ each.efforts.filter(t => t.projected && fridayDayOfWeek !== t.date_of_week).map(t => t.hours).map(Number).reduce((a,b) => a + (b || 0), 0) }})
          </span>     
          <br>
        </span>
        
         
        </td> 
         <!-- Col 6 -->  
        <td class="text-center">
          <span v-for="each, i in task.tasks" :key="i">
          {{ each.progress }}<br>
        </span>
        </td>
      </tr>  
     
      <tr class="py-2">
     <!-- Col 1 -->  
      <td ></td> 
      <!-- Col 2 -->  
      <td ></td> 
       <!-- Col 3 -->  
      <td ></td> 
       <!-- Col 4 -->  
      <td class="text-right" >
        <span class="bold">Project's Effort Total:   
            
        </span>   

      </td> 
      <!-- Col 5 -->  
      <td class="text-center">   
        <span class="bold">
            {{ task.tasks
              .filter(t => t.efforts.length > 0)
              .map(t => t.efforts)
              .flat()
              .filter(t => !t.projected || fridayDayOfWeek == t.date_of_week)
              .map(t => t.hours )
              .map(Number)
              .reduce((a,b) => a + (b || 0), 0) 
              }} 
        </span>   
        <span class="bold" v-if="dateOfWeekFilter == 'ALL WEEKS' && showProjectedHours">          
            ({{ task.tasks
              .filter(t => t.efforts.length > 0)
              .map(t => t.efforts).flat()
              .filter(t => t.projected && fridayDayOfWeek !== t.date_of_week)
              .map(t => t.hours)
              .map(Number)
              .reduce((a,b) => a + (b || 0), 0) 
              }})                   
        </span>   
      </td> 
       <!-- Col 6 -->  
      <td>      
      </td> 
      </tr>
      </tbody>       
      </table>
      <table
      class="table table-sm table-bordered"     
      style=""
      >
      <thead style="background-color:#ededed"> 
        <tr style="background-color:#ededed">
          <th style="width:15%; font-size: 1rem"></th>
          <th style="width:14%; font-size: 1rem"></th>
          <th style="width:22%; font-size: 1rem"></th>
          <th style="width:14%; font-size: .80rem; text-align: right; padding-right: 4px">Program's Effort Total: </th>
          <th style="width:12%; font-size: .80rem; text-align: center">          
            {{ user.facilities
            .filter(t => t.tasks && t.tasks.length > 0)
            .map(t => t.tasks).flat()
            .map(t => t.efforts)
            .flat().filter(t => !t.projected || fridayDayOfWeek == t.date_of_week)
            .map(t => t.hours)
            .map(Number)
            .reduce((a,b) => a + (b || 0), 0)            
            }}
          <span class="bold" v-if="dateOfWeekFilter == 'ALL WEEKS' && showProjectedHours">                  
            ({{ user.facilities
            .filter(t => t.tasks && t.tasks.length > 0)
            .map(t => t.tasks).flat()
            .map(t => t.efforts).flat()
            .filter(t => t.projected && fridayDayOfWeek !== t.date_of_week)
            .map(t => t.hours)
            .map(Number)
            .reduce((a,b) => a + (b || 0), 0)            
            }})
          </span>
          </th>
          <th style="width:12%; font-size: 1rem"></th>
        </tr>       
      
      </thead>
     
    </table> 
    <span v-if="dateOfWeekFilter == 'ALL WEEKS' && showProjectedHours">( ) Values in parenthesis represent Projected Effort</span>
   <!-- BEGIN USER EFFORT PRINT OUT TABLE -->    
    <table class="table table-sm mt-3" 
      :id="`taskSheetsList1${userIndex}`"
      ref="table" 
      style="display:none">   
      <thead>     
    
        <tr style="background-color:#ededed">
          <th>Project</th>
          <th>Task</th>
          <th>Last Update</th> 
          <th>Planned Effort <br>for Entire Task</th>
          <th>
            <span v-if="dateOfWeekFilter == 'ALL WEEKS' && showProjectedHours">
              Actual (Projected) <br> Effort for User
            </span>              
            <span v-else>
            Actual Effort for<br> User This Week
            </span>              
          </th>
          <th>%Completion <br>(if applicable)</th>
        </tr>
  
      </thead>
      <tbody v-for="(task, i) in user.facilities.filter(t => t  && t.tasks.length > 0)" :key="i" class="mb-2">

       <tr class="mb-1" v-if="task" style="line-height: 3">
        <td>{{ task.facility_name }}</td>       
        <td>
          <span v-for="each, i in task.tasks.filter(t => t.efforts.length > 0)" :key="i">
          {{ each.text }}<br>
        </span>
        </td>
        <td>
        <span v-for="each, i in task.tasks.filter(t => t.efforts.length > 0)" :key="i">
         <span v-if="each.last_update && each.last_update.body"> {{ each.last_update.body }}</span>  <br>
        </span>  
        </td>
         <td class="text-center">
          <span v-for="each, i in task.tasks" :key="i">
          {{ each.planned_effort }}<br>
        </span>
        </td>   

        <td class="text-center">
          <span v-for="each, i in task.tasks.filter(t => t.efforts.length > 0)" :key="i">
          <span>
            {{ each.efforts
            .filter(t => !t.projected || fridayDayOfWeek == t.date_of_week)
            .map(t => t.hours)
            .map(Number)
            .reduce((a,b) => a + (b || 0), 0) 
            }}
          </span>
          <span v-if="dateOfWeekFilter == 'ALL WEEKS' && showProjectedHours">
            ({{ each.efforts
            .filter(t => t.projected && fridayDayOfWeek !== t.date_of_week)
            .map(t => t.hours)
            .map(Number)
            .reduce((a,b) => a + (b || 0), 0) 
            }})
          </span> 
           <br>
          </span>    
        </td>   

         <td class="text-center">
          <span v-for="each, i in task.tasks" :key="i">
          {{ each.progress }}<br>
        </span>
        </td>   
      </tr>  
     
      <tr class="py-2">    
      <td >    
      </td>      
      <td >       
      </td>  
      <td >
       
      </td> 
      <td >
        <em class="bold">Project's Effort Total:  
        </em>
      </td>   
      <td> 
        <span class="bold">
            {{ task.tasks
            .filter(t => t.efforts.length > 0)
            .map(t => t.efforts).flat()
            .filter(t => !t.projected || fridayDayOfWeek == t.date_of_week)
            .map(t => t.hours )
            .map(Number)
            .reduce((a,b) => a + (b || 0), 0) 
            }} 
        </span>   
        <span class="bold" v-if="dateOfWeekFilter == 'ALL WEEKS' && showProjectedHours">          
            ({{ task.tasks
            .filter(t => t.efforts.length > 0)
            .map(t => t.efforts).flat()
            .filter(t => t.projected && fridayDayOfWeek !== t.date_of_week)
            .map(t => t.hours)            
            .map(Number)
            .reduce((a,b) => a + (b || 0), 0) 
            }})                   
        </span>   
      </td> 
         <td>

         </td>
      </tr>

      </tbody>  
      <tr class="py-2">    
      <td></td>      
      <td></td>  
      <td></td>
      <!-- Col 4 -->
      <td >
        <em class="text-dark">Program's Effort Total:
        </em>
      </td>
      <!-- Col 5 -->
      <td>
          {{ user.facilities
          .filter(t => t.tasks && t.tasks.length > 0)
          .map(t => t.tasks).flat()
          .map(t => t.efforts).flat()
          .filter(t => !t.projected || fridayDayOfWeek == t.date_of_week)
          .map(t => t.hours)
          .map(Number)
          .reduce((a,b) => a + (b || 0), 0)            
          }}
          <span class="bold" v-if="dateOfWeekFilter == 'ALL WEEKS' && showProjectedHours">                  
            ({{ user.facilities
            .filter(t => t.tasks && t.tasks.length > 0)
            .map(t => t.tasks).flat()
            .map(t => t.efforts).flat()
            .filter(t => t.projected && fridayDayOfWeek !== t.date_of_week)
            .map(t => t.hours)
            .map(Number)
            .reduce((a,b) => a + (b || 0), 0)            
            }})
          </span>
      </td>
      <!-- Col 6 -->
      <td></td>           
      </tr>     
 
    </table>
   <!-- END USER EFFORT PRINT OUT TABLE -->
   
    <span class="centerLogo" >
        <img
          class="my-2"
          style="width: 147px;cursor:pointer"
          :src="require('../../../assets/images/microhealthllc.png')"
        />
      </span>
     
     </div>  
    </div> 
  
    
      </el-dialog>

      <!-- USER TASK EFFORT REPORT ENDS -->
        </span>         
       </div>       
    </div>

<!-- SECOND ROW: ACTION CARDS (TASK, ISSUES, RISKS, LESSONS) -->
    <div class="row">
      <div class="col-9 py-0 px-0" :class="[isMapView ? 'col-12' : '']">
          <el-card
            class="box-card mb-2"
            style="background-color:#fff"
            data-cy="task_summary"
          >      
            <div class="row mb-4">
             <div class="col pb-2 relative" >
                      <h5 class="d-inline text-light px-2 mh-blue absolute">TASKS</h5>
                      <h4 class="d-inline">
                        <b data-cy="tasks_count"
                          class="badge badge-secondary badge-pill pill"
                          >{{ filteredTasks.length }}</b
                        >
                      </h4>
                      <!-- <hr /> -->
                    </div>
            </div>

            <div v-if="contentLoaded">
               <div class="row mt-1 text-center">               
                <div class="col p-0 mb-0">                                       
                <span v-tooltip="`100% Progress achieved`" class="d-block">
                  <i class="fas fa-clipboard-check text-success grow" id="taskFlags" @click="completedOnly"></i>
                </span>           
                  <span class="smallerFont d-block">COMPLETE</span>               
                 </div>
                  
               <div class="col p-0 mb-0">
                <span v-tooltip="`Start date on or before current date`" class="d-block">
                  <i class="far fa-tasks text-primary grow" id="taskFlags" @click="inprogressOnly"></i>
                </span>
                     <span class="smallerFont d-block">IN PROGRESS</span>           
                </div>

                  <div class="col p-0  mb-0">                  
                  <span v-tooltip="`Start date beyond current date (not a Draft)`"  class="d-block">
                    <i class="fas fa-calendar-check text-info font-md grow" id="taskFlags" @click="plannedOnly"></i>
                  </span>
                      <span class="smallerFont d-block">PLANNED</span>
                </div>
                <div class="col p-0 mb-0" >
                <!-- <div class="col p-0 mb-0">  -->
                 <span v-tooltip="`Due Date has passed`" class="d-block">
                   <i class="fas fa-calendar text-danger grow" id="taskFlags" @click="overdueOnly"> </i>
                  </span>
                     <span class="smallerFont d-block">OVERDUE</span>               
                </div>
                 <div class="col p-0 mb-0">
                 <span v-tooltip="`Temporarily halted`" class="d-block">
                   <i class="fas fa-pause-circle text-primary font-md grow" id="taskFlags" @click="onholdOnly"></i>
                   </span>
                      <span class="smallerFont d-block">ON HOLD  </span>           
                </div>
                  <div class="col p-0 mb-0">
                 <span  class="d-block" v-tooltip="`Unofficial action`">
                   <i class="fas fa-pencil-alt text-warning font-md grow" id="taskFlags" @click="draftsOnly"></i>
                  </span>
                    <span class="smallerFont d-block">DRAFTS</span>               
                </div>
                 <div class="col p-0 mb-0">
                   
               <span  class="d-block" v-tooltip="`Recurring action without Due Date`">
                 <i class="fas fa-retweet text-success grow" id="taskFlags" @click="ongoingOnly"></i></span>
                 <span class="smallerFont d-block">ONGOING </span>    
                </div>  
             
              </div>

                <div class="row text-center mt-0" :class="[filteredTasks.length > 0 ? '' : '']">
                <div class="col pb-0 mb-0">
                   <h4 class="">{{
                    taskVariation.completed.count
                  }}</h4>         
                </div>
                 <div class="col pb-0 mb-0">
                  <h4>{{
                    taskVariation.inProgress.count
                  }}</h4>        
                </div>
                 <div class="col pb-0 mb-0">
                   <h4 class="">{{
                    taskVariation.planned.count
                  }}</h4>         
                </div>
                 <div class="col pb-0 mb-0">
                   <h4>{{ taskVariation.overdue.count }}
                     </h4>
                                    
                </div>
                 <div class="col pb-0 mb-0">
                  <h4>{{
                    taskVariation.onHoldT.count
                  }}</h4>        
                </div>
                <div class="col pb-0 mb-0">
                   <h4>{{  taskVariation.taskDrafts.count }}</h4>                      
                </div>
                 <div class="col pb-0 mb-0">
                  <h4>{{
                    taskVariation.ongoing.length
                  }}<span
                       v-tooltip="`Ongoing: Closed`"
                       v-if="taskVariation.ongoingClosed.count > 0"
                       style="color:lightgray"
                       >({{taskVariation.ongoingClosed.count}})
                    </span>
                  </h4>          
                </div>               
               </div>      
                
           
           
                 <div v-if="filteredTasks.length">
                <el-collapse id="roll_up" class="taskCard">
                  <el-collapse-item title="..." name="1">
                     
                    <div class="row my-1">
                      <div class="col-6">
                        <span class="underline" :class="{ 'font-sm': isMapView }">PROCESS AREAS</span>
                      </div>
                      <div class="col-1 pl-0">
                        #
                      </div>
                        <div class="col-5 pl-3">
                          <span class="underline" :class="{ 'font-sm': isMapView }">PROGRESS</span>
                      </div>
                    </div>
                    <div v-for="(task, index) in currentTaskTypes" :key="index">
                      <div class="row font-sm" v-if="task._display">
                        <div class="col-6">
                          <span class="font-sm"> {{ task.name }}</span>                       
                        </div>
                        <div class="col-1 pl-0">                      
                          <span
                            class="badge badge-secondary  font-sm badge-pill"
                      
                            >{{ task.length }}</span
                          >
                        </div>

                        <div class="col-5">
                          <span
                            class="w-100 progress ml-2 pg-content"
                            :class="{ 'progress-0': task.progress <= 0 }"
                          >
                            <div
                              class="progress-bar bg-info"
                              :style="`width: ${task.progress}%`"
                            >
                              {{ task.progress }} %
                            </div>
                          </span>
                        </div>
                      </div>
                    </div>
                  </el-collapse-item>
                </el-collapse>
              </div>
              <div v-else>
                 <el-collapse id="roll_up" class="taskCard">
                  <el-collapse-item title="..." name="1">
                <div class="row mt-1 text-center">
                <div class="col p-0  mb-0">                  
                  NO DATA TO DISPLAY
                </div>             
              </div>        
                  </el-collapse-item>
                </el-collapse>
              </div>
            </div>
            <div v-if="!contentLoaded" class="my-4">
              <loader type="code"></loader>
            </div>
          </el-card>

      </div>
       <div class="col-3 pl-2 pt-0" :class="[isMapView ? 'd-none' : '']" data-cy="facility_tasks">
                <el-card class="box-card" style="background-color:#fff">
                  <div class="row">
                    <div class="col text-center mh-blue py-0">
                      <h6 class="d-block mb-0 text-center text-light">TASK PROGRESS</h6>                  
                    </div>
                  </div>

                <div class="row mt-1 text-center">
                <div class="col p-0 mb-0">
                  
               <h4 class="text-center">
                        <span :class="{ 'progress-0': allTasksProgress.final <= 0 }">
                          <el-progress
                            type="circle"
                            class="py-3"                          
                            :percentage="Math.round(allTasksProgress.final)"
                          ></el-progress>
                        </span>
                      </h4>
                </div>
                </div>
           
                <div>
              </div>
          </el-card>
              </div>

    </div>

    <div class="row">
    <div class="col-9 py-0 px-0" :class="[isMapView ? 'col-12' : '']" >
          <el-card
          class="box-card mb-2"
          style="background-color:#fff"
          data-cy="issue_summary"
        >
          <div class="row mb-4">
            <div class="col pb-2 relative" >
                    <h5 class="d-inline text-light px-2 mh-green absolute">ISSUES</h5>
                    <h4 class="d-inline">
                      <b data-cy="issues_count"
                        class="badge badge-secondary badge-pill pill"
                        >{{ filteredIssues.length }}</b
                      >
                    </h4>
                    <!-- <hr /> -->
                  </div>
          </div>

          <div v-if="contentLoaded">
              <div class="row mt-1 text-center">
              <div class="col p-0 mb-0">                  
                <span v-tooltip="`100% Progress achieved`" class="d-block">
                  <i class="fas fa-clipboard-check text-success grow" id="issueFlags" @click="completedOnly" ></i>
                </span>
                      <span class="smallerFont d-block">COMPLETE</span>
              </div>
                <div class="col p-0 mb-0">
              <span v-tooltip="`Start date on or before current date`" class="d-block">
                <i class="far fa-tasks text-primary grow" id="issueFlags" @click="inprogressOnly"></i>
              </span>
                    <span class="smallerFont d-block">IN PROGRESS</span>           
              </div>
                <div class="col p-0  mb-0">                  
                <span v-tooltip="`Start date beyond current date (not a Draft)`" class="d-block">
                  <i class="fas fa-calendar-check text-info font-md grow" id="issueFlags" @click="plannedOnly"></i>
                </span>
                    <span class="smallerFont d-block">PLANNED</span>
              </div>
                <div class="col p-0 mb-0">
                <span v-tooltip="`Due Date has passed`" class="d-block">
                  <i class="fas fa-calendar text-danger grow" id="issueFlags" @click="overdueOnly"> </i>
                </span>
                    <span class="smallerFont d-block">OVERDUE</span>               
              </div>
              <div class="col p-0 mb-0">
                <span v-tooltip="`Temporarily halted`" class="d-block">
                  <i class="fas fa-pause-circle text-primary font-md grow" id="issueFlags" @click="onholdOnly" ></i>
                </span>
                    <span class="smallerFont d-block">ON HOLD  </span>           
              </div>
                <div class="col p-0 mb-0">
                <span  class="d-block" v-tooltip="`Unofficial action`" >
                  <i class="fas fa-pencil-alt text-warning font-md grow" @click="draftsOnly" id="issueFlags" ></i>
                </span>
                  <span class="smallerFont d-block">DRAFTS</span>               
              </div>
<!-- Hidden for aligment purposes -->
                <div class="col p-0 mb-0">
                <span class="d-block hide">
                  <i class="fas fa-pencil-alt text-warning font-md grow"></i>
                </span>
                <span class="d-block smallerFont hide">DRAFTS</span>               
                </div>   
              
            </div>

              <div class="row text-center mt-0" :class="[filteredIssues.length > 0 ? '' : '']">
              <div class="col pb-0 mb-0">
                  <h4 class="">{{
                  issueVariation.completed.count
                }}</h4>         
              </div>
                <div class="col pb-0 mb-0">
                <h4>{{
                  issueVariation.inProgress.count
                }}</h4>        
              </div>
              <div class="col pb-0 mb-0">
                  <h4 class="">{{
                  issueVariation.planned.count
                }}</h4>         
              </div>
                <div class="col pb-0 mb-0">
                  <h4>{{ issueVariation.overdue.count }}
                    </h4>                      
              </div>  
                <div class="col pb-0 mb-0">
                <h4>{{
                  issueVariation.onHoldI.count
                }}</h4>        
              </div>
                <div class="col pb-0 mb-0">
                  <h4>{{ issueVariation.issueDrafts.count }}</h4>                      
              </div> 
                <div class="col pb-0 mb-0">
                  <h4 class="mb-0 hide">{{ issueVariation.issueDrafts.count }}</h4>                      
                </div>
              </div>
              <!-- Hidden for alignment purposes -->
              
                          

            <!-- If Issues? Place in collapsible container -->
            <div v-if="filteredIssues.length">
              <el-collapse>
                <el-collapse-item title="..." name="1">
                <div v-if="contentLoaded">
                      <div class="row">
                      <div class="col mt-1 underline">
                          PROCESS AREAS
                      </div>
                        <div class="col-1 pl-0">
                      #
                    </div>
                      <div class="col-5 pl-3">
                        <span class="underline" :class="{ 'font-sm': isMapView }">PROGRESS</span>
                    </div>
                    </div>
                    <div
                      class="row"
                      v-for="(issue, index) in issueTaskCATEGORIES"
                      :key="index"
                    >
                      <div class="col-6">
                        <span> {{ issue.name }}</span>                      
                      </div>
                      <div class="col-1 pl-0">    
                                            
                        <span                       
                        class="badge badge-secondary font-sm badge-pill">{{
                          issue.count
                        }}</span>
                      </div>
                      <div class="col-5">
                        <span
                          class="w-100 my-1 progress ml-2 pg-content"
                          :class="{ 'progress-0': issue.progress <= 0 }"
                        >
                          <div
                            class="progress-bar bg-info"
                            :style="`width: ${issue.progress}%`"
                          >
                            {{ issue.progress }} %
                          </div>
                        </span>
                      </div>
                    </div>
                  </div>

                  <div class="col mt-2 mb-1 pl-0 underline">
                    ISSUE TYPES
                  </div>
                  <div v-for="issue in currentIssueTypes" :key="issue.id">
                    <div class="row font-sm" v-if="issue._display">
                      <div class="col-6">
                        <span> {{ issue.name }}</span>                        
                      </div>
                      <div class="col-1 pl-0">                        
                        <span                          
                          class="badge badge-secondary  font-sm badge-pill">{{
                          issue.length
                        }}</span>
                      </div>
                      <div class="col-5">
                        <span
                          class="w-100 my-1 progress ml-2 pg-content"
                          :class="{ 'progress-0': issue.progress <= 0 }"
                        >
                          <div
                            class="progress-bar bg-info"
                            :style="`width: ${issue.progress}%`"
                          >
                            {{ issue.progress }} %
                          </div>
                        </span>
                      </div>
                    </div>
                  </div>
                </el-collapse-item>
              </el-collapse>
            </div>
            <div v-else>
                <el-collapse id="roll_up" class="taskCard">
                <el-collapse-item title="..." name="1">
              <div class="row mt-1 text-center">
              <div class="col p-0  mb-0">
                
                      NO DATA TO DISPLAY
              </div>
                
            
            </div>                 
                </el-collapse-item>
              </el-collapse>
            </div>
          </div>

          <div v-if="!contentLoaded" class="my-4">
            <loader type="code"></loader>
          </div>
        </el-card>
    </div>

        <div class="col-3 pl-2 pt-0" :class="[isMapView ? 'd-none' : '']" data-cy="facility_tasks">
              <el-card class="box-card" style="background-color:#fff">
                <div class="row">
                  <div class="col text-center mh-green py-0">
                    <h6 class="d-block mb-0 text-center text-light">ISSUE PROGRESS</h6>
                    
                  
                  </div>
                </div>

              <div class="row mt-1 text-center">
              <div class="col p-0 mb-0">
                
              <h4 class="text-center">
                      <span :class="{ 'progress-0': allIssuesProgress.final <= 0 }">
                        <el-progress
                          type="circle"
                          class="py-3"                          
                          :percentage="Math.round(allIssuesProgress.final)"
                        ></el-progress>
                      </span>
                    </h4>
              </div>
              </div>
          
              <div>
            </div>
        </el-card>
            </div>
    </div>

    <div class="row">
      <div class="col-9 py-0 px-0" :class="[isMapView ? 'col-12' : '']">
          <el-card
              class="box-card"
              style="background-color:#fff"
              data-cy="risk_summary"
            >
           <div class="row mb-4">
             <div class="col pb-2 relative" >
                      <h5 class="d-inline text-light px-2 mh-orange absolute">RISKS</h5>
                      <h4 class="d-inline">
                        <b data-cy="risks_count"
                          class="badge badge-secondary badge-pill pill"
                          >{{ filteredRisks.length }}</b
                        >
                      </h4>
                      <!-- <hr /> -->
                    </div>
            </div>

             <div v-if="contentLoaded">
              <div class="row mt-1 text-center">
                <div class="col p-0 mb-0">
                  
                  <span v-tooltip="`100% Progress achieved`" class="d-block">
                   <i class="fas fa-clipboard-check text-success grow" id="riskFlags" @click="completedOnly"></i>
                  </span>
                       <span class="smallerFont d-block">COMPLETE</span>
                </div>
                 <div class="col p-0 mb-0">
                 <span  v-tooltip="`Start date on or before current date`"  class="d-block">
                   <i class="far fa-tasks text-primary grow" id="riskFlags" @click="inprogressOnly"></i>
                   </span>
                     <span class="smallerFont d-block"> IN PROGRESS   </span>           
                </div>
                <div class="col p-0  mb-0">                    
                    <span v-tooltip="`Start date beyond current date (not a Draft)`" class="d-block">
                      <i class="fas fa-calendar-check text-info font-md grow" id="riskFlags" @click="plannedOnly"></i>
                    </span>
                        <span class="smallerFont d-block">PLANNED</span>
                  </div>
                 <div class="col p-0 mb-0">
                 <span  v-tooltip="`Due Date has passed`" class="d-block">
                    <i class="fas fa-calendar text-danger grow" id="riskFlags" @click="overdueOnly"> </i>
                  </span>
                     <span class="smallerFont d-block">OVERDUE </span>               
                </div>
                <div class="col p-0 mb-0">
                   <span v-tooltip="`Temporarily halted`" class="d-block">
                     <i class="fas fa-pause-circle text-primary font-md grow" id="riskFlags" @click="onholdOnly"></i>
                     </span>
                      <span class="smallerFont d-block"> ON HOLD  </span>           
                  </div>
                  <div class="col p-0 mb-0">
                    <span v-tooltip="`Unofficial action`" class="d-block">
                       <i class="fas fa-pencil-alt text-warning font-md grow" id="riskFlags" @click="draftsOnly"></i>
                    </span>
                        <span class="smallerFont d-block">DRAFTS</span>               
                  </div>
                 <div class="col p-0 mb-0">
                   <span v-tooltip="`Recurring action without Due Date`" class="d-block"> 
                      <i class="fas fa-retweet text-success grow" id="riskFlags" @click="ongoingOnly"></i>
                  </span>
                     <span class="smallerFont d-block">ONGOING</span>    
                </div>       
              </div>
            

              <div class="row text-center mt-0" :class="[filteredRisks.length > 0 ? '' : '']">
                <div class="col pb-0 mb-0">
                   <h4 class="">{{
                    riskVariation.completed.count
                  }}</h4>         
                </div>
                 <div class="col pb-0 mb-0">
                  <h4>{{
                    riskVariation.inProgress.count
                  }}</h4>        
                </div>
                <div class="col pb-0 mb-0">
                  <h4 class="">{{
                    riskVariation.planned.count
                  }}</h4>         
                </div>
                 <div class="col pb-0 mb-0">
                   <h4>{{ riskVariation.overdue.count }}
                     </h4>
                 </div>
                  <div class="col pb-0 mb-0">
                  <h4>{{
                    riskVariation.onHoldR.count
                  }}</h4>        
                </div>
                 <div class="col pb-0 mb-0">
                  <h4>{{  riskVariation.riskDrafts.count }}</h4>                      
                </div>
                 <div class="col pb-0 mb-0">
                  <h4>{{
                    riskVariation.ongoing.length
                  }}<span
                       v-tooltip="`Ongoing: Closed`"
                       v-if="riskVariation.ongoingClosed.count > 0"
                       style="color:lightgray"
                       >({{riskVariation.ongoingClosed.count}})</span>       
                  </h4>       
                </div>
                </div>
                 
              

              <div v-if="filteredRisks.length > 0">
                <el-collapse  id="roll_up" class="taskCard">
                  <el-collapse-item title="..." name="1">             
                   
                    <div class="row">
                      <div class="col my-1 underline">
                      PROCESS AREAS
                      </div>
                       <div class="col-1 pl-0">
                        #
                      </div>
                        <div class="col-5 pl-3">
                          <span class="underline" :class="{ 'font-sm': isMapView }">PROGRESS</span>
                      </div>
                    </div>

                    <div v-for="risk in currentRiskTypes" :key="risk.id">
                      <div class="row" v-if="risk._display">
                        <div class="col-6">
                          <span> {{ risk.name }}</span>                    
                        </div>
                        <div class="col-1 pl-0">                 
                          <span                       
                          class="badge badge-secondary  font-sm badge-pill">{{
                            risk.length
                          }}</span>
                        </div>
                        <div class="col-5">
                          <span
                            class="w-100 my-1 ml-2 progress pg-content"
                            :class="{ 'progress-0': risk.progress <= 0 }"
                          >
                            <div
                              class="progress-bar bg-info"
                              :style="`width: ${risk.progress}%`"
                            >
                              {{ risk.progress }} %
                            </div>
                          </span>
                        </div>
                      </div>
                    </div>

                    <div v-if="contentLoaded">
                      <div class="row mt-3 mb-2">
                        <div class="col underline">
                          <span :class="{ 'font-sm': isMapView }">
                            RISK PRIORITY LEVELS</span
                          >
                        </div>
                      </div>
                      <div class="row">
                        <div
                          class="col text-center"
                          v-if="isMapView"
                        >
                          <p class="mb-2 grey2" v-tooltip="`Very Low`">VL</p>
                          <p class="mb-2 green" v-tooltip="`Low`">L</p>
                          <p class="mb-2 yellow" v-tooltip="`Moderate`">M</p>
                        </div>
                        <div
                        v-else
                          class="col text-center"                     
                        >
                          <p class="mb-2 grey2">Very Low</p>
                          <p class="mb-2 green">Low</p>
                          <p class="mb-2 yellow">Moderate</p>
                        </div>
                        <div class="col" :class="{ 'font-sm': isMapView }">
                          <span
                            class="mt-1 p-1 badge w-50 badge-secondary badge-pill d-block"
                            >{{ riskPriorityLevels.grey }}</span
                          >
                          <span
                            class="my-2 p-1 badge w-50 badge-secondary badge-pill d-block"
                            >{{ riskPriorityLevels.green }}</span
                          >
                          <span
                            class="my-2 p-1 badge w-50 badge-secondary badge-pill d-block"
                            >{{ riskPriorityLevels.yellow }}</span
                          >
                        </div>
                        <div
                          class="col text-center"               
                          v-if="isMapView"
                        >
                          <p class="mb-2 orange" v-tooltip="`High`">H</p>
                          <p class="mb-2 red" v-tooltip="`Extreme`">E</p>
                        </div>
                        <div
                          class="col text-center"               
                          v-else
                        >
                          <p class="mb-2 orange">High</p>
                          <p class="mb-2 red">Extreme</p>
                        </div>
                        <div class="col">
                          <span
                            class="mt-1 p-1 badge w-50 badge-secondary badge-pill d-block"
                            >{{ riskPriorityLevels.orange }}</span
                          >
                          <span
                            class="my-2 p-1 badge w-50 badge-secondary badge-pill d-block"
                            >{{ riskPriorityLevels.red }}</span
                          >
                        </div>
                      </div>
                    </div>
                  </el-collapse-item>
                </el-collapse>
              </div>
              <div v-else>
                 <el-collapse id="roll_up" class="taskCard">
                  <el-collapse-item title="..." name="1">
                <div class="row mt-1 text-center">
                  <div class="col p-0  mb-0">                  
                    NO DATA TO DISPLAY
                  </div>             
                 </div>
                  </el-collapse-item>
                </el-collapse>
              </div>
              </div>
              <div v-if="!contentLoaded" class="my-4">
                <loader type="code"></loader>
              </div>          
        
            </el-card>
      </div>
          <div class="col-3 pt-0 pl-2" :class="[isMapView ? 'd-none' : '']" data-cy="facility_tasks">
                <el-card class="box-card" style="background-color:#fff">
                  <div class="row">
                    <div class="col text-center mh-orange py-0">
                      <h6 class="d-block mb-0 text-center text-light">RISK PROGRESS</h6>                  
                    </div>
                  </div>

                <div class="row mt-1 text-center">
                <div class="col p-0 mb-0">
                  
               <h4 class="text-center">
                        <span :class="{ 'progress-0': allRisksProgress.final <= 0 }">
                          <el-progress
                            type="circle"
                            class="py-3"                          
                            :percentage="Math.round(allRisksProgress.final)"
                          ></el-progress>
                        </span>
                      </h4>
                </div>
                </div>
           
                <div>
              </div>
          </el-card>
              </div>
    </div>

    <div class="row" :class="[isMapView ? 'mt-2' : '']">
      <div class="col-2 pt-0" :class="[isMapView ? 'col-3 px-0 ' : 'pl-0']">
        <el-card
            class="box-card mb-2"        
            style="background-color:#fff"  
          >
            <div class="row mb-4">
              <div class="col pb-0 relative">
                <h5 class="text-light px-2 bg-secondary absolute">LESSONS</h5>
                <h5 v-if="contentLoaded" class="d-inline">
                    <b class="pill badge badge-secondary badge-pill pill mr-1">{{
                      programLessonsCount.total_count 
                    }}</b>
                  </h5>
                </div>
            </div>      
              <div class="row mt-3 text-center" >
                <div class="col-6 p-0 mb-0">                  
                  <span  class="d-block" v-tooltip="`COMPLETE`">
                     <i class="fas fa-clipboard-check text-success grow" id="lessonFlags" @click="completedOnly"></i>
                  </span>
                       <span :class="[isMapView ? 'd-none' : 'd-block']" class="sm">COMPLETE</span>
                </div>
                 <div class="col-6 p-0 mb-0">
                <span class="d-block"  v-tooltip="`DRAFTS`">
                  <i class="fas fa-pencil-alt text-warning font-md grow" id="lessonFlags" @click="draftsOnly"></i>
                  </span>
                     <span :class="[isMapView ? 'd-none' : 'd-block']" class="sm">DRAFTS</span>           
                </div>
                
                  </div>
                <div class="row text-center mt-0">
                <div class="col-6 pb-0 mb-0">
                  <h4 class="">{{
                   programLessonsCount.completed
                  }}</h4>         
                </div>
                <div class="col-6 pb-0 mb-0">
                  <h4>{{
                   programLessonsCount.progress
                  }}</h4>        
                </div>                     
                </div>            
           
    
          </el-card>
      </div> 
      <div :class="[isMapView ? 'col-9 pr-0' : 'col p-0']">
        <el-card class="box-card">
          <div class="row">
            <div class="col">
              <h5 class="d-inline">PROJECTS</h5>
               <h4 v-if="contentLoaded" class="d-inline">
                    <span class="badge bg-secondary text-light badge-pill float-right">
                     {{ C_facilityCount }}
                    </span>
                  </h4>
              <hr />
            </div>
          </div>
          <div v-if="contentLoaded && C_facilityCount > 0">
            <div>
               <div class="row">
                   <div class="col-6 mb-0 card-title">
                     Project Status
                   </div>
                    <div class="col-1 mb-0 pl-2 card-title">   
                      #
                    </div>      
                     <div class="col-5 mb-0 pl-4 card-title">   
                       Project Distribution
                    </div>      
               </div>
              <div class="row mb-2"  v-for="(status, index) in projectStatuses" :key="index">
                <div class="col-6 mb-1">
                  <span
                    class="badge badge-pill badge-color"
                    :class="{ 'font-sm': isMapView }"
                    :style="`background: ${status.color}`"
                    >&nbsp;</span
                  >
                  <span :class="{ 'font-sm': isMapView }">
                    {{ status.name }}</span
                  >                
                </div>
                <div class="col-1 pl-0 mb-1">                
                  <span class="badge badge-secondary badge-pill font-sm">{{
                    status.length
                  }}</span>
                </div>
                <div class="col-5">
                  <span
                    class="w-100 mt-1 ml-2 progress pg-content"
                    :class="{
                      'font-sm': isMapView,
                      'progress-0': status.progress <= 0,
                    }"
                  >
                    <div
                      class="progress-bar bg-info"
                      :style="`width: ${status.progress}%`"
                    >
                      {{ status.progress }} %
                    </div>
                  </span>
                </div>
              </div>
            </div>
          </div>
          <div v-if="!contentLoaded" class="my-4">
            <loader type="code"></loader>
          </div>
        </el-card>
     </div>
      <div :class="[isMapView ? 'col-12 p-0' : 'col pt-0']"
        v-if="from !== 'manager_view'"
        data-cy="facility_group_summary"
      >

        <!-- Issues -->
    
    
   
           <el-card class="box-card" data-cy="projet_group_summary">
          <div class="row">
            <div class="col">
              <h5 class="d-inline">PROJECT GROUPS</h5>
                  <h4 v-if="contentLoaded" class="d-inline">
                    <span class="badge bg-secondary text-light badge-pill float-right">{{
                      filteredFacilityGroups.length 
                    }}</span>
                  </h4>
              <hr />
            </div>
          </div>
          <div
            v-for="(facilityGroup, index) in filteredFacilityGroups"
            :key="index"
          >
            <div class="row mb-2">
              <div class="col-6 mb-2">
                <span :class="{ 'font-sm': isMapView }">{{
                  facilityGroup.name
                }}</span>
               
              </div>
              <div class="col-1 pl-0">              
                <span class="badge badge-secondary badge-pill">{{
                  facilityGroupFacilities(facilityGroup).length
                }}</span>
              </div>
              <div class="col-5">
                <span
                  class="w-100 mt-1 ml-2 progress pg-content"
                  :class="{
                    'font-sm': isMapView,
                    'progress-0': facilityGroupProgress(facilityGroup) <= 0,
                  }"
                >
                  <div
                    class="progress-bar bg-info"
                    :style="`width: ${facilityGroupProgress(facilityGroup)}%`"
                  >
                    {{ facilityGroupProgress(facilityGroup) }} %
                  </div>
                </span>
              </div>
            </div>
          </div>
          <div v-if="!contentLoaded" class="my-4">
            <loader type="code"></loader>
          </div>
        </el-card>
    </div>
       <div class="col-3 pl-2 pt-0"  :class="[isMapView ? 'd-none' : '']" >
                <el-card class="box-card" style="background-color:#fff">
                  <div class="row">
                    <div class="col text-center bg-secondary py-0">
                      <h6 class="d-block mb-0 text-center text-light">OVERALL PROGRESS</h6>                  
                    </div>
                  </div>

                   <!-- <h3 v-if="contentLoaded" class="d-inline">
           <el-popover
            placement="top-start"
            title="Project #"
            width="200"
            trigger="hover"
            content="This is the total number of projects in this program.">
          <b class="badge bg-secondary text-light badge-pill" slot="reference"> {{ C_facilityCount }}</b>
          </el-popover>
        </h3>   -->

                <div class="row mt-1 text-center">
                <div class="col p-0 mb-0">
                  
               <h4 class="text-center">
                        <span :class="{ 'progress-0': projectTotalProgress <= 0 }">
                          <el-progress
                            type="circle"
                            class="pt-4 pb-3"                          
                            :percentage="Math.round(projectTotalProgress)"
                          ></el-progress>
                        </span>
                      </h4>
                </div>
                </div>
           
                <div>
              </div>
          </el-card>
              </div>
      
    
    </div>

      <!-- </el-tab-pane>
  
    <el-tab-pane label="Program Breakdown">
     <div class="mb-2 float-right"> <button class="btn btn-md btn-info"> PROJECTS: {{ C_facilityCount }}</button></div>
        <div v-if="contentLoaded" class="pb-2 table-div">
          <div class="grid-container">
            <el-card class="list-group-item text-center" style="min-height: 150px" v-for="(item, index) in projectObj"  :key="index" >              
             
               <span class="p-2" > {{ item.facilityName }} </span>          
            </el-card>
          </div>         
      </div>
    </el-tab-pane>
    
    <el-tab-pane label="Analytics">  -->
<!-- KPI's and visual graphs will go here -->    
       

    <!-- </el-tab-pane>
       </el-tabs>  -->
  </div>
</template>


<script>
import Loader from "./loader";
import {jsPDF} from "jspdf"
// import { Printd } from 'printd'
import { mapGetters, mapActions, mapMutations } from "vuex";
export default {
  name: "ProjectRollup",
  props: ["from"],
  components: {
    Loader,
  },
  // el: '#printAll', 
  data() {
    return {
      uri :'data:application/vnd.ms-excel;base64,',
      template:'<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="https://www.w3.org/TR/2018/SPSD-html401-20180327/"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
      base64: function(s){ return window.btoa(unescape(encodeURIComponent(s))) },
      format: function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) },
      showLess: "Show More",
      showMore: true,  
      reportCenterModal: false, 
      dialog2Visible: false,  
      // d: new Printd(),
      showProjectedHours: true, 
      projectedHoursDisplay: false,
      userTasksDialog: false,    
      matrixDates: [],
      filteredUsers: [],
      dateOfWeekFilter: '',
      programDateOfWeekFilter: '',
      today: new Date().toISOString().slice(0, 10),
    };
  },
  computed: {
    ...mapGetters([
      "activeProjectUsers",
      "programEfforts",
      "contentLoaded",
      "currentProject",
      "lessonsLoaded",
      'currProgramTab',
      "projectLessons",
      "programLessonsCount",
      'projects',
      "facilities",
      "facilityCount",
      "facilityGroupFacilities",
      "facilityProgress",
      "filterDataForAdvancedFilter",
      "filteredAllIssues",
      "filteredAllRisks",
      "filteredAllTasks",
      "filteredFacilities",
      "filteredFacilityGroups",
      "getAllFilterNames",
      "getFilterValue",
      "getTaskIssueUserFilter",
      "getUnfilteredFacilities",
      "issueSeverityFilter",
      "issueStageFilter",
      "issueTypeFilter",
      "issueTypes",
      "issueUserFilter",
      "myActionsFilter",
      "onWatchFilter",
      "riskStageFilter",
      "statuses",
      "taskStageFilter",
      "taskTypeFilter",
      "taskTypes",
      "taskTypes",
      "taskUserFilter",
       'getHideComplete',
      'getHideInprogress',
      'getHidePlanned',
      'getHideOngoing',
      'getHideOnhold',
      'getHideDraft',
      'getHideOverdue',
      'programTaskEffort'

    ]),
    //BEGIN EFFORT / EFFORT RELATED CODE
    tableData() {
      if (this.programEfforts && this.programEfforts.length > 0){            
        let tasks = this.programEfforts.filter(t => t.facilities && t.facilities.length > 0)
        .filter((task) => {
        if (this.filteredUsers && this.filteredUsers.length > 0 ) {       
          let status = this.filteredUsers.map((t) => t.id);
          return status.includes(task.id);         
          } else return true;
        })
          return tasks                
       }      
     },
     overdueTasks(){
      const today = new Date()
      const tomorrow = new Date(today)
      let tomorr = tomorrow.setDate(tomorrow.getDate() + 1)       
      const current = new Date();      
      let plusSevenDays = current.setDate(current.getDate() + 7);

      if (this.filteredTasks.length > 0) {       
        let dueDatesTomorrow = this.filteredTasks.filter(t => new Date(t.dueDate) > new Date() && new Date(t.dueDate) < tomorr )   
        let datesWithinSevenDays = this.filteredTasks.filter(t => new Date(t.dueDate) >= today && new Date(t.dueDate) <= plusSevenDays )   
        return {
          value24: dueDatesTomorrow,   
          value7: datesWithinSevenDays,          
        }

        }
     },
     fridayDayOfWeek( ) {
        let date = new Date();
        let friday = 5; 
        let resultDate = new Date(date.getTime());
        resultDate.setDate(date.getDate() + (7 + friday - date.getDay()) % 7);
        return moment(resultDate).format("DD MMM YY");
      },
     effortUsers(){
      if(this.programEfforts && this.activeProjectUsers){
          return this.programEfforts.filter( t => t && t.facilities.length > 0)    
      }
     },
     weekOfArr(){      
          // let taskStartDates = this.facility.tasks.map(t => new Date(t.startDate))  
        if(this.facilities ){
            let taskDueDates = this.facilities.filter(t => t.tasks && t.tasks.length > 0).map(t => t.tasks).flat().map(t => new Date(t.dueDate))
        
        // let earliestTaskDate = taskStartDates.sort((date1, date2) => new Date(date1).setHours(0, 0, 0, 0) - new Date(date2).setHours(0, 0, 0, 0))[0]
        let latestTaskDate = taskDueDates.sort((date1, date2) => new Date(date1).setHours(0, 0, 0, 0) - new Date(date2).setHours(0, 0, 0, 0))[taskDueDates.length - 1]
       
        if(taskDueDates.length == 1 ){
          console.log(taskDueDates[0])   
          latestTaskDate = new Date(taskDueDates[0])
        }

        console.log( this.facilities )

        let start = new Date("01/06/2023");  

        if (latestTaskDate){
          let end = latestTaskDate.setDate(latestTaskDate.getDate() + 7);             
        //Change this datre or Change the DTG Format on backend        
        // let end = latestTaskDate.setDate(latestTaskDate.getDate() + 7);  
 
        let loop = new Date(start);
        while(loop <= end){  
          this.matrixDates.push(moment(loop).format("DD MMM YY"))        
          let newDate = loop.setDate(loop.getDate() + 7);
          loop = new Date(newDate);
         } 
        }
       }     
          
      },
    // END EFFORT /EFFORT RELATED CODE
    toggleWatched(){
    this.setHideWatched(!this.getHideWatched)    
    },
    toggleImportant(){
    this.setHideImportant(!this.getHideImportant)    
    },
    toggleBriefed(){
        this.setHideBriefed(!this.getHideBriefed)    
    },
    toggleComplete(){
    this.setHideComplete(!this.getHideComplete)    
    },
    toggleDraft(){
    this.setHideDraft(!this.getHideDraft)    
    },
    togglePlanned(){
        this.setHidePlanned(!this.getHidePlanned)    
    },
    toggleInprogress(){
    this.setHideInprogress(!this.getHideInprogress)    
    },
    toggleOngoing(){
        this.setHideOngoing(!this.getHideOngoing)    
    },
    toggleOnhold(){
        this.setHideOnhold(!this.getHideOnhold)    
    },
    toggleOverdue(){
    //  this.setAdvancedFilter({id: 'overdue', name: 'Overdue', value: "overdue", filterCategoryId: 'overDueFilter', filterCategoryName: 'Action Overdue'}) 
    this.setHideOverdue(!this.getHideOverdue)    
    },
     projectObj() {
        return this.currentProject.facilities
      },
    C_taskTypeFilter: {
      get() {
        return this.taskTypeFilter;
      },
      set(value) {
        this.setTaskTypeFilter(value);
      },
    },
    C_myTasks: {
      get() {
        return _.map(this.myActionsFilter, "value").includes("tasks");
      },
    },
    C_myIssues: {
      get() {
        return _.map(this.myActionsFilter, "value").includes("issues");
      },
    },
    C_onWatchTasks: {
      get() {
        return _.map(this.onWatchFilter, "value").includes("tasks");
      },
    },
    C_onWatchIssues: {
      get() {
        return _.map(this.onWatchFilter, "value").includes("issues");
      },
    },
    C_facilityCount() {         
      return this.facilityGroup
      
        ? this.facilityGroupFacilities(this.facilityGroup).length
        : this.facilityCount; 
      
    },
    C_facilityProgress() {
      return this.facilityGroup
        ? Number(
            _.meanBy(
              this.facilityGroupFacilities(this.facilityGroup),
              "progress"
            ) || 0
          ).toFixed(0)
        : this.facilityProgress;
    },
    isMapView() {
      return this.$route.name.includes("Map");
    },
    ProgramView() {
     return `/programs/${this.$route.params.programId}/dataviewer`
    },
    isSheetsView() {
      return this.$route.name.includes("Sheet");
    },  
    filteredTasks() {
      let typeIds = _.map(this.taskTypeFilter, "id");
      let stageIds = _.map(this.taskStageFilter, "id");
      let tasks = this.facilityGroup
        ? _.flatten(
            _.map(this.facilityGroupFacilities(this.facilityGroup), "tasks")
          )
        : this.filteredAllTasks;
      let taskIssueUsers = this.getTaskIssueUserFilter;
      return _.filter(tasks, (resource) => {
        let valid = true;
        let userIds = [
          ..._.map(resource.checklists, "userId"),
          resource.userIds,
        ];
        if (taskIssueUsers.length > 0) {
          valid =
            valid &&
            userIds.some((u) => _.map(taskIssueUsers, "id").indexOf(u) !== -1);
        }
        //TODO: For performance, send the whole tasks array instead of one by one
        valid =
          valid &&
          this.filterDataForAdvancedFilter([resource], "facilityRollupTasks");
        if (stageIds.length > 0)
          valid = valid && stageIds.includes(resource.taskStageId);
        if (typeIds.length > 0)
          valid = valid && typeIds.includes(resource.taskTypeId);
        return valid;
      });
    },
    filteredIssues() {
      let typeIds = _.map(this.issueTypeFilter, "id");
      let stageIds = _.map(this.issueStageFilter, "id");
      let severityIds = _.map(this.issueSeverityFilter, "id");
      let issues = this.facilityGroup
        ? _.flatten(
            _.map(this.facilityGroupFacilities(this.facilityGroup), "issues")
          )
        : this.filteredAllIssues;

      let taskIssueUsers = this.getTaskIssueUserFilter;
      return _.filter(issues, (resource) => {
        let valid = true;
        let userIds = [
          ..._.map(resource.checklists, "userId"),
          resource.userIds,
        ];
        if (taskIssueUsers.length > 0) {
          valid =
            valid &&
            userIds.some((u) => _.map(taskIssueUsers, "id").indexOf(u) !== -1);
        }
        //TODO: For performance, send the whole tasks array instead of one by one
        valid =
          valid &&
          this.filterDataForAdvancedFilter([resource], "facilityRollupIssues");
        if (typeIds.length > 0)
          valid = valid && typeIds.includes(resource.issueTypeId);
        if (severityIds.length > 0)
          valid = valid && severityIds.includes(resource.issueSeverityId);
        if (stageIds.length > 0)
          valid = valid && stageIds.includes(resource.issueStageId);
        return valid;
      });
    },
    issueTaskCATEGORIES() {
      let issues = new Array();
      let group = _.groupBy(this.filteredIssues, "taskTypeName");
      for (let type in group) {
        if (!type || type == "null") continue;
        issues.push({
          name: type,
          count: group[type].length,
          progress: Number((_.meanBy(group[type], "progress") || 0).toFixed(0)),
        });
      }
      return issues;
    },
    filteredRisks() {
      let typeIds = _.map(this.taskTypeFilter, "id");
      let stageIds = _.map(this.riskStageFilter, "id");
      let risks = this.facilityGroup
        ? _.flatten(
            _.map(this.facilityGroupFacilities(this.facilityGroup), "risks")
          )
        : this.filteredAllRisks;
      let taskIssueUsers = this.getTaskIssueUserFilter;
      return _.filter(risks, (resource) => {
        let valid = true;
        let userIds = [
          ..._.map(resource.checklists, "userId"),
          resource.userIds,
        ];
        if (taskIssueUsers.length > 0) {
          valid =
            valid &&
            userIds.some((u) => _.map(taskIssueUsers, "id").indexOf(u) !== -1);
        }
        //TODO: For performance, send the whole tasks array instead of one by one
        valid =
          valid &&
          this.filterDataForAdvancedFilter([resource], "facilityRollupTasks");
        if (stageIds.length > 0)
          valid = valid && stageIds.includes(resource.riskStageId);
        if (typeIds.length > 0)
          valid = valid && typeIds.includes(resource.taskTypeId);
        return valid;
      });
    },
    riskPriorityLevels() {
      let grey = _.filter(
        this.filteredRisks,
        (t) => t && t.priorityLevelName && t.priorityLevelName == "Very Low"
      );
      let green = _.filter(
        this.filteredRisks,
        (t) => t && t.priorityLevelName && t.priorityLevelName == "Low"
      );
      let yellow = _.filter(
        this.filteredRisks,
        (t) => t && t.priorityLevelName && t.priorityLevelName == "Moderate"
      );
      let orange = _.filter(
        this.filteredRisks,
        (t) => t && t.priorityLevelName && t.priorityLevelName == "High"
      );
      let red = _.filter(
        this.filteredRisks,
        (t) => t && t.priorityLevelName && t.priorityLevelName == "Extreme"
      );
      return {
        grey: grey.length,
        green: green.length,
        yellow: yellow.length,
        orange: orange.length,
        red: red.length,
      };
    },
    activeFacilitiesByStatus() {
      return this.facilityGroup
        ? this.facilityGroupFacilities(this.facilityGroup).length
        : this.filteredFacilities("active").length;
    },
    inactiveFacilitiesByStatus() {
      return this.facilityGroup
        ? this.facilityGroupFacilities(this.facilityGroup, "inactive").length
        : this.filteredFacilities("inactive").length;
    },
    projectStatuses() {
      let statuses = [];

      if (this.contentLoaded && this.facilities.length > 0) {
        this.statuses.forEach((status) => {
          // Find number of facilities with current status
          let count = this.facilities
            .filter((facility) => facility.projectStatus === status.name)
            .reduce((total) => total + 1, 0);
          // Insert status into projectStatuses for use Project Status card
          statuses.push({
            name: status.name,
            color: status.color,
            length: count,
            progress: Math.floor((count / this.facilities.length) * 100),
          });
        });
      }

      return statuses;
    },
    currentTaskTypes() {
      let names =
        this.taskTypeFilter &&
        this.taskTypeFilter.length &&
        _.map(this.taskTypeFilter, "name");
      let taskTypes = new Array();
      for (let type of this.taskTypes) {
        let tasks = _.filter(
          this.filteredTasks,
          (t) => t.taskTypeId == type.id
        );
        taskTypes.push({
          name: type.name,
          _display:
            tasks.length > 0 && (names ? names.includes(type.name) : true),
          length: tasks.length,
          progress: Number(_.meanBy(tasks, "progress").toFixed(0)),
        });
      }
      return taskTypes;
    },
    currentIssueTypes() {
      let names =
        this.issueTypeFilter &&
        this.issueTypeFilter.length &&
        _.map(this.issueTypeFilter, "name");
      let issueTypes = new Array();
      for (let type of this.issueTypes) {
        let issues = _.filter(
          this.filteredIssues,
          (t) => t.issueTypeId == type.id
        );
        issueTypes.push({
          name: type.name,
          _display:
            (names ? names.includes(type.name) : true) && issues.length > 0,
          length: issues.length,
          progress: Number(_.meanBy(issues, "progress").toFixed(0)),
        });
      }
      return issueTypes;
    },
    currentRiskTypes() {
      let names =
        this.taskTypeFilter &&
        this.taskTypeFilter.length &&
        _.map(this.taskTypeFilter, "name");
      let taskTypes = new Array();
      for (let type of this.taskTypes) {
        let risks = _.filter(
          this.filteredRisks,
          (t) => t.taskTypeId == type.id
        );
        taskTypes.push({
          name: type.name,
          _display:
            risks.length > 0 && (names ? names.includes(type.name) : true),
          length: risks.length,
          progress: Number(_.meanBy(risks, "progress").toFixed(0)),
        });
      }
      return taskTypes;
    },
    viableTasksForProgressTotal(){
      return this.filteredTasks.filter(t => t.draft == false && t.onHold == false  && t.ongoing == false )
    },
     viableIssuesForProgressTotal(){
      return this.filteredIssues.filter(issue => issue.draft == false && issue.onHold == false)
    },
     viableRisksForProgressTotal(){
      return this.filteredRisks.filter(r => r.draft == false && r.onHold == false  && r.ongoing == false )
    },
   allTasksProgress() {
      let task = new Array();
      let group = _.groupBy(this.viableTasksForProgressTotal, "id");
      for (let ids in group) {
        task.push({
          id: ids,  
          // text: text,      
          progress: Number((_.meanBy(group[ids], "progress") || 0).toFixed(0)),
        });
      }
      let total = task.map(t => t.progress);
      let count = task.map(t => t).length;

      let sum = total.reduce(( accumulator, currentValue ) => accumulator + currentValue, 0)

     let roundedSum = Math.round(sum)
     let final = roundedSum / count

     if (isNaN(final)){
       final = 0;
     }
    //  let allCounts = this.allRisksProgress.count + this.allIssuesProgress.count + count
    //  let weightedVal = count / allCounts
     let weighted = count * final 
    
       if (isNaN(final)) {
        return 0
       } else return {
          final, 
          count, 
          weighted, 
          roundedSum  
      }
    },
    allRisksProgress() {
      let risk = new Array();
      let group = _.groupBy(this.viableRisksForProgressTotal, "id");
      for (let ids in group) {
        risk.push({
          id: ids,  
          // text: text,      
          progress: Number((_.meanBy(group[ids], "progress") || 0).toFixed(0)),
        });
      }
      let total = risk.map(r => r.progress);
      let count = risk.map(r => r).length;

      let sum = total.reduce(( accumulator, currentValue ) => accumulator + currentValue, 0)
      let roundedSum = Math.round(sum)

       let final = roundedSum / count

       
     if (isNaN(final)){
       final = 0;
     }
          let weighted = count * final
    
        if (isNaN(final)) {
        return 0
       } else return {
          final, 
          count, 
          weighted    
      }
    },
    allIssuesProgress() {
      let issue = new Array();
      let group = _.groupBy(this.viableIssuesForProgressTotal, "id");
      for (let ids in group) {
        issue.push({
          id: ids,  
          // text: text,      
          progress: Number((_.meanBy(group[ids], "progress") || 0).toFixed(0)),
        });
      }
      let total = issue.map(iss => iss.progress);
      let count = issue.map(iss => iss).length;
      
      let sum = total.reduce(( accumulator, currentValue ) => accumulator + currentValue, 0)     

      let roundedSum = Math.round(sum)
      let final = roundedSum / count
      
     if (isNaN(final)){
       final = 0;
     }
      let weighted = count * final

       if (isNaN(final)) {
        return 0
       } else return {
          final, 
          count, 
          weighted    
      }
    },
    projectTotalProgress(){
     let sum = this.allTasksProgress.weighted + this.allRisksProgress.weighted + this.allIssuesProgress.weighted
      let denominator = this.allTasksProgress.count + this.allRisksProgress.count + this.allIssuesProgress.count
        if (isNaN(sum || denominator )) {
          sum = 0;
          denominator = 0;
        }
 
      let total = sum / denominator
      if (isNaN(total)) {
        return 0
      } else return Math.round(total)
    },  


    // Find sum of all valid Tasks, Issues, and Risks (75)
    taskVariation() {
      let planned = _.filter(
        this.filteredTasks,
        (t) => t && t.planned == true
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let taskDrafts = _.filter(
        this.filteredTasks,
        (t) => t && t.draft == true
      );      
      let completed = _.filter(
        this.filteredTasks,
        (t) => t && t.completed == true
      );
      let completed_percent = this.getAverage(
        completed.length,
        this.filteredTasks.length
      );
      let inProgress = _.filter(
        this.filteredTasks,
        (t) => t && t.inProgress == true
      );
     let onHoldT = _.filter(
        this.filteredTasks,
        (t) => t && t.onHold == true
      );
      let inProgress_percent = this.getAverage(
        inProgress.length,
        this.filteredTasks.length
      );
      let overdue = _.filter(this.filteredTasks, (t) => t && t.isOverdue);
      let overdue_percent = this.getAverage(
        overdue.length,
        this.filteredTasks.length
      );
      let ongoing = _.filter(this.filteredTasks, (t) => t && t.ongoing );
      let ongoingClosed = _.filter(this.filteredTasks, (t) => t && t.closed );
      return {
        planned: {
          count: planned.length, 
          plannedTs: planned            
        },
        onHoldT: {
          count: onHoldT.length,          
        },
        taskDrafts: {
          count: taskDrafts.length,          
        },
        completed: {
          count: completed.length,
          percentage: Math.round(completed_percent),
        },
      
        inProgress: {
          count: inProgress.length,
          percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          percentage: Math.round(overdue_percent),
        },
        ongoingClosed: {
          count: ongoingClosed.length      
        },
        ongoing,       
    
      };
    },
   issueVariation() {
     let planned = _.filter(
        this.filteredIssues,
        (t) => t && t.planned == true    
      );     
      let issueDrafts = _.filter(
        this.filteredIssues,
         (t) => t && t.draft == true 
      );      
      let completed = _.filter(
        this.filteredIssues,
        (t) => t && t.completed == true
      );
      let completed_percent = this.getAverage(
        completed.length,
        this.filteredIssues.length
      ); 
       let inProgress = _.filter(
        this.filteredIssues,
        (t) => t && t.inProgress == true 
        );
      let onHoldI = _.filter(
        this.filteredIssues,
        (t) => t && t.onHold == true 
      );
      let inProgress_percent = this.getAverage(
        inProgress.length,
        this.filteredIssues.length
      );
      let overdue = _.filter(this.filteredIssues, (t) => t && t.isOverdue);
      let overdue_percent = this.getAverage(
        overdue.length,
        this.filteredIssues.length
      );
      return {
        planned: {
          count: planned.length,          
        },
        onHoldI: {
          count: onHoldI.length,          
        },
        issueDrafts: {
          count: issueDrafts.length,          
        },
        completed: {
          count: completed.length,
          percentage: Math.round(completed_percent),
        },
        inProgress: {
          count: inProgress.length,
          percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          percentage: Math.round(overdue_percent),
        },
      };
    },
    riskVariation() {
     let planned = _.filter(
        this.filteredRisks,
        (t) => t && t.planned == true     
      );  
      let riskDrafts = _.filter(
        this.filteredRisks,
        (t) => t && t.draft == true 
      ); 
      let completed = _.filter(
        this.filteredRisks,
        (t) => t && t.completed == true
      );
      let inProgress = _.filter(
        this.filteredRisks,
        (t) => t && t.inProgress == true
      );
      let onHoldR = _.filter(
        this.filteredRisks,
        (t) => t && t.onHold == true 
      );  
 
      let completed_percent = this.getAverage(
        completed.length,
        this.filteredRisks.length
      );
      let inProgress_percent = this.getAverage(
        inProgress.length,
        this.filteredRisks.length
      );
      let overdue = _.filter(this.filteredRisks, (t) => t && t.isOverdue);
      let overdue_percent = this.getAverage(
        overdue.length,
        this.filteredRisks.length
      );
      let ongoing = _.filter(this.filteredRisks, (t) => t && t.ongoing);
      let ongoingClosed = _.filter(this.filteredRisks, (t) => t && t.closed);
      return {
        planned: {
          count: planned.length,          
        },
        onHoldR: {
          count: onHoldR.length,          
        },
        riskDrafts: {
          count: riskDrafts.length,          
        },
        completed: {
          count: completed.length,
          percentage: Math.round(completed_percent),
        },
        inProgress: {
          count: inProgress.length,
          percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          percentage: Math.round(overdue_percent),
        },
        ongoingClosed: {
          count: ongoingClosed.length,        
        },
        ongoing
      };
    },
  },
  methods: {
      ...mapActions([
        'fetchProgramLessonCounts',
        'fetchProgramEfforts',
        'fetchDateOfWeekQuery',
        "fetchProgramEffortReport"
     ]), 
     ...mapMutations([
        'setHideComplete',
        'setCurrProgramTab',
        'setHideInprogress',
        'setHidePlanned',
        'setHideOverdue',
        'setHideOngoing',
        'setHideOnhold',
        'setHideDraft',
      ]),
    openProjectGroup() {
    this.dialog2Visible = true;
    this.programDateOfWeekFilter = this.fridayDayOfWeek
    this.fetchProgramEffortReport({programId: this.$route.params.programId,  date: this.fridayDayOfWeek })
    },
    // printAllUsers () {
    //   this.d.print( this.$el, [this.cssText])
    // },
    openUserTasksReport() {
      // this.userTasksDialog = true;
      this.dateOfWeekFilter = this.fridayDayOfWeek
      this.reportCenterModal = true
      this.fetchProgramEfforts({programId: this.$route.params.programId,  date: this.fridayDayOfWeek })
    },
    showLessToggle() {
      this.showLess = "Show Less";
    },
    exportToExcel(table, name){
        if (!table.nodeType) table = this.$refs.table
        var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML}
        var link = document.createElement('a');
        link.setAttribute('href', this.uri + this.base64(this.format(this.template, ctx)));
        link.setAttribute('download', 'Team_Members_list.xls');
        link.click();
      },
    printTaskReport(index, week, username, title, weekFilter, showProjEffort) {
      //jsPDF image documentation:  https://raw.githack.com/MrRio/jsPDF/master/docs/module-addImage.html#~addImage
      const doc = new jsPDF({orientation: "l"})
      const html =  this.$refs.table.innerHTML   
     
      const logo = require('../../../assets/images/microhealthllc.png')
      var imgLogo = new Image()
      imgLogo.src = logo    

      doc.autoTable({
        html:  `#taskSheetsList1${index}`,
        margin: { top: 30, left: 5, right: 5, bottom: 15 },
        theme: 'grid',
        columnStyles: {
          0: {cellWidth: 40},
          1: {cellWidth: 45},
          2: {cellWidth: 69},
          3: {cellWidth: 50, halign: 'center'},
          4: {cellWidth: 50, halign: 'center'},
          5: {cellWidth: 32.5, halign: 'center'}     
          },        
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
      //didDrawPage function is for standard content you want on all pages (eg, header, footer)
        didDrawPage: function (data) {
          
        // Header        
        var str = "Page " + doc.internal.getNumberOfPages();
        doc.setFontSize(10);
        doc.setTextColor(33,33,33);
        doc.setFont("undefined", "undefined").text(str, 280, 10);    
        doc.setFont("undefined","bold").text(120, 11, `USER TASK EFFORT REPORT`)
        doc.setFont("undefined", "undefined").text(5, 10, `Week of:  ${week}`); 
        doc.text(5, 15, `Date of Report:  ${moment().format("DD MMM YY")} `); 
        doc.text(5, 20, `Name of Staff:  ${username} `); 
        doc.text(5, 25, `Position:  ${title} `); 
        console.log("TEST TEST")
        if(weekFilter == 'ALL WEEKS' && showProjEffort){
          doc.text(5, 205, `( ) Values in parenthesis represent Projected Effort`); 
        }  
        // Footer
        doc.addImage(imgLogo, 'PNG', 129, 195, 35, 10)
        },
        didParseCell: function(hookData) {
          if (hookData.section == "head") {
            hookData.cell.styles.fillColor = [237, 237, 237];
            hookData.cell.styles.textColor = "#383838";
          }     
          if (hookData.table.body) {
              hookData.cell.styles.overflow = 'ellipsize';
          }  
          if (hookData.section == 'row') {
            hookData.cell.styles.rowHeight = 3;  
          }               
        },
        });        
      doc.setLineHeightFactor(3)
      doc.save("User_Task_Effort_Totals.pdf")
    },
    printAllReports(week, users, showProjEffort) {
      //jsPDF image documentation:  https://raw.githack.com/MrRio/jsPDF/master/docs/module-addImage.html#~addImage
     for (let i = 0; i < users.length; i++) {
      let eachUser = users[i]
      const doc = new jsPDF({orientation: "l"})     
      const html =  this.$refs.table.innerHTML  
      console.log("each User: " , eachUser)
      const logo = require('../../../assets/images/microhealthllc.png')
      var imgLogo = new Image()
      imgLogo.src = logo    
      doc.autoTable({
        html:  `#taskSheetsList1${i}`,
        margin: { top: 30, left: 5, right: 5, bottom: 15 },
        theme: 'grid',
          columnStyles: {
            0: {cellWidth: 40},
            1: {cellWidth: 45},
            2: {cellWidth: 69},
            3: {cellWidth: 50, halign: 'center'},
            4: {cellWidth: 50, halign: 'center'},
            5: {cellWidth: 32.5, halign: 'center'}     
          },        
    
       didDrawPage: function (data) {
              
            // Header        
            var str = "Page " + doc.internal.getNumberOfPages();
            doc.setFontSize(10);
            doc.setTextColor(33,33,33);
            doc.setFont("undefined", "undefined").text(str, 280, 10);    

            doc.setFont("undefined","bold").text(120, 11, `USER TASK EFFORT REPORT`)

            doc.setFont("undefined", "undefined").text(5, 10, `Week of:  ${week}`); 
            doc.text(5, 15, `Date of Report:  ${moment().format("DD MMM YY")} `); 
            doc.text(5, 20, `Name of Staff:  ${eachUser.full_name} `); 
            doc.text(5, 25, `Position:  ${eachUser.title} `); 
            console.log("TEST TEST")
            if( week == 'ALL WEEKS' && showProjEffort){
              doc.text(5, 205, `( ) Values in parenthesis represent Projected Effort`); 
            }  
            // Footer
            doc.addImage(imgLogo, 'PNG', 129, 195, 35, 10)

        },
        didParseCell: function(hookData) {
          if (hookData.section == "head") {
            hookData.cell.styles.fillColor = [237, 237, 237];
            hookData.cell.styles.textColor = "#383838";
          }     
          if (hookData.table.body) {
              hookData.cell.styles.overflow = 'ellipsize';
          }  
          if (hookData.section == 'row') {
            hookData.cell.styles.rowHeight = 3;  
          }               
         },
        });     

        doc.save(`${eachUser.full_name}_Effort_Report.pdf`)
        doc.setLineHeightFactor(3) 

      }                
        
    },
    printProgramEffortReport(programName, week) {
      const doc = new jsPDF("l")
      const html =  this.$refs.table1.innerHTML    
      const logo = require('../../../assets/images/microhealthllc.png')
      var imgLogo = new Image()
      imgLogo.src = logo
      //jsPDF image documentation:  https://raw.githack.com/MrRio/jsPDF/master/docs/module-addImage.html#~addImage

      doc.autoTable({
        html:  `#taskSheetsList1`,
        margin: { top: 30, left: 5, right: 5, bottom: 15 },
        theme: 'grid',
        columnStyles: {
          2: { halign: 'center'},
          3: { halign: 'center'},
          4: { halign: 'center'},
          5: { halign: 'center'},
      },
      didDrawPage: function (data) {
        // Header        
        var str = "Page " + doc.internal.getNumberOfPages();
        doc.setFontSize(10);
        doc.setTextColor(33,33,33);
        doc.setFont("undefined", "undefined").text(str, 280, 10);
        doc.setFont("undefined","bold").text(120, 10, `${programName}'s Task Effort Report`)   
        doc.setFont("undefined", "undefined").text(5, 10, `Week of:  ${ week } `)
        doc.setFont("undefined", "undefined").text(5, 15, `Date of Report:  ${moment().format("DD MMM YY")} `)
        // Footer
        doc.addImage(imgLogo, 'PNG', 129, 195, 35, 10)

      },
      didParseCell: function(hookData) {
        if (hookData.section == "head") {
          hookData.cell.styles.fillColor = [237, 237, 237];
          hookData.cell.styles.textColor = "#383838";
        }     
        if (hookData.table.body) {
          hookData.cell.styles.overflow = 'ellipsize';
        }               
      },
      });

    doc.save("Program_Task_Effort_Report.pdf")
    },
    log(e){
      console.log(e)
    },
    handleClick(tab, event) {
        // console.log(tab, event);
    },
    completedOnly(e){
      let action = e.currentTarget.id;
      if (action == "taskFlags"){
        this.setCurrProgramTab('#tab-tasks')
      } else if (action == "issueFlags"){
        this.setCurrProgramTab('#tab-issues')
      } else if (action == "riskFlags"){
        this.setCurrProgramTab('#tab-risks')
      } else if (action == "lessonFlags"){
        this.setCurrProgramTab('#tab-lessons')
      } 
      // this.setHideComplete(!this.getHideComplete)    
      this.setHideDraft(!this.getHideDraft)    
      this.setHidePlanned(!this.getHidePlanned)    
      this.setHideInprogress(!this.getHideInprogress)    
      this.setHideOngoing(!this.getHideOngoing)    
      this.setHideOnhold(!this.getHideOnhold) 
      this.setHideOverdue(!this.getHideOverdue) 
      this.$router.push(
         `/programs/${this.$route.params.programId}/dataviewer`
      );
    },
    draftsOnly(e){
      let action = e.currentTarget.id;
      if (action == "taskFlags"){
        this.setCurrProgramTab('#tab-tasks')
      } else if (action == "issueFlags"){
        this.setCurrProgramTab('#tab-issues')
      } else if (action == "riskFlags"){
        this.setCurrProgramTab('#tab-risks')
      } else if (action == "lessonFlags"){
        this.setCurrProgramTab('#tab-lessons')
      } 
      this.setHideComplete(!this.getHideComplete)    
      // this.setHideDraft(!this.getHideDraft)    
      this.setHidePlanned(!this.getHidePlanned)    
      this.setHideInprogress(!this.getHideInprogress)    
      this.setHideOngoing(!this.getHideOngoing)    
      this.setHideOnhold(!this.getHideOnhold) 
      this.setHideOverdue(!this.getHideOverdue) 
      this.$router.push(
         `/programs/${this.$route.params.programId}/dataviewer`
      );
    },
    plannedOnly(e){
      let action = e.currentTarget.id;  
      if (action == "taskFlags"){
        this.setCurrProgramTab('#tab-tasks')
      } else if (action == "issueFlags"){
        this.setCurrProgramTab('#tab-issues')
      } else if (action == "riskFlags"){
        this.setCurrProgramTab('#tab-risks')
      }
      this.setHideComplete(!this.getHideComplete)    
      this.setHideDraft(!this.getHideDraft)    
      // this.setHidePlanned(!this.getHidePlanned)    
      this.setHideInprogress(!this.getHideInprogress)    
      this.setHideOngoing(!this.getHideOngoing)    
      this.setHideOnhold(!this.getHideOnhold) 
      this.setHideOverdue(!this.getHideOverdue) 
      this.$router.push(
         `/programs/${this.$route.params.programId}/dataviewer`
      );
    },
    inprogressOnly(e){
      let action = e.currentTarget.id;  
      if (action == "taskFlags"){
        this.setCurrProgramTab('#tab-tasks')
      } else if (action == "issueFlags"){
        this.setCurrProgramTab('#tab-issues')
      } else if (action == "riskFlags"){
        this.setCurrProgramTab('#tab-risks')
      } 
      this.setHideComplete(!this.getHideComplete)    
      this.setHideDraft(!this.getHideDraft)    
      this.setHidePlanned(!this.getHidePlanned)    
      // this.setHideInprogress(!this.getHideInprogress)    
      this.setHideOngoing(!this.getHideOngoing)    
      this.setHideOnhold(!this.getHideOnhold) 
      this.setHideOverdue(!this.getHideOverdue) 
      this.$router.push(
         `/programs/${this.$route.params.programId}/dataviewer`
      );
    },
    ongoingOnly(e){
      let action = e.currentTarget.id;  
      if (action == "taskFlags"){
        this.setCurrProgramTab('#tab-tasks')
      } else if (action == "riskFlags"){
        this.setCurrProgramTab('#tab-risks')
      } 
      this.setHideComplete(!this.getHideComplete)    
      this.setHideDraft(!this.getHideDraft)    
      this.setHidePlanned(!this.getHidePlanned)    
      this.setHideInprogress(!this.getHideInprogress)    
      // this.setHideOngoing(!this.getHideOngoing)    
      this.setHideOnhold(!this.getHideOnhold) 
      this.setHideOverdue(!this.getHideOverdue) 
      this.$router.push(
         `/programs/${this.$route.params.programId}/dataviewer`
      );
    },
    onholdOnly(e){
     let action = e.currentTarget.id;  
      if (action == "taskFlags"){
        this.setCurrProgramTab('#tab-tasks')
      } else if (action == "issueFlags"){
        this.setCurrProgramTab('#tab-issues')
      } else if (action == "riskFlags"){
        this.setCurrProgramTab('#tab-risks')
      } 
      this.setHideComplete(!this.getHideComplete)    
      this.setHideDraft(!this.getHideDraft)    
      this.setHidePlanned(!this.getHidePlanned)    
      this.setHideInprogress(!this.getHideInprogress)    
      this.setHideOngoing(!this.getHideOngoing)    
      // this.setHideOnhold(!this.getHideOnhold) 
      this.setHideOverdue(!this.getHideOverdue) 
      this.$router.push(
         `/programs/${this.$route.params.programId}/dataviewer`
      );
    },
    overdueOnly(e){   
      let action = e.currentTarget.id;  
      if (action == "taskFlags"){
        this.setCurrProgramTab('#tab-tasks')
      } else if (action == "issueFlags"){
        this.setCurrProgramTab('#tab-issues')
      } else if (action == "riskFlags"){
        this.setCurrProgramTab('#tab-risks')
      } 
      this.setHideComplete(!this.getHideComplete)    
      this.setHideDraft(!this.getHideDraft)    
      this.setHidePlanned(!this.getHidePlanned)    
      this.setHideInprogress(!this.getHideInprogress)    
      this.setHideOngoing(!this.getHideOngoing)    
      this.setHideOnhold(!this.getHideOnhold) 
      // this.setHideOverdue(!this.getHideOverdue) 
      this.$router.push(
         `/programs/${this.$route.params.programId}/dataviewer`
      );
    },
     facilityGroupProgress(f_group) {
      let ids = _.map(this.filteredFacilities("active"), "id");
      let mean =
        _.meanBy(
          _.filter(
            f_group.facilities,
            (f) =>
              ids.includes(f.facilityId) &&
              f.projectId == this.currentProject.id
          ),
          "progress"
        ) || 0;
      return Number(mean.toFixed(0));
    },
    // programView() {
    //   window.location.pathname = `/programs/${this.$route.params.programId}/dataviewer`
  
    // },
  },
  mounted() {
    this.fetchProgramLessonCounts(this.$route.params) 
 
      // const { contentWindow } = this.d.getIFrame()

      // contentWindow.addEventListener(
      //   'beforeprint', () => console.log('before print event!')
      // )
      // contentWindow.addEventListener(
      //   'afterprint', () => console.log('after print event!')
      // )
     
  },
  watch: {   
      dateOfWeekFilter(){
        if(this.dateOfWeekFilter !== ""){        
          let dateObj = {
            programId: this.$route.params.programId,
            date: this.dateOfWeekFilter.replace(/\s+/g, '-')
          }
          this.fetchProgramEfforts(dateObj)
        } else  {
          this.fetchProgramEfforts({programId: this.$route.params.programId})
          this.dateOfWeekFilter = "ALL WEEKS"
        }
      }, 
      programDateOfWeekFilter(){
        if(this.programDateOfWeekFilter !== ""){        
          let dateObj = {
            programId: this.$route.params.programId,
            date: this.programDateOfWeekFilter.replace(/\s+/g, '-')
          }
          this.fetchProgramEffortReport(dateObj)
        } else  {
          this.projectedHoursDisplay = true
          console.log(this.projectedHoursDisplay)
          this.fetchProgramEffortReport({programId: this.$route.params.programId})
          this.programDateOfWeekFilter = "ALL WEEKS"        
      
        }
      }, 
    }
};
</script>

<style scoped lang="scss">
.overdueWarningCard {
  border-radius: 2px;
  padding: 4px;
  z-index:1;
  width: 400px;
  position: absolute;
  bottom: 5rem;
  right: 5rem;
  box-shadow: 0 2.5px 5px rgba(236, 7, 7, 0.19),
    0 3px 3px rgba(223, 11, 11, 0.23);
  // border: solid red 1px;
}

.badge-color {
  height: 12px;
  padding-top: 2px;
}
.box-card {
  min-height: 150px;
}
.proj-type {
  display: inline;
  border-radius: 2px;
  padding: 4px;
  color: #fff;
  font-size: small;
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.fac-proj-status,
.tasks,
.issues,
.fac-groups {
  border-radius: 2px;
  background-color: #fff;
  box-shadow: 0 5px 5px rgba(0, 0, 0, 0.19), 0 3px 3px rgba(0, 0, 0, 0.23);
}
table {
  ul > li {
  display: inline-block !important;
  /* You can also add some margins here to make it look prettier */
  zoom: 1;
  *display: inline;
  /* this fix is needed for IE7- */
}
td  {
  font-size: 1rem;
}
}
// ul > li {
//   display: inline-block !important;
//   /* You can also add some margins here to make it look prettier */
//   zoom: 1;
//   *display: inline;
//   /* this fix is needed for IE7- */
// }
.grey {
  background-color: lightgray;
}
.grey2 {
  background-color: #ededed;
}
i.grow {
    cursor: pointer;
    transition: all .2s ease-in
}
i.grow:hover{
   transform: scale(1.5); 
}
.yellow {
  background-color: yellow;
}
.orange {
  background-color: #f0ad4e;
}
.green, .filterGreen {
  background-color: rgb(92, 184, 92);
}
.red {
  background-color: #d9534f;
}
.red,
.orange,
.green,
.grey {
  color: white;
  border-radius: 3px;
}
.red,
.orange,
.green,
.grey,
.grey2,
.yellow {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.grey2 {
  border-radius: 3px;
}

.underline {
  text-decoration: underline;
}
.ongoing-bg {
  background-color: #e9ecef;
  border-radius: 0.25rem;
  font-size: 0.75rem;
  height: 20px;
}

// td {
//   li.updates {
//     overflow: hidden;
//     text-overflow: ellipsis !important;
//     white-space: nowrap;
//     max-width: 26%;
//     display: block;
//   }
// }


 td.updates {
 max-width: 0;
 overflow: hidden;
 text-overflow: ellipsis !important;
 white-space: nowrap;
  // display: -webkit-box;
  // -webkit-line-clamp: 1;
  // -webkit-box-orient: vertical;  
  // overflow: hidden;
  // &:hover
  // {
  //   display: -webkit-box;
  //   -webkit-line-clamp: unset;
  // }
}


.centerLogo{
  display:block;
  margin-left: auto;
  margin-right: auto;
  text-align: center;
}
.smallerFont {
  font-size: 10px;
}
.sm {
  font-size: 9px;
}
.btn-info {
  box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
}

/deep/.el-collapse-item__header, /deep/.el-collapse-item__wrap  {
  border-bottom: none !important;
}

/deep/.el-dialog, /deep/.el-dialog--center  {
    width: 90% ;
}
/deep/.el-card__body {
    padding-bottom: 0 !important;
}
/deep/.el-collapse-item__header {
  font-size: 2rem;
  }

/deep/.el-collapse-item__arrow, /deep/.el-icon-arrow-right {
  display: none;
}
.programName {
  font-variant: small-caps;
}
.giantNumber {
  font-size: 3.7rem;
}
.giantMapView {
  font-size: 3.25rem; 
}
.card-title {
  text-decoration-line: underline;
}
em.text-dark{
  font-weight: 700;
}
.bold{
  font-weight: 700;
}
/deep/.el-progress-circle {
  height: 118px !important;
  width: 118px !important;
}
.hide {
  visibility: hidden;
}
.relative {
  position: relative;
}
.absolute {
  position: absolute;
  top:7%;
  left:0;
}
.progressLabel {
  position: absolute;
}
.pill {
  position: absolute;
  top: 10%;
  right: 1%;
}

.taskUserInfo {
  border-radius: 2px;  
  margin-bottom: 15px;
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}

.filterDiv {
  position: absolute;
  top: -8%;
  right: 9.5%;
  width: 40%;
  border-radius: 4px; 
  border: .5px solid lightgray;
  overflow-y: auto;

}
.filterLabel {
  position: fixed;
}

.filterCol {
  height: 70px;
}

.lessonsCard {
.sheetHeight {
  /deep/.el-card__body{
    min-height: 184px;
  }
 }
}

.lessonsCard {
.mapHeight {
  /deep/.el-card__body{
    min-height: 175px;
  }
 }
}
</style>
