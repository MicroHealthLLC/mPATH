<template>
  <div>
    <RiskSheetsIndex :facility="facility" :contract="contract" :vehicle="vehicle" />
  </div>
</template>

<script>
import RiskSheetsIndex from "../../../dashboard/risks/sheets/risk_sheets_index.vue";

export default {
  props: ["facility", "contract", "vehicle"],
  components: { RiskSheetsIndex },
};
</script>

<style></style>