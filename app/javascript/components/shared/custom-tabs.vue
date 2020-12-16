<template>
  <div id="customtabs" class="d-flex align-items-center" :class="{'tab-shadow': !badgeMargin}">
    <div v-for="tab in tabs" :key="tab.key">
      <div class="badge" :class="{active: currentTab == tab.key, disabled: tab.disabled}" @click.prevent="changeTab(tab)" :style="badgeStyle" data-cy="facility_tabs">
        <div>{{tab.label}}</div>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: "CustomTabs",
    props: ["tabs", "currentTab", "badgeMargin"],
    methods: {
      changeTab(tab) {
        if (tab.disabled) return;
        this.$emit('on-change-tab', tab)
      }
    },
    computed: {
      badgeStyle() {
        return this.badgeMargin ? {margin: this.badgeMargin} : {}
      }
    }
  }
</script>

<style scoped lang="scss">
  #customtabs {
    .badge {
      cursor: pointer;
      padding: 7px 10px;
      letter-spacing: 0.12em;
      margin: 4px 7px;
      transition: auto;
      &.active {
        color: #fff;
        background-color: #17a2b8;
      }
      &.disabled {
        pointer-events: none;
        opacity: 0.5;
        cursor: not-allowed;
        border: 0 !important;
        padding: 7px 10px !important;
      }
      &:hover {
        padding: 6px 9px;
        border: 1px solid #17a2b8;
      }
    }
  }
  .tab-shadow {
    box-shadow: 0 2px 5px 0 rgba(0,0,0,0.02), 0 2px 5px 0 rgba(0,0,0,0.03);
  }
</style>
