<template>
  <div>
    <div class="w-75 filters-wrapper">
    <div class="d-flex align-item-center justify-content-between mb-2 w-100">
      <div
        class="w-100 mr-1"
      >
       <label class="font-sm mb-0"><span style="visibility:hidden">L</span></label>
        <el-input
          type="search"
          placeholder="Search Issues"
          aria-label="Search"
          aria-describedby="search-addon"
          v-model="sidebarIssuesQuery"
          data-cy="search_issues"
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
    ]),
    handleAddNew(stage) {
      if (!this.viewPermit(this.currentTab, "write")) return;

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
    ]),
    C_kanban() {
      let stages = [];
      let cards = [];

      stages = this.filterIssueStages;
      cards = this.filteredIssues;

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
      let issues = _.orderBy(
        _.filter(this.facility.issues, (resource) => {
          let valid = Boolean(resource && resource.hasOwnProperty("progress"));
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
      if ( _.map(this.getAdvancedFilter, 'id') == 'draft' || _.map(this.getAdvancedFilter, 'id') == 'onHold') {   
        
        return issues
        
       } else  {
        
        issues  = issues.filter(t => t.draft == false && t.onHold == false)
        return issues
      
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

<style>
  .filters-wrapper {
    float: right;
    margin-top: -60px;
  }
</style>
