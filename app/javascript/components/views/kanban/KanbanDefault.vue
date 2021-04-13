<template>
  <div class="d-flex align-items-center justify-content-center h-100">
    <el-card class="text-center">
      <i class="fa fa-tasks font-lg text-center" style="font-size: 1.8rem"></i>
      <p>View, Edit, filter Tasks/Issues/Risks in kanban mode.</p>
      <p v-show="$route.name === 'KanbanDefault'" style="color:#007bff">
        Please select a project.
      </p>
    </el-card>
  </div>
</template>

<script>
export default {};
</script>

<style></style>
