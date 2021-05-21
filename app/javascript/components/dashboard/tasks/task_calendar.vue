
<template>
<div>
   <span class="filters-wrapper w-75">
      <div class="d-flex align-item-center justify-content-between mb-2 w-100">
        <div class="input-group task-search-bar w-100">
           <el-input
            type="search"          
            placeholder="Search Tasks"
            aria-label="Search"            
            aria-describedby="search-addon"    
            v-model="tasksQuery"     
            data-cy="search_tasks"
        >
          <el-button slot="prepend" icon="el-icon-search"></el-button>
        </el-input>
        </div>
        <div class="mx-1 w-100">
         <!-- <label class="font-sm my-0">Category</label> -->
          <el-select
           v-model="C_taskTypeFilter"
          :key="componentKey"   
           class="w-100"          
           track-by="name"
           value-key="id"
           multiple
           placeholder="Select Category"
           collapse-tags
           >
          <el-option
            v-for="item in taskTypes"
            :value="item"
            :key="item.id"
            :label="item.name"
            >
          </el-option>
          </el-select>
        </div>

        <div class="w-100">
          <!-- <label class="font-sm my-0">Flags</label> -->
           <el-select
           v-model="C_calendarTaskFilter"
          :key="componentKey"   
           class="w-100"
           track-by="name"
           value-key="id"
           multiple
           placeholder="Filter by Flags"
           collapse-tags
           >
          <el-option
            v-for="item in getAdvancedFilterOptions"
            :value="item"
            :key="item.id"
            :label="item.name"
            >
          </el-option>
          </el-select>
        </div>
    </div>
   </span>
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
        <div
          class="mr-3"
          >        
      
        </div>
          <div
          class="mr-3"
          > 
          <v-btn
            fab
            text
            small
            class="back-forth-btn"
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
            class="back-forth-btn"
            small
            color="grey darken-2"
            @click="next"
          >
            <v-icon small>
              mdi-chevron-right
            </v-icon>
          </v-btn>
            </div>   

          <v-toolbar-title v-if="$refs.calendar" class="monthTitle">
            {{ $refs.calendar.title }}
          </v-toolbar-title>
          <v-spacer></v-spacer>
           <v-checkbox
            v-model="checkbox"
            class="mr-5 mt-6 mb-0"
            :key="componentKey"         
            @click="showAllEvents"
            :label="`Show All`"
          ></v-checkbox>
           <v-btn        
            class="mr-4 todayBtn"          
            @click="setToday"
            small
            elevation="0"
            >
            <font-awesome-icon icon="calendar-check" class="mr-1 today-icon"  />
            Today
            </v-btn>
          
           <v-btn-toggle
            v-model="C_calendarView"          
             >
             <v-btn    
              v-for="item in getCalendarViewFilterOptions"
              :value="item"
              :key="item.id"
              :label="item.name"
              small
            >
            <span v-if="item.id == 'day'"><font-awesome-icon icon="calendar-day" class="mr-1"  /> Day</span>
            <span v-if="item.id == 'week'"><font-awesome-icon icon="calendar-week" class="mr-1"  /> Week</span>
            <span v-if="item.id == 'month'"><font-awesome-icon icon="calendar-alt" class="mr-1"  /> Month</span>
            <span v-if="item.id == '4day'"><font-awesome-icon icon="calendar-minus" class="mr-1"  /> 4 Day</span>
         
            </v-btn>        
           </v-btn-toggle>   

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
          @contextmenu:event="showSummary"         
        >            
        </v-calendar>  
         <v-menu
          v-model="selectedOpen"
          :close-on-content-click="false"
          :activator="selectedElement"         
          class="actionSummary"  
          max-width="330"          
        >
       <v-card class="actionSummary p-2" max-width="330">       
        <table class="w-100 text-center contextTable">
          <!-- <thead class="p-2"> -->
          <tr>
            <th>
           <h4>
            {{ selectedEvent.name }}
           </h4>
             </th>  
          </tr>        
    
          <!-- <body class="w-100 p-2 text-center"> -->
          <tr>
            <td class="bg-light p-1"><b>Category</b></td>           
          </tr>
          <tr>
             <td>{{ selectedEvent.category }}</td>
          </tr>

          <tr>
            <td class="bg-light p-1"><b>Start Date</b></td>           
          </tr> 
          <tr>
             <td>{{ selectedEvent.start }}</td>    
          </tr>
          <tr>
            <td class="bg-light p-1"><b>Due Date</b></td>           
          </tr> 
           <tr>           
            <td>{{ selectedEvent.end }}</td>    
          </tr> 
         
           <tr>
            <td class="bg-light p-1"><b>Progress</b></td>         
           </tr> 
           <tr>           
             <td>{{ selectedEvent.progess }}%</td>    
           </tr> 
          <tr>
           <td class="bg-light p-1"><b>Flags</b></td>            
          </tr> 
          <tr>         
           <td>
            <span v-if="selectedEvent.watch == true"  v-tooltip="`On Watch`"><font-awesome-icon icon="eye" class="mr-1"  /></span>
              <span v-if="selectedEvent.pastDue == true" v-tooltip="`Overdue`"><font-awesome-icon icon="calendar" class="text-danger mr-1"  /></span>
              <span v-if="selectedEvent.progess == 100" v-tooltip="`Completed Task`"><font-awesome-icon icon="clipboard-check" class="text-success"  /></span>    
           </td>
          </tr> 
          <!-- </body> -->
        </table>

        <v-card-actions>
          <v-spacer></v-spacer>
       

          <!-- <v-btn
            text
            @click="menu = false"
          >
            Cancel
          </v-btn>
          <v-btn
            color="primary"
            text
            @click="menu = false"
          >
            Save
          </v-btn> -->
        </v-card-actions>
      </v-card>
    </v-menu>  

      </v-sheet>
    </v-col>
  </v-row>
  </v-app>
</div>
</template>

<script>
 import {mapGetters, mapMutations, mapActions} from "vuex"
 import { library } from '@fortawesome/fontawesome-svg-core'
 import { faCalendarAlt, faCalendarCheck, faCalendarDay, faCalendarWeek, faEye, faCalendar, faClipboardCheck } from '@fortawesome/free-solid-svg-icons'
 import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
 library.add(faCalendarDay, faCalendarWeek, faCalendarAlt, faCalendarCheck, faEye, faCalendar, faClipboardCheck)
 Vue.component('font-awesome-icon', FontAwesomeIcon)

  export default {
    name: 'TaskCalendar',
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
        tasksQuery: '',
        taskNames: [], 
        taskIds:[],       
        checkbox: false,
        taskData: [],     
        componentKey: 0,
        taskStartDates: [],       
        taskEndDates: [],   
        selectedEventId: {},
        selectedEvent: {},
        calendarTask: {},
        selectedElement: null,      
        selectedOpen: false,
        events: [],
        names: [],          
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
        this.todayView = true 
        this.focus = ''       
      },
      prev () {
        this.$refs.calendar.prev()
      },
      next () {
        this.$refs.calendar.next()
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
      showAllEvents(){
      this.checkbox == !this.checkbox
        if (this.checkbox == true) {
          this.reRenderCalendar()
        } else if (this.checkbox == false){
           this.reRenderCalendar()
        }
      },
      showSummary ({ nativeEvent, event }) {        
        const open = () => {
          this.selectedEvent = event
          this.selectedElement = nativeEvent.target
          requestAnimationFrame(() => requestAnimationFrame(() => this.selectedOpen = true))         
        }        
        if (this.selectedOpen) {
          this.selectedOpen = false
          requestAnimationFrame(() => requestAnimationFrame(() => open()))
        } else {
          open()
        }

        nativeEvent.stopPropagation()
      },
      updateRange ({ start, end }) {    
        // Mapping over Task Names, Start Dates, and Due Dates 
      if (this.filteredCalendar !== undefined && this.filteredCalendar.length > 0) {
        this.taskData = this.filteredCalendar.map(task => task)  
        this.taskNames = this.filteredCalendar.map(task => task.text)    
        this.taskIds = this.filteredCalendar.map(task => task.id)      
        this.taskStartDates = this.filteredCalendar.map(task => task.startDate)     
        this.taskEndDates = this.filteredCalendar.map(task => task.dueDate) 
        this.categories = this.filteredCalendar.map(task => task.taskType) 
        this.onWatch = this.filteredCalendar.map(task => task.watched)   
        this.overdue = this.filteredCalendar.map(task => task.isOverdue) 
        this.percentage = this.filteredCalendar.map(task => task.progress)
           
        const events = []
        const min = new Date(`${start.date}T00:00:00`)
        const max = new Date(`${end.date}T23:59:59`)
        const days = (max.getTime() - min.getTime()) / 86400000   
        // For loop to determine length of Calendar Tasks 
        for (let i = 0; i < this.filteredCalendar.length; i++) {
            events.push({            
            name: this.taskNames[i],
            start: this.taskStartDates[i],
            end: this.taskEndDates[i],         
            taskId: this.taskIds[i],
            task: this.taskData[i] ,
            category: this.categories[i],  
            watch: this.onWatch[i],
            pastDue: this.overdue[i], 
            progess: this.percentage[i]  
            // timed: !allDay,            
          })
        }
          // This is the main Events array pushed into Calendar
        //  this.events = events
         if (this.checkbox == false && !(this.tasksQuery.length > 0) ) {
           this.events = []
         } else 
          this.events = events
       }      
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
        'getDayView',
        'getMonthView',
        'getWeekView',
        'getCalendarViewFilter',
        'filterDataForAdvancedFilter', 
        'getAdvancedFilter',     
        'getTaskIssueProgressStatusOptions',
        'getTaskIssueProgressStatusFilter',
        'taskIssueProgressFilter',
        'getTaskIssueOverdueOptions',
        'taskIssueOverdueFilter',
        'noteDateFilter',
        'taskIssueDueDateFilter',
        'taskTypeFilter', 
        'myActionsFilter',
        'onWatchFilter',
        "currentTasks",
        "contentLoaded",
        "currentIssues",
        "viewPermit",
        "currentProject",
        'taskUserFilter',
        'taskTypes',    
     
       ]),
       _isallowed() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.tasks[salut]
      },
      filteredCalendar() {
        let search_query = this.exists(this.tasksQuery.trim()) ? new RegExp(_.escapeRegExp(this.tasksQuery.trim().toLowerCase()), 'i') : null
        const filterDataForAdvancedFilterFunction = this.filterDataForAdvancedFilter
        let tasks = _.sortBy(_.filter(this.facility.tasks, (resource) => {
        let valid = Boolean(resource && resource.hasOwnProperty('progress'))        
        valid = valid && filterDataForAdvancedFilterFunction([resource], 'sheetsTasks')
         
         if (search_query) valid = valid && search_query.test(resource.text)
         
        return valid
        }), ['dueDate'])
    
        return tasks
    }, 
     C_calendarTaskFilter: {           
        get() {
          this.reRenderCalendar()
          return this.getAdvancedFilter
        },
        set(value) {
          this.setAdvancedFilter(value)
        }
      },
      C_taskIssueProgressStatusFilter: {
        get() {
          if (this.getTaskIssueProgressStatusFilter.length < 1) {
            this.setTaskIssueProgressStatusFilter([{ id: 'active', name: 'active' }])
          }
          return this.getTaskIssueProgressStatusFilter
        },
        set(value) {
          this.setTaskIssueProgressStatusFilter(value)
        }
      },
      C_taskIssueOverdueFilter: {
        get() {
          return this.taskIssueOverdueFilter
        },
        set(value) {
          this.setTaskIssueOverdueFilter(value)
        }
      },
      C_taskTypeFilter: {
        get() {           
          return this.taskTypeFilter
        },
        set(value) {
          this.reRenderCalendar()     
          this.setTaskTypeFilter(value)
        }
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
    tasksQuery: {
      handler() {
       if(this.tasksQuery.length > 0) {
         this.checkbox = false;
         this.reRenderCalendar()
       } else if (!(this.tasksQuery.length > 0) && this.checkbox == false) {
         this.events = [];
         this.reRenderCalendar()
       }
      },
    },
    checkbox: {
      handler() {
       if(this.checkbox == false) {
         this.reRenderCalendar()
         this.events = [];
       } else if (this.checkbox == true) {
         this.tasksQuery = "";
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
/deep/.v-event-start {
  border-left-color: #41b883 !important;
  border-left-width: thick;
  border-left-style: double;
  border-top-left-radius: 0;
  border-bottom-left-radius: 0;
  padding-left: 3px;
  

}
/deep/.v-event-end {
  border-right-color: #d9534f !important;
  border-right-width: thick;
  border-right-style: double;
  border-top-right-radius: 0;
  border-bottom-right-radius: 0;
  text-align: right;
  font-weight: 500;  
  padding-right: 3px;
}
.addTaskBtn, .exportBtns, .showAll {
   box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
 }
 .filters-wrapper {
  float: right;
  margin-top: -55px;
}
/deep/.v-event {
  visibility: hidden;
}
/deep/.v-event.v-event-start, /deep/.v-event.v-event-end {
  visibility: visible !important;
  font-weight: 500 !important;

}
/deep/.v-menu__content {
  position: absolute !important;
  z-index: 100;
  top: 50% !important;
  left: 50% !important;
  transform: translate(-50%, -50%) !important;
}
/deep/.v-input__slot {
  .v-label {
    margin-top: 0.5rem
  }
}
.monthTitle {
  font-weight: 500;
  font-size: 1.5rem;
}
input[type=search] {
    color: #383838;
    text-align: left;
    cursor: pointer;
    display: block;
 }
 .contextTable {
   border: solid 1px lightgray;
   td {
    border: solid 1px lightgray;
   }
 }

</style> 