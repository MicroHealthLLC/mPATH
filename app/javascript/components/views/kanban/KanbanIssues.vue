<template>
  <div>
    <div class="filters-wrapper">
    <div class="d-flex align-item-center justify-content-between ml-3 mb-2 w-100">
      <div
        class="ninety mr-1"
      >
       <label class="font-sm mb-0" style="visibility:hidden">Search</label>
        <el-input
          type="search"
          placeholder="Enter Search Criteria"
          aria-label="Search"
          aria-describedby="search-addon"
          v-model="sidebarIssuesQuery"
          data-cy="search_issues"
          ><el-button slot="prepend" icon="el-icon-search"></el-button
        ></el-input>
      </div>
      <div class="ninety mr-1">
        <label class="font-sm mb-0">Process Area</label>
        <el-select
          v-model="C_taskTypeFilter"
          class="w-100"
          track-by="name"
          value-key="id"
          multiple
          clearable
          placeholder="Select Process Area"
          collapse-tags
        >
          <el-option
            v-for="item in taskTypes"
            :value="item"
            :key="item.id"
            :label="item.name"
          >
          </el-option>
        </el-select>
      </div>
      <div class="w-100">
        <label class="font-sm mb-0">Flags</label>
             <span class="d-flex px-0 mr-1" :class="[getShowCount == true ? '': 'toggleHeight']">
               <span class="one statesCol px-2 mr-1 d-flex">
                 <div class="pt-1 pr-3 text-center d-inline-block icons" :class="[getHideComplete == true ? 'light':'']" @click.prevent="toggleComplete" >                              
                   <span class="d-block" v-tooltip="`COMPLETE`" >
                    <i class="fas fa-clipboard-check" :class="[getHideComplete == true ? 'light':'text-success']"></i>
                    </span>      
               
                   <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{variation.completed.count}}</h6>  
                  </div>
                 <div class="pr-3 pt-1 text-center d-inline-block icons" :class="[getHideInprogress == true ? 'light':'']" @click.prevent="toggleInprogress">                              
                   <span v-tooltip="`IN PROGRESS`" class="d-block">
                    <i class="far fa-tasks" :class="[getHideInprogress == true ? 'light':'text-primary']"></i>
                    </span>      
                
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.inProgress.count }}</h6>
                  </div>
                   <div class="pr-3 pt-1 text-center d-inline-block icons" :class="[getHidePlanned == true ? 'light':'']" @click.prevent="togglePlanned">                              
                   <span v-tooltip="`PLANNED`" class="d-block">
                    <i class="fas fa-calendar-check"  :class="[getHidePlanned == true ? 'light':'text-info']"></i>
                    </span>      
                
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.planned.count }}</h6>
                  </div>
                  <div class="pr-3 pt-1 text-center d-inline-block icons" :class="[getHideOverdue == true ? 'light':'']" @click.prevent="toggleOverdue" >                              
                   <span v-tooltip="`OVERDUE`" class="d-block">
                    <i class="fas fa-calendar" :class="[getHideOverdue == true ? 'light':'text-danger']"></i>
                    </span>      
                
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.overdue.count }}</h6>
                  </div>
                     
                  <div class="pr-3 pt-1 text-center d-inline-block icons" :class="[getHideOnhold == true ? 'light':'']"  @click.prevent="toggleOnhold"  >                              
                   <span v-tooltip="`ON HOLD`"  class="d-block">
                    <i class="fas fa-pause-circle" :class="[getHideOnhold == true ? 'light':'text-primary']"></i>
                    </span>      
        
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.onHold.count }}</h6>
                  </div>
                  <div class="pr-1 pt-1 text-center d-inline-block icons"  :class="[getHideDraft == true ? 'light':'']"  @click.prevent="toggleDraft" >                              
                   <span v-tooltip="`DRAFT`" class="d-block">
                    <i class="fas fa-pencil-alt"  :class="[getHideDraft == true ? 'light':'text-warning']"></i>
                    </span>      
         
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.drafts.count }}</h6>
                  </div>
                
  
               </span>
                <!-- <label>Tafsd</label> -->
               <span class="tagsCol px-2 d-flex">
     
                  <div class="pr-3 pt-1 text-center d-inline-block icons" :class="[getHideWatched == true ? '':'light']" @click.prevent="toggleWatched"  >                              
                   <span v-tooltip="`ON WATCH`"  class="d-block">
                    <i class="fas fa-eye"></i>
                    </span>      
          
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.watched.count }}</h6>
                  </div>
  
                  <div class="pr-3 pt-1 text-center d-inline-block icons" :class="[getHideImportant == true ? '':'light']" @click.prevent="toggleImportant">                              
                   <span v-tooltip="`IMPORTANT`" class="d-block">
                    <i class="fas fa-star" :class="[getHideImportant == true ? 'text-warning':'light']"></i>
                    </span>      
          
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.important.count }}</h6>
                  </div>
                  <div class="pr-2 pt-1 text-center d-inline-block icons" :class="[getHideBriefed == true ? '':'light']" @click.prevent="toggleBriefed">                              
                   <span v-tooltip="`BRIEFINGS`" class="d-block">
                    <i class="fas fa-presentation" :class="[getHideBriefed == true ? 'text-primary':'']"></i>
                    </span>      
                   <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.briefings.count }}</h6>
                  </div>  

               </span>

                   <div class="d-inline-block mx-0">
             <!-- <v-app id="app"> -->
             <v-checkbox     
           v-model="C_showCountToggle"     
            class="d-inline-block mt-0 px-2 ml-1"  
            @click.prevent="showCounts"               
           v-tooltip="`Show Counts`"
          ></v-checkbox>
             <!-- </v-app> -->

          </div>
            </span>
        <!-- <label class="font-sm mb-0">Flags</label>
        <el-select
          v-model="C_kanbanTaskFilter"
          class="w-100"
          track-by="name"
          value-key="id"
          multiple
          placeholder="Filter by Flags"
          collapse-tags
        >
          <el-option
            v-for="item in getAdvancedFilterOptions"
            :value="item"
            :key="item.id"
            :label="item.name"
          >
          </el-option>
        </el-select> -->
      </div>
    </div>
    </div>
    <Kanban
      :stages="C_kanban.stages"
      :kanban-type="kanbanType"
      :cards="C_kanban.cards"
      @on-add-new="handleAddNew"
      @on-search-change="handleSearchQueryChange"
    ></Kanban>
  </div>
  
</template>

<script>
import { mapGetters, mapMutations } from "vuex";
import Kanban from "../../shared/kanban.vue";

export default {
  props: ["facility"],
  components: {
    Kanban,
  },
  data() {
    return {
      kanbanType: "issues",
      currentTab: "issues",
      searchIssuesQuery: "",
      sidebarIssuesQuery: "",
      searchStageId: null,
    };
  },
  methods: {
    ...mapMutations([
    "setAdvancedFilter", 
    "setTaskTypeFilter", 
    'setIssueTypeFilter',
    'setIssueSeverityFilter',
    'setShowCount',
    // 7 States
    'setHideComplete',
    'setHideInprogress',
    'setHidePlanned',
    'setHideOverdue',
    'setHideOnhold',
      'setHideDraft',
    // 3 Tags
    'setHideWatched',
    'setHideImportant',
    'setHideBriefed',
    ]),

    //TODO: change the method name of isAllowed
    _isallowed(salut) {
        return this.checkPrivileges("KanbanIsues", salut, this.$route)

      // var programId = this.$route.params.programId;
      // var projectId = this.$route.params.projectId
      // let fPrivilege = this.$projectPrivileges[programId][projectId]
      // let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      // let s = permissionHash[salut]
      // return  fPrivilege.issues.includes(s); 
    },
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
    toggleOnhold(){
        this.setHideOnhold(!this.getHideOnhold)    
    },
    toggleOverdue(){
    //  this.setAdvancedFilter({id: 'overdue', name: 'Overdue', value: "overdue", filterCategoryId: 'overDueFilter', filterCategoryName: 'Action Overdue'}) 
      this.setHideOverdue(!this.getHideOverdue)    
    },
    showCounts(){
      this.setShowCount(!this.getShowCount)       
    },

    handleAddNew(stage) {
      // if (!this.viewPermit(this.currentTab, "write")) return;
      if(!this._isallowed('write')) return;

      // Route to new issue form page
      this.$router.push({
        name: "KanbanIssueForm",
        params: {
          programId: this.$route.params.programId,
          projectId: this.$route.params.projectId,
          issueId: "new",
          stage: stage,
        },
      });
    },
    handleSearchQueryChange(searchElement) {
      this.searchStageId = $(searchElement).attr("data-stage-id");
      if ($(searchElement).attr("data-kanban-type") == "issues") {
        this.searchIssuesQuery = $(searchElement).val();
      }
    },
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "filterDataForAdvancedFilter",
      "getAdvancedFilter",
      "getAdvancedFilterOptions",
      "getTaskIssueUserFilter",
      "issueSeverityFilter",
      "issueStageFilter",
      "issueStages",
      "issueTypeFilter",
      "noteDateFilter",
      "taskTypeFilter",
      "taskTypes",
      "viewPermit",
      'getShowCount',
      // 7 States
      'getHideComplete',
      'getHideInprogress',
      'getHidePlanned',
      'getHideOnhold',
      'getHideDraft',
      'getHideOverdue',
      // 3 Tags
      'getHideWatched',
      'getHideImportant',
      'getHideBriefed',
    ]),
    C_kanban() {
      let stages = [];
      let cards = [];

      stages = this.filterIssueStages;
      cards = this.filteredIssues.filtered.issues;

      return { stages, cards };
    },
    filterIssueStages() {
      let stageIds = _.map(this.issueStageFilter, "id");
      return _.filter(this.issueStages, (s) =>
        stageIds && stageIds.length ? stageIds.includes(s.id) : true
      );
    },
    filteredIssues() {
      let typeIds = _.map(this.C_issueTypeFilter, "id");
      let taskTypeIds = _.map(this.C_taskTypeFilter, "id");
      let severityIds = _.map(this.C_issueSeverityFilter, "id");
      let stageIds = _.map(this.issueStageFilter, "id");
      const search_query = this.exists(this.searchIssuesQuery.trim()) ? new RegExp(_.escapeRegExp(this.searchIssuesQuery.trim().toLowerCase()),"i") : null
      const sidebar_search_query = this.exists(this.sidebarIssuesQuery.trim()) ? new RegExp(_.escapeRegExp(this.sidebarIssuesQuery.trim().toLowerCase()),"i") : null
      let noteDates = this.noteDateFilter;
      let taskIssueDueDates = this.taskIssueDueDateFilter;
      let taskIssueProgress = this.taskIssueProgressFilter;
      let taskIssueUsers = this.getTaskIssueUserFilter;
      let issues = _.sortBy(
        _.filter(this.facility.issues, (resource) => {
          let valid = Boolean(resource && resource.hasOwnProperty("progress"));
          if (resource.issueStageId == null) {
            return resource.issueStageId !== null
          }
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
          valid = valid && this.filterDataForAdvancedFilter([resource], "kanbanIssues");
          if (typeIds.length > 0)
            valid = valid && typeIds.includes(resource.issueTypeId);
          if (taskTypeIds.length > 0)
            valid = valid && taskTypeIds.includes(resource.taskTypeId);
          if (severityIds.length > 0)
            valid = valid && severityIds.includes(resource.issueSeverityId)
          if (stageIds.length > 0) 
            valid = valid && stageIds.includes(resource.issueStageId)
          if (noteDates && noteDates[0] && noteDates[1]) {
            let startDate = moment(noteDates[0], "YYYY-MM-DD");
            let endDate = moment(noteDates[1], "YYYY-MM-DD");
            let _notesCreatedAt = _.map(resource.notes, "createdAt");
            let is_valid = resource.notes.length > 0;
            for (let createdAt of _notesCreatedAt) {
              let nDate = moment(createdAt, "YYYY-MM-DD");
              is_valid = nDate.isBetween(startDate, endDate, "days", true);
              if (is_valid) break;
            }
            valid = is_valid;
          }
          if (taskIssueDueDates && taskIssueDueDates[0] && taskIssueDueDates[1]) {
            let startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD");
            let endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD");
            let is_valid = true;
            let nDate = moment(resource.dueDate, "YYYY-MM-DD");
            is_valid = nDate.isBetween(startDate, endDate, "days", true);
            valid = is_valid;
          }
          if (taskIssueProgress && taskIssueProgress[0]) {
            let min = taskIssueProgress[0].value.split("-")[0];
            let max = taskIssueProgress[0].value.split("-")[1];
            valid =
              valid && resource.progress >= min && resource.progress <= max;
          }
          if (search_query) valid = valid && search_query.test(resource.title) ||
            valid && search_query.test(resource.issueType) ||
            valid && search_query.test(resource.issueSeverity) ||
            valid && search_query.test(resource.userNames)
          if (sidebar_search_query) valid = valid && sidebar_search_query.test(resource.title) ||
            valid && sidebar_search_query.test(resource.issueType) ||
            valid && sidebar_search_query.test(resource.issueSeverity) ||
            valid && sidebar_search_query.test(resource.userNames) 
          
          return valid;
        }),
        "kanbanOrder",
        "asc"
      );
         return {
       unfiltered: {
          issues
            },
       filtered: {
         issues:  issues.filter(t => {
        if (this.getHideOverdue == true) {          
         return t.isOverdue == false
       } else return true

      }).filter(t => {
      if (this.getHideComplete == true) { 
        return !t.completed
      } else return true

      }).filter(t => {
      if (this.getHidePlanned == true) { 
        return t.planned == false
      } else return true

      }).filter(t => {
      if (this.getHideOnhold == true) { 
        return t.onHold == false
      } else return true

      }).filter(t => {
      if (this.getHideInprogress == true) { 
        return t.inProgress == false
      } else return true
     
      }).filter(t => {
       if (this.getHideDraft == true){
         return t.draft == false
       } else return true   

        }).filter(t => {
         if (this.getHideBriefed && !this.getHideWatched && !this.getHideImportant ) {
          return t.reportable
        }
        if (this.getHideBriefed && this.getHideWatched && !this.getHideImportant) {          
           return t.reportable + t.watched

        } if (this.getHideBriefed && this.getHideWatched && this.getHideImportant) {          
           return t.reportable + t.watched + t.important
        } else return true

      }).filter(t => {
        // This and last 2 filters are for Filtered Tags
         if (this.getHideWatched && !this.getHideBriefed && !this.getHideImportant) {
           return t.watched
        } if (this.getHideWatched && !this.getHideBriefed && this.getHideImportant) {
           return t.watched + t.important
        } if (this.getHideWatched && this.getHideBriefed && !this.getHideImportant) {          
           return  t.watched + t.reportable
        } if (this.getHideWatched && this.getHideBriefed && this.getHideImportant) {          
           return  t.watched + t.reportable + t.important
        } else return true          
       
      }).filter(t => {
         if (this.getHideImportant && !this.getHideBriefed && !this.getHideWatched) {
          return t.important
        } if (this.getHideImportant && this.getHideBriefed && !this.getHideWatched) {
          return t.important + t.reportable
       } if (this.getHideImportant && this.getHideBriefed && this.getHideWatched) {
          return t.important + t.reportable + t.watched
        } else return true          
       }),
       }
       }       
    },
  variation() {
    let planned = _.filter(
      this.filteredIssues.unfiltered.issues,
        (t) => t && t.planned 
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let drafts = _.filter(
      this.filteredIssues.unfiltered.issues,
        (t) => t && t.draft
      );  
      let important = _.filter(
      this.filteredIssues.unfiltered.issues,
        (t) => t && t.important 
      ); 
        let briefings = _.filter(
      this.filteredIssues.unfiltered.issues,
        (t) => t && t.reportable 
      );
      let watched = _.filter(
      this.filteredIssues.unfiltered.issues,
        (t) => t && t.watched 
      );
              
      let completed = _.filter(
      this.filteredIssues.unfiltered.issues,
        (t) => t && t.completed 
      );
      let inProgress = _.filter(
      this.filteredIssues.unfiltered.issues,
        (t) => t && t.inProgress 
      );
     let onHold = _.filter(this.filteredIssues.unfiltered.issues, (t) => t && t.onHold == true );
     let overdue = _.filter(this.filteredIssues.unfiltered.issues, (t) => t.isOverdue == true);

      return {
        planned: {
          count: planned.length, 
          plannedTs: planned            
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
        onHold: {
          count: onHold.length,          
        },
        drafts: {
          count: drafts.length,          
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
    C_showCountToggle: {                  
    get() {
      return this.getShowCount                
    },
    set(value) {
      this.setShowCount(value) ||  this.setShowCount(!this.getShowCount)
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
    C_taskTypeFilter: {
      get() {
        return this.taskTypeFilter;
      },
      set(value) {
        this.setTaskTypeFilter(value);
      },
    },
    C_kanbanTaskFilter: {
      get() {
        return this.getAdvancedFilter;
      },
      set(value) {
        this.setAdvancedFilter(value);
      },
    },
  },
};
</script>

<style lang="scss" scoped>
.ninety {
  width: 75%;
}

.filters-wrapper {
    float: right; 
    margin-top: -70px;
    width: 85%;
  }
.tagsCol, .statesCol {
  border-radius: 4px;
  border: .5px solid lightgray;
}

.tagsCol {
  background-color: #f8f9fa;
}

.toggleHeight {
  height: 32px;
}

</style>
