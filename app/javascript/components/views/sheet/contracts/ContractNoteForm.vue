<template>
  <ContractsNotesForm :contract="contract" />
</template>

<script>
import ContractsNotesForm from "../../../dashboard/notes/contract_notes_form.vue";

export default {
  props: ["contract"],
  components: { ContractsNotesForm },
 
};
</script>

<style></style>
