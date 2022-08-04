<template>
  <div>
    <TaskSheetsIndex :facility="facility" :contract="contract" :vehicle="vehicle" />
  </div>
</template>

<script>
import TaskSheetsIndex from "../../../dashboard/tasks/task_sheets_index.vue";

export default {
  props: ["facility", "contract", "vehicle"],
  components: {
    TaskSheetsIndex,
  },
};
</script>

<style></style>