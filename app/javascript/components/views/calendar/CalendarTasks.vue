<template>
  <div>
    <TaskCalendar :facility="facility" />
  </div>
</template>

<script>
import TaskCalendar from "../../dashboard/tasks/task_calendar.vue";

export default {
  props: ["facility"],
  components: {
    TaskCalendar,
  },
};
</script>

<style></style>
