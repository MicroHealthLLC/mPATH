<!--  NOTE: This file is used in Sheets view as overview tab -->
<template>
  <div id="contract-sheets" data-cy="contract_sheets">
    <div v-if="contentLoaded" class="position-sticky">
      <div>
        <div>
          <div v-if="_isallowed('read')" class="container-fluid px-0 mx-1">
            <!-- <div v-if="_isallowed('read')" class="container-fluid px-0 mx-1"> -->
           <div class="row mt-3">
           <div class="col-4">
             <el-card
              class="box-card mb-2 pb-3"
              style="background-color:#fff"
              data-cy="task_summary"
            >   
            <h4>Contract Project Lightning</h4>
            <hr>
           <div class="row">
             <div class="col">
              <b>Customer:</b>
              </div>  
              <div class="col">
               <h5>US Navy Medical Corps</h5>
              </div>  
           </div>  
          
            <div class="row">
             <div class="col">
              <b>Contract Number:</b>
              </div>  
              <div class="col">
               <h5>0000-TZX</h5>
              </div>  
           </div>  

             <div class="row">
             <div class="col">
              <b>Award/TO Number:</b>
              </div>  
              <div class="col">
               <h5>WED-0000-TZX</h5>
              </div>  
             </div>  
          
          

           </el-card>  
           </div>
           </div>

           
          </div>
           <div v-else class="text-danger mx-2 mt-5">
            <h5> <i>Sorry, you don't have read-permissions for this tab! Please click on any available tab.</i></h5>
          </div>
        </div>
      </div>
    </div>
    <div v-else></div>
  </div>
</template>

<script>
// import http from "../../../../common/http";
Vue.component('my-currency-input', {
 props: ["value"],
 template: `
        <div>
            <input type="text" v-model="displayValue" @blur="isInputActive = false" @focus="isInputActive = true"/>
        </div>`,
          data: function() {
        return {
            isInputActive: false
        }
    },
    computed: {
        displayValue: {
            get: function() {
                if (this.isInputActive) {
                    // Cursor is inside the input field. unformat display value for user
                    return this.value.toString()
                } else if (!this.isInputActive && this.value) {
                    // User is not modifying now. Format display value for user interface
                    return "$ " + this.value.toFixed(2).replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, "$1,")
                } else return "$0.00"
            },
            set: function(modifiedValue) {
                // Recalculate value after ignoring "$" and "," in user input
                let newValue = parseFloat(modifiedValue.replace(/[^\d\.]/g, ""))
                // Ensure that it is not NaN
                if (isNaN(newValue)) {
                    newValue = 0
                }
                // Note: we cannot set this.value as it is a "prop". It needs to be passed to parent component
                // $emit the event so that parent component gets it
                this.$emit('input', newValue)
                console.log(newValue)
            }
        }
    }
});
import { mapGetters, mapMutations, mapActions } from "vuex";
import Loader from "../../../shared/loader";
import FormTabs from "../../../shared/FormTabs.vue";
import moment from 'moment';
import RelatedTaskMenuVue from '../../../shared/RelatedTaskMenu.vue';
export default {
  name: "SheetContract",
  components: {
    Loader,
    FormTabs,
  },
  props: ["contractClass"], 
  data() {
    return {
      loading: true,
      isInputActive: false,
      da: "",
      statusId: null,
      componentKey: 0,
      saving: false, 
      showErrors: false,
      loading: true,
      inputText: "",
      value: "",
      currentTab: "tab1",
      options: [],
      tabs: [
        {
          label: "Info",
          key: "tab1",
          closable: false,
          form_fields: [
          "Contract Name",
          "Contract Nickname",            
        ],
        },
        {
          label: "Dates",
          key: "tab2",
          closable: false,
        },
        {
          label: "$$",
          key: "tab3",
          closable: false,
        },
      ],
    };
  },
  mounted() {
    this.loading = false;
    if (this.$route.params.contractId) {
      this.getCAgency()
      this.getStatus()
      this.getVehicle()
      this.getPrimeIdIqNumber()
      this.getCnData()
      this.getClientType()
      this.getScData()
      this.getPrimeData()
      this.fetchClassificationTypes();
      this.fetchContract({
        id: this.$route.params.contractId,
        ...this.$route.params,
      });
    }
  },
  methods: {
    ...mapActions([
      "fetchContract",
      "updateContract",
      "fetchContracts",
      "fetchCurrentPop",
      "fetchContractGroupTypes",
      "fetchCustomerAgencies",
      "fetchContractStatuses",
      "fetchClientTypes",
      "fetchVehicles",
      "fetchPrime",
      "fetchVehicleNumbers",
      "fetchClassificationTypes",
      "fetchContractNumber",
      "fetchSubcontractNumbers",
    ]),
    ...mapMutations([
      "SET_CONTRACT",
      "SET_CONTRACT_STATUS",
      "SET_CONTRACTS",
      "SET_DAYS_REMAINING",
      "SET_CONTRACT_GROUP_TYPES",
      "SET_CONTRACT_LOADED",
      "SET_CONTRACT_CLASSIFICATIONS",
      "SET_CONTRACTS_LOADED",
      "SET_CLIENT_TYPES",
      "SET_CURRENT_POP",
      "SET_PRIME",
      "SET_VEHICLES",
      "SET_VEHICLE_NUMBERS",
      "SET_SUBCONTRACT_NUMBER",
      "SET_CONTRACT_NUMBER",
      "SET_CUSTOMER_AGENCIES_FILTER",
      "setContractTypeFilter",
    ]),
    reRenderDropdowns() {
      this.componentKey += 1;
      this.getCAgency()
      this.getStatus()
      this.getClientType()      
      this.getVehicle()
      this.getPrimeIdIqNumber()
      this.getCnData()
      this.getScData()
      this.getPrimeData()
      this.fetchClassificationTypes();
    },
    saveEdits() {
      // console.log(this.contract.notes)
     this.$validator.validate().then((success) => {
        if (!success || this.loading) {
          this.showErrors = !success;
          return;
        }
      let id = this.contract.id;
      let contractData = {
        contract: {
          id: this.contract.id,
          project_id: this.contract.project_id,
          facility_group_id: this.contract.facility_group_id,
          nickname: this.contract.nickname,
          notes: this.contract.notes,
          project_code: this.contract.project_code,
          contract_type_id: this.contract.contract_type_id,
          contract_status_id: this.contract.contract_status_id,
          total_subcontracts: this.contract.total_subcontracts,
          contract_client_type_id: this.contract.contract_client_type_id,
          contract_customer_id: this.contract.contract_customer_id,
          contract_vehicle_id: this.contract.contract_vehicle_id,
          contract_vehicle_number_id: this.contract.contract_vehicle_number_id,
          contract_number_id: this.contract.contract_number_id,
          contract_classification_id: this.contract.contract_classification_id,
          subcontract_number_id: this.contract.subcontract_number_id,
          contract_prime_id: this.contract.contract_prime_id,
          contract_current_pop_id: this.contract.contract_current_pop_id,
          name: this.contract.name,
          current_pop_start_time: this.contract.current_pop_start_time,
          current_pop_end_time: this.contract.current_pop_end_time,
          days_remaining: this.daysRemaining,
          total_contract_value: this.contract.total_contract_value,
          current_pop_value: this.contract.current_pop_value,
          current_pop_funded: this.contract.current_pop_funded,
          total_contract_funded: this.contract.total_contract_funded,
          start_date: this.contract.start_date,
          end_date: this.contract.end_date,
        },
      };
      this.updateContract({
        ...contractData,
        id,
      });
      this.reRenderDropdowns();
      this.saving = true
     });
      // console.log(this.contract.contract_vehicle_id.id)
    },
    vehicleText(e) {
      this.SET_VEHICLES(e);
    },
    getCAgency(e) {
      this.fetchCustomerAgencies();
    },
    getStatus(e) {
      this.fetchContractStatuses();
    },
    getClientType(e) {
      this.fetchClientTypes();
    },
    getVehicle(e) {
        this.fetchVehicles();

    },
    getPrimeIdIqNumber(e) {
        this.fetchVehicleNumbers();

    },
    getCnData(e) {
        this.fetchContractNumber();

    },
    getScData(e) {
        this.fetchSubcontractNumbers();

    },
    getPrimeData(e) {
        this.fetchPrime();

    },
    onChangeTab(tab) {
      this.currentTab = tab ? tab.key : "tab1";
      if (tab.key == "tab2") {
        this.fetchContractGroupTypes();
        this.fetchCurrentPop();
        this.fetchClassificationTypes();
      }
    },
    _isallowed(salut) {
      return this.checkPrivileges("SheetContract", salut, this.$route)
      // var programId = this.$route.params.programId
      // var contractId = this.$route.params.contractId
      // let fPrivilege = this.$contractPrivileges[programId][contractId]
      // let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      // let s = permissionHash[salut]
      // return fPrivilege.overview.includes(s);
    },
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "contractLoaded",
      "contractStatus",
      "getAllFilterNames",
      "getContractTypeFilter",
      "getCustomerAgenciesFilter",
      "getContractGroupTypes",
      "getCurrentPop",
      "getDaysRemaining",
      "getContractClassifications",
      "getContractGroupOptions",
      "getContractStatusesFilter",
      "getFilterValue",
      "getClientTypes",
      "getPrime",
      "getVehicles",
      "getVehicleNumbers",
      "getSubcontractNumbers",
      "getContractNumbers",
      "contract",
      "contracts",
    ]),
    daysRemaining(){    
      let popEnd =  this.contract.current_pop_end_time
      if(popEnd !== null ){      
        let a =  moment();
        let b =  moment(popEnd);
        let diff =  b - a;
        const diffDuration =  diff / (1000 * 3600 * 24);  
        return Math.trunc(diffDuration) 
      } else return this.contract.days_remaining  
    },
   cVehicleOptions: {
      get() {
        if (this.getVehicles && this.getVehicles.length > 0 ) {
            return this.getVehicles.filter(c => c.name !== 'undefined');
        } else return []       
      },
      set(value) {
        this.SET_VEHICLES(value);
      },
    },
    cClientTypeOptions: {
       get() {
        if (this.getClientTypes && this.getClientTypes.length > 0 ) {
            return this.getClientTypes;
        } else return []       
      },
      set(value) {
        this.SET_CLIENT_TYPES(value);
      },
    },
    cContractNoOptions: {
      get() {
        if (this.getContractNumbers && this.getContractNumbers.length > 0){
          return this.getContractNumbers.filter(c => c.name !== 'undefined');
        } else return []        
      },
      set(value) {
        this.SET_CONTRACT_NUMBER(value);
      },
    },
    cPrimeIdiqOptions: {
      get() {
        if(this.getVehicleNumbers && this.getVehicleNumbers.length > 0){
          return this.getVehicleNumbers.filter(c => c.name !== 'undefined');
        } else return []        
      },
      set(value) {
        this.SET_VEHICLE_NUMBERS(value);
      },
    },
    cSubcontractNoOptions: {
      get() {
        if (this.getSubcontractNumbers && this.getSubcontractNumbers.length > 0) {
          return this.getSubcontractNumbers.filter(c => c.name !== 'undefined');
        }  else return []   
      },
      set(value) {
        this.SET_SUBCONTRACT_NUMBER(value);
      },
    },
    cPrimeOptions: {
      get() {
        if (this.getPrime && this.getPrime.length > 0){
          return this.getPrime.filter(c => c.name !== 'undefined');
        } else return []      
      },
      set(value) {
        this.SET_PRIME(value);
      },
    },
    cStatusOptions: {
      get() {
        if (this.getContractStatusesFilter){
            return this.getContractStatusesFilter.filter(c => c.name !== 'undefined'); 
        } else return []       
      },
      set(value) {
        this.SET_CONTRACT_STATUSES_FILTER(value);
      },
    },
    cCustomerAgenciesOptions: {
      get() {
        if (this.getCustomerAgenciesFilter && this.getCustomerAgenciesFilter.length > 0){
          return this.getCustomerAgenciesFilter.filter(c => c.name !== 'undefined');
        } else return []      
      },
      set(value) {
        this.SET_CUSTOMER_AGENCIES_FILTER(value);
      },
    },
    cClassificationOptions: {
      get() {
        if (this.getContractClassifications && this.getContractClassifications.length > 0){
          return this.getContractClassifications.filter(c => c.name !== 'undefined');
        } else return []        
      },
      set(value) {
        this.SET_CONTRACT_CLASSIFICATIONS(value);
      },
    },
    cGroupTypeOptions: {
      get() {
         if (this.getContractGroupTypes && this.getContractGroupTypes.length > 0){
        return this.getContractGroupTypes.filter(c => c.name !== 'undefined')
         } else return []
      },
      set(value) {
        this.SET_CONTRACT_GROUP_TYPES(value);
      },
    },
  },
  watch: {
    contract: {
      handler(newValue, oldValue) {
        if (
          this.contractLoaded &&
          Object.keys(oldValue).length === 0 &&
          this.$route.params.contractId != "new"
        ) {
          this.statusId = this.contract_status_id;
          // this.nickname = this.contract.contract_nickname;
          // this.projectCode = this.contract.project_code;
        }
        if (this.contract.nickname === "null"){
            this.contract.nickname = ''
        }
        if (this.contract.name === "null"){
            this.contract.name = ''
        }
        if (this.contract.project_code === "null"){
            this.contract.project_code = ''
        }
        if (this.contract.total_subcontracts === "null"){
            this.contract.total_subcontracts = ''
        }
         if (this.contract.notes === "null"){
            this.contract.notes = ''
        }
      },
    },
    contractLoaded: {
      handler() {
        if (this.contract) {
          this.statusId = this.contract_status_id;
        }
      },
    },
    contractStatus: {
      handler() {
        if (this.contractStatus == 200) {
          this.reRenderDropdowns();
          this.$message({
            message: `${this.contract.nickname} was saved successfully.`,
            type: "success",
            showClose: true,
          });
          this.contractLoaded
          this.SET_CONTRACT_STATUS(0);
          setTimeout(() => this.saving = false, 2000);
        
        }
      },
    },
  },
};
</script>

<style lang="scss" scoped>
.f-head {
  word-break: break-word;
  text-overflow: ellipsis;
}
.f-notes {
  border: 1px solid #ccc;
  padding: 5px 10px;
  border-radius: 5px;
  overflow: auto;
  min-height: 20vh;
  max-height: 34vh;
}
.f-show-btn {
  font-size: 12px;
  font-style: italic;
  display: flex;
  flex-direction: row-reverse;
}
.custom-tab {
  background-color: #ededed !important;
  width: auto;
  text-transform: uppercase;
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.apply-btn,
.red,
.orange,
.green,
.grey,
.grey2,
.yellow {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.pg-content {
  width: 100%;
  height: 20px;
  font-size: 14px;
  font-weight: bold;
}
.vue-tabs {
  margin-top: 15px;
}
.vdp-datepicker {
  width: 100%;
}
.search-tab {
  width: 80%;
}
.displayNone {
  display: none !important;
}
.fa-usd-square {
  font-size: 1.3rem;
}

/deep/.el-button.usd-icon {
  cursor:text;
}
.fa-building {
  font-size: large !important;
  color: #383838 !important;
}
.close-sidebar-btn {
  z-index: 800;
  cursor: pointer;
  display: flex;
  position: absolute;
  left: 0;
  top: 0;
  background: #fff;
  padding: 5px;
}
.my-el-card {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}
.vue2-datepicker /deep/ .mx-input:disabled {
  color: #555;
  background-color: #fff;
}
.simple-select /deep/ .multiselect {
  .multiselect__placeholder {
    text-overflow: ellipsis;
  }
}
.saveBtn {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.fac-sum {
  border-radius: 2px;
  padding: 8px;
  margin-bottom: 8px;
  background-color: #fff;
  box-shadow: 0 5px 5px rgba(0, 0, 0, 0.19), 0 3px 3px rgba(0, 0, 0, 0.23);
}
.grey {
  background-color: lightgray;
}
.grey2 {
  background-color: #ededed;
}
.yellow {
  background-color: yellow;
}
.orange {
  background-color: #f0ad4e;
}
.green {
  background-color: rgb(92, 184, 92);
}
.red {
  background-color: #d9534f;
}
.red,
.orange,
.green,
.grey {
  color: white;
  border-radius: 3px;
}
.grey2 {
  border-radius: 3px;
}
.risk-card-title {
  font-size: 1rem;
}
.font-12 {
  font-size: 12px;
}
.mt-neg-4 {
  margin-top: -4px;
}
.underline {
  text-decoration: underline;
}
.smallerFont {
  font-size: 10px;
}
/deep/.el-collapse-item__header,
/deep/.el-collapse-item__wrap {
  border-bottom: none !important;
}

/deep/.el-card__body {
  padding-bottom: 0 !important;
}
/deep/.el-progress-circle {
  height: 100px !important;
  width: 100px !important;
}
/deep/.el-collapse-item__header {
  font-size: 2rem;
}

/deep/.el-collapse-item__arrow,
/deep/.el-icon-arrow-right {
  display: none;
}
.giantNumber {
  font-size: 3.7rem;
}
.halfRem {
  margin-top: 0.5rem;
  margin-bottom: 0.5rem;
}
.hide {
  visibility: hidden;
}
.relative {
  position: relative;
}
.absolute {
  position: absolute;
  top: 7%;
  left: 0;
}
.progressLabel {
  position: absolute;
}
.pill {
  position: absolute;
  top: 10%;
  right: 1%;
}

.filterDiv {
  position: fixed;
  top: 130px;
  right: 9.5%;
  width: 20%;
  border-radius: 4px;
  border: 0.5px solid #383838;
  overflow-y: auto;
}
.filterLabel {
  position: fixed;
}

.filterCol {
  height: 70px;
}

@media screen and (min-width: 1550px) {
  .filterDiv {
    right: 8.5%;
  }
}
</style>
