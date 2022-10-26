<template>
  <NotesSheetsIndex :vehicle="vehicle" class="mt-4" />
</template>

<script>
import NotesSheetsIndex from "../../../dashboard/notes/notes_sheets_index.vue";

export default {
  props: ["vehicle"],
  components: { NotesSheetsIndex },
};
</script>

<style></style>
