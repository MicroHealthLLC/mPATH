<template>
  <div>
    <RiskSheetsIndex :facility="facility" />
  </div>
</template>

<script>
import RiskSheetsIndex from "../../dashboard/risks/sheets/risk_sheets_index.vue";

export default {
  props: ["facility"],
  components: { RiskSheetsIndex },
};
</script>

<style></style>
