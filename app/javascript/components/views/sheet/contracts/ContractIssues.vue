<template>
  <div>
    <IssueSheetsIndex :facility="facility" :contract="contract" />
  </div>
</template>
<script>
import IssueSheetsIndex from "../../../dashboard/issues/issue_sheets_index.vue";

export default {
  props: ["facility", "contract"],
  components: { IssueSheetsIndex },
};
</script>

<style></style>
