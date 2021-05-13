
<template>
  <v-app id="app" class="mt-4 mr-2">
  <v-row class="fill-height">
    <v-col class="pt-0">
      <v-sheet height="64">
        <v-toolbar
          flat
        >
         <button
          v-if="_isallowed('write')"
          class="btn btn-md btn-primary mr-3 addTaskBtn"
          @click.prevent="addNewTask"
          data-cy="add_task"
       >
        <font-awesome-icon icon="plus-circle" />
        Add Task
        </button>         
          <v-btn
            fab
            text
            small
            color="grey darken-2"
            @click="prev"
          >
            <v-icon small>
              mdi-chevron-left
            </v-icon>
          </v-btn>
          <v-btn
            fab
            text
            small
            color="grey darken-2"
            @click="next"
          >
            <v-icon small>
              mdi-chevron-right
            </v-icon>
          </v-btn>
          <v-toolbar-title v-if="$refs.calendar">
            {{ $refs.calendar.title }}
          </v-toolbar-title>
          <v-spacer></v-spacer>
           <el-button         
            class="todayBtn mr-4"          
            @click="setToday"
          >
            Today
          </el-button>
          <el-select
            v-model="C_calendarView" 
            :load="log(JSON.stringify(C_calendarView))"
            track-by="value"
            value-key="id"            
          >
          <el-option
            v-for="item in getCalendarViewFilterOptions"
              :load="log(JSON.stringify(getCalendarViewFilterOptions))"
            :value="item"
            :key="item.id"
            :label="item.name"
            >
          </el-option>
          </el-select>

        </v-toolbar>
      </v-sheet>
    
      <v-sheet height="550"    >     
         <v-calendar                      
          ref="calendar"
          v-model="focus"
          color="primary"
          :events="events"         
          :event-color="getEventColor"
          :type="C_calendarView.id"      
          :task="events"   
          :key="componentKey"                
          @click:event="editTask"
          @click:more="viewDay"
          @click:date="viewDay"
          @change="updateRange"
          @mouseup.right="openContextMenu" 
          @contextmenu.prevent=""          
        >        
         <ContextMenu
        :facilities="facilities"
        :facilityGroups="facilityGroups" 
        :display="showContextMenu"
        :task="calendarTask"
        ref="menu"
        @open-task="editTask">  
       </ContextMenu>      
        </v-calendar>   
             
      </v-sheet>
    </v-col>
  </v-row>
  </v-app>
</template>

<script>
 import {mapGetters, mapMutations, mapActions} from "vuex"
 import ContextMenu from "../../shared/ContextMenu";
  export default {
    name: 'TaskCalendar',
    components: {ContextMenu},
    props:
      {
      fromView: {
        type: String,
        default: "map_view",
      },    
      facility: Object, 
     },
    data() {
      return {         
        focus: '',        
        type: this.C_calendarView,       
        taskNames: [],    
        taskIds:[],       
        taskData: [],
        componentKey: 0,
        taskStartDates: [],       
        taskEndDates: [],   
        selectedEventId: {},
        calendarTask: {},
        selectedElement: null,      
        selectedOpen: false,
        showContextMenu: false,
        events: [],
        names: [],      
        colors: {
          onScheduleColor: '#5cb85c',
          defaultColor: 'rgba(214, 219, 223, .5)',
          warningColor: '#f0ad4e',
          pastDueColor: '#d9534f',
        },        
      }
    },
    mounted () {   
    this.$refs.calendar.checkChange();
    },
    methods: {
     ...mapMutations([
        'setAdvancedFilter',
        'setTaskIssueProgressStatusFilter',
        'setCalendarViewFilter',
        'setTaskIssueOverdueFilter',
        'setTaskTypeFilter',
        'setMyActionsFilter',
        'setOnWatchFilter',     
        'setTaskForManager'
      ]),
       ...mapActions([
        'taskDeleted',
        'taskUpdated',
        'updateWatchedTasks'
      ]), 
       reRenderCalendar() {
        this.componentKey += 1;
      },
      viewDay ({ date }) {
        this.focus = date
        this.type = 'day'
      },
      getEventColor (event) {
        return event.color
      },
      setToday () {
        this.focus = ''  
      },
      prev () {
        this.$refs.calendar.prev()
      },
      next () {
        this.$refs.calendar.next()
      }, 
     openContextMenu(e) {
      e.preventDefault();
      this.$refs.menu.open(e);
    },
      addNewTask() {
      this.setTaskForManager({key: 'task', value: {}})
      // Route to new task form page
      this.$router.push(
        `/programs/${this.$route.params.programId}/calendar/projects/${this.$route.params.projectId}/tasks/new`
        );
      },
      editTask(event) {   
        let eventObj = event
        this.selectedEventId = eventObj.event.taskId;
        this.calendarTask = eventObj.event.task       
        this.$router.push(`/programs/${this.$route.params.programId}/calendar/projects/${this.$route.params.projectId}/tasks/${this.selectedEventId}`)        
      },
      updateRange ({ start, end }) {    
        // Mapping over Task Names, Start Dates, and Due Dates 
       this.taskData = this.filteredTasks.map(task => task)  
       this.taskNames = this.filteredTasks.map(task => task.text)    
       this.taskIds = this.filteredTasks.map(task => task.id)      
       this.taskStartDates = this.filteredTasks.map(task => task.startDate)     
       this.taskEndDates = this.filteredTasks.map(task => task.dueDate)              
        const events = []
        const min = new Date(`${start.date}T00:00:00`)
        const max = new Date(`${end.date}T23:59:59`)
        const days = (max.getTime() - min.getTime()) / 86400000   
        // For loop to determine length of Tasks 
        for (let i = 0; i < this.filteredTasks.length; i++) {
            events.push({            
            name: this.taskNames[i],
            start: this.taskStartDates[i],
            end: this.taskEndDates[i],
            color: this.colors.defaultColor,
            taskId: this.taskIds[i],
            task: this.taskData[i]     
            // timed: !allDay,            
          })
        }
        // This is the main Events array pushed into Calendar
        this.events = events
      },     
      rnd (a, b) {
        return Math.floor((b - a + 1) * Math.random()) + a
      },    
    },

    computed: {
     ...mapGetters([
        "facilities",
        "facilityGroups",
        'getAdvancedFilterOptions',
        'getCalendarViewFilterOptions',
        'calendarViewFilter',
        'getCalendarViewFilter',
        'filterDataForAdvancedFilter',
        'getTasksPerPageFilterOptions',
        'getTasksPerPageFilter',
        'getTaskIssueUserFilter',
        'getAdvancedFilter',
        'getTaskIssueTabFilterOptions',
        'getTaskIssueProgressStatusOptions',
        'getTaskIssueProgressStatusFilter',
        'taskIssueProgressFilter',
        'getTaskIssueOverdueOptions',
        'taskIssueOverdueFilter',
        'noteDateFilter',
        'taskIssueDueDateFilter',
        'taskTypeFilter',
        'taskStageFilter',
        'myActionsFilter',
        'onWatchFilter',
        "currentTasks",
        "contentLoaded",
        "currentIssues",
        "viewPermit",
        "currentProject",
        'taskUserFilter',
        'taskTypes',
        'viewPermit',
     
       ]),
       _isallowed() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.tasks[salut]
      },
      filteredTasks() {
        let typeIds = _.map(this.C_taskTypeFilter, 'id')
        let stageIds = _.map(this.taskStageFilter, 'id')      
        let noteDates = this.noteDateFilter
        let taskIssueDueDates = this.taskIssueDueDateFilter
        let taskIssueProgress = this.taskIssueProgressFilter
        let taskIssueUsers = this.getTaskIssueUserFilter
        var filterDataForAdvancedFilterFunction = this.filterDataForAdvancedFilter
        let tasks = _.sortBy(_.filter(this.facility.tasks, (resource) => {
          let valid = Boolean(resource && resource.hasOwnProperty('progress'))
          let userIds = [..._.map(resource.checklists, 'userId'), ...resource.userIds]
          if (taskIssueUsers.length > 0) {
            if(taskIssueUsers.length > 0){
              valid = valid && userIds.some(u => _.map(taskIssueUsers, 'id').indexOf(u) !== -1)
            }
          }
          //TODO: For performance, send the whole tasks array instead of one by one
          valid = valid && filterDataForAdvancedFilterFunction([resource], 'sheetsTasks')
          if (stageIds.length > 0) valid = valid && stageIds.includes(resource.taskStageId)
          if (typeIds.length > 0) valid = valid && typeIds.includes(resource.taskTypeId)
          if (noteDates && noteDates[0] && noteDates[1]) {
            var startDate = moment(noteDates[0], "YYYY-MM-DD")
            var endDate = moment(noteDates[1], "YYYY-MM-DD")
            var _notesCreatedAt = _.map(resource.notes, 'createdAt')
            var is_valid = resource.notes.length > 0
            for (var createdAt of _notesCreatedAt) {
              var nDate = moment(createdAt, "YYYY-MM-DD")
              is_valid = nDate.isBetween(startDate, endDate, 'days', true)
              if (is_valid) break
            }
            valid = valid && is_valid
          }
          if (taskIssueDueDates && taskIssueDueDates[0] && taskIssueDueDates[1]) {
            var startDate = taskIssueDueDates[0]
            var endDate = taskIssueDueDates[1]
            var is_valid = true
            var nDate = moment(resource.dueDate, "YYYY-MM-DD")
            is_valid = nDate.isBetween(startDate, endDate, 'days', true)
            valid = valid && is_valid
          }
          if (taskIssueProgress && taskIssueProgress[0]) {
            var min = taskIssueProgress[0].value.split("-")[0]
            var max = taskIssueProgress[0].value.split("-")[1]
            valid = valid && (resource.progress >= min && resource.progress <= max)
          }
     
          return valid
        }), ['dueDate'])
        return tasks    

      }, 
    C_calendarView: {
      get() {
        return this.getCalendarViewFilter || {id: 'month', name: 'Month', value: 'month'}
      },
      set(value) {
        this.setCalendarViewFilter(value)
      }
     }
    },   
  watch: {
   contentLoaded: {
      handler() {
        if (this.$route.params.projectId && this.currentFacility.tasks.length > 0) {
          this.reRenderCalendar()
          this.currentFacility = this.facilities.find(
            (facility) => facility.facilityId == this.$route.params.projectId
          );
        }
      },
    },
    currentFacility: {
      handler() {
        this.currentFacilityGroup = this.facilityGroups.find(
          (group) => group.id == this.currentFacility.facility.facilityGroupId
        );

        this.expanded.id = this.currentFacilityGroup.id;
      },
    },
    facilities: {
      handler() {
        this.currentFacility = this.facilities.find(
          (facility) => facility.facilityId == this.$route.params.projectId
        );
      },
    },
  },
    filterTree(value) {
      this.$refs.duplicatetree.filter(value);
      this.$refs.movetree.filter(value);
    }
  }
</script>

<style lang="scss" scoped>
/deep/.v-toolbar__content {
  padding-left: 0;
  padding-right: 0;
}
/deep/.v-event {
  color: #383838 !important;
}
.addTaskBtn, .exportBtns, .showAll, .todayBtn {
   box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
 }
</style> 