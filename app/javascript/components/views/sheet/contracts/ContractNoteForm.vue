<template>
  <ContractNotesForm  :contract="contract"   />
</template>

<script>
import ContractNotesForm from "../../../dashboard/notes/contract_notes_form.vue";
export default {
  props: ["contract"],
  components: { ContractNotesForm },
};
</script>

<style></style>
