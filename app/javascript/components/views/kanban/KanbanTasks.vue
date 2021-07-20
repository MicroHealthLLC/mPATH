<template>
<div>
  <div class="w-75 filters-wrapper">
    <div class="d-flex align-item-center justify-content-between mb-2 w-100">
      <div class="task-search-bar w-100 mr-1">
         <label class="font-sm mb-0"><span style="visibility:hidden">L</span></label>
        <el-input
          type="search"
          placeholder="Search Tasks"
          aria-label="Search"
          aria-describedby="search-addon"
          v-model="sidebarTasksQuery"
          data-cy="search_tasks"
        >
          <el-button slot="prepend" icon="el-icon-search"></el-button>
        </el-input>
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
      kanbanType: "tasks",
      currentTab: "tasks",
      searchTasksQuery: "",
      sidebarTasksQuery: "",
      searchStageId: null,
    };
  },
  methods: {
    ...mapMutations(["setAdvancedFilter", "setTaskTypeFilter"]),
    //TODO: change the method name of isAllowed
    _isallowed(salut) {
      var programId = this.$route.params.programId;
      var projectId = this.$route.params.projectId
      let fPrivilege = this.$projectPrivileges[programId][projectId]
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return  fPrivilege.tasks.includes(s); 
    },
    handleAddNew(stage) {
      //if (!this.viewPermit(this.currentTab, "write")) return;
      if(!this._isallowed('write')) return;

      this.$router.push({
        name: "KanbanTaskForm",
        params: {
          programId: this.$route.params.programId,
          projectId: this.$route.params.projectId,
          taskId: "new",
          stage: stage,
        },
      });
    },
    handleSearchQueryChange(searchElement) {
      this.searchStageId = $(searchElement).attr("data-stage-id");
      if ($(searchElement).attr("data-kanban-type") == "tasks") {
        this.searchTasksQuery = $(searchElement).val();
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
      "taskIssueDueDateFilter",
      "taskIssueProgressFilter",
      "taskStageFilter",
      "taskStages",
      "taskTypeFilter",
      "taskTypes",
      "viewPermit",
    ]),
    C_kanban() {
      let stages = [];
      let cards = [];

      stages = this.filterTaskStages;
      cards = this.filteredTasks;

      return { stages, cards };
    },
    filterTaskStages() {
      let stageIds = _.map(this.taskStageFilter, "id");
      return _.filter(this.taskStages, (s) =>
        stageIds && stageIds.length ? stageIds.includes(s.id) : true
      );
    },
    filteredTasks() {
      let typeIds = _.map(this.C_taskTypeFilter, "id");
      let stageIds = _.map(this.taskStageFilter, "id");
      const search_query = this.exists(this.searchTasksQuery.trim())
        ? new RegExp(
            _.escapeRegExp(this.searchTasksQuery.trim().toLowerCase()),
            "i"
          )
        : null;
      const sidebar_search_query = this.exists(this.sidebarTasksQuery.trim())
        ? new RegExp(
            _.escapeRegExp(this.sidebarTasksQuery.trim().toLowerCase()),
            "i"
          )
        : null;
      let noteDates = this.noteDateFilter;
      let taskIssueDueDates = this.taskIssueDueDateFilter;
      let taskIssueProgress = this.taskIssueProgressFilter;

      let taskIssueUsers = this.getTaskIssueUserFilter;
      var filterDataForAdvancedFilterFunction = this
        .filterDataForAdvancedFilter;

      return _.orderBy(
        _.filter(this.facility.tasks, (resource) => {
          let valid = Boolean(resource && resource.hasOwnProperty("progress"));
          if (typeIds.length > 0)
            valid = valid && typeIds.includes(resource.taskTypeId);
          if (stageIds.length > 0)
            valid = valid && stageIds.includes(resource.taskStageId);
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
            filterDataForAdvancedFilterFunction([resource], "kanbanTasks");

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
            valid = valid && is_valid;
          }

          if (
            taskIssueDueDates &&
            taskIssueDueDates[0] &&
            taskIssueDueDates[1]
          ) {
            let startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD");
            let endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD");
            let is_valid = true;
            let nDate = moment(resource.dueDate, "YYYY-MM-DD");
            is_valid = nDate.isBetween(startDate, endDate, "days", true);
            valid = valid && is_valid;
          }

          if (taskIssueProgress && taskIssueProgress[0]) {
            let min = taskIssueProgress[0].value.split("-")[0];
            let max = taskIssueProgress[0].value.split("-")[1];
            valid =
              valid && resource.progress >= min && resource.progress <= max;
          }

          if (search_query) valid = valid && search_query.test(resource.text);
          if (sidebar_search_query)
            valid = valid && sidebar_search_query.test(resource.text);
          return valid;
        }),
        "kanbanOrder",
        "asc"
      );
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
