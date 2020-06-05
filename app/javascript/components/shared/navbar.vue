<template>
  <div id="filterbar" :style="filterBarStyle">
    <div id="filter_bar" class="shadow-sm">
      <div class="text-center my-3">
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
    props: ['projects', 'statuses', 'facilityGroups', 'taskTypes'],
    data() {
      return {
        isLoading: false,
        showFilters: false,
        currentProject: null,
        currentStatus: null,
        currentTaskType: null,
        currentFacilityGroup: null,
        selectedFacility: null,
        currentProgress: null,
        dueDateRange: null,
        facilities: [],
        DV_statuses: this.statuses,
        DV_taskTypes: this.taskTypes,
        DV_facilityGroups: this.facilityGroups,
        DV_projects: this.projects,
        DV_progressRanges: [
          { name: '0', value: '0'},
          { name: '1-10', value: '1-10'},
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
      }
    },
    mounted() {
      this.currentProject = this.DV_projects.find(project => project.id == this.$route.params.projectId)
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
        this.dueDateRange = null
        this.selectedFacility = null
        this.$emit('clear-filters', {id: 'sa'})
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
    height: calc(100vh - 90px);
    max-height: calc(100vh - 90px);
    width: 320px;
  }
  .filters_wrap {
    width: 90%;
    margin: 0 auto;
  }
  .project-select {
    width: 280px;
  }
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
      width: 350px;
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
    position: absolute;
    top: 8px;
    right: 10px;
  }
  .duedate-range /deep/ .mx-datepicker-range {
    width: 280px;
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
    background: #37AFEA;
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
</style>
