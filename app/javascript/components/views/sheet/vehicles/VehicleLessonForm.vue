<template>
  <div>
    <VehiclesLessonForm class="mx-4" :vehicle="vehicle" />
  </div>
</template>

<script>
import VehiclesLessonForm from "../../../dashboard/lessons/VehiclesLessonForm.vue";

export default {
  name: "VehicleLessonForm",
  props: ["vehicle"],
  components: {
    VehiclesLessonForm,
  },
};
</script>

<style scoped></style>
