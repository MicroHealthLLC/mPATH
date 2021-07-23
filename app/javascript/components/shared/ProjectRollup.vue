<!--  NOTE: This File is used in Map view right side bard -->
<template>
  <div class="container-fluid m-2" data-cy="facility_rollup">

   <!-- <el-tabs type="border-card" @tab-click="handleClick">
  <el-tab-pane label="Program Rollup" class="p-3"> -->
    <!-- FIRST ROW:  PROGRAM NAME AND COUNT -->
    <div class="row pt-2">
      <div class="col-6 py-0 pl-0">
        <span v-if="contentLoaded">
          <h4 v-if="isMapView" class="d-inline mr-2 programName">{{ currentProject.name }}</h4>          
          <h3 v-else class="d-inline mr-2 programName">{{ currentProject.name }}</h3>        
        </span>     
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
       
      </div>
  
     
    </div>

<!-- SECOND ROW: ACTION CARDS (TASK, ISSUES, RISKS, LESSONS) -->
    <div class="row">
      <div class="col px-0" :class="[isMapView ? 'col-6' : '']" >
          <el-card
            class="box-card mb-2"
            style="background-color:#fff"
            data-cy="task_summary"
          >      
            <div class="row">
              <div class="col pl-2" :class="[isMapView ? 'pb-1 pl-3' : '']">              
                <h5 class="d-inline">TASKS</h5>
                <h5 v-if="contentLoaded" class="d-inline">
                  <span class="badge bg-secondary text-light badge-pill float-right">{{
                    filteredTasks.length 
                  }}</span>
                </h5>
                <hr class="mb-half"/>
              </div>
            </div>

            <div v-if="contentLoaded">
               <div class="row text-center">
                <div class="col-3 p-0 mb-0">
                  
                  <span class="d-block" v-tooltip="`COMPLETE`" ><i class="fas fa-clipboard-check text-success"></i></span>
                  <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">COMPLETE</span>
                    <!-- <span class="d-block smallerFont">COMPLETE</span> -->

                </div>
                 <div class="col-3 p-0 mb-0">
                  <span class="d-block" v-tooltip="`IN PROGRESS`"><i class="far fa-tasks text-primary"></i></span>
                     <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont"> IN PROGRESS</span>           
                </div>
                 <div class="col-3 p-0 mb-0">
                   <span class="d-block" v-tooltip="`OVERDUE`"><font-awesome-icon icon="calendar" class="text-danger"  /></span>
                    <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">OVERDUE </span>               
                </div>
                 <div class="col-3 p-0 mb-0">
                   <span class="d-block" v-tooltip="`ONGOING`"><i class="fas fa-retweet text-success"></i></span>
                    <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">ONGOING </span>    
                </div>       
              </div>

                <div class="row text-center mt-0" :class="[filteredTasks.length > 0 ? '' : 'pb-3']">
                <div class="col-3 pb-0 mb-0">
                   <h4 class="">{{
                    taskVariation.completed.count
                  }}</h4>         
                </div>
                 <div class="col-3 pb-0 mb-0">
                  <h4>{{
                    taskVariation.inProgress.count
                  }}</h4>        
                </div>
                 <div class="col-3 pb-0 mb-0">
                   <h4>{{ taskVariation.overdue.count }}
                     </h4>
                                    
                </div>
                 <div class="col-3 pb-0 mb-0">
                  <h4>{{
                    taskVariation.ongoing.length
                  }}</h4>          
                </div>        
                </div>      

              <div v-if="filteredTasks.length">
                <el-collapse id="roll_up" class="taskCard">
                  <el-collapse-item title="..." name="1">
                <div class="row mt-1 text-center">
                <div class="col-3 p-0  mb-0">
                  
                  <span class="d-block" v-tooltip="`PLANNED`"><i class="fas fa-calendar-check text-info font-md"></i></span>
                      <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">PLANNED</span>
                </div>
                 <div class="col-3 p-0 mb-0">
                 <span  v-tooltip="`ON HOLD`" class="d-block"><i class="fas fa-pause-circle text-primary font-md"></i></span>
                     <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">ON HOLD  </span>           
                </div>
                 <div class="col-3 p-0 mb-0">
                <span  v-tooltip="`DRAFTS`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                     <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">DRAFTS</span>               
                </div>
                 
              </div>

                <div class="row text-center mt-0">
                <div class="col-3 pb-0 mb-0">
                   <h4 class="">{{
                    taskVariation.planned.count
                  }}</h4>         
                </div>
                 <div class="col-3 pb-0 mb-0">
                  <h4>{{
                    taskVariation.onHoldT.count
                  }}</h4>        
                </div>
                 <div class="col-3 pb-0 mb-0">
                   <h4>{{  taskVariation.taskDrafts.count }}</h4>                      
                </div>
                
                </div>
                <hr/>
              
                    <div class="row my-1">
                      <div class="col-6">
                        <span class="underline" :class="{ 'font-sm': isMapView }">CATEGORIES</span>
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
      <div class="col" :class="[isMapView ? 'col-6' : '']">
            <el-card
            class="box-card mb-2"
            style="background-color:#fff"
            data-cy="issue_summary"
          >
            <div class="row">
              <div class="col" :class="[isMapView ? 'pb-1' : '']">
                <h5 class="d-inline">ISSUES</h5>
                <h5 v-if="contentLoaded" class="d-inline">
                  <span class="badge bg-secondary text-light badge-pill float-right">{{
                    filteredIssues.length 
                  }}</span>
                </h5>
                <hr class="mb-half"/>
              </div>
            </div>

            <div v-if="contentLoaded">
               <div class="row text-center">
                <div class="col-3 p-0 mb-0">                  
                  <span  v-tooltip="`COMPLETE`" class="d-block"><i class="fas fa-clipboard-check text-success"></i></span>
                       <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">COMPLETE</span>
                </div>
                 <div class="col-3 p-0 mb-0">
                <span v-tooltip="`IN PROGRESS`" class="d-block"><i class="far fa-tasks text-primary"></i></span>
                     <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">IN PROGRESS</span>           
                </div>
                 <div class="col-3 p-0 mb-0">
                 <span v-tooltip="`OVERDUE`" class="d-block"><font-awesome-icon icon="calendar" class="text-danger"  /></span>
                     <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">OVERDUE</span>               
                </div>
                
              </div>

                <div class="row text-center mt-0" :class="[filteredIssues.length > 0 ? '' : 'pb-3']">
                <div class="col-3 pb-0 mb-0">
                   <h4 class="">{{
                    issueVariation.completed.count
                  }}</h4>         
                </div>
                 <div class="col-3 pb-0 mb-0">
                  <h4>{{
                    issueVariation.inProgress.count
                  }}</h4>        
                </div>
                 <div class="col-3 pb-0 mb-0">
                   <h4>{{ issueVariation.overdue.count }}
                     </h4>                      
                </div>      
                </div>

              <!-- If Issues? Place in collapsible container -->
              <div v-if="filteredIssues.length">
                <el-collapse>
                  <el-collapse-item title="..." name="1">
                 <div v-if="contentLoaded">
                  <div class="row mt-1 text-center">
                <div class="col-3 p-0  mb-0">
                  
                  <span v-tooltip="`PLANNED`" class="d-block"><i class="fas fa-calendar-check text-info font-md"></i></span>
                      <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">PLANNED</span>
                </div>
                 <div class="col-3 p-0 mb-0">
                 <span v-tooltip="`ON HOLD`" class="d-block"><i class="fas fa-pause-circle text-primary font-md"></i></span>
                      <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">ON HOLD  </span>           
                </div>
                 <div class="col-3 p-0 mb-0">
                 <span  v-tooltip="`DRAFTS`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                    <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">DRAFTS</span>               
                </div>
                 
              </div>

                <div class="row text-center mt-0">
                <div class="col-3 pb-0 mb-0">
                   <h4 class="">{{
                    issueVariation.planned.count
                  }}</h4>         
                </div>
                 <div class="col-3 pb-0 mb-0">
                  <h4>{{
                    issueVariation.onHoldI.count
                  }}</h4>        
                </div>
                 <div class="col-3 pb-0 mb-0">
                   <h4>{{ issueVariation.issueDrafts.count }}</h4>                      
                </div>
                
                </div>
                <hr/>
                      <div class="row">
                        <div class="col mt-1 underline">
                          CATEGORIES
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
      <div class="col px-0" :class="[isMapView ? 'col-6 pt-1' : '']" >
          <el-card
              class="box-card"
              style="background-color:#fff"
              data-cy="risk_summary"
            >
              <div class="row">
                <div class="col pb-0" :class="[isMapView ? 'pb-1' : '']">
                  <h5 class="d-inline">RISKS</h5>
                  <h5 v-if="contentLoaded" class="d-inline">
                    <span class="badge bg-secondary text-light badge-pill float-right">{{
                      filteredRisks.length 
                    }}</span>
                  </h5>
                  <hr class="mb-half" />
                </div>
              </div>          
              <div class="row text-center">
                <div class="col-3 p-0 mb-0">
                  
                  <span  v-tooltip="`COMPLETE`" class="d-block"><i class="fas fa-clipboard-check text-success"></i></span>
                       <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">COMPLETE</span>
                </div>
                 <div class="col-3 p-0 mb-0">
                 <span  v-tooltip="`IN PROGRESS`" class="d-block"><i class="far fa-tasks text-primary"></i></span>
                     <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont"> IN PROGRESS   </span>           
                </div>
                 <div class="col-3 p-0 mb-0">
                 <span  v-tooltip="`OVERDUE`"  class="d-block"><font-awesome-icon icon="calendar" class="text-danger"  /></span>
                     <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">OVERDUE </span>               
                </div>
                 <div class="col-3 p-0 mb-0">
                   <span v-tooltip="`ONGOING`" class="d-block"> <i class="fas fa-retweet text-success"></i></span>
                     <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">ONGOING</span>    
                </div>       
              </div>

              <div class="row text-center mt-0" :class="[filteredRisks.length > 0 ? '' : 'pb-3']">
                <div class="col-3 pb-0 mb-0">
                   <h4 class="">{{
                    riskVariation.completed.count
                  }}</h4>         
                </div>
                 <div class="col-3 pb-0 mb-0">
                  <h4>{{
                    riskVariation.inProgress.count
                  }}</h4>        
                </div>
                 <div class="col-3 pb-0 mb-0">
                   <h4>{{ riskVariation.overdue.count }}
                     </h4>
              
                       
                </div>
                 <div class="col-3 pb-0 mb-0">
                  <h4>{{
                    riskVariation.ongoing.length
                  }}</h4>          
                </div>
        
              </div>
              

              <div v-if="filteredRisks.length > 0">
                <el-collapse>
                  <el-collapse-item title="..." name="1">
                <div class="row mt-1 text-center">
                  <div class="col-3 p-0  mb-0">                    
                    <span v-tooltip="`PLANNED`"  class="d-block"><i class="fas fa-calendar-check text-info font-md"></i></span>
                        <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">PLANNED</span>
                  </div>
                  <div class="col-3 p-0 mb-0">
                   <span v-tooltip="`ON HOLD`" class="d-block"><i class="fas fa-pause-circle text-primary font-md"></i></span>
                      <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont"> ON HOLD  </span>           
                  </div>
                  <div class="col-3 p-0 mb-0">
                    <span v-tooltip="`DRAFTS`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                        <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">DRAFTS</span>               
                  </div>
                  
                </div>

                <div class="row text-center mt-0">
                <div class="col-3 pb-0 mb-0">
                  <h4 class="">{{
                    riskVariation.planned.count
                  }}</h4>         
                </div>
                <div class="col-3 pb-0 mb-0">
                  <h4>{{
                    riskVariation.onHoldR.count
                  }}</h4>        
                </div>
                <div class="col-3 pb-0 mb-0">
                  <h4>{{  riskVariation.riskDrafts.count }}</h4>                      
                </div>
                
                </div>
                <hr/>
              
                    <div class="row">
                      <div class="col my-1 underline">
                        CATEGORIES
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
              <div v-if="!contentLoaded" class="my-4">
                <loader type="code"></loader>
              </div>
            </el-card>
      </div>
      <div class="col-2" :class="[isMapView ? 'col-6 pt-1' : '']" >
                 <el-card
            class="box-card mb-2"
            style="background-color:#fff"
            data-cy="issue_summary"
          >
            <div class="row">
              <div class="col pb-0" :class="[isMapView ? 'pb-1' : '']">
                <h6 class="d-inline">LESSONS LEARNED</h6>
               
                <hr class="mb-half"/>
              </div>
            </div>

            <div v-if="contentLoaded">
               <div class="row text-center">
              <div class="col p-0">
                <span class="giantNumber" :class="[isMapView ? 'giantMapView' : '']">{{ programLessons.total_count }}</span>
              </div>
                
              </div>

        

              <!-- If Issues? Place in collapsible container -->
              <div>
                <el-collapse>
                  <el-collapse-item title="..." name="1">
                 <div v-if="programLessons.total_count > 0">
                <div class="row mt-1 text-center" >
                <div class="col-6 p-0 mb-0">                  
                  <span  v-tooltip="`COMPLETE`" class="d-block"><i class="fas fa-clipboard-check text-success font-md"></i></span>
                       <span :class="[isMapView ? 'd-none' : 'd-block']" class="sm">COMPLETE</span>
                </div>
                 <div class="col-6 p-0 mb-0">
                <span v-tooltip="`IN PROGRESS`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                     <span :class="[isMapView ? 'd-none' : 'd-block']" class="sm">DRAFTS</span>           
                </div>
                
                  </div>
                <div class="row text-center mt-0">
                <div class="col-6 pb-0 mb-0">
                  <h4 class="">{{
                   programLessons.completed
                  }}</h4>         
                </div>
                <div class="col-6 pb-0 mb-0">
                  <h4>{{
                   programLessons.progress
                  }}</h4>        
                </div>                     
                </div>            
                    
                    </div>
              
               <div v-else>
                <div class="row mt-1 text-center">
                <div class="col p-0  mb-0">
                  
                       NO DATA TO DISPLAY
                </div>
          </div>
              
                    
                    </div>
                  </el-collapse-item>
                </el-collapse>
              </div>
            </div>
    
  
        
      
            <!-- <div v-if="!contentLoaded" class="my-4">
              <loader type="code"></loader> -->
          
    
          </el-card>
      </div>

    </div>



    <div class="row row-1 mt-1">
      <div class="col-md-6 col-lg-6 px-0 col-sm-6">
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
        <!-- <el-card
          class="box-card my-2"
          style="background-color:#41b883;color:#fff"
        >
          <div class="row">
            <div class="col">
              <h5 class="d-inline">Filters</h5>
              <hr />
            </div>
          </div>

          <div v-for="(filterArray, index) in getAllFilterNames" :key="index">
        <span v-if="getFilterValue(filterArray[0])">
                      <span
                        ><b class="mr-1">{{ filterArray[1] }}:</b>
                        {{ getFilterValue(filterArray[0]) }}
                      </span>
                    </span>
          </div>
          <span v-show="facilities.length !== getUnfilteredFacilities.length"
            >Map Boundary Filter: Active</span
          >
        </el-card>
    -->
      </div>
      <div
        class="col-md-6 col-lg-6 col-sm-6 pl-2"
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
import { mapGetters, mapActions } from "vuex";
export default {
  name: "ProjectRollup",
  props: ["from"],
  components: {
    Loader,
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
      "currentProject",
      "lessonsLoaded",
      "projectLessons",
      "programLessons",
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
    ]),
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
    taskVariation() {
      let planned = _.filter(
        this.filteredTasks,
        (t) => t && t.draft == false && t.startDate && t.startDate > this.today 
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let taskDrafts = _.filter(
        this.filteredTasks,
        (t) => t && t.draft == true && t.onHold == false && t.ongoing == false   
      );      
      let completed = _.filter(
        this.filteredTasks,
        (t) => t && t.progress && t.progress == 100 
      );
      let completed_percent = this.getAverage(
        completed.length,
        this.filteredTasks.length
      );
      let inProgress = _.filter(
        this.filteredTasks,
        (t) => t && t.progressStatus == 'active' && t.draft == false && !t.isOverdue && t.onHold == false && !t.ongoing && t.startDate <= this.today 
      );
     let onHoldT = _.filter(
        this.filteredTasks,
        (t) => t && t.onHold == true && t.progressStatus == 'active' && !t.isOverdue && !t.ongoing
      );
      let inProgress_percent = this.getAverage(
        inProgress.length,
        this.filteredTasks.length
      );
      let overdue = _.filter(this.filteredTasks, (t) => t && t.isOverdue && !t.onHold && t.ongoing == false);
      let overdue_percent = this.getAverage(
        overdue.length,
        this.filteredTasks.length
      );
      let ongoing = _.filter(this.filteredTasks, (t) => t && t.ongoing );
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
          count: inProgress.length - planned.length,
          percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          percentage: Math.round(overdue_percent),
        },
        ongoing,       
    
      };
    },
   issueVariation() {
     let planned = _.filter(
        this.filteredIssues,
        (t) => t && t.draft == false && t.startDate && t.startDate > this.today     
      );     
      let issueDrafts = _.filter(
        this.filteredIssues,
         (t) => t && t.draft == true && t.onHold == false 
      );      
      let completed = _.filter(
        this.filteredIssues,
        (t) => t && t.progress && t.progress == 100
      );
      let completed_percent = this.getAverage(
        completed.length,
        this.filteredIssues.length
      ); 
       let inProgress = _.filter(
        this.filteredIssues,
        (t) => t && t.progressStatus == 'active' && t.draft == false && !t.isOverdue && t.onHold == false && t.startDate <= this.today 
        );
      let onHoldI = _.filter(
        this.filteredIssues,
        (t) => t && t.onHold == true && t.progressStatus == 'active' && !t.isOverdue
      );
      let inProgress_percent = this.getAverage(
        inProgress.length,
        this.filteredIssues.length
      );
      let overdue = _.filter(this.filteredIssues, (t) => t && t.isOverdue && !t.onHold);
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
        (t) => t && t.draft == false && t.startDate && t.startDate > this.today     
      );  
      let riskDrafts = _.filter(
        this.filteredRisks,
        (t) => t && t.draft == true && t.onHold == false && t.ongoing == false  
      ); 
      let completed = _.filter(
        this.filteredRisks,
        (t) => t && t.progress && t.progress == 100  && t.draft == false
      );
      let inProgress = _.filter(
        this.filteredRisks,
        (t) => t && t.progressStatus == 'active' && t.draft == false && !t.isOverdue && t.onHold == false && !t.ongoing && t.startDate <= this.today 
      );
      let onHoldR = _.filter(
        this.filteredRisks,
        (t) => t && t.onHold == true && t.progressStatus == 'active' && !t.isOverdue && !t.ongoing
      );  
 
      let completed_percent = this.getAverage(
        completed.length,
        this.filteredRisks.length
      );
      let inProgress_percent = this.getAverage(
        inProgress.length,
        this.filteredRisks.length
      );
      let overdue = _.filter(this.filteredRisks, (t) => t && t.isOverdue && !t.onHold);
      let overdue_percent = this.getAverage(
        overdue.length,
        this.filteredRisks.length
      );
      let ongoing = _.filter(this.filteredRisks, (t) => t && t.ongoing);
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
        ongoing
      };
    },
  },
  methods: {
      ...mapActions([
     'fetchProgramLessons'
     ]), 

    showLessToggle() {
      this.showLess = "Show Less";
    },
    log(e){
      console.log("this is Lessons" + e)
    },
    handleClick(tab, event) {
        console.log(tab, event);
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
  },
  mounted() {
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
</style>
