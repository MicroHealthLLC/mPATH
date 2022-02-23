<template>
  <NotesSheetsIndex :contract="contract" class="mt-4" />
</template>

<script>
import NotesSheetsIndex from "../../../dashboard/notes/notes_sheets_index.vue";

export default {
  props: ["contract"],
  components: { NotesSheetsIndex },
};
</script>

<style></style>
