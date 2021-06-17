<template>
  <div>
     <div class="w-75 filters-wrapper">
    <div class="d-flex align-item-center justify-content-between mb-2 w-100">
      <div class="w-100 mr-1">
        <label class="font-sm mb-0"><span style="visibility:hidden">L</span></label>
        <el-input
          type="search"
          placeholder="Search Risks"
          aria-label="Search"
          aria-describedby="search-addon"
          v-model="sidebarRisksQuery"
          data-cy="search_risks"
          ><el-button slot="prepend" icon="el-icon-search"></el-button
        ></el-input>
      </div>

      <div class="w-100 mr-1">
        <label class="font-sm mb-0">Category</label>
        <el-select
          v-model="C_taskTypeFilter"
          class="w-100"
          track-by="name"
          value-key="id"
          multiple
          placeholder="Select Category"
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
        </el-select>
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
import Kanban from "../../shared/kanban";

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
      ]),
    handleAddNew(stage) {
      if (!this.viewPermit(this.currentTab, "write")) return;

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
    ]),
    C_kanban() {
      let stages = [];
      let cards = [];

      stages = this.filterRiskStages;
      cards = this.filteredRisks;

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
      const sidebar_search_query = this.exists(this.sidebarRisksQuery.trim()) ? new RegExp(_.escapeRegExp(this.sidebarRisksQuery.trim().toLowerCase()),"i") : null      let noteDates = this.noteDateFilter
      let taskIssueDueDates = this.taskIssueDueDateFilter
      let taskIssueProgress = this.taskIssueProgressFilter
      let taskIssueUsers = this.getTaskIssueUserFilter
      var filterDataForAdvancedFilterFunction = this.filterDataForAdvancedFilter
      let risks = _.sortBy(_.filter(this.facility.risks, ((resource) => {
        let valid = Boolean(resource && resource.hasOwnProperty('progress'))
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
      if ( _.map(this.getAdvancedFilter, 'id') == 'draft' || _.map(this.getAdvancedFilter, 'id') == 'onHold') {           
        return risks
        
        } else  {
        
        risks  = risks.filter(t => t.draft == false && t.onHold == false)
        return risks
      
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

<style>
  .filters-wrapper {
    float: right;
    margin-top: -60px;
  }
</style>
