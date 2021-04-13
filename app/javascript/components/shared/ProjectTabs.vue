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
        },
        {
          label: "Tasks",
          key: "tasks",
          closable: false,
        },
        {
          label: "Issues",
          key: "issues",
          closable: false,
        },
        {
          label: "Risks",
          key: "risks",
          closable: false,
        },
        {
          label: "Notes",
          key: "notes",
          closable: false,
        },
      ],
    };
  },
  methods: {
    changeTab(tab) {
      if (tab.key === "overview") {
        this.$router.push(this.path);
      } else {
        this.$router.push(this.path + `/${tab.key}`);
      }
    },
  },
  computed: {
    currentTab() {
      return this.tabs
        .map((tab) => tab.key)
        .filter((key) =>
          this.$route.name.toUpperCase().includes(key.toUpperCase())
        );
    },
    tab() {
      let url = this.$route.path;

      if (url.includes("sheet")) {
        return "sheet";
      } else {
        return "map";
      }
    },
    path() {
      return `/programs/${this.$route.params.programId}/${this.tab}/projects/${this.$route.params.projectId}`;
    },
  },
};
</script>

<style scoped lang="scss">
#customtabs {
  background-color: #ededed;
  border-top: solid 0.3px #ededed;
  padding-left: 5px;
  padding-right: 5px;
  box-shadow: 0 2.5px 2.5px rgba(0, 0, 0, 0.19), 0 3px 3px rgba(0, 0, 0, 0.23);
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
</style>
