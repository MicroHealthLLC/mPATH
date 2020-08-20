<template>
  <div id="filterbar" :style="filterBarStyle">
    <div id="filter_bar" class="shadow-sm">
      <div class="d-flex m-3 align-items-center justify-content-between">
        <button @click.prevent="exportData" :disabled="!enableExport || exporting" class="btn btn-sm btn-link">export</button>
        <h4>Filter View</h4>
        <button class="btn btn-sm btn-link" @click.prevent="onClearFilter">clear</button>
      </div>
      <div class="filters_wrap">
        <div class="project-select my-3 mx-1">
          <multiselect
            v-model="currentProject"
            track-by="name"
            label="name"
            placeholder="Select Project"
            :options="projects"
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
        <div class="facilitygroup-select my-3 mx-1">
          <multiselect
            v-model="C_facilityGroupFilter"
            track-by="name"
            label="name"
            placeholder="Filter by Facility Group"
            :options="C_activeFacilityGroups"
            :multiple="true"
            select-label="Select"
            deselect-label="Remove"
            :searchable="false"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <div class="facilityname-search my-3 mx-1">
          <multiselect
            placeholder="Search by Facility Name"
            v-model="C_facilityNameFilter"
            label="facilityName"
            track-by="id"
            :multiple="true"
            :options="facilities"
            :searchable="true"
            :loading="isLoading"
            :preserve-search="true"
            select-label="Select"
            deselect-label="Remove"
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
        <div class="status-select mx-1">
          <multiselect
            v-model="C_projectStatusFilter"
            track-by="name"
            label="name"
            placeholder="Filter by Status"
            :options="statuses"
            :searchable="false"
            :multiple="true"
            select-label="Select"
            deselect-label="Remove"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <div class="progress-ranges-select my-3 mx-1">
          <multiselect
            v-model="C_facilityProgressFilter"
            track-by="name"
            label="name"
            placeholder="Facility % Progress Range"
            :options="DV_progressRanges"
            :searchable="false"
            :multiple="true"
            select-label="Select"
            deselect-label="Remove"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <div class="duedate-range my-3 mx-1">
          <v2-date-picker
            v-model="C_facilityDueDateFilter"
            placeholder="Due Date Range"
            range
          />
        </div>
        <div class="tasktype-select my-3 mx-1">
          <multiselect
            v-model="C_taskTypeFilter"
            track-by="name"
            label="name"
            placeholder="Filter by Task Type"
            :options="taskTypes"
            :searchable="false"
            :multiple="true"
            select-label="Select"
            deselect-label="Remove"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <div class="taskProgress-select my-3 mx-1">
          <multiselect
            v-model="C_taskProgressFilter"
            track-by="name"
            label="name"
            placeholder="Task % Progress Range"
            :options="DV_taskProgressRanges"
            :searchable="false"
            :multiple="true"
            select-label="Select"
            deselect-label="Remove"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <div class="issetype-select my-3 mx-1">
          <multiselect
            v-model="C_issueTypeFilter"
            track-by="name"
            label="name"
            placeholder="Filter by Issue Type"
            :options="issueTypes"
            :searchable="false"
            :multiple="true"
            select-label="Select"
            deselect-label="Remove"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <div class="issueProgress-select my-3 mx-1">
          <multiselect
            v-model="C_issueProgressFilter"
            track-by="name"
            label="name"
            placeholder="Issue % Progress Range"
            :options="DV_issueProgressRanges"
            :searchable="false"
            :multiple="true"
            select-label="Select"
            deselect-label="Remove"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <div class="issueSeverity-select my-3 mx-1">
          <multiselect
            v-model="C_issueSeverityFilter"
            track-by="name"
            label="name"
            placeholder="Filter by Issue Severity"
            :options="issueSeverities"
            :searchable="false"
            :multiple="true"
            select-label="Select"
            deselect-label="Remove"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
        <div class="actions-select my-3 mx-1">
          <multiselect
            v-model="C_myActionsFilter"
            track-by="name"
            label="name"
            placeholder="My-actions Filter"
            :options="myActions"
            :searchable="false"
            :multiple="true"
            select-label="Select"
            deselect-label="Remove"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
      </div>
    </div>
    <div class="knocker" @click="showFilters=!showFilters">
      <div class="linner"></div>
    </div>
  </div>
</template>

<script>
  import {mapGetters, mapMutations} from 'vuex'
  import XLSX from 'xlsx'

  export default {
    name: 'FilterSidebar',
    data() {
      return {
        isLoading: false,
        exporting: false,
        showFilters: false,
        facilities: [],
        myActions: [
          {name: 'My Tasks', value: 'tasks'},
          {name: 'My Issues', value: 'issues'}
        ],
        DV_progressRanges: this.progressRanges(),
        DV_issueProgressRanges: this.progressRanges(),
        DV_taskProgressRanges: this.progressRanges()
      }
    },
    computed: {
      ...mapGetters([
        'projectStatusFilter',
        'taskTypeFilter',
        'facilityGroupFilter',
        'facilityNameFilter',
        'facilityProgressFilter',
        'facilityDueDateFilter',
        'issueTypeFilter',
        'issueSeverityFilter',
        'issueProgressFilter',
        'taskProgressFilter',
        'projects',
        'currentProject',
        'statuses',
        'activeFacilityGroups',
        'taskTypes',
        'issueTypes',
        'issueSeverities',
        'unFilterFacilities',
        'filterFacilitiesWithActiveFacilityGroups',
        'ganttData',
        'myActionsFilter'
      ]),
      enableExport() {
        return this.filterFacilitiesWithActiveFacilityGroups.length > 0
      },
      C_activeFacilityGroups() {
        var id = Number(this.$route.params.projectId)
        return this.activeFacilityGroups(id)
      },
      C_projectStatusFilter: {
        get() {
          return this.projectStatusFilter
        },
        set(value) {
          this.setProjectStatusFilter(value)
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
      C_facilityProgressFilter: {
        get() {
          return this.facilityProgressFilter
        },
        set(value) {
          this.setFacilityProgressFilter(value)
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
      C_issueProgressFilter: {
        get() {
          return this.issueProgressFilter
        },
        set(value) {
          this.setIssueProgressFilter(value)
        }
      },
      C_taskProgressFilter: {
        get() {
          return this.taskProgressFilter
        },
        set(value) {
          this.setTaskProgressFilter(value)
        }
      },
      C_myActionsFilter: {
        get() {
          return this.myActionsFilter
        },
        set(value) {
          this.setMyActionsFilter(value)
        }
      },
      filterBarStyle() {
        if (this.showFilters) return {}
        return {
          transform: 'translateX(-320px)'
        }
      },
      isMapView() {
        return this.$route.name === 'ProjectMapView'
      },
      isGanttView() {
        return this.$route.name === 'ProjectGanttChart'
      }
    },
    methods: {
      ...mapMutations([
        'updateMapFilters',
        'setProjectStatusFilter',
        'setTaskTypeFilter',
        'setFacilityGroupFilter',
        'setFacilityNameFilter',
        'setFacilityProgressFilter',
        'setFacilityDueDateFilter',
        'setIssueTypeFilter',
        'setIssueSeverityFilter',
        'setIssueProgressFilter',
        'setTaskProgressFilter',
        'setMyActionsFilter',
        'setMapFilters'
      ]),
      updateProjectQuery(selected, index) {
        window.location.pathname = "/projects/" + selected.id
      },
      progressRanges() {
        return [
          {name: '0', value: '0'},
          {name: '11-20', value: '11-20'},
          {name: '21-30', value: '21-30'},
          {name: '31-40', value: '31-40'},
          {name: '41-50', value: '41-50'},
          {name: '51-60', value: '51-60'},
          {name: '61-70', value: '61-70'},
          {name: '71-80', value: '71-80'},
          {name: '81-90', value: '81-90'},
          {name: '91-99', value: '91-99'},
          {name: '100', value: '100'}
        ]
      },
      findFacility(query) {
        this.isLoading = true
        if (query) {
          const resp = new RegExp(_.escapeRegExp(query.toLowerCase()), 'i')
          const isMatch = (result) => resp.test(result.facilityName)
          this.facilities = _.filter(this.unFilterFacilities, isMatch)
          this.isLoading = false
        }
        else {
          this.facilities = this.unFilterFacilities
          this.isLoading = false
        }
      },
      onClearFilter() {
        this.setProjectStatusFilter(null)
        this.setTaskTypeFilter(null)
        this.setFacilityGroupFilter(null)
        this.setFacilityProgressFilter(null)
        this.setFacilityDueDateFilter([null])
        this.setFacilityNameFilter(null)
        this.setIssueTypeFilter(null)
        this.setIssueSeverityFilter(null)
        this.setIssueProgressFilter(null)
        this.setTaskProgressFilter(null)
        this.setMyActionsFilter(null)
        this.setMapFilters([])
      },
      exportData() {
        if (!this.enableExport || this.exporting) return;
        this.exporting = true
        if (this.isMapView) this.exportMapData()
        else if (this.isGanttView) this.exportGanttData()
      },
      exportMapData() {
        try {
          var filters = [`Map Filters: ${this.currentProject.name} \n
            Facility Group: ${this.facilityGroupFilter ? _.map(this.facilityGroupFilter, 'name').join() : 'all'}\n
            Facility Name: ${this.facilityNameFilter ? _.map(this.facilityNameFilter, 'facilityName').join() : 'all'}\n
            Project Status: ${this.projectStatusFilter ? _.map(this.projectStatusFilter, 'name').join() : 'all'}\n
            Facility % Progress Range: ${this.facilityProgressFilter ? _.map(this.facilityProgressFilter, 'name').join() : 'all'}\n
            Facility Due Date: ${this.facilityDueDateFilter && this.facilityDueDateFilter[0] ? this.formatDate(this.facilityDueDateFilter[0]) + ' to ' + this.formatDate(this.facilityDueDateFilter[1]) : 'all'}\n
            Task Type: ${this.taskTypeFilter ?  _.map(this.taskTypeFilter, 'name').join() : 'all'}\n
            Task % Progress Range: ${this.taskProgressFilter ?  _.map(this.taskProgressFilter, 'name').join() : 'all'}\n
            Issue Type: ${this.issueTypeFilter ?  _.map(this.issueTypeFilter, 'name').join() : 'all'}\n
            Issue % Progress Range: ${this.issueProgressFilter ?  _.map(this.issueProgressFilter, 'name').join() : 'all'}\n
            Issue severity: ${this.issueSeverityFilter ?  _.map(this.issueSeverityFilter, 'name').join() : 'all'}\n
          `]
          var header = ["Facility Name", "Facility Group", "Project Status", "Due Date", "Percentage Complete", "Point of Contact Name", "Point of Contact Phone", "Point of Contact Email"]

          var ex_data = []
          for (var facility of this.filterFacilitiesWithActiveFacilityGroups) {
            ex_data.push({
              "Facility Name": facility.facilityName || 'N/A',
              "Facility Group": facility.facilityGroupName || 'N/A',
              "Project Status": facility.projectStatus || 'N/A',
              "Due Date": facility.dueDate || 'N/A',
              "Percentage Complete": facility.progress || 0,
              "Point of Contact Name": facility.pointOfContact || 'N/A',
              "Point of Contact Phone": facility.phoneNumber || 'N/A',
              "Point of Contact Email": facility.email || 'N/A'
            })
          }

          var wb = XLSX.utils.book_new()
          var ws = XLSX.utils.aoa_to_sheet(new Array(filters))
          XLSX.utils.sheet_add_json(ws, ex_data, {header: header,  origin: "A3"})
          XLSX.utils.book_append_sheet(wb, ws, "MGIS")
          XLSX.writeFile(wb, `${this.random()}.xlsx`)
          this.exporting = false
        }
        catch(err) {
          console.error(err)
        }
      },
      exportGanttData() {
        try {
          var header = ["Sr.", "Name", "Duration", "% Complete", "Start Date", "End Date", "Assigned To"]
          var ex_data = []
          for (var row of this.ganttData) {
            ex_data.push({
              "Sr.": row._id,
              "Name": row.name,
              "Duration": row.durationInDays,
              "% Complete": row.progress,
              "Start Date": this.formatDate(row.startDate),
              "End Date": this.formatDate(row.endDate),
              "Assigned To": row._users ? row._users.join(', ') : ''
            })
          }

          var wb = XLSX.utils.book_new()
          var ws = XLSX.utils.json_to_sheet(ex_data, {header: header})
          XLSX.utils.book_append_sheet(wb, ws, "MGIS")
          XLSX.writeFile(wb, `${this.random()}.xlsx`)
          this.exporting = false
        }
        catch(err) {
          console.error(err)
        }
      }
    },
    watch: {
      facilityDueDateFilter(value) {
        this.updateMapFilters({key: 'dueDate', filter: value, same: true})
      },
      facilityGroupFilter(value) {
        this.updateMapFilters({key: 'facilityGroupIds', filter: value})
      },
      facilityNameFilter(value) {
        this.updateMapFilters({key: 'ids', filter: value})
      },
      projectStatusFilter(value) {
        this.updateMapFilters({key: 'statusIds', filter: value})
      },
      facilityProgressFilter(value) {
        this.updateMapFilters({key: 'progress', filter: value, _k: 'value'})
      },
      taskTypeFilter(value) {
        this.updateMapFilters({key: 'taskTypeIds', filter: value})
      },
      taskProgressFilter(value) {
        this.updateMapFilters({key: 'taskProgress', filter: value, _k: 'value'})
      },
      issueTypeFilter(value) {
        this.updateMapFilters({key: 'issueTypeIds', filter: value})
      },
      issueProgressFilter(value) {
        this.updateMapFilters({key: 'issueProgress', filter: value, _k: 'value'})
      },
      issueSeverityFilter(value) {
        this.updateMapFilters({key: 'issueSeverityIds', filter: value})
      },
      myActionsFilter(value) {
        this.updateMapFilters({key: 'myActions', filter: value, _k: 'value'})
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
    height: calc(100vh - 94px);
    max-height: calc(100vh - 94px);
    width: 320px;
  }
  .filters_wrap {
    width: 90%;
    margin: 0 auto;
  }
  .project-select {
    width: 280px;
  }
  .actions-select /deep/ .multiselect,
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
</style>
