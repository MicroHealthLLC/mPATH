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
      risk: {},
      allProgramRisks: [],
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
  if (!this.getShowProjectStats){
    this.allProgramRisks = this.filteredAllRisks
  } else if (this.getShowProjectStats){
    this.allProgramRisks = this.filteredAllContractRisks
  }

    if (this.contentLoaded) {
      this.risk =  this.allProgramRisks.find(
        (risk) => risk.id == this.$route.params.riskId
      );
    }
  },
  watch: {
    contentLoaded: {
      handler() {
        this.risk =  this.allProgramRisks.find(
          (risk) => risk.id == this.$route.params.riskId
        );
      },
    },
  },
};
</script>

<style></style>
