
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
          class="btn btn-md btn-primary mr-3 addRiskBtn"
          @click.prevent="addNewRisk"
          data-cy="add_risk"
       >
        <font-awesome-icon icon="plus-circle" />
        Add Risk
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
          :risk="events"                   
          @click:event="editRisk"
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
          :risk="calendarRisk"
          ref="menu"
          @open-task="editRisk">  
        </ContextMenu>
      
        </v-calendar>  
      
             
      </v-sheet>
    </v-col>
  </v-row>
  </v-app>
</template>

<script>
 import {mapGetters, mapMutations, mapActions} from "vuex"
 import ContextMenu from "../../../shared/ContextMenu";
  export default {
    name: 'RiskCalendar',
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
        riskNames: [],   
        riskIds:[],       
        riskData: [],
        riskStartDates: [],
        riskEndDates: [],   
        selectedEventId: {},
        calendarRisk: {},
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
        'setTaskIssueOverdueFilter',
        'setTaskTypeFilter',
        'setMyActionsFilter',
        'setOnWatchFilter',
        'setRiskForManager',     
        'setTaskForManager'
      ]),
      ...mapActions([
        'taskDeleted',
        'taskUpdated',
        'updateWatchedTasks'
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
    addNewRisk() {
      this.setRiskForManager({key: 'risk', value: {}})
      // Route to new risk form page
      this.$router.push(
        `/programs/${this.$route.params.programId}/calendar/projects/${this.$route.params.projectId}/risks/new`
      );
    },
    editRisk(event) {   
      let eventObj = event
      this.selectedEventId = eventObj.event.riskId;
      this.calendarRisk = eventObj.event.risk
      console.log(this.selectedEventId)         
      this.$router.push(`/programs/${this.$route.params.programId}/calendar/projects/${this.$route.params.projectId}/risks/${this.selectedEventId}`)
              
    },
    updateRange ({ start, end }) {    
      // Mapping over Task Names, Start Dates, and Due Dates 
      this.riskkData = this.filteredRisks.map(risk => risk)  
      this.riskNames = this.filteredRisks.map(risk=> risk.text)    
      this.riskIds = this.filteredRisks.map(risk => risk.id)      
      this.riskStartDates = this.filteredRisks.map(risk =>risk.startDate)     
      this.riskEndDates = this.filteredRisks.map(risk => risk.dueDate)              
      const events = []
      const min = new Date(`${start.date}T00:00:00`)
      const max = new Date(`${end.date}T23:59:59`)
      const days = (max.getTime() - min.getTime()) / 86400000   
      // For loop to determine length of Tasks 
      for (let i = 0; i < this.filteredRisks.length; i++) {
          events.push({            
          name: this.riskNames[i],
          start: this.riskStartDates[i],
          end: this.riskEndDates[i],
          color: this.colors.defaultColor,
          riskId: this.riskIds[i],
          risk: this.riskData[i]     
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
       'getRiskPriorityLevelFilter',
        'getRiskPriorityLevelFilterOptions',
        'getRisksPerPageFilterOptions',
        'getRisksPerPageFilter',
        'getAdvancedFilterOptions',
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
        'taskTypeFilter',
        'getRiskApproachFilterOptions',
        'getRiskApproachFilter',
        'riskStageFilter',
        'myActionsFilter',
        'onWatchFilter',
        'riskUserFilter',
        'taskTypes',      
       ]),
       _isallowed() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.tasks[salut]
      },
        filteredRisks() {
        let milestoneIds = _.map(this.C_taskTypeFilter, 'id')
        let stageIds = _.map(this.riskStageFilter, 'id')
        let riskApproachIds = _.map(this.C_riskApproachFilter, 'id')
        let riskPriorityLevelFilterIds = _.map(this.C_riskPriorityLevelFilter, 'id')
        let riskPriorityLevelFilter = this.getRiskPriorityLevelFilter        
        let noteDates = this.noteDateFilter
        let taskIssueDueDates = this.taskIssueDueDateFilter
        let taskIssueProgress = this.taskIssueProgressFilter
        let taskIssueUsers = this.getTaskIssueUserFilter
        var filterDataForAdvancedFilterFunction = this.filterDataForAdvancedFilter
        let risks = _.sortBy(_.filter(this.facility.risks, ((resource) => {
          let valid = Boolean(resource && resource.hasOwnProperty('progress'))
          let userIds = [..._.map(resource.checklists, 'userId'), resource.userIds]
          if(taskIssueUsers.length > 0){
            valid = valid && userIds.some(u => _.map(taskIssueUsers, 'id').indexOf(u) !== -1)
          }
          //TODO: For performance, send the whole tasks array instead of one by one
          valid = valid && filterDataForAdvancedFilterFunction([resource], 'facilityManagerRisks')
          if (stageIds.length > 0) valid = valid && stageIds.includes(resource.riskStageId)
          if (taskIssueProgress && taskIssueProgress[0]) {
            var min = taskIssueProgress[0].value.split("-")[0]
            var max = taskIssueProgress[0].value.split("-")[1]
            valid = valid && (resource.progress >= min && resource.progress <= max)
          }
          if (milestoneIds.length > 0) valid = valid && milestoneIds.includes(resource.riskTypeId)
          if (riskApproachIds.length > 0) valid = valid && riskApproachIds.includes(resource.riskApproach)

          if (riskPriorityLevelFilterIds.length > 0) valid = valid && riskPriorityLevelFilterIds.includes(resource.priorityLevelName.toLowerCase())
          // if (search_query) valid = valid && search_query.test(resource.text) ||
          // valid && search_query.test(resource.text) ||
          // valid && search_query.test(resource.riskApproach) ||
          // valid && search_query.test(resource.priorityLevelName) ||
          // valid && search_query.test(resource.userNames)
          return valid;
        })), ['dueDate'])
        return risks
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
   
    },
  watch: {
    filterTree(value) {
      this.$refs.duplicatetree.filter(value);
      this.$refs.movetree.filter(value);
    }
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
.addRiskBtn, .showAll, .todayBtn {
   box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
 }
</style> 