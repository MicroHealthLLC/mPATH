<template>
  <RiskForm
    v-if="facility !== null"
    :facility="facility"
    :risk="risk"
    @on-close-form="redirectBack"
  />
</template>

<script>
import { mapGetters } from "vuex";
import RiskForm from "../../dashboard/risks/risk_form.vue";

export default {
  props: ["facility"],
  components: { RiskForm },
  data() {
    return {
      risk: {},
    };
  },
  methods: {
    redirectBack() {
      this.$router.push(
        `/programs/${this.$route.params.programId}/map/projects/${this.$route.params.projectId}/risks`
      );
    },
  },
  computed: {
    ...mapGetters(["contentLoaded"]),
  },
  mounted() {
    if (this.contentLoaded) {
      this.risk = this.facility.risks.find(
        (risk) => risk.id == this.$route.params.riskId
      );
    }
  },
  watch: {
    contentLoaded: {
      handler() {
        this.risk = this.facility.risks.find(
          (risk) => risk.id == this.$route.params.riskId
        );
      },
    },
  },
};
</script>

<style></style>
