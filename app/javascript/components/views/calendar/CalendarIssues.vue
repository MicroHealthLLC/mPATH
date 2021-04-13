<template>
  <div>
    <IssueCalendarIndex :facility="facility" />
  </div>
</template>

<script>
import IssueCalendarIndex from "../../dashboard/issues/issue_calendar_index.vue";

export default {
  props: ["facility"],
  components: { IssueCalendarIndex },
};
</script>

<style></style>
