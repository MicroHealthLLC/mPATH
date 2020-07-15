<template>
  <div>
    <tabsbar></tabsbar>
    <router-view></router-view>
  </div>
</template>
<script>
  import Tabsbar from './../shared/tabsbar'
  export default {
    name: 'Dashboard',
    components: {
      Tabsbar
    }
  }
</script>
