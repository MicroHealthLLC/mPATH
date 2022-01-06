<template>
  <LessonForm :lesson="lesson" @on-close-form="redirectBack" style="padding:30px" />
</template>

<script>
import { mapGetters } from "vuex";
import LessonForm from "./../../dashboard/lessons/LessonForm";
export default {
 components: { 
   LessonForm
   },
  data() {
    return {
      lesson: {},
      allProgramLessons: [],
    };
  },
  methods: {
    redirectBack() {
      this.$router.push(
         `/programs/${this.$route.params.programId}/dataviewer`
      );
    },
  },
  computed: {
    ...mapGetters(["contentLoaded", 'programLessons', 'getShowProjectStats']),
  },
  mounted() {
    if(!this.getShowProjectStats){
        this.allProgramLessons = this.programLessons.filter(l => l.project_id)
      } else if (this.getShowProjectStats){
         this.allProgramLessons =  this.programLessons.filter(l => l.contract_id)
      } 
    if (this.contentLoaded) {
      this.lesson =  this.allProgramLessons.find(
        (lesson) => lesson.id == this.$route.params.lessonId
      );
    }
  },
  watch: {
    contentLoaded: {
      handler() {
        this.lesson =  this.allProgramLessons.find(
          (lesson) => lesson.id == this.$route.params.lessonId
        );
      },
    },
  },
};
</script>

<style></style>
