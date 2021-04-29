<template>
  <NoteIndex v-if="facility !== null" :facility="facility" class="mt-2" />
</template>

<script>
import NoteIndex from "../../dashboard/notes/notes_index.vue";
export default {
  props: ["facility"],
  components: { NoteIndex },
};
</script>

<style></style>
