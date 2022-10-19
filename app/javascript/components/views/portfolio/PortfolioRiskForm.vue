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
    ...mapActions(['fetchPortfolioRisk', 'fetchPortfolioCategories', 'fetchPortfolioAssignees', 'fetchPortfolioRiskStages' ]),
    redirectBack() {
      this.$router.push(
        `/portfolio`
      );
    },
  },
  computed: {
    ...mapGetters(['portfolioRisk'])
  },
  mounted(){
    this.fetchPortfolioCategories()
    this.fetchPortfolioRisk(this.$route.params)
    this.fetchPortfolioAssignees()
    this.fetchPortfolioRiskStages() 
  },
};
</script>

<style scoped></style>
