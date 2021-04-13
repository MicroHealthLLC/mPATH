<template>
  <div>
    <TaskCalendarIndex :facility="facility" />
  </div>
</template>

<script>
import TaskCalendarIndex from "../../dashboard/tasks/task_calendar_index";

export default {
  props: ["facility"],
  components: {
    TaskCalendarIndex,
  },
};
</script>

<style></style>
