<template>
  <div>
    <RiskCalendarIndex :facility="facility" />
  </div>
</template>

<script>
import RiskSheetsIndex from "../../dashboard/risks/calendar/risk_calendar_index.vue";

export default {
  props: ["facility"],
  components: { RiskSheetsIndex },
};
</script>

<style></style>
