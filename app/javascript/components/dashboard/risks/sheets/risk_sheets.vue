
<template>
  <div id="risk-sheets">
    <table class="table table-sm table-bordered table-striped">
      <tr v-if="!loading" class="mx-3 mb-3 mt-2 py-4 edit-action" @click.prevent="editRisk" data-cy="risk_row">
        <td class="oneFive">{{risk.text}}</td>
        <td class="eight">{{risk.riskApproach}}</td>
        <td class="eight">{{risk.priorityLevel}}</td>
        <td class="seven">{{formatDate(risk.startDate)}}</td>
        <td class="seven">{{formatDate(risk.dueDate)}}</td>
        <td class="nine" v-if="(risk.userNames.length) >= 0">{{ risk.userNames }}</td>
        <td class="nine" v-else></td>
        <td class="nine">{{risk.progress + "%"}}</td>
        <td class="nine" v-if="(risk.dueDate) <= now"><h5>x</h5></td>
        <td class="nine" v-else></td>
        <td class="eight" v-if="(risk.watched) == true"><h5>x</h5></td>
        <td class="eight" v-else></td>
         <td class="twenty" v-if="(risk.notes.length) > 0">
         By:  {{risk.notes[0].user.fullName}} on 
         {{ moment(risk.notes[0].createdAt).format('DD MMM YYYY, h:mm a') }}: 
        {{risk.notes[0].body}}
        </td>
        <td v-else class="twenty">No Updates</td>
      </tr>
    </table>



    <sweet-modal
      class="risk_form_modal"
      ref="riskFormModal"
      :hide-close-button="true"
      :blocking="true"
      >
      <div v-if="has_risk" class="w-100">
        <risk-form
          v-if="Object.entries(DV_edit_risk).length"
          :facility="facility"
          :risk="DV_edit_risk"
          title="Edit Risk"
          @risk-updated="updateRelatedRiskIssue"
          @on-close-form="onCloseForm"
          class="form-inside-modal"
        ></risk-form>

        <issue-form
          v-if="Object.entries(DV_edit_issue).length"
          :facility="facility"
          :issue="DV_edit_issue"
          @issue-updated="updateRelatedRiskIssue"
          @on-close-form="onCloseForm"
          class="form-inside-modal"
        ></issue-form>
      </div>
    </sweet-modal>
  </div>
</template>

<script>
  import {mapGetters, mapMutations, mapActions} from "vuex"
  import {SweetModal} from 'sweet-modal-vue'
  import RiskForm from "./../risk_form"
  // import IssueForm from "./../issues/issue_form"
  import moment from 'moment'
  Vue.prototype.moment = moment

  export default {
    name: 'RiskSheets',
    components: {
      RiskForm,
      SweetModal,
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
        has_risk: false
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
        'setRiskForManager'
      ]),
      ...mapActions([
        'riskDeleted',
        'riskUpdated',
        'updateWatchedRisks'
      ]),
      deleteRisk() {
        var confirm = window.confirm(`Are you sure, you want to delete "${this.DV_risk.text}"?`)
        if (!confirm) {return}
        this.riskDeleted(this.DV_risk)
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

        if (this.fromView == 'map_view') {
          this.$emit('edit-risk', this.DV_risk)
        }
        else if (this.fromView == 'manager_view') {
          this.setRiskForManager({key: 'risk', value: this.DV_risk})
        }
        else {
          this.has_risk = Object.entries(this.DV_risk).length > 0
          this.DV_edit_risk = this.DV_risk
          this.$refs.riskFormModal && this.$refs.riskFormModal.open()
        }
      },
      onCloseForm() {
        this.$refs.riskFormModal && this.$refs.riskFormModal.close()
        this.has_risk = false
        this.DV_edit_risk = {}
        this.DV_edit_issue = {}
      },
      toggleWatched() {
        if (this.DV_risk.watched) {
          var confirm = window.confirm(`Are you sure, you want to remove this risk from on-watch?`)
          if (!confirm) {return}
        }
        this.DV_risk = {...this.DV_risk, watched: !this.DV_risk.watched}
        this.updateWatchedRisks(this.DV_risk)
      },
      updateRelatedRiskIssue(risk) {
        this.riskUpdated({facilityId: risk.facilityId, projectId: risk.projectId, cb: () => this.onCloseForm()})
      },
      getRisk(risk) {
        return this.currentRisks.find(t => t.id == risk.id) || {}
      },
      getIssue(issue) {
        return this.currentIssues.find(t => t.id == issue.id) || {}
      }
    },
    computed: {
      ...mapGetters([
        'facilities',
        'facilityGroups',
        'managerView',
        'currentRisks',
        'currentIssues',
        'viewPermit'
      ]),
      _isallowed() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.risks[salut]
      },
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
  .oneFive {
    width: 15%;
  }
  .sixteen {
    width: 16%;
  }
  .twenty {
    width: 20%;
  }
  .pg-content {
    width: 100%;
    height: 20px;
    font-weight: bold;
  }
  .toolTip {
    background-color: rgba(132, 133, 133, 1);
    font-size: .75rem;
    padding:1px;
    color: #fff;
    border-radius: 3px;
  }
  td {
    overflow-wrap: break-word;
  }
  .risk_form_modal.sweet-modal-overlay {
    z-index: 10000001;
  }
  .risk_form_modal.sweet-modal-overlay /deep/ .sweet-modal {
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
</style>
