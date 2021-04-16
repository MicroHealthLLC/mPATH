<template>
  <div>
    <RiskCalendar :facility="facility" />
  </div>
</template>

<script>
import RiskCalendar from "../../dashboard/risks/calendar/risk_calendar.vue";

export default {
  props: ["facility"],
  components: { RiskCalendar },
};
</script>

<style></style>
