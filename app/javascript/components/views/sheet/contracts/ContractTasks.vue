<template>
  <div>
    <TaskSheetsIndex :facility="facility" :contract="contract" />
  </div>
</template>

<script>
import TaskSheetsIndex from "../../../dashboard/tasks/task_sheets_index.vue";

export default {
  props: ["facility", "contract"],
  components: {
    TaskSheetsIndex,
  },
};
</script>

<style></style>
