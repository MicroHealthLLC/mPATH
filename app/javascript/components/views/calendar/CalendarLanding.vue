<template>
  <div
    class="main-container d-flex align-items-center justify-content-center"
  >
    <el-card class="font-lg text-center">
       <font-awesome-icon
          icon="calendar"
          class="mr-1 "
          style="color: #9EC64C"
        />
      <h4>Calendar View</h4>
      <p v-show="$route.name === 'CalendarLanding'" style="color:#9EC64C">
         Select a Project to get started!
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
