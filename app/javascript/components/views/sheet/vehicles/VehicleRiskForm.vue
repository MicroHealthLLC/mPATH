<template>
  <RiskForm :vehicle="vehicle" :risk="risk" @on-close-form="redirectBack" />
</template>

<script>
import { mapGetters } from "vuex";

import RiskForm from "../../../dashboard/risks/risk_form.vue";
export default {
  props: ["vehicle"],
  components: { RiskForm },
  data() {
    return {
      risk: {},
    };
  },
  methods: {
    redirectBack() {
      this.$router.push(
        `/programs/${this.$route.params.programId}/sheet/vehicles/${this.$route.params.vehicleId}/risks`
      );
    },
  },
  computed: {
    ...mapGetters(["contentLoaded"]),
  },
  mounted() {
    if (this.contentLoaded && this.$route.params.riskId !== "new") {
      this.risk = this.vehicle.risks.find(
        (risk) => risk.id == this.$route.params.riskId
      );
    }
  },
  watch: {
    contentLoaded: {
      handler() {
         if (this.$route.params.riskId !== "new"){
            this.risk = this.vehicle.risks.find(
          (risk) => risk.id == this.$route.params.riskId
        );
        }
      },
    },
  },
};
</script>

<style></style>
