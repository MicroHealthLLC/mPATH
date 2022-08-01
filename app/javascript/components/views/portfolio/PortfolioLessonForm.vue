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
    ...mapActions(['fetchPortfolioLesson']),
    redirectBack() {
      // this.fetchPortfolioLessons()
      this.$router.push(
        `/portfolio`
      );
    },
  },
  computed: {
    ...mapGetters(['portfolioLesson'])
  },
 mounted(){
    this.fetchPortfolioLesson(this.$route.params)    
  },
};
</script>

<style scoped></style>
