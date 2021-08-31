<template>
  <portfolioRiskForm :risk="portfolioRisk" @on-close-form="redirectBack"/>
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
    ...mapActions(['fetchPortfolioRisk', 'portfolioRisksLoaded', 'fetchPortfolioRisks', 'fetchPortfolioCategories']),
    redirectBack() {
      this.fetchPortfolioRisks()
      this.$router.push(
        `/portfolio`
      );
    },
  },
  computed: {
    ...mapGetters(['portfolioRisk'])
  },
  beforeMount(){
    this.fetchPortfolioRisk(this.$route.params)
    this.fetchPortfolioCategories()
  },
};
</script>

<style scoped></style>
