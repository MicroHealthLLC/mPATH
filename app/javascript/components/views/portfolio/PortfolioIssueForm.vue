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
      ]),
    redirectBack() {
      this.$router.push(
        `/portfolio`
      );        
    },
  },
  computed: {
    ...mapGetters(['portfolioIssue'])
  },
  mounted(){
    this.fetchPortfolioIssue(this.$route.params)
  },
};
</script>

<style scoped></style>
