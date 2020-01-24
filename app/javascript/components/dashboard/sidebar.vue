<template>
  <div id="sidebar-wrapper">
    <facilities-index></facilities-index>
  </div>
</template>

<script>
  import FacilitiesIndex from './facilities/_index'
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
    height: calc(100vh - 130px);
    max-height: calc(100vh - 130px);
    overflow: auto; 
    background: white;
    padding: 10px 20px;
  }
</style>
