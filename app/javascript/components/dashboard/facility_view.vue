<template>
  <div id="facility_view">
    <div class="row">
      <div class="col-md-3 facility-groups-tab">
        <h4 class="mt-4 text-center">Facility Manager</h4>
        <div class="my-4 ml-2">
          <div v-for="group in filteredFacilityGroups">
            <div class="d-flex align-items-center expandable" @click="toggleExpanded(group)" :class="{'active': group.id == currentFacilityGroup.id}">
              <span v-show="expanded.id != group.id">
                <i class="fa fa-plus font-sm mr-2"></i>
              </span>
              <span v-show="expanded.id == group.id">
                <i class="fa fa-minus font-sm mr-2"></i>
              </span>
              <h5>{{group.name}}</h5>
            </div>
            <div v-show="expanded.id == group.id" class="ml-2">
              <div v-for="item in facilityGroupFacilities(group)">
                <div class="d-flex align-items-center expandable" @click="showFacility(item)" :class="{'active': item.id == currentFacility.id}">
                  <i class="fa fa-minus font-sm mr-2" aria-hidden="true"></i>
                  <h6>{{item.facility.facilityName}}</h6>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-md-4 facility-show-tab">
        <div class="mt-4">
          <facility-show
            v-if="C_showFacilityTab"
            from="manager_view"
            :facility="currentFacility"
            :facility-group="currentFacilityGroup"
          ></facility-show>
        </div>
      </div>
      <div class="col-md-5 facility-forms-tab">
        <div class="mt-4">
          <task-form
            v-if="managerView.task"
            :facility="currentFacility"
            :task="managerView.task"
            title="Edit Task"
            @task-updated="updateFacilityTask"
          ></task-form>

          <issue-form
            v-if="managerView.issue"
            :facility="currentFacility"
            :issue="managerView.issue"
            @issue-updated="updateFacilityIssue"
          ></issue-form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import {mapGetters, mapMutations} from "vuex"
  import FacilityShow from './facilities/facility_show'
  import TaskForm from "./tasks/task_form"
  import IssueForm from "./issues/issue_form"

  export default {
    name: "FacilityManagerView",
    components: {
      FacilityShow,
      TaskForm,
      IssueForm
    },
    data() {
      return {
        expanded: {
          id: ''
        },
        currentFacility: {},
        currentFacilityGroup: {}
      }
    },
    computed: {
      ...mapGetters([
        'filteredFacilityGroups',
        'facilityGroupFacilities',
        'managerView'
      ]),
      C_showFacilityTab() {
        return !(_.isEmpty(this.currentFacility) && _.isEmpty(this.currentFacility))
      }
    },
    methods: {
      ...mapMutations([
        'updateTasksHash',
        'updateIssuesHash',
        'setTaskForManager'
      ]),
      toggleExpanded(group) {
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
      showFacility(facility) {
        this.currentFacility = facility
      },
      updateFacilityTask(task) {
        this.updateTasksHash({task: task})
        this.setTaskForManager({key: 'task', value: null})
      },
      updateFacilityIssue(issue) {
        this.updateIssuesHash({issue: issue})
        this.setTaskForManager({key: 'issue', value: null})
      }
    },
    watch: {
      currentFacility: {
        handler(value) {
          if (!value.id) {
            this.setTaskForManager({key: 'task', value: null})
            this.setTaskForManager({key: 'issue', value: null})
          }
        }, deep: true
      }
    }
  }
</script>

<style lang="scss">
  #facility_view {
    padding: 0 70px;
    .facility-groups-tab {
      background: #4472C4;
      color: #fff;
      max-height: calc(100vh - 94px);
      height: calc(100vh - 94px);
      overflow-y: auto;
    }
    .facility-forms-tab,
    .facility-show-tab {
      max-height: calc(100vh - 94px);
      height: calc(100vh - 94px);
      overflow-y: auto;
    }
    .expandable {
      cursor: pointer;
      &.active,
      &:hover {
        text-decoration: underline;
      }
    }
  }
</style>
