<template>
  <portfolioTaskForm :task="portfolioTask" @on-close-form="redirectBack"/>
</template>


<script>
import portfolioTaskForm from "./portfolio_task_form.vue"
import{ mapActions, mapGetters }  from 'vuex';

export default {
  name: "PortfolioTaskForm",
  // props: ["task"],
  components: {
    portfolioTaskForm,
  },
  //  data() {
  //   return {
  //     task: {},
  //   };
  // },
  methods:{
    ...mapActions(['fetchPortfolioTask', 'portfolioTasksLoaded']),

    redirectBack() {
      this.$router.push(
        `/portfolio`
      );
    },
  },
  //   mounted() {
  //   if (this.portfolioTasksLoaded && this.$route.params.taskId !== "new") {
  //     this.task = this.$route.params.task
  //   }
  // },
  computed: {
    ...mapGetters(['portfolioTask'])
  },
  beforeMount(){
    this.fetchPortfolioTask(this.$route.params)
  },
};
</script>

<style scoped></style>
