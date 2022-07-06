<template>
  <portfolioIssueForm :issue="portfolioIssue" @on-close-form="redirectBack" />
</template>
<script>

import portfolioIssueForm from "./portfolio_issue_form.vue"
import{ mapActions, mapGetters }  from 'vuex';
export default {
  name: "PortfolioIssueForm",
  components: {
    portfolioIssueForm,
  },
  methods:{
    ...mapActions([
      'fetchPortfolioIssue', 
      'fetchPortfolioIssues', 
      'fetchPortfolioAssignees', 
      'fetchPortfolioIssueStages', 
      'fetchPortfolioIssueTypes', 
      'fetchPortfolioIssueSeverities',
      'fetchPortfolioCategories',
      ]),
    redirectBack() {
      this.$router.push(
        `/portfolio`
      );        
    },
  },
  computed: {
    ...mapGetters(['portfolioIssue', 'portfolioTab'])
  },
  beforeMount(){
    this.fetchPortfolioIssue(this.$route.params)
    this.fetchPortfolioIssueStages()
    this.fetchPortfolioAssignees()
    this.fetchPortfolioIssueTypes()
    this.fetchPortfolioIssueSeverities()
    this.fetchPortfolioCategories()
  },
};
</script>

<style scoped></style>
