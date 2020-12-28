<template>
  <div v-if="!loading" class="mt-4 risks-index" data-cy="risks_list">
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
      <div class="d-flex align-item-center justify-content-between w-100">
        <div class="input-group w-100">
          <div class="input-group-prepend d-inline">
            <span class="input-group-text" id="search-addon">
              <i class="fa fa-search"></i>
            </span>
          </div>
          <input
            type="search"
            style="height:30px"
            class="form-control form-control-sm"
            placeholder="Search Risks"
            aria-label="Search"
            aria-describedby="search-addon"
            v-model="risksQuery"
            data-cy="search_risks"
          />
        </div>
      </div>

      <div class="d-flex font-sm w-100 mt-2">
        <div class="simple-select enum-select w-100">
          <multiselect
            v-model="viewList"
            style="width:100%"
            :options="listOptions"
            :searchable="false"
            :close-on-select="false"
            :show-labels="false"
            placeholder="Filter by Risk Status"
            data-cy="risks_status_list"
          >
            <template slot="singleLabel">
              <div class="d-flex">
                <span class='select__tag-name'>{{viewList}}</span>
              </div>
            </template>
          </multiselect>
        </div>
      </div>
      <div class="d-flex align-item-center justify-content-between w-100">
        <div class="simple-select w-100">
          <multiselect
            v-model="C_riskMilestoneFilter"
            track-by="name"
            label="name"
            placeholder="Filter by Risk Milestone"
            :options="riskMilestones"
            :searchable="false"
            :multiple="true"
            select-label="Select"
            deselect-label="Remove"
            >
            <template slot="singleLabel" slot-scope="{option}">
              <div class="d-flex">
                <span class='select__tag-name'>{{option.name}}</span>
              </div>
            </template>
          </multiselect>
        </div>
      </div>

      <div class="mt-3">
        <button v-if="_isallowed('write')"
          class="btn btn-sm btn-primary addRiskBtn"
          @click.prevent="addNewRisk">
          <i class="fas fa-plus-circle mr-2" data-cy="new_risk"></i>
          Add Risk
        </button>
        <!-- <button
          @click.prevent="download"
          class="btn btn-sm btn-dark export2pdf">
          <font-awesome-icon icon="file-pdf" class="mr-2" />
           Export to PDF
        </button> -->
        <div class="form-check-inline font-sm float-right mt-1 mr-0">
          <label class="form-check-label mr-2">
            <input type="checkbox" class="form-check-input" v-model="C_myRisks">
            <i class="fas fa-user mr-1"></i>My Risks
          </label>
          <label v-if="viewPermit('watch_view', 'read')" class="form-check-label ml-2">
            <input type="checkbox" class="form-check-input" v-model="C_onWatchRisks">
            <i class="fas fa-eye mr-1"></i>On Watch
          </label>
        </div>
        <div v-if="_isallowed('read')">
          <div v-if="filteredRisks.length > 0">
            <hr/>
            <risk-show
              v-for="(risk, i) in filteredRisks"
              class="riskHover"
              :class="{'b_border': !!filteredRisks[i+1]}"
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
        <p v-else class="text-danger mx-2"> You don't have permissions to read!</p>
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
        viewList: 'active',
        listOptions: ['active','all', 'completed'],
        currentRisk: null,
        now: new Date().toISOString(),
        risksQuery: ''
      }
    },
    mounted() {
      this.loading = false
    },
    methods: {
      ...mapMutations([
        'setTaskIssueOverdueFilter',
        'setRiskMilestoneFilter',
        'setTaskTypeFilter',
        'setIssueSeverityFilter',
        'setMyActionsFilter',
        'updateFacilityHash',
        'setTaskForManager',
        'setOnWatchFilter'
      ]),
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
      download() {
        const doc = new jsPDF("l")
        const html =  this.$refs.table.innerHTML
        doc.autoTable({html: "#riskTableList"})
        doc.save("Risk_Log.pdf")
      },
      riskEdited(risk) {
        this.currentRisk = risk
        this.newRisk = true
      },
      addNewRisk() {
        if (this.from == "manager_view") {
          this.setTaskForManager({key: 'risk', value: {}})
        } else {
          this.currentRisk = null
          this.newRisk = true
        }
      }
    },
    computed: {
      ...mapGetters([
        'riskMilestones',
        'currentProject',
        'riskMilestoneFilter',
        'myActionsFilter',
        'managerView',
        'onWatchFilter',
        'viewPermit'
      ]),
      _isallowed() {
        return salut => this.$currentUser.role == "superadmin" || this.$permissions.risks[salut]
      },
      filteredRisks() {
        let milestoneIds = _.map(this.C_riskMilestoneFilter, 'id')
        const search_query = this.exists(this.risksQuery.trim()) ? new RegExp(_.escapeRegExp(this.risksQuery.trim().toLowerCase()), 'i') : null

        let risks = _.sortBy(_.filter(this.facility.risks, ((risk) => {
          let valid = Boolean(risk && risk.hasOwnProperty('progress'))
          if (this.C_myRisks) {
            let userIds = [..._.map(risk.checklists, 'userId'), risk.userId]
            if (this.C_myRisks) valid = valid && userIds.includes(this.$currentUser.id)
          }
          if (this.C_onWatchRisks) {
            valid  = valid && risk.watched
          }
          if (milestoneIds.length > 0) valid = valid && milestoneIds.includes(risk.riskTypeId)

          if (search_query) valid = valid && search_query.test(risk.riskDescription)

          switch (this.viewList) {
            case "active": {
              valid = valid && risk.progress < 100
              break
            }
            case "completed": {
              valid = valid && risk.progress == 100
              break
            }
            default: {
              break
            }
          }
          return valid;
        })), ['dueDate'])

        return risks
      },
      C_riskMilestoneFilter: {
        get() {
          return this.riskMilestoneFilter
        },
        set(value) {
          this.setRiskMilestoneFilter(value)
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
  input[type=search] {
    color: #383838;
    text-align: left;
    cursor: pointer;
    display: block;
  }
  .addRiskBtn,
  .export2pdf,
  .riskHover {
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
  }
</style>
