<template>
  <div>
    <div v-if="!loading">
      <filter-sidebar ref="filterSidebar"></filter-sidebar>
      <div id="dash-wrap">
        <div class="col p-0">
          <project-map-view ref="projectMap"></project-map-view>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import FilterSidebar from './../shared/filter_sidebar'
  import ProjectMapView from './project_map_view'

  export default {
    components: {
      ProjectMapView,
      FilterSidebar
    },
    data() {
      return {
        loading: true
      }
    },
    mounted() {
      this.loading = false
    }
  }
</script>

<style lang="scss" scoped>
  #dash-wrap {
    padding-top: 1px;
    height: calc(100vh - 94px);
    width: 100%;
    display: flex;
    flex-wrap: wrap;
  }
</style>
