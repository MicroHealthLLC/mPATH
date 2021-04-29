<template>
  <RiskForm
    :facility="facility"
    :risk="risk"
    :fixedStage="stage"
    @on-close-form="redirectBack"
  />
</template>

<script>
import { mapGetters } from "vuex";

import RiskForm from "../../dashboard/risks/risk_form.vue";
export default {
  props: ["facility", "stage"],
  components: { RiskForm },
  data() {
    return {
      risk: {},
    };
  },
  methods: {
    redirectBack() {
      this.$router.push(
        `/programs/${this.$route.params.programId}/kanban/projects/${this.$route.params.projectId}/risks`
      );
    },
  },
  computed: {
    ...mapGetters(["contentLoaded"]),
  },
  mounted() {
    if (this.contentLoaded && this.$route.params.riskId !== "new") {
      this.risk = this.facility.risks.find(
        (risk) => risk.id == this.$route.params.riskId
      );
    }
  },
  watch: {
    contentLoaded: {
      handler() {
        if (this.$route.params.riskId !== "new") {
          this.risk = this.facility.risks.find(
            (risk) => risk.id == this.$route.params.riskId
          );
        }
      },
    },
  },
};
</script>

<style></style>
