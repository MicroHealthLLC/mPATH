<template>
  <div>
    <IssueSheetsIndex :facility="facility" :contract="contract" :vehicle="vehicle" />
  </div>
</template>
<script>
import IssueSheetsIndex from "../../../dashboard/issues/issue_sheets_index.vue";

export default {
  props: ["facility", "contract", "vehicle"],
  components: { IssueSheetsIndex },
};
</script>

<style></style>
