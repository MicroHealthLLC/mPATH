<template>
  <div id="filterbar" :style="filterBarStyle">
    <div id="filter_bar" class="shadow-sm">
      <div class="text-center my-3 filter-header">
        <h5 class="mb-4">Filter Map</h5>
        <button class="btn btn-sm btn-link clear_btn" @click.prevent="onClearFilter">clear</button>
      </div>
      <div class="filters_wrap">
        <div class="project-select my-3">
          <multiselect
            v-model="currentProject"
            track-by="name"
            label="name"
            placeholder="Select Project"
            :options="DV_projects"
            :searchable="false"
            :allow-empty="false"
            select-label="Select"
            @select="updateProjectQuery"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name selected-opt'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <div class="facilitygroup-select my-3">
          <multiselect
            v-model="currentFacilityGroup"
            track-by="name"
            label="name"
            placeholder="Filter by Facility Group"
            :options="DV_facilityGroups"
            :multiple="true"
            :max="1"
            select-label="Select"
            deselect-Label="Remove"
            :searchable="false"
            @select="updateFacilityGroupFilter"
            @remove="removeFacilityGroupFilter"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <div class="facilityname-search my-3">
          <multiselect
            placeholder="Search by Facility Name"
            v-model="selectedFacility"
            label="facilityName"
            track-by="id"
            :multiple="true"
            :max="1"
            :options="facilities"
            :searchable="true"
            :loading="isLoading"
            :preserve-search="true"
            select-label="Select"
            deselect-Label="Remove"
            @select="onSelectFacility"
            @remove="onRemoveFacility"
            @search-change="findFacility"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.facilityName}}</span>
              </div>
            </template>
            <span slot="noOptions">...</span>
          </multiselect>
        </div>
        <div class="status-select">
          <multiselect
            v-model="currentStatus"
            track-by="name"
            label="name"
            placeholder="Filter by Status"
            :options="DV_statuses"
            :searchable="false"
            :multiple="true"
            :max="1"
            select-label="Select"
            deselect-Label="Remove"
            @select="updateStatusFilter"
            @remove="removeStatusFilter"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <div class="progress-ranges-select my-3">
          <multiselect
            v-model="currentProgress"
            track-by="name"
            label="name"
            placeholder="Facility % Progress Range"
            :options="DV_progressRanges"
            :searchable="false"
            :multiple="true"
            :max="1"
            select-label="Select"
            deselect-Label="Remove"
            @select="updateProgressFilter"
            @remove="removeProgressFilter"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <div class="duedate-range my-3">
          <v2-date-picker
            v-model="dueDateRange"
            placeholder="Due Date Range"
            range
          />
        </div>
        <div class="tasktype-select my-3">
          <multiselect
            v-model="currentTaskType"
            track-by="name"
            label="name"
            placeholder="Filter by Task Type"
            :options="DV_taskTypes"
            :searchable="false"
            :multiple="true"
            :max="1"
            select-label="Select"
            deselect-Label="Remove"
            @select="updateTaskTypeFilter"
            @remove="removeTaskTypeFilter"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <div class="taskProgress-select my-3">
          <multiselect
            v-model="currentTaskProgress"
            track-by="name"
            label="name"
            placeholder="Task % Progress Range"
            :options="DV_taskProgressRanges"
            :searchable="false"
            :multiple="true"
            :max="1"
            select-label="Select"
            deselect-Label="Remove"
            @select="updateTaskProgressFilter"
            @remove="removeTaskProgressFilter"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <div class="issetype-select my-3">
          <multiselect
            v-model="currentIssueType"
            track-by="name"
            label="name"
            placeholder="Filter by Issue Type"
            :options="DV_issueTypes"
            :searchable="false"
            :multiple="true"
            :max="1"
            select-label="Select"
            deselect-Label="Remove"
            @select="updateIssueTypeFilter"
            @remove="removeIssueTypeFilter"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <div class="issueProgress-select my-3">
          <multiselect
            v-model="currentIssueProgress"
            track-by="name"
            label="name"
            placeholder="Issue % Progress Range"
            :options="DV_issueProgressRanges"
            :searchable="false"
            :multiple="true"
            :max="1"
            select-label="Select"
            deselect-Label="Remove"
            @select="updateIssueProgressFilter"
            @remove="removeIssueProgressFilter"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <div class="issueSeverity-select my-3">
          <multiselect
            v-model="currentIssueSeverity"
            track-by="name"
            label="name"
            placeholder="Filter by Issue Severity"
            :options="DV_issueSeverities"
            :searchable="false"
            :multiple="true"
            :max="1"
            select-label="Select"
            deselect-Label="Remove"
            @select="updateIssueSeverityFilter"
            @remove="removeIssueSeverityFilter"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
      </div>
      <div class="export-btn my-4">
        <button @click.prevent="exportData" :disabled="!enableExport && !exporting" class="btn btn-info badge badge-pill px-3">Export</button>
      </div>
    </div>
    <div class="knocker" @click="showFilters=!showFilters">
      <div class="linner"></div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'Navbar',
    props: ['projects', 'statuses', 'facilityGroups', 'taskTypes', 'issueTypes', 'issueSeverities'],
    data() {
      return {
        isLoading: false,
        exporting: false,
        enableExport: this.$listeners['is-exportable'](),
        showFilters: false,
        currentProject: null,
        currentStatus: null,
        currentTaskType: null,
        currentFacilityGroup: null,
        selectedFacility: null,
        currentProgress: null,
        dueDateRange: null,
        currentIssueType: null,
        currentIssueSeverity: null,
        currentIssueProgress: null,
        currentTaskProgress: null,
        facilities: [],
        DV_statuses: this.statuses,
        DV_taskTypes: this.taskTypes,
        DV_issueTypes: this.issueTypes,
        DV_issueSeverities: this.issueSeverities,
        DV_facilityGroups: this.facilityGroups,
        DV_projects: this.projects,
        DV_progressRanges: this.progressRanges(),
        DV_issueProgressRanges: this.progressRanges(),
        DV_taskProgressRanges: this.progressRanges()
      }
    },
    mounted() {
      this.currentProject = this.DV_projects.find(project => project.id == this.$route.params.projectId)
    },
    updated() {
      this.$nextTick(() => {
        this.enableExport = this.$listeners['is-exportable']()
      })
    },
    computed: {
      allowFacilityAdd() {
        return this.currentProject
      },
      filterBarStyle() {
        if (this.showFilters) return {}
        return {
          transform: 'translateX(-320px)'
        }
      }
    },
    methods: {
      updateProjectQuery(selected, index) {
        window.location.pathname = "/projects/" + selected.id
        // this.$router.push({name: 'ProjectDashboard', params: {projectId: selected.id} })
      },
      progressRanges() {
        return [
          { name: '0', value: '0'},
          { name: '11-20', value: '11-20'},
          { name: '21-30', value: '21-30'},
          { name: '31-40', value: '31-40'},
          { name: '41-50', value: '41-50'},
          { name: '51-60', value: '51-60'},
          { name: '61-70', value: '61-70'},
          { name: '71-80', value: '71-80'},
          { name: '81-90', value: '81-90'},
          { name: '91-99', value: '91-99'},
          { name: '100', value: '100'}
        ]
      },
      updateStatusFilter(selected, index) {
        this.$emit('on-status-change', selected)
      },
      removeStatusFilter() {
        this.$emit('on-status-change', {id: 'sa'})
      },
      updateFacilityGroupFilter(selected, index) {
        this.$emit('on-facilitygroup-change', selected)
      },
      removeFacilityGroupFilter() {
        this.$emit('on-facilitygroup-change', {id: 'sa'})
      },
      updateProgressFilter(selected, index) {
        this.$emit('on-progress-change', selected)
      },
      removeProgressFilter() {
        this.$emit('on-progress-change', {id: 'sa'})
      },
      updateTaskTypeFilter(selected, index) {
        this.$emit('on-tasktype-change', selected)
      },
      removeTaskTypeFilter() {
        this.$emit('on-tasktype-change', {id: 'sa'})
      },
      updateIssueTypeFilter(selected, index) {
        this.$emit('on-issuetype-change', selected)
      },
      removeIssueTypeFilter() {
        this.$emit('on-issuetype-change', {id: 'sa'})
      },
      updateIssueSeverityFilter(selected, index) {
        this.$emit('on-issueseverity-change', selected)
      },
      removeIssueSeverityFilter() {
        this.$emit('on-issueseverity-change', {id: 'sa'})
      },
      updateIssueProgressFilter(selected, index) {
        this.$emit('on-issueprogress-change', selected)
      },
      removeIssueProgressFilter() {
        this.$emit('on-issueprogress-change', {id: 'sa'})
      },
      updateTaskProgressFilter(selected, index) {
        this.$emit('on-taskprogress-change', selected)
      },
      removeTaskProgressFilter() {
        this.$emit('on-taskprogress-change', {id: 'sa'})
      },
      addFacility() {
        if (this.allowFacilityAdd) this.$emit('add-facility-from-nav')
      },
      findFacility(query) {
        this.isLoading = true
        var callback = (response => {
          this.facilities = response
          this.isLoading = false
        })
        this.$emit('on-facility-name-search', query, callback)
      },
      onSelectFacility(selected) {
        this.$emit('on-filter-by-facility', selected)
      },
      onRemoveFacility() {
        this.$emit('on-filter-by-facility', null)
      },
      onClearFilter() {
        this.currentStatus = null
        this.currentTaskType = null
        this.currentFacilityGroup = null
        this.currentProgress = null
        this.dueDateRange = [null]
        this.selectedFacility = null
        this.currentIssueType = null
        this.currentIssueSeverity = null
        this.currentIssueProgress = null
        this.currentTaskProgress = null
        this.$emit('clear-filters', {id: 'sa'})
      },
      exportData() {
        if (!this.enableExport || this.exporting) return;
        this.exporting = true
        var cb = (err) => this.exporting = false

        var filters = [`Map Filters:\n
          Facility Group: ${this.currentFacilityGroup ? this.currentFacilityGroup.name : 'all'}\n
          Facility Name: ${this.selectedFacility ? this.selectedFacility.facilityName : 'all'}\n
          Project Status: ${this.currentStatus ? this.currentStatus.name : 'all'}\n
          Facility % Progress Range: ${this.currentProgress ? this.currentProgress.name : 'all'}\n
          Facility Due Date: ${this.dueDateRange && this.dueDateRange[0] ? this.dueDateRange[0].toLocaleDateString() + ' to ' + this.dueDateRange[1].toLocaleDateString() : 'all'}\n
          Task Type: ${this.currentTaskType ? this.currentTaskType.name : 'all'}\n
          Task % Progress Range: ${this.currentTaskProgress ? this.currentTaskProgress.name : 'all'}\n
          Issue Type: ${this.currentIssueType ? this.currentIssueType.name : 'all'}\n
          Issue % Progress Range: ${this.currentIssueProgress ? this.currentIssueProgress.name : 'all'}\n
          Issue severity: ${this.currentIssueSeverity ? this.currentIssueSeverity.name : 'all'}\n
        `]
        this.$emit('export-data', filters, cb)
      }
    },
    watch: {
      projects: {
        handler: function(value) {
          this.DV_projects = value
        }, deep: true
      },
      dueDateRange(value) {
        this.$emit('on-duedate-change', value)
      }
    }
  }
</script>
<style scoped lang="scss">
  #filterbar {
    position: absolute;
    z-index: 1000;
    transition: .4s ease;
  }
  #filter_bar {
    overflow-y: auto;
    background: white;
    height: calc(100vh - 60px);
    max-height: calc(100vh - 60px);
    width: 320px;
  }
  .filters_wrap {
    width: 90%;
    margin: 0 auto;
  }
  .project-select {
    width: 280px;
  }
  .issetype-select /deep/ .multiselect,
  .issueSeverity-select /deep/ .multiselect,
  .issueProgress-select /deep/ .multiselect,
  .taskProgress-select /deep/ .multiselect,
  .tasktype-select /deep/ .multiselect,
  .progress-ranges-select /deep/ .multiselect,
  .facilityname-search /deep/ .multiselect,
  .facilitygroup-select /deep/ .multiselect,
  .status-select /deep/ .multiselect {
    font-size: 14px;
    width: 280px;
    .multiselect__placeholder {
      margin-bottom: 2px;
      padding-top: 2px;
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
  .project-select /deep/ .multiselect {
    font-size: 14px;
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
  .duedate-range /deep/ .mx-datepicker-range {
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
  .knocker {
    cursor: pointer;
    position: absolute;
    top: 40%;
    right: -12px;
    width: 12px;
    border-top-right-radius: 12px;
    border-bottom-right-radius: 12px;
    height: 100px;
    background: #ffa500;
    display: flex;
    align-items: center;
    justify-content: center;
    .linner {
      width: 5px;
      height: 60px;
      border-left: 1px solid #fff;
      border-right: 1px solid #fff;
    }
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
  .export-btn {
    text-align: center;
    .btn {
      font-size: 18px;
    }
  }
</style>
