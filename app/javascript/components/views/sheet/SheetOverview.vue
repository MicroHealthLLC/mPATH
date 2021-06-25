<!--  NOTE: This file is used in Sheets view as overview tab -->
<template>
  <div id="facility-sheets" data-cy="facility_sheets">
    <div v-if="contentLoaded" class="position-sticky">
      <div>
        <div>
          <div v-if="_isallowed('read')" class="container-fluid px-0 mx-1">
            <div class="row row-2 mt-3 task-issue-risk-row">
              <div class="col" data-cy="facility_tasks">
                <el-card class="box-card" style="background-color:#fff">
                  <div class="row">
                    <div class="col pb-0">
                      <h5 class="d-inline">TASKS</h5>
                      <h5 class="d-inline">
                        <b
                          class="float-right badge badge-secondary badge-pill"
                          >{{ filteredTasks.length }}</b
                        >
                      </h5>
                      <hr />
                    </div>
                  </div>

                <div class="row text-center">
                <div class="col-3 p-0 mb-0">
                  
                  <span class="d-block" v-tooltip="`COMPLETE`" ><i class="fas fa-clipboard-check text-success"></i></span>
                  <span   :class="{'d-none': isMapView }" class="d-block smallerFont">COMPLETE</span>
                </div>
                 <div class="col-3 p-0 mb-0">
                  <span class="d-block" v-tooltip="`IN PROGRESS`"><i class="far fa-tasks text-primary"></i></span>
                 <span :class="{'d-none': isMapView }" class="d-block smallerFont"> IN PROGRESS</span>           
                </div>
                 <div class="col-3 p-0 mb-0">
                   <span class="d-block" v-tooltip="`OVERDUE`"><font-awesome-icon icon="calendar" class="text-danger"  /></span>
                 <span :class="{'d-none': isMapView }" class="d-block smallerFont">OVERDUE </span>               
                </div>
                 <div class="col-3 p-0 mb-0">
                   <span class="d-block" v-tooltip="`ONGOING`"> <i class="fas fa-retweet text-success"></i></span>
                 <span :class="{'d-none': isMapView }" class="d-block smallerFont">ONGOING </span>    
                </div>       
              </div>

              <div class="row text-center mt-0" :class="[taskStats.length > 0 ? '' : 'pb-3']">
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
                <div v-if="taskStats.length > 0" data-cy="task_categories">
                <el-collapse class="taskCard">
                  <el-collapse-item title="..." name="1">
                  <div class="row mt-1 text-center">
                 <div class="col-3 p-0  mb-0">
                  
                  <span class="d-block" v-tooltip="`PLANNED`"><font-awesome-icon icon="calendar-check" class="text-secondary font-md"  /></span>
                  <span :class="{'d-none': isMapView }" class="d-block smallerFont">PLANNED</span>
                </div>
                 <div class="col-3 p-0 mb-0">
                 <span  v-tooltip="`ON HOLD`" class="d-block"><i class="fas fa-pause-circle text-primary font-md"></i></span>
                 <span :class="{'d-none': isMapView }" class="d-block smallerFont"> ON HOLD  </span>           
                </div>
                 <div class="col-3 p-0 mb-0">
                <span  v-tooltip="`DRAFTS`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                 <span :class="{'d-none': isMapView }" class="d-block smallerFont">DRAFTS</span>               
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
                <div data-cy="task_categories" class="row">
                  <div class="col-5 underline">
                    CATEGORIES
                  </div>
                    <div class="col-2 pl-0">
                  #
                  </div>
                <div class="col-5 pl-3">
                  <span class="underline" :class="{ 'font-sm': isMapView }">PROGRESS</span>
                  </div>
                </div>
                <div
                  class="row"
                  v-for="(task, index) in taskStats"
                  :key="index"
                >
                  <div class="col-5 font-sm pr-0">
                    <span> {{ task.name }}</span>                          
                  </div>
                    <div class="col-2 pl-0">                          
                    <span class="badge badge-secondary  font-sm badge-pill">{{
                      task.count
                    }}</span>
                  </div>

                  <div class="col-5 mb-1">
                    <span
                      class="w-100 progress pg-content"
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
          </el-card>
        </div>

              <!-- Row 2, col-2 for Issues Card -->

              <div
                class="col px-0 mb-2"
                data-cy="facility_issues"
              >
                <el-card class="box-card" style="background-color:#fff">
                  <div class="row">
                    <div class="col pb-0">
                      <h5 class="d-inline">ISSUES</h5>
                      <h5 class="d-inline">
                        <b
                          class="float-right badge badge-secondary badge-pill"
                          >{{ filteredIssues.length }}</b
                        >
                      </h5>
                      <hr />
                    </div>
                  </div>

                <div class="row text-center">
                <div class="col-3 p-0 mb-0">                  
                  <span  v-tooltip="`COMPLETE`" class="d-block"><i class="fas fa-clipboard-check text-success"></i></span>
                  <span :class="{'d-none': isMapView }" class="d-block smallerFont">COMPLETE</span>
                </div>
                 <div class="col-3 p-0 mb-0">
                <span v-tooltip="`IN PROGRESS`" class="d-block"><i class="far fa-tasks text-primary"></i></span>
                 <span :class="{'d-none': isMapView }" class="d-block smallerFont">IN PROGRESS</span>           
                </div>
                 <div class="col-3 p-0 mb-0">
                 <span v-tooltip="`OVERDUE`" class="d-block"><font-awesome-icon icon="calendar" class="text-danger"  /></span>
                 <span :class="{'d-none': isMapView }" class="d-block smallerFont">OVERDUE</span>               
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


                  <!-- TASK CATEGORIES FOR ISSUE INSIDE COLLAPSIBLE SECTION -->

                  <div v-if="filteredIssues.length" data-cy="issue_types">
                    <el-collapse>
                      <el-collapse-item title="..." name="1">
                        <div v-if="contentLoaded">
                   <div class="row mt-1 text-center">
                    <div class="col-3 p-0  mb-0">                      
                      <span v-tooltip="`PLANNED`" class="d-block"><font-awesome-icon icon="calendar-check" class="text-secondary font-md"  /></span>
                      <span :class="{'d-none': isMapView }" class="d-block smallerFont">PLANNED</span>
                    </div>
                    <div class="col-3 p-0 mb-0">
                    <span v-tooltip="`ON HOLD`" class="d-block"><i class="fas fa-pause-circle text-primary font-md"></i></span>
                    <span :class="{'d-none': isMapView }" class="d-block smallerFont"> ON HOLD  </span>           
                    </div>
                    <div class="col-3 p-0 mb-0">
                    <span  v-tooltip="`DRAFTS`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                    <span :class="{'d-none': isMapView }" class="d-block smallerFont">DRAFTS</span>               
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
                            <div class="col-5 mt-1 underline">
                              CATEGORIES
                            </div>
                            <div class="col-2 pl-0">
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
                            <div class="col-5 pr-0">
                              <span> {{ issue.name }}</span>                           
                            </div>
                             <div class="col-2 pl-0">                             
                              <span class="badge badge-secondary  font-sm badge-pill">{{
                                issue.count
                              }}</span>
                            </div>
                            <div class="col-5 mb-1">
                              <span
                                class="w-100 progress pg-content"
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

                        <div data-cy="issue_types">
                          <div class="col mt-1 underline pl-0">
                            ISSUE TYPES
                          </div>
                        </div>

                        <div
                          class="row"
                          v-for="issue in issueStats"
                          :key="issue.id"
                        >
                          <div class="col-5 font-sm pr-0">
                            <span> {{ issue.name }}</span>                          
                          </div>
                           <div class="col-2 pl-0">                          
                            <span class="badge badge-secondary  font-sm badge-pill">{{
                              issue.count
                            }}</span>
                          </div>
                          <div class="col-5 mb-1">
                            <span
                              class="w-100 progress pg-content"
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
                </el-card>
              </div>

              <!-- Row 2, col-3 for Risks Card -->
              <div
                class="col pr-0"
                data-cy="facility_risks"
              >
                <el-card class="box-card" style="background-color:#fff">
                  <div class="row">
                    <div class="col pb-0">
                      <h5 class="d-inline">RISKS</h5>
                      <h5 v-if="contentLoaded" class="d-inline">
                        <b
                          class="float-right badge badge-secondary badge-pill"
                          >{{ filteredRisks.length }}</b
                        >
                      </h5>
                      <hr />
                    </div>
                  </div>                  
                  <div class="row text-center">
                  <div class="col-3 p-0 mb-0">                    
                    <span  v-tooltip="`COMPLETE`" class="d-block"><i class="fas fa-clipboard-check text-success"></i></span>
                    <span :class="{'d-none': isMapView }" class="d-block smallerFont">COMPLETE</span>
                  </div>
                  <div class="col-3 p-0 mb-0">
                  <span  v-tooltip="`IN PROGRESS`" class="d-block"><i class="far fa-tasks text-primary"></i></span>
                  <span :class="{'d-none': isMapView }" class="d-block smallerFont"> IN PROGRESS   </span>           
                  </div>
                  <div class="col-3 p-0 mb-0">
                  <span  v-tooltip="`OVERDUE`"  class="d-block"><font-awesome-icon icon="calendar" class="text-danger"  /></span>
                  <span :class="{'d-none': isMapView }" class="d-block smallerFont">OVERDUE </span>               
                  </div>
                  <div class="col-3 p-0 mb-0">
                    <span v-tooltip="`ONGOING`" class="d-block"> <i class="fas fa-retweet text-success"></i></span>
                  <span :class="{'d-none': isMapView }" class="d-block smallerFont">ONGOING</span>    
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
             

                  <!-- RISK CATEGORIES INSIDE COLLAPSIBLE SECTION -->
                  <div v-if="filteredRisks.length">
                    <el-collapse>
                      <el-collapse-item title="..." name="1">
                   <div class="row mt-1 text-center">
                  <div class="col-3 p-0  mb-0">                    
                    <span v-tooltip="`PLANNED`"  class="d-block"><font-awesome-icon icon="calendar-check" class="text-secondary font-md"  /></span>
                    <span :class="{'d-none': isMapView }" class="d-block smallerFont">PLANNED</span>
                  </div>
                  <div class="col-3 p-0 mb-0">
                   <span v-tooltip="`ON HOLD`" class="d-block"><i class="fas fa-pause-circle text-primary font-md"></i></span>
                  <span :class="{'d-none': isMapView }" class="d-block smallerFont"> ON HOLD  </span>           
                  </div>
                  <div class="col-3 p-0 mb-0">
                    <span v-tooltip="`DRAFTS`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                    <span :class="{'d-none': isMapView }" class="d-block smallerFont">DRAFTS</span>               
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
                          <div class="col-5 mt-1 underline">
                            CATEGORIES
                          </div>
                          <div class="col-2 pl-0">
                          #
                         </div>
                        <div class="col-5 pl-3">
                          <span class="underline" :class="{ 'font-sm': isMapView }">PROGRESS</span>
                         </div>
                        </div>
                        <div
                          v-for="(risk, index) in currentRiskTypes"
                          :key="index"
                        >
                          <div class="row" v-if="risk._display">
                            <div class="col-5 pr-0">
                              <span> {{ risk.name }}</span>                            
                            </div>
                            <div class="col-2 pl-0">                             
                              <span class="badge badge-secondary  font-sm badge-pill">{{
                                risk.length
                              }}</span>
                            </div>
                            <div class="col-5 mb-1">
                              <span
                                class="w-100 progress pg-content"
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

                        <div class="row mt-3 mb-2">
                          <div class="col underline">
                            RISK PRIORITY LEVELS
                          </div>
                        </div>
                        <div class="row font-sm">
                          <div class="col text-center">
                            <p class="mb-2 grey2">Very Low</p>
                            <p class="mb-2 green">Low</p>
                            <p class="mb-2 yellow">Moderate</p>
                          </div>
                          <div class="col">
                            <span
                              class="my-2 badge w-50 badge-secondary badge-pill d-block"
                              >{{ riskPriorityLevels.grey }}</span
                            >
                            <span
                              class="my-2 badge w-50 badge-secondary badge-pill d-block"
                              >{{ riskPriorityLevels.green }}</span
                            >
                            <span
                              class="my-2 badge w-50 badge-secondary badge-pill d-block"
                              >{{ riskPriorityLevels.yellow }}</span
                            >
                          </div>
                          <div class="col text-center">
                            <p class="mb-2 orange">High</p>
                            <p class="mb-2 red">Extreme</p>
                          </div>
                          <div class="col">
                            <span
                              class="my-2 badge w-50 badge-secondary badge-pill d-block"
                              >{{ riskPriorityLevels.orange }}</span
                            >
                            <span
                              class="my-2 badge w-50 badge-secondary badge-pill d-block"
                              >{{ riskPriorityLevels.red }}</span
                            >
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
                </el-card>
              </div>
                 <div class="col-2" :class="[isMapView ? 'col-6 pt-1' : '']" >
          <el-card
              class="box-card"
              style="background-color:#fff"
            
            >
              <div class="row">
                <div class="col pb-0">
                  <h6 class="d-inline">LESSONS LEARNED</h6>                 
                  <hr />
                </div>
              </div>
                <div class="row mt-0 pb-0 text-center">
                <div class="col py-0">
                 <span class="giantNumber">7</span>
                </div>
              </div>
                <div>
                <el-collapse>
                  <el-collapse-item title="..." name="1">
                <div class="row mt-1 text-center">
                LESSONS LEARNED DATA COMING SOON                  
                </div>

                  </el-collapse-item>
                </el-collapse>
              </div>

            
            </el-card>
               </div>
            </div>
            <div class="row row-1 mt-2">
              <div class="col-md-5 col-lg-5 col-sm-12" :class="[isMapView ? 'col-7' : '']">
                <div class="box-card my-el-card p-3" style="position:relative">
                  <div class="row">
                    <div class="col">
                      <p>PROJECT GROUP:</p>
                      <p>COMPLETION DATE:</p>
                      <p>
                        STATUS:
                        <span>
                          <small
                            v-if="!facility.statusId && _isallowed('write')"
                            class="ml-2 d-inline text-danger"
                            style="position:absolute"
                          >
                            Must be updated before you can enter a Completion
                            Date!
                          </small>
                        </span>
                      </p>
                    </div>

                    <div class="col">
                      <p
                        class="badge badge-secondary badge-pill font-weight-light"
                      >
                        {{ facility.facility.facilityGroupName }}
                      </p>
                      <div class="simple-select">
                        <v2-date-picker
                          v-model="dueDate"
                          value-type="YYYY-MM-DD"
                          format="DD MMM YYYY"
                          class="w-100 vue2-datepicker"
                          @input="onChange"
                          placeholder="DD MM YYYY"
                          :disabled="!_isallowed('write') || !facility.statusId"
                        />
                      </div>

                      <div class="el-dropdown-wrapper my-2">
                        <el-select
                          v-model="statusId"
                          track-by="id"
                          class="w-100"
                          @change="onChange"
                          :disabled="!_isallowed('write')"
                          placeholder="Select Project Status"
                        >
                          <el-option
                            v-for="item in statuses"
                            :label="item.name"
                            :key="item.id"
                            :value="item.id"
                          >
                          </el-option>
                        </el-select>
                      </div>
                    </div>
                  </div>
                  <button
                    v-if="_isallowed('write') && DV_updated"
                    class="btn btn-secondary mt-2 btn-sm apply-btn w-100"
                    @click="updateFacility"
                    :disabled="!DV_updated"
                  >
                    Apply
                  </button>
                </div>
              </div>

              <div
                class="col-md-2 col-lg-2 col-sm-6 pl-0"
                data-cy="date_set_filter"
              >
                <el-card class="box-card" style="background-color:#fff">
                  <div class="row">
                    <div class="col">
                     <h5 class="d-inline">PROGRESS</h5>
                      <hr />
                      <p class="text-center">
                        <span :class="{ 'progress-0': facility.progress <= 0 }">
                          <el-progress
                            type="circle"
                            :percentage="facility.progress"
                          ></el-progress>
                        </span>
                      </p>
                    </div>
                  </div>
                </el-card>
              </div>

              <div class="col-md-3 col-lg-3 col-sm-6" v-show="isSheetsView"  data-cy="date_set_filter">
                <el-card
                  class="box-card"
                  style="background-color: #41b883; color:#fff"
                >
                  <div class="row">
                    <div class="col">
                      <h5 class="d-inline">Filters</h5>
                      <hr style="background-color: #fff; color:#fff" />
                    </div>
                  </div>

                  <div
                    v-for="(filterArray, index) in getAllFilterNames"
                    :key="index"                  
                  >
                    <span v-if="getFilterValue(filterArray[0])">
                      <span
                        ><b class="mr-1">{{ filterArray[1] }}:</b>
                        {{ getFilterValue(filterArray[0]) }}
                      </span>
                    </span>
                  </div>
                  <span
                    v-show="
                      facilities.length !== getUnfilteredFacilities.length
                    "
                    >Map Boundary Filter: Active</span
                  >
                </el-card>
              </div>

              <div
                v-show="isSheetsView" 
                class="col-md-2 col-lg-2 col-sm-6 pl-0"
                data-cy="date_set_filter"
              >
                <el-card class="box-card" style="background-color: #fafafa">
                  <div class="row">
                    <div class="col">
                      <h5 class="d-inline">CONTACT</h5>
                      <hr class="mb-0 pb-0" />
                    </div>
                  </div>
                  <div class="row">
                    <div class="col font-sm">
                      <p class="mt-1">
                        <span class="fbody-icon"
                          ><i class="far fa-id-badge"></i
                        ></span>
                        <span>{{
                          facility.facility.pointOfContact || "N/A"
                        }}</span>
                      </p>
                      <p class="mt-0">
                        <span class="fbody-icon"
                          ><i class="fas fa-map-marker"></i
                        ></span>
                        <span>{{ facility.facility.address || "N/A" }}</span>
                      </p>
                      <p class="my-0">
                        <span class="fbody-icon"
                          ><i class="fas fa-phone"></i
                        ></span>
                        <span>{{
                          facility.facility.phoneNumber || "N/A"
                        }}</span>
                      </p>
                      <p class="my-0">
                        <span class="fbody-icon"
                          ><i class="far fa-envelope"></i
                        ></span>
                        <span>{{ facility.facility.email || "N/A" }}</span>
                      </p>
                    </div>
                  </div>
                </el-card>
              </div>
            </div>
            <!-- SECOND ROW WITH TASKS ISSUES & RISKS -->

            <!-- Row 2, col-1 for Tasks Card -->
            
          </div>
          <div v-else class="text-danger mx-2 my-4">
            You don't have permission to read!
          </div>
        </div>
      </div>
    </div>
    <div v-else></div>
  </div>
</template>

<script>
import http from "../../../common/http";
import { mapGetters, mapMutations } from "vuex";
import Loader from "../../shared/loader";

export default {
  name: "SheetOverview",
  components: {
    Loader,
  },
  props: ["facility"],
  data() {
    return {
      dueDate: "",
      statusId: 0,
      today:  new Date().toISOString().slice(0, 10),
      loading: true,
      DV_updated: false,
      notesQuery: "",
      _selected: null,
      _categories: null,
    };
  },
  mounted() {
    this.dueDate = this.facility.dueDate;
    this.statusId = this.facility.statusId;
  },
  methods: {
    ...mapMutations(["setTaskTypeFilter", "updateFacilityHash"]),
    updateFacility(e) {
      if (e.target) e.target.blur();
      if (!this._isallowed("write") || !this.DV_updated) return;
      this.DV_updated = false;
      let data = {
        facility: {
          statusId: this.statusId,
          dueDate: this.dueDate,
        },
      };
      // Used to update state
      let updatedFacility = Object.assign(this.facility, {
        statusId: this.statusId,
        dueDate: this.dueDate,
        projectStatus: this.statuses.find(
          (status) => status.id === this.statusId
        ).name,
      });

      http
        .put(
          `/projects/${this.currentProject.id}/facilities/${this.$route.params.projectId}.json`,
          data
        )
        .then((res) => {
          this.updateFacilityHash(updatedFacility);
          if (res.status === 200) {
            this.$message({
              message: `${res.data.facility.facilityName} was saved successfully.`,
              type: "success",
              showClose: true,
            });
          }
        })
        .catch((err) => {
          console.error(err);
        });
    },
    isBlockedStatus(status) {
      return (
        status &&
        status.name.toLowerCase().includes("complete") &&
        this.facility.progress < 100
      );
    },
   onChange() {
      this.$nextTick(() => {
        this.DV_updated = true;
      });
    },
  },
  computed: {
    ...mapGetters([
      "getTaskIssueUserFilter",
      "filterDataForAdvancedFilter",
      "facilityGroupFacilities",
      "taskTypes",
      "getAllFilterNames",
      "getFilterValue",
      "contentLoaded",
      "currentProject",
      "taskTypeFilter",
      "issueTypeFilter",
      "riskStageFilter",
      "issueSeverityFilter",
      "getRiskPriorityLevelFilter",
      "taskUserFilter",
      "taskStageFilter",
      "issueStageFilter",
      "riskStageFilter",
      "issueUserFilter",
      "statuses",
      "myActionsFilter",
      "onWatchFilter",
      "facilities",
      "getUnfilteredFacilities",
    ]),
    selectedStatus: {
      get() {
        return this.facility.statusId; //this.$data._selected
      },
      set(value) {
        this.$data._selected = value;
        // this.facility.statusId = value
        // console.log(value)
        if (value) {
          this.$nextTick(() => {
            this.DV_updated = true;
          });
          this.facility.statusId = value;
        }
      },
    },
    C_taskTypeFilter: {
      get() {
        return this.taskTypeFilter;
      },
      set(value) {
        //  console.log(" C_taskTypeFilter set value: " + value)
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
    isMapView() {
      return this.$route.name.includes("Map");
    },
    isSheetsView() {
      return this.$route.name.includes("Sheet");
    },
    filteredTasks() {
      let typeIds = _.map(this.taskTypeFilter, "id");
      let stageIds = _.map(this.taskStageFilter, "id");
      let taskIssueUsers = this.getTaskIssueUserFilter;

      return _.filter(this.facility.tasks, (resource) => {
        let valid = true;
        let userIds = [
          ..._.map(resource.checklists, "userId"),
          ...resource.userIds,
        ];

        if (taskIssueUsers.length > 0) {
          if (taskIssueUsers.length > 0) {
            valid =
              valid &&
              userIds.some(
                (u) => _.map(taskIssueUsers, "id").indexOf(u) !== -1
              );
          }
        }
        //TODO: For performance, send the whole tasks array instead of one by one
        valid =
          valid &&
          this.filterDataForAdvancedFilter([resource], "facilityShowTasks");

        if (stageIds.length > 0)
          valid = valid && stageIds.includes(resource.taskStageId);
        if (typeIds.length > 0)
          valid = valid && typeIds.includes(resource.taskTypeId);
        return valid;
      });
    },
    taskStats() {
      let tasks = new Array();
      let group = _.groupBy(this.filteredTasks, "taskType");
      for (let type in group) {
        tasks.push({
          name: type,
          count: group[type].length,
          progress: Number((_.meanBy(group[type], "progress") || 0).toFixed(0)),
        });
      }
      return tasks;
    },
    // TODO: Move this calculation to back-end so that statistics can be available for other devices
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
        (t) => t && t.progress && t.progress == 100 && t.draft == false
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
    filteredIssues() {
      let taskTypeIds = _.map(this.taskTypeFilter, "id");
      let typeIds = _.map(this.issueTypeFilter, "id");
      let severityIds = _.map(this.issueSeverityFilter, "id");
      let stageIds = _.map(this.issueStageFilter, "id");
      let taskIssueUsers = this.getTaskIssueUserFilter;

      return _.filter(this.facility.issues, (resource) => {
        let valid = true;
        let userIds = [
          ..._.map(resource.checklists, "userId"),
          ...resource.userIds,
        ];

        if (taskIssueUsers.length > 0) {
          if (taskIssueUsers.length > 0) {
            valid =
              valid &&
              userIds.some(
                (u) => _.map(taskIssueUsers, "id").indexOf(u) !== -1
              );
          }
        }
        //TODO: For performance, send the whole tasks array instead of one by one
        valid =
          valid &&
          this.filterDataForAdvancedFilter([resource], "facilityShowIssues");

        if (taskTypeIds.length > 0)
          valid = valid && taskTypeIds.includes(resource.taskTypeId);
        if (typeIds.length > 0)
          valid = valid && typeIds.includes(resource.issueTypeId);
        if (severityIds.length > 0)
          valid = valid && severityIds.includes(resource.issueSeverityId);
        if (stageIds.length > 0)
          valid = valid && stageIds.includes(resource.issueStageId);
        return valid;
      });
    },
    issueStats() {
      let issues = new Array();
      let group = _.groupBy(this.filteredIssues, "issueType");
      for (let type in group) {
        issues.push({
          name: type,
          count: group[type].length,
          progress: Number((_.meanBy(group[type], "progress") || 0).toFixed(0)),
        });
      }
      return issues;
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
    // TODO: Move this calculation to back-end so that statistics can be available for other devices
  issueVariation() {
     let planned = _.filter(
        this.filteredIssues,
        (t) => !t.draft && t.startDate && t.startDate > this.today     
      );     
      let issueDrafts = _.filter(
        this.filteredIssues,
         (t) => t && t.draft == true 
      );      
      let completed = _.filter(
        this.filteredIssues,
        (t) => t && t.progress && t.progress == 100  && t.draft == false
      );
      let completed_percent = this.getAverage(
        completed.length,
        this.filteredIssues.length
      ); 
       let inProgress = _.filter(
        this.filteredIssues,
        (t) => t && t.progressStatus == 'active' && t.draft == false && !t.isOverdue && t.onHold == false && !t.ongoing && t.startDate <= this.today 
        );
      let onHoldI = _.filter(
        this.filteredIssues,
        (t) => t && t.onHold == true && t.progressStatus == 'active' && !t.isOverdue && !t.ongoing
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
    filteredRisks() {
      let typeIds = _.map(this.taskTypeFilter, "id");
      let riskPriorityLevelIds = _.map(this.getRiskPriorityLevelFilter, "id");
      let stageIds = _.map(this.riskStageFilter, "id");
      let riskApproachIds = _.map(this.C_riskApproachFilter, "id");
      let taskIssueUsers = this.getTaskIssueUserFilter;

      return _.filter(this.facility.risks, (resource) => {
        let valid = true;
        let userIds = [
          ..._.map(resource.checklists, "userId"),
          ...resource.userIds,
        ];

        if (taskIssueUsers.length > 0) {
          if (taskIssueUsers.length > 0) {
            valid =
              valid &&
              userIds.some(
                (u) => _.map(taskIssueUsers, "id").indexOf(u) !== -1
              );
          }
        }
        //TODO: For performance, send the whole tasks array instead of one by one
        valid =
          valid &&
          this.filterDataForAdvancedFilter([resource], "facilityShowTasks");

        if (stageIds.length > 0)
          valid = valid && stageIds.includes(resource.riskStageId);
        if (typeIds.length > 0)
          valid = valid && typeIds.includes(resource.taskTypeId);
        if (riskApproachIds.length > 0)
          valid = valid && riskApproachIds.includes(resource.riskApproach);
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
    // TODO: Move this calculation to back-end so that statistics can be available for other devices
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
    _isallowed() {
      return (salut) =>
        this.$currentUser.role == "superadmin" ||
        this.$permissions.overview[salut];
    },
  },
  watch: {
    contentLoaded: {
      handler() {
        this.dueDate = this.facility.dueDate;
        this.statusId = this.facility.statusId;
      },
    },
  },
};
</script>

<style lang="scss" scoped>
.f-head {
  word-break: break-word;
  text-overflow: ellipsis;
}
.f-notes {
  border: 1px solid #ccc;
  padding: 5px 10px;
  border-radius: 5px;
  overflow: auto;
  min-height: 20vh;
  max-height: 34vh;
}
.f-show-btn {
  font-size: 12px;
  font-style: italic;
  display: flex;
  flex-direction: row-reverse;
}
.custom-tab {
  background-color: #ededed !important;
  width: auto;
  text-transform: uppercase;
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.apply-btn,
.red,
.orange,
.green,
.grey,
.grey2,
.yellow {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.pg-content {
  width: 100%;
  height: 20px;
  font-size: 14px;
  font-weight: bold;
}
.vue-tabs {
  margin-top: 15px;
}
.vdp-datepicker {
  width: 100%;
}
.search-tab {
  width: 80%;
}
.displayNone {
  display: none !important;
}
.fa-building {
  font-size: large !important;
  color: #383838 !important;
}
.close-sidebar-btn {
  z-index: 800;
  cursor: pointer;
  display: flex;
  position: absolute;
  left: 0;
  top: 0;
  background: #fff;
  padding: 5px;
}
.my-el-card {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}
.vue2-datepicker /deep/ .mx-input:disabled {
  color: #555;
  background-color: #fff;
}
.simple-select /deep/ .multiselect {
  .multiselect__placeholder {
    text-overflow: ellipsis;
  }
}

.fac-sum {
  border-radius: 2px;
  padding: 8px;
  margin-bottom: 8px;
  background-color: #fff;
  box-shadow: 0 5px 5px rgba(0, 0, 0, 0.19), 0 3px 3px rgba(0, 0, 0, 0.23);
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
.green {
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
.grey2 {
  border-radius: 3px;
}
.risk-card-title {
  font-size: 1rem;
}
.font-12 {
  font-size: 12px;
}
.mt-neg-4 {
  margin-top: -4px;
}
.underline {
  text-decoration: underline;
}
.smallerFont {
  font-size: 10px;
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
.giantNumber {
  font-size: 3.7rem;
}

</style>
