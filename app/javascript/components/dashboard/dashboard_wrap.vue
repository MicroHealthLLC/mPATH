<template>
  <div>
    <div v-if="!loading">
      <navbar
        @add-facility-from-nav="openModal"
        :projects="projects"
        :statuses="statuses"
        @on-status-change="onStatusChange"
      />
      <div id="dash-wrap">
        <div class="col p-0">
          <regions-map
            :projects="projects"
            :with-facility="facilityModal"
            :project-status="projectStatus"
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
        projectStatus: null,
        statuses: []
      }
    },
    mounted() {
      this.fetchProjects()
    },
    methods: {
      fetchProjects() {
        http.get('/projects.json')
          .then((res) => {
            this.projects = res.data.projects
            this.fetchStatuses()
          })
          .catch((err) => {
            console.error(err)
          })
      },
      fetchStatuses() {
        http.get('/statuses.json')
          .then((res) => {
            this.statuses = res.data.statuses
            this.loading = false
          })
          .catch((err) => {
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
        this.projectStatus = status
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
