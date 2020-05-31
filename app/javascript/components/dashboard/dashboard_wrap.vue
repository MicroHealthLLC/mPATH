<template>
  <div>
    <div v-if="!loading">
      <navbar
        @add-facility-from-nav="openModal"
        :projects="projects"
        :statuses="statuses"
        :facility-groups="activeFacilityGroups"
        :task-types="taskTypes"
        @on-facility-name-search="onFacilitySearch"
        @on-status-change="onStatusChange"
        @on-facilitygroup-change="onFacilityGroupChange"
        @on-duedate-change="onDuedateChange"
        @on-tasktype-change="onTasktypeChange"
        @on-progress-change="onProgressChange"
        @on-filter-by-facility="onFilterByFacility"
        @clear-filters="onClearFilters"
      />
      <div id="dash-wrap">
        <div class="col p-0">
          <regions-map
            :projects="projects"
            :facility-groups="facilityGroups"
            :with-facility="facilityModal"
            :status="status"
            :statuses="statuses"
            :facility-group="facilityGroup"
            :facility-query="facilityQuery"
            :filter-facility="filterFacility"
            :due-date="dueDate"
            :progress="progress"
            :task-type="taskType"
            @nullify-modals="nullifyModal"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import http       from './../../common/http'
  import Navbar     from './../shared/navbar'
  import Sidebar    from './sidebar'
  import RegionsMap from './regions_map'
  export default {
    components: {
      Sidebar,
      RegionsMap,
      Navbar
    },
    data() {
      return {
        loading: true,
        facilityModal: false,
        projects: [],
        status: null,
        statuses: [],
        taskTypes: [],
        progress: null,
        taskType: null,
        dueDate: null,
        facilityGroups: [],
        facilityGroup: null,
        facilityQuery: {},
        filterFacility: null
      }
    },
    mounted() {
      var cb = () => this.loading = false
      this.fetchProjects(cb)
    },
    methods: {
      fetchProjects(cb) {
        http.get('/projects.json')
          .then((res) => {
            this.projects = res.data.projects
            this.fetchFacilityGroups(cb)
          })
          .catch((err) => {
            cb(err)
            console.error(err)
          })
      },
      fetchFacilityGroups(cb) {
        http
          .get(`/api/facility_groups.json`)
          .then((res) => {
            this.facilityGroups = res.data.facilityGroups
            this.fetchStatuses(cb)
          })
          .catch((err) => {
            cb(err)
            console.error(err);
          })
      },
      fetchStatuses(cb) {
        http.get('/api/statuses.json')
          .then((res) => {
            this.statuses = res.data.statuses
            this.fetchTaskTypes(cb)
          })
          .catch((err) => {
            cb(err)
            console.log(err)
          })
      },
      fetchTaskTypes(cb) {
        http.get('/api/task_types.json')
          .then((res) => {
            this.taskTypes = res.data.taskTypes
            cb()
          })
          .catch((err) => {
            cb(err)
            console.log(err)
          })
      },
      openModal() {
        this.facilityModal = true
      },
      nullifyModal() {
        this.facilityModal = false
      },
      onStatusChange(status) {
        this.status = status
      },
      onFacilityGroupChange(facilityGroup) {
        this.facilityGroup = facilityGroup
      },
      onFacilitySearch(query, cb) {
        this.facilityQuery= {q: query, cb: cb}
      },
      onFilterByFacility(facility) {
        this.filterFacility = facility
      },
      onDuedateChange(duedate) {
        this.dueDate = duedate
      },
      onProgressChange(progress) {
        this.progress = progress
      },
      onTasktypeChange(tasktype) {
        this.taskType = tasktype
      },
      onClearFilters(value) {
        this.progress = value
        this.taskType = value
        this.dueDate = null
        this.status = value
        this.facilityGroup = value
        this.filterFacility = null
        this.$forceUpdate()
      }
    },
    computed: {
      activeFacilityGroups() {
        return _.filter(this.facilityGroups, (f) => f.status === 'active')
      }
    }
  }
</script>

<style lang="scss" scoped>
  #dash-wrap {
    padding-top: 1px;
    height: calc(100vh - 90px);
    width: 100%;
    display: flex;
    flex-wrap: wrap;
  }
</style>
