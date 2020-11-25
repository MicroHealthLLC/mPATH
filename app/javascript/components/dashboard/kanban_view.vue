<template>
  <div id="kanban-view">
    <div class="row">
      <div class="col-md-2 facility-groups-tab" :class="{'col-md-4': expandFilter, 'col-md-2': !expandFilter}">
        <custom-tabs :current-tab="currentTab" :tabs="tabs" @on-change-tab="onChangeTab" class="mt-4" badge-margin="4px" />

        <div class="row">
          <div class="col d-flex">
            <facility-sidebar
              class="facilitySidebar"
              :current-facility-group="currentFacilityGroup"
              :expanded="expanded"
              :current-facility="currentFacility"
              @on-expand-facility-group="expandFacilityGroup"
              @on-expand-facility="showFacility"
            ></facility-sidebar>

            <div v-if="expandFilter" class="mt-4">
              <div v-if="currentTab === 'tasks'">
                <div class="d-flex align-item-center justify-content-between mx-2">
                  <div class="simple-select w-100">
                    <multiselect
                      v-model="C_taskTypeFilter"
                      track-by="name"
                      label="name"
                      placeholder="Filter by Task Category"
                      :options="taskTypes"
                      :searchable="false"
                      :multiple="true"
                      select-label="Select"
                      deselect-label="Remove"
                      >
                      <template slot="singleLabel" slot-scope="{option}">
                        <div class="d-flex">
                          <span class='select__tag-name'>{{option.name}}</span>
                        </div>
                      </template>
                    </multiselect>
                  </div>
                </div>
                <div class="mx-2 mb-3 font-sm">
                  <div class="simple-select w-50">
                    <multiselect
                      v-model="viewList"
                      :options="listOptions"
                      :searchable="false"
                      :close-on-select="false"
                      :show-labels="false"
                      placeholder="Filter by Task Status"
                      >
                      <template slot="singleLabel">
                        <div class="d-flex">
                          <span class='select__tag-name'>{{viewList}}</span>
                        </div>
                      </template>
                    </multiselect>
                  </div>
                  <div class="form-check my-1 mt-3">
                    <label class="form-check-label">
                      <input type="checkbox" class="form-check-input" v-model="C_myTasks"><span><i class="fas fa-user mr-1"></i></span>My Tasks
                    </label>
                  </div>
                  <div class="form-check my-1">
                    <label v-if="viewPermit('watch_view', 'read')" class="form-check-label">
                      <input type="checkbox" class="form-check-input" v-model="C_onWatchTasks"><span><i class="fas fa-eye mr-1"></i></span>On Watch
                    </label>
                  </div>
                  <div class="form-check my-4 pl-0">
                    <label class="form-check-label text-primary">
                     <h5> Total: {{filteredTasks.length}}</h5>
                    </label>
                  </div>
                </div>
              </div>

              <div v-if="currentTab === 'issues'">
                <div class="d-flex align-item-center justify-content-between mx-2">
                  <div class="simple-select w-100">
                    <multiselect
                      v-model="C_issueTypeFilter"
                      track-by="name"
                      label="name"
                      placeholder="Filter by Issue Type"
                      :options="issueTypes"
                      :searchable="false"
                      :multiple="true"
                      select-label="Select"
                      deselect-label="Remove"
                      >
                      <template slot="singleLabel" slot-scope="{option}">
                        <div class="d-flex">
                          <span class='select__tag-name'>{{option.name}}</span>
                        </div>
                      </template>
                    </multiselect>

                    <multiselect
                      v-model="C_issueSeverityFilter"
                      track-by="name"
                      label="name"
                      placeholder="Filter by Issue Severity"
                      :options="issueSeverities"
                      :searchable="false"
                      :multiple="true"
                      select-label="Select"
                      deselect-label="Remove"
                      >
                      <template slot="singleLabel" slot-scope="{option}">
                        <div class="d-flex">
                          <span class='select__tag-name'>{{option.name}}</span>
                        </div>
                      </template>
                    </multiselect>
                  </div>
                </div>
                <div class="mx-2 mb-3 font-sm">
                  <div class="simple-select w-50">
                    <multiselect
                      v-model="viewList"
                      :options="listOptions"
                      :searchable="false"
                      :close-on-select="false"
                      :show-labels="false"
                      placeholder="Filter by Issue Status"
                      >
                      <template slot="singleLabel">
                        <div class="d-flex">
                          <span class='select__tag-name'>{{viewList}}</span>
                        </div>
                      </template>
                    </multiselect>
                  </div>

                  <div class="form-check my-1 mt-3">
                    <label class="form-check-label">
                      <input type="checkbox" class="form-check-input" v-model="C_myIssues"><span><i class="fas fa-user mr-1"></i></span>My Issues
                    </label>
                  </div>
                  <div class="form-check my-1">
                    <label v-if="viewPermit('watch_view', 'read')" class="form-check-label">
                      <input type="checkbox" class="form-check-input" v-model="C_onWatchIssues"><span><i class="fas fa-eye mr-1"></i></span>On Watch
                    </label>
                  </div>
                  <div class="form-check my-4 pl-0">
                    <label class="form-check-label text-primary">
                      <h5>Total: {{filteredIssues.length}}</h5>
                    </label>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="kanban-tab bt-light" :class="{'col-md-8': expandFilter, 'col-md-10': !expandFilter}">
        <div v-if="'id' in currentFacilityGroup">
          <span class="clickable" @click.prevent="expandFilter=!expandFilter">
            <span v-show="!expandFilter" class="expandBtn">
              <i class="fa fa-chevron-right" aria-hidden="true"></i>
            </span>
            <span v-show="expandFilter" class="expandBtn">
              <i class="fa fa-chevron-left" aria-hidden="true"></i>
            </span>
          </span>
        </div>

        <div class="mt-4">
          <div v-if="'id' in currentFacility">
            <kanban
              :stages="C_kanban.stages"
              :kanban-type="currentTab"
              :cards="C_kanban.cards"
              @on-add-new="handleAddNew"
            ></kanban>
          </div>
          <div v-else class="center-section text-center">
            <i class="fa fa-tasks font-lg text-center" style="font-size:1.8rem"></i>
            <p>View, Edit, filter Tasks/issues in kanban mode.</p>
          </div>
        </div>
      </div>
    </div>

    <sweet-modal
      class="new_form_modal"
      ref="newFormModal"
      :hide-close-button="true"
      :blocking="true"
      >
      <div v-if="('id' in currentFacility) && fixedStageId" class="w-100">
        <task-form
          v-if="currentTab === 'tasks'"
          :facility="currentFacility"
          :fixed-stage="fixedStageId"
          @on-close-form="onCloseForm"
          @task-created="handleNewTask"
          class="form-inside-modal"
        ></task-form>

        <issue-form
          v-if="currentTab === 'issues'"
          :facility="currentFacility"
          :fixed-stage="fixedStageId"
          @issue-created="handleNewIssue"
          @on-close-form="onCloseForm"
          class="form-inside-modal"
        ></issue-form>
      </div>
    </sweet-modal>
  </div>
</template>

<script>
  import Kanban from './../shared/kanban'
  import CustomTabs from './../shared/custom-tabs'
  import FacilitySidebar from './facilities/facility_sidebar'
  import {mapGetters, mapMutations, mapActions} from 'vuex'
  import IssueForm from "./issues/issue_form"
  import TaskForm from "./tasks/task_form"
  import {SweetModal} from 'sweet-modal-vue'

  export default {
    name: 'KanbanView',
    components: {Kanban, CustomTabs, FacilitySidebar, IssueForm, TaskForm, SweetModal},
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
        fixedStageId: null,
        viewList: 'active',
        listOptions: ['active','all', 'completed'],
        currentFacility: {},
        currentFacilityGroup: {},
        expandFilter: false
      }
    },
    mounted() {
      // make the first facility_group expanded
      if (this.filteredFacilityGroups.length) this.expandFacilityGroup(this.filteredFacilityGroups[0])
    },
    methods: {
      ...mapMutations([
        'setMyActionsFilter',
        'setOnWatchFilter',
        'setIssueSeverityFilter',
        'setIssueTypeFilter',
        'setTaskTypeFilter',
        'updateTasksHash',
        'updateIssuesHash'
      ]),
      ...mapActions([
        'taskUpdated'
      ]),
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
      handleAddNew(stage) {
        this.fixedStageId = stage.id
        this.$refs.newFormModal && this.$refs.newFormModal.open()
      },
      onCloseForm() {
        this.fixedStageId = null
        this.$refs.newFormModal && this.$refs.newFormModal.close()
      },
      handleNewTask(task) {
        let cb = () => this.updateTasksHash({task: task})
        this.taskUpdated({facilityId: task.facilityId, projectId: task.projectId, cb}).then((facility) => this.currentFacility = facility)
        this.onCloseForm()
      },
      handleNewIssue(issue) {
        let cb = () => this.updateIssuesHash({issue: issue})
        this.taskUpdated({facilityId: issue.facilityId, projectId: issue.projectId, cb}).then((facility) => this.currentFacility = facility)
        this.onCloseForm()
      },
    },
    computed: {
      ...mapGetters([
        'filteredFacilityGroups',
        'taskStages',
        'issueStages',
        'taskTypeFilter',
        'taskStageFilter',
        'issueStageFilter',
        'myActionsFilter',
        'onWatchFilter',
        'issueTypeFilter',
        'issueSeverityFilter',
        'viewPermit',
        'facilityGroupFacilities',
        'taskTypes',
        'issueTypes',
        'issueSeverities'
      ]),
      filteredTasks() {
        let typeIds = _.map(this.C_taskTypeFilter, 'id')
        let stageIds = _.map(this.taskStageFilter, 'id')
        return _.filter(this.currentFacility.tasks, (task) => {
          let valid = Boolean(task && task.hasOwnProperty('progress'))
          if (typeIds.length > 0) valid = valid && typeIds.includes(task.taskTypeId)
          if (stageIds.length > 0) valid = valid && stageIds.includes(task.taskStageId)
          if (this.C_myTasks || this.taskUserFilter) {
            let userIds = [..._.map(task.checklists, 'userId'), ...task.userIds]
            if (this.C_myTasks) valid = valid && userIds.includes(this.$currentUser.id)
            if (this.taskUserFilter && this.taskUserFilter.length > 0) valid = valid && userIds.some(u => _.map(this.taskUserFilter, 'id').indexOf(u) !== -1)
          }
          if (this.C_onWatchTasks) {
            valid  = valid && task.watched
          }
          switch (this.viewList) {
            case "active": {
              valid = valid && task.progress < 100
              break
            }
            case "completed": {
              valid = valid && task.progress == 100
              break
            }
            default: {
              break
            }
          }
          return valid
        })
      },
      C_myTasks: {
        get() {
          return _.map(this.myActionsFilter, 'value').includes('tasks')
        },
        set(value) {
          if (value) this.setMyActionsFilter([...this.myActionsFilter, {name: "My Tasks", value: "tasks"}])
          else this.setMyActionsFilter(this.myActionsFilter.filter(f => f.value !== "tasks"))
        }
      },
      C_taskTypeFilter: {
        get() {
          return this.taskTypeFilter
        },
        set(value) {
          this.setTaskTypeFilter(value)
        }
      },
      C_onWatchTasks: {
        get() {
          return _.map(this.onWatchFilter, 'value').includes('tasks')
        },
        set(value) {
          if (value) this.setOnWatchFilter([...this.onWatchFilter, {name: "On Watch Tasks", value: "tasks"}])
          else this.setOnWatchFilter(this.onWatchFilter.filter(f => f.value !== "tasks"))
        }
      },
      filteredIssues() {
        let typeIds = _.map(this.C_issueTypeFilter, 'id')
        let severityIds = _.map(this.C_issueSeverityFilter, 'id')
        let stageIds = _.map(this.issueStageFilter, 'id')
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
          if (stageIds.length > 0) valid = valid && stageIds.includes(issue.issueStageId)
          if (severityIds.length > 0) valid = valid && severityIds.includes(issue.issueSeverityId)
          switch (this.viewList) {
            case "active": {
              valid = valid && issue.progress < 100
              break
            }
            case "completed": {
              valid = valid && issue.progress == 100
              break
            }
            default: {
              break
            }
          }
          return valid;
        })
      },
      C_issueTypeFilter: {
        get() {
          return this.issueTypeFilter
        },
        set(value) {
          this.setIssueTypeFilter(value)
        }
      },
      C_issueSeverityFilter: {
        get() {
          return this.issueSeverityFilter
        },
        set(value) {
          this.setIssueSeverityFilter(value)
        }
      },
      C_myIssues: {
        get() {
          return _.map(this.myActionsFilter, 'value').includes('issues')
        },
        set(value) {
          if (value) this.setMyActionsFilter([...this.myActionsFilter, {name: "My Issues", value: "issues"}])
          else this.setMyActionsFilter(this.myActionsFilter.filter(f => f.value !== "issues"))
        }
      },
      C_onWatchIssues: {
        get() {
          return _.map(this.onWatchFilter, 'value').includes('issues')
        },
        set(value) {
          if (value) this.setOnWatchFilter([...this.onWatchFilter, {name: "On Watch Issues", value: "issues"}])
          else this.setOnWatchFilter(this.onWatchFilter.filter(f => f.value !== "issues"))
        }
      },
      filterTaskStages() {
        let stageIds = _.map(this.taskStageFilter, 'id')
        return _.filter(this.taskStages, s => stageIds && stageIds.length ? stageIds.includes(s.id) : true)
      },
      filterIssueStages() {
        let stageIds = _.map(this.issueStageFilter, 'id')
        return _.filter(this.issueStages, s => stageIds && stageIds.length ? stageIds.includes(s.id) : true)
      },
      C_kanban() {
        return {
          stages: this.currentTab == 'tasks' ? this.filterTaskStages : this.filterIssueStages,
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
          } else {
            this.currentFacilityGroup = value.find(f => f.id === this.currentFacilityGroup.id)
            this.currentFacility = this.facilityGroupFacilities(this.currentFacilityGroup).find(f => f.id == this.currentFacility.id)
          }
        }, deep: true
      },
      currentFacilityGroup: {
        handler(value) {
          if (!('id' in value)) this.expandFilter = false
        }
      }, deep: true
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
    .center-section {
      box-shadow: 0 10px 20px rgba(56,56, 56,0.19), 0 6px 6px rgba(56,56,56,0.23);
      border: 1px solid #383838;
      border-radius: 4px;
      padding: 10px;
      width: 25rem;
      margin: 10rem auto;
    }
  }
  .row [class*='col-'] {
    transition: .2s ease-in-out;
  }
  .facilitySidebar {
    width: 200px;
    max-width: 200px;
    min-width: 200px;
  }
  .expandBtn {
    position: absolute;
    top: 50px;
    left: -12px;
    padding: 5px;
    border-radius: 50%;
    height: 25px;
    color: #fff;
    background-color: #17a2b8;
    font-size: 18px;
    width: 25px;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .simple-select /deep/ .multiselect {
    width: 230px;
  }
  .new_form_modal.sweet-modal-overlay {
    z-index: 10000001;
  }
  .new_form_modal.sweet-modal-overlay /deep/ .sweet-modal {
    min-width: 40vw;
    max-height: 80vh;
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
