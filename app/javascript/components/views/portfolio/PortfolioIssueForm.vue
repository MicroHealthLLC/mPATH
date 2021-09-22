<template>
  <portfolioIssueForm :issue="portfolioIssue" @on-close-form="redirectBack" @issue-updated="updateTable"/>
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
    updateTable() {
      this.fetchPortfolioIssues()  
      },   
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
    this.fetchPortfolioUsers()
    this.fetchPortfolioIssueTypes()
    this.fetchPortfolioIssueSeverities()
    this.fetchPortfolioCategories()
  },
};
</script>

<style scoped></style>
