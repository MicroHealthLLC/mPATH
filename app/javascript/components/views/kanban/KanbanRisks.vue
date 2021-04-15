<template>
  <div>
    <div class="d-flex mb-4">
      <div
        class="searchBar input-group w-25 d-inline-flex mr-1 align-items-end"
      >
        <div class="input-group-prepend d-inline">
          <span class="input-group-text searchB"
            ><i class="fa fa-search"></i
          ></span>
        </div>
        <input
          type="search"
          class="form-control searchB form-control-sm"
          placeholder="Search Risks"
          aria-label="Search"
          aria-describedby="search-addon"
          v-model="sidebarRisksQuery"
          data-cy="search_risks"
        />
      </div>

      <div class="simple-select w-25 d-inline">
        <label class="font-sm mb-0">Category</label>
        <el-select
          v-model="C_taskTypeFilter"
          class="w-100"
          track-by="name"
          value-key="id"
          multiple
          placeholder="Select Category"
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
      <div class="simple-select w-25 d-inline">
        <label class="font-sm mb-0">Flags</label>
        <el-select
          v-model="C_kanbanTaskFilter"
          class="w-100"
          track-by="name"
          value-key="id"
          multiple
          placeholder="Filter by Flags"
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
    ...mapMutations(["setAdvancedFilter", "setTaskTypeFilter"]),
    handleAddNew(stage) {
      if (!this.viewPermit(this.currentTab, "write")) return;
      this.fixedStageId = stage.id;

      this.$router.push(
        `/programs/${this.$route.params.programId}/kanban/projects/${this.$route.params.projectId}/risks/new`
      );
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
      let taskTypeIds = _.map(this.C_taskTypeFilter, "id");
      let stageIds = _.map(this.riskStageFilter, "id");
      const search_query = this.exists(this.searchRisksQuery.trim())
        ? new RegExp(
            _.escapeRegExp(this.searchRisksQuery.trim().toLowerCase()),
            "i"
          )
        : null;
      const sidebar_search_query = this.exists(this.sidebarRisksQuery.trim())
        ? new RegExp(
            _.escapeRegExp(this.sidebarRisksQuery.trim().toLowerCase()),
            "i"
          )
        : null;

      let noteDates = this.noteDateFilter;
      let taskIssueDueDates = this.taskIssueDueDateFilter;
      let taskIssueProgress = this.taskIssueProgressFilter;
      let taskIssueUsers = this.getTaskIssueUserFilter;

      let riskPriorityLevelFilterIds = _.map(
        this.getRiskPriorityLevelFilter,
        "id"
      );

      let riskApproachIds = _.map(this.getRiskApproachFilter, "id");

      return _.orderBy(
        _.filter(this.facility.risks, (resource) => {
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
          valid =
            valid &&
            this.filterDataForAdvancedFilter([resource], "kanbanRisks");

          if (taskTypeIds.length > 0)
            valid = valid && taskTypeIds.includes(resource.taskTypeId);

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
            valid = is_valid;
          }

          if (taskIssueProgress && taskIssueProgress[0]) {
            let min = taskIssueProgress[0].value.split("-")[0];
            let max = taskIssueProgress[0].value.split("-")[1];
            valid =
              valid && resource.progress >= min && resource.progress <= max;
          }

          if (riskApproachIds.length > 0)
            valid = valid && riskApproachIds.includes(resource.riskApproach);

          if (riskPriorityLevelFilterIds.length > 0)
            valid =
              valid &&
              riskPriorityLevelFilterIds.includes(
                resource.priorityLevelName.toLowerCase()
              );

          if (
            this.searchStageId &&
            this.searchStageId == resource.riskStageId
          ) {
            if (search_query)
              valid = valid && search_query.test(resource.title);
          } else if (stageIds.length > 0) {
            valid = valid && stageIds.includes(resource.riskStageId);
          }
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

<style></style>
