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
      'filteredAllContractTasks',
      ]),
  },
mounted() {
  if (this.contentLoaded) {
    this.task = this.filteredAllContractTasks.find(
        (task) => task.id == this.$route.params.taskId
      );
    }        
  },
  watch: {
    contentLoaded: {
      handler() {       
          this.task = this.filteredAllContractTasks.find(
            (task) => task.id == this.$route.params.taskId
          );
      },
    },
  },
};
</script>

<style>

</style>
