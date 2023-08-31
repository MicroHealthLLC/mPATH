import http from "./../common/http";
import * as Moment from "moment";
import { extendMoment } from "moment-range";
const moment = extendMoment(Moment);
import createPersistedState from "vuex-persistedstate";
import * as Cookies from "js-cookie";
import exampleModule from "./modules/example-module-store";
import settingsStore from "./modules/settings-store";
import programStore from "./modules/program-store";
import contractStore from "./modules/contract-store";
import projectStore from "./modules/project-store";
// import taskStore from "./modules/task-store";
// import issueStore from "./modules/issue-store";
import riskStore from "./modules/risk-store";
import notesStore from "./modules/notes-store";
import lessonStore from "./modules/lesson-store";
import effortStore from './modules/effort-store'
import portfolioModule from "./modules/portfolio-store";
import { API_BASE_PATH } from "./../mixins/utils";

// utility function
const getSimpleDate = (date) => {
  let dt = [undefined, null, "N/A"].includes(date)
    ? new Date()
    : new Date(date);
  let y = dt.getFullYear();
  let m = dt.getMonth();
  let d = dt.getDate();
  return new Date(y, m, d, 0, 0, 0).getTime();
};

export default new Vuex.Store({
  modules: {
    exampleModule,
    programStore,
    contractStore,
    projectStore,
    effortStore,
    // taskStore,
    settingsStore,
    // issueStore,
    riskStore,
    lessonStore,
    notesStore,
    portfolioModule,
  },
  state: {
    advancedFilter: [],
    myAssignmentsFilter: [],
    contentLoaded: false,
    projectsLoaded: false,
    showProjectStats: 0,
    showContractStats: false,
    showVehicleStats: false,
    toggleRACI: true,
    expandedGroup: "", 
    showAllEventsToggle: false,
    showAdvancedFilter: false,
    currentProject: null,
    lastCalendarFocus: "",
    mapLoading: true,
    sideLoading: true,
    projects: new Array(),
    tableData: new Array(),
    facilities: new Array(),
    contracts: new Array(),
    vehicles: new Array(),
    facilityGroups: new Array(),
    statuses: new Array(),
    advancedFilterOptions: new Array(),
    taskIssueOverdueFilter: new Array(),

    projectGroupFilter: null,

    taskTypes: new Array(),
    taskTypeFilter: null,
    taskStages: new Array(),
    taskStageFilter: null,
    taskProgressFilter: null,

    riskStages: new Array(),
    riskStageFilter: new Array(),
    riskApproachFilter: null,
    riskApproachFilterOptions: new Array(),
    riskProbabilityOptions: new Array(),
    riskPriorityLevelFilter: new Array(),
    riskImpactLevelOptions: new Array(),

    riskDispositionStatus: new Array(),
    riskDispositionDuration: new Array(),

    issueStages: new Array(),
    issueTypes: new Array(),
    issueSeverities: new Array(),
    issueTypeFilter: null,
    issueSeverityFilter: null,
    issueStageFilter: null,
    issueProgressFilter: null,

    // Datatable items per page filters
    tasksPerPageFilter: null,
    risksPerPageFilter: null,
    lessonsPerPageFilter: null,
    issuesPerPageFilter: null,
    membersPerPageFilter: null,

    currentProject: null,
    projectUsers: new Array(),
    accountableUsers: new Array(),
    consultedUsers: new Array(),
    informedUsers: new Array(),

    currentFacility: null,
    currentFacilityGroup: null,
    mapFilters: new Array(),
    projectStatusFilter: null,
    calendarViewFilter: null,
    facilityGroupFilter: null,
    facilityNameFilter: null,
    facilityProgressFilter: null,
    programProgressFilter: null,
    facilityDueDateFilter: null,
    noteDateFilter: null,
    taskIssueDueDateFilter: null,
    // This filter is used for progress range number e.g. 1-19
    taskIssueProgressFilter: null,
    // This filter is used to check status e.g. active or completed
    taskIssueProgressStatusFilter: new Array(),
    contactInfoForm: {
      poc: '',
      phoneNo: '',
      email: '',
     },
    progressFilter: {
      facility: {
        min: "",
        max: "",
        error: "",
      },
      program: {
        min: "",
        max: "",
        error: "",
      },
      task: {
        min: "",
        max: "",
        error: "",
      },
      issue: {
        min: "",
        max: "",
        error: "",
      },
      taskIssue: {
        min: "",
        max: "",
        error: "",
      },
    },
    taskIssueUserFilter: new Array(),
    myActionsFilter: new Array(),
    onWatchFilter: new Array(),
    managerView: {
      task: null,
      issue: null,
      note: null,
      risk: null,
      lesson: null,
    },
    mapZoomFilter: new Array(),
    unfilteredFacilities: new Array(),
    previousRoute: "",

    newSession: true,
  },

  mutations: {
    setTaskIssueUserFilter: (state, filter) =>
      (state.taskIssueUserFilter = filter),
    setProjectGroupFilter: (state, filter) =>
      (state.projectGroupFilter = filter),
    setTaskIssueProgressStatusFilter: (state, filter) =>
      (state.taskIssueProgressStatusFilter = filter),
    setTaskIssueProgressFilter: (state, filter) =>
      (state.taskIssueProgressFilter = filter),
    setMyAssignmentsFilter: (state, filter) =>
      (state.myAssignmentsFilter = filter),
    setAdvancedFilter: (state, selectedOptions) => {
      state.advancedFilter = selectedOptions;
      // var _taskIssueOverdueFilter = []
      // var _onWatchFilter = []
      // var _myActionsFilter = []
      // var _taskIssueProgressStatusFilter = []

      // for(var option of selectedOptions){
      //   if(option.id == "overdue" || option.id == 'notOverdue'){
      //     _taskIssueOverdueFilter.push(option)
      //   }else if(option.id == "active" || option.id == 'completed'){
      //     _taskIssueProgressStatusFilter.push(option)
      //   }else if(option.id == "myAction"){
      //     _myActionsFilter.push({id: 'myAction', name: 'My Assignments', value: 'myAction'})

      //   }else if(option.id == "onWatch"){
      //     // TODO: make just one  instead of 2. for now keeping two nearly will not break other features.
      //     _onWatchFilter.push({id: 'onWatch', name: 'On Watch', value: 'onWatch'})

      //   }else if(option.id == 'notOnWatch'){
      //     _onWatchFilter.push({id: 'notOnWatch', name: 'Not On Watch', value: 'notOnWatch'})

      //   }else if(option.id == "notMyAction"){
      //      _myActionsFilter.push({id: 'notMyAction', name: 'Not My Assignments', value: 'notMyAction'})
      //   }
      // }

      // state.taskIssueOverdueFilter = _taskIssueOverdueFilter
      // state.onWatchFilter = _onWatchFilter
      // state.myActionsFilter = _myActionsFilter
      // state.taskIssueProgressStatusFilter = _taskIssueProgressStatusFilter
    },
    setContentLoaded: (state, loading) => (state.contentLoaded = loading),
    SET_EXPANDED_GROUP: (state, value) => (state.expandedGroup = value),
    setProjectsLoaded: (state, loading) => (state.projectsLoaded = loading),
    setToggleRACI: (state, raci) => (state.toggleRACI = raci),
    setShowAllEventsToggle: (state, showAll) =>
      (state.showAllEventsToggle = showAll),
    setShowProjectStats: (state, showStats) =>
    (state.showProjectStats = showStats),
    setShowContractStats: (state, showStats) =>
    (state.showContractStats = showStats),
    setShowVehicleStats: (state, showStats) =>
    (state.showVehicleStats = showStats),
    setLastFocusFilter: (state, lastFocus) =>
      (state.lastCalendarFocus = lastFocus),
    setMapLoading: (state, loading) => (state.mapLoading = loading),
    setSideLoading: (state, loading) => (state.sideLoading = loading),
    setProjects: (state, projects) => (state.projects = projects),
    setFacilities: (state, facilities) => (state.facilities = facilities),
    setContracts: (state, contracts) => (state.contracts = contracts),
    setVehicles: (state, vehicles) => (state.vehicles = vehicles),
    setTableData: (state, tableData) => (state.tableData = tableData),
    setUnfilteredFacilities: (state, facilities) =>
      (state.unfilteredFacilities = facilities),
    setFacilityGroups: (state, facilityGroups) =>
      (state.facilityGroups = facilityGroups),
    setStatuses: (state, statuses) => (state.statuses = statuses),

    setTaskTypes: (state, taskTypes) => (state.taskTypes = taskTypes),
    setTaskStages: (state, taskStages) => (state.taskStages = taskStages),
    setTaskTypeFilter: (state, filter) => (state.taskTypeFilter = filter),
    setTaskStageFilter: (state, filter) => (state.taskStageFilter = filter),
    setTaskProgressFilter: (state, filter) =>
      (state.taskProgressFilter = filter),

    setRiskStages: (state, riskStages) => (state.riskStages = riskStages),
    setRiskStageFilter: (state, filter) => (state.riskStageFilter = filter),
    setRiskApproachFilter: (state, filter) =>
      (state.riskApproachFilter = filter),
    setRiskPriorityLevelFilter: (state, filter) =>
      (state.riskPriorityLevelFilter = filter),
    setRiskProbabilityOptions: (state, riskProbabilityOptions) =>
      (state.riskProbabilityOptions = riskProbabilityOptions),
    setRiskImpactLevelOptions: (state, riskImpactLevelOptions) =>
      (state.riskImpactLevelOptions = riskImpactLevelOptions),

    setRiskDispositionDuration: (state, riskDispositionDuration) =>
      (state.riskDispositionDuration = riskDispositionDuration),
    setRiskDispositionStatus: (state, riskDispositionStatus) =>
      (state.riskDispositionStatus = riskDispositionStatus),

    setIssueStages: (state, issueStages) => (state.issueStages = issueStages),
    setIssueTypes: (state, issueTypes) => (state.issueTypes = issueTypes),
    setIssueSeverities: (state, issueSeverities) =>
      (state.issueSeverities = issueSeverities),
    setIssueTypeFilter: (state, filter) => (state.issueTypeFilter = filter),
    setIssueStageFilter: (state, filter) => (state.issueStageFilter = filter),
    setIssueSeverityFilter: (state, filter) =>
      (state.issueSeverityFilter = filter),
    setIssueProgressFilter: (state, filter) =>
      (state.issueProgressFilter = filter),

    setMembersPerPageFilter: (state, filter) =>
      (state.membersPerPageFilter = filter),
    setTasksPerPageFilter: (state, filter) =>
      (state.tasksPerPageFilter = filter),
    setIssuesPerPageFilter: (state, filter) =>
      (state.issuesPerPageFilter = filter),
    setRisksPerPageFilter: (state, filter) =>
      (state.risksPerPageFilter = filter),
    setLessonsPerPageFilter: (state, filter) =>
      (state.lessonsPerPageFilter = filter),

    setCalendarViewFilter: (state, filter) =>
      (state.calendarViewFilter = filter),

    setCurrentProject: (state, project) => (state.currentProject = project),
    setProjectUsers: (state, users) => (state.projectUsers = users),
    setAccountableUsers: (state, users) => (state.accountableUsers = users),
    setConsultedUsers: (state, consulted) => (state.consultedUsers = consulted),
    setInformedUsers: (state, informed) => (state.informedUsers = informed),

    setCurrentFacility: (state, facility) => (state.currentFacility = facility),
    setCurrentFacilityGroup: (state, facilityGroup) =>
      (state.currentFacilityGroup = facilityGroup),
    setMapFilters: (state, filters) => (state.mapFilters = filters),
    updateFacilities: (state, { index, facility }) =>
      Vue.set(state.facilities, index, facility),
    updateFacilityHash: (state, facility) => {
      let index = state.facilities.findIndex((f) => f.id == facility.id);
      if (index > -1) Vue.set(state.facilities, index, facility);
    },
    updateMapFilters: (state, { key, filter, same, _k }) => {
      if (
        filter &&
        !filter.includes(null) &&
        Array.isArray(filter) &&
        filter.length > 0
      ) {
        let i = state.mapFilters.findIndex((f) => f.hasOwnProperty(key));
        if (i < 0) i = state.mapFilters.length;
        let value = { [key]: same ? filter : _.map(filter, _k || "id") };
        Vue.set(state.mapFilters, i, value);
      } else {
        state.mapFilters = _.filter(
          state.mapFilters,
          (f) => !f.hasOwnProperty(key)
        );
      }
    },
    updateTasksHash: (state, { task, action }) => {
      let facility_i = state.facilities.findIndex(
        (f) => f.id == task.facilityId
      );
      if (facility_i > -1) {
        let facility = Object.assign({}, state.facilities[facility_i]);
        let task_i = facility.tasks.findIndex((t) => t.id == task.id);
        if (action === "delete") {
          for (let t of _.flatten(_.map(state.facilities, "tasks"))) {
            _.remove(t.subTaskIds, (id) => id == t.id);
          }
          Vue.delete(facility.tasks, task_i);
        } else if (task_i > -1) {
          Vue.set(facility.tasks, task_i, task);
        } else if (task_i == -1) {
          facility.tasks.push(task);
        }
        Vue.set(state.facilities, facility_i, facility);
      }
    },
    updateContractTasks: (state, { task, action }) => {
      let contract_i = state.contracts.findIndex(
        (f) => f.projectContractId == task.projectContractId
      );
      if (contract_i > -1) {
        let contract = Object.assign({}, state.contracts[contract_i]);
        let task_i = contract.tasks.findIndex((t) => t.id == task.id);
        if (action === "delete") {
          for (let t of _.flatten(_.map(state.contracts, "tasks"))) {
            _.remove(t.subTaskIds, (id) => id == t.id);
          }
          Vue.delete(contract.tasks, task_i);
        } else if (task_i > -1) {
          Vue.set(contract.tasks, task_i, task);
        } else if (task_i == -1) {
          contract.tasks.push(task);
        }
        Vue.set(state.contracts, contract_i, contract);
      }
    },
    updateVehicleTasks: (state, { task, action }) => {
      let vehicle_i = state.vehicles.findIndex(
        (f) => f.projectContractVehicleId == task.projectContractVehicleId
      );
      if (vehicle_i > -1) {
        let vehicle = Object.assign({}, state.vehicles[vehicle_i]);
        let task_i = vehicle.tasks.findIndex((t) => t.id == task.id);
        if (action === "delete") {
          for (let t of _.flatten(_.map(state.vehicles, "tasks"))) {
            _.remove(t.subTaskIds, (id) => id == t.id);
          }
          Vue.delete(vehicle.tasks, task_i);
        } else if (task_i > -1) {
          Vue.set(vehicle.tasks, task_i, task);
        } else if (task_i == -1) {
          vehicle.tasks.push(task);
        }
        Vue.set(state.vehicles, vehicle_i, vehicle);
      }
    },
    updateContractIssues: (state, { issue, action }) => {
      let contract_i = state.contracts.findIndex(
        (f) => f.projectContractId == issue.projectContractId
      );
      if (contract_i > -1) {
        let contract = Object.assign({}, state.contracts[contract_i]);
        let issue_i = contract.issues.findIndex((t) => t.id == issue.id);
        if (action === "delete") {
          for (let t of _.flatten(_.map(state.contracts, "issues"))) {
            _.remove(t.subIssueIds, (id) => id == t.id);
          }
          Vue.delete(contract.issues, issue_i);
        } else if (issue_i > -1) {
          Vue.set(contract.issues, issue_i, issue);
        } else if (issue_i == -1) {
          contract.issues.push(issue);
        }
        Vue.set(state.contracts, contract_i, contract);
      }
    },
    updateVehicleIssues: (state, { issue, action }) => {
      let vehicle_i = state.vehicles.findIndex(
        (f) => f.projectContractVehicleId == issue.projectContractVehicleId
      );
      if (vehicle_i > -1) {
        let vehicle = Object.assign({}, state.vehicles[vehicle_i]);
        let issue_i = vehicle.issues.findIndex((t) => t.id == issue.id);
        if (action === "delete") {
          for (let t of _.flatten(_.map(state.vehicles, "issues"))) {
            _.remove(t.subIssueIds, (id) => id == t.id);
          }
          Vue.delete(vehicle.issues, issue_i);
        } else if (issue_i > -1) {
          Vue.set(vehicle.issues, issue_i, issue);
        } else if (issue_i == -1) {
          vehicle.issues.push(issue);
        }
        Vue.set(state.vehicles, vehicle_i, vehicle);
      }
    },
    updateIssuesHash: (state, { issue, action }) => {
      let facility_i = state.facilities.findIndex(
        (f) => f.id == issue.facilityId
      );
      if (facility_i > -1) {
        let facility = Object.assign({}, state.facilities[facility_i]);
        let issue_i = facility.issues.findIndex((t) => t.id == issue.id);
        if (action === "delete") {
          for (let t of _.flatten(_.map(state.facilities, "issues"))) {
            _.remove(t.subIssueIds, (id) => id == t.id);
          }
          Vue.delete(facility.issues, issue_i);
        } else if (issue_i > -1) {
          Vue.set(facility.issues, issue_i, issue);
        } else if (issue_i == -1) {
          facility.issues.push(issue);
        }
        Vue.set(state.facilities, facility_i, facility);
      }
    },

    updateRisksHash: (state, { risk, action }) => {
      let facility_i = state.facilities.findIndex(
        (f) => f.id == risk.facilityId
      );
      if (facility_i > -1) {
        let facility = Object.assign({}, state.facilities[facility_i]);
        let risk_i = facility.risks.findIndex((t) => t.id == risk.id);
        if (action === "delete") {
          for (let t of _.flatten(_.map(state.facilities, "risks"))) {
            _.remove(t.subRiskIds, (id) => id == t.id);
          }
          Vue.delete(facility.risks, risk_i);
        } else if (risk_i > -1) {
          Vue.set(facility.risks, risk_i, risk);
        } else if (risk_i == -1) {
          facility.risks.push(risk);
        }
        Vue.set(state.facilities, facility_i, facility);
      }
    },
    updateContractRisks: (state, { risk, action }) => {
      let contract_i = state.contracts.findIndex(
        (f) => f.projectContractId == risk.projectContractId
      );
      if (contract_i > -1) {
        let contract = Object.assign({}, state.contracts[contract_i]);
        let risk_i = contract.risks.findIndex((t) => t.id == risk.id);
        if (action === "delete") {
          for (let t of _.flatten(_.map(state.contracts, "risks"))) {
            _.remove(t.subRiskIds, (id) => id == t.id);
          }
          Vue.delete(contract.risks, risk_i);
        } else if (risk_i > -1) {
          Vue.set(contract.risks, risk_i, risk);
        } else if (risk_i == -1) {
          contract.risks.push(risk);
        }
        Vue.set(state.contracts, contract_i, contract);
      }
    },
    updateVehicleRisks: (state, { risk, action }) => {
      let vehicle_i = state.vehicles.findIndex(
        (f) => f.projectContractVehicleId == risk.projectContractVehicleId
      );
      if (vehicle_i > -1) {
        let vehicle = Object.assign({}, state.vehicles[vehicle_i]);
        let risk_i = vehicle.risks.findIndex((t) => t.id == risk.id);
        if (action === "delete") {
          for (let t of _.flatten(_.map(state.vehicles, "risks"))) {
            _.remove(t.subRiskIds, (id) => id == t.id);
          }
          Vue.delete(vehicle.risks, risk_i);
        } else if (risk_i > -1) {
          Vue.set(vehicle.risks, risk_i, risk);
        } else if (risk_i == -1) {
          vehicle.risks.push(risk);
        }
        Vue.set(state.vehicles, vehicle_i, vehicle);
      }
    },
    updateNotesHash: (state, { note, facilityId, action }) => {
      // console.log(JSON.stringify(note))
      let facility_i = state.facilities.findIndex((f) => f.id == facilityId);
      if (facility_i > -1) {
        let facility = Object.assign({}, state.facilities[facility_i]);
        let note_i = facility.notes.findIndex((t) => t.id == note.id);
        if (action === "delete") {
          Vue.delete(facility.notes, note_i);
        } else if (note_i > -1) {
          Vue.set(facility.notes, note_i, note);
        } else if (note_i == -1) {
          facility.notes.push(note);
        }
        Vue.set(state.facilities, facility_i, facility);
      }
    },
    setProjectStatusFilter: (state, filter) =>
      (state.projectStatusFilter = filter),
    setTaskIssueOverdueFilter: (state, filter) => {
      state.taskIssueOverdueFilter = filter;
    },

    setFacilityGroupFilter: (state, filter) =>
      (state.facilityGroupFilter = filter),
    setFacilityNameFilter: (state, filter) =>
      (state.facilityNameFilter = filter),
    setFacilityProgressFilter: (state, filter) =>
      (state.facilityProgressFilter = filter),
    setProgramProgressFilter: (state, filter) =>
      (state.programProgressFilter = filter),
    setFacilityDueDateFilter: (state, filter) =>
      (state.facilityDueDateFilter = filter),
    setNoteDateFilter: (state, filter) => (state.noteDateFilter = filter),
    setTaskIssueDueDateFilter: (state, filter) =>
      (state.taskIssueDueDateFilter = filter),

    setShowAdvancedFilter: (state, show) => (state.showAdvancedFilter = show),

    setMyActionsFilter: (state, filter) => (state.myActionsFilter = filter),
    setOnWatchFilter: (state, filter) => (state.onWatchFilter = filter),
    clearProgressFilters: (state) => {
      let filters = new Object();
      for (let key of Object.keys(state.progressFilter)) {
        filters[key] = new Object();
        for (let fil of Object.keys(state.progressFilter[key])) {
          filters[key][fil] = "";
        }
      }
      state.progressFilter = filters;
    },
    setProgressFilters: (state, { key, value }) =>
      (state.progressFilter[key] = value),
    nullifyTasksForManager: (state) =>
      (state.managerView = { task: null, issue: null, note: null, risk: null }),
    setTaskForManager: (state, { key, value }) => {
      for (let k in state.managerView) {
        state.managerView[k] = k == key ? value : null;
      }
    },
    setMapZoomFilter: (state, filteredIds) =>
      (state.mapZoomFilter = filteredIds),
    setRiskForManager: (state, { key, value }) => {
      for (let k in state.managerView) {
        state.managerView[k] = k == key ? value : null;
      }
    },
    setLessonForManager: (state, { key, value }) => {
      for (let k in state.managerView) {
        state.managerView[k] = k == key ? value : null;
      }
    },
    setContactInfoForm: (state, { key, value }) =>
    (state.contactInfoForm[key] = value),
    setMapZoomFilter: (state, filteredIds) =>
      (state.mapZoomFilter = filteredIds),
    setPreviousRoute: (state, route) => (state.previousRoute = route),
    setNewSession: (state) => (state.newSession = !state.newSession),
  },

  getters: {
    getExpandedGroup: (state) => state.expandedGroup,
    getFacilityProjectOptions: (state, getters) => {
      var options = [];
      for (let f of getters.facilities) {
        options.push({ id: f.facilityProjectId, name: f.facilityName });
      }
      return options;
    },
    getTaskIssueUserFilter: (state, getters) => {
      return state.taskIssueUserFilter;
    },
    // TODO: remove if not used anywhere
    getTaskIssueTabFilterOptions: (state, getters) => {
      var options = [
        {
          id: "active",
          name: "Not Completed",
          value: "active",
          filterCategoryId: "progressStatusFilter",
          filterCategoryName: "Progress Status",
        },
        {
          id: "completed",
          name: "Completed",
          value: "completed",
          filterCategoryId: "progressStatusFilter",
          filterCategoryName: "Progress Status",
        },
        {
          id: "overdue",
          name: "Overdue",
          value: "overdue",
          filterCategoryId: "overDueFilter",
          filterCategoryName: "Action Overdue",
        },
        // {id: 'notOverdue', name: 'On Schedule', value: "not overdue", filterCategoryId: 'overDueFilter', filterCategoryName: 'Action Overdue'},
        {
          id: "myAction",
          name: "My Assignments",
          value: "my action",
          filterCategoryId: "myActionsFilter",
          filterCategoryName: "My Assignments",
        },
        {
          id: "notMyAction",
          name: "Not My Assignments",
          value: "not my action",
          filterCategoryId: "myActionsFilter",
          filterCategoryName: "My Assignments",
        },
        {
          id: "onWatch",
          name: "On Watch",
          value: "onWatch",
          filterCategoryId: "onWatchFilter",
          filterCategoryName: "On Watch",
        },
        {
          id: "notOnWatch",
          name: "Not On Watch",
          value: "onWatch",
          filterCategoryId: "onWatchFilter",
          filterCategoryName: "On Watch",
        },
        {
          id: "onHold",
          name: "On Hold",
          value: "onHold",
          filterCategoryId: "onHoldFilter",
          filterCategoryName: "On Hold",
        },
        {
          id: "draft",
          name: "Drafts",
          value: "draft",
          filterCategoryId: "draft",
          filterCategoryName: "Drafts",
        },
      ];

      return options;
    },
    getCalendarViewFilter: (state) => state.calendarViewFilter,
    getCalendarViewFilterOptions: (state, getters) => {
      var options = [
        { id: "month", name: "Month", value: "month" },
        { id: "week", name: "Week", value: "week" },
        { id: "day", name: "Day", value: "day" },
        { id: "4day", name: "4 Days", value: "4day" },
      ];
      return options;
    },
    //For Datatables items per page display only
    getMembersPerPageFilter: (state) => state.membersPerPageFilter,
    getMembersPerPageFilterOptions: (state, getters) => {
      var options = [
        { id: 5, name: "5", value: 5 },
        { id: 15, name: "15", value: 15 },
        { id: 25, name: "25", value: 25 },
        { id: 50, name: "50", value: 50 },
        { id: 100, name: "100", value: 100 },
      ];
      return options;
    },
    getTasksPerPageFilter: (state) => state.tasksPerPageFilter,
    getTasksPerPageFilterOptions: (state, getters) => {
      var options = [
        { id: 5, name: "5", value: 5 },
        { id: 15, name: "15", value: 15 },
        { id: 25, name: "25", value: 25 },
        { id: 50, name: "50", value: 50 },
        { id: 100, name: "100", value: 100 },
      ];
      return options;
    },
    getIssuesPerPageFilter: (state) => state.issuesPerPageFilter,
    getIssuesPerPageFilterOptions: (state, getters) => {
      var options = [
        { id: 5, name: "5", value: 5 },
        { id: 15, name: "15", value: 15 },
        { id: 25, name: "25", value: 25 },
        { id: 50, name: "50", value: 50 },
        { id: 100, name: "100", value: 100 },
      ];
      return options;
    },

    getRisksPerPageFilter: (state) => state.risksPerPageFilter,
    getRisksPerPageFilterOptions: (state, getters) => {
      var options = [
        { id: 5, name: "5", value: 5 },
        { id: 15, name: "15", value: 15 },
        { id: 25, name: "25", value: 25 },
        { id: 50, name: "50", value: 50 },
        { id: 100, name: "100", value: 100 },
      ];
      return options;
    },
    getLessonsPerPageFilter: (state) => state.lessonsPerPageFilter,
    getLessonsPerPageFilterOptions: (state, getters) => {
      var options = [
        { id: 5, name: "5", value: 5 },
        { id: 15, name: "15", value: 15 },
        { id: 25, name: "25", value: 25 },
        { id: 50, name: "50", value: 50 },
        { id: 100, name: "100", value: 100 },
      ];
      return options;
    },
    getTaskIssueProgressStatusOptions: (state, getters) => {
      return [
        { id: "active", name: "Not Completed" },
        { id: "completed", name: "Completed" },
      ];
    },
    getTaskIssueProgressStatusFilter: (state) => {
      return state.taskIssueProgressStatusFilter;
    },
    getMyAssignmentsFilter: (state) => state.myAssignmentsFilter,
    getMyAssignmentsFilterOptions: (state, getters) => {
      var options = [
        {
          id: "myAction",
          name: "My Assignments",
          value: "my action",
          filterCategoryId: "myActionsFilter",
          filterCategoryName: "My Assignments",
        },
        {
          id: "notMyAction",
          name: "Not My Assignments",
          value: "not my action",
          filterCategoryId: "myActionsFilter",
          filterCategoryName: "My Assignments",
        },
      ];
      return options;
    },
    // DO NOT ERASE:  HELPFUL IF WE WANT TO ADD DROPDOWN WITH DIFFERENT CATEGORY LABELS
    getAdvancedFilter: (state) => state.advancedFilter,
    getAdvancedFilterOptions: (state, getters) => {
      var options = [
        {
          label: "State To Display",
          options: [
            {
              id: "completed",
              name: "Complete",
              value: "completed",
              filterCategoryId: "progressStatusFilter",
              filterCategoryName: "Progress Status",
            },
            {
              id: "inProgress",
              name: "In Progress",
              value: "inProgress",
              filterCategoryId: "inProgressFilter",
              filterCategoryName: "In Progress",
            },
            {
              id: "planned",
              name: "Planned",
              value: "planned",
              filterCategoryId: "plannedFilter",
              filterCategoryName: "Planned",
            },
            {
              id: "overdue",
              name: "Overdue",
              value: "overdue",
              filterCategoryId: "overDueFilter",
              filterCategoryName: "Action Overdue",
            },
            {
              id: "onGoing",
              name: "Ongoing",
              value: "onGoing",
              filterCategoryId: "onGoingFilter",
              filterCategoryName: "Ongoing",
            },
            {
              id: "onHold",
              name: "On Hold",
              value: "onHold",
              filterCategoryId: "onHoldFilter",
              filterCategoryName: "On Hold",
            },
            {
              id: "draft",
              name: "Drafts",
              value: "draft",
              filterCategoryId: "draftFilter",
              filterCategoryName: "Drafts",
            },
          ],
        },
        {
          label: "Tag Focus",
          options: [
            {
              id: "onWatch",
              name: "On Watch",
              value: "onWatch",
              filterCategoryId: "onWatchFilter",
              filterCategoryName: "On Watch",
            },
            {
              id: "reportable",
              name: "Briefings",
              value: "reportable",
              filterCategoryId: "briefingsFilter",
              filterCategoryName: "Briefings",
            },
            {
              id: "important",
              name: "Marked Important",
              value: "important",
              filterCategoryId: "importantFilter",
              filterCategoryName: "Important",
            },
          ],
          // }, {
          //   label: 'Assignments',
          //   options: [{
          //   id: 'myAction', name: 'My Assignments', value: 'my action', filterCategoryId: 'myActionsFilter', filterCategoryName: 'My Assignments', label:"Assignments"
          //  },{
          //   id: 'notMyAction', name: 'Not My Assignments', value: 'not my action', filterCategoryId: 'myActionsFilter', filterCategoryName: 'My Assignments',  label:"Assignments"
          //  }]
          // }, {
          //     label: 'Default Settings',
          //     options: [{
          //       id: 'active', name: 'Not Completed', value: 'active', filterCategoryId: 'progressStatusFilter', filterCategoryName: 'Progress Status'
          //    },{
          //     id: 'notMyAction', name: 'Not My Assignments', value: 'not my action', filterCategoryId: 'myActionsFilter', filterCategoryName: 'My Assignments',  label:"Assignments"
          //    }]
        },
      ];
      return options;
    },

    getRiskApproachFilter: (state) => state.riskApproachFilter,
    getRiskApproachFilterOptions: (state, getters) => {
      var options = [
        { id: "accept", name: "Accept", value: "accept" },
        { id: "avoid", name: "Avoid", value: "avoid" },
        { id: "mitigate", name: "Mitigate", value: "mitigate" },
        { id: "transfer", name: "Transfer", value: "transfer" },
      ];
      return options;
    },
    getRiskImpactLevelOptions: (state) => state.riskImpactLevelOptions,
    getRiskImpactLevelNames: (state, getters) => {
      var options = [
        { id: 1, value: 1, name: "1 - Negligible" },
        { id: 2, value: 2, name: "2 - Minor" },
        { id: 3, value: 3, name: "3 - Moderate" },
        { id: 4, value: 4, name: "4 - Major" },
        { id: 5, value: 5, name: "5 - Catastrophic" },
        // {value: 1, name: "1 - Rare"}, "2 - Unlikely", "3 - Possible", "4 - Likely", "5 - Almost Certain"
      ];
      return options;
    },
    getRiskDispositionStatusOptions: (state) => state.riskDispositionStatus,
    getRiskDispositionStatus: (state, getters) => {
      var options = [
        { id: 1, value: 1, name: "Monitoring" },
        { id: 2, value: 2, name: "Resolved" },
        { id: 3, value: 3, name: "Closed" },
      ];
      return options;
    },
    getRiskDispositionDurationOptions: (state) => state.riskDispositionDuration,
    getRiskDispositionDuration: (state, getters) => {
      var options = [
        { id: 1, value: 1, name: "Temporary" },
        { id: 2, value: 2, name: "Perpetual" },
      ];
      return options;
    },
    getRiskProbabilityOptions: (state) => state.riskProbabilityOptions,
    getRiskProbabilityNames: (state, getters) => {
      var options = [
        { id: 1, value: 1, name: "1 - Rare" },
        { id: 2, value: 2, name: "2 - Unlikely" },
        { id: 3, value: 3, name: "3 - Possible" },
        { id: 4, value: 4, name: "4 - Likely" },
        { id: 5, value: 5, name: "5 - Almost Certain" },
        // {value: 1, name: "1 - Rare"}, "2 - Unlikely", "3 - Possible", "4 - Likely", "5 - Almost Certain"
      ];
      return options;
    },
    getRiskPriorityLevelFilter: (state) => state.riskPriorityLevelFilter,
    getRiskPriorityLevelFilterOptions: (state, getters) => {
      var options = [
        { id: "very low", name: "Very Low 1", value: "very low" },
        { id: "low", name: "Low 2 - 3", value: "low" },
        { id: "moderate", name: "Moderate 4 - 6", value: "moderate" },
        { id: "high", name: "High 8 - 12", value: "high" },
        { id: "extreme", name: "Extreme 15 - 25", value: "extreme" },
      ];
      return options;
    },
    // This method is used to show filters applied in overview tabs
    getAllFilterNames: (state, getters) => {
      return [
        ["facilityGroupFilter", "Project Groups"],
        ["facilityNameFilter", "Project Names"],
        ["projectStatusFilter", "Project Statuses"],
        ["facilityProgressFilter", "Project Progress Range"],
        ["facilityDueDateFilter", "Project Completion Date Range"],
        ["taskTypeFilter", "Categories"],
        ["noteDateFilter", "Updates Date Range"],
        ["taskIssueDueDateFilter", "Action Due Date Range"],
        ["taskIssueProgressFilter", "Action Progress Range"],
        ["taskUserFilter", "Task Users"],
        ["issueTypeFilter", "Issue Types"],
        ["issueSeverityFilter", "Issue Severities"],
        ["issueUserFilter", "Issue Users"],
        ["taskStageFilter", "Task Stages"],
        ["issueStageFilter", "Issue Stages"],
        ["calendarViewFilter", "Calendar View"],
        ["membersPerPageFilter", "Members Per Page"],
        ["tasksPerPageFilter", "Tasks Per Page"],
        ["issuesPerPageFilter", "Issues Per Page"],
        ["risksPerPageFilter", "Risks Per Page"],
        ["lessonsPerPageFilter", "Lessons Per Page"],
        ["taskIssueUserFilter", "Action Users"],
        ["riskApproachFilter", "Risk Approaches"],
        ["riskStageFilter", "Risk Stages"],
        ["riskPriorityLevelFilter", "Risk Priority Levels"],

        // Advanced Filters
        // The first index value is filterCategoryId in advanced filter
        ["overDueFilter", "Action Overdue"],
        ["myActionsFilter", "My Assignments"],
        ["myAssignmentsFilter", "My Assignments"],
        ["onWatchFilter", "On Watch"],
        ["importantFilter", "Important"],
        ["briefingsFilter", "Briefings"],
        ["onGoingFilter", "Ongoing"],
        ["inProgressFilter", "In Progress"],
        ["plannedFilter", "Planned"],
        ["onHoldFilter", "On Hold"],
        ["draftFilter", "Drafts"],
        ["progressStatusFilter", "Action Status"],
      ];
    },
    // This method is used to show filters applied in overview tabs
    getFilterValue: (state, getter) => (_filterValue) => {
      if (_filterValue == "facilityGroupFilter") {
        // console.log(getter.facilityGroupFilter)
        var user_names = null;
        if (getter.facilityGroupFilter && getter.facilityGroupFilter[0]) {
          user_names = _.map(getter.facilityGroupFilter, "name").join(", ");
        }
        return user_names;
        // Advanced filters
      } else if (
        [
          "plannedFilter",
          "inProgressFilter",
          "overDueFilter",
          "myActionsFilter",
          "onWatchFilter",
          "progressStatusFilter",
          "importantFilter",
          "onGoingFilter",
          "onHoldFilter",
          "draftFilter",
          "briefingsFilter",
        ].includes(_filterValue)
      ) {
        var aFilter = getter.getAdvancedFilter;
        var user_names = _.map(
          _.filter(aFilter, (fHash) => fHash.filterCategoryId == _filterValue),
          "name"
        ).join(", ");

        return user_names;
      } else if (_filterValue == "myActionsFilter") {
        var user_names = null;
        if (getter.myActionsFilter && getter.myActionsFilter[0]) {
          user_names = _.map(getter.myActionsFilter, "myActionsFilter").join(
            ", "
          );
        }
        return user_names;

        // }else if(_filterValue =='myAssignmentsFilter'){
        //   var user_names = null
        //     if(getter.myAssignmentsFilter && getter.myAssignmentsFilter[0]){
        //       user_names = _.map(getter.myAssignmentsFilter, 'myAssignmentsFilter').join(", ")
        //     }
        //     return user_names
      } else if (_filterValue == "facilityNameFilter") {
        // console.log(getter.facilityNameFilter)
        var user_names = null;
        if (getter.facilityNameFilter && getter.facilityNameFilter[0]) {
          user_names = _.map(getter.facilityNameFilter, "facilityName").join(
            ", "
          );
        }
        return user_names;
      } else if (_filterValue == "projectStatusFilter") {
        // console.log(getter.projectStatusFilter)
        var user_names = null;
        if (getter.projectStatusFilter && getter.projectStatusFilter[0]) {
          user_names = _.map(getter.projectStatusFilter, "name").join(", ");
        }
        return user_names;
      } else if (_filterValue == "facilityProgressFilter") {
        // console.log(getter.facilityProgressFilter)
        var user_names = null;
        if (getter.facilityProgressFilter && getter.facilityProgressFilter[0]) {
          user_names = _.map(getter.facilityProgressFilter, "name").join(", ");
        }
        return user_names;
      } else if (_filterValue == "facilityDueDateFilter") {
        // console.log(getter.facilityDueDateFilter)
        var dates = null;
        if (getter.facilityDueDateFilter && getter.facilityDueDateFilter[0]) {
          dates = [];
          dates.push(
            moment(getter.facilityDueDateFilter[0]).format("YYYY-MM-DD")
          );
          dates.push(
            moment(getter.facilityDueDateFilter[1]).format("YYYY-MM-DD")
          );
          dates = dates.join(" - ");
        }
        return dates;
      } else if (_filterValue == "taskTypeFilter") {
        // console.log(getter.taskTypeFilter)
        var user_names = null;
        if (getter.taskTypeFilter && getter.taskTypeFilter[0]) {
          user_names = _.map(getter.taskTypeFilter, "name").join(", ");
        }
        return user_names;
      } else if (_filterValue == "noteDateFilter") {
        // console.log(getter.noteDateFilter)
        var dates = null;
        if (getter.noteDateFilter && getter.noteDateFilter[0]) {
          dates = [];
          dates.push(moment(getter.noteDateFilter[0]).format("YYYY-MM-DD"));
          dates.push(moment(getter.noteDateFilter[1]).format("YYYY-MM-DD"));
          dates = dates.join(" - ");
        }
        return dates;
      } else if (_filterValue == "taskIssueDueDateFilter") {
        // console.log(getter.taskIssueDueDateFilter)
        var dates = null;
        if (getter.taskIssueDueDateFilter && getter.taskIssueDueDateFilter[0]) {
          dates = [];
          dates.push(
            moment(getter.taskIssueDueDateFilter[0]).format("YYYY-MM-DD")
          );
          dates.push(
            moment(getter.taskIssueDueDateFilter[1]).format("YYYY-MM-DD")
          );
          dates = dates.join(" - ");
        }
        return dates;
      } else if (_filterValue == "taskIssueProgressFilter") {
        // console.log(getter.taskProgressFilter)
        var user_names = null;
        if (
          getter.taskIssueProgressFilter &&
          getter.taskIssueProgressFilter[0]
        ) {
          user_names = _.map(getter.taskIssueProgressFilter, "name").join(", ");
        }
        return user_names;
      } else if (_filterValue == "taskUserFilter") {
        // console.log(getter.taskUserFilter)
        var user_names = null;
        if (getter.taskUserFilter && getter.taskUserFilter[0]) {
          user_names = _.map(getter.taskUserFilter, "fullName").join(", ");
        }
        return user_names;
      } else if (_filterValue == "issueTypeFilter") {
        // console.log(getter.issueTypeFilter)
        var names = null;
        if (getter.issueTypeFilter && getter.issueTypeFilter[0]) {
          names = _.map(getter.issueTypeFilter, "name").join(", ");
        }
        return names;
      } else if (_filterValue == "issueProgressFilter") {
        // console.log(getter.issueProgressFilter)
        var user_names = null;
        if (getter.issueProgressFilter && getter.issueProgressFilter[0]) {
          user_names = _.map(getter.issueProgressFilter, "name").join(", ");
        }
        return user_names;
      } else if (_filterValue == "issueSeverityFilter") {
        // console.log(getter.issueSeverityFilter)
        var names = null;
        if (getter.issueSeverityFilter && getter.issueSeverityFilter[0]) {
          names = _.map(getter.issueSeverityFilter, "name").join(", ");
        }
        return names;
      } else if (_filterValue == "issueUserFilter") {
        // console.log(getter.issueUserFilter)
        var user_names = null;
        if (getter.issueUserFilter && getter.issueUserFilter[0]) {
          user_names = _.map(getter.issueUserFilter, "fullName").join(", ");
        }
        return user_names;
      } else if (_filterValue == "taskStageFilter") {
        // console.log(getter.taskStageFilter)

        var user_names = null;
        if (getter.taskStageFilter && getter.taskStageFilter[0]) {
          user_names = _.map(getter.taskStageFilter, "name").join(", ");
        }
        return user_names;
      } else if (_filterValue == "issueStageFilter") {
        // console.log(getter.issueStageFilter)
        var user_names = null;
        if (getter.issueStageFilter && getter.issueStageFilter[0]) {
          user_names = _.map(getter.issueStageFilter, "name").join(", ");
        }
        return user_names;
      } else if (_filterValue == "taskIssueUserFilter") {
        // console.log(getter.getTaskIssueUserFilter)
        var user_names = null;
        if (getter.getTaskIssueUserFilter && getter.getTaskIssueUserFilter[0]) {
          user_names = _.map(getter.getTaskIssueUserFilter, "fullName").join(
            ", "
          );
        }
        return user_names;
      } else if (_filterValue == "riskPriorityLevelFilter") {
        // console.log(getter.getTaskIssueUserFilter)
        var user_names = null;
        if (
          getter.getRiskPriorityLevelFilter &&
          getter.getRiskPriorityLevelFilter[0]
        ) {
          user_names = _.map(getter.getRiskPriorityLevelFilter, "name").join(
            ", "
          );
        }
        return user_names;
      } else if (_filterValue == "riskStageFilter") {
        // console.log(getter.getTaskIssueUserFilter)
        var user_names = null;
        if (getter.riskStageFilter && getter.riskStageFilter[0]) {
          user_names = _.map(getter.riskStageFilter, "name").join(", ");
        }
        return user_names;
      } else if (_filterValue == "riskApproachFilter") {
        // console.log(getter.getTaskIssueUserFilter)
        var user_names = null;
        if (getter.getRiskApproachFilter && getter.getRiskApproachFilter[0]) {
          user_names = _.map(getter.getRiskApproachFilter, "name").join(", ");
        }
        return user_names;
      }
    },
    contentLoaded: (state) => state.contentLoaded,
    projectsLoaded: (state) => state.projectsLoaded,
    getToggleRACI: (state) => state.toggleRACI,
    getShowProjectStats: (state) => state.showProjectStats,
    getShowContractStats: (state) => state.showContractStats,
    getShowVehicleStats: (state) => state.showVehicleStats,
    getShowAllEventsToggle: (state) => state.showAllEventsToggle,
    getShowAdvancedFilter: (state) => state.showAdvancedFilter,
    getLastFocusFilter: (state) => state.lastCalendarFocus,

    mapLoading: (state) => state.mapLoading,
    sideLoading: (state) => state.sideLoading,
    projects: (state) => state.projects,
    facilities: (state) => state.facilities,
    projectContracts: (state) => state.contracts,
    projectVehicles: (state) => state.vehicles,
    tableData: (state) => state.tableData, 
    facilityGroups: (state) => state.facilityGroups,
    statuses: (state) => state.statuses,

    taskTypes: (state) => state.taskTypes,
    taskStages: (state) => state.taskStages,
    taskTypeFilter: (state) => state.taskTypeFilter,
    taskStageFilter: (state) => state.taskStageFilter,
    taskProgressFilter: (state) => state.taskProgressFilter,
    taskUserFilter: (state) => state.taskUserFilter,

    getProjectGroupFilter: (state) => state.projectGroupFilter,

    riskStages: (state) => state.riskStages,
    riskStageFilter: (state) => state.riskStageFilter,
    riskApproach: (state) => state.riskApproach,
    riskApproachFilter: (state) => state.riskApproachFilter,
    riskProbabilityOptions: (state) => state.riskProbabilityOptions,
    riskImpactLevelOptions: (state) => state.riskImpactLevelOptions,

    issueStages: (state) => state.issueStages,
    issueTypes: (state) => state.issueTypes,
    issueSeverities: (state) => state.issueSeverities,
    issueStageFilter: (state) => state.issueStageFilter,
    issueTypeFilter: (state) => state.issueTypeFilter,
    issueSeverityFilter: (state) => state.issueSeverityFilter,
    issueProgressFilter: (state) => state.issueProgressFilter,
    issueUserFilter: (state) => state.issueUserFilter,

    membersPerPageFilter: (state) => state.membersPerPageFilter,
    tasksPerPageFilter: (state) => state.tasksPerPageFilter,
    issuesPerPageFilter: (state) => state.issuesPerPageFilter,
    risksPerPageFilter: (state) => state.risksPerPageFilter,
    lessonsPerPageFilter: (state) => state.lessonsPerPageFilter,
    calendarViewFilter: (state) => state.calendarViewFilter,

    currentProject: (state) => state.currentProject,
    projectUsers: (state) => state.projectUsers,
    accountableUsers: (state) => state.accountableUsers,
    consultedUsers: (state) => state.consultedUsers,
    informedUsers: (state) => state.informedUsers,
    activeProjectUsers: (state) =>
      _.filter(state.projectUsers, (u) => u.status == "active"),
    accountableProjectUsers: (state) =>
      _.filter(state.accountableUsers, (u) => u.status == "active"),
    consultedProjectUsers: (state) =>
      _.filter(state.consultedUsers, (u) => u.status == "active"),
    informedProjectUsers: (state) =>
      _.filter(state.informedUsers, (u) => u.status == "active"),

    currentFacility: (state) => state.currentFacility,
    currentFacilityGroup: (state) => state.currentFacilityGroup,
    projectStatusFilter: (state) => state.projectStatusFilter,
    taskIssueOverdueFilter: (state) => state.taskIssueOverdueFilter,

    facilityGroupFilter: (state) => state.facilityGroupFilter,
    facilityNameFilter: (state) => state.facilityNameFilter,
    facilityProgressFilter: (state) => state.facilityProgressFilter,
    programProgressFilter: (state) => state.programProgressFilter,
    facilityDueDateFilter: (state) => state.facilityDueDateFilter,
    noteDateFilter: (state) => state.noteDateFilter,
    taskIssueDueDateFilter: (state) => state.taskIssueDueDateFilter,

    taskIssueProgressFilter: (state) => state.taskIssueProgressFilter,
    myActionsFilter: (state) => state.myActionsFilter,
    onWatchFilter: (state) => state.onWatchFilter,
    mapFilters: (state) => state.mapFilters,
    progressFilter: (state) => state.progressFilter,
    managerView: (state) => state.managerView,
    contactInfoForm: (state) => state.contactInfoForm,
    // NOTE: This function will be used in many pages to filter data based on advanced filter
    // selected by user.
    filterDataForAdvancedFilter: (state, getters) => (
      resources,
      page_name,
      facility = null
    ) => {
      var aFilter = getters.getAdvancedFilter;

      // console.log("aFilter----")
      // console.log(aFilter)
      // console.log(resources)

      var myFilter = getters.getMyAssignmentsFilter;

      let taksIssueNotOnWatch = _.map(aFilter, "id").includes("notOnWatch");
      let taskIssueOnWatch = _.map(aFilter, "id").includes("onWatch");

      let taksIssueNotImportant = _.map(aFilter, "id").includes("notImportant");
      let taskIssueImporant = _.map(aFilter, "id").includes("important");

      let taksIssueNotReportable = _.map(aFilter, "id").includes(
        "notReportable"
      );
      let taskIssueReportable = _.map(aFilter, "id").includes("reportable");

      let taksIssueNotOnGoing = _.map(aFilter, "id").includes("notOnGoing");
      let taskIssueOnGoing = _.map(aFilter, "id").includes("onGoing");

      let taskIssueMyAction = _.map(myFilter, "id").includes("myAction");
      let taksIssueNotMyAction = _.map(myFilter, "id").includes("notMyAction");

      let taskIssueOverdue = _.map(aFilter, "id").includes("overdue");
      let taskIssueNotOverdue = _.map(aFilter, "id").includes("notOverdue");

      let taskIssueActiveProgressStatus = _.map(aFilter, "id").includes(
        "active"
      );
      let taskIssueCompletedProgressStatus = _.map(aFilter, "id").includes(
        "completed"
      );

      let taskIssueRiskDraft = _.map(aFilter, "id").includes("draft");
      let taskIssueRiskNotDraft = _.map(aFilter, "id").includes("notDraft");

      let taskIssueRiskOnHold = _.map(aFilter, "id").includes("onHold");
      let taskIssueRiskNotOnHold = _.map(aFilter, "id").includes("notOnHold");

      let taskIssueRiskPlanned = _.map(aFilter, "id").includes("planned");
      let taskIssueRiskNotPlanned = _.map(aFilter, "id").includes("notPlanned");

      let taskIssueRiskInprogress = _.map(aFilter, "id").includes("inProgress");
      let taskIssueRiskNotInprogress = _.map(aFilter, "id").includes(
        "notInprogress"
      );

      // let riskPriorityLevel = _.map(aFilter, 'filterCategoryId').includes("riskPriorityLevelFilter")
      // let riskPriorityLevelNames = _.map(aFilter, 'id')

      // let riskApproach = _.map(aFilter, 'filterCategoryId').includes("riskApproachFilter")
      // let riskApproachNames = _.map(aFilter, 'id')

      let valid = true;

      if (
        (taskIssueActiveProgressStatus == true &&
          taskIssueCompletedProgressStatus == true) ||
        (taskIssueMyAction == true && taksIssueNotMyAction == true) ||
        (taskIssueOnWatch == true && taksIssueNotOnWatch == true) ||
        (taskIssueImporant == true && taksIssueNotImportant == true) ||
        (taskIssueReportable == true && taksIssueNotReportable == true) ||
        (taskIssueOnGoing == true && taksIssueNotOnGoing == true) ||
        (taskIssueRiskPlanned == true && taskIssueRiskNotPlanned == true) ||
        (taskIssueRiskInprogress == true &&
          taskIssueRiskNotInprogress == true) ||
        (taskIssueOverdue == true && taskIssueNotOverdue == true) ||
        // (taskIssueRiskNotDraft == true && taskIssueRiskDraft == true) ||
        (taskIssueRiskNotOnHold == true && taskIssueRiskOnHold == true)
      ) {
        valid = true;
      }

      let _isOverdues = [];
      _isOverdues = _.map(resources, "isOverdue");

      let _isDrafts = [];
      _isDrafts = _.map(resources, "draft");

      let isPlanned = [];
      isPlanned = resources.map((p) => p.planned);

      let isInprogress = [];
      isInprogress = resources.map((p) => p.inProgress);

      let _isOnHolds = [];
      _isOnHolds = _.map(resources, "onHold");

      if (
        taskIssueRiskDraft == true ||
        taskIssueRiskOnHold == true ||
        taskIssueRiskPlanned == true ||
        taskIssueRiskInprogress == true ||
        taskIssueOverdue == true ||
        taskIssueCompletedProgressStatus == true ||
        taskIssueOnGoing == true ||
        taskIssueOnWatch == true ||
        taskIssueReportable == true ||
        taskIssueImporant == true
      ) {
        valid = false;
      }

      if (taskIssueRiskDraft == false && taskIssueRiskNotDraft == true) {
        valid = valid && _isDrafts.includes(false);
      }
      if (taskIssueRiskDraft == true && taskIssueRiskNotDraft == false) {
        valid = valid || _isDrafts.includes(true);
      }
      if (taskIssueRiskOnHold == false && taskIssueRiskNotOnHold == true) {
        valid = valid && _isOnHolds.includes(false);
      }

      if (taskIssueRiskOnHold == true && taskIssueRiskNotOnHold == false) {
        valid = valid || _isOnHolds.includes(true);
      }

      if (taskIssueRiskPlanned == false && taskIssueRiskNotPlanned == true) {
        valid = valid && isPlanned.includes(false);
      }

      if (taskIssueRiskPlanned == true && taskIssueRiskNotPlanned == false) {
        valid = valid || isPlanned.includes(true);
      }

      if (
        taskIssueRiskInprogress == false &&
        taskIssueRiskNotInprogress == true
      ) {
        valid = valid && isInprogress.includes(false);
      }

      if (
        taskIssueRiskInprogress == true &&
        taskIssueRiskNotInprogress == false
      ) {
        valid = valid || isInprogress.includes(true);
      }

      if (taskIssueOverdue == true && taskIssueNotOverdue == false) {
        valid = valid || _isOverdues.includes(true);
      }
      if (taskIssueOverdue == false && taskIssueNotOverdue == true) {
        valid = valid && _isOverdues.includes(false);
      }
      if (
        page_name.toLowerCase().includes("lesson") &&
        taskIssueCompletedProgressStatus == true
        ) {
        valid = valid || _isDrafts.includes(false);
      } else {
        let _progressStatuses = [];
        _progressStatuses = _.map(resources, "progressStatus");

        if (
          taskIssueActiveProgressStatus == true &&
          taskIssueCompletedProgressStatus == false &&
          _progressStatuses.length > 0
        ) {
          valid = valid && _progressStatuses.includes("active");
        }
        if (
          taskIssueActiveProgressStatus == false &&
          taskIssueCompletedProgressStatus == true &&
          _progressStatuses.length > 0
        ) {
          valid = valid || _progressStatuses.includes("completed");
        }
      }

      // var notes = _.flatten(_.map(resources, 'notes'))
      var userIds = []; //_.uniq(_.map(notes, 'userId'))

      var uids = _.compact(
        _.uniq([
          ..._.flatten(_.map(resources, "userIds")),
          ..._.map(_.flatten(_.map(resources, "checklists")), "userId"),
        ])
      );
      // if(page_name == 'filteredFacilities'){
      //   var u = _.uniq(_.map(facility['notes'], 'userId'))
      //   userIds = userIds.concat(u)
      // }
      userIds = _.uniq(userIds.concat(uids));

      if (taskIssueMyAction == true && taksIssueNotMyAction == false) {
        valid = valid && userIds.includes(Vue.prototype.$currentUser.id);
      }

      if (taskIssueMyAction == false && taksIssueNotMyAction == true) {
        var isValid = false;
        for (let res of resources) {
          if (!res.userIds.includes(Vue.prototype.$currentUser.id)) {
            isValid = true;
          }
          if (isValid) break;
        }
        valid = valid && isValid;
      }

      var watches = _.uniq(_.map(resources, "watched"));

      if (taskIssueOnWatch == true && taksIssueNotOnWatch == false) {
        valid = valid || watches.includes(true);
      }

      if (taskIssueOnWatch == false && taksIssueNotOnWatch == true) {
        valid = valid && watches.includes(false);
      }

      var importants = _.uniq(_.map(resources, "important"));
      if (taskIssueImporant == true && taksIssueNotImportant == false) {
        valid = valid || importants.includes(true);
      }

      if (taskIssueImporant == false && taksIssueNotImportant == true) {
        valid = valid && importants.includes(false);
      }

      let reportables = _.uniq(_.map(resources, "reportable"));
      if (taskIssueReportable == true && taksIssueNotReportable == false) {
        valid = valid || reportables.includes(true);
      }

      if (taskIssueReportable == false && taksIssueNotReportable == true) {
        valid = valid && reportables.includes(false);
      }

      // As per issue https://github.com/MicroHealthLLC/mPATH/issues/2649
      // ongoing flat is just for Task and Risk so, we will filter it
      // on Task or Risk resources
      if (
        page_name.toLowerCase().includes("task") ||
        page_name.toLowerCase().includes("risk")
      ) {
        // console.log("inside ongoing filter")
        var onGoings = _.uniq(_.map(resources, "ongoing"));
        if (taskIssueOnGoing == true && taksIssueNotOnGoing == false) {
          valid = valid || onGoings.includes(true);
        }

        if (taskIssueOnGoing == false && taksIssueNotOnGoing == true) {
          valid = valid && onGoings.includes(false);
        }
      } else if (page_name.toLowerCase().includes("issue")) {
        if (taskIssueOnGoing == true && taksIssueNotOnGoing == false) {
          valid = false;
        }
      }
      return valid;
    },

    filteredFacilities: (state, getters) => (_status = "active") => {
      // return getters.facilities;

      return _.filter(getters.facilities, (facility) => {
        let valid = _status === "all" || facility.status === _status;
        valid = valid && facility.facilityGroupStatus == "active";
        if (!valid) return valid;
        if (state.mapFilters.length < 1) return valid;

        var resources1 = [];
        resources1.push(...facility.tasks);
        resources1.push(...facility.issues);
        resources1.push(...facility.risks);
        // resources1 = resources1.concat(facility.tasks)
        // resources1 = resources1.concat(facility.issues)
        // resources1 = resources1.concat(facility.risks)

        _.each(state.mapFilters, (f) => {
          let k = Object.keys(f)[0];
          switch (k) {
            case "advancedFilter": {
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredFacilities",
                  facility
                );
              break;
            }
            case "dueDate": {
              let range = moment.range(f[k][0], f[k][1]);
              valid =
                valid &&
                facility[k] &&
                range.contains(new Date(facility[k].replace(/-/g, "/")));
              break;
            }
            case "noteDate": {
              let taksIssues = facility.tasks
                .concat(facility.issues)
                .concat(facility.risks);
              let resources = [];
              for (let r of taksIssues) {
                var v = getters.filterDataForAdvancedFilter(
                  [r],
                  "filteredFacilities",
                  facility
                );
                if (v) {
                  resources.push(r);
                }
              }
              var startDate = moment(f[k][0], "YYYY-MM-DD");
              var endDate = moment(f[k][1], "YYYY-MM-DD");
              var _notes = _.flatten(_.map(resources, "notes"));
              var is_valid = false;
              for (var n of _notes) {
                var nDate = moment(n.createdAt, "YYYY-MM-DD");
                is_valid = nDate.isBetween(startDate, endDate, "days", true);
                if (is_valid) break;
              }

              valid = valid && is_valid;
              break;
            }
            case "taskIssueDueDate": {
              let taksIssues = facility.tasks
                .concat(facility.issues)
                .concat(facility.risks);
              let resources = [];
              for (let r of taksIssues) {
                var v = getters.filterDataForAdvancedFilter(
                  [r],
                  "filteredFacilities",
                  facility
                );
                if (v) {
                  resources.push(r);
                }
              }

              var startDate = moment(f[k][0], "YYYY-MM-DD");
              var endDate = moment(f[k][1], "YYYY-MM-DD");
              var _dueDates = _.flatten(_.map(resources, "dueDate"));
              var is_valid = false;

              if (_dueDates.length < 1) {
                valid = valid && is_valid;
                break;
              } else {
                for (var dueDate of _dueDates) {
                  var nDate = moment(dueDate, "YYYY-MM-DD");
                  is_valid = nDate.isBetween(startDate, endDate, "days", true);
                  if (is_valid) break;
                }
                valid = valid && is_valid;
                break;
              }
            }
            // This is for facility progress
            case "progress": {
              let ranges = f[k].map((r) => r.split("-").map(Number));
              let is_valid = false;
              for (let range of ranges) {
                is_valid =
                  range[1] !== undefined
                    ? range[0] <= facility[k] && range[1] >= facility[k]
                    : facility[k] == range[0];
                if (is_valid) break;
              }
              valid = valid && is_valid;
              break;
            }
            // TODO: Improve this function
            case "taskIssueProgress": {
              let progressFor = facility.tasks
                .concat(facility.issues)
                .concat(facility.risks);
              let resources = [];
              for (let r of progressFor) {
                var v = getters.filterDataForAdvancedFilter(
                  [r],
                  "filteredFacilities",
                  facility
                );
                if (v) {
                  resources.push(r);
                }
              }
              let progress = _.uniq(_.map(resources, "progress"));
              let ranges = f[k].map((r) => r.split("-").map(Number));
              let is_valid = false;
              for (let range of ranges) {
                let size = range[1] ? range[1] - range[0] + 1 : 1;
                is_valid =
                  _.intersection(
                    progress,
                    Array.from(Array(size), (_, i) => i + range[0])
                  ).length > 0;
                if (is_valid) break;
              }
              valid = valid && is_valid;
              break;
            }
            case "issueTypeIds": {
              var issues = facility.issues;
              var resources = _.filter(issues, (ti) =>
                f[k].includes(ti.issueTypeId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredFacilities",
                  facility
                );

              break;
            }
            case "issueSeverityIds": {
              var issues = facility.issues;
              var resources = _.filter(issues, (ti) =>
                f[k].includes(ti.issueSeverityId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredFacilities",
                  facility
                );

              break;
            }
            case "issueStageIds": {
              var issues = facility.issues;
              var resources = _.filter(issues, (ti) =>
                f[k].includes(ti.issueStageId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredFacilities",
                  facility
                );
              break;
            }
            case "taskTypeIds": {
              var tasksIssues = facility.tasks
                .concat(facility.issues)
                .concat(facility.risks);
              var resources = _.filter(tasksIssues, (ti) =>
                f[k].includes(ti.taskTypeId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredFacilities",
                  facility
                );

              break;
            }
            case "taskStageIds": {
              var tasks = facility.tasks;
              var resources = _.filter(tasks, (ti) =>
                f[k].includes(ti.taskStageId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredFacilities",
                  facility
                );
              break;
            }
            case "riskStageIds": {
              var risks = facility.risks;
              var resources = _.filter(risks, (ti) =>
                f[k].includes(ti.riskStageId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredFacilities",
                  facility
                );
              break;
            }
            case "riskPriorityLevelIds": {
              var risks = facility.risks;
              var resources = _.filter(risks, (ti) =>
                f[k].includes(ti.riskPriorityLevelId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredFacilities",
                  facility
                );
              break;
            }
            case "riskApproachFilter": {
              var risks = facility.risks;
              var fApproaches = _.map(f[k], "id");
              var resources = _.filter(risks, (ti) =>
                fApproaches.includes(ti.riskApproach)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredFacilities",
                  facility
                );
              break;
            }
            case "riskApproachFilterIds": {
              var risks = facility.risks;
              var fApproaches = _.map(f[k], "id");
              var resources = _.filter(risks, (ti) =>
                fApproaches.includes(ti.riskApproachId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredFacilities",
                  facility
                );
              break;
            }
            case "riskPriorityLevelFilter": {
              var risks = facility.risks;
              var fPriorityLevels = _.map(f[k], "id");
              var resources = _.filter(risks, (ti) =>
                fPriorityLevels.includes(ti.priorityLevelName.toLowerCase())
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredFacilities",
                  facility
                );
              break;
            }
            case "taskIssueUsers": {
              var taskIssues = facility.tasks
                .concat(facility.issues)
                .concat(facility.risks);
              var resources = _.filter(
                taskIssues,
                (ti) => _.intersection(ti.userIds, f[k]).length > 0
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredFacilities",
                  facility
                );
              break;
            }
            case "facilityGroupIds": {
              valid =
                valid &&
                f[k].includes(facility.facilityGroupId) &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredFacilities",
                  facility
                );
              break;
            }
            case "ids": {
              valid =
                valid &&
                f[k].includes(facility.id) &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredFacilities",
                  facility
                );
              break;
            }
            case "statusIds": {
              valid =
                valid &&
                f[k].includes(facility.statusId) &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredFacilities",
                  facility
                );
              break;
            }
            default: {
              valid = valid && facility[k] == f[k];
              break;
            }
          }
        });
        return valid;
      });
    },
    filteredContracts: (state, getters) => {
      return _.filter(getters.projectContracts, (contract) => {
        let valid = contract.projectContractId || null;
        // valid = valid && facility.facilityGroupStatus == "active";
        if (!valid) return valid;
        if (state.mapFilters.length < 1) return valid;

        var resources1 = [];
        resources1.push(...contract.tasks);
        resources1.push(...contract.issues);
        resources1.push(...contract.risks);
  
        _.each(state.mapFilters, (f) => {
          let k = Object.keys(f)[0];
          switch (k) {
            case "advancedFilter": {
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredContracts",
                  contract
                );
              break;
            }
            case "dueDate": {
              let range = moment.range(f[k][0], f[k][1]);
              valid =
                valid &&
                contract[k] &&
                range.contains(new Date(contract[k].replace(/-/g, "/")));
              break;
            }
            case "noteDate": {
              let taksIssues = contract.tasks
                .concat(contract.issues)
                .concat(contract.risks);
              let resources = [];
              for (let r of taksIssues) {
                var v = getters.filterDataForAdvancedFilter(
                  [r],
                  "filteredContracts",
                  contract
                );
                if (v) {
                  resources.push(r);
                }
              }
              var startDate = moment(f[k][0], "YYYY-MM-DD");
              var endDate = moment(f[k][1], "YYYY-MM-DD");
              var _notes = _.flatten(_.map(resources, "notes"));
              var is_valid = false;
              for (var n of _notes) {
                var nDate = moment(n.createdAt, "YYYY-MM-DD");
                is_valid = nDate.isBetween(startDate, endDate, "days", true);
                if (is_valid) break;
              }

              valid = valid && is_valid;
              break;
            }
            case "taskIssueDueDate": {
              let taksIssues = contract.tasks
                .concat(contract.issues)
                .concat(contract.risks);
              let resources = [];
              for (let r of taksIssues) {
                var v = getters.filterDataForAdvancedFilter(
                  [r],
                  "filteredContracts",
                  contract
                );
                if (v) {
                  resources.push(r);
                }
              }

              var startDate = moment(f[k][0], "YYYY-MM-DD");
              var endDate = moment(f[k][1], "YYYY-MM-DD");
              var _dueDates = _.flatten(_.map(resources, "dueDate"));
              var is_valid = false;

              if (_dueDates.length < 1) {
                valid = valid && is_valid;
                break;
              } else {
                for (var dueDate of _dueDates) {
                  var nDate = moment(dueDate, "YYYY-MM-DD");
                  is_valid = nDate.isBetween(startDate, endDate, "days", true);
                  if (is_valid) break;
                }
                valid = valid && is_valid;
                break;
              }
            }
            // This is for facility progress
            case "progress": {
              let ranges = f[k].map((r) => r.split("-").map(Number));
              let is_valid = false;
              for (let range of ranges) {
                is_valid =
                  range[1] !== undefined
                    ? range[0] <= contract[k] && range[1] >= contract[k]
                    : contract[k] == range[0];
                if (is_valid) break;
              }
              valid = valid && is_valid;
              break;
            }
            // TODO: Improve this function
            case "taskIssueProgress": {
              let progressFor = contract.tasks
                .concat(contract.issues)
                .concat(contract.risks);
              let resources = [];
              for (let r of progressFor) {
                var v = getters.filterDataForAdvancedFilter(
                  [r],
                  "filteredContracts",
                  contract
                );
                if (v) {
                  resources.push(r);
                }
              }
              let progress = _.uniq(_.map(resources, "progress"));
              let ranges = f[k].map((r) => r.split("-").map(Number));
              let is_valid = false;
              for (let range of ranges) {
                let size = range[1] ? range[1] - range[0] + 1 : 1;
                is_valid =
                  _.intersection(
                    progress,
                    Array.from(Array(size), (_, i) => i + range[0])
                  ).length > 0;
                if (is_valid) break;
              }
              valid = valid && is_valid;
              break;
            }
            case "issueTypeIds": {
              var issues = contract.issues;
              var resources = _.filter(issues, (ti) =>
                f[k].includes(ti.issueTypeId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredContracts",
                  contract
                );

              break;
            }
            case "issueSeverityIds": {
              var issues = contract.issues;
              var resources = _.filter(issues, (ti) =>
                f[k].includes(ti.issueSeverityId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredContracts",
                  contract
                );

              break;
            }
            case "issueStageIds": {
              var issues = contract.issues;
              var resources = _.filter(issues, (ti) =>
                f[k].includes(ti.issueStageId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredContracts",
                  contract
                );
              break;
            }
            case "taskTypeIds": {
              var tasksIssues = contract.tasks
                .concat(contract.issues)
                .concat(contract.risks);
              var resources = _.filter(tasksIssues, (ti) =>
                f[k].includes(ti.taskTypeId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredContracts",
                  contract
                );

              break;
            }
            case "taskStageIds": {
              var tasks = contract.tasks;
              var resources = _.filter(tasks, (ti) =>
                f[k].includes(ti.taskStageId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredContracts",
                  contract
                );
              break;
            }
            case "riskStageIds": {
              var risks = contract.risks;
              var resources = _.filter(risks, (ti) =>
                f[k].includes(ti.riskStageId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredContracts",
                  contract
                );
              break;
            }
            case "riskPriorityLevelIds": {
              var risks = contract.risks;
              var resources = _.filter(risks, (ti) =>
                f[k].includes(ti.riskPriorityLevelId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredContracts",
                  contract
                );
              break;
            }
            case "riskApproachFilter": {
              var risks = contract.risks;
              var fApproaches = _.map(f[k], "id");
              var resources = _.filter(risks, (ti) =>
                fApproaches.includes(ti.riskApproach)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredContracts",
                  contract
                );
              break;
            }
            case "riskApproachFilterIds": {
              var risks = contract.risks;
              var fApproaches = _.map(f[k], "id");
              var resources = _.filter(risks, (ti) =>
                fApproaches.includes(ti.riskApproachId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredContracts",
                  contract
                );
              break;
            }
            case "riskPriorityLevelFilter": {
              var risks = contract.risks;
              var fPriorityLevels = _.map(f[k], "id");
              var resources = _.filter(risks, (ti) =>
                fPriorityLevels.includes(ti.priorityLevelName.toLowerCase())
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredContracts",
                  contract
                );
              break;
            }
            case "taskIssueUsers": {
              var taskIssues = contract.tasks
                .concat(contract.issues)
                .concat(contract.risks);
              var resources = _.filter(
                taskIssues,
                (ti) => _.intersection(ti.userIds, f[k]).length > 0
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredContracts",
                  contract
                );
              break;
            }
            case "facilityGroupIds": {
              valid =
                valid &&
                f[k].includes(contract.contractGroupId) &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredContracts",
                  contract
                );
              break;
            }
            case "ids": {
              valid =
                valid &&
                f[k].includes(contract.project_contract_id) &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredContracts",
                  contract
                );
              break;
            }
            case "statusIds": {
              valid =
                valid &&
                f[k].includes(contract.statusId) &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredContracts",
                  contract
                );
              break;
            }
            default: {
              valid = valid && contract[k] == f[k];
              break;
            }
          }
        });
        return valid;
      });
    },
    filteredVehicles: (state, getters) => {
      return _.filter(getters.projectVehicles, (vehicle) => {
        let valid = vehicle.projectContractVehicleId || null;
        // valid = valid && facility.facilityGroupStatus == "active";
        if (!valid) return valid;
        if (state.mapFilters.length < 1) return valid;

        var resources1 = [];
        resources1.push(...vehicle.tasks);
        resources1.push(...vehicle.issues);
        resources1.push(...vehicle.risks);
  
        _.each(state.mapFilters, (f) => {
          let k = Object.keys(f)[0];
          switch (k) {
            case "advancedFilter": {
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredVehicles",
                  vehicle
                );
              break;
            }
            case "dueDate": {
              let range = moment.range(f[k][0], f[k][1]);
              valid =
                valid &&
                vehicle[k] &&
                range.contains(new Date(vehicle[k].replace(/-/g, "/")));
              break;
            }
            case "noteDate": {
              let taksIssues = vehicle.tasks
                .concat(vehicle.issues)
                .concat(vehicle.risks);
              let resources = [];
              for (let r of taksIssues) {
                var v = getters.filterDataForAdvancedFilter(
                  [r],
                  "filteredVehicles",
                  vehicle
                );
                if (v) {
                  resources.push(r);
                }
              }
              var startDate = moment(f[k][0], "YYYY-MM-DD");
              var endDate = moment(f[k][1], "YYYY-MM-DD");
              var _notes = _.flatten(_.map(resources, "notes"));
              var is_valid = false;
              for (var n of _notes) {
                var nDate = moment(n.createdAt, "YYYY-MM-DD");
                is_valid = nDate.isBetween(startDate, endDate, "days", true);
                if (is_valid) break;
              }

              valid = valid && is_valid;
              break;
            }
            case "taskIssueDueDate": {
              let taksIssues = vehicle.tasks
                .concat(vehicle.issues)
                .concat(vehicle.risks);
              let resources = [];
              for (let r of taksIssues) {
                var v = getters.filterDataForAdvancedFilter(
                  [r],
                  "filteredVehicles",
                  vehicle
                );
                if (v) {
                  resources.push(r);
                }
              }

              var startDate = moment(f[k][0], "YYYY-MM-DD");
              var endDate = moment(f[k][1], "YYYY-MM-DD");
              var _dueDates = _.flatten(_.map(resources, "dueDate"));
              var is_valid = false;

              if (_dueDates.length < 1) {
                valid = valid && is_valid;
                break;
              } else {
                for (var dueDate of _dueDates) {
                  var nDate = moment(dueDate, "YYYY-MM-DD");
                  is_valid = nDate.isBetween(startDate, endDate, "days", true);
                  if (is_valid) break;
                }
                valid = valid && is_valid;
                break;
              }
            }
            // This is for facility progress
            case "progress": {
              let ranges = f[k].map((r) => r.split("-").map(Number));
              let is_valid = false;
              for (let range of ranges) {
                is_valid =
                  range[1] !== undefined
                    ? range[0] <= vehicle[k] && range[1] >= vehicle[k]
                    : vehicle[k] == range[0];
                if (is_valid) break;
              }
              valid = valid && is_valid;
              break;
            }
            // TODO: Improve this function
            case "taskIssueProgress": {
              let progressFor = vehicle.tasks
                .concat(vehicle.issues)
                .concat(vehicle.risks);
              let resources = [];
              for (let r of progressFor) {
                var v = getters.filterDataForAdvancedFilter(
                  [r],
                  "filteredVehicles",
                  vehicle
                );
                if (v) {
                  resources.push(r);
                }
              }
              let progress = _.uniq(_.map(resources, "progress"));
              let ranges = f[k].map((r) => r.split("-").map(Number));
              let is_valid = false;
              for (let range of ranges) {
                let size = range[1] ? range[1] - range[0] + 1 : 1;
                is_valid =
                  _.intersection(
                    progress,
                    Array.from(Array(size), (_, i) => i + range[0])
                  ).length > 0;
                if (is_valid) break;
              }
              valid = valid && is_valid;
              break;
            }
            case "issueTypeIds": {
              var issues = vehicle.issues;
              var resources = _.filter(issues, (ti) =>
                f[k].includes(ti.issueTypeId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredVehicles",
                  vehicle
                );

              break;
            }
            case "issueSeverityIds": {
              var issues = vehicle.issues;
              var resources = _.filter(issues, (ti) =>
                f[k].includes(ti.issueSeverityId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredVehicles",
                  vehicle
                );

              break;
            }
            case "issueStageIds": {
              var issues = vehicle.issues;
              var resources = _.filter(issues, (ti) =>
                f[k].includes(ti.issueStageId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredVehicles",
                  vehicle
                );
              break;
            }
            case "taskTypeIds": {
              var tasksIssues = vehicle.tasks
                .concat(vehicle.issues)
                .concat(vehicle.risks);
              var resources = _.filter(tasksIssues, (ti) =>
                f[k].includes(ti.taskTypeId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredVehicles",
                  vehicle
                );

              break;
            }
            case "taskStageIds": {
              var tasks = vehicle.tasks;
              var resources = _.filter(tasks, (ti) =>
                f[k].includes(ti.taskStageId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredVehicles",
                  vehicle
                );
              break;
            }
            case "riskStageIds": {
              var risks = vehicle.risks;
              var resources = _.filter(risks, (ti) =>
                f[k].includes(ti.riskStageId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredVehicles",
                  vehicle
                );
              break;
            }
            case "riskPriorityLevelIds": {
              var risks = vehicle.risks;
              var resources = _.filter(risks, (ti) =>
                f[k].includes(ti.riskPriorityLevelId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredVehicles",
                  vehicle
                );
              break;
            }
            case "riskApproachFilter": {
              var risks = vehicle.risks;
              var fApproaches = _.map(f[k], "id");
              var resources = _.filter(risks, (ti) =>
                fApproaches.includes(ti.riskApproach)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredVehicles",
                  vehicle
                );
              break;
            }
            case "riskApproachFilterIds": {
              var risks = vehicle.risks;
              var fApproaches = _.map(f[k], "id");
              var resources = _.filter(risks, (ti) =>
                fApproaches.includes(ti.riskApproachId)
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredVehicles",
                  vehicle
                );
              break;
            }
            case "riskPriorityLevelFilter": {
              var risks = vehicle.risks;
              var fPriorityLevels = _.map(f[k], "id");
              var resources = _.filter(risks, (ti) =>
                fPriorityLevels.includes(ti.priorityLevelName.toLowerCase())
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredVehicles",
                  vehicle
                );
              break;
            }
            case "taskIssueUsers": {
              var taskIssues = vehicle.tasks
                .concat(vehicle.issues)
                .concat(vehicle.risks);
              var resources = _.filter(
                taskIssues,
                (ti) => _.intersection(ti.userIds, f[k]).length > 0
              );
              if (resources.length < 1) {
                valid = false;
              }
              valid =
                valid &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredVehicles",
                  vehicle
                );
              break;
            }
            case "facilityGroupIds": {
              valid =
                valid &&
                f[k].includes(vehicle.vehicleGroupId) &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredVehicles",
                  vehicle
                );
              break;
            }
            case "ids": {
              valid =
                valid &&
                f[k].includes(vehicle.project_contract_vehicle_id) &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredVehicles",
                  vehicle
                );
              break;
            }
            case "statusIds": {
              valid =
                valid &&
                f[k].includes(vehicle.statusId) &&
                getters.filterDataForAdvancedFilter(
                  resources1,
                  "filteredVehicles",
                  vehicle
                );
              break;
            }
            default: {
              valid = valid && vehicle[k] == f[k];
              break;
            }
          }
        });
        return valid;
      });
    },
    filteredFacilityGroups: (state, getters) => {
      let ids = _.map(getters.facilities, "facilityGroupId");
      return _.filter(
        getters.facilityGroups,
        (fg) => ids.includes(fg.id) && fg.status == "active"
      );
    },
    facilityCount: (state, getters) => {
      return getters.filteredFacilities("all").length;
    },
    facilityProgress: (state, getters) => {
      let mean =
        _.meanBy(getters.filteredFacilities("active"), "progress") || 0;
      return Number(mean.toFixed(2));
    },
    filterFacilitiesWithActiveFacilityGroups: (state, getters) => {
      let ids = _.map(
        _.filter(state.facilityGroups, (fg) => fg.status === "active"),
        "id"
      );
      return _.filter(
        getters.filteredFacilities("active"),
        (f) => ids.includes(f.facilityGroupId) && f.status === "active"
      );
    },
    unFilterFacilities: (state) => {
      let ids = _.map(
        _.filter(state.facilityGroups, (fg) => fg.status === "active"),
        "id"
      );
      return _.filter(
        state.facilities,
        (f) => ids.includes(f.facilityGroupId) && f.status === "active"
      );
    },
    // activeFacilityGroups: (state, getters) => (id=getters.currentProject.id) => {
    //   return _.filter(getters.facilityGroups, f => f.status === 'active' && f.projectIds.includes(id))
    // },

    activeFacilityGroups: (state, getters) => (id) => {
      return _.filter(getters.facilityGroups, (f) => f.status === "active");
    },
    getTaskIssueOverdueOptions: (state, getters) => {
      return [
        { id: "overdue", name: "overdue", value: "overdue" },
        { id: "notOverdue", name: "not overdue", value: "not overdue" },
      ];
    },

    currentTasks: (state, getters) => {
      return _.flatten(
        _.map(getters.filterFacilitiesWithActiveFacilityGroups, "tasks")
      );
    },
    currentIssues: (state, getters) => {
      return _.flatten(
        _.map(getters.filterFacilitiesWithActiveFacilityGroups, "issues")
      );
    },
    currentRisks: (state, getters) => {
      return _.flatten(
        _.map(getters.filterFacilitiesWithActiveFacilityGroups, "risks")
      );
    },
    facilityGroupFacilities: (state, getters) => (group, status = "active") => {
      return {
      projects: { 
          a: getters.filteredFacilities(status)
          .filter(f => 
              f.facilityGroupId == group.id &&
              f.projectId == getters.currentProject.id
              ).sort((a, b) => a.facilityName.localeCompare(b.facilityName)),
        },
      contracts: { 
          b: getters.filteredContracts
          .filter(f => 
              f.facilityGroup.id == group.id 
              ).sort((a, b) => a.name.localeCompare(b.name)),
         },
      vehicles: { 
          c: getters.filteredVehicles
          .filter(f => 
              f.facilityGroup.id == group.id 
              ).sort((a, b) => a.name.localeCompare(b.name)),
      }      
      }
    },
    // for gantt chart view
    ganttData: (state, getters) => {
      let hash = new Array();
      if (!getters.contentLoaded) return hash;

      // for project
      let p_id = getters.currentProject
        ? `p_${getters.currentProject.id}`
        : `p_${Vue.prototype.$preferences.projectId}`;

      let _p_id = "1";
      let p_s_date = _.min(_.map(getters.currentTasks, "startDate")) || "N/A";
      let p_e_date = _.max(_.map(getters.currentTasks, "dueDate")) || "N/A";
      let p_duration = getSimpleDate(p_e_date) - getSimpleDate(p_s_date) || 0;
      let p_progress = _.meanBy(getters.currentTasks, "progress") || 0;

      hash.push({
        id: p_id,
        _id: _p_id,
        name: getters.currentProject.name,
        duration: p_duration,
        durationInDays: `${Math.ceil(p_duration / (1000 * 3600 * 24)) ||
          0} days`,
        percent: Number(p_progress.toFixed(2)),
        start: getSimpleDate(p_s_date),
        startDate: p_s_date,
        endDate: p_e_date,
        type: "project",
      });

      // for facility_groups
      let groups = _.groupBy(
        getters.filterFacilitiesWithActiveFacilityGroups,
        "facilityGroupName"
      );
      let group_count = 1;
      for (let group in groups) {
        let _fg_id = _p_id + "." + group_count;
        let fg_id = `${p_id}_fg_${group}`.replace(/ /i, "_");
        let fg_tasks = _.flatten(_.map(groups[group], "tasks"));
        let fg_s_date = _.min(_.map(fg_tasks, "startDate")) || "N/A";
        let fg_e_date = _.max(_.map(fg_tasks, "dueDate")) || "N/A";
        let fg_duration =
          getSimpleDate(fg_e_date) - getSimpleDate(fg_s_date) || 0;
        let fg_progress = _.meanBy(fg_tasks, "progress") || 0;

        hash.push({
          id: fg_id,
          _id: _fg_id,
          parentId: p_id,
          name: group,
          duration: fg_duration,
          durationInDays: `${Math.ceil(fg_duration / (1000 * 3600 * 24)) ||
            0} days`,
          percent: Number(fg_progress.toFixed(2)),
          start: getSimpleDate(fg_s_date),
          startDate: fg_s_date,
          endDate: fg_e_date,
          type: "milestone",
        });

        let f_read =
          Vue.prototype.$topNavigationPermissions.gantt_view["read"] || false;
        // for facilities under facility_groups
        let facility_count = 1;
        for (let facility of groups[group]) {
          let f_id = f_read ? `${fg_id}_f_${facility.id}` : fg_id;
          let _f_id = _fg_id + "." + facility_count;
          let f_s_date = _.min(_.map(facility.tasks, "startDate")) || "N/A";
          let f_e_date = _.max(_.map(facility.tasks, "dueDate")) || "N/A";
          let f_duration =
            getSimpleDate(f_e_date) - getSimpleDate(f_s_date) || 0;
          let f_progress = _.meanBy(facility.tasks, "progress") || 0;

          hash.push({
            id: f_id,
            _id: _f_id,
            parentId: fg_id,
            name: facility.facility.facilityName,
            duration: f_duration,
            durationInDays: `${Math.ceil(f_duration / (1000 * 3600 * 24)) ||
              0} days`,
            percent: Number(f_progress.toFixed(2)),
            start: getSimpleDate(f_s_date),
            startDate: f_s_date,
            endDate: f_e_date,
            type: "milestone",
          });

          if (f_read) {
            // for task_types under facilities
            let types = _.groupBy(facility.tasks, "taskType");
            let filteredTaskTypes = _.map(getters.taskTypeFilter, "name");
            let types_count = 1;
            for (let type in types) {
              if (
                filteredTaskTypes.length > 0 &&
                !filteredTaskTypes.includes(type)
              )
                continue;
              let tasks = types[type];
              let tt_id = `${f_id}_tt_${type}`.replace(/ /i, "_");
              let _tt_id = _f_id + "." + types_count;
              let tt_s_date = _.min(_.map(tasks, "startDate"));
              let tt_e_date = _.max(_.map(tasks, "dueDate"));
              let tt_duration =
                getSimpleDate(tt_e_date) - getSimpleDate(tt_s_date);
              let tt_progress = _.meanBy(tasks, "progress");

              hash.push({
                id: tt_id,
                _id: _tt_id,
                parentId: f_id,
                name: type,
                duration: tt_duration,
                durationInDays: `${Math.ceil(
                  tt_duration / (1000 * 3600 * 24)
                )} days`,
                percent: Number(tt_progress.toFixed(2)),
                start: getSimpleDate(tt_s_date),
                startDate: tt_s_date,
                endDate: tt_e_date,
                type: "milestone",
              });

              let ranges = getters.taskProgressFilter
                ? _.map(getters.taskProgressFilter, "value").map((r) =>
                    r.split("-").map(Number)
                  )
                : false;
              let stages =
                getters.taskStageFilter && getters.taskStageFilter.length
                  ? _.map(getters.taskStageFilter, "id")
                  : [];

              // for tasks under task_types
              let task_count = 1;
              for (let task of tasks) {
                if (stages.length > 0 && !stages.includes(task.taskStageId))
                  continue;
                if (_.map(getters.myActionsFilter, "value").includes("tasks")) {
                  let userIds = [
                    ..._.map(task.checklists, "userId"),
                    ...task.userIds,
                  ];
                  if (!userIds.includes(Vue.prototype.$currentUser.id))
                    continue;
                }
                if (ranges && ranges.length > 0) {
                  let is_valid = false;
                  for (let range of ranges) {
                    is_valid =
                      range[1] !== undefined
                        ? range[0] <= task.progress && range[1] >= task.progress
                        : task.progress == range[0];
                    if (is_valid) break;
                  }
                  if (!is_valid) continue;
                }
                let t_id = `${tt_id}_t_${task.id}`;
                let _t_id = _tt_id + "." + task_count;
                let t_duration =
                  getSimpleDate(task.dueDate) - getSimpleDate(task.startDate);

                hash.push({
                  taskUrl: `${API_BASE_PATH}/programs/${getters.currentProject.id}/projects/${facility.facility.id}/tasks/${task.id}`,
                  facilityId: facility.id,
                  projectId: getters.currentProject.id,
                  id: t_id,
                  _id: _t_id,
                  parentId: tt_id,
                  name: task.text,
                  duration: t_duration,
                  durationInDays: `${Math.ceil(
                    t_duration / (1000 * 3600 * 24)
                  )} days`,
                  percent: Number(task.progress.toFixed(2)),
                  start: getSimpleDate(task.startDate),
                  startDate: task.startDate,
                  endDate: task.dueDate,
                  _users: task.users.map((_u) => _u.fullName).join(","),
                  type: "task",
                  collapsed: true,
                });

                // for checklists under tasks
                let checklist_count = 1;
                for (let checklist of task.checklists) {
                  if (
                    _.map(getters.myActionsFilter, "value").includes("tasks") &&
                    checklist.userId !== Vue.prototype.$currentUser.id
                  )
                    continue;
                  let c_id = `${t_id}_t_${checklist.id}`;
                  let _c_id = _t_id + "." + checklist_count;
                  hash.push({
                    id: c_id,
                    _id: _c_id,
                    parentId: t_id,
                    name: checklist.text,
                    dueDate: checklist.dueDate,
                    duration: t_duration,
                    durationInDays: `${Math.ceil(
                      t_duration / (1000 * 3600 * 24)
                    )} days`,
                    percent: checklist.checked ? 100 : 0,
                    start: getSimpleDate(task.startDate),
                    startDate: task.startDate,
                    endDate: task.dueDate,
                    type: "task",
                    dependentOn: [t_id],
                    _users: checklist.user ? [checklist.user.fullName] : null,
                  });
                  checklist_count++;
                }
                task_count++;
              }
              types_count++;
            }
          }
          facility_count++;
        }
        group_count++;
      }

      return hash;
    },
    filteredAllTasks: (state, getters) => {
      let ids =
        getters.taskTypeFilter && getters.taskTypeFilter.length
          ? _.map(getters.taskTypeFilter, "id")
          : [];
      let stages =
        getters.taskStageFilter && getters.taskStageFilter.length
          ? _.map(getters.taskStageFilter, "id")
          : [];
      let taskIssueDueDates = getters.taskIssueDueDateFilter;
      let taskIssueOverdue = getters.taskIssueOverdueFilter;

      return _.filter(
        _.flatten(_.map(getters.filteredFacilities("active"), "tasks")),
        (t) => {
          let valid = true;
          if (ids.length > 0) valid = valid && ids.includes(t.taskTypeId);
          if (stages.length > 0)
            valid = valid && stages.includes(t.taskStageId);

          if (
            taskIssueDueDates &&
            taskIssueDueDates[0] &&
            taskIssueDueDates[1]
          ) {
            var startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD");
            var endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD");

            var is_valid = true;
            var nDate = moment(t.dueDate, "YYYY-MM-DD");
            is_valid = nDate.isBetween(startDate, endDate, "days", true);
            valid = is_valid;
          }
          if (
            taskIssueOverdue &&
            taskIssueOverdue[0] &&
            taskIssueOverdue[0].name == "overdue"
          ) {
            valid = t.isOverdue == true;
          }

          if (
            taskIssueOverdue &&
            taskIssueOverdue[0] &&
            taskIssueOverdue[0].id == "notOverdue"
          ) {
            valid = t.isOverdue == false;
          }

          return valid;
        }
      );
    },
    filteredAllContractTasks: (state, getters) => {
      let ids =
        getters.taskTypeFilter && getters.taskTypeFilter.length
          ? _.map(getters.taskTypeFilter, "id")
          : [];
      let stages =
        getters.taskStageFilter && getters.taskStageFilter.length
          ? _.map(getters.taskStageFilter, "id")
          : [];
      let taskIssueDueDates = getters.taskIssueDueDateFilter;
      let taskIssueOverdue = getters.taskIssueOverdueFilter;

      return _.filter(
        _.flatten(_.map(getters.filteredContracts, "tasks")),
        (t) => {
          let valid = true;
          if (ids.length > 0) valid = valid && ids.includes(t.taskTypeId);
          if (stages.length > 0)
            valid = valid && stages.includes(t.taskStageId);

          if (
            taskIssueDueDates &&
            taskIssueDueDates[0] &&
            taskIssueDueDates[1]
          ) {
            var startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD");
            var endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD");

            var is_valid = true;
            var nDate = moment(t.dueDate, "YYYY-MM-DD");
            is_valid = nDate.isBetween(startDate, endDate, "days", true);
            valid = is_valid;
          }
          if (
            taskIssueOverdue &&
            taskIssueOverdue[0] &&
            taskIssueOverdue[0].name == "overdue"
          ) {
            valid = t.isOverdue == true;
          }

          if (
            taskIssueOverdue &&
            taskIssueOverdue[0] &&
            taskIssueOverdue[0].id == "notOverdue"
          ) {
            valid = t.isOverdue == false;
          }

          return valid;
        }
      );
    },
    filteredAllVehicleTasks: (state, getters) => {
      let ids =
        getters.taskTypeFilter && getters.taskTypeFilter.length
          ? _.map(getters.taskTypeFilter, "id")
          : [];
      let stages =
        getters.taskStageFilter && getters.taskStageFilter.length
          ? _.map(getters.taskStageFilter, "id")
          : [];
      let taskIssueDueDates = getters.taskIssueDueDateFilter;
      let taskIssueOverdue = getters.taskIssueOverdueFilter;

      return _.filter(
        _.flatten(_.map(getters.filteredVehicles, "tasks")),
        (t) => {
          let valid = true;
          if (ids.length > 0) valid = valid && ids.includes(t.taskTypeId);
          if (stages.length > 0)
            valid = valid && stages.includes(t.taskStageId);

          if (
            taskIssueDueDates &&
            taskIssueDueDates[0] &&
            taskIssueDueDates[1]
          ) {
            var startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD");
            var endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD");

            var is_valid = true;
            var nDate = moment(t.dueDate, "YYYY-MM-DD");
            is_valid = nDate.isBetween(startDate, endDate, "days", true);
            valid = is_valid;
          }
          if (
            taskIssueOverdue &&
            taskIssueOverdue[0] &&
            taskIssueOverdue[0].name == "overdue"
          ) {
            valid = t.isOverdue == true;
          }

          if (
            taskIssueOverdue &&
            taskIssueOverdue[0] &&
            taskIssueOverdue[0].id == "notOverdue"
          ) {
            valid = t.isOverdue == false;
          }

          return valid;
        }
      );
    },
    filteredAllIssues: (state, getters) => {
      let taskTypeIds =
        getters.taskTypeFilter && getters.taskTypeFilter.length
          ? _.map(getters.taskTypeFilter, "id")
          : [];
      let ids =
        getters.issueTypeFilter && getters.issueTypeFilter.length
          ? _.map(getters.issueTypeFilter, "id")
          : [];
      let stages =
        getters.issueStageFilter && getters.issueStageFilter.length
          ? _.map(getters.issueStageFilter, "id")
          : [];
      let severities =
        getters.issueSeverityFilter && getters.issueSeverityFilter.length
          ? _.map(getters.issueSeverityFilter, "id")
          : [];
      let taskIssueDueDates = getters.taskIssueDueDateFilter;
      let taskIssueOverdue = getters.taskIssueOverdueFilter;

      return _.filter(
        _.flatten(_.map(getters.filteredFacilities("active"), "issues")),
        (t) => {
          let valid = true;
          if (ids.length > 0) valid = valid && ids.includes(t.issueTypeId);
          if (taskTypeIds.length > 0)
            valid = valid && taskTypeIds.includes(t.taskTypeId);
          if (stages.length > 0)
            valid = valid && stages.includes(t.issueStageId);
          if (severities.length > 0)
            valid = valid && severities.includes(t.issueSeverityId);

          if (
            taskIssueDueDates &&
            taskIssueDueDates[0] &&
            taskIssueDueDates[1]
          ) {
            var startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD");
            var endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD");

            var is_valid = true;
            var nDate = moment(t.dueDate, "YYYY-MM-DD");
            is_valid = nDate.isBetween(startDate, endDate, "days", true);
            valid = is_valid;
          }

          if (
            taskIssueOverdue &&
            taskIssueOverdue[0] &&
            taskIssueOverdue[0].id == "overdue"
          ) {
            valid = t.isOverdue == true;
          }

          if (
            taskIssueOverdue &&
            taskIssueOverdue[0] &&
            taskIssueOverdue[0].id == "notOverdue"
          ) {
            valid = t.isOverdue == false;
          }

          // if(taskIssueRiskDraft && taskIssueRiskDraft[0] && taskIssueRiskDraft[0].id == "draft"){
          //   valid = (t.draft == true)
          // }

          // if(taskIssueRiskOnHold && taskIssueRiskOnHold[0] && taskIssueRiskOnHold[0].id == "onHold"){
          //   valid = (t.onHold == true)
          // }

          return valid;
        }
      );
    },
    filteredAllContractIssues: (state, getters) => {
      let taskTypeIds =
        getters.taskTypeFilter && getters.taskTypeFilter.length
          ? _.map(getters.taskTypeFilter, "id")
          : [];
      let ids =
        getters.issueTypeFilter && getters.issueTypeFilter.length
          ? _.map(getters.issueTypeFilter, "id")
          : [];
      let stages =
        getters.issueStageFilter && getters.issueStageFilter.length
          ? _.map(getters.issueStageFilter, "id")
          : [];
      let severities =
        getters.issueSeverityFilter && getters.issueSeverityFilter.length
          ? _.map(getters.issueSeverityFilter, "id")
          : [];
      let taskIssueDueDates = getters.taskIssueDueDateFilter;
      let taskIssueOverdue = getters.taskIssueOverdueFilter;

      return _.filter(
        _.flatten(_.map(getters.filteredContracts, "issues")),
        (t) => {
          let valid = true;
          if (ids.length > 0) valid = valid && ids.includes(t.issueTypeId);
          if (taskTypeIds.length > 0)
            valid = valid && taskTypeIds.includes(t.taskTypeId);
          if (stages.length > 0)
            valid = valid && stages.includes(t.issueStageId);
          if (severities.length > 0)
            valid = valid && severities.includes(t.issueSeverityId);

          if (
            taskIssueDueDates &&
            taskIssueDueDates[0] &&
            taskIssueDueDates[1]
          ) {
            var startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD");
            var endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD");

            var is_valid = true;
            var nDate = moment(t.dueDate, "YYYY-MM-DD");
            is_valid = nDate.isBetween(startDate, endDate, "days", true);
            valid = is_valid;
          }

          if (
            taskIssueOverdue &&
            taskIssueOverdue[0] &&
            taskIssueOverdue[0].id == "overdue"
          ) {
            valid = t.isOverdue == true;
          }

          if (
            taskIssueOverdue &&
            taskIssueOverdue[0] &&
            taskIssueOverdue[0].id == "notOverdue"
          ) {
            valid = t.isOverdue == false;
          }

          // if(taskIssueRiskDraft && taskIssueRiskDraft[0] && taskIssueRiskDraft[0].id == "draft"){
          //   valid = (t.draft == true)
          // }

          // if(taskIssueRiskOnHold && taskIssueRiskOnHold[0] && taskIssueRiskOnHold[0].id == "onHold"){
          //   valid = (t.onHold == true)
          // }

          return valid;
        }
      );
    },
    filteredAllVehicleIssues: (state, getters) => {
      let taskTypeIds =
        getters.taskTypeFilter && getters.taskTypeFilter.length
          ? _.map(getters.taskTypeFilter, "id")
          : [];
      let ids =
        getters.issueTypeFilter && getters.issueTypeFilter.length
          ? _.map(getters.issueTypeFilter, "id")
          : [];
      let stages =
        getters.issueStageFilter && getters.issueStageFilter.length
          ? _.map(getters.issueStageFilter, "id")
          : [];
      let severities =
        getters.issueSeverityFilter && getters.issueSeverityFilter.length
          ? _.map(getters.issueSeverityFilter, "id")
          : [];
      let taskIssueDueDates = getters.taskIssueDueDateFilter;
      let taskIssueOverdue = getters.taskIssueOverdueFilter;

      return _.filter(
        _.flatten(_.map(getters.filteredVehicles, "issues")),
        (t) => {
          let valid = true;
          if (ids.length > 0) valid = valid && ids.includes(t.issueTypeId);
          if (taskTypeIds.length > 0)
            valid = valid && taskTypeIds.includes(t.taskTypeId);
          if (stages.length > 0)
            valid = valid && stages.includes(t.issueStageId);
          if (severities.length > 0)
            valid = valid && severities.includes(t.issueSeverityId);

          if (
            taskIssueDueDates &&
            taskIssueDueDates[0] &&
            taskIssueDueDates[1]
          ) {
            var startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD");
            var endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD");

            var is_valid = true;
            var nDate = moment(t.dueDate, "YYYY-MM-DD");
            is_valid = nDate.isBetween(startDate, endDate, "days", true);
            valid = is_valid;
          }

          if (
            taskIssueOverdue &&
            taskIssueOverdue[0] &&
            taskIssueOverdue[0].id == "overdue"
          ) {
            valid = t.isOverdue == true;
          }

          if (
            taskIssueOverdue &&
            taskIssueOverdue[0] &&
            taskIssueOverdue[0].id == "notOverdue"
          ) {
            valid = t.isOverdue == false;
          }
          return valid;
        }
      );
    },    
    filteredAllRisks: (state, getters) => {
      let taskTypeIds =
        getters.taskTypeFilter && getters.taskTypeFilter.length
          ? _.map(getters.taskTypeFilter, "id")
          : [];
      let approaches =
        getters.riskApproachFilter && getters.riskApproachFilter.length
          ? _.map(getters.riskApproachFilter, "id")
          : [];
      let stages =
        getters.riskStageFilter && getters.riskStageFilter.length
          ? _.map(getters.riskStageFilter, "id")
          : [];
      let riskPriorityLevels =
        getters.riskPriorityLevelFilter &&
        getters.riskPriorityLevelFilter.length
          ? _.map(getters.riskPriorityLevelFilter, "id")
          : [];
      let taskIssueDueDates = getters.taskIssueDueDateFilter;
      let taskIssueOverdue = getters.taskIssueOverdueFilter;

      return _.filter(
        _.flatten(_.map(getters.filteredFacilities("active"), "risks")),
        (t) => {
          let valid = true;
          if (approaches.length > 0)
            valid = valid && approaches.includes(t.riskApproachFilterIds);
          if (taskTypeIds.length > 0)
            valid = valid && taskTypeIds.includes(t.taskTypeId);
          if (stages.length > 0)
            valid = valid && stages.includes(t.riskStageId);
          if (riskPriorityLevels.length > 0)
            valid =
              valid && riskPriorityLevels.includes(t.riskPriorityLevelIds);

          if (
            taskIssueDueDates &&
            taskIssueDueDates[0] &&
            taskIssueDueDates[1]
          ) {
            var startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD");
            var endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD");

            var is_valid = true;
            var nDate = moment(t.dueDate, "YYYY-MM-DD");
            is_valid = nDate.isBetween(startDate, endDate, "days", true);
            valid = is_valid;
          }

          if (
            taskIssueOverdue &&
            taskIssueOverdue[0] &&
            taskIssueOverdue[0].id == "overdue"
          ) {
            valid = t.isOverdue == true;
          }

          if (
            taskIssueOverdue &&
            taskIssueOverdue[0] &&
            taskIssueOverdue[0].id == "notOverdue"
          ) {
            valid = t.isOverdue == false;
          }

          // if(taskIssueRiskDraft && taskIssueRiskDraft[0] && taskIssueRiskDraft[0].id == "draft"){
          //   valid = (t.draft == true)
          // }

          // if(taskIssueRiskOnHold && taskIssueRiskOnHold[0] && taskIssueRiskOnHold[0].id == "onHold"){
          //   valid = (t.onHold == true)
          // }

          return valid;
        }
      );
    },
    filteredAllContractRisks: (state, getters) => {
      let taskTypeIds =
        getters.taskTypeFilter && getters.taskTypeFilter.length
          ? _.map(getters.taskTypeFilter, "id")
          : [];
      let approaches =
        getters.riskApproachFilter && getters.riskApproachFilter.length
          ? _.map(getters.riskApproachFilter, "id")
          : [];
      let stages =
        getters.riskStageFilter && getters.riskStageFilter.length
          ? _.map(getters.riskStageFilter, "id")
          : [];
      let riskPriorityLevels =
        getters.riskPriorityLevelFilter &&
        getters.riskPriorityLevelFilter.length
          ? _.map(getters.riskPriorityLevelFilter, "id")
          : [];
      let taskIssueDueDates = getters.taskIssueDueDateFilter;
      let taskIssueOverdue = getters.taskIssueOverdueFilter;

      return _.filter(
        _.flatten(_.map(getters.filteredContracts, "risks")),
        (t) => {
          let valid = true;
          if (approaches.length > 0)
            valid = valid && approaches.includes(t.riskApproachFilterIds);
          if (taskTypeIds.length > 0)
            valid = valid && taskTypeIds.includes(t.taskTypeId);
          if (stages.length > 0)
            valid = valid && stages.includes(t.riskStageId);
          if (riskPriorityLevels.length > 0)
            valid =
              valid && riskPriorityLevels.includes(t.riskPriorityLevelIds);

          if (
            taskIssueDueDates &&
            taskIssueDueDates[0] &&
            taskIssueDueDates[1]
          ) {
            var startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD");
            var endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD");

            var is_valid = true;
            var nDate = moment(t.dueDate, "YYYY-MM-DD");
            is_valid = nDate.isBetween(startDate, endDate, "days", true);
            valid = is_valid;
          }

          if (
            taskIssueOverdue &&
            taskIssueOverdue[0] &&
            taskIssueOverdue[0].id == "overdue"
          ) {
            valid = t.isOverdue == true;
          }

          if (
            taskIssueOverdue &&
            taskIssueOverdue[0] &&
            taskIssueOverdue[0].id == "notOverdue"
          ) {
            valid = t.isOverdue == false;
          }
          return valid;
        }
      );
    },
    filteredAllVehicleRisks: (state, getters) => {
      let taskTypeIds =
        getters.taskTypeFilter && getters.taskTypeFilter.length
          ? _.map(getters.taskTypeFilter, "id")
          : [];
      let approaches =
        getters.riskApproachFilter && getters.riskApproachFilter.length
          ? _.map(getters.riskApproachFilter, "id")
          : [];
      let stages =
        getters.riskStageFilter && getters.riskStageFilter.length
          ? _.map(getters.riskStageFilter, "id")
          : [];
      let riskPriorityLevels =
        getters.riskPriorityLevelFilter &&
        getters.riskPriorityLevelFilter.length
          ? _.map(getters.riskPriorityLevelFilter, "id")
          : [];
      let taskIssueDueDates = getters.taskIssueDueDateFilter;
      let taskIssueOverdue = getters.taskIssueOverdueFilter;

      return _.filter(
        _.flatten(_.map(getters.filteredVehicles, "risks")),
        (t) => {
          let valid = true;
          if (approaches.length > 0)
            valid = valid && approaches.includes(t.riskApproachFilterIds);
          if (taskTypeIds.length > 0)
            valid = valid && taskTypeIds.includes(t.taskTypeId);
          if (stages.length > 0)
            valid = valid && stages.includes(t.riskStageId);
          if (riskPriorityLevels.length > 0)
            valid =
              valid && riskPriorityLevels.includes(t.riskPriorityLevelIds);

          if (
            taskIssueDueDates &&
            taskIssueDueDates[0] &&
            taskIssueDueDates[1]
          ) {
            var startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD");
            var endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD");

            var is_valid = true;
            var nDate = moment(t.dueDate, "YYYY-MM-DD");
            is_valid = nDate.isBetween(startDate, endDate, "days", true);
            valid = is_valid;
          }

          if (
            taskIssueOverdue &&
            taskIssueOverdue[0] &&
            taskIssueOverdue[0].id == "overdue"
          ) {
            valid = t.isOverdue == true;
          }

          if (
            taskIssueOverdue &&
            taskIssueOverdue[0] &&
            taskIssueOverdue[0].id == "notOverdue"
          ) {
            valid = t.isOverdue == false;
          }
          return valid;
        }
      );
    },
    on_watched: (state, getters) => {
      let tasks = _.filter(getters.filteredAllTasks, (t) => t.watched);
      let issues = _.filter(getters.filteredAllIssues, (t) => t.watched);
      let risks = _.filter(getters.filteredAllRisks, (t) => t.watched);
      let ids = [
        ..._.map(issues, "facilityId"),
        ..._.map(tasks, "facilityId"),
        ..._.map(risks, "facilityId"),
      ];
      let facilities = _.filter(getters.filteredFacilities("active"), (t) =>
        ids.includes(t.id)
      );

      return { tasks, issues, risks, facilities };
    },
    approved_risks: (state, getters) => {
      let risks = _.filter(getters.filteredAllRisks, (t) => t.approved);
      let ids = [..._.map(risks, "facilityId")];
      let facilities = _.filter(getters.filteredFacilities("active"), (t) =>
        ids.includes(t.id)
      );
      return { risks, facilities };
    },
    viewPermit: () => (view, req) => {
      if (Vue.prototype.$currentUser.role === "superadmin") return true;
      return Vue.prototype.$permissions[view][req];
    },
    riskApproaches: () => {
      return ["avoid", "mitigate", "transfer", "accept"];
    },
    // riskDispositionStatuses: () => {
    //   return   ['monitoring', 'resolved', 'closed']
    // },
    // riskDispositionDuration: () => {
    //   return   ['temporary', 'perpetual']

    // },
    probabilityNames: () => {
      return [
        { id: 1, value: 1, name: "1 - Rare" },
        { id: 2, value: 2, name: "2 - Unlikely" },
        { id: 3, value: 3, name: "3 - Possible" },
        { id: 4, value: 4, name: "4 - Likely" },
        { id: 5, value: 5, name: "5 - Almost Certain" },
        // {value: 1, name: "1 - Rare"}, "2 - Unlikely", "3 - Possible", "4 - Likely", "5 - Almost Certain"
      ];
    },
    impactLevelNames: () => {
      return [
        "1 - Negligible",
        "2 - Minor",
        "3 - Moderate",
        "4 - Major",
        "5 - Catastrophic",
      ];
    },
    getMapZoomFilter: (state) => state.mapZoomFilter,
    getUnfilteredFacilities: (state) => state.unfilteredFacilities,
    getPreviousRoute: (state) => state.previousRoute,
    getNewSession: (state) => state.newSession,
  },

  actions: {
    fetchFacilities({ commit, dispatch }, id) {
      return new Promise((resolve, reject) => {
        http
          .get(`${API_BASE_PATH}/programs/${id}/projects.json`)
          .then((res) => {
            let facilities = res.data.facilities;
            // for (let facility of res.data.facilities) {
            //   facilities.push({...facility, ...facility.facility})
            // }
            commit("setFacilities", facilities);
            commit("setProjectsLoaded", true);
            resolve();
            
          })
          .catch((err) => {
            console.error(err);
            reject();
          });
      });
    },
    fetchProjectContracts({ commit, dispatch }, id) {
      return new Promise((resolve, reject) => {
        http
          .get(`${API_BASE_PATH}/program_settings/contracts?project_id=${id}`)
          .then((res) => {
            let contracts = [];
            for (let c of res.data.contracts) {
              contracts.push({ ...c, ...c });
            }           
            commit("setContracts", contracts);
            resolve();
          })
          .catch((err) => {
            console.error(err);
            reject();
          });
      });
    },
    fetchProjectVehicles({ commit, dispatch }, id) {
      return new Promise((resolve, reject) => {
        http
          .get(`${API_BASE_PATH}/program_settings/contract_vehicles?project_id=${id}`)
          .then((res) => {
            console.log(res)
            let vehicles = [];
            for (let v of res.data.contract_vehicles) {
              vehicles.push({ ...v, ...v });
            }           
            commit("setVehicles", vehicles);
            resolve();
          })
          .catch((err) => {
            console.error(err);
            reject();
          });
      });
    },
    fetchCurrentProject({ commit, dispatch }, id) {
      let spaths = window.location.pathname.split("/")
      let url = `${API_BASE_PATH}/programs/${id}.json`
      if(spaths.length > 0){
        if(spaths.indexOf("settings") > 0){
          url = `${API_BASE_PATH}/program_settings/programs/${id}.json`
        }
      }
      return new Promise((resolve, reject) => {
        http
          .get(url)
          .then((res) => {
            let facilities = [];
            for (let facility of res.data.project.facilities) {
              facilities.push({ ...facility, ...facility.facility });
            }
            let contracts = [];
            for (let c of res.data.project.contracts) {
              contracts.push({ ...c, ...c });
            }
            let vehicles = [];
            for (let v of res.data.project.contractVehicles) {
              vehicles.push({ ...v, ...v });
            }
            commit("setFacilities", facilities);
            commit("setContracts", contracts);
            commit("setVehicles", vehicles);
            commit("setCurrentProject", res.data.project);
            commit("setFacilityGroups", res.data.project.facilityGroups);
            commit("setProjectUsers", res.data.project.users);
            commit("setAccountableUsers", res.data.project.accountableUsers);
            commit("setConsultedUsers", res.data.project.consulted);
            commit("setInformedUsers", res.data.project.informed);
            commit("setStatuses", res.data.project.statuses);
            commit("setTaskTypes", res.data.project.taskTypes);
            commit("setTaskStages", res.data.project.taskStages);
            commit("setRiskStages", res.data.project.riskStages);
            commit("setIssueStages", res.data.project.issueStages);
            commit("setIssueTypes", res.data.project.issueTypes);
            commit("setIssueSeverities", res.data.project.issueSeverities);
            commit("SET_LESSON_STAGES", res.data.project.lessonStages);
            resolve();
          })
          .catch((err) => {
            console.error(err);
            reject();
          });
      });
    },
    fetchProjectNames({ commit, dispatch }, id) {
      return new Promise((resolve, reject) => {
        http
          .get(`${API_BASE_PATH}/programs/${id}.json`)
          .then((res) => {
            let facilities = [];
            for (let facility of res.data.project.facilities) {
              facilities.push({ ...facility, ...facility.facility });
            }
            commit("setTableData", facilities);
           
            // console.log(facilities)
            resolve();
          })
          .catch((err) => {
            console.error(err);
            reject();
          }) .finally(() => {
            commit("setContentLoaded", true);
          });
      });
    },
    

    fetchFacility({ commit, dispatch, getters }, { projectId, facilityId }) {
      return new Promise((resolve, reject) => {
        http
          .get(
            `${API_BASE_PATH}/programs/${projectId}/projects/${facilityId}.json`
          )
          .then((res) => {
            let facility = Object.assign(
              {},
              { ...res.data.facility, ...res.data.facility.facility }
            );
            let index = getters.facilities.findIndex(
              (f) => f.id == facility.id
            );
            if (index > -1) commit("updateFacilities", { index, facility });
            return resolve(facility);
          })
          .catch((err) => {
            console.error(err);
            reject(err);
          });
      });
    },
    fetchProjects({ commit }) {
      return new Promise((resolve, reject) => {
        http
          .get(`${API_BASE_PATH}/projects.json`)
          .then((res) => {
            commit("setProjects", res.data.projects);
            resolve();
          })
          .catch((err) => {
            console.error(err);
            reject();
          });
      });
    },
    fetchFacilityGroups({ commit }, id) {
      let url = `${API_BASE_PATH}/facility_groups.json`;
      if (id !== undefined) url = url + `?=project_id=${id}`;
      return new Promise((resolve, reject) => {
        http
          .get(url)
          .then((res) => {
            commit("setFacilityGroups", res.data.facilityGroups);
            // console.log(res.data.facilityGroups)
            resolve();
          })
          .catch((err) => {
            console.error(err);
            reject();
          });
      });
    },

    async fetchDashboardData({ dispatch, commit }, { id, cb }) {
      // await dispatch('fetchProjects')
      await dispatch("fetchCurrentProject", id);
      commit("setContentLoaded", true);
      // commit('setToggleRACI', false)
      if (cb) return cb();
    },

    async taskUpdated({ dispatch }, { projectId, facilityId, cb }) {
      return new Promise(async (resolve, reject) => {
        let facility = await dispatch("fetchFacility", {
          projectId,
          facilityId,
        });
        if (cb) cb();
        if (facility instanceof Error) return reject(facility);
        return resolve(facility);
      });
    },

    // store actions watch_view
    updateWatchedTasks({ commit }, task) {
      return new Promise((resolve, reject) => {
        http
          .put(
            `${API_BASE_PATH}/programs/${task.projectId}/projects/${task.facilityId}/tasks/${task.id}.json`,
            { task: task }
          )
          .then((res) => {
            commit("updateTasksHash", { task: res.data.task });
            MessageDialogService.showDialog({
              response: res
            });
            resolve();
          })
          .catch((err) => {
            console.error(err);
            reject();
          });
      });
    },
    updateWatchedIssues({ commit }, issue) {
      return new Promise((resolve, reject) => {
        http
          .put(
            `${API_BASE_PATH}/programs/${issue.projectId}/projects/${issue.facilityId}/issues/${issue.id}.json`,
            { issue: issue }
          )
          .then((res) => {
            commit("updateIssuesHash", { issue: res.data.issue });
            MessageDialogService.showDialog({
              response: res
            });
            resolve();
          })
          .catch((err) => {
            console.error(err);
            reject();
          });
      });
    },
    updateWatchedRisks({ commit }, risk) {
      return new Promise((resolve, reject) => {
        http
          .put(
            `${API_BASE_PATH}/programs/${risk.projectId}/projects/${risk.facilityId}/risks/${risk.id}.json`,
            { risk: risk }
          )
          .then((res) => {
            commit("updateRisksHash", { risk: res.data.risk });
            MessageDialogService.showDialog({
              response: res
            });
            resolve();
          })
          .catch((err) => {
            console.error(err);
            reject();
          });
      });
    },
    updateApprovedRisks({ commit }, risk) {
      return new Promise((resolve, reject) => {
        http
          .put(
            `${API_BASE_PATH}/programs/${risk.projectId}/projects/${risk.facilityId}/risks/${risk.id}.json`,
            { risk: risk }
          )
          .then((res) => {
            commit("updateRisksHash", { risk: res.data.risk });
            MessageDialogService.showDialog({
              response: res
            });
            resolve();
          })
          .catch((err) => {
            console.error(err);
            reject();
          });
      });
    },
    // update_from_kanban_view
    updateKanbanTaskIssues(
      { commit, getters },
      { projectId, facilityId, data, type }
    ) {
      return new Promise((resolve, reject) => {
        http
          .post(
            `${API_BASE_PATH}/programs/${projectId}/projects/${facilityId}/${type}/batch_update.json`,
            data
          )
          .then((res) => {
            let facility = Object.assign(
              {},
              { ...res.data, ...res.data.facility }
            );
            let index = getters.facilities.findIndex(
              (f) => f.id == facility.id
            );
            if (index > -1) commit("updateFacilities", { index, facility });
            MessageDialogService.showDialog({
              response: res
            });
            return resolve(res);
          })
          .catch((err) => {
            console.error(err);
            reject();
          });
      });
    },
    // contractTaskDeleted({ commit }, { task}) {
    //    let pCid = task.projectContractId
      
    //   return new Promise((resolve, reject) => {
    //     http
    //       .delete(
    //         `${API_BASE_PATH}/project_contracts/${pCid}/tasks/${task.id}.json`
    //       )
    //       .then((res) => {          
    //         commit("updateContractTasks", { task: task, action: "delete" });                   
    //         resolve("Success");
    //       })
    //       .catch((err) => {
    //         console.log("Error",err);
    //         reject();
    //       });
    //   });
    // },

  taskDeleted({ commit }, { task, programId }) {
      let deleteUrl = `programs/${programId}/projects/${task.facilityId}/tasks/${task.id}.json`   
      if(task.projectContractId){
         let pcid = task.projectContractId
         deleteUrl = `/project_contracts/${pcid}/tasks/${task.id}.json`
      } 
      if(task.projectContractVehicleId){
        let pcid = task.projectContractVehicleId
        deleteUrl = `/project_contract_vehicles/${pcid}/tasks/${task.id}.json`
      } 
      return new Promise((resolve, reject) => {
        http
          .delete(
            `${API_BASE_PATH}/${deleteUrl}`
          )
          .then((res) => {
            if (task.facilityId){
              commit("updateTasksHash", { task: task, action: "delete" });
            } 
            if (task.projectContractVehicleId){
              commit("updateVehicleTasks", { task: task, action: "delete" });
            } 
            if (task.projectContractId)  {
              commit("updateContractTasks", { task: task, action: "delete" });
            }
            MessageDialogService.showDialog({
              response: res
            });            
            resolve("Success");
          })
          .catch((err) => {
            console.log("Error",err);
            reject();
          });
      });
    },
    noteDeleted({ commit }, { note, projectId, facilityId, cb }) {
      let deleteUrl = `programs/${projectId}/projects/${facilityId}/notes/${note.id}.json`   
        if(note.projectContractId){
          let pcid = note.projectContractId
          deleteUrl = `/project_contracts/${pcid}/notes/${note.id}.json`
        } 
      return new Promise((resolve, reject) => {
        http
          .delete(
            `${API_BASE_PATH}/${deleteUrl}`
          )
          .then((res) => {
            if (note.facilityProjectId){
              commit("updateNotesHash", {
                note: note,
                facilityId,
                action: "delete",
              });
            } else   {
              commit("updateContractNotes", { note: note, action: "delete" });
            }            
            if (cb) cb();
            MessageDialogService.showDialog({
              response: res
            });
            resolve();
          })
          .catch((err) => {
            console.log("Error",err);
            reject();
          });
      });
    },
    issueDeleted({ commit }, { issue, programId }) {
      let deleteUrl = `programs/${programId}/projects/${issue.facilityId}/issues/${issue.id}.json`   
        if(issue.projectContractId){
          let pcid = issue.projectContractId
          deleteUrl = `/project_contracts/${pcid}/issues/${issue.id}.json`
        } 
        if(issue.projectContractVehicleId){
          let pcid = issue.projectContractVehicleId
          deleteUrl = `/project_contract_vehicles/${pcid}/issues/${issue.id}.json`
       } 
      return new Promise((resolve, reject) => {
        http
          .delete(
            `${API_BASE_PATH}/${deleteUrl}`
          )
          .then((res) => {
            if (issue.facilityId){
              commit("updateIssuesHash", { issue: issue, action: "delete" });
            } 
            if(issue.projectContractId)   {
              commit("updateContractIssues", { issue: issue, action: "delete" });
            }    
            if (issue.projectContractVehicleId)  {
              commit("updateVehicleIssues", {issue: issue, action: "delete" });
            }    
            MessageDialogService.showDialog({
              response: res
            });          
            resolve("Success");
          })
          .catch((err) => {
            console.log("Error",err);
            reject();
          });
      });
    },
    riskDeleted({ commit }, { risk, programId }) {
        let deleteUrl = `programs/${programId}/projects/${risk.facilityId}/risks/${risk.id}.json`   
        if(risk.projectContractId){
          let pcid = risk.projectContractId
          deleteUrl = `/project_contracts/${pcid}/risks/${risk.id}.json`
        } 
        if(risk.projectContractVehicleId){
          let pcid = risk.projectContractVehicleId
          deleteUrl = `/project_contract_vehicles/${pcid}/risks/${risk.id}.json`
        } 
       return new Promise((resolve, reject) => {
        http
          .delete(
            `${API_BASE_PATH}/${deleteUrl}`
          )
          .then((res) => {
            if (risk.facilityId){
              commit("updateRisksHash", { risk: risk, action: "delete" });
            } 
            if (risk.projectContractVehicleId){
              commit("updateVehicleRisks", { risk: risk, action: "delete" });
            } 
            if (risk.projectContractId)  {
              commit("updateContractRisks", { risk: risk, action: "delete" });
            }    
            MessageDialogService.showDialog({
              response: res
            });      
            resolve("Success");
          })
          .catch((err) => {
            console.log("Error",err);
            reject();
          });
      });
    },
  },

  plugins: [
    createPersistedState({
      localStorage: {
        getState: (key) => Cookies.getJSON(key),
        setState: (key, state) => Cookies.set(key, state, { expires: 3 }),
        removeItem: (key) => Cookies.remove(key),
      },
      paths: [
        // 'advancedFilter',
        "taskIssueUserFilter",
        "projectStatusFilter",
        "calendarViewFilter",

        "taskTypeFilter",
        "taskStageFilter",

        "facilityGroupFilter",
        "facilityNameFilter",
        "facilityProgressFilter",
        "facilityDueDateFilter",
        "noteDateFilter",
        "taskIssueDueDateFilter",

        "issueTypeFilter",
        "issueSeverityFilter",
        "issueStageFilter",

        "membersPerPageFilter",
        "tasksPerPageFilter",
        "issuesPerPageFilter",
        "risksPerPageFilter",
        "lessonsPerPageFilter",

        "riskStageFilter",
        "riskApproachFilter",
        "riskPriorityLevelFilter",
        "riskProbabilityOptions",
        "riskImpactLevelOptions",
        "riskDispositionStatus",
        "riskDispositionDuration",

        "taskIssueProgressFilter",
        "myAssignmentsFilter",
        "myActionsFilter",
        "onWatchFilter",
        "progressFilter",
        "mapFilters",
      ],
    }),
  ],
});
