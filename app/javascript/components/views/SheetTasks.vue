<template>
  <div>
    <h1>Tasks</h1>
  </div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
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
