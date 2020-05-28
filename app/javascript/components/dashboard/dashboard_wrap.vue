<template>
  <div>
    <div v-if="!loading">
      <navbar
        @add-facility-from-nav="openModal"
        :projects="projects"
        :statuses="statuses"
        :facility-groups="activeFacilityGroups"
        @on-facility-name-search="onFacilitySearch"
        @on-status-change="onStatusChange"
        @on-facilitygroup-change="onFacilityGroupChange"
        @on-filter-by-facility="onFilterByFacility"
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
        facilityGroups: [],
        facilityGroup: null,
        facilityQuery: {},
        filterFacility: null
      }
    },
    mounted() {
      this.fetchProjects((err) => {
        if (!err) this.loading = false;
      })
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
            cb(null)
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
    height: calc(100vh - 130px);
    width: 100%;
    display: flex;
    flex-wrap: wrap;
  }
</style>
