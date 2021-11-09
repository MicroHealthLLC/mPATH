<!--  NOTE: This file is used in Sheets view as overview tab -->
<template>
 <div id="facility-sheets" data-cy="facility_sheets">
    <div v-if="contentLoaded" class="position-sticky">
      <div>
        <div>
           <div class="container-fluid px-0 mx-1">
          <!-- <div v-if="_isallowed('read')" class="container-fluid px-0 mx-1"> -->
            <form
             @submit.prevent="saveContract"
            :class="{ 'vh100' : !contentLoaded}"
                accept-charset="UTF-8"
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
       <div class="ml-auto d-flex align-items-center">
        <button      
          class="btn btn-sm sticky-btn btn-primary text-nowrap btn-shadow mr-2"
        >
          Save
        </button>
    <!-- Add Read only button and v-if to Save button for privileges -->
        <button        
          class="btn btn-sm sticky-btn btn-outline-secondary btn-shadow mr-1"         
        >
          Close
        </button>
      </div>
    </div>
 
    <h6 class=" mt-4 mb-0" style="color: gray; font-size: 13px">
      <span style="color: #dc3545; font-size: 15px">*</span> Indicates required
      fields
    </h6>
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
 <div v-show="currentTab == 'tab1'" class="container mt-2 mx-0">
  <div class="row row_1">
    <div class="col-6 pl-0 pr-1">
    <label class="font-md"
        >Project Code <span style="color: #dc3545">*</span>
    </label> 
        <el-input
        name="Project Code" 
        v-model="contract.project_code"       
        type="text"
        placeholder="Enter Project Code"
        />          
    </div>
    <div class="col-6 pl-1 pr-0">
        <label class="font-md"
            >Contract Nickname <span style="color: #dc3545">*</span>
        </label>
            <el-input
            name="Contract Nickname"  
            v-model="contract.contract_nickname"          
            type="text"
            placeholder="Contact Nickname"
            />    <!-- Need to add additional div here for error handling -->           
    </div>
  </div>
  <div class="row row_2">
   <div class="col-6 pl-0 pr-1">
    <label class="font-md"
        >Type <span style="color: #dc3545">*</span>
    </label>
   <!-- <el-input
    name="Contract Nickname"  
    v-model="contract.contract_type_id"          
    type="text"
    placeholder="Contact Nickname"
    />  -->
     <v-app class="contract">
          <v-combobox
           :items=" cTypeOptions"
            v-model="contract.contract_type_id"  
            persistent-hint  
            dense
          ></v-combobox>
     </v-app>
      </div>
    <div class="col-6 pl-1 pr-0">
    <label class="font-md"
        >Status <span style="color: #dc3545">*</span>
    </label>
    <v-app class="contract">
    <v-combobox
      :items=" cStatusOptions"
      v-model="contract.contract_status_id"  
      persistent-hint  
      dense
    ></v-combobox>
     </v-app>
    </div>
  </div>
   <div class="row row_2">
    <div class="col-12 px-0">
    <label class="font-md"
        >Contract Name Customer (Agency) <span style="color: #dc3545">*</span>
    </label>
    <v-app class="contract">
    <v-combobox
      :items="cncOptions"
      v-model="contract.contract_name_customer_id"  
      persistent-hint  
      dense
    ></v-combobox>
     </v-app>
           
      </div>
   </div>
 <div class="row row_3">
  <div class="col-6 pl-0 pr-1">
    <label class="font-md"
      >Vehicle <span style="color: #dc3545">*</span>
    </label>
    <v-app class="contract">
    <v-combobox
      :items="vehicleOptions"
      v-model="contract.contract_vehicle_id"  
      persistent-hint  
      dense
    ></v-combobox>
    </v-app>

      </div>
  <div class="col-6 pl-1 pr-0">
        <label class="font-md"
          >Prime IDIQ/Vehicle Contract Number <span style="color: #dc3545">*</span>
        </label>
   <v-app class="contract">
    <v-combobox
      :items="vehicleOptions"
      v-model="contract.contract_vehicle_id"  
      persistent-hint  
      dense
    ></v-combobox>
    </v-app>
  </div>
 </div>
  <div class="row row_4">
     <div class="col-6 pl-0 pr-1">
        <label class="font-md"
          >Prime Contract Number / Task Order / PO Number <span style="color: #dc3545">*</span>
        </label>
  <el-select v-model="value" class="w-100" filterable clearable placeholder="Select">
    <el-option
      v-for="item in options"
      :key="item.value"
      :label="item.label"
      :value="item.value">
    </el-option>
   </el-select>
      </div>
       <div class="col-6 pl-1 pr-0">
        <label class="font-md"
          >Subcontract Number / PO Number *<span style="color: #dc3545">*</span>
        </label>
   <el-select v-model="value" class="w-100" filterable clearable  placeholder="Select">
    <el-option
      v-for="item in options"
      :key="item.value"
      :label="item.label"
      :value="item.value">
    </el-option>
   </el-select>
      </div>
  </div>
 <div class="row row_5">
   <div class="col-4 pl-0 pr-1">
    <label class="font-md"
        >Prime <span style="color: #dc3545">*</span>
    </label>
     <el-select v-model="value" class="w-100" filterable clearable  placeholder="Select">
    <el-option
      v-for="item in options"
      :key="item.value"
      :label="item.label"
      :value="item.value">
    </el-option>
   </el-select>
</div>
 </div>
 </div>

    <!-- TAB 2: DATES -->
    <div v-show="currentTab == 'tab2'" class="container mt-2 mx-0">

  <div class="row">
     <div class="col-6 pl-0 pr-1">
        <label class="font-md"
          >Contract Start Date <span style="color: #dc3545">*</span></label
        >
         <div>    
          <v2-date-picker
            name="Date"
            v-validate="'required'"          
            value-type="YYYY-MM-DD"
            format="DD MMM YYYY"
            placeholder="DD MM YYYY"
            class="w-100"
           
          />
        </div>
        <!-- <div v-show="errors.has('Date')" class="text-danger">
          {{ errors.first("Date") }}
        </div> -->
      </div>
     <div class="col-6 pl-1 pr-0">
     <label class="font-md"
          >Contract End Date <span style="color: #dc3545">*</span></label
        >
         <div>    
          <v2-date-picker
            name="Date"
            v-validate="'required'"          
            value-type="YYYY-MM-DD"
            format="DD MMM YYYY"
            placeholder="DD MM YYYY"
            class="w-100"
           
          />
        </div>         
    </div>
  </div>
  <div class="row">
     <div class="col-4 pl-1 pr-0">
        <label class="font-md"
          >Contract PoP <span style="color: #dc3545">*</span>
        </label>
  <el-select v-model="value" filterable clearable class="w-100" placeholder="Select">
    <el-option
      v-for="item in options"
      :key="item.value"
      :label="item.label"
      :value="item.value">
    </el-option>
   </el-select>     
    </div>
  </div>
      <div class="row">  
   <div class="col-6 pl-0 pr-1">
        <label class="font-md"
          >Current PoP Start <span style="color: #dc3545">*</span></label
        >
         <div>    
          <v2-date-picker
            name="Date"
            v-validate="'required'"          
            value-type="YYYY-MM-DD"
            format="DD MMM YYYY"
            placeholder="DD MM YYYY"
            class="w-100"
           
          />
        </div>
        <!-- <div v-show="errors.has('Date')" class="text-danger">
          {{ errors.first("Date") }}
        </div> -->
      </div>
     <div class="col-6 pl-1 pr-0">
     <label class="font-md"
          >Current Pop End <span style="color: #dc3545">*</span></label
        >
         <div>    
          <v2-date-picker
            name="Date"
            v-validate="'required'"          
            value-type="YYYY-MM-DD"
            format="DD MMM YYYY"
            placeholder="DD MM YYYY"
            class="w-100"
           
          />
        </div>         
    </div>
      </div>
<div class="row">
     <div class="col-4 pl-1 pr-0">
        <label class="font-md"
          >Days Remaining<span style="color: #dc3545">*</span>
        </label>
         <el-input
          name="Contract Nickname"        
          type="text"
          placeholder="Days Remaining"
         />    
         <!-- Need to add additional div here for error handling -->           
    </div>
</div>

    </div>
<div v-show="currentTab == 'tab3'" class="container mt-2 mx-0">
  <div class="row t3 row_1">
    <div class="col-6 pl-0 pr-1">
    <label class="font-md"
        >Total Contract Value<span style="color: #dc3545">*</span>
    </label> 
        <el-input
        name="Project Code"        
        type="text"
        placeholder="Total Contract Value"
        />          
    </div>
        <div class="col-6 pl-1 pr-0">
        <label class="font-md"
            >Current PoP Value <span style="color: #dc3545">*</span>
        </label>
            <el-input
            name="Contract Nickname"        
            type="text"
            placeholder="Contact Nickname"
            />    <!-- Need to add additional div here for error handling -->           
    </div>
  </div>
  <div class="row row_2">
   <div class="col-6 pl-0 pr-1">
    <label class="font-md"
        >Current PoP Funded <span style="color: #dc3545">*</span>
    </label>
        <el-input
        name="Contract Type"        
        type="text"
        placeholder="Enter Contract Type"
        />
           
      </div>
    <div class="col-6 pl-1 pr-0">
    <label class="font-md"
        >Total Funded To Date <span style="color: #dc3545">*</span>
    </label>
        <el-input
        name="Contract Status"        
        type="text"
        placeholder="Enter Contract Status"
        />           
    </div>
  </div>
    </div>
  </form>
        
           

       

            
        
            <!-- SECOND ROW WITH TASKS ISSUES & RISKS -->

            <!-- Row 2, col-1 for Tasks Card -->
            
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
import FormTabs from "../../../shared/FormTabs.vue"
export default {
  name: "SheetContract",
  components: {
    Loader,
    FormTabs
  },
  props: ["facility"],
  data() {
    return {
      loading: true,
      statusId: null, 
      // contractNickname: '',
      // projectCode: null, 
      inputText:'',
       options: [{
          value: 'Option1',
          label: 'Option1'
        }, {
          value: 'Option2',
          label: 'Option2'
        }, {
          value: 'Option3',
          label: 'Option3'
        }, {
          value: 'Option4',
          label: 'Option4'
        }, {
          value: 'Option5',
          label: 'Option5'
        }],
        value: '',
      currentTab: "tab1",
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
  this.fetchContracts();    
    console.log(this.contract)
       console.log(this.$route.params)
      console.log(this.$projectPrivileges[this.$route.params.programId][this.$route.params.contractId])  
    if (this.$route.params.contractId) {
      this.fetchContract({
        id: this.$route.params.contractId,
        ...this.$route.params,
      });
    }
  },
  methods: {
       ...mapActions(["fetchContract", "updateContract", "fetchContracts"]),
    ...mapMutations([
      "SET_CONTRACT", 
      "SET_CONTRACT_STATUS", 
      "SET_CONTRACTS",  
      "SET_CONTRACT_LOADED",
      "SET_CONTRACTS_LOADED",
      ]),
    saveContract() {
       let contractData = {
          contract: {
            contract_nickname: this.contract.contract_nickname,
            project_code: this.contract.project_code,  
                     
          },
        }
          
          // this.updateContract({
          //   ...contractData,
          //   ...this.$route.params,
          // })
    },
    onChangeTab(tab) {
      this.currentTab = tab ? tab.key : "tab1";
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
      "getAllFilterNames", 
      "getFilterValue", 
      "contract", 
      "contracts"]),
      cTypeOptions(){
        if (this.contracts){
          let t = this.contracts;
        return [...new Set(t.map((c) => c.contract_type_id))];
        }
      },
      vehicleOptions(){
        if (this.contracts){
          let v = this.contracts;
        return [...new Set(v.map((c) => c.contract_vehicle_id))];
        }
      },
      cncOptions(){
        if (this.contracts){
          let cnc = this.contracts;
        return [...new Set(cnc.map((c) => c.contract_name_customer_id))];
        }
      },
      cStatusOptions(){
        if (this.contracts){
          let s = this.contracts;
        return [...new Set(s.map((c) => c.contract_status_id))];
        }
      },
    },
 watch: {
    contract: {
      handler(newValue, oldValue) {
        if (
          this.contentLoaded &&
          Object.keys(oldValue).length === 0 &&
          this.$route.params.contractId != "new"
        ) {
        
           this.statusId = this.contract_status_id;   
           // this.nickname = this.contract.contract_nickname;
          // this.projectCode = this.contract.project_code;  
        }
      },
    },
    contentLoaded: {
      handler() {
        if (this.contract) {
          this.statusId = this.contract_status_id;
          // this.nickname = this.contract.contract_nickname;
          // this.projectCode = this.contract.project_code;        
        }
      },
    },
    contractStatus: {
      handler() {
        if (this.contractStatus == 200) {
          this.$message({
            message: `${this.contract.contract_nickname} was saved successfully.`,
            type: "success",
            showClose: true,
          });
          this.SET_CONTRACT_STATUS(0);
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
/deep/.el-collapse-item__header, /deep/.el-collapse-item__wrap  {
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

/deep/.el-collapse-item__arrow, /deep/.el-icon-arrow-right {
  display: none;
}
.giantNumber {
  font-size: 3.7rem;
}
.halfRem{
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
  top:7%;
  left:0;
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
  position:fixed;
  top: 130px;
  right: 9.5%;
  width: 20%;
  border-radius: 4px; 
  border: .5px solid #383838;
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

