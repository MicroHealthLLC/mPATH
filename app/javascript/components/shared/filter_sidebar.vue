<!-- NOTE: This file is used Global filter view in left side -->
<template>

  <div id="filterbar" :style="filterBarStyle" data-cy="filter_bar">

    <div id="filter_bar" class="container shadow-sm" data-cy="filter_info">

      <!-- First row: Filter View Title/Header -->
      <div class="row my-2">
        <div class="col-md-12">
           <h5 class="d-inline"><i class="fas fa-sliders-h pr-2"></i>ADVANCED FILTERS</h5>
             <button class="btn btn-sm float-right d-inline-block font-sm btn-secondary py-0 ml-1 mb-1" @click.prevent="resetFilters();resetMapFilter()" data-cy="clear_filter"><i class="far fa-redo text-light clickable mr-1"></i>Reset</button>
            <!-- <button class="btn btn-sm btn-link float-right d-inline-block font-sm btn-success text-light py-0 mb-1" @click.prevent="saveFilters1" data-cy="save_filter"> <font-awesome-icon icon="save" class="text-light clickable mr-1" />Save Filter Settings</button> -->
         </div>
      </div>
   <el-tabs type="border-card" @tab-click="handleClick">
      <el-tab-pane label="Projects">
      <div class="filter-border filter-sections px-3 pb-1 pt-0">
          <div class="row">
            <div class="col-md-12">
              <h5 class="mb-0">Projects</h5>
            </div>
          </div>

          <!-- Next row for two columns that will contain Facilities-related menus -->
          <div class="row justify-content-between pb-2">
            <div class="col-md-6">
              <div>
                <label class="font-sm mb-0">Project Groups</label>
                <el-select 
                    v-model="C_facilityGroupFilter"                    
                    class="w-100" 
                    track-by="name" 
                    filterable
                    value-key="id"
                    multiple                                                                                                                                               
                    clearable
                    placeholder="Search and select Project Group"
                  >
                  <el-option 
                    v-for="item in C_activeFacilityGroups"                                                     
                    :value="item"   
                    :key="item.id + 'i'"
                    :label="item.name"                                                  
                    >
                  </el-option>
                  </el-select> 
              </div>
              <label class="font-sm mb-0">Project Names</label>
                  <el-select 
                    v-model="C_facilityNameFilter" 
                    class="w-100" 
                    track-by="name" 
                    value-key="id"
                    data-cy="facility_name" 
                    :loading="isLoading"
                    multiple   
                    filterable                                                                                                                                                        
                    clearable
                    placeholder="Search and select Project Name"
                    >
                  <el-option 
                    v-for="item in C_activeProjectNames"                                                            
                    :value="item"   
                    :key="item.id + 'j'"
                    :label="projectNameShortener(item.facilityName, 35)"                                                     
                    >
                  </el-option>
                </el-select> 

              <div>
                <label class="font-sm mb-0">Project % Progress Range</label>
                <div class="form-row">
                  <div class="form-group col mb-0">
                    <input type="number" class="form-control" placeholder="Min." min="0" max="100" @input="onChangeProgress($event, {variable: 'facility', type: 'min'})" :value="C_facilityProgress.min">
                  </div>
                  <div class="form-group col mb-0">
                    <input type="number" class="form-control" placeholder="Max." min="0" max="100" @input="onChangeProgress($event, {variable: 'facility', type: 'max'})" :value="C_facilityProgress.max">
                  </div>
                </div>
                <span class="font-sm text-danger ml-1" v-if="C_facilityProgress.error">{{C_facilityProgress.error}}</span>
              </div>
              </div>
              <div class="">

            </div>
            <div class="col-md-6">
              <label class="font-sm mb-0">Project Statuses</label>
                <el-select 
                    v-model="C_projectStatusFilter"                    
                    class="w-100" 
                    track-by="name" 
                    value-key="id"
                    data-cy="project_status"                
                    multiple                                                                                                                                                         
                    clearable
                    placeholder="Select Project Status"
                    >
                  <el-option 
                    v-for="item in statuses"                                                     
                    :value="item"   
                    :key="item.id + 'k'"
                    :label="item.name"                                                  
                    >
                  </el-option>
                </el-select> 

              <div>
                <!-- Available row for filter -->
              </div>
              <div class="mt-1">
                <label class="font-sm mb-0">Project Completion Date Range</label>
                <v2-date-picker v-model="C_facilityDueDateFilter" class="datepicker dp" placeholder="Select Date Range" @open="datePicker=true" range />
              </div>
              <!-- To Do: Convert to multiselect to match other filter toggles -->
              <div class="mt-1 d-flex flex-column">
                <label class="font-sm mb-0">Map Boundary Filter</label>
                <el-button @click="resetMapFilter" size="small" :disabled="mapFilterApplied" class="text-primary">Reset Map Filter <i class="el-icon-refresh"></i></el-button>
              </div>
            </div>
          </div>         
          <div class="row mt-3 pb-2">
              <div class="col-md-4" style="border-right:solid lightgray .8px">
                <div>
                <label class="font-sm mb-1">Process Areas</label>
                <el-select 
                  v-model="C_taskTypeFilter"                    
                  class="w-100" 
                  track-by="name" 
                  value-key="id"                  
                  data-cy="task_category"       
                  multiple                                                                                                                                                         
                  clearable
                  placeholder="Select Process Areas"
                  >
                <el-option 
                  v-for="item in taskTypes"                                                     
                  :value="item"   
                  :key="item.id + 'l'"
                  :label="item.name"                                                  
                  >
                </el-option>
                </el-select>                
               </div>              
               <div>
                <label class="font-sm mb-0">Action Users</label>
                <el-select 
                  v-model="C_taskIssueUserFilter"                    
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
                  v-for="item in activeProjectUsers"                                                     
                  :value="item"   
                  :key="item.id + 'm'"
                  :label="item.fullName"                                                  
                  >
                </el-option>
              </el-select> 
              </div>
              </div>
              <div class="col-md-4" style="border-right:solid lightgray .8px">
                <div >

                 <label class="font-sm mb-0">Assignments</label>
                 <el-select 
                  v-model="C_myAssignmentsFilter"                   
                  class="w-100" 
                  track-by="name" 
                  value-key="id" 
                  filterable                 
                  data-cy="task_category"       
                  multiple                                                                                                                                                         
                  clearable
                  placeholder="Select Option"
                  >
                <el-option 
                  v-for="item in getMyAssignmentsFilterOptions"                                                     
                  :value="item"   
                  :key="item.id + 'n'"
                  :label="item.name"                                                  
                  >
                </el-option>
              </el-select> 

                  <!-- Reference for Dropdown with multiple category labels (Do not delete) -->
                <label class="font-sm mb-0">Flags</label>
                 <el-select 
                  v-model="C_advancedFilter"                   
                  class="w-100" 
                  track-by="name" 
                  value-key="id" 
                  filterable                 
                  data-cy="task_category"       
                  multiple                                                                                                                                                         
                  clearable
                  placeholder="Filter by Flags"
                  >
                  <el-option-group
                    v-for="group in getAdvancedFilterOptions"
                    :key="group.label"
                    :label="group.label">
                <el-option 
                  v-for="item in group.options"                                                     
                  :value="item"   
                  :key="item.id + 'o'"
                  :label="item.name"                                                                        
                  >
                </el-option>
                  </el-option-group>
              </el-select> 
              </div>
         
             </div>
              <div class="col-md-4">
              <div>
                <label class="font-sm mb-0">Action % Progress Range</label>
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
                <div>
              <label class="font-sm mb-0">Action Due Date Range</label>
              <v2-date-picker v-model="C_taskIssueDueDateFilter" placeholder="Select Date Range" class="datepicker" @open="datePicker=true" range />
            </div>
            <div class="mt-1">
              <label class="font-sm mb-0">Updates Date Range</label>
              <v2-date-picker v-model="C_noteDateFilter" class="datepicker" placeholder="Select Date Range" @open="datePicker=true" range />
            </div>
              </div>
          </div>
      
      </div>

 
      </el-tab-pane>

      <el-tab-pane label="Tasks, Issues, Risks">
  <!-- Put this top row/section into two tabs: Projects \ Favorites -->
        <div class="filter-sections filter-border px-3 pt-1 pb-2 my-3">
        <div class="row pt-3 pb-2">
          <div class="col-md-4" style="border-right:solid lightgray .8px">
            <h5 class="mb-0">Tasks</h5>
            <div>
              <label class="font-sm mb-0">Task Stages</label>
               <el-select 
                  v-model="C_taskStageFilter"                    
                  class="w-100" 
                  track-by="name" 
                  value-key="id"                  
                  data-cy="task_stage"             
                  multiple                                                                                                                                                         
                  clearable
                  placeholder="Select Task Stage"
                  >
                <el-option 
                  v-for="item in taskStages"                                                     
                  :value="item"   
                  :key="item.id + 'a'"
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
                  v-model="C_issueStageFilter"                    
                  class="w-100" 
                  track-by="name" 
                  value-key="id"                  
                  data-cy="issue_stage"            
                  multiple                                                                                                                                                         
                  clearable
                  placeholder="Select Issue Stage"
                  >
                <el-option 
                  v-for="item in issueStages"                                                     
                  :value="item"   
                  :key="item.id + 'b'"
                  :label="item.name"                                                  
                  >
                </el-option>
              </el-select> 
          
            </div>
            <div>
              <label class="font-sm mb-0">Issue Types</label>
              <el-select 
                  v-model="C_issueTypeFilter"                    
                  class="w-100" 
                  track-by="name" 
                  value-key="id"                  
                  data-cy="issue_type"            
                  multiple                                                                                                                                                         
                  clearable
                  placeholder="Select Issue Type"
                  >
                <el-option 
                  v-for="item in issueTypes"                                                     
                  :value="item"   
                  :key="item.id + 'c'"
                  :label="item.name"                                                  
                  >
                </el-option>
              </el-select>            
            </div>

            <div>
              <label class="font-sm mb-0">Issue Severities</label>
              <el-select 
                  v-model="C_issueSeverityFilter"                    
                  class="w-100" 
                  track-by="name" 
                  value-key="id"                  
                  data-cy="issue_stage"            
                  multiple                                                                                                                                                         
                  clearable
                  placeholder="Select Issue Severity"
                  >
                <el-option 
                  v-for="item in issueSeverities"                                                     
                  :value="item"   
                  :key="item.id + 'd'"
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
                  v-model="C_riskStageFilter"                   
                  class="w-100" 
                  track-by="name" 
                  value-key="id"                  
                  data-cy="risk_stage"           
                  multiple                                                                                                                                                         
                  clearable
                  placeholder="Select Risk Stage"
                  >
                <el-option 
                  v-for="item in riskStages"                                                     
                  :value="item"   
                  :key="item.id + 'e'"
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
                  v-for="item in getRiskApproachFilterOptions"                                                     
                  :value="item"   
                  :key="item.id + 'f'"
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
                  v-for="item in getRiskPriorityLevelFilterOptions"                                                     
                  :value="item"   
                  :key="item.id + 'g'"
                  :label="item.name"                                                  
                  >
                </el-option>
              </el-select> 
            </div>             
          </div>
        </div>        
      </div> 

      </el-tab-pane>   

      <el-tab-pane label="Favorites">
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
                    :key="item.id + 'h'"
                    :label="item.name"                                                  
                    >
                  </el-option>
                </el-select>
              
            </div>
            <div class="mt-2">
              <label class="font-sm mb-0">Favorites Filter Name</label>
              <input type="text" class="form-control" placeholder="Enter Name" v-model="C_favoriteFilter.name" :readonly="!hasAdminAccess('write')">             
              <!-- <button class="btn btn-sm btn-link float-right d-inline-block font-sm btn-danger text-light py-0 ml-1 mb-1" @click.prevent="resetFilters" data-cy="clear_filter"><font-awesome-icon icon="redo" class="text-light clickable mr-1" />Reset</button> -->
            </div>
          </div>
            <div class="col-md-7">              
             <div class="btn-group-sm text-center">  
              <button
                v-if="hasAdminAccess('write')"
                class="btn btn-sm font-sm btn-success text-light"
                @click.prevent="saveFavoriteFilters" 
                data-cy="save_favorite_filter"> 
               <i class="fas fa-save text-light clickable mr-1"></i>
                Save to Favorites
              </button>            
              <button 
                v-if="C_favoriteFilter.id ? hasAdminAccess('delete') : false "
                class="btn btn-sm font-sm btn-danger text-light" 
                @click.prevent="onClearFilter" data-cy="clear_filter">
                <font-awesome-icon icon="trash" class="text-light clickable mr-1" />
                Remove
              </button>   
               <button 
                class="btn btn-sm font-sm btn-light" >
                Shared
                <input type="checkbox" style="" v-model="C_favoriteFilter.shared" :disabled="!hasAdminAccess('write')">              
              </button>                      
             </div>
          </div>
        </div>
       </div>
      </el-tab-pane>
      
    </el-tabs>    
   
    </div>
    <div class="knocker" @click.prevent="toggleFilters" data-cy="advanced_filter">
        <button class="btn btn-sm ml-0 knocker-btn text-light p-1"><small><span class="pr-1"><i class="fas fa-sliders-h"></i></span>ADVANCED  FILTERS</small></button>
    </div>
  </div>
</template>
<script>
import axios from 'axios'
import humps from 'humps'
import { mapGetters, mapMutations } from 'vuex'
import * as XLSX from "xlsx/xlsx";
import {API_BASE_PATH} from './../../mixins/utils'

export default {
  name: 'FilterSidebar',
  data() {
    return {
      hasFilterAccess: true,
      isLoading: false,
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
    this.resetFilters()
    this.fetchFilters()
  },
  computed: {
    ...mapGetters([
      'getTaskIssueUserFilter',
      'getTaskIssueProgressStatusFilter',
      'getMyAssignmentsFilter',
      'getMyAssignmentsFilterOptions',
      'getAdvancedFilterOptions',
      'getAdvancedFilter',
      'getShowAdvancedFilter',
      'projectStatusFilter',

      'taskTypes',
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
      'facilityDueDateFilter',
      'noteDateFilter',
      'taskIssueDueDateFilter',
      'taskIssueProgressFilter',
      'projects',
      'currentProject',
      'activeProjectUsers',
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
      'getUnfilteredFacilities'
    ]),
    hasAdminAccess() {
      return salut =>  this.favoriteFilterData.user_id == this.$currentUser.id || !this.favoriteFilterData.id
    },
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
        return this.getRiskPriorityLevelFilter
      },
      set(value) {
        this.setRiskPriorityLevelFilter(value)
      }
    },

    C_riskApproachFilter: {
      get() {
        return this.getRiskApproachFilter
      },
      set(value) {
        this.setRiskApproachFilter(value)
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

    C_taskTypeFilter: {
      get() {
        return this.taskTypeFilter
      },
      set(value) {
        this.setTaskTypeFilter(value)
      }
    },
    C_taskStageFilter: {
      get() {
        return this.taskStageFilter
      },
      set(value) {
        this.setTaskStageFilter(value)
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
    C_facilityNameFilter: {
      get() {
        return this.facilityNameFilter
      },
      set(value) {
        this.setFacilityNameFilter(value)
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
    C_issueTypeFilter: {
      get() {
        return this.issueTypeFilter
      },
      set(value) {
        this.setIssueTypeFilter(value)
      }
    },
    C_issueSeverityFilter: {
      get() {
        return this.issueSeverityFilter
      },
      set(value) {
        this.setIssueSeverityFilter(value)
      }
    },
    C_issueStageFilter: {
      get() {
        return this.issueStageFilter
      },
      set(value) {
        this.setIssueStageFilter(value)
      }
    },

    C_taskIssueUserFilter: {
      get() {
        return this.getTaskIssueUserFilter
      },
      set(value) {
        this.setTaskIssueUserFilter(value)
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
    C_facilityProgress: {
      get() {
        return this.progressFilter.facility
      }
    },
   C_advancedFilter: {
      get() {
        // Note: This code will be useful if want active as default select and never want advanced filter blank
        // if (this.getAdvancedFilter.length == 0) {
        //   // return [{ id: 'active', name: 'Active' }]
        //   this.setAdvancedFilter([{id: 'active', name: 'Active', value: 'active', filterCategoryId: 'progressStatusFilter', filterCategoryName: 'Progress Status'}])
        //   return this.getAdvancedFilter
        // }else{
        //   return this.getAdvancedFilter
        // }
        return this.getAdvancedFilter
      },
      set(value) {
        if (!value) {
          this.setAdvancedFilter([])
        } else {
          this.setAdvancedFilter(value)
        }
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
    }
  },
  methods: {
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
      'setFacilityDueDateFilter',
      'setNoteDateFilter',
      'setTaskIssueDueDateFilter',
      'setIssueTypeFilter',
      'setIssueSeverityFilter',
      'setMyActionsFilter',
      'setOnWatchFilter',
      'setMapFilters',
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
      'setMapZoomFilter'
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
    //   console.log("getAdvancedFilterOptions " + e)
    // },
    // handleOutsideClick() {
    //   if (this.getShowAdvancedFilter && !this.datePicker) {
    //      this.setShowAdvancedFilter(this.getShowAdvancedFilter) 
    //   }
     
    // },
    toggleFilters() {
      this.setShowAdvancedFilter(!this.getShowAdvancedFilter)
    },
    updateProjectQuery(selected, index) {
      window.location.pathname = "/projects/" + selected.id
    },
    handleClick(tab, event) {
        console.log(tab, event);
    },
    // findFacility(query) {
    //   this.isLoading = true
    //   if (query) {
    //     const resp = new RegExp(_.escapeRegExp(query.toLowerCase()), 'i')
    //     const isMatch = (result) => resp.test(result.facilityName)
    //     this.facilities = _.filter(this.unFilterFacilities, isMatch)
    //     this.isLoading = false
    //   } else {
    //     this.facilities = this.unFilterFacilities
    //     this.isLoading = false
    //   }
    // },
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
      var url = `${API_BASE_PATH}/programs/${this.currentProject.id}/query_filters.json`
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
      })
      .catch((err) => {
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

      var url = `${API_BASE_PATH}/programs/${this.currentProject.id}/query_filters.json`
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
          message: `Favorite Filter is saved successfully.`
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
      this.setTaskIssueUserFilter([])
      this.setTaskIssueProgressStatusFilter([])
      if(this.favoriteFilterData.id){
        this.setAdvancedFilter([])
      }else{
        this.setAdvancedFilter([])        
      }
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
    },
    onClearFilter() {
      this.$confirm(`Are you sure you want to remove this favorite filter?`, 'Confirm Remove', {
        confirmButtonText: 'Remove',
        cancelButtonText: 'Cancel',
        type: MessageDialogService.msgTypes.WARNING
      }).then(() => {
        this.setTaskIssueUserFilter([])
        this.setTaskIssueProgressStatusFilter([])
        this.setAdvancedFilter([])
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

        var url = `${API_BASE_PATH}/programs/${this.currentProject.id}/query_filters/reset.json`
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
            message: `Favorite Filter is removed successfully.`,
            
            
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
#filterbar {
  position: absolute;
  z-index: 1100;
  transition: .4s ease;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.19), 0 24px 24px rgba(0, 0, 0, 0.23);
}
.vdp-datepicker.dp {
  height: 42.8px !important;
}
#filter_bar {
  overflow-y: auto;
  border-radius: 4px;
  background-color: #fafafa;
  height: calc(100vh - 94px);
  max-height: calc(100vh - 94px);
  width: 685px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.19), 0 24px 24px rgba(0, 0, 0, 0.23);
}
.filter-sections {
  background-color: #fff;
  border-top:solid #41b883 3.5px;
}
.filters_wrap {
  width: 90%;
  margin: 0 auto;
}
.fac-group-filter {
  min-height: 48px !important;
  margin-right: 0px !important;
  width: 100%;
}
.issueUser-select ::v-deep .multiselect,
.taskUser-select ::v-deep .multiselect,
.actions-select ::v-deep .multiselect,
.issetype-select ::v-deep .multiselect,
.issueSeverity-select ::v-deep .multiselect,
.issueProgress-select ::v-deep .multiselect,
.taskProgress-select ::v-deep .multiselect,
.tasktype-select ::v-deep .multiselect,
.progress-ranges-select ::v-deep .multiselect,
.facilityname-search ::v-deep .multiselect,
.facilitygroup-select ::v-deep .multiselect,
.status-select ::v-deep .multiselect {
  font-size: 14px;
  width: 280px;
  .multiselect__placeholder {
    margin-bottom: 10px;
    padding-top: 3px;
  }
  .select__tag-name {
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
    width: 170px;
  }
  .multiselect__option {
    white-space: normal;
  }
  .multiselect__option--selected:after {
    content: unset;
  }
  .multiselect__tags {
    padding-top: 6px;
  }
}
.facilitygroup-select,
.duedate-range {
  display: flex;
}
.project-select ::v-deep .multiselect {
  font-size: 14px;
  width: 280px;
  .multiselect__tags {
    min-height: 20px;
  }
  .multiselect__placeholder {
    margin-bottom: 2px;
    padding-top: 2px;
  }
  .select__tag-name {
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
    width: fit-content;
  }
  .multiselect__option {
    white-space: normal;
  }
  .multiselect__option--selected:after {
    content: unset;
  }
}
.taskissueoverdue-select ::v-deep .multiselect {
  font-size: 14px;
  width: 280px;
  .multiselect__tags {
    min-height: 20px;
  }
  .multiselect__placeholder {
    margin-bottom: 2px;
    padding-top: 2px;
  }
  .select__tag-name {
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
    width: fit-content;
  }
  .multiselect__option {
    white-space: normal;
  }
  .multiselect__option--selected:after {
    content: unset;
  }
}
a.disabled {
  pointer-events: none;
  cursor: default;
  opacity: 0.8;
}
.clear_btn {
  position: relative;
  top: -50px;
  left: 120px;
}
.filter-header {
  height: 30px;
}
.duedate-range ::v-deep .mx-datepicker-range {
  width: 280px;
  .mx-input {
    display: inline-block;
    box-sizing: border-box;
    box-shadow: none;
    width: 100%;
    height: 40px;
    padding: 6px 30px;
    padding-left: 8px;
    line-height: 1.4;
    background-color: #fff;
    border-radius: 4px;
    min-height: 40px;
    border: 1px solid #e8e8e8;
    font-size: 14px;
    &::placeholder {
      color: #adadad;
    }
  }
}
.notedate-range ::v-deep .mx-datepicker-range {
  width: 280px;
  .mx-input {
    display: inline-block;
    box-sizing: border-box;
    box-shadow: none;
    width: 100%;
    height: 40px;
    padding: 6px 30px;
    padding-left: 8px;
    line-height: 1.4;
    background-color: #fff;
    border-radius: 4px;
    min-height: 40px;
    border: 1px solid #e8e8e8;
    font-size: 14px;
    &::placeholder {
      color: #adadad;
    }
  }
}
.taskissueduedate-range ::v-deep .mx-datepicker-range {
  width: 280px;
  .mx-input {
    display: inline-block;
    box-sizing: border-box;
    box-shadow: none;
    width: 100%;
    height: 40px;
    padding: 6px 30px;
    padding-left: 8px;
    line-height: 1.4;
    background-color: #fff;
    border-radius: 4px;
    min-height: 40px;
    border: 1px solid #e8e8e8;
    font-size: 14px;
    &::placeholder {
      color: #adadad;
    }
  }
}
.datepicker,
.milestones {
  width: 100% !important;
}
.knocker {
  cursor: pointer;
  position: absolute;
  bottom: 10%;
  right: -85px;
  width: 140px;
  -moz-transform:rotate(-90deg);
  -ms-transform:rotate(-90deg);
  -o-transform:rotate(-90deg);
  -webkit-transform:rotate(-90deg);
}
.knocker-btn {
  // Bootstrap success color rgba with transparency
   background-color: rgba(65, 184, 131, .85);
}
.filter-border {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19), 0 3px 3px rgba(56, 56, 56, 0.23);
  border-radius: 5px;
  padding: 6px
}
.fav-filter {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19), 0 3px 3px rgba(56, 56, 56, 0.23);
  border-radius: 5px;
  background-color: #fff;
  border-top: solid #41b883 3.5px;
  padding: 6px
}
.btn-light, .btn-secondary {
  box-shadow: 0 2px 2px rgba(56, 56, 56, 0.19), 0 1.5px 1.5px rgba(56, 56, 56, 0.23) !important;
}
.selected-opt {
  position: relative;
  display: inline-block;
  padding: 5px 25px 5px 10px;
  border-radius: 5px;
  margin-right: 10px;
  color: #fff;
  line-height: 1;
  background: #41b883;
  white-space: nowrap;
  overflow: hidden;
  max-width: 100%;
  text-overflow: ellipsis;
}
.progress_ranges {
  label {
    margin-left: 0.5em;
    font-size: 14px;
    color: #adadad;
  }
  input {
    border-color: #e8e8e8;
  }
  ::placeholder {
    color: #bbb9b9;
  }
}
::placeholder { /* Chrome, Firefox, Opera, Safari 10.1+ */
  color: #bbb9b9;
  opacity: 1; /* Firefox */
}

:-ms-input-placeholder { /* Internet Explorer 10-11 */
  color: #bbb9b9;
}

::-ms-input-placeholder { /* Microsoft Edge */
  color: #bbb9b9;
}
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
/* Firefox */
input[type=number] {
  -moz-appearance: textfield;
  height: 34px;
}
::v-deep.mx-input {
  font-size: .75rem !important;
}
.clear-btn {
  text-decoration-line: none !important;
}
::v-deep.multiselect__tags {   
    padding: 4px 40px 0 8px;
    border-radius: 5px;
    border: 1px solid #ced4da;
    font-size: 13px;
    .multiselect__placeholder {
    padding-top:0;
    }
  }
.btn-success, .btn-danger {
   box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19), 0 3px 3px rgba(56, 56, 56, 0.23);
   text-decoration-line: none !important;
}
</style>
