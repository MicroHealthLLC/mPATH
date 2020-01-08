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
    height: calc(100vh - 130px);
    width: 100%;
    display: flex;
    flex-wrap: wrap;
  }  
</style>
