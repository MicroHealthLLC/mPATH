<template>
  <IssueIndex v-if="facility !== null" :facility="facility" />
</template>

<script>
import IssueIndex from "../../dashboard/issues/issue_index.vue";
export default {
  props: ["facility"],
  components: { IssueIndex },
};
</script>

<style></style>
