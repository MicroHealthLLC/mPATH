
<template>
  <div id="risk-sheets">    
    <table class="table table-sm table-bordered">    
      <tr v-if="!loading" class="mx-3 mb-3 mt-2 py-4 edit-action" @click.prevent="editRisk" data-cy="risk_row" @mouseup.right="openContextMenu" @contextmenu.prevent="">
       <td class="oneFive">{{risk.text}}</td>
       <td class="eight">{{risk.riskApproach.charAt(0).toUpperCase() + risk.riskApproach.slice(1) }}</td>
       <td class="eight pt-2 font-sm">
            <span v-if="(risk.priorityLevelName) == 'Very Low'" class="gray2">{{risk.priorityLevelName}}</span> 
            <span v-if="(risk.priorityLevelName) == 'Low'" class="green1">{{risk.priorityLevelName}}</span> 
            <span v-if="(risk.priorityLevelName) == 'Moderate'" class="yellow1"> {{risk.priorityLevelName}} </span> 
            <span v-if="(risk.priorityLevelName) == 'High'" class="orange1"> {{risk.priorityLevelName}} </span> 
            <span v-if="(risk.priorityLevelName) == 'Extreme'" class="red1"> {{risk.priorityLevelName}}</span> 
       </td>
       <td class="eight text-center">         
          <span v-if="risk.ongoing && !risk.closed && risk.startDate == null || undefined">
            <i class="fas fa-retweet text-success"></i>
          </span>
          <span v-else-if="risk.ongoing && risk.closed && risk.startDate == null || undefined">
            <i class="fas fa-retweet text-secondary"></i>
              </span>
          <span v-else>{{
            moment(risk.startDate).format("DD MMM YYYY") 
          }}</span>
         </td>
       <td class="eight text-center">
         <span v-if="risk.ongoing && !risk.closed" v-tooltip="`Ongoing`"><i class="far fa-retweet text-success"></i></span>
         <span v-else-if="risk.onHold && risk.dueDate == null" v-tooltip="`On Hold (w/no Due Date)`"><i class="fas fa-pause-circle text-primary"></i></span>
         <span v-else>
         {{formatDate(risk.dueDate)}}
        </span>
       </td>
       <td class="twelve" >
          <span v-if="(risk.responsibleUsers.length > 0) && (risk.responsibleUsers[0] !== null)"> <span class="badge mr-1 font-sm badge-secondary badge-pill">R</span>{{risk.responsibleUsers[0].name}} <br></span> 
          <span v-if="(risk.accountableUsers.length > 0) && (risk.accountableUsers[0] !== null)"> <span class="badge mr-1 font-sm badge-secondary badge-pill">A</span>{{risk.accountableUsers[0].name}}<br></span>   
           <!-- Consulted Users and Informed Users are toggle values         -->
          <span :class="{'show-all': getToggleRACI }" >             
             <span v-if="(risk.consultedUsers.length > 0) && (risk.consultedUsers[0] !== null)"> <span class="badge mr-1 font-sm badge-secondary badge-pill">C</span>{{JSON.stringify(risk.consultedUsers.map(consultedUsers => (consultedUsers.name))).replace(/]|[['"]/g, ' ')}}<br></span> 
             <span v-if="(risk.informedUsers.length > 0) && (risk.informedUsers[0] !== null)"> <span class="badge font-sm badge-secondary mr-1 badge-pill">I</span>{{JSON.stringify(risk.informedUsers.map(informedUsers => (informedUsers.name))).replace(/]|[['"]/g, ' ')}}</span>      
         </span>        
        </td>
        <td class="eight text-center" >
        <span v-if="risk.ongoing && !risk.closed" v-tooltip="`Ongoing`"><i class="far fa-retweet text-success"></i></span>
        <span v-else-if="risk.ongoing == true && risk.closed" v-tooltip="`Ongoing:Closed`"><i class="far fa-retweet text-secondary"></i></span>  
        <span v-else>{{risk.progress + "%"}}</span>
        </td>
        <td class="ten text-center">
                <span v-if="risk.watched == true"  v-tooltip="`On Watch`"><i class="fas fa-eye mr-1"></i></span>
                <span v-if="risk.important == true"  v-tooltip="`Important`"> <i class="fas fa-star text-warning mr-1"></i></span>
                <span v-if="risk.reportable" v-tooltip="`Briefings`"><i class="fas fa-presentation mr-1 text-primary"></i></span>
                <span v-if="risk.isOverdue" v-tooltip="`Overdue`"> <i class="fas fa-calendar text-danger mr-1"></i></span>
                <span v-if="risk.completed" v-tooltip="`Completed`"><i class="fas fa-clipboard-check text-success mr-1"></i></span>   
                <span v-if="risk.ongoing == true && !risk.closed" v-tooltip="`Ongoing`"><i class="far fa-retweet text-success mr-1"></i></span>   
                <span v-if="risk.closed" v-tooltip="`Ongoing:Closed`"><i class="far fa-retweet text-secondary mr-1"></i></span>   
                <span v-if="risk.onHold == true" v-tooltip="`On Hold`">   <i class="fas fa-pause-circle mr-1 text-primary"></i></span>   
                <span v-if="risk.draft == true" v-tooltip="`Draft`"> <i class="fas fa-pencil-alt text-warning"></i></span>   
                <span v-if="risk.planned" v-tooltip="`Planned`"> <i class="fas fa-calendar-check text-info mr-1"></i></span>
                <span v-if="risk.inProgress" v-tooltip="`In Progress`"> <i class="far fa-tasks text-primary mr-1"></i></span>
               
         </td>  
         <td class="twentyFour" v-if="risk.notes.length > 0">       
          <span  class="toolTip" v-tooltip="('By: ' + risk.lastUpdate.user.fullName)" > 
          {{ moment(risk.lastUpdate.createdAt).format('DD MMM YYYY, h:mm a')}} <br>         
          </span> 
          <span class="truncate-line-five">
            {{risk.lastUpdate.body}}
          </span>         
        </td>  
         <td  class="twentyFour" v-else >No Updates</td> 
      </tr>
      <!-- The context-menu appears only if table row is right-clicked -->
      <RiskContextMenu
        :facilities="facilities"
        :facilityGroups="facilityGroups"
        :risk="risk"
        :display="showContextMenu"
        ref="menu"
        @open-risk="editRisk">  
      </RiskContextMenu>
    </table>
  </div>
</template>

<script>
  import {mapGetters, mapMutations, mapActions} from "vuex"
  // import IssueForm from "./../issues/issue_form"
  import RiskContextMenu from "../../../shared/RiskContextMenu"
  import moment from 'moment'
  Vue.prototype.moment = moment

  import MessageDialogService from "../../../../services/message_dialog_service";

export default {
    name: 'RiskSheets',
    components: {
      RiskContextMenu 
    },
    props: {
      fromView: {
        type: String,
        default: 'map_view'
      },
      risk: Object
    },
    data() {
      return {
        loading: true,
        now: new Date().toISOString(),
        DV_risk: {},
        DV_edit_risk: {},
        has_risk: false,
        showContextMenu: false
      }
    },
    mounted() {
      if (this.risk) {
        this.loading = false
        this.DV_risk = this.risk
      }
    },
    methods: {
      ...mapMutations([
        'updateRisksHash',
        'setRiskForManager',
        'setToggleRACI',
        'SET_RISK_FORM_OPEN',
        'SET_SELECTED_RISK'
      ]),
      ...mapActions([
        'riskDeleted',
        'taskUpdated',
        'updateWatchedRisks'
      ]),
      deleteRisk() {
        this.$confirm(`Are you sure you want to delete "${this.DV_risk.text}"?`, 'Confirm Delete', {
          confirmButtonText: 'Delete',
          cancelButtonText: 'Cancel',
          type: MessageDialogService.msgTypes.WARNING
        }).then(() => {
          this.riskDeleted(this.DV_risk)
        });
      },  
      openSubRisk(subRisk) {
        let risk = this.currentRisks.find(t => t.id == subRisk.id)
        if (!risk) return
        this.has_risk = Object.entries(risk).length > 0
        this.DV_edit_risk = risk
        this.$refs.riskFormModal && this.$refs.riskFormModal.open()
      },
      openSubIssue(subIssue) {
        let issue = this.currentIssues.find(t => t.id == subIssue.id)
        if (!issue) return
        this.has_risk = Object.entries(issue).length > 0
        this.DV_edit_issue = issue
        this.$refs.riskFormModal && this.$refs.riskFormModal.open()
      },
      editRisk() {
        console.log(this.DV_risk)
        this.DV_edit_risk = this.DV_risk;
        if (this.$route.params.contractId){
          this.$router.push(`/programs/${this.$route.params.programId}/sheet/contracts/${this.$route.params.contractId}/risks/${this.DV_edit_risk.id}`);
        } else if (this.$route.params.vehicleId){
          this.$router.push(`/programs/${this.$route.params.programId}/sheet/vehicles/${this.$route.params.vehicleId}/risks/${this.DV_edit_risk.id}`);
        } else this.$router.push(`/programs/${this.$route.params.programId}/sheet/projects/${this.$route.params.projectId}/risks/${this.DV_edit_risk.id}`);        
      },
      onCloseForm() {
        this.$refs.riskFormModal && this.$refs.riskFormModal.close()
        this.has_risk = false
        this.DV_edit_risk = {}
        this.DV_edit_issue = {}
      },
      toggleWatched() {
        if (this.DV_risk.watched) {
          this.$confirm(`Are you sure you want to remove this risk from on-watch?`, 'Confirm Remove', {
            confirmButtonText: 'Remove',
            cancelButtonText: 'Cancel',
            type: MessageDialogService.msgTypes.WARNING
          }).then(() => {
            this.DV_risk = {...this.DV_risk, watched: !this.DV_risk.watched}
            this.updateWatchedRisks(this.DV_risk)
          });
        }
      },    
      getRisk(risk) {
        return this.currentRisks.find(t => t.id == risk.id) || {}
      },
      getIssue(issue) {
        return this.currentIssues.find(t => t.id == issue.id) || {}
      },
      openContextMenu(e) {
        e.preventDefault();
        this.$refs.menu.open(e);
      },
    },
    computed: {
      ...mapGetters([
        'facilities',
        'facilityGroups',
        'managerView',
        'currentRisks',
        'currentIssues',
        'viewPermit',
        'getToggleRACI',
      ]),
      is_overdue() {
        return this.DV_risk.progress !== 100 && new Date(this.DV_risk.dueDate).getTime() < new Date().getTime()
      },
      facility() {
        return this.facilities.find(f => f.id == this.DV_risk.facilityId)
      },
      facilityGroup() {
        return this.facilityGroups.find(f => f.id == this.facility.facilityGroupId)
      },
      C_editForManager() {
        return this.managerView.risk && this.managerView.risk.id == this.DV_risk.id
      }
    },
    watch: {
      risk: {
        handler(value) {
          this.DV_risk = Object.assign({}, value)
        },
        deep: true
      }
    }
  };
</script>

<style lang="scss" scoped>
  .t_actions {
    display: flex;
    align-items: center;
    justify-content: space-between;
    span {
      font-size: 13px;
    }
    .empty_box,
    .check_box {
      font-size: 16px;
    }
  }
  table {
    table-layout: fixed ;
    width: 100% ;
    margin-bottom: 0 !important;
    overflow: auto;
  }
  .toolTip {
    background-color: #6c757d;
    font-size: .75rem;
    padding:1px;
    color: #fff;
    border-radius: 3px;
  }
  .seven {
    width: 7%;
  }
  .eight {
    width: 8%;
  }
  .nine {
    width: 9%;
  }
  .ten {
    width: 10%;
  }
  .twelve {
    width: 12%;
  }
  .fort {
    width: 14%;
  }
  .oneFive {
    width: 15%;
  }
  .sixteen {
    width: 16%;
  }
  .oneEight{
    width: 18%;
  }
  .twenty{
    width: 20%;
  }
  .twentyFour{
    width: 24%;
  }
  .pg-content {
    width: 100%;
    height: 20px;
    font-weight: bold;
  }
  td {
    overflow-wrap: break-word;
  }
  .risk_form_modal.sweet-modal-overlay {
    z-index: 10000001;
  }
  .risk_form_modal.sweet-modal-overlay ::v-deep .sweet-modal {
    min-width: 30vw;
    max-height: 80vh;
    .sweet-content {
      padding-top: 30px;
      text-align: unset;
    }
    .modal_close_btn {
      display: flex;
      position: absolute;
      top: 20px;
      right: 30px;
      font-size: 20px;
      cursor: pointer;
    }
    .fa-long-arrow-alt-right {
      margin-bottom: 1rem !important;
      margin-left: 1rem !important;
      height: .8em !important;
    }
    .onHover:hover {
      cursor: pointer !important;
      background-color: rgba(91, 192, 222, 0.3) !important;
      border-left: solid rgb(91, 192, 222) !important;
    }
    .form-inside-modal {
      form {
        position: inherit !important;
      }
    }
  }
    .red1 {
    background-color: #d9534f;
  }
  .yellow1 {
    background-color: yellow;  
    color:#383838;  
    display: block;
  }
  .orange1 {
    background-color: #f0ad4e;
  }
  .green1 {
    background-color: rgb(92,184,92);
  }  
  .gray2 {
    background-color: #ededed;
  }
  .green1, .orange1, .red1, .yellow1, .gray2 {
    display: inline;   
    border-radius: 2px; 
    padding: 1px 1px;
    box-shadow: 0 1px 2.5px rgba(56,56, 56,0.19), 0 1.5px 1.5px rgba(56,56,56,0.23);
  }
   .green1, .orange1, .red1 {   
    color:#fff;   
  }
  .truncate-line-five
  {
    display: -webkit-box;
    -webkit-line-clamp: 4;
    -webkit-box-orient: vertical;  
    overflow: hidden;
    &:hover
    {
      display: -webkit-box;
      -webkit-line-clamp: unset;
    }
  }
</style>
