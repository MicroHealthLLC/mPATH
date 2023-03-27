<template>
  <IssueForm
    :vehicle="vehicle"
    :issue="issue"
    @on-close-form="redirectBack"
  />
</template>

<script>
import { mapGetters } from "vuex";
import IssueForm from "../../../dashboard/issues/issue_form.vue";
export default {
  props: ["vehicle"],
  name: "VehicleIssueForm",
  components: { IssueForm },
  data() {
    return {
      issue: {},
    };
  },
  methods: {
    redirectBack() {
      this.$router.push(
        `/programs/${this.$route.params.programId}/sheet/vehicles/${this.$route.params.vehicleId}/issues`
      );
    },
  },
  computed: {
    ...mapGetters(["contentLoaded"]),
  },
  mounted() {
    if (this.contentLoaded && this.$route.params.issueId !== "new") {
      this.issue = this.vehicle.issues.find(
        (issue) => issue.id == this.$route.params.issueId
      );
    }
  },
  watch: {
    contentLoaded: {
      handler() {
       if (this.$route.params.issueId !== "new"){
        this.issue = this.vehicle.issues.find(
          (issue) => issue.id == this.$route.params.issueId
        );
       }
      },
    },
  },
};
</script>

<style></style>
