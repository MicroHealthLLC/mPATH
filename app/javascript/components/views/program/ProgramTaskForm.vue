<template>
  <TaskForm :task="task" @on-close-form="redirectBack"/>
</template>

<script>
import { mapGetters } from "vuex";
import TaskForm from "../../dashboard/tasks/task_form";
export default {
  components: {
    TaskForm,
  },
  data() {
    return {
      task: {},
      allProgramTasks: [],
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
    ...mapGetters([
      "contentLoaded", 
      "currentProject", 
      'filteredAllTasks',
      'filteredAllContractTasks',
      'getShowProjectStats'
      ]),
  },
mounted() {
  if (!this.getShowProjectStats){
    this.allProgramTasks = this.filteredAllTasks
  } else if (this.getShowProjectStats){
    this.allProgramTasks = this.filteredAllContractTasks
  }
  if (this.contentLoaded) {
    this.task = this.allProgramTasks.find(
        (task) => task.id == this.$route.params.taskId
      );
    }        
  },
  watch: {
    contentLoaded: {
      handler() {       
          this.task = this.allProgramTasks.find(
            (task) => task.id == this.$route.params.taskId
          );
      },
    },
  },
};
</script>

<style>

</style>
