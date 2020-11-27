<template>
  <div>
    <tabsbar></tabsbar>
    <filter-sidebar v-if="contentLoaded"></filter-sidebar>
    <router-view></router-view>
  </div>
</template>

<script>
  import {mapGetters, mapActions} from 'vuex'
  import Tabsbar from './../shared/tabsbar'
  import FilterSidebar from './../shared/filter_sidebar'

  export default {
    name: 'Dashboard',
    components: {
      Tabsbar,
      FilterSidebar
    },
    mounted() {
      let id = this.$route.params.projectId
      this.fetchDashboardData({id})
    },
    methods: {
      ...mapActions([
        'fetchDashboardData'
      ])
    },
    computed: {
      ...mapGetters([
        'contentLoaded'
      ])
    }
  }
</script>
