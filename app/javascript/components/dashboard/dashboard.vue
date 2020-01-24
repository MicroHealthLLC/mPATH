<template>
  <div>
    <!-- <Navbar></Navbar> -->
    <router-view></router-view>
  </div>
</template>
<script>
  import Navbar from './../shared/navbar.vue'
  export default {
    components: {
      Navbar
    }
  }
</script>
