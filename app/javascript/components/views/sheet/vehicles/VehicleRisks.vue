<template>
  <div>
    <RiskSheetsIndex :facility="facility" :vehicle="vehicle" />
  </div>
</template>

<script>
import RiskSheetsIndex from "../../../dashboard/risks/sheets/risk_sheets_index.vue";

export default {
  props: ["facility", "vehicle"],
  components: { RiskSheetsIndex },
};
</script>

<style></style>