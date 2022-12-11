<!--  NOTE: This file is used in Sheets view as overview tab -->
<template>
  <div id="facility-sheets" data-cy="facility_sheets">
    <div v-if="contentLoaded" class="position-sticky">
      <div>
        <div>
          <div v-if="_isallowed('read')" class="container-fluid px-0 mx-1">
            <!-- <div v-if="_isallowed('read')" class="container-fluid px-0 mx-1"> -->

            <div class="row filterDiv">
              <div class="text-center filterLabel underline">
                <small class="px-2 bg">FILTERS </small>
              </div>
              <div class="col filterCol text-right">
                <div class="d-inline-block mr-1" v-for="(filterArray, index) in getAllFilterNames" :key="index">
                  <span class="d-inline" v-if="getFilterValue(filterArray[0])">
                    <span class="filter-green d-inline font-sm text-light px-2">{{
                       getFilterValue(filterArray[0])  }}</span>
                  </span>
                </div>
              </div>
            </div>
            <div class="row row-1 mt-3 task-issue-risk-row">
              <div class="col-9 pr-0" data-cy="facility_tasks">
                <el-card class="box-card" style="background-color: #fff">
                  <div class="row mb-3">
                    <div class="col pb-2 relative">
                      <h5 class="d-inline text-light px-2 mh-blue absolute">
                        TASKS
                      </h5>
                      <h4 class="d-inline">
                        <b class="badge badge-secondary badge-pill pill">{{
                           filteredTasks.length 
                          }}</b>
                      </h4>
                      <!-- <hr /> -->
                    </div>
                  </div>

                  <div class="row text-center mt-3">
                    <div class="col p-0 mb-0">
                      <span class="d-block" v-tooltip="`100% Progress achieved`"><i
                          class="fas fa-clipboard-check text-success"></i></span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">COMPLETE</span>
                    </div>
                    <div class="col p-0 mb-0">
                      <span class="d-block" v-tooltip="`Start date on or before current date`"><i
                          class="far fa-tasks text-primary"></i></span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">IN
                        PROGRESS</span>
                    </div>

                    <div class="col p-0 mb-0">
                      <span class="d-block" v-tooltip="
                        `Start date beyond current date (not a Draft)`
                      ">
                        <font-awesome-icon icon="calendar-check" class="text-info font-md" />
                      </span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">PLANNED</span>
                    </div>
                    <div class="col p-0 mb-0">
                      <span class="d-block" v-tooltip="`Due Date has passed`">
                        <i class="fas fa-calendar text-danger"> </i></span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">OVERDUE
                      </span>
                    </div>
                    <div class="col p-0 mb-0">
                      <span v-tooltip="`Temporarily halted`" class="d-block"><i
                          class="fas fa-pause-circle text-primary font-md"></i></span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">ON HOLD
                      </span>
                    </div>

                    <div class="col p-0 mb-0">
                      <span v-tooltip="`Unofficial action`" class="d-block"><i
                          class="fas fa-pencil-alt text-warning font-md"></i></span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">DRAFTS</span>
                    </div>
                    <div class="col p-0 mb-0">
                      <span class="d-block" v-tooltip="`Recurring action without Due Date`">
                        <i class="fas fa-retweet text-success"></i></span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">ONGOING
                      </span>
                    </div>
                  </div>

                  <div class="row text-center mt-0" :class="[taskStats.length > 0 ? '' : '']">
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">{{  taskVariation.completed.count  }}</h4>
                    </div>
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">{{  taskVariation.inProgress.count  }}</h4>
                    </div>
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">{{  taskVariation.planned.count  }}</h4>
                    </div>
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">{{  taskVariation.overdue.count  }}</h4>
                    </div>
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">{{  taskVariation.onHoldT.count  }}</h4>
                    </div>
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">{{  taskVariation.taskDrafts.count  }}</h4>
                    </div>
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">
                        {{  taskVariation.ongoing.length 
                        }}<span v-tooltip="`Ongoing: Closed`" v-if="taskVariation.ongoingClosed.count > 0"
                          style="color: lightgray">({{  taskVariation.ongoingClosed.count 
                          }})</span>
                      </h4>
                    </div>
                  </div>

                  <div v-if="taskStats.length > 0" data-cy="task_categories">
                    <el-collapse class="taskCard">
                      <el-collapse-item title="..." name="1">
                        <div data-cy="task_categories" class="row">
                          <div class="col-5 pb-0 underline">PROCRESS AREAS</div>
                          <div class="col-2 pb-0 pl-0">#</div>

                          <div class="col-5 pb-0 pl-3">
                            <span class="underline" :class="{ 'font-sm': isMapView }">PROGRESS</span>
                          </div>
                        </div>

                        <div class="row" v-for="(task, index) in taskStats" :key="index">
                          <div class="col-5 pb-0 font-sm pr-0">
                            <span> {{  task.name  }}</span>
                          </div>
                          <div class="col-2 pb-0 pl-0">
                            <span class="badge badge-secondary font-sm badge-pill">{{
                               task.count  }}</span>
                          </div>

                          <div class="col-5 pb-0 mb-1">
                            <span class="w-100 progress pg-content" :class="{ 'progress-0': task.progress <= 0 }">
                              <div class="progress-bar bg-info" :style="`width: ${task.progress}%`">
                                {{  task.progress  }} %
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
                          <div class="col p-0 mb-0">NO DATA TO DISPLAY</div>
                        </div>
                      </el-collapse-item>
                    </el-collapse>
                  </div>
                </el-card>
              </div>
              <div class="col-2 pl-2" data-cy="facility_tasks">
                <el-card class="box-card" style="background-color: #fff">
                  <div class="row">
                    <div class="col text-center mh-blue py-0">
                      <h6 class="d-block mb-0 text-center text-light">
                        TASK PROGRESS
                      </h6>
                    </div>
                  </div>

                  <div class="row mt-1 text-center">
                    <div class="col p-0 mb-0">
                      <h4 class="text-center">
                        <span :class="{ 'progress-0': allTasksProgress.final <= 0 }">
                          <el-progress type="circle" class="py-3" :percentage="Math.round(allTasksProgress.final)">
                          </el-progress>
                        </span>
                      </h4>
                    </div>
                  </div>

                  <div></div>
                </el-card>
              </div>
            </div>
            <!-- Row 2, col-2 for Issues Card -->

            <div class="row mt-0 row-2">
              <div class="col-9 pr-0" data-cy="facility_issues">
                <el-card class="box-card" style="background-color: #fff">
                  <div class="row mb-3">
                    <div class="col pb-2 relative">
                      <h5 class="text-light px-2 mh-green absolute">ISSUES</h5>
                      <h4 class="d-inline">
                        <b class="badge badge-secondary badge-pill pill">{{
                           filteredIssues.length 
                          }}</b>
                      </h4>
                    </div>
                  </div>

                  <div class="row text-center mt-3">
                    <div class="col p-0 mb-0">
                      <span class="d-block" v-tooltip="`100% Progress achieved`"><i
                          class="fas fa-clipboard-check text-success"></i></span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">COMPLETE</span>
                    </div>
                    <div class="col p-0 mb-0">
                      <span class="d-block" v-tooltip="`Start date on or before current date`"><i
                          class="far fa-tasks text-primary"></i></span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">IN
                        PROGRESS</span>
                    </div>
                    <div class="col p-0 mb-0">
                      <span class="d-block" v-tooltip="
                        `Start date beyond current date (not a Draft)`
                      "><i class="fas fa-calendar-check text-info font-md"></i></span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">PLANNED</span>
                    </div>
                    <div class="col p-0 mb-0">
                      <span class="d-block" v-tooltip="`Due Date has passed`"><i class="fas fa-calendar text-danger">
                        </i></span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">OVERDUE</span>
                    </div>

                    <div class="col p-0 mb-0">
                      <span v-tooltip="`Temporarily halted`" class="d-block"><i
                          class="fas fa-pause-circle text-primary font-md"></i></span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">
                        ON HOLD
                      </span>
                    </div>
                    <div class="col p-0 mb-0">
                      <span v-tooltip="`Unofficial action`" class="d-block"><i
                          class="fas fa-pencil-alt text-warning font-md"></i></span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">DRAFTS</span>
                    </div>
                    <div class="col p-0 mb-0">
                      <span class="d-block hide"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                      <span class="d-block smallerFont hide">DRAFTS</span>
                    </div>
                  </div>

                  <div class="row text-center mt-0" :class="[filteredIssues.length > 0 ? '' : '']">
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">{{  issueVariation.completed.count  }}</h4>
                    </div>
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">
                        {{  issueVariation.inProgress.count  }}
                      </h4>
                    </div>
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">{{  issueVariation.planned.count  }}</h4>
                    </div>
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">{{  issueVariation.overdue.count  }}</h4>
                    </div>

                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">{{  issueVariation.onHoldI.count  }}</h4>
                    </div>
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">
                        {{  issueVariation.issueDrafts.count  }}
                      </h4>
                    </div>
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0 hide">
                        {{  issueVariation.issueDrafts.count  }}
                      </h4>
                    </div>
                  </div>

                  <!-- TASK CATEGORIES FOR ISSUE INSIDE COLLAPSIBLE SECTION -->

                  <div v-if="filteredIssues.length" data-cy="issue_types">
                    <el-collapse>
                      <el-collapse-item title="..." name="1">
                        <div v-if="contentLoaded">
                          <div class="row">
                            <div class="col-5 pb-0 mt-1 underline">
                              PROCESS AREAS
                            </div>
                            <div class="col-2 pb-0 pl-0">#</div>
                            <div class="col-5 pb-0 pl-3">
                              <span class="underline" :class="{ 'font-sm': isMapView }">PROGRESS</span>
                            </div>
                          </div>
                          <div class="row" v-for="(issue, index) in issueTaskCATEGORIES" :key="index">
                            <div class="col-5 pb-0 pr-0">
                              <span> {{  issue.name  }}</span>
                            </div>
                            <div class="col-2 pb-0 pl-0">
                              <span class="badge badge-secondary font-sm badge-pill">{{
                                 issue.count  }}</span>
                            </div>
                            <div class="col-5 pb-0 mb-1">
                              <span class="w-100 progress pg-content" :class="{ 'progress-0': issue.progress <= 0 }">
                                <div class="progress-bar bg-info" :style="`width: ${issue.progress}%`">
                                  {{  issue.progress  }} %
                                </div>
                              </span>
                            </div>
                          </div>
                        </div>

                        <div data-cy="issue_types">
                          <div class="col mt-2 underline pl-0">ISSUE TYPES</div>
                        </div>

                        <div class="row" v-for="issue in issueStats" :key="issue.id">
                          <div class="col-5 pb-0 font-sm pr-0">
                            <span> {{  issue.name  }}</span>
                          </div>
                          <div class="col-2 pb-0 pl-0">
                            <span class="badge badge-secondary font-sm badge-pill">{{
                               issue.count  }}</span>
                          </div>
                          <div class="col-5 pb-0 mb-1">
                            <span class="w-100 progress pg-content" :class="{ 'progress-0': issue.progress <= 0 }">
                              <div class="progress-bar bg-info" :style="`width: ${issue.progress}%`">
                                {{  issue.progress  }} %
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
                          <div class="col p-0 mb-0">NO DATA TO DISPLAY</div>
                        </div>
                      </el-collapse-item>
                    </el-collapse>
                  </div>
                </el-card>
              </div>
              <div class="col-2 pl-2" data-cy="facility_tasks">
                <el-card class="box-card" style="background-color: #fff">
                  <div class="row">
                    <div class="col text-center mh-green py-0">
                      <h6 class="d-block mb-0 text-center text-light">
                        ISSUE PROGRESS
                      </h6>
                    </div>
                  </div>

                  <div class="row mt-1 text-center">
                    <div class="col p-0 mb-0">
                      <h4 class="text-center">
                        <span :class="{
                          'progress-0': allIssuesProgress.final <= 0,
                        }">
                          <el-progress type="circle" class="py-3" :percentage="Math.round(allIssuesProgress.final)">
                          </el-progress>
                        </span>
                      </h4>
                    </div>
                  </div>

                  <div></div>
                </el-card>
              </div>
            </div>

            <div class="row mt-0 row-3">
              <!-- Row 3 Risks Card -->
              <div class="col-9 pr-0" data-cy="facility_risks">
                <el-card class="box-card" style="background-color: #fff">
                  <div class="row mb-3">
                    <div class="col pb-2 relative">
                      <h5 class="text-light px-2 mh-orange absolute">RISKS</h5>
                      <h4 class="d-inline">
                        <b class="badge badge-secondary badge-pill pill">{{
                           filteredRisks.length 
                          }}</b>
                      </h4>
                    </div>
                  </div>
                  <div class="row text-center mt-3">
                    <div class="col p-0 mb-0">
                      <span v-tooltip="`100% Progress achieved`" class="d-block"><i
                          class="fas fa-clipboard-check text-success"></i></span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">COMPLETE</span>
                    </div>
                    <div class="col p-0 mb-0">
                      <span v-tooltip="`Start date on or before current date`" class="d-block"><i
                          class="far fa-tasks text-primary"></i></span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">
                        IN PROGRESS
                      </span>
                    </div>
                    <div class="col p-0 mb-0">
                      <span v-tooltip="
                        `Start date beyond current date (not a Draft)`
                      " class="d-block">
                        <font-awesome-icon icon="calendar-check" class="text-info font-md" />
                      </span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">PLANNED</span>
                    </div>
                    <div class="col p-0 mb-0">
                      <span v-tooltip="`Due Date has passed`" class="d-block"><i class="fas fa-calendar text-danger">
                        </i></span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">OVERDUE
                      </span>
                    </div>
                    <div class="col p-0 mb-0">
                      <span v-tooltip="`Temporarily halted`" class="d-block"><i
                          class="fas fa-pause-circle text-primary font-md"></i></span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">
                        ON HOLD
                      </span>
                    </div>
                    <div class="col p-0 mb-0">
                      <span v-tooltip="`Unofficial action`" class="d-block"><i
                          class="fas fa-pencil-alt text-warning font-md"></i></span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">DRAFTS</span>
                    </div>
                    <div class="col p-0 mb-0">
                      <span v-tooltip="`Recurring action without Due Date`" class="d-block">
                        <i class="fas fa-retweet text-success"></i></span>
                      <span :class="{ 'd-none': isMapView }" class="d-block smallerFont">ONGOING</span>
                    </div>
                  </div>

                  <div class="row text-center mt-0" :class="[filteredRisks.length > 0 ? '' : '']">
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">{{  riskVariation.completed.count  }}</h4>
                    </div>
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">{{  riskVariation.inProgress.count  }}</h4>
                    </div>
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">{{  riskVariation.planned.count  }}</h4>
                    </div>
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">{{  riskVariation.overdue.count  }}</h4>
                    </div>
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">{{  riskVariation.onHoldR.count  }}</h4>
                    </div>

                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">{{  riskVariation.riskDrafts.count  }}</h4>
                    </div>
                    <div class="col pb-0 mb-0">
                      <h4 class="mb-0">
                        {{  riskVariation.ongoing.length 
                        }}<span v-tooltip="`Ongoing: Closed`" v-if="riskVariation.ongoingClosed.count > 0"
                          style="color: lightgray">({{  riskVariation.ongoingClosed.count 
                          }})</span>
                      </h4>
                    </div>
                  </div>

                  <!-- RISK CATEGORIES INSIDE COLLAPSIBLE SECTION -->
                  <div v-if="filteredRisks.length">
                    <el-collapse>
                      <el-collapse-item title="..." name="1">
                        <div class="row">
                          <div class="col-5 mt-1 underline">PROCESS AREAS</div>
                          <div class="col-2 pl-0">#</div>
                          <div class="col-5 pl-3">
                            <span class="underline" :class="{ 'font-sm': isMapView }">PROGRESS</span>
                          </div>
                        </div>
                        <div v-for="(risk, index) in currentRiskTypes" :key="index">
                          <div class="row" v-if="risk._display">
                            <div class="col-5 pr-0">
                              <span> {{  risk.name  }}</span>
                            </div>
                            <div class="col-2 pl-0">
                              <span class="badge badge-secondary font-sm badge-pill">{{
                                 risk.length  }}</span>
                            </div>
                            <div class="col-5 mb-1">
                              <span class="w-100 progress pg-content" :class="{ 'progress-0': risk.progress <= 0 }">
                                <div class="progress-bar bg-info" :style="`width: ${risk.progress}%`">
                                  {{  risk.progress  }} %
                                </div>
                              </span>
                            </div>
                          </div>
                        </div>

                        <div class="row mt-3 mb-2">
                          <div class="col underline">RISK PRIORITY LEVELS</div>
                        </div>
                        <div class="row font-sm">
                          <div class="col text-center">
                            <p class="mb-2 grey2">Very Low</p>
                            <p class="mb-2 green">Low</p>
                            <p class="mb-2 yellow">Moderate</p>
                          </div>
                          <div class="col">
                            <span class="my-2 badge w-50 badge-secondary badge-pill d-block">{{
                               riskPriorityLevels.grey  }}</span>
                            <span class="my-2 badge w-50 badge-secondary badge-pill d-block">{{
                               riskPriorityLevels.green  }}</span>
                            <span class="my-2 badge w-50 badge-secondary badge-pill d-block">{{
                               riskPriorityLevels.yellow  }}</span>
                          </div>
                          <div class="col text-center">
                            <p class="mb-2 orange">High</p>
                            <p class="mb-2 red">Extreme</p>
                          </div>
                          <div class="col">
                            <span class="my-2 badge w-50 badge-secondary badge-pill d-block">{{
                               riskPriorityLevels.orange  }}</span>
                            <span class="my-2 badge w-50 badge-secondary badge-pill d-block">{{
                               riskPriorityLevels.red  }}</span>
                          </div>
                        </div>
                      </el-collapse-item>
                    </el-collapse>
                  </div>
                  <div v-else>
                    <el-collapse id="roll_up" class="taskCard">
                      <el-collapse-item title="..." name="1">
                        <div class="row mt-1 text-center">
                          <div class="col p-0 mb-0">NO DATA TO DISPLAY</div>
                        </div>
                      </el-collapse-item>
                    </el-collapse>
                  </div>
                </el-card>
              </div>

              <div class="col-2 pl-2" data-cy="facility_tasks">
                <el-card class="box-card" style="background-color: #fff">
                  <div class="row">
                    <div class="col text-center mh-orange py-0">
                      <h6 class="d-block mb-0 text-center text-light">
                        RISK PROGRESS
                      </h6>
                    </div>
                  </div>

                  <div class="row mt-1 text-center">
                    <div class="col p-0 mb-0">
                      <h4 class="text-center">
                        <span :class="{ 'progress-0': allRisksProgress.final <= 0 }">
                          <el-progress type="circle" class="py-3" :percentage="Math.round(allRisksProgress.final)">
                          </el-progress>
                        </span>
                      </h4>
                    </div>
                  </div>

                  <div></div>
                </el-card>
              </div>
            </div>

            <div class="row row-1 mt-2">
              <div class="col-2">
                <el-card class="box-card" style="background-color: #fff">
                  <div class="row mb-4 pb-3">
                    <div class="col pb-0 relative">
                      <h5 class="text-light px-2 bg-secondary absolute">
                        LESSONS
                      </h5>
                      <h5 v-if="contentLoaded" class="d-inline">
                        <b class="pill badge badge-secondary badge-pill pill mr-1">{{
                           vehicleLessons.length  }}</b>
                      </h5>
                    </div>
                  </div>

                  <div v-if="contentLoaded">
                    <div class="row mt-4 text-center">
                      <div class="col-6 p-0 mb-0">
                        <span class="d-block" v-tooltip="`COMPLETE`"><i
                            class="fas fa-clipboard-check text-success"></i></span>
                        <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">COMPLETE</span>
                      </div>
                      <div class="col-6 p-0 mb-0">
                        <span class="d-block" v-tooltip="`DRAFT`"><i class="fas fa-pencil-alt text-warning"></i></span>
                        <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">DRAFT</span>
                      </div>
                    </div>
                    <div class="row text-center mb-4 mt-0">
                      <div class="col-6 pb-0 mb-0">
                        <h4 class="" v-if="lessonVariation && lessonVariation.completes">{{
                           lessonVariation.completes.length  }}</h4>
                        <h4 class="" v-else>0</h4>
                      </div>
                      <div class="col-6 pb-0 mb-0">
                        <h4 v-if="lessonVariation && lessonVariation.drafts">{{
                           lessonVariation.drafts.length  }}</h4>
                        <h4 class="" v-else>0</h4>
                      </div>
                    </div>
                  </div>
                </el-card>
              </div>

              <!-- <div class="col-md-3 col-lg-3 col-sm-6" v-show="isSheetsView"  data-cy="date_set_filter">
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
                </div> -->

              <div v-show="isSheetsView" class="col-3" data-cy="date_set_filter">
                <el-card class="box-card" style="background-color: #fafafa">
                  <div class="row">
                    <div class="col pb-0">
                      <h5 class="d-inline" style="font-weight: 600">CONTACT</h5>
                    </div>
                  </div>
                  <div class="row">
                    <div class="col font-sm">
                      <p class="mt-1 mb-0">
                        <span class="fbody-icon"><i class="far fa-id-badge"></i></span>
                        <!-- <span>{{
                            facility.facility.pointOfContact || "N/A"
                          }}</span> -->
                      </p>
                      <p class="mt-1 mb-0">
                        <span class="fbody-icon"><i class="fas fa-map-marker"></i></span>
                        <!-- <span>{{ facility.facility.address || "N/A" }}</span> -->
                      </p>
                      <p class="mt-1 mb-0">
                        <span class="fbody-icon"><i class="fas fa-phone"></i></span>
                        <!-- <span>{{
                            facility.facility.phoneNumber || "N/A"
                          }}</span> -->
                      </p>
                      <p class="mt-1">
                        <span class="fbody-icon"><i class="far fa-envelope"></i></span>
                        <!-- <span>{{ facility.facility.email || "N/A" }}</span> -->
                      </p>
                    </div>
                  </div>
                </el-card>
              </div>
              <div class="col-2 pl-2">
                <el-card class="box-card" style="background-color: #fff">
                  <div class="row">
                    <div class="col text-center bg-secondary py-0">
                      <h6 class="d-block mb-0 text-center text-light">
                        OVERALL PROGRESS
                      </h6>
                    </div>
                  </div>

                  <div class="row mt-1 text-center">
                    <div class="col p-0 mb-0">
                      <h4 class="text-center">
                        <span :class="{ 'progress-0': projectTotalProgress <= 0 }">
                          <el-progress type="circle" class="pt-4 pb-3" :percentage="Math.round(projectTotalProgress)">
                          </el-progress>
                        </span>
                      </h4>
                    </div>
                  </div>

                  <div></div>
                </el-card>
              </div>
            </div>
            <!-- SECOND ROW WITH TASKS ISSUES & RISKS -->

            <!-- Row 2, col-1 for Tasks Card -->
          </div>
          <div v-else class="text-danger mx-2 mt-5">
            <h5> <i>Sorry, you don't have read-permissions for this tab! Please click on any available
                tab.</i></h5>
          </div>
        </div>
      </div>
    </div>
    <div v-else></div>
  </div>
</template>
  
  <script>
import http from "../../../../common/http";
import { mapGetters, mapMutations, mapActions } from "vuex";
import Loader from "../../../shared/loader.vue";
import { API_BASE_PATH } from "../../../../mixins/utils";

export default {
  name: "VehicleAnalytics",
  components: {
    Loader,
  },
  props: ["vehicleClass", "vehicle"],
  data() {
    return {
      dueDate: "",
      statusId: 0,
      today: new Date().toISOString().slice(0, 10),
      loading: true,
      DV_updated: false,
      notesQuery: "",
      _selected: null,
      _categories: null,
    };
  },
  mounted() {
    // this.dueDate = this.facility.dueDate;
    // this.statusId = this.facility.statusId;
    this.fetchVehicleLessons(this.$route.params);
  },
  methods: {
    ...mapActions(['fetchVehicleLessons']),
    ...mapMutations(["setTaskTypeFilter", "updateFacilityHash"]),
    onChange() {
      this.$nextTick(() => {
        this.DV_updated = true;
      });
    },
    _isallowed(salut) {
      return this.checkPrivileges("VehicleAnalytics", salut, this.$route)
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
      "vehicleLessons",
      "contentLoaded",
      "currentProject",
      "programLessons",
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

      return _.filter(this.vehicle.tasks, (resource) => {
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
    viableTasksForProgressTotal() {
      return this.filteredTasks.filter(
        (t) => t.draft == false && t.onHold == false && t.ongoing == false
      );
    },
    viableIssuesForProgressTotal() {
      return this.filteredIssues.filter(
        (issue) => issue.draft == false && issue.onHold == false
      );
    },
    viableRisksForProgressTotal() {
      return this.filteredRisks.filter(
        (r) => r.draft == false && r.onHold == false && r.ongoing == false
      );
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
      let total = task.map((t) => t.progress);
      let count = task.map((t) => t).length;

      let sum = total.reduce(
        (accumulator, currentValue) => accumulator + currentValue,
        0
      );

      let roundedSum = Math.round(sum);
      let final = roundedSum / count;

      if (isNaN(final)) {
        final = 0;
      }
      //  let allCounts = this.allRisksProgress.count + this.allIssuesProgress.count + count
      //  let weightedVal = count / allCounts
      let weighted = count * final;

      if (isNaN(final)) {
        return 0;
      } else
        return {
          final,
          count,
          weighted,
          roundedSum,
        };
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
      let total = risk.map((r) => r.progress);
      let count = risk.map((r) => r).length;

      let sum = total.reduce(
        (accumulator, currentValue) => accumulator + currentValue,
        0
      );
      let roundedSum = Math.round(sum);

      let final = roundedSum / count;

      if (isNaN(final)) {
        final = 0;
      }
      let weighted = count * final;

      if (isNaN(final)) {
        return 0;
      } else
        return {
          final,
          count,
          weighted,
        };
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
      let total = issue.map((iss) => iss.progress);
      let count = issue.map((iss) => iss).length;

      let sum = total.reduce(
        (accumulator, currentValue) => accumulator + currentValue,
        0
      );

      let roundedSum = Math.round(sum);
      let final = roundedSum / count;

      if (isNaN(final)) {
        final = 0;
      }
      let weighted = count * final;

      if (isNaN(final)) {
        return 0;
      } else
        return {
          final,
          count,
          weighted,
        };
    },
    projectTotalProgress() {
      let sum =
        this.allTasksProgress.weighted +
        this.allRisksProgress.weighted +
        this.allIssuesProgress.weighted;
      let denominator =
        this.allTasksProgress.count +
        this.allRisksProgress.count +
        this.allIssuesProgress.count;
      if (isNaN(sum || denominator)) {
        sum = 0;
        denominator = 0;
      }

      let total = sum / denominator;
      if (isNaN(total)) {
        return 0;
      } else return Math.round(total);
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
        (t) => t && t.planned
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
      let inProgress = _.filter(this.filteredTasks, (t) => t && t.inProgress);
      let onHoldT = _.filter(this.filteredTasks, (t) => t && t.onHold == true);
      let inProgress_percent = this.getAverage(
        inProgress.length,
        this.filteredTasks.length
      );
      let overdue = _.filter(this.filteredTasks, (t) => t && t.isOverdue);
      let overdue_percent = this.getAverage(
        overdue.length,
        this.filteredTasks.length
      );
      let ongoing = _.filter(this.filteredTasks, (t) => t && t.ongoing);
      let ongoingClosed = _.filter(this.filteredTasks, (t) => t && t.closed);
      return {
        planned: {
          count: planned.length,
          plannedTs: planned,
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
        ongoingClosed: {
          count: ongoingClosed.length,
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

      return _.filter(this.vehicle.issues, (resource) => {
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
      let planned = _.filter(this.filteredIssues, (t) => t.planned == true);
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
      let onHoldI = _.filter(this.filteredIssues, (t) => t && t.onHold == true);
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

      return _.filter(this.vehicle.risks, (resource) => {
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
      let planned = _.filter(this.filteredRisks, (t) => t && t.planned == true);
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
      let onHoldR = _.filter(this.filteredRisks, (t) => t && t.onHold == true);

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
      let ongoingClosed = _.filter(this.filteredRisks, (t) => t && t.closed);
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
        ongoingClosed: {
          count: ongoingClosed.length,
        },
        ongoing,
      };
    },
    filteredLessons() {
      if (this.vehicleLessons && this.vehicleLessons.length > 0) {
        let typeIds = _.map(this.taskTypeFilter, "id");
        return _.filter(this.vehicleLessons, (resource) => {
          let valid = true;
          valid = valid && this.filterDataForAdvancedFilter([resource], "facilityRollupLessons");
          if (typeIds.length > 0)
            valid = valid && typeIds.includes(resource.task_type_id);
          return valid;
        })
      }
    },
    lessonVariation() {
      if (this.filteredLessons && this.filteredLessons.length > 0) {
        let completes = this.filteredLessons.filter(l => !l.draft)
        let drafts = this.filteredLessons.filter(l => l.draft)
        return {
          completes,
          drafts
        }
      }
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
  },
  watch: {
    contentLoaded: {
      handler() {
        // this.dueDate = this.facility.dueDate;
        // this.statusId = this.facility.statusId;
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
  
  .vue2-datepicker ::v-deep .mx-input:disabled {
    color: #555;
    background-color: #fff;
  }
  
  .simple-select ::v-deep .multiselect {
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
  
  ::v-deep.el-collapse-item__header,
  ::v-deep.el-collapse-item__wrap {
    border-bottom: none !important;
  }
  
  ::v-deep.el-card__body {
    padding-bottom: 0 !important;
  }
  
  ::v-deep.el-progress-circle {
    height: 100px !important;
    width: 100px !important;
  }
  
  ::v-deep.el-collapse-item__header {
    font-size: 2rem;
  }
  
  ::v-deep.el-collapse-item__arrow,
  ::v-deep.el-icon-arrow-right {
    display: none;
  }
  
  .giantNumber {
    font-size: 3.7rem;
  }
  
  .halfRem {
    margin-top: 0.5rem;
    margin-bottom: 0.5rem;
  }
  
  .hide {
    visibility: hidden;
  }
  
  .relative {
    position: relative;
  }
  
  .absolute {
    position: absolute;
    top: 7%;
    left: 0;
  }
  
  .progressLabel {
    position: absolute;
  }
  
  .pill {
    position: absolute;
    top: 10%;
    right: 1%;
  }
  
  .filterDiv {
    position: fixed;
    top: 130px;
    right: 9.5%;
    width: 20%;
    border-radius: 4px;
    border: 0.5px solid #383838;
    overflow-y: auto;
  }
  
  .filterLabel {
    position: fixed;
  }
  
  .filterCol {
    height: 70px;
  }
  
  @media screen and (min-width: 1550px) {
    .filterDiv {
      right: 8.5%;
    }
  }
  </style>
  