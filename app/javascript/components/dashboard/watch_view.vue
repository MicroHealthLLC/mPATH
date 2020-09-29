<template>
  <div id="watch_view">
    <div class="row">
      <div class="col">
        <div class="watch-task-timeline p-4 mb-4">
          <h5 class="mb-2">On Watch Timeline</h5>
          <div id="watch_task_timeline"></div>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col-md-7">
        <div class="row">
          <div class="col-md-4">
            <div class="blue-box w-100 h-100 text-center p-3">
              <h6 class="px-3">Total Number of Watched Tasks</h6>
              <h1 class="px-3">{{on_watched.tasks.length}}</h1>
            </div>
          </div>
          <div class="col-md-4">
            <div class="blue-box w-100 h-100 text-center p-3">
              <h6 class="px-3">Total Number of Watched Issues</h6>
              <h1 class="px-3">{{on_watched.issues.length}}</h1>
            </div>
          </div>
          <div class="col-md-4">
            <div class="blue-box w-100 h-100 text-center p-3">
              <h6 class="px-3">Facilities on Watch</h6>
              <h1 class="px-3">{{on_watched.facilities.length}}</h1>
            </div>
          </div>
        </div>
        <div class="row mt-4">
          <div class="col-md-4">
            <div class="d_chart_box">
              <h6 class="py-2 px-3 text-center">Watched Task Progress</h6>
              <div class="d_chart">
                <doughnut :chart-data="watchedTasksCompletionData" :width="200" :height="100" />
                <h5 class="d_abbr">{{completedTasksInPercent}} %</h5>
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <div class="d_chart_box">
              <h6 class="py-2 px-3 text-center">Watched Issue Progress</h6>
              <div class="d_chart">
                <doughnut :chart-data="watchedIssuesCompletionData" :width="200" :height="100" />
                <h5 class="d_abbr">{{completedIssuesInPercent}} %</h5>
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <div class="blue-box w-100 h-75 text-center p-3">
              <div class="warning-icon" v-tooltip="`overdue`"><i class="fa fa-exclamation-triangle"></i></div>
              <h6 class="px-3">Tasks and Issues</h6>
              <h1 class="px-3">{{overdueTasksNIssues.length}}</h1>
            </div>
          </div>
        </div>
      </div>
      <div class="col-md-5">
        <div class="border-gray h-330">
          <h5 class="mb-2">Watched Facilities and Status</h5>
          <div v-if="on_watched.facilities.length > 0">
            <div v-for="facility in on_watched.facilities">
              <div class="row my-3">
                <div class="col-md-9">
                  <div class="d-flex align-items-center">
                    <div class="fbody-icon mr-2"><i class="fas fa-check"></i></div>
                    <div class="mr-2">{{facility.facilityName}}</div>
                    <div class="status-box px-2 text-secondary" :style="`border-color: ${facility.color}`">{{facility.projectStatus || 'No Status'}}</div>
                  </div>
                </div>
                <div class="col-md-3 d-flex align-items-center">
                  <span class="w-100 progress pg-content" :class="{'progress-0': facility.progress <= 0}">
                    <div class="progress-bar bg-info" :style="`width: ${facility.progress}%`">{{facility.progress}} %</div>
                  </span>
                </div>
              </div>
            </div>
          </div>
          <div v-else class="p-2 text-danger">No Data Found..</div>
        </div>
      </div>
    </div>

    <div class="border-gray mt-3">
      <h5 class="px-3 mb-2">Watched Tasks Stats</h5>
      <div class="row">
        <div class="col-md-6">
          <div class="border-gray h-330">
            <h5 class="mb-2">Watched Milestone Progressions</h5>
            <div v-if="displayWatchedTaskTypes">
              <div v-for="task in watchedTaskTypes">
                <div class="row mt-1" v-if="task._display">
                  <div class="col-md-9">
                    <span> {{task.name}}</span>
                    <span class="badge badge-secondary badge-pill">{{task.length}}</span>
                  </div>
                  <div class="col-md-3 d-flex align-items-center">
                    <span class="w-100 progress pg-content" :class="{'progress-0': task.progress <= 0}">
                      <div class="progress-bar bg-info" :style="`width: ${task.progress}%`">{{task.progress}} %</div>
                    </span>
                  </div>
                </div>
              </div>
            </div>
            <div v-else class="p-2 text-danger">No Data Found..</div>
          </div>
        </div>
        <div class="col-md-6">
          <div class="wacthed-task-list">
            <div class="watched-list">
              <h5 class="py-2 px-3">Watched Tasks</h5>
              <div v-if="sortedTasks.length > 0">
                <div
                  class="p-1 watch-task-item"
                  @click="onWatchedItem(task, 'TaskShow')"
                  v-for="(task, i) in sortedTasks"
                  :key="task.id"
                  >
                  <task-show
                    :class="{'b_border': !!on_watched.tasks[i+1]}"
                    :task="task"
                    from-view="watch_view"
                    @toggle-watched="updateWatchedTasks"
                  ></task-show>
                </div>
              </div>
              <div v-else class="p-2 text-danger">No Data Found..</div>
            </div>
          </div>
        </div>
      </div>
      <div class="row mt-4">
        <div class="col-md-6">
          <h6 class="px-3 text-center">Watched Milestones vs Total</h6>
          <stacked :chart-data="onWatchedTaskData" :width="300" :height="100" />
        </div>
        <div class="col-md-6">
          <h6 class="px-3">Assigned Users</h6>
          <bar :chart-data="watchedTaskUsers" :width="300" :height="watchedUserHeight" />
          <p class="mt-2 text-center">Total Assigned Tasks and Checklist Items</p>
        </div>
      </div>
    </div>

    <div class="border-gray mt-4">
      <h5 class="px-3 mb-2">Watched Issues Stats</h5>
      <div class="row">
        <div class="col-md-6">
          <div class="border-gray h-330">
            <h5 class="mb-2">Watched Issue Types</h5>
            <div v-if="displayWatchedIssueTypes">
              <div v-for="issue in watchedIssueTypes">
                <div class="row mt-1" v-if="issue._display">
                  <div class="col-md-9">
                    <span> {{issue.name}}</span>
                    <span class="badge badge-secondary badge-pill">{{issue.length}}</span>
                  </div>
                  <div class="col-md-3 d-flex align-items-center">
                    <span class="w-100 progress pg-content" :class="{'progress-0': issue.progress <= 0}">
                      <div class="progress-bar bg-info" :style="`width: ${issue.progress}%`">{{issue.progress}} %</div>
                    </span>
                  </div>
                </div>
              </div>
            </div>
            <div v-else class="p-2 text-danger">No Data Found..</div>
          </div>
        </div>
        <div class="col-md-6">
          <div class="watched-issue-list">
            <div class="watched-list">
              <h5 class="py-2 px-3">Watched Issues</h5>
              <div v-if="sortedIssues.length > 0">
                <div
                  v-for="(issue, i) in sortedIssues"
                  :key="issue.id"
                  class="p-1 watch-task-item"
                  @click="onWatchedItem(issue, 'IssueShow')"
                  >
                  <issue-show
                    :class="{'b_border': !!on_watched.issues[i+1]}"
                    :issue="issue"
                    from-view="watch_view"
                    @toggle-watch-issue="updateWatchedIssues"
                  ></issue-show>
                </div>
              </div>
              <div v-else class="p-2 text-danger">No Data Found..</div>
            </div>
          </div>
        </div>
      </div>

      <div class="row mt-4">
        <div class="col-md-6">
          <h6 class="px-3 text-center">Watched Issues vs Total</h6>
          <stacked :chart-data="onWatchedIssueData" :width="300" :height="100" />
        </div>
        <div class="col-md-6">
          <h6 class="px-3">Assigned Users</h6>
          <bar :chart-data="watchedIssueUsers" :width="300" :height="watchedUserHeight" />
          <p class="mt-2 text-center">Total Assigned Issues and Checklist Items</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import Doughnut from './../shared/doughnut_chart'
  import Stacked from './../shared/stacked_chart'
  import Bar from './../shared/bar_chart'
  import TaskShow from './../dashboard/tasks/task_show'
  import IssueShow from './../dashboard/issues/issue_show'
  import {mapGetters, mapActions} from 'vuex'
  import {Timeline, DataSet} from "vis-timeline/standalone"

  export default {
    name: "ProjectWatchView",
    components: {Doughnut, Stacked, Bar, TaskShow, IssueShow},
    data() {
      return {
        watchItem: null,
        watchType: '',
        timeline: null,
        timelineOptions: {
          clickToUse: true,
          height: '480px',
          zoomFriction: 10,
          zoomMax: 315360000000,
          zoomMin: 864000000,
          tooltip: {
            template: (data) => {
              return `<div>
                        <div>Facility: ${data.item.facilityName}</div>
                        <div>Type: ${data.taskType}</div>
                        <div>Start: ${this.formatDate(data.item.startDate)}</div>
                        <div class="${data.overdue ? 'text-danger' : ''}">Due: ${this.formatDate(data.item.dueDate)}<span>${data.overdue ? '<span class="warning-icon ml-2"><i class="fa fa-exclamation-triangle"></i></span>' : ''}</span></div>
                        <div>Progress: ${data.item.progress}%</div>
                      </div>`
            },
            delay: 100,
            followMouse: true
          }
        }
      }
    },
    mounted() {
      this.createTimeline()
    },
    computed: {
      ...mapGetters([
        'on_watched',
        'issueTypes',
        'taskTypes',
        'issueTypeFilter',
        'taskTypeFilter',
        'projectUsers'
      ]),
      completedIssues() {
        return _.filter(this.on_watched.issues, i => i.progress && Number(i.progress) == 100)
      },
      completedTasks() {
        return _.filter(this.on_watched.tasks, i => i.progress && Number(i.progress) == 100)
      },
      completedIssuesInPercent() {
        return Number(_.meanBy(this.on_watched.issues, 'progress').toFixed(0)) || 0
      },
      completedTasksInPercent() {
        return Number(_.meanBy(this.on_watched.tasks, 'progress').toFixed(0)) || 0
      },
      watchedIssuesCompletionData() {
        return {
          datasets: [{
            data: [
              this.completedIssuesInPercent,
              100 - this.completedIssuesInPercent
            ],
            backgroundColor: ['#ef8d38', '#eee']
          }]
        }
      },
      watchedTasksCompletionData() {
        return {
          datasets: [{
            data: [
              this.completedTasksInPercent,
              100 - this.completedTasksInPercent
            ],
            backgroundColor: ['#a3cde4', '#eee']
          }]
        }
      },
      overdueTasksNIssues() {
        return _.filter([...this.on_watched.tasks, ...this.on_watched.issues], t => t.progress !== 100 && new Date(t.dueDate).getTime() < new Date().getTime())
      },
      watchedFacilityStatus() {
        var status = new Array
        for (var [key, value] of Object.entries(_.groupBy(this.on_watched.facilities, 'projectStatus'))) {
          status.push(
            {
              name: key.replace('null', 'No Status'),
              length: value.length,
              color: value[0].color,
              progress: this.getAverage(value.length, this.on_watched.facilities.length)
            }
          )
        }
        return status
      },
      watchedIssueTypes() {
        var names = this.issueTypeFilter && this.issueTypeFilter.length && _.map(this.issueTypeFilter, 'name')
        var issueTypes = new Array
        for (var type of this.issueTypes) {
          var issues = _.filter(this.on_watched.issues, t => t.issueTypeId == type.id)
          issueTypes.push(
            {
              _id: type.id,
              name: type.name,
              _display: (names ? names.includes(type.name) : true) && issues.length > 0,
              length: issues.length,
              progress: Number(_.meanBy(issues, 'progress').toFixed(2))
            }
          )
        }
        return issueTypes
      },
      displayWatchedIssueTypes() {
        return _.filter(this.watchedIssueTypes, i => i._display).length > 0
      },
      watchedTaskTypes() {
        var names = this.taskTypeFilter && this.taskTypeFilter.length && _.map(this.taskTypeFilter, 'name')
        var taskTypes = new Array
        for (var type of this.taskTypes) {
          var tasks = _.filter(this.on_watched.tasks, t => t.taskTypeId == type.id)
          taskTypes.push(
            {
              _id: type.id,
              name: type.name,
              _display: tasks.length > 0 && (names ? names.includes(type.name) : true),
              length: tasks.length,
              progress: Number(_.meanBy(tasks, 'progress').toFixed(2))
            }
          )
        }
        return taskTypes
      },
      displayWatchedTaskTypes() {
        return _.filter(this.watchedTaskTypes, t => t._display).length > 0
      },
      onWatchedTaskData() {
        var c_data = {labels: [], datasets: [{label: 'watched', backgroundColor: '#ef549a', data: []}, {label: 'total', backgroundColor: '#34edfe', data: []}]}
        for (var type of this.watchedTaskTypes) {
          if (!type._display) continue
          var tasks = _.filter(this.on_watched.tasks, t => t.taskTypeId == type._id)
          c_data.labels.push(type.name)
          c_data.datasets[0].data.push(_.filter(tasks, t => t.watched).length)
          c_data.datasets[1].data.push(tasks.length)
        }
        return c_data
      },
      onWatchedIssueData() {
        var c_data = {labels: [], datasets: [{label: 'watched', backgroundColor: '#ef549a', data: []}, {label: 'total', backgroundColor: '#34edfe', data: []}]}
        for (var type of this.watchedIssueTypes) {
          if (!type._display) continue
          var issues = _.filter(this.on_watched.issues, t => t.issueTypeId == type._id)
          c_data.labels.push(type.name)
          c_data.datasets[0].data.push(_.filter(issues, t => t.watched).length)
          c_data.datasets[1].data.push(issues.length)
        }
        return c_data
      },
      watchedTaskUsers() {
        var u_data = {labels: [], datasets: []}
        for (var user of this.projectUsers) {
          var count = _.countBy(this.on_watched.tasks, t => t.userIds.includes(user.id) || _.map(t.checklists, 'userId').includes(user.id)).true
          if (count > 0) {
            u_data.datasets.push({
              label: user.fullName,
              backgroundColor: this.getColor(),
              data: [count]
            })
          }
        }
        return u_data
      },
      watchedIssueUsers() {
        var u_data = {labels: [], datasets: []}
        for (var user of this.projectUsers) {
          var count = _.countBy(this.on_watched.issues, t => t.userIds.includes(user.id) || _.map(t.checklists, 'userId').includes(user.id)).true
          if (count > 0) {
            u_data.datasets.push({
              label: user.fullName,
              backgroundColor: this.getColor(),
              data: [count]
            })
          }
        }
        return u_data
      },
      watchedUserHeight() {
        return this.projectUsers.length > 10 ? this.projectUsers.length * 10 : 100
      },
      timelineData() {
        var data = []
        for (var task of [...this.on_watched.issues, ...this.on_watched.tasks]) {
          var _hash = {item: {...task}}
          var is_task = task.hasOwnProperty('taskTypeId')
          _hash.id = is_task ? 'task_'+task.id : 'issue_'+task.id
          _hash.taskType = is_task ? task.taskType : task.issueType
          _hash.content = is_task ? task.text : task.title
          _hash.start = task.startDate
          if (new Date(task.startDate).getTime() !== new Date(task.endDate).getTime()) _hash.end = task.endDate
          _hash.className = is_task ? 'vis-task' : 'vis-issue'
          if (task.progress !== 100 && new Date(task.dueDate).getTime() < new Date().getTime()) {
            _hash.className = 'vis-overdue'
            _hash.overdue = true
          }
          data.push(_hash)
        }
        return data
      },
      sortedTasks() {
        return _.sortBy(this.on_watched.tasks, ['dueDate'])
      },
      sortedIssues() {
        return _.sortBy(this.on_watched.issues, ['dueDate'])
      }
    },
    methods: {
      ...mapActions([
        'updateWatchedTasks',
        'updateWatchedIssues'
      ]),
      onWatchedItem(item, type) {
        // this.watchItem = item
        // this.watchType = type
      },
      createTimeline() {
        var container = document.getElementById('watch_task_timeline')
        this.timeline = new Timeline(container, new DataSet(this.timelineData), this.timelineOptions)
      }
    },
    watch: {
      on_watched: {
        handler(value) {
          this.timeline.destroy()
          this.createTimeline()
        }, deep: true
      }
    }
  }
</script>

<style lang="scss">
  #watch_view {
    padding: 10px 70px;
    max-height: calc(100vh - 94px);
    height: calc(100vh - 94px);
    overflow-y: auto;
  }
  .d_chart {
    width: 200px;
    .d_abbr {
      position: relative;
      bottom: 25px;
      left: 42%;
    }
  }

  .bar_chart {
    width: 400px;
    height: 100px;
  }
  .watched-list {
    border: 1px solid rgba(0, 0, 0, 0.125);
    height: 330px;
    overflow-y: auto;
    padding: 1em;
  }
  .watch-task-timeline {
    height: 570px;
    border: 1px solid rgba(0, 0, 0, 0.125);
    overflow-y: auto;
  }
  .watch-months {
    display: flex;
    align-items: center;
    justify-content: space-between;
    border-top: 2px solid blue;
  }
  .blue-box {
    border: 2px solid blue;
  }
  .light-box {
    border: 1px solid #ccc;
  }
  .watch-task-item:hover {
    background: lightcyan;
  }
  .border-gray {
    border: 1px solid rgba(0, 0, 0, 0.125);
    padding: 1.5em;
    margin-bottom: 10px;
  }
  .vis-task {
    color: #28a745;
    background: #c7ffd4;
    border-color: #28a745;
  }
  .vis-issue {
    color: #ea9800;
    background: #ffe5b5;
    border-color: #ea9800;
  }
  .vis-overdue {
    color: #fff !important;
    background: #000 !important;
    border-color: #000 !important;
  }
  .h-330 {
    height: 330px;
    overflow-y: auto;
  }
  .status-box {
    border: 1px solid;
    border-left: 16px solid;
    font-size: 12px;
  }
</style>
