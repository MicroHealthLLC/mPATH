<template>
  <div>
    <IssueSheetsIndex :facility="facility" :vehicle="vehicle" />
  </div>
</template>
<script>
import IssueSheetsIndex from "../../../dashboard/issues/issue_sheets_index.vue";

export default {
  props: ["facility", "vehicle"],
  components: { IssueSheetsIndex },
};
</script>

<style></style>
