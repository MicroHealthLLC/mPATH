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
    ...mapActions([
      'fetchPortfolioIssue', 
      'fetchPortfolioIssues', 
      'fetchPortfolioUsers', 
      'fetchPortfolioIssueStages', 
      'fetchPortfolioIssueTypes', 
      'fetchPortfolioIssueSeverities',
      'fetchPortfolioCategories',
      ]),
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
  mounted(){
  this.fetchPortfolioIssueSeverities()
  this.fetchPortfolioCategories()
  },
  beforeMount(){
    this.fetchPortfolioIssue(this.$route.params)
    this.fetchPortfolioIssueStages()
    this.fetchPortfolioUsers()
    this.fetchPortfolioIssueTypes()
  },
};
</script>

<style scoped></style>
