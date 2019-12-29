<template>
  <div id="dash-wrap">
    <div class="col p-0">
      <regions-map></regions-map>
    </div>
  </div>
</template>

<script>
  import Sidebar    from './sidebar.vue'
  import RegionsMap from './regions_map.vue'
  export default {
    components: {
      Sidebar,
      RegionsMap
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
    
    .sidebar {
      padding: 0 !important;
      z-index: 1020;
      box-shadow: 0 2px 5px 0 rgba(0,0,0,0.16), 0 2px 10px 0 rgba(0,0,0,0.12);
    }
  }  
</style>
