<template>
  <div>
    <TaskSheetsIndex :facility="facility" />
  </div>
</template>

<script>
import TaskSheetsIndex from "../../dashboard/tasks/task_sheets_index";

export default {
  props: ["facility"],
  components: {
    TaskSheetsIndex,
  },
  data() {
    return {};
  },
  computed: {},
  mounted() {},
};
</script>

<style></style>
