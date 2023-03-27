<template>
  <VehicleNotesForm  :vehicle="vehicle"   />
</template>

<script>
import VehicleNotesForm from "../../../dashboard/notes/vehicle_notes_form.vue";
export default {
  props: ["vehicle"],
  components: { VehicleNotesForm },
};
</script>

<style></style>
