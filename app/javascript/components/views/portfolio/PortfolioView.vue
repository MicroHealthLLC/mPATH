<template>
<div class="container-fluid mt-3 mx-3">
  <!-- Actual Portfolio name will be dynamic value of organization name   -->
<div>
<span> <img class="mb-2" style="width:40px" :src="require('../../../../assets/images/mpathcircles.JPG')" /> 
<h3 class="d-inline mt-1 programName" >MicroHealth BO Portfolio</h3>
</span>
   <span class="float-right mr-4">
    <button style="cursor:pointer" @click.prevent="closeWindow">
      <i class="far fa-times-circle"></i>
    </button> 
   </span>
  </div>
  <el-tabs class="mt-1 mr-3 " type="border-card" @tab-click="handleClick">
  <el-tab-pane label="PORTFOLIO VIEWER" class="p-3" :load="log(filterOutWatched.length)">
     <el-tabs class="mt-1" type="border-card" @tab-click="handleClick">
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
                <label class="font-sm pb-1 mb-0">FILTER BY PROGRAM</label>
                <el-select                                  
                    class="w-100" 
                   
                    track-by="name" 
                    filterable
                    value-key="id"
                    multiple                                                                                                                                               
                    placeholder="Filter by Program"
                  >
                  <el-option                   
                     value="NEED DATA"                                                                             
                    >
                  </el-option>
                  </el-select> 
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
                    <i class="far fa-calendar" :class="[hideOverdueTasks == true ? 'light':'text-danger']"></i>
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
                <label class="font-sm mb-0 pb-1 d-block">FILTER DISPLAYED TASKS BY TAG</label>
                 <div class="pb-0 pl-2 mb-0 d-inline-flex">    
                  <div class="text-center icons" :class="[hideWatchedTasks == true ? 'light':'']" @click.prevent="toggleWatched"   >             
                 <span class="d-block">
                      <i class="fas fa-eye " ></i>
                 </span>                  
                  <span class="smallerFont">ON WATCH</span>
                   <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="watched" v-model="C_hideWatchedTasks">               -->
                   <h5 class="d-block">{{ taskVariation.watched.count }}</h5>  
                  </div>
                  <div class="px-5 text-center icons" :class="[hideImportantTasks == true ? 'light':'']" @click.prevent="toggleImportant"     >
                  <span class="d-block">
                      <i class="fas fa-star" :class="[hideImportantTasks == true ? 'light':'text-warning']"></i>
                  </span>     
                      <span class="smallerFont">IMPORTANT</span> 
                       <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="important" v-model="C_hideImportantTasks">     -->
                     <h5 class="d-block">{{ taskVariation.important.count }}</h5>  
                  </div>
                   <div class="text-center icons"  :class="[hideBriefedTasks == true ? 'light':'']" @click.prevent="toggleBriefing"         >
                      <span class="d-block">
                     <i class="fas fa-presentation" :class="[hideBriefedTasks == true ? 'light':'text-primary']"></i>
                  </span>     
                    <span class="smallerFont">BRIEFINGS </span> 
                      <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="briefed" v-model="C_hideBriefedTasks">   -->
                    <h5 class="d-block"> {{ taskVariation.briefings.count }}  </h5>    
                  </div>
               </div>
             </div>
              </div>

      <div class="row text-center mt-2" v-if="tasksObj !== null">            
            <span class="count mt-3"><button class="btn countBtn text-light btn-md mh-orange">RESULTS: {{ tasksObj.length}}</button></span>   
                
      
        <div data-cy="tasks_table">
          <table class="table table-sm mt-5 stickyTableHeader table-bordered">
           
            <thead style="background-color:#ededed;">
              <th class="sort-th" @click="sort('program_name')" >Program Name
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
              <th class="sort-th" @click="sort('project_name')">Project Name
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
              <th class="pl-1 sort-th" @click="sort('text')">Task
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
              <th class="sort-th p-1">
                 <span class="py-2 d-inline-block">Assigned Users</span>


              </th>
              <th class="sort-th" @click="sort('progress')">Progress
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
              <th class='non-sort-th'>Flags
               
              </th>
              <th class="sort-th" @click="sort('notesUpdatedAt')">Last Update
                 <span class="inactive-sort-icon scroll" v-if="currentSort !== 'notesUpdateAt'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'notesUpdatedAt'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'notesUpdatedAt'">
                 <i class="fas fa-sort-up"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'notesUpdatedAt'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'notesUpdatedAt'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
            </thead>
         <tbody>
        <tr v-for="task, index in sortedTasks" :key="index">
        <td>{{ task.program_name }}</td>
        <td>{{ task.project_name }}</td>
        <td>{{ task.text }}</td>
        <td>{{ task.category }}</td>
        <td> {{ task.users }} </td>   
        <td> {{ task.progress }} </td>
        <td class="text-center">
            <span v-if="task.watched == true"  v-tooltip="`On Watch`"><font-awesome-icon icon="eye" class="mr-1"  /></span>
            <span v-if="task.important == true"  v-tooltip="`Important`"> <i class="fas fa-star text-warning mr-1"></i></span>
            <span v-if="task.reportable" v-tooltip="`Briefings`"> <i class="fas fa-presentation mr-1 text-primary"></i></span>
            <span v-if="task.is_overdue" v-tooltip="`Overdue`"><font-awesome-icon icon="calendar" class="text-danger mr-1"  /></span>
            <span v-if="task.progress == 100" v-tooltip="`Completed`"><font-awesome-icon icon="clipboard-check" class="text-success"  /></span>   
            <span v-if="task.ongoing == true" v-tooltip="`Ongoing`"><i class="far fa-retweet text-success"></i></span>   
            <span v-if="task.on_hold == true" v-tooltip="`On Hold`"> <i class="fas fa-pause-circle mr-1 text-primary"></i></span>   
            <span v-if="task.draft == true" v-tooltip="`Draft`"> <i class="fas fa-pencil-alt text-warning"></i></span>   
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
        <td v-if="task.last_update !== null">{{task.last_update.body}}</td>
        <td v-else>No Update</td>
     
       
        </tr>
        </tbody>
        </table> 
          
          <div class="float-right mb-4 mt-2 font-sm">
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
               
     </el-tab-pane>
      <el-tab-pane class="px-3 pt-0">  
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
                    class="w-100"                    
                    track-by="name" 
                    filterable
                    value-key="id"
                    multiple                                                                                                                                               
                    placeholder="Filter by Program"
                  >
                  <el-option 
                    value="NEED DATA"                                                                              
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
                    <i class="far fa-calendar" :class="[hideOverdueIssues == true ? 'light':'text-danger']"></i>
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
                <label class="font-sm mb-0 pb-1 d-block">FILTER DISPLAYED ISSUES BY TAG</label>
                 <div class="pb-0 pl-2 mb-0 d-inline-flex">    
                  <div class="text-center icons" :class="[hideWatchedIssues == true ? 'light':'']" @click.prevent="toggleWatchedI"   >             
                 <span class="d-block">
                      <i class="fas fa-eye " ></i>
                 </span>                  
                  <span class="smallerFont">ON WATCH</span>
                   <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="watched" v-model="C_hideWatchedissues">               -->
                   <h5 class="d-block">{{ issueVariation.watched.count }}</h5>  
                  </div>
                  <div class="px-5 text-center icons" :class="[hideImportantIssues == true ? 'light':'']" @click.prevent="toggleImportantI"     >
                  <span class="d-block">
                      <i class="fas fa-star" :class="[hideImportantIssues == true ? 'light':'text-warning']"></i>
                  </span>     
                      <span class="smallerFont">IMPORTANT</span> 
                       <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="important" v-model="C_hideImportantissues">     -->
                     <h5 class="d-block">{{ issueVariation.important.count }}</h5>  
                  </div>
                   <div class="text-center icons"  :class="[hideBriefedIssues == true ? 'light':'']" @click.prevent="toggleBriefingI"         >
                      <span class="d-block">
                     <i class="fas fa-presentation" :class="[hideBriefedIssues == true ? 'light':'text-primary']"></i>
                  </span>     
                    <span class="smallerFont">BRIEFINGS </span> 
                      <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="briefed" v-model="C_hideBriefedissues">   -->
                    <h5 class="d-block"> {{ issueVariation.briefings.count }}  </h5>    
                  </div>
               </div>
             </div>
              </div>
      <div class="row text-center mt-2" v-if="issuesObj !== null">            
            <span class="count mt-3"><button class="btn countBtn text-light btn-md mh-orange">RESULTS: {{ issuesObj.length}}</button></span>   
                
      
        <div data-cy="issues_table">
          <table class="table table-sm mt-5 stickyTableHeader table-bordered">
           
            <thead style="background-color:#ededed;">
              <th class="sort-th" @click="sortI('program_name')" >Program Name
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
              <th class="sort-th" @click="sortI('project_name')">Project Name
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
              <th class="pl-1 sort-th" @click="sortI('title')">Issue
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
              <th class="sort-th p-1">
                 <span class="py-2 d-inline-block">Assigned Users</span>
              </th>
              <th class="sort-th" @click="sortI('progress')">Progress
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
              <th class='non-sort-th'>Flags
               
              </th>
              <th class="sort-th" @click="sortI('notesUpdatedAt')">Last Update
                 <span class="inactive-sort-icon scroll" v-if="currentSort !== 'notesUpdateAt'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'notesUpdatedAt'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'notesUpdatedAt'">
                 <i class="fas fa-sort-up"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'notesUpdatedAt'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'notesUpdatedAt'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
            </thead>
         <tbody>
        <tr v-for="issue, index in sortedIssues" :key="index">
        <td>{{ issue.program_name }}</td>
        <td>{{ issue.project_name }}</td>
        <td>{{ issue.title }}</td>
        <td>{{ issue.issue_type }}</td>
        <td> {{ issue.users }} </td>   
        <td> {{ issue.progress }} </td>
        <td class="text-center">
            <span v-if="issue.watched == true"  v-tooltip="`On Watch`"><font-awesome-icon icon="eye" class="mr-1"  /></span>
            <span v-if="issue.important == true"  v-tooltip="`Important`"> <i class="fas fa-star text-warning mr-1"></i></span>
            <span v-if="issue.reportable" v-tooltip="`Briefings`"> <i class="fas fa-presentation mr-1 text-primary"></i></span>
            <span v-if="issue.is_overdue" v-tooltip="`Overdue`"><font-awesome-icon icon="calendar" class="text-danger mr-1"  /></span>
            <span v-if="issue.progress == 100" v-tooltip="`Completed`"><font-awesome-icon icon="clipboard-check" class="text-success"  /></span>   
 
            <span v-if="issue.on_hold == true" v-tooltip="`On Hold`"> <i class="fas fa-pause-circle mr-1 text-primary"></i></span>   
            <span v-if="issue.draft == true" v-tooltip="`Draft`"> <i class="fas fa-pencil-alt text-warning"></i></span>   
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
        <td v-if="issue.last_update !== null">{{issue.last_update.body}}</td>
        <td v-else>No Update</td>
     
       
        </tr>
        </tbody>
        </table> 
          
          <div class="float-right mb-4 mt-2 font-sm">
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
           
  <!-- ISSUES TABLE -->

          <!-- <div class="row text-center mt-2" v-if="issuesObj !== null">       -->
            <!-- <el-table
              :data="issuesObj"
              border
              class="mt-4"
              style="width: 100%">
            <el-table-column
              fixed
              prop="program_name"
              sortable
              label="Program"
              width="250">
            </el-table-column>
            <el-table-column
              prop="project_name"
              label="Project"
              fixed
              sortable
              width="250">
            </el-table-column>
            <el-table-column
              prop="title"
              label="Issue"
              sortable
              fixed
              width="250">
            </el-table-column>
            <el-table-column
              prop="category"
              sortable
              label="Category"
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
              label="Last Update"
              sortable
              fixed="right"
              width="300">
            </el-table-column> -->
            <!-- <el-table-column
              fixed="right"
              label="Operations"
              width="120"> -->
              <!-- <template slot-scope="scope">
                <el-button @click="handleClick" type="text" size="small">Detail</el-button>
                <el-button type="text" size="small">Edit</el-button>
              </template> -->
            <!-- </el-table-column> -->



            <!-- </el-table>                    -->
          </div> 
      </el-tab-pane>
  
<!-- 
  RISKS TAB STARTS HERE -->

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
                    class="w-100" 
                   
                    track-by="name" 
                    filterable
                    value-key="id"
                    multiple                                                                                                                                               
                    placeholder="Filter by Program"
                  >
                  <el-option                   
                     value="NEED DATA"                                                                             
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
                    <i class="far fa-calendar" :class="[hideOverdueRisks == true ? 'light':'text-danger']"></i>
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
                <label class="font-sm mb-0 pb-1 d-block">FILTER DISPLAYED RISKS BY TAG</label>
                 <div class="pb-0 pl-2 mb-0 d-inline-flex">    
                  <div class="text-center icons" :class="[hideWatchedRisks == true ? 'light':'']" @click.prevent="toggleWatchedR"   >             
                 <span class="d-block">
                      <i class="fas fa-eye " ></i>
                 </span>                  
                  <span class="smallerFont">ON WATCH</span>
                   <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="watched" v-model="C_hideWatchedTasks">               -->
                   <h5 class="d-block">{{ riskVariation.watched.count }}</h5>  
                  </div>
                  <div class="px-5 text-center icons" :class="[hideImportantRisks == true ? 'light':'']" @click.prevent="toggleImportantR"     >
                  <span class="d-block">
                      <i class="fas fa-star" :class="[hideImportantRisks == true ? 'light':'text-warning']"></i>
                  </span>     
                      <span class="smallerFont">IMPORTANT</span> 
                       <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="important" v-model="C_hideImportantTasks">     -->
                     <h5 class="d-block">{{ riskVariation.important.count }}</h5>  
                  </div>
                   <div class="text-center icons"  :class="[hideBriefedRisks == true ? 'light':'']" @click.prevent="toggleBriefingR"         >
                      <span class="d-block">
                     <i class="fas fa-presentation" :class="[hideBriefedRisks == true ? 'light':'text-primary']"></i>
                  </span>     
                    <span class="smallerFont">BRIEFINGS </span> 
                      <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="briefed" v-model="C_hideBriefedTasks">   -->
                    <h5 class="d-block"> {{ riskVariation.briefings.count }}  </h5>    
                  </div>
               </div>
             </div>
              </div>

      <div class="row text-center mt-2" v-if="risksObj !== null">            
            <span class="count mt-3"><button class="btn countBtn text-light btn-md mh-orange">RESULTS: {{ risksObj.length}}</button></span>   
                
      
        <div data-cy="tasks_table">
          <table class="table table-sm mt-5 stickyTableHeader table-bordered">
           
            <thead style="background-color:#ededed;">
              <th class="sort-th" @click="sort('program_name')" >Program Name
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
              <th class="sort-th" @click="sort('project_name')">Project Name
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
              <th class="pl-1 sort-th" @click="sort('text')">Risk
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
              <th class="sort-th p-1">
                 <span class="py-2 d-inline-block">Assigned Users</span>


              </th>
              <th class="sort-th" @click="sort('progress')">Progress
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
              <th class='non-sort-th'>Flags
               
              </th>
              <th class="sort-th" @click="sort('notesUpdatedAt')">Last Update
                 <span class="inactive-sort-icon scroll" v-if="currentSort !== 'notesUpdateAt'">
                 <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'notesUpdatedAt'">
                 <i class="fas fa-sort-up"></i></span>
                 <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'notesUpdatedAt'">
                 <i class="fas fa-sort-up"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'notesUpdatedAt'">
                 <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'notesUpdatedAt'">
                 <i class="fas fa-sort-down"></i></span>

              </th>
            </thead>
         <tbody>
        <tr v-for="risk, index in sortedRisks" :key="index">
        <td>{{ risk.program_name }}</td>
        <td>{{ risk.project_name }}</td>
        <td>{{ risk.text }}</td>
        <td>{{ risk.category }}</td>
        <td> {{ risk.users }} </td>   
        <td> {{ risk.progress }} </td>
        <td class="text-center">
            <span v-if="risk.watched == true"  v-tooltip="`On Watch`"><font-awesome-icon icon="eye" class="mr-1"  /></span>
            <span v-if="risk.important == true"  v-tooltip="`Important`"> <i class="fas fa-star text-warning mr-1"></i></span>
            <span v-if="risk.reportable" v-tooltip="`Briefings`"> <i class="fas fa-presentation mr-1 text-primary"></i></span>
            <span v-if="risk.is_overdue" v-tooltip="`Overdue`"><font-awesome-icon icon="calendar" class="text-danger mr-1"  /></span>
            <span v-if="risk.progress == 100" v-tooltip="`Completed`"><font-awesome-icon icon="clipboard-check" class="text-success"  /></span>   
            <span v-if="risk.ongoing == true" v-tooltip="`Ongoing`"><i class="far fa-retweet text-success"></i></span>   
            <span v-if="risk.on_hold == true" v-tooltip="`On Hold`"> <i class="fas fa-pause-circle mr-1 text-primary"></i></span>   
            <span v-if="risk.draft == true" v-tooltip="`Draft`"> <i class="fas fa-pencil-alt text-warning"></i></span>   
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
        <td v-if="risk.last_update !== null">{{risk.last_update.body}}</td>
        <td v-else>No Update</td>
     
       
        </tr>
        </tbody>
        </table> 
          
          <div class="float-right mb-4 mt-2 font-sm">
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
    
       </div>
               
     </el-tab-pane>
    <el-tab-pane disabled class="p-3">
          <template slot="label" class="text-right">
           LESSONS LEARNED (Coming Soon)
           <span class="badge badge-secondary badge-pill">
           14
          </span>   
          </template>
           <div class="row pt-2 text-center w-50">          
                <div class="pb-0 pl-2 pr-4 mb-0">                  
                  <span class="d-block" v-tooltip="`COMPLETE`" ><i class="fas fa-clipboard-check text-success"></i></span>
                  <span class="smallerFont">COMPLETE</span>
                   <h5 class="d-block">12</h5>  
                </div>
            
                 <div class="py-0 px-4 mb-0">
                <span  v-tooltip="`DRAFTS`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                     <span class="smallerFont">DRAFTS</span>   
                       <h5 class="d-block">6</h5>              
                </div>             
              </div>
      
    <!-- LESSONS LEARNED TABLE -->
        <div class="row text-center mt-2" v-if="programObj !== null">      
          <el-table
          :data="programObj"
          border
          class="mt-4"
          style="width: 100%">
          <el-table-column
            fixed
            prop="name"
            sortable
            label="Program"
            width="250">
          </el-table-column>
          <el-table-column
            prop="project"
            label="Project"
            fixed
            sortable
            width="250">
          </el-table-column>
          <el-table-column
            prop="lesson"
            sortable
            fixed
            label="Lessons Learned"
            width="250">
          </el-table-column>
          <el-table-column
            prop="date"
            label="Date"
            sortable
            width="120">
          </el-table-column>
          <el-table-column
            prop="addeBy"
            label="Added By"
            sortable
            width="200">
          </el-table-column>
          <el-table-column
            prop="description"
            label="Description"
            sortable
            width="300">
          </el-table-column>
          <el-table-column
            prop="flags"
            label="Flags"
            sortable
            width="200">
          </el-table-column>
          <el-table-column
            prop="lastUpdate"
            label="Last Update"
            sortable
            fixed="right"
            width="250">
          </el-table-column>
          <!-- <el-table-column
            fixed="right"
            label="Operations"
            width="120"> -->
            <!-- <template slot-scope="scope">
              <el-button @click="handleClick" type="text" size="small">Detail</el-button>
              <el-button type="text" size="small">Edit</el-button>
            </template> -->
          <!-- </el-table-column> -->
          </el-table>             
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
import axios from 'axios';
import Loader from "../../shared/loader.vue";
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
      currentIssuesPage:1,
      currentRisksPage:1,


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

      portfolioData: null,  
    
      issuesData: null, 
      risksData: null, 
      programId: null, 
      programName: null, 
      page: 1,
      pageSize: 10,
      // tasksRequest: axios.get("/api/v1/portfolio/tasks"),
      // issuesRequest: axios.get("/api/v1/portfolio/issues"),
      risksRequest: axios.get("/api/v1/portfolio/risks"),
      portfolioRequest: axios.get("/api/v1/portfolio/programs.json"),
      showMore: true,
      today: new Date().toISOString().slice(0, 10),
    };
  },
   mounted() { 
    //  this.fetchLessonsLearned(),
     this.fetchPortfolioTasks(), 
     this.fetchPortfolioIssues(),
     this.fetchPortfolioRisks()
  
  },
  computed: {
    ...mapGetters([
      'getPortfolioWatchedTasksToggle', 
      'getPortfolioBriefedTasksToggle',
      'getTasksPerPageFilterOptions',
      'getIssuesPerPageFilterOptions',
      'getRisksPerPageFilterOptions',
      'getPortfolioImportantTasksToggle', 
      'getProgramNameFilter',
      'getTasksPerPageFilter',    
      'getIssuesPerPageFilter',  
      'getRisksPerPageFilter',      
      'programNameFilter',
      'portfolioTasks',
      'portfolioIssues',
      'portfolioRisks'      
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
    programObj(){     
      if (this.portfolioData !== null) {
      return this.portfolioData
      }
    }, 
    portfolioTaskObj(){      
         return this.portfolioTasks      
    },
    portfolioIssueObj(){      
         return this.portfolioIssues      
    },
    portfolioRiskObj(){      
         return this.portfolioRisks
    },
    tasksObj(){      
      return this.portfolioTaskObj.filter(task => {
        
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

      }).filter(task => {
         if (this.hideInprogressTasks) {
          return task.progress < 100 && task.start_date <= this.today
        } else return true
      }).filter(task => {
        // This and last 2 filters are for Filtered Tags
         if (this.hideWatchedTasks) {
          return !task.watched
        } else return true
      }).filter(task => {
         if (this.hideImportantTasks) {
          return !task.important
        } else return true    
      })
    }, 
    issuesObj(){     
      return this.portfolioIssueObj.filter(issue => {        
        if (this.hideDraftIssues) {
          return !issue.draft
        } else return true
        
      }).filter(issue => {
         if (this.hideOnholdIssues) {
          return !issue.on_hold
        } else return true

     }).filter(issue => {
         if (this.hideInprogressIssues) {
          return issue.progress < 100 && issue.start_date <= this.today 
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
      }).filter(issue => {
        // This and last 2 filters are for Filtered Tags
         if (this.hideWatchedIssues) {
          return !issue.watched
        } else return true
      }).filter(issue => {
         if (this.hideImportantIssues) {
          return !issue.important
        } else return true    
      })
    }, 
     risksObj(){     
      return this.portfolioRiskObj.filter(risk => {        
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
      }).filter(risk => {
        // This and last 2 filters are for Filtered Tags
         if (this.hideWatchedRisks) {
          return !risk.watched
        } else return true
      }).filter(risk => {
         if (this.hideImportantRisks) {
          return !risk.important
        } else return true    
      })
    }, 
    //  pagedTableData() {
    //    if (this.tasksObj && this.tasksObj !== undefined)
    //    return this.tasksObj.slice(this.pageSize * this.page - this.pageSize, this.pageSize * this.page)
    //  },
   taskVariation() {
      let planned = _.filter(
        this.portfolioTasks,
        (t) => t && t.draft == false && t.start_date && t.start_date > this.today 
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let taskDrafts = _.filter(
      this.portfolioTasks,
        (t) => t && t.draft == true
      );  
      let important = _.filter(
      this.portfolioTasks,
        (t) => t && t.important == true
      ); 
        let briefings = _.filter(
        this.portfolioTasks,
        (t) => t && t.reportable == true
      );
      let watched = _.filter(
      this.portfolioTasks,
        (t) => t && t.watched == true
      );
              
      let completed = _.filter(
       this.portfolioTasks,
        (t) => t && t.progress && t.progress == 100 
      );
      let inProgress = _.filter(
      this.portfolioTasks,
        (t) => t && t.progress < 100 && t.start_date <= this.today 
      );
     let onHoldT = _.filter(this.portfolioTasks, (t) => t && t.on_hold == true );
     let ongoing = _.filter(this.portfolioTasks, (t) => t && t.ongoing == true );
     let overdue = _.filter( this.portfolioTasks, (t) => t.is_overdue == true);

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
        this.portfolioIssues,
        (t) => t && t.draft == false && t.start_date && t.start_date > this.today 
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let issueDrafts = _.filter(
       this.portfolioIssues,
        (t) => t && t.draft == true
      );      
      let completed = _.filter(
      this.portfolioIssues,
        (t) => t && t.progress && t.progress == 100 
      );
      let inProgress = _.filter(
        this.portfolioIssues,
        (t) => t && t.progress < 100 && t.start_date <= this.today 
      );
     let onHoldI = _.filter(this.portfolioIssues, (t) => t && t.on_hold == true );
     let overdue = _.filter(this.portfolioIssues, (t) => t && t.is_overdue == true);
     let important = _.filter(
        this.portfolioIssues,
        (t) => t && t.important == true
      ); 
      let briefings = _.filter(
        this.portfolioIssues,
        (t) => t && t.reportable == true
      );
      let watched = _.filter(
        this.portfolioIssues,
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
        this.portfolioRisks,
        (t) => t && t.draft == false && t.start_date && t.start_date > this.today 
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let riskDrafts = _.filter(
        this.portfolioRisks,
        (t) => t && t.draft == true
      );      
     let important = _.filter(
      this.portfolioRisks,
        (t) => t && t.important == true
      ); 
        let briefings = _.filter(
        this.portfolioRisks,
        (t) => t && t.reportable == true
      );
      let watched = _.filter(
      this.portfolioRisks,
        (t) => t && t.watched == true
      );
      let completed = _.filter(
        this.portfolioRisks,
        (t) => t && t.progress && t.progress == 100 
      );
      let inProgress = _.filter(
        this.portfolioRisks,
        (t) => t && t.progress < 100 && t.start_date <= this.today 
      );
     let onHoldR = _.filter(this.portfolioRisks, (t) => t && t.on_hold == true );
     let ongoing = _.filter(this.portfolioRisks, (t) => t && t.ongoing == true );
     let overdue = _.filter(this.portfolioRisks, (t) => t && t.is_overdue == true);
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
    // C_programNames() {
    //   return this.getProgramNameFilter
    // },
    // C_programNameFilter: {
    //   get() {
    //     return this.programNameFilter
    //   },
    //   set(value) {
    //     this.setProgramNameFilter(value)
    //   }
    // },
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
    'setPortfolioBriefedTasksToggle',
    'setPortfolioImportantTasksToggle',
    'setProgramNameFilter'
     ]),
   ...mapActions([
      'fetchPortfolioTasks',
      'fetchPortfolioIssues',
      'fetchPortfolioRisks'
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
    log(e){
      // console.log("Name consoleLogged value here" + e)
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
    handleClick(tab, event) {
        console.log(tab, event);
    },
    // programRoute() {      
    //     return  ;
    // },
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

/deep/.el-collapse-item__header, /deep/.el-collapse-item__wrap  {
  border-bottom: none !important;
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
i, .icons {
  cursor: pointer;
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
    table-layout: fixed;
    width: 100%;
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
    width: 100%;
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

</style>
