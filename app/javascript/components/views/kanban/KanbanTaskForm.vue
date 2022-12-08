<template>
  <TaskForm
    :facility="facility"
    :task="task"
    :fixedStage="stage"
    @on-close-form="redirectBack"
  />
</template>

<script>
import { mapGetters } from "vuex";
import TaskForm from "../../dashboard/tasks/task_form.vue";

export default {
  props: ["facility", "stage"],
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
        `/programs/${this.$route.params.programId}/kanban/projects/${this.$route.params.projectId}/tasks`
      );
    },
  },
  computed: {
    ...mapGetters(["contentLoaded"]),
  },
  mounted() {
    if (this.contentLoaded) {
      this.task = this.facility.tasks.find(
        (task) => task.id == this.$route.params.taskId
      );
    }
  },
  watch: {
    contentLoaded: {
      handler() {
        if (this.$route.params.taskId !== "new") {
          this.task = this.facility.tasks.find(
            (task) => task.id == this.$route.params.taskId
          );
        }
      },
    },
  },
};
</script>

<style></style>
