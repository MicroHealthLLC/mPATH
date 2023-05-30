<template>
    <SheetEffort :facility="facility" class="mt-4" />
  </template>
  
  <script>
  import SheetEffort from "../../dashboard/effort/effort_sheets.vue";
  
  export default {
    props: ["facility"],
    components: { SheetEffort },
  };
  </script>
  
  <style></style>