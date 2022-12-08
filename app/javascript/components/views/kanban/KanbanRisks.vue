<template>
  <div>
     <div class="filters-wrapper">
    <div class="d-flex align-item-center justify-content-between mb-2 ml-3 w-100">
      <div class="ninety mr-1">
        <label class="font-sm mb-0" style="visibility:hidden">Search</label>
        <el-input
          type="search"
          placeholder="Enter Search Criteria"
          aria-label="Search"
          aria-describedby="search-addon"
          v-model="sidebarRisksQuery"
          data-cy="search_risks"
          ><el-button slot="prepend" icon="el-icon-search"></el-button
        ></el-input>
      </div>

      <div class="ninety mr-1" :load="log(filterRiskStages)">
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
                    <div class="pr-3 pt-1 text-center d-inline-block icons" :class="[getHideOngoing == true ? 'light':'']" @click.prevent="toggleOngoing" >                              
                   <span v-tooltip="`ONGOING`"  class="d-block">
                    <i class="fas fa-retweet" :class="[getHideOngoing == true ? 'light':'text-success']"></i>
                    </span>      
              
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.ongoing.count }}
                      <span 
                        v-tooltip="`Ongoing: Closed`"
                        v-if="variation.ongoingClosed.count > 0"
                        style="color:lightgray"                      
                        >({{variation.ongoingClosed.count}})
                      </span>
                      </h6>
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
      kanbanType: "risks",
      currentTab: "risks",
      searchRisksQuery: "",
      sidebarRisksQuery: "",
      searchStageId: null,
    };
  },
  methods: {
    ...mapMutations([
      "setAdvancedFilter",
      "setTaskTypeFilter",      
      "setRiskPriorityLevelFilter",
      "setRiskApproachFilter",
      'setShowCount',
      // 7 States
      'setHideComplete',
      'setHideInprogress',
      'setHidePlanned',
      'setHideOverdue',
      'setHideOngoing',
      'setHideOnhold',
        'setHideDraft',
      // 3 Tags
      'setHideWatched',
      'setHideImportant',
      'setHideBriefed',
      
      
      ]),

    //TODO: change the method name of isAllowed
    _isallowed(salut) {
        return this.checkPrivileges("KanbanRisks", salut, this.$route)

      // var programId = this.$route.params.programId;
      // var projectId = this.$route.params.projectId
      // let fPrivilege = this.$projectPrivileges[programId][projectId]
      // let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      // let s = permissionHash[salut]
      // return  fPrivilege.risks.includes(s); 
    },
    log(e){
      console.log({e})

    },
    handleAddNew(stage) {
      // if (!this.viewPermit(this.currentTab, "write")) return;
      if(!this._isallowed('write')) return;

      this.$router.push({
        name: "KanbanRiskForm",
        params: {
          programId: this.$route.params.programId,
          projectId: this.$route.params.projectId,
          riskId: "new",
          stage: stage,
        },
      });
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
    toggleOngoing(){
        this.setHideOngoing(!this.getHideOngoing)    
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
    handleSearchQueryChange(searchElement) {
      this.searchStageId = $(searchElement).attr("data-stage-id");
      if ($(searchElement).attr("data-kanban-type") == "risks") {
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
      "noteDateFilter",
      'getRiskApproachFilterOptions',
      'getRiskApproachFilter',
      'getRiskPriorityLevelFilter',
      'getRiskPriorityLevelFilterOptions',
      "riskStageFilter",
      "riskStages",
      "taskIssueDueDateFilter",
      "taskIssueProgressFilter",
      "taskTypeFilter",
      "taskTypes",
      "viewPermit",
      'getShowCount',
      // 7 States
      'getHideComplete',
      'getHideInprogress',
      'getHidePlanned',
      'getHideOngoing',
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

      stages = this.filterRiskStages;
      cards = this.filteredRisks.filtered.risks;

      return { stages, cards };
    },
    filterRiskStages() {
      let stageIds = _.map(this.riskStageFilter, "id");
      return _.filter(this.riskStages, (s) =>
        stageIds && stageIds.length ? stageIds.includes(s.id) : true
      );
    },
    filteredRisks() {
      let milestoneIds = _.map(this.C_taskTypeFilter, 'id')
      let stageIds = _.map(this.riskStageFilter, 'id')
      let riskApproachIds = _.map(this.C_riskApproachFilter, 'id')
      let riskPriorityLevelFilterIds = _.map(this.C_riskPriorityLevelFilter, 'id')
      let riskPriorityLevelFilter = this.getRiskPriorityLevelFilter
      const search_query = this.exists(this.searchRisksQuery.trim()) ? new RegExp(_.escapeRegExp(this.searchRisksQuery.trim().toLowerCase()),"i") : null
      const sidebar_search_query = this.exists(this.sidebarRisksQuery.trim()) ? new RegExp(_.escapeRegExp(this.sidebarRisksQuery.trim().toLowerCase()),"i") : null     
     let noteDates = this.noteDateFilter
     let taskIssueDueDates = this.taskIssueDueDateFilter
      let taskIssueProgress = this.taskIssueProgressFilter
      let taskIssueUsers = this.getTaskIssueUserFilter
      var filterDataForAdvancedFilterFunction = this.filterDataForAdvancedFilter
      let risks = _.sortBy(_.filter(this.facility.risks, ((resource) => {
        let valid = Boolean(resource && resource.hasOwnProperty('progress'))
        if (resource.riskStageId == null) {
            return resource.riskStageId !== null
          }
        let userIds = [..._.map(resource.checklists, 'userId'), resource.userIds]
        if(taskIssueUsers.length > 0){
          valid = valid && userIds.some(u => _.map(taskIssueUsers, 'id').indexOf(u) !== -1)
        }
        //TODO: For performance, send the whole tasks array instead of one by one
        valid = valid && filterDataForAdvancedFilterFunction([resource], 'kanbanRisks')
        if (stageIds.length > 0) valid = valid && stageIds.includes(resource.riskStageId)
        if (taskIssueProgress && taskIssueProgress[0]) {
          var min = taskIssueProgress[0].value.split("-")[0]
          var max = taskIssueProgress[0].value.split("-")[1]
          valid = valid && (resource.progress >= min && resource.progress <= max)
        }
        if (milestoneIds.length > 0) valid = valid && milestoneIds.includes(resource.taskTypeId)
        if (riskApproachIds.length > 0) valid = valid && riskApproachIds.includes(resource.riskApproach)
        if (riskPriorityLevelFilterIds.length > 0) valid = valid && riskPriorityLevelFilterIds.includes(resource.priorityLevelName.toLowerCase())        
        if (sidebar_search_query) valid = valid && sidebar_search_query.test(resource.text) ||
        valid && sidebar_search_query.test(resource.text) ||
        valid && sidebar_search_query.test(resource.riskApproach) ||
        valid && sidebar_search_query.test(resource.priorityLevelName) ||
        valid && sidebar_search_query.test(resource.taskType.name) ||
        valid && sidebar_search_query.test(resource.userNames)
        return valid;
      })), 'kanbanOrder', 'asc')
         return {
       unfiltered: {
            risks
            },
       filtered: {
           risks: risks.filter(t => {
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
       if (this.getHideOngoing == true) {
          return t.ongoing == false
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
      this.filteredRisks.unfiltered.risks,
        (t) => t && t.planned == true
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let drafts = _.filter(
        this.filteredRisks.unfiltered.risks,
        (t) => t && t.draft 
      );  
      let important = _.filter(
       this.filteredRisks.unfiltered.risks,
        (t) => t && t.important
      ); 
      let briefings = _.filter(
         this.filteredRisks.unfiltered.risks,
        (t) => t && t.reportable 
      );
      let watched = _.filter(
       this.filteredRisks.unfiltered.risks,
        (t) => t && t.watched 
      );
              
      let completed = _.filter(
        this.filteredRisks.unfiltered.risks,
        (t) => t && t.completed
      );
    let inProgress = _.filter(
        this.filteredRisks.unfiltered.risks,
        (t) => t && t.inProgress 
      );
     let onHold = _.filter(this.filteredRisks.unfiltered.risks, (t) => t && t.onHold == true );
     let ongoing = _.filter(this.filteredRisks.unfiltered.risks, (t) => t && t.ongoing == true );
     let ongoingClosed = _.filter(this.filteredRisks.unfiltered.risks, (t) => t && t.closed == true );
     let overdue = _.filter(this.filteredRisks.unfiltered.risks, (t) => t.isOverdue == true);

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
        ongoingClosed: {
          count: ongoingClosed.length,
        },
         ongoing: {
          count: ongoing.length
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

<style scoped lang="scss">
.ninety {
  width: 75%;
}

.filters-wrapper {
  float:right;
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
