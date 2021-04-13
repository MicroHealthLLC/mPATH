<template>
  <div>
    <IssueSheetsIndex :facility="facility" />
  </div>
</template>

<script>
import IssueSheetsIndex from "../../dashboard/issues/issue_sheets_index.vue";

export default {
  props: ["facility"],
  components: { IssueSheetsIndex },
};
</script>

<style></style>
