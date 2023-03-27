<template>
  <div
    class="container-fluid mt-3 mx-3 portfolioView_main"
    v-loading="!portfolioProgramsLoaded"
    element-loading-text="Fetching Portfolio data. Please wait..."
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)"
    :class="{ vh100: !portfolioProgramsLoaded }"
  >
    <!-- Actual Portfolio name will be dynamic value of organization name   -->
    <div>
      <span @click.prevent="backHomeBtn">
        <img
          class="mb-2"
          style="width: 147px;cursor:pointer"
          :src="require('../../../../assets/images/microhealthllc.png')"
        />
        <!-- <h3 class="d-inline mt-1 programName">{{ this.$portfolio_heading }}</h3> -->
      </span>
      <span class="float-right mr-4">
        <button
          class="portfolioHomeBtn mh-orange btn btn-sm"
          style="cursor: pointer"
          @click.prevent="backHomeBtn"
        >
          <i class="fas fa-home text-light"></i>
        </button>
      </span>
    </div>
    <el-tabs class="mt-2 mr-3" type="border-card">
      <el-tab-pane
        label="PORTFOLIO DATA VIEWER"
        class="p-3"
        style="postion:relative"
      >
        <!-- El-Dialog is the Presentation.  This component is dynamically populated based on tab.  Thus, it appears just once in the file. -->

        <el-dialog
          :visible.sync="dialogVisible"
          append-to-body
          center
          class="portfolioDialogMode"
        >
          <template slot="title">
            <div
              v-if="
                dynamicObj.length > 0 &&
                  dynamicObj[currentTaskSlide] !== undefined
              "
              class="container-fluid"
            >
              <h5
                class="pl-2 mt-3 d-inline-block mh-blue px-3 text-light"
                style="cursor:pointer; position:absolute; left:0; top:0"
              >
                <i class="fal fa-clipboard-list text-light py-2 mr-1"></i>
                {{ action }}
              </h5>
              <div v-for="number in [currentTaskSlide]" :key="number">
                <div class="row justify-content-center">
                  <div class="col-3 pb-0">
                    <img
                      class="mb-0"
                      style="width: 125px"
                      :src="require('../../../../assets/images/mpath.png')"
                    />
                  </div>
                  <div
                    class="col-5 text-center px-3 py-2"
                    v-if="dynamicObj[currentTaskSlide]"
                  >
                    <span
                      v-if="
                        dynamicObj[currentTaskSlide] &&
                          dynamicObj[currentTaskSlide].is_overdue
                      "
                      v-tooltip="`Overdue`"
                    >
                      <i
                        class="fas fa-calendar text-danger mr-1"
                        style="font-size:1.8rem"
                      ></i
                    ></span>
                    <span
                      v-if="
                        dynamicObj[currentTaskSlide] &&
                          dynamicObj[currentTaskSlide].completed
                      "
                      v-tooltip="`Completed`"
                      ><i
                        class="fas fa-clipboard-check text-success mr-1"
                        style="font-size:1.8rem"
                      ></i
                    ></span>
                    <span
                      v-if="
                        dynamicObj[currentTaskSlide] &&
                          dynamicObj[currentTaskSlide].ongoing == true &&
                          dynamicObj[currentTaskSlide].closed == false
                      "
                      v-tooltip="`Ongoing`"
                      ><i
                        class="fas fa-retweet mr-1 text-success"
                        style="font-size:1.8rem"
                      ></i
                    ></span>
                    <span
                      v-if="
                        dynamicObj[currentTaskSlide] &&
                          dynamicObj[currentTaskSlide].closed
                      "
                      v-tooltip="`Ongoing: Closed`"
                      ><i
                        class="fas fa-retweet mr-1 text-secondary"
                        style="font-size:1.8rem"
                      ></i
                    ></span>
                    <span
                      v-if="
                        dynamicObj[currentTaskSlide] &&
                          dynamicObj == lessonsObj.filtered.lessons &&
                          !dynamicObj[currentTaskSlide].draft
                      "
                      v-tooltip="`Completed`"
                      ><i
                        class="fas fa-clipboard-check text-success mr-1"
                        style="font-size:1.8rem"
                      ></i
                    ></span>
                    <span
                      v-if="
                        dynamicObj[currentTaskSlide] &&
                          dynamicObj[currentTaskSlide].on_hold == true
                      "
                      v-tooltip="`On Hold`"
                    >
                      <i
                        class="fas fa-pause-circle mr-1 text-primary"
                        style="font-size:1.8rem"
                      ></i
                    ></span>
                    <span
                      v-if="
                        dynamicObj[currentTaskSlide] &&
                          dynamicObj[currentTaskSlide].draft == true
                      "
                      v-tooltip="`Draft`"
                    >
                      <i
                        class="fas fa-pencil-alt mr-1 text-warning"
                        style="font-size:1.8rem"
                      ></i
                    ></span>
                    <span
                      v-if="
                        dynamicObj[currentTaskSlide] &&
                          dynamicObj[currentTaskSlide].planned
                      "
                      v-tooltip="`Planned`"
                    >
                      <i
                        class="fas fa-calendar-check text-info mr-1"
                        style="font-size:1.8rem"
                      ></i
                    ></span>
                    <span
                      v-if="
                        dynamicObj[currentTaskSlide] &&
                          dynamicObj[currentTaskSlide].in_progress
                      "
                      v-tooltip="`In Progress`"
                    >
                      <i
                        class="far fa-tasks text-primary mr-1"
                        style="font-size:1.8rem"
                      ></i
                    ></span>

                    <span v-if="dynamicObj[currentTaskSlide].text">
                      <h2 class="mt-2 d-inline text-truncate">
                        {{ dynamicObj[currentTaskSlide].text }}
                      </h2>
                    </span>
                    <span v-if="dynamicObj[currentTaskSlide].title">
                      <h2 class="mt-2 d-inline text-truncate">
                        {{ dynamicObj[currentTaskSlide].title }}
                      </h2>
                    </span>
                  </div>

                  <div class="col-3 mt-3">
                    <img
                      style="width: 145px"
                      :src="
                        require('../../../../assets/images/microhealthllc.png')
                      "
                    />
                  </div>
                </div>

                <div class="row pt-3 justify-content-center">
                  <div class="col-3 text-center slideCol leftProgramCol">
                    <div class="col py-2">
                      <h6 class="mh-orange leftColLabel text-light">PROGRAM</h6>
                      <h4
                        v-if="
                          dynamicObj[currentTaskSlide] &&
                            dynamicObj[currentTaskSlide].program_name
                        "
                      >
                        {{ dynamicObj[currentTaskSlide].program_name }}
                      </h4>
                    </div>

                    <div class="col truncate-line-two">
                      <h6 class="leftColLabel text-light mh-orange">
                        GROUP
                      </h6>
                      <h4
                        v-if="
                          dynamicObj[currentTaskSlide] &&
                            dynamicObj[currentTaskSlide].project_group_name
                        "
                      >
                        {{ dynamicObj[currentTaskSlide].project_group_name }}
                      </h4>
                    </div>

                    <div class="col py-2">
                      <h6 class="leftColLabel text-light mh-orange">PROJECT</h6>
                      <h4
                        v-if="
                          dynamicObj[currentTaskSlide] &&
                            dynamicObj[currentTaskSlide].project_name
                        "
                      >
                        {{ dynamicObj[currentTaskSlide].project_name }}
                      </h4>
                    </div>

                    <div class="col">
                      <h6 class="leftColLabel mh-blue text-light">
                        PROCESS AREA
                      </h6>
                      <h4
                        v-if="
                          dynamicObj[currentTaskSlide] &&
                            dynamicObj[currentTaskSlide].category
                        "
                      >
                        {{ dynamicObj[currentTaskSlide].category }}
                      </h4>
                      <h4 v-else>--</h4>
                    </div>
                  </div>

                  <div
                    class="col-5 text-center  mx-4 p-0"
                    v-if="dynamicObj[currentTaskSlide] !== undefined"
                  >
                    <div class="lastUpdateCol">
                      <h3 class="mh-green text-light d-block">LAST UPDATE</h3>
                      <div style="height:300px; overflow-y:auto">
                        <span
                          v-if="
                            dynamicObj[currentTaskSlide].notes_updated_at
                              .length > 0
                          "
                        >
                          <span>
                            <br />
                            <h4 class="px-3">
                              <em>{{
                                dynamicObj[currentTaskSlide].notes[
                                  dynamicObj[currentTaskSlide].notes.length - 1
                                ].body
                              }}</em>
                            </h4>
                          </span>
                          <span class="px-2">
                            <h6 class="mt-2">
                              {{
                                moment(
                                  dynamicObj[currentTaskSlide]
                                    .notes_updated_at[0]
                                ).format("DD MMM YYYY, h:mm a ") +
                                  " By: " +
                                  dynamicObj[currentTaskSlide].notes[
                                    dynamicObj[currentTaskSlide].notes.length -
                                      1
                                  ].user.full_name
                              }}
                            </h6>
                          </span>
                        </span>
                        <span v-else>
                          <br />
                          <h4 class="px-3" style="color:lightgray">
                            <em>NO UPDATES</em>
                          </h4>
                        </span>
                      </div>
                    </div>
                    <div
                      class="wrap d-flex"
                      v-if="dynamicObj == issuesObj.filtered.issues"
                    >
                      <div class="issueTypes mt-3 px-0 w-50 mr-2 pt-0">
                        <h6 class="bg-secondary text-light py-1 d-block">
                          ISSUE TYPE
                        </h6>
                        <div style="height:45px; overflow-y:auto">
                          <h4 class="px-3">
                            {{ dynamicObj[currentTaskSlide].issue_type }}
                          </h4>
                        </div>
                      </div>
                      <div
                        class="issueTypes mt-3 px-0 pt-0 ml-2 w-50"
                        v-if="dynamicObj == issuesObj.filtered.issues"
                      >
                        <h6 class="text-light bg-secondary py-1 d-block">
                          ISSUE SEVERITY
                        </h6>
                        <div style="height:45px; overflow-y:auto">
                          <h4 class="px-3">
                            {{ dynamicObj[currentTaskSlide].issue_severity }}
                          </h4>
                        </div>
                      </div>
                    </div>

                    <div
                      class="issueTypes mt-3"
                      v-if="dynamicObj == risksObj.filtered.risks"
                    >
                      <h6 class="bg-secondary text-light py-1 d-block">
                        RISK DESCRIPTION
                      </h6>
                      <div style="height:100px; overflow-y:auto">
                        <h4 class="px-3">
                          {{ dynamicObj[currentTaskSlide].risk_description }}
                        </h4>
                      </div>
                    </div>

                    <div
                      class="issueTypes mt-3"
                      v-if="dynamicObj == tasksObj.filtered.tasks"
                    >
                      <h6 class="bg-secondary text-light py-1 d-block">
                        TASK DESCRIPTION
                      </h6>
                      <div style="height:100px; overflow-y:auto">
                        <h4 class="px-3">
                          {{ dynamicObj[currentTaskSlide].description }}
                        </h4>
                      </div>
                    </div>
                  </div>

                  <div
                    class="col-3 mh-blue text-center text-light slideCol"
                    v-if="dynamicObj[currentTaskSlide] !== undefined"
                  >
                    <div
                      class="col pt-2"
                      v-if="dynamicObj !== lessonsObj.filtered.lessons"
                    >
                      <i
                        class="fas fa-calendar text-light d-block pb-1"
                        style="font-size:2.8rem"
                      ></i>
                      <span
                        v-if="
                          dynamicObj[currentTaskSlide] &&
                            dynamicObj[currentTaskSlide].start_date
                        "
                        class="d-inline-block"
                      >
                        <h5>
                          {{
                            moment(
                              dynamicObj[currentTaskSlide].start_date
                            ).format("DD MMM YYYY")
                          }}
                        </h5></span
                      >
                      <span v-else> -- </span>
                      -
                      <span
                        v-if="
                          dynamicObj[currentTaskSlide] &&
                            dynamicObj[currentTaskSlide].due_date
                        "
                        class="d-inline-block"
                      >
                        <h5>
                          {{
                            moment(
                              dynamicObj[currentTaskSlide].due_date
                            ).format("DD MMM YYYY")
                          }}
                        </h5></span
                      >
                      <span v-else> </span>
                    </div>
                    <div
                      class="col pt-2"
                      v-if="dynamicObj == lessonsObj.filtered.lessons"
                    >
                      <i
                        class="fas fa-calendar text-light d-block pb-1"
                        style="font-size:2.8rem"
                      ></i>
                      <span
                        v-if="
                          dynamicObj[currentTaskSlide] &&
                            dynamicObj[currentTaskSlide].date
                        "
                        class="d-inline-block"
                      >
                        <h5>
                          {{
                            moment(dynamicObj[currentTaskSlide].date).format(
                              "DD MMM YYYY"
                            )
                          }}
                        </h5></span
                      >
                    </div>

                    <div
                      class="col mt-3 truncate-line-two"
                      v-if="dynamicObj == lessonsObj.filtered.lessons"
                    >
                      <i
                        class="fas fa-user d-block text-light"
                        style="font-size:2.8rem"
                      ></i>
                      <span
                        class="truncate-line-two"
                        v-if="dynamicObj[currentTaskSlide].added_by"
                        ><h4>
                          Added By: {{ dynamicObj[currentTaskSlide].added_by }}
                        </h4></span
                      >
                    </div>

                    <div
                      class="col mt-3 truncate-line-two"
                      v-if="dynamicObj !== lessonsObj.filtered.lessons"
                    >
                      <i
                        class="fas fa-users d-block text-light"
                        style="font-size:2.8rem"
                      ></i>
                      <span
                        class="truncate-line-two"
                        v-if="dynamicObj[currentTaskSlide].users.length > 0"
                        ><h4>{{ dynamicObj[currentTaskSlide].users }}</h4></span
                      >
                      <span v-else> <h4>No Assignments</h4></span>
                    </div>

                    <div
                      class="col"
                      v-if="
                        dynamicObj !== lessonsObj.filtered.lessons &&
                          !dynamicObj[currentTaskSlide].ongoing &&
                          dynamicObj !== risksObj.filtered.risks
                      "
                    >
                      <span
                        :class="{
                          'text-light':
                            dynamicObj[currentTaskSlide].progress <= 0,
                        }"
                      >
                        <el-progress
                          type="circle"
                          class="py-2 text-light"
                          :percentage="
                            Math.round(dynamicObj[currentTaskSlide].progress)
                          "
                        ></el-progress>
                      </span>
                      <h4>{{ action }} PROGRESS</h4>
                    </div>

                    <div
                      class="col mt-3"
                      v-if="dynamicObj == risksObj.filtered.risks"
                    >
                      <h6>RISK APPROACH</h6>
                      <h4 class="text-light labels px-2 d-inline-block">
                        {{
                          dynamicObj[currentTaskSlide].risk_approach
                            .charAt(0)
                            .toUpperCase() +
                            dynamicObj[currentTaskSlide].risk_approach.slice(1)
                        }}
                      </h4>

                      <h6 class="mt-5">PRIORITY LEVEL</h6>
                      <h4
                        v-if="
                          dynamicObj[currentTaskSlide].priority_level ==
                            'Very Low'
                        "
                        class="gray2 px-1 riskLabels"
                      >
                        Very Low
                      </h4>
                      <h4
                        v-else-if="
                          dynamicObj[currentTaskSlide].priority_level == 'Low'
                        "
                        class="green1 riskLabels px-1"
                      >
                        Low
                      </h4>
                      <h4
                        v-else-if="
                          dynamicObj[currentTaskSlide].priority_level ==
                            'Moderate'
                        "
                        class="yellow1 riskLabels px-1"
                      >
                        Moderate
                      </h4>
                      <h4
                        v-else-if="
                          dynamicObj[currentTaskSlide].priority_level == 'High'
                        "
                        class="orange1 riskLabels px-1"
                      >
                        High
                      </h4>
                      <h4
                        v-else-if="
                          dynamicObj[currentTaskSlide].priority_level ==
                            'Extreme'
                        "
                        class="red1 riskLabels px-1"
                      >
                        Extreme
                      </h4>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div
              slot="footer"
              class="dialog-footer-left"
              v-if="dynamicObj[currentTaskSlide] !== undefined"
            >
              <el-button class="elBtn tagsBtn py-1 text-light mr-2">
                <h5 class="d-inline px-2 text-dark">FOCUS FLAGS:</h5>
                <span
                  v-if="dynamicObj[currentTaskSlide].watched == true"
                  v-tooltip="`On Watch`"
                  ><i
                    class="fas fa-eye mr-1 text-dark"
                    style="font-size:1.5rem"
                  ></i
                ></span>
                <span
                  v-if="dynamicObj[currentTaskSlide].important == true"
                  v-tooltip="`Important`"
                >
                  <i
                    class="fas fa-star text-warning mr-1 "
                    style="font-size:1.5rem"
                  ></i
                ></span>
                <span
                  v-if="dynamicObj[currentTaskSlide].reportable"
                  v-tooltip="`Briefings`"
                >
                  <i
                    class="fas fa-presentation mr-1 text-primary"
                    style="font-size:1.5rem"
                  ></i
                ></span>
              </el-button>
            </div>

            <div slot="footer" class="dialog-footer">
              <el-button
                class="mh-orange elBtn text-light"
                @click.prevent="previousTask"
                ><i class="far fa-chevron-left" style="font-size:1.35rem"></i
              ></el-button>
              <el-button class="bg-secondary elBtn text-light"
                ><span style="font-size:1.35rem"
                  ><span>{{ action }}</span> {{ currentTaskSlide + 1 }} of
                  {{ dynamicObj.length }}</span
                ></el-button
              >
              <el-button
                class="mh-orange elBtn text-light"
                @click.prevent="nextTask"
                ><i class="far fa-chevron-right" style="font-size:1.35rem"></i
              ></el-button>
            </div>
          </template>
        </el-dialog>
        <div class="row pb-4">
          <div class="col-4 py-2">
            <div class="w-100 d-flex">
              <div class="d font-sm mt-2 mr-2">SEARCH</div>
              <div class="w-100" v-if="currentTab == 'tasks'">
                <el-input
                  type="search"
                  placeholder="Enter Tasks Search Criteria"
                  v-model="search_tasks"
                >
                  <el-button slot="prepend" icon="el-icon-search"></el-button>
                </el-input>
              </div>
              <div class="w-100" v-if="currentTab == 'issues'">
                <el-input
                  type="search"
                  placeholder="Enter Issues Search Criteria"
                  v-model="search_issues"
                >
                  <el-button slot="prepend" icon="el-icon-search"></el-button>
                </el-input>
              </div>
              <div class="w-100" v-if="currentTab == 'risks'">
                <el-input
                  type="search"
                  placeholder="Enter Risks Search Criteria"
                  v-model="search_risks"
                >
                  <el-button slot="prepend" icon="el-icon-search"></el-button>
                </el-input>
              </div>
              <div class="w-100" v-if="currentTab == 'lessons'">
                <el-input
                  type="search"
                  placeholder="Enter Lessons Search Criteria"
                  v-model="search_lessons"
                >
                  <el-button slot="prepend" icon="el-icon-search"></el-button>
                </el-input>
              </div>
            </div>
          </div>

          <div class="col-4 py-2">
            <div class="d-flex w-100">
              <div class="font-sm px-0 mt-2 mr-2">
                PROGRAM<span class="invi">i</span>FILTER
              </div>
              <template>
                <treeselect
                  placeholder="Search and select"
                  :multiple="true"
                  @input="updateProgramFilterValue"
                  :value="C_portfolioNamesFilter"
                  :options="portfolioPrograms"
                  v-model="C_portfolioNamesFilter"
                  track-by="name"
                  :limit="3"
                  :maxHeight="200"
                  :limitText="(count) => `...`"
                  valueFormat="object"
                />
                <!-- <treeselect-value :value="C_portfolioNamesFilter" />    -->
              </template>
            </div>
          </div>
          <div class="col-4 pl-0 py-2">
            <div class="d-flex w-100">
              <div class="font-sm mr-2 mt-2">PROCESS AREA</div>
              <template>
                <el-select
                  v-model="C_categoryNameFilter"
                  class="w-75"
                  track-by="name"
                  value-key="id"
                  multiple
                  clearable
                  @clear="setValueNull"
                  placeholder="Select Process Area"
                >
                  <el-option
                    v-for="item in C_categories"
                    :value="item"
                    :key="item"
                    :label="item"
                  >
                  </el-option>
                </el-select>
              </template>
            </div>
          </div>
        </div>

        <el-tabs
          class="mt-1"
          type="border-card"
          @tab-click="handleClick"
          style="postion:relative"
        >
          <!-- TASKS -->
          <el-tab-pane
            class="pt-2"
            name="tasks"
            style="postion:relative"
            v-loading="!portfolioTasksLoaded"
            element-loading-text="Fetching Portfolio Tasks. Please wait..."
            element-loading-spinner="el-icon-loading"
            element-loading-background="rgba(0, 0, 0, 0.8)"
          >
            <template slot="label" class="text-right" v-if="true">
              TASKS
              <span class="badge badge-secondary badge-pill">
                <span>{{ portfolioCounts.tasks_count }}</span>
              </span>
            </template>

            <div class="box-shadow py-2" style="postion:relative">
              <div class="row py-1 pr-2">
                <div class="col-10 px-1 pt-2">
                  <div class="pb-0 pl-2 pr-4 mb-0 d-inline-flex">
                    <span class=""
                      ><label class="font-sm px-2 mt-4 d-block"
                        >STATES TO DISPLAY</label
                      >
                    </span>

                    <span class="d-flex statesCol mr-3 px-3 py-2">
                      <div
                        class="pr-4 text-center icons"
                        :class="[hideCompleteFlag == true ? 'light' : '']"
                        @click.prevent="toggleComplete"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-clipboard-check"
                            :class="[
                              hideCompleteFlag == true
                                ? 'light'
                                : 'text-success',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">COMPLETE</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ taskVariation.completed.count }}
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideInprogressFlag == true ? 'light' : '']"
                        @click.prevent="toggleInprogress"
                      >
                        <span class="d-block">
                          <i
                            class="far fa-tasks"
                            :class="[
                              hideInprogressFlag == true
                                ? 'light'
                                : 'text-primary',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">IN PROGRESS</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ taskVariation.inProgress.count }}
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideOverdueFlag == true ? 'light' : '']"
                        @click.prevent="toggleOverdue"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-calendar"
                            :class="[
                              hideOverdueFlag == true ? 'light' : 'text-danger',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">OVERDUE </span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ taskVariation.overdue.count }}
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideOngoingFlag == true ? 'light' : '']"
                        @click.prevent="toggleOngoing"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-retweet"
                            :class="[
                              hideOngoingFlag == true
                                ? 'light'
                                : 'text-success',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">ONGOING </span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          <span v-if="tasksObj.filtered.tasks"
                            >{{ taskVariation.ongoing.count
                            }}<span
                              v-tooltip="`Ongoing: Closed`"
                              v-if="taskVariation.ongoingClosed.count > 0"
                              style="color:lightgray"
                              >({{ taskVariation.ongoingClosed.count }})
                            </span>
                          </span>
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hidePlannedFlag == true ? 'light' : '']"
                        @click.prevent="togglePlanned"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-calendar-check"
                            :class="[
                              hidePlannedFlag == true ? 'light' : 'text-info',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">PLANNED</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          <span v-if="tasksObj.filtered.tasks">{{
                            taskVariation.planned.count
                          }}</span>
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideOnholdFlag == true ? 'light' : '']"
                        @click.prevent="toggleOnhold"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-pause-circle"
                            :class="[
                              hideOnholdFlag == true ? 'light' : 'text-primary',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">ON HOLD</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ taskVariation.onHoldT.count }}
                        </h5>
                      </div>
                      <div
                        class="text-center icons"
                        :class="[hideDraftFlag == true ? 'light' : '']"
                        @click.prevent="toggleDraft"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-pencil-alt"
                            :class="[
                              hideDraftFlag == true ? 'light' : 'text-warning',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">DRAFTS</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ taskVariation.taskDrafts.count }}
                        </h5>
                      </div>
                    </span>

                    <span class=""
                      ><label class="font-sm mt-4 pr-2"><b>FOCUS</b></label>
                    </span>
                    <span class="tagsCol d-flex px-3 py-2">
                      <div
                        class="text-center icons"
                        :class="[hideWatchedFlag == true ? '' : 'light']"
                        @click.prevent="toggleWatched"
                      >
                        <span class="d-block">
                          <i class="fas fa-eye"></i>
                        </span>
                        <span class="smallerFont">ON WATCH</span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="watched" v-model="C_hideWatchedTasks">               -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ taskVariation.watched.count }}
                        </h5>
                      </div>
                      <div
                        class="px-4 text-center icons"
                        :class="[hideImportantFlag == true ? '' : 'light']"
                        @click.prevent="toggleImportant"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-star"
                            :class="[
                              hideImportantFlag == true
                                ? 'text-warning'
                                : 'light',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">IMPORTANT</span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="important" v-model="C_hideImportantTasks">     -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ taskVariation.important.count }}
                        </h5>
                      </div>
                      <div
                        class="text-center icons"
                        :class="[hideBriefedFlag == true ? '' : 'light']"
                        @click.prevent="toggleBriefing"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-presentation"
                            :class="[
                              hideBriefedFlag == true
                                ? 'text-primary'
                                : 'light',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">BRIEFINGS </span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="briefed" v-model="C_hideBriefedTasks">   -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ taskVariation.briefings.count }}
                        </h5>
                      </div>
                    </span>
                  </div>
                  <template>
                    <v-checkbox
                      v-model="C_showCountToggle"
                      class="d-inline-block portfolio"
                      @click.prevent="showCounts"
                      :label="`Show Counts`"
                    ></v-checkbox>
                  </template>
                </div>

                <div class="col-2 pl-0 pr-2">
                  <span class="btnRow d-flex">
                    <button
                      v-tooltip="`Presentation Mode`"
                      @click.prevent="openTpresentation"
                      class="btn btn-md presentBtn mr-1 mh-blue text-light"
                      :disabled="tasksObj.filtered.tasks.length == 0"
                    >
                      <i class="fas fa-presentation"></i>
                    </button>
                    <button
                      v-tooltip="`Export to PDF`"
                      @click.prevent="exportTasksToPdf"
                      class="btn btn-md exportBtns text-light"
                      :disabled="tasksObj.filtered.tasks.length == 0"
                    >
                      <i class="far fa-file-pdf"></i>
                    </button>
                    <button
                      v-tooltip="`Export to Excel`"
                      @click.prevent="
                        exportTasksToExcel('table', 'Portfolio Tasks')
                      "
                      class="btn btn-md mx-1 exportBtns text-light"
                      :disabled="tasksObj.filtered.tasks.length == 0"
                    >
                      <i class="far fa-file-excel"></i>
                    </button>
                    <button
                      class="btn text-light btn-md mh-orange px-1 profile-btns portfolioResultsBtn"
                    >
                      RESULTS: {{ tasksObj.filtered.tasks.length }}
                    </button>
                  </span>
                </div>
              </div>

              <div
                class="row mt-2 pr-3"
                style="postion:relative"
                v-if="
                  tasksObj.filtered.tasks !== null &&
                    tasksObj.filtered.tasks.length > 0
                "
              >
                <div class="px-3 tableFixHead">
                  <table
                    class="table table-sm table-bordered"
                    id="portTasks"
                  >
                    <thead style="background-color: #ededed">
                      <th
                        class="sort-th twenty"
                        @click="sortCol1('program_name')"
                      >
                        Program Name
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSortCol1 !== 'program_name'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon main scroll"
                          v-if="
                            currentSortDir1 === 'asc' &&
                              currentSortCol1 === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir1 !== 'asc' &&
                              currentSortCol1 === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon main scroll"
                          v-if="
                            currentSortDir1 === 'desc' &&
                              currentSortCol1 === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir1 !== 'desc' &&
                              currentSortCol1 === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th
                        class="sort-th twenty"
                        @click="sortCol2('project_name')"
                      >
                        Project Name
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSortDir2 !== ''"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon main scroll"
                          v-if="
                            currentSortDir2 === 'asc' &&
                              currentSortCol2 === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir2 !== 'asc' &&
                              currentSortCol2 === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon main scroll"
                          v-if="
                            currentSortDir2 === 'desc' &&
                              currentSortCol2 === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir2 !== 'desc' &&
                              currentSortCol2 === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="pl-1 sort-th twenty" @click="sort('text')">
                        Task
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'text'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' && currentSort === 'text'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' && currentSort === 'text'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' && currentSort === 'text'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' && currentSort === 'text'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>

                      <th
                        class="sort-th twenty"
                        @click="sort('notes_updated_at')"
                        style="min-width: 300px"
                      >
                        Last Update
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'notes_updated_at'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                              currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                              currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                              currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                              currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>

                      <th
                        class="sort-th"
                        style="min-width: 140px"
                        @click="sort('start_date')"
                      >
                        Start Date
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'start_date'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                              currentSort === 'start_date'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                              currentSort === 'start_date'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                              currentSort === 'start_date'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                              currentSort === 'start_date'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th
                        class="sort-th"
                        style="min-width: 140px"
                        @click="sort('due_date')"
                      >
                        Due Date
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'due_date'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                              currentSort === 'due_date'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                              currentSort === 'due_date'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                              currentSort === 'due_date'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                              currentSort === 'due_date'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="sort-th p-1">
                        <span class="py-2 d-inline-block">Assigned Users</span>
                      </th>
                      <th
                        class="sort-th"
                        style="min-width: 115px"
                        @click="sort('progress')"
                      >
                        Progress
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'progress'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                              currentSort === 'progress'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                              currentSort === 'progress'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                              currentSort === 'progress'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                              currentSort === 'progress'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="non-sort-th" style="min-width: 145px">
                        Flags
                      </th>
                      <th class="pl-1 sort-th twenty" @click="sort('category')">
                        Process Area
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'category'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                              currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                              currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                              currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                              currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                    </thead>
                    <tbody>
                      <tr
                        v-for="(task, index) in sortedTasks.reverse()"
                        :key="index"
                        class="portTable taskHover"
                        @click="openTask(task)"
                      >
                        <td>{{ task.program_name }}</td>
                        <td>{{ task.project_name }}</td>
                        <td>{{ task.text }}</td>
                        <td
                          v-if="task.notes_updated_at.length > 0"
                        >
                          <span
                            class="toolTip"
                            v-tooltip="
                              'By: ' +
                                task.notes[task.notes.length - 1].user.full_name
                            "
                          >
                            {{
                              moment(task.notes_updated_at[0]).format(
                                "DD MMM YYYY, h:mm a"
                              )
                            }}
                          </span>
                          <br />
                          <span class="truncate-line-five">
                            {{ task.notes[task.notes.length - 1].body }}
                          </span>
                        </td>
                        <!-- <td v-else class="twentyTwo">No Updates</td> -->
                        <td v-else>No Update</td>

                        <td class="text-center">
                          <span
                            v-if="
                              (task.ongoing &&
                                !task.closed &&
                                task.start_date == null) ||
                                undefined
                            "
                          >
                            <i class="fas fa-retweet text-success"></i>
                          </span>
                          <span
                            v-else-if="
                              (task.ongoing &&
                                task.closed &&
                                task.start_date == null) ||
                                undefined
                            "
                          >
                            <i class="fas fa-retweet text-secondary"></i>
                          </span>
                          <span v-else>{{
                            moment(task.start_date).format("DD MMM YYYY")
                          }}</span>
                        </td>
                        <td class="text-center">
                          <span
                            v-if="task.ongoing && !task.closed"
                            v-tooltip="`Ongoing`"
                            ><i class="fas fa-retweet text-success"></i
                          ></span>
                          <span
                            v-else-if="
                              task.completed &&
                                (task.due_date == null ||
                                  task.due_date == undefined)
                            "
                          ></span>
                          <span
                            v-else-if="task.on_hold && task.due_date == null"
                            v-tooltip="`On Hold (w/no Due Date)`"
                            ><i class="fas fa-pause-circle text-primary"></i
                          ></span>
                          <span v-else>{{
                            moment(task.due_date).format("DD MMM YYYY")
                          }}</span>
                        </td>
                        <td>{{ task.users }}</td>
                        <td class="text-center">
                          <span
                            v-if="task.ongoing && !task.closed"
                            v-tooltip="`Ongoing`"
                            ><i class="fas fa-retweet text-success"></i
                          ></span>
                          <span
                            v-else-if="task.closed"
                            v-tooltip="`Ongoing: Closed`"
                            ><i class="fas fa-retweet text-secondary"></i
                          ></span>

                          <span v-else>
                            {{ task.progress + "%" }}
                          </span>
                        </td>
                        <td class="text-center">
                          <span v-if="task.is_overdue" v-tooltip="`Overdue`">
                            <i class="fas fa-calendar text-danger mr-1"></i
                          ></span>
                          <span v-if="task.completed" v-tooltip="`Completed`"
                            ><i
                              class="fas fa-clipboard-check text-success mr-1"
                            ></i
                          ></span>
                          <span
                            v-if="task.ongoing == true && !task.closed"
                            v-tooltip="`Ongoing`"
                            ><i class="fas fa-retweet mr-1 text-success"></i
                          ></span>
                          <span v-if="task.closed" v-tooltip="`Ongoing: Closed`"
                            ><i class="fas fa-retweet mr-1 text-secondary"></i
                          ></span>
                          <span
                            v-if="task.on_hold == true"
                            v-tooltip="`On Hold`"
                          >
                            <i class="fas fa-pause-circle mr-1 text-primary"></i
                          ></span>
                          <span v-if="task.draft == true" v-tooltip="`Draft`">
                            <i class="fas fa-pencil-alt mr-1 text-warning"></i
                          ></span>
                          <span
                            v-if="task.watched == true"
                            v-tooltip="`On Watch`"
                            ><i class="fas fa-eye mr-1"></i
                          ></span>
                          <span
                            v-if="task.important == true"
                            v-tooltip="`Important`"
                          >
                            <i class="fas fa-star text-warning mr-1"></i
                          ></span>
                          <span v-if="task.reportable" v-tooltip="`Briefings`">
                            <i class="fas fa-presentation mr-1 text-primary"></i
                          ></span>
                          <span v-if="task.planned" v-tooltip="`Planned`">
                            <i class="fas fa-calendar-check text-info mr-1"></i
                          ></span>
                          <span
                            v-if="task.in_progress"
                            v-tooltip="`In Progress`"
                          >
                            <i class="far fa-tasks text-primary mr-1"></i
                          ></span>

                          <!-- <span v-if="
                      task.important == false &&
                      task.reportable == false &&
                      task.watched == false &&
                      task.ongoing == false && 
                      task.isOverdue == false &&
                      task.onHold == false &&  
                      task.draft == false && 
                      task.progress < 100 "             
                    >
                       
              </span>               -->
                        </td>
                        <td>{{ task.category }}</td>
                      </tr>
                    </tbody>
                  </table>
                  <!-- EXPORT (Display:None) -->
                  <table
                    class="table table-bordered w-100"
                    ref="table"
                    id="portTasks1"
                    style="display:none"
                  >
                    <thead>
                      <tr style="background-color:#ededed">
                        <th>Task</th>
                        <th>Process Area</th>
                        <th>Project</th>
                        <th>Start Date</th>
                        <th>Due Date</th>
                        <th>Assigned Users</th>
                        <th>Progress</th>
                        <th>Flags</th>
                        <th>Last Update</th>
                      </tr>
                      <tr></tr>
                    </thead>
                    <tbody v-for="(p, i) in validTaskPrograms" :key="i">
                      <tr id="program">
                        <th scope="row">
                          <b>{{ p }}</b>
                        </th>
                      </tr>
                      <tr
                        v-for="(task, index) in tasksObj.filtered.tasks"
                        :key="index"
                        v-if="task.program_name == p"
                      >
                        <td>{{ task.text }}</td>
                        <td>{{ task.category }}</td>
                        <td>{{ task.project_name }}</td>
                        <td>
                          <span
                            v-if="
                              (task.ongoing &&
                                !task.closed &&
                                task.start_date == null) ||
                                undefined
                            "
                          >
                            <i class="fas fa-retweet text-success"></i>
                          </span>
                          <span
                            v-else-if="
                              (task.ongoing &&
                                task.closed &&
                                task.start_date == null) ||
                                undefined
                            "
                          >
                            <i class="fas fa-retweet text-secondary"></i>
                          </span>
                          <span v-else>{{
                            moment(task.start_date).format("DD MMM YYYY")
                          }}</span>
                        </td>
                        <td>
                          <span
                            v-if="task.ongoing && !task.closed"
                            v-tooltip="`Ongoing`"
                            ><i class="fas fa-retweet text-success"></i
                          ></span>
                          <span
                            v-else-if="
                              task.completed &&
                                (task.due_date == null ||
                                  task.due_date == undefined)
                            "
                          ></span>
                          <span
                            v-else-if="task.on_hold && task.due_date == null"
                            v-tooltip="`On Hold (w/no Due Date)`"
                            ><i class="fas fa-pause-circle text-primary"></i
                          ></span>

                          <span v-else>{{
                            moment(task.due_date).format("DD MMM YYYY")
                          }}</span>
                        </td>
                        <td>{{ task.users }}</td>

                        <td>
                          <span
                            v-if="task.ongoing && !task.closed"
                            v-tooltip="`Ongoing`"
                            ><i class="fas fa-retweet text-success"></i
                          ></span>
                          <span
                            v-else-if="task.closed"
                            v-tooltip="`Ongoing: Closed`"
                            ><i class="fas fa-retweet text-secondary"></i
                          ></span>

                          <span v-else>
                            {{ task.progress + "%" }}
                          </span>
                        </td>
                        <td class="text-center">
                          <span v-if="task.is_overdue" v-tooltip="`Overdue`">
                            Overdue
                          </span><span v-if="task.important" v-tooltip="`Important`">
                            Important
                          </span><span v-if="task.reportable" v-tooltip="`Briefings`">
                            Briefings
                          </span><span v-if="task.watched" v-tooltip="`Watched`">
                            Watched
                          </span>
                          <span v-if="task.completed" v-tooltip="`Completed`">
                            Completed
                          </span>
                          <span
                            v-if="task.ongoing == true && !task.closed"
                            v-tooltip="`Ongoing`"
                            >Ongoing</span>
                          <span v-if="task.closed" v-tooltip="`Ongoing: Closed`"
                            >Ongoing</span>
                          <span
                            v-if="task.on_hold == true"
                            v-tooltip="`On Hold`"
                          >
                            On Hold
                          </span>
                          <span v-if="task.draft == true" v-tooltip="`Draft`">
                            Draft
                          </span>

                          <span v-if="task.planned" v-tooltip="`Planned`">
                            Planned
                          </span>
                          <span
                            v-if="task.in_progress"
                            v-tooltip="`In Progress`"
                          >
                            In Progress
                          </span>
                        </td>
                        <td
                          v-if="task.notes_updated_at.length > 0"
                        >
                          <span
                            class="toolTip"
                            v-tooltip="
                              'By: ' +
                                task.notes[task.notes.length - 1].user.full_name
                            "
                          >
                            {{
                              moment(task.notes_updated_at[0]).format(
                                "DD MMM YYYY, h:mm a"
                              )
                            }}
                          </span>
                          <br />
                          <span class="truncate-line-five">
                            {{ task.notes[task.notes.length - 1].body }}
                          </span>
                        </td>
                        <td v-else>No Update</td>
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
                  <span
                    class="mr-1 pr-3"
                    style="border-right: solid 1px lightgray"
                    >Per Page
                  </span>
                  <button class="btn btn-sm page-btns" @click="prevPage">
                    <i class="fas fa-angle-left"></i>
                  </button>
                  <button class="btn btn-sm page-btns" id="page-count">
                    {{ currentPage }} of
                    {{
                      Math.ceil(
                        tasksObj.filtered.tasks.length /
                          this.C_tasksPerPage.value
                      )
                    }}
                  </button>
                  <button class="btn btn-sm page-btns" @click="nextPage">
                    <i class="fas fa-angle-right"></i>
                  </button>
                </div>
              </div>
              <!-- <div v-else-if="!portfolioTasksLoaded" class="load-spinner spinner-border"></div> -->
              <div v-else class="mt-5">NO RESULTS TO DISPLAY</div>
            </div>
          </el-tab-pane>
          <el-tab-pane
            class="pt-2"
            name="issues"
            v-loading="!portfolioIssuesLoaded"
            element-loading-text="Fetching Portfolio Issues. Please wait..."
            element-loading-spinner="el-icon-loading"
            element-loading-background="rgba(0, 0, 0, 0.8)"
          >
            <template slot="label" class="text-right">
              ISSUES
              <span class="badge badge-secondary badge-pill">
                <span>{{ portfolioCounts.issues_count }}</span>
              </span>
            </template>
            <div class="box-shadow pt-2 pb-1">
              <div class="row py-1 pr-2">
                <div class="col-10 px-1 pt-2">
                  <div class="pb-0 pl-2 pr-4 mb-0 d-inline-flex">
                    <span class=""
                      ><label class="font-sm px-2 mt-4 d-block"
                        >STATES TO DISPLAY</label
                      >
                    </span>

                    <span class="d-flex statesCol mr-3 px-3 py-2">
                      <div
                        class="pr-4 text-center icons"
                        :class="[hideCompleteFlag == true ? 'light' : '']"
                        @click.prevent="toggleComplete"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-clipboard-check"
                            :class="[
                              hideCompleteFlag == true
                                ? 'light'
                                : 'text-success',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">COMPLETE</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ issueVariation.completed.count }}
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideInprogressFlag == true ? 'light' : '']"
                        @click.prevent="toggleInprogress"
                      >
                        <span class="d-block">
                          <i
                            class="far fa-tasks"
                            :class="[
                              hideInprogressFlag == true
                                ? 'light'
                                : 'text-primary',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">IN PROGRESS</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ issueVariation.inProgress.count }}
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideOverdueFlag == true ? 'light' : '']"
                        @click.prevent="toggleOverdue"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-calendar"
                            :class="[
                              hideOverdueFlag == true ? 'light' : 'text-danger',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">OVERDUE </span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ issueVariation.overdue.count }}
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hidePlannedFlag == true ? 'light' : '']"
                        @click.prevent="togglePlanned"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-calendar-check"
                            :class="[
                              hidePlannedFlag == true ? 'light' : 'text-info',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">PLANNED</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          <span v-if="issuesObj.filtered.issues">{{
                            issueVariation.planned.count
                          }}</span>
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideOnholdFlag == true ? 'light' : '']"
                        @click.prevent="toggleOnhold"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-pause-circle"
                            :class="[
                              hideOnholdFlag == true ? 'light' : 'text-primary',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">ON HOLD</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ issueVariation.onHoldI.count }}
                        </h5>
                      </div>

                      <div
                        class="text-center icons"
                        :class="[hideDraftFlag == true ? 'light' : '']"
                        @click.prevent="toggleDraft"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-pencil-alt"
                            :class="[
                              hideDraftFlag == true ? 'light' : 'text-warning',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">DRAFTS</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ issueVariation.issueDrafts.count }}
                        </h5>
                      </div>
                    </span>

                    <span class=""
                      ><label class="font-sm mt-4 pr-2"><b>FOCUS</b></label>
                    </span>
                    <span class="tagsCol d-flex px-3 py-2">
                      <div
                        class="text-center icons"
                        :class="[hideWatchedFlag == true ? '' : 'light']"
                        @click.prevent="toggleWatched"
                      >
                        <span class="d-block">
                          <i class="fas fa-eye"></i>
                        </span>
                        <span class="smallerFont">ON WATCH</span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="watched" v-model="C_hideWatchedissues">               -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ issueVariation.watched.count }}
                        </h5>
                      </div>
                      <div
                        class="px-4 text-center icons"
                        :class="[hideImportantFlag == true ? '' : 'light']"
                        @click.prevent="toggleImportant"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-star"
                            :class="[
                              hideImportantFlag == true
                                ? 'text-warning'
                                : 'light',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">IMPORTANT</span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="important" v-model="C_hideImportantissues">     -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ issueVariation.important.count }}
                        </h5>
                      </div>
                      <div
                        class="text-center icons"
                        :class="[hideBriefedFlag == true ? '' : 'light']"
                        @click.prevent="toggleBriefing"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-presentation"
                            :class="[
                              hideBriefedFlag == true ? 'text-primary' : '',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">BRIEFINGS </span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="briefed" v-model="C_hideBriefedissues">   -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ issueVariation.briefings.count }}
                        </h5>
                      </div>
                    </span>
                  </div>
                  <template>
                    <v-checkbox
                      v-model="C_showCountToggle"
                      class="d-inline-block  portfolio"
                      @click.prevent="showCounts"
                      :label="`Show Counts`"
                    ></v-checkbox>
                  </template>
                </div>

                <div class="col-2 pl-0 pr-2">
                  <span class="btnRow d-flex">
                    <button
                      v-tooltip="`Presentation Mode`"
                      @click.prevent="openIpresentation"
                      class="btn btn-md presentBtn mr-1 text-light mh-blue"
                      :disabled="issuesObj.filtered.issues.length == 0"
                    >
                      <i class="fas fa-presentation"></i>
                    </button>
                    <button
                      v-tooltip="`Export to PDF`"
                      @click.prevent="exportIssuesToPdf"
                      class="btn btn-md exportBtns text-light"
                      :disabled="issuesObj.filtered.issues.length == 0"
                    >
                      <i class="far fa-file-pdf"></i>
                    </button>
                    <button
                      v-tooltip="`Export to Excel`"
                      @click.prevent="
                        exportIssuesToExcel('table', 'Portfolio Issues')
                      "
                      class="btn btn-md mx-1 exportBtns text-light"
                      :disabled="issuesObj.filtered.issues.length == 0"
                    >
                      <i class="far fa-file-excel"></i>
                    </button>
                    <button
                      class="btn text-light btn-md mh-orange px-1 profile-btns portfolioResultsBtn"
                    >
                      RESULTS: {{ issuesObj.filtered.issues.length }}
                    </button>
                  </span>
                </div>
              </div>
            </div>

            <div
              class="row mt-1 pr-3"
              v-if="
                issuesObj.filtered.issues !== null &&
                  issuesObj.filtered.issues.length > 0
              "
            >
              <div class="px-3 tableFixHead" style="overflow-x: auto">
                <table
                  class="table table-sm table-bordered"
                  id="portIssues"
                >
                  <thead style="background-color: #ededed">
                    <th
                      class="sort-th twenty"
                      @click="sortCol1('program_name')"
                    >
                      Program Name
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSortCol1 !== 'program_name'"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon main scroll"
                        v-if="
                          currentSortDir1 === 'asc' &&
                            currentSortCol1 === 'program_name'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir1 !== 'asc' &&
                            currentSortCol1 === 'program_name'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon main scroll"
                        v-if="
                          currentSortDir1 === 'desc' &&
                            currentSortCol1 === 'program_name'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir1 !== 'desc' &&
                            currentSortCol1 === 'program_name'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>
                    <th
                      class="sort-th twenty"
                      @click="sortCol2('project_name')"
                    >
                      Project Name
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSortCol2 !== ''"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon main scroll"
                        v-if="
                          currentSortDir2 === 'asc' &&
                            currentSortCol2 === 'project_name'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir2 !== 'asc' &&
                            currentSortCol2 === 'project_name'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon main scroll"
                        v-if="
                          currentSortDir2 === 'desc' &&
                            currentSortCol2 === 'project_name'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir2 !== 'desc' &&
                            currentSortCol2 === 'project_name'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>
                    <th class="pl-1 sort-th twenty" @click="sortI('title')">
                      Issue
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSort !== 'title'"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'asc' && currentSort === 'title'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'asc' && currentSort === 'title'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'desc' && currentSort === 'title'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'desc' && currentSort === 'title'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>

                    <th
                      class="sort-th"
                      style="min-width: 300px"
                      @click="sortI('notes_updated_at')"
                    >
                      Last Update
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSort !== 'notes_updated_at'"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'asc' &&
                            currentSort === 'notes_updated_at'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'asc' &&
                            currentSort === 'notes_updated_at'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'desc' &&
                            currentSort === 'notes_updated_at'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'desc' &&
                            currentSort === 'notes_updated_at'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>
                    <th class="pl-1 sort-th" @click="sortI('issue_type')">
                      Issue Type
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSort !== 'issue_type'"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'asc' &&
                            currentSort === 'issue_type'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'asc' &&
                            currentSort === 'issue_type'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'desc' &&
                            currentSort === 'issue_type'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'desc' &&
                            currentSort === 'issue_type'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>

                    <th class="pl-1 sort-th" @click="sortI('issue_severity')">
                      Issue Severity
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSort !== 'issue_severity'"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'asc' &&
                            currentSort === 'issue_severity'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'asc' &&
                            currentSort === 'issue_severity'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'desc' &&
                            currentSort === 'issue_severity'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'desc' &&
                            currentSort === 'issue_severity'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>
                    <th
                      class="sort-th"
                      style="min-width: 140px"
                      @click="sort('start_date')"
                    >
                      Start Date
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSort !== 'start_date'"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'asc' &&
                            currentSort === 'start_date'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'asc' &&
                            currentSort === 'start_date'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'desc' &&
                            currentSort === 'start_date'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'desc' &&
                            currentSort === 'start_date'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>
                    <th
                      class="sort-th"
                      style="min-width: 140px"
                      @click="sort('due_date')"
                    >
                      Due Date
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSort !== 'due_date'"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'asc' && currentSort === 'due_date'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'asc' && currentSort === 'due_date'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'desc' &&
                            currentSort === 'due_date'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'desc' &&
                            currentSort === 'due_date'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>
                    <th class="sort-th p-1">
                      <span class="py-2 d-inline-block">Assigned Users</span>
                    </th>
                    <th
                      class="sort-th"
                      style="min-width: 115px"
                      @click="sortI('progress')"
                    >
                      Progress
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSort !== 'progress'"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'asc' && currentSort === 'progress'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'asc' && currentSort === 'progress'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'desc' &&
                            currentSort === 'progress'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'desc' &&
                            currentSort === 'progress'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>
                    <th class="non-sort-th" style="min-width: 145px">Flags</th>
                    <th class="pl-1 sort-th" @click="sort('category')">
                      Process Area
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSort !== 'category'"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'asc' && currentSort === 'category'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'asc' && currentSort === 'category'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'desc' &&
                            currentSort === 'category'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'desc' &&
                            currentSort === 'category'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>
                  </thead>
                  <tbody>
                    <tr
                      v-for="(issue, index) in sortedIssues"
                      :key="index"
                      class="portTable taskHover"
                      @click="openIssue(issue)"
                    >
                      <td>{{ issue.program_name }}</td>
                      <td>{{ issue.project_name }}</td>
                      <td>{{ issue.title }}</td>
                      <td
                        v-if="issue.notes_updated_at.length > 0"
                      >
                        <span
                          class="toolTip"
                          v-tooltip="
                            'By: ' +
                              issue.notes[issue.notes.length - 1].user.full_name
                          "
                        >
                          {{
                            moment(issue.notes_updated_at[0]).format(
                              "DD MMM YYYY, h:mm a"
                            )
                          }}
                        </span>
                        <br />
                        <span class="truncate-line-five">
                          {{ issue.notes[issue.notes.length - 1].body }}
                        </span>
                      </td>
                      <!-- <td v-else class="twentyTwo">No Updates</td> -->
                      <td v-else>No Update</td>
                      <td>{{ issue.issue_type }}</td>
                      <td>{{ issue.issue_severity }}</td>
                      <td class="text-center">
                        {{ moment(issue.start_date).format("DD MMM YYYY") }}
                      </td>
                      <td class="text-center">
                        <span
                          v-if="issue.on_hold && issue.due_date == null"
                          v-tooltip="`On Hold (w/no Due Date)`"
                          ><i class="fas fa-pause-circle text-primary"></i
                        ></span>
                        <span
                          v-else-if="
                            issue.completed &&
                              (issue.due_date == null ||
                                issue.due_date == undefined)
                          "
                        ></span>
                        <span v-else
                          >{{ moment(issue.due_date).format("DD MMM YYYY") }}
                        </span>
                      </td>
                      <td>{{ issue.users }}</td>
                      <td class="text-center">{{ issue.progress + "%" }}</td>
                      <td class="text-center">
                        <span v-if="issue.is_overdue" v-tooltip="`Overdue`">
                          <i class="fas fa-calendar mr-1 text-danger"></i>
                        </span>
                        <span v-if="issue.completed" v-tooltip="`Completed`"
                          ><i
                            class="fas fa-clipboard-check text-success mr-1"
                          ></i
                        ></span>
                        <span
                          v-if="issue.on_hold == true"
                          v-tooltip="`On Hold`"
                        >
                          <i class="fas fa-pause-circle mr-1 text-primary"></i
                        ></span>
                        <span v-if="issue.draft == true" v-tooltip="`Draft`">
                          <i class="fas fa-pencil-alt text-warning"></i
                        ></span>
                        <span
                          v-if="issue.watched == true"
                          v-tooltip="`On Watch`"
                          ><i class="fas fa-eye mr-1"></i
                        ></span>
                        <span
                          v-if="issue.important == true"
                          v-tooltip="`Important`"
                        >
                          <i class="fas fa-star text-warning mr-1"></i
                        ></span>
                        <span v-if="issue.reportable" v-tooltip="`Briefings`">
                          <i class="fas fa-presentation mr-1 text-primary"></i
                        ></span>
                        <span v-if="issue.planned" v-tooltip="`Planned`">
                          <i class="fas fa-calendar-check text-info mr-1"></i
                        ></span>
                        <span
                          v-if="issue.in_progress"
                          v-tooltip="`In Progress`"
                        >
                          <i class="far fa-tasks text-primary mr-1"></i
                        ></span>
                      </td>

                      <td>
                        <span v-if="issue.category">{{ issue.category }}</span>
                        <span v-else> --- </span>
                      </td>
                    </tr>
                  </tbody>
                </table>
                <table
                  class="table table-bordered w-100"
                  ref="issueTable"
                  id="portIssues1"
                  style="display:none"
                >
                  <thead>
                    <tr style="background-color:#ededed">
                      <th>Issue</th>
                      <th>Issue Type</th>
                      <th>Project</th>
                      <th>Issue Severity</th>
                      <th>Start Date</th>
                      <th>Due Date</th>
                      <th>Assigned Users</th>
                      <th>Progress</th>
                      <th>Flags</th>
                      <th>Last Update</th>
                    </tr>
                    <tr></tr>
                  </thead>
                  <tbody v-for="(p, i) in validIssuePrograms" :key="i">
                    <tr class="text-center">
                      <th scope="row">{{ p }}</th>
                    </tr>
                    <tr
                      v-for="(issue, index) in issuesObj.filtered.issues"
                      :key="index"
                      v-if="issue.program_name == p"
                    >
                      <td>{{ issue.title }}</td>
                      <td>{{ issue.issue_type }}</td>
                      <td>{{ issue.project_name }}</td>
                      <td>{{ issue.issue_severity }}</td>
                      <td>
                        {{ moment(issue.start_date).format("DD MMM YYYY") }}
                      </td>
                      <td>
                        <span
                          v-if="issue.on_hold && issue.due_date == null"
                          v-tooltip="`On Hold (w/no Due Date)`"
                          ><i class="fas fa-pause-circle text-primary"></i
                        ></span>
                        <span
                          v-else-if="
                            issue.completed &&
                              (issue.due_date == null ||
                                issue.due_date == undefined)
                          "
                        ></span>
                        <span v-else
                          >{{ moment(issue.due_date).format("DD MMM YYYY") }}
                        </span>
                      </td>
                      <td>{{ issue.users }}</td>
                      <td>{{ issue.progress + "%" }}</td>
                      <td class="text-center">
                        <span v-if="issue.is_overdue" v-tooltip="`Overdue`">
                          Overdue
                        </span>
                        <span v-if="issue.completed" v-tooltip="`Completed`">
                          Completed</span>
                        <span
                          v-if="issue.on_hold == true"
                          v-tooltip="`On Hold`"
                        >
                          On Hold
                        </span>
                        <span v-if="issue.draft == true" v-tooltip="`Draft`">
                          Draft
                        </span>
                        <span v-if="issue.planned" v-tooltip="`Planned`">
                          Planned
                        </span>
                        <span
                          v-if="issue.in_progress"
                          v-tooltip="`In Progress`"
                        >
                          In Progress
                        </span>
                        <span v-if="issue.reportable" v-tooltip="`Briefings`">
                          Briefings</span>
                        <span v-if="issue.important" v-tooltip="`Important`">
                          Important</span>
                        <span v-if="issue.watched" v-tooltip="`Watched`">
                          Watched</span>
                      </td>
                      <td>
                        <span
                          v-if="issue.notes_updated_at.length > 0"
                        >
                          <span
                            class="toolTip"
                            v-tooltip="
                              'By: ' +
                                issue.notes[issue.notes.length - 1].user
                                  .full_name
                            "
                          >
                            {{
                              moment(issue.notes_updated_at[0]).format(
                                "DD MMM YYYY, h:mm a"
                              )
                            }}
                          </span>
                          <br />
                          <span class="truncate-line-five">
                            {{ issue.notes[issue.notes.length - 1].body }}
                          </span>
                        </span>
                        <span v-else> </span>
                      </td>
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
                <span
                  class="mr-1 pr-3"
                  style="border-right: solid 1px lightgray"
                  >Per Page
                </span>
                <button class="btn btn-sm page-btns" @click="prevIssuesPage">
                  <i class="fas fa-angle-left"></i>
                </button>
                <button class="btn btn-sm page-btns" id="page-count">
                  {{ currentIssuesPage }} of
                  {{
                    Math.ceil(
                      this.issuesObj.filtered.issues.length /
                        this.C_issuesPerPage.value
                    )
                  }}
                </button>
                <button class="btn btn-sm page-btns" @click="nextIssuesPage">
                  <i class="fas fa-angle-right"></i>
                </button>
              </div>
            </div>
            <div
              v-else-if="!portfolioIssuesLoaded"
              class="load-spinner spinner-border"
            ></div>
            <div v-else class="mt-5">NO RESULTS TO DISPLAY</div>
          </el-tab-pane>

          <!-- RISKS TAB STARTS HERE -->

          <el-tab-pane
            class="pt-2"
            name="risks"
            v-loading="!portfolioRisksLoaded"
            element-loading-text="Fetching Portfolio Risks. Please wait..."
            element-loading-spinner="el-icon-loading"
            element-loading-background="rgba(0, 0, 0, 0.8)"
          >
            <template
              slot="label"
              class="text-right"
              v-if="
                risksObj.filtered.risks && risksObj.filtered.risks !== undefined
              "
            >
              RISKS
              <span class="badge badge-secondary badge-pill">
                <span>{{ portfolioCounts.risks_count }}</span>
              </span>
            </template>

            <div class="box-shadow py-2">
              <div class="row py-1 pr-2">
                <div class="col-10 px-1 pt-2">
                  <div class="pb-0 pl-2 pr-4 mb-0 d-inline-flex">
                    <span class=""
                      ><label class="font-sm px-2 mt-4 d-block"
                        >STATES TO DISPLAY</label
                      >
                    </span>

                    <span class="d-flex statesCol mr-3 px-3 py-2">
                      <div
                        class="pr-4 text-center icons"
                        :class="[hideCompleteFlag == true ? 'light' : '']"
                        @click.prevent="toggleComplete"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-clipboard-check"
                            :class="[
                              hideCompleteFlag == true
                                ? 'light'
                                : 'text-success',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">COMPLETE</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ riskVariation.completed.count }}
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideInprogressFlag == true ? 'light' : '']"
                        @click.prevent="toggleInprogress"
                      >
                        <span class="d-block">
                          <i
                            class="far fa-tasks"
                            :class="[
                              hideInprogressFlag == true
                                ? 'light'
                                : 'text-primary',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">IN PROGRESS</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ riskVariation.inProgress.count }}
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideOverdueFlag == true ? 'light' : '']"
                        @click.prevent="toggleOverdue"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-calendar"
                            :class="[
                              hideOverdueFlag == true ? 'light' : 'text-danger',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">OVERDUE </span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ riskVariation.overdue.count }}
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideOngoingFlag == true ? 'light' : '']"
                        @click.prevent="toggleOngoing"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-retweet"
                            :class="[
                              hideOngoingFlag == true
                                ? 'light'
                                : 'text-success',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">ONGOING </span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          <span v-if="risksObj.filtered.risks"
                            >{{ riskVariation.ongoing.count
                            }}<span
                              v-tooltip="`Ongoing: Closed`"
                              v-if="riskVariation.ongoingClosed.count > 0"
                              style="color:lightgray"
                              >({{ riskVariation.ongoingClosed.count }})
                            </span>
                          </span>
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hidePlannedFlag == true ? 'light' : '']"
                        @click.prevent="togglePlanned"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-calendar-check"
                            :class="[
                              hidePlannedFlag == true ? 'light' : 'text-info',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">PLANNED</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          <span v-if="risksObj.filtered.risks">{{
                            riskVariation.planned.count
                          }}</span>
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideOnholdFlag == true ? 'light' : '']"
                        @click.prevent="toggleOnhold"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-pause-circle"
                            :class="[
                              hideOnholdFlag == true ? 'light' : 'text-primary',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">ON HOLD</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ riskVariation.onHoldR.count }}
                        </h5>
                      </div>

                      <div
                        class="text-center icons"
                        :class="[hideDraftFlag == true ? 'light' : '']"
                        @click.prevent="toggleDraft"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-pencil-alt"
                            :class="[
                              hideDraftFlag == true ? 'light' : 'text-warning',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">DRAFTS</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ riskVariation.riskDrafts.count }}
                        </h5>
                      </div>
                    </span>

                    <span class=""
                      ><label class="font-sm mt-4 pr-2"><b>FOCUS</b></label>
                    </span>
                    <span class="tagsCol d-flex px-3 py-2">
                      <div
                        class="text-center icons"
                        :class="[hideWatchedFlag == true ? '' : 'light']"
                        @click.prevent="toggleWatched"
                      >
                        <span class="d-block">
                          <i class="fas fa-eye"></i>
                        </span>
                        <span class="smallerFont">ON WATCH</span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="watched" v-model="C_hideWatchedTasks">               -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ riskVariation.watched.count }}
                        </h5>
                      </div>
                      <div
                        class="px-4 text-center icons"
                        :class="[hideImportantFlag == true ? '' : 'light']"
                        @click.prevent="toggleImportant"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-star"
                            :class="[
                              hideImportantFlag == true
                                ? 'text-warning'
                                : 'light',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">IMPORTANT</span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="important" v-model="C_hideImportantTasks">     -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ riskVariation.important.count }}
                        </h5>
                      </div>
                      <div
                        class="text-center icons"
                        :class="[hideBriefedFlag == true ? '' : 'light']"
                        @click.prevent="toggleBriefing"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-presentation"
                            :class="[
                              hideBriefedFlag == true
                                ? 'text-primary '
                                : 'light',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">BRIEFINGS </span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="briefed" v-model="C_hideBriefedTasks">   -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ riskVariation.briefings.count }}
                        </h5>
                      </div>
                    </span>
                  </div>
                  <template>
                    <v-checkbox
                      v-model="C_showCountToggle"
                      class="d-inline-block portfolio"
                      @click.prevent="showCounts"
                      :label="`Show Counts`"
                    ></v-checkbox>
                  </template>
                </div>

                <div class="col-2 pl-0 pr-2">
                  <span class="btnRow d-flex">
                    <button
                      v-tooltip="`Presentation Mode`"
                      @click.prevent="openRpresentation"
                      class="btn btn-md mr-1 text-light mh-blue presentBtn"
                      :disabled="risksObj.filtered.risks.length == 0"
                    >
                      <i class="fas fa-presentation"></i>
                    </button>
                    <button
                      v-tooltip="`Export to PDF`"
                      @click.prevent="exportRisksToPdf"
                      class="btn btn-md exportBtns text-light"
                      :disabled="risksObj.filtered.risks.length == 0"
                    >
                      <i class="far fa-file-pdf"></i>
                    </button>
                    <button
                      v-tooltip="`Export to Excel`"
                      @click.prevent="
                        exportRisksToExcel('table', 'Portfolio Risks')
                      "
                      class="btn btn-md mx-1 exportBtns text-light"
                      :disabled="risksObj.filtered.risks.length == 0"
                    >
                      <i class="far fa-file-excel"></i>
                    </button>
                    <button
                      class="btn text-light btn-md mh-orange px-1 profile-btns portfolioResultsBtn"
                    >
                      RESULTS: {{ risksObj.filtered.risks.length }}
                    </button>
                  </span>
                </div>
              </div>
              <div
                class="row mt-2 pr-3"
                v-if="
                  risksObj.filtered.risks !== null &&
                    risksObj.filtered.risks.length > 0
                "
              >
                <div class="px-3 tableFixHead">
                  <table
                    class="table table-sm table-bordered"
                    id="portRisks"
                  >
                    <thead style="background-color: #ededed">
                      <th
                        class="sort-th twenty"
                        @click="sortCol1('program_name')"
                      >
                        Program Name
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSortCol1 !== 'program_name'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon main scroll"
                          v-if="
                            currentSortDir1 === 'asc' &&
                              currentSortCol1 === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir1 !== 'asc' &&
                              currentSortCol1 === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon main scroll"
                          v-if="
                            currentSortDir1 === 'desc' &&
                              currentSortCol1 === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir1 !== 'desc' &&
                              currentSortCol1 === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th
                        class="sort-th twenty"
                        @click="sortCol2('project_name')"
                      >
                        Project Name
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSortCol2 !== ''"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon main scroll"
                          v-if="
                            currentSortDir2 === 'asc' &&
                              currentSortCol2 === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir2 !== 'asc' &&
                              currentSortCol2 === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon main scroll"
                          v-if="
                            currentSortDir2 === 'desc' &&
                              currentSortCol2 === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir2 !== 'desc' &&
                              currentSortCol2 === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="pl-1 sort-th twenty" @click="sort('text')">
                        Risk
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'text'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' && currentSort === 'text'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' && currentSort === 'text'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' && currentSort === 'text'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' && currentSort === 'text'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th
                        class="sort-th"
                        style="min-width: 300px"
                        @click="sort('notes_updated_at')"
                      >
                        Last Update
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'notes_updated_at'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                              currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                              currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                              currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                              currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>

                      <th class="sort-th" @click="sort('risk_approach')">
                        Risk Approach
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'risk_approach'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                              currentSort === 'risk_approach'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                              currentSort === 'risk_approach'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                              currentSort === 'risk_approach'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                              currentSort === 'risk_approach'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="sort-th" @click="sort('priority_level')">
                        Priority Level
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'priority_level'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                              currentSort === 'priority_level'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                              currentSort === 'priority_level'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                              currentSort === 'priority_level'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                              currentSort === 'priority_level'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th
                        class="sort-th"
                        style="min-width: 140px"
                        @click="sort('start_date')"
                      >
                        Start Date
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'start_date'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                              currentSort === 'start_date'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                              currentSort === 'start_date'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                              currentSort === 'start_date'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                              currentSort === 'start_date'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th
                        class="sort-th"
                        @click="sort('due_date')"
                        style="min-width: 145px"
                      >
                        Risk Approach Due Date
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'due_date'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                              currentSort === 'due_date'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                              currentSort === 'due_date'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                              currentSort === 'due_date'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                              currentSort === 'due_date'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="sort-th p-1">
                        <span class="py-2 d-inline-block">Assigned Users</span>
                      </th>
                      <th
                        class="sort-th"
                        style="min-width: 115px"
                        @click="sort('progress')"
                      >
                        Progress
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'progress'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                              currentSort === 'progress'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                              currentSort === 'progress'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                              currentSort === 'progress'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                              currentSort === 'progress'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="non-sort-th" style="min-width: 145px">
                        Flags
                      </th>
                      <th class="pl-1 sort-th" @click="sort('category')">
                        Process Area
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'category'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                              currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                              currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                              currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                              currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                    </thead>
                    <tbody>
                      <tr
                        v-for="(risk, index) in sortedRisks"
                        :key="index"
                        class="portTable taskHover"
                        @click="openRisk(risk)"
                      >
                        <td>{{ risk.program_name }}</td>
                        <td>{{ risk.project_name }}</td>
                        <td>{{ risk.text }}</td>
                        <td
                          v-if="risk.notes_updated_at.length > 0"
                        >
                          <span
                            class="toolTip"
                            v-tooltip="
                              'By: ' +
                                risk.notes[risk.notes.length - 1].user.full_name
                            "
                          >
                            {{
                              moment(risk.notes_updated_at[0]).format(
                                "DD MMM YYYY, h:mm a"
                              )
                            }}
                          </span>
                          <br />
                          <span class="truncate-line-five">
                            {{ risk.notes[risk.notes.length - 1].body }}
                          </span>
                        </td>
                        <!-- <td v-else class="twentyTwo">No Updates</td> -->
                        <td v-else>No Update</td>

                        <td>
                          {{
                            risk.risk_approach.charAt(0).toUpperCase() +
                              risk.risk_approach.slice(1)
                          }}
                        </td>
                        <td>
                          <span
                            v-if="risk.priority_level == 'Very Low'"
                            class="gray2"
                            >Very Low</span
                          >
                          <span
                            v-else-if="risk.priority_level == 'Low'"
                            class="green1"
                            >Low</span
                          >
                          <span
                            v-else-if="risk.priority_level == 'Moderate'"
                            class="yellow1"
                            >Moderate</span
                          >
                          <span
                            v-else-if="risk.priority_level == 'High'"
                            class="orange1"
                            >High</span
                          >
                          <span
                            v-else-if="risk.priority_level == 'Extreme'"
                            class="red1"
                            >Extreme</span
                          >
                        </td>
                        <td class="text-center">
                          <span
                            v-if="
                              (risk.ongoing &&
                                !risk.closed &&
                                risk.start_date == null) ||
                                undefined
                            "
                          >
                            <i class="fas fa-retweet text-success"></i>
                          </span>
                          <span
                            v-else-if="
                              (risk.ongoing &&
                                risk.closed &&
                                risk.start_date == null) ||
                                undefined
                            "
                          >
                            <i class="fas fa-retweet text-secondary"></i>
                          </span>
                          <span v-else>{{
                            moment(risk.start_date).format("DD MMM YYYY")
                          }}</span>
                        </td>
                        <td class="text-center">
                          <span
                            v-if="risk.ongoing && !risk.closed"
                            v-tooltip="`Ongoing`"
                            ><i class="fas fa-retweet text-success"></i
                          ></span>
                          <span
                            v-else-if="
                              risk.completed &&
                                (risk.due_date == null ||
                                  risk.due_date == undefined)
                            "
                          ></span>
                          <span
                            v-else-if="risk.on_hold && risk.due_date == null"
                            v-tooltip="`On Hold (w/no Due Date)`"
                            ><i class="fas fa-pause-circle text-primary"></i
                          ></span>
                          <span v-else>{{
                            moment(risk.due_date).format("DD MMM YYYY")
                          }}</span>
                        </td>
                        <td>{{ risk.users }}</td>
                        <td class="text-center">
                          <span
                            v-if="risk.ongoing && !risk.closed"
                            v-tooltip="`Ongoing`"
                            ><i class="fas fa-retweet text-success"></i
                          ></span>
                          <span
                            v-else-if="risk.closed"
                            v-tooltip="`Ongoing: Closed`"
                            ><i class="fas fa-retweet text-secondary"></i
                          ></span>
                          <span v-else>
                            {{ risk.progress + "%" }}
                          </span>
                        </td>
                        <td class="text-center">
                          <span v-if="risk.is_overdue" v-tooltip="`Overdue`"
                            ><i class="fas fa-calendar mr-1 text-danger"></i
                          ></span>
                          <span v-if="risk.completed" v-tooltip="`Completed`"
                            ><i
                              class="fas fa-clipboard-check mr-1 text-success"
                            ></i
                          ></span>
                          <span
                            v-if="risk.ongoing == true && !risk.closed"
                            v-tooltip="`Ongoing`"
                            ><i class="fas fa-retweet text-success"></i
                          ></span>
                          <span
                            v-if="risk.closed == true"
                            v-tooltip="`Ongoing: Closed`"
                            ><i class="fas fa-retweet text-secondary"></i
                          ></span>
                          <span
                            v-if="risk.on_hold == true"
                            v-tooltip="`On Hold`"
                          >
                            <i class="fas fa-pause-circle mr-1 text-primary"></i
                          ></span>
                          <span v-if="risk.draft == true" v-tooltip="`Draft`">
                            <i class="fas fa-pencil-alt text-warning"></i
                          ></span>
                          <span
                            v-if="risk.watched == true"
                            v-tooltip="`On Watch`"
                            ><i class="fas fa-eye mr-1"></i
                          ></span>
                          <span
                            v-if="risk.important == true"
                            v-tooltip="`Important`"
                          >
                            <i class="fas fa-star text-warning mr-1"></i
                          ></span>
                          <span v-if="risk.reportable" v-tooltip="`Briefings`">
                            <i class="fas fa-presentation mr-1 text-primary"></i
                          ></span>
                          <span v-if="risk.planned" v-tooltip="`Planned`">
                            <i class="fas fa-calendar-check text-info mr-1"></i
                          ></span>
                          <span
                            v-if="risk.in_progress"
                            v-tooltip="`In Progress`"
                          >
                            <i class="far fa-tasks text-primary mr-1"></i
                          ></span>
                        </td>
                        <td>{{ risk.category }}</td>
                        <!-- <td v-if="risk.last_update !== null">{{risk.last_update.body}}</td> -->
                      </tr>
                    </tbody>
                  </table>
                  <!-- Export (Display:none) -->
                  <table
                    class="table table-bordered w-100"
                    ref="riskTable"
                    id="portRisks1"
                    style="display:none"
                  >
                    <thead>
                      <tr style="background-color:#ededed">
                        <th>Risk</th>
                        <th>Project</th>
                        <th>Risk Approach</th>
                        <th>Priority Level</th>
                        <th>Start Date</th>
                        <th>Due Date</th>
                        <th>Assigned Users</th>
                        <th>Progress</th>
                        <th>Flags</th>
                        <th>Last Update</th>
                      </tr>
                      <tr></tr>
                    </thead>
                    <tbody v-for="(p, i) in validRiskPrograms" :key="i">
                      <tr class="text-center">
                        <th scope="row">{{ p }}</th>
                      </tr>
                      <tr
                        v-for="(risk, index) in risksObj.filtered.risks"
                        :key="index"
                        v-if="risk.program_name == p"
                      >
                        <td>{{ risk.text }}</td>
                        <td>{{ risk.project_name }}</td>
                        <td>
                          {{
                            risk.risk_approach.charAt(0).toUpperCase() +
                              risk.risk_approach.slice(1)
                          }}
                        </td>
                        <td>
                          <span
                            v-if="risk.priority_level == 'Very Low'"
                            class="gray2"
                            >Very Low</span
                          >
                          <span
                            v-else-if="risk.priority_level == 'Low'"
                            class="green1"
                            >Low</span
                          >
                          <span
                            v-else-if="risk.priority_level == 'Moderate'"
                            class="yellow1"
                            >Moderate</span
                          >
                          <span
                            v-else-if="risk.priority_level == 'High'"
                            class="orange1"
                            >High</span
                          >
                          <span
                            v-else-if="risk.priority_level == 'Extreme'"
                            class="red1"
                            >Extreme</span
                          >
                        </td>
                        <td>
                          <span
                            v-if="
                              (risk.ongoing &&
                                !risk.closed &&
                                risk.start_date == null) ||
                                undefined
                            "
                          >
                            <i class="fas fa-retweet text-success"></i>
                          </span>
                          <span
                            v-else-if="
                              (risk.ongoing &&
                                risk.closed &&
                                risk.start_date == null) ||
                                undefined
                            "
                          >
                            <i class="fas fa-retweet text-secondary"></i>
                          </span>
                          <span v-else>{{
                            moment(risk.start_date).format("DD MMM YYYY")
                          }}</span>
                        </td>
                        <td>
                          <span
                            v-if="risk.ongoing && !risk.closed"
                            v-tooltip="`Ongoing`"
                            ><i class="fas fa-retweet text-success"></i
                          ></span>
                          <span
                            v-else-if="
                              risk.completed &&
                                (risk.due_date == null ||
                                  risk.due_date == undefined)
                            "
                          ></span>
                          <span
                            v-else-if="risk.on_hold && risk.due_date == null"
                            v-tooltip="`On Hold (w/no Due Date)`"
                            ><i class="fas fa-pause-circle text-primary"></i
                          ></span>
                          <span v-else>{{
                            moment(risk.due_date).format("DD MMM YYYY")
                          }}</span>
                        </td>
                        <td>{{ risk.users }}</td>
                        <td>
                          <span
                            v-if="risk.ongoing && !risk.closed"
                            v-tooltip="`Ongoing`"
                          >
                            Ongoing
                          </span>
                          <span
                            v-else-if="risk.closed"
                            v-tooltip="`Ongoing: Closed`"
                          >
                            Ongoing
                          </span>
                          <span v-else>
                            {{ risk.progress + "%" }}
                          </span>
                        </td>
                        <td class="text-center">
                          <span v-if="risk.is_overdue" v-tooltip="`Overdue`">
                            Overdue
                          </span>
                          <span v-if="risk.completed" v-tooltip="`Completed`">
                            Completed
                          </span>
                          <span
                            v-if="risk.ongoing == true && !risk.closed"
                            v-tooltip="`Ongoing`"
                          >
                            Ongoing
                          </span>
                          <span
                            v-if="risk.closed == true"
                            v-tooltip="`Ongoing: Closed`"
                          >
                            Ongoing
                          </span>
                          <span
                            v-if="risk.on_hold == true"
                            v-tooltip="`On Hold`"
                          >
                            On Hold
                          </span>
                          <span v-if="risk.draft == true" v-tooltip="`Draft`">
                            Draft
                          </span>

                          <span v-if="risk.planned" v-tooltip="`Planned`">
                            Planned
                          </span>
                          <span
                            v-if="risk.in_progress"
                            v-tooltip="`In Progress`"
                          >
                            In Progress
                          </span>
                          <span v-if="risk.important" v-tooltip="`Important`">
                            Important
                          </span>
                          <span v-if="risk.watched" v-tooltip="`Watched`">
                            Watched
                          </span>
                          <span
                            v-if="risk.reportable"
                            v-tooltip="`Briefings`"
                          >
                            Briefings
                          </span>
                        </td>
                        <td
                          v-if="risk.notes_updated_at.length > 0"
                        >
                          <span
                            class="toolTip"
                            v-tooltip="
                              'By: ' +
                                risk.notes[risk.notes.length - 1].user.full_name
                            "
                          >
                            {{
                              moment(risk.notes_updated_at[0]).format(
                                "DD MMM YYYY, h:mm a"
                              )
                            }}
                          </span>
                          <br />
                          <span class="truncate-line-five">
                            {{ risk.notes[risk.notes.length - 1].body }}
                          </span>
                        </td>
                        <!-- <td v-else class="twentyTwo">No Updates</td> -->
                        <td v-else>No Update</td>
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
                  <span
                    class="mr-1 pr-3"
                    style="border-right: solid 1px lightgray"
                    >Per Page
                  </span>
                  <button class="btn btn-sm page-btns" @click="prevRisksPage">
                    <i class="fas fa-angle-left"></i>
                  </button>
                  <button class="btn btn-sm page-btns" id="page-count">
                    {{ currentRisksPage }} of
                    {{
                      Math.ceil(
                        this.risksObj.filtered.risks.length /
                          this.C_risksPerPage.value
                      )
                    }}
                  </button>
                  <button class="btn btn-sm page-btns" @click="nextRisksPage">
                    <i class="fas fa-angle-right"></i>
                  </button>
                </div>
              </div>
              <div
                v-else-if="!portfolioRisksLoaded"
                class="load-spinner spinner-border"
              ></div>

              <div v-else class="mt-5">NO RESULTS TO DISPLAY</div>
            </div>
          </el-tab-pane>

          <el-tab-pane
            class="pt-2"
            name="lessons"
            v-loading="!portfolioLessonsLoaded"
            element-loading-text="Fetching Portfolio Lessons. Please wait..."
            element-loading-spinner="el-icon-loading"
            element-loading-background="rgba(0, 0, 0, 0.8)"
          >
            <template slot="label" class="text-right">
              LESSONS LEARNED
              <span class="badge badge-secondary badge-pill">
                {{ portfolioCounts.lessons_count }}
              </span>
            </template>
            <div class="box-shadow py-2">
              <div class="row py-1 pr-2">
                <div class="col-10 px-1 pt-2">
                  <div class="pb-0 pl-2 pr-4 mb-0 d-inline-flex">
                    <span class=""
                      ><label class="font-sm px-2 mt-4 d-block"
                        >STATES TO DISPLAY</label
                      >
                    </span>
                    <span class="d-flex statesCol mr-3 px-3 py-2">
                      <div
                        class="pr-4 text-center icons"
                        :class="[hideCompleteFlag == true ? 'light' : '']"
                        @click.prevent="toggleComplete"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-clipboard-check"
                            :class="[
                              hideCompleteFlag == true
                                ? 'light'
                                : 'text-success',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">COMPLETE</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ lessonVariation.completed.count }}
                        </h5>
                      </div>
                      <div
                        class="text-center icons"
                        :class="[hideDraftFlag == true ? 'light' : '']"
                        @click.prevent="toggleDraft"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-pencil-alt"
                            :class="[
                              hideDraftFlag == true ? 'light' : 'text-warning',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">DRAFTS</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ lessonVariation.lessonDrafts.count }}
                        </h5>
                      </div>
                    </span>

                    <span class=""
                      ><label class="font-sm mt-4 pr-2"><b>FOCUS</b></label>
                    </span>
                    <span class="tagsCol d-flex px-3 py-2">
                      <div
                        class="pr-4 text-center icons"
                        :class="[hideImportantFlag == true ? '' : 'light']"
                        @click.prevent="toggleImportant"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-star"
                            :class="[
                              hideImportantFlag == true
                                ? 'text-warning'
                                : 'light',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">IMPORTANT</span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="important" v-model="C_hideImportantTasks">     -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ lessonVariation.important.count }}
                        </h5>
                      </div>
                      <div
                        class="text-center icons"
                        :class="[hideBriefedFlag == true ? '' : 'light']"
                        @click.prevent="toggleBriefing"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-presentation"
                            :class="[
                              hideBriefedFlag == true
                                ? 'text-primary '
                                : 'light',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">BRIEFINGS </span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="briefed" v-model="C_hideBriefedTasks">   -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ lessonVariation.briefings.count }}
                        </h5>
                      </div>
                    </span>
                  </div>
                  <template>
                    <v-checkbox
                      v-model="C_showCountToggle"
                      class="d-inline-block portfolio"
                      @click.prevent="showCounts"
                      :label="`Show Counts`"
                    ></v-checkbox>
                  </template>
                </div>
                <div class="col-2 pl-0 pr-2">
                  <span class="btnRow d-flex">
                    <button
                      v-tooltip="`Presentation Mode`"
                      @click.prevent="openLpresentation"
                      class="btn btn-md presentBtn mr-1 mh-blue"
                      :disabled="lessonsObj.filtered.lessons.length == 0"
                    >
                      <i class="fas fa-presentation text-light"></i>
                    </button>
                    <button
                      v-tooltip="`Export to PDF`"
                      @click.prevent="exportLessonsToPdf"
                      class="btn btn-md exportBtns text-light"
                      :disabled="lessonsObj.filtered.lessons.length == 0"
                    >
                      <i class="far fa-file-pdf"></i>
                    </button>
                    <button
                      v-tooltip="`Export to Excel`"
                      @click.prevent="
                        exportLessonsToExcel('table', 'Portfolio Lessons')
                      "
                      class="btn btn-md mx-1 exportBtns text-light"
                      :disabled="lessonsObj.filtered.lessons.length == 0"
                    >
                      <i class="far fa-file-excel"></i>
                    </button>
                    <button
                      class="btn text-light btn-md mh-orange px-1 profile-btns portfolioResultsBtn"
                    >
                      RESULTS: {{ lessonsObj.filtered.lessons.length }}
                    </button>
                  </span>
                </div>
              </div>

              <div
                class="row mt-2 pr-3"
                v-if="
                  lessonsObj.filtered.lessons !== null &&
                    lessonsObj.filtered.lessons.length > 0
                "
              >
                <div class="tableFixHead px-3">
                  <table
                    class="table table-sm table-bordered"
                    id="portLessons"
                  >
                    <thead style="background-color: #ededed">
                      <th
                        class="sort-th twenty"
                        @click="sortCol1('program_name')"
                      >
                        Program Name
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'program_name'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon main scroll"
                          v-if="
                            currentSortDir1 === 'asc' &&
                              currentSortCol1 === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir1 !== 'asc' &&
                              currentSortCol1 === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon main scroll"
                          v-if="
                            currentSortDir1 === 'desc' &&
                              currentSortCol1 === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir1 !== 'desc' &&
                              currentSortCol1 === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th
                        class="sort-th twenty"
                        @click="sortCol2('project_name')"
                      >
                        Project Name
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSortCol2 !== ''"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon main scroll"
                          v-if="
                            currentSortDir2 === 'asc' &&
                              currentSortCol2 === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir2 !== 'asc' &&
                              currentSortCol2 === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon main scroll"
                          v-if="
                            currentSortDir2 === 'desc' &&
                              currentSortCol2 === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir2 !== 'desc' &&
                              currentSortCol2 === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="pl-1 sort-th" @click="sortL('title')">
                        Lessons Learned
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'title'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' && currentSort === 'title'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' && currentSort === 'title'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' && currentSort === 'title'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' && currentSort === 'title'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th
                        class="sort-th"
                        style="min-width: 300px"
                        @click="sort('notes_updated_at')"
                      >
                        Last Update
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'notes_updated_at'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                              currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                              currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                              currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                              currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th
                        class="pl-1 sort-th"
                        style="min-width: 325px"
                        @click="sortL('description')"
                      >
                        Description
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'description'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                              currentSort === 'description'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                              currentSort === 'description'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                              currentSort === 'description'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                              currentSort === 'description'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <!-- <th class="sort-th p-1">
                 <span class="py-2 d-inline-block">Assigned Users</span>
              </th> -->
                      <th class="sort-th" @click="sortL('added_by')">
                        Added By
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'added_by'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                              currentSort === 'added_by'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                              currentSort === 'added_by'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                              currentSort === 'added_by'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                              currentSort === 'added_by'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th
                        class="sort-th"
                        @click="sortL('created_at')"
                        style="min-width: 140px"
                      >
                        Date Added
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'created_at'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                              currentSort === 'created_at'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                              currentSort === 'created_at'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                              currentSort === 'created_at'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                              currentSort === 'created_at'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th style="min-width: 145px">Flags</th>
                      <th class="pl-1 sort-th" @click="sort('category')">
                        Process Area
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'category'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                              currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                              currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                              currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                              currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                    </thead>
                    <tbody>
                      <tr
                        v-for="(lesson, index) in sortedLessons"
                        :key="index"
                        class="portTable taskHover"
                        @click="openLesson(lesson)"
                      >
                        <td>{{ lesson.program_name }}</td>
                        <td>{{ lesson.project_name }}</td>
                        <td>{{ lesson.title }}</td>
                        <td
                          v-if="lesson.notes_updated_at.length > 0"
                        >
                          <span
                            class="toolTip"
                            v-tooltip="
                              'By: ' +
                                lesson.notes[lesson.notes.length - 1].user
                                  .full_name
                            "
                          >
                            {{
                              moment(lesson.notes_updated_at[0]).format(
                                "DD MMM YYYY, h:mm a"
                              )
                            }}
                          </span>
                          <br />
                          <span class="truncate-line-five">
                            {{ lesson.notes[lesson.notes.length - 1].body }}
                          </span>
                        </td>
                        <!-- <td v-else class="twentyTwo">No Updates</td> -->
                        <td v-else>No Update</td>
                        <td>
                          <span class="truncate-line-five">{{
                            lesson.description
                          }}</span>
                        </td>
                        <td>{{ lesson.added_by }}</td>
                        <td class="text-center">
                          {{ moment(lesson.created_at).format("DD MMM YYYY") }}
                        </td>
                        <td class="text-center">
                          <span v-if="lesson.draft == true" v-tooltip="`Draft`">
                            <i class="fas fa-pencil-alt text-warning"></i
                          ></span>
                          <span
                            v-if="lesson.draft == false"
                            v-tooltip="`Completed`"
                          >
                            <i class="fas fa-clipboard-check text-success"></i
                          ></span>
                          <span
                            v-if="lesson.important == true"
                            v-tooltip="`Important`"
                          >
                            <i class="fas fa-star text-warning mr-1"></i
                          ></span>
                          <span
                            v-if="lesson.reportable"
                            v-tooltip="`Briefings`"
                          >
                            <i class="fas fa-presentation mr-1 text-primary"></i
                          ></span>

                          <span
                            v-if="
                              lesson.important == false &&
                                lesson.reportable == false &&
                                lesson.draft == false
                            "
                          >
                            <!-- No flags at this time          -->
                          </span>
                        </td>
                        <td>
                          <span v-if="lesson.category">{{
                            lesson.category
                          }}</span>
                          <span v-else> --- </span>
                        </td>

                        <!-- <td> {{ lesson.progress }} </td> -->
                      </tr>
                    </tbody>
                  </table>
                  <table
                    class="table table-bordered w-100"
                    id="portLessons1"
                    style="display:none"
                    ref="lessonTable"
                  >
                    <thead>
                      <tr style="background-color:#ededed">
                        <th>Lesson</th>
                        <th>Date Added</th>
                        <th>Added By</th>
                        <th>Description</th>
                        <th>Flags</th>
                        <th>Last Update</th>
                      </tr>
                      <tr></tr>
                    </thead>
                    <tbody v-for="(p, i) in validLessonPrograms" :key="i">
                      <tr class="text-center">
                        <th scope="row">{{ p }}</th>
                      </tr>
                      <tr
                        v-for="(lesson, index) in lessonsObj.filtered.lessons"
                        :key="index"
                        v-if="lesson.program_name == p"
                      >
                        <td>{{ lesson.title }}</td>
                        <td>
                          {{ moment(lesson.created_at).format("DD MMM YYYY") }}
                        </td>
                        <td>
                          {{ lesson.added_by }}
                        </td>
                        <td>
                          <span class="truncate-line-five">{{
                            lesson.description
                          }}</span>
                        </td>
                        <td class="text-center">
                          <span v-if="lesson.important == true" v-tooltip="`Important`">Important</span>
                          <span v-if="lesson.reportable" v-tooltip="`Briefings`">Briefings</span>
                          <span v-if="lesson.draft == true" v-tooltip="`Draft`">Draft</span>
                          <span v-if="lesson.draft == false" v-tooltip="`Completed`">Completed</span>
                          <span v-if="
                                lesson.important == false &&
                                lesson.reportable == false &&
                                lesson.draft == false">
                          </span>
                        </td>
                        <td
                          v-if="lesson.notes_updated_at.length > 0"
                        >
                          <span
                            class="toolTip"
                            v-tooltip="
                              'By: ' +
                                lesson.notes[lesson.notes.length - 1].user
                                  .full_name
                            "
                          >
                            {{
                              moment(lesson.notes_updated_at[0]).format(
                                "DD MMM YYYY, h:mm a"
                              )
                            }}
                          </span>
                          <br />
                          <span class="truncate-line-five">
                            {{ lesson.notes[lesson.notes.length - 1].body }}
                          </span>
                        </td>
                        <!-- <td v-else class="twentyTwo">No Updates</td> -->
                        <td v-else>No Update</td>
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
                  <span
                    class="mr-1 pr-3"
                    style="border-right: solid 1px lightgray"
                    >Per Page
                  </span>
                  <button class="btn btn-sm page-btns" @click="prevLessonsPage">
                    <i class="fas fa-angle-left"></i>
                  </button>
                  <button class="btn btn-sm page-btns" id="page-count">
                    {{ currentLessonsPage }} of
                    {{
                      Math.ceil(
                        this.lessonsObj.filtered.lessons.length /
                          this.C_lessonsPerPage.value
                      )
                    }}
                  </button>
                  <button class="btn btn-sm page-btns" @click="nextLessonsPage">
                    <i class="fas fa-angle-right"></i>
                  </button>
                </div>
              </div>
              <div
                v-else-if="!portfolioLessonsLoaded"
                class="load-spinner spinner-border"
              ></div>
              <div v-else class="mt-5">NO RESULTS TO DISPLAY</div>
            </div>
          </el-tab-pane>
        </el-tabs>
        <div class="row pt-2">
          <div class="col-6 py-0 pl-0"></div>
        </div>
      </el-tab-pane>
      <el-tab-pane
        disabled
        label="PORTFOLIO ANALYTICS (Coming Soon)"
        class="p-3"
      >
      </el-tab-pane>
    </el-tabs>
  </div>
  <!-- </div> -->
</template>

<script>
import Loader from "../../shared/loader.vue";
import { jsPDF } from "jspdf";
import "jspdf-autotable";
import moment from "moment";
Vue.prototype.moment = moment;
import { mapGetters, mapActions, mapMutations } from "vuex";

// We just use `setTimeout()` here to simulate an async operation
// instead of requesting a real API server for demo purpose.
const simulateAsyncOperation = (fn) => {
  setTimeout(fn, 2000);
};

export default {
  name: "PortfolioView",
  props: ["facility"],
  components: {
    Loader,
  },
  data() {
    return {
      prevRoute: null,
      showLess: "Show More",
      activeName: "tasks",
      dialogVisible: false,
      taskRow: {},
      dynamicArray: [],
      taskArray: [],
      taskCount: null,
      issueArray: [],
      issueCount: null,
      riskArray: [],
      riskCount: null,
      lessonArray: [],
      lessoCount: null,
      taskLastPage: null,
      action: "",
      dynamicObj: {},
      currentTaskSlide: 0,
      isSlidingToPrevious: false,
      taskIndex: null,
      search_tasks: "",
      search_issues: "",
      search_risks: "",
      loadMoreItems: 600,
      search_lessons: "",
      currentSort: "text" || "title",
      currentSortCol1: "program_name",
      currentSortCol2: "project_name",
      // currentSortIssueRisk: "title",
      currentSortDir: "asc",
      currentSortDir1: "asc",
      currentSortDir2: "asc",
      // currentSortDir3: "asc",
      loadIssues: false,
      loadRisks: false,
      loadLessons: false,
      programId: null,
      programName: null,
      page: 1,
      pageSize: 10,
      showMore: true,
      today: new Date().toISOString().slice(0, 10),
      facility_project_ids: [],
      uri: "data:application/vnd.ms-excel;base64,",
      template:
        '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="https://www.w3.org/TR/2018/SPSD-html401-20180327/"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
      base64: function(s) {
        return window.btoa(unescape(encodeURIComponent(s)));
      },
      format: function(s, c) {
        return s.replace(/{(\w+)}/g, function(m, p) {
          return c[p];
        });
      },
    };
  },
  mounted() {
    this.fetchPortfolioPrograms();
    this.fetchPortfolioCategories();
    this.$nextTick(function() {
     $(this.currTab).trigger("click");
      this.fetchPortfolioCounts();
      this.setFacilityProjectIds();
    });
  },
  computed: {
    ...mapGetters([
      "getPortfolioWatchedTasksToggle",
      "getPortfolioBriefedTasksToggle",
      "getMyAssignmentsFilter",
      "currentTaskPage",
      "currentIssuePage",
      "currentRiskPage",
      "currentLessonPage",
      "getTasksPerPageFilterOptions",
      "getIssuesPerPageFilterOptions",
      "getRisksPerPageFilterOptions",
      "getLessonsPerPageFilterOptions",
      "getPortfolioImportantTasksToggle",
      "getTasksPerPageFilter",
      "getIssuesPerPageFilter",
      "getRisksPerPageFilter",
      "getLessonsPerPageFilter",
      "getShowCount",
      "currTab",
      // 'hideWatchedFlag',
      "getHideWatched",
      "getHideImportant",
      "getHideBriefed",
      "getHideDraft",
      "getHideComplete",
      "getHideOngoing",
      "getHideInprogress",
      "getHideOverdue",
      "getHidePlanned",
      "getHideOnhold",
      "portfolioTab",
      "portfolioCategories",
      "portfolioNameFilter",
      "portfolioRiskNameFilter",
      "facilityDueDateFilter",
      "noteDateFilter",
      "taskIssueDueDateFilter",
      "activeProjectUsers",
      "programNameFilter",
      "portfolioTasksLoaded",
      "portfolioIssuesLoaded",
      "portfolioRisksLoaded",
      "portfolioLessonsLoaded",
      "taskTypes",
      "currentProject",
      "portfolioCategoriesFilter",
      "portfolioTasks",
      "portfolioCounts",
      "portfolioIssues",
      "portfolioRisks",
      "portfolioLessons",
      "portfolioPrograms",
      "portfolioProgramsLoaded",
      "facilityProgressFilter",
      "programProgressFilter",
      "portfolioUsers",
      "portfolioUsersFilter",
      "portfolioStatuses",
      "portfolioStatusesFilter",
      "portfolioTaskStages",
      "portfolioIssueStages",
      "portfolioRiskStages",
      "portfolioLessonStages",
      "portfolioTaskStagesFilter",
      "portfolioIssueStagesFilter",
      "portfolioRiskStagesFilter",
      "portfolioLessonStagesFilter",
      "portfolioIssueTypes",
      "portfolioIssueTypesFilter",
      "portfolioIssueSeverities",
      "portfolioIssueSeveritiesFilter",
      "portfolioRiskPriorities",
      "portfolioRiskPrioritiesFilter",
      "portfolioRiskApproaches",
      "portfolioRiskApproachesFilter",
      "taskIssueProgressFilter",
    ]),
    prevRoutePath() {
      return this.prevRoute ? this.prevRoute.path : "/";
    },
    currentTab: {
      get() {
        return this.portfolioTab;
      },
      set(value) {
        if (value === "issues") {
          this.setCurrTab("#tab-issues");
        } else if (value === "risks") {
          this.setCurrTab("#tab-risks");
        } else if (value === "lessons") {
          this.setCurrTab("#tab-lessons");
        } else this.setCurrTab("#tab-tasks");
        this.setPortfolioTab(value);
      },
    },
    hideWatchedFlag: {
      get() {
        return this.getHideWatched;
      },
      set(value) {
        this.setHideWatched(value);
      },
    },
    hideCompleteFlag: {
      get() {
        return this.getHideComplete;
      },
      set(value) {
        this.setHideComplete(value);
      },
    },
    hideInprogressFlag: {
      get() {
        return this.getHideInprogress;
      },
      set(value) {
        this.setHideInprogress(value);
      },
    },
    hideDraftFlag: {
      get() {
        return this.getHideDraft;
      },
      set(value) {
        this.setHideDraft(value);
      },
    },
    hideOverdueFlag: {
      get() {
        return this.getHideOverdue;
      },
      set(value) {
        this.setHideOverdue(value);
      },
    },
    hidePlannedFlag: {
      get() {
        return this.getHidePlanned;
      },
      set(value) {
        this.setHidePlanned(value);
      },
    },
    hideOngoingFlag: {
      get() {
        return this.getHideOngoing;
      },
      set(value) {
        this.setHideOngoing(value);
      },
    },
    hideOnholdFlag: {
      get() {
        return this.getHideOnhold;
      },
      set(value) {
        this.setHideOnhold(value);
      },
    },
    hideBriefedFlag: {
      get() {
        return this.getHideBriefed;
      },
      set(value) {
        this.setHideBriefed(value);
      },
    },
    hideImportantFlag: {
      get() {
        return this.getHideImportant;
      },
      set(value) {
        this.setHideImportant(value);
      },
    },
    sortedTasks: function() {
      return this.tasksObj.filtered.tasks
        .sort((a, b) => {
          let modifier = 1;

          if (this.currentSortDir1 === "desc") modifier = -1;
          if (a[this.currentSortCol1] < b[this.currentSortCol1])
            return -1 * modifier;
          if (a[this.currentSortCol1] > b[this.currentSortCol1])
            return 1 * modifier;

          if (this.currentSortDir2 === "desc") modifier = -1;
          if (a[this.currentSortCol2] < b[this.currentSortCol2])
            return -1 * modifier;
          if (a[this.currentSortCol2] > b[this.currentSortCol2])
            return 1 * modifier;

          if (this.currentSortDir === "desc") modifier = -1;
          if (
            typeof a[this.currentSort] === "string" &&
            typeof b[this.currentSort] === "string"
          ) {
            if (
              typeof a[this.currentSort] === "string" ||
              typeof b[this.currentSort] === "string"
            ) {
              if (
                a[this.currentSort].toLowerCase() <
                b[this.currentSort].toLowerCase()
              )
                return -1 * modifier;
              if (
                a[this.currentSort].toLowerCase() >
                b[this.currentSort].toLowerCase()
              )
                return 1 * modifier;
            }
          } else if (a[this.currentSort] < b[this.currentSort])
            return -1 * modifier;
          if (a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
          return 0;
        })
        .filter((row, index) => {
          let start = (this.currentPage - 1) * this.C_tasksPerPage.value;
          let end = this.currentPage * this.C_tasksPerPage.value;
          if (index >= start && index < end) return true;
          return this.end;
        });
    },
    validTaskPrograms() {
      let name = this.sortedTasks;
      return [...new Set(name.map((item) => item.program_name))];
    },
    sortedIssues: function() {
      return this.issuesObj.filtered.issues
        .sort((a, b) => {
          let modifier = 1;
          if (this.currentSortDir1 === "desc") modifier = -1;
          if (a[this.currentSortCol1] < b[this.currentSortCol1])
            return -1 * modifier;
          if (a[this.currentSortCol1] > b[this.currentSortCol1])
            return 1 * modifier;

          if (this.currentSortDir2 === "desc") modifier = -1;
          if (a[this.currentSortCol2] < b[this.currentSortCol2])
            return -1 * modifier;
          if (a[this.currentSortCol2] > b[this.currentSortCol2])
            return 1 * modifier;

          if (this.currentSortDir === "desc") modifier = -1;
          if (
            typeof a[this.currentSort] === "string" &&
            typeof b[this.currentSort] === "string"
          ) {
            if (
              typeof a[this.currentSort] === "string" ||
              typeof b[this.currentSort] === "string"
            ) {
              if (
                a[this.currentSort].toLowerCase() <
                b[this.currentSort].toLowerCase()
              )
                return -1 * modifier;
              if (
                a[this.currentSort].toLowerCase() >
                b[this.currentSort].toLowerCase()
              )
                return 1 * modifier;
            }
          } else if (a[this.currentSort] < b[this.currentSort])
            return -1 * modifier;
          if (a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
          return 0;
        })
        .filter((row, index) => {
          let start = (this.currentIssuesPage - 1) * this.C_issuesPerPage.value;
          let end = this.currentIssuesPage * this.C_issuesPerPage.value;
          if (index >= start && index < end) return true;
          return this.end;
        });
    },
    validIssuePrograms() {
      let name = this.sortedIssues;
      return [...new Set(name.map((item) => item.program_name))];
    },
    sortedRisks: function() {
      return this.risksObj.filtered.risks
        .sort((a, b) => {
          let modifier = 1;
          if (this.currentSortDir1 === "desc") modifier = -1;
          if (a[this.currentSortCol1] < b[this.currentSortCol1])
            return -1 * modifier;
          if (a[this.currentSortCol1] > b[this.currentSortCol1])
            return 1 * modifier;

          if (this.currentSortDir2 === "desc") modifier = -1;
          if (a[this.currentSortCol2] < b[this.currentSortCol2])
            return -1 * modifier;
          if (a[this.currentSortCol2] > b[this.currentSortCol2])
            return 1 * modifier;

          if (this.currentSortDir === "desc") modifier = -1;
          if (
            typeof a[this.currentSort] === "string" &&
            typeof b[this.currentSort] === "string"
          ) {
            if (
              typeof a[this.currentSort] === "string" ||
              typeof b[this.currentSort] === "string"
            ) {
              if (
                a[this.currentSort].toLowerCase() <
                b[this.currentSort].toLowerCase()
              )
                return -1 * modifier;
              if (
                a[this.currentSort].toLowerCase() >
                b[this.currentSort].toLowerCase()
              )
                return 1 * modifier;
            }
          } else if (a[this.currentSort] < b[this.currentSort])
            return -1 * modifier;
          if (a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
          return 0;
        })
        .filter((row, index) => {
          let start = (this.currentRisksPage - 1) * this.C_risksPerPage.value;
          let end = this.currentRisksPage * this.C_risksPerPage.value;
          if (index >= start && index < end) return true;
          return this.end;
        });
    },
    validRiskPrograms() {
      let name = this.sortedRisks;
      return [...new Set(name.map((item) => item.program_name))];
    },
    sortedLessons: function() {
      return this.lessonsObj.filtered.lessons
        .sort((a, b) => {
          let modifier = 1;

          if (this.currentSortDir1 === "desc") modifier = -1;
          if (a[this.currentSortCol1] < b[this.currentSortCol1])
            return -1 * modifier;
          if (a[this.currentSortCol1] > b[this.currentSortCol1])
            return 1 * modifier;

          if (this.currentSortDir2 === "desc") modifier = -1;
          if (a[this.currentSortCol2] < b[this.currentSortCol2])
            return -1 * modifier;
          if (a[this.currentSortCol2] > b[this.currentSortCol2])
            return 1 * modifier;

          if (this.currentSortDir === "desc") modifier = -1;
          if (
            typeof a[this.currentSort] === "string" &&
            typeof b[this.currentSort] === "string"
          ) {
            if (
              typeof a[this.currentSort] === "string" ||
              typeof b[this.currentSort] === "string"
            ) {
              if (
                a[this.currentSort].toLowerCase() <
                b[this.currentSort].toLowerCase()
              )
                return -1 * modifier;
              if (
                a[this.currentSort].toLowerCase() >
                b[this.currentSort].toLowerCase()
              )
                return 1 * modifier;
            }
          } else if (a[this.currentSort] < b[this.currentSort])
            return -1 * modifier;
          if (a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
          return 0;
        })
        .filter((row, index) => {
          let start =
            (this.currentLessonsPage - 1) * this.C_lessonsPerPage.value;
          let end = this.currentLessonsPage * this.C_lessonsPerPage.value;
          if (index >= start && index < end) return true;
          return this.end;
        });
    },
    validLessonPrograms() {
      let name = this.sortedLessons;
      return [...new Set(name.map((item) => item.program_name))];
    },
    validStages() {
      return this.taskArray.filter((t) => {
        return t.task_stage !== null && t.task_stage !== "";
      });
    },
    tasksObj() {
      // if(this.currentTab != 'tasks')
      //   return []
      let tasks = this.taskArray
        .filter((task) => {
          return this.facility_project_ids.length < 1
            ? true
            : this.facility_project_ids.includes(task.facility_project_id);
        })
        .filter((task) => {
          if (this.C_portfolioUsersFilter.length > 0) {
            let users = this.C_portfolioUsersFilter.map((t) => t.name);
            let taskObjUsers = task.task_users.map((t) => t.name);
            return users.some((element) => taskObjUsers.includes(element));
          } else return true;
        })
        .filter((task) => {
          let taskIssueProgress = this.taskIssueProgressFilter;
          if (taskIssueProgress && taskIssueProgress[0]) {
            var min = taskIssueProgress[0].value.split("-")[0];
            var max = taskIssueProgress[0].value.split("-")[1];
            return task.progress >= min && task.progress <= max;
          } else return true;
        })
        .filter((task) => {
          let taskIssueDueDates = this.taskIssueDueDateFilter;
          if (
            taskIssueDueDates &&
            taskIssueDueDates[0] &&
            taskIssueDueDates[1]
          ) {
            let startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD");
            let endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD");
            let valid = true;
            let nDate = moment(task.due_date, "YYYY-MM-DD");
            valid = nDate.isBetween(startDate, endDate, "days", true);
            return valid;
          } else return true;
        })
        .filter((task) => {
          let projectGroupDueDates = this.facilityDueDateFilter;
          if (
            projectGroupDueDates &&
            projectGroupDueDates[0] &&
            projectGroupDueDates[1]
          ) {
            let startDate = moment(projectGroupDueDates[0], "YYYY-MM-DD");
            let endDate = moment([1], "YYYY-MM-DD");
            let valid = true;
            let nDate = moment(task.due_date, "YYYY-MM-DD");
            valid = nDate.isBetween(startDate, endDate, "days", true);
            return valid;
          } else return true;
        })
        .filter((task) => {
          let noteDates = this.noteDateFilter;
          if (noteDates && noteDates[0] && noteDates[1]) {
            let startDate = moment(noteDates[0], "YYYY-MM-DD");
            let endDate = moment(noteDates[1], "YYYY-MM-DD");
            let _notesCreatedAt = _.map(task.notes, "created_at");
            let valid = task.notes.length > 0;
            for (let createdAt of _notesCreatedAt) {
              let nDate = moment(createdAt, "YYYY-MM-DD");
              valid = nDate.isBetween(startDate, endDate, "days", true);
              return valid;
            }
          } else return true;
        })
        .filter((task) => {
          let projectProgress = this.facilityProgressFilter;
          // let valid = Boolean(task && task.hasOwnProperty('progress'))
          if (projectProgress && projectProgress[0]) {
            var min = projectProgress[0].value.split("-")[0];
            var max = projectProgress[0].value.split("-")[1];
            return task.project_progress >= min && task.project_progress <= max;
          } else return true;
        })
        .filter((task) => {
          let programProgress = this.programProgressFilter;
          if (programProgress && programProgress[0]) {
            var min = programProgress[0].value.split("-")[0];
            var max = programProgress[0].value.split("-")[1];
            return task.program_progress >= min && task.program_progress <= max;
          } else return true;
        })
        .filter((task) => {
          // return task.task_stage !== null && task.task_stage !== ''
          if (this.C_portfolioTaskStageFilter.length > 0) {
            let stages = this.C_portfolioTaskStageFilter.map((t) => t.name);
            return stages.includes(task.task_stage);
          } else return true;
        })
        .filter((task) => {
          if (this.C_portfolioStatusesFilter.length > 0) {
            let status = this.C_portfolioStatusesFilter.map((t) => t.name);
            return status.includes(task.project_status);
          } else return true;
        })
        .filter((task) => {
          if (this.C_categoryNameFilter.length > 0) {
            let category = this.C_categoryNameFilter.map((t) => t);
            return category.includes(task.category);
          } else return true;
        })
        .filter((task) => {
          if (this.search_tasks !== "") {
            return (
              task.text.toLowerCase().match(this.search_tasks.toLowerCase()) ||
              task.category
                .toLowerCase()
                .match(this.search_tasks.toLowerCase()) ||
              task.program_name
                .toLowerCase()
                .match(this.search_tasks.toLowerCase()) ||
              task.project_name
                .toLowerCase()
                .match(this.search_tasks.toLowerCase()) ||
              task.users.toLowerCase().match(this.search_tasks.toLowerCase())
            );
          } else return true;
          // Filtering 7 Task States
        });

      return {
        unfiltered: {
          tasks,
        },
        filtered: {
          tasks: tasks
            .filter((task) => {
              if (this.hideDraftFlag) {
                return !task.draft;
              } else return true;
            })
            .filter((task) => {
              if (this.hideOnholdFlag) {
                return !task.on_hold;
              } else return true;
            })
            .filter((task) => {
              if (this.hideOngoingFlag) {
                return !task.ongoing;
              } else return true;
            })
            .filter((task) => {
              if (this.hideInprogressFlag) {
                return !task.in_progress;
              } else return true;
            })
            .filter((task) => {
              if (this.hidePlannedFlag) {
                return !task.planned;
              } else return true;
            })
            .filter((task) => {
              if (this.hideOverdueFlag) {
                return !task.is_overdue;
              } else return true;
            })
            .filter((task) => {
              if (this.hideCompleteFlag) {
                return !task.completed;
              } else return true;
              // Filtering 3 Task Tags
            })
            .filter((task) => {
              if (
                this.hideBriefedFlag &&
                !this.hideWatchedFlag &&
                !this.hideImportantFlag
              ) {
                return task.reportable;
              }
              if (
                this.hideBriefedFlag &&
                this.hideWatchedFlag &&
                !this.hideImportantFlag
              ) {
                return task.reportable + task.watched;
              }
              if (
                this.hideBriefedFlag &&
                this.hideWatchedFlag &&
                this.hideImportantFlag
              ) {
                return task.reportable + task.watched + task.important;
              } else return true;
            })
            .filter((task) => {
              // This and last 2 filters are for Filtered Tags
              if (
                this.hideWatchedFlag &&
                !this.hideBriefedFlag &&
                !this.hideImportantFlag
              ) {
                return task.watched;
              }
              if (
                this.hideWatchedFlag &&
                !this.hideBriefedFlag &&
                this.hideImportantFlag
              ) {
                return task.watched + task.important;
              }
              if (
                this.hideWatchedFlag &&
                this.hideBriefedFlag &&
                !this.hideImportantFlag
              ) {
                return task.watched + task.reportable;
              }
              if (
                this.hideWatchedFlag &&
                this.hideBriefedFlag &&
                this.hideImportantFlag
              ) {
                return task.watched + task.reportable + task.important;
              } else return true;
            })
            .filter((task) => {
              if (
                this.hideImportantFlag &&
                !this.hideBriefedFlag &&
                !this.hideWatchedFlag
              ) {
                return task.important;
              }
              if (
                this.hideImportantFlag &&
                this.hideBriefedFlag &&
                !this.hideWatchedFlag
              ) {
                return task.important + task.reportable;
              }
              if (
                this.hideImportantFlag &&
                this.hideBriefedFlag &&
                this.hideWatchedFlag
              ) {
                return task.important + task.reportable + task.watched;
              } else return true;
            }),
        },
      };
    },
    issuesObj() {
      // if(this.currentTab != 'issues')
      //   return []
      let issues = this.issueArray
        .filter((issue) => {
          return this.facility_project_ids.length < 1
            ? true
            : this.facility_project_ids.includes(issue.facility_project_id);
        })
        .filter((issue) => {
          if (this.C_categoryNameFilter.length > 0) {
            let category = this.C_categoryNameFilter.map((t) => t);
            return category.includes(issue.category);
          } else return true;
        })
        .filter((issue) => {
          let taskIssueDueDates = this.taskIssueDueDateFilter;
          if (
            taskIssueDueDates &&
            taskIssueDueDates[0] &&
            taskIssueDueDates[1]
          ) {
            let startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD");
            let endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD");
            let valid = true;
            let nDate = moment(issue.due_date, "YYYY-MM-DD");
            valid = nDate.isBetween(startDate, endDate, "days", true);
            return valid;
          } else return true;
        })
        .filter((issue) => {
          let noteDates = this.noteDateFilter;
          if (noteDates && noteDates[0] && noteDates[1]) {
            let startDate = moment(noteDates[0], "YYYY-MM-DD");
            let endDate = moment(noteDates[1], "YYYY-MM-DD");
            let _notesCreatedAt = _.map(issue.notes, "created_at");
            let valid = issue.notes.length > 0;
            for (let createdAt of _notesCreatedAt) {
              let nDate = moment(createdAt, "YYYY-MM-DD");
              valid = nDate.isBetween(startDate, endDate, "days", true);
              return valid;
            }
          } else return true;
        })
        .filter((issue) => {
          let taskIssueProgress = this.taskIssueProgressFilter;
          if (taskIssueProgress && taskIssueProgress[0]) {
            var min = taskIssueProgress[0].value.split("-")[0];
            var max = taskIssueProgress[0].value.split("-")[1];
            return issue.progress >= min && issue.progress <= max;
          } else return true;
        })
        .filter((issue) => {
          let projectProgress = this.facilityProgressFilter;
          if (projectProgress && projectProgress[0]) {
            var min = projectProgress[0].value.split("-")[0];
            var max = projectProgress[0].value.split("-")[1];
            return (
              issue.project_progress >= min && issue.project_progress <= max
            );
          } else return true;
        })
        .filter((issue) => {
          let programProgress = this.programProgressFilter;
          if (programProgress && programProgress[0]) {
            var min = programProgress[0].value.split("-")[0];
            var max = programProgress[0].value.split("-")[1];
            return (
              issue.program_progress >= min && issue.program_progress <= max
            );
          } else return true;
        })
        .filter((issue) => {
          if (this.C_portfolioStatusesFilter.length > 0) {
            let status = this.C_portfolioStatusesFilter.map((t) => t.name);
            return status.includes(issue.project_status);
          } else return true;
        })
        .filter((issue) => {
          // return task.task_stage !== null && task.task_stage !== ''
          if (this.C_portfolioIssueStageFilter.length > 0) {
            let stages = this.C_portfolioIssueStageFilter.map((t) => t.name);
            return stages.includes(issue.issue_stage);
          } else return true;
        })
        .filter((issue) => {
          // return task.task_stage !== null && task.task_stage !== ''
          if (this.C_portfolioIssueSeverityFilter.length > 0) {
            let stages = this.C_portfolioIssueSeverityFilter.map((t) => t.name);
            return stages.includes(issue.issue_severity);
          } else return true;
        })
        .filter((issue) => {
          if (this.C_portfolioUsersFilter.length > 0) {
            let users = this.C_portfolioUsersFilter.map((t) => t.name);
            let issueObjUsers = issue.issue_users.map((t) => t.name);
            // console.log(users.some(element => taskObjUsers.includes(element)))
            return users.some((element) => issueObjUsers.includes(element));
          } else return true;
        })
        .filter((issue) => {
          if (this.C_portfolioIssueTypesFilter.length > 0) {
            let types = this.C_portfolioIssueTypesFilter.map((t) => t.name);
            return types.includes(issue.issue_type);
          } else return true;
        })
        .filter((issue) => {
          if (this.search_issues !== "") {
            return (
              issue.title
                .toLowerCase()
                .match(this.search_issues.toLowerCase()) ||
              issue.issue_severity
                .toLowerCase()
                .match(this.search_issues.toLowerCase()) ||
              issue.issue_type
                .toLowerCase()
                .match(this.search_issues.toLowerCase()) ||
              // Process Area not included as it is not a requirement for Issues and null values will break search filter
              // issue.category.toLowerCase().match(this.search_issues.toLowerCase()) ||
              issue.program_name
                .toLowerCase()
                .match(this.search_issues.toLowerCase()) ||
              issue.project_name
                .toLowerCase()
                .match(this.search_issues.toLowerCase()) ||
              issue.users.toLowerCase().match(this.search_issues.toLowerCase())
            );
          } else return true;
        });
      return {
        unfiltered: {
          issues,
        },
        filtered: {
          issues: issues
            .filter((issue) => {
              if (this.hideDraftFlag) {
                return !issue.draft;
              } else return true;
            })
            .filter((issue) => {
              if (this.hideOnholdFlag) {
                return !issue.on_hold;
              } else return true;
            })
            .filter((issue) => {
              if (this.hideOverdueFlag) {
                return !issue.is_overdue;
              } else return true;
            })
            .filter((issue) => {
              if (this.hideCompleteFlag) {
                return !issue.completed;
              } else return true;
            })
            .filter((issue) => {
              if (this.hideInprogressFlag) {
                return !issue.in_progress;
              } else return true;
            })
            .filter((issue) => {
              if (this.hidePlannedFlag) {
                return !issue.planned;
              } else return true;
              // Filtering 3 Issues Tags
            })
            .filter((issue) => {
              if (
                this.hideBriefedFlag &&
                !this.hideWatchedFlag &&
                !this.hideImportantFlag
              ) {
                return issue.reportable;
              }
              if (
                this.hideBriefedFlag &&
                this.hideWatchedFlag &&
                !this.hideImportantFlag
              ) {
                return issue.reportable + issue.watched;
              }
              if (
                this.hideBriefedFlag &&
                this.hideWatchedFlag &&
                this.hideImportantFlag
              ) {
                return issue.reportable + issue.watched + issue.important;
              } else return true;
            })
            .filter((issue) => {
              if (
                this.hideWatchedFlag &&
                !this.hideBriefedFlag &&
                !this.hideImportantFlag
              ) {
                return issue.watched;
              }
              if (
                this.hideWatchedFlag &&
                !this.hideBriefedFlag &&
                this.hideImportantFlag
              ) {
                return issue.watched + issue.important;
              }
              if (
                this.hideWatchedFlag &&
                this.hideImportantFlag &&
                !this.hideBriefedFlag
              ) {
                return issue.important + issue.watched;
              }
              if (
                this.hideWatchedFlag &&
                this.hideImportantFlag &&
                this.hideBriefedFlag
              ) {
                return issue.important + issue.watched + issue.reportable;
              } else return true;
            })
            .filter((issue) => {
              if (
                this.hideImportantFlag &&
                !this.hideBriefedFlag &&
                !this.hideWatchedFlag
              ) {
                return issue.important;
              }
              if (
                this.hideImportantFlag &&
                this.hideBriefedFlag &&
                !this.hideWatchedFlag
              ) {
                return issue.important + issue.reportable;
              }
              if (
                this.hideImportantFlag &&
                this.hideBriefedFlag &&
                this.hideWatchedFlag
              ) {
                return issue.important + issue.reportable + issue.watched;
              } else return true;
            }),
        },
      };
    },
    risksObj() {
      // if(this.currentTab != 'risks')
      //   return []
      let risks = this.riskArray
        .filter((risk) => {
          return this.facility_project_ids.length < 1
            ? true
            : this.facility_project_ids.includes(risk.facility_project_id);
        })
        .filter((risk) => {
          let projectProgress = this.facilityProgressFilter;
          if (projectProgress && projectProgress[0]) {
            var min = projectProgress[0].value.split("-")[0];
            var max = projectProgress[0].value.split("-")[1];
            return risk.project_progress >= min && risk.project_progress <= max;
          } else return true;
        })
        .filter((risk) => {
          let noteDates = this.noteDateFilter;
          if (noteDates && noteDates[0] && noteDates[1]) {
            let startDate = moment(noteDates[0], "YYYY-MM-DD");
            let endDate = moment(noteDates[1], "YYYY-MM-DD");
            let _notesCreatedAt = _.map(risk.notes, "created_at");
            let valid = risk.notes.length > 0;
            for (let createdAt of _notesCreatedAt) {
              let nDate = moment(createdAt, "YYYY-MM-DD");
              valid = nDate.isBetween(startDate, endDate, "days", true);
              return valid;
            }
          } else return true;
        })
        .filter((risk) => {
          let taskIssueDueDates = this.taskIssueDueDateFilter;
          if (
            taskIssueDueDates &&
            taskIssueDueDates[0] &&
            taskIssueDueDates[1]
          ) {
            let startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD");
            let endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD");
            let valid = true;
            let nDate = moment(risk.due_date, "YYYY-MM-DD");
            valid = nDate.isBetween(startDate, endDate, "days", true);
            return valid;
          } else return true;
        })
        .filter((risk) => {
          let programProgress = this.programProgressFilter;
          if (programProgress && programProgress[0]) {
            var min = programProgress[0].value.split("-")[0];
            var max = programProgress[0].value.split("-")[1];
            return risk.program_progress >= min && risk.program_progress <= max;
          } else return true;
        })
        .filter((risk) => {
          let taskIssueProgress = this.taskIssueProgressFilter;
          if (taskIssueProgress && taskIssueProgress[0]) {
            var min = taskIssueProgress[0].value.split("-")[0];
            var max = taskIssueProgress[0].value.split("-")[1];
            return risk.progress >= min && risk.progress <= max;
          } else return true;
        })
        .filter((risk) => {
          if (this.C_portfolioStatusesFilter.length > 0) {
            let status = this.C_portfolioStatusesFilter.map((t) => t.name);
            return status.includes(risk.project_status);
          } else return true;
        })
        .filter((risk) => {
          if (this.C_categoryNameFilter.length > 0) {
            let category = this.C_categoryNameFilter.map((t) => t);
            return category.includes(risk.category);
          } else return true;
        })
        .filter((risk) => {
          if (this.C_portfolioUsersFilter.length > 0) {
            let users = this.C_portfolioUsersFilter.map((t) => t.name);
            let riskObjUsers = risk.risk_users.map((t) => t.name);
            return users.some((element) => riskObjUsers.includes(element));
          } else return true;
        })
        .filter((risk) => {
          if (this.C_portfolioRiskStageFilter.length > 0) {
            let stages = this.C_portfolioRiskStageFilter.map((t) => t.name);
            return stages.includes(risk.risk_stage);
          } else return true;
        })
        .filter((risk) => {
          if (this.C_riskPriorityLevelFilter.length > 0) {
            let priority = this.C_riskPriorityLevelFilter.map((t) => t.id);
            return priority.includes(risk.priority_level.toLowerCase());
          } else return true;
        })
        .filter((risk) => {
          if (this.C_riskApproachFilter.length > 0) {
            let approach = this.C_riskApproachFilter.map((t) => t.name);
            return approach.includes(risk.risk_approach);
          } else return true;
        })
        .filter((risk) => {
          if (this.search_risks !== "") {
            return (
              risk.text.toLowerCase().match(this.search_risks.toLowerCase()) ||
              risk.category
                .toLowerCase()
                .match(this.search_risks.toLowerCase()) ||
              risk.risk_approach
                .toLowerCase()
                .match(this.search_risks.toLowerCase()) ||
              risk.program_name
                .toLowerCase()
                .match(this.search_risks.toLowerCase()) ||
              risk.project_name
                .toLowerCase()
                .match(this.search_risks.toLowerCase()) ||
              risk.users.toLowerCase().match(this.search_risks.toLowerCase())
            );
          } else return true;
        });
      return {
        unfiltered: {
          risks,
        },
        filtered: {
          risks: risks
            .filter((risk) => {
              if (this.hideDraftFlag) {
                return !risk.draft;
              } else return true;
            })
            .filter((risk) => {
              if (this.hideOnholdFlag) {
                return !risk.on_hold;
              } else return true;
            })
            .filter((risk) => {
              if (this.hideInprogressFlag) {
                return !risk.in_progress;
              } else return true;
            })
            .filter((risk) => {
              if (this.hidePlannedFlag) {
                return !risk.planned;
              } else return true;
            })
            .filter((risk) => {
              if (this.hideOverdueFlag) {
                return !risk.is_overdue;
              } else return true;
            })
            .filter((risk) => {
              if (this.hideOngoingFlag) {
                return !risk.ongoing;
              } else return true;
            })
            .filter((risk) => {
              if (this.hideCompleteFlag) {
                return !risk.completed;
              } else return true;
            })
            .filter((risk) => {
              if (
                this.hideBriefedFlag &&
                !this.hideWatchedFlag &&
                !this.hideImportantFlag
              ) {
                return risk.reportable;
              }
              if (
                this.hideBriefedFlag &&
                this.hideWatchedFlag &&
                !this.hideImportantFlag
              ) {
                return risk.reportable + risk.watched;
              }
              if (
                this.hideBriefedFlag &&
                this.hideWatchedFlag &&
                this.hideImportantFlag
              ) {
                return risk.reportable + risk.watched + risk.important;
              } else return true;
            })
            .filter((risk) => {
              if (
                this.hideWatchedFlag &&
                !this.hideBriefedFlag &&
                !this.hideImportantFlag
              ) {
                return risk.watched;
              }
              if (
                this.hideWatchedFlag &&
                !this.hideBriefedFlag &&
                this.hideImportantFlag
              ) {
                return risk.watched + risk.important;
              }
              if (
                this.hideWatchedFlag &&
                this.hideImportantFlag &&
                !this.hideBriefedFlag
              ) {
                return risk.important + risk.watched;
              }
              if (
                this.hideWatchedFlag &&
                this.hideImportantFlag &&
                this.hideBriefedFlag
              ) {
                return risk.important + risk.watched + risk.reportable;
              } else return true;
            })
            .filter((risk) => {
              if (
                this.hideImportantFlag &&
                !this.hideBriefedFlag &&
                !this.hideWatchedFlag
              ) {
                return risk.important;
              }
              if (
                this.hideImportantFlag &&
                this.hideBriefedFlag &&
                !this.hideWatchedFlag
              ) {
                return risk.important + risk.reportable;
              }
              if (
                this.hideImportantFlag &&
                this.hideBriefedFlag &&
                this.hideWatchedFlag
              ) {
                return risk.important + risk.reportable + risk.watched;
              } else return true;
            }),
        },
      };
    },
    lessonsObj() {
      // if(this.currentTab != 'lessons')
      //   return []
      let lessons = this.lessonArray
        .filter((lesson) => {
          return this.facility_project_ids.length < 1
            ? true
            : this.facility_project_ids.includes(lesson.facility_project_id);
        })
        .filter((lesson) => {
          if (this.C_portfolioUsersFilter.length > 0) {
            let users = this.C_portfolioUsersFilter.map((t) => t.name);
            let lessonObjUsers = lesson.added_by;
            // console.log(users.some(element => taskObjUsers.includes(element)))
            return users.some((element) => lessonObjUsers.includes(element));
          } else return true;
        })
        .filter((lesson) => {
          if (this.C_categoryNameFilter.length > 0) {
            let category = this.C_categoryNameFilter.map((t) => t);
            return category.includes(lesson.category);
          } else return true;
        })
        .filter((lesson) => {
          let noteDates = this.noteDateFilter;
          if (noteDates && noteDates[0] && noteDates[1]) {
            let startDate = moment(noteDates[0], "YYYY-MM-DD");
            let endDate = moment(noteDates[1], "YYYY-MM-DD");
            let _notesCreatedAt = _.map(lesson.notes, "created_at");
            let valid = lesson.notes.length > 0;
            for (let createdAt of _notesCreatedAt) {
              let nDate = moment(createdAt, "YYYY-MM-DD");
              valid = nDate.isBetween(startDate, endDate, "days", true);
              return valid;
            }
          } else return true;
        })
        .filter((lesson) => {
          // if (this.search_lessons !== "" && lesson.category && lesson.category !== null) {
          if (this.search_lessons !== "") {
            return (
              lesson.title
                .toLowerCase()
                .match(this.search_lessons.toLowerCase()) ||
              lesson.program_name
                .toLowerCase()
                .match(this.search_lessons.toLowerCase()) ||
              lesson.project_name
                .toLowerCase()
                .match(this.search_lessons.toLowerCase()) ||
              lesson.added_by
                .toLowerCase()
                .match(this.search_lessons.toLowerCase())
            );
          } else return true;
        });
      return {
        unfiltered: {
          lessons,
        },
        filtered: {
          lessons: lessons
            .filter((lesson) => {
              // Filtering 3 Lesson States
              if (this.hideDraftFlag) {
                return !lesson.draft;
              } else return true;
            })
            .filter((lesson) => {
              if (this.hideCompleteFlag) {
                return lesson.draft;
              } else return true;

              // Filtering 3 Task Tags
            })
            .filter((lesson) => {
              if (this.hideBriefedFlag && !this.hideImportantFlag) {
                return lesson.reportable;
              }
              if (
                this.hideBriefedFlag &&
                this.hideWatchedFlag &&
                this.hideImportantFlag
              ) {
                return lesson.reportable + lesson.watched + lesson.important;
              } else return true;
            })
            .filter((lesson) => {
              if (this.hideImportantFlag && !this.hideBriefedFlag) {
                return lesson.important;
              }
              if (this.hideImportantFlag && this.hideBriefedFlag) {
                return lesson.important + lesson.reportable;
              } else return true;
            })
            .filter((lesson) => {
              if (this.C_portfolioLessonStageFilter.length > 0) {
                let stages = this.C_portfolioLessonStageFilter.map((t) => t.name);
                return stages.includes(lesson.lesson_stage);
              } else return true;
            }),
        },
      };
    },
    taskVariation() {
      let planned = _.filter(
        this.tasksObj.unfiltered.tasks,
        (t) => t && t.planned
      );
      let taskDrafts = _.filter(
        this.tasksObj.unfiltered.tasks,
        (t) => t && t.draft == true
      );
      let important = _.filter(
        this.tasksObj.unfiltered.tasks,
        (t) => t && t.important == true
      );
      let briefings = _.filter(
        this.tasksObj.unfiltered.tasks,
        (t) => t && t.reportable == true
      );
      let watched = _.filter(
        this.tasksObj.unfiltered.tasks,
        (t) => t && t.watched == true
      );

      let completed = _.filter(
        this.tasksObj.unfiltered.tasks,
        (t) => t && t.completed
      );
      let inProgress = _.filter(
        this.tasksObj.unfiltered.tasks,
        (t) => t && t.in_progress
      );
      let onHoldT = _.filter(
        this.tasksObj.unfiltered.tasks,
        (t) => t && t.on_hold == true
      );
      let ongoing = _.filter(
        this.tasksObj.unfiltered.tasks,
        (t) => t && t.ongoing == true
      );
      let ongoingClosed = _.filter(
        this.tasksObj.unfiltered.tasks,
        (t) => t && t.closed == true
      );
      let overdue = _.filter(
        this.tasksObj.unfiltered.tasks,
        (t) => t && t.is_overdue == true
      );

      return {
        planned: {
          count: planned.length,
          plannedTs: planned,
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
          count: inProgress.length,
          // percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          // percentage: Math.round(overdue_percent),
        },
        ongoingClosed: {
          count: ongoingClosed.length,
        },
        ongoing: {
          count: ongoing.length,
        },
      };
    },
    issueVariation() {
      let planned = _.filter(
        this.issuesObj.unfiltered.issues,
        (t) => t && t.planned == true
        // (t) => t && t.startDate && t.startDate > this.today
      );
      let issueDrafts = _.filter(
        this.issuesObj.unfiltered.issues,
        (t) => t && t.draft == true
      );
      let completed = _.filter(
        this.issuesObj.unfiltered.issues,
        (t) => t && t.completed
      );
      let inProgress = _.filter(
        this.issuesObj.unfiltered.issues,
        (t) => t && t.in_progress == true
      );
      let onHoldI = _.filter(
        this.issuesObj.unfiltered.issues,
        (t) => t && t.on_hold == true
      );
      let overdue = _.filter(
        this.issuesObj.unfiltered.issues,
        (t) => t && t.is_overdue == true
      );
      let important = _.filter(
        this.issuesObj.unfiltered.issues,
        (t) => t && t.important == true
      );
      let briefings = _.filter(
        this.issuesObj.unfiltered.issues,
        (t) => t && t.reportable == true
      );
      let watched = _.filter(
        this.issuesObj.unfiltered.issues,
        (t) => t && t.watched == true
      );

      return {
        planned: {
          count: planned.length,
          plannedTs: planned,
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
          count: inProgress.length,
          // percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          // percentage: Math.round(overdue_percent),
        },
      };
    },
    // filterOutWatched() {
    //   return _.filter(this.tasksObj, (t) => t && t.watched == false);
    // },
    riskVariation() {
      let planned = _.filter(
        this.risksObj.unfiltered.risks,
        (t) => t && t.planned == true
        // (t) => t && t.startDate && t.startDate > this.today
      );
      let riskDrafts = _.filter(
        this.risksObj.unfiltered.risks,
        (t) => t && t.draft == true
      );
      let important = _.filter(
        this.risksObj.unfiltered.risks,
        (t) => t && t.important == true
      );
      let briefings = _.filter(
        this.risksObj.unfiltered.risks,
        (t) => t && t.reportable == true
      );
      let watched = _.filter(
        this.risksObj.unfiltered.risks,
        (t) => t && t.watched == true
      );
      let completed = _.filter(
        this.risksObj.unfiltered.risks,
        (t) => t && t.completed == true
      );
      let inProgress = _.filter(
        this.risksObj.unfiltered.risks,
        (t) => t && t.in_progress == true
      );
      let onHoldR = _.filter(
        this.risksObj.unfiltered.risks,
        (t) => t && t.on_hold == true
      );
      let ongoing = _.filter(
        this.risksObj.unfiltered.risks,
        (t) => t && t.ongoing == true
      );
      let ongoingClosed = _.filter(
        this.risksObj.unfiltered.risks,
        (t) => t && t.closed == true
      );
      let overdue = _.filter(
        this.risksObj.unfiltered.risks,
        (t) => t && t.is_overdue == true
      );
      return {
        planned: {
          count: planned.length,
          plannedTs: planned,
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
          count: inProgress.length,
          // percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          // percentage: Math.round(overdue_percent),
        },
        ongoingClosed: {
          count: ongoingClosed.length,
        },
        ongoing: {
          count: ongoing.length,
        },
      };
    },
    lessonVariation() {
      let lessonDrafts = _.filter(
        this.lessonsObj.unfiltered.lessons,
        (t) => t && t.draft == true
      );
      let important = _.filter(
        this.lessonsObj.unfiltered.lessons,
        (t) => t && t.important == true
      );
      let briefings = _.filter(
        this.lessonsObj.unfiltered.lessons,
        (t) => t && t.reportable == true
      );
      let completed = _.filter(
        this.lessonsObj.unfiltered.lessons,
        (t) => t && t.draft == false
      );
      return {
        important: {
          count: important.length,
        },
        briefings: {
          count: briefings.length,
        },
        lessonDrafts: {
          count: lessonDrafts.length,
        },
        completed: {
          count: completed.length,
          // percentage: Math.round(completed_percent),
        },
      };
    },
    C_showCountToggle: {
      get() {
        return this.getShowCount;
      },
      set(value) {
        this.setShowCount(value) || this.setShowCount(!this.getShowCount);
      },
    },
    C_portfolioUsersFilter: {
      get() {
        return this.portfolioUsersFilter;
      },
      set(value) {
        this.setPortfolioUsersFilter(value);
      },
    },
    C_portfolioNamesFilter: {
      get() {
        return this.portfolioNameFilter;
      },
      set(value) {
        this.setPortfolioNameFilter(value);
        this.setFacilityProjectIds();
      },
    },
    C_portfolioIssueTypesFilter: {
      get() {
        return this.portfolioIssueTypesFilter;
      },
      set(value) {
        this.setPortfolioIssueTypesFilter(value);
      },
    },
    C_portfolioStatusesFilter: {
      get() {
        return this.portfolioStatusesFilter;
      },
      set(value) {
        this.setPortfolioStatusesFilter(value);
      },
    },
    C_riskPriorityLevelFilter: {
      get() {
        return this.portfolioRiskPrioritiesFilter;
      },
      set(value) {
        this.setPortfolioRiskPrioritiesFilter(value);
      },
    },

    C_riskApproachFilter: {
      get() {
        return this.portfolioRiskApproachesFilter;
      },
      set(value) {
        this.setPortfolioRiskApproachesFilter(value);
      },
    },
    // C_programNames() {
    //   return this.portfolioPrograms;
    // },
    C_categories() {
      let category = this.dynamicArray;
      return [
        ...new Set(
          category
            .filter((item) => item.category != null)
            .map((item) => item.category)
        ),
      ];
    },
    C_i_categories() {
      let category = this.issueArray;
      return [
        ...new Set(
          category
            .filter((item) => item.category != null)
            .map((item) => item.category)
        ),
      ];
    },
    C_r_categories() {
      let category = this.riskArray;
      return [
        ...new Set(
          category
            .filter((item) => item.category != null)
            .map((item) => item.category)
        ),
      ];
    },
    C_l_categories() {
      let category = this.lessonArray;
      return [
        ...new Set(
          category
            .filter((item) => item.category != null)
            .map((item) => item.category)
        ),
      ];
    },
    C_programNameFilter: {
      get() {
        return this.programNameFilter;
      },
      set(value) {
        // console.log(value)
        this.setProgramNameFilter(value);
      },
    },
    C_portfolioTaskStageFilter: {
      get() {
        return this.portfolioTaskStagesFilter;
      },
      set(value) {
        this.setPortfolioTaskStagesFilter(value);
      },
    },
    C_portfolioIssueStageFilter: {
      get() {
        return this.portfolioIssueStagesFilter;
      },
      set(value) {
        this.setPortfolioIssueStagesFilter(value);
      },
    },
    C_portfolioIssueSeverityFilter: {
      get() {
        return this.portfolioIssueSeveritiesFilter;
      },
      set(value) {
        this.setPortfolioIssueSeveritiesFilter(value);
      },
    },
    C_portfolioRiskStageFilter: {
      get() {
        return this.portfolioRiskStagesFilter;
      },
      set(value) {
        this.setPortfolioRiskStagesFilter(value);
      },
    },
     C_portfolioLessonStageFilter: {
      get() {
        return this.portfolioLessonStagesFilter;
      },
      set(value) {
        this.setPortfolioLessonStagesFilter(value);
      },
    },
    C_categoryNameFilter: {
      get() {
        return this.portfolioCategoriesFilter;
      },
      set(value) {
        // console.log(value)
        this.setPortfolioCategoriesFilter(value);
      },
    },
    C_hideWatchedTasks: {
      get() {
        return this.getPortfolioWatchedTasksToggle;
      },
      set() {
        this.setPortfolioWatchedTasksToggle(
          !this.getPortfolioWatchedTasksToggle
        );
      },
    },
    C_hideImportantTasks: {
      get() {
        return this.getPortfolioImportantTasksToggle;
      },
      set() {
        this.setPortfolioImportantTasksToggle(
          !this.getPortfolioImportantTasksToggle
        );
      },
    },
    C_issuesPerPage: {
      get() {
        return this.getIssuesPerPageFilter || { id: 15, name: "15", value: 15 };
      },
      set(value) {
        this.setIssuesPerPageFilter(value);
      },
    },
    C_tasksPerPage: {
      get() {
        return this.getTasksPerPageFilter || { id: 15, name: "15", value: 15 };
      },
      set(value) {
        this.setTasksPerPageFilter(value);
      },
    },
    currentPage: {
      get() {
        return this.currentTaskPage;
      },
      set(value) {
        this.setCurrentPage(value);
      },
    },
    currentIssuesPage: {
      get() {
        return this.currentIssuePage;
      },
      set(value) {
        this.setCurrentIssuePage(value);
      },
    },
    currentRisksPage: {
      get() {
        return this.currentRiskPage;
      },
      set(value) {
        this.setCurrentRiskPage(value);
      },
    },
    currentLessonsPage: {
      get() {
        return this.currentLessonPage;
      },
      set(value) {
        this.setCurrentLessonPage(value);
      },
    },
    C_risksPerPage: {
      get() {
        return this.getRisksPerPageFilter || { id: 15, name: "15", value: 15 };
      },
      set(value) {
        this.setRisksPerPageFilter(value);
      },
    },
    C_lessonsPerPage: {
      get() {
        return (
          this.getLessonsPerPageFilter || { id: 15, name: "15", value: 15 }
        );
      },
      set(value) {
        this.setLessonsPerPageFilter(value);
      },
    },
    C_hideBriefedTasks: {
      get() {
        return this.getPortfolioBriefedTasksToggle;
      },
      set() {
        this.setPortfolioBriefedTasksToggle(
          !this.getPortfolioBriefedTasksToggle
        );
      },
    },
  },
  methods: {
    ...mapMutations([
      "setPortfolioWatchedTasksToggle",
      "setPortfolioNameFilter",
      "setCurrentPage",
      "setCurrentIssuePage",
      "setCurrentRiskPage",
      "setCurrentLessonPage",
      "setPortfolioRiskNameFilter",
      "setTaskIssueUserFilter",
      "setPortfolioTab",
      "setCurrTab",
      "setPortfolioUsersFilter",
      "setTasksPerPageFilter",
      "setTaskIssueProgressFilter",
      "setIssuesPerPageFilter",
      "setRisksPerPageFilter",
      "setLessonsPerPageFilter",
      "setPortfolioBriefedTasksToggle",
      "setPortfolioImportantTasksToggle",
      "setPortfolioCategoriesFilter",
      "setPortfolioStatuses",
      "setPortfolioStatusesFilter",
      "setPortfolioUsers",
      "setPortfolioTaskStages",
      "setPortfolioTaskStagesFilter",
      "setPortfolioIssueStages",
      "setPortfolioIssueStagesFilter",
      "setPortfolioIssueSeverities",
      "setPortfolioIssueSeveritiesFilter",
      "setPortfolioRiskStages",
      "setPortfolioRiskStagesFilter",
      "setPortfolioLessonStagesFilter",
      "setPortfolioUsersFilter",
      "setProgramNameFilter",
      "setPortfolioIssueTypes",
      "setPortfolioIssueTypesFilter",
      "setTaskTypeFilter",
      "setHideWatched",
      "setHideComplete",
      "setHideInprogress",
      "setHideDraft",
      "setHidePlanned",
      "setHideOverdue",
      "setHideOngoing",
      "setHideOnhold",
      "setHideBriefed",
      "setHideImportant",
      "setShowCount",
      "setPortfolioRiskPriorities",
      "setPortfolioRiskPrioritiesFilter",
      "setPortfolioRiskApproaches",
      "setPortfolioRiskApproachesFilter",
      "setProgramProgressFilter",
      "setFacilityProgressFilter",
      "setNoteDateFilter",
      "setTaskIssueDueDateFilter",
      "setFacilityDueDateFilter",
      "updateProgramFilterValue",
    ]),
    ...mapActions([
      "fetchPortfolioTasks",
      "fetchPortfolioIssues",
      "fetchPortfolioCounts",
      "fetchPortfolioRisks",
      "fetchPortfolioLessons",
      "fetchPortfolioPrograms",
      "fetchPortfolioCategories",
      'fetchPortfolioAssignees', 
      'fetchPortfolioIssueStages', 
      'fetchPortfolioLessonStages',
      'fetchPortfolioRiskStages',
      'fetchPortfolioIssueTypes', 
      'fetchPortfolioIssueSeverities',
      

    ]),
    log(e) {
      console.log(e);
    },
    showCounts() {
      this.setShowCount(!this.getShowCount);
    },
    setFacilityProjectIds() {
      this.facility_project_ids = [];
      let value = this.portfolioNameFilter;
      if (!value) {
        return;
      }
      for (let k = 0; k < value.length; k++) {
        if (value[k].program_id) {
          this.facility_project_ids = this.facility_project_ids.concat(
            value[k].all_facility_project_ids
          );
        } else if (value[k].project_group_id) {
          this.facility_project_ids = this.facility_project_ids.concat(
            value[k].all_facility_project_ids
          );
        } else if (value[k].project_id) {
          this.facility_project_ids.push(value[k].facility_project_id);
        }
      }
      this.facility_project_ids = _.uniq(this.facility_project_ids);
    },
    openTask(task) {
      this.$router.push({
        name: "PortfolioTaskForm",
        params: {
          programId: task.program_id,
          projectId: task.project_id,
          id: task.id,
        },
      });
    },
    hasHistory() {
      return window.history.length > 2;
    },
    openIssue(issue) {
      this.$router.push({
        name: "PortfolioIssueForm",
        params: {
          programId: issue.program_id,
          projectId: issue.project_id,
          id: issue.id,
        },
      });
    },
    openRisk(risk) {
      this.$router.push({
        name: "PortfolioRiskForm",
        params: {
          programId: risk.program_id,
          projectId: risk.project_id,
          id: risk.id,
        },
      });
    },
    openLesson(lesson) {
      //  console.log(lesson)
      this.$router.push({
        name: "PortfolioLessonForm",
        params: {
          programId: lesson.program_id,
          projectId: lesson.project_id,
          id: lesson.id,
          lessonId: lesson.id,
          lesson,
        },
      });
    },
    beforeClose(done) {
      this.dialogVisible = false;
      done();
    },
    setValueNull(val) {
      this.setPortfolioCategoriesFilter("");
    },
    // NOTE: WIP
    programAjaxFilterOptions({ action, parentNode, callback }) {
      // Typically, do the AJAX stuff here.
      // Once the server has responded,
      // assign children options to the parent node & call the callback.

      if (action === LOAD_CHILDREN_OPTIONS) {
        switch (parentNode.id) {
          case "success": {
            simulateAsyncOperation(() => {
              parentNode.children = [
                {
                  id: "child",
                  label: "Child option",
                },
              ];
              callback();
            });
            break;
          }
          case "no-children": {
            simulateAsyncOperation(() => {
              parentNode.children = [];
              callback();
            });
            break;
          }
          case "failure": {
            simulateAsyncOperation(() => {
              callback(new Error("Failed to load options: network error."));
            });
            break;
          }
          default: /* empty */
        }
      }
    },
    searchChildren: function(node) {
      // console.log("start", new Date() )
      if (node.children && node.children.length > 0) {
        for (let k = 0; k < node.children.length; k++) {
          this.searchChildren(node.children[k]);
        }
      } else {
        this.facility_project_ids.push(node.facility_project_id);
      }
      // console.log("end",new Date() )
    },
    openTpresentation() {
      this.dialogVisible = true;
      this.currentTaskSlide = 0;
      this.dynamicObj = this.tasksObj.filtered.tasks;
      this.action = "TASK";
    },
    openIpresentation() {
      this.dialogVisible = true;
      this.currentTaskSlide = 0;
      this.dynamicObj = this.issuesObj.filtered.issues;
      this.action = "ISSUE";
    },
    openRpresentation() {
      this.dialogVisible = true;
      this.currentTaskSlide = 0;
      this.dynamicObj = this.risksObj.filtered.risks;
      this.action = "RISK";
    },
    openLpresentation() {
      this.dialogVisible = true;
      this.currentTaskSlide = 0;
      this.dynamicObj = this.lessonsObj.filtered.lessons;
      this.action = "LESSON";
    },
    nextTask() {
      this.isSlidingToPrevious = false;
      if (this.currentTaskSlide == this.dynamicObj.length - 1) {
        this.currentTaskSlide = 0;
      } else {
        this.currentTaskSlide += 1;
      }
    },
    previousTask() {
      this.isSlidingToPrevious = true;
      if (this.currentTaskSlide == 0) {
        this.currentTaskSlide = this.dynamicObj.length - 1;
      } else {
        this.currentTaskSlide -= 1;
      }
    },
    showCountToggle() {
      this.getShowCount(!this.getShowCount);
    },
    sort: function(s) {
      //if s == current sort, reverse
      if (s === this.currentSort) {
        this.currentSortDir = this.currentSortDir === "asc" ? "desc" : "asc";
      }
      this.currentSort = s;
    },
    sortI: function(s) {
      //if s == current sort, reverse
      if (s === this.currentSort) {
        this.currentSortDir = this.currentSortDir === "asc" ? "desc" : "asc";
      }
      this.currentSort = s;
    },
    sortCol1: function(s) {
      //if s == current sort, reverse
      if (s === this.currentSortCol1) {
        this.currentSortDir1 = this.currentSortDir1 === "asc" ? "desc" : "asc";
      }
      this.currentSortCol1 = s;
      this.currentSort = "";
    },
    sortCol2: function(s) {
      //if s == current sort, reverse
      if (s === this.currentSortCol2) {
        this.currentSortDir2 = this.currentSortDir2 === "asc" ? "desc" : "asc";
      }
      this.currentSortCol2 = s;
      this.currentSort = "";
    },
    nextPage: function() {
      if (
        this.currentPage * this.C_tasksPerPage.value <
        this.tasksObj.filtered.tasks.length
      )
        this.currentPage++;
    },
    prevPage: function() {
      if (this.currentPage > 1) this.currentPage--;
    },

    nextIssuesPage: function() {
      if (
        this.currentIssuesPage * this.C_issuesPerPage.value <
        this.issuesObj.filtered.issues.length
      )
        this.currentIssuesPage++;
    },
    prevIssuesPage: function() {
      if (this.currentIssuesPage > 1) this.currentIssuesPage--;
    },
    sortR: function(s) {
      //if s == current sort, reverse
      if (s === this.currentSort) {
        this.currentSortDir = this.currentSortDir === "asc" ? "desc" : "asc";
      }
      this.currentSort = s;
    },
    nextRisksPage: function() {
      if (
        this.currentRisksPage * this.C_risksPerPage.value <
        this.risksObj.filtered.risks.length
      )
        this.currentRisksPage++;
    },
    prevRisksPage: function() {
      if (this.currentRisksPage > 1) this.currentRisksPage--;
    },
    sortL: function(s) {
      //if s == current sort, reverse
      if (s === this.currentSort) {
        this.currentSortDir = this.currentSortDir === "asc" ? "desc" : "asc";
      }
      this.currentSort = s;
    },
    nextLessonsPage: function() {
      if (
        this.currentLessonsPage * this.C_lessonsPerPage.value <
        this.lessonsObj.filtered.lessons.length
      )
        this.currentLessonsPage++;
    },
    prevLessonsPage: function() {
      if (this.currentLessonsPage > 1) this.currentLessonsPage--;
    },
    exportTasksToPdf() {
      const doc = new jsPDF("l");
      const html = this.$refs.table.innerHTML;
      doc.autoTable({
        html: "#portTasks1",
        didParseCell: function(hookData) {
          // console.log(hookData)
          if (hookData.section == "head") {
            hookData.cell.styles.fillColor = "383838";
            hookData.cell.styles.textColor = [255, 255, 255];
          }
          for (const t of Object.values(hookData.table.body)) {
            if (t.raw.length === 1) {
              // console.log("yes")
              for (const s of Object.values(t.cells)) {
                s.styles.fontStyle = "bold";
                s.styles.textColor = [255, 255, 255];
                s.styles.fillColor = [2, 117, 216];
              }
            }
          }
        },
      });
      doc.save("Portfolio_Task_List.pdf");
    },
    exportTasksToExcel(table, name) {
      if (!table.nodeType) table = this.$refs.table;
      var ctx = { worksheet: name || "Worksheet", table: table.innerHTML };
      window.location.href =
        this.uri + this.base64(this.format(this.template, ctx));
    },
    exportIssuesToPdf() {
      const doc = new jsPDF("l");
      const html = this.$refs.table.innerHTML;
      doc.autoTable({
        html: "#portIssues1",
        didParseCell: function(hookData) {
          // console.log(hookData)
          if (hookData.section == "head") {
            hookData.cell.styles.fillColor = "383838";
            hookData.cell.styles.textColor = [255, 255, 255];
          }
          for (const t of Object.values(hookData.table.body)) {
            if (t.raw.length === 1) {
              // console.log("yes")
              for (const s of Object.values(t.cells)) {
                s.styles.fontStyle = "bold";
                s.styles.textColor = [255, 255, 255];
                s.styles.fillColor = [2, 117, 216];
              }
            }
          }
        },
      });
      doc.save("Portfolio_Issues_Log.pdf");
    },
    exportIssuesToExcel(issueTable, name) {
      if (!issueTable.nodeType) issueTable = this.$refs.issueTable;
      var ctx = { worksheet: name || "Worksheet", table: issueTable.innerHTML };
      window.location.href =
        this.uri + this.base64(this.format(this.template, ctx));
    },
    exportRisksToPdf() {
      const doc = new jsPDF("l");
      const html = this.$refs.table.innerHTML;
      doc.autoTable({
        html: "#portRisks1",
        didParseCell: function(hookData) {
          // console.log(hookData)
          if (hookData.section == "head") {
            hookData.cell.styles.fillColor = "383838";
            hookData.cell.styles.textColor = [255, 255, 255];
          }
          for (const t of Object.values(hookData.table.body)) {
            if (t.raw.length === 1) {
              // console.log("yes")
              for (const s of Object.values(t.cells)) {
                s.styles.fontStyle = "bold";
                s.styles.textColor = [255, 255, 255];
                s.styles.fillColor = [2, 117, 216];
              }
            }
          }
        },
      });
      doc.save("Portfolio_Risk_List.pdf");
    },
    exportRisksToExcel(riskTable, name) {
      if (!riskTable.nodeType) riskTable = this.$refs.riskTable;
      var ctx = { worksheet: name || "Worksheet", table: riskTable.innerHTML };
      window.location.href =
        this.uri + this.base64(this.format(this.template, ctx));
    },
    exportLessonsToPdf() {
      const doc = new jsPDF("l");
      const html = this.$refs.table.innerHTML;
      doc.autoTable({
        html: "#portLessons1",
        didParseCell: function(hookData) {
          // console.log(hookData)
          if (hookData.section == "head") {
            hookData.cell.styles.fillColor = "383838";
            hookData.cell.styles.textColor = [255, 255, 255];
          }
          for (const t of Object.values(hookData.table.body)) {
            if (t.raw.length === 1) {
              // console.log("yes")
              for (const s of Object.values(t.cells)) {
                s.styles.fontStyle = "bold";
                s.styles.textColor = [255, 255, 255];
                s.styles.fillColor = [2, 117, 216];
              }
            }
          }
        },
      });
      doc.save("Portfolio_Lessons_List.pdf");
    },
    exportLessonsToExcel(lessonTable, name) {
      if (!lessonTable.nodeType) lessonTable = this.$refs.lessonTable;
      var ctx = {
        worksheet: name || "Worksheet",
        table: lessonTable.innerHTML,
      };
      window.location.href =
        this.uri + this.base64(this.format(this.template, ctx));
    },
    // Toggle for 3 Action Tags
    toggleWatched() {
      this.setHideWatched(!this.getHideWatched);
      // this.hideWatchedFlag = !this.hideWatchedFlag;
    },
    toggleBriefing() {
      this.setHideBriefed(!this.getHideBriefed);
    },
    toggleImportant() {
      this.setHideImportant(!this.getHideImportant);
    },
    // Toggle for 7 Action States
    toggleComplete() {
      this.setHideComplete(!this.getHideComplete);
    },
    toggleInprogress() {
      this.setHideInprogress(!this.getHideInprogress);
    },
    toggleOverdue() {
      this.setHideOverdue(!this.getHideOverdue);
    },
    toggleOngoing() {
      this.setHideOngoing(!this.getHideOngoing);
    },
    toggleDraft() {
      this.setHideDraft(!this.getHideDraft);
    },
    togglePlanned() {
      this.setHidePlanned(!this.getHidePlanned);
    },
    toggleOnhold() {
      this.setHideOnhold(!this.getHideOnhold);
    },
    toggleOverdue() {
      this.setHideOverdue(!this.getHideOverdue);
    },
    setPage(val) {
      this.page = val;
    },
    getProgramId(id) {
      this.programId = id;
      // console.log(id);
    },
    backHomeBtn() {
      window.location.pathname = "/";
    },
    handleClick(tab, event) {
      // let size = this.loadMoreItems;
      let page = 1;
      // console.log(tab);
      let tab_id = $(event.target).attr("id");
      if (tab_id == "tab-tasks" || tab.name == "tasks") {
        this.currentTab = "tasks";
        if (
          this.tasksObj.filtered.tasks &&
          this.tasksObj.filtered.tasks.length < 1
        ) {
          this.fetchPortfolioTasks({page});
          this.fetchPortfolioAssignees()
        }
      } else if (tab_id == "tab-issues" || tab.name == "issues") {
        this.currentTab = "issues";
        if (
          this.issuesObj.filtered.issues &&
          this.issuesObj.filtered.issues.length < 1
        ) {
          this.fetchPortfolioIssues({page});
          this.fetchPortfolioIssueStages()
          this.fetchPortfolioIssueTypes()
          this.fetchPortfolioIssueSeverities()
        }
      } else if (tab_id == "tab-risks" || tab.name == "risks") {
        this.currentTab = "risks";
        if (
          this.risksObj.filtered.risks &&
          this.risksObj.filtered.risks.length < 1
        ) {
          this.fetchPortfolioRisks({page});     
          this.fetchPortfolioRiskStages()

         }
      } else if (tab_id == "tab-lessons" || tab.name == "lessons") {
        this.currentTab = "lessons";
        if (
          this.lessonsObj.filtered.lessons &&
          this.lessonsObj.filtered.lessons.length < 1
        ) {
          this.fetchPortfolioLessons({page});
          this.fetchPortfolioLessonStages();
        }
      }
    },
  },
  watch: {
    $route(to, from) {
      this.$store && this.$store.commit("nullifyTasksForManager");
    },
    portfolioTasksLoaded: {
      handler() {
        if (this.portfolioTasksLoaded) {
          this.taskArray = this.portfolioTasks.tasks;
          this.dynamicArray = this.portfolioTasks.tasks;
          this.taskLastPage = this.portfolioTasks.last_page;
          this.taskCount = this.portfolioTasks.total_count;
          let currCount = this.portfolioTasks.tasks.length;
          let total = this.portfolioTasks.total_count;
          // if(this.portfolioTasks.next_page){
          //   let page = this.portfolioTasks.current_page 
          //   this.fetchPortfolioTasks({page});
          // }
          // if (currCount < total) {
          //   let size = (this.loadMoreItems += 250);
          //   this.fetchPortfolioTasks({ size });
          // } else if (currCount == total) {
          //   return;
          // }
        }
      },
    },
    portfolioIssuesLoaded: {
      handler() {
        if (this.portfolioIssuesLoaded) {
          this.issueArray = this.portfolioIssues.issues;
          this.dynamicArray = this.portfolioIssues.issues;
          this.issueLastPage = this.portfolioIssues.last_page;
          this.issueCount = this.portfolioIssues.total_count;
          let currCount = this.portfolioIssues.issues.length;
          let total = this.portfolioIssues.total_count;
          if(this.portfolioIssues.next_page && this.portfolioIssues.current_page != this.portfolioIssues.next_page){
            let page = this.portfolioIssues.next_page
            this.fetchPortfolioIssues({page});
          }
          
          // if (currCount == total) {
          //   return;
          //   // this.fetchPortfolioIssues({size});
          //   // console.log("tasks: ", this.portfolioTasks.tasks.length, "total: ", this.portfolioTasks.total_count)
          // } else if (currCount < total) {
          //   let size = (this.loadMoreItems += 250);
          //   this.fetchPortfolioIssues({ size });
          // }
        }
      },
    },
    portfolioRisksLoaded: {
      handler() {
        if (this.portfolioRisksLoaded) {
          this.riskArray = this.portfolioRisks.risks;
          this.dynamicArray = this.portfolioRisks.risks;
          this.riskLastPage = this.portfolioRisks.last_page;
          this.riskCount = this.portfolioRisks.total_count;
          let currCount = this.portfolioRisks.risks.length;
          let total = this.portfolioRisks.total_count;
          if(this.portfolioRisks.next_page && this.portfolioRisks.current_page != this.portfolioRisks.next_page){
            let page = this.portfolioRisks.next_page
            this.fetchPortfolioRisks({page});
          }
          // if (currCount < total) {
          //   let size = (this.loadMoreItems += 250);
          //   this.fetchPortfolioRisks({ size });
          //   // console.log("tasks: ", this.portfolioTasks.tasks.length, "total: ", this.portfolioTasks.total_count)
          // } else if (currCount == total) {
          //   return;
          // }
        }
      },
    },
    portfolioLessonsLoaded: {
      handler() {
        if (this.portfolioLessonsLoaded) {
          this.lessonArray = this.portfolioLessons.lessons;
          this.dynamicArray = this.portfolioLessons.lessons;
          this.lessonLastPage = this.portfolioLessons.last_page;
          this.lessonCount = this.portfolioLessons.total_count;
          let currCount = this.portfolioLessons.lessons.length;
          let total = this.portfolioLessons.total_count;
          if(this.portfolioLessons.next_page && this.portfolioLessons.current_page != this.portfolioLessons.next_page){
            let page = this.portfolioLessons.next_page
            this.fetchPortfolioLessons({page});
          }
          // if (currCount < total) {
          //   let size = (this.loadMoreItems += 250);
          //   this.fetchPortfolioLessons({ size });
          //   // console.log("tasks: ", this.portfolioTasks.tasks.length, "total: ", this.portfolioTasks.total_count)
          // } else if (currCount == total) {
          //   return;
          // }
        }
      },
    },
  },
};
</script>

<style scoped lang="scss">
.breakWord {
  /* These are technically the same, but use both */
  overflow-wrap: break-word;
  word-wrap: break-word;
  white-space: pre-wrap;
  -ms-word-break: break-all;
  /* This is the dangerous one in WebKit, as it breaks things wherever */
  word-break: break-all;
  /* Instead use this non-standard one: */
  word-break: break-word;

  /* Adds a hyphen where the word breaks, if supported (No Blink) */
  -ms-hyphens: auto;
  -moz-hyphens: auto;
  -webkit-hyphens: auto;
  hyphens: auto;
}
</style>
