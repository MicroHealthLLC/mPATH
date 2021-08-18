
<template>
<div>
   <span class="filters-wrapper">
      <div class="d-flex align-item-center justify-content-between mb-2 w-100">
        <div class="task-search-bar w-100">
        <label class="font-sm mb-0" style="visibility:hidden">Search</label>
           <el-input
            type="search"          
            placeholder="Enter Search Criteria"
            aria-label="Search"            
            aria-describedby="search-addon"    
            v-model="issuesQuery"     
            data-cy="search_tasks"
        >
          <el-button slot="prepend" icon="el-icon-search"></el-button>
        </el-input>
        </div>
        <div class="mx-1 ninety">
         <label class="font-sm my-0">Process Area</label>
          <el-select
           v-model="C_taskTypeFilter"
          :key="componentKey"   
           class="w-100"          
           track-by="name"
           value-key="id"
           multiple
           placeholder="Select Process Area"
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
        <label class="font-sm mb-0">Flags</label>
             <span class="d-flex px-0 mr-1" :class="[getShowCount == true ? '': 'toggleHeight']">
               <span class="one statesCol px-2 mr-1 d-flex">
                 <div class="pt-1 pr-3 text-center d-inline-block icons" :class="[getHideComplete == true ? 'light':'']" @click.prevent="toggleComplete" >                              
                   <span class="d-block" v-tooltip="`COMPLETE`" >
                    <i class="fas fa-clipboard-check" :class="[getHideComplete == true ? 'light':'text-success']"></i>
                    </span>      
               
                   <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{variation.completed.count}}</h6>  
                  </div>
                 <div class="pr-3 pt-1 text-center d-inline-block icons" :class="[getHideInprogress == true ? 'light':'']" @click.prevent="toggleInprogress">                              
                   <span v-tooltip="`IN PROGRESS`" class="d-block">
                    <i class="far fa-tasks" :class="[getHideInprogress == true ? 'light':'text-primary']"></i>
                    </span>      
                
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.inProgress.count }}</h6>
                  </div>
                   <div class="pr-3 pt-1 text-center d-inline-block icons" :class="[getHidePlanned == true ? 'light':'']" @click.prevent="togglePlanned">                              
                   <span v-tooltip="`PLANNED`" class="d-block">
                    <i class="fas fa-calendar-check"  :class="[getHidePlanned == true ? 'light':'text-info']"></i>
                    </span>      
                
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.planned.count }}</h6>
                  </div>
                  <div class="pr-3 pt-1 text-center d-inline-block icons" :class="[getHideOverdue == true ? 'light':'']" @click.prevent="toggleOverdue" >                              
                   <span v-tooltip="`OVERDUE`" class="d-block">
                    <i class="fas fa-calendar" :class="[getHideOverdue == true ? 'light':'text-danger']"></i>
                    </span>      
                
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.overdue.count }}</h6>
                  </div>
            
                  <div class="pr-3 pt-1 text-center d-inline-block icons" :class="[getHideOnhold == true ? 'light':'']"  @click.prevent="toggleOnhold"  >                              
                   <span v-tooltip="`ON HOLD`"  class="d-block">
                    <i class="fas fa-pause-circle" :class="[getHideOnhold == true ? 'light':'text-primary']"></i>
                    </span>      
        
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.onHold.count }}</h6>
                  </div>
                  <div class="pr-1 pt-1 text-center d-inline-block icons"  :class="[getHideDraft == true ? 'light':'']"  @click.prevent="toggleDraft" >                              
                   <span v-tooltip="`DRAFT`" class="d-block">
                    <i class="fas fa-pencil-alt"  :class="[getHideDraft == true ? 'light':'text-warning']"></i>
                    </span>      
         
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.drafts.count }}</h6>
                  </div>
                
  
               </span>
                <!-- <label>Tafsd</label> -->
               <span class="tagsCol px-2 d-flex">
     
                  <div class="pr-3 pt-1 text-center d-inline-block icons" :class="[getHideWatched == true ? '':'light']" @click.prevent="toggleWatched"  >                              
                   <span v-tooltip="`ON WATCH`"  class="d-block">
                    <i class="fas fa-eye"></i>
                    </span>      
          
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.watched.count }}</h6>
                  </div>
  
                  <div class="pr-3 pt-1 text-center d-inline-block icons" :class="[getHideImportant == true ? '':'light']" @click.prevent="toggleImportant">                              
                   <span v-tooltip="`IMPORTANT`" class="d-block">
                    <i class="fas fa-star" :class="[getHideImportant == true ? 'text-warning':'light']"></i>
                    </span>      
          
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.important.count }}</h6>
                  </div>
                  <div class="pr-2 pt-1 text-center d-inline-block icons" :class="[getHideBriefed == true ? '':'light']" @click.prevent="toggleBriefed">                              
                   <span v-tooltip="`BRIEFINGS`" class="d-block">
                    <i class="fas fa-presentation" :class="[getHideBriefed == true ? 'text-primary':'']"></i>
                    </span>      
                   <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.briefings.count }}</h6>
                  </div>  

               </span>

          <div class="d-inline-block mx-0">
            <v-checkbox     
              v-model="C_showCountToggle"     
              class="d-inline-block mt-0 px-2 ml-1"  
              @click.prevent="showCounts"               
              v-tooltip="`Show Counts`"
          ></v-checkbox>
            </div>
            </span>
      
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
          @click.prevent="addNewIssue"
          data-cy="add_issue"
       >
        <font-awesome-icon icon="plus-circle" />
        Add Issue
        </button>  
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
            small
            class="back-forth-btn"
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
            v-model="C_showAllEventsToggle"
            class="mr-5 mt-6 mb-0"
            :key="componentKey"         
            @click.prevent="showAllEvents"
            :label="`Show All`"
          ></v-checkbox>
            <v-btn        
            class="mr-4 todayBtn"          
            @click="setToday"
            small
            elevation="0"
            >
          <i class="far fa-calendar-check today-icon mr-1"></i>
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
            <span v-if="item.id == 'day'"><i class="far fa-calendar-day mr-1"></i> Day</span>
            <span v-if="item.id == 'week'"><i class="far fa-calendar-week mr-1"></i> Week</span>
            <span v-if="item.id == 'month'"><i class="far fa-calendar-alt mr-1"></i> Month</span>
            <span v-if="item.id == '4day'"><i class="far fa-calendar-minus"></i> 4 Day</span>
         
            </v-btn>        
           </v-btn-toggle>  
          <button class="btn btn-sm btn-info ml-3 total-table-btns">
          Total: {{filteredCalendar.filtered.issues.length}}
         </button>      
        </v-toolbar>
      </v-sheet>    
      <v-sheet height="600" >     
         <v-calendar               
          ref="calendar"
          v-model="C_lastFocus"
          color="primary"
          :events="events"
          :event-color="getEventColor"
          :type="C_calendarView.id"        
          :key="componentKey"                    
          @click:event="editIssue"
          @click:more="viewDay"
          @click:date="viewDay"
          @change="updateRange"
          @contextmenu:event="showSummary"  
          @mouseup.right="openContextMenu"    
        >         
        </v-calendar>
         <v-menu
          v-model="selectedOpen"
          :close-on-content-click="false"
          ref="menu"             
        >
          <v-card class="p-2" min-width="265">       
           <v-list>
            <v-list-item>          
              <v-list-item-title>
                <span class="d-inline mr-1"><small><b>Issue Name:</b></small></span>
                {{ selectedEvent.name }}
              </v-list-item-title>
            </v-list-item>
            <v-list-item>
              <v-list-item-title>            
                <span class="d-inline mr-1"><small><b>Process Area:</b></small></span>
                <span v-if="selectedEvent.category">{{ selectedEvent.category }} </span>       
                <span v-else>No Process Area Assigned </span>
              </v-list-item-title>
            </v-list-item>
            <v-list-item>
              <v-list-item-title @click.prevent="scrollToStartDate" class="point">          
                <span class="d-inline mr-1"><small><b>Start Date:</b></small></span>            
                {{ moment(selectedEvent.start).format('DD MMM YYYY') }}
              </v-list-item-title>
            </v-list-item>
            <v-list-item>
              <v-list-item-title @click.prevent="scrollToEndDate" class="point"> 
              <span class="d-inline mr-1"><small><b>Due Date:</b></small></span>  
                
                 <span v-if="selectedEvent.isOnHold == true && selectedEvent.end == null">
                 <i class="fas fa-pause-circle text-primary"></i>
                </span>              
               <span v-else> 
              {{ moment(selectedEvent.end).format('DD MMM YYYY') }}
               </span>
                
                
              </v-list-item-title>
            </v-list-item>
            <v-list-item>
              <v-list-item-title>
                <span class="d-inline mr-1"><small><b>Progress:</b></small></span>  
              {{ selectedEvent.progess }}%          
              </v-list-item-title>
            </v-list-item>
            <v-list-item>
              <v-list-item-title>
              <span class="d-inline mr-1"><small><b>Flags</b></small></span>  
                  <span v-if="selectedEvent.watch == true"  v-tooltip="`On Watch`"><i class="fas fa-eye mr-1"></i></span>
                  <span v-if="selectedEvent.hasStar == true"  v-tooltip="`Important`"> <i class="fas fa-star text-warning mr-1"></i></span>
                  <span v-if="selectedEvent.pastDue == true" v-tooltip="`Overdue`"><i class="far fa-calendar text-danger"></i></span>
                  <span v-if="selectedEvent.progess == 100" v-tooltip="`Completed Task`"><i class="fas fa-clipboard-check text-success"></i></span>  
                  <span v-if="selectedEvent.isOnHold == true" v-tooltip="`On Hold`"><i class="fas fa-pause-circle text-primary"></i></span>   
                  <span v-if="selectedEvent.isDraft == true" v-tooltip="`Draft`"><i class="fas fa-pencil-alt text-warning mr-1"></i></span>      
                  <span v-if="
                      selectedEvent.watch == false && 
                      selectedEvent.pastDue == false &&     
                      selectedEvent.hasStar == false && 
                      selectedEvent.isOnHold == false && 
                      selectedEvent.isDraft == false && 
                      selectedEvent.progess < 100">
                    
                    No flags at this time
                    </span>                    
              </v-list-item-title>
            </v-list-item>        
           </v-list>
          <v-card-actions>
             <!-- <v-btn
            small
            class="mh-green text-light"
          >
             <font-awesome-icon icon="clipboard-list" class="mr-1" />
            See More
          </v-btn> -->
           <v-btn
            small
            @click.prevent="detailsBtn"
            color="primary"
          >
          <i class="far fa-edit mr-1"></i>
            Details
          </v-btn>
            
          <v-btn
            color="error"
            small
            @click.prevent="deleteIssue"           
            v-if="_isallowed('delete')"           
          >
         <i class="far fa-trash-alt mr-1"></i>
          DELETE
          </v-btn>  
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
  export default {
    name: 'IssueCalendar',
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
        type: this.C_calendarView,
        focus: this.C_lastFocus,   
        issuesQuery: '',       
        issueNames: [], 
        componentKey: 0,  
        issueIds:[],  
        issueData: [],
        issueStartDates: [],
          colors: {
          onScheduleColor: '#5cb85c',
          defaultColor: 'rgba(214, 219, 223, .15)',
          warningColor: '#f0ad4e',
          pastDueColor: '#d9534f',
        },        
        issueEndDates: [],   
        selectedEventId: {},
        calendarIssue: {},
        selectedEvent: {},
        selectedElement: null,      
        selectedOpen: false,
        showContextMenu: false,
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
        'setCalendarViewFilter',
        'setTaskIssueProgressStatusFilter',
        'setShowAllEventsToggle',
        'setIssuesPerPageFilter',
        'setTaskIssueOverdueFilter',
        'setLastFocusFilter',
        'setIssueTypeFilter',
        'setIssueSeverityFilter',
        'setTaskTypeFilter',
        'setMyActionsFilter',
        'setToggleRACI',
        'updateFacilityHash',
        'setTaskForManager',
        'setOnWatchFilter', 
        'setShowCount',
        // 7 States
        'setHideComplete',
        'setHideInprogress',
        'setHidePlanned',
        'setHideOverdue',
        'setHideOngoing',
        'setHideOnhold',
          'setHideDraft',
        // 3 Tags
        'setHideWatched',
        'setHideImportant',
        'setHideBriefed',  
      ]),
       ...mapActions([
        'issueDeleted',
        'issueUpdated',
        'updateWatchedIssues'
      ]), 
      //TODO: change the method name of isAllowed
      _isallowed(salut) {
        var programId = this.$route.params.programId;
        var projectId = this.$route.params.projectId
        let fPrivilege = this.$projectPrivileges[programId][projectId]
        let permissionHash = {"write": "W", "read": "R", "delete": "D"}
        let s = permissionHash[salut]
        return  fPrivilege.issues.includes(s); 
      },

    reRenderCalendar() {
      this.componentKey += 1;
    },
    toggleWatched(){
      this.setHideWatched(!this.getHideWatched)    
    },
    toggleImportant(){
      this.setHideImportant(!this.getHideImportant)    
    },
    toggleBriefed(){
        this.setHideBriefed(!this.getHideBriefed)    
    },
    toggleComplete(){
      this.setHideComplete(!this.getHideComplete)    
    },
    toggleDraft(){
      this.setHideDraft(!this.getHideDraft)    
    },
    togglePlanned(){
        this.setHidePlanned(!this.getHidePlanned)    
    },
    toggleInprogress(){
      this.setHideInprogress(!this.getHideInprogress)    
    },
    toggleOngoing(){
        this.setHideOngoing(!this.getHideOngoing)    
    },
    toggleOnhold(){
        this.setHideOnhold(!this.getHideOnhold)    
    },
    toggleOverdue(){
    //  this.setAdvancedFilter({id: 'overdue', name: 'Overdue', value: "overdue", filterCategoryId: 'overDueFilter', filterCategoryName: 'Action Overdue'}) 
      this.setHideOverdue(!this.getHideOverdue)    
    },
    showCounts(){
      this.setShowCount(!this.getShowCount)       
    },
      viewDay ({ date }) {
        this.focus = date
        this.setCalendarViewFilter({id: 'day', name: 'Day', value: 'day'})
      },
      getEventColor (event) {
        return event.color
      },
      setToday () {
        this.focus = '' || this.setLastFocusFilter('')  
      },
      prev () {
        this.$refs.calendar.prev()
      },
      next () {
        this.$refs.calendar.next()
      }, 
     addNewIssue() {
      this.setTaskForManager({key: 'issue', value: {}})
      // Route to new issue form page
      this.$router.push(
        `/programs/${this.$route.params.programId}/calendar/projects/${this.$route.params.projectId}/issues/new`
        );
    },
    scrollToEndDate() {
      if (this.selectedEvent.end !== '2099-01-01'){
        this.setLastFocusFilter(this.selectedEvent.end)  
       }
       },
      scrollToStartDate() {     
        this.setLastFocusFilter(this.selectedEvent.start)    
     },
     editIssue(event) {   
        let eventObj = event
        this.selectedEventId = eventObj.event.issueId;
        this.calendarIssue = eventObj.event.issue          
        this.$router.push(`/programs/${this.$route.params.programId}/calendar/projects/${this.$route.params.projectId}/issues/${this.selectedEventId}`)        
      },
     openContextMenu(e) {
      e.preventDefault();
      this.$refs.menu.open(e);
     },
    showAllEvents(){
        this.setShowAllEventsToggle(!this.getShowAllEventsToggle)
        console.log(this.getShowAllEventsToggle)
        if (this.getShowAllEventsToggle == true) {
          this.reRenderCalendar()
        } else if (this.getShowAllEventsToggle == false){
           this.events = [];
           this.reRenderCalendar()
        }
      },
      detailsBtn() {  
      //  Opens Issue edit form in context-menu
        let issueId = this.selectedEvent.issue.id  
        this.$router.push(`/programs/${this.$route.params.programId}/calendar/projects/${this.$route.params.projectId}/issues/${issueId}`)
     },
      deleteIssue() {
      let issue = this.selectedEvent.issue            
      this.$confirm(`Are you sure you want to delete ${issue.title}?`, 'Confirm Delete', {
          confirmButtonText: 'Delete',
          cancelButtonText: 'Cancel',
          type: 'warning'
        }).then(() => {
          this.issueDeleted(issue).then((value) => {
            if (value === 'Success') {
              this.$message({
                message: `${issue.title} was deleted successfully.`,
                type: "success",
                showClose: true,
              });
            }
            this.reRenderCalendar()
          })
        }).catch(() => {
          this.$message({
            type: 'info',
            message: 'Delete canceled',
            showClose: true
          });          
        });
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
       if (this.filteredCalendar.filtered.issues !== undefined && this.filteredCalendar.filtered.issues.length > 0) {
       this.issueData = this.filteredCalendar.filtered.issues.map(issue => issue)  
       this.issueNames = this.filteredCalendar.filtered.issues.map(issue=> issue.title)    
       this.issueIds = this.filteredCalendar.filtered.issues.map(issue => issue.id)      
       this.issueStartDates = this.filteredCalendar.filtered.issues.map(issue => issue.startDate)     
       this.issueEndDates = this.filteredCalendar.filtered.issues.map(issue => issue.dueDate)  
       this.categories = this.filteredCalendar.filtered.issues.map(issue => issue.taskTypeName) 
       this.onWatch = this.filteredCalendar.filtered.issues.map(issue => issue.watched)   
       this.overdue = this.filteredCalendar.filtered.issues.map(issue => issue.isOverdue) 
       this.star = this.filteredCalendar.filtered.issues.map(issue => issue.important)
       this.percentage = this.filteredCalendar.filtered.issues.map(issue => issue.progress)
       this.onhold = this.filteredCalendar.filtered.issues.map(issue => issue.onHold)
       this.draft = this.filteredCalendar.filtered.issues.map(issue => issue.draft)
                   
        const events = []
        const min = new Date(`${start.date}T00:00:00`)
        const max = new Date(`${end.date}T23:59:59`)
        const days = (max.getTime() - min.getTime()) / 86400000   
        // For loop to determine length of Tasks 
        for (let i = 0; i < this.filteredCalendar.filtered.issues.length; i++) {
            if(this.issueData[i].onHold && this.issueEndDates[i] == null ) {        
            this.issueEndDates[i] = '2099-01-01'
            }
          
           if(this.issueData[i].onHold) {
            this.issueNames[i] = this.issueNames[i] + " (On Hold)"          
            }
            events.push({            
            name: this.issueNames[i],
            start: this.issueStartDates[i],
            end: this.issueEndDates[i],         
            issueId: this.issueIds[i],
            issue: this.issueData[i],
            category: this.categories[i],  
            watch: this.onWatch[i],
            pastDue: this.overdue[i], 
            progess: this.percentage[i],
            // color: this.colors.defaultColor,  
            hasStar: this.star[i] , 
            isDraft: this.draft[i],
            isOnHold: this.onhold[i]              
            // timed: !allDay,            
          })
        }       
        // This is the main Events array pushed into Calendar
        if (this.getShowAllEventsToggle == false && !(this.issuesQuery.length > 0) ) {
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
        'getCalendarViewFilterOptions',
        'getCalendarViewFilter',
        'calendarViewFilter',
        'getShowAllEventsToggle',
        'getAdvancedFilterOptions',
        'getIssuesPerPageFilterOptions',
        'getIssuesPerPageFilter',
        'filterDataForAdvancedFilter',
        'getTaskIssueUserFilter',
        'getAdvancedFilter',
        'getLastFocusFilter',
        'getTaskIssueTabFilterOptions',
        'getTaskIssueProgressStatusOptions',
        'getTaskIssueProgressStatusFilter',
        'taskIssueProgressFilter',
        'getTaskIssueOverdueOptions',
        'taskIssueOverdueFilter',
        'noteDateFilter',
        'taskIssueDueDateFilter',
        'currentProject',
        "contentLoaded",
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
         'getShowCount',
        // 7 States
        'getHideComplete',
        'getHideInprogress',
        'getHidePlanned',
        'getHideOngoing',
        'getHideOnhold',
        'getHideDraft',
        'getHideOverdue',
        // 3 Tags
        'getHideWatched',
        'getHideImportant',
        'getHideBriefed',           
      ]),
      filteredCalendar() {
         let typeIds = _.map(this.C_issueTypeFilter, 'id')
        let taskTypeIds = _.map(this.C_taskTypeFilter, 'id')
        let severityIds = _.map(this.C_issueSeverityFilter, 'id')
        let stageIds = _.map(this.issueStageFilter, 'id')
        const search_query = this.exists(this.issuesQuery.trim()) ? new RegExp(_.escapeRegExp(this.issuesQuery.trim().toLowerCase()), 'i') : null
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

          if (search_query) valid = valid && search_query.test(resource.title) ||
            valid && search_query.test(resource.issueType) ||
            valid && search_query.test(resource.issueSeverity) ||
            valid && search_query.test(resource.taskTypeName) ||
            valid && search_query.test(resource.userNames)
          return valid;
        })), ['dueDate'])
         return {
       unfiltered: {
          issues
            },
       filtered: {
         issues:  issues.filter(t => {
        if (this.getHideOverdue == true) {          
         return t.isOverdue == false
       } else return true

      }).filter(t => {
      if (this.getHideComplete == true) { 
        return !t.completed
      } else return true

      }).filter(t => {
      if (this.getHidePlanned == true) { 
        return t.planned == false
      } else return true

      }).filter(t => {
      if (this.getHideOnhold == true) { 
        return t.onHold == false
      } else return true

      }).filter(t => {
      if (this.getHideInprogress == true) { 
        return t.inProgress == false
      } else return true
     
      }).filter(t => {
       if (this.getHideDraft == true){
         return t.draft == false
       } else return true   

        }).filter(t => {
         if (this.getHideBriefed && !this.getHideWatched && !this.getHideImportant ) {
          return t.reportable
        }
        if (this.getHideBriefed && this.getHideWatched && !this.getHideImportant) {          
           return t.reportable + t.watched

        } if (this.getHideBriefed && this.getHideWatched && this.getHideImportant) {          
           return t.reportable + t.watched + t.important
        } else return true

      }).filter(t => {
        // This and last 2 filters are for Filtered Tags
         if (this.getHideWatched && !this.getHideBriefed && !this.getHideImportant) {
           return t.watched
        } if (this.getHideWatched && !this.getHideBriefed && this.getHideImportant) {
           return t.watched + t.important
        } if (this.getHideWatched && this.getHideBriefed && !this.getHideImportant) {          
           return  t.watched + t.reportable
        } if (this.getHideWatched && this.getHideBriefed && this.getHideImportant) {          
           return  t.watched + t.reportable + t.important
        } else return true          
       
      }).filter(t => {
         if (this.getHideImportant && !this.getHideBriefed && !this.getHideWatched) {
          return t.important
        } if (this.getHideImportant && this.getHideBriefed && !this.getHideWatched) {
          return t.important + t.reportable
       } if (this.getHideImportant && this.getHideBriefed && this.getHideWatched) {
          return t.important + t.reportable + t.watched
        } else return true          
       }),
       }
       }  
   
    }, 
      variation() {
    let planned = _.filter(
      this.filteredCalendar.unfiltered.issues,
        (t) => t && t.planned 
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let drafts = _.filter(
      this.filteredCalendar.unfiltered.issues,
        (t) => t && t.draft
      );  
      let important = _.filter(
      this.filteredCalendar.unfiltered.issues,
        (t) => t && t.important 
      ); 
        let briefings = _.filter(
      this.filteredCalendar.unfiltered.issues,
        (t) => t && t.reportable 
      );
      let watched = _.filter(
      this.filteredCalendar.unfiltered.issues,
        (t) => t && t.watched 
      );
              
      let completed = _.filter(
      this.filteredCalendar.unfiltered.issues,
        (t) => t && t.completed 
      );
      let inProgress = _.filter(
      this.filteredCalendar.unfiltered.issues,
        (t) => t && t.inProgress 
      );
     let onHold = _.filter(this.filteredCalendar.unfiltered.issues, (t) => t && t.onHold == true );
     let overdue = _.filter(this.filteredCalendar.unfiltered.issues, (t) => t.isOverdue == true);

      return {
        planned: {
          count: planned.length, 
          plannedTs: planned            
        },
        important: {
          count: important.length,             
        },
        briefings: {
          count: briefings.length,          
        },
        watched: {
          count: watched.length,          
        },
        onHold: {
          count: onHold.length,          
        },
        drafts: {
          count: drafts.length,          
        },
        completed: {
          count: completed.length,
          // percentage: Math.round(completed_percent),
        },      
        inProgress: {
          count: inProgress.length,
          // percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          // percentage: Math.round(overdue_percent),
        },
     
      };
    },
    C_showCountToggle: {                  
        get() {
         return this.getShowCount                
        },
        set(value) {
          this.setShowCount(value) ||  this.setShowCount(!this.getShowCount)
        }
        
      },
      C_calendarIssueFilter: {
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
    C_taskTypeFilter: {
        get() {           
          return this.taskTypeFilter
        },
        set(value) {
          this.reRenderCalendar()     
          this.setTaskTypeFilter(value)
        }
      },
    C_showAllEventsToggle: {                  
        get() {
         return this.getShowAllEventsToggle                 
        },
        set(value) {
          this.setShowAllEventsToggle(value) ||  this.setShowAllEventsToggle(!this.getShowAllEventsToggle)
        }
        
      },
     C_lastFocus: {
      get() {         
        return this.getLastFocusFilter  || this.focus
      
      },
      set(value) {
        this.setLastFocusFilter(value) 
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
        if (this.$route.params.projectId && this.currentFacility.issues.length > 0) {
          this.reRenderCalendar()
          this.currentFacility = this.facilities.find(
            (facility) => facility.facilityId == this.$route.params.projectId
          );
        }
      },
    },
    issuesQuery: {
      handler() {
       if(this.issuesQuery.length > 0) {
          this.reRenderCalendar()
       } else if (!(this.issuesQuery.length > 0) && this.checkbox == false) {
         this.events = [];
         this.reRenderCalendar()
       }
      },
    },
    filteredCalendar: {
      handler(value) {
        if (value) {
          this.reRenderCalendar()        
        } 
        if (value && this.filteredCalendar.filtered.issues.length == 0)   {
          this.events = []
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

<style scoped lang="scss">

 /deep/.v-toolbar__content {
  padding-left: 0;
  padding-right: 0;
}
/deep/.v-event {
  color: #383838 !important;
}
/deep/.v-event:hover {
  background-color: rgba(214, 219, 223, .45) !important;
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
.addTaskBtn, .exportBtns, .showAll, .todayBtn {
   box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
 }
.filters-wrapper {
  float: right;
  margin-top: -83.5px;
}
/deep/.v-event.v-event-start, /deep/.v-event.v-event-end {
  visibility: visible !important;
  font-weight: 500 !important;

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
/deep/.v-list-item {
  min-height: 30px;
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
 .point {
   cursor: pointer;
  }
  .point:hover {
   cursor: pointer;
   background-color: rgba(214, 219, 223, .45);
 }
 .ninety {
  width: 75%;
}
.filters-wrapper {
    float: right;
    margin-top: -95px;
    width: 85%;
  }
.tagsCol, .statesCol {
  border-radius: 4px;
  border: .5px solid lightgray;
}

.tagsCol {
  background-color: #f8f9fa;
}

.toggleHeight {
  height: 32px;
}
</style>
