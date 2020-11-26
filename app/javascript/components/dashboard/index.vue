<template>
  <div>
    <div v-if="!loading">
      <tabsbar></tabsbar>
      <filter-sidebar ref="filterSidebar"></filter-sidebar>
      <router-view></router-view>
    </div>
    <div v-else class="d-flex justify-content-center align-items-center h-75 mt-5 pt-5">
      <loader :loading="true" color="black"></loader>
      <p class="__loading">Loading</p>
    </div>
  </div>
</template>

<script>
  import {mapActions} from 'vuex'
  export default {
    name: 'Dashboard',
    components: {
      Tabsbar: () => import('./../shared/tabsbar'),
      FilterSidebar: () => import('./../shared/filter_sidebar')
    },
    data() {
      return {
        loading: true
      }
    },
    mounted() {
      let id = this.$route.params.projectId
      let cb = () => this.loading = false
      this.fetchDashboardData({cb, id})
    },
    methods: {
      ...mapActions([
        'fetchDashboardData'
      ])
    }
  }
</script>
