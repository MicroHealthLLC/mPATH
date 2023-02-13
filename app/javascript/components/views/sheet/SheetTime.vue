<template>
  <TimeSheetsIndex :facility="facility" class="mt-4" />
</template>

<script>
import TimeSheetsIndex from "../../dashboard/time/time_sheets_index.vue";

export default {
  props: ["facility"],
  components: { TimeSheetsIndex },
};
</script>

<style></style>
