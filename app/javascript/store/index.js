import http from './../common/http'
import * as Moment from 'moment'
import {extendMoment} from 'moment-range'
const moment = extendMoment(Moment)
import createPersistedState from 'vuex-persistedstate'
import * as Cookies from 'js-cookie'

// utility function
const getSimpleDate = (date) => {
  var dt = [undefined, null, 'N/A'].includes(date) ? new Date : new Date(date)
  var y = dt.getFullYear()
  var m = dt.getMonth()
  var d = dt.getDate()
  return new Date(y, m, d, 0, 0, 0).getTime()
}

export default new Vuex.Store({
  state: {
    mapLoading: true,
    sideLoading: true,
    projects: new Array,
    facilities: new Array,
    facilityGroups: new Array,
    statuses: new Array,
    taskTypes: new Array,
    issueTypes: new Array,
    issueSeverities: new Array,
    currentProject: null,
    projectUsers: new Array,
    currentFacility: null,
    currentFacilityGroup: null,
    mapFilters: new Array,
    projectStatusFilter: null,
    taskTypeFilter: null,
    facilityGroupFilter: null,
    facilityNameFilter: null,
    facilityProgressFilter: null,
    facilityDueDateFilter: null,
    issueTypeFilter: null,
    issueSeverityFilter: null,
    issueProgressFilter: null,
    taskProgressFilter: null,
    progressFilter: {
      facility: {
        min: '',
        max: '',
        error: ''
      },
      task: {
        min: '',
        max: '',
        error: ''
      },
      issue: {
        min: '',
        max: '',
        error: ''
      }
    },
    taskUserFilter: null,
    issueUserFilter: null,
    myActionsFilter: new Array,
    managerView: {
      task: null,
      issue: null,
      note: null
    }
  },

  mutations: {
    setMapLoading: (state, loading) => state.mapLoading = loading,
    setSideLoading: (state, loading) => state.sideLoading = loading,
    setProjects: (state, projects) => state.projects = projects,
    setFacilities: (state, facilities) => state.facilities = facilities,
    setFacilityGroups: (state, facilityGroups) => state.facilityGroups = facilityGroups,
    setStatuses: (state, statuses) => state.statuses = statuses,
    setTaskTypes: (state, taskTypes) => state.taskTypes = taskTypes,
    setIssueTypes: (state, issueTypes) => state.issueTypes = issueTypes,
    setIssueSeverities: (state, issueSeverities) => state.issueSeverities = issueSeverities,
    setCurrentProject: (state, project) => state.currentProject = project,
    setProjectUsers: (state, users) => state.projectUsers = users,
    setCurrentFacility: (state, facility) => state.currentFacility = facility,
    setCurrentFacilityGroup: (state, facilityGroup) => state.currentFacilityGroup = facilityGroup,
    setMapFilters: (state, filters) => state.mapFilters = filters,
    updateFacilities: (state, {index, facility}) => {
      Vue.set(state.facilities, index, facility)
    },
    updateFacilityHash: (state, facility) => {
      var index = state.facilities.findIndex(f => f.id == facility.id)
      if (index > -1) Vue.set(state.facilities, index, facility)
    },
    updateMapFilters: (state, {key, filter, same, _k}) => {
      if (filter && !filter.includes(null) && Array.isArray(filter) && filter.length > 0) {
        var i = state.mapFilters.findIndex(f => f.hasOwnProperty(key))
        if (i < 0) i = state.mapFilters.length
        var value = {[key]: same ? filter : _.map(filter, _k || 'id')}
        Vue.set(state.mapFilters, i, value)
      }
      else {
        state.mapFilters = _.filter(state.mapFilters, f => !f.hasOwnProperty(key))
      }
    },
    updateTasksHash: (state, {task, action}) => {
      var facility_i = state.facilities.findIndex(f => f.id == task.facilityId)
      if (facility_i > -1) {
        var facility = Object.assign({}, state.facilities[facility_i])
        var task_i = facility.tasks.findIndex((t) => t.id == task.id)
        if (action === 'delete') {
          for (let t of _.flatten(_.map(state.facilities, 'tasks'))) {
            _.remove(t.subTaskIds, id => id == t.id)
          }
          Vue.delete(facility.tasks, task_i)
        }
        else if (task_i > -1) Vue.set(facility.tasks, task_i, task)
        Vue.set(state.facilities, facility_i, facility)
      }
    },
    updateIssuesHash: (state, {issue, action}) => {
      var facility_i = state.facilities.findIndex(f => f.id == issue.facilityId)
      if (facility_i > -1) {
        var facility = Object.assign({}, state.facilities[facility_i])
        var issue_i = facility.issues.findIndex((t) => t.id == issue.id)
        if (action === 'delete') {
          for (let t of _.flatten(_.map(state.facilities, 'issues'))) {
            _.remove(t.subIssueIds, id => id == t.id)
          }
          Vue.delete(facility.issues, issue_i)
        }
        else if (issue_i > -1) Vue.set(facility.issues, issue_i, issue)
        Vue.set(state.facilities, facility_i, facility)
      }
    },
    setProjectStatusFilter: (state, filter) => state.projectStatusFilter = filter,
    setTaskTypeFilter: (state, filter) => state.taskTypeFilter = filter,
    setFacilityGroupFilter: (state, filter) => state.facilityGroupFilter = filter,
    setFacilityNameFilter: (state, filter) => state.facilityNameFilter = filter,
    setFacilityProgressFilter: (state, filter) => state.facilityProgressFilter = filter,
    setFacilityDueDateFilter: (state, filter) => state.facilityDueDateFilter = filter,
    setIssueTypeFilter: (state, filter) => state.issueTypeFilter = filter,
    setIssueSeverityFilter: (state, filter) => state.issueSeverityFilter = filter,
    setIssueProgressFilter: (state, filter) => state.issueProgressFilter = filter,
    setTaskProgressFilter: (state, filter) => state.taskProgressFilter = filter,
    setTaskUserFilter: (state, filter) => state.taskUserFilter = filter,
    setIssueUserFilter: (state, filter) => state.issueUserFilter = filter,
    setMyActionsFilter: (state, filter) => state.myActionsFilter = filter,
    clearProgressFilters: (state) => {
      var filters = new Object
      for (var key of Object.keys(state.progressFilter)) {
        filters[key] = new Object
        for (var fil of Object.keys(state.progressFilter[key])) {
          filters[key][fil] = ""
        }
      }
      state.progressFilter = filters
    },
    setProgressFilters: (state, {key, value}) => state.progressFilter[key] = value,
    setTaskForManager: (state, {key, value}) => {
      for (let k in state.managerView) {
        state.managerView[k] = k == key ? value : null
      }
    }
  },

  getters: {
    mapLoading: state => state.mapLoading,
    sideLoading: state => state.sideLoading,
    projects: state => state.projects,
    facilities: state => state.facilities,
    facilityGroups: state => state.facilityGroups,
    statuses: state => state.statuses,
    taskTypes: state => state.taskTypes,
    issueTypes: state => state.issueTypes,
    issueSeverities: state => state.issueSeverities,
    currentProject: state => state.currentProject,
    projectUsers: state => state.projectUsers,
    activeProjectUsers: state => _.filter(state.projectUsers, u => u.status == "active"),
    currentFacility: state => state.currentFacility,
    currentFacilityGroup: state => state.currentFacilityGroup,
    projectStatusFilter: state => state.projectStatusFilter,
    taskTypeFilter: state => state.taskTypeFilter,
    facilityGroupFilter: state => state.facilityGroupFilter,
    facilityNameFilter: state => state.facilityNameFilter,
    facilityProgressFilter: state => state.facilityProgressFilter,
    facilityDueDateFilter: state => state.facilityDueDateFilter,
    issueTypeFilter: state => state.issueTypeFilter,
    issueSeverityFilter: state => state.issueSeverityFilter,
    issueProgressFilter: state => state.issueProgressFilter,
    taskProgressFilter: state => state.taskProgressFilter,
    taskUserFilter: state => state.taskUserFilter,
    issueUserFilter: state => state.issueUserFilter,
    myActionsFilter: state => state.myActionsFilter,
    mapFilters: state => state.mapFilters,
    progressFilter: state => state.progressFilter,
    managerView: state => state.managerView,
    filteredFacilities: (state, getters) => (_status='active') => {
      return _.filter(getters.facilities, (facility) => {
        var valid = _status === 'all' || facility.status === _status
        if (!valid) return valid
        _.each(state.mapFilters, (f) => {
          var k = Object.keys(f)[0]
          switch(k) {
            case "dueDate": {
              var range = moment.range(f[k][0], f[k][1])
              valid = valid && facility[k] && range.contains(new Date(facility[k].replace(/-/g, '/')))
              break
            }
            case "progress": {
              var ranges = f[k].map(r => r.split("-").map(Number))
              var is_valid = false
              for (var range of ranges) {
                is_valid = range[1] !== undefined ? range[0] <= facility[k] && range[1] >= facility[k] : facility[k] == range[0]
                if (is_valid) break
              }
              valid = valid && is_valid
              break
            }
            case "taskTypeIds": {
              var ids = _.map(facility.tasks, 'taskTypeId')
              valid = valid && _.intersection(f[k], ids).length > 0
              break
            }
            case "issueTypeIds": {
              var ids = _.map(facility.issues, 'issueTypeId')
              valid = valid && _.intersection(f[k], ids).length > 0
              break
            }
            case "issueProgress":
            case "taskProgress": {
              var progressFor = k === 'taskProgress' ? facility.tasks : facility.issues
              var progress = _.uniq(_.map(progressFor, 'progress'))
              var ranges = f[k].map(r => r.split("-").map(Number))
              var is_valid = false
              for (var range of ranges) {
                var size = range[1] ? (range[1] - range[0]) + 1 : 1
                is_valid = _.intersection(progress, Array.from(Array(size), (_, i) => i + range[0])).length > 0
                if (is_valid) break
              }
              valid = valid && is_valid
              break
            }
            case "issueSeverityIds": {
              var ids = _.map(facility.issues, 'issueSeverityId')
              valid = valid && _.intersection(f[k], ids).length > 0
              break
            }
            case "issueUserIds": {
              var ids = _.uniq(_.compact(_.flatten(_.map(facility.issues, 'userIds'))))
              valid = valid && _.intersection(f[k], ids).length > 0
              break
            }
            case "taskUserIds": {
              var ids = _.uniq(_.compact(_.flatten(_.map(facility.tasks, 'userIds'))))
              valid = valid && _.intersection(f[k], ids).length > 0
              break
            }
            case "facilityGroupIds": {
              valid = valid && f[k].includes(facility.facilityGroupId)
              break
            }
            case "ids": {
              valid = valid && f[k].includes(facility.id)
              break
            }
            case "statusIds": {
              valid = valid && f[k].includes(facility.statusId)
              break
            }
            case "myActions": {
              var is_valid = false
              for (var act of f[k]) {
                var userIds = _.compact(_.uniq([..._.flatten(_.map(facility[act], 'userIds')), ..._.map(_.flatten(_.map(facility[act], 'checklists')), 'userId')]))
                is_valid = is_valid || userIds.includes(Vue.prototype.$currentUser.id)
              }
              valid = valid && is_valid
              break
            }
            default: {
              valid = valid && facility[k] == f[k]
              break
            }
          }
        })
        return valid
      })
    },
    filteredFacilityGroups: (state, getters) => {
      var ids = _.map(getters.filteredFacilities('active'), 'facilityGroupId')
      return _.filter(getters.facilityGroups, fg => ids.includes(fg.id))
    },
    facilityCount: (state, getters) => {
      return getters.filteredFacilities('all').length
    },
    facilityProgress: (state, getters) => {
      var mean = _.meanBy(getters.filteredFacilities('active'), 'progress') || 0
      return Number(mean.toFixed(2))
    },
    filterFacilitiesWithActiveFacilityGroups: (state, getters) => {
      var ids = _.map(_.filter(state.facilityGroups, fg => fg.status === 'active'), 'id')
      return _.filter(getters.filteredFacilities('active'), (f) => ids.includes(f.facilityGroupId) && f.status === 'active')
    },
    unFilterFacilities: (state) => {
      var ids = _.map(_.filter(state.facilityGroups, fg => fg.status === 'active'), 'id')
      return _.filter(state.facilities, (f) => ids.includes(f.facilityGroupId) && f.status === 'active')
    },
    activeFacilityGroups: (state, getters) => (id=getters.currentProject.id) => {
      return _.filter(getters.facilityGroups, f => f.status === 'active' && f.projectIds.includes(id))
    },
    currentTasks: (state, getters) => {
      return _.flatten(_.map(getters.filterFacilitiesWithActiveFacilityGroups, 'tasks'))
    },
    currentIssues: (state, getters) => {
      return _.flatten(_.map(getters.filterFacilitiesWithActiveFacilityGroups, 'issues'))
    },
    facilityGroupFacilities: (state, getters) => (group) => {
      return _.filter(getters.filteredFacilities('active'), f => f.facilityGroupId == group.id && f.projectId == getters.currentProject.id)
    },

    // for gantt chart view
    ganttData: (state, getters) => {
      var hash = new Array

      // for project
      var p_id = `p_${getters.currentProject.id}`
      var _p_id = '1'
      var p_s_date = _.min(_.map(getters.currentTasks, 'startDate')) || 'N/A'
      var p_e_date = _.max(_.map(getters.currentTasks, 'dueDate')) || 'N/A'
      var p_duration = getSimpleDate(p_e_date) - getSimpleDate(p_s_date) || 0
      var p_progress = _.meanBy(getters.currentTasks, 'progress') || 0

      hash.push(
        {
          id: p_id,
          _id: _p_id,
          name: getters.currentProject.name,
          duration: p_duration,
          durationInDays: `${Math.ceil(p_duration / (1000 * 3600 * 24)) || 0} days`,
          percent: Number(p_progress.toFixed(2)),
          start: getSimpleDate(p_s_date),
          startDate: p_s_date,
          endDate: p_e_date,
          type: 'project'
        }
      )

      // for facility_groups
      var groups = _.groupBy(getters.filterFacilitiesWithActiveFacilityGroups, 'facilityGroupName')
      var group_count = 1
      for (var group in groups) {
        var _fg_id = _p_id + "." + group_count
        var fg_id = `${p_id}_fg_${group}`.replace(/ /i, '_')
        var fg_tasks = _.flatten(_.map(groups[group], 'tasks'))
        var fg_s_date = _.min(_.map(fg_tasks, 'startDate')) || 'N/A'
        var fg_e_date = _.max(_.map(fg_tasks, 'dueDate')) || 'N/A'
        var fg_duration = getSimpleDate(fg_e_date) - getSimpleDate(fg_s_date) || 0
        var fg_progress = _.meanBy(fg_tasks, 'progress') || 0

        hash.push(
          {
            id: fg_id,
            _id: _fg_id,
            parentId: p_id,
            name: group,
            duration: fg_duration,
            durationInDays: `${Math.ceil(fg_duration / (1000 * 3600 * 24)) || 0} days`,
            percent: Number(fg_progress.toFixed(2)),
            start: getSimpleDate(fg_s_date),
            startDate: fg_s_date,
            endDate: fg_e_date,
            type: 'milestone'
          }
        )

        var f_read = Vue.prototype.$permissions.overview.read || false
        // for facilities under facility_groups
        var facility_count = 1
        for (var facility of groups[group]) {
          var f_id = f_read ? `${fg_id}_f_${facility.id}` : fg_id
          var _f_id = _fg_id + "." + facility_count
          var f_s_date = _.min(_.map(facility.tasks, 'startDate')) || 'N/A'
          var f_e_date = _.max(_.map(facility.tasks, 'dueDate')) || 'N/A'
          var f_duration = getSimpleDate(f_e_date) - getSimpleDate(f_s_date) || 0
          var f_progress = _.meanBy(facility.tasks, 'progress') || 0

          hash.push(
            {
              id: f_id,
              _id: _f_id,
              parentId: fg_id,
              name: facility.facility.facilityName,
              duration: f_duration,
              durationInDays: `${Math.ceil(f_duration / (1000 * 3600 * 24)) || 0} days`,
              percent: Number(f_progress.toFixed(2)),
              start: getSimpleDate(f_s_date),
              startDate: f_s_date,
              endDate: f_e_date,
              type: 'milestone'
            }
          )

          if (Vue.prototype.$permissions.tasks.read)
          {
            // for task_types under facilities
            var types = _.groupBy(facility.tasks, 'taskType')
            var filteredTaskTypes = _.map(getters.taskTypeFilter, 'name')
            var types_count = 1
            for (var type in types) {
              if (filteredTaskTypes.length > 0 && !filteredTaskTypes.includes(type)) continue
              var tasks = types[type]
              var tt_id = `${f_id}_tt_${type}`.replace(/ /i, '_')
              var _tt_id = _f_id + "." + types_count
              var tt_s_date = _.min(_.map(tasks, 'startDate'))
              var tt_e_date = _.max(_.map(tasks, 'dueDate'))
              var tt_duration = getSimpleDate(tt_e_date) - getSimpleDate(tt_s_date)
              var tt_progress = _.meanBy(tasks, 'progress')

              hash.push(
                {
                  id: tt_id,
                  _id: _tt_id,
                  parentId: f_id,
                  name: type,
                  duration: tt_duration,
                  durationInDays: `${Math.ceil(tt_duration / (1000 * 3600 * 24))} days`,
                  percent: Number(tt_progress.toFixed(2)),
                  start: getSimpleDate(tt_s_date),
                  startDate: tt_s_date,
                  endDate: tt_e_date,
                  type: 'milestone'
                }
              )

              var ranges = getters.taskProgressFilter ? _.map(getters.taskProgressFilter, 'value').map(r => r.split("-").map(Number)) : false

              // for tasks under task_types
              var task_count = 1
              for (var task of tasks) {
                if (_.map(getters.myActionsFilter, 'value').includes('tasks')) {
                  var userIds = [..._.map(task.checklists, 'userId'), ...task.userIds]
                  if (!userIds.includes(Vue.prototype.$currentUser.id)) continue
                }
                if (ranges && ranges.length > 0) {
                  let is_valid = false
                  for (var range of ranges) {
                    is_valid = range[1] !== undefined ? range[0] <= task.progress && range[1] >= task.progress : task.progress == range[0]
                    if (is_valid) break
                  }
                  if (!is_valid) continue
                }
                var t_id = `${tt_id}_t_${task.id}`
                var _t_id = _tt_id + "." + task_count
                var t_duration = getSimpleDate(task.dueDate) - getSimpleDate(task.startDate)

                hash.push(
                  {
                    taskUrl: `/projects/${getters.currentProject.id}/facilities/${facility.facility.id}/tasks/${task.id}`,
                    facilityId: facility.id,
                    projectId: getters.currentProject.id,
                    id: t_id,
                    _id: _t_id,
                    parentId: tt_id,
                    name: task.text,
                    duration: t_duration,
                    durationInDays: `${Math.ceil(t_duration / (1000 * 3600 * 24))} days`,
                    percent: Number(task.progress.toFixed(2)),
                    start: getSimpleDate(task.startDate),
                    startDate: task.startDate,
                    endDate: task.dueDate,
                    _users: task.users,
                    type: 'task',
                    collapsed: true
                  }
                )

                // for checklists under tasks
                var checklist_count = 1
                for (var checklist of task.checklists) {
                  if (_.map(getters.myActionsFilter, 'value').includes('tasks') && checklist.userId !== Vue.prototype.$currentUser.id) continue
                  var c_id = `${t_id}_t_${checklist.id}`
                  var _c_id = _t_id + "." + checklist_count
                  hash.push(
                    {
                      id: c_id,
                      _id: _c_id,
                      parentId: t_id,
                      name: checklist.text,
                      duration: t_duration,
                      durationInDays: `${Math.ceil(t_duration / (1000 * 3600 * 24))} days`,
                      percent: checklist.checked ? 100 : 0,
                      start: getSimpleDate(task.startDate),
                      startDate: task.startDate,
                      endDate: task.dueDate,
                      type: 'task',
                      dependentOn: [t_id],
                      _users: checklist.user ? [checklist.user.fullName] : null
                    }
                  )
                  checklist_count++
                }
                task_count++
              }
              types_count++
            }
          }
          facility_count++
        }
        group_count++
      }

      return hash
    },
    filteredAllTasks: (state, getters) => {
      var ids = getters.taskTypeFilter && getters.taskTypeFilter.length ? _.map(getters.taskTypeFilter, 'id') : []
      return _.filter(_.flatten(_.map(getters.filteredFacilities('active'), 'tasks')), t => ids.length ? ids.includes(t.taskTypeId) : true)
    },
    filteredAllIssues: (state, getters) => {
      var ids = getters.issueTypeFilter && getters.issueTypeFilter.length ? _.map(getters.issueTypeFilter, 'id') : []
      return _.filter(_.flatten(_.map(getters.filteredFacilities('active'), 'issues')), t => ids.length ? ids.includes(t.issueTypeId) : true)
    },
    on_watched: (state, getters) => {
      var tasks = _.filter(getters.filteredAllTasks, t => t.watched)
      var issues = _.filter(getters.filteredAllIssues, t => t.watched)
      var ids = [..._.map(issues, 'facilityId'), ..._.map(tasks, 'facilityId')]
      var facilities = _.filter(getters.filteredFacilities('active'), t => ids.includes(t.id))

      return {tasks, issues, facilities}
    }
  },

  actions: {
    fetchFacilities({commit, dispatch}, id) {
      return new Promise((resolve, reject) => {
        http.get(`/projects/${id}/facilities.json`)
          .then((res) => {
            var facilities = []
            for (var facility of res.data.facilities) {
              facilities.push({...facility, ...facility.facility})
            }
            commit('setFacilities', facilities)
            resolve()
          })
          .catch((err) => {
            console.error(err)
            reject()
          })
      })
    },
    fetchCurrentProject({commit, dispatch}, id) {
      return new Promise((resolve, reject) => {
        http.get(`/projects/${id}.json`)
          .then((res) => {
            commit('setCurrentProject', res.data.project)
            commit('setProjectUsers', res.data.users)
            resolve()
          })
          .catch((err) => {
            console.error(err)
            reject()
          })
      })
    },
    fetchFacility({commit, dispatch, getters}, {projectId, facilityId}) {
      return new Promise((resolve, reject) => {
        http.get(`/projects/${projectId}/facilities/${facilityId}.json`)
          .then((res) => {
            var facility = Object.assign({}, {...res.data.facility, ...res.data.facility.facility})
            var index = getters.facilities.findIndex(f => f.id == facility.id)
            if (index > -1) commit('updateFacilities', {index, facility})
            return resolve(facility)
          })
          .catch((err) => {
            console.error(err)
            reject(err)
          })
      })
    },
    fetchProjects({commit}) {
      return new Promise((resolve, reject) => {
        http.get('/projects.json')
          .then((res) => {
            commit('setProjects', res.data.projects)
            resolve()
          })
          .catch((err) => {
            console.error(err)
            reject()
          })
      })
    },
    fetchFacilityGroups({commit}, id) {
      let url = '/api/facility_groups.json'
      if (id !== undefined) url = url + `?=project_id=${id}`
      return new Promise((resolve, reject) => {
        http.get(url)
          .then((res) => {
            commit('setFacilityGroups', res.data.facilityGroups)
            resolve()
          })
          .catch((err) => {
            console.error(err)
            reject()
          })
      })
    },
    fetchStatuses({commit}) {
      return new Promise((resolve, reject) => {
        http.get('/api/statuses.json')
          .then((res) => {
            commit('setStatuses', res.data.statuses)
            resolve()
          })
          .catch((err) => {
            console.error(err)
            reject()
          })
      })
    },
    fetchTaskTypes({commit}) {
      return new Promise((resolve, reject) => {
        http.get('/api/task_types.json')
          .then((res) => {
            commit('setTaskTypes', res.data.taskTypes)
            resolve()
          })
          .catch((err) => {
            console.error(err)
            reject()
          })
      })
    },
    fetchIssueTypes({commit}) {
      return new Promise((resolve, reject) => {
        http.get('/api/issue_types.json')
          .then((res) => {
            commit('setIssueTypes', res.data.issueTypes)
            resolve()
          })
          .catch((err) => {
            console.error(err)
            reject()
          })
      })
    },
    fetchIssueSeverities({commit}) {
      return new Promise((resolve, reject) => {
        http.get('/api/issue_severities.json')
          .then((res) => {
            commit('setIssueSeverities', res.data.issueSeverities)
            resolve()
          })
          .catch((err) => {
            console.error(err)
            reject()
          })
      })
    },
    async fetchDashboardData({dispatch}, {id, cb}) {
      await dispatch('fetchProjects')
      await dispatch('fetchCurrentProject', id)
      await dispatch('fetchFacilities', id)
      await dispatch('fetchFacilityGroups', id)
      await dispatch('fetchStatuses')
      await dispatch('fetchTaskTypes')
      await dispatch('fetchIssueTypes')
      await dispatch('fetchIssueSeverities')
      if (cb) return cb()
    },
    async taskUpdated({dispatch}, {projectId, facilityId, cb}) {
      return new Promise(async (resolve, reject) => {
        let facility = await dispatch('fetchFacility', {projectId, facilityId})
        if (cb) cb()
        if (facility instanceof Error) return reject(facility)
        return resolve(facility)
      })
    },

    // store actions watch_view
    updateWatchedTasks({commit}, task) {
      return new Promise((resolve, reject) => {
        http.put(`/projects/${task.projectId}/facilities/${task.facilityId}/tasks/${task.id}.json`, {task: task})
          .then((res) => {
            commit('updateTasksHash', {task: res.data.task})
            resolve()
          })
          .catch((err) => {
            console.error(err)
            reject()
          })
      })
    },
    updateWatchedIssues({commit}, issue) {
      return new Promise((resolve, reject) => {
        http.put(`/projects/${issue.projectId}/facilities/${issue.facilityId}/issues/${issue.id}.json`, {issue: issue})
          .then((res) => {
            commit('updateIssuesHash', {issue: res.data.issue})
            resolve()
          })
          .catch((err) => {
            console.error(err)
            reject()
          })
      })
    },
    taskDeleted({commit}, task) {
      return new Promise((resolve, reject) => {
        http
          .delete(`/projects/${task.projectId}/facilities/${task.facilityId}/tasks/${task.id}.json`)
          .then((res) => {
            commit('updateTasksHash', {task: task, action: 'delete'})
            resolve()
          })
          .catch((err) => {
            console.log(err)
            reject()
          })
      })
    },
    issueDeleted({commit}, issue) {
      return new Promise((resolve, reject) => {
        http
          .delete(`/projects/${issue.projectId}/facilities/${issue.facilityId}/issues/${issue.id}.json`)
          .then((res) => {
            commit('updateIssuesHash', {issue: issue, action: 'delete'})
            resolve()
          })
          .catch((err) => {
            console.log(err)
            reject()
          })
      })
    }
  },

  plugins: [
    createPersistedState({
      localStorage: {
        getState: key => Cookies.getJSON(key),
        setState: (key, state) => Cookies.set(key, state, { expires: 3 }),
        removeItem: key => Cookies.remove(key),
      },
      paths: [
        'projectStatusFilter',
        'taskTypeFilter',
        'facilityGroupFilter',
        'facilityNameFilter',
        'facilityProgressFilter',
        'facilityDueDateFilter',
        'issueTypeFilter',
        'issueSeverityFilter',
        'issueProgressFilter',
        'taskProgressFilter',
        'myActionsFilter',
        'taskUserFilter',
        'issueUserFilter',
        'progressFilter',
        'mapFilters'
      ]
    })
  ]
})
