<template>
  <SheetTIme :facility="facility" class="mt-4" />
</template>

<script>
import SheetTime from "../../dashboard/time/time_sheets.vue";

export default {
  props: ["facility"],
  components: { SheetTime },
};
</script>

<style></style>
