<template>
  <portfolioTaskForm :task="portfolioTask" @on-close-form="redirectBack"/>
</template>


<script>
import portfolioTaskForm from "./portfolio_task_form.vue"
import{ mapActions, mapGetters }  from 'vuex';

export default {
  name: "PortfolioTaskForm",
  components: {
    portfolioTaskForm,
  },
  methods:{
    ...mapActions(['fetchPortfolioTask', 'portfolioTaskLoaded', 'fetchPortfolioUsers', 'fetchPortfolioTasks', 'fetchPortfolioCategories', 'fetchPortfolioTaskStages']),
    redirectBack() {
      this.fetchPortfolioTasks()
      this.$router.push(
        `/portfolio`
      );
    },
  },
  computed: {
    ...mapGetters(['portfolioTask'])
  },
  beforeMount(){
    this.fetchPortfolioTask(this.$route.params)
    this.fetchPortfolioUsers()
    this.fetchPortfolioCategories()
    this.fetchPortfolioTaskStages()
  },
};
</script>

<style scoped></style>
