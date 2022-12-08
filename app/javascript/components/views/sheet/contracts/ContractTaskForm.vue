<template>
  <TaskForm :contract="contract" :task="task" @on-close-form="redirectBack" />
</template>

<script>
import { mapGetters } from "vuex";
import TaskForm from "../../../dashboard/tasks/task_form.vue";

export default {
  props: ["contract"],
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
        `/programs/${this.$route.params.programId}/sheet/contracts/${this.$route.params.contractId}/tasks`
      );
    },
  },
  computed: {
    ...mapGetters(["contentLoaded", "currentProject"]),
  },
  mounted() {
    if (this.contentLoaded && this.$route.params.taskId !== "new") {
      this.task = this.contract.tasks.find(
        (task) => task.id == this.$route.params.taskId
      );
    }
  },
  watch: {
    contentLoaded: {
      handler() {
        if (this.$route.params.taskId !== "new"){
            this.task = this.contract.tasks.find(
            (task) => task.id == this.$route.params.taskId
          );
        }
      },
    },
  },
};
</script>

<style></style>
