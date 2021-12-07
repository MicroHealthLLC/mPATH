<template>
  <div>
    <LessonForm class="mx-4" :contract="contract" />
  </div>
</template>

<script>
import LessonForm from "../../../dashboard/lessons/LessonForm";

export default {
  name: "SheetLessonForm",
  props: ["contract"],
  components: {
    LessonForm,
  },
};
</script>

<style scoped></style>
