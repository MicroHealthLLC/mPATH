<template>
  <div>
    <div v-if="!loading">
      <navbar 
        @add-facility-from-nav="openModal"
        :projects="projects"
      ></navbar>
      <div id="dash-wrap">
        <div class="col p-0">
          <regions-map :with-facility="facilityModal" @nullify-modals="nullifyModal"></regions-map>
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
        projects: []
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
            this.loading = false
          })
          .catch((err) => {
            console.error(err)
          })
      },
      openModal() {
        this.facilityModal = true
      },
      nullifyModal() {
        this.facilityModal = false
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
