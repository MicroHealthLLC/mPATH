<template>
  <div
  v-loading="!portfolioTaskLoaded"
  element-loading-text="Fetching Task data. Please wait..."
  :class="[!portfolioTaskLoaded ? 'vh100': '']"
  element-loading-spinner="el-icon-loading"
  element-loading-background="rgba(0, 0, 0, 0.8)"   
  >
   <form
      id="portfolio-task-form"
      @submit.prevent="saveTask"
      class="mx-auto portfolio-task-form"
      accept-charset="UTF-8"
      :class="{ _disabled: loading }"

    >
      <div class="mt-2 mx-4 d-flex align-items-center">
        <div>
          <h5 class="mb-0">
            <span style="font-size: 16px; margin-right: 2.5px"
              > <i class="fas fa-suitcase mb-1"></i>
            </span>
            <router-link v-if="DV_task"  :to="
                `/portfolio`
              ">{{
                  DV_task.facility_name
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
              >Tasks</router-link
            >
            <el-icon
              class="el-icon-arrow-right"
              style="font-size: 12px"
            ></el-icon>
            <span v-if="portfolioTaskLoaded && DV_task">{{ DV_task.text }}</span>
            <span v-else>...</span>
          </h5>
        </div>
       
        <div class="ml-auto d-flex" v-if="_isallowed('read')">  
          <button    
            v-if="_isallowed('write')"      
            class="btn btn-sm sticky-btn btn-primary text-nowrap mr-2"
            data-cy="task_save_btn"
          >
            Save Task
          </button>
          <button
            v-else
            disabled
            class="btn btn-sm sticky-btn btn-primary mr-2"
            data-cy="task_read_only_btn"
          >
            Read Only
          </button>
          <button
            class="btn btn-sm sticky-btn btn-outline-secondary"
            @click.prevent="cancelSave"
            data-cy="task_close_btn"
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
      <!-- fixed-form class covers entire tab form.  CSS properties can be found in app/assets/stylesheets/common.scss file -->
      <div class="formTitle fixed-form pt-1">
        <div v-if="errors.items.length > 0" class="text-danger mx-4">
          Please fill the required fields before submitting
          <ul class="error-list mx-4">
            <li
              v-for="(error, index) in errors.all()"
              :key="index"
              v-tooltip="{
                content: 'Field is located on Task Info',
                placement: 'left',
              }"
            >
              {{ error }}
            </li>
          </ul>
        </div>
      

        <!-- TASK INFO TAB #1 -->
        <div v-show="currentTab == 'tab1'" class="paperLookTab tab1">
          <div class="form-group pt-3 mx-4">
            <label class="font-md"
              >Task Name <span style="color: #dc3545">*</span></label
            >
            <div class="toggleWrapper float-right" :class="{'font-sm': isMapView}">

              <span class="statesCol p-1 mr-1">           
            <span
              class="watch_action clickable mx-2"
              @click.prevent.stop="toggleOngoing"
              data-cy="task_ongoing"
              v-tooltip="`Ongoing`" 
            >
              <span              
                v-show="DV_task.ongoing">
              <i class="fas fa-retweet text-success"></i>
              </span>
              <span              
                v-show="!DV_task.ongoing">
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
                v-show="DV_task.on_hold">
                <i class="fas fa-pause-circle mr-1 text-primary"></i>
              
              </span>
              <span
                v-show="!DV_task.on_hold">
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
                 v-show="DV_task.draft">
               <i class="fas fa-pencil-alt text-warning"></i>
              </span>
              <span               
                v-show="!DV_task.draft">
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
                  v-show="DV_task.watched" 
                  ><i class="fas fa-eye mr-1"></i
                ></span>
                <span 
                  v-show="!DV_task.watched" 
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
                v-show="DV_task.important">
               <i class="fas fa-star text-warning"></i>
              </span>
              <span 
                v-show="!DV_task.important">
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
                  v-show="DV_task.reportable">
                <i class="fas fa-presentation text-primary"></i>
                </span>
                <span 
                v-show="!DV_task.reportable">
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
              name="Task Name"
              v-validate="'required'"
              type="text"
              v-model="DV_task.text"
              placeholder="Task Name"
              :readonly="!_isallowed('write')"
              :class="{ error: errors.has('Task Name'), }"
              data-cy="task_name"
            />
            <div
              v-show="errors.has('Task Name')"
              class="text-danger"
              data-cy="task_name_error"
            >
              {{ errors.first("Task Name") }}
            </div>
          </div>
          <div class="form-group mx-4">
            <label class="font-md">Description</label>
            <el-input
              type="textarea"
              placeholder="Task brief description"
              v-model="DV_task.description"
              rows="4"
              :readonly="!_isallowed('write')"
              data-cy="task_description"
            />
          </div>

          <!-- Row begins -->
          <div class="d-flex mb-1 form-group">
            <div class="simple-select form-group w-33 ml-4">
              <label class="font-md"
                >Process Area <span style="color: #dc3545">*</span></label
              >
                <el-select
                v-model="selectedTaskType"              
                class="w-100"
                track-by="id"
                value-key="id" 
               :disabled="!_isallowed('write')"             
                data-cy="task_type"    
              :class="{ 'error': errors.has('Process Area') }"         
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
                data-cy="task_category_error"
              >
                {{ errors.first("Process Area") }}
              </div>
             
            </div>
          </div>

         <div class="mx-4 mt-2 mb-4" v-if="selectedTaskStage !== null">
          <div v-if="selectedTaskStage !== undefined">       
          <div style="position:relative"><label class="font-md mb-0">Stage</label>               
         <button  v-if="_isallowed('write')"  @click.prevent="clearStages" :disabled="fixedStage" class="btn btn-sm btn-danger font-sm float-right d-inline-block clearStageBtn">Clear Stages</button>  
            </div>    
          <el-steps 
            v-if="taskStagesSorted && taskStagesSorted.length >= 0"
            class="exampleOne mt-3" 
            finish-status="success"  
            :class="{'overSixSteps': taskStagesSorted.length >= 6 }" 
            :active="taskStagesSorted.findIndex(stage => stage.id == selectedTaskStage.id)"
            :disabled="!_isallowed('write') || fixedStage  && isKanbanView"
            v-model="selectedTaskStage"
            track-by="id" 
            value-key="id"
            >    
          <el-step
            v-for="item in taskStagesSorted"
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
            v-if="selectedTaskStage == null || selectedTaskStage == undefined"
          >
            <label class="font-md">Select Stage</label>
            <el-steps
               v-if="taskStagesSorted && taskStagesSorted.length >= 0"
              class="exampleOne"
              finish-status="success"
              :class="{ overSixSteps: taskStagesSorted.length >= 6 }"
              :disabled="!_isallowed('write') || !!fixedStage"
              v-model="selectedTaskStage"
              track-by="id"
              value-key="id"
            >
              <el-step
                v-for="item in taskStagesSorted"
                :key="item.id"
                :value="item"
                style="cursor:pointer"
                @click.native="selectedStage(item)"
                :title="item.name"
                description=""
              ></el-step>
         
            </el-steps>
          </div>

          <!-- Stages Row ends -->

          <div class="form-row mx-4">
            <div class="form-group col-md-6 pl-0">
              <span v-if="DV_task.ongoing">
              <label class="font-md"
                >Date Identified</label
              ></span>
               <span v-else>
              <label class="font-md"
                >Start Date <span style="color: #dc3545">*</span></label
              ></span>
              <div :class="{ 'error': errors.has('Start Date') }">
                <v2-date-picker
                  v-validate="{ required: !DV_task.ongoing }"
                  v-model="DV_task.start_date"
                  value-type="YYYY-MM-DD"
                  format="DD MMM YYYY"
                  placeholder="DD MM YYYY"
                  name="Start Date"
                  class="w-100 vue2-datepicker"
                  :disabled="!_isallowed('write')"
                  data-cy="task_start_date"
                />
              </div>
              <div
                v-show="errors.has('Start Date')"
                class="text-danger"
                data-cy="task_start_date_error"
              >
                {{ errors.first("Start Date") }}
              </div>
            </div>
            <div class="form-group col-md-6 pr-0">
              <span v-if="DV_task.ongoing ">           
               <label class="font-md"
                ><i class="fas fa-retweet text-success mr-1"></i>Date Closed</label
              ></span>
               <span v-else-if="DV_task.on_hold ">           
                <label class="font-md">
                Due Date <span><small class="text-danger">(Not required if Task is On Hold)</small></span>
                 </label
                  ></span>
              <span v-else>           
               <label class="font-md"
                >Due Date <span style="color: #dc3545">*</span></label
              ></span>
          
                <v2-date-picker
                  v-validate="{ required: !DV_task.ongoing && !DV_task.on_hold }"
                  v-model="DV_task.due_date"
                  value-type="YYYY-MM-DD"
                  format="DD MMM YYYY"
                  placeholder="DD MM YYYY"
                  name="Due Date"
                  class="w-100 vue2-datepicker"
                    :class="{
                      'error': errors.has('Due Date'),
                    }"
                   :disabled="
                    !_isallowed('write') ||
                      DV_task.start_date === '' ||
                      DV_task.start_date === null
                  "
                  :disabled-date="disabledDueDate"
                  data-cy="task_due_date"
                />
            
              <div
                v-show="errors.has('Due Date')"
                class="text-danger"
                data-cy="task_due_date_error"
              >
                {{ errors.first("Due Date") }}
              </div>
              
          
            <!-- <span v-else class="text-center font-italic"><i class="fas fa-retweet text-success mr-1"></i>
              THIS TASK IS ONGOING
            </span> -->
            </div>
               
          </div>

          <!-- closing div for tab1 -->
        </div>

        <div v-show="currentTab == 'tab2'" class="paperLookTab tab2">
          <div class="form-group mb-0 pt-3 d-flex w-100">
            <div class="form-group user-select ml-4 mr-1 w-100">
              <!-- 'Responsible' field was formally known as 'Assign Users' field -->
              <label class="font-md mb-0">Responsible</label>
              <el-select
                v-model="responsibleUsers"
                class="w-100"
                filterable
                clearable
                track-by="id"
                value-key="id"
                placeholder="Search and select Responsible User"      
                :disabled="!_isallowed('write')"         
                data-cy="task_owner"
              >
                <el-option
                  v-for="item in portfolioUsers"
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
                v-model="accountableTaskUsers"
                class="w-100"
                clearable
                track-by="id"
                value-key="id"
                placeholder="Search and select Accountable User"               
                filterable
               :disabled="!_isallowed('write')"
              >
                <el-option
                  v-for="item in portfolioUsers"
                  :value="item"
                  :key="item.id"
                  :label="item.name"
                >
                </el-option>
              </el-select>
            </div>
          </div>
          <div class="mt-0 d-flex w-100">
            <div class="ml-4 form-group w-100 mr-1">
              <label class="font-md mb-0">Consulted</label>
              <el-select
                v-model="consultedTaskUsers"
                class="w-100"
                track-by="id"
                value-key="id"
                :multiple="true"
                placeholder="Search and select Consulted Users"               
                filterable
               :disabled="!_isallowed('write')"
              >
                <el-option
                v-for="item in portfolioUsers"
                  :value="item"
                  :key="item.id"
                  :label="item.name"
                >
                </el-option>
              </el-select>
            </div>
            <div class="ml-1 form-group mr-4 w-100">
              <label class="font-md mb-0">Informed</label>
              <el-select
                v-model="informedTaskUsers"
                class="informed w-100"
                track-by="id"
                value-key="id"
                multiple
                :disabled="!_isallowed('write')"
                filterable
                placeholder="Search and select Informed Users"             
              >
                <el-option
                  v-for="item in portfolioUsers"
                  :value="item"
                  :key="item.id"
                  :label="item.name"
                >
                </el-option>
              </el-select>
            </div>
          </div>
        </div>

        <!-- CHECKLIST TAB #3-->

        <div v-show="currentTab == 'tab3'" class="paperLookTab tab3">
          <div v-show="!DV_task.ongoing" class="form-group pt-3 ml-4 mr-5">
            <label class="font-md mb-0">Progress (in %)</label>
            <span class="ml-3">
              <label class="font-sm mb-0 d-inline-flex align-items-center">
                <input
                  type="checkbox"
                  v-model="DV_task.auto_calculate"
                  :disabled="!_isallowed('write')"
                  :readonly="!_isallowed('write')"
                />
                <span>&nbsp;&nbsp;Auto Calculate Progress</span></label
              >
            </span>
            <el-slider
              v-model="DV_task.progress"
              :input="removeFromWatch()"  
              :disabled="!_isallowed('write') || DV_task.auto_calculate"
              :marks="{ 0: '0%', 25: '25%', 50: '50%', 75: '75%', 100: '100%' }"
              :format-tooltip="(value) => value + '%'"
              class="mx-2"
            ></el-slider>
          </div>

          <div class="form-group pt-3 mx-4">
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
                @change="(e) => handleEnd(e, DV_task.checklists)"
                :list="DV_task.checklists"
                :animation="100"
                ghost-class="ghost-card"
              >
                <div
                  v-for="(check, index) in DV_task.checklists"
                  :key="index"                
                  class="d-flex w-100 mb-3 drag"
                  v-if="!check._destroy && isMyCheck(check)"
                >
                  <div
                    class="form-control h-100 check-items pb-0"
                    style="background-color:#fafafa;position:relative"
                  >
                    <div class="row" style="width:97%">
                      <div class="col-8 justify-content-start">
                        <input
                          type="checkbox"
                          name="check"
                          :checked="check.checked"
                          @change="updateCheckItem($event, 'check', index)"
                          :key="`check_${index}`"
                          :disabled="!_isallowed('write') || !check.text.trim()"
                        />
                        <input
                          :value="check.text"
                          name="text"
                          @input="updateCheckItem($event, 'text', index)"
                          :key="`text_${index}`"
                          placeholder="Checkpoint name here"
                          type="text"
                          class="checklist-text pl-1"
                          maxlength="80"  
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
                        style="margin-left:-25px"
                      >
                        <v2-date-picker
                          v-model="check.due_date"
                          :value="check.due_date"
                          :disabled="!_isallowed('write') || !check.text"
                          @selected="updateCheckItem($event, 'due_date', index)"
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

                    <!-- Collpase section begins here -->
                    <el-collapse id="roll_up" style="background-color:#fafafa">
                      <el-collapse-item
                        title="Details"
                        name="1"
                        style="background-color:#fafafa"
                      >
                        <div
                          v-if="isMapView"
                          class="row justify-content-end pt-2 pb-5"
                          style="background-color:#fafafa;position:relative"
                        >
                          <div
                            class="d-flex col mb-0"
                            style="position:absolute"
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
                          style="background-color:#fafafa;position:inherit"
                        >
                          <div
                            class="simple-select d-flex form-group col mb-0"
                            style="position:absolute"
                          >
                            <div
                              class="d-flex w-100"
                              style="padding-left:6.1rem"
                            >
                              <span class="font-sm pt-2 pr-2"
                                >Assigned To:</span
                              >
                              <el-select
                                v-model="check.user"
                                class="w-75"
                                track-by="id"
                                clearable
                                value-key="id"
                                filterable
                                :disabled="!_isallowed('write') || !check.text"
                                placeholder="Search and select user"
                              >
                                <el-option
                                  v-for="item in portfolioUsers"
                                  :value="item"
                                  :key="item.id"
                                  :label="item.name"
                                >
                                </el-option>
                              </el-select>
                            </div>
                          </div>
                         
                        </div>

                        <!-- Start Checkbox Progress List -->
                        <!-- Create component to manage progress list -->
                        <div class="pt-5 vuetify-checkitem pb-3" style="background-color:#fafafa">
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
                            style="width:100%"
                            class="mt-1"
                            v-if="check.progress_lists.length > 0"
                          >
                            <thead>
                              <tr>
                                <th style="width:50%">Progress</th>
                                <th>Last Updated</th>
                                <th>By</th>
                                <th
                                  v-if="
                                    _isallowed('write') || _isallowed('delete')
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
                                      :class="{ 'red-border': !progress.user }"
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
                                    _isallowed('write') || _isallowed('delete')
                                  "
                                >
                                  <span
                                    class="pl-2"
                                    v-tooltip="`Save`"
                                    v-if="!progress.user"
                                    @click.prevent="saveTask"
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
          <!-- closing div for tab2 -->
        </div>
        

        <!-- FILES TAB # 4-->
        <div v-show="currentTab == 'tab4'" class="paperLookTab tab4">
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
                    class="input-group-text  d-inline clickable px-1 w-100 hover"
                    :class="{ 'btn-disabled': !file.uri }"
                    @click.prevent="downloadFile(file)"
                  >
                    <span><i class="far fa-file mr-1"></i></span>

                    <input
                      readonly
                      type="text"
                      style="border:none; cursor:pointer;background-color:transparent"
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
                    <span class="ml-2 clickable" @click.prevent="addFilesInput">
                      <i class="fas fa-plus-circle"></i>
                    </span>
                  </div>

                  <div
                    v-for="(file, index) in DV_task.task_files.slice().reverse()"
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
                        <i class="fas fa-link mr-1"></i></span
                      >{{ urlShortener(file.uri, 68) }}
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
          <!-- closing div for tab4 -->
        </div>

        <!-- RELATED TAB #5 -->
        <!-- <div v-show="currentTab == 'tab5'" class="paperLookTab tab5">
          <div class="row mx-3 mt-2">
          
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
          </div>
        </div> -->
        

        <!-- UPDATE TAB 6 -->
        <div v-show="currentTab == 'tab5'" class="paperLookTab tab5">
          <div class="form-group mx-4 paginated-updates">
            <label class="font-sm">Updates:</label>
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
        <!-- closing div for tab5 -->
      
    
      </div>

      <!-- TABBED OUT SECTION END HERE -->
  </form>  
    <div
      v-if="loading"
      class="load-spinner spinner-border text-dark"
      role="status"
    ></div>
 

    <RelatedTaskMenu
      :facilities="facilities"
      :facilityGroups="facilityGroups"
      :task="task"
      :relatedTasks="relatedTasks"
      :relatedIssues="relatedIssues"
      :relatedRisks="relatedRisks"
      @add-related-tasks="addRelatedTasks"
      @add-related-issues="addRelatedIssues"
      @add-related-risks="addRelatedRisks"
      ref="menu"
    >
    </RelatedTaskMenu>
  </div>

   
</template>

<script>
import axios from "axios";
import Draggable from "vuedraggable";
import FormTabs from "./../../shared/FormTabs";
import RelatedTaskMenu from "./../../shared/RelatedTaskMenu";
import humps from "humps";
import { mapGetters, mapMutations, mapActions } from "vuex";
import AttachmentInput from "./../../shared/attachment_input";
import * as Moment from "moment";
import { extendMoment } from "moment-range";
import {API_BASE_PATH} from './../../../mixins/utils'

const moment = extendMoment(Moment);
export default {
  name: "portfolioTaskForm",
  props: ["facility", "task", "title", "fixedStage"],
  components: {
    AttachmentInput,
    Draggable,
    FormTabs,
    RelatedTaskMenu,
  },
  data() {
    return {
      DV_task: this.INITIAL_TASK_STATE(),
      DV_facility: Object.assign({}, this.facility),
      paginate: ["filteredNotes"],
      destroyedFiles: [],
      editTimeLive: "",
      programId: this.$route.params.programId,
      selectedTaskType: null,
      selectedTaskStage: null,
      responsibleUsers: null,
      accountableTaskUsers: null,
      consultedTaskUsers: [],
      informedTaskUsers: [],
      relatedIssues: [],
      relatedTasks: [],
      relatedRisks: [],
      editToggle: false,
      _ismounted: false,
      showErrors: false,
      loading: true,
      movingSlot: "",
      currentTab: "tab1",
      tabs: [
        {
          label: "Task Info",
          key: "tab1",
          closable: false,
          form_fields: [
            "Task Name",
            "Description",
            "Start Date",
            "Process Area",
            "Stage",
            "Start Date",
            "Date Closed",
          ],
        },
        {
          label: "Assignments",
          key: "tab2",
          closable: false,
          form_fields: ["Responsible", "Accountable", "Consulted", "Informed"],
        },
        {
          label: "Checklist",
          key: "tab3",
          closable: false,
          form_fields: ["Checklists"],
        },
        {
          label: "Files & Links",
          key: "tab4",
          closable: false,
          form_fields: ["Files"],
        },
        // {
        //   label: "Related",
        //   key: "tab5",
        //   closable: false,
        //   disabled: true, 
        //   form_fields: ["Related Tasks", "Related Issues", "Related Risks"],
        // },
        {
          label: "Updates",
          key: "tab5",
          closable: false,
          form_fields: ["Progress", "Updates"],
        },
      ],
    };
  },
  updated() {
    if (this.fixedStage) {
      this.selectedTaskStage = this.fixedStage;
    }
  },
  mounted() {
    
    if (!_.isEmpty(this.task)) {
      this.loadTask(this.task);
    } else {
      this.loadTask(this.DV_task);
    }    
    this.loading = false;
    this._ismounted = true;
  },
  methods: {
    ...mapMutations(["setTaskForManager", "updateTasksHash", 'setPortfolioCategoriesFilter']),
    ...mapActions(["taskDeleted", "taskUpdated", "updateWatchedTasks", 'fetchPortfolioTask']),
    INITIAL_TASK_STATE() {
      return {
        text: "",
        start_date: "",
        due_date: "",
        facilityProjectId: this.$route.params.projectId,
        checklistDueDate: "",
        taskTypeId: "",
        taskArray: [],
        // programStageId: null,
        important: false,
        reportable: false,
        on_hold: false,
        draft: false,
        ongoing: false,
        responsible_user_ids: [],
        accountable_user_ids: [],
        consulted_user_ids: [],
        informed_user_ids: [],
         sub_task_ids: [],
        sub_risk_ids: [],
        sub_issue_ids: [],
        description: "",
        progress: 0,
        autoCalculate: true,
        task_files: [],
        checklists: [],
        notes: [],
      };
    },
    // log(e){
    //   console.log("taskSorted: " + e)
    // },
    //TODO: change the method name of isAllowed
    _isallowed(salut) {
        return this.checkPrivileges("portfolio_task_form", salut, this.$route)

      // var programId = this.$route.params.programId;
      // var projectId = this.$route.params.projectId
      // let fPrivilege = this.$projectPrivileges[programId][projectId]
      // let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      // let s = permissionHash[salut]
      // return  fPrivilege.tasks.includes(s); 
    },
    selectedStage(item) {     
      if (this._isallowed("write")) {
        this.selectedTaskStage = item; 
      }   
    },
    clearStages() {
      this.selectedTaskStage = null;
      this.taskStageId = "";
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
      this.DV_task.checklists.push({ text: "", checked: false });
    },
    scrollToUpdates() {
      this.$refs.addUpdates.scrollIntoView({
        behavior: "smooth",
        block: "end",
        inline: "nearest",
      });
      this.DV_task.notes.unshift({ body: "", user_id: "", guid: this.guid() });
    },
    handleMove(item) {
      this.movingSlot = item.relatedContext.component.$vnode.key;
      return true;
    },
    onChangeTab(tab) {
      this.currentTab = tab ? tab.key : "tab1";
    },
    handleEnd(e, checklists) {
      var cc = this.DV_task.checklists;
      var count = 0;
      for (var checklist of cc) {
        checklist.position = count;
        count++;
      }
    },
    editProgress() {
      this.editToggle = !this.editToggle;
      //this.editTimeLive = moment.format('DD MMM YYYY, h:mm a')
    },
    deleteTask() {
      this.$confirm(`Are you sure you want to delete "${this.DV_task.text}"?`, 'Confirm Delete', {
        confirmButtonText: 'Delete',
        cancelButtonText: 'Cancel',
        type: 'warning'
      }).then(() => {
        this.taskDeleted(this.DV_task);
        this.cancelSave();
      });
    },
    progressListTitleText(progress_list) {
      if (!progress_list.id) return;
      var date = moment(progress_list.created_at).format("MM/DD/YYYY");
      var time = moment(progress_list.created_at).format("hh:mm:ss a");
      return `${progress_list.user.full_name} at ${date} ${time} `;
    },
    // RACI USERS commented out out here.....Awaiting backend work
    loadTask(task) {
      this.DV_task = { ...this.DV_task, ..._.cloneDeep(task) };
      if (this.responsibleUsers) {
          this.responsibleUsers = _.filter(this.portfolioUsers, (u) =>
        this.DV_task.responsible_user_ids.includes(u.id)
      )[0];
      }
     if ( this.accountableTaskUsers){
      this.accountableTaskUsers = _.filter(this.portfolioUsers, (u) =>
        this.DV_task.accountable_user_ids.includes(u.id)
      )[0];
     }
      if (this.consultedTaskUsers){
       this.consultedTaskUsers = _.filter(this.portfolioUsers, (u) =>
        this.DV_task.consulted_user_ids.includes(u.id)
      );
       }    
       if ( this.informedTaskUsers){
       this.informedTaskUsers = _.filter(this.portfolioUsers, (u) =>
        this.DV_task.informed_user_ids.includes(u.id)
       );
       }     
      this.relatedIssues = _.filter(this.filteredIssues, (u) =>
        this.DV_task.sub_issue_ids.includes(u.id)
      );
      this.relatedTasks = _.filter(this.filteredTasks, (u) =>
        this.DV_task.sub_task_ids.includes(u.id)
      );
      this.relatedRisks = _.filter(this.filteredRisks, (u) =>
        this.DV_task.sub_risk_ids.includes(u.id)
      );
      this.selectedTaskType = this.taskTypes.find(
        (t) => t.id === this.DV_task.task_type_id
      );
      if (this.taskStages) {
      this.selectedTaskStage = this.taskStages[this.programId].find(
        (t) => t.id === this.DV_task.task_stage_id
      );
      }   
      this.selectedFacilityProject = this.getFacilityProjectOptions.find(
        (t) => t.id === this.DV_task.facility_project_id
      );
      if (this.DV_task.attach_files)
        this.addFile(this.DV_task.attach_files, false);
      this.$nextTick(() => {
        this.errors.clear();
        this.$validator.reset();
      });
    },
    addFile(files, append = true) {
      let _files = append ? [...this.DV_task.task_files] : [];
      for (let file of files) {
        file.guid = this.guid();
        _files.push(file);
      }
      this.DV_task.task_files = _files;
    },
    deleteFile(file) {
      if (!file) return;
      this.$confirm(`Are you sure you want to delete attachment?`, 'Confirm Delete', {
        confirmButtonText: 'Delete',
        cancelButtonText: 'Cancel',
        type: 'warning'
      }).then(() => {
        if (file.uri || file.link) {
          let index = this.DV_task.task_files.findIndex(
            (f) => f.guid === file.guid
          );
          if (file.id) {
            Vue.set(this.DV_task.task_files, index, { ...file, _destroy: true });
            this.destroyedFiles.push(file);
          }
          this.DV_task.task_files.splice(
            this.DV_task.task_files.findIndex((f) => f.guid === file.guid),
            1
          );
        } else if (file.name) {
          this.DV_task.task_files.splice(
            this.DV_task.task_files.findIndex((f) => f.guid === file.guid),
            1
          );
        }
      });
    },
    toggleWatched() {
      if(!this._isallowed('write')){
        return
      }      
       if (this.DV_task.progress == 100 && !this.DV_task.watched ) {
         this.$message({
            message: `Tasks at 100% progress cannot be placed On Watch status.`,
            type: "warning",
            showClose: true,
          });      
        return
      } 
      if (this.DV_task.watched) {
         this.$message({
            message: `${this.DV_task.text} has been removed from On Watch status.`,
            type: "warning",
            showClose: true,
          });
      } else {
         this.$message({
            message: `${this.DV_task.text} successfully placed On Watch status.`,
            type: "success",
            showClose: true,
          });
      }
      this.DV_task = { ...this.DV_task, watched: !this.DV_task.watched };
      this.saveTask()
      // this.updateWatchedTasks(this.DV_task);
    },
    removeFromWatch() {
      if(!this._isallowed('write')){
        return
      }
      if ( (this.DV_task.progress == 100) && (this.DV_task.watched == true) ) {         
        this.toggleWatched()     
      }
    },
    toggleImportant() {
      if(!this._isallowed('write')){
        return
      }
      this.DV_task = { ...this.DV_task, important: !this.DV_task.important };
    },
    toggleOnhold() {
      if(!this._isallowed('write')){
        return
      }
      this.DV_task = { ...this.DV_task, on_hold: !this.DV_task.on_hold };
      this.DV_task.due_date = '';
    },
    toggleDraft() {
      if(!this._isallowed('write')){
        return
      }
      this.DV_task = { ...this.DV_task, draft: !this.DV_task.draft };
    },
   toggleReportable() {
      if(!this._isallowed('write')){
        return
      }
      this.DV_task = { ...this.DV_task, reportable: !this.DV_task.reportable };
    },
    toggleOngoing() {
      if(!this._isallowed('write')){
        return
      }
      this.DV_task = { ...this.DV_task, ongoing: !this.DV_task.ongoing };
      this.DV_task.due_date = '';
    },
    cancelSave() {
     this.$emit("on-close-form");     
    //  this.setTaskForManager({ key: "task", value: null });
    },
    saveTask() {
      if (!this._isallowed("write")) return;
      this.$validator.validate().then((success) => {
        if (!success || this.loading) {
          this.showErrors = !success;
          return;
        }
        this.editToggle = !this.editToggle;
        this.loading = true;
        let formData = new FormData();
        formData.append("source", "portfolio_viewer");        
        formData.append("task[text]", this.DV_task.text);
        formData.append("task[due_date]", this.DV_task.due_date);
        formData.append("task[start_date]", this.DV_task.start_date);
        formData.append("task[task_type_id]", this.DV_task.task_type_id);
        formData.append("task[task_stage_id]", this.DV_task.task_stage_id);
        formData.append("task[progress]", this.DV_task.progress);
        formData.append("task[auto_calculate]", this.DV_task.auto_calculate);
        formData.append("task[description]", this.DV_task.description);
        formData.append("task[important]", this.DV_task.important);
        formData.append("task[reportable]", this.DV_task.reportable);
        formData.append("task[on_hold]", this.DV_task.on_hold);
        formData.append("task[draft]", this.DV_task.draft);
        formData.append("task[ongoing]", this.DV_task.ongoing);
        formData.append("task[watched]", this.DV_task.watched);
        formData.append(
          "task[destroy_file_ids]",
          _.map(this.destroyedFiles, "id")
        );
       //Responsible User Id
        //  formData.append('responsible_user_ids', this.DV_task.responsibleUserIds)
        if (
          this.DV_task.responsible_user_ids &&
          this.DV_task.responsible_user_ids.length
        ) {
          for (let u_id of this.DV_task.responsible_user_ids) {
            formData.append("responsible_user_ids[]", u_id);
          }
        } else {
          formData.append("responsible_user_ids[]", []);
        }
        // Accountable UserId
        if (
          this.DV_task.accountable_user_ids &&
          this.DV_task.accountable_user_ids.length
        ) {
          for (let u_id of this.DV_task.accountable_user_ids) {
            formData.append("accountable_user_ids[]", u_id);
          }
        } else {
          formData.append("accountable_user_ids[]", []);
        }
        // Consulted UserId

        if (this.DV_task.consulted_user_ids.length) {
          for (let u_id of this.DV_task.consulted_user_ids) {
            formData.append("consulted_user_ids[]", u_id);
          }
        } else {
          formData.append("consulted_user_ids[]", []);
        }
        // Informed UserId

        if (this.DV_task.informed_user_ids.length) {
          for (let u_id of this.DV_task.informed_user_ids) {
            formData.append("informed_user_ids[]", u_id);
          }
        } else {
          formData.append("informed_user_ids[]", []);
        }
        // RACI USERS ABOVE THIS LINE  Awaiting backend work
        // More RACI Users in Computed section below
        if (this.DV_task.sub_task_ids.length) {
          for (let u_id of this.DV_task.sub_task_ids) {
            formData.append("task[sub_task_ids][]", u_id);
          }
        } else {
          formData.append("task[sub_task_ids][]", []);
        }
        if (this.DV_task.sub_issue_ids.length) {
          for (let u_id of this.DV_task.sub_issue_ids) {
            formData.append("task[sub_issue_ids][]", u_id);
          }
        } else {
          formData.append("task[sub_issue_ids][]", []);
        }
        if (this.DV_task.sub_risk_ids.length) {
          for (let u_id of this.DV_task.sub_risk_ids) {
            formData.append("task[sub_risk_ids][]", u_id);
          }
        } else {
          formData.append("task[sub_risk_ids][]", []);
        }
        for (let i in this.DV_task.checklists) {
          let check = this.DV_task.checklists[i];
          if (!check.text && !check._destroy) continue;
          for (let key in check) {
            if (key === "user") key = "user_id";
            let value =
              key == "user_id"
                ? check.user
                  ? check.user.id
                  : null
                : check[key];
            // if (key === "dueDate"){
            //   key = "due_date"
            // }
            key = humps.decamelize(key);
            if (["created_at", "updated_at", "progress_lists"].includes(key))
              continue;
            formData.append(`task[checklists_attributes][${i}][${key}]`, value);
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
                  `task[checklists_attributes][${i}][progress_lists_attributes][${pi}][${pkey}]`,
                  pvalue
                );
              }
            }
          }
        }
        for (let i in this.DV_task.notes) {
          let note = this.DV_task.notes[i];
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
            formData.append(`task[notes_attributes][${i}][${key}]`, value);
          }
        }
        for (let file of this.DV_task.task_files) {
          if (file.id) continue;
          if (!file.link) {
            formData.append("task[task_files][]", file);
          } else if (file.link) {
            formData.append("file_links[]", file.name);
          }
        }
        let url = `${API_BASE_PATH}/programs/${this.$route.params.programId}/projects/${this.$route.params.projectId}/tasks.json`;
        let method = "POST";
        let callback = "task-created";
        if (this.task && this.task.id) {
          url = `${API_BASE_PATH}/programs/${this.$route.params.programId}/projects/${this.$route.params.projectId}/tasks/${this.task.id}.json`;
          method = "PUT";
          callback = "task-updated";
        }
        // var beforeSaveTask = this.task
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
           
            this.loadTask(response.data.task);
            // this.updateTasksHash({ task: response.data.task });

            // let task_i = this.taskArray.findIndex((t) => t.id == this.DV_task.id)
            // console.log(this.taskArray)
            // if (task_i > -1){
            //   Vue.set(this.taskArray, task_i, this.DV_task)
            // }else if (task_i == -1){
            //   this.taskArray.push(this.DV_task)
            // }
            // Vue.set(state.facilities, facility_i, facility)

            // updateTasksHash: (state, {task, action}) => {
            //   let facility_i = state.facilities.findIndex(f => f.id == task.facilityId)
            //   if (facility_i > -1) {
            //     let facility = Object.assign({}, state.facilities[facility_i])

            //   }
            // },

          
            if (response.status === 200) {
              this.$message({
                message: `${response.data.task.text} was saved successfully.`,
                type: "success",
                showClose: true,
              });
            }
            //Route to newly created task form page
           //this.fetchPortfolioTasks()
          //  this.$router.push(
          //       `/portfolio`
          //     );
          })
          // .catch((err) => {
          //   alert(err.response.data.error);
          // })
          .finally(() => {
            this.loading = false;
          });
      });
    },
    addProgressList(check) {
      if (check.progress_lists !== undefined || null) {
       var postion = check.progress_lists.length;
        check.progress_lists.push({ body: "", position: postion });
          this.editToggle = true;
      }   
    },
    addChecks() {
      var postion = this.DV_task.checklists.length;
      this.DV_task.checklists.push({
        text: "",
        checked: false,
        position: postion,
        progress_lists: [],
      });
    },
    addFilesInput() {
      this.DV_task.task_files.push({
        name: "",
        uri: "",
        link: true,
        guid: this.guid(),
      });
    },
    addNote() {
      this.DV_task.notes.unshift({ body: "", user_id: "", guid: this.guid() });
    },

    destroyNote(note) {
      this.$confirm(`Are you sure you want to delete note?`, 'Confirm Delete', {
        confirmButtonText: 'Delete',
        cancelButtonText: 'Cancel',
        type: 'warning'
      }).then(() => {
        let i = note.id
          ? this.DV_task.notes.findIndex((n) => n.id === note.id)
          : this.DV_task.notes.findIndex((n) => n.guid === note.guid);
        Vue.set(this.DV_task.notes, i, { ...note, _destroy: true });
      });
    },
    noteBy(note) {
      return note.user
        ? `${note.user.full_name} at ${new Date(
            note.created_at
          ).toLocaleString()}`
        : `${this.$currentUser.full_name} at (Now)`;
    },
    downloadFile(file) {
      let url = window.location.origin + file.uri;
      window.open(url, "_blank");
    },
    destroyProgressList(check, progress_list, index) {
      this.$confirm(`Are you sure you want to delete this Program list item?`, 'Confirm Delete', {
        confirmButtonText: 'Delete',
        cancelButtonText: 'Cancel',
        type: 'warning'
      }).then(() => {
        let i = progress_list.id
          ? check.progress_lists.findIndex((c) => c.id === progress_list.id)
          : index;
        Vue.set(check.progress_lists, i, { ...progress_list, _destroy: true });
        this.saveTask();
      });
    },
    destroyCheck(check, index) {
      this.$confirm(`Are you sure you want to delete this checklist item?`, 'Confirm Delete', {
        confirmButtonText: 'Delete',
        cancelButtonText: 'Cancel',
        type: 'warning'
      }).then(() => {
        let i = check.id
          ? this.DV_task.checklists.findIndex((c) => c.id === check.id)
          : index;
        Vue.set(this.DV_task.checklists, i, { ...check, _destroy: true });
        this.saveTask();
      });
    },
    disabledDueDate(date) {
      date.setHours(0, 0, 0, 0);
      const startDate = new Date(this.DV_task.start_date);
      startDate.setHours(48, 0, 0, 0);
      return date < startDate;
    },
    calculateProgress(checks = null) {
      try {
        if (!checks) checks = this.DV_task.checklists;
        let checked = _.filter(
          checks,
          (v) => !v._destroy && v.checked && v.text.trim()
        ).length;
        let total = _.filter(checks, (v) => !v._destroy && v.text.trim())
          .length;
        this.DV_task.progress = Number(
          ((checked / total) * 100 || 0).toFixed(2)
        );
      } catch (err) {
        this.DV_task.progress = 0;
      }
    },
    updateCheckItem(event, name, index) {
      if (name === "text") {
        this.DV_task.checklists[index].text = event.target.value;
        if (!event.target.value) this.DV_task.checklists[index].checked = false;
      } else if (name === "check" && this.DV_task.checklists[index].text) {
        this.DV_task.checklists[index].checked = event.target.checked;
      } else if (name === "due_date" && this.DV_task.checklists[index].text) {
        this.DV_task.checklists[index].due_date = event.target.value;
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
      return this.C_myTasks && check.id
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
      var due_date = new Date(this.DV_task.due_date);
      due_date.setDate(due_date.getDate() + 1);
      return date < new Date(this.DV_task.start_date) || date > due_date;
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
          type: 'warning'
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
          type: 'warning'
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
          type: 'warning'
        }).then(() => {
          this.relatedRisks.splice(
            this.relatedRisks.findIndex((risk) => risk.id == id),
            1
          );
        });
    },
  },
  computed: {
    ...mapGetters([
      "activeProjectUsers",
      'portfolioTaskLoaded',
      "portfolioUsers",
      "currentIssues",
      "currentProject",
      "currentRisks",
      'portfolioTasksLoaded',
      "currentTasks",
      'portfolioCategories',
      "fetchPortfolioTasks",
      'portfolioCategoriesFilter',
      "facilities",
      "portfolioTasks",
      "portfolioRisks",
      "portfolioTasks",
      'portfolioTaskStages',
      "facilityGroups",
      "getFacilityProjectOptions",
      "managerView",
      "myActionsFilter",
      "projectUsers",  
       ]),
    taskStages(){
          if(this.portfolioTaskStages){
            return this.portfolioTaskStages.program_stages
          }
       },
    taskStagesSorted() { 
      if (this.taskStages) {
        let stageObj =  [...this.taskStages[this.programId]]
        return stageObj.sort((a,b) => (a.percentage > b.percentage) ? 1 : -1);  
      }        
    },    
    taskTypes(){
      return this.portfolioCategories
    },
    readyToSave() {
      return (
        this.DV_task &&
        this.exists(this.DV_task.text) &&
        this.exists(this.DV_task.task_type_id) && 
        this.exists(this.DV_task.due_date)  &&  
        this.exists(this.DV_task.start_date)
      );
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
    isMapView() {
      return this.$route.name === "MapTaskForm";
    },
    isKanbanView() {
      return this.$route.name === "KanbanTaskForm";
    },
    isSheetsView() {
      return this.$route.name === "SheetTaskForm";
    },
    isCalendarView() {
      return this.$route.name === "CalendarTaskForm";
    },
    filteredChecks() {
      return _.filter(this.DV_task.checklists, (c) => !c._destroy);
    },
    filteredFiles() {
      return _.filter(this.DV_task.task_files, (f) => !f._destroy);
    },
    C_myTasks() {
      return _.map(this.myActionsFilter, "value").includes("tasks");
    },
    // filteredtProjects(){
    //    return _.filter(this.portfolioTasks.tasks, (t) => t.facility_project_id == this.DV_task.facility_project_id);
    // },
    // filterediProjects(){
    //    return _.filter(this.portfolioIssues, (t) => t.facility_project_id == this.DV_task.facility_project_id);
    // },
    // filteredrProjects(){
    //    return _.filter(this.portfolioRisks, (t) => t.facility_project_id == this.DV_task.facility_project_id);
    // },
    // filteredTasks() {
    //   return _.filter(this.filteredtProjects, (t) => t.id !== this.DV_task.id);
    // },
    filteredRisks() {
      return _.filter(this.filteredrProjects, (t) => t.id !== this.DV_task.id);
    },
    filteredIssues() {
      return this.filterediProjects;
    },
    filteredNotes() {
      return _.orderBy(
        _.filter(this.DV_task.notes, (n) => !n._destroy),
        "created_at",
        "desc"
      );
    },
    C_title() {
      return this._isallowed("write")
        ? this.task.id
          ? "Edit Task"
          : "Add Task"
        : "Task";
    },
  },
  watch: {
    task: {
      handler: function(value) {
        this.loadTask(this.task);
      },
    },
   portfolioTasksLoaded: {
     handler(){
      if(this.portfolioTasksLoaded){
      this.taskArray = this.portfolioTasks.tasks;  
     
       }
      }
   },
    "DV_task.start_date"(value) {
      if (this._ismounted && !value) this.DV_task.due_date = "";
    },
    // "DV_task.dueDate"(value) {
    //   if (this._ismounted && this.facility.dueDate) {
    //     if (moment(value).isAfter(this.facility.dueDate, "day")) {
    //       this.$alert(`${this.DV_task.text} Due Date is past ${this.facility.facilityName} Completion Date!`, `${this.DV_task.text} Due Date Warning`, {
    //       confirmButtonText: 'Ok',
    //       type: 'warning'
    //     });
    //     }
    //   }
    // },
    "DV_task.checklists": {
      handler: function(value) {
        if (this.DV_task.auto_calculate) this.calculateProgress(value);
      },
      deep: true,
    },
    "DV_task.auto_calculate"(value) {
      if (value) this.calculateProgress();
    },
    // RACI USERS HERE awaiting backend work
    responsibleUsers: {
      handler: function(value) {
        if (value) {
          this.DV_task.responsible_user_ids = _.uniq(
            _.map(_.flatten([value]), "id")
          );
        } else {
          this.DV_task.responsible_user_ids = null;
        }
      },
      deep: true,
    },
    accountableTaskUsers: {
      handler: function(value) {
        if (value) {
          this.DV_task.accountable_user_ids = _.uniq(
            _.map(_.flatten([value]), "id")
          );
        } else {
          this.DV_task.accountable_user_ids = null;
        }
      },
      deep: true,
    },
    consultedTaskUsers: {
      handler: function(value) {
        if (value) {
          this.DV_task.consulted_user_ids = _.uniq(_.map(value, "id"));
        } else {
          this.DV_task.consulted_user_ids = [];
        }
      },
      deep: true,
    },
    informedTaskUsers: {
      handler: function(value) {
        if (value) {
          this.DV_task.informed_user_ids = _.uniq(_.map(value, "id"));
        } else {
          this.DV_task.informed_user_ids = [];
        }
      },
      deep: true,
    },
    relatedIssues: {
      handler: function(value) {
        if (value) this.DV_task.sub_issue_ids = _.uniq(_.map(value, "id"));
      },
      deep: true,
    },
    relatedTasks: {
      handler: function(value) {
        if (value) this.DV_task.sub_task_ids = _.uniq(_.map(value, "id"));
      },
      deep: true,
    },
    relatedRisks: {
      handler: function(value) {
        if (value) this.DV_task.sub_risk_ids = _.uniq(_.map(value, "id"));
      },
      deep: true,
    },
    selectedTaskType: {
      handler: function(value) {
        this.DV_task.task_type_id = value ? value.id : null;
      },
      deep: true,
    },
    selectedTaskStage: {
      handler: function(value) {
        this.DV_task.task_stage_id = value ? value.id : null;
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

<style scoped lang="scss">
// .tasks-form {
// }

</style>
