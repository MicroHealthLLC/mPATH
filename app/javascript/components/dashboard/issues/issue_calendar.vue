
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
          @click.prevent="addNewIssue"
          data-cy="add_issue"
       >
        <font-awesome-icon icon="plus-circle" />
        Add Issue
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
            v-model="type" 

            track-by="id"
            value-key="id"     
          >
          <el-option
            v-for="item in typeToLabel"
            :value="item.id"
            :key="item.id"
            :label="item.name"
            >
          </el-option>
          </el-select>

        </v-toolbar>
      </v-sheet>
    
      <v-sheet height="600" >     
         <v-calendar               
          ref="calendar"
          v-model="focus"
          color="primary"
          :events="events"
          :event-color="getEventColor"
          :type="type"      
          :issue="events"                   
          @click:event="editIssue"
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
          :issue="calendarIssue"
          ref="menu"
          @open-issue="editIssue">  
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
    name: 'IssueCalendar',
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
        type: 'month',       
        issueNames: [],   
        issueIds:[],       
        issueData: [],
        issueStartDates: [],
        issueEndDates: [],   
        selectedEventId: {},
        calendarIssue: {},
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
        'setIssuesPerPageFilter',
        'setTaskIssueOverdueFilter',
        'setIssueTypeFilter',
        'setIssueSeverityFilter',
        'setTaskTypeFilter',
        'setMyActionsFilter',
        'setToggleRACI',
        'updateFacilityHash',
        'setTaskForManager',
        'setOnWatchFilter'
      ]),
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
     addNewIssue() {
      this.setTaskForManager({key: 'issue', value: {}})
      // Route to new issue form page
      this.$router.push(
        `/programs/${this.$route.params.programId}/calendar/projects/${this.$route.params.projectId}/issues/new`
        );
    },
     editIssue(event) {   
        let eventObj = event
        this.selectedEventId = eventObj.event.issueId;
        this.calendarIssue = eventObj.event.issue
        console.log(this.selectedEventId)         
        this.$router.push(`/programs/${this.$route.params.programId}/calendar/projects/${this.$route.params.projectId}/issues/${this.selectedEventId}`)        
      },
      updateRange ({ start, end }) {    
        // Mapping over Task Names, Start Dates, and Due Dates 
       this.issueData = this.filteredIssues.map(issue => issue)  
       this.issueNames = this.filteredIssues.map(issue=> issue.title)    
       this.issueIds = this.filteredIssues.map(issue => issue.id)      
       this.issueStartDates = this.filteredIssues.map(issue => issue.startDate)     
       this.issueEndDates = this.filteredIssues.map(issue => issue.dueDate)              
        const events = []
        const min = new Date(`${start.date}T00:00:00`)
        const max = new Date(`${end.date}T23:59:59`)
        const days = (max.getTime() - min.getTime()) / 86400000   
        // For loop to determine length of Tasks 
        for (let i = 0; i < this.filteredIssues.length; i++) {
            events.push({            
            name: this.issueNames[i],
            start: this.issueStartDates[i],
            end: this.issueEndDates[i],
            color: this.colors.defaultColor,
            issueId: this.issueIds[i],
            issue: this.issueData[i]     
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
        'getIssuesPerPageFilterOptions',
        'getIssuesPerPageFilter',
        'filterDataForAdvancedFilter',
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
        'currentProject',
        'issueTypes',
        'taskTypes',
        'issueSeverities',
        'issueTypeFilter',
        'issueSeverityFilter',
        'issueStageFilter',
        'taskTypeFilter',
        'issueUserFilter',
        'myActionsFilter',
        'managerView',
        'onWatchFilter',
        'viewPermit',
        'getToggleRACI'
      ]),
      _isallowed() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.issues[salut]
      },
      filteredIssues() {
        let typeIds = _.map(this.C_issueTypeFilter, 'id')
        let taskTypeIds = _.map(this.C_taskTypeFilter, 'id')
        let severityIds = _.map(this.C_issueSeverityFilter, 'id')
        let stageIds = _.map(this.issueStageFilter, 'id')
        // const search_query = this.exists(this.issuesQuery.trim()) ? new RegExp(_.escapeRegExp(this.issuesQuery.trim().toLowerCase()), 'i') : null
        let noteDates = this.noteDateFilter
        let taskIssueDueDates = this.taskIssueDueDateFilter
        let taskIssueProgress = this.taskIssueProgressFilter
        let taskIssueUsers = this.getTaskIssueUserFilter
        var filterDataForAdvancedFilterFunction = this.filterDataForAdvancedFilter
        let issues = _.sortBy(_.filter(this.facility.issues, ((resource) => {
          let valid = Boolean(resource && resource.hasOwnProperty('progress'))
          let userIds = [..._.map(resource.checklists, 'userId'), ...resource.userIds]
          if (taskIssueUsers.length > 0) {
            if(taskIssueUsers.length > 0){
              valid = valid && userIds.some(u => _.map(taskIssueUsers, 'id').indexOf(u) !== -1)
            }
          }
          //TODO: For performance, send the whole tasks array instead of one by one
          valid = valid && filterDataForAdvancedFilterFunction([resource], 'sheetsIssues')
          if (typeIds.length > 0) valid = valid && typeIds.includes(resource.issueTypeId)
          if (taskTypeIds.length > 0) valid = valid && taskTypeIds.includes(resource.taskTypeId)
          if (severityIds.length > 0) valid = valid && severityIds.includes(resource.issueSeverityId)
          if (stageIds.length > 0) valid = valid && stageIds.includes(resource.issueStageId)
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
            var startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD")
            var endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD")
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

          // if (search_query) valid = valid && search_query.test(resource.title) ||
          //   valid && search_query.test(resource.issueType) ||
          //   valid && search_query.test(resource.issueSeverity) ||
          //   valid && search_query.test(resource.userNames)
          return valid;
        })), ['dueDate'])
        return issues
      },
      C_sheetsIssueFilter: {
        get() {
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
      C_issueTypeFilter: {
        get() {
          return this.issueTypeFilter
        },
        set(value) {
          this.setIssueTypeFilter(value)
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
      C_issuesPerPage: {
        get() {
          return this.getIssuesPerPageFilter || {id: 15, name: '15', value: 15}
        },
        set(value) {
          this.setIssuesPerPageFilter(value)
        }
     },
    typeToLabel () {  
      var options = [
        {id: 'month', name: 'Month', value: 'month'},
        {id: 'week', name: 'Week', value: 'week'},
        {id: 'day', name: 'Day', value: 'day'},
        {id: '4day', name: '4 Days', value: '4day'}, 
      ]
      return options;
      },       
   
    }
  }
</script>

<style scoped lang="scss">

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
