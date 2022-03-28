<template>
  <div v-if="!loading" class="mt-3 risks-index px-0" data-cy="risk_list">
    <div v-if="newRisk && from != 'manager_view'">
      <risk-form
        :facility="facility"
        :risk="currentRisk"
        @on-close-form="newRisk=false"
        @risk-created="riskCreated"
        @risk-updated="riskUpdated"
        class="risk-form-modal"
      ></risk-form>
    </div>
    <div v-else>
          <div class="d-flex align-item-center justify-content-between w-100 mb-3">
        <div class="input-group w-100 mr-1">
          <el-input type="search" style="height:30px" placeholder="Enter Search Criteria" aria-label="Search" aria-describedby="search-addon" v-model="risksQuery"  data-cy="search_risks">
            <el-button slot="prepend" icon="el-icon-search"></el-button>
          </el-input>
        </div>        
     
 <div class="w-100" style="position:relative">  
 
  <el-collapse class="issuesFilter w-100"  style="position:absolute">
  <el-collapse-item name="1">
    <template slot="title" class="text-right">     
    <i class="fas fa-sliders-h d-inline mr-2"></i>
    MORE RISK FILTERS
    </template>
    <div class="mr-1 w-100 d-unset p-2">
    <label class="mb-0">Process Area</label>
    <el-select 
      v-model="C_taskTypeFilter"                    
      class="w-100" 
      track-by="name" 
      value-key="id"
      multiple                                                                                                                                               
      clearable
      placeholder="Select Process Area"
      >
    <el-option 
      v-for="item in taskTypes"                                                     
      :value="item"   
      :key="item.id"
      :label="item.name"                                                  
      >
    </el-option>
    </el-select>

      <label class="mb-0">Risk Approach</label>


       <el-select 
           v-model="C_riskApproachFilter"                    
          class="w-100 mr-1 mb-1"
           track-by="name" 
           value-key="id"
           multiple                                                                                                                                               
          clearable
           placeholder="Filter by Risk Approach"
           >
          <el-option 
            v-for="item in getRiskApproachFilterOptions"                                                     
            :value="item"   
            :key="item.id"
            :label="item.name"
            >
          </el-option>
          </el-select>          
     
       <label class="mb-0">Risk Priority Level</label>
        <el-select
        v-model="C_riskPriorityLevelFilter"
        class="w-100"
        track-by="name"
        value-key="id"
        multiple
        clearable
        placeholder="Filter by Risk Priority Level"
        >
        <el-option
          v-for="item in getRiskPriorityLevelFilterOptions"
          :value="item"
          :key="item.id"
          :label="item.name"
          >
        </el-option>
        </el-select>
      </div>
        </el-collapse-item>
      </el-collapse>  
            
    </div>
 </div>
      </div>
      <div class="mb-3">
        <span class="d-inline">
        <button v-if="_isallowed('write')"
          class="btn btn-md btn-primary addRiskBtn mr-2 float-left"
          @click.prevent="addNewRisk">
         <font-awesome-icon icon="plus-circle" data-cy="new_risk" />
          Add Risk
        </button>
         <span class="d-inline-block tagCol pl-1">
             <div class="pr-3 text-center d-inline-block icons" :class="[getHideComplete == true ? 'light':'']" @click.prevent="toggleComplete" >                              
                   <span v-tooltip="`COMPLETE`" class="d-block">
                    <i class="fas fa-clipboard-check" :class="[getHideComplete == true ? 'light':'text-success']"></i>
                    </span>      
               
                   <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{variation.completed.count}}</h6>  
                  </div>
                 <div class="pr-3 text-center d-inline-block icons" :class="[getHideInprogress == true ? 'light':'']" @click.prevent="toggleInprogress">                              
                   <span v-tooltip="`IN PROGRESS`" class="d-block">
                    <i class="far fa-tasks" :class="[getHideInprogress == true ? 'light':'text-primary']"></i>
                    </span>      
                
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.inProgress.count }}</h6>
                  </div>
                   <div class="pr-3 text-center d-inline-block icons" :class="[getHidePlanned == true ? 'light':'']" @click.prevent="togglePlanned">                              
                   <span v-tooltip="`PLANNED`" class="d-block">
                    <i class="fas fa-calendar-check"  :class="[getHidePlanned == true ? 'light':'text-info']"></i>
                    </span>      
                
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.planned.count }}</h6>
                  </div>
                  <div class="pr-3 text-center d-inline-block icons" :class="[getHideOverdue == true ? 'light':'']" @click.prevent="toggleOverdue" >                              
                   <span v-tooltip="`OVERDUE`" class="d-block">
                    <i class="fas fa-calendar" :class="[getHideOverdue == true ? 'light':'text-danger']"></i>
                    </span>      
                
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.overdue.count }}</h6>
                  </div>
                    <div class="pr-3 text-center d-inline-block icons" :class="[getHideOngoing == true ? 'light':'']" @click.prevent="toggleOngoing" >                              
                   <span v-tooltip="`ONGOING`" class="d-block">
                    <i class="fas fa-retweet" :class="[getHideOngoing == true ? 'light':'text-success']"></i>
                    </span>      
              
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.ongoing.count }}
                    <span
                       v-tooltip="`Ongoing: Closed`"
                       v-if="variation.ongoingClosed.count > 0"
                       style="color:lightgray"
                       >({{variation.ongoingClosed.count}})
                    </span>
                    </h6>
                  </div>
  
                  <div class="pr-3 text-center d-inline-block icons" :class="[getHideOnhold == true ? 'light':'']"  @click.prevent="toggleOnhold"  >                              
                   <span v-tooltip="`ON HOLD`"  class="d-block">
                    <i class="fas fa-pause-circle" :class="[getHideOnhold == true ? 'light':'text-primary']"></i>
                    </span>      
        
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.onHold.count }}</h6>
                  </div>
                  <div class="pr-3 text-center d-inline-block icons"  :class="[getHideDraft == true ? 'light':'']"  @click.prevent="toggleDraft" >                              
                   <span v-tooltip="`DRAFT`"  class="d-block">
                    <i class="fas fa-pencil-alt"  :class="[getHideDraft == true ? 'light':'text-warning']"></i>
                    </span>      
         
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.drafts.count }}</h6>
                  </div>
                        
      
                  <div class="pr-3 text-center d-inline-block icons" :class="[getHideWatched == true ? '':'light']" @click.prevent="toggleWatched"  >                              
                   <span v-tooltip="`ON WATCH`"  class="d-block">
                    <i class="fas fa-eye"></i>
                    </span>      
          
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.watched.count }}</h6>
                  </div>
  
                  <div class="pr-3 text-center d-inline-block icons" :class="[getHideImportant == true ? '':'light']" @click.prevent="toggleImportant">                              
                   <span v-tooltip="`IMPORTANT`" class="d-block">
                    <i class="fas fa-star" :class="[getHideImportant == true ? 'text-warning':'light']"></i>
                    </span>      
          
                    <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.important.count }}</h6>
                  </div>
                  <div class="pr-2 text-center d-inline-block icons" :class="[getHideBriefed == true ? '':'light']" @click.prevent="toggleBriefed">                              
                   <span v-tooltip="`BRIEFINGS`"  class="d-block">
                    <i class="fas fa-presentation" :class="[getHideBriefed == true ? 'text-primary':'']"></i>
                    </span>      
                   <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.briefings.count }}</h6>
                  </div>  

          <div class="d-inline-block mx-0">
             <!-- <v-app id="app"> -->
             <v-checkbox     
           v-model="C_showCountToggle"     
            class="d-inline-block"  
            @click.prevent="showCounts"   
           v-tooltip="`Show Counts`"
          ></v-checkbox>
             <!-- </v-app> -->

          </div>
            </span>
            
            
     </span>
     <div class="float-right">
         <button v-tooltip="`Export to PDF`" @click.prevent="exportToPdf" class="btn btn-md mr-1 exportBtns text-light">
          <font-awesome-icon icon="file-pdf" />
        </button>
        <button v-tooltip="`Export to Excel`" @click.prevent="exportToExcel('table', 'Risk Register')" class="btn btn-md exportBtns text-light">
          <font-awesome-icon icon="file-excel" />
        </button>
     </div>
        <div v-if="_isallowed('read')">
          <div v-if="filteredRisks.filtered.risks.length  > 0">
            <hr/>
            <risk-show
              v-for="(risk, i) in filteredRisks.filtered.risks"         
              class="riskHover"        
              :class="{'b_border': !!filteredRisks.filtered.risks[i+1]}"
              :key="risk.id"
              :risk="risk"
              :from-view="from"
              @risk-edited="riskEdited"
            ></risk-show>
          </div>
          <div v-else>
            <br/>
            <h6 class="text-danger ml-1 mt-4">No risks found..</h6>
          </div>
        </div>
      <div v-else class="text-danger mx-2 mt-2">
        <h5> <i>Sorry, you don't have read-permissions for this tab! Please click on any available tab.</i></h5>
      </div>
         <table style="display:none" class="table table-sm table-bordered" ref="table" id="riskList1">
      <thead>
        <tr>          
          <th>Risk</th>
          <th>Project</th>
          <th>Risk Approach</th>
          <th>Priority Level</th>         
          <th>Start Date</th>
          <th>Due Date</th>
          <th>Assigned Users</th>
          <th>Progress</th>
          <th>Overdue</th>
          <th>On Watch</th>
          <th>Last Update</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(risk, i) in filteredRisks.filtered.risks" :key="i">
          <td>{{risk.text}}</td>
          <td>{{risk.facilityName}}</td>
          <td>{{risk.riskApproach.charAt(0).toUpperCase() + risk.riskApproach.slice(1)}}</td>
          <td>{{risk.priorityLevel}}</td>         
          <td>{{formatDate(risk.startDate)}}</td>
          <td>{{formatDate(risk.dueDate)}}</td>
          <td v-if="(risk.userNames.length) > 0">{{ risk.userNames }}</td>
          <td v-else></td>
          <td>{{risk.progress + "%"}}</td>
          <td v-if="(risk.dueDate) <= now"><h5>X</h5></td>
          <td v-else></td>
          <td v-if="(risk.watched) == true"><h5>X</h5></td>
          <td v-else></td>
           <td v-if="risk.notes.length > 0">       
          <span  class="toolTip" v-tooltip="('By: ' + risk.lastUpdate.user.fullName)" > 
          {{ moment(risk.lastUpdate.createdAt).format('DD MMM YYYY, h:mm a')}} <br>         
          </span> 
          <span>
            {{risk.lastUpdate.body}}
          </span>         
        </td>  
         <td v-else >No Updates</td> 
        </tr>
      </tbody>
    </table>
      </div>
    </div>
  </div>
</template>

<script>
  import {jsPDF} from "jspdf"
  import 'jspdf-autotable'
  import {mapGetters, mapMutations} from 'vuex'
  import RiskForm from './risk_form'
  import RiskShow from './risk_show'
  import {library} from '@fortawesome/fontawesome-svg-core'
  import {faFilePdf} from '@fortawesome/free-solid-svg-icons'
  import * as Moment from 'moment'
  import {extendMoment} from 'moment-range'

  const moment = extendMoment(Moment)
  library.add(faFilePdf)

  export default {
    name: 'RiskIndex',
    props: ['facility', 'from'],
    components: {
      RiskForm,
      RiskShow
    },
    data() {
      return {
        loading: true,
        newRisk: false,
        currentRisk: null,
        now: new Date().toISOString(),
        risksQuery: '',
        uri: 'data:application/vnd.ms-excel;base64,',
        template: '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="https://www.w3.org/TR/2018/SPSD-html401-20180327/"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
        base64: function(s) { return window.btoa(unescape(encodeURIComponent(s))) },
        format: function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) }
      }
    },
    mounted() {
      this.loading = false
    },
    methods: {
      ...mapMutations([
        'setAdvancedFilter', 
        'setRiskPriorityLevelFilter', 
        'setTaskIssueProgressStatusFilter',
        'setTaskIssueOverdueFilter',
        'setTaskTypeFilter',
        'setRiskApproachFilter',
        'setIssueSeverityFilter',
        'setMyActionsFilter',
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
       _isallowed(salut) {
          return this.checkPrivileges("risk_index", salut, this.$route)

      //  if (this.$route.params.contractId) {
      //     // return this.defaultPrivileges
      //     let fPrivilege = this.$contractPrivileges[this.$route.params.programId][this.$route.params.contractId]    
      //     let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      //     let s = permissionHash[salut]
      //     return fPrivilege.risks.includes(s);
      //   } else {
      //     let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      //     let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      //     let s = permissionHash[salut]
      //     return fPrivilege.risks.includes(s); 
      //   }
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
      riskCreated(risk) {
        this.facility.risks.unshift(risk)
        this.newRisk = false
        this.$emit('refresh-facility')
      },
      riskUpdated(risk, refresh=true) {
        let index = this.facility.risks.findIndex((t) => t.id == risk.id)
        if (index > -1) Vue.set(this.facility.risks, index, risk)
        if (refresh) {
          this.newRisk = false
          this.$emit('refresh-facility')
        } else {
          this.updateFacilityHash(this.facility)
        }
      },
      exportToPdf() {
        const doc = new jsPDF("l")
        const html = this.$refs.table.innerHTML
        doc.autoTable({ html: "#riskList1" })
        doc.text(150, 285, "Risk Register")
        doc.save("Risk Register.pdf")
      },
     exportToExcel(table, name) {
        if (!table.nodeType) table = this.$refs.table
        var ctx = { worksheet: name || 'Worksheet', table: table.innerHTML }
        var link = document.createElement('a');
        link.setAttribute('href', this.uri + this.base64(this.format(this.template, ctx)));
        link.setAttribute('download', 'Risk Register.xls');
        link.click();
      },
      riskEdited(risk) {
        this.currentRisk = risk
        this.newRisk = true
      },
      addNewRisk() {
        this.setTaskForManager({key: 'risk', value: {}})
        // Route to new risk form page
        this.$router.push(
          `/programs/${this.$route.params.programId}/map/projects/${this.$route.params.projectId}/risks/new`
        );
      }
    },
    computed: {
      ...mapGetters([
        // 'getAdvancedFilterOptions',
        'getRiskApproachFilterOptions',
        'getRiskApproachFilter',
        'getRiskPriorityLevelFilter',
        'getRiskPriorityLevelFilterOptions',
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
        'taskTypes',
        'riskStageFilter',
        'riskUserFilter',
        'currentProject',
        'taskTypeFilter',
        'riskApproach',
        'riskApproaches',
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
      filteredRisks() {

        let milestoneIds = _.map(this.C_taskTypeFilter, 'id')
        let stageIds = _.map(this.riskStageFilter, 'id')
        let riskApproachIds = _.map(this.C_riskApproachFilter, 'id')
        let riskPriorityLevelFilterIds = _.map(this.C_riskPriorityLevelFilter, 'id')
        let riskPriorityLevelFilter = this.getRiskPriorityLevelFilter
        const search_query = this.exists(this.risksQuery.trim()) ? new RegExp(_.escapeRegExp(this.risksQuery.trim().toLowerCase()), 'i') : null
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

          if (milestoneIds.length > 0) valid = valid && milestoneIds.includes(resource.taskTypeId)

          if (riskApproachIds.length > 0) valid = valid && riskApproachIds.includes(resource.riskApproach)

        
          if (riskPriorityLevelFilterIds.length > 0) valid = valid && riskPriorityLevelFilterIds.includes(resource.priorityLevelName.toLowerCase())
          if (search_query) valid = valid && search_query.test(resource.text) ||
          valid && search_query.test(resource.text) ||
          valid && search_query.test(resource.riskApproach) ||
          valid && search_query.test(resource.priorityLevelName) ||  
          valid && search_query.test(resource.taskType.name) || 
          valid && search_query.test(resource.userNames)


          return valid;
        })), ['dueDate'])

     return {
       unfiltered: {
            risks
            },
       filtered: {
           risks: risks.filter(t => {
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
       if (this.getHideOngoing == true) {
          return t.ongoing == false
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
      this.filteredRisks.unfiltered.risks,
        (t) => t && t.planned == true
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let drafts = _.filter(
      this.filteredRisks.unfiltered.risks,
        (t) => t && t.draft == true
      );  
      
       let important = _.filter(
       this.filteredRisks.unfiltered.risks,
        (t) => t && t.important == true
      ); 
      let briefings = _.filter(
        this.filteredRisks.unfiltered.risks,
        (t) => t && t.reportable == true
      );
      let watched = _.filter(
        this.filteredRisks.unfiltered.risks,
        (t) => t && t.watched == true
      );
              
    let completed = _.filter(
      this.filteredRisks.unfiltered.risks,
        (t) => t && t.completed == true
      );
    let inProgress = _.filter(
     this.filteredRisks.unfiltered.risks,
        (t) => t && t.inProgress == true
      );
     let onHold = _.filter(this.filteredRisks.unfiltered.risks, (t) => t && t.onHold == true );
     let ongoing = _.filter(this.filteredRisks.unfiltered.risks, (t) => t && t.ongoing == true );
     let ongoingClosed = _.filter(this.filteredRisks.unfiltered.risks, (t) => t && t.closed == true );
     let overdue = _.filter(this.filteredRisks.unfiltered.risks, (t) => t.isOverdue == true);

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
          count: inProgress.length - planned.length,
          // percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          // percentage: Math.round(overdue_percent),
        },
        ongoing: {
          count: ongoing.length
        }, 
        ongoingClosed: {
          count: ongoingClosed.length
        },     
      };
    },
      C_facilityManagerRiskFilter: {
        get() {
          return this.getAdvancedFilter
        },
        set(value) {
          this.setAdvancedFilter(value)
        }
      },
      C_showCountToggle: {                  
        get() {
          return this.getShowCount                
        },
        set(value) {
          this.setShowCount(value) ||  this.setShowCount(!this.getShowCount)
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
          this.setTaskTypeFilter(value)
        }
      },
      C_riskApproachFilter: {
        get() {      
          return this.getRiskApproachFilter
        },
        set(value) {     
            this.setRiskApproachFilter(value)
        }
      },
      C_myRisks: {
        get() {
          return _.map(this.myActionsFilter, 'value').includes('risks')
        },
        set(value) {
          if (value) this.setMyActionsFilter([...this.myActionsFilter, {name: "My Risks", value: "risks"}])
          else this.setMyActionsFilter(this.myActionsFilter.filter(f => f.value !== "risks"))
        }
      },
      C_riskPriorityLevelFilter: {
        get() {
          return this.getRiskPriorityLevelFilter
        },
        set(value) {
          this.setRiskPriorityLevelFilter(value)
        }
      },
      C_onWatchRisks: {
        get() {
          return _.map(this.onWatchFilter, 'value').includes('risks')
        },
        set(value) {
          if (value) this.setOnWatchFilter([...this.onWatchFilter, {name: "On Watch Risks", value: "risks"}])
          else this.setOnWatchFilter(this.onWatchFilter.filter(f => f.value !== "risks"))
        }
      }
    }
  }
</script>

<style lang="scss" scoped>
  .risks-index {
    height: 465px;
  }
  .riskHover:hover {
    cursor: pointer;
    box-shadow: 0.5px 0.5px 1px 1px rgba(56,56, 56,0.29), 0 2px 2px rgba(56,56,56,0.23);
    background-color: rgba(91, 192, 222, 0.3);
    border-left: solid rgb(91, 192, 222);
  }
 .alt-text {
    position: relative;
    padding-top: 80px !important;
  }
  .exportBtns {
    transition: all .2s ease-in-out;
    background-color: #41b883;
  }

  .exportBtns:hover {
    transform: scale(1.06);
  }
  input[type=search] {
    color: #383838;
    text-align: left;
    cursor: pointer;
    display: block;
  }
  .addRiskBtn,
  .export2pdf,
  .exportBtns,
  .riskHover {
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
  }

  .displayNone {
  display: none;
}
.filters-wrapper {
  float: right;
  margin-top: -85px;  
}
.tagCol {
  border-radius: 4px;
  border: .5px solid lightgray;
}

i, .icons {
  cursor: pointer;
  -webkit-touch-callout: none;
  -webkit-user-select: none;
  -khtml-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}
.statesCol {
  border-radius: 4px; 
  border: .5px solid lightgray;

}

/deep/.v-input__slot {
  display: inline;
  .v-label {
   font-family: 'FuturaPTBook';
  //  font-weight: 600;
   color: #007bff !important;
  }
}

.hideLabels {
  font-weight: 600;
}
/deep/.v-input__control {
  display: block !important;
}

/deep/.v-input--checkbox{
  margin-top: 0;
}

@media screen and (max-width: 1500px) {
  .filters-wrapper {
    width: 65% !important;
  } 
}

@media screen and (max-width: 1550px) {
  .hideLabels {
    display: none !important;
  }
}
</style>
