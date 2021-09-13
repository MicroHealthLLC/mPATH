<template>
  <div
    class="main-container d-flex align-items-center justify-content-center"
  >
    <el-card class="font-lg text-center">
       <i class="fal fa-columns mr-1" style="color: #9EC64C"></i>
      <h4>Kanban View</h4>
      <p v-show="$route.name === 'KanbanDefault'" style="color:#9EC64C">
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
