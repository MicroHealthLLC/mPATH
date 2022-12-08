<template>
  <ContractsLessonForm :lesson="lesson" @on-close-form="redirectBack" style="padding:30px" />
</template>

<script>
import { mapGetters } from "vuex";
import ContractsLessonForm from "./../../dashboard/lessons/ContractsLessonForm.vue";
export default {
 name:  "ProgramContractLessonForm",
 components: { 
   ContractsLessonForm
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
         this.allProgramLessons =  this.programLessons.filter(l => l && l.project_contract_id)
       
      } 
    if (this.contentLoaded) {
      this.lesson =  this.allProgramLessons.find(
        (lesson) => lesson.id == this.$route.params.lessonId
      );
        // console.log(this.lesson)
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
