<template>
  <NotesSheetsIndex :facility="facility" class="mt-4" />
</template>

<script>
import NotesSheetsIndex from "../../dashboard/notes/notes_sheets_index.vue";

export default {
  props: ["facility"],
  components: { NotesSheetsIndex },
};
</script>

<style></style>
