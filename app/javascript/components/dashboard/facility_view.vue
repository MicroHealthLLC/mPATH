<template>
  <div id="facility_view">
    <div class="row">
      <div class="col-md-2 facility-groups-tab">
        <h4 class="mt-4 ml-4 text-info">Facility Manager</h4>
        <div class="my-4 ml-2">
          <div v-for="group in filteredFacilityGroups" class="my-3">
            <div class="d-flex expandable" @click="expandFacilityGroup(group)" :class="{'active': group.id == currentFacilityGroup.id}">
              <span v-show="expanded.id != group.id">
                <i class="fa fa-angle-right font-sm mr-2 clickable"></i>
              </span>
              <span v-show="expanded.id == group.id">
               <i class="fa fa-angle-down font-md mr-2 clickable"></i>
              </span>
              <h5 class="clickable">{{group.name}}</h5>
            </div>
            <div v-show="expanded.id == group.id" class="ml-2">
              <div v-for="item in facilityGroupFacilities(group)">
                <div class="d-flex align-items-center expandable" @click="showFacility(item)" :class="{'active': item.id == currentFacility.id}">
                <h6 class="fac-manager-sidebar">{{item.facility.facilityName}}</h6>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-md-4 facility-show-tab bt-light">
        <div class="mt-4">
          <facility-show
            v-if="C_showFacilityTab"
            from="manager_view"
            :facility="currentFacility"
            :facility-group="currentFacilityGroup"
          ></facility-show>
          <facility-rollup
            v-else
            :facility-group="C_showFacilityRollup ? currentFacilityGroup : null"
            from="manager_view"
          ></facility-rollup>
        </div>
      </div>
      <div class="col-md-6 facility-forms-tab bt-light">
        <div class="default-background mt-3">
          <div class="bg-white">
            <task-form
              v-if="managerView.task"
              :facility="currentFacility"
              :task="managerView.task"
              title="Edit Task"
              @task-created="updateFacilityTask"
              @task-updated="updateFacilityTask"
            ></task-form>

            <issue-form
              v-else-if="managerView.issue"
              :facility="currentFacility"
              :issue="managerView.issue"
              @issue-updated="updateFacilityIssue"
              @issue-created="updateFacilityIssue"
            ></issue-form>

            <notes-form
              v-else-if="managerView.note"
              from="manager_view"
              :facility="currentFacility"
              :note="managerView.note"
              @close-note-input=""
              @note-created="createdFacilityNote"
              @note-updated="updatedFacilityNote"
            ></notes-form>

            <div v-else class="centeredDiv text-center">
              <i class="fa fa-tasks font-lg text-center" style="font-size:1.8rem"></i>
              <p>View, Add or Edit Tasks, Issues, and Notes here.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import {mapGetters, mapMutations, mapActions} from "vuex"
  import FacilityShow from './facilities/facility_show'
  import FacilityRollup from './facilities/facility_rollup'
  import TaskForm from "./tasks/task_form"
  import IssueForm from "./issues/issue_form"
  import NotesForm from "./notes/notes_form"

  export default {
    name: "FacilityManagerView",
    components: {
      FacilityShow,
      FacilityRollup,
      TaskForm,
      IssueForm,
      NotesForm
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
        return !_.isEmpty(this.currentFacility) && !_.isEmpty(this.currentFacilityGroup)
      },
      C_showFacilityRollup() {
        return !_.isEmpty(this.currentFacilityGroup)
      }
    },
    mounted() {
      // make the first facility_group expanded
      if (this.filteredFacilityGroups.length) this.expandFacilityGroup(this.filteredFacilityGroups[0])
    },
    methods: {
      ...mapMutations([
        'updateTasksHash',
        'updateIssuesHash',
        'setTaskForManager'
      ]),
      ...mapActions([
        'taskUpdated'
      ]),
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
      showFacility(facility) {
        this.currentFacility = facility
      },
      updateFacilityTask(task) {
        let cb = () => this.updateTasksHash({task: task})
        this.taskUpdated({facilityId: task.facilityId, projectId: task.projectId, cb}).then((facility) => this.currentFacility = facility)
        this.setTaskForManager({key: 'task', value: null})
      },
      updateFacilityIssue(issue) {
        let cb = () => this.updateIssuesHash({issue: issue})
        this.taskUpdated({facilityId: issue.facilityId, projectId: issue.projectId, cb}).then((facility) => this.currentFacility = facility)
        this.setTaskForManager({key: 'issue', value: null})
      },
      createdFacilityNote(note) {
        this.currentFacility.notes.unshift(note)
        this.setTaskForManager({key: 'note', value: null})
      },
      updatedFacilityNote(note) {
        let index = this.currentFacility.notes.findIndex(n => n.id == note.id)
        if (index > -1) Vue.set(this.currentFacility.notes, index, note)
        this.setTaskForManager({key: 'note', value: null})
      },
      goBackFromEdits() {
        this.setTaskForManager({key: 'task', value: null})
        this.setTaskForManager({key: 'issue', value: null})
        this.setTaskForManager({key: 'note', value: null})
      }
    },
    watch: {
      currentFacility: {
        handler(value, previous) {
          if (_.isEmpty(value) || value.id !== previous.id) {
            this.goBackFromEdits()
          }
        }, deep: true
      },
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

<style lang="scss">
  #facility_view {
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
    .facility-forms-tab,
    .facility-show-tab {
      max-height: calc(100vh - 94px);
      height: calc(100vh - 94px);
      overflow-y: auto;
    }
    .fac-manager-sidebar {
      cursor: pointer;
      font-weight: 400 !important;
    }
    .default-background {
      background-color: #ededed;
      height: calc(100vh - 130px);
      max-height: calc(100vh - 130px);
      position: relative;
      border-radius: 4px;
      z-index: 1;
    }
    .centeredDiv {
      position: absolute;
      box-shadow: 0 10px 20px rgba(56,56, 56,0.19), 0 6px 6px rgba(56,56,56,0.23);
      border: 1px solid #383838;
      border-radius: 4px;
      padding: 10px;
      top: 50%;
      left: 50%;
      margin-right: -50%;
      transform: translate(-50%, -50%);
    }
    h6.fac-manager-sidebar {
      padding: 0 8px;
    }
    .fac-manager-sidebar:hover {
      cursor: pointer;
      font-weight: 900 !important;
      background-color: rgba(91, 192, 222, 0.3);
    }
    .expandable {
      &.active {
        h6 {
          background-color: rgba(211, 211, 211, 10%);
        }
      }
    }
    .expandable {
      &.active,
      &:hover {
        h5, h6 {
          font-weight: 900 !important;
        }
      }
    }
  }
</style>
