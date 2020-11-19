<template>
  <div id="customtabs" class="d-flex align-items-center">
    <div v-for="tab in tabs" :key="tab.key">
      <div class="badge" :class="{active: currentTab == tab.key, disabled: tab.disabled}" @click.prevent="changeTab(tab)">
        <div>{{tab.label}}</div>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: "CustomTabs",
    props: ["tabs", "currentTab"],
    methods: {
      changeTab(tab) {
        this.$emit('on-change-tab', tab)
      }
    }
  }
</script>

<style scoped lang="scss">
  #customtabs {
    display: flex;
    align-items: center;
    box-shadow: 0 2px 5px 0 rgba(0,0,0,0.02), 0 2px 5px 0 rgba(0,0,0,0.03);
    .badge {
      cursor: pointer;
      padding: 7px 10px;
      letter-spacing: 0.12em;
      margin: 4px 10px;
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
</style>
