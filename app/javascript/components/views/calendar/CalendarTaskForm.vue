<template>
  <TaskForm :facility="facility" :task="task" @on-close-form="redirectBack" />
</template>

<script>
import { mapGetters } from "vuex";
import TaskForm from "../../dashboard/tasks/task_form.vue";

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
        `/programs/${this.$route.params.programId}/calendar/projects/${this.$route.params.projectId}/tasks`
      );
    },
  },
  computed: {
    ...mapGetters(["contentLoaded", "currentProject"]),
  },
  mounted() {
    if (this.contentLoaded && this.$route.params.taskId !== "new") {
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
