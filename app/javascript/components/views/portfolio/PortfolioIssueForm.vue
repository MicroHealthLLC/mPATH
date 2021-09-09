<template>
  <portfolioIssueForm :issue="portfolioIssue" @on-close-form="redirectBack"/>
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
    ...mapActions(['fetchPortfolioIssue', 'portfolioIssuesLoaded', 'fetchPortfolioIssueSeverities', 'fetchPortfolioIssueTypes',  'fetchPortfolioIssues', 'fetchPortfolioUsers', 'fetchPortfolioCategories', 'fetchPortfolioIssueStages']),
    redirectBack() {
      this.fetchPortfolioIssues()  
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
    this.fetchPortfolioCategories()
    this.fetchPortfolioIssueStages()
    this.fetchPortfolioUsers()
    this.fetchPortfolioIssueTypes()
    this.fetchPortfolioIssueSeverities()
  },
};
</script>

<style scoped></style>
