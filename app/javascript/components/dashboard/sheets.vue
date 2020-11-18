<template>
  <div id="sheets_view">
    <div class="row">
      <div class="col-md-2 facility-groups-tab">
        <h4 class="mt-4 ml-4 text-info">Facility Sheets</h4>
        <div class="my-4 ml-2 scrollBar">
          <div v-for="group in filteredFacilityGroups" class="my-3">
            <div class="d-flex expandable" @click="expandFacilityGroup(group)" :class="{'active': group.id == currentFacilityGroup.id}">
              <span v-show="expanded.id != group.id">
                <i class="fa fa-angle-right font-sm mr-2 cursor"></i>
              </span>
              <span v-show="expanded.id == group.id">
               <i class="fa fa-angle-down font-md mr-2 cursor"></i>
              </span>
              <h5 class="cursor">{{group.name}}</h5>
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
      <div class="col-md-10 facility-show-tab pr-3" style="background-color: solid #ededed 15px">
        <div class="mt-3">
          <facility-sheets
            v-if="C_showFacilityTab"
            from="manager_view"
            :facility="currentFacility"
            :facility-group="currentFacilityGroup"
          ></facility-sheets>
          <facility-rollup v-else></facility-rollup>
        </div>

        <sweet-modal
          class="form_modal"
          ref="formModals"
          :hide-close-button="true"
          :blocking="true"
          >
          <div v-if="managerView.task || managerView.issue" class="w-100">
            <task-form
              v-if="managerView.task"
              :facility="currentFacility"
              :task="managerView.task"
              title="Edit Task"
              @task-created="updateFacilityTask"
              @task-updated="updateFacilityTask"
              class="form-inside-modal"
            ></task-form>
            <issue-form
              v-if="managerView.issue"
              :facility="currentFacility"
              :issue="managerView.issue"
              @issue-updated="updateFacilityIssue"
              @issue-created="updateFacilityIssue"
              class="form-inside-modal"
            ></issue-form>
          </div>
        </sweet-modal>
      </div>
    </div>
  </div>
</template>

<script>
  import {mapGetters, mapMutations, mapActions} from "vuex"
  import FacilitySheets from './facilities/facility_sheets'
  import FacilityRollup from './facilities/facility_rollup'
  import TaskForm from "./tasks/task_form"
  import IssueForm from "./issues/issue_form"
  import {SweetModal} from 'sweet-modal-vue'

  export default {
    name: "ProjectSheets",
    components: {
      FacilitySheets,
      FacilityRollup,
      TaskForm,
      IssueForm,
      SweetModal
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
        var cb = () => this.updateTasksHash({task: task})
        this.taskUpdated({facilityId: task.facilityId, projectId: task.projectId, cb}).then((facility) => this.currentFacility = facility)
        this.setTaskForManager({key: 'task', value: null})
      },
      updateFacilityIssue(issue) {
        var cb = () => this.updateIssuesHash({issue: issue})
        this.taskUpdated({facilityId: issue.facilityId, projectId: issue.projectId, cb}).then((facility) => this.currentFacility = facility)
        this.setTaskForManager({key: 'issue', value: null})
      },
      createdFacilityNote(note) {
        this.currentFacility.notes.unshift(note)
        this.setTaskForManager({key: 'note', value: null})
      },
      updatedFacilityNote(note) {
        var index = this.currentFacility.notes.findIndex(n => n.id == note.id)
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
        handler(value) {
          if (_.isEmpty(value)) {
            this.goBackFromEdits()
          }
        }, deep: true
      },
      managerView: {
        handler(value) {
          if (value.task || value.issue) {
            this.$refs.formModals && this.$refs.formModals.open()
          } else {
            this.$refs.formModals && this.$refs.formModals.close()
          }
        }, deep: true
      }
    }
  }
</script>

<style lang="scss">
  #sheets_view {
    overflow: hidden;
    padding: 0 10px;
    .cursor {
      cursor: pointer;
    }
    .facility-groups-tab {
      background: #ededed;
      max-height: calc(100vh - 94px);
      height: calc(100vh - 94px);
      overflow-y: scroll;
    }
    .facility-forms-tab,
    .facility-show-tab {
      max-height: calc(100vh - 94px);
      height: calc(100vh - 94px);
      overflow-y: scroll;
      position: relative;
    }
    .fac-manager-sidebar {
      cursor: pointer;
      font-weight: 400 !important;
    }
    .default-background {
      background-color: #ededed;
      height: 100%;
      position: relative;
      border-radius: 4px;
      z-index: 1;
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
  }
</style>

