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
      allProgramIssues: [],
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
      'filteredAllContractIssues',
      'getShowProjectStats'     
      ]),
  },
  mounted() {
  if (!this.getShowProjectStats){
      this.allProgramIssues = this.filteredAllIssues
    } else if (this.getShowProjectStats){
      this.allProgramIssues = this.filteredAllContractIssues
    }

    if (this.contentLoaded) {
      this.issue = this.allProgramIssues.find(
        (issue) => issue.id == this.$route.params.issueId
      );
    }
  },
  watch: {
    contentLoaded: {
      handler() {
        this.issue = this.allProgramIssues.find(
          (issue) => issue.id == this.$route.params.issueId
        );
      },
    },
  },
};
</script>

<style></style>
