<template>
  <div id="kanban-view">
    <custom-tabs :current-tab="currentTab" :tabs="tabs" @on-change-tab="onChangeTab" />
    <div v-show="currentTab == 'issues'">
      <kanban
        :stages="issueStages"
        kanban-type="issues"
        :cards="filteredAllIssues"
      ></kanban>
    </div>
    <div v-show="currentTab == 'tasks'">
      <kanban
        :stages="taskStages"
        kanban-type="tasks"
        :cards="filteredAllTasks"
      ></kanban>
    </div>

  </div>
</template>

<script>
  import Kanban from './../shared/kanban'
  import CustomTabs from './../shared/custom-tabs'
  import {mapGetters} from 'vuex'

  export default {
    name: 'KanbanView',
    components: {Kanban, CustomTabs},
    data() {
      return {
        tabs: [
          {
            label: 'Tasks',
            key: 'tasks',
            closable: false
          },
          {
            label: 'Issues',
            key: 'issues',
            closable: false
          }
        ],
        currentTab: 'tasks'
      }
    },
    methods: {
      onChangeTab(tab) {
        this.currentTab = tab ? tab.key : 'tasks'
      }
    },
    computed: {
      ...mapGetters([
        'filteredAllTasks',
        'filteredAllIssues',
        'taskStages',
        'issueStages'
      ])
    }
  }
</script>
<style lang="scss" scoped>
  #kanban-view {
    padding: 10px 70px;
    max-height: calc(100vh - 100px);
    height: calc(100vh - 100px);
    overflow-y: auto;
  }
</style>
