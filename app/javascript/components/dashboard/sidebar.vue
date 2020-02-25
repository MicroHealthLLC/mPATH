<template>
  <div id="sidebar-wrapper">
    <facilities-index />
  </div>
</template>

<script>
  import FacilitiesIndex from './facilities/facility_index'

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

    background: white;
    padding: 10px 20px;
  }
</style>
