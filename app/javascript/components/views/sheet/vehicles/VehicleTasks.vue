<template>
  <div>
    <TaskSheetsIndex :facility="facility" :vehicle="vehicle" />
  </div>
</template>

<script>
import TaskSheetsIndex from "../../../dashboard/tasks/task_sheets_index.vue";

export default {
  props: ["facility", "vehicle"],
  components: {
    TaskSheetsIndex,
  },
};
</script>

<style></style>