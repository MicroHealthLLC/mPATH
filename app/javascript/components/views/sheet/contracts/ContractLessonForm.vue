<template>
  <div>
    <ContractsLessonForm class="mx-4" :contract="contract" />
  </div>
</template>

<script>
import ContractsLessonForm from "../../../dashboard/lessons/ContractsLessonForm.vue";

export default {
  name: "ContractLessonForm",
  props: ["contract"],
  components: {
    ContractsLessonForm,
  },
};
</script>

<style scoped></style>
