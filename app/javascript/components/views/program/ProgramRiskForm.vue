<template>
  <RiskForm :risk="risk" @on-close-form="redirectBack" />
</template>

<script>
import { mapGetters } from "vuex";

import RiskForm from "../../dashboard/risks/risk_form.vue";
export default {
  props: ["facility"],
  components: { RiskForm },
  data() {
    return {
      risk: {}
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
      'filteredAllRisks',
      'filteredAllContractRisks',
      'getShowProjectStats'
      ]),
  },
  mounted() {

      this.risk =  this.filteredAllRisks.find(
        (risk) => risk.id == this.$route.params.riskId
      );
  },
  watch: {
    contentLoaded: {
      handler() {
        this.risk =  this.filteredAllRisks.find(
          (risk) => risk.id == this.$route.params.riskId
        );
      },
    },
  },
};
</script>

<style></style>
