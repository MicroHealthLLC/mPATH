<template>
  <TaskForm :task="task" @on-close-form="redirectBack"/>
</template>

<script>
import { mapGetters } from "vuex";
import TaskForm from "../../dashboard/tasks/task_form";
export default {
  props: ["facility"],
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
    ...mapGetters(["contentLoaded", "currentProject", 'filteredAllTasks']),
  },
  mounted() {
    if (this.contentLoaded && this.$route.params.taskId !== "new") {
      this.task = this.filteredAllTasks.find(
        (task) => task.id == this.$route.params.taskId
      );
    }
  },
  watch: {
    contentLoaded: {
      handler() {
        if (this.$route.params.taskId !== "new") {
          this.task = this.filteredAllTasks.find(
            (task) => task.id == this.$route.params.taskId
          );
        }
      },
    },
  },
};
</script>

<style>

</style>
