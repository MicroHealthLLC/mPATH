<template>
<div class="container-fluid mt-3 mx-3">
  <!-- Actual Portfolio name will be dynamic value of organization name   -->
<div>
<span> <img class="mb-2" style="width:40px" :src="require('../../../../assets/images/mpathcircles.JPG')" /> 
<h3 class="d-inline mt-1 programName" >{{this.$portfolio_heading}}</h3>
</span>
   <span class="float-right mr-4">
    <button style="cursor:pointer" @click.prevent="closeWindow">
      <i class="far fa-times-circle"></i>
    </button> 
   </span>
  </div>
  <el-tabs class="mt-1 mr-3 " type="border-card">
  <el-tab-pane label="PORTFOLIO VIEWER" class="p-3">
     <el-tabs class="mt-1" type="border-card">
       <!-- TASKS -->
     <el-tab-pane class="px-3 pt-0" >
         <template slot="label" class="text-right" v-if="tasksObj && tasksObj !== undefined">
           TASKS
           <span class="badge badge-secondary badge-pill">
              <span>{{ portfolioTasks.length }}</span>
                <!-- <span v-if="getPortfolioWatchedTasksToggle">{{ tasksObj.length }}</span>
                <span v-if="!getPortfolioWatchedTasksToggle"> {{filterOutWatched.length }}</span> -->
          </span>   
          </template>
             <div class="row pt-2">              
             <div class="col-3 text-center py-0">
               <div>
                 <label class="font-sm pb-1 mb-0">FILTER BY PROGRAM</label>
                 <template>
                <el-select     
                    v-model="C_programNameFilter"                               
                    class="w-100" 
                    track-by="name" 
                    value-key="id"
                    multiple                                                                                                                                                                   
                    placeholder="Filter By Program"
                  >
                  <el-option                   
                    v-for="item in C_programNames"                                                               
                    :value="item"   
                    class="text-truncate"
                    :key="item.id"
                    :label="item.name"                                                                      
                    >
                  </el-option>
                  </el-select> 
                      </template>
               </div>
              </div>           
              
                <div class="col-6 text-center pt-2">
                <label class="font-sm mb-0 pb-1 d-block">DISPLAY TASKS BY STATE</label>
                <div class="pb-0 pl-2 pr-4 mb-0 d-inline-flex">                       
                  <div class="pr-5 text-center icons" :class="[hideCompleteTasks == true ? 'light':'']" @click.prevent="toggleComplete">             
                   <span class="d-block">
                    <i class="fas fa-clipboard-check" :class="[hideCompleteTasks == true ? 'light':'text-success']"></i>
                    </span>      
                  <span class="smallerFont">COMPLETE</span>
                   <h5 class="d-block">{{ taskVariation.completed.count }}</h5>  
                  </div>

                  <div class="pr-5 text-center icons" :class="[hideInprogressTasks == true ? 'light':'']" @click.prevent="toggleInprogress">
                    <span class="d-block">
                    <i class="far fa-tasks" :class="[hideInprogressTasks == true ? 'light':'text-primary']"></i>
                    </span>                          
                     <span class="smallerFont">IN PROGRESS</span> 
                     <h5 class="d-block">{{ taskVariation.inProgress.count }}</h5>  
                  </div>
                
                
                 <div class="pr-5 text-center icons" :class="[hideOverdueTasks == true ? 'light':'']" @click.prevent="toggleOverdue">
                    <span class="d-block">
                    <i class="fas fa-calendar" :class="[hideOverdueTasks == true ? 'light':'text-danger']"></i>
                    </span>                  
                    <span class="smallerFont">OVERDUE </span> 
                    <h5 class="d-block"> {{ taskVariation.overdue.count }}  </h5>    
                  </div>

                <div class="pr-5 text-center icons" :class="[hideOngoingTasks == true ? 'light':'']" @click.prevent="toggleOngoing">
                  <span class="d-block">
                  <i class="fas fa-retweet" :class="[hideOngoingTasks == true ? 'light':'text-success']"></i>
                  </span> 
                    <span class="smallerFont">ONGOING </span>    
                    <h5 class="d-block"> <span v-if="tasksObj">{{ taskVariation.ongoing.count }}</span></h5>  
                 </div> 


                <div class="pr-5 text-center icons" :class="[hidePlannedTasks == true ? 'light':'']" @click.prevent="togglePlanned"> 
                  <span class="d-block">
                  <i class="fas fa-calendar-check" :class="[hidePlannedTasks == true ? 'light':'text-info']"></i>
                  </span>                     
                  <span class="smallerFont">PLANNED</span>
                    <h5 class="d-block"> <span v-if="tasksObj">{{ taskVariation.planned.count }}</span></h5>  
                </div>
             
                <div class="pr-5 text-center icons" :class="[hideOnholdTasks == true ? 'light':'']"  @click.prevent="toggleOnhold">
                     <span class="d-block">
                      <i class="fas fa-pause-circle" :class="[hideOnholdTasks == true ? 'light':'text-primary']"></i>
                     </span> 
                     <span class="smallerFont">ON HOLD</span> 
                       <h5 class="d-block">{{ taskVariation.onHoldT.count }}</h5>            
                </div>
                 
                 
                 <div class="text-center icons" :class="[hideDraftTasks == true ? 'light':'']"  @click.prevent="toggleDraft" >
                  <span class="d-block">
                      <i class="fas fa-pencil-alt" :class="[hideDraftTasks == true ? 'light':'text-warning']"></i>
                  </span>     
                  <span class="smallerFont">DRAFTS</span>   
                        <h5 class="d-block">{{  taskVariation.taskDrafts.count }}</h5>              
                </div> 
               
               
                </div>
              </div>
                 <div class="col-3 tagsCol text-center pt-2 pl-0">
                <label class="font-sm mb-0 pb-1 d-block">FOCUS DISPLAYED TASKS BY TAG</label>
                 <div class="pb-0 pl-2 mb-0 d-inline-flex">    
                  <div class="text-center icons" :class="[hideWatchedTasks == true ? '':'light']" @click.prevent="toggleWatched"   >             
                 <span class="d-block">
                      <i class="fas fa-eye " ></i>
                 </span>                  
                  <span class="smallerFont">ON WATCH</span>
                   <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="watched" v-model="C_hideWatchedTasks">               -->
                   <h5 class="d-block">{{ taskVariation.watched.count }}</h5>  
                  </div>
                  <div class="px-5 text-center icons" :class="[hideImportantTasks == true ? '':'light']" @click.prevent="toggleImportant"     >
                  <span class="d-block">
                      <i class="fas fa-star" :class="[hideImportantTasks == true ? 'text-warning':'light']"></i>
                  </span>     
                      <span class="smallerFont">IMPORTANT</span> 
                       <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="important" v-model="C_hideImportantTasks">     -->
                     <h5 class="d-block">{{ taskVariation.important.count }}</h5>  
                  </div>
                   <div class="text-center icons"  :class="[hideBriefedTasks == true ? '':'light']" @click.prevent="toggleBriefing"         >
                      <span class="d-block">
                     <i class="fas fa-presentation" :class="[hideBriefedTasks == true ? 'text-primary':'light']"></i>
                  </span>     
                    <span class="smallerFont">BRIEFINGS </span> 
                      <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="briefed" v-model="C_hideBriefedTasks">   -->
                    <h5 class="d-block"> {{ taskVariation.briefings.count }}  </h5>    
                  </div>
               </div>
             </div>
              </div>

      <div class="row text-center mt-2" v-if="tasksObj !== null && tasksObj.length > 0 ">            
          <span class="ml-auto mt-3 btnRow"> <button
          v-tooltip="`Export to PDF`"
          @click.prevent="exportTasksToPdf"
          class="btn btn-md mr-1 exportBtns text-light">
          <i class="far fa-file-pdf"></i>
        </button>
        <button
          v-tooltip="`Export to Excel`"
          @click.prevent="exportTasksToExcel('table', 'Portfolio Tasks')"
          class="btn btn-md mr-3 exportBtns text-light">
        <i class="far fa-file-excel"></i>
        </button><button class="btn text-light btn-md mh-orange profile-btns">RESULTS: {{ tasksObj.length}}</button></span>   
                
      
        <div class="xTable" style="overflow-x:auto;margin-top:-30px">
          <table class="table table-sm mt-5 stickyTableHeader table-bordered" ref="table" id="portTasks">        
          
              <thead style="background-color:#ededed;">
              <th class="sort-th twenty" @click="sort('program_name')" >Program Name
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'program_name'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'program_name'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'program_name'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'program_name'">
                 <i class="fas fa-sort-down"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'program_name'">
                 <i class="fas fa-sort-down"></i></span>
              </th>
              <th class="sort-th twenty" @click="sort('project_name')">Project Name
                <span class="inactive-sort-icon scroll" v-if="currentSort !== ''">
                 <i class="fas fa-sort"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'project_name'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'project_name'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'project_name'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'project_name'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
              <th class="pl-1 sort-th twenty" @click="sort('text')">Task
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'text'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'text'">
                 <i class="fas fa-sort-up"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'text'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'text'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'text'">
                 <i class="fas fa-sort-down"></i></span>
              </th>
              <th class="pl-1 sort-th twenty" @click="sort('category')">Category
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'category'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'category'">
                 <i class="fas fa-sort-up"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'category'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'category'">
                 <i class="fas fa-sort-down"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'category'">
                 <i class="fas fa-sort-down"></i></span>
              </th>
               <th class="sort-th" style="min-width:175px" @click="sort('start_date')">Start Date
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'start_date'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'start_date'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'start_date'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'start_date'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'start_date'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
               <th class="sort-th" style="min-width:175px" @click="sort('due_date')">Due Date
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'due_date'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'due_date'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'due_date'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'due_date'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'due_date'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
              <th class="sort-th p-1">
                 <span class="py-2 d-inline-block">Assigned Users</span>


              </th>
              <th class="sort-th" style="min-width:175px" @click="sort('progress')">Progress
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'progress'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'progress'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'progress'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'progress'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'progress'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
              <th class='non-sort-th' style="min-width:200px">Flags
               
              </th>
              <th class="sort-th twenty" @click="sort('notes_updated_at')" style="min-width:300px">Last Update
                 <span class="inactive-sort-icon scroll" v-if="currentSort !== 'notes_updated_at'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'notes_updated_at'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'notes_updated_at'">
                 <i class="fas fa-sort-up"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'notes_updated_at'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'notes_updated_at'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
              </thead>
         <tbody>
        <tr v-for="task, index in sortedTasks" :key="index">
        <td>{{ task.program_name }}</td>
        <td>{{ task.project_name }}</td>
        <td>{{ task.text }}</td>
        <td>{{ task.category }}</td>
          <td>{{ task.start_date}}</td>
            <td>{{ task.due_date }}</td>
        <td> {{ task.users }} </td>   
        <td> {{ task.progress + '%' }} </td>
        <td class="text-center">
            <span v-if="task.is_overdue" v-tooltip="`Overdue`">  <i class="fas fa-calendar text-danger mr-1"></i></span>
            <span v-if="task.progress == 100" v-tooltip="`Completed`"><i class="far fa-clipboard-check text-success mr-1"></i></span>   
            <span v-if="task.ongoing == true" v-tooltip="`Ongoing`"><i class="far fa-retweet text-success"></i></span>   
            <span v-if="task.on_hold == true" v-tooltip="`On Hold`"> <i class="fas fa-pause-circle mr-1 text-primary"></i></span>   
            <span v-if="task.draft == true" v-tooltip="`Draft`"> <i class="fas fa-pencil-alt text-warning"></i></span>   
            <span v-if="task.watched == true"  v-tooltip="`On Watch`"><i class="fas fa-eye mr-1"></i></span>
            <span v-if="task.important == true"  v-tooltip="`Important`"> <i class="fas fa-star text-warning mr-1"></i></span>
            <span v-if="task.reportable" v-tooltip="`Briefings`"> <i class="fas fa-presentation mr-1 text-primary"></i></span>
           
            <span v-if="
                      task.important == false &&
                      task.reportable == false &&
                      task.watched == false &&
                      task.ongoing == false && 
                      task.isOverdue == false &&
                      task.onHold == false &&  
                      task.draft == false && 
                      task.progress < 100 "             
                    >
                  No flags at this time         
              </span>              
          </td>
         <td class="text-left" v-if="(task.notes_updated_at.length) > 0">
           <span class="toolTip" v-tooltip="('By: ' + task.notes[task.notes.length - 1].user.full_name)">              
          {{moment(task.notes_updated_at[0]).format('DD MMM YYYY, h:mm a')}}
            </span>
            <br> 
            <span>
              {{task.notes[task.notes.length - 1].body}}
            </span>
           
        </td>       
        <!-- <td v-else class="twentyTwo">No Updates</td> -->
        <td  class="text-left" v-else>No Update</td>
     
       
        </tr>
        </tbody>
        </table>     
        </div>
          <div class="ml-auto mb-4 mt-2 font-sm">
           <div class="simple-select d-inline-block text-right font-sm">
           <span class="mr-1">Displaying </span>
            <el-select
            v-model="C_tasksPerPage"
            class="w-33"
            track-by="value"
            value-key="id"
            >
            <el-option
              v-for="item in getTasksPerPageFilterOptions"
              :value="item"
              :key="item.id"
              :label="item.name"
              >
            </el-option>
            </el-select>
           </div> 
          <span class="mr-1 pr-3" style="border-right:solid 1px lightgray">Per Page </span>
            <button class="btn btn-sm page-btns" @click="prevPage"><i class="fas fa-angle-left"></i></button>
            <button class="btn btn-sm page-btns" id="page-count"> {{ currentPage }} of {{ Math.ceil(this.tasksObj.length / this.C_tasksPerPage.value) }} </button>
            <button class="btn btn-sm page-btns" @click="nextPage"><i class="fas fa-angle-right"></i></button>
        </div>
    
     
              <!-- TASKS TABLE -->
           <!-- <el-table
              :data="pagedTableData"  
              class="mt-5"
              border
              style="width: 100%">
            <el-table-column
              fixed
              prop="program_name"
              sortable
              :sort-change="test"
              label="Program"
              width="250">
            </el-table-column>
            <el-table-column
              prop="project_name"
              fixed
              sortable
              label="Project"
              width="225">
            </el-table-column>
            <el-table-column
              prop="text"
              fixed
              sortable
              label="Task"
              width="225">
            </el-table-column>
            <el-table-column
              prop="category"
              label="Category"
              sortable
              width="200">
            </el-table-column>
            <el-table-column
              prop="start_date"
              label="Start Date"
              sortable
              width="120">
            </el-table-column>
            <el-table-column
              prop="due_date"
              label="Due Date"
              sortable
              width="120">
            </el-table-column>
            <el-table-column
              prop="users"
              label="Assigned Users"
              sortable
              width="200">
            </el-table-column>
            <el-table-column
              prop="progress"
              sortable
              label="Progress"
              width="100">
            </el-table-column>
            <el-table-column
              prop="flags"
              label="Flags"
              sortable
              width="150">
            </el-table-column>
            <el-table-column
              prop="last_update"
              fixed="right"
              label="Last Update"
              sortable
              width="250">             
            </el-table-column>

          

          </el-table>
         
                      
            </div>    
             <div class="float-right mt-2">
          <el-pagination
            
            @current-change="setPage"
            layout="prev, pager, next"
            :page-size="pageSize"
            :total="tasksObj.length">
          </el-pagination> -->
    

      </div>
      <div v-else class="mt-5">
        NO RESULTS TO DISPLAY
      </div>
               
     </el-tab-pane>
      <el-tab-pane class="px-3 pt-0"  >  
          <template slot="label" class="text-right">
           ISSUES
           <span class="badge badge-secondary badge-pill">
           <span v-if="issuesObj">{{ portfolioIssues.length }}</span>
          </span>   
          </template>    
           <div class="row pt-2">          

            
             <div class="col-3 text-center py-0">
                  <label class="font-sm pb-1 mb-0">FILTER BY PROGRAM</label>
                <el-select     
                    v-model="C_programNameFilter"                               
                    class="w-100" 
                    track-by="name" 
                    value-key="id"
                    multiple                                                                                                                                                                   
                    placeholder="Filter By Program"
                  >
                  <el-option                   
                    v-for="item in C_programNames"                                                               
                    :value="item"   
                    class="text-truncate"
                    :key="item.id"
                    :label="item.name"                                                                      
                    >
                  </el-option>
                  </el-select> 
              </div>           
              
                <div class="col-6 text-center pt-2">
                <label class="font-sm mb-0 pb-1 d-block">DISPLAY ISSUES BY STATE</label>
                <div class="pb-0 pl-2 pr-4 mb-0 d-inline-flex">                       
                  <div class="pr-5 text-center icons" :class="[hideCompleteIssues == true ? 'light':'']" @click.prevent="toggleCompleteI">             
                   <span class="d-block">
                    <i class="fas fa-clipboard-check" :class="[hideCompleteIssues == true ? 'light':'text-success']"></i>
                    </span>      
                  <span class="smallerFont">COMPLETE</span>
                   <h5 class="d-block">{{ issueVariation.completed.count }}</h5>  
                  </div>

                  <div class="pr-5 text-center icons" :class="[hideInprogressIssues == true ? 'light':'']" @click.prevent="toggleInprogressI">
                    <span class="d-block">
                    <i class="far fa-tasks" :class="[hideInprogressIssues == true ? 'light':'text-primary']"></i>
                    </span>                          
                     <span class="smallerFont">IN PROGRESS</span> 
                     <h5 class="d-block">{{ issueVariation.inProgress.count }}</h5>  
                  </div>
                
                
                 <div class="pr-5 text-center icons" :class="[hideOverdueIssues == true ? 'light':'']" @click.prevent="toggleOverdueI">
                    <span class="d-block">
                    <i class="fas fa-calendar" :class="[hideOverdueIssues == true ? 'light':'text-danger']"></i>
                    </span>                  
                    <span class="smallerFont">OVERDUE </span> 
                    <h5 class="d-block"> {{ issueVariation.overdue.count }}  </h5>    
                  </div>

                 <div class="pr-5 text-center icons" :class="[hidePlannedIssues == true ? 'light':'']" @click.prevent="togglePlannedI"> 
                  <span class="d-block">
                  <i class="fas fa-calendar-check" :class="[hidePlannedIssues == true ? 'light':'text-info']"></i>
                  </span>                     
                  <span class="smallerFont">PLANNED</span>
                    <h5 class="d-block"> <span v-if="issuesObj">{{ issueVariation.planned.count }}</span></h5>  
                </div>
             
                <div class="pr-5 text-center icons" :class="[hideOnholdIssues == true ? 'light':'']"  @click.prevent="toggleOnholdI">
                     <span class="d-block">
                      <i class="fas fa-pause-circle" :class="[hideOnholdIssues == true ? 'light':'text-primary']"></i>
                     </span> 
                     <span class="smallerFont">ON HOLD</span> 
                       <h5 class="d-block">{{ issueVariation.onHoldI.count }}</h5>            
                </div>
                 
                 
                 <div class="text-center icons" :class="[hideDraftIssues == true ? 'light':'']"  @click.prevent="toggleDraftI" >
                  <span class="d-block">
                      <i class="fas fa-pencil-alt" :class="[hideDraftIssues == true ? 'light':'text-warning']"></i>
                  </span>     
                  <span class="smallerFont">DRAFTS</span>   
                        <h5 class="d-block">{{  issueVariation.issueDrafts.count }}</h5>              
                </div> 
               
               
                </div>
              </div>
                 <div class="col-3 tagsCol text-center pt-2 pl-0">
                <label class="font-sm mb-0 pb-1 d-block">FOCUS DISPLAYED ISSUES BY TAG</label>
                 <div class="pb-0 pl-2 mb-0 d-inline-flex">    
                  <div class="text-center icons" :class="[hideWatchedIssues == true ? '':'light']" @click.prevent="toggleWatchedI"   >             
                 <span class="d-block">
                      <i class="fas fa-eye " ></i>
                 </span>                  
                  <span class="smallerFont">ON WATCH</span>
                   <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="watched" v-model="C_hideWatchedissues">               -->
                   <h5 class="d-block">{{ issueVariation.watched.count }}</h5>  
                  </div>
                  <div class="px-5 text-center icons" :class="[hideImportantIssues == true ? '':'light']" @click.prevent="toggleImportantI"     >
                  <span class="d-block">
                      <i class="fas fa-star" :class="[hideImportantIssues == true ? 'text-warning':'light']"></i>
                  </span>     
                      <span class="smallerFont">IMPORTANT</span> 
                       <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="important" v-model="C_hideImportantissues">     -->
                     <h5 class="d-block">{{ issueVariation.important.count }}</h5>  
                  </div>
                   <div class="text-center icons"  :class="[hideBriefedIssues == true ? '':'light']" @click.prevent="toggleBriefingI"         >
                      <span class="d-block">
                     <i class="fas fa-presentation" :class="[hideBriefedIssues == true ? 'text-primary':'']"></i>
                  </span>     
                    <span class="smallerFont">BRIEFINGS </span> 
                      <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="briefed" v-model="C_hideBriefedissues">   -->
                    <h5 class="d-block"> {{ issueVariation.briefings.count }}  </h5>    
                  </div>
               </div>
             </div>
              </div>
      <div class="row text-center mt-2" v-if="issuesObj !== null && issuesObj.length > 0 ">            
        <span class="ml-auto mt-3 btnRow"> 
        <button
          v-tooltip="`Export to PDF`"
          @click.prevent="exportIssuesToPdf"
          class="btn btn-md mr-1 exportBtns text-light">
          <i class="far fa-file-pdf"></i>
        </button>
        <button
          v-tooltip="`Export to Excel`"
          @click.prevent="exportIssuesToExcel('table', 'Portfolio Issues')"
          class="btn btn-md mr-3 exportBtns text-light">
        <i class="far fa-file-excel"></i>
        </button>
        <button class="btn text-light btn-md mh-orange profile-btns">RESULTS: {{ issuesObj.length}}</button>
        </span>                  
      
        <div class="xTable" style="overflow-x:auto;">
          <table class="table table-sm mt-3 stickyTableHeader table-bordered" ref="issueTable" id="portIssues">
           
            <thead style="background-color:#ededed;">
              <th class="sort-th twenty" @click="sortI('program_name')" >Program Name
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'program_name'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'program_name'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'program_name'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'program_name'">
                 <i class="fas fa-sort-down"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'program_name'">
                 <i class="fas fa-sort-down"></i></span>
              </th>
              <th class="sort-th twenty" @click="sortI('project_name')">Project Name
                <span class="inactive-sort-icon scroll" v-if="currentSort !== ''">
                 <i class="fas fa-sort"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'project_name'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'project_name'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'project_name'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'project_name'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
              <th class="pl-1 sort-th twenty" @click="sortI('title')">Issue
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'title'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'title'">
                 <i class="fas fa-sort-up"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'title'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'title'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'title'">
                 <i class="fas fa-sort-down"></i></span>
              </th>
              <th class="pl-1 sort-th" @click="sortI('issue_type')">Issue Type
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'issue_type'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'issue_type'">
                 <i class="fas fa-sort-up"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'issue_type'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'issue_type'">
                 <i class="fas fa-sort-down"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'issue_type'">
                 <i class="fas fa-sort-down"></i></span>
              </th>
              <th class="pl-1 sort-th" @click="sortI('issue_severity')">Issue Severity
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'issue_severity'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'issue_severity'">
                 <i class="fas fa-sort-up"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'issue_severity'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'issue_severity'">
                 <i class="fas fa-sort-down"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'issue_severity'">
                 <i class="fas fa-sort-down"></i></span>
              </th>
              <th class="sort-th" style="min-width:175px" @click="sort('start_date')">Start Date
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'start_date'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'start_date'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'start_date'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'start_date'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'start_date'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
               <th class="sort-th" style="min-width:175px" @click="sort('due_date')">Due Date
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'due_date'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'due_date'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'due_date'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'due_date'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'due_date'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
              <th class="sort-th p-1">
                 <span class="py-2 d-inline-block">Assigned Users</span>
              </th>
              <th class="sort-th" style="min-width:175px" @click="sortI('progress')">Progress
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'progress'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'progress'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'progress'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'progress'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'progress'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
              <th class='non-sort-th' style="min-width:200px">Flags
               
              </th>
              <th class="sort-th" style="min-width:300px" @click="sortI('notes_updated_at')">Last Update
                 <span class="inactive-sort-icon scroll" v-if="currentSort !== 'notes_updated_at'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'notes_updated_at'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'notes_updated_at'">
                 <i class="fas fa-sort-up"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'notes_updated_at'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'notes_updated_at'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
            </thead>
         <tbody>
        <tr v-for="issue, index in sortedIssues" :key="index">
        <td>{{ issue.program_name }}</td>
        <td>{{ issue.project_name }}</td>
        <td>{{ issue.title }}</td>
        <td>{{ issue.issue_type }}</td>
        <td>{{ issue.issue_severity }}</td>
        <td> {{ issue.start_date }} </td>   
        <td> {{ issue.due_date }} </td>   
        <td> {{ issue.users }} </td>   
        <td> {{ issue.progress + '%' }} </td>
        <td class="text-center">
            
            <span v-if="issue.is_overdue" v-tooltip="`Overdue`">  <i class="fas fa-calendar text-danger"></i> </span>
            <span v-if="issue.progress == 100" v-tooltip="`Completed`"><i class="fas fa-clipboard-check text-success mr-1"></i></span> 
            <span v-if="issue.on_hold == true" v-tooltip="`On Hold`"> <i class="fas fa-pause-circle mr-1 text-primary"></i></span>   
            <span v-if="issue.draft == true" v-tooltip="`Draft`"> <i class="fas fa-pencil-alt text-warning"></i></span>   
            <span v-if="issue.watched == true"  v-tooltip="`On Watch`"><i class="fas fa-eye mr-1"></i></span>
            <span v-if="issue.important == true"  v-tooltip="`Important`"> <i class="fas fa-star text-warning mr-1"></i></span>
            <span v-if="issue.reportable" v-tooltip="`Briefings`"> <i class="fas fa-presentation mr-1 text-primary"></i></span>
            <span v-if="
                      issue.important == false &&
                      issue.reportable == false &&
                      issue.watched == false &&
                      issue.isOverdue == false &&
                      issue.onHold == false &&  
                      issue.draft == false && 
                      issue.progress < 100 "             
                    >
                  No flags at this time         
              </span>              
          </td>
           <td class="text-left" v-if="(issue.notes_updated_at.length) > 0">
           <span class="toolTip" v-tooltip="('By: ' + issue.notes[issue.notes.length - 1].user.full_name)">              
          {{moment(issue.notes_updated_at[0]).format('DD MMM YYYY, h:mm a')}}
            </span>
            <br> 
            <span>
              {{issue.notes[issue.notes.length - 1].body}}
            </span>
           
        </td>       
        <!-- <td v-else class="twentyTwo">No Updates</td> -->
        <td  class="text-left" v-else>No Update</td>
     
       
        </tr>
        </tbody>
        </table> 
          
        
        </div>
          <div class="ml-auto mb-4 mt-2 font-sm">
           <div class="simple-select d-inline-block text-right font-sm">
           <span class="mr-1">Displaying </span>
            <el-select
            v-model="C_issuesPerPage"
            class="w-33"
            track-by="value"
            value-key="id"
            >
            <el-option
              v-for="item in getIssuesPerPageFilterOptions"
              :value="item"
              :key="item.id"
              :label="item.name"
              >
            </el-option>
            </el-select>
           </div> 
          <span class="mr-1 pr-3" style="border-right:solid 1px lightgray">Per Page </span>
            <button class="btn btn-sm page-btns" @click="prevIssuesPage"><i class="fas fa-angle-left"></i></button>
            <button class="btn btn-sm page-btns" id="page-count"> {{ currentIssuesPage }} of {{ Math.ceil(this.issuesObj.length / this.C_issuesPerPage.value) }} </button>
            <button class="btn btn-sm page-btns" @click="nextIssuesPage"><i class="fas fa-angle-right"></i></button>
        </div>
           
  
          </div> 
       <div v-else class="mt-5">
        NO RESULTS TO DISPLAY
      </div>
      </el-tab-pane>
  
<!-- RISKS TAB STARTS HERE -->

      <el-tab-pane class="px-3 pt-0" >
         <template slot="label" class="text-right" v-if="risksObj && risksObj !== undefined">
           RISKS
           <span class="badge badge-secondary badge-pill">
              <span>{{ portfolioRisks.length }}</span>
                <!-- <span v-if="getPortfolioWatchedTasksToggle">{{ tasksObj.length }}</span>
                <span v-if="!getPortfolioWatchedTasksToggle"> {{filterOutWatched.length }}</span> -->
          </span>   
          </template>
             <div class="row pt-2">          

            
             <div class="col-3 text-center py-0">
                 <label class="font-sm pb-1 mb-0">FILTER BY PROGRAM</label>
                <el-select     
                    v-model="C_programNameFilter"                               
                    class="w-100" 
                    track-by="name" 
                    value-key="id"
                    multiple                                                                                                                                                                   
                    placeholder="Filter By Program"
                  >
                  <el-option                   
                    v-for="item in C_programNames"                                                               
                    :value="item"   
                    class="text-truncate"
                    :key="item.id"
                    :label="item.name"                                                                      
                    >
                  </el-option>
                  </el-select> 
              </div>           
              
                <div class="col-6 text-center pt-2">
                <label class="font-sm mb-0 pb-1 d-block">DISPLAY RISKS BY STATE</label>
                <div class="pb-0 pl-2 pr-4 mb-0 d-inline-flex">                       
                  <div class="pr-5 text-center icons" :class="[hideCompleteRisks == true ? 'light':'']" @click.prevent="toggleCompleteR">             
                   <span class="d-block">
                    <i class="fas fa-clipboard-check" :class="[hideCompleteRisks == true ? 'light':'text-success']"></i>
                    </span>      
                  <span class="smallerFont">COMPLETE</span>
                   <h5 class="d-block">{{ riskVariation.completed.count }}</h5>  
                  </div>

                  <div class="pr-5 text-center icons" :class="[hideInprogressRisks == true ? 'light':'']" @click.prevent="toggleInprogressR">
                    <span class="d-block">
                    <i class="far fa-tasks" :class="[hideInprogressRisks == true ? 'light':'text-primary']"></i>
                    </span>                          
                     <span class="smallerFont">IN PROGRESS</span> 
                     <h5 class="d-block">{{ riskVariation.inProgress.count }}</h5>  
                  </div>
                
                
                 <div class="pr-5 text-center icons" :class="[hideOverdueRisks == true ? 'light':'']" @click.prevent="toggleOverdueR">
                    <span class="d-block">
                    <i class="fas fa-calendar" :class="[hideOverdueRisks == true ? 'light':'text-danger']"></i>
                    </span>                  
                    <span class="smallerFont">OVERDUE </span> 
                    <h5 class="d-block"> {{ riskVariation.overdue.count }}  </h5>    
                  </div>

                <div class="pr-5 text-center icons" :class="[hideOngoingRisks == true ? 'light':'']" @click.prevent="toggleOngoingR">
                  <span class="d-block">
                  <i class="fas fa-retweet" :class="[hideOngoingRisks == true ? 'light':'text-success']"></i>
                  </span> 
                    <span class="smallerFont">ONGOING </span>    
                    <h5 class="d-block"> <span v-if="risksObj">{{ riskVariation.ongoing.count }}</span></h5>  
                 </div> 


                <div class="pr-5 text-center icons" :class="[hidePlannedRisks == true ? 'light':'']" @click.prevent="togglePlannedR"> 
                  <span class="d-block">
                  <i class="fas fa-calendar-check" :class="[hidePlannedRisks == true ? 'light':'text-info']"></i>
                  </span>                     
                  <span class="smallerFont">PLANNED</span>
                    <h5 class="d-block"> <span v-if="risksObj">{{ riskVariation.planned.count }}</span></h5>  
                </div>
             
                <div class="pr-5 text-center icons" :class="[hideOnholdRisks == true ? 'light':'']"  @click.prevent="toggleOnholdR">
                     <span class="d-block">
                      <i class="fas fa-pause-circle" :class="[hideOnholdRisks == true ? 'light':'text-primary']"></i>
                     </span> 
                     <span class="smallerFont">ON HOLD</span> 
                       <h5 class="d-block">{{ riskVariation.onHoldR.count }}</h5>            
                </div>
                 
                 
                 <div class="text-center icons" :class="[hideDraftRisks == true ? 'light':'']"  @click.prevent="toggleDraftR" >
                  <span class="d-block">
                      <i class="fas fa-pencil-alt" :class="[hideDraftRisks == true ? 'light':'text-warning']"></i>
                  </span>     
                  <span class="smallerFont">DRAFTS</span>   
                        <h5 class="d-block">{{  riskVariation.riskDrafts.count }}</h5>              
                </div> 
               
               
                </div>
              </div>
                 <div class="col-3 tagsCol text-center pt-2 pl-0">
                <label class="font-sm mb-0 pb-1 d-block">FOCUS DISPLAYED RISKS BY TAG</label>
                 <div class="pb-0 pl-2 mb-0 d-inline-flex">    
                  <div class="text-center icons" :class="[hideWatchedRisks == true ? '':'light']" @click.prevent="toggleWatchedR"   >             
                 <span class="d-block">
                      <i class="fas fa-eye" ></i>
                 </span>                  
                  <span class="smallerFont">ON WATCH</span>
                   <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="watched" v-model="C_hideWatchedTasks">               -->
                   <h5 class="d-block">{{ riskVariation.watched.count }}</h5>  
                  </div>
                  <div class="px-5 text-center icons" :class="[hideImportantRisks == true ? '':'light']" @click.prevent="toggleImportantR"     >
                  <span class="d-block">
                      <i class="fas fa-star" :class="[hideImportantRisks == true ? 'text-warning':'light']"></i>
                  </span>     
                      <span class="smallerFont">IMPORTANT</span> 
                       <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="important" v-model="C_hideImportantTasks">     -->
                     <h5 class="d-block">{{ riskVariation.important.count }}</h5>  
                  </div>
                   <div class="text-center icons"  :class="[hideBriefedRisks == true ? '':'light']" @click.prevent="toggleBriefingR"         >
                      <span class="d-block">
                     <i class="fas fa-presentation" :class="[hideBriefedRisks == true ? 'text-primary ':'light']"></i>
                  </span>     
                    <span class="smallerFont">BRIEFINGS </span> 
                      <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="briefed" v-model="C_hideBriefedTasks">   -->
                    <h5 class="d-block"> {{ riskVariation.briefings.count }}  </h5>    
                  </div>
               </div>
             </div>
              </div>

      <div class="row text-center mt-2" v-if="risksObj !== null && risksObj.length > 0 ">            
        <span class="ml-auto mt-3 btnRow"> 
        <button
          v-tooltip="`Export to PDF`"
          @click.prevent="exportRisksToPdf"
          class="btn btn-md mr-1 exportBtns text-light">
          <i class="far fa-file-pdf"></i>
        </button>
        <button
          v-tooltip="`Export to Excel`"
          @click.prevent="exportRisksToExcel('table', 'Portfolio Risks')"
          class="btn btn-md mr-3 exportBtns text-light">
        <i class="far fa-file-excel"></i>
        </button>
        <button class="btn text-light btn-md mh-orange profile-btns">RESULTS: {{ risksObj.length}}</button>
        </span>                   
                
      
        <div class="xTable" style="overflow-x:auto;">
          <table class="table table-sm mt-3 stickyTableHeader table-bordered" ref="riskTable" id="portRisks">
           
            <thead style="background-color:#ededed;">
              <th class="sort-th twenty" @click="sort('program_name')" >Program Name
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'program_name'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'program_name'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'program_name'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'program_name'">
                 <i class="fas fa-sort-down"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'program_name'">
                 <i class="fas fa-sort-down"></i></span>
              </th>
              <th class="sort-th twenty" @click="sort('project_name')">Project Name
                <span class="inactive-sort-icon scroll" v-if="currentSort !== ''">
                 <i class="fas fa-sort"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'project_name'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'project_name'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'project_name'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'project_name'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
              <th class="pl-1 sort-th twenty" @click="sort('text')">Risk
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'text'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'text'">
                 <i class="fas fa-sort-up"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'text'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'text'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'text'">
                 <i class="fas fa-sort-down"></i></span>
              </th>
              <th class="pl-1 sort-th" @click="sort('category')">Category
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'category'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'category'">
                 <i class="fas fa-sort-up"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'category'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'category'">
                 <i class="fas fa-sort-down"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'category'">
                 <i class="fas fa-sort-down"></i></span>
              </th>
              <th class="sort-th" @click="sort('risk_approach')">Risk Approach
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'risk_approach'">
               <i class="fas fa-sort"></i></span>
              <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'risk_approach'">
              <i class="fas fa-sort-up"></i></span>
              <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'risk_approach'">
              <i class="fas fa-sort-up"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'risk_approach'">
              <i class="fas fa-sort-down"></i></span>
              <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'risk_approach'">
              <i class="fas fa-sort-down"></i></span>

            </th>
            <th class="sort-th"  @click="sort('priority_level')">Priority Level
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'priority_level'">
               <i class="fas fa-sort"></i></span>
              <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'priority_level'">
              <i class="fas fa-sort-up"></i></span>
              <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'priority_level'">
              <i class="fas fa-sort-up"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'priority_level'">
              <i class="fas fa-sort-down"></i></span>
              <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'priority_level'">
              <i class="fas fa-sort-down"></i></span>
            </th>
              <th class="sort-th" style="min-width:175px" @click="sort('start_date')">Start Date
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'start_date'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'start_date'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'start_date'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'start_date'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'start_date'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
               <th class="sort-th" @click="sort('due_date')">Risk Approach Due Date
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'due_date'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'due_date'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'due_date'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'due_date'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'due_date'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
              <th class="sort-th p-1">
                 <span class="py-2 d-inline-block">Assigned Users</span>


              </th>
              <th class="sort-th" style="min-width:175px" @click="sort('progress')">Progress
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'progress'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'progress'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'progress'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'progress'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'progress'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
              <th class='non-sort-th' style="min-width:200px">Flags
               
              </th>
              <th class="sort-th" style="min-width:300px" @click="sort('notes_updated_at')">Last Update
                 <span class="inactive-sort-icon scroll" v-if="currentSort !== 'notes_updated_at'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'notes_updated_at'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'notes_updated_at'">
                 <i class="fas fa-sort-up"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'notes_updated_at'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'notes_updated_at'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
            </thead>
         <tbody>
        <tr v-for="risk, index in sortedRisks" :key="index">
        <td>{{ risk.program_name }}</td>
        <td>{{ risk.project_name }}</td>
        <td>{{ risk.text }}</td>
        <td>{{ risk.category }}</td>
        <td>{{ risk.risk_approach.charAt(0).toUpperCase() + risk.risk_approach.slice(1) }}</td>
        <td>
            <span v-if="(risk.priority_level) == 1" class="gray2">Very Low</span> 
            <span v-else-if="(risk.priority_level) <= 3" class="green1">Low</span> 
            <span v-else-if="(risk.priority_level) <= 6" class="yellow1">Moderate</span> 
            <span v-else-if="(risk.priority_level) <= 14" class="orange1">High</span> 
            <span v-else-if="(risk.priority_level) >= 15" class="red1">Extreme</span> 
       </td>
         <td>{{ risk.start_date }}</td>
        <td> {{ risk.due_date }} </td>   
        <td> {{ risk.users }} </td>   
        <td> {{ risk.progress }} </td>
        <td class="text-center">
            <span v-if="risk.is_overdue" v-tooltip="`Overdue`"><i class="fas fa-calendar mr-1 text-danger"></i></span>
            <span v-if="risk.progress == 100" v-tooltip="`Completed`"><i class="fas fa-clipboard-check text-success"></i></span>   
            <span v-if="risk.ongoing == true" v-tooltip="`Ongoing`"><i class="far fa-retweet text-success"></i></span>   
            <span v-if="risk.on_hold == true" v-tooltip="`On Hold`"> <i class="fas fa-pause-circle mr-1 text-primary"></i></span>   
            <span v-if="risk.draft == true" v-tooltip="`Draft`"> <i class="fas fa-pencil-alt text-warning"></i></span>   
            <span v-if="risk.watched == true"  v-tooltip="`On Watch`"><i class="fas fa-eye mr-1"></i></span>
            <span v-if="risk.important == true"  v-tooltip="`Important`"> <i class="fas fa-star text-warning mr-1"></i></span>
            <span v-if="risk.reportable" v-tooltip="`Briefings`"> <i class="fas fa-presentation mr-1 text-primary"></i></span>
            
            <span v-if="
                      risk.important == false &&
                      risk.reportable == false &&
                      risk.watched == false &&
                      risk.ongoing == false && 
                      risk.isOverdue == false &&
                      risk.onHold == false &&  
                      risk.draft == false && 
                      risk.progress < 100 "             
                    >
                  No flags at this time         
              </span>              
          </td>
        <!-- <td v-if="risk.last_update !== null">{{risk.last_update.body}}</td> -->

          <td class="text-left" v-if="(risk.notes_updated_at.length) > 0">
           <span class="toolTip" v-tooltip="('By: ' + risk.notes[risk.notes.length - 1].user.full_name)">              
          {{moment(risk.notes_updated_at[0]).format('DD MMM YYYY, h:mm a')}}
            </span>
            <br> 
            <span>
              {{risk.notes[risk.notes.length - 1].body}}
            </span>
           
        </td>       
        <!-- <td v-else class="twentyTwo">No Updates</td> -->
        <td  class="text-left" v-else>No Update</td>
     
       
        </tr>
        </tbody>
        </table> 
          
      
        </div>
            <div class="ml-auto mb-4 mt-2 font-sm">
           <div class="simple-select d-inline-block text-right font-sm">
           <span class="mr-1">Displaying </span>
            <el-select
            v-model="C_risksPerPage"
            class="w-33"
            track-by="value"
            value-key="id"
            >
            <el-option
              v-for="item in getRisksPerPageFilterOptions"
              :value="item"
              :key="item.id"
              :label="item.name"
              >
            </el-option>
            </el-select>
           </div> 
          <span class="mr-1 pr-3" style="border-right:solid 1px lightgray">Per Page </span>
            <button class="btn btn-sm page-btns" @click="prevRisksPage"><i class="fas fa-angle-left"></i></button>
            <button class="btn btn-sm page-btns" id="page-count"> {{ currentRisksPage }} of {{ Math.ceil(this.risksObj.length / this.C_risksPerPage.value) }} </button>
            <button class="btn btn-sm page-btns" @click="nextRisksPage"><i class="fas fa-angle-right"></i></button>
        </div>
    
       </div>
       <div v-else class="mt-5">
        NO RESULTS TO DISPLAY
      </div>
     </el-tab-pane>
        <el-tab-pane class="px-3 pt-0">  
          <template slot="label" class="text-right">
          LESSONS LEARNED
           <span class="badge badge-secondary badge-pill">
           <span v-if="lessonsObj !== null">{{ portfolioLessons.length }}</span>
          </span>   
          </template>   
            <div class="row pt-2">          

            
             <div class="col-3 text-center py-0">
                 <label class="font-sm pb-1 mb-0">FILTER BY PROGRAM</label>
                 <el-select     
                    v-model="C_programNameFilter"                               
                    class="w-100" 
                    track-by="name" 
                    value-key="id"
                    multiple                                                                                                                                                                   
                    placeholder="Filter By Program"
                  >
                  <el-option                   
                    v-for="item in C_programNames"                                                               
                    :value="item"   
                    class="text-truncate"
                    :key="item.id"
                    :label="item.name"                                                                      
                    >
                  </el-option>
                  </el-select> 
              </div>           
              
                <div class="col-6 text-center pt-2">
                <label class="font-sm mb-0 pb-1 d-block">DISPLAY LESSONS BY STATE</label>
                <div class="pb-0 pl-2 pr-4 mb-0 d-inline-flex">                       
                  <div class="pr-5 text-center icons" :class="[hideCompleteLessons == true ? 'light':'']" @click.prevent="toggleCompleteL">             
                   <span class="d-block">
                    <i class="fas fa-clipboard-check" :class="[hideCompleteLessons == true ? 'light':'text-success']"></i>
                    </span>      
                  <span class="smallerFont">COMPLETE</span>
                   <h5 class="d-block">{{ lessonVariation.completed.count }}</h5>  
                  </div>

                  <div class="pr-5 text-center icons" :class="[hideInprogressLessons == true ? 'light':'']" @click.prevent="toggleInprogressL">
                    <span class="d-block">
                    <i class="far fa-tasks" :class="[hideInprogressLessons == true ? 'light':'text-primary']"></i>
                    </span>                          
                     <span class="smallerFont">IN PROGRESS</span> 
                     <h5 class="d-block">{{ lessonVariation.inProgress.count }}</h5>  
                  </div>
                
<!--                 
                <div class="pr-5 text-center icons" :class="[hideOngoingRisks == true ? 'light':'']" @click.prevent="toggleOngoingR">
                  <span class="d-block">
                  <i class="fas fa-retweet" :class="[hideOngoingRisks == true ? 'light':'text-success']"></i>
                  </span> 
                    <span class="smallerFont">ONGOING </span>    
                    <h5 class="d-block"> <span v-if="risksObj">{{ riskVariation.ongoing.count }}</span></h5>  
                 </div>  -->


                <!-- <div class="pr-5 text-center icons" :class="[hidePlannedLessons == true ? 'light':'']" @click.prevent="togglePlannedL"> 
                  <span class="d-block">
                  <i class="fas fa-calendar-check" :class="[hidePlannedLessons == true ? 'light':'text-info']"></i>
                  </span>                     
                  <span class="smallerFont">PLANNED</span>
                    <h5 class="d-block"> <span v-if="risksObj">{{ lessonVariation.planned.count }}</span></h5>  
                </div> -->
             
                <!-- <div class="pr-5 text-center icons" :class="[hideOnholdLessons == true ? 'light':'']"  @click.prevent="toggleOnholdL">
                     <span class="d-block">
                      <i class="fas fa-pause-circle" :class="[hideOnholdLessons == true ? 'light':'text-primary']"></i>
                     </span> 
                     <span class="smallerFont">ON HOLD</span> 
                       <h5 class="d-block">{{ lessonVariation.onHoldL.count }}</h5>            
                </div> -->
                 
                 
                 <div class="text-center icons" :class="[hideDraftLessons == true ? 'light':'']"  @click.prevent="toggleDraftL" >
                  <span class="d-block">
                      <i class="fas fa-pencil-alt" :class="[hideDraftLessons == true ? 'light':'text-warning']"></i>
                  </span>     
                  <span class="smallerFont">DRAFTS</span>   
                        <h5 class="d-block">{{  lessonVariation.lessonDrafts.count }}</h5>              
                </div> 
               
               
                </div>
              </div>
                 <div class="col-3 tagsCol text-center pt-2 pl-0">
                <label class="font-sm mb-0 pb-1 d-block">FOCUS DISPLAYED LESSONS BY TAG</label>
                 <div class="pb-0 pl-2 mb-0 d-inline-flex">    
                  <div class="text-center icons" :class="[hideWatchedLessons == true ? '':'light']" @click.prevent="toggleWatchedL"   >             
                 <span class="d-block">
                      <i class="fas fa-eye" ></i>
                 </span>                  
                  <span class="smallerFont">ON WATCH</span>
                   <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="watched" v-model="C_hideWatchedTasks">               -->
                   <h5 class="d-block">{{ lessonVariation.watched.count }}</h5>  
                  </div>
                  <div class="px-5 text-center icons" :class="[hideImportantLessons == true ? '':'light']" @click.prevent="toggleImportantL"     >
                  <span class="d-block">
                      <i class="fas fa-star" :class="[hideImportantLessons == true ? 'text-warning':'light']"></i>
                  </span>     
                      <span class="smallerFont">IMPORTANT</span> 
                       <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="important" v-model="C_hideImportantTasks">     -->
                     <h5 class="d-block">{{ lessonVariation.important.count }}</h5>  
                  </div>
                   <div class="text-center icons"  :class="[hideBriefedLessons == true ? '':'light']" @click.prevent="toggleBriefingL"         >
                      <span class="d-block">
                     <i class="fas fa-presentation" :class="[hideBriefedLessons == true ? 'text-primary ':'light']"></i>
                  </span>     
                    <span class="smallerFont">BRIEFINGS </span> 
                      <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="briefed" v-model="C_hideBriefedTasks">   -->
                    <h5 class="d-block"> {{ lessonVariation.briefings.count }}  </h5>    
                  </div>
               </div>
             </div>
              </div>
 
    
      <div class="row text-center mt-2" v-if="lessonsObj !== null && lessonsObj.length > 0">            
      <span class="ml-auto mt-3 btnRow"> 
        <button
          v-tooltip="`Export to PDF`"
          @click.prevent="exportLessonsToPdf"
          class="btn btn-md mr-1 exportBtns text-light">
          <i class="far fa-file-pdf"></i>
        </button>
        <button
          v-tooltip="`Export to Excel`"
          @click.prevent="exportLessonsToExcel('table', 'Portfolio Lessons')"
          class="btn btn-md mr-3 exportBtns text-light">
        <i class="far fa-file-excel"></i>
        </button>
        <button class="btn text-light btn-md mh-orange profile-btns">RESULTS: {{ lessonsObj.length}}</button>
        </span>                   
                
      
       <div class="xTable" style="overflow-x:auto;">
          <table class="table table-sm mt-3 stickyTableHeader table-bordered" ref="lessonTable" id="portLessons">
           
            <thead style="background-color:#ededed;">
              <th class="sort-th twenty" @click="sortL('program_name')">Program Name
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'program_name'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'program_name'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'program_name'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'program_name'">
                 <i class="fas fa-sort-down"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'program_name'">
                 <i class="fas fa-sort-down"></i></span>
              </th>
              <th class="sort-th twenty" @click="sortL('project_name')">Project Name
                <span class="inactive-sort-icon scroll" v-if="currentSort !== ''">
                 <i class="fas fa-sort"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'project_name'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'project_name'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'project_name'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'project_name'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
              <th class="pl-1 sort-th" @click="sortL('title')">Lessons Learned
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'title'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'title'">
                 <i class="fas fa-sort-up"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'title'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'title'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'title'">
                 <i class="fas fa-sort-down"></i></span>
              </th>
              <th class="pl-1 sort-th"  style="min-width:325px" @click="sortL('description')">Description
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'description'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'description'">
                 <i class="fas fa-sort-up"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'description'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'description'">
                 <i class="fas fa-sort-down"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'description'">
                 <i class="fas fa-sort-down"></i></span>
              </th>
              <!-- <th class="sort-th p-1">
                 <span class="py-2 d-inline-block">Assigned Users</span>
              </th> -->
              <th class="sort-th" @click="sortL('added_by')">Added By
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'added_by'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'added_by'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'added_by'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'added_by'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'added_by'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
              <th class="sort-th" @click="sortL('created_at')">Date Added
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'created_at'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'created_at'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'created_at'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'created_at'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'created_at'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
              <th style="min-width:200px">
                Flags
              </th>  
                 <th class="sort-th" style="min-width:300px" @click="sort('notes_updated_at')">Last Update
                 <span class="inactive-sort-icon scroll" v-if="currentSort !== 'notes_updated_at'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'notes_updated_at'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'notes_updated_at'">
                 <i class="fas fa-sort-up"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'notes_updated_at'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'notes_updated_at'">
                 <i class="fas fa-sort-down"></i></span>

              </th>            
            </thead>
         <tbody>
        <tr v-for="lesson, index in sortedLessons" :key="index">
        <td>{{ lesson.program_name }}</td>
        <td>{{ lesson.project_name }}</td>
        <td>{{ lesson.title }}</td>
         <td>{{ lesson.description }}</td>      
        <td> {{ lesson.added_by }} </td>  
         <td> {{ moment(lesson.created_at).format('DD MMM YYYY') }} </td>  
         <td class="text-center">
        
            <span v-if="lesson.ongoing == true" v-tooltip="`Ongoing`"><i class="far fa-retweet text-success"></i></span>   
            <span v-if="lesson.on_hold == true" v-tooltip="`On Hold`"> <i class="fas fa-pause-circle mr-1 text-primary"></i></span>   
            <span v-if="lesson.draft == true" v-tooltip="`Draft`"> <i class="fas fa-pencil-alt text-warning"></i></span>   
            <span v-if="lesson.watched == true"  v-tooltip="`On Watch`"><i class="fas fa-eye mr-1"></i></span>
            <span v-if="lesson.important == true"  v-tooltip="`Important`"> <i class="fas fa-star text-warning mr-1"></i></span>
            <span v-if="lesson.reportable" v-tooltip="`Briefings`"> <i class="fas fa-presentation mr-1 text-primary"></i></span>
            
            <span v-if="
                      lesson.important == false &&
                      lesson.reportable == false &&
                      lesson.watched == false &&
                      lesson.ongoing == false && 
               
                      lesson.onHold == false &&  
                      lesson.draft == false "             
                    >
                  No flags at this time         
              </span>              
          </td>
             <td class="text-left" v-if="(lesson.notes_updated_at.length) > 0">
           <span class="toolTip" v-tooltip="('By: ' + lesson.notes[lesson.notes.length - 1].user.full_name)">              
          {{moment(lesson.notes_updated_at[0]).format('DD MMM YYYY, h:mm a')}}
            </span>
            <br> 
            <span>
              {{lesson.notes[lesson.notes.length - 1].body}}
            </span>
           
        </td>       
        <!-- <td v-else class="twentyTwo">No Updates</td> -->
        <td  class="text-left" v-else>No Update</td>
     
        <!-- <td> {{ lesson.progress }} </td> -->
  
       
        </tr>
        </tbody>
        </table> 
          
       
        </div>
           <div class="ml-auto mb-4 mt-2 font-sm">
           <div class="simple-select d-inline-block text-right font-sm">
           <span class="mr-1">Displaying </span>
            <el-select
            v-model="C_lessonsPerPage"
            class="w-33"
            track-by="value"
            value-key="id"
            >
            <el-option
              v-for="item in getLessonsPerPageFilterOptions"
              :value="item"
              :key="item.id"
              :label="item.name"
              >
            </el-option>
            </el-select>
           </div> 
          <span class="mr-1 pr-3" style="border-right:solid 1px lightgray">Per Page </span>
            <button class="btn btn-sm page-btns" @click="prevLessonsPage"><i class="fas fa-angle-left"></i></button>
            <button class="btn btn-sm page-btns" id="page-count"> {{ currentLessonsPage }} of {{ Math.ceil(this.lessonsObj.length / this.C_lessonsPerPage.value) }} </button>
            <button class="btn btn-sm page-btns" @click="nextLessonsPage"><i class="fas fa-angle-right"></i></button>
        </div>
      </div> 
       <div v-else class="mt-5">
        NO RESULTS TO DISPLAY
      </div>
        
      </el-tab-pane>
  
     </el-tabs>
    <div class="row pt-2">
    <div class="col-6 py-0 pl-0">      
    
       
          <!-- <el-popover
          placement="top-start"
          title="Project #"
          width="200"
          trigger="hover"
          content="This is the total number of programs in your portfolio.">
        <b class="badge bg-secondary text-light badge-pill" slot="reference"> </b>
        </el-popover> -->

    
  </div>
   </div>

   

 </el-tab-pane> 
   <el-tab-pane disabled  label="PORTFOLIO ANALYTICS (Coming Soon)" class="p-3">
    
   </el-tab-pane>
    </el-tabs>

 <div class="mhLogo"> <img class="mb-2" style="width:125px" :src="require('../../../../assets/images/microhealthllc.png')" /></div>
</div>
</template>

<script>
import Loader from "../../shared/loader.vue";
import {jsPDF} from "jspdf"
import 'jspdf-autotable'
import moment from "moment";
Vue.prototype.moment = moment;
import { mapGetters, mapActions, mapMutations } from "vuex";
export default {
  name: "PortfolioView",
  props: ["from"],
  components: {
    Loader,
    },
  data() {
    return {
      showLess: "Show More",
      currentSort:'program_name',
      currentSortDir:'asc',
      currentPage:1,
      // selectedProgram: this.C_programNameFilter,
      currentIssuesPage:1,
      currentRisksPage:1,
      currentLessonsPage:1,

      loadIssues: false,
      loadRisks: false,
      loadLessons: false,


      // 3 Tags for Tasks
      hideWatchedTasks:false, 
      hideImportantTasks:false, 
      hideBriefedTasks:false, 

      // 7 Action States for Tasks
      hideDraftTasks:false,
      hideCompleteTasks:false, 
      hideInprogressTasks:false, 
      hideOverdueTasks:false, 
      hideOngoingTasks:false, 
      hidePlannedTasks:false, 
      hideOnholdTasks:false, 

      // 3 Tags for Issues
      hideWatchedIssues:false, 
      hideImportantIssues:false, 
      hideBriefedIssues:false, 

      // 7 Action States for Issues
      hideDraftIssues:false,
      hideCompleteIssues:false, 
      hideInprogressIssues:false, 
      hideOverdueIssues:false, 
      hideOngoingIssues:false, 
      hidePlannedIssues:false, 
      hideOnholdIssues:false, 

        // 3 Tags for Risks
      hideWatchedRisks:false, 
      hideImportantRisks:false, 
      hideBriefedRisks:false, 

      // 7 Action States for Issues
      hideDraftRisks:false,
      hideCompleteRisks:false, 
      hideInprogressRisks:false, 
      hideOverdueRisks:false, 
      hideOngoingRisks:false, 
      hidePlannedRisks:false, 
      hideOnholdRisks:false, 


         // 3 Tags for Lessons
      hideWatchedLessons:false, 
      hideImportantLessons:false, 
      hideBriefedLessons:false, 

      // Action States for Lessons
      hideDraftLessons:false,
      hideCompleteLessons:false, 
      hideInprogressLessons:false,      
      // hideOngoingIssues:false, 
      // hidePlannedLessons:false, 
      // hideOnholdLessons:false, 

      programId: null, 
      programName: null, 
      page: 1,
      pageSize: 10,
      showMore: true,
      today: new Date().toISOString().slice(0, 10),

      uri :'data:application/vnd.ms-excel;base64,',
      template:'<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="https://www.w3.org/TR/2018/SPSD-html401-20180327/"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
      base64: function(s){ return window.btoa(unescape(encodeURIComponent(s))) },
      format: function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) }
    };
  },
   mounted() {    
        this.fetchPortfolioPrograms()
        this.fetchPortfolioTasks()
        this.fetchPortfolioIssues()
        this.fetchPortfolioRisks()
        this.fetchPortfolioLessons()
   },
  computed: {
    ...mapGetters([
      'getPortfolioWatchedTasksToggle', 
      'getPortfolioBriefedTasksToggle',
      'getTasksPerPageFilterOptions',
      'getIssuesPerPageFilterOptions',
      'getRisksPerPageFilterOptions',
      'getLessonsPerPageFilterOptions',
      'getPortfolioImportantTasksToggle', 
      'getTasksPerPageFilter',    
      'getIssuesPerPageFilter',  
      'getRisksPerPageFilter', 
      'getLessonsPerPageFilter', 
      'programNameFilter',
      'taskTypes',
      'portfolioTasks',
      'portfolioIssues',
      'portfolioRisks', 
      'portfolioLessons',
      'portfolioPrograms',    
    ]),
   sortedTasks:function() {
          return this.tasksObj.sort((a,b) => {
          let modifier = 1;
          if(this.currentSortDir === 'desc') modifier = -1;
          if(a[this.currentSort] < b[this.currentSort]) return -1 * modifier;
          if(a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
          return 0;
           }).filter((row, index) => {
          let start = (this.currentPage-1)*this.C_tasksPerPage.value;
          let end = this.currentPage*this.C_tasksPerPage.value;
          if(index >= start && index < end) return true;
          return this.end
        });
    },
    sortedIssues:function() {
          return this.issuesObj.sort((a,b) => {
          let modifier = 1;
          if(this.currentSortDir === 'desc') modifier = -1;
          if(a[this.currentSort] < b[this.currentSort]) return -1 * modifier;
          if(a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
          return 0;
           }).filter((row, index) => {
          let start = (this.currentIssuesPage-1)*this.C_issuesPerPage.value;
          let end = this.currentIssuesPage*this.C_issuesPerPage.value;
          if(index >= start && index < end) return true;
          return this.end
        });
    },
   sortedRisks:function() {
          return this.risksObj.sort((a,b) => {
          let modifier = 1;
          if(this.currentSortDir === 'desc') modifier = -1;
          if(a[this.currentSort] < b[this.currentSort]) return -1 * modifier;
          if(a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
          return 0;
           }).filter((row, index) => {
          let start = (this.currentRisksPage-1)*this.C_risksPerPage.value;
          let end = this.currentRisksPage*this.C_risksPerPage.value;
          if(index >= start && index < end) return true;
          return this.end
        });
    },
     sortedLessons:function() {
          return this.lessonsObj.sort((a,b) => {
          let modifier = 1;
          if(this.currentSortDir === 'desc') modifier = -1;
          if(a[this.currentSort] < b[this.currentSort]) return -1 * modifier;
          if(a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
          return 0;
           }).filter((row, index) => {
          let start = (this.currentLessonsPage-1)*this.C_lessonsPerPage.value;
          let end = this.currentLessonsPage*this.C_lessonsPerPage.value;
          if(index >= start && index < end) return true;
          return this.end
        });
    },
    tasksObj(){
      return this.portfolioTasks.filter(task => { 
         if (this.C_programNameFilter.length > 0) {
          let programNames = this.C_programNameFilter.map((program) => program.name);
          return programNames.includes(task.program_name);
        } else return true;   
         // Filtering 7 Task States        
        if (this.hideDraftTasks) {
          return !task.draft
        } else return true        
      }).filter(task => {
         if (this.hideOnholdTasks) {
          return !task.on_hold
        } else return true

      }).filter(task => {
         if (this.hideOngoingTasks) {
          return !task.ongoing
        } else return true

      }).filter(task => {
         if (this.hideInprogressTasks) {
          return task.progress < 100 && task.start_date <= this.today 
        } else return true

      }).filter(task => {
         if (this.hideOverdueTasks) {
          return !task.is_overdue
        } else return true

      }).filter(task => {
         if (this.hideCompleteTasks) {
          return task.progress < 100
        } else return true
      // Filtering 3 Task Tags
      }).filter(task => {
         if (this.hideBriefedTasks && !this.hideWatchedTasks && !this.hideImportantTasks ) {
          return task.reportable
        }
        if (this.hideBriefedTasks && this.hideWatchedTasks && !this.hideImportantTasks) {          
           return task.reportable + task.watched

        } if (this.hideBriefedTasks && this.hideWatchedTasks && this.hideImportantTasks) {          
           return task.reportable + task.watched + task.important
        } else return true

      }).filter(task => {
        // This and last 2 filters are for Filtered Tags
         if (this.hideWatchedTasks  && !this.hideBriefedTasks && !this.hideImportantTasks) {
           return task.watched
        } if (this.hideWatchedTasks && this.hideBriefedTasks && !this.hideImportantTasks) {          
           return  task.watched + task.reportable
        } if (this.hideWatchedTasks && this.hideBriefedTasks && this.hideImportantTasks) {          
           return  task.watched + task.reportable + task.important
        } else return true          
       
      }).filter(task => {
         if (this.hideImportantTasks && !this.hideBriefedTasks && !this.hideWatchedTask) {
          return task.important
        } if (this.hideImportantTasks && this.hideBriefedTasks && !this.hideWatchedTask) {
          return task.important + task.reportable
       } if (this.hideImportantTasks && this.hideBriefedTasks && this.hideWatchedTask) {
          return task.important + task.reportable + task.watched
        } else return true          
        
     
      })
    }, 
    issuesObj(){     
      return this.portfolioIssues.filter(issue => {    
      if (this.C_programNameFilter.length > 0) {
          let programNames = this.C_programNameFilter.map((program) => program.name);
          return programNames.includes(issue.program_name);
        } else return true;   
     }).filter(issue => {
        if (this.hideDraftIssues) {
          return !issue.draft
        } else return true
        
      }).filter(issue => {
         if (this.hideOnholdIssues) {
          return !issue.on_hold
        } else return true
   
      }).filter(issue => {
         if (this.hideOverdueIssues) {
          return !issue.is_overdue
        } else return true

      }).filter(issue => {
         if (this.hideCompleteIssues) {
          return issue.progress < 100
        } else return true

      }).filter(issue => {
         if (this.hideInprogressIssues) {
          return issue.progress < 100 && issue.start_date <= this.today
        } else return true
    // Filtering 3 Issues Tags

      }).filter(issue => {
         if (this.hideBriefedIssues && !this.hideWatchedIssues && !this.hideImportantIssues ) {
          return issue.reportable
        }
        if (this.hideBriefedIssues && this.hideWatchedIssues && !this.hideImportantIssues) {          
           return issue.reportable + issue.watched

        } if (this.hideBriefedIssues && this.hideWatchedIssues && this.hideImportantIssues) {          
           return issue.reportable + issue.watched + issue.important
        } else return true   

      }).filter(issue => {
         if (this.hideWatchedIssues && !this.hideBriefedIssues && !this.hideImportantIssues) {
           return issue.watched
        } if (this.hideWatchedIssues && this.hideImportantIssues && !this.hideBriefedIssues ) {          
           return issue.important + issue.watched
       } if (this.hideWatchedIssues && this.hideImportantIssues && this.hideBriefedIssues ) {          
           return issue.important + issue.watched + issue.reportable
        } else return true    
       
      }).filter(issue => {
         if (this.hideImportantIssues && !this.hideBriefedIssues && !this.hideWatchedIssues) {
          return issue.important
        } if (this.hideImportantIssues && this.hideBriefedIssues  && !this.hideWatchedIssues) {
          return issue.important + issue.reportable
         } if (this.hideImportantIssues && this.hideBriefedIssues  && this.hideWatchedIssues) {
          return issue.important + issue.reportable + issue.watched
        } else return true   
        })
    }, 
     risksObj(){     
      return this.portfolioRisks.filter(risk => { 
     let programName = this.C_programNameFilter.map(t => t.name)
        if (programName.length > 1) {
          if (programName.includes(risk.program_name)) {
            return risk
          }
        } else if (programName.length == 1) {
          return risk.program_name.includes(programName)
        } else return true
     }).filter(risk => {       
        if (this.hideDraftRisks) {
          return !risk.draft
        } else return true
        
      }).filter(risk => {
         if (this.hideOnholdRisks) {
          return !risk.on_hold
        } else return true    

     }).filter(risk => {
         if (this.hideInprogressRisks) {
          return risk.progress < 100 && risk.start_date <= this.today 
        } else return true

      }).filter(risk => {
         if (this.hideOverdueRisks) {
          return !risk.is_overdue
        } else return true

      }).filter(risk => {
         if (this.hideOngoingRisks) {
          return !risk.ongoing
        } else return true

      }).filter(risk => {
         if (this.hideCompleteRisks) {
          return risk.progress < 100
        } else return true

      }).filter(risk => {
         if (this.hideInprogressRisks) {
          return risk.progress < 100 && risk.start_date <= this.today
        } else return true

    // Filtering 3 Risks Tags
    }).filter(risk => {
         if (this.hideBriefedRisks && !this.hideWatchedRisks && !this.hideImportantRisks ) {
          return risk.reportable
        }
        if (this.hideBriefedRisks && this.hideWatchedRisks && !this.hideImportantRisks) {          
           return risk.reportable + risk.watched

        } if (this.hideBriefedRisks && this.hideWatchedRisks && this.hideImportantRisks) {          
           return risk.reportable + risk.watched + risk.important
        } else return true   

      }).filter(risk => {
         if (this.hideWatchedRisks && !this.hideBriefedRisks && !this.hideImportantRisks) {
           return risk.watched
        } if (this.hideWatchedRisks && this.hideImportantRisks && !this.hideBriefedRisks ) {          
           return risk.important + risk.watched
       } if (this.hideWatchedRisks && this.hideImportantRisks && this.hideBriefedRisks ) {          
           return risk.important + risk.watched + risk.reportable
        } else return true    
       
      }).filter(risk => {
         if (this.hideImportantRisks && !this.hideBriefedRisks && !this.hideWatchedRisks) {
          return risk.important
        } if (this.hideImportantRisks && this.hideBriefedRisks  && !this.hideWatchedRisks) {
          return risk.important + risk.reportable
         } if (this.hideImportantRisks && this.hideBriefedRisks && this.hideWatchedRisks) {
          return risk.important + risk.reportable + risk.watched
        } else return true   

       })
    }, 
    lessonsObj(){      
      return this.portfolioLessons.filter(lesson => {
     let programName = this.C_programNameFilter.map(t => t.name)
        if (programName.length > 1) {
          if (programName.includes(lesson.program_name)) {
            return lesson
          }
        } else if (programName.length == 1) {
          return lesson.program_name.includes(programName)
        } else return true
     }).filter(lesson => {
        // Filtering 3 Lesson States        
        if (this.hideDraftLessons) {
          return !lesson.draft
        } else return true

      }).filter(lesson => {
         if (this.hideInprogressLessons) {
          return lesson.progress < 100 && lesson.start_date <= this.today 
        } else return true

   
      }).filter(lesson => {
         if (this.hideCompleteLessons) {
          return lesson.progress < 100
        } else return true



      // Filtering 3 Task Tags
      }).filter(lesson => {
         if (this.hideBriefedLessons && !this.hideWatchedLessons && !this.hideImportantLessons ) {
          return lesson.reportable
        }
        if (this.hideBriefedLessons && this.hideWatchedLessons && !this.hideImportantLessons) {          
           return lesson.reportable + lesson.watched

        } if (this.hideBriefedLessons && this.hideWatchedLessons && this.hideImportantLessons) {          
           return lesson.reportable + lesson.watched + lesson.important
        } else return true

      }).filter(lesson => {
        // This and last 2 filters are for Filtered Tags
         if (this.hideWatchedLessons  && !this.hideBriefedLessons && !this.hideImportantLessons) {
           return lesson.watched
        } if (this.hideWatchedLessons && this.hideBriefedLessons && !this.hideImportantLessons) {          
           return lesson.watched +lesson.reportable
        } if (this.hideWatchedLessons && this.hideBriefedLessons && this.hideImportantLessons) {          
           return  lesson.watched + lesson.reportable + lesson.important
        } else return true          
       
      }).filter(lesson => {
         if (this.hideImportantLessons && !this.hideBriefedLessons && !this.hideWatchedLessons) {
          return lesson.important
        } if (this.hideImportantLessons && this.hideBriefedLessons && !this.hideWatchedLessons) {
          return lesson.important + lesson.reportable
       } if (this.hideImportantLessons && this.hideBriefedLessons && this.hideWatchedLessons) {
          return lesson.important + lesson.reportable + lesson.watched
        } else return true          
            
      })
    }, 
    taskVariation() {
      let planned = _.filter(
        this.tasksObj,
        (t) => t && t.draft == false && t.start_date && t.start_date > this.today 
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let taskDrafts = _.filter(
     this.tasksObj,
        (t) => t && t.draft == true
      );  
      let important = _.filter(
     this.tasksObj,
        (t) => t && t.important == true
      ); 
        let briefings = _.filter(
       this.tasksObj,
        (t) => t && t.reportable == true
      );
      let watched = _.filter(
     this.tasksObj,
        (t) => t && t.watched == true
      );
              
      let completed = _.filter(
      this.tasksObj,
        (t) => t && t.progress && t.progress == 100 
      );
      let inProgress = _.filter(
     this.tasksObj,
        (t) => t && t.progress < 100 && t.start_date <= this.today 
      );
     let onHoldT = _.filter(this.tasksObj, (t) => t && t.on_hold == true );
     let ongoing = _.filter(this.tasksObj, (t) => t && t.ongoing == true );
     let overdue = _.filter(this.tasksObj, (t) => t.is_overdue == true);

      return {
        planned: {
          count: planned.length, 
          plannedTs: planned            
        },
        important: {
          count: important.length,             
        },
        briefings: {
          count: briefings.length,          
        },
        watched: {
          count: watched.length,          
        },
        onHoldT: {
          count: onHoldT.length,          
        },
        taskDrafts: {
          count: taskDrafts.length,          
        },
        completed: {
          count: completed.length,
          // percentage: Math.round(completed_percent),
        },      
        inProgress: {
          count: inProgress.length - planned.length,
          // percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          // percentage: Math.round(overdue_percent),
        },
        ongoing: {
          count: ongoing.length
        },     
      };
    },
     issueVariation() {
      let planned = _.filter(
      this.issuesObj,
        (t) => t && t.draft == false && t.start_date && t.start_date > this.today 
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let issueDrafts = _.filter(
        this.issuesObj,
        (t) => t && t.draft == true
      );      
      let completed = _.filter(
        this.issuesObj,
        (t) => t && t.progress && t.progress == 100 
      );
      let inProgress = _.filter(
         this.issuesObj,
        (t) => t && t.progress < 100 && t.start_date <= this.today 
      );
     let onHoldI = _.filter(this.issuesObj, (t) => t && t.on_hold == true );
     let overdue = _.filter(this.issuesObj, (t) => t && t.is_overdue == true);
     let important = _.filter(
          this.issuesObj,
        (t) => t && t.important == true
      ); 
      let briefings = _.filter(
         this.issuesObj,
        (t) => t && t.reportable == true
      );
      let watched = _.filter(
         this.issuesObj,
        (t) => t && t.watched == true
      );
    
      return {
        planned: {
          count: planned.length, 
          plannedTs: planned            
        },
        onHoldI: {
          count: onHoldI.length,          
        },
        issueDrafts: {
          count: issueDrafts.length,          
        },     
        important: {
          count: important.length,          
        },
        briefings: {
          count: briefings.length,          
        },
        watched: {
          count: watched.length,          
        },        
        completed: {
          count: completed.length,
          // percentage: Math.round(completed_percent),
        },      
        inProgress: {
          count: inProgress.length - planned.length,
          // percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          // percentage: Math.round(overdue_percent),
        },
       };
    },
    filterOutWatched(){
      return _.filter(this.tasksObj, (t) => t && t.watched == false );
    },
    riskVariation() {
      let planned = _.filter(
         this.risksObj,
        (t) => t && t.draft == false && t.start_date && t.start_date > this.today 
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let riskDrafts = _.filter(
      this.risksObj,
        (t) => t && t.draft == true
      );      
     let important = _.filter(
      this.risksObj,
        (t) => t && t.important == true
      ); 
        let briefings = _.filter(
        this.risksObj,
        (t) => t && t.reportable == true
      );
      let watched = _.filter(
     this.risksObj,
        (t) => t && t.watched == true
      );
      let completed = _.filter(
       this.risksObj,
        (t) => t && t.progress && t.progress == 100 
      );
      let inProgress = _.filter(
       this.risksObj,
        (t) => t && t.progress < 100 && t.start_date <= this.today 
      );
     let onHoldR = _.filter(this.risksObj, (t) => t && t.on_hold == true );
     let ongoing = _.filter(this.risksObj, (t) => t && t.ongoing == true );
     let overdue = _.filter(this.risksObj, (t) => t && t.is_overdue == true);
      return {
        planned: {
          count: planned.length, 
          plannedTs: planned            
        },
        important: {
          count: important.length,             
        },
        briefings: {
          count: briefings.length,          
        },
        watched: {
          count: watched.length,          
        },
        onHoldR: {
          count: onHoldR.length,          
        },
        riskDrafts: {
          count: riskDrafts.length,          
        },
        completed: {
          count: completed.length,
          // percentage: Math.round(completed_percent),
        },      
        inProgress: {
          count: inProgress.length - planned.length,
          // percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          // percentage: Math.round(overdue_percent),
        },
        ongoing: {
          count: ongoing.length
        },     
      };
    },
     lessonVariation() {
      let planned = _.filter(
         this.lessonsObj,
        (t) => t && t.draft == false && t.start_date && t.start_date > this.today 
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let lessonDrafts = _.filter(
        this.lessonsObj,
        (t) => t && t.draft == true
      );      
     let important = _.filter(
       this.lessonsObj,
        (t) => t && t.important == true
      ); 
        let briefings = _.filter(
        this.lessonsObj,
        (t) => t && t.reportable == true
      );
      let watched = _.filter(
        this.lessonsObj,
        (t) => t && t.watched == true
      );
      let completed = _.filter(
        this.lessonsObj,
        (t) => t && t.progress && t.progress == 100 
      );
      let inProgress = _.filter(
        this.lessonsObj,
        (t) => t && t.progress < 100 && t.start_date <= this.today 
      );
         return {
        planned: {
          count: planned.length, 
          plannedTs: planned            
        },
        important: {
          count: important.length,             
        },
        briefings: {
          count: briefings.length,          
        },
        watched: {
          count: watched.length,          
        },
     
        lessonDrafts: {
          count: lessonDrafts.length,          
        },
        completed: {
          count: completed.length,
          // percentage: Math.round(completed_percent),
        },      
        inProgress: {
          count: inProgress.length - planned.length,
          // percentage: Math.round(inProgress_percent),
        },
      
      };
    },
    C_programNames() {     
      return this.portfolioPrograms
     },
    C_programIssuesNameFilter: {
      get() {
        return this.programNameFilter
      },
      set(value) {
        // console.log(value)
        this.setProgramNameFilter(value)
      }
    },
    C_programNameFilter: {
      get() {
        return this.programNameFilter
      },
      set(value) {
        // console.log(value)
        this.setProgramNameFilter(value)
      }
    },
     C_hideWatchedTasks: {                  
        get() {       
         return this.getPortfolioWatchedTasksToggle                 
        },
        set() {        
         this.setPortfolioWatchedTasksToggle(!this.getPortfolioWatchedTasksToggle)
        }        
      },
      C_hideImportantTasks: {                  
      get() {       
        return this.getPortfolioImportantTasksToggle                 
      },
      set() {        
        this.setPortfolioImportantTasksToggle(!this.getPortfolioImportantTasksToggle)
      }
      
    },
    C_issuesPerPage: {
      get() {
        return this.getIssuesPerPageFilter || {id: 15, name: '15', value: 15}
      },
      set(value) {
        this.setIssuesPerPageFilter(value)
       }
     },
    C_tasksPerPage: {
      get() {
        return this.getTasksPerPageFilter || {id: 15, name: '15', value: 15}
      },
      set(value) {
        this.setTasksPerPageFilter(value)
       }
     },
    C_risksPerPage: {
      get() {
        return this.getRisksPerPageFilter || {id: 15, name: '15', value: 15}
      },
      set(value) {
        this.setRisksPerPageFilter(value)
       }
     },
      C_lessonsPerPage: {
      get() {
        return this.getLessonsPerPageFilter || {id: 15, name: '15', value: 15}
      },
      set(value) {
        this.setLessonsPerPageFilter(value)
       }
     },
     C_hideBriefedTasks: {                  
      get() {       
        return this.getPortfolioBriefedTasksToggle                 
      },
      set() {        
        this.setPortfolioBriefedTasksToggle(!this.getPortfolioBriefedTasksToggle)
      }
      
    },
  },
  methods: {  
   ...mapMutations([
    'setPortfolioWatchedTasksToggle',
    'setTasksPerPageFilter',
    'setIssuesPerPageFilter',
    'setRisksPerPageFilter',
    'setLessonsPerPageFilter',
    'setPortfolioBriefedTasksToggle',
    'setPortfolioImportantTasksToggle',
    'setProgramNameFilter'
     ]),
   ...mapActions([
      'fetchPortfolioTasks',
      'fetchPortfolioIssues',
      'fetchPortfolioRisks',
      'fetchPortfolioLessons',
      'fetchPortfolioPrograms'

     ]),     
      sort:function(s) {
      //if s == current sort, reverse
      if(s === this.currentSort) {
        this.currentSortDir = this.currentSortDir==='asc'?'desc':'asc';
      }
        this.currentSort = s;
      },
      nextPage:function() {
        if((this.currentPage*this.C_tasksPerPage.value) < this.tasksObj.length) this.currentPage++;
      },
      prevPage:function() {
        if(this.currentPage > 1) this.currentPage--;
      },
      sortI:function(s) {
      //if s == current sort, reverse
      if(s === this.currentSort) {
        this.currentSortDir = this.currentSortDir==='asc'?'desc':'asc';
      }
        this.currentSort = s;
      },
      nextIssuesPage:function() {
        if((this.currentIssuesPage*this.C_issuesPerPage.value) < this.issuesObj.length) this.currentIssuesPage++;
      },
      prevIssuesPage:function() {
        if(this.currentIssuesPage > 1) this.currentIssuesPage--;
      },
      sortR:function(s) {
      //if s == current sort, reverse
      if(s === this.currentSort) {
        this.currentSortDir = this.currentSortDir==='asc'?'desc':'asc';
      }
        this.currentSort = s;
      },
      nextRisksPage:function() {
        if((this.currentRisksPage*this.C_risksPerPage.value) < this.risksObj.length) this.currentRisksPage++;
      },
      prevRisksPage:function() {
        if(this.currentRisksPage > 1) this.currentRisksPage--;
      },
     sortL:function(s) {
      //if s == current sort, reverse
      if(s === this.currentSort) {
        this.currentSortDir = this.currentSortDir==='asc'?'desc':'asc';
      }
        this.currentSort = s;
      },
      nextLessonsPage:function() {
        if((this.currentLessonsPage*this.C_lessonsPerPage.value) < this.lessonsObj.length) this.currentLessonsPage++;
      },
      prevLessonsPage:function() {
        if(this.currentLessonsPage > 1) this.currentLessonsPage--;
      },
      exportTasksToPdf() {
        const doc = new jsPDF("l")
        const html =  this.$refs.table.innerHTML
        doc.autoTable({html: "#portTasks"})
        doc.save("Portfolio_Task_List.pdf")
      },
      exportTasksToExcel(table, name){
        if (!table.nodeType) table = this.$refs.table
        var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML}
        window.location.href = this.uri + this.base64(this.format(this.template, ctx))
      },
      exportIssuesToPdf() {
        const doc = new jsPDF("l")
        const html =  this.$refs.table.innerHTML
        doc.autoTable({html: "#portIssues"})
        doc.save("Portfolio_Issues_Log.pdf")
      },
      exportIssuesToExcel(issueTable, name){
        if (!issueTable.nodeType) issueTable = this.$refs.issueTable
        var ctx = {worksheet: name || 'Worksheet', table: issueTable.innerHTML}
        window.location.href = this.uri + this.base64(this.format(this.template, ctx))
      },
      exportRisksToPdf() {
        const doc = new jsPDF("l")
        const html =  this.$refs.table.innerHTML
        doc.autoTable({html: "#portRisks"})
        doc.save("Portfolio_Risk_List.pdf")
      },
      exportRisksToExcel(riskTable, name){
        if (!riskTable.nodeType) riskTable = this.$refs.riskTable
        var ctx = {worksheet: name || 'Worksheet', table: riskTable.innerHTML}
        window.location.href = this.uri + this.base64(this.format(this.template, ctx))
      },
      exportLessonsToPdf() {
        const doc = new jsPDF("l")
        const html =  this.$refs.table.innerHTML
        doc.autoTable({html: "#portLessons"})
        doc.save("Portfolio_Lessons_List.pdf")
      },
      exportLessonsToExcel(lessonTable, name){
        if (!lessonTable.nodeType) lessonTable = this.$refs.lessonTable
        var ctx = {worksheet: name || 'Worksheet', table: lessonTable.innerHTML}
        window.location.href = this.uri + this.base64(this.format(this.template, ctx))
      },
    log(e){
      //  console.log("" + e)
    }, 
  // Toggle for 3 Action Tags
    toggleWatched(){
        this.hideWatchedTasks = !this.hideWatchedTasks
    },
    toggleBriefing(){
        this.hideBriefedTasks = !this.hideBriefedTasks
    },
    toggleImportant(){
        this.hideImportantTasks = !this.hideImportantTasks
    },
// Toggle for 7 Action States
    toggleComplete(){
        this.hideCompleteTasks = !this.hideCompleteTasks
    },
    toggleInprogress(){
        this.hideInprogressTasks = !this.hideInprogressTasks
    },
    toggleOverdue(){
        this.hideOverdueTasks = !this.hideOverdueTasks
    },
    toggleOngoing(){
        this.hideOngoingTasks = !this.hideOngoingTasks
    },
    toggleDraft(){
        this.hideDraftTasks = !this.hideDraftTasks
    },  
    togglePlanned(){
        this.hidePlannedTasks = !this.hidePlannedTasks
    },  
    toggleOnhold(){
        this.hideOnholdTasks = !this.hideOnholdTasks
    },
    toggleOverdue(){
      this.hideOverdueTasks = !this.hideOverdueTasks
    },

    // For ISSUES
    // Toggle for 3 Action Tags
    toggleWatchedI(){
        this.hideWatchedIssues = !this.hideWatchedIssues
    },
    toggleBriefingI(){
        this.hideBriefedIssues = ! this.hideBriefedIssues
    },
    toggleImportantI(){
        this.hideImportantIssues = !this.hideImportantIssues
    },
// Toggle for 7 Action States
    toggleCompleteI(){
        this.hideCompleteIssues = !this.hideCompleteIssues
    },
    toggleInprogressI(){
        this.hideInprogressIssues = !this.hideInprogressIssues
    },
    toggleOverdueI(){
        this.hideOverdueIssues = !this.hideOverdueIssues
    },
    toggleDraftI(){
        this.hideDraftIssues = !this.hideDraftIssues
    },  
    togglePlannedI(){
        this.hidePlannedIssues = !this.hidePlannedIssues
    },  
    toggleOnholdI(){
        this.hideOnholdIssues = !this.hideOnholdIssues
    },
    toggleOverdueI(){
      this.hideOverdueIssues = !this.hideOverdueIssues
    },


    // For RISKS
      // Toggle for 3 Action Tags
    toggleWatchedR(){
        this.hideWatchedRisks = !this.hideWatchedRisks
    },
    toggleBriefingR(){
        this.hideBriefedRisks = !this.hideBriefedRisks
    },
    toggleImportantR(){
        this.hideImportantRisks = !this.hideImportantRisks
    },
// Toggle for 7 Action States
    toggleCompleteR(){
        this.hideCompleteRisks = !this.hideCompleteRisks
    },
    toggleInprogressR(){
        this.hideInprogressRisks = !this.hideInprogressRisks
    },
    toggleOverdueR(){
        this.hideOverdueRisks = !this.hideOverdueRisks
    },
    toggleOngoingR(){
        this.hideOngoingRisks = !this.hideOngoingRisks
    },
    toggleDraftR(){
        this.hideDraftRisks = !this.hideDraftRisks
    },  
    togglePlannedR(){
        this.hidePlannedRisks = !this.hidePlannedRisks
    },  
    toggleOnholdR(){
        this.hideOnholdRisks = !this.hideOnholdRisks
    },
    toggleOverdueR(){
      this.hideOverdueRisks = !this.hideOverdueRisks
    },
    // For Lessons
      // Toggle for 3 Action Tags
    toggleWatchedL(){
        this.hideWatchedLessons = !this.hideWatchedLessons
    },
    toggleBriefingL(){
        this.hideBriefedLessons = !this.hideBriefedLessons
    },
    toggleImportantL(){
        this.hideImportantLessons = !this.hideImportantLessons
    },
// Toggle for 3 Lessons Action States
    toggleCompleteL(){
        this.hideCompleteLessons = !this.hideCompleteLessons
    },
    toggleInprogressL(){
        this.hideInprogressLessons = !this.hideInprogressLessons
    },
 
    toggleDraftL(){
        this.hideDraftLessons = !this.hideDraftLessons
    },
     setPage (val) {
      this.page = val
    },
    getProgramId(id){
      this.programId = id
      console.log(id)
    }, 
    closeWindow(){
     window.close()
    },  
    // handleClick(tab, event) {
    
    //     // console.log(tab._uid , event);
    // },
  
  },
   watch: {
    $route(to, from) {
      this.$store && this.$store.commit("nullifyTasksForManager");
    },
  },
};
</script>

<style scoped lang="scss">
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
ul > li {
  display: inline-block !important;
  /* You can also add some margins here to make it look prettier */
  zoom: 1;
  *display: inline;
  /* this fix is needed for IE7- */
}
.grey {
  background-color: lightgray;
}
.grey2 {
  background-color: #ededed;
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
.smallerFont {
  font-size: 10px;
}
.btn-info {
  box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
}

// /deep/.el-collapse-item__header, /deep/.el-collapse-item__wrap  {
//   border-bottom: none !important;
// }

// /deep/.el-card__body {
//     padding-bottom: 0 !important;
// }
// /deep/.el-collapse-item__header {
//   font-size: 2rem;
//   }

// /deep/.el-collapse-item__arrow, /deep/.el-icon-arrow-right {
//   display: none;
// }
.programName {
  font-variant: small-caps;
}
.giantNumber {
  font-size: 3.7rem;
}
.giantMapView {
  font-size: 3.25rem;
}
i, .icons {
  cursor: pointer;
  -webkit-touch-callout: none;
  -webkit-user-select: none;
  -khtml-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}
ul {
  margin-bottom: 0.5rem;
}

/deep/.el-table {
    padding-top: 0px;    
    width: 100%;
    margin-bottom: 6px;
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
    border-top: solid #ededed 1.8px;    
  }
/deep/.el-table {
  th {
    background-color: #ededed !important;
    text-align: center;     
    color: #383838;  
    }
  }

th {
  font-size: .8rem !important;
  }
.programNoBadge {
  box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
}
.tcard {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, .10);
}
.mhLogo {
  position: fixed;
  bottom: 1%;
  right: 1.5%;
  z-index: 10;
}
.tagsCol {
  border-radius: 4px;
  background-color: #f8f9fa;
  border: .5px solid lightgray;
}
.fa-times-circle {
  font-size: 1.40rem;
  font-weight: 400;
  transition: all .2s ease-in;
  // box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
  //   0 3px 3px rgba(56, 56, 56, 0.23);
}
.fa-times-circle:hover {
  transform: scale(1.25); 
}
.countBtn {
    box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
    position: absolute;
    right:1%;
}
.light {
  color: lightgray;
}
  table {
    position: relative;
    margin-bottom: 0 !important;
  }
  .stickyTableHeader {
    position: sticky;
    position: -webkit-sticky;
    z-index: 10;
    justify-content: center;
    left: 15;
    top: 0;
   }  
   .page-btns {
    width: 20px;
    line-height: 1 !important;
    border: none !important;
    height: 25px;
    margin-right: 1px;
    background-color: white;
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

 .ten {
   width: 10%;
 }

 .fifteen {
   width: 15%;
 }

 .twenty {
   width: 20%;
 }
.btnRow {
  position: relative;
}
.sort-th {
  min-width: 225px;
}
.profile-btns {
  box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23); 
  cursor: default;
}

.el-select-dropdown__item {
    font-size: 14px;
    display: block !important;
    padding: 0 20px;
    position: relative;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    color: #606266;
    height: 34px;
    line-height: 34px;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
    cursor: pointer;
}

.red1 {
  background-color: #d9534f;
}

.yellow1 {
  background-color: yellow;  
  color:#383838;  
  display: block;
}

.orange1 {
  background-color: #f0ad4e;
}

.green1 {
  background-color: rgb(92,184,92);
}  

.gray2 {
  background-color: #ededed;
}

.green1, .orange1, .red1, .yellow1, .gray2 {
  display: inline;   
  border-radius: 2px; 
  padding: 1px 1px;
  box-shadow: 0 1px 2.5px rgba(56,56, 56,0.19), 0 1.5px 1.5px rgba(56,56,56,0.23);
}
.green1, .orange1, .red1 {   
  color:#fff;   
}
</style>
