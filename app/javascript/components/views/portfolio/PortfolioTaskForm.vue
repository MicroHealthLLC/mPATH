<template>
  <portfolioTaskForm :task="portfolioTask" @on-close-form="redirectBack"  />
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
    ...mapActions(['fetchPortfolioTask']),
    redirectBack() {
      this.$router.push(
        `/portfolio`
      );
    },
  },
  computed: {
    ...mapGetters(['portfolioTask'])
  },
 mounted(){   
    this.fetchPortfolioTask(this.$route.params)   
  },
};
</script>

<style scoped></style>
