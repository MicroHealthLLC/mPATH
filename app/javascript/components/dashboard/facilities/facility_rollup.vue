<template>
  <div class="m-3">
    <div class="text-info font-weight-bold">Project Type: {{currentProject.projectType}}</div>
    <br>
    <div class="text-center">
      <h2>{{facilityCount}} Facilities</h2>
      <p class="mt-2 d-flex align-items-center">
        <span class="w-100 progress pg-content" :class="{'progress-0': facilityProgress <= 0}">
          <div class="progress-bar bg-info" :style="`width: ${facilityProgress}%`">{{facilityProgress}} %</div>
        </span>
      </p>
      <div v-if="facilityCount > 0" class="d-flex justify-content-around">
        <div>
          <span> active</span>
          <span class="badge badge-secondary badge-pill">{{facilitiesByStatus.active}}</span>
        </div>
        <div>
          <span> inactive</span>
          <span class="badge badge-secondary badge-pill">{{facilitiesByStatus.inactive}}</span>
        </div>
      </div>
    </div>
    <hr>
    <div class="my-1">
      <h5 class="text-center">Facility Project Status</h5>
      <div v-if="facilityCount > 0">
        <div v-for="status in facilitiesByProjectStatus">
          <div class="row">
            <div class="col-md-9">
              <span class="badge badge-pill badge-color" :style="`background: ${status.color}`">&nbsp;</span>
              <span> {{status.name}}</span>
              <span class="badge badge-secondary badge-pill">{{status.length}}</span>
            </div>
            <div class="col-md-3 d-flex align-items-center">
              <span class="w-100 progress pg-content" :class="{'progress-0': status.progress <= 0}">
                <div class="progress-bar bg-info" :style="`width: ${status.progress}%`">{{status.progress}} %</div>
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
    <hr>
    <div class="my-1">
      <h5 class="text-center">{{filteredAllTasks.length}} Tasks</h5>
      <div>
        <div class="row">
          <div class="col-md-9">
            <span>Complete</span>
            <span class="badge badge-secondary badge-pill">{{taskVariation.completed.count}}</span>
          </div>
          <div class="col-md-3 d-flex align-items-center">
            <span class="w-100 progress pg-content" :class="{'progress-0': taskVariation.completed.percentage <= 0}">
              <div class="progress-bar bg-info" :style="`width: ${taskVariation.completed.percentage}%`">{{taskVariation.completed.percentage}} %</div>
            </span>
          </div>
        </div>
        <div class="row">
          <div class="col-md-9">
            <span>Incomplete</span>
            <span class="badge badge-secondary badge-pill">{{taskVariation.incompleted.count}}</span>
          </div>
          <div class="col-md-3 d-flex align-items-center">
            <span class="w-100 progress pg-content" :class="{'progress-0': taskVariation.incompleted.percentage <= 0}">
              <div class="progress-bar bg-info" :style="`width: ${taskVariation.incompleted.percentage}%`">{{taskVariation.incompleted.percentage}} %</div>
            </span>
          </div>
        </div>
        <div class="row">
          <div class="col-md-9">
            <span>Overdue</span>
            <span class="badge badge-secondary badge-pill">{{taskVariation.overdue.count}}</span>
          </div>
          <div class="col-md-3 d-flex align-items-center">
            <span class="w-100 progress pg-content" :class="{'progress-0': taskVariation.overdue.percentage <= 0}">
              <div class="progress-bar bg-info" :style="`width: ${taskVariation.overdue.percentage}%`">{{taskVariation.overdue.percentage}} %</div>
            </span>
          </div>
        </div>
      </div>
      <br>
      <div v-if="filteredAllTasks.length" class="text-info font-weight-bold text-center">Milestones</div>
      <div v-for="task in currentTaskTypes">
        <div class="row" v-if="task._display">
          <div class="col-md-9">
            <span> {{task.name}}</span>
            <span class="badge badge-secondary badge-pill">{{task.length}}</span>
          </div>
          <div class="col-md-3 d-flex align-items-center">
            <span class="w-100 progress pg-content" :class="{ 'progress-0': task.progress <= 0 }">
              <div class="progress-bar bg-info" :style="`width: ${task.progress}%`">{{task.progress}} %</div>
            </span>
          </div>
        </div>
      </div>
    </div>
    <hr>
    <div class="my-1">
      <h5 class="text-center">{{filteredAllIssues.length}} Issues</h5>
      <div>
        <div class="row">
          <div class="col-md-9">
            <span>Complete</span>
            <span class="badge badge-secondary badge-pill">{{issueVariation.completed.count}}</span>
          </div>
          <div class="col-md-3 d-flex align-items-center">
            <span class="w-100 progress pg-content" :class="{'progress-0': issueVariation.completed.percentage <= 0}">
              <div class="progress-bar bg-info" :style="`width: ${issueVariation.completed.percentage}%`">{{issueVariation.completed.percentage}} %</div>
            </span>
          </div>
        </div>
        <div class="row">
          <div class="col-md-9">
            <span>Incomplete</span>
            <span class="badge badge-secondary badge-pill">{{issueVariation.incompleted.count}}</span>
          </div>
          <div class="col-md-3 d-flex align-items-center">
            <span class="w-100 progress pg-content" :class="{'progress-0': issueVariation.incompleted.percentage <= 0}">
              <div class="progress-bar bg-info" :style="`width: ${issueVariation.incompleted.percentage}%`">{{issueVariation.incompleted.percentage}} %</div>
            </span>
          </div>
        </div>
        <div class="row">
          <div class="col-md-9">
            <span>Overdue</span>
            <span class="badge badge-secondary badge-pill">{{issueVariation.overdue.count}}</span>
          </div>
          <div class="col-md-3 d-flex align-items-center">
            <span class="w-100 progress pg-content" :class="{'progress-0': issueVariation.overdue.percentage <= 0}">
              <div class="progress-bar bg-info" :style="`width: ${issueVariation.overdue.percentage}%`">{{issueVariation.overdue.percentage}} %</div>
            </span>
          </div>
        </div>
      </div>
      <br>
      <div v-if="filteredAllIssues.length" class="text-info font-weight-bold text-center">Issue Types</div>
      <div v-for="issue in currentIssueTypes">
        <div class="row" v-if="issue._display">
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
    <hr>
    <div>
      <h5 class="text-center">Facility Groups</h5>
      <div class="row my-2" v-for="facilityGroup in filteredFacilityGroups">
        <div class="col-md-9 font-md">
          <span class="badge badge-pill" :class="{'badge-success':
            facilityGroup.status == 'active', 'badge-danger': facilityGroup.status == 'inactive'}">
            {{facilityGroup.status}}
          </span>
          <span>{{facilityGroup.name}}</span>
          <span class="badge badge-secondary badge-pill">{{facilityGroupFacilities(facilityGroup).length}}</span>
        </div>
        <div class="col-md-3 d-flex align-items-center">
          <span class="w-100 progress pg-content" :class="{'progress-0': facilityGroupProgress(facilityGroup) <= 0}">
            <div class="progress-bar bg-info" :style="`width: ${facilityGroupProgress(facilityGroup)}%`">{{facilityGroupProgress(facilityGroup)}} %</div>
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {mapGetters} from 'vuex'
export default {
  name: 'FacilityRollup',
  computed: {
    ...mapGetters([
      'facilities',
      'currentProject',
      'filteredFacilityGroups',
      'facilityCount',
      'facilityProgress',
      'filteredFacilities',
      'facilityGroupFacilities',
      'taskTypeFilter',
      'issueTypeFilter',
      'taskTypes',
      'issueTypes',
      'filteredAllTasks',
      'filteredAllIssues'
    ]),
    facilitiesByStatus() {
      return {
        active: this.filteredFacilities('active').length,
        inactive: this.filteredFacilities('inactive').length
      }
    },
    facilitiesByProjectStatus() {
      var statuses = new Array
      const active = this.filteredFacilities('active')
      for (var [key, value] of Object.entries(_.groupBy(active, 'projectStatus'))) {
        statuses.push(
          {
            name: key.replace('null', 'No Status'),
            length: value.length,
            color: value[0].color,
            progress: this.getAverage(value.length, active.length)
          }
        )
      }
      return statuses
    },
    currentTaskTypes() {
      var names = this.taskTypeFilter && this.taskTypeFilter.length && _.map(this.taskTypeFilter, 'name')
      var taskTypes = new Array
      for (var type of this.taskTypes) {
        var tasks = _.filter(this.filteredAllTasks, t => t.taskTypeId == type.id)
        taskTypes.push(
          {
            name: type.name,
            _display: tasks.length > 0 && (names ? names.includes(type.name) : true),
            length: tasks.length,
            progress: Number(_.meanBy(tasks, 'progress').toFixed(2))
          }
        )
      }
      return taskTypes
    },
    currentIssueTypes() {
      var names = this.issueTypeFilter && this.issueTypeFilter.length && _.map(this.issueTypeFilter, 'name')
      var issueTypes = new Array
      for (var type of this.issueTypes) {
        var issues = _.filter(this.filteredAllIssues, t => t.issueTypeId == type.id)
        issueTypes.push(
          {
            name: type.name,
            _display: (names ? names.includes(type.name) : true) && issues.length > 0,
            length: issues.length,
            progress: Number(_.meanBy(issues, 'progress').toFixed(2))
          }
        )
      }
      return issueTypes
    },
    taskVariation() {
      var completed = _.filter(this.filteredAllTasks, (t) => t && t.progress && t.progress == 100)
      var completed_percent = this.getAverage(completed.length, this.filteredAllTasks.length)
      var overdue = _.filter(this.filteredAllTasks, (t) => t && t.progress !== 100 && new Date(t.dueDate).getTime() < new Date().getTime())
      var overdue_percent = this.getAverage(overdue.length, this.filteredAllTasks.length)
      var incompleted = this.filteredAllTasks.length - (completed.length + overdue.length)
      var incompleted_percent = incompleted > 0 ? 100 - (completed_percent + overdue_percent) : 0

      return {
        completed: {count: completed.length, percentage: completed_percent},
        incompleted: {count: incompleted, percentage: Number(incompleted_percent.toFixed(2))},
        overdue: {count: overdue.length, percentage: overdue_percent},
      }
    },
    issueVariation() {
      var completed = _.filter(this.filteredAllIssues, (t) => t && t.progress && t.progress == 100)
      var completed_percent = this.getAverage(completed.length, this.filteredAllIssues.length)
      var overdue = _.filter(this.filteredAllIssues, (t) => t && t.progress !== 100 && new Date(t.dueDate).getTime() < new Date().getTime())
      var overdue_percent = this.getAverage(overdue.length, this.filteredAllIssues.length)
      var incompleted = this.filteredAllIssues.length - (completed.length + overdue.length)
      var incompleted_percent = incompleted > 0 ? 100 - (completed_percent + overdue_percent) : 0

      return {
        completed: {count: completed.length, percentage: completed_percent},
        incompleted: {count: incompleted, percentage: Number(incompleted_percent.toFixed(2))},
        overdue: {count: overdue.length, percentage: overdue_percent},
      }
    }
  },
  methods: {
    facilityGroupProgress(f_group) {
      var ids = _.map(this.filteredFacilities('active'), 'id')
      var mean = _.meanBy(_.filter(f_group.facilities, (f => ids.includes(f.facilityId) && f.projectId == this.currentProject.id)), 'progress') || 0
      return Number(mean.toFixed(2))
    }
  }
}
</script>

<style scoped lang="scss">
  .badge-color {
    height: 12px;
    padding-top: 2px;
  }
</style>
