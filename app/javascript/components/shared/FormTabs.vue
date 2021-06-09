<template>
  <div
    class="d-flex align-items-center"
    :class="{
      'map-width': $route.name.includes('Map') && !$route.name.includes('Risk'),
      'map-risk-width':
        $route.name.includes('Map') && $route.name.includes('Risk'),
    }"
  >
    <div v-for="tab in tabs" :key="tab.key">
      <div
        class="form-tabs"
        :class="{ active: currentTab == tab.key, disabled: tab.disabled }"
        @click.prevent="changeTab(tab)"
        data-cy="facility_tabs"
      >
        <div :class="{ label: tabHasErrors(tab) }">
          <span class="inner-label-text">{{ tab.label }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "FormTabs",
  props: ["tabs", "currentTab", "allErrors"],
  methods: {
    changeTab(tab) {
      if (tab.disabled) return;
      this.$emit("on-change-tab", tab);
    },
    tabHasErrors(tab) {
      if (this.errors.items.length > 0 && tab.form_fields) {
        var errorFields = this.errors.items.map((item) => item.field);
        return tab.form_fields.some((item) => errorFields.includes(item));
      } else {
        return false;
      }
    },
  },
};
</script>

<style scoped lang="scss">
.form-tabs {
  cursor: pointer;
  border-bottom: 5px solid rgba(0, 0, 0, 0.1);
  text-align: center;
  &.active {
    border-bottom: 5px solid #007bff;
    color: #007bff;
  }
  &.disabled .inner-label-text {
    opacity: 0.5;
  }
  &.disabled:hover {
    cursor: not-allowed;
  }
  &:hover {
    color: #007bff;
  }
}
.map-width {
  transform: scale(0.85);
  transform-origin: left;
}
.map-risk-width {
  transform: scale(0.75);
  transform-origin: left;
}
.label::after {
  content: "*";
  color: #dc3545;
  font-weight: 600;
  margin-left: -8px;
}
.inner-label-text {
  margin-left: 10px;
  margin-right: 10px;
  white-space: nowrap;
}
</style>
