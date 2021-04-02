<template>
  <div id="customtabs" class="d-flex align-items-center">
    <div v-for="tab in tabs" :key="tab.key">
      <div
        class="badge"
        :class="{ active: currentTab == tab.key, disabled: tab.disabled }"
        @click="changeTab(tab)"
      >
        <div>{{ tab.label }}</div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "ProjectTabs",
  data() {
    return {
      tabs: [
        {
          label: "Overview",
          key: "overview",
          closable: false,
          path: `/programs/${this.$route.params.programId}/sheet/projects/${this.$route.params.projectId}`,
        },
        {
          label: "Tasks",
          key: "tasks",
          closable: false,
          path: `/programs/${this.$route.params.programId}/sheet/projects/${this.$route.params.projectId}/tasks`,
        },
        {
          label: "Issues",
          key: "issues",
          closable: false,
          path: `/programs/${this.$route.params.programId}/sheet/projects/${this.$route.params.projectId}/issues`,
        },
        {
          label: "Risks",
          key: "risks",
          closable: false,
          path: `/programs/${this.$route.params.programId}/sheet/projects/${this.$route.params.projectId}/risks`,
        },
        {
          label: "Notes",
          key: "notes",
          closable: false,
          path: `/programs/${this.$route.params.programId}/sheet/projects/${this.$route.params.projectId}/notes`,
        },
      ],
    };
  },
  methods: {
    changeTab(tab) {
      this.$router.push(tab.path)
    }
  },
  computed: {
    currentTab() {
      return this.tabs
        .map((tab) => tab.key)
        .filter((key) =>
          this.$route.name.toUpperCase().includes(key.toUpperCase())
        );
    },
  },
};
</script>

<style scoped lang="scss">
#customtabs {
  .badge {
    cursor: pointer;
    padding: 7px 10px;
    border-radius: 0.1rem;
    font-weight: 500;
    letter-spacing: 0.12em;
    margin: 4px 7px;
    transition: auto;
    &.active {
      color: #fff !important;
      background-color: #383838 !important;
    }
    &.disabled {
      pointer-events: none;
      opacity: 0.5;
      cursor: not-allowed;
      border: 0 !important;
      padding: 7px 10px !important;
    }
    &:hover {
      background-color: rgba(91, 192, 222, 0.3);
      border: none !important;
      color: #383838;
    }
  }
}
.tab-shadow {
  box-shadow: 0 2px 5px 0 rgba(0, 0, 0, 0.02), 0 2px 5px 0 rgba(0, 0, 0, 0.03);
}
</style>
