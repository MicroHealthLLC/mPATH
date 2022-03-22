
<template>
  <div v-if="contentLoaded" id="facility-sheets" data-cy="facility_sheets">
    <div v-if="_isallowed('read')" class="px-0 mx-0">
    <div class="row row-1 mt-1 task-issue-risk-row">
      <!-- Tasks Cards -->
    <div class="col-12 pr-0" data-cy="facility_tasks">
        <el-card class="box-card" style="background-color:#fff">
          <div class="row">
            <div class="col pb-2 relative" >
                      <h5 class="d-inline text-light px-2 mh-blue absolute">TASKS</h5>
                      <h5 class="d-inline">
                        <b
                          class="badge badge-secondary badge-pill pill"
                          >{{ filteredTasks.length }}</b
                        >
                      </h5>
                      <!-- <hr /> -->
                    </div>
                  </div>
              <div class="row text-center mt-4">
            <div class="col p-0 mb-0">
                  
                  <span class="d-block"  v-tooltip="`100% Progress achieved`"><i class="fas fa-clipboard-check text-success"></i></span>
                  <span class="d-block smallerFont">COMPLETE</span>
                </div>
                 <div class="col p-0 mb-0">
                  <span class="d-block" v-tooltip="`Start date on or before current date`"><i class="far fa-tasks text-primary"></i></span>
                 <span class="d-block smallerFont"> IN PROGRESS</span>           
                </div>

                 <div class="col p-0 mb-0">                 
                  <span class="d-block" v-tooltip="`Start date beyond current date (not a Draft)`"><i class="fas fa-calendar-check text-info font-md"></i></span>
                  <span class="d-block smallerFont">PLANNED</span>
                </div>
                 <div class="col p-0 mb-0">
                   <span class="d-block" v-tooltip="`Due Date has passed`"><i class="fas fa-calendar text-danger"> </i></span>
                 <span class="d-block smallerFont">OVERDUE </span>               
                </div>
                     <div class="col p-0 mb-0">
                 <span  v-tooltip="`Temporarily halted`" class="d-block"><i class="fas fa-pause-circle text-primary font-md"></i></span>
                 <span class="d-block smallerFont"> ON HOLD  </span>           
                </div>         
            
                 <div class="col p-0 mb-0">
                <span  v-tooltip="`Unofficial action`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                 <span class="d-block smallerFont">DRAFTS</span>               
                </div>
                  <div class="col p-0 mb-0">
                   <span class="d-block" v-tooltip="`Recurring action without Due Date`"> <i class="fas fa-retweet text-success"></i></span>
                 <span class="d-block smallerFont">ONGOING </span>    
                </div> 
              </div>

            <div class="row text-center mt-0" :class="[taskStats.length > 0 ? '' : 'pb-3']">
              <div class="col pb-0 mb-0">
                  <h4 class="mb-0">{{
                  taskVariation.completed.count
                }}</h4>         
              </div>
                <div class="col pb-0 mb-0">
                <h4 class="mb-0">{{
                  taskVariation.inProgress.count
                }}</h4>        
              </div>

              <div class="col pb-0 mb-0">
                  <h4 class="mb-0">{{
                  taskVariation.planned.count
                }}</h4>         
              </div>
                <div class="col pb-0 mb-0">
                   <h4 class="mb-0">{{ taskVariation.overdue.count }}
                     </h4>                                    
                </div>
                <div class="col pb-0 mb-0">
                  <h4 class="mb-0">{{
                    taskVariation.onHoldT.count
                  }}</h4>        
                </div>
                 <div class="col pb-0 mb-0">
                   <h4 class="mb-0">{{  taskVariation.taskDrafts.count }}</h4>                      
                </div>                   
                 <div class="col pb-0 mb-0">
                  <h4 class="mb-0">{{
                    taskVariation.ongoing.length
                  }}<span v-tooltip="`Ongoing: Closed`"
                          v-if="taskVariation.ongoingClosed.count > 0"
                          style="color:lightgray"
                          >({{taskVariation.ongoingClosed.count}})</span></h4>          
                </div>    
              </div>  

          <div v-if="taskStats.length > 0" data-cy="task_categories">
            <el-collapse>
              <el-collapse-item title="..." name="1">           
                <div data-cy="task_categories" class="row">
                  
                  <div class="col-5 pb-0 mt-1 underline">
                      CATEGORIES
                    </div>
                    <div class="col-2 pb-0 pl-0">
                      #
                    </div>
                        <div class="col-5 pb-0 pl-3">
                          <span class="underline">PROGRESS</span>
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
                    <span class="badge badge-secondary font-sm badge-pill">{{
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
      <!-- Issues Card -->
    </div>
        <div class="row">
        <div
            class="col-12 py-0 pr-0"
            data-cy="facility_issues"
              >
                <el-card class="box-card" style="background-color:#fff">
                  <div class="row mb-3">
                    <div class="col pb-2 relative">
                      <h5 class="text-light px-2 mh-green absolute">ISSUES</h5>
                      <h5 class="d-inline">
                        <b
                          class="badge badge-secondary badge-pill pill"
                          >{{ filteredIssues.length }}</b
                        >
                      </h5>
                    
                    </div>
                  </div>

                <div class="row text-center mt-3">
                  <div class="col p-0 mb-0">                  
                    <span  class="d-block" v-tooltip="`100% Progress achieved`" ><i class="fas fa-clipboard-check text-success"></i></span>
                    <span  class="d-block smallerFont">COMPLETE</span>
                  </div>
                  <div class="col p-0 mb-0">
                  <span class="d-block"  v-tooltip="`Start date on or before current date`"><i class="far fa-tasks text-primary"></i></span>
                  <span  class="d-block smallerFont">IN PROGRESS</span>           
                  </div>
                  <div class="col p-0  mb-0">                      
                    <span class="d-block" v-tooltip="`Start date beyond current date (not a Draft)`"><i class="fas fa-calendar-check text-info font-md"></i></span>
                    <span  class="d-block smallerFont">PLANNED</span>
                  </div>
                  <div class="col p-0 mb-0">
                  <span class="d-block" v-tooltip="`Due Date has passed`"><i class="fas fa-calendar text-danger"> </i></span>
                  <span  class="d-block smallerFont">OVERDUE</span>               
                  </div>
                  
                  <div class="col p-0 mb-0">
                  <span v-tooltip="`Temporarily halted`"  class="d-block"><i class="fas fa-pause-circle text-primary font-md"></i></span>
                  <span  class="d-block smallerFont"> ON HOLD  </span>           
                  </div>
                  <div class="col p-0 mb-0">
                  <span  v-tooltip="`Unofficial action`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                  <span  class="d-block smallerFont">DRAFTS</span>               
                  </div>     
                   <div class="col p-0 mb-0">
                  <span class="d-block hide"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                  <span class="d-block smallerFont hide">DRAFTS</span>               
                  </div>                 
              </div>


                <div class="row text-center mt-0" :class="[filteredIssues.length > 0 ? '' : 'pb-3']">
                <div class="col pb-0 mb-0">
                   <h4 class="mb-0">{{
                    issueVariation.completed.count
                  }}</h4>         
                </div>
                 <div class="col pb-0 mb-0">
                  <h4 class="mb-0">{{
                    issueVariation.inProgress.count
                  }}</h4>        
                </div>
                <div class="col pb-0 mb-0">
                    <h4 class="mb-0">{{
                      issueVariation.planned.count
                    }}</h4>         
                  </div>
                 <div class="col pb-0 mb-0">
                   <h4 class="mb-0">{{ issueVariation.overdue.count }}
                     </h4>                      
                </div>  
                
                  <div class="col pb-0 mb-0">
                    <h4 class="mb-0">{{
                      issueVariation.onHoldI.count
                    }}</h4>        
                  </div>
                  <div class="col pb-0 mb-0">
                    <h4 class="mb-0">{{ issueVariation.issueDrafts.count }}</h4>                      
                  </div>
                    <div class="col pb-0 mb-0">
                    <h4 class="mb-0 hide">{{ issueVariation.issueDrafts.count }}</h4>                      
                  </div>
                </div>


                  <!-- TASK CATEGORIES FOR ISSUE INSIDE COLLAPSIBLE SECTION -->

                  <div v-if="filteredIssues.length" data-cy="issue_types">
                    <el-collapse>
                      <el-collapse-item title="..." name="1">
                        <div v-if="contentLoaded">                
                          <div class="row">
                            <div class="col-5 pb-0 mt-1 underline">
                              CATEGORIES
                            </div>
                            <div class="col-2 pb-0 pl-0">
                             #
                            </div>
                        <div class="col-5 pb-0 pl-3">
                          <span class="underline" >PROGRESS</span>
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
      </div>


    <div class="row">
      <!-- Risks Card -->
        <div
                class="col-12 pr-0"
                data-cy="facility_risks"
              >
                <el-card class="box-card" style="background-color:#fff">
                  <div class="row mb-3">
                    <div class="col pb-2 relative">
                       <h5 class="text-light px-2 mh-orange absolute">RISKS</h5>
                      <h5 class="d-inline">
                        <b
                          class="badge badge-secondary badge-pill pill"
                          >{{ filteredRisks.length }}</b
                        >
                      </h5>                    
                    </div>
                  </div>                  
                <div class="row text-center mt-3">
                  <div class="col p-0 mb-0">                    
                    <span v-tooltip="`100% Progress achieved`" class="d-block"><i class="fas fa-clipboard-check text-success"></i></span>
                    <span  class="d-block smallerFont">COMPLETE</span>
                  </div>
                  <div class="col p-0 mb-0">
                  <span v-tooltip="`Start date on or before current date`" class="d-block"><i class="far fa-tasks text-primary"></i></span>
                  <span  class="d-block smallerFont"> IN PROGRESS   </span>           
                  </div>
                   <div class="col p-0  mb-0">                    
                    <span v-tooltip="`Start date beyond current date (not a Draft)`" class="d-block"><font-awesome-icon icon="calendar-check" class="text-info font-md"  /></span>
                    <span  class="d-block smallerFont">PLANNED</span>
                  </div>
                  <div class="col p-0 mb-0">
                  <span v-tooltip="`Due Date has passed`" class="d-block"><i class="fas fa-calendar text-danger"> </i></span>
                  <span  class="d-block smallerFont">OVERDUE </span>               
                  </div>
                      <div class="col p-0 mb-0">
                   <span v-tooltip="`Temporarily halted`" class="d-block"><i class="fas fa-pause-circle text-primary font-md"></i></span>
                  <span  class="d-block smallerFont"> ON HOLD  </span>           
                  </div>
                  <div class="col p-0 mb-0">
                    <span v-tooltip="`Unofficial action`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                    <span  class="d-block smallerFont">DRAFTS</span>               
                  </div> 
                    <div class="col p-0 mb-0">
                    <span v-tooltip="`Recurring action without Due Date`" class="d-block"> <i class="fas fa-retweet text-success"></i></span>
                  <span  class="d-block smallerFont">ONGOING</span>    
                  </div> 
               </div>

              <div class="row text-center mt-0" :class="[filteredRisks.length > 0 ? '' : 'pb-3']">
                <div class="col pb-0 mb-0">
                   <h4 class="mb-0">{{
                    riskVariation.completed.count
                  }}</h4>         
                </div>
                 <div class="col pb-0 mb-0">
                  <h4 class="mb-0">{{
                    riskVariation.inProgress.count
                  }}</h4>        
                </div>
                 <div class="col pb-0 mb-0">
                  <h4 class="mb-0">{{
                    riskVariation.planned.count
                  }}</h4>         
                </div>
                 <div class="col pb-0 mb-0">
                   <h4 class="mb-0">{{ riskVariation.overdue.count }}
                     </h4>              
                       
                </div>
                 <div class="col pb-0 mb-0">
                   <h4 class="mb-0">{{
                    riskVariation.onHoldR.count
                  }}</h4>        
                </div>

                 <div class="col pb-0 mb-0">
                   <h4 class="mb-0">{{  riskVariation.riskDrafts.count }}</h4>                      
                </div>
                 <div class="col pb-0 mb-0">
                   <h4 class="mb-0">{{
                    riskVariation.ongoing.length
                  }}<span v-tooltip="`Ongoing: Closed`"
                          v-if="riskVariation.ongoingClosed.count > 0"
                          style="color:lightgray"                  
                  >({{riskVariation.ongoingClosed.count}})</span></h4>          
                </div>            
        
              </div>          
             

                  <!-- RISK CATEGORIES INSIDE COLLAPSIBLE SECTION -->
                  <div v-if="filteredRisks.length">
                    <el-collapse>
                      <el-collapse-item title="..." name="1">
                        <div class="row">
                          <div class="col-5 mt-1 underline">
                            CATEGORIES
                          </div>
                          <div class="col-2 pl-0">
                          #
                         </div>
                        <div class="col-5 pl-3">
                          <span class="underline">PROGRESS</span>
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
      </div>
   
      <div class="row row-1 mt-2">
         <div class="col-4">
         <el-card
            class="box-card"
            style="background-color:#fff"
           
          >
            <div class="row mb-4 pb-3">
               <div class="col pb-0 relative">
                <h5 class="text-light px-2 bg-secondary absolute">LESSONS</h5>
                <h5 v-if="contentLoaded" class="d-inline">
                  <b class="pill badge badge-secondary badge-pill pill mr-1">{{
                   projectLessons.length
                  }}</b>
                </h5>
               
             
              </div>
            </div>

            <div v-if="contentLoaded">
               <div class="row mt-4 text-center" >
                <div class="col-6 p-0 mb-0">                  
                  <span class="d-block" v-tooltip="`COMPLETE`"><i class="fas fa-clipboard-check text-success"></i></span>
                       <span class="smallerFont">COMPLETE</span>
                </div>
                 <div class="col-6 p-0 mb-0">
                <span class="d-block" v-tooltip="`DRAFTS`"><i class="fas fa-pencil-alt text-warning"></i></span>
                     <span class="smallerFont">DRAFTS</span>           
                </div>
                
                  </div>
                <div class="row text-center mb-4 mt-0">
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

      </div>
    </div>
    <div v-else class="text-danger mx-2 my-4">
      You don't have permission to read!
    </div>
  </div>
</template>

<script>
import http from "../../../common/http";
import { mapGetters, mapMutations, mapActions } from "vuex";
import Loader from "../../shared/loader";
import {API_BASE_PATH} from './../../../mixins/utils'

export default {
  name: "MapOverview",
  components: {
    Loader,
  },
  props: ["facility"],
  data() {
    return {
      dueDate: "",
      statusId: 0,
      loading: true,
      DV_updated: false,
      notesQuery: "",
      today: new Date().toISOString().slice(0, 10),
      _selected: null,
      _categories: null,
    };
  },
  mounted() {
     this.fetchProjectLessons(this.$route.params);
    if (Vue.prototype.$preferences.sub_navigation_menu) {
      this.currentTab = Vue.prototype.$preferences.sub_navigation_menu;
    }
    if (this.contentLoaded) {
      this.dueDate = this.facility.dueDate;
      this.statusId = this.facility.statusId;
    }
  },
  methods: {
    ...mapActions(["fetchProjectLessons"]),
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
          `${API_BASE_PATH}/programs/${this.currentProject.id}/projects/${this.$route.params.projectId}.json`,
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
   _isallowed(salut) {
      return this.checkPrivileges("MapOverview", salut, this.$route)

    // var programId = this.$route.params.programId;
    // var projectId = this.$route.params.projectId
    // let fPrivilege = this.$projectPrivileges[programId][projectId]
    // let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    // let s = permissionHash[salut]
    // return  fPrivilege.overview.includes(s);      
    },
  },
  computed: {
    ...mapGetters([
      "getTaskIssueUserFilter",
      "filterDataForAdvancedFilter",
      "taskTypes",
      "contentLoaded",
      "currentProject",
      "projectLessons",
      "taskTypeFilter",
      "issueTypeFilter",
      "riskStageFilter",
      "issueSeverityFilter",
      "getRiskPriorityLevelFilter",
      "taskStageFilter",
      "issueStageFilter",
      "riskStageFilter",
      "statuses",
      "myActionsFilter",
      "onWatchFilter",
      "facilities",
    ]),
    selectedStatus: {
      get() {
        return this.facility.statusId;
      },
      set(value) {
        this.$data._selected = value;

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
    
       if (isNaN(final)) {
        return 0
      } else return final 
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
    
       if (isNaN(final)) {
        return 0
      } else return final 
  
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
      if (isNaN(final)) {
        return 0
      } else return final 
    },
    projectTotalProgress(){
      let sum = this.allTasksProgress + this.allRisksProgress + this.allIssuesProgress
      let total = sum / 3
      return Math.round(total)
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
          count: inProgress.length - planned.length,
          percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          percentage: Math.round(overdue_percent),
        },
        ongoingClosed: {
          count: ongoingClosed.length,         
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
        (t) => t.planned == true  
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
    lessonVariation() {
      let completes = this.projectLessons.filter(l => !l.draft )
       let drafts = this.projectLessons.filter(l => l.draft)
      return {
        completes,
        drafts
      }
    },
    lessonStats() {
      let lessons = new Array();
      let group = _.groupBy(this.projectLessons, "category");
      for (let type in group) {
        lessons.push({
          name: type,
          count: group[type].length,
        });
      }
      return lessons;
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
.vue2-datepicker /deep/ .mx-input:disabled {
  color: #555;
  background-color: #fff;
}
.simple-select /deep/ .multiselect {
  .multiselect__placeholder {
    text-overflow: ellipsis;
  }
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
  font-size: 2.75rem;
}

.lessonsCard {
  /deep/.el-card__body{
    min-height: 161px;
  }
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
  right: 3%;
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
.my-el-card {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}
.filterCol {
  height: 70px;
}

</style>

