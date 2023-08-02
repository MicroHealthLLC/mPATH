<template>
  <div style="height:80vh" class="portfolio-contracts-module">
     <div  style="height: 100%; overflow-y:auto" v-if="contractProjects && contractProjects.length > 0">
     <el-table
    :data="contractProjects.filter(t => t && t.id && t.contract_end_date < today && t.ignore_expired == false)"
    border
    height="800"
    style="width: 95%"
    :summary-method="getSummaries"
    show-summary
    >
    <el-table-column
      fixed
      label="Code*"
      width=""
      prop="charge_code">
      <template slot-scope="scope">
       <span v-if="_isallowed('write') && rowId == scope.row.id">
        <el-input
          size="small"
          style="text-align:center"
          class="p-0"
          v-model="scope.row.charge_code"
          controls-position="right"
          ></el-input>
        </span>
      <span v-if="rowId !== scope.row.id">
        {{ scope.row.charge_code }} 
        </span>
        </template>
    </el-table-column>
    <el-table-column
      fixed
      label="Project Name*"
      width="200"
      prop="name">
      <template slot-scope="scope">
       <span v-if="_isallowed('write') && rowId == scope.row.id">
        <el-input
          size="small"
          style="text-align:center"
          v-model="scope.row.name"
          controls-position="right"
          ></el-input>
        </span>
      <span v-if="rowId !== scope.row.id">
        {{ scope.row.name }} 
        </span>
        </template>
     </el-table-column>
     <el-table-column    
      label="Customer*"
      width="200"
     >
     <template slot-scope="scope" >
     <span v-if="_isallowed('write') && (rowId == scope.row.id)">
       <el-select
        v-model="scope.row.contract_customer_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        placeholder=""
        clearable
        allow-create
        default-first-option
        size="small"
        >
        <el-option
          v-for="item in customerOptions"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && (scope.row.contract_customer && scope.row.contract_customer.name !== null)">
      {{ scope.row.contract_customer.name }}
      </span>
      </template>
    </el-table-column>
      <el-table-column    
      label="Vehicle/ Schedule"
      width="125"
      >
       <template slot-scope="scope" >
     <span v-if="_isallowed('write') && (rowId == scope.row.id)">
     
       <span v-if="(!scope.row.contract_vehicle && scope.row.contract_vehicle_id) || (!scope.row.contract_vehicle && !scope.row.contract_vehicle_id) ">
      <el-select
        v-model="blankVehicle"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        placeholder=""
        default-first-option
        size="small"
       >
        <el-option
          v-for="item in vehicleOptions"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
       </span>
      <span v-if="scope.row.contract_vehicle && scope.row.contract_vehicle_id">
       <el-select
        v-model="scope.row.contract_vehicle_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        placeholder=""
        default-first-option
        size="small"
       >
        <el-option
          v-for="item in vehicleOptions"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>     
      </span>
      </span>
      <span v-if="rowId !== scope.row.id && 
      (scope.row.contract_vehicle && scope.row.contract_vehicle.name !== null)">
      {{ scope.row.contract_vehicle.name }}
      </span>
      </template>
    </el-table-column>
      <el-table-column
      label="Contract Number**"
      width="125"
     >
    <template slot-scope="scope" >
     <span v-if="_isallowed('write') && (rowId == scope.row.id)">
       <el-select
        v-model="scope.row.contract_number_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        placeholder=""
        clearable
        allow-create
        default-first-option
        size="small"
      >
        <el-option
          v-for="item in contractNumber"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
       <span v-if="rowId !== scope.row.id && (scope.row.contract_number && scope.row.contract_number.name !== null)">
       {{ scope.row.contract_number.name }}
      </span>
      </template>
    </el-table-column>
    <el-table-column
      label="Award/ TO Number**"
      width="125"
      
     >
       <template slot-scope="scope" >
     <span v-if="_isallowed('write') && (rowId == scope.row.id)">
       <el-select
        v-model="scope.row.contract_award_to_id"
        filterable       
        track-by="id" 
        placeholder=""       
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        size="small"
      >
        <el-option
          v-for="item in awardToNums"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id &&
        (scope.row.contract_award_to && scope.row.contract_award_to.name !== null)">
      {{ scope.row.contract_award_to.name }}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="NAICS*"
      width="70"
      >
     <template slot-scope="scope" >
      <span v-if="_isallowed('write') && (rowId == scope.row.id)">
       <el-select
        v-model="scope.row.contract_naic_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        placeholder=""
        clearable
        allow-create
        default-first-option
        size="small"
      >
        <el-option
          v-for="item in naicsOptions"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && (scope.row.contract_naic && scope.row.contract_naic.name !== null)">
      {{ scope.row.contract_naic.name }}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="Award Type*"
      width="70"
      >
      <template slot-scope="scope" >
      <span v-if="_isallowed('write') && (rowId == scope.row.id)">
       <el-select
        v-model="scope.row.contract_award_type_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        placeholder=""
        allow-create
        default-first-option
        size="small"
      >
        <el-option
          v-for="item in awardTypes"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && (scope.row.contract_award_type && scope.row.contract_award_type.name !== null)">
      {{ scope.row.contract_award_type.name }}
      </span>
      </template>
    </el-table-column>
    <el-table-column
      label="Contract Type*"
      width="75"
      >
      <template slot-scope="scope" >
      <span v-if="_isallowed('write') && (rowId == scope.row.id )">
       <el-select
        v-model="scope.row.contract_type_id"
        filterable       
        track-by="name" 
        placeholder=""       
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        size="small"
      >
        <el-option
          v-for="item in contractTypes"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && (scope.row.contract_type && scope.row.contract_type.name !== null)">
      {{ scope.row.contract_type.name }}
      </span>
      </template>
    </el-table-column>
      <el-table-column
      label="Prime vs Sub"
      width="55"
      prop="prime_or_sub">
     <template slot-scope="scope" >
      <span v-if="_isallowed('write') && (rowId == scope.row.id)">
       <el-select
        v-model="scope.row.prime_or_sub"
        track-by="name"  
        placeholder=""      
        value-key="id"
        class="w-100"
        clearable
        default-first-option
        size="small"
        >
        <el-option
          v-for="item in primeOrSub"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id">
      {{ scope.row.prime_or_sub }}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="Contract Start Date*"
      width="100"
      prop="contract_start_date">
       <template slot-scope="scope">
     <span v-if="_isallowed('write') && (rowId == scope.row.id)">
         <v2-date-picker
          name="Date"     
          v-model="contractStartDate"  
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
     <span v-if="rowId !== scope.row.id">
        <span v-if="scope.row.contract_start_date == null || scope.row.contract_start_date == undefined">      
        </span>
        <span v-else>
            {{ moment(scope.row.contract_start_date).format("MM-DD-YYYY") }}
        </span>   
      </span>
     </template>
    </el-table-column>
     <el-table-column
      label="Contract End Date*"
      width="100"
      prop="contract_end_date">
      <template slot-scope="scope">
       <span v-if="_isallowed('write') && rowId == scope.row.id">
         <v2-date-picker
          name="Date"     
          :disabled-date="disabledContractEndDate"
          v-model="contractEndDate"  
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
      <span v-if="rowId !== scope.row.id" >
        <span v-if="scope.row.contract_end_date == null || scope.row.contract_end_date == undefined">      
        </span>
        <span v-else>
          {{ moment(scope.row.contract_end_date).format("MM-DD-YYYY") }}
        </span>     
      </span>
     </template>
    </el-table-column>
     <el-table-column
      label="Total Contract Value*"
      width="175"
      prop="total_contract_value">
     <template slot-scope="scope">
      <span v-if="_isallowed('write') && (rowId == scope.row.id)">
     <el-input
      size="small"    
      :step="0.01"  
      type="number"
      style="text-align:center"
       v-model="scope.row.total_contract_value"
      controls-position="right"
      ></el-input>
      </span>
      <span v-if="rowId !== scope.row.id">
      {{ scope.row.total_contract_value | toCurrency }}
      </span>
    </template>

    </el-table-column>
    <el-table-column
      label="PoP's*"
       width="100"
       >
      <template slot-scope="scope" >
      <span v-if="_isallowed('write') && (rowId == scope.row.id)">
       <el-select
        v-model="scope.row.contract_pop_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        placeholder=""
        clearable
        allow-create
        default-first-option
        size="small"
        >
        <el-option
          v-for="item in pops"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && (scope.row.contract_pop && scope.row.contract_pop.name !== null)">
      {{ scope.row.contract_pop.name }}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="Current PoP"
      width="100"
       >
    <template slot-scope="scope" >
      <span v-if="_isallowed('write') && (rowId == scope.row.id )">
       <el-select
        v-model="scope.row.contract_current_pop_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        placeholder=""
        clearable
        allow-create
        default-first-option
        size="small"
       >
        <el-option
          v-for="item in currentPops"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && (scope.row.contract_current_pop && scope.row.contract_current_pop.name !== null)">
      {{ scope.row.contract_current_pop.name }}
      </span>
      </template>
    </el-table-column>
    <el-table-column
      label="Contract PoP Start Date*"
       width="100"
      prop="contract_current_pop_start_date">
      <template slot-scope="scope">
        <span v-if="rowId == scope.row.id">
         <v2-date-picker
          name="Date"   
          v-model="popStartDate"          
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
       <span v-if="rowId !== scope.row.id">
          <span v-if="scope.row.contract_current_pop_start_date == null || scope.row.contract_current_pop_start_date == undefined" >        
          </span>
          <span v-else> {{ moment(scope.row.contract_current_pop_start_date).format("MM-DD-YYYY") }}
          </span>      
       </span>
     </template>
    </el-table-column>
       <el-table-column
      label="Contract PoP End Date*"
       width="100"
      prop="contract_current_pop_end_date">
     <template slot-scope="scope">
        <span v-if="rowId == scope.row.id">
         <v2-date-picker
          name="Date"  
          :disabled-date="disabledPoPEndDate"
          v-model="popEndDate"       
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
      <span v-if="rowId !== scope.row.id">
       <span v-if="scope.row.contract_current_pop_end_date == null || scope.row.contract_current_pop_end_date == undefined" >        
          </span>
          <span v-else>  {{ moment(scope.row.contract_current_pop_end_date).format('MM-DD-YYYY') }}
          </span>    
      </span>
     </template>
    </el-table-column>
    <el-table-column
      label="Notes"
      width="350"
       >
      <template slot-scope="scope">
        <span v-if="_isallowed('write') && rowId == scope.row.id && scope.$index !== createRow">
        <el-input
          size="small"
          style="text-align:center"
          v-model="scope.row.notes"
          controls-position="right"
          ></el-input>
        </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
        {{ scope.row.notes }} 
        </span>
        </template>
     </el-table-column>
    <el-table-column
      label="Actions"
      width="145"
      v-if="_isallowed('write') || _isallowed('delete')"
      fixed="right"
      align="center">
   <template slot-scope="scope">
      <el-button
        size="small"
        type="default"
        @click="saveContractProject(scope.$index, scope.row)"
        v-if="scope.$index == rowIndex &&  (
          scope.row.charge_code && scope.row.name && scope.row.contract_customer_id && 
          (scope.row.contract_number_id || scope.row.contract_award_to_id) && 
           scope.row.contract_naic_id && scope.row.contract_award_type_id &&
          scope.row.contract_type_id && contractStartDate && contractEndDate &&  scope.row.total_contract_value
          && scope.row.contract_pop_id && popStartDate && popEndDate
          )"  
        v-tooltip="`Save`" 
        class="bg-primary text-light px-2">               
        <i class="far fa-save"></i>
        </el-button>
      <el-button 
       size="small"
        type="default" 
        v-tooltip="`Cancel Edit`"       
        v-if="scope.$index == rowIndex"
        @click.prevent="cancelEdits(scope.$index, scope.row)"  
        class="bg-secondary text-light px-2">
      <i class="fas fa-ban"></i>
        </el-button>
        <el-button 
        size="small"
        type="default" 
        v-tooltip="`Exempt expiration date`"       
        v-if="scope.$index == rowIndex"
        @click.prevent="setIgnoreStatus(scope.$index, scope.row)"  
        class="bg-light px-2">
        <i class="fa-solid fa-calendar-xmark text-success"></i>
        </el-button>
         <el-button
         size="small"
          type="default"
           v-tooltip="`Edit`" 
          class="bg-light px-2"
           v-if="(scope.$index !== rowIndex) && _isallowed('write')"
          @click="editMode(scope.$index, scope.row)"><i class="fal fa-edit text-primary"></i>
          </el-button>
          <el-button
          type="default"
          size="small"
           v-tooltip="`Delete`" 
          class="bg-light px-2"
           v-if="(scope.$index !== rowIndex) && _isallowed('delete')"
          @click="deleteContractProj(scope.$index, scope.row)"><i class="far fa-trash-alt text-danger "></i>   
          </el-button>
       </template>

    </el-table-column>
  </el-table>
  
      </div>
     
      </div>
          
</template>
    
<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
Vue.filter('toCurrency', function (value) {
    if (typeof value !== "number") {
        return value;
    }
    var formatter = new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD'
    });
    return formatter.format(value);
});
export default {
  name: "PortfolioExpiredContracts",
   data() {    
      return {
        today: new Date().toISOString().slice(0, 10),
        blankVehicle: '',
        totalContractValue: 0,
        contractStartDate: null,
        contractEndDate: null,
        popStartDate: null,
        popEndDate: null,
        nothing: true,
        pocDialogVisible: false,
        rowIndex: null,  
        rowId: null, 
        pocRowIndex: null, 
        pocRowId: null, 
        email: null, 
        tabPosition: 'bottom',      
        search: '',
    };
  },
  methods: {
    ...mapMutations([
     "SET_CONTRACT_PROJECT_STATUS",
     "SET_CONTRACT_POCS_STATUS"
    ]),
    ...mapActions([
      //Contract Projects
      "createContractProject",
      "fetchContractProjects",
      "updateContractProject",
      "deleteContractProject",
      "updateIgnoreExpired",

      //POCs
      "createContractPOC",
      "fetchContractPOCs",
      "updateContractPOC",
      "deleteContractPOC",
      //Vehicles
      "fetchContractVehicles"
    ]),
    _isallowed(salut) {
        return this.checkPortfolioContractPrivileges("PortfolioContracts", salut, this.$route, {settingType: 'Contracts'})
    }, 
    getSummaries(param) {
      const { columns, data } = param;
      const sums = [];
      columns.forEach((column, index) => {
        if (index === 0) {
          sums[index] = 'Totals';
          return;
        }
        const values = data.map(item => Number(item[column.property]));
        if (!values.every(value => isNaN(value))) {
          sums[index] = values.reduce((prev, curr) => {
            const value = Number(curr);
            if (!isNaN(value)) {
              return prev + curr
            } else {
              return prev
            }
          }, 0);
        } else {
          sums[index] = '';
        }
      });
      let newSums = ['Totals']
      for (const ele of sums) {
        if (ele !== 'Totals'){          
            newSums.push(ele.toLocaleString('en-US', {
            style: 'currency',
            currency: 'USD',
          }))
        }          
      }    
     
     return newSums
    },
  validateEmail(m){
    let regex = new RegExp("([!#-'*+/-9=?A-Z^-~-]+(\.[!#-'*+/-9=?A-Z^-~-]+)*|\"\(\[\]!#-[^-~ \t]|(\\[\t -~]))+\")@([!#-'*+/-9=?A-Z^-~-]+(\.[!#-'*+/-9=?A-Z^-~-]+)*|\[[\t -Z^-~]*])");
    if (m) {
      if (regex.test(m)){
        this.isValidEmail = true
        return (true)
      }
      MessageDialogService.showDialog({
        message: `Please enter a valid email address.  Example: "john@example.com"`,
        type: MessageDialogService.msgTypes.WARNING,
        
      });
      this.isValidEmail = false
       console.log( this.isValidEmail)
      return (false)
    }
  } ,
  validatePhoneNumber(m){
    if (m) {
      if (m.length == 14){
        console.log(m.length)
        this.isValidWorkNum = true
        return (true)    
      } else {
        this.isValidWorkNum = false
          console.log(this.isValidWorkNum )
        MessageDialogService.showDialog({
          message: `Please enter a valid 10 digit phone number.  Example: (508) 345-2342`,
          type: MessageDialogService.msgTypes.WARNING
        });
      }  
    }
  },
  validateMobPhoneNumber(m){
    if (m) {
  if (m.length == 14)
    {
      console.log(m.length)
      this.isValidMobNum = true
      return (true)    
    }
       console.log(this.isValidMobNum )
    MessageDialogService.showDialog({
      message: `Please enter a valid 10 digit phone number.  Example: (508) 345-2342`,
      type: MessageDialogService.msgTypes.WARNING,
      
    });
      this.isValidMobNum = false
      return (false)
    }
  },
  acceptNumber() {
    if(this.workNumberVal){
      let x = this.workNumberVal.replace(/\D/g, '').match(/(\d{0,3})(\d{0,3})(\d{0,4})/);
      this.workNumberVal = !x[2] ? x[1] : '(' + x[1] + ') ' + x[2] + (x[3] ? '-' + x[3] : '');
    }
      if(this.workNumberValNew){
      let  x = this.workNumberValNew.replace(/\D/g, '').match(/(\d{0,3})(\d{0,3})(\d{0,4})/);
      this.workNumberValNew = !x[2] ? x[1] : '(' + x[1] + ') ' + x[2] + (x[3] ? '-' + x[3] : '');
    }
    if(this.mobNumberVal){
      let x = this.mobNumberVal.replace(/\D/g, '').match(/(\d{0,3})(\d{0,3})(\d{0,4})/);
      this.mobNumberVal = !x[2] ? x[1] : '(' + x[1] + ') ' + x[2] + (x[3] ? '-' + x[3] : '');
    }
    if(this.mobNumberValNew){
      let  x = this.mobNumberValNew.replace(/\D/g, '').match(/(\d{0,3})(\d{0,3})(\d{0,4})/);
      this.mobNumberValNew = !x[2] ? x[1] : '(' + x[1] + ') ' + x[2] + (x[3] ? '-' + x[3] : '');
    }
     
    },
  backHomeBtn() {
      window.location.pathname = "/";
    }, 
  log(e){
    // console.log(e)
  },
  openPocModal(){
    this.pocDialogVisible = true;
    this.fetchContractPOCs()
  },   
  editMode(index, rows) {
    console.log(rows)
    this.rowIndex = index,
    this.rowId = rows.id
    if(rows.contract_current_pop_start_date){
      this.popStartDate = rows.contract_current_pop_start_date;
    }
    if(rows.contract_current_pop_end_date){
      this.popEndDate = rows.contract_current_pop_end_date;
    }
    if(rows.contract_start_date){
      this.contractStartDate = rows.contract_start_date;
    }
    if(rows.contract_end_date){
      this.contractEndDate = rows.contract_end_date;
    }
  }, 
  editPocRow(index, rows) {
    console.log(rows)
    this.pocRowIndex = index,
    this.pocRowId = rows.id
    this.workNumberVal = rows.work_number
    this.mobNumberVal = rows.mobile_number
  },  
  saveNewPocRow(){
    // Row create action will occur here
    //After save, dont forget to push new empty object to append new create row
     this.pocRowIndex = null;
    this.pocRowId = null;
  },
 deleteContractPoc(index, rows) {
        this.$confirm(
        `Are you sure you want to delete ${rows.name} from your Contract POC's?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
       ).then(() => {
        this.deleteContractPOC(rows.id);
      });     
    },
  deleteContractProj(index, rows) {
        this.$confirm(
        `Are you sure you want to delete ${rows.name} from your Contract Projects?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
       ).then(() => {
        this.deleteContractProject(rows.id);
      });     
    },
  saveContractProject(index, row){
    this.rowIndex = null;
    this.rowId = null;
    let id = null;
    let vehicle = ""
    
    if (row.id) {
      id = row.id
      if(this.blankVehicle !== '') {
        vehicle = this.blankVehicle
      }
      if(row.contract_vehicle_id && row.contract_vehicle && row.contract_vehicle.name) {
        vehicle = row.contract_vehicle_id
      }
      if (!this.contractEndDate) {
        this.contractEndDate = rows.contract_end_date
      }
      if (!this.contractStartDate) {
        this.contractStartDate = rows.contract_start_date
      }       
      if (!this.popStartDate){
        this.popStartDate = rows.contract_current_pop_start_date
      }
      if (!this.popEndDate){
        this.popEndDate = rows.contract_current_pop_end_date
      }
    }
    // if (!row.id){
    //     vehicle = row.contract_vehicle_id;
    //     this.contractStartDate = this.newContractStartDate;
    //     this.contractEndDate = this.newContractEndDate;
    //     this.popStartDate = this.newPopStartDate;
    //     this.popEndDate = this.newPopEndDate;
    // }
    let contractProjectData = {
          cProjectData: {
            charge_code: row.charge_code,
            name: row.name,  
            notes: row.notes, 
            prime_or_sub: row.prime_or_sub,
            contract_customer_id: row.contract_customer_id, 
            contract_start_date: this.contractStartDate,
            contract_end_date: this.contractEndDate,
            total_contract_value: row.total_contract_value,
            contract_current_pop_start_date: this.popStartDate,
            contract_current_pop_end_date: this.popEndDate,
            contract_vehicle_id: vehicle,
            number:  row.contract_number_id,
            contract_naic_id: row.contract_naic_id,
            contract_award_type_id: row.contract_award_type_id,
            contract_award_to_id: row.contract_award_to_id,
            contract_type_id: row.contract_type_id,
            contract_pop_id: row.contract_pop_id,
            contract_current_pop_id: row.contract_current_pop_id,        
        },
      };
    console.log(vehicle)
    if (id){
      this.updateContractProject({...contractProjectData, id})
    } else {
      this.createContractProject({...contractProjectData})     
    }
   
  },
 setIgnoreStatus(index, row){
    this.rowIndex = null;
    this.rowId = null;
    let id = row.id;
  
   let contractProjectData = {
          cProjectData: {
            isExpired: true
        },
      };
    this.updateIgnoreExpired({...contractProjectData, id})
   
  },
  saveContractPOC(index, row){
    let filteredNote = ''
    if(row.notes) {
    filteredNote = row.notes
    }
    let workNumber = ''
    let mobNumber = ''
    if (row.id){
        workNumber = this.workNumberVal
        mobNumber = this.mobNumberVal
    } else {
        workNumber = this.workNumberValNew
        mobNumber = this.mobNumberValNew
    } 
    let contractPOCdata = {
          cPOCsData: {
            name: row.name, 
            pocType: row.poc_type, 
            email: row.email, 
            title: row.title, 
            workNum: workNumber, 
            mobileNum: mobNumber, 
            notes: filteredNote,   
        },
      };
       console.log(row)
      if (row.id){
      if ((this.workNumberVal && this.workNumberVal.length !== 14) || (this.mobNumberVal && this.mobNumberVal.length !== 14)){
         MessageDialogService.showDialog({
              message: `Please fix invalid field(s) before saving.`,
              type: MessageDialogService.msgTypes.WARNING,
              
            });

        } else {
              let id = row.id
              this.updateContractPOC({...contractPOCdata, id})
           }
      }  else {
         if ((this.workNumberValNew && this.workNumberValNew.length !== 14) || (this.mobNumberValNew && this.mobNumberValNew.length !== 14)){
         MessageDialogService.showDialog({
              message: `Please fix invalid field(s) before saving.`,
              type: MessageDialogService.msgTypes.WARNING,
              
            });

        } else {      
            this.createContractPOC({...contractPOCdata})
            }
       }     
     
    },
    
  cancelPocEdits() {
    this.pocRowIndex = null;
    this.pocRowId = null;
    this.workNumberVal = null;
       
  },
  cancelEdits(index, rows) {
    this.rowIndex = null;
    this.rowId = null; 
    this.fetchContractProjects();      
  },
  handleDelete(index, row) {
    console.log(index, row);
  },
  disabledPoPEndDate(date) {
  if (this.popStartDate){
    date.setHours(0, 0, 0, 0);
    const startDate = new Date(this.popStartDate);
    startDate.setHours(48, 0, 0, 0);
    return date < startDate;  
    }      
  },  
  disabledContractEndDate(date) {
  if (this.contractStartDate){
    // console.log(this.contractStartDate, date)
    date.setHours(0, 0, 0, 0);
    const startDate = new Date(this.contractStartDate);
    startDate.setHours(48, 0, 0, 0);
    return date < startDate;  
    }      
  },  
  disabledNewPoPEndDate(date) {
  if (this.newPopStartDate){
    date.setHours(0, 0, 0, 0);
    const startDate = new Date(this.newPopStartDate);
    startDate.setHours(48, 0, 0, 0);
    return date < startDate;  
    }      
  },  
  // disabledNewContractEndDate(date) {
  // if (this.newContractStartDate){
  //   // console.log(this.contractStartDate, date)
  //   date.setHours(0, 0, 0, 0);
  //   const startDate = new Date(this.newContractStartDate);
  //   startDate.setHours(48, 0, 0, 0);
  //   return date < startDate;  
  //   }      
  // },  
  handleClick(tab, event) {
    if (tab.paneName == 0){
       this.pane0 = true;
       this.pane1 = false;
       this.pane2 = false;
       this.pane3 = false;
       this.pane4 = false;
    }
    if (tab.paneName == 1){
       this.pane0 = false;
       this.pane1 = true;
       this.pane2 = false;
       this.pane3 = false;
       this.pane4 = false;
    }
    if (tab.paneName == 2){
       this.pane0 = false;
       this.pane1 = false;
       this.pane2 = true;
       this.pane3 = false;
       this.pane4 = false;
    }
    if (tab.paneName == 3){
       this.fetchContractPOCs()
       this.pane0 = false;
       this.pane1 = false;
       this.pane2 = false;
       this.pane3 = true;
       this.pane4 = false;
    }
   if (tab.paneName == 4){
       this.pane0 = false;
       this.pane1 = false;
       this.pane2 = false;
       this.pane3 = false;
       this.pane4 = true;
    } 
   },
  },
  mounted() {
    this.fetchContractProjects()
    this.fetchContractVehicles()
  },
  computed: {
    ...mapGetters([
      //Contract Projects 
      "contractProjectStatus",
      "contractProjects",
      "contractProjectsLoaded",
      //POCs 
      "contractPOCs",
      "contractPOCsStatus",  
      "contractPOCsLoaded",
      //Vehicles
      "contractVehicles",
      "contractVehiclesLoaded",

    ]), 
   tableData(){
      if (this.contractProjects && this.contractProjects.length > 0){
        let data = this.contractProjects.filter(t => t.contract_end_date > this.today)
         data.push({})
         return data    
     } else {
        let data = []
         data.push({})
         return data
     }      
    },
    createRow(){
      let lastItem = this.tableData.length - 1
      //  console.log(lastItem)
      return lastItem
    },
    pocData(){
      if (this.contractPOCs && this.contractPOCs.length > 0){
       let data = this.contractPOCs  
         data.push({})
         return data    
     } else {
        let data = []
         data.push({})
         return data
     }      
    },
    pocCreateRow(){
      let lastItem = this.pocData.length - 1
      //  console.log(lastItem)
      return lastItem
    },
    awardToNums(){
      if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueAwardTOs = _.uniq(this.contractProjects.filter(t => t.contract_award_to_id))
        let awardTos = uniqueAwardTOs.map(t => t.contract_award_to).filter(t => t !== undefined)
        let unique = [];
        // console.log(awardTos)
        awardTos.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
         return unique
      }
    },
    primeOrSub(){
      return ['Prime', 'Sub']
    },                  
    contractNumber(){
     if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueContractNums = _.uniq(this.contractProjects.filter(t => t.contract_number_id))
        let contractNums = uniqueContractNums.map(t => t.contract_number).filter(t => t && t.id && t !== undefined && t !== null)
        let unique = [];
        contractNums.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
        return unique
      }
    },
    // vehicleOptions is foreign key value and must come from contract_vehicles data, not from contractProjects
    vehicleOptions(){
     if (this.contractVehicles && this.contractVehicles.length > 0){
        let vehicles = this.contractVehicles.filter(t => t && t.id)
        return vehicles
      }
    },
    customerOptions(){
     if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueCustomerOptions = _.uniq(this.contractProjects.filter(t => t.contract_customer_id))
        let customers = uniqueCustomerOptions.map(t => t.contract_customer).filter(t => t !== undefined)
        let unique = [];
        // console.log(customers)
        customers.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
        return unique
      }
    },
    naicsOptions(){
     if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueNaics = _.uniq(this.contractProjects.filter(t => t.contract_naic_id))
        let naics = uniqueNaics.map(t => t.contract_naic).filter(t => t && t.id && t !== undefined && t !== null)
        let unique = [];
        // console.log(naics)
        naics.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
        return unique
      }
    },
    awardTypes(){
      if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueAwardTypes = _.uniq(this.contractProjects.filter(t => t.contract_award_type_id))
        let awardType = uniqueAwardTypes.map(t => t.contract_award_type).filter(t => t && t.id && t !== undefined && t !== null)
        let unique = [];
        // console.log(awardType)
        awardType.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
        return unique
      }
    },
    pops(){
      if (this.contractProjects && this.contractProjects.length > 0){
        let uniquePoPs = _.uniq(this.contractProjects.filter(t => t.contract_pop_id))
        let pops = uniquePoPs.map(t => t.contract_pop).filter(t => t && t.id && t !== undefined && t !== null)
        let unique = [];
        // console.log(pops)
        pops.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
         return unique
      }
    },
    currentPops(){
      if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueCurrentPoPs = _.uniq(this.contractProjects.filter(t => t.contract_current_pop_id))
        let currentPoPs = uniqueCurrentPoPs.map(t => t.contract_current_pop).filter(t => t && t.id && t !== undefined && t !== null)
        let unique = [];
        // console.log(currentPoPs)
        currentPoPs.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
         return unique
      }
    },
    contractTypes(){
     if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueContractTypes = _.uniq(this.contractProjects.filter(t => t.contract_type_id))
        let contractTypes = uniqueContractTypes.map(t => t.contract_type).filter(t => t && t.id && t !== undefined && t !== null)
        let unique = [];
        // console.log(contractTypes)
        contractTypes.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
         return unique
      }
    },
  },
  watch: {
    contractProjectStatus: {
      handler() {
        if (this.contractProjectStatus == 200) {
          MessageDialogService.showDialog({
            message: `Contract Project saved successfully.`,
            
            
          });
          this.contractStartDate = null;
          this.contractEndDate = null;
          this.popStartDate = null;
          this.popEndDate = null;
          this.blankVehicle = '';  
          this.SET_CONTRACT_PROJECT_STATUS(0);
          this.fetchContractProjects();
          this.fetchContractVehicles()
        }
      },
    }, 
   
  },
};
</script>
    
<style scoped lang="scss">
.requiredFields{
    font-size: .88rem;
  }
  .bottomTabs{
    position: absolute;
    bottom: 2.5%;
    width: 100%;
  }
 ::v-deep.el-dialog {
  width: 70%;  
 }
::v-deep.el-input__inner {
  padding: 1px 1px 1px 2px;
}
::v-deep.el-tabs__content {
  padding-bottom: 0;
}
::v-deep.el-table {
    font-size: 13px !important;
    th.el-table__cell>.cell {
      word-break: break-word;
      font-size: .88rem;
    }
    th {
      color: #383838;
    }

    tr, td {
      word-break: break-word;
    }


  }    
</style>