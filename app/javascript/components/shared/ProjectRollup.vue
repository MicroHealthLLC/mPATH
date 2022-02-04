<template>
  <div class="container-fluid" data-cy="facility_rollup">
      <div class="row pt-1 pb-2">
      <div class="col-6 py-3 pl-3" v-if="contentLoaded">
        <span>
          <h4 v-if="isMapView" class="d-inline mr-2 programName">{{ currentProject.name }}</h4>          
          <h3 v-else class="d-inline mr-2 programName">{{ currentProject.name }}</h3>        
        </span> 
        <br>    
        <el-button-group :class="{'d-none': !_isallowedContracts('read') || currentProject.contracts.length <= 0 }">
          <el-button :class="[ !getShowProjectStats ? 'lightBtn' : 'inactive']" @click.prevent="showProjectStats" class="pr-2">  
          <!-- <i class="fal fa-clipboard-list mr-1" :class="[ getShowProjectStats ? 'inactive' : 'mh-green-text']"></i> -->
          PROJECTS
          <span 
            v-if="currentProject && currentProject.facilities"
            class="ml-1 badge badge-secondary badge-pill pill pill-toggle"
            >{{ currentProject.facilities.length }}
            </span>
        </el-button>
        <el-button :class="[ getShowProjectStats ? 'lightBtn' : 'inactive']" @click.prevent="showContractStats" class="pr-2"> 
          <!-- <i class="far fa-file-contract mr-1" :class="[ getShowProjectStats == false ? 'inactive' : 'mh-orange-text']"></i> -->
          CONTRACTS 
            <span 
              v-if="currentProject && currentProject.contracts"
              class="ml-1 badge badge-secondary badge-pill pill pill-toggle"
              >{{ currentProject.contracts.length }}
              </span>
           </el-button>
       </el-button-group>
            
      </div>
      <div class="col-6 py-3 pl-0">
        <span v-if="contentLoaded" class="float-right mt-2">
          <!-- <h4 v-if="isMapView" class="d-inline mr-2 programName">{{ currentProject.name }}</h4>           -->
          <router-link :to="ProgramView" > 
               <button                
                  class="btn btn-sm mh-orange text-light programViewerBtn allCaps" data-cy=program_viewer_btn>
                  PROGRAM DATA VIEWER
                </button>   
          </router-link>             
        </span>         
       
      </div>
  
     
    </div>

   <el-tabs type="border-card" @tab-click="handleClick">
       <el-tab-pane class="p-3" v-if="currentProject && currentProject.facilities.length <= 0 && !this.getShowProjectStats"> 
      <template slot="label">
      <i class="fas fa-analytics mr-1"></i>
      ANALYTICS   
    </template>     
    NO DATA TO DISPLAY  
    </el-tab-pane>
    <el-tab-pane class="p-3" v-else> 
      <template slot="label">
      <i class="fas fa-analytics mr-1"></i>
      ANALYTICS   
    </template>   
    <!-- FIRST ROW:  PROGRAM NAME AND COUNT -->
 
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

    <div class="row" :class="[isMapView ? 'mt-4' : '']">
      <div class="col-3 pt-0" :class="[isMapView ? 'col-3 pl-0 pr-1' : 'pl-0']">
        <el-card
            class="box-card mb-2"        
            style="background-color:#fff"  
          >
            <div class="row mb-4">
              <div class="col pb-0 relative">
                <h5 class="text-light px-2 bg-secondary absolute">LESSONS</h5>
                <h5 v-if="contentLoaded" class="d-inline">
                    <b class="pill badge badge-secondary badge-pill pill mr-1">{{
                      filteredLessons.length
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
                    lessonVariation.completes.length
                  }}</h4>         
                </div>
                <div class="col-6 pb-0 mb-0">
                  <h4>{{
                    lessonVariation.drafts.length
                  }}</h4>        
                </div>                     
                </div>            
              <div v-if="lessonStats.length > 0" data-cy="lesson_categories">
              <el-collapse class="lessonCard">
                <el-collapse-item title="..." name="1">
                  <div data-cy="lesson_categories" class="row">
                    <div class="col-6 pb-0 underline">PROCRESS AREAS</div>
                    <div class="col-6 pb-0">#</div>
                  </div>

                  <div class="row" v-for="(lesson, index) in lessonStats" :key="index">
                    <div class="col-6 pb-0 font-sm pr-0">
                      <span> {{ lesson.name }}</span>
                    </div>
                    <div class="col-6 pb-0">
                      <span class="badge badge-secondary  font-sm badge-pill">{{ lesson.count }}</span>
                    </div>
                  </div>
                </el-collapse-item>
              </el-collapse>
            </div>
            <div v-else>
              <el-collapse id="roll_up" class="lessonCard">
                <el-collapse-item title="..." name="1">
                  <div class="row mt-1 text-center">
                    <div class="col p-0  mb-0">NO DATA TO DISPLAY</div>
                  </div>
                </el-collapse-item>
              </el-collapse>
            </div>
          </el-card>
      </div> 
   
      <div :class="[isMapView ? 'col-9 p-0' : 'col-6 px-0 pt-0']"
        v-if="from !== 'manager_view'"
        data-cy="facility_group_summary"
      >
         <el-card class="box-card" v-if="getShowProjectStats">
          <div class="row">
            <div class="col">
              <h5 class="d-inline"><i class="far fa-file-contract mr-1 mh-orange-text"></i>
               CONTRACTS
              </h5>
               <h4 v-if="contentLoaded" class="d-inline">
                    <span class="badge bg-secondary text-light badge-pill float-right">
                     {{ programResourceObj.length }}
                    </span>
                  </h4>
              <hr />
            </div>
          </div>
          <div v-if="contentLoaded">
          <div
           style="height:215px; overflow-y:auto" 
           class="pb-2"
          >
         <div class="row py-1">
            <div class="col-5">
               <small class="underline">Group</small>               
              </div>
              <div class="col-1 pl-0">              
                 <small class="underline">Contracts</small>
              </div>
              <div class="col-5">
                <small class="underline">Total Progress</small>
              </div>
            </div>
          <div
            v-for="(group, index) in facilityGroups"
            :key="index"
            >
            <div class="row py-1">
              <div class="col-5 mb-2">
                <span :class="{ 'font-sm': isMapView }">{{
                 group.name
                }}</span>
               
              </div>
              <div class="col-1 pl-0">              
                <span class="badge badge-secondary badge-pill">{{
                  facilityGroupFacilities(group).contracts.b.length
                }}</span>
              </div>
              <div class="col-5">
                <span
                  class="w-100 mt-1 ml-2 progress pg-content"
                  :class="{
                    'font-sm': isMapView,
                    'progress-0': facilityGroupProgress(group) <= 0,
                  }"
                >
                  <div
                    class="progress-bar bg-info"
                    :style="`width: ${facilityGroupProgress(group)}%`"
                  >
                    {{ facilityGroupProgress(group) }} %
                  </div>
                </span>
              </div>
            </div>
          </div>
   
           </div>
            <!-- <div class="pb-2">
               <div class="row mb-1">
                   <div class="col-10 mb-0 py-1 card-title">
                     Project Group Name
                   </div>
                    <div class="col-2 mb-0 pl-3 py-1 card-title">   
                      #
                    </div>      
                 </div>
              <div class="row my-0" v-for="item, i in getContractGroupOptions" :key="i">
                <div class="col-10 py-1">
               
                  <span :class="{ 'font-sm': isMapView }">
                  {{ item.name }}</span
                  >                
                </div>
                <div class="col-2 py-1">                
                  <span v-if="item.id == 1" class="badge badge-secondary badge-pill font-sm">{{
                    contractCategoryCount.prime
                  }}</span>
                    <span v-if="item.id == 2"   class="badge badge-secondary badge-pill font-sm">{{
                    contractCategoryCount.nonPrime
                  }}</span>
                    <span v-if="item.id == 3"  class="badge badge-secondary badge-pill font-sm">{{
                    contractCategoryCount.primeV_IDIQs
                  }}</span>
                </div>
               </div>
             </div> -->
          </div>
          <div v-if="!contentLoaded" class="my-4">
            <loader type="code"></loader>
          </div>
        </el-card>
         <el-card class="box-card" data-cy="projet_group_summary" style="max-height: auto" v-if="!getShowProjectStats">
          <div class="row">
            <div class="col">
              <h5 class="d-inline"><i class="fal fa-clipboard-list mh-green-text mr-1"></i>
              PROJECTS
              </h5>
               <h4 v-if="contentLoaded" class="d-inline">
                    <span class="badge bg-secondary text-light badge-pill float-right">
                     {{ C_facilityCount }}
                    </span>
                  </h4>
                  <!-- <h4 v-if="contentLoaded" class="d-inline">
                    <span class="badge bg-secondary text-light badge-pill float-right">{{
                      filteredFacilityGroups.length 
                    }}</span>
                  </h4> -->
              <hr />
            </div>
          </div>
           <div
           style="height:215px; overflow-y:auto" 
           class="pb-2"
          >
          <div class="row py-1">
            <div class="col-5">
               <small class="underline">Group</small>               
              </div>
              <div class="col-1 pl-0">              
                 <small class="underline">Projects</small>
              </div>
              <div class="col-5">
                <small class="underline">Total Progress</small>
              </div>
            </div>
          <div
            v-for="(group, index) in facilityGroups"
            :key="index"
            >
           
            <div class="row py-1">
              <div class="col-5 mb-2">
                <span :class="{ 'font-sm': isMapView }">{{
                  group.name
                }}</span>
               
              </div>
              <div class="col-1 pl-0">              
                <span class="badge badge-secondary badge-pill">{{
                  facilityGroupFacilities(group).projects.a.length
                }}</span>
              </div>
              <div class="col-5">
                <span
                  class="w-100 mt-1 ml-2 progress pg-content"
                  :class="{
                    'font-sm': isMapView,
                    'progress-0': facilityGroupProgress(group) <= 0,
                  }"
                >
                  <div
                    class="progress-bar bg-info"
                    :style="`width: ${facilityGroupProgress(group)}%`"
                  >
                    {{ facilityGroupProgress(group) }} %
                  </div>
                </span>
              </div>
            </div>
          </div>
         <el-collapse id="roll_up" >
           <el-collapse-item title="..." name="1">
          <div v-if="contentLoaded && C_facilityCount > 0">
            <div  
            style="height:215px; overflow-y:auto" 
            class="pb-2"
            >
               <div class="row">
                   <div class="col-5 mb-0 card-title">
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
                <div class="col-5 mb-1">
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
                </el-collapse-item>
              </el-collapse>
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
    </el-tab-pane>
    <el-tab-pane class="p-3" v-if="currentProject && currentProject.facilities.length <= 0 && !this.getShowProjectStats"> 
      <template slot="label">
       <i class="fal fa-table mr-1"></i>
      TABLE   
    </template>     
    NO DATA TO DISPLAY  
    </el-tab-pane>
  <el-tab-pane class="p-3 overflowX" v-else>
     <template slot="label">
      <i class="fal fa-table mr-1"></i>
      TABLE    
    </template>   

<!-- ROW FOR FILTERS -->
    <div class="row">
    <div class="col-6 py-0 px-0" :class="[isMapView ? 'col-12' : '']" >
      <!-- SEARCH BAR -->
    </div>
        <div class="col-6 py-0 px-0">
        <!-- SEARCH BY GROUP -->
    </div>
      
    </div>

     <div class="row">
    <ProgramContractsSheet v-if="this.getShowProjectStats" />
    <ProgramProjectsSheet v-else />      
    </div>
    </el-tab-pane>
  
    </el-tabs>  
  </div>
</template>

<script>
import Loader from "./loader";
import ProgramContractsSheet from "../views/program/ProgramContractsSheet.vue"
import ProgramProjectsSheet from "../views/program/ProgramProjectsSheet.vue"
import { mapGetters, mapActions, mapMutations } from "vuex";
export default {
  name: "ProjectRollup",
  props: ["from"],
  components: {
    Loader,
    ProgramContractsSheet,
    ProgramProjectsSheet 
  },
  data() {
    return {
      showLess: "Show More",
      showMore: true,      
      today: new Date().toISOString().slice(0, 10),
    };
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "getShowProjectStats",
      "getContractGroupOptions",
      "currentProject",
      "lessonsLoaded",
      'currProgramTab',
      "projectLessons",
      "programLessons",
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
      "facilityGroups",
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

    ]),
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
    programResourceObj(){
      if (this.currentProject && this.currentProject.facilities && !this.getShowProjectStats ){
        return this.currentProject.facilities
      } else if (this.currentProject && this.currentProject.contracts && this.getShowProjectStats){
        return this.currentProject.contracts
      }
    },
    contractCategoryCount(){
      if (this.currentProject && this.currentProject.contracts){     
       return {
       prime: this.currentProject.contracts.filter(c => c.contractTypeId == 1).length,
       nonPrime: this.currentProject.contracts.filter(c => c.contractTypeId == 2).length,
       primeV_IDIQs: this.currentProject.contracts.filter(c => c.contractTypeId == 3).length
       }     
      } 
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
      
        ? this.facilityGroupFacilities(this.facilityGroup).projects.a.length
        : this.facilityCount; 
      
    },
    C_facilityProgress() {
      return this.facilityGroup
        ? Number(
            _.meanBy(
              this.facilityGroupFacilities(this.facilityGroup).projects.a,
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
    lessonVariation() {
      let completes = this.filteredLessons.filter(l => !l.draft )
      let drafts = this.filteredLessons.filter(l => l.draft)
      return {
        completes,
        drafts
      }
    },
    filteredLessons() {
      let programLessonsObj = [];
      if(!this.getShowProjectStats){
        programLessonsObj = this.programLessons.filter(l => l.project_id)
      } else programLessonsObj =  this.programLessons.filter(l => l.contract_id)

      let typeIds = _.map(this.taskTypeFilter, "id");
      return _.filter(programLessonsObj, (resource) => {
        let valid = true;
        valid = valid && this.filterDataForAdvancedFilter([resource], "facilityRollupLessons");
        if (typeIds.length > 0)
          valid = valid && typeIds.includes(resource.task_type_id);
        return valid;
      })
    },
    filteredTasks() {
      let typeIds = _.map(this.taskTypeFilter, "id");
      let stageIds = _.map(this.taskStageFilter, "id");
      let tasks = this.currentProject ? _.flatten(
            _.map(this.programResourceObj, "tasks")
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
      let issues = this.currentProject ? _.flatten(
            _.map(this.programResourceObj, "issues")
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
    lessonStats() {
      let lessons = new Array();
      let group = _.groupBy(this.filteredLessons, "category");
      for (let type in group) {
        if (!type || type == "null") continue;
        lessons.push({
          name: type,
          count: group[type].length,
        });
      }
      return lessons;
    },
    filteredRisks() {
      let typeIds = _.map(this.taskTypeFilter, "id");
      let stageIds = _.map(this.riskStageFilter, "id");
      let risks =  this.currentProject ? _.flatten(
            _.map(this.programResourceObj, "risks")
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
          this.filterDataForAdvancedFilter([resource], "facilityRollupLessons");
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
        ? this.facilityGroupFacilities(this.facilityGroup).projects.a.length
        : this.filteredFacilities("active").length;
    },
    inactiveFacilitiesByStatus() {
      return this.facilityGroup
        ? this.facilityGroupFacilities(this.facilityGroup, "inactive").projects.a.length
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
     'fetchProgramLessons',
     ]), 
     ...mapMutations([
        'setHideComplete',
        'setCurrProgramTab',
        'setHideInprogress',
        'setShowProjectStats',
        'setHidePlanned',
        'setHideOverdue',
        'setHideOngoing',
        'setHideOnhold',
        'setHideDraft',
      ]),
    _isallowedContracts(salut) {
      let pPrivilege = this.$programPrivileges[this.$route.params.programId]        
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return pPrivilege.contracts.includes(s);     
    },
    showLessToggle() {
      this.showLess = "Show Less";
    },
    showContractStats(){
     if(this.getShowProjectStats == false){
        this.setShowProjectStats(!this.getShowProjectStats)
     } else return
     
    },
    showProjectStats(){
      if(this.getShowProjectStats == true){
        // console.log(this.getShowProjectStats)
        this.setShowProjectStats(!this.getShowProjectStats)
          // console.log(this.getShowProjectStats)
      } else return
    },
    log(e){
      // console.log(e)
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
    this.fetchProgramLessons(this.$route.params)
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
.inactive {
  color: lightgray ;
}
.grey2, .lightBtn {
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
.pill.pill-toggle {
  position: relative !important;
  top: 10%;
  right: 1%;
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
