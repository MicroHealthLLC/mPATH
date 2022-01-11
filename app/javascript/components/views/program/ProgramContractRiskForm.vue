<template>
  <RiskForm :risk="risk" @on-close-form="redirectBack" />
</template>

<script>
import { mapGetters } from "vuex";
import RiskForm from "../../dashboard/risks/risk_form.vue";
export default {
  components: { RiskForm },
  data() {
    return {
      risk: {},
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
      'filteredAllContractRisks',
        ]),
  },
  mounted() {
    if (this.contentLoaded) {
      this.risk =  this.filteredAllContractRisks.find(
        (risk) => risk.id == this.$route.params.riskId
      );
    }
  },
  watch: {
    contentLoaded: {
      handler() {
        this.risk =  this.filteredAllContractRisks.find(
          (risk) => risk.id == this.$route.params.riskId
        );
      },
    },
  },
};
</script>

<style></style>
