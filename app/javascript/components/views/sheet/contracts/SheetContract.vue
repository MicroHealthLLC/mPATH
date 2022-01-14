<!--  NOTE: This file is used in Sheets view as overview tab -->
<template>
  <div id="contract-sheets" data-cy="contract_sheets">
    <div v-if="contentLoaded" class="position-sticky">
      <div>
        <div>
          <div class="container-fluid px-0 mx-1">
            <!-- <div v-if="_isallowed('read')" class="container-fluid px-0 mx-1"> -->
            <form
              v-loading="!contractLoaded || saving"
              accept-charset="UTF-8"
              element-loading-text="Fetching Contract data. Please wait..."
              element-loading-spinner="el-icon-loading"
              element-loading-background="rgba(0, 0, 0, 0.8)"
            >
              <hr class="mb-6 mt-4" />
              <div class="mt-2  d-flex align-items-center">
                <div class="d-flex pt-1 mb-1 justify-content-start">
                  <FormTabs
                    :current-tab="currentTab"
                    :tabs="tabs"
                    :allErrors="errors"
                    @on-change-tab="onChangeTab"
                  />
                </div>
                <!-- Breadcrumbs and form buttons -->
              </div>
          <div class="container-fluid px-5">
          <div class="row">
            <div class="col pl-0">
              <h6 class=" mt-4 mb-0" style="color: gray; font-size: 13px">
                <span style="color: #dc3545; font-size: 15px">*</span> Indicates
                required fields
              </h6>
            </div>
               <div class="col text-right">
                    <button
                      @click.prevent="saveEdits"
                      class="btn btn-sm saveBtn btn-primary text-nowrap btn-shadow mr-2"
                    >
                      Save Edits
                    </button>
                    <!-- Add Read only button and v-if to Save button for privileges -->
                  </div>
          </div>
          </div>
              <div class="pt-1">
                <div v-if="errors.items.length > 0" class="text-danger ">
                  Please fill the required fields before submitting
                  <ul class="error-list mx-4">
                    <li
                      v-for="(error, index) in errors.all()"
                      :key="index"
                      v-tooltip="{
                        content: 'Field is located on Lesson Info',
                        placement: 'left',
                      }"
                    >
                      {{ error }}
                    </li>
                  </ul>
                </div>
              </div>
              <!-- Lesson Info Tab -->
              <div v-show="currentTab == 'tab1'" class="container-fluid mt-2 mx-0 px-5">
                <div class="row row_1">
                  <div class="col-5 pl-0">
                   <label class="font-md">Contract Name </label>
                    <el-input
                      name="Contract Nickname"
                      v-model="contract.name"
                      type="text"
                      placeholder="Contract Name"
                    />
                  </div>
                  <!-- <div class="col-5 pl-0 d-flex">
                    <label class="font-sm my-auto mr-2 d-inline-block"
                      >Project Group Name:
                    </label>
                    <el-select
                      v-model="contract.contract_type_id"
                      class="w-50 d-inline"
                      track-by="id"
                      value-key="id"
                      placeholder="Select Contract Group Type"
                    >
                      <el-option
                        v-for="item in getContractGroupOptions"
                        :value="item.id"
                        :key="item.id"
                        :label="item.name"
                      >
                      </el-option>
                    </el-select>
                  </div> -->
                 
                </div>
                <div class="row row_1">
                  <div class="col-2 pl-0">
                    <label class="font-md">Project Code </label>
                    <el-input
                      name="Project Code"
                      v-model="contract.project_code"
                      type="text"
                      placeholder="Enter Project Code"
                    />
                  </div>
                  <div class="col-5 px-2">
                    <label class="font-md">Contract Nickname </label>
                    <el-input
                      name="Contract Nickname"
                      v-model="contract.nickname"
                      type="text"
                      placeholder="Contract Nickname"
                    />
                    <!-- Need to add additional div here for error handling -->
                  </div>
                  <div class="col-3 pr-2">
                    <label class="font-md">Type </label>
                    <el-select
                      v-model="contract.contract_classification_id"
                      class="w-100"
                      track-by="id"
                      value-key="id"
                      placeholder="Select Type"
                    >
                      <el-option
                        v-for="item in cClassificationOptions"
                        :value="item.id"
                        :key="item.id"
                        :label="item.name"
                      >
                      </el-option>
                    </el-select>
                  </div>
                      <div class="col-2 pr-0">
                    <label class="font-md">Total # of Subcontracts</label>
                   <el-input
                      name="Total Subcontracts"  
                      v-model="contract.total_subcontracts"
                      type="text"
                      placeholder="Contract Nickname"                                   
                    />
                  </div>
                </div>
                <div class="row row_2">
                  <div class="col-6 pl-0 pr-3">
                    <label class="font-md">Customer (Agency) </label>

                    <el-select
                      v-model="contract.contract_customer_id"
                      filterable
                      class="w-100"
                      track-by="id"
                      value-key="id"
                      allow-create
                      default-first-option
                      placeholder="Select or enter Customer (Agency)"
                    >
                      <el-option
                        v-for="item in cCustomerAgenciesOptions"
                        :key="item.id"
                        :label="item.name"
                        :value="item.id"
                      >
                      </el-option>
                    </el-select>
                  </div>

                  <div class="col-6 pl-3 pr-0">
                    <!-- Amand, if I add 'multiple" attribute to this Customer Entity el-select component, it creates error.
                    Can backend store multiple entities?   -->
                    <label class="font-md">Customer Entity </label>
                    <el-select
                      v-model="contract.contract_client_type_id"
                      filterable       
                      track-by="name"        
                      value-key="id"
                      class="w-100"
                      allow-create
                      default-first-option
                      placeholder="Select or enter status"
                    >
                      <el-option
                        v-for="item in cClientTypeOptions"
                        :key="item.id"
                        :label="item.name"
                        :value="item.id"
                      >
                      </el-option>
                    </el-select>
                  </div>
                </div>
                <div class="row row_2"></div>
                <div class="row row_3">
                  <div class="col-6 pl-0 pr-3">
                    <label class="font-md">Vehicle </label>
                    <el-select
                      v-model="contract.contract_vehicle_id"
                      filterable
                      :key="componentKey"
                      class="w-100"
                      track-by="id"
                      value-key="id"
                      allow-create
                      default-first-option
                      placeholder="Select Vehicle"
                    >
                      <el-option
                        v-for="item in cVehicleOptions"
                        :key="item.id"
                        :label="item.name"
                        :value="item.id"
                      >
                      </el-option>
                    </el-select>
                  </div>
                  <div class="col-6 pl-3 pr-0">
                    <label class="font-md"
                      >Prime IDIQ/Vehicle Contract Number
                    </label>
                    <el-select
                      v-model="contract.contract_vehicle_number_id"
                      filterable
                      class="w-100"
                      track-by="id"
                      value-key="id"
                      allow-create
                      default-first-option
                      placeholder="Select Prime IDIQ/Vehicle Contract Number"
                    >
                      <el-option
                        v-for="item in cPrimeIdiqOptions"
                        :key="item.id"
                        :label="item.name"
                        :value="item.id"
                      >
                      </el-option>
                    </el-select>
                  </div>
                </div>
                <div class="row row_4">
                  <div class="col-6 pl-0 pr-3">
                    <label class="font-md"
                      >Prime Contract Number / Task Order / PO Number
                    </label>
                    <el-select
                      v-model="contract.contract_number_id"
                      filterable
                      ref="primeContractNumber"
                      name="primeContractNumber"
                      class="w-100"
                      track-by="id"
                      value-key="id"
                      allow-create
                      default-first-option
                      placeholder="Select Prime IDIQ/Vehicle Contract Number"
                    >
                      <el-option
                        v-for="item in cContractNoOptions"
                        :key="item.id"
                        :label="item.name"
                        :value="item.id"
                      >
                      </el-option>
                    </el-select>
                  </div>
                  <div class="col-6 pl-3 pr-0">
                    <label class="font-md"
                      >Subcontract Number / PO Number
                    </label>
                    <el-select
                      v-model="contract.subcontract_number_id"
                      filterable
                      class="w-100"
                      name="subContractNumber"
                      ref="subContractNumber"
                      track-by="id"
                      value-key="id"
                      allow-create
                      default-first-option
                      placeholder="Select Subcontract Number / PO Number"
                    >
                      <el-option
                        v-for="item in cSubcontractNoOptions"
                        :key="item.id"
                        :label="item.name"
                        :value="item.id"
                      >
                      </el-option>
                    </el-select>
                  </div>
                </div>
                <div class="row row_5">
                  <div class="col-6 pl-0 pr-3">
                    <label class="font-md"
                      >Prime 
                    </label>
                    <el-select
                      v-model="contract.contract_prime_id"
                      filterable
                      class="w-100"
                      track-by="id"
                      value-key="id"
                      allow-create
                      default-first-option
                      placeholder="Select Prime"
                    >
                      <el-option
                        v-for="item in cPrimeOptions.filter(c => c.name !== 'null')"
                        :key="item.id"
                        :label="item.name"
                        :value="item.id"
                      >
                      </el-option>
                    </el-select>
                  </div>
                   <div class="col-6 pl-3 pr-0">
                  <label class="font-md">Status </label>
                    <el-select
                      v-model="contract.contract_status_id"
                      filterable
                      class="w-100"
                      track-by="id"
                      value-key="id"
                      allow-create
                      default-first-option
                      placeholder="Select or enter status"
                    >
                      <el-option
                        v-for="item in cStatusOptions"
                        :key="item.id"
                        :label="item.name"
                        :value="item.id"
                      >
                      </el-option>
                    </el-select>
                   </div>
                  <!-- STATUS -->
                </div>

                <div class="row row_5">
                  <div class="col-12 px-0">
                    <label class="font-md"
                      >Contract Notes
                    </label>
                     <el-input
                      name="Contract Notes"
                      type="textarea"
                      :rows="3"
                      v-model="contract.notes"
                      placeholder="Enter note here"
                    />
                
                  </div>
                 </div>
              </div>

              <!-- TAB 2: DATES -->
              <div v-show="currentTab == 'tab2'" class="container-fluid mt-2 mx-0 px-5">
                <div class="row">
                  <div class="col-6 pl-0 pr-1">
                    <label class="font-md"
                      >Contract Start Date
                     </label
                    >
                    <div>
                      <v2-date-picker
                        name="Date"
                        v-model="contract.end_date"
                        value-type="YYYY-MM-DD"
                        format="M/DD/YYYY"
                        placeholder="M/DD/YYYY"
                        class="w-100"
                      />
                    </div>
                    <!-- <div v-show="errors.has('Date')" class="text-danger">
          {{ errors.first("Date") }}
        </div> -->
                  </div>
                  <div class="col-6 pl-1 pr-0">
                    <label class="font-md"
                      >Contract End Date
                     </label
                    >
                    <div>
                      <v2-date-picker
                        name="Date"
                        v-model="contract.start_date"
                        value-type="YYYY-MM-DD"
                        format="M/DD/YYYY"
                        placeholder="M/DD/YYYY"
                        class="w-100"
                      />
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-2 pl-0 pr-2">
                    <label class="font-md"
                      >Current PoP
                    </label>
                    <el-select
                      v-model="contract.contract_current_pop_id"
                      class="w-100"
                      track-by="id"
                      value-key="id"
                      placeholder="Select Current Pop"
                    >
                      <el-option
                        v-for="item in getCurrentPop.filter(c => c.name !== 'undefined')"
                        :value="item.id"
                        :key="item.id"
                        :label="item.name"
                      >
                      </el-option>
                    </el-select>
                  </div>
                  <div class="col-5 pr-1">
                    <label class="font-md"
                      >Current PoP Start
                    </label
                    >
                    <div>
                      <v2-date-picker
                        name="Date"
                        v-model="contract.current_pop_start_time"
                        value-type="YYYY-MM-DD"
                        format="M/DD/YYYY"
                        placeholder="M/DD/YYYY"
                        class="w-100"
                      />
                    </div>
                    <!-- <div v-show="errors.has('Date')" class="text-danger">
          {{ errors.first("Date") }}
        </div> -->
                  </div>
                  <div class="col-5 pr-0">
                    <label class="font-md"
                      >Current PoP End
                      <span style="color: #dc3545">*</span></label
                    >
                    <div>
                      <v2-date-picker
                        name="Date"
                        v-model="contract.current_pop_end_time"  
                        value-type="YYYY-MM-DD"                     
                        format="M/DD/YYYY"
                        placeholder="M/DD/YYYY"
                        class="w-100"
                      />
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-4 pl-1 pr-0">
                    <label class="font-md"
                      >Days Remaining
                    </label>
                    <el-input
                      v-model="daysRemaining"
                      :disabled="!contract.current_pop_end_time"
                      name="Days Remaining"
                      placeholder="Days Remaining"
                    />
                    <!-- Need to add additional div here for error handling -->
                  </div>
                </div>
              </div>
              <div v-show="currentTab == 'tab3'" class="container-fluid px-5 mt-2 mx-0">
                <div class="row t3 row_1">
                  <div class="col-6 pl-0 pr-1">
                    <label class="font-md"
                      >Total Contract Value
                    </label>
                    <el-input
                      name="Total Contract Value"
                      v-model="contract.total_contract_value"
                      type="text"
                      placeholder="Total Contract Value"
                    />
                  </div>
                  <div
                    class="col-6 pl-1 pr-0">
                    <label class="font-md"
                      >Current PoP Value 
                    </label>
                    <el-input
                      name="Pop Value"
                      v-model="contract.current_pop_value"
                      type="text"
                      placeholder="Enter Current PoP Value"
                    />
                    <!-- Need to add additional div here for error handling -->
                  </div>
                </div>
                <div
                  class="row row_2">
                  <div class="col-6 pl-0 pr-1">
                    <label class="font-md"
                      >Current PoP Funded
                    </label>
                    <el-input
                      name="Contract Type"
                      v-model="contract.current_pop_funded"
                      type="text"
                      placeholder="Enter Current PoP Funded"
                    />
                  </div>
                  <div class="col-6 pl-1 pr-0">
                    <label class="font-md"
                      >Total Funded To Date
                    </label>
                    <el-input
                      v-model="contract.total_contract_funded"
                      name="Contract Status"
                      type="text"
                      placeholder="Enter Total Funded To Date"
                    />
                  </div>
                </div>
              </div>
            </form>
          </div>
          <!-- <div v-else class="text-danger mx-2 my-4">
            You don't have permission to read!
          </div> -->
        </div>
      </div>
    </div>
    <div v-else></div>
  </div>
</template>

<script>
// import http from "../../../../common/http";
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
      da: "",
      statusId: null,
      componentKey: 0,
      saving: false, 
      // contractNickname: '',
      // projectCode: null,
      inputText: "",
      value: "",
      currentTab: "tab1",
      options: [],
      tabs: [
        {
          label: "Info",
          key: "tab1",
          closable: false,
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
      console.log(this.contract.notes)
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
    //    _isallowed(salut) {
    //       var programId = this.$route.params.programId;
    //       var contractId = this.$route.params.contractId
    //       let fPrivilege = this.$projectPrivileges[programId][contractId]
    //       let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    //       let s = permissionHash[salut]
    //       return  fPrivilege.overview.includes(s);
    //   },
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
            return this.getClientTypes.filter(c => c.name !== 'undefined');
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
