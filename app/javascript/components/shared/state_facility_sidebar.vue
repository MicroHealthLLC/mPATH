<template>
  <div id="facility_sidebar">
    <div class="row">
      <div class="col-md-2 facility-groups-tab">
        <facility-sidebar
          :current-facility-group="currentFacilityGroup"
          :expanded="expanded"
          :current-facility="currentFacility"
          @on-expand-facility-group="expandFacilityGroup"
          @on-expand-facility="showFacility"
        ></facility-sidebar>
      </div>
       <div class="col-md-4 facility-show-tab" v-if="isFacilityManagerView">
        <div class="my-3">
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
        <div class="col-md-6 facility-forms-tab" v-if="isFacilityManagerView">
        <div class="default-background">
          <div class="bg-white mt-4">
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

            <risk-form
              v-else-if="managerView.risk"
              from="manager_view"
              :facility="currentFacility"
              :risk="managerView.risk"
              @risk-created="updateFacilityRisk"
              @risk-updated="updateFacilityRisk"
            ></risk-form>

            <div v-else class="center-section text-center">
              <i class="fa fa-tasks font-lg text-center" style="font-size:1.8rem"></i>
              <p>View, Add or Edit Tasks, Issues, Risks and Notes here.</p>
            </div>
          </div>
        </div>
      </div>

       <div class="col-md-10 facility-show-tab pr-3" data-cy="sheets_view" style="background-color: solid #ededed 15px" v-else >
        <div class="mt-3">
          <facility-sheets
            v-if="C_showFacilityTab"
            from="manager_view"
            :facility="currentFacility"
            :facility-group="currentFacilityGroup"
          ></facility-sheets>
          <facility-rollup v-else></facility-rollup>
        </div>

      </div>
    </div>
  </div>
</template>

<script>
  import {mapGetters, mapMutations, mapActions} from "vuex"
  import {SweetModal} from 'sweet-modal-vue'
  import FacilityShow from './../dashboard/facilities/facility_show'
  import FacilitySheets from './../dashboard/facilities/facility_sheets'
  import FacilityRollup from './../dashboard/facilities/facility_rollup'
  import FacilitySidebar from './../dashboard/facilities/facility_sidebar'
  import TaskForm from "./../dashboard/tasks/task_form"
  import IssueForm from "./../dashboard/issues/issue_form"
  import NotesForm from "./../dashboard/notes/notes_form"
  import RiskForm from "./../dashboard/risks/risk_form"

  export default {
    name: "StateFacilitySidebar",
     components: {
     FacilitySidebar,
     FacilityRollup,
     FacilitySheets,
     FacilityShow,
     SweetModal,
     TaskForm,
     IssueForm,
     NotesForm,
     RiskForm
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
      },
      isFacilityManagerView() {
        return this.$route.name === 'FacilityManagerView'
      },
    },
    methods: {
      ...mapMutations([
        'updateTasksHash',
        'updateIssuesHash',
        'updateRisksHash',
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
      updateFacilityRisk(risk) {
        let cb = () => this.updateRisksHash({risk: risk})
        this.taskUpdated({facilityId: risk.facilityId, projectId: risk.projectId, cb}).then((facility) => this.currentFacility = facility)
        this.setTaskForManager({key: 'risk', value: null})
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
          } else {
            let group = value.find(f => f.id === this.currentFacilityGroup.id)
            if (group) {
              this.currentFacilityGroup = group
              let facility = this.facilityGroupFacilities(this.currentFacilityGroup).find(f => f.id == this.currentFacility.id)
              if (facility) {
                this.currentFacility = facility
              } else {
                this.currentFacility = {}
              }
            }
            else {
              this.currentFacilityGroup = {}
              this.currentFacility = {}
              this.expanded.id = ''
            }
          }
        }, deep: true
      }
    }
  }
</script>

<style lang="scss" scoped>
  #facility_sidebar {
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
      box-shadow: 0 2.5px 2.5px rgba(0,0,0,0.19), 0 3px 3px rgba(0,0,0,0.23);
    }

    .default-background {
      background-color: #ededed;
      box-shadow: 0 2.5px 2.5px rgba(0,0,0,0.19), 0 3px 3px rgba(0,0,0,0.23);
      height: calc(100vh - 130px);
      max-height: calc(100vh - 130px);
      position: relative;
      border-radius: 4px;
      z-index: 1;
    }
    .center-section {
      position: absolute;
      box-shadow: 0.5px 0.5px 5px 5px rgba(0,0,0,0.19), 0 3px 3px rgba(0,0,0,0.23);
      border-radius: 2px;
      padding: 10px;
      top: 50%;
      left: 50%;
      margin-right: -50%;
      transform: translate(-50%, -50%);
    }
  }
  .form_modal.sweet-modal-overlay {
    z-index: 10000001;
  }
  .form_modal.sweet-modal-overlay /deep/ .sweet-modal {
    min-width: 80vw;
    max-height: 90vh;
    background-color: #ededed;
    .sweet-content {
      padding-top: 30px;
      text-align: unset;
    }
    .modal_close_btn {
      display: flex;
      position: absolute;
      top: 20px;
      right: 30px;
      font-size: 20px;
      cursor: pointer;
    }
    .form-inside-modal {
      form {
        position: inherit !important;
      }
    }
  }
</style>
