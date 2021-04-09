<template>
  <NotesForm
    :facility="facility"
    :note="note"
    @close-note-input="redirectBack"
  />
</template>

<script>
import { mapGetters } from "vuex";
import NotesForm from "../../dashboard/notes/notes_form.vue";

export default {
  props: ["facility"],
  components: { NotesForm },
  data() {
    return {
      note: {},
    };
  },
  methods: {
    redirectBack() {
      this.$router.push(
        `/programs/${this.$route.params.programId}/sheet/projects/${this.$route.params.projectId}/notes`
      );
    },
  },
  computed: {
    ...mapGetters(["contentLoaded"]),
  },
  mounted() {
    if (this.contentLoaded) {
      this.note = this.facility.notes.find(
        (note) => note.id == this.$route.params.noteId
      );
    }
  },
  watch: {
    contentLoaded: {
      handler() {
        this.note = this.facility.notes.find(
          (note) => note.id == this.$route.params.noteId
        );
      },
    },
  },
};
</script>

<style></style>
