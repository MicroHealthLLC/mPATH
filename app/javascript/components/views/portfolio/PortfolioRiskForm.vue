<template>
  <portfolioRiskForm :risk="portfolioRisk" @on-close-form="redirectBack" @risk-updated="updateTable"/>
</template>
<script>

import portfolioRiskForm from "./portfolio_risk_form.vue"
import{ mapActions, mapGetters }  from 'vuex';
export default {
  name: "PortfolioRiskForm",
  components: {
    portfolioRiskForm,
  },
  methods:{
    ...mapActions(['fetchPortfolioRisk', 'portfolioRisksLoaded', 'fetchPortfolioRisks', 'fetchPortfolioUsers','fetchPortfolioCategories', 'fetchPortfolioRiskStages']),
   updateTable() {
      this.fetchPortfolioRisks()
      },    
   redirectBack() {
      this.$router.push(
        `/portfolio`
      );
    },
  },
  computed: {
    ...mapGetters(['portfolioRisk', 'portfolioRisks'])
  },
  beforeMount(){
    this.fetchPortfolioRisk(this.$route.params)
    this.fetchPortfolioUsers()
    this.fetchPortfolioCategories()
    this.fetchPortfolioRiskStages()
  },
};
</script>

<style scoped></style>
