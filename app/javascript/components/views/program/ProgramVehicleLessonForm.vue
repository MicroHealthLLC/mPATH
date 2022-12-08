<template>
  <VehiclesLessonForm :lesson="lesson" @on-close-form="redirectBack" style="padding:30px" />
</template>

<script>
import { mapGetters } from "vuex";
import VehiclesLessonForm from "./../../dashboard/lessons/VehiclesLessonForm.vue";
export default {
 name:  "ProgramVehicleLessonForm",
 components: { 
   VehiclesLessonForm
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
    if (this.getShowProjectStats == 0)  {
        this.allProgramLessons = this.programLessons.filter(l => l.project_id)
    } 
    if (this.getShowProjectStats == 1){
        this.allProgramLessons = this.programLessons.filter(l => l.project_contract_id)
      }
    if (this.getShowProjectStats == 2){
        this.allProgramLessons =  this.programLessons.filter(l => l && l.project_contract_vehicle_id)       
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
