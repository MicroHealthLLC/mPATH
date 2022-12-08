<template>
  <LessonForm :lesson="lesson" @on-close-form="redirectBack" style="padding:30px" />
</template>

<script>
import { mapGetters } from "vuex";
import LessonForm from "./../../dashboard/lessons/LessonForm.vue";
export default {
 name:  "ProgramLessonForm",
 components: { 
   LessonForm
   },
  data() {
    return {
      lesson: {},
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
    ...mapGetters(["contentLoaded", 'programLessons']),
  },
  mounted() {
      this.lesson =  this.programLessons.find(
        (lesson) => lesson.id == this.$route.params.lessonId
      );
  },
  watch: {
    contentLoaded: {
      handler() {
        this.lesson =  this.programLessons.find(
          (lesson) => lesson.id == this.$route.params.lessonId
        );
      },
    },
  },
};
</script>

<style></style>
