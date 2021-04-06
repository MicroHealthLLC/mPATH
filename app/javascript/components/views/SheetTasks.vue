<template>
  <div>
    <TaskSheetsIndex
      :facility="facility"
    />
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import TaskSheetsIndex from "../dashboard/tasks/task_sheets_index"

export default {
  props: ["facility"],
  components: {
    TaskSheetsIndex
  },
  data() {
    return {
      project: {},
    };
  },
  computed: {
    ...mapGetters(["currentProject"]),
  },
  mounted() {
    this.project = this.currentProject.facilities.find(
      (item) => item.facilityId == this.$route.params.projectId
    );
  },
};
</script>

<style></style>
