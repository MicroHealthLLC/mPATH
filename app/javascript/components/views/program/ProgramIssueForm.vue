<template>
  <IssueForm :issue="issue" @on-close-form="redirectBack" />
</template>

<script>
import { mapGetters } from "vuex";

import IssueForm from "../../dashboard/issues/issue_form.vue";
export default {
  components: { IssueForm },
  data() {
    return {
      issue: {},
    };
  },
  methods: {
    redirectBack() {
      this.$router.push(
         `/programs/${this.$route.params.programId}/dataviewer`
      );
    },
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      'filteredAllIssues',
      ]),
  },
  mounted() {
     this.issue = this.filteredAllIssues.find(
        (issue) => issue.id == this.$route.params.issueId
      )
  },
  watch: {
    contentLoaded: {
      handler() {
        this.issue = this.filteredAllIssues.find(
          (issue) => issue.id == this.$route.params.issueId
        );
      },
    },
  },
};
</script>

<style></style>
