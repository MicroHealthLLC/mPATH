<template>
  <div id="tabbar">
    <router-link :to="mapView" tag="div">
      <div class="badge" :class="{'active': isMapView}">Map View</div>
    </router-link>
    <router-link :to="ganttView" tag="div">
      <div class="badge" :class="{'active': isGanttView}">Gantt View</div>
    </router-link>
    <router-link :to="watchView" tag="div">
      <div class="badge" :class="{'active': isWatchView}">Watch View</div>
    </router-link>
    <div class="badge disabled">Task Kanban (Coming Soon)</div>
    <div class="badge disabled">Issues Kanban (Coming Soon)</div>
    <div class="badge disabled">Documents (Coming Soon)</div>
  </div>
</template>

<script>
  export default {
    name: 'Tabsbar',
    computed: {
      isMapView() {
        return this.$route.name === 'ProjectMapView'
      },
      isGanttView() {
        return this.$route.name === 'ProjectGanttChart'
      },
      isWatchView() {
        return this.$route.name === 'ProjectWatchView'
      },
      mapView() {
        return `/projects/${this.$route.params.projectId}`
      },
      ganttView() {
        return `/projects/${this.$route.params.projectId}/gantt_chart`
      },
      watchView() {
        return `/projects/${this.$route.params.projectId}/watch_view`
      }
    }
  }
</script>

<style scoped lang="scss">
  #tabbar {
    padding: 4px 70px;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 2px 5px 0 rgba(0,0,0,0.02), 0 2px 5px 0 rgba(0,0,0,0.03);
    .badge {
      cursor: pointer;
      padding: 5px;
      margin: 2px 10px;
      transition: auto;
      &.active {
        color: #fff;
        padding: 5px;
        background-color: #17a2b8;
      }
      &.disabled {
        opacity: 0.5;
        cursor: not-allowed;
        border: 0 !important;
        padding: 5px !important;
      }
      &:hover {
        padding: 4px;
        border: 1px solid #17a2b8;
      }
    }
  }
</style>
