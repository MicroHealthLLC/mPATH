<template>
  <div id="sidebar-wrapper">
    <facilities-index></facilities-index>
  </div>
</template>

<script>
  import FacilitiesIndex from './facilities/facilities_index.vue'
  export default {
    name: 'Sidebar',
    components: {
      FacilitiesIndex
    }
  }  
</script>

<style lang="scss" scoped>
  #sidebar-wrapper {
    width: 100%;
    height: calc(100vh - 90px);
    max-height: calc(100vh - 90px);
    overflow: auto; 
    background: white;
    padding: 10px 20px;
  }
</style>
