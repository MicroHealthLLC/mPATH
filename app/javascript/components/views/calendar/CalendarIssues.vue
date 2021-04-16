<template>
  <div>
    <IssueCalendar :facility="facility" />
  </div>
</template>

<script>
import IssueCalendar from "../../dashboard/issues/issue_calendar.vue";

export default {
  props: ["facility"],
  components: { IssueCalendar },
};
</script>

<style></style>
