<template>
  <div>
    <LessonForm class="mx-4" :facility="facility" />
  </div>
</template>

<script>
import LessonForm from "./../../dashboard/lessons/LessonForm.vue";

export default {
  name: "SheetLessonForm",
  props: ["facility"],
  components: {
    LessonForm,
  },
};
</script>

<style scoped></style>
