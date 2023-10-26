<!-- NOTE: This file is used Global filter view in left side -->
<template>
<div class="portfolioFilter" v-if="!isContractView">
  <div id="filterbar" :style="filterBarStyle" v-click-outside="handleOutsideClick" data-cy="filter_bar">

    <div id="filter_bar" class="container shadow-sm" data-cy="filter_info">

      <!-- First row: Filter View Title/Header -->
      <div class="row my-2">
        <div class="col-md-12">
           <h5 class="d-inline"><i class="fas fa-sliders-h pr-2"></i>PORTFOLIO FILTERS</h5>
             <button class="btn btn-sm float-right d-inline-block font-sm btn-secondary py-0 ml-1 mb-1" @click.prevent="resetFilters();resetMapFilter()" data-cy="clear_filter"><i class="far fa-redo text-light clickable mr-1"></i>Reset</button>
            <!-- <button class="btn btn-sm btn-link float-right d-inline-block font-sm btn-success text-light py-0 mb-1" @click.prevent="saveFilters1" data-cy="save_filter"> <font-awesome-icon icon="save" class="text-light clickable mr-1" />Save Filter Settings</button> -->
         </div>
      </div>
   <el-tabs type="border-card">
      <el-tab-pane label="Portfolio">
      <div class="filter-border filter-sections px-3 pt-0">
         <!-- Next row for two columns that will contain Facilities-related menus -->
          <div class="row justify-content-between pb-2 mt-1">
            <div class="col-md-6">
              <div>
                <label class="font-sm mb-0">Programs, Project Groups & Projects</label>

                    <div id="app">
                   <treeselect  
                    placeholder="Search and select" 
                     @input="updateProgramFilterValue"
                    :value="C_portfolioNamesFilter"
                    :limit="3"
                    :maxHeight="200"
                    :match-keys= "['facility_project_id', 'id', 'label']"
                    :limitText="count => `...`"      
                    :multiple="true" 
                    clearable
                    :options="portfolioPrograms" 
                    v-model="C_portfolioNamesFilter"  
                    valueFormat="object" />   
                 </div>

              </div>

                <div class="mt-2">
                <label class="font-sm mb-0">Program % Progress Range</label>
                <div class="form-row">
                  <div class="form-group col pt-0 mb-0">
                    <input type="number" class="form-control" placeholder="Min." min="0" max="100" @input="onChangeProgress($event, {variable: 'program', type: 'min'})" :value="C_programProgress.min">
                  </div>
                  <div class="form-group col pt-0 mb-0">
                    <input type="number" class="form-control" placeholder="Max." min="0" max="100" @input="onChangeProgress($event, {variable: 'program', type: 'max'})" :value="C_programProgress.max">
                  </div>
                </div>
                <span class="font-sm text-danger ml-1" v-if="C_programProgress.error">{{C_programProgress.error}}</span>
                </div>
                <div class="">
                 <label class="font-sm mb-0">Project % Progress Range</label>
                <div class="form-row">
                  <div class="form-group col pt-0 mb-0">
                    <input type="number" class="form-control" placeholder="Min." min="0" max="100" @input="onChangeProgress($event, {variable: 'facility', type: 'min'})" :value="C_projectProgress.min">
                  </div>
                  <div class="form-group col pt-0 mb-0">
                    <input type="number" class="form-control" placeholder="Max." min="0" max="100" @input="onChangeProgress($event, {variable: 'facility', type: 'max'})" :value="C_projectProgress.max">
                  </div>
                </div>
                <span class="font-sm text-danger ml-1" v-if="C_projectProgress.error">{{C_projectProgress.error}}</span>

            </div>
               
       
              </div>
             
            <div class="col-md-6">
              <label class="font-sm mb-0">Project Statuses</label>
                <el-select 
                    v-model="C_portfolioStatusesFilter"                    
                    class="w-100" 
                    track-by="name" 
                    value-key="id"
                    data-cy="project_status"                
                    multiple
                    clearable
                    placeholder="Select Project Status"
                    >
                  <el-option 
                    v-for="item in portfolioStatuses"                                                     
                    :value="item"   
                    :key="item.id"
                    :label="item.name"                                                  
                    >
                  </el-option>
                </el-select> 

              <div>
                <!-- Available row for filter -->
              </div>
              <div class="mt-1">
                <label class="font-sm mb-0">Project Completion Date Range</label>
                <v2-date-picker v-model="C_facilityDueDateFilter" class="datepicker portFilter dp" placeholder="Select Date Range" @open="datePicker=true" range />
              </div>
              <!-- To Do: Convert to multiselect to match other filter toggles -->
              <!-- <div class="mt-1 d-flex flex-column">
                <label class="font-sm mb-0">Map Boundary Filter</label>
                <el-button @click="resetMapFilter" size="small" :disabled="mapFilterApplied" class="text-primary">Reset Map Filter <i class="el-icon-refresh"></i></el-button>
              </div> -->
            </div>
          </div>         
          <div class="row mt-3 pb-2">
              <div class="col-md-4" style="border-right:solid lightgray .8px">
                <div>
                <label class="font-sm mb-1">Process Areas</label>
                  <el-select 
                    v-model="C_categoryNameFilter"                    
                    class="w-100" 
                    track-by="name" 
                    value-key="id"
                    multiple
                    clearable
                    placeholder="Select Process Areas"
                  >
                  <el-option 
                    v-for="item in C_categories"                                                     
                    :value="item"   
                    :key="item"
                    :label="item"                                                  
                    >
                  </el-option>
                  </el-select>      
               </div>              
               <div>
                <label class="font-sm mb-0">Action Users</label>
                <el-select 
                  v-model="C_portfolioUsersFilter"                    
                  class="w-100" 
                  track-by="id" 
                  value-key="id" 
                  filterable                 
                  data-cy="task_category"       
                  multiple
                  clearable
                  placeholder="Search and select names"
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
              <div class="col-md-4" style="border-right:solid lightgray .8px">
                <div >

                 <!-- <label class="font-sm mb-0">Assignments</label>
                 <el-select 
                  v-model="C_myAssignmentsFilter"                   
                  class="w-100" 
                  track-by="name" 
                  value-key="id" 
                  filterable                 
                  data-cy="task_category"       
                  multiple                                                                                                                                                         
                  placeholder="Select Option"
                  >
                <el-option 
                  v-for="item in getMyAssignmentsFilterOptions"                                                     
                  :value="item"   
                  :key="item.id"
                  :label="item.name"                                                  
                  >
                </el-option>
              </el-select>  -->

                  <!-- Reference for Dropdown with multiple category labels (Do not delete)
                <label class="font-sm mb-0">Flags</label>
                 <el-select 
                  v-model="C_advancedFilter"                   
                  class="w-100" 
                  track-by="name" 
                  value-key="id" 
                  filterable                 
                  data-cy="task_category"       
                  multiple                                                                                                                                                         
                  placeholder="Filter by Flags"
                  >
                  <el-option-group
                    v-for="group in getAdvancedFilterOptions"
                    :key="group.label"
                    :label="group.label">
                <el-option 
                  v-for="item in group.options"                                                     
                  :value="item"   
                  :key="item.id"
                  :label="item.name"  
                                                                        
                  >
                </el-option>
                  </el-option-group>
              </el-select>  -->
              </div>
              <div>
                <label class="font-sm mb-0 pb-1">Action % Progress Range</label>
                <div class="form-row">
                  <div class="form-group col pt-0 mb-0">
                    <input type="number" class="form-control" placeholder="Min." min="0" max="100" @input="onChangeProgress($event, {variable: 'taskIssue', type: 'min'})" :value="C_taskIssueProgress.min">
                  </div>
                  <div class="form-group col pt-0 mb-0">
                    <input type="number" class="form-control" placeholder="Max." min="0" max="100" @input="onChangeProgress($event, {variable: 'taskIssue', type: 'max'})" :value="C_taskIssueProgress.max">
                  </div>
                </div>
                  <span class="font-sm text-danger ml-1" v-if="C_taskIssueProgress.error">{{C_taskIssueProgress.error}}</span>
              </div> 
             </div>
              <div class="col-md-4">
                <div>
              <label class="font-sm mb-0">Action Due Date Range</label>
              <v2-date-picker v-model="C_taskIssueDueDateFilter" placeholder="Select Date Range" class="datepicker portFilter" @open="datePicker=true" range />
            </div>
            <div>
              <label class="font-sm mb-0">Updates Date Range</label>
              <v2-date-picker v-model="C_noteDateFilter" class="datepicker portFilter" placeholder="Select Date Range" @open="datePicker=true" range />
            </div>
              </div>
          </div>
      
      </div>

 
      </el-tab-pane>

      <el-tab-pane label="Tasks, Issues, Risks, Lessons">
  <!-- Put this top row/section into two tabs: Projects \ Favorites -->
        <div class="filter-sections filter-border px-3 pt-1 pb-2 my-3">
        <div class="row pt-3 pb-2" >
          <div class="col-md-4" style="border-right:solid lightgray .8px">
            <h5 class="mb-0">Tasks</h5>
            <div>
              <label class="font-sm mb-0">Task Stages</label>
               <el-select 
                  v-model="C_portfolioTaskStageFilter"                    
                  class="w-100" 
                  track-by="name" 
                  value-key="id"                  
                  data-cy="task_stage"                     
                  multiple
                  clearable
                  placeholder="Select Task Stage"
                  >
                <el-option 
                  v-for="item in portfolioTaskStages.all_stages"                                                               
                  :value="item"   
                  :key="item.id"
                  :label="item.name"                                                  
                  >
                </el-option>
              </el-select> 
            </div>
          </div>
          <div class="col-md-4" style="border-right:solid lightgray .8px">
           <h5 class="mb-0">Issues</h5>
            <div>
              <label class="font-sm mb-0">Issue Stages</label>
              <el-select 
                  v-model="C_portfolioIssueStageFilter"                    
                  class="w-100" 
                  track-by="name" 
                  value-key="id"                  
                  data-cy="issue_stage"            
                  multiple
                  clearable
                  placeholder="Select Issue Stage"
                  >
                <el-option 
                  v-for="item in portfolioIssueStages.all_stages"                                                                       
                  :value="item"   
                  :key="item.id"
                  :label="item.name"                                                  
                  >
                </el-option>
              </el-select> 
          
            </div>
            <div>
              <label class="font-sm mb-0">Issue Types</label>
              <el-select 
                  v-model=" C_portfolioIssueTypesFilter"                    
                  class="w-100" 
                  track-by="name" 
                  value-key="id"                  
                  data-cy="issue_type"            
                  multiple
                  clearable
                  placeholder="Select Issue Type"
                  >
                <el-option 
                  v-for="item in portfolioIssueTypes"                                                     
                  :value="item"   
                  :key="item.id"
                  :label="item.name"                                                  
                  >
                </el-option>
              </el-select>            
            </div>

            <div>
              <label class="font-sm mb-0">Issue Severities</label>
              <el-select 
                  v-model="C_portfolioIssueSeverityFilter"                    
                  class="w-100" 
                  track-by="name" 
                  value-key="id"                  
                  data-cy="issue_stage"            
                  multiple                                                                                                                                                         
                  clearable
                  placeholder="Select Issue Severity"
                  >
                <el-option 
                  v-for="item in portfolioIssueSeverities"                                                     
                  :value="item"   
                  :key="item.id"
                  :label="item.name"                                                  
                  >
                </el-option>
              </el-select>             
            </div>
          </div>

          <div class="col-md-4">
            <h5 class="mb-0 pt-1">Risks</h5>
            <div>
              <label class="font-sm mb-0">Risk Stages</label>
                <el-select 
                  v-model="C_portfolioRiskStageFilter"                    
                  class="w-100" 
                  track-by="name" 
                  value-key="id"                  
                  data-cy="issue_stage"            
                  multiple                                                                                                                                                         
                  clearable
                  placeholder="Select Risk Stage"
                  >
                 <el-option 
                  v-for="item in portfolioRiskStages.all_stages"                                                                       
                  :value="item"   
                  :key="item.id"
                  :label="item.name"                                                  
                  >
                </el-option>
              </el-select>               
              <label class="font-sm mb-0">Risk Approaches</label>
              <el-select 
                  v-model="C_riskApproachFilter"                   
                  class="w-100" 
                  track-by="name" 
                  value-key="id"                  
                  data-cy="risk_stage"           
                  multiple                                                                                                                                                         
                  clearable
                  placeholder="Select Risk Approach"
                  >
                <el-option 
                  v-for="item in portfolioRiskApproaches"                                                     
                  :value="item"   
                  :key="item.id"
                  :label="item.name"                                                  
                  >
                </el-option>
              </el-select> 
              <label class="font-sm mb-0">Risk Priority Levels</label>
               <el-select 
                  v-model="C_riskPriorityLevelFilter"          
                  class="w-100" 
                  track-by="name" 
                  value-key="id"                  
                  data-cy="risk_stage"           
                  multiple                                                                                                                                                         
                  clearable
                  placeholder="Select Risk Priority Level"
                  >
                <el-option 
                  v-for="item in portfolioRiskPriorities"  
                                                            
                  :value="item"   
                  :key="item.id"
                  :label="item.name"                                                  
                  >
                </el-option>
              </el-select> 
            </div>             
          </div>
        </div>
        <div class="row pt-3 pb-2">
          <div class="col-md-4" style="border-right:solid lightgray .8px">
            <h5 class="mb-0">Lessons</h5>
            <div>
              <label class="font-sm mb-0">Lesson Stages</label>
               <el-select
                  v-model="C_portfolioLessonStageFilter"
                  class="w-100"
                  track-by="name"
                  value-key="id"
                  data-cy="lesson_stage"
                  multiple
                  clearable
                  placeholder="Select Lesson Stage"
                  >
                <el-option
                  v-for="item in portfolioLessonStages.all_stages"
                  :value="item"
                  :key="item.id"
                  :label="item.name"
                  >
                </el-option>
              </el-select>
            </div>
          </div>
        </div>
      </div> 

      </el-tab-pane>   

      <el-tab-pane label="Favorites (Coming Soon)" disabled>
          <div class="fav-filter px-3 pb-1 pt-0 mt-3">
        <div class="row mb-1">
          <div class="col-md-12">
            <h5 class="my-1">Favorites</h5>
          </div>
        </div>

        <!-- FAVORITE FILTERS SECTION -->
        <div class="row justify-content-between pb-2">
          <div class="col-md-5" style="border-right:solid lightgray .8px">
            <div>
                <el-select 
                  v-model="C_favoriteFilterSelectModel"                    
                  class="w-100" 
                  track-by="name" 
                  filterable
                  value-key="id"
                  placeholder="Search and select Favorites"
                >
                  <el-option 
                    v-for="item in C_favoriteFilterSelectOptions"                                                     
                    :value="item"   
                    :key="item.id"
                    :label="item.name"                                                  
                    >
                  </el-option>
                </el-select>
              
            </div>
            <div class="mt-2">
              <label class="font-sm mb-0">Favorites Filter Name</label>
              <input type="text" class="form-control" placeholder="Enter Name" v-model="C_favoriteFilter.name">             
              <!-- <button class="btn btn-sm btn-link float-right d-inline-block font-sm btn-danger text-light py-0 ml-1 mb-1" @click.prevent="resetFilters" data-cy="clear_filter"><font-awesome-icon icon="redo" class="text-light clickable mr-1" />Reset</button> -->
            </div>
          </div>
            <div class="col-md-7">              
             <div class="btn-group-sm text-center">  
              <button
            
                class="btn btn-sm font-sm btn-success text-light"
                @click.prevent="saveFavoriteFilters" 
                data-cy="save_favorite_filter"> 
               <i class="fas fa-save text-light clickable mr-1"></i>
                Save to Favorites
              </button>            
              <button
                class="btn btn-sm font-sm btn-danger text-light" 
                @click.prevent="onClearFilter" data-cy="clear_filter">
                <i class="far fa-trash-alt text-light mr-1"></i>
                Remove
              </button>   
               <button 
                class="btn btn-sm font-sm btn-light" >
                Shared
                <input type="checkbox" style="" v-model="C_favoriteFilter.shared">              
              </button>                      
             </div>
          </div>
        </div>
       </div>
      </el-tab-pane>
      
    </el-tabs>    
   
    </div>
    <div class="knocker" @click.prevent="toggleFilters" data-cy="advanced_filter">
        <button class="btn btn-sm ml-0 knocker-btn text-light p-1"><small><span class="pr-1"><i class="fas fa-sliders-h"></i></span>PORTFOLIO  FILTERS</small></button>
    </div>
  </div>
</div>
</template>
<script>
import { mapActions, mapGetters, mapMutations } from 'vuex'
import * as XLSX from "xlsx/xlsx";
import 'vue2-datepicker/index.css'
 Vue.component('v2-date-picker', DatePicker)
 import DatePicker from 'vue2-datepicker'
 Vue.component('treeselect', VueTreeselect.Treeselect)

export default {
  name: 'PortfolioFilterSidebar',
  data() {
    return {
      hasFilterAccess: true,
      isLoading: false,
      taskArray:[],
      activeName: 'first',
      exporting: false,
      // showFilters: false,
      datePicker: false,
      favoriteFilterData: {id: null, name: null, shared: false},
      favoriteFilterOptions: [],
      myActions: [
        { name: 'My Tasks', value: 'tasks' },
        { name: 'My Issues', value: 'issues' },
        { name: 'My Notes', value: 'notes' }
      ],
      onWatch: [
        { name: 'On Watch Tasks', value: 'tasks' },
        { name: 'On Watch Issues', value: 'issues' }
      ],
      mapFilterSet: false
    }
  },
  mounted() {
    // this.resetFilters()
    // this.fetchPortfolioPrograms()
    // this.fetchPortfolioUsers()
    // this.fetchPortfolioStatuses()
    // this.fetchPortfolioRiskStages()
    // this.fetchPortfolioIssueStages()
    // this.fetchPortfolioIssueTypes()
    // this.fetchPortfolioIssueSeverities()
    // this.fetchPortfolioRiskApproaches()
    // this.fetchPortfolioRiskPriorities()
    // // this.fetchFilters()
  },
  computed: {
    ...mapGetters([      
      'getTaskIssueUserFilter',
      'getTaskIssueProgressStatusFilter',
      'getMyAssignmentsFilter',
      'getMyAssignmentsFilterOptions',
      'getShowAdvancedFilter',
      'taskTypes',
      'portfolioTasksLoaded',
      'taskStages',
      'taskTypeFilter',
      'taskStageFilter',
      'taskUserFilter',
      'riskStages',
      'riskStageFilter',
      'getRiskApproachFilterOptions',
      'getRiskApproachFilter',
      'getRiskPriorityLevelFilter',
      'getRiskPriorityLevelFilterOptions',
      'issueSeverities',
      'issueTypes',
      'issueStages',
      'issueStageFilter',
      'issueUserFilter',
      'issueTypeFilter',
      'issueSeverityFilter',

      'facilityGroupFilter',
      'facilityNameFilter',
      'facilityProgressFilter',
      'programProgressFilter',
      'facilityDueDateFilter',
      'noteDateFilter',
      'taskIssueDueDateFilter',
      'taskIssueProgressFilter',
      'projects',
      'currentProject',
      'activeProjectUsers',
      'activePortfolioUsers',
      'portfolioTasks',
      'statuses',
      'getTaskIssueOverdueOptions',
      'getShowAdvancedFilter',
      'taskIssueOverdueFilter',
      'activeFacilityGroups',
      'unFilterFacilities',
      'filterFacilitiesWithActiveFacilityGroups',
      'ganttData',
      'myActionsFilter',
      'onWatchFilter',
      'progressFilter',
      'viewPermit',
      'getMapZoomFilter',
      'getUnfilteredFacilities',
      // START PORTFOLIO VIEWER FILTERS HERE.  DELETE ALL GETTERS ABOVE IF NOT USED
      'portfolioPrograms', 
      'portfolioUsers', 
      'portfolioIssueTypes',
      'portfolioIssueTypesFilter',
      'portfolioStatuses',
      'portfolioTaskStages',
      'portfolioIssueStages',
      'portfolioRiskStages',
      'portfolioLessonStages',
      'portfolioTaskStagesFilter',
      'portfolioIssueStagesFilter',
      'portfolioRiskStagesFilter',
      'portfolioLessonStagesFilter',
      'portfolioIssueSeverities',
      'portfolioIssueSeveritiesFilter',
      'portfolioNameFilter',
      'portfolioUsersFilter',
      'portfolioCategoriesFilter',
      'portfolioStatusesFilter',
      'portfolioRiskApproachesFilter',
      'portfolioRiskApproaches',
      'portfolioRiskPrioritiesFilter',
      'portfolioRiskPriorities',
    ]),
    // hasAdminAccess() {
    //   return salut =>  this.favoriteFilterData.user_id == this.$currentUser.id || !this.favoriteFilterData.id
    // },
    C_favoriteFilterSelectModel: {
      get() {
        return this.favoriteFilterData
      },
      set(value) {
        if(!value.id){
          this.favoriteFilterData = {id: null, name: null, shared: false}  
        }else{
          this.favoriteFilterData = value  
        }
        
        this.loadFavoriteFilter(this.favoriteFilterData)
        // if(!this.favoriteFilterData.id){
        //   this.resetFilters()
        // }else{
        //   this.loadFavoriteFilter(this.favoriteFilterData)
        // }
        
      }
    },
    C_favoriteFilterSelectOptions: {
      get() {
        let i = this.favoriteFilterOptions.findIndex(n => n.id === null)
        if(i == -1){
          this.favoriteFilterOptions.unshift({id: null, name: "New Filter", shared: false})
        }
        return this.favoriteFilterOptions
      },
      set(value) {
        this.favoriteFilterOptions = value
      }
    },
    C_favoriteFilter: {
      get() {
        return this.favoriteFilterData
      },
      set(value) {
        this.favoriteFilterData.name = value
      }
    },
    C_riskPriorityLevelFilter: {
      get() {
        return this.portfolioRiskPrioritiesFilter
      },
      set(value) {
        this.setPortfolioRiskPrioritiesFilter(value)
      }
    },

    C_riskApproachFilter: {
      get() {
        return this.portfolioRiskApproachesFilter
      },
      set(value) {
        this.setPortfolioRiskApproachesFilter(value)
      }
    }, 
   C_taskIssueProgress: {
      get() {
        return this.progressFilter.taskIssue
      },
    },
    C_myAssignmentsFilter: {
      get() {
        // Note: This code will be useful if want active as default select and never want advanced filter blank
        // if (this.getAdvancedFilter.length == 0) {
        //   // return [{ id: 'active', name: 'Active' }]
        //   this.setAdvancedFilter([{id: 'active', name: 'Active', value: 'active', filterCategoryId: 'progressStatusFilter', filterCategoryName: 'Progress Status'}])
        //   return this.getAdvancedFilter
        // }else{
        //   return this.getAdvancedFilter
        // }
        return this.getMyAssignmentsFilter
      },
      set(value) {
        if (!value) {
          this.setMyAssignmentsFilter([])
        } else {
          this.setMyAssignmentsFilter(value)
        }
      }
    },
    enableExport() {
      return this.filterFacilitiesWithActiveFacilityGroups.length > 0
    },
    C_activeFacilityGroups() {
      // What if no project is selected e.g. URL http://localhost:3000/programs/1/map
      let id = Number(this.$route.params.projectId)
      return this.activeFacilityGroups(id)
    },
    C_activeProjectNames() {
      return this.getUnfilteredFacilities
    },
    C_projectStatusFilter: {
      get() {
        return this.projectStatusFilter
      },
      set(value) {
        this.setProjectStatusFilter(value)
      }
    },
    C_taskIssueOverdueFilter: {
      get() {
        return this.taskIssueOverdueFilter
      },
      set(value) {
        this.setTaskIssueOverdueFilter(value)
      }
    },

    C_riskStageFilter: {
      get() {
        return this.riskStageFilter
      },
      set(value) {
        this.setRiskStageFilter(value)
      }
    },
    C_categories() {
      let category = this.taskArray 
      return [
        ...new Set(
          category
            .filter((item) => item.category != null)
            .map((item) => item.category)
        ),
      ];
    },
     C_categoryNameFilter: {
      get() {
        return this.portfolioCategoriesFilter
      },
      set(value) {
        // console.log(value)
        this.setPortfolioCategoriesFilter(value)
      }
    },
    C_taskTypeFilter: {
      get() {
        return this.taskTypeFilter
      },
      set(value) {
        this.setTaskTypeFilter(value)
      }
    },
    C_portfolioTaskStageFilter: {
      get() {
        return this.portfolioTaskStagesFilter
      },
      set(value) {
        this.setPortfolioTaskStagesFilter(value)
      }
    },
    C_portfolioIssueStageFilter: {
      get() {
        return this.portfolioIssueStagesFilter
      },
      set(value) {
        this.setPortfolioIssueStagesFilter(value)
      }
    },
     C_portfolioIssueSeverityFilter: {
      get() {
        return this.portfolioIssueSeveritiesFilter
      },
      set(value) {
        this.setPortfolioIssueSeveritiesFilter(value)
      }
    },
    C_portfolioRiskStageFilter: {
      get() {
        return this.portfolioRiskStagesFilter
      },
      set(value) {
        this.setPortfolioRiskStagesFilter(value)
      }
    },
    C_portfolioIssueTypesFilter: {
      get() {
        return this.portfolioIssueTypesFilter
      },
      set(value) {
        this.setPortfolioIssueTypesFilter(value)
      }
    },
    C_portfolioLessonStageFilter: {
      get() {
        return this.portfolioLessonStagesFilter
      },
      set(value) {
        this.setPortfolioLessonStagesFilter(value)
      }
    },
    C_facilityGroupFilter: {
      get() {
        return this.facilityGroupFilter
      },
      set(value) {
        this.setFacilityGroupFilter(value)
      }
    },
    C_portfolioNamesFilter: {
      get() {
        return this.portfolioNameFilter
      },
      set(value) {
        this.setPortfolioNameFilter(value)
      }
    },
     C_portfolioUsersFilter: {
      get() {
        return this.portfolioUsersFilter
      },
      set(value) {
        this.setPortfolioUsersFilter(value)
      }
    },
     C_portfolioStatusesFilter: {
      get() {
        return this.portfolioStatusesFilter
      },
      set(value) {
        this.setPortfolioStatusesFilter(value)
      }
    },
    C_facilityDueDateFilter: {
      get() {
        if (!this.facilityDueDateFilter) return this.facilityDueDateFilter
        return this.facilityDueDateFilter.map(d => d ? new Date(d) : d)
      },
      set(value) {
        this.setFacilityDueDateFilter(value)
      }
    },
    C_noteDateFilter: {
      get() {
        if (!this.noteDateFilter) return this.noteDateFilter
        return this.noteDateFilter.map(d => d ? new Date(d) : d)
      },
      set(value) {
        this.setNoteDateFilter(value)
      }
    },
    C_taskIssueDueDateFilter: {
      get() {
        if (!this.taskIssueDueDateFilter) return this.taskIssueDueDateFilter
        return this.taskIssueDueDateFilter.map(d => d ? new Date(d) : d)
      },
      set(value) {
        this.setTaskIssueDueDateFilter(value)
      }
    }, 
  
    C_myActionsFilter: {
      get() {
        return this.myActionsFilter
      },
      set(value) {
        value = value ? value : []
        this.setMyActionsFilter(value)
      }
    },
    C_onWatchFilter: {
      get() {
        return this.onWatchFilter
      },
      set(value) {
        value = value ? value : []
        this.setOnWatchFilter(value)
      }
    },
    C_projectProgress: {
      get() {
        return this.progressFilter.facility
      }
    },
    C_programProgress: {
      get() {
        return this.progressFilter.program
      }
    },
    filterBarStyle() {
      if (this.getShowAdvancedFilter) return {}
      return {
        transform: 'translateX(-685px)'
      }
    },
    isMapView() {
      return this.$route.name === 'ProjectMapView'
    },
    isGanttView() {
      return this.$route.name === 'ProjectGanttChart'
    },
    mapFilterApplied() {
      return this.getMapZoomFilter.length === this.getUnfilteredFacilities.length || !this.mapFilterSet
    },
    isContractView() {
     return this.$route.name.includes("Contract") || this.$route.name.includes("Vehicle")
    },
  },
  methods: {
    ...mapActions([
     'fetchPortfolioPrograms',
     'fetchPortfolioUsers',
     'fetchPortfolioStatuses',
     'fetchPortfolioTaskStages',
     'fetchPortfolioIssueStages',
     'fetchPortfolioRiskStages',
     'fetchPortfolioLessonStages',
     'fetchPortfolioIssueTypes',
     'fetchPortfolioIssueSeverities',
     'fetchPortfolioRiskPriorities',
     'fetchPortfolioRiskApproaches'
    ]),
    ...mapMutations([
      'setTaskIssueUserFilter',     
      'setTaskIssueProgressStatusFilter',
      'setTaskIssueProgressFilter',
      'setAdvancedFilter',
      'updateMapFilters',
      'setShowAdvancedFilter',
      'setTaskIssueOverdueFilter',
      'setProjectStatusFilter',
      'setTaskTypeFilter',
      'setFacilityGroupFilter',
      'setFacilityNameFilter',
      'setFacilityProgressFilter',
      'setProgramProgressFilter',
      'setFacilityDueDateFilter',
      'setNoteDateFilter',
      'setTaskIssueDueDateFilter',
      'setIssueTypeFilter',
      'setIssueSeverityFilter',
      'setMyActionsFilter',
      'setOnWatchFilter',
      'setMapFilters',
      'setPortfolioCategoriesFilter',
      'setMyAssignmentsFilter',
      'setTaskUserFilter',
      'setIssueUserFilter',
      'setProgressFilters',
      'clearProgressFilters',
      'setTaskStageFilter',
      'setIssueStageFilter',
      'setRiskStageFilter',
      'setRiskApproachFilter',
      'setRiskPriorityLevelFilter',
      'setShowAdvancedFilter',
      'setTasksPerPageFilter',
      'setRisksPerPageFilter',
      'setIssuesPerPageFilter',
      'setMembersPerPageFilter',
      'setFacilities',
      'setMapZoomFilter',
      // BEGIN PORTFOLIO VIEWER FILTERS. DELETE ALL SETTERS ABOVE IF NOT NEEDED
      'setPortfolioNameFilter',
      'setPortfolioUsers',
      'setPortfolioUsersFilter',
      'setPortfolioStatusesFilter',
      'setPortfolioTaskStages',
      'setPortfolioTaskStagesFilter',
      'setPortfolioIssueStages',
      'setPortfolioIssueStagesFilter',
      'setPortfolioRiskStages',
      'setPortfolioRiskStagesFilter',
      'setPortfolioLessonStagesFilter',
      'setPortfolioIssueTypes',
      'setPortfolioIssueTypesFilter',
      'setPortfolioIssueSeveritiesFilter',
      'setPortfolioIssueSeverities',
      'setPortfolioRiskApproachesFilter',
      'setPortfolioRiskApproaches',
      'setPortfolioRiskPrioritiesFilter',
      'setPortfolioRiskPriorities',
      'updateProgramFilterValue'
    ]),
   projectNameShortener(str, length, ending) {
      if (length == null) {
        length = 40;
      }
      if (ending == null) {
        ending = '...';
      }
      if (str.length > length) {
        return str.substring(0, length - ending.length) + ending;
      } else {
        return str;
      }
    },
    // log(e){
    //   console.log(" risk priorities " + e)
    // },
    handleOutsideClick() {
      if (this.getShowAdvancedFilter && !this.datePicker) {
         this.setShowAdvancedFilter(this.getShowAdvancedFilter) 
      }
     
    },
    toggleFilters() {
      if(!this.getShowAdvancedFilter){
        // this.resetFilters()

        if(this.portfolioUsers && this.portfolioUsers.length < 1){
          this.fetchPortfolioPrograms()
        }
        if(this.portfolioUsers && this.portfolioUsers.length < 1){
          this.fetchPortfolioUsers()
        }
        if(this.portfolioStatuses && this.portfolioStatuses.length < 1){
          this.fetchPortfolioStatuses()
        }
        // if(this.portfolioTaskStages.all_stages && this.portfolioTaskStages.all_stages.length < 1){
          this.fetchPortfolioTaskStages()
        // }
        // if(this.portfolioRiskStages.all_stages && this.portfolioRiskStages.all_stages.length < 1){
          this.fetchPortfolioRiskStages()
        // }
        // if(this.portfolioIssueStages.all_stages && this.portfolioIssueStages.all_stages.length < 1){
          this.fetchPortfolioIssueStages()
          this.fetchPortfolioLessonStages()
        // }
        if(this.portfolioIssueTypes && this.portfolioIssueTypes.length < 1){
          this.fetchPortfolioIssueTypes()
        }
        if(this.portfolioIssueSeverities && this.portfolioIssueSeverities.length < 1){
          this.fetchPortfolioIssueSeverities()
        }
        if(this.portfolioRiskApproaches && this.portfolioRiskApproaches.length < 1){
          this.fetchPortfolioRiskApproaches()
        }
        if(this.portfolioRiskPriorities && this.portfolioRiskPriorities.length < 1){
          this.fetchPortfolioRiskPriorities()
        }
      }
      this.setShowAdvancedFilter(!this.getShowAdvancedFilter)
    },
    updateProjectQuery(selected, index) {
      window.location.pathname = "/projects/" + selected.id
    },
    loadFavoriteFilter(fav_filter){

      this.resetFilters()
      var res = fav_filter.query_filters

      if(!res){
        return;
      }
      for(var i = 0; i < res.length; i++){

        if(res[i].filter_key == "issueTypeFilter"){
          this.setIssueTypeFilter(res[i].filter_value)

        }else if(res[i].filter_key == "issueSeverityFilter"){
          this.setIssueSeverityFilter(res[i].filter_value)

        }else if(res[i].filter_key == "getAdvancedFilter"){
          this.setAdvancedFilter(res[i].filter_value)

        }else if(res[i].filter_key == "facilityGroupFilter"){

          this.setFacilityGroupFilter(res[i].filter_value)

        }else if(res[i].filter_key == "projectStatusFilter"){
          this.setProjectStatusFilter(res[i].filter_value)

        }else if(res[i].filter_key == "facilityDueDateFilter"){
          this.setFacilityDueDateFilter(res[i].filter_value)
        
        }else if(res[i].filter_key == "riskPriorityLevelFilter"){
          this.setRiskPriorityLevelFilter(res[i].filter_value)
        
        }else if(res[i].filter_key == "riskApproachFilter"){
          this.setRiskApproachFilter(res[i].filter_value)
        
        }else if(res[i].filter_key == "riskStageFilter"){
          this.setRiskStageFilter(res[i].filter_value)
        
        }else if(res[i].filter_key == "taskTypeFilter"){
          this.setTaskTypeFilter(res[i].filter_value)
        
        }else if(res[i].filter_key == "taskIssueProgressFilter"){
          //this.setTaskIssueProgressFilter(res[i].filter_value)
          var min = res[i].filter_value[0].name.split("-")[0]
          var max = res[i].filter_value[0].name.split("-")[1]
          this.progressFilter.taskIssue = {min: min, max: max}

        }else if(res[i].filter_key == "taskIssueDueDateFilter"){
          this.setTaskIssueDueDateFilter(res[i].filter_value)
        
        }else if(res[i].filter_key == "noteDateFilter"){
          this.setNoteDateFilter(res[i].filter_value)
        
        }else if(res[i].filter_key == "facilityNameFilter"){
          this.setFacilityNameFilter(res[i].filter_value)
        
        }else if(res[i].filter_key == "facilityProgressFilter"){
          //this.setFacilityProgressFilter(res[i].filter_value)
          var min = res[i].filter_value[0].name.split("-")[0]
          var max = res[i].filter_value[0].name.split("-")[1]
          this.progressFilter.facility = {min: min, max: max}

        }else if(res[i].filter_key == "taskStageFilter"){
          this.setTaskStageFilter(res[i].filter_value)
        
        }else if(res[i].filter_key == "issueStageFilter"){
          this.setIssueStageFilter(res[i].filter_value)
        
        }else if(res[i].filter_key == "taskIssueUserFilter"){
          this.setTaskIssueUserFilter(res[i].filter_value)
        }
      }
    },
    fetchFilters(){
      var url = `/projects/${this.currentProject.id}/query_filters.json`
      var method = "GET"

      axios({
        method: method,
        url: url,
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').attributes['content'].value
        }
      })
      .then((response) => {
        var res = response.data
        this.favoriteFilterOptions = res
        MessageDialogService.showDialog({
          response: response
        });
      })
      .catch((err) => {
        // var errors = err.response.data.errors
        console.log(err)
      })
      .finally(() => {
        // this.loading = false
      })


    },
    saveFavoriteFilters(){
      let formData = new FormData()

      formData.append('favorite_filter[name]', this.favoriteFilterData.name)
      if(this.favoriteFilterData.id)
        formData.append('favorite_filter[id]', this.favoriteFilterData.id)

      if(this.favoriteFilterData.shared){
        formData.append('favorite_filter[shared]', this.favoriteFilterData.shared)
      }else{
        formData.append('favorite_filter[shared]', false)
      }
      
      // Categories Filter
      if(this.facilityGroupFilter && this.facilityGroupFilter[0]){
        formData.append('query_filters[][filter_key]', "facilityGroupFilter")
        formData.append('query_filters[][name]', "Project Groups")
        // var v = JSON.stringify(this.facilityGroupFilter)
        var v = JSON.stringify( _.map(this.facilityGroupFilter, function(val) {  return {id: val.id, name: val.name}  }) );
        //var v = JSON.stringify(this.facilityGroupFilter)

        formData.append('query_filters[][filter_value]', v )       
      }

      // Categories Filter
      if(this.projectStatusFilter && this.projectStatusFilter[0]){
        formData.append('query_filters[][filter_key]', "projectStatusFilter")
        formData.append('query_filters[][name]', "Project Statuses")
        
        // var v = JSON.stringify( _.map(this.projectStatusFilter, function(val) {  return {id: val.id, name: val.name}  }) );
        var v = JSON.stringify(this.projectStatusFilter)

        formData.append('query_filters[][filter_value]', v )       
      }

      // Categories Filter
      if(this.facilityNameFilter && this.facilityNameFilter[0]){
        formData.append('query_filters[][filter_key]', "facilityNameFilter")
        formData.append('query_filters[][name]', "Project Names")
        var v = JSON.stringify( _.map(this.facilityNameFilter, function(val) {  return {id: val.id, facilityName: val.facilityName}  }) );

        // NOTE: this saving more data than required so not using this code
        // var v = JSON.stringify(this.facilityNameFilter)

        formData.append('query_filters[][filter_value]', v )       
      }      

      // Categories Filter
      if(this.facilityProgressFilter && this.facilityProgressFilter[0]){
        formData.append('query_filters[][filter_key]', "facilityProgressFilter")
        formData.append('query_filters[][name]', "Project % Progress Range")

        // var v = JSON.stringify( _.map(this.facilityProgressFilter, function(val) {  return {name: val.name, value: val.value}  }) );
        var v = JSON.stringify(this.facilityProgressFilter)

        formData.append('query_filters[][filter_value]', v )       
      }

      // Categories Filter
      if(this.facilityDueDateFilter && this.facilityDueDateFilter[0]){
        formData.append('query_filters[][filter_key]', "facilityDueDateFilter")
        formData.append('query_filters[][name]', "Project Completion Date Range")
        var dates = []
        dates.push( moment(this.facilityDueDateFilter[0]).format("YYYY-MM-DD") )
        dates.push( moment(this.facilityDueDateFilter[1]).format("YYYY-MM-DD") )
        dates = JSON.stringify(dates)
        formData.append('query_filters[][filter_value]', dates ) 
      }

      // Categories Filter
      if(this.taskStageFilter && this.taskStageFilter[0]){
        formData.append('query_filters[][filter_key]', "taskStageFilter")
        formData.append('query_filters[][name]', "Task Stages")

        // var v = JSON.stringify( _.map(this.taskStageFilter, function(val) {  return {id: val.id, name: val.name}  }) );
        var v = JSON.stringify(this.taskStageFilter)

        formData.append('query_filters[][filter_value]', v )       
      }

      // Categories Filter
      if(this.issueTypeFilter && this.issueTypeFilter[0]){
        formData.append('query_filters[][filter_key]', "issueTypeFilter")
        formData.append('query_filters[][name]', "Issue Types")

        // var v = JSON.stringify( _.map(this.issueTypeFilter, function(val) {  return {id: val.id, name: val.name}  }) );
        var v = JSON.stringify(this.issueTypeFilter)

        formData.append('query_filters[][filter_value]', v )       
      }

      // Categories Filter
      if(this.issueSeverityFilter && this.issueSeverityFilter[0]){
        formData.append('query_filters[][filter_key]', "issueSeverityFilter")
        formData.append('query_filters[][name]', "Issue Severities")

        // var v = JSON.stringify( _.map(this.issueSeverityFilter, function(val) {  return {id: val.id, name: val.name}  }) );
        var v = JSON.stringify(this.issueSeverityFilter)

        formData.append('query_filters[][filter_value]', v )       
      }

      // Categories Filter
      if(this.issueStageFilter && this.issueStageFilter[0]){
        formData.append('query_filters[][filter_key]', "issueStageFilter")
        formData.append('query_filters[][name]', "Issue Stages")

        // var v = JSON.stringify( _.map(this.issueStageFilter, function(val) {  return {id: val.id, name: val.name}  }) );
        var v = JSON.stringify(this.issueStageFilter)
        formData.append('query_filters[][filter_value]', v )       
      }

      // Categories Filter
      if(this.getRiskPriorityLevelFilter && this.getRiskPriorityLevelFilter[0]){
        formData.append('query_filters[][filter_key]', "riskPriorityLevelFilter")
        formData.append('query_filters[][name]', "Risk Priority Levels")
        
        // var v = JSON.stringify( _.map(this.getRiskPriorityLevelFilter, function(val) {  return {id: val.id, name: val.name}  }) );
        var v = JSON.stringify( this.getRiskPriorityLevelFilter );

        formData.append('query_filters[][filter_value]', v )       
      }

      // Categories Filter
      if(this.riskStageFilter && this.riskStageFilter[0]){
        formData.append('query_filters[][filter_key]', "riskStageFilter")
        formData.append('query_filters[][name]', "Risk Stages")
        // var v = JSON.stringify( _.map(this.riskStageFilter, function(val) {  return {id: val.id, name: val.name}  }) );
        var v = JSON.stringify( this.riskStageFilter );
        formData.append('query_filters[][filter_value]', v )       
      }

      // Categories Filter
      if(this.getRiskApproachFilter && this.getRiskApproachFilter[0]){
        formData.append('query_filters[][filter_key]', "riskApproachFilter")
        formData.append('query_filters[][name]', "Risk Approaches")
        // var v = JSON.stringify( _.map(this.getRiskApproachFilter, function(val) {  return {id: val.id, name: val.name}  }) );
        var v = JSON.stringify( this.getRiskApproachFilter );
        formData.append('query_filters[][filter_value]', v )       
      }

      // Categories Filter
      if(this.taskTypeFilter && this.taskTypeFilter[0]){
        formData.append('query_filters[][filter_key]', "taskTypeFilter")
        formData.append('query_filters[][name]', "Categories")
        var v = JSON.stringify(this.taskTypeFilter)
        // var v = JSON.stringify( _.map(this.taskTypeFilter, function(val) {  return {id: val.id, name: val.name}  }) );
        formData.append('query_filters[][filter_value]', v )        
      }

      // Categories Filter
      if(this.getTaskIssueUserFilter && this.getTaskIssueUserFilter[0]){
        formData.append('query_filters[][filter_key]', "taskIssueUserFilter")
        formData.append('query_filters[][name]', "Action Users")

        // var v = JSON.stringify( _.map(this.getTaskIssueUserFilter, function(val) {  return {id: val.id, fullName: val.fullName}  }) );
        var v = JSON.stringify( this.getTaskIssueUserFilter );

        formData.append('query_filters[][filter_value]', v )       
      }

      // Categories Filter
      if(this.getAdvancedFilter && this.getAdvancedFilter[0]){
        formData.append('query_filters[][filter_key]', "getAdvancedFilter")
        formData.append('query_filters[][name]', "Flags")
        var v = JSON.stringify(this.taskTypeFilter)
        
        // var v = JSON.stringify( _.map(this.getAdvancedFilter, function(val) {  return {id: val.id, name: val.name}  }) );
        var v = JSON.stringify(this.getAdvancedFilter);
        
        formData.append('query_filters[][filter_value]', v )       
      }

      // Categories Filter
      if(this.taskIssueProgressFilter && this.taskIssueProgressFilter[0]){
        formData.append('query_filters[][filter_key]', "taskIssueProgressFilter")
        formData.append('query_filters[][name]', "Action % Progress Range")
        var v = JSON.stringify(this.taskIssueProgressFilter)
        // var v = JSON.stringify( _.map(this.taskIssueProgressFilter, function(val) {  return {name: val.name, value: val.value}  }) );
        formData.append('query_filters[][filter_value]', v )       
      }
      
      // Categories Filter
      if(this.taskIssueDueDateFilter && this.taskIssueDueDateFilter[0]){
        formData.append('query_filters[][filter_key]', "taskIssueDueDateFilter")
        formData.append('query_filters[][name]', "Action Due Date Range")
        var dates = []
        dates.push( moment(this.taskIssueDueDateFilter[0]).format("YYYY-MM-DD") )
        dates.push( moment(this.taskIssueDueDateFilter[1]).format("YYYY-MM-DD") )
        dates = JSON.stringify(dates)
        formData.append('query_filters[][filter_value]', dates )        
      }

      // Categories Filter
      if(this.noteDateFilter && this.noteDateFilter[0]){
        formData.append('query_filters[][filter_key]', "noteDateFilter")
        formData.append('query_filters[][name]', "Updates Date Range")
        var dates = []
        dates.push( moment(this.noteDateFilter[0]).format("YYYY-MM-DD") )
        dates.push( moment(this.noteDateFilter[1]).format("YYYY-MM-DD") )
        dates = JSON.stringify(dates)
        formData.append('query_filters[][filter_value]', dates )        
      }

      var url = `/projects/${this.currentProject.id}/query_filters.json`
      var method = "POST"
      var callback = "filter-created"

      axios({
        method: method,
        url: url,
        data: formData,
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').attributes['content'].value
        }
      })
      .then((response) => {
        var favorite_filter =  response.data.favorite_filter
        this.favoriteFilterData = favorite_filter
        let i = this.favoriteFilterOptions.findIndex(n => n.id === favorite_filter.id)

        if(i == -1){
          this.favoriteFilterOptions.unshift(favorite_filter) 
        }else{
          Vue.set(this.favoriteFilterOptions, i, favorite_filter)
        }
        _.remove(this.favoriteFilterOptions, (t) => t.id === null)
        this.favoriteFilterOptions.unshift({id: null, name: "New Filter", shared: false }) 
        
        MessageDialogService.showDialog({
          response: response
        });
      })
      .catch((err) => {
        // var errors = err.response.data.errors
        console.log(err)
      })
      .finally(() => {
        // this.loading = false
      })

    },
    resetFilters(){
      this.setPortfolioUsersFilter([]) 
      this.setPortfolioNameFilter([])
      this.setPortfolioCategoriesFilter([])     
      this.setTaskIssueUserFilter([])
      this.setTaskIssueProgressStatusFilter([])
      this.setPortfolioStatusesFilter([])
      this.setPortfolioTaskStagesFilter([])
      this.setPortfolioIssueStagesFilter([])
      this.setPortfolioRiskStagesFilter([])
      this.setPortfolioLessonStagesFilter([])
      this.setPortfolioIssueSeveritiesFilter([])
      this.setPortfolioIssueTypesFilter([])
      this.setPortfolioRiskApproachesFilter([])
      this.setPortfolioRiskPrioritiesFilter([])

      this.setProjectStatusFilter(null)
      this.setTaskIssueOverdueFilter([])
      this.setTaskTypeFilter(null)
      this.setFacilityGroupFilter(null)
      this.setFacilityProgressFilter(null)
      this.setFacilityDueDateFilter([null])
      this.setNoteDateFilter([null])
      this.setTaskIssueDueDateFilter([null])
      this.setFacilityNameFilter(null)
      this.setIssueTypeFilter(null)
      this.setIssueSeverityFilter(null)
      this.setIssueStageFilter(null)
      this.setTaskStageFilter(null)
      this.setRiskStageFilter(null)
      this.setTaskIssueProgressFilter(null)
      this.setMyActionsFilter([])
      this.setOnWatchFilter([])
      this.setMapFilters([])
      this.clearProgressFilters()
      this.setIssueUserFilter([])
      this.setTaskUserFilter(null)
      this.setRiskApproachFilter([])
      this.setRiskPriorityLevelFilter([])
      this.setTasksPerPageFilter(null)
      this.setRisksPerPageFilter(null)
      this.setIssuesPerPageFilter(null)
      this.setMembersPerPageFilter(null)
    },
    onClearFilter() {
      this.$confirm(`Are you sure you want to remove this favorite filter?`, 'Confirm Remove', {
        confirmButtonText: 'Remove',
        cancelButtonText: 'Cancel',
        type: MessageDialogService.msgTypes.WARNING
      }).then(() => {
        this.setPortfolioUsersFilter([])
        this.setPortfolioCategoriesFilter([])
        this.setTaskIssueUserFilter([])
        this.setTaskIssueProgressStatusFilter([])
        this.setPortfolioStatusesFilter([])
        this.setPortfolioTaskStagesFilter([])
        this.setPortfolioIssueStagesFilter([])
        this.setPortfolioRiskStagesFilter([])
        this.setPortfolioLessonStagesFilter([])
        this.setPortfolioIssueSeveritiesFilter([])
        this.setPortfolioIssueTypesFilter([])
        this.setPortfolioRiskApproachesFilter([])
        this.setPortfolioRiskPrioritiesFilter([])
        this.setPortfolioNameFilter([])
        this.setTaskIssueUserFilter([])
        this.setTaskIssueProgressStatusFilter([])
        // this.setAdvancedFilter([])
        this.setMyAssignmentsFilter([])
        this.setProjectStatusFilter(null)
        this.setTaskIssueOverdueFilter([])
        this.setTaskTypeFilter(null)
        this.setFacilityGroupFilter(null)
        this.setFacilityProgressFilter(null)
        this.setFacilityDueDateFilter([null])
        this.setNoteDateFilter([null])
        this.setTaskIssueDueDateFilter([null])
        this.setFacilityNameFilter(null)
        this.setIssueTypeFilter(null)
        this.setIssueSeverityFilter(null)
        this.setIssueStageFilter(null)
        this.setTaskStageFilter(null)
        this.setRiskStageFilter(null)
        this.setTaskIssueProgressFilter(null)
        this.setMyActionsFilter([])
        this.setOnWatchFilter([])
        this.setMapFilters([])
        this.clearProgressFilters()
        this.setIssueUserFilter([])
        this.setTaskUserFilter(null)
        this.setRiskApproachFilter([])
        this.setRiskPriorityLevelFilter([])
        this.setTasksPerPageFilter(null)
        this.setRisksPerPageFilter(null)
        this.setIssuesPerPageFilter(null)
        this.setMembersPerPageFilter(null)
        this.setFacilities(this.getUnfilteredFacilities)

        if(!this.favoriteFilterData.id)
          return

        var url = `/projects/${this.currentProject.id}/query_filters/reset.json`
        var method = "DELETE"
        var callback = "filter-destroyed"

        let formData = new FormData()

        formData.append('favorite_filter[id]', this.favoriteFilterData.id)

        axios({
          method: method,
          url: url,
          data: formData,
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').attributes['content'].value
          }
        })
        .then((response) => {
          var id = parseInt(response.data.id)
          this.favoriteFilterOptions = _.filter(this.favoriteFilterOptions, function(currentObject) {
            return currentObject.id != id;
          });
          if(this.favoriteFilterOptions && this.favoriteFilterOptions.length > 0){
            this.favoriteFilterData = this.favoriteFilterOptions[0]
            this.loadFavoriteFilter(this.favoriteFilterData)
          }else{
            this.favoriteFilterData = {id: null, name: "New Filter", shared: false}
          }

          //let i = this.favoriteFilterOptions.findIndex(n => n.id === id)
          //Vue.set(this.favoriteFilterOptions, i, null)
          MessageDialogService.showDialog({
            response: response
          });
        })
        .catch((err) => {
          // var errors = err.response.data.errors
          console.log(err)
        })
        .finally(() => {
          // this.loading = false
        })
      });
    },
    exportData() {
      if (!this.enableExport || this.exporting) return;
      this.exporting = true
      if (this.isMapView) this.exportMapData()
      else if (this.isGanttView) this.exportGanttData()
    },
    exportMapData() {
      try {
        let filters = [`Map Filters: ${this.currentProject.name} \n
            Project Group: ${this.facilityGroupFilter ? _.map(this.facilityGroupFilter, 'name').join() : 'all'}\n
            Project Name: ${this.facilityNameFilter ? _.map(this.facilityNameFilter, 'facilityName').join() : 'all'}\n
            Project Status: ${this.projectStatusFilter ? _.map(this.projectStatusFilter, 'name').join() : 'all'}\n
            Facility % Progress Range: ${this.facilityProgressFilter ? _.map(this.facilityProgressFilter, 'name').join() : 'all'}\n
            Facility Due Date: ${this.facilityDueDateFilter && this.facilityDueDateFilter[0] ? this.formatDate(this.facilityDueDateFilter[0]) + ' to ' + this.formatDate(this.facilityDueDateFilter[1]) : 'all'}\n
            Milestones: ${this.taskTypeFilter ?  _.map(this.taskTypeFilter, 'name').join() : 'all'}\n
            Task % Progress Range: ${this.taskIssueProgressFilter ?  _.map(this.taskIssueProgressFilter, 'name').join() : 'all'}\n
            Issue Type: ${this.issueTypeFilter ?  _.map(this.issueTypeFilter, 'name').join() : 'all'}\n
            Issue % Progress Range: ${this.taskIssueProgressFilter ?  _.map(this.taskIssueProgressFilter, 'name').join() : 'all'}\n
            Issue severity: ${this.issueSeverityFilter ?  _.map(this.issueSeverityFilter, 'name').join() : 'all'}\n
          `]
        let header = ["Project Name", "Project Group", "Project Status", "Due Date", "Percentage Complete", "Point of Contact Name", "Point of Contact Phone", "Point of Contact Email"]
        let ex_data = []
        for (let facility of this.filterFacilitiesWithActiveFacilityGroups) {
          ex_data.push({
            "Project Name": facility.facilityName || 'N/A',
            "Project Group": facility.facilityGroupName || 'N/A',
            "Project Status": facility.projectStatus || 'N/A',
            "Due Date": facility.dueDate || 'N/A',
            "Percentage Complete": facility.progress || 0,
            "Point of Contact Name": facility.pointOfContact || 'N/A',
            "Point of Contact Phone": facility.phoneNumber || 'N/A',
            "Point of Contact Email": facility.email || 'N/A'
          })
        }
        let wb = XLSX.utils.book_new()
        let ws = XLSX.utils.aoa_to_sheet(new Array(filters))
        XLSX.utils.sheet_add_json(ws, ex_data, { header: header, origin: "A3" })
        XLSX.utils.book_append_sheet(wb, ws, "MGIS")
        XLSX.writeFile(wb, `${this.random()}.xlsx`)
        this.exporting = false
      } catch (err) {
        console.error(err)
      }
    },
    exportGanttData() {
      try {
        let header = ["WBS", "Name", "Duration", "% Complete", "Start Date", "End Date", "Assigned To"]
        let ex_data = []
        for (let row of this.ganttData) {
          ex_data.push({
            "WBS": row._id,
            "Name": row.name,
            "Duration": row.durationInDays,
            "% Complete": row.progress,
            "Start Date": this.formatDate(row.startDate),
            "End Date": this.formatDate(row.endDate),
            "Assigned To": row._users ? row._users.join(', ') : ''
          })
        }
        let wb = XLSX.utils.book_new()
        let ws = XLSX.utils.json_to_sheet(ex_data, { header: header })
        XLSX.utils.book_append_sheet(wb, ws, "MGIS")
        XLSX.writeFile(wb, `${this.random()}.xlsx`)
        this.exporting = false
      } catch (err) {
        console.error(err)
      }
    },
    onChangeProgress(event, option) {
      let user_input = event.target.value
      let input = event.target.value
      let hash = Object.assign({}, this.progressFilter[option.variable])
      let error = ""
      if (this.exists(input)) {
        if (input < 0 || input === "") input = 0
        if (input > 100) input = 100
        if ( (option.type == 'min' && input > hash.max) || (option.type == 'max' && input < hash.min)) {
          error = "Min should not be greator than Max."
        }
        if (( option.type == 'min' &&  hash.max == "") || ( option.type == 'max' &&  hash.min == "")) {
          error = "Both fields are required."
        }
      }

      hash[option.type] = (input <= 0 ? 0 : Number(input) )
      if (hash.max < 0 || hash.min < 0) error = "Both fields are required."
      if (hash.max == "" && hash.min == "") error = ""
      hash.error = error
      if((input === 0 || input === "" ) && user_input === "" && option.type == 'min') hash.min = ""
      if((input === 0 || input === "" ) && option.type == 'max') hash.max = ""

      this.setProgressFilters({ key: option.variable, value: hash })
    },
    resetMapFilter() {
      this.setFacilities(this.getUnfilteredFacilities)
      this.setMapZoomFilter(this.getUnfilteredFacilities.map(facility => facility.id))
    }
  },
  watch: {

    portfolioTasksLoaded: {
     handler(){
      if(this.portfolioTasksLoaded){
      this.taskArray = this.portfolioTasks.tasks;  
      }
     }
    },
    getRiskApproachFilter(value) {
      this.updateMapFilters({ key: 'riskApproachFilter', filter: value, same: true })
    },
    getRiskPriorityLevelFilter(value) {
      this.updateMapFilters({ key: 'riskPriorityLevelFilter', filter: value, same: true })
    },

    getAdvancedFilter(value) {
      this.updateMapFilters({ key: 'advancedFilter', filter: value, same: true })
    },
    getTaskIssueProgressStatusFilter(value){
      this.updateMapFilters({ key: 'taskIssueProgressStatus', filter: value, same: true })
    },
    facilityDueDateFilter(value) {
      this.updateMapFilters({ key: 'dueDate', filter: value, same: true })
    },
    noteDateFilter(value) {
      this.updateMapFilters({ key: 'noteDate', filter: value, same: true })
    },
    taskIssueDueDateFilter(value) {
      this.updateMapFilters({ key: 'taskIssueDueDate', filter: value, same: true })
    },
    taskIssueOverdueFilter(value) {
      this.updateMapFilters({ key: 'taskIssueOverdue', filter: value, same: true })
    },
    facilityGroupFilter(value) {
      this.updateMapFilters({ key: 'facilityGroupIds', filter: value })
    },
    facilityNameFilter(value) {
      this.updateMapFilters({ key: 'ids', filter: value })
    },
    projectStatusFilter(value) {
      this.updateMapFilters({ key: 'statusIds', filter: value })
    },
    facilityProgressFilter(value) {
      this.updateMapFilters({ key: 'progress', filter: value, _k: 'value' })
    },

    programProgressFilter(value) {
      this.updateMapFilters({ key: 'progress', filter: value, _k: 'value' })
    },
    taskTypeFilter(value) {
      this.updateMapFilters({ key: 'taskTypeIds', filter: value })
    },
    taskIssueProgressFilter(value) {
      this.updateMapFilters({ key: 'taskIssueProgress', filter: value, _k: 'value' })
    },
    issueTypeFilter(value) {
      this.updateMapFilters({ key: 'issueTypeIds', filter: value })
    },
    issueSeverityFilter(value) {
      this.updateMapFilters({ key: 'issueSeverityIds', filter: value })
    },
    issueStageFilter(value) {
      this.updateMapFilters({ key: 'issueStageIds', filter: value })
    },
    taskStageFilter(value) {
      this.updateMapFilters({ key: 'taskStageIds', filter: value })
    },
    riskStageFilter(value) {
      this.updateMapFilters({ key: 'riskStageIds', filter: value })
    },
    getTaskIssueUserFilter(value) {
      this.updateMapFilters({ key: 'taskIssueUsers', filter: value })
    },
    myActionsFilter(value) {
      this.updateMapFilters({ key: 'myActions', filter: value, _k: 'value' })
    },
    onWatchFilter(value) {
      this.updateMapFilters({ key: 'onWatch', filter: value, _k: 'value' })
    },
    "progressFilter.program": {
      handler(value) {
       if (value.error == "" && value.min !== "" && value.max !== ""  && value.min <= value.max) {
          value = { name: value.min + "-" + value.max, value: value.min + "-" + value.max }
          this.setProgramProgressFilter([value])
        } else if (value.min == "" && value.max == "") {
          this.setProgramProgressFilter([])
        }
      },
      deep: true
    },
    "progressFilter.facility": {
      handler(value) {
       if (value.error == "" && value.min !== "" && value.max !== ""  && value.min <= value.max) {
          value = { name: value.min + "-" + value.max, value: value.min + "-" + value.max }
          this.setFacilityProgressFilter([value])
        } else if (value.min == "" && value.max == "") {
          this.setFacilityProgressFilter([])
        }
      },
      deep: true
    },
    "progressFilter.taskIssue": {
      handler(value) {
        if (value.error == "" && value.min !== "" && value.max !== ""  && value.min <= value.max) {
          value = { name: value.min + "-" + value.max, value: value.min + "-" + value.max }
          this.setTaskIssueProgressFilter([value])
        } else if (value.min == "" && value.max == "") {
          this.setTaskIssueProgressFilter([])
        }
      },
      deep: true
    },
    getMapZoomFilter: {
      handler() {
        this.mapFilterSet = true
      }
    }
  }
}
</script>
<style scoped lang="scss">

</style>
