<template>
  <TaskForm :task="task" @on-close-form="redirectBack"/>
</template>

<script>
import { mapGetters } from "vuex";
import TaskForm from "../../dashboard/tasks/task_form.vue";
export default {
  components: {
    TaskForm,
  },
  data() {
    return {
      task: {},
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
      'getShowProjectStats'
      ]),
  },
mounted() {
    this.task = this.filteredAllTasks.find(
        (task) => task.id == this.$route.params.taskId
      );      
  },
  watch: {
    contentLoaded: {
      handler() {       
          this.task = this.filteredAllTasks.find(
            (task) => task.id == this.$route.params.taskId
          );
      },
    },
  },
};
</script>

<style>

</style>
