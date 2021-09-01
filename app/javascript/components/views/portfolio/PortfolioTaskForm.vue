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
    ...mapActions(['fetchPortfolioTask', 'portfolioTaskLoaded', 'fetchPortfolioTasks', 'fetchPortfolioCategories']),
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
    this.fetchPortfolioCategories()
  },
};
</script>

<style scoped></style>
