<template>
  <div
    class="main-container d-flex align-items-center justify-content-center"
  >
    <el-card class="text-center">
      <i class="fa fa-tasks font-lg text-center" style="font-size: 1.8rem"></i>
      <p>Calendar Landing</p>
      <p v-show="$route.name === 'CalendarLanding'" style="color:#007bff">
        Please select a project.
      </p>
    </el-card>
  </div>
</template>

<script>
export default {};
</script>

<style scoped>
.main-container {
  height: calc(100vh - 100px);
}
</style>
