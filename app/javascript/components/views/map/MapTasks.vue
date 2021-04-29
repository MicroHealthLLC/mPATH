<template>
  <TaskIndex v-if="facility !== null" :facility="facility" />
</template>

<script>
import TaskIndex from "../../dashboard/tasks/task_index.vue";

export default {
  props: ["facility"],
  components: { TaskIndex },
};
</script>

<style></style>
