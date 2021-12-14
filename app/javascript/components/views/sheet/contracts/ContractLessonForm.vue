<template>
  <div>
    <LessonForm class="mx-4" :contract="contract" />
  </div>
</template>

<script>
import LessonForm from "../../../dashboard/lessons/LessonForm";

export default {
  name: "ContractLessonForm",
  props: ["contract"],
  components: {
    LessonForm,
  },
};
</script>

<style scoped></style>
