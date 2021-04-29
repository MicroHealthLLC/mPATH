<template>
  <IssueForm
    :facility="facility"
    :issue="issue"
    :fixedStage="stage"
    @on-close-form="redirectBack"
  />
</template>

<script>
import { mapGetters } from "vuex";
import IssueForm from "../../dashboard/issues/issue_form.vue";
export default {
  props: ["facility", "stage"],
  components: { IssueForm },
  data() {
    return {
      issue: {},
    };
  },
  methods: {
    redirectBack() {
      this.$router.push(
        `/programs/${this.$route.params.programId}/kanban/projects/${this.$route.params.projectId}/issues`
      );
    },
  },
  computed: {
    ...mapGetters(["contentLoaded"]),
  },
  mounted() {
    if (this.contentLoaded && this.$route.params.issueId !== "new") {
      this.issue = this.facility.issues.find(
        (issue) => issue.id == this.$route.params.issueId
      );
    }
  },
  watch: {
    contentLoaded: {
      handler() {
        if (this.$route.params.issueId !== "new") {
          this.issue = this.facility.issues.find(
            (issue) => issue.id == this.$route.params.issueId
          );
        }
      },
    },
  },
};
</script>

<style></style>
