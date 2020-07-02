<template>
  <div>
    <div v-if="!loading">
      <navbar
        @add-facility-from-nav="openModal"
        :projects="projects"
        :statuses="statuses"
        :facility-groups="activeFacilityGroups"
        :task-types="taskTypes"
        :issue-types="issueTypes"
        :issue-severities="issueSeverities"
        @is-exportable="isExportable"
        @on-facility-name-search="onFacilitySearch"
        @on-status-change="onStatusChange"
        @on-facilitygroup-change="onFacilityGroupChange"
        @on-duedate-change="onDuedateChange"
        @on-tasktype-change="onTasktypeChange"
        @on-taskprogress-change="onTaskProgressChange"
        @on-issuetype-change="onIssuetypeChange"
        @on-issueprogress-change="onIssueProgressChange"
        @on-issueseverity-change="onIssueseverityChange"
        @on-progress-change="onProgressChange"
        @on-filter-by-facility="onFilterByFacility"
        @clear-filters="onClearFilters"
        @export-data="exportData"
      />
      <div id="dash-wrap">
        <div class="col p-0">
          <regions-map
            ref="regionsMap"
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
            :issue-type="issueType"
            :issue-progress="issueProgress"
            :task-progress="taskProgress"
            :issue-severity="issueSeverity"
            @nullify-modals="nullifyModal"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import http from './../../common/http'
  import utils from './../../mixins/utils'
  import Navbar from './../shared/navbar'
  import Sidebar from './sidebar'
  import RegionsMap from './regions_map'
  import XLSX from 'xlsx'

  export default {
    components: {
      Sidebar,
      RegionsMap,
      Navbar
    },
    mixins: [utils],
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
        taskProgress: null,
        dueDate: null,
        facilityGroups: [],
        facilityGroup: null,
        facilityQuery: {},
        filterFacility: null,
        issueTypes: [],
        issueType: null,
        issueProgress: null,
        issueSeverities: [],
        issueSeverity: null
      }
    },
    mounted() {
      var cb = (err) => this.loading = false
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
            this.fetchIssueTypes(cb)
          })
          .catch((err) => {
            cb(err)
            console.log(err)
          })
      },
      fetchIssueTypes(cb) {
        http.get('/api/issue_types.json')
          .then((res) => {
            this.issueTypes = res.data.issueTypes
            this.fetchIssueSeverities(cb)
          })
          .catch((err) => {
            cb(err)
            console.log(err)
          })
      },
      fetchIssueSeverities(cb) {
        http.get('/api/issue_severities.json')
          .then((res) => {
            this.issueSeverities = res.data.issueSeverities
            return cb(null)
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
      onTaskProgressChange(progress) {
        this.taskProgress = progress
      },
      onIssuetypeChange(type) {
        this.issueType = type
      },
      onIssueProgressChange(progress) {
        this.issueProgress = progress
      },
      onIssueseverityChange(severity) {
        this.issueSeverity = severity
      },
      onClearFilters() {
        this.progress = null
        this.taskType = null
        this.taskProgress = null
        this.dueDate = null
        this.status = null
        this.facilityGroup = null
        this.filterFacility = null
        this.issueType = null
        this.issueProgress = null
        this.issueSeverity = null
        this.$forceUpdate()
      },
      isExportable() {
        return this.$refs.regionsMap && this.$refs.regionsMap.filterFacilitiesWithActiveRegion && this.$refs.regionsMap.filterFacilitiesWithActiveRegion.length > 0
      },
      exportData(filters, cb) {
        try {
          var header = ["Facility Name", "Facility Group", "Project Status", "Due Date", "Percentage Complete", "Point of Contact Name", "Point of Contact Phone", "Point of Contact Email"]

          var ex_data = []
          for (var facility of this.$refs.regionsMap.filterFacilitiesWithActiveRegion) {
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
          return cb()
        }
        catch(error) {
          console.log(error)
          return cb(error)
        }
      }
    },
    computed: {
      activeFacilityGroups() {
        let projectId = Number(this.$route.params.projectId)
        return _.filter(this.facilityGroups, (f) => f.status === 'active' && f.projectIds.includes(projectId))
      }
    }
  }
</script>

<style lang="scss" scoped>
  #dash-wrap {
    padding-top: 1px;
    height: calc(100vh - 60px);
    width: 100%;
    display: flex;
    flex-wrap: wrap;
  }
</style>
