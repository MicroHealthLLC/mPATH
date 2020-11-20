<template>
  <div id="kanban-view">
    <div class="row">
      <div class="col-md-2 facility-groups-tab">
        <custom-tabs :current-tab="currentTab" :tabs="tabs" @on-change-tab="onChangeTab" class="mt-4" badge-margin="4px" />
        <facility-sidebar
          :current-facility-group="currentFacilityGroup"
          :expanded="expanded"
          :current-facility="currentFacility"
          @on-expand-facility-group="expandFacilityGroup"
          @on-expand-facility="showFacility"
        ></facility-sidebar>
      </div>
      <div class="col-md-10 kanban-tab bt-light">
        <div class="mt-4">
          <div v-if="'id' in currentFacility">
            <kanban
              :stages="C_kanban.stages"
              :kanban-type="currentTab"
              :cards="C_kanban.cards"
            ></kanban>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import Kanban from './../shared/kanban'
  import CustomTabs from './../shared/custom-tabs'
  import FacilitySidebar from './facilities/facility_sidebar'
  import {mapGetters} from 'vuex'

  export default {
    name: 'KanbanView',
    components: {Kanban, CustomTabs, FacilitySidebar},
    data() {
      return {
        tabs: [
          {
            label: 'Kanban Tasks',
            key: 'tasks',
            closable: false
          },
          {
            label: 'Kanban Issues',
            key: 'issues',
            closable: false
          }
        ],
        currentTab: 'tasks',
        expanded: {
          id: ''
        },
        currentFacility: {},
        currentFacilityGroup: {}
      }
    },
    mounted() {
      // make the first facility_group expanded
      if (this.filteredFacilityGroups.length) this.expandFacilityGroup(this.filteredFacilityGroups[0])
    },
    methods: {
      onChangeTab(tab) {
        this.currentTab = tab ? tab.key : 'tasks'
      },
      showFacility(facility) {
        this.currentFacility = facility
      },
      expandFacilityGroup(group) {
        if (group.id == this.expanded.id) {
          this.expanded.id = ''
          this.currentFacilityGroup = {}
        }
        else {
          this.expanded.id = group.id
          this.currentFacilityGroup = group
        }
        this.currentFacility = {}
      },
    },
    computed: {
      ...mapGetters([
        'filteredFacilityGroups',
        'taskStages',
        'issueStages',
        'taskTypeFilter',
        'myActionsFilter',
        'onWatchFilter',
        'issueTypeFilter',
        'issueSeverityFilter'
      ]),
      filteredTasks() {
        let typeIds = _.map(this.taskTypeFilter, 'id')
        return _.filter(this.currentFacility.tasks, (task) => {
          let valid = Boolean(task && task.hasOwnProperty('progress'))
          if (typeIds.length > 0) valid = valid && typeIds.includes(task.taskTypeId)
          if (this.C_myTasks || this.taskUserFilter) {
            let userIds = [..._.map(task.checklists, 'userId'), ...task.userIds]
            if (this.C_myTasks) valid = valid && userIds.includes(this.$currentUser.id)
            if (this.taskUserFilter && this.taskUserFilter.length > 0) valid = valid && userIds.some(u => _.map(this.taskUserFilter, 'id').indexOf(u) !== -1)
          }
          if (this.C_onWatchTasks) {
            valid  = valid && task.watched
          }
          return valid
        })
      },
      C_myTasks: {
        get() {
          return _.map(this.myActionsFilter, 'value').includes('tasks')
        },
      },
      C_onWatchTasks: {
        get() {
          return _.map(this.onWatchFilter, 'value').includes('tasks')
        }
      },
      filteredIssues() {
        let typeIds = _.map(this.issueTypeFilter, 'id')
        let severityIds = _.map(this.issueSeverityFilter, 'id')
        return _.filter(this.currentFacility.issues, (issue) => {
          let valid = Boolean(issue && issue.hasOwnProperty('progress'))
          if (this.C_myIssues || this.issueUserFilter) {
            let userIds = [..._.map(issue.checklists, 'userId'), ...issue.userIds]
            if (this.C_myIssues) valid = valid && userIds.includes(this.$currentUser.id)
            if (this.issueUserFilter && this.issueUserFilter.length > 0) valid = valid && userIds.some(u => _.map(this.issueUserFilter, 'id').indexOf(u) !== -1)
          }
          if (this.C_onWatchIssues) {
            valid  = valid && issue.watched
          }
          if (typeIds.length > 0) valid = valid && typeIds.includes(issue.issueTypeId)
          if (severityIds.length > 0) valid = valid && severityIds.includes(issue.issueSeverityId)

          return valid;
        })
      },
      C_myIssues: {
        get() {
          return _.map(this.myActionsFilter, 'value').includes('issues')
        }
      },
      C_onWatchIssues: {
        get() {
          return _.map(this.onWatchFilter, 'value').includes('issues')
        }
      },
      C_kanban() {
        return {
          stages: this.currentTab == 'tasks' ? this.taskStages : this.issueStages,
          cards: this.currentTab == 'tasks' ? this.filteredTasks : this.filteredIssues
        }
      }
    },
    watch: {
      filteredFacilityGroups: {
        handler(value) {
          if (!(this.currentFacilityGroup && _.map(value, 'id').includes(this.currentFacilityGroup.id))) {
            this.currentFacilityGroup = {}
            this.currentFacility = {}
            this.expanded.id = ''
          }
        }, deep: true
      }
    }
  }
</script>
<style lang="scss" scoped>
  #kanban-view {
    padding: 0 10px;
    .bt-light {
      border-top: solid #ededed 15px;
    }
    .facility-groups-tab {
      background: #ededed;
      max-height: calc(100vh - 94px);
      height: calc(100vh - 94px);
      overflow-y: auto;
    }
  }
</style>
