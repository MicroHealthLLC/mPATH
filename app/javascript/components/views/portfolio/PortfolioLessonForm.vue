<template>
  <portfolioLessonForm :lesson="portfolioLesson" @on-close-form="redirectBack"/>
</template>


<script>
import portfolioLessonForm from "./portfolio_lesson_form.vue"
import{ mapActions, mapGetters }  from 'vuex';

export default {
  name: "PortfolioLessonForm",
  components: {
    portfolioLessonForm,
  },
  methods:{
    ...mapActions(['fetchPortfolioLesson', 'portfolioLessonLoaded', 'fetchPortfolioLessons', 'fetchPortfolioCategories']),
    redirectBack() {
      this.fetchPortfolioLessons()
      this.$router.push(
        `/portfolio`
      );
    },
  },
  computed: {
    ...mapGetters(['portfolioLesson'])
  },
  beforeMount(){
    // this.fetchPortfolioLesson(this.$route.params)
    this.fetchPortfolioCategories()
  },
};
</script>

<style scoped></style>
