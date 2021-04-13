<template>
  <RiskIndex v-if="facility !== null" :facility="facility" />
</template>

<script>
import RiskIndex from "../../dashboard/risks/risk_index.vue";

export default {
  props: ["facility"],
  components: { RiskIndex },
};
</script>

<style></style>
