<template>
  <div
    v-loading="!portfolioRiskLoaded"
    element-loading-text="Fetching Risk data. Please wait..."
    :class="[!portfolioRiskLoaded ? 'vh100': '']"
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)"   
  >
    <form
      @submit.prevent="validateThenSave"
      class="portfolio-risk-form mx-auto"
      :class="{
        _disabled: loading,
      }"
      accept-charset="UTF-8"
    >
      <div class="form-group mb-1">
        <div class="mt-2 mx-4 d-flex align-items-center">
          <div>
            <h5 class="mb-0">
               <span style="font-size: 16px; margin-right: 2.5px"
              > <i class="fas fa-suitcase mb-1"></i>
              </span>
               <router-link v-if="DV_risk"  :to="
                `/portfolio`
              ">{{
                  DV_risk.facility_name
            }}            
            </router-link>
              <el-icon
                class="el-icon-arrow-right"
                style="font-size: 12px"
              ></el-icon>
               <router-link
              :to="
                `/portfolio`
              "
              >Risks</router-link
            >
              <el-icon
                class="el-icon-arrow-right"
                style="font-size: 12px"
              ></el-icon>
              <span v-if="portfolioRiskLoaded && DV_risk.text">{{ DV_risk.text }}</span>
              <span v-else>...</span>
            </h5>
          </div>
          <div class="ml-auto d-flex" v-if="_isallowed('read')">
            <button
              v-if="_isallowed('write')"
              class="btn btn-sm sticky-btn btn-primary text-nowrap mr-2"
              data-cy="risk_save_btn"
            >
              Save Risk
            </button>
            <button
              v-else
              disabled
              class="btn btn-sm sticky-btn btn-primary mr-2"
              data-cy="risk_read_only_btn"
            >
              Read Only
            </button>
            <button
              class="btn btn-sm sticky-btn btn-outline-secondary"
              @click.prevent="cancelRiskSave"
              data-cy="risk_close_btn"
            >
              Close
            </button>
          </div>
        </div>
        <hr class="mx-4 mb-6 mt-2" />
        <div
          v-if="_isallowed('read')"
          class="d-flex form-group pt-1 mb-1 justify-content-start"
        >
          <FormTabs
            class="ml-4"
            :current-tab="currentTab"
            :tabs="tabs"
            :allErrors="errors"
            @on-change-tab="onChangeTab"
          />
        </div>
        <h6 class="mx-4 mt-4 mb-0" style="color: gray; font-size: 13px">
          <span style="color: #dc3545; font-size: 15px">*</span> Indicates
          required fields
        </h6>

        <div class="fixed-form">
          <div class="mx-0">
            <div v-if="errors.items.length > 0" class="text-danger mx-4">
              Please fill the required fields before submitting
              <ul class="error-list mx-4">
                <li
                  v-for="(error, index) in errors.all()"
                  :key="index"
                  v-tooltip="{
                    content: `${errorLocation(error)}`,
                    placement: 'left',
                  }"
                >
                  {{ error }}
                </li>
              </ul>
            </div>

            <div v-show="currentTab == 'risk'" class="paperLookTab">
              <!-- RISK OVERVIEW TAB -->
              <div class="form-group mx-4">
                <label class="font-md mt-3"
                  >Risk Name <span style="color: #dc3545">*</span></label
                >

           <div class="toggleWrapper float-right" id="risk_toggles" :class="{'font-sm': isMapView}">
               
              <span class="statesCol p-1 mr-1">           
            <span
              class="watch_action clickable mx-2"
              @click.prevent.stop="toggleOngoing"
              data-cy="task_ongoing"
              v-tooltip="`Ongoing`" 
            >
              <span              
                v-show="DV_risk.ongoing">
              <i class="fas fa-retweet text-success"></i>
              </span>
              <span              
                v-show="!DV_risk.ongoing">
              <i class="fas fa-retweet" style="color:lightgray;cursor:pointer"></i>
              </span>             
              <small 
                :class="{'d-none': isMapView }"
                style="vertical-align:text-top"> 
                Ongoing
              </small>
            </span>

            <span
              class="watch_action clickable mx-2"
              @click.prevent.stop="toggleOnhold"
              data-cy="task_on_hold"
               v-tooltip="`On Hold`" 
            >
              <span                
                v-show="DV_risk.on_hold">
                <i class="fas fa-pause-circle mr-1 text-primary"></i>
              
              </span>
              <span
                v-show="!DV_risk.on_hold">
              <i class="fas fa-pause-circle mr-1" style="color:lightgray;cursor:pointer"></i>              
              </span>
             
              <small 
                :class="{'d-none': isMapView }"
                style="vertical-align:text-top"> 
                On Hold
              </small>
            </span>
           
          
            <span
              class="watch_action clickable mx-2"
              @click.prevent.stop="toggleDraft"
              data-cy="task_important"
              v-tooltip="`Draft`" 
            >
              <span               
                 v-show="DV_risk.draft">
               <i class="fas fa-pencil-alt text-warning"></i>
              </span>
              <span               
                v-show="!DV_risk.draft">
               <i class="fas fa-pencil-alt" style="color:lightgray;cursor:pointer"></i>
              </span>
             
              <small 
                :class="{'d-none': isMapView }"
                style="vertical-align:text-top"> 
                Draft
              </small>
            </span>



              </span>


              <span class="tagsCol p-1">

              <span
                class="watch_action clickable mx-2"
                v-tooltip="`On Watch`" 
                @click.prevent.stop="toggleWatched"
                data-cy="task_on_watch"
              >
                <span                
                  v-show="DV_risk.watched" 
                  ><i class="fas fa-eye mr-1"></i
                ></span>
                <span 
                  v-show="!DV_risk.watched" 
                  ><i  class="fas fa-eye mr-1" style="color:lightgray;cursor:pointer"></i
                ></span>           
                <small 
                  style="vertical-align:text-top" 
                  :class="{'d-none': isMapView }"
                > 
                  On Watch
                </small>
              </span>
              <span
              class="watch_action clickable mx-2"
              @click.prevent.stop="toggleImportant"
              data-cy="task_important"
              v-tooltip="`Important`" 
            >
              <span 
                v-show="DV_risk.important">
               <i class="fas fa-star text-warning"></i>
              </span>
              <span 
                v-show="!DV_risk.important">
               <i class="far fa-star" style="color:lightgray;cursor:pointer"></i>
              </span>             
              <small 
               :class="{'d-none': isMapView }"
                style="vertical-align:text-top"> 
                Important
              </small>
              </span>
              <span
                class="watch_action clickable mx-2"
                @click.prevent.stop="toggleReportable"
                data-cy="task_reportable"
                v-tooltip="`Briefings`" 
              >
                <span               
                  v-show="DV_risk.reportable">
                <i class="fas fa-presentation text-primary"></i>
                </span>
                <span 
                v-show="!DV_risk.reportable">
                <i class="fas fa-presentation" style="color:lightgray;cursor:pointer"></i>
                </span>
              
                <small 
                  :class="{'d-none': isMapView }"
                  style="vertical-align:text-top"> 
                Briefings
                </small>
              </span>                
              </span>

              </div>


                <el-input
                  v-validate="'required'"
                  placeholder="Risk Name"
                  v-model="DV_risk.text"
                  :readonly="!_isallowed('write')"
                  data-cy="risk_name"
                  name="Risk Name"
                  class ="inner-name-lowercase"
                  :class="{
                    error: errors.has('Risk Name'),
                  }"
                />
                <div
                  v-show="errors.has('Risk Name')"
                  class="text-danger"
                  data-cy="risk_name_error"
                >
                  {{ errors.first("Risk Name") }}
                </div>
              </div>

              <div class="form-group mx-4">
                <label class="font-md"
                  >Risk Description <span style="color: #dc3545">*</span></label
                >
                <el-input
                  v-validate="'required'"
                  type="textarea"
                  placeholder="Risk brief description"
                  v-model="DV_risk.risk_description"
                  rows="3"
                  :readonly="!_isallowed('write')"
                  data-cy="risk_description"
                  name="Risk Description"
                  :class="{
                    error: errors.has('Risk Description'),
                  }"
                />
                <div
                  v-show="errors.has('Risk Description')"
                  class="text-danger"
                  data-cy="risk_description_error"
                >
                  {{ errors.first("Risk Description") }}
                </div>
              </div>

              <div class="d-flex mb-1 form-group">
                <div class="simple-select form-group w-33 ml-4">
                  <label class="font-md"
                    >Process Area <span style="color: #dc3545">*</span></label
                  >
                  <el-select
                    v-model="selectedTaskType"
                    v-validate="'required'"
                    class="w-100"
                    track-by="id"
                    value-key="id"
                    :disabled="!_isallowed('write')"
                    data-cy="task_type"
                    name="Process Area"
                    :class="{ 'error': errors.has('Process Area') }"
                    placeholder="Select Process Area"
                  >
                    <el-option
                      v-for="item in taskTypes"
                      :value="item"
                      :key="item.id"
                      :label="item.name"
                    >
                    </el-option>
                  </el-select>

                  <div
                    v-show="errors.has('Process Area')"
                    class="text-danger"
                    data-cy="risk_milestone_error"
                  >
                    {{ errors.first("Process Area") }}
                  </div>
                </div>
              </div>

              <div class="mx-4 mt-2 mb-4" v-if="selectedRiskStage !== null">
                <div v-if="selectedRiskStage !== undefined">       
                  <div style="position:relative"><label class="font-md mb-0">Stage</label>               
                    <button v-if="_isallowed('write')" @click.prevent="clearStages" :disabled="fixedStage" class="btn btn-sm d-inline-block btn-danger font-sm float-right clearStageBtn">Clear Stages</button>  
                  </div>    
                <el-steps 
                  v-if="riskStagesSorted && riskStagesSorted.length >= 0"
                  class="exampleOne mt-3" 
                  :class="{'overSixSteps': riskStagesSorted.length >= 6 }" 
                  :active="riskStagesSorted.findIndex(stage => stage.id == selectedRiskStage.id)"                                  
                  finish-status="success"  
                  :disabled="!_isallowed('write') || fixedStage && isKanbanView"
                  v-model="selectedRiskStage"
                  track-by="id" 
                  value-key="id"
                  >         
                <el-step
                  v-for="item in riskStagesSorted"
                  :key="item.id"                        
                  :value="item"
                  style="cursor:pointer"
                  @click.native="selectedStage(item)"        
                  :title="item.name"   
                  description=""                    
                ></el-step>          
                  </el-steps>          
              </div>
              </div>

              <div
                class="mx-4 mt-2 mb-4"
                v-if="
                  selectedRiskStage == null || selectedRiskStage == undefined
                "
              >
                <label class="font-md">Select Stage</label>
                <el-steps
                  class="exampleOne"
                   v-if="riskStagesSorted && riskStagesSorted.length >= 0"
                  :class="{ overSixSteps: riskStagesSorted.length >= 6 }"
                  finish-status="success"
                  :disabled="
                    !_isallowed('write') || (fixedStage && isKanbanView)
                  "
                  v-model="selectedRiskStage"
                  track-by="id"
                  value-key="id"
                >
                  <el-step
                    v-for="item in riskStagesSorted"
                    :key="item.id"
                    :value="item"
                    style="cursor:pointer"
                    @click.native="selectedStage(item)"
                    :title="item.name"
                    description=""
                  ></el-step>
                </el-steps>
              </div>

              <div class="form-row mx-4">
                <div class="form-group col-md-6 pl-0">
                  <label class="font-md"
                    >Date Identified
                    <span v-show="!DV_risk.ongoing" style="color: #dc3545">*</span></label
                  >
                  <v2-date-picker
                    v-validate="{ required: !DV_risk.ongoing }"
                    v-model="DV_risk.start_date"
                    value-type="YYYY-MM-DD"
                    format="DD MMM YYYY"
                    placeholder="DD MM YYYY"
                    name="Date Identified"
                    class="w-100 vue2-datepicker"
                    :class="{ 'error': errors.has('Date Identified') }"
                    :disabled="!_isallowed('write')"
                    data-cy="risk_start_date"
                  />
                  <div
                    v-show="errors.has('Date Identified')"
                    class="text-danger"
                    data-cy="risk_start_date_error"
                  >
                    {{ errors.first(" Date Identified") }}
                  </div>
                </div>

                <div class="form-group col-md-6 pr-0">
                <span v-if="DV_risk.ongoing">           
                <label class="font-md"><i class="fas fa-retweet text-success mr-1"></i>
                 Date Closed
                 </label
                  ></span>
                <span v-if="DV_risk.on_hold">           
                <label class="font-md">
                Risk Approach Due Date <span><small class="text-danger">(Not required if Risk is On Hold)</small></span>
                 </label
                  ></span>
                  <span v-if="!DV_risk.ongoing && !DV_risk.on_hold">           
                  <label class="font-md"
                    >Risk Approach Due Date
                    <span style="color: #dc3545">*</span></label
                  ></span>
                  <v2-date-picker
                    v-validate="{ required: !DV_risk.ongoing && !DV_risk.on_hold }"
                    v-model="DV_risk.due_date"
                    value-type="YYYY-MM-DD"
                    format="DD MMM YYYY"
                    placeholder="DD MM YYYY"
                    name="Risk Approach Due Date"
                    class="w-100 vue2-datepicker"
                    :class="{
                      'error': errors.has('Risk Approach Due Date'),
                    }"
                    :disabled="
                      !_isallowed('write') ||
                        DV_risk.start_date === '' ||
                        DV_risk.start_date === null
                    "
                    :disabled-date="disabledDueDate"
                    data-cy="risk_due_date"
                  />
                  <div
                    v-show="errors.has('Risk Approach Due Date')"
                    class="text-danger"
                    data-cy="risk_due_date_error"
                  >
                    {{ errors.first("Risk Approach Due Date") }}
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!-- END RISK IDENTIFY TAB SECTION -->

          <!-- BEGIN ASSIGN Tab 2 -->
          <div v-show="currentTab == 'tab2'" class="paperLookTab tab2">
            <div class="form-group mb-0 pt-3 d-flex w-100">
              <div class="form-group user-select ml-4 mr-1 w-100">
                <!-- 'Responsible' field was formally known as 'Assign Users' field -->
                <label class="font-md mb-0">Responsible</label>

                <el-select
                  v-model="responsibleUsers"
                  class="w-100"
                  track-by="id"
                  clearable
                  filterable
                  value-key="id"
                  placeholder="Search and select Responsible User"
                  :disabled="!_isallowed('write')"
                  data-cy="risk_owner"
                >
                  <el-option
                    v-for="item in activeProjectUsers"
                    :value="item"
                    :key="item.id"
                    :label="item.name"
                  >
                  </el-option>
                </el-select>
              </div>
              <div class="form-group user-select ml-1 mr-4 w-100">
                <label class="font-md mb-0">Accountable</label>

                <el-select
                  v-model="accountableRiskUsers"
                  class="w-100"
                  track-by="id"
                  clearable
                  value-key="id"
                  placeholder="Search and select Accountable User"
                  :disabled="!_isallowed('write')"
                  filterable
                >
                  <el-option
                    v-for="item in activeProjectUsers"
                    :value="item"
                    :key="item.id"
                    :label="item.name"
                  >
                  </el-option>
                </el-select>
              </div>
            </div>

            <div class="form-group mt-0 d-flex w-100">
              <div class="form-group user-select ml-4 mr-1 w-100">
                <label class="font-md mb-0">Consulted</label>
                <el-select
                  v-model="consultedRiskUsers"
                  class="w-100"
                  track-by="id"
                  value-key="id"
                  :multiple="true"
                  placeholder="Search and select Consulted Users"
                  :disabled="!_isallowed('write')"
                  filterable
                >
                  <el-option
                    v-for="item in activeProjectUsers"
                    :value="item"
                    :key="item.id"
                    :label="item.name"
                  >
                  </el-option>
                </el-select>
              </div>
              <div class="form-group user-select ml-1 mr-4 w-100">
                <label class="font-md mb-0">Informed</label>
                <el-select
                  v-model="informedRiskUsers"
                  class="w-100"
                  track-by="id"
                  value-key="id"
                  multiple
                  filterable
                  placeholder="Search and select Informed Users"
                  :disabled="!_isallowed('write')"
                >
                  <el-option
                    v-for="item in activeProjectUsers"
                    :value="item"
                    :key="item.id"
                    :label="item.name"
                  >
                  </el-option>
                </el-select>
              </div>
            </div>
          </div>

          <!-- END ASSIGN Tab 2-->

          <!-- BEGIN RISK PRIORITIZE TAB -->

          <div v-show="currentTab == 'tab3'" class="paperLookTab">
            <div class="container-fluid pt-2 px-4">
              <div class="row mb-0">
                <div class="col-md-3 simple-select form-group">
                  <label class="font-md">Priority Level:</label>
                  <div class="risk-priorityLevel text-center">
                    <span class="risk-pL px-2 pt-2 mb-0 pb-0 mx-0">
                      {{ calculatePriorityLevel }}</span
                    >
                    <br />
                    <span
                      v-if="
                       this.selectedRiskImpactLevel &&  
                        this.selectedRiskPossibility.id *
                          this.selectedRiskImpactLevel.id ==
                          1
                      "
                      class="gray2"
                      >Very Low</span
                    >
                    <span
                      v-if="
                       this.selectedRiskImpactLevel &&  
                        this.selectedRiskPossibility.id *
                          this.selectedRiskImpactLevel.id ==
                          2
                      "
                      class="green1"
                      >Low</span
                    >
                    <span
                      v-if="
                       this.selectedRiskImpactLevel &&  
                        this.selectedRiskPossibility.id *
                          this.selectedRiskImpactLevel.id ==
                          3
                      "
                      class="green1"
                      >Low</span
                    >
                    <span
                      v-if="
                       this.selectedRiskImpactLevel &&  
                        this.selectedRiskPossibility.id *
                          this.selectedRiskImpactLevel.id ==
                          4
                      "
                      class="yellow1"
                      >Moderate
                    </span>
                    <span
                      v-if="
                       this.selectedRiskImpactLevel &&  
                        this.selectedRiskPossibility.id *
                          this.selectedRiskImpactLevel.id ==
                          5
                      "
                      class="yellow1"
                      >Moderate
                    </span>
                    <span
                      v-if="
                       this.selectedRiskImpactLevel &&  
                        this.selectedRiskPossibility.id *
                          this.selectedRiskImpactLevel.id ==
                          6
                      "
                      class="yellow1"
                      >Moderate
                    </span>
                    <span
                      v-if="
                       this.selectedRiskImpactLevel &&  
                        this.selectedRiskPossibility.id *
                          this.selectedRiskImpactLevel.id ==
                          8
                      "
                      class="orange1"
                      >High
                    </span>
                    <span
                      v-if="
                       this.selectedRiskImpactLevel &&  
                        this.selectedRiskPossibility.id *
                          this.selectedRiskImpactLevel.id ==
                          9
                      "
                      class="orange1"
                      >High
                    </span>
                    <span
                      v-if="
                       this.selectedRiskImpactLevel &&  
                        this.selectedRiskPossibility.id *
                          this.selectedRiskImpactLevel.id ==
                          10
                      "
                      class="orange1"
                      >High
                    </span>
                    <span
                      v-if="
                       this.selectedRiskImpactLevel &&  
                        this.selectedRiskPossibility.id *
                          this.selectedRiskImpactLevel.id ==
                          12
                      "
                      class="orange1"
                      >High
                    </span>
                    <span
                      v-if="
                       this.selectedRiskImpactLevel &&  
                        this.selectedRiskPossibility.id *
                          this.selectedRiskImpactLevel.id >=
                          15
                      "
                      class="red1"
                      >Extreme
                    </span>
                  </div>
                  <p class="font-sm mt-2">
                    <b>HINT:</b> Update Probability and/or Impact Level to
                    change Priority Level.
                  </p>
                </div>

                <div class="col-md-3 p-0">
                  <div class="simple-select form-group mb-4">
                    <label class="font-md">Probability</label>
                    <el-select
                      v-model="selectedRiskPossibility"
                      class="w-100"
                      track-by="value"
                      value-key="id"
                      placeholder="Risk Probablity"
                      :disabled="!_isallowed('write')"
                      :class="{ error: errors.has('Risk Probability') }"
                      data-cy="risk_probability"
                    >
                      <el-option
                        v-for="item in getRiskProbabilityNames"
                        :value="item"
                        :key="item.id"
                        :label="item.name"
                      >
                      </el-option>
                    </el-select>

                    <div
                      v-show="errors.has('Risk Probability')"
                      class="text-danger"
                      data-cy="risk_probability_error"
                    >
                      {{ errors.first("Risk Probability") }}
                    </div>
                  </div>

                  <!-- COLUMN ROW 2 -->
                  <div class="simple-select form-group">
                    <label class="font-md mb-0">Impact Level</label>
                    <el-select
                      v-model="selectedRiskImpactLevel"
                      class="w-100"
                      track-by="value"
                      value-key="id"
                      placeholder="Impact Level"
                      :disabled="!_isallowed('write')"
                      :class="{ error: errors.has('Impact Level') }"
                      data-cy="impact_level"
                    >
                      <el-option
                        v-for="item in getRiskImpactLevelNames"
                        :value="item"
                        :key="item.id"
                        :label="item.name"
                      >
                      </el-option>
                    </el-select>

                    <div
                      v-show="errors.has('Impact Level')"
                      class="text-danger"
                      data-cy="impact_level_error"
                    >
                      {{ errors.first("Impact Level") }}
                    </div>
                  </div>

                  <!-- COLUMN FOR TEXT FIELD            -->
                </div>

                <div class="col-md-6 pl-1 pr-3">
                  <div class="form-group mx-1 mb-0">
                    <label class="font-md">Probability Description </label>
                    <el-input
                      type="textarea"
                      placeholder="Risk Probability description"
                      v-model="DV_risk.probabilityDescription"
                      rows="3"
                      :readonly="!_isallowed('write')"
                      data-cy="probability_description"
                      name="Probability Description"
                      :class="{
                        error: errors.has('Probability Description'),
                      }"
                    />
                    <div
                      v-show="errors.has('Probability Description')"
                      class="text-danger"
                      data-cy="probability_description_error"
                    >
                      {{ errors.first("Probability Description") }}
                    </div>
                  </div>
                  <div class="form-group mx-1">
                    <label class="font-md mb-0">Impact Description </label>
                    <el-input
                      type="textarea"
                      placeholder="Risk impact description"
                      v-model="DV_risk.impact_description"
                      rows="3"
                      :readonly="!_isallowed('write')"
                      data-cy="impact_description"
                      name="Impact Description"
                      :class="{
                        error: errors.has('Impact Description'),
                      }"
                    />
                    <div
                      v-show="errors.has('Impact Description')"
                      class="text-danger"
                      data-cy="impact_description_error"
                    >
                      {{ errors.first("Impact Description") }}
                    </div>
                  </div>
                </div>
                <!-- ROW ENDS -->
              </div>

              <!-- CONTAINER ENDS -->
            </div>

            <div class="container mx-2 my-0 justify-content-center text-center">
              <el-collapse accordion class="risk_matrix">
                <el-collapse-item
                  title="Click to see Priority Level Risk Matrix"
                  name="1"
                >
                  <div>
                    <!-- Risk Matrix begins here -->
                    <div class="container my-2 px-2">
                      <!-- This first row is not a true row...Just a transformed vertical div header -->
                      <div class="row">
                        <div style="position: relative">
                          <div class="vertical-head risk-matrix-header">
                            <h6>PROBABILITY</h6>
                          </div>
                        </div>
                        <div class="col">
                          <div class="row">
                            <div class="col">
                              <h4 class="mb-3">
                                Risk Matrix for:
                                <span id="riskName">{{ DV_risk.text }}</span>
                              </h4>
                            </div>
                            <!-- <div class="col text-right"><h4 class="mb-3">Risk Priority Level: <span id="riskName">{{DV_risk.priorityLevel}}</span></h4>
                    </div> -->
                          </div>

                          <div class="row">
                            <div class="col text-center">
                              <h6 class="mb-1">IMPACT</h6>
                            </div>
                          </div>
                          <!-- Risk Matrix first row, Category headers -->

                          <div class="container mb-2 mt-0 risk-matrix">
                            <div class="row">
                              <div class="col-md-2 p-2 gray text-center"></div>
                              <div
                                class="col-md-2 gray p-2 text-center text-truncate"
                              >
                                Negligible <br />1
                              </div>
                              <div
                                class="col-md-2 gray p-2 text-center text-truncate"
                              >
                                Minor <br />2
                              </div>
                              <div
                                class="col-md-2 gray p-2 text-center text-truncate"
                              >
                                Moderate<br />
                                3
                              </div>
                              <div
                                class="col-md-2 gray p-2 text-center text-truncate"
                              >
                                Major<br />
                                4
                              </div>
                              <div
                                class="col-md-2 gray p-2 text-center text-truncate"
                              >
                                Catastrophic<br />
                                5
                              </div>
                            </div>

                            <!-- Risk Matrix 2nd row (first color row) -->
                            <div class="row">
                              <div
                                class="col-md-2 gray p-2 text-center text-truncate"
                              >
                                Almost<br />Certain<br />
                                5
                              </div>
                              <div
                                class="col-md-2 yellow p-2 text-center"
                                :class="[matrix15 == true ? 'reg-opacity' : '']"
                              >
                                Moderate<br />
                                5
                              </div>
                              <div
                                class="col-md-2 orange p-2 text-center"
                                :class="[matrix25 == true ? 'reg-opacity' : '']"
                              >
                                High<br />
                                10
                              </div>
                              <div
                                class="col-md-2 red p-2 text-center"
                                :class="[matrix35 == true ? 'reg-opacity' : '']"
                              >
                                Extreme <br />15
                              </div>
                              <div
                                class="col-md-2 red p-2 text-center"
                                :class="[matrix45 == true ? 'reg-opacity' : '']"
                              >
                                Extreme<br />
                                20
                              </div>
                              <div
                                class="col-md-2 red p-2 text-center"
                                :class="[matrix55 == true ? 'reg-opacity' : '']"
                              >
                                Extreme<br />
                                25
                              </div>
                            </div>

                            <!-- Risk Matrix 3rd row -->
                            <div class="row">
                              <div
                                class="col-md-2 gray p-2 text-center text-truncate"
                              >
                                Likely<br />
                                4
                              </div>
                              <div
                                class="col-md-2 yellow p-2 text-center"
                                :class="[matrix14 == true ? 'reg-opacity' : '']"
                              >
                                Moderate<br />
                                4
                              </div>
                              <div
                                class="col-md-2 orange p-2 text-center"
                                :class="[matrix24 == true ? 'reg-opacity' : '']"
                              >
                                High<br />
                                8
                              </div>
                              <div
                                class="col-md-2 orange p-2 text-center"
                                :class="[matrix34 == true ? 'reg-opacity' : '']"
                              >
                                High<br />
                                12
                              </div>
                              <div
                                class="col-md-2 red p-2 text-center"
                                :class="[matrix44 == true ? 'reg-opacity' : '']"
                              >
                                Extreme<br />
                                16
                              </div>
                              <div
                                class="col-md-2 red p-2 text-center"
                                :class="[matrix54 == true ? 'reg-opacity' : '']"
                              >
                                Extreme<br />
                                20
                              </div>
                            </div>

                            <!-- Risk Matrix 4th row -->
                            <div class="row">
                              <div
                                class="col-md-2 gray p-2 text-center text-truncate"
                              >
                                Possible<br />
                                3
                              </div>
                              <div
                                class="col-md-2 green p-2 text-center"
                                :class="[matrix13 == true ? 'reg-opacity' : '']"
                              >
                                Low<br />
                                3
                              </div>
                              <div
                                class="col-md-2 yellow p-2 text-center"
                                :class="[matrix23 == true ? 'reg-opacity' : '']"
                              >
                                Moderate<br />
                                6
                              </div>
                              <div
                                class="col-md-2 orange p-2 text-center"
                                :class="[matrix33 == true ? 'reg-opacity' : '']"
                              >
                                High<br />
                                9
                              </div>
                              <div
                                class="col-md-2 orange p-2 text-center"
                                :class="[matrix43 == true ? 'reg-opacity' : '']"
                              >
                                High<br />
                                12
                              </div>
                              <div
                                class="col-md-2 red p-2 text-center"
                                :class="[matrix53 == true ? 'reg-opacity' : '']"
                              >
                                Extreme<br />
                                15
                              </div>
                            </div>

                            <!-- Risk Matrix 5th row -->
                            <div class="row">
                              <div
                                class="col-md-2 gray p-2 text-center text-truncate"
                              >
                                Unlikely<br />
                                2
                              </div>
                              <div
                                class="col-md-2 green p-2 text-center"
                                :class="[matrix12 == true ? 'reg-opacity' : '']"
                              >
                                Low<br />
                                2
                              </div>
                              <div
                                class="col-md-2 yellow p-2 text-center"
                                :class="[matrix22 == true ? 'reg-opacity' : '']"
                              >
                                Moderate<br />
                                4
                              </div>
                              <div
                                class="col-md-2 yellow p-2 text-center"
                                :class="[matrix32 == true ? 'reg-opacity' : '']"
                              >
                                Moderate<br />
                                6
                              </div>
                              <div
                                class="col-md-2 orange p-2 text-center"
                                :class="[matrix42 == true ? 'reg-opacity' : '']"
                              >
                                High<br />
                                8
                              </div>
                              <div
                                class="col-md-2 orange p-2 text-center"
                                :class="[matrix52 == true ? 'reg-opacity' : '']"
                              >
                                High<br />
                                10
                              </div>
                            </div>

                            <!-- Risk Matrix 6th row (last row) -->
                            <div class="row">
                              <div
                                class="col-md-2 gray p-2 text-center text-truncate"
                              >
                                Rare<br />
                                1
                              </div>
                              <div
                                class="col-md-2 gray3 p-2 text-center"
                                :class="[matrix11 == true ? 'reg-opacity' : '']"
                              >
                                Very Low<br />
                                1
                              </div>
                              <div
                                class="col-md-2 green p-2 text-center"
                                :class="[matrix21 == true ? 'reg-opacity' : '']"
                              >
                                Low<br />
                                2
                              </div>
                              <div
                                class="col-md-2 green p-2 text-center"
                                :class="[matrix31 == true ? 'reg-opacity' : '']"
                              >
                                Low<br />
                                3
                              </div>
                              <div
                                class="col-md-2 yellow p-2 text-center"
                                :class="[matrix41 == true ? 'reg-opacity' : '']"
                              >
                                Moderate<br />
                                4
                              </div>
                              <div
                                class="col-md-2 yellow p-2 text-center"
                                :class="[matrix51 == true ? 'reg-opacity' : '']"
                              >
                                Moderate<br />
                                5
                              </div>
                            </div>
                          </div>
                        </div>

                        <!-- Risk Matrix Container ends at this top div  -->
                      </div>
                    </div>
                  </div>
                </el-collapse-item>
              </el-collapse>
            </div>

            <div class="row form-group mx-4 mb-0">
              <div class="col-md-12 px-0 simple-select form-group">
                <label class="font-md"
                  >Risk Approach <span style="color: #dc3545">*</span></label
                >
                <el-select
                  v-model="DV_risk.risk_approach"
                  class="w-100 upperCase"
                  track-by="name"
                  v-validate="'required'"
                  placeholder="Risk Approach"
                  :disabled="!_isallowed('write')"
                  :class="{ error: errors.has('Risk Approach') }"
                  data-cy="risk_approach"
                >
                  <el-option
                    v-for="item in riskApproaches"
                    :value="item"
                    :key="item.id"
                    class="upperCase"
                    :label="item"
                  >
                  </el-option>
                </el-select>
                <div
                  v-show="errors.has('Risk Approach')"
                  class="text-danger"
                  data-cy="risk_approach_error"
                >
                  {{ errors.first("Risk Approach") }}
                </div>
              </div>
            </div>

            <div class="row form-group mx-4 mb-0">
              <div class="col-md-12 px-0 simple-select form-group">
                <label class="font-md">Risk Approach Description </label>
                <el-input
                  type="textarea"
                  placeholder="Describe how the Risk will be controlled"
                  v-model="DV_risk.risk_approach_description"
                  rows="2"
                  :readonly="!_isallowed('write')"
                  data-cy="approach_description"
                  name="Risk Approach Description"
                  :class="{
                    error: errors.has('Risk Approach Description'),
                  }"
                />
                <div
                  v-show="errors.has('Risk Approach Description')"
                  class="text-danger"
                  data-cy="approach_description_error"
                >
                  {{ errors.first("Risk Approach Description") }}
                </div>
              </div>
            </div>

            <div class="row mx-4 mb-0">
              <div class="col-md-12 font-md pt-3 pl-0">
                Risk Approach Approval
              </div>
            </div>

            <div
              class="row form-group pl-2 mx-4 mb-0 w-80"
              style="background-color: #fafafa; border: solid 1px #ededed"
            >
              <div class="col-md-3 pl-1 py-2 mb-0">
                <label class="font-sm mb-0">Risk Approach</label>
                <span
                  class="d-block approver-pointer"
                  @click.prevent="toggleApproved"
                >
                  <span
                    v-show="DV_risk.approved"
                    class="check_box mx-1 approver-pointer"
                    ><i class="far fa-check-square"></i
                  ></span>
                  <span
                    v-show="!DV_risk.approved"
                    class="empty_box mx-1 approver-pointer"
                    ><i class="far fa-square"></i
                  ></span>
                  <small style="vertical-align: text-top">Approved</small>
                </span>
              </div>
              <div
                v-show="DV_risk.approved"
                class="col-md-7 pr-2 py-2 mb-0 simple-select form-group ml-0"
              >
                <label class="font-sm mb-0"
                  >Date/Time Risk Approach Approved:</label
                >
                <input
                  class="form-control"
                  v-model="DV_risk.approval_time"
                  rows="1"
                  :readonly="!_isallowed('write')"
                  data-cy="approach_description"
                  name="Approval Time"
                  disabled
                />
              </div>
            </div>
          </div>
          <!-- END RISK PRIORITIZE TAB SECTION -->

          <!-- BEGIN RISK CONTROL TAB SECTION -->
          <div v-show="currentTab == 'tab4'" class="paperLookTab">
            <div v-show="!DV_risk.ongoing"  class="form-group pt-2 mb-3 ml-4 mr-5">
              <label class="font-md mb-0 mr-3">Progress (in %)</label>
              <span class="ml-3">
                <label class="font-md mb-0 d-inline-flex align-items-center">
                  <input
                    type="checkbox"
                    v-model="DV_risk.auto_calculate"
                    :disabled="!_isallowed('write')"
                    :readonly="!_isallowed('write')"
                  />
                  <span>&nbsp;&nbsp;Auto Calculate Progress</span>
                </label>
              </span>
              <el-slider
                v-model="DV_risk.progress"
                :input="removeFromWatch()"
                :disabled="!_isallowed('write') || DV_risk.auto_calculate"
                :marks="{
                  0: '0%',
                  25: '25%',
                  50: '50%',
                  75: '75%',
                  100: '100%',
                }"
                :format-tooltip="(value) => value + '%'"
                class="mx-2"
              ></el-slider>
            </div>

            <div class="form-group mt-2 mx-4">
              <label class="font-md">Checklists</label>
              <span
                class="ml-2 clickable"
                v-if="_isallowed('write')"
                @click.prevent="addChecks"
              >
                <i class="fas fa-plus-circle"></i>
              </span>
              <span
                class="float-right bg-dark font-sm text-light display-length px-1"
                v-if="filteredChecks.length > 1"
              >
                Displaying:
                <span class="mx-1">{{ filteredChecks.length }}</span> items
              </span>
              <span
                class="float-right bg-dark font-sm text-light display-length px-1"
                v-if="filteredChecks.length == 1"
              >
                Displaying:
                <span class="mx-1">{{ filteredChecks.length }}</span> item
              </span>
              <div v-if="filteredChecks.length > 0">
                <draggable
                  :move="handleMove"
                  @change="(e) => handleEnd(e, DV_risk.checklists)"
                  :list="DV_risk.checklists"
                  :animation="100"
                  ghost-class="ghost-card"
                  class="drag"
                >
                  <div
                    v-for="(check, index) in DV_risk.checklists"
                    class="d-flex w-100 mb-3 drag-item"
                    v-if="!check._destroy && isMyCheck(check)"
                    :key="index"
                  >
                    <div
                      class="form-control h-100 check-items pb-0"
                      style="background-color: #fafafa; position: relative"
                    >
                      <div class="row" style="width: 97%">
                        <div class="col-8 justify-content-start">
                          <input
                            type="checkbox"
                            name="check"
                            :checked="check.checked"
                            @change="updateCheckItem($event, 'check', index)"
                            :key="`check_${index}`"
                            :disabled="
                              !_isallowed('write') || !check.text.trim()
                            "
                          />
                          <input
                            :value="check.text"
                            name="text"
                            @input="updateCheckItem($event, 'text', index)"
                            :key="`text_${index}`"
                            placeholder="Checkpoint name here"
                            type="text"
                            class="checklist-text pl-1"
                            :readonly="!_isallowed('write')"
                          />
                        </div>
                        <div                      
                          class="col-1 pl-0 pr-0"
                        >
                          <span class="font-sm dueDate">Due Date:</span>
                        </div>
                        <div                        
                          class="col-3 pl-0"
                          style="margin-left: -25px"
                        >
                          <v2-date-picker
                            v-model="check.due_date"
                            :value="check.due_date"
                            :disabled="!_isallowed('write') || !check.text"
                            @selected="
                              updateCheckItem($event, 'due_date', index)
                            "
                            :key="`dueDate_${index}`"
                            value-type="YYYY-MM-DD"
                            format="DD MMM YYYY"
                            placeholder="DD MM YYYY"
                            name="due_date"
                            class="w-100 vue2-datepicker d-flex ml-auto"
                            :disabled-date="disabledDateRange"
                            :class="{ disabled: disabledDateRange }"
                          />
                        </div>
                      </div>

                      <!-- Collpase section begins here -->
                      <el-collapse
                        id="roll_up"
                        style="background-color: #fafafa"
                      >
                        <el-collapse-item
                          title="Details"
                          name="1"
                          style="background-color: #fafafa"
                        >
                          <div
                            v-if="isMapView"
                            class="row justify-content-end pt-2 pb-5"
                            style="
                              background-color: #fafafa;
                              position: relative;
                            "
                          >
                            <div
                              class="d-flex col mb-0"
                              style="position: absolute"
                            >
                              Due Date:
                              <v2-date-picker
                                v-model="check.due_date"
                                :value="check.due_date"
                                :disabled="!_isallowed('write') || !check.text"
                                @selected="
                                  updateCheckItem($event, 'due_date', index)
                                "
                                :key="`due_date_${index}`"
                                value-type="YYYY-MM-DD"
                                format="DD MMM YYYY"
                                placeholder="DD MM YYYY"
                                name="due_date"
                                class="w-100 vue2-datepicker d-flex ml-auto"
                                :disabled-date="disabledDateRange"
                                :class="{ disabled: disabledDateRange }"
                              />
                            </div>
                          </div>
                          <div
                            class="row justify-content-end pt-2"
                            style="background-color: #fafafa; position: inherit"
                          >
                            <div
                              class="simple-select d-flex form-group col mb-0"
                              style="position: absolute"
                            >
                              <div
                                class="d-flex w-100"
                                style="padding-left: 6.1rem"
                              >
                                <span class="font-sm pt-2 pr-2 m"
                                  >Assigned To:</span
                                >
                                <el-select
                                  v-model="check.user"
                                  class="w-75"
                                  clearable
                                  track-by="id"
                                  value-key="id"
                                  filterable
                                  :disabled="
                                    !_isallowed('write') || !check.text
                                  "
                                  placeholder="Search and select user"
                                >
                                  <el-option
                                    v-for="item in activeProjectUsers"
                                    :value="item"
                                    :key="item.id"
                                    :label="item.name"
                                  >
                                  </el-option>
                                </el-select>
                              </div>
                            </div>
                            <!-- <div class="simple-select form-group col mb-0">

              </div> -->
                          </div>

                          <!-- Start Checkbox Progress List -->
                          <!-- Create component to manage progress list -->
                          <div
                            class="pt-5 vuetify-checkitem pb-3"
                            style="background-color: #fafafa"
                          >
                          <div class="font-md pt-3">
                            Progress Update
                            <span v-if="editToggle">
                              <span class="ml-2 clickable">
                             <i class="fal fa-plus-circle mr-1 text-danger"></i>
                              </span>
                            </span>
                            <span v-else>
                              <span
                                class="ml-2 clickable"
                                v-if="_isallowed('write')"
                                @click.prevent="addProgressList(check)"
                              >
                              <i class="fas fa-plus-circle mr-1"></i>
                              </span>
                            </span>

                            <table
                              v-if="check.progress_lists.length > 0"
                              style="width: 100%"
                              class="mt-1"
                            >
                              <thead>
                                <tr>
                                  <th style="width: 50%">Progress</th>
                                  <th>Last Updated</th>
                                  <th>By</th>
                                  <th
                                    v-if="
                                      _isallowed('write') ||
                                        _isallowed('delete')
                                    "
                                  >
                                    Action
                                  </th>
                                </tr>
                              </thead>
                              <tbody>
                                <tr
                                  v-for="(progress,
                                  pindex) in check.progress_lists
                                    .slice()
                                    .reverse()"
                                  :key="pindex"
                                  v-if="!progress._destroy"
                                >
                                  <td>
                                    <span v-if="editToggle">
                                      <input
                                        :value="progress.body"
                                        name="text"
                                        :class="{
                                          'red-border': !progress.user,
                                        }"
                                        @input="
                                          updateProgressListItem(
                                            $event,
                                            'text',
                                            progress
                                          )
                                        "
                                        :key="`ptext_${pindex}`"
                                        placeholder="Type Progress update here"
                                        type="text"
                                        class="checklist-text pl-1"
                                        maxlength="80"
                                      />
                                    </span>
                                    <span v-else>
                                      {{ progress.body }}
                                    </span>
                                  </td>
                                  <td>
                                    <span v-if="!progress.user"></span>
                                    <span v-else>
                                      {{
                                        moment(progress.updated_at).format(
                                          "DD MMM YYYY, h:mm a"
                                        )
                                      }}
                                    </span>
                                  </td>
                                  <td>
                                    <span v-if="progress.user">
                                      <span> {{ progress.user.full_name }}</span>
                                    </span>
                                    <span v-else>
                                      {{ $currentUser.full_name }}
                                    </span>
                                  </td>
                                  <td
                                    v-if="
                                      _isallowed('write') ||
                                        _isallowed('delete')
                                    "
                                  >
                                    <span
                                      class="pl-2"
                                      v-tooltip="`Save`"
                                      v-if="!progress.user"
                                      @click.prevent="validateThenSave"
                                    >
                                     <i class="far fa-save text-primary clickable"></i>
                                    </span>
                                    <span
                                      v-tooltip="`Edit`"
                                      v-if="progress.user"
                                      class="px-2"
                                    >
                                       <i class="fas fa-pencil-alt text-info clickable"  
                                        @click.prevent="editProgress"
                                        :readonly="!_isallowed('write')">
                                      </i>          
                                    </span>
                                    <span
                                      v-tooltip="`Delete`"
                                      class="pl-1"
                                      v-if="progress.user"
                                    >
                                    <i class="fal fa-trash-alt text-danger clickable"
                                      v-if="_isallowed('write')"
                                      @click.prevent="
                                        destroyProgressList(
                                          check,
                                          progress,
                                          pindex
                                        )
                                      "                                 
                                    >
                                    </i>
                                    </span>
                                  </td>
                                </tr>
                              </tbody>
                            </table>
                            <div v-else class="text-danger">
                              No Checklist Progress Updates to Display
                            </div>
                            <!-- End Checkbox Progress List -->
                          </div>
                          </div>
                        </el-collapse-item>
                      </el-collapse>
                    </div>
                    <span
                      class="del-check clickable"
                      v-if="_isallowed('write')"
                      @click.prevent="destroyCheck(check, index)"
                    >
                      <i class="fas fa-times"></i>
                    </span>
                  </div>
                </draggable>
              </div>
              <p v-else class="text-danger font-sm">No checks..</p>
            </div>
          </div>

          <!-- END RISK CONTROL SECTION TAB -->

          <!-- BEGIN RISK FILES TAB SECTION -->
          <div v-show="currentTab == 'tab5'" class="paperLookTab">
            <div class="container-fluid mx-4 mt-2">
              <div class="row">
                <div class="col-5 pr-4 links-col">
                  <div v-if="_isallowed('write')" class="form-group">
                    <attachment-input
                      @input="addFile"
                      :show-label="true"
                    ></attachment-input>
                  </div>
                  <div
                    v-for="file in filteredFiles.slice().reverse()"
                    class="d-flex mb-2 w-100"
                    v-if="!file.link"
                  >
                    <div
                      class="input-group-text d-inline clickable px-1 w-100 hover"
                      :class="{ 'btn-disabled': !file.uri }"
                      @click.prevent="downloadFile(file)"
                    >
                    <span><i class="far fa-file mr-1"></i></span>
                      <input
                        readonly
                        type="text"
                        style="border:none; cursor:pointer; background-color:transparent"
                        class="w-100 mr-1 file-link"
                        :value="file.name || file.uri"
                      />
                    </div>
                    <span
                      :class="{ _disabled: loading || !_isallowed('write') }"
                      class="del-check mt-2 clickable"
                      @click.prevent="deleteFile(file)"
                    >
                      <i class="fas fa-times"></i>
                    </span>
                  </div>
                </div>
                <div class="col-6 mb-2 pl-4 links-col">
                  <div class="input-group mb-1">
                    <div v-if="_isallowed('write')" class="d-block mt-1">
                      <label class="font-lg">Add link</label>
                      <span
                        class="ml-2 clickable"
                        @click.prevent="addFilesInput"
                      >
                        <i class="fas fa-plus-circle"></i>
                      </span>
                    </div>

                    <div
                      v-for="(file,
                      index) in DV_risk.risk_files.slice().reverse()"
                      :key="index"
                      class="d-flex mb-2 w-75"
                      v-if="!file.id && file.link"
                    >
                      <div class="input-group-append">
                        <div
                          class="input-group-text clickable"
                          :class="{ 'btn-disabled': !file.uri }"
                          @click.prevent="downloadFile(file)"
                        >
                          <!-- <i class="fas fa-link"></i> -->
                        </div>
                      </div>
                      <input
                        type="text"
                        placeholder="Enter link to a site or file"
                        class="form-control form-control-sm mw-95"
                        @input="updateFileLinkItem($event, 'text', file)"
                      />
                      <div
                        :class="{ _disabled: loading || !_isallowed('write') }"
                        class="del-check clickable"
                        @click.prevent="deleteFile(file)"
                      >
                        <i class="fas fa-times"></i>
                      </div>
                    </div>
                    <div
                      v-for="(file, index) in filteredFiles.slice().reverse()"
                      :key="index"
                      class="d-flex mb-2 w-100 px-1 hover"
                      v-if="file.link && file.id"
                    >
                      <input
                        readonly
                        type="text"
                        class="form-control form-control-sm mw-95"
                        :value="file.name || file.uri"
                        v-if="!file.link"
                      />
                      <a
                        :href="file.uri"
                        target="_blank"
                        v-if="file.link"
                        class="no-text-decoration"
                      >
                        <span v-if="file.link">
                          <i class="fas fa-link mr-1"></i
                        ></span>
                        {{ urlShortener(file.uri, 68) }}
                      </a>
                      <div
                        :class="{ _disabled: loading || !_isallowed('write') }"
                        class="del-check clickable"
                        @click.prevent="deleteFile(file)"
                      >
                        <i class="fas fa-times"></i>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!-- END RISK CONTROL TAB SECTION -->

          <!-- BEGIN RISK RELATED TAB SECTION -->
          <!-- <div v-show="currentTab == 'tab6'" class="paperLookTab">
            <div class="row mx-3 mt-2">
            
              <div :class="[isMapView ? 'col-12' : 'col']">
                Related Risks
                <span
                  class="ml-2 clickable"
                  v-if="_isallowed('write')"
                  @click="openContextMenu($event, 'risk')"
                  @contextmenu.prevent=""
                >
                  <i id="risk-add-btn" class="fas fa-plus-circle"></i>
                </span>

                <hr class="mt-0" />

                <ul class="text-smaller">
                  <li
                    class="d-flex justify-content-between align-items-center my-2"
                    v-for="(risk, index) in relatedRisks"
                    :key="index"
                  >
                    <el-popover placement="right" width="200" trigger="hover">
                      <div>
                        <p class="m-0 text-left">
                          <el-tag size="mini">Project Name</el-tag>
                          {{ risk.facilityName }}
                        </p>
                      </div>
                      <router-link
                        :to="
                          `/programs/${$route.params.programId}/${tab}/projects/${risk.facilityId}/risks/${risk.id}`
                        "
                        slot="reference"
                        >{{ risk.text }}</router-link
                      ></el-popover
                    >
                    <el-button
                      size="mini"
                      icon="el-icon-delete"
                      title="Remove Related Risk"
                      @click.prevent="removeRelatedRisk(risk)"
                      :disabled="!_isallowed('delete')"
                    ></el-button>
                  </li>
                </ul>
              </div>
           
              <div :class="[isMapView ? 'col-12' : 'col']">
                Related Tasks
                <span
                  class="ml-2 clickable"
                  v-if="_isallowed('write')"
                  @click="openContextMenu($event, 'task')"
                  @contextmenu.prevent=""
                >
                  <i class="fas fa-plus-circle"></i>
                </span>

                <hr class="mt-0" />

                <ul class="text-smaller">
                  <li
                    class="d-flex justify-content-between align-items-center my-2"
                    v-for="(task, index) in relatedTasks"
                    :key="index"
                  >
                    <el-popover placement="right" width="200" trigger="hover">
                      <div>
                        <p class="m-0 text-left">
                          <el-tag size="mini">Project Name</el-tag>
                          {{ task.facilityName }}
                        </p>
                      </div>
                      <router-link
                        :to="
                          `/programs/${$route.params.programId}/${tab}/projects/${task.facilityId}/tasks/${task.id}`
                        "
                        slot="reference"
                        >{{ task.text }}</router-link
                      ></el-popover
                    >
                    <el-button
                      size="mini"
                      icon="el-icon-delete"
                      title="Remove Related Task"
                      @click.prevent="removeRelatedTask(task)"
                      :disabled="!_isallowed('delete')"
                    ></el-button>
                  </li>
                </ul>
              </div>
            
              <div :class="[isMapView ? 'col-12' : 'col']">
                Related Issues
                <span
                  class="ml-2 clickable"
                  v-if="_isallowed('write')"
                  @click="openContextMenu($event, 'issue')"
                  @contextmenu.prevent=""
                >
                  <i id="issue-add-btn" class="fas fa-plus-circle"></i>
                </span>

                <hr class="mt-0" />

                <ul class="text-smaller">
                  <li
                    class="d-flex justify-content-between align-items-center my-2"
                    v-for="(issue, index) in relatedIssues"
                    :key="index"
                  >
                    <el-popover placement="right" width="200" trigger="hover">
                      <div>
                        <p class="m-0 text-left">
                          <el-tag size="mini">Project Name</el-tag>
                          {{ issue.facilityName }}
                        </p>
                      </div>
                      <router-link
                        :to="
                          `/programs/${$route.params.programId}/${tab}/projects/${issue.facilityId}/issues/${issue.id}`
                        "
                        slot="reference"
                        >{{ issue.title }}</router-link
                      ></el-popover
                    >
                    <el-button
                      size="mini"
                      icon="el-icon-delete"
                      title="Remove Related Issue"
                      @click.prevent="removeRelatedIssue(issue)"
                      :disabled="!_isallowed('delete')"
                    ></el-button>
                  </li>
                </ul>
              </div>
            </div>
          </div> -->
          <!-- END RISK RELATED TAB SECTION -->

          <!-- BEGIN RISK DISPOSITION SECTION TAB -->
          <div
            v-show="currentTab == 'tab6'"
            style="min-height: 300px"
            class="paperLookTab"
          >
            <div class="form-group mt-3 mx-4">             
                <div class="form-group mx-4">
                <label class="font-md"
                  >Explanation</label
                >
                <el-input                
                  type="textarea"
                  placeholder="Disposition Explanation"
                  v-model="DV_risk.explanation"
                  v-if="!null"
                  rows="3"
                  :readonly="!_isallowed('write')"
                  data-cy="risk_explanation"
                 
                />              
              </div>
              <div class="d-flex mb-1 mx-4 form-group">
                <div class="simple-select form-group w-50">
                  <label class="font-md"
                    >Status</label
                  >
                  <el-select
                    v-model="selectedStatus"                                            
                    class="w-100"
                    clearable
                    track-by="name"                  
                    :disabled="!_isallowed('write')"                                 
                    placeholder="Risk Disposition Status"
                  >
                    <el-option
                      v-for="item in getRiskDispositionStatus"                 
                      :value="item"
                      :key="item.id"
                      :label="item.name"
                      class="upperCase"
                    >
                    </el-option>
                  </el-select>                  
                </div>
                  <div class="simple-select form-group w-50 ml-4">
                  <label class="font-md"
                    >Duration</label
                  >
                  <el-select
                    v-model="selectedDuration"  
                                           
                    class="w-100"
                    clearable
                    track-by="name"                  
                    :disabled="!_isallowed('write')"                                 
                    placeholder="Risk Disposition Duration"
                  >
                    <el-option
                      v-for="item in getRiskDispositionDuration"                 
                      :value="item"
                      :key="item.id"
                      :label="item.name"
                      class="upperCase"
                    >
                    </el-option>
                  </el-select>

                  
                </div>
              </div>
            </div>
          </div>
          <!-- END RISK DISPOSITION SECTION TAB -->

          <!-- BEGIN RISK UPDATES TAB SECTION -->
          <div v-show="currentTab == 'tab8'" class="paperLookTab">
            <div class="form-group mt-2 mx-4 paginated-updates">
              <label class="font-md my-2">Updates</label>
              <span
                class="ml-2 clickable"
                v-if="_isallowed('write')"
                @click.prevent="addNote"
              >
                <i class="fas fa-plus-circle"></i>
              </span>
              <paginate-links
                v-if="filteredNotes.length"
                for="filteredNotes"
                :show-step-links="true"
                :limit="2"
              ></paginate-links>
              <paginate
                ref="paginator"
                name="filteredNotes"
                :list="filteredNotes"
                :per="5"
                class="paginate-list"
                :key="filteredNotes ? filteredNotes.length : 1"
              >
                

                <el-card
                  v-for="note in paginated('filteredNotes')"
                  :key="note.id"
                  class="update-card mb-3"
                >
                  <div class="d-flex justify-content-between">
                    <label class="font-md">Update</label>
                    <div class="font-sm">
                      <el-tag size="mini"
                        ><span class="font-weight-bold">Submitted by:</span>
                        <span v-if="note.updated_at"
                          >{{ note.user.full_name }} on
                          {{ new Date(note.updated_at).toLocaleString() }}</span
                        ><span v-else
                          >{{ $currentUser.full_name }} on
                          {{ new Date().toLocaleDateString() }}</span
                        ></el-tag
                      >
                      <i
                        v-if="allowDeleteNote(note)"
                        class="el-icon-delete clickable ml-3"
                        @click.prevent.stop="destroyNote(note)"
                      ></i>
                    </div>
                  </div>

                  <el-input
                    v-model="note.body"
                    type="textarea"
                    :rows="3"
                    placeholder="Enter your update here..."
                    :readonly="!allowEditNote(note)"
                  ></el-input>
                </el-card>


              </paginate>
            </div>
          </div>
          <!-- END RISK UPDATES TAB SECTION -->
        </div>
      </div>
      <!-- TABBED OUT SECTION END HERE -->
      <div ref="addUpdates" class="pt-0 mt-0"></div>
      <div></div>
    </form>
    <!-- <div
      v-if="loading"
      class="load-spinner spinner-border text-dark"
      role="status"
    ></div> -->

    <RelatedRiskMenu
      :facilities="facilities"
      :facilityGroups="facilityGroups"
      :risk="risk"
      :relatedTasks="relatedTasks"
      :relatedIssues="relatedIssues"
      :relatedRisks="relatedRisks"
      @add-related-tasks="addRelatedTasks"
      @add-related-issues="addRelatedIssues"
      @add-related-risks="addRelatedRisks"
      ref="menu"
    >
    </RelatedRiskMenu>
  </div>
</template>

<script>
import axios from "axios";
import humps from "humps";
import * as Moment from "moment";
import Draggable from "vuedraggable";
import FormTabs from "./../../shared/FormTabs.vue";
import {API_BASE_PATH} from './../../../mixins/utils'
import { mapGetters, mapMutations, mapActions } from "vuex";
import AttachmentInput from "./../../shared/attachment_input";
import RelatedRiskMenu from "./../../shared/RelatedRiskMenu";
import AuthorizationService from "../../../services/authorization_service"


export default {
  name: "portfolioRiskForm",
  props: ["facility", "risk", "facilities", "fixedStage"],
  components: {
    AttachmentInput,
    FormTabs,
    Draggable,
    RelatedRiskMenu,
    AuthorizationService
  },
  data() {
    return {
      DV_risk: this.INITIAL_RISK_STATE(),
      DV_facility: Object.assign({}, this.facility),
      paginate: ["filteredNotes"],
      now: new Date().toLocaleString(),
      programId: this.$route.params.programId,
      destroyedFiles: [],
      responsibleUsers: null,
      accountableRiskUsers: null,
      consultedRiskUsers: [],
      informedRiskUsers: [],
      probability: [],
      selectedRiskPossibility: { id: 1, value: 1, name: "1 - Rare" },
      selectedRiskImpactLevel: { id: 1, value: 1, name: "1 - Negligible" },   
      selectedStatus: { id: 1, value: 1, name: "Nothing Selected" },   
      selectedDuration: { id: 1, value: 1, name: "Nothing Selected" },   
      selectedTaskType: null,  
      selectedRiskStage: null,
      relatedIssues: [],
      editToggle: false,  
      relatedTasks: [],
      relatedRisks: [],
      showErrors: false,
      loading: true,
      movingSlot: "",
      currentTab: "risk",
      tabs: [
        {
          label: "Identify",
          key: "risk",
          closable: false,
          form_fields: [
            "Risk Name",
            "Risk Description",
            "Process Area",
            "Date Identified",
            "Risk Approach Due Date",
          ],
        },
        {
          label: "Assign",
          key: "tab2",
          closable: false,
        },
        {
          label: "Prioritize",
          key: "tab3",
          closable: false,
          form_fields: [
            "Probability",
            "Probability Description",
            "Impact Level",
            "Impact Description",
            "Risk Approach",
            "Risk Approach Description",
          ],
        },
        {
          label: "Control",
          key: "tab4",
          closable: false,
        },
        {
          label: "Files & Links",
          key: "tab5",
          closable: false,
        },
        // {
        //   label: "Related",
        //   key: "tab6",
        //   disabled: true, 
        //   closable: false,
        // },
        {
          label: "Updates",
          key: "tab8",
          closable: false,
        },
        {
          label: "Disposition",
          key: "tab6",
          closable: false,
          disabled: false,
        },
      ],
    };
  },
  updated() {
    if (this.fixedStage) {
      this.selectedRiskStage = this.fixedStage;
    }
  }, 
  mounted() {
    // this.fetchPortfolioAssignees()
    this.fetchPortfolioRiskStages()
    this.fetchPortfolioAssignees()
    this.fetchPortfolioCategories()
    console.log(this.$route.params)
    AuthorizationService.getRolePrivileges();       
    if (!_.isEmpty(this.risk)) {
      this.loadRisk(this.risk);
    } else {
      this.loading = false;
      this.loadRisk(this.DV_risk);
    }   
    this.loading = false;
    this._ismounted = true; 
  },
  methods: {
    ...mapMutations([
      "setRiskForManager",
      "setRiskProbabilityOptions",
      "setRiskImpactLevelOptions",
      'setRiskDispositionStatus',
      'setRiskDispositionDuration',

      "updateRisksHash",
    ]),
    ...mapActions([
      "riskDeleted",
      "riskUpdated",
      "updateWatchedRisks",
      "updateApprovedRisks",
      'fetchPortfolioAssignees', 
      'fetchPortfolioCategories', 
      'fetchPortfolioRiskStages',
      'fetchPortfolioRisk'
    ]),
    INITIAL_RISK_STATE() {
      return {
        text: "",
        facilityProjectId: this.$route.params.projectId,
        text: "",
        risk_description: "",
        explanation: "",
        impactDescription: "",
        probabilityDescription: "",
        riskApproach: "avoid",
        approvalTime: "",
        riskApproachDescription: "",
        riskTypeId: "",
        me: "",
        riskStageId: "",
        probability: 1,
        impactLevel: 1,
        probabilityName: "1 - Rare",
        impactLevelName: "1 - Negligible",
        progress: 0,
        start_date: "",
        getRiskImpactLevelNames: "1 - Negligible",
        // getRiskDispositionDuration: "Nothing Selected",
        // getRiskDispositionStatus: "Nothing Selected",
        due_date: "",
        autoCalculate: true,
        important: false,
        reportable: false, 
        onHold: false,
        draft: false,
        ongoing: false,
        // riskApproverUserIds: [],
        responsible_user_ids: [],
        accountable_user_ids: [],
        consulted_user_ids: [],
        informed_user_ids: [],
        risk_files: [],
        sub_task_ids: [],
        sub_risk_ids: [],
        sub_issue_ids: [],
        checklists: [],
        notes: [],
      };
    },
    //TODO: change the method name of isAllowed
    _isallowed(salut) {
      return this.checkPrivileges("portfolio_risk_form", salut, this.$route)

      // var programId = this.$route.params.programId;
      // var projectId = this.$route.params.projectId
      // let fPrivilege = this.$projectPrivileges[programId][projectId]
      // let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      // let s = permissionHash[salut]
      // return  fPrivilege.risks.includes(s); 
    },
    urlShortener(str, length, ending) {
      if (length == null) {
        length = 70;
      }
      if (ending == null) {
        ending = "...";
      }
      if (str.length > length) {
        return str.substring(0, length - ending.length) + ending;
       } else {
        return str;
      }
    },
    scrollToChecklist() {
      this.$refs.addCheckItem.scrollIntoView({
        behavior: "smooth",
        block: "start",
        inline: "nearest",
      });
      this.DV_risk.checklists.push({ text: "", checked: false });
    },
    scrollToUpdates() {
      this.$refs.addUpdates.scrollIntoView({
        behavior: "smooth",
        block: "end",
        inline: "nearest",
      });
      this.DV_risk.notes.unshift({ body: "", user_id: "", guid: this.guid() });
    },
    scrollToRiskMatrix() {
      this.$refs.riskMatrix.scrollIntoView({
        behavior: "smooth",
        block: "start",
        inline: "nearest",
      });
    },
    handleMove(item) {
      this.movingSlot = item.relatedContext.component.$vnode.key;
      return true;
    },
    handleEnd(e, checklists) {
      let cc = this.DV_risk.checklists;
      let count = 0;
      for (let checklist of cc) {
        checklist.position = count;
        count++;
      }
    },
    onChangeTab(tab) {
      this.currentTab = tab ? tab.key : "risk";
    },
    loadRisk(risk) {
      this.DV_risk = { ...this.DV_risk, ..._.cloneDeep(risk) };
      this.responsibleUsers = _.filter(this.activeProjectUsers, (u) =>
        this.DV_risk.responsible_user_ids.includes(u.id)
      )[0];
      this.accountableRiskUsers = _.filter(this.activeProjectUsers, (u) =>
        this.DV_risk.accountable_user_ids.includes(u.id)
      )[0];
      this.consultedRiskUsers = _.filter(this.activeProjectUsers, (u) =>
        this.DV_risk.consulted_user_ids.includes(u.id)
      );
      this.informedRiskUsers = _.filter(this.activeProjectUsers, (u) =>
        this.DV_risk.informed_user_ids.includes(u.id)
      );
      // this.riskApprover = _.filter(this.activeProjectUsers, (u) =>
      //   this.DV_risk.riskApproverUserIds.includes(u.id)
      // )[0];
      this.relatedIssues = _.filter(this.currentIssues, (u) =>
        this.DV_risk.sub_issue_ids.includes(u.id)
      );
      this.relatedTasks = _.filter(this.currentTasks, (u) =>
        this.DV_risk.sub_task_ids.includes(u.id)
      );
      this.relatedRisks = _.filter(this.currentRisks, (u) =>
        this.DV_risk.sub_risk_ds.includes(u.id)
      );
      this.selectedTaskType = this.taskTypes.find(
        (t) => t.id === this.DV_risk.task_type_id
      );
      if (this.riskStages){
        this.selectedRiskStage = this.riskStages[this.programId].find(
        (t) => t.id === this.DV_risk.risk_stage_id
      );
      }    
      this.selectedRiskPossibility = this.getRiskProbabilityNames.find(
        (t) => t.id === this.DV_risk.probability
      );
      this.selectedRiskImpactLevel = this.getRiskImpactLevelNames.find(
        (t) => t.id === this.DV_risk.impact_level
      );
        this.selectedDuration = this.getRiskDispositionDuration.find(
        (t) => t.id === this.DV_risk.duration
      );
       this.selectedStatus = this.getRiskDispositionStatus.find(
        (t) => t.id === this.DV_risk.status
      );
      if (this.DV_risk.attach_files)
        this.addFile(this.DV_risk.attach_files, false);
      this.$nextTick(() => {
        this.errors.clear();
        this.$validator.reset();
        this.loading = false;
      });
    },
    addFile(files = [], append = true) {
      let _files = append ? [...this.DV_risk.risk_files] : [];
      for (let file of files) {
        file.guid = this.guid();
        _files.push(file);
      }
      this.DV_risk.risk_files = _files;
    },
    deleteRisk() {
      this.$confirm(`Are you sure you want to delete this risk?`, 'Confirm Delete', {
        confirmButtonText: 'Delete',
        cancelButtonText: 'Cancel',
        type: MessageDialogService.msgTypes.WARNING
      }).then(() => {
        this.riskDeleted(this.DV_risk);
        this.cancelRiskSave();
      });
    },
    deleteFile(file) {
      if (!file) return;
      this.$confirm(`Are you sure you want to delete attachment?`, 'Confirm Delete', {
        confirmButtonText: 'Delete',
        cancelButtonText: 'Cancel',
        type: MessageDialogService.msgTypes.WARNING
      }).then(() => {
        if (file.uri || file.link) {
          let index = this.DV_risk.risk_files.findIndex(
            (f) => f.guid === file.guid
          );
          if (file.id) {
            Vue.set(this.DV_risk.risk_files, index, { ...file, _destroy: true });
            this.destroyedFiles.push(file);
          }
          this.DV_risk.risk_files.splice(
            this.DV_risk.risk_files.findIndex((f) => f.guid === file.guid),
            1
          );
        } else if (file.name) {
          this.DV_risk.risk_files.splice(
            this.DV_risk.risk_files.findIndex((f) => f.guid === file.guid),
            1
          );
        }
      });
    },
    toggleWatched() {
      if(!this._isallowed('write')){
        return
      }
      if (this.DV_risk.progress == 100 && !this.DV_risk.watched) {
        MessageDialogService.showDialog({
          message: `Risks at 100% progress cannot be placed On Watch status.`,
          type: MessageDialogService.msgTypes.WARNING
        });
        return;
      }
      if (this.DV_risk.watched) {
        MessageDialogService.showDialog({
          message: `${this.DV_risk.text} has been removed from On Watch status.`,
          type: MessageDialogService.msgTypes.WARNING
        });
      } else {
        MessageDialogService.showDialog({
          message: `${this.DV_risk.text} successfully placed On Watch status.`
        });
      }
      this.DV_risk = { ...this.DV_risk, watched: !this.DV_risk.watched };
      this.validateThenSave()
    },
    toggleImportant() {
      if(!this._isallowed('write')){
        return
      }
      this.DV_risk = { ...this.DV_risk, important: !this.DV_risk.important };
    },
    toggleOngoing() {
      if(!this._isallowed('write')){
        return
      }
      this.DV_risk = { ...this.DV_risk, ongoing: !this.DV_risk.ongoing };
      this.DV_risk.due_date = '';
    },
    toggleOnhold() {
      if(!this._isallowed('write')){
        return
      }
        this.DV_risk = { ...this.DV_risk, on_hold: !this.DV_risk.on_hold };
        this.DV_risk.due_date = '';
      },
    toggleDraft() {
      if(!this._isallowed('write')){
        return
      }
        this.DV_risk = { ...this.DV_risk, draft: !this.DV_risk.draft };
      },
    toggleReportable() {
      if(!this._isallowed('write')){
        return
      }
        this.DV_risk = { ...this.DV_risk, reportable: !this.DV_risk.reportable };
      },
    removeFromWatch() {
      if(!this._isallowed('write')){
        return
      }
      if (this.DV_risk.progress == 100 && this.DV_risk.watched == true) {
        this.toggleWatched();
      }
    },
    toggleApproved(e) {
      if(!this._isallowed("write"))
        return;
      this.DV_risk = { ...this.DV_risk, approved: !this.DV_risk.approved };
      this.DV_risk.approval_time =
        this.$currentUser.full_name + " on " + new Date().toLocaleString();
      if (!this.DV_risk.approved) {
        this.DV_risk.approval_time = "";
      }
      //this.updateApprovedRisks(this.DV_risk);
      this.validateThenSave(e);
    },
    selectedStage(item) {
      if (this._isallowed("write")) {
        this.selectedRiskStage = item;
      }
    },
    clearStages() {
      this.selectedRiskStage = null;
      this.riskStageId = "";
    },
    editProgress() {
      this.editToggle = !this.editToggle;
      //this.editTimeLive = moment.format('DD MMM YYYY, h:mm a')
    },
    progressListTitleText(progress_list) {
      if (!progress_list.id) return;
      var date = moment(progress_list.created_at).format("MM/DD/YYYY");
      var time = moment(progress_list.created_at).format("hh:mm:ss a");
      return `${progress_list.user.full_name} at ${date} ${time} `;
    },
    cancelRiskSave() {
      this.$emit("on-close-form");
      this.setRiskForManager({ key: "risk", value: null });
    },
    validateThenSave() {
      // e.preventDefault();
      this.$validator.validate().then((success) => {
        if (!success || this.loading) {
          this.showErrors = !success;
          return;
        }
        this.editToggle = !this.editToggle;
        this.loading = true;
        let formData = new FormData();
        formData.append("source", "portfolio_viewer");        
        formData.append("risk[text]", this.DV_risk.text);
        formData.append("risk[risk_description]", this.DV_risk.risk_description);
        formData.append("risk[approved]", this.DV_risk.approved);
        
        if (!this.DV_risk.explanation) {
          formData.append("risk[explanation]",'')
        } else {
          formData.append("risk[explanation]", this.DV_risk.explanation);   
        }      
        formData.append(
          "risk[impact_description]",
          this.DV_risk.impact_description
        );
        formData.append(
          "risk[probability_description]",
          this.DV_risk.probability_description
        );
        formData.append(
          "risk[probability_name]",
          this.selectedRiskPossibility.name
        );
        formData.append("risk[probability]", this.selectedRiskPossibility.id);
        formData.append(
          "risk[impact_level_name]",
          this.selectedRiskImpactLevel.name
        );
        if (this.selectedStatus) {        
          formData.append("risk[status]", this.selectedStatus.id);
          formData.append("risk[status_name]", this.selectedStatus.name);
        } else {          
            formData.append("risk[status_name]", '');
            formData.append("risk[status]", null);
        }
                
        if (this.selectedDuration) {
          formData.append("risk[duration]", this.selectedDuration.id)
          formData.append("risk[duration_name]", this.selectedDuration.name);
              
        } else {
           formData.append("risk[duration_name]", '')
           formData.append("risk[duration]", null);
        }
        formData.append("risk[impact_level]", this.selectedRiskImpactLevel.id);
        // console.log("-------------")
        // console.log(this.DV_risk.risk_approach)
        formData.append("risk[risk_approach]", this.DV_risk.risk_approach);
        formData.append(
          "risk[risk_approach_description]",
          this.DV_risk.risk_approach_description
        );
        formData.append("risk[approval_time]", this.DV_risk.approval_time);     
        formData.append("risk[task_type_id]", this.DV_risk.task_type_id);
        formData.append("risk[risk_stage_id]", this.DV_risk.risk_stage_id);
        formData.append("risk[progress]", this.DV_risk.progress);
        formData.append("risk[start_date]", this.DV_risk.start_date);
        formData.append("risk[due_date]", this.DV_risk.due_date);
        formData.append("risk[auto_calculate]", this.DV_risk.auto_calculate);
        formData.append("risk[important]", this.DV_risk.important);
        formData.append("risk[ongoing]", this.DV_risk.ongoing);
        formData.append("risk[reportable]", this.DV_risk.reportable);
        formData.append("risk[on_hold]", this.DV_risk.on_hold);
        formData.append("risk[watched]", this.DV_risk.watched);
        formData.append("risk[draft]", this.DV_risk.draft);
        formData.append(
          "risk[destroy_file_ids]",
          _.map(this.destroyedFiles, "id")
        );
        // Responsible User id
        if (
          this.DV_risk.responsible_user_ids &&
          this.DV_risk.responsible_user_ids.length
        ) {
          for (let u_id of this.DV_risk.responsible_user_ids) {
            formData.append("responsible_user_ids[]", u_id);
          }
        } else {
          formData.append("responsible_user_ids[]", []);
        }
        // Accountable UserId
        if (
          this.DV_risk.accountable_user_ids &&
          this.DV_risk.accountable_user_ids.length
        ) {
          for (let u_id of this.DV_risk.accountable_user_ids) {
            formData.append("accountable_user_ids[]", u_id);
          }
        } else {
          formData.append("accountable_user_ids[]", []);
        }
        // Consulted UserId

        if (
          this.DV_risk.consulted_user_ids &&
          this.DV_risk.consulted_user_ids.length
        ) {
          for (let u_id of this.DV_risk.consulted_user_ids) {
            formData.append("consulted_user_ids[]", u_id);
          }
        } else {
          formData.append("consulted_user_ids[]", []);
        }
        // Informed UserId

        if (
          this.DV_risk.informed_user_ids &&
          this.DV_risk.informed_user_ids.length
        ) {
          for (let u_id of this.DV_risk.informed_user_ids) {
            formData.append("informed_user_ids[]", u_id);
          }
        } else {
          formData.append("informed_user_ids[]", []);
        }

        if (this.DV_risk.sub_task_ids.length) {
          for (let u_id of this.DV_risk.sub_task_ids) {
            formData.append("risk[sub_task_ids][]", u_id);
          }
        } else {
          formData.append("risk[sub_task_ids][]", []);
        }
        if (this.DV_risk.sub_issue_ids.length) {
          for (let u_id of this.DV_risk.sub_issue_ids) {
            formData.append("risk[sub_issue_ids][]", u_id);
          }
        } else {
          formData.append("risk[sub_issue_ids][]", []);
        }
        if (this.DV_risk.sub_risk_ids.length) {
          for (let u_id of this.DV_risk.sub_risk_ids) {
            formData.append("risk[sub_risk_ids][]", u_id);
          }
        } else {
          formData.append("risk[sub_risk_ids][]", []);
        }
        for (let i in this.DV_risk.checklists) {
          let check = this.DV_risk.checklists[i];
          if (!check.text && !check._destroy) continue;
          for (let key in check) {
            if (key === "user") key = "user_id";
            let value =
              key == "user_id"
                ? check.user
                  ? check.user.id
                  : null
                : check[key];
            // if (key === "dueDate") key = "due_date"

            key = humps.decamelize(key);
            if (["created_at", "updated_at", "progress_lists"].includes(key))
              continue;
            formData.append(`risk[checklists_attributes][${i}][${key}]`, value);

            for (let pi in check.progress_lists) {
              let progress_list = check.progress_lists[pi];
              if (!progress_list.body && !progress_list._destroy) continue;
              for (let pkey in progress_list) {
                if (pkey === "user") pkey = "user_id";
                let pvalue =
                  pkey == "user_id"
                    ? progress_list.user
                      ? progress_list.user.id
                      : null
                    : progress_list[pkey];

                pkey = humps.decamelize(pkey);
                if (["created_at", "updated_at"].includes(pkey)) continue;
                formData.append(
                  `risk[checklists_attributes][${i}][progress_lists_attributes][${pi}][${pkey}]`,
                  pvalue
                );
              }
            }
          }
        }

        for (let i in this.DV_risk.notes) {
          let note = this.DV_risk.notes[i];
          if (!note.body && !note._destroy) continue;
          for (let key in note) {
            let value =
              key == "user_id"
                ? note.user_id
                  ? note.user_id
                  : this.$currentUser.id
                : note[key];
                if ( key == 'body') {
                  value = value.replace(/[^ -~]/g,'')
                }        
            formData.append(`risk[notes_attributes][${i}][${key}]`, value);
          }
        }
        for (let file of this.DV_risk.risk_files) {
          if (file.id) continue;
          if (!file.link) {
            formData.append("risk[risk_files][]", file);
          } else if (file.link) {
            formData.append("file_links[]", file.name);
          }
        }

        let url = `${API_BASE_PATH}/programs/${this.$route.params.programId}/projects/${this.$route.params.projectId}/risks.json`;
        let method = "POST";
        let callback = "risk-created";
        if (this.risk && this.risk.id) {
          url = `${API_BASE_PATH}/programs/${this.$route.params.programId}/projects/${this.$route.params.projectId}/risks/${this.risk.id}.json`;
          method = "PUT";
          callback = "risk-updated";
        }
        // var beforeRisk = this.risk
        axios({
          method: method,
          url: url,
          data: formData,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((response) => {
           this.loadRisk(response.data.risk);
          //  this.updateRisksHash({ risk: response.data.risk });

            // let risk_i = this.portfolioRisks.risks.findIndex((t) => t.id == this.DV_risk.id)
            // if (risk_i > -1){
            //   Vue.set(this.portfolioRisks.risks, risk_i, this.DV_risk)
            // }else if (risk_i == -1){
            //   this.portfolioRisks.risks.push(this.DV_risk)
            // }

            if (response.status === 200) {
              MessageDialogService.showDialog({
                message: `${response.data.risk.text} was saved successfully.`,
                
                
              });
            }
           })
          .catch((err) => {
            console.log("Error",err);
          })
          .finally(() => {
            this.loading = false;
          });
      });
    },
    addFilesInput() {
      this.DV_risk.risk_files.push({
        name: "",
        uri: "",
        link: true,
        guid: this.guid(),
      });
    },
    addProgressList(check) {
      if (check.progress_lists !== undefined || null) {
       var postion = check.progress_lists.length;
        check.progress_lists.push({ body: "", position: postion });
          this.editToggle = true;
      }
    },
    destroyProgressList(check, progress_list, index) {
      this.$confirm(`Are you sure you want to delete this Program list item?`, 'Confirm Delete', {
        confirmButtonText: 'Delete',
        cancelButtonText: 'Cancel',
        type: MessageDialogService.msgTypes.WARNING
      }).then(() => {
        let i = progress_list.id
          ? check.progress_lists.findIndex((c) => c.id === progress_list.id)
          : index;
        Vue.set(check.progress_lists, i, { ...progress_list, _destroy: true });
        this.validateThenSave();
      });
    },
    downloadFile(file) {
      let url = window.location.origin + file.uri;
      window.open(url, "_blank");
    },
    disabledDueDate(date) {
      date.setHours(0, 0, 0, 0);
      const startDate = new Date(this.DV_risk.start_date);
      startDate.setHours(48, 0, 0, 0);
      // console.log(startDate)
      return date < startDate;
    },
    destroyNote(note) {
      this.$confirm(`Are you sure you want to delete this note?`, 'Confirm Delete', {
        confirmButtonText: 'Delete',
        cancelButtonText: 'Cancel',
        type: MessageDialogService.msgTypes.WARNING
      }).then(() => {
        let i = note.id
          ? this.DV_risk.notes.findIndex((n) => n.id === note.id)
          : this.DV_risk.notes.findIndex((n) => n.guid === note.guid);
        Vue.set(this.DV_risk.notes, i, { ...note, _destroy: true });
      });
    },
    addChecks() {
      var postion = this.DV_risk.checklists.length;
      this.DV_risk.checklists.push({
        text: "",
        checked: false,
        position: postion,
        progress_lists: [],
      });
    },
    noteBy(note) {
      return note.user
        ? `${note.user.full_name} at ${new Date(
            note.created_at
          ).toLocaleString()}`
        : `${this.$currentUser.full_name} at (Now)`;
    },
    addNote() {
      this.DV_risk.notes.unshift({ body: "", user_id: "", guid: this.guid() });
    },
    destroyCheck(check, index) {
      this.$confirm(`Are you sure you want to delete this checklist item?`, 'Confirm Delete', {
        confirmButtonText: 'Delete',
        cancelButtonText: 'Cancel',
        type: MessageDialogService.msgTypes.WARNING
      }).then(() => {
        let i = check.id
          ? this.DV_risk.checklists.findIndex((c) => c.id === check.id)
          : index;
        Vue.set(this.DV_risk.checklists, i, { ...check, _destroy: true });
        this.validateThenSave();
      });
    },
    calculateProgress(checks = null) {
      try {
        if (!checks) checks = this.DV_risk.checklists;
        let checked = _.filter(
          checks,
          (v) => !v._destroy && v.checked && v.text.trim()
        ).length;
        let total = _.filter(checks, (v) => !v._destroy && v.text.trim())
          .length;
        this.DV_risk.progress = Number(
          ((checked / total) * 100 || 0).toFixed(2)
        );
      } catch (err) {
        this.DV_risk.progress = 0;
      }
    },
    updateCheckItem(event, name, index) {
      if (name === "text") {
        this.DV_risk.checklists[index].text = event.target.value;
        if (!event.target.value) this.DV_risk.checklists[index].checked = false;
      } else if (name === "check" && this.DV_risk.checklists[index].text) {
        this.DV_risk.checklists[index].checked = event.target.checked;
      } else if (name === "due_date" && this.DV_risk.checklists[index].text) {
        this.DV_risk.checklists[index].due_date = event.target.value;
      }
    },
    updateFileLinkItem(event, name, input) {
      //var v = event.target.value
      //var valid = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$/i/.test(v);
      if (event.target.value) {
        input.name = event.target.value;
      }
    },
    updateProgressListItem(event, name, progress_list) {
      progress_list.body = event.target.value;
    },
    isMyCheck(check) {
      return this.C_myRisks && check.id
        ? check.user && check.user.id == this.$currentUser.id
        : true;
    },
    allowDeleteNote(note) {
      return (
        (this._isallowed("delete") && note.guid) ||
        note.user_id == this.$currentUser.id
      );
    },
    allowEditNote(note) {
      return (
        (this._isallowed("write") && note.guid) ||
        note.user_id == this.$currentUser.id
      );
    },
    disabledDateRange(date) {
      var dueDate = new Date(this.DV_risk.due_date);
      dueDate.setDate(dueDate.getDate() + 1);
      return date < new Date(this.DV_risk.start_date) || date > dueDate;
    },
    errorLocation(error) {
      var identifyTabFields = [
        "Risk Name",
        "Risk Description",
        "Process Area",
        "Date Identified",
        "Risk Approach Due Date",
      ];

      var tooltipMessage = "Field is located on Prioritize";

      // var priortizeTabFields = ["Probability", "Probability Description", "Impact Level", "Impact Description", "Risk Approach", "Risk Approach Description"]

      identifyTabFields.forEach((field) => {
        var regex = new RegExp(field);

        if (regex.test(error)) {
          tooltipMessage = "Field is located on Identify";
        }
      });
      return tooltipMessage;
    },
    openContextMenu(e, item) {
      e.preventDefault();
      this.$refs.menu.open(e, item);
    },
    addRelatedTasks(tasks) {
      tasks.forEach((task) => this.relatedTasks.push(task));
    },
    removeRelatedTask({ id }) {
      this.$confirm(`Are you sure you want to delete this related task?`, 'Confirm Delete', {
          confirmButtonText: 'Delete',
          cancelButtonText: 'Cancel',
          type: MessageDialogService.msgTypes.WARNING
        }).then(() => {
          this.relatedTasks.splice(
            this.relatedTasks.findIndex((task) => task.id == id),
            1
          );
        });
    },
    addRelatedIssues(issues) {
      issues.forEach((issue) => this.relatedIssues.push(issue));
    },
    removeRelatedIssue({ id }) {
      this.$confirm(`Are you sure you want to delete this related issue?`, 'Confirm Delete', {
          confirmButtonText: 'Delete',
          cancelButtonText: 'Cancel',
          type: MessageDialogService.msgTypes.WARNING
        }).then(() => {
          this.relatedIssues.splice(
            this.relatedIssues.findIndex((issue) => issue.id == id),
            1
          );
        });
    },
    addRelatedRisks(risks) {
      risks.forEach((risk) => this.relatedRisks.push(risk));
    },
    removeRelatedRisk({ id }) {
      this.$confirm(`Are you sure you want to delete this related risk?`, 'Confirm Delete', {
          confirmButtonText: 'Delete',
          cancelButtonText: 'Cancel',
          type: MessageDialogService.msgTypes.WARNING
        }).then(() => {
          this.relatedRisks.splice(
            this.relatedRisks.findIndex((risk) => risk.id == id),
            1
          );
        });
    },
    author(id) {
      return this.activeProjectUsers.find((user) => user.id == id).name;
    },
  },
  computed: {
    ...mapGetters([
      "portfolioRisks",
      "portfolioRisk",
      "portfolioUsers",
      "currentIssues",
      "portfolioCategories", 
      'portfolioRiskLoaded',
      "categories",
      "currentProject",
      "currentRisks",
      "currentTasks",
      "facilityGroups",
      "getFacilityProjectOptions",
      "getRiskImpactLevelNames",
      "getRiskDispositionDuration",
      "getRiskDispositionStatus",
      "getRiskImpactLevelOptions",
      "getRiskProbabilityNames",
      "getRiskProbabilityOptions",
      "impactLevelNames",
      'dispositionStatuses',
      "managerView",
      "myActionsFilter",
      "probabilityNames",
      "projectUsers",
      "riskApproaches",
      'riskDispositionStatuses',
      'riskDispositionDuration',
      "portfolioRiskStages",
     ]),
     riskStages(){
          if(this.portfolioRiskStages){
            return this.portfolioRiskStages.program_stages
          }
       },
    riskStagesSorted() { 
      if (this.riskStages) {
        let stageObj =  [...this.riskStages[this.programId]]
        return stageObj.sort((a,b) => (a.percentage > b.percentage) ? 1 : -1);  
      }        
    },   
    activeProjectUsers(){
      return this.portfolioUsers;
    },
    readyToSave() {
      return (
        this.DV_risk &&
        this.exists(this.DV_risk.text) &&
        this.exists(this.DV_risk.risk_description) &&
        // this.exists(this.DV_risk.impactDescription) &&
        // this.exists(this.DV_risk.probabilityDescription) &&
        this.exists(this.selectedRiskPossibility.id) &&
        this.exists(this.selectedRiskImpactLevel.id) &&
        this.exists(this.selectedRiskPossibility.id) &&     
        this.exists(this.DV_risk.risk_approach) &&
        // this.exists(this.DV_risk.riskApproachDescription) &&
        this.exists(this.DV_risk.task_type_id) &&
        this.exists(this.DV_risk.start_date) &&
        this.exists(this.DV_risk.due_date)
      );
    },
    riskStagePercentage() {
     if (this.riskStages){
        return _.map(this.riskStages[this.programId], "percentage").toString();
     }    
    },
    taskTypes(){
      return this.portfolioCategories  
    },
    isMapView() {
      return this.$route.name === "MapRiskForm";
    },
    isSheetsView() {
      return this.$route.name === "SheetRiskForm";
    },
    isKanbanView() {
      return this.$route.name === "KanbanRiskForm";
    },
    isCalendarView() {
      return this.$route.name === "CalendarRiskForm";
    },
    filteredChecks() {
      return _.filter(this.DV_risk.checklists, (c) => !c._destroy);
    },
    filteredFiles() {
      return _.filter(this.DV_risk.risk_files, (f) => !f._destroy);
    },
    C_myRisks() {
      return _.map(this.myActionsFilter, "value").includes("risks");
    },
    C_riskProbabilityOptions: {
      get() {
        return this.getRiskProbabilityOptions;
      },
      set(value) {
        this.setRiskProbabilityOptions(value);
      },
    },
    C_riskImpactLevelOptions: {
      get() {
        return this.getRiskImpactLevelOptions;
      },
      set(value) {
        this.setRiskImpactLevelOptions(value);
      },
    },
    title() {
      return this._isallowed("write")
        ? this.DV_risk.id
          ? "Edit Risk"
          : "Create Risk"
        : "Risk";
    },
    filteredTasks() {
      return this.currentTasks;
    },
    filteredIssues() {
      return this.currentIssues;
    },
    filteredRisks() {
      return _.filter(this.currentRisks, (t) => t.id !== this.DV_risk.id);
    },
    filteredNotes() {
      return _.orderBy(
        _.filter(this.DV_risk.notes, (n) => !n._destroy),
        "created_at",
        "desc"
      );
    },
    matrix11() {
      if (
        this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 1 &&
        this.selectedRiskPossibility.id == 1
      )
        return true;
    },
    matrix12() {
      if (
         this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 1 &&
        this.selectedRiskPossibility.id == 2
      )
        return true;
    },
    matrix13() {
      if (
         this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 1 &&
        this.selectedRiskPossibility.id == 3
      )
        return true;
    },
    matrix14() {
      if (
       this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 1 &&
        this.selectedRiskPossibility.id == 4
      )
        return true;
    },
    matrix15() {
      if (
      this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 1 &&
        this.selectedRiskPossibility.id == 5
      )
        return true;
    },
    matrix21() {
      if (
       this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 2 &&
        this.selectedRiskPossibility.id == 1
      )
        return true;
    },
    matrix22() {
      if (
       this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 2 &&
        this.selectedRiskPossibility.id == 2
      )
        return true;
    },
    matrix23() {
      if (
      this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 2 &&
        this.selectedRiskPossibility.id == 3
      )
        return true;
    },
    matrix24() {
      if (
     this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 2 &&
        this.selectedRiskPossibility.id == 4
      )
        return true;
    },
    matrix25() {
      if (
      this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 2 &&
        this.selectedRiskPossibility.id == 5
      )
        return true;
    },
    matrix31() {
      if (
      this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 3 &&
        this.selectedRiskPossibility.id == 1
      )
        return true;
    },
    matrix32() {
      if (
      this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 3 &&
        this.selectedRiskPossibility.id == 2
      )
        return true;
    },
    matrix33() {
      if (
     this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 3 &&
        this.selectedRiskPossibility.id == 3
      )
        return true;
    },
    matrix34() {
      if (
     this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 3 &&
        this.selectedRiskPossibility.id == 4
      )
        return true;
    },
    matrix35() {
      if (
     this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 3 &&
        this.selectedRiskPossibility.id == 5
      )
        return true;
    },
    matrix41() {
      if (
      this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 4 &&
        this.selectedRiskPossibility.id == 1
      )
        return true;
    },
    matrix42() {
      if (
       this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 4 &&
        this.selectedRiskPossibility.id == 2
      )
        return true;
    },
    matrix43() {
      if (
       this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 4 &&
        this.selectedRiskPossibility.id == 3
      )
        return true;
    },
    matrix44() {
      if (
       this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 4 &&
        this.selectedRiskPossibility.id == 4
      )
        return true;
    },
    matrix45() {
      if (
      this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 4 &&
        this.selectedRiskPossibility.id == 5
      )
        return true;
    },
    matrix51() {
      if (
     this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 5 &&
        this.selectedRiskPossibility.id == 1
      )
        return true;
    },
    matrix52() {
      if (
       this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 5 &&
        this.selectedRiskPossibility.id == 2
      )
        return true;
    },
    matrix53() {
      if (
      this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 5 &&
        this.selectedRiskPossibility.id == 3
      )
        return true;
    },
    matrix54() {
      if (
       this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 5 &&
        this.selectedRiskPossibility.id == 4
      )
        return true;
    },
    matrix55() {
      if (
      this.selectedRiskImpactLevel &&  this.selectedRiskImpactLevel.id == 5 &&
        this.selectedRiskPossibility.id == 5
      )
        return true;
    },
    calculatePriorityLevel() {   
      if (this.selectedRiskImpactLevel !== undefined)
       return this.selectedRiskImpactLevel.id * this.selectedRiskPossibility.id;
    },
    tab() {
      if (this.$route.path.includes("map")) {
        return "map";
      } else if (this.$route.path.includes("sheet")) {
        return "sheet";
      } else if (this.$route.path.includes("calendar")) {
        return "calendar";
      } else {
        return "kanban";
      }
    },
  projectNameLink() {
      if (this.$route.path.includes("map") || this.$route.path.includes("sheet") ) {
        return `/programs/${this.$route.params.programId}/${this.tab}/projects/${this.$route.params.projectId}/overview`;
      } else {
        return `/programs/${this.$route.params.programId}/${this.tab}`;
      }
    },
  },
  watch: {
    risk: {
      handler(risk) {
        if (risk && risk.id) {
          this.DV_risk = this.INITIAL_RISK_STATE();
        } 
        this.DV_risk.risk_files = [];
        this.destroyedFiles = [];
        if (risk) {
          this.loadRisk(risk);
        }
      },
      deep: true,
    },
    "DV_risk.start_date"(value) {
      if (!value) this.DV_risk.due_date = "";
    },
    // "DV_risk.due_date"(value) {
    //   if (this.facility.dueDate) {
    //     if (moment(value).isAfter(this.facility.dueDate, "day")) {
    //       this.$alert(`${this.DV_risk.text} Due Date is past ${this.facility.facilityName} Completion Date!`, `${this.DV_risk.text} Due Date Warning`, {
    //       confirmButtonText: 'Ok',
    //       type: MessageDialogService.msgTypes.WARNING
    //     });
    //     }
    //   }
    // },
    "DV_risk.checklists": {
      handler: function(value) {
        if (this.DV_risk.auto_calculate) this.calculateProgress(value);
      },
      deep: true,
    },
    "DV_risk.auto_calculate"(value) {
      if (value) this.calculateProgress();
    },
    responsibleUsers: {
      handler: function(value) {
        if (value) {
          this.DV_risk.responsible_user_ids = _.uniq(
            _.map(_.flatten([value]), "id")
          );
        } else {
          this.DV_risk.responsible_user_ids = null;
        }
      },
      deep: true,
    },
    accountableRiskUsers: {
      handler: function(value) {
        if (value) {
          this.DV_risk.accountable_user_ids = _.uniq(
            _.map(_.flatten([value]), "id")
          );
        } else {
          this.DV_risk.accountable_user_ids = null;
        }
      },
      deep: true,
    },
    consultedRiskUsers: {
      handler: function(value) {
        if (value) {
          this.DV_risk.consulted_user_ids = _.uniq(_.map(value, "id"));
        } else {
          this.DV_risk.consulted_user_ids = [];
        }
      },
      deep: true,
    },
    informedRiskUsers: {
      handler: function(value) {
        if (value) {
          this.DV_risk.informed_user_ids = _.uniq(_.map(value, "id"));
        } else {
          this.DV_risk.informed_user_ids = [];
        }
      },
      deep: true,
    },
    relatedIssues: {
      handler: function(value) {
        if (value) this.DV_risk.sub_issue_ids = _.uniq(_.map(value, "id"));
      },
      deep: true,
    },
    relatedTasks: {
      handler: function(value) {
        if (value) this.DV_risk.sub_task_ids = _.uniq(_.map(value, "id"));
      },
      deep: true,
    },
    relatedRisks: {
      handler: function(value) {
        if (value) this.DV_risk.sub_risk_ids = _.uniq(_.map(value, "id"));
      },
      deep: true,
    },
    selectedTaskType: {
      handler: function(value) {
        this.DV_risk.task_type_id = value ? value.id : null;
      },
      deep: true,
    },
    selectedStatus: {
      handler: function(value) {
        this.DV_risk.status = value ? value.id : null;
      },
      deep: true,
    },
   selectedDuration: {
      handler: function(value) {
        this.DV_risk.duration = value ? value.id : null;      
      },
      deep: true,
    },
    selectedRiskStage: {
      handler: function(value) {
        // console.log("This is the watcher id value: " + value.id)
        this.DV_risk.risk_stage_id = value ? value.id : null;
      },
      deep: true,
    },
    filteredTasks: {
      handler(value) {
        let ids = _.map(value, "id");
        this.relatedTasks = _.filter(this.relatedTasks, (t) =>
          ids.includes(t.id)
        );
      },
      deep: true,
    },
    filteredIssues: {
      handler(value) {
        let ids = _.map(value, "id");
        this.relatedIssues = _.filter(this.relatedIssues, (t) =>
          ids.includes(t.id)
        );
      },
      deep: true,
    },
    filteredRisks: {
      handler(value) {
        let ids = _.map(value, "id");
        this.relatedRisks = _.filter(this.relatedRisks, (t) =>
          ids.includes(t.id)
        );
      },
      deep: true,
    },
    "filteredNotes.length"(value, previous) {
      this.$nextTick(() => {
        if (this.$refs.paginator && (value === 1 || previous === 0)) {
          this.$refs.paginator.goToPage(1);
        }
      });
    },
  },
};
</script>

<style lang="scss" scoped>
.fixed-form {
  overflow-y: auto;
  overflow-x: hidden;
  height: calc(100vh - 175px);
}
.title {
  font-size: 15px;
  margin-left: 65px;
}
td,
th {
  border: solid 1px #ededed;
  padding: 1px 3px;
}
tbody {
  background-color: #fff;
}

th {
  background: #ededed;
  color: #383838;
  padding: 1px 3px;
}
.checklist-text {
  margin-left: 5px;
  border: 0;
  width: 95%;
  outline: none;
  border: solid #ededed 1px;
  border-radius: 4px;
}
.del-check {
  position: absolute;
  display: flex;
  right: 2rem;
  font-weight: 500;
  background: transparent;
  height: fit-content;
  color: #dc3545;
}
ul {
  list-style-type: none;
  padding: 0;
}
.drag {
  cursor: all-scroll;
}
.formTitle {
  padding-top: 25px;
}
.paperLookTab {
  padding-bottom: 20px;
  margin-bottom: 10px;
  position: relative;
  background-color: #fff;
}
.sticky-btn {
  margin-top: 5px;
  margin-bottom: 5px;
  box-shadow: 0 5px 10px rgba(56, 56, 56, 0.19),
    0 1px 1px rgba(56, 56, 56, 0.23);
}
.rmBtn,
.clearBtn {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.sticky {
  justify-content: center;
  z-index: 1000;
  left: 15;
  top: 0;
  width: 100%;
  padding: 6px;
  background-color: rgba(237, 237, 237, 0.85);
  box-shadow: 0 10px 20px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.check-due-date {
  text-align: end;
}
.paginate-links.filteredNotes {
  list-style: none !important;
  user-select: none;
  text-decoration-line: none !important;
  margin-bottom: 18px;
  a {
    width: 20px;
    height: 25px;
    margin-right: 0;
    border-radius: 2px;
    background-color: white;
    box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
      0 3px 3px rgba(56, 56, 56, 0.23);
    color: #383838;
    padding: 5px 12px;
    cursor: pointer;
    text-decoration-line: none !important;
  }
  .approver-pointer {
    cursor: pointer;
  }
  a:hover {
    background-color: #ededed;
  }
  li.active a {
    font-weight: bold;
    color: #383838;
    background-color: rgba(211, 211, 211, 10%);
  }
  a.active {
    background-color: rgba(211, 211, 211, 10%);
  }
  li.next:before {
    content: " | ";
    margin-right: 13px;
    color: #ddd;
  }
  li.disabled a {
    color: #ccc;
    cursor: no-drop;
  }
  li {
    display: inline !important;
    margin: 1px;
    color: #383838 !important;
  }
}
.btn-group {
  position: absolute;
  top: 50%;
  left: 50%;
  -ms-transform: translate(-50%, -50%);
  transform: translate(-50%, -50%);
}
.scrollToChecklist {
  box-shadow: 0 5px 10px rgba(56, 56, 56, 0.19),
    0 1px 1px rgba(56, 56, 56, 0.23);
}
.risk-priorityLevel {
  border-radius: 5px;
  min-height: 33px;
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
  background-color: rgba(255, 255, 255, 1);
  font-weight: bold;
}
.risk-pL {
  // margin-right: 50px;
  font-size: large;
}
// Risk Matrix styling (Hexcodes are Bootstrap colors)
.risk-matrix {
  font-size: 0.85rem;
  border-radius: 4px;
  box-shadow: 0 5px 10px rgba(56, 56, 56, 0.19),
    0 1px 1px rgba(56, 56, 56, 0.23);
}
.risk-matrix-header {
  color: #5e6469;
  font-weight: bold;
  background-color: #efefef;
  background-image: linear-gradient(180deg, #efefef, #dfe1e2);
}
.vertical-head {
  transform: rotate(-90deg);
  position: absolute;
  top: 64%;
  left: 34%;
  width: 30%;
  font-weight: 500;
}
.gray {
  background-color: #f7f7f7;
}
.red {
  background-color: #d9534f;
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
.red1 {
  background-color: #d9534f;
}
.gray2 {
  background-color: #ededed;
}
.yellow1 {
  background-color: yellow;
  color: #383838;
  display: block;
}
.orange1 {
  background-color: #f0ad4e;
}
.green1 {
  background-color: rgb(92, 184, 92);
}
.green1,
.orange1,
.red1 {
  display: block;
  color: #fff;
}
.red,
.yellow,
.orange,
.green,
.gray3 {
  opacity: 0.44;
  min-height: 76px;
}
.gray2 {
  display: block;
  color: #383838;
}
.red:hover,
.yellow:hover,
.orange:hover,
.green:hover,
.gray2:hover,
.gray3:hover {
  opacity: 1;
  cursor: pointer;
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.reg-opacity {
  opacity: 1 !important;
  box-shadow: 0 5px 10px rgba(56, 56, 56, 0.19),
    0 1px 1px rgba(56, 56, 56, 0.23);
}
#riskName {
  padding: 4px;
  border-radius: 4px;
  background-color: #f8f9fa;
  border-color: #f8f9fa;
  border: 1px solid transparent;
}
.disabled {
  opacity: 0.6;
}
.error {
  font-size: 0.8rem;
}
.risk-approved-date {
  min-height: 32px;
  max-width: 225px;
  padding: 5px 40px 0 8px;
  border-radius: 5px;
  border: 1px solid #ced4da;
  font-size: 13px;
  text-align: left;
  color: #35495e;
  background-color: #fff;
}
.clearBtn {
  position: absolute;
  top: 5%;
  right: 1%;
}
.custom-tab {
  background-color: #fff;
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.display-length {
  border-radius: 0.15rem;
  margin-right: 12px;
}

.red-border {
  border: solid 0.5px red;
}
#roll_up {
  ::v-deep.el-collapse-item__header {
    float: right;
    padding: 1em;
    margin-top: -32px;
    color: #d9534f !important;
    border-bottom: none !important;
    background-color: #fafafa !important;
  }
}
.risk_matrix {
  ::v-deep.el-collapse-item__header {
    border-bottom: none !important;
    background-color: #fff !important;
  }
}
::v-deep .el-collapse {
  border-top: none !important;
  border-bottom: none !important;
}
::v-deep.el-collapse-item__content {
  padding-bottom: 0 !important;
}
::v-deep.el-collapse-item__header {
  background-color: #fafafa;
}
::v-deep.el-input__inner {
  text-transform: capitalize;
}
.inner-name-lowercase{
  ::v-deep.el-input__inner{
    text-transform: none !important;
  }
}
.fa-building {
  font-size: large !important;
  color: #383838 !important;
}
.error-list {
  list-style-type: circle;
  li {
    width: max-content;
  }
}
.text-danger {
  font-size: 13px;
}
.overflow-ellipsis {
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow-x: hidden;
}
.links-col {
  /* These are technically the same, but use both */
  overflow-wrap: break-word;
  word-wrap: break-word;

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
.no-text-decoration:link {
  text-decoration: none;
  color: #495057;
  text-decoration-color: none;
}
.no-text-decoration:active {
  text-decoration: none;
  color: #495057;
  text-decoration-color: none;
}
.no-text-decoration:visited {
  text-decoration: none;
  color: #495057;
  text-decoration-color: none;
}
.hover {
  background: transparent;
  border-radius: 0 !important;
}
.hover:hover {
  cursor: pointer;
  background-color: rgba(91, 192, 222, 0.3);
}
input.file-link {
  outline: 0 none;
}

.clearStageBtn {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.exampleTwo.el-steps,
.exampleTwo.el-steps--simple {
  border: 1px solid #dcdfe6;
  background: #fff;
}
.overSixSteps {
  ::v-deep.el-step__title {
    font-size: 11px !important;
    line-height: 23px !important;
    margin: 5px !important;
  }
}
a {
  color: #007bff;
}
a:hover {
  text-decoration: unset;
}
.text-smaller {
  font-size: smaller;
}
.update-card {
  background-color: #ededed;
  border-color: lightgray;
  border-left: 10px solid #5aaaff;
}

.tagsCol, .statesCol {  
  border: .5px solid lightgray;
}

.statesCol {
  border-top-left-radius: 4px;
  border-bottom-left-radius: 4px;
  border-top-right-radius: 0;
  border-bottom-right-radius: 0;
}

.tagsCol {
  background-color: #f8f9fa;
  border-top-right-radius: 4px;
  border-bottom-right-radius: 4px;
  border-top-left-radius: 0;
  border-bottom-left-radius: 0;

}
</style>
