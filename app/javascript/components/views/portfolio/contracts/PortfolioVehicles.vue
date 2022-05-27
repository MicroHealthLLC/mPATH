<template>
  <div style="height:80vh" class="portfolio-contracts-module">
    <div  style="height: 100%; overflow-y:auto">
    <el-table
    :data="tableData"
    border
    height="800"
    style="width: 95%">
   <el-table-column
      fixed
      label="Vehicle"
      width="175"
      prop="name">
    <template slot-scope="scope">
    <el-input
      size="small"
      v-if="scope.$index == createRow"
      placeholder=""
      style="text-align:center"
      v-model="scope.row.name"
      controls-position="right"
    ></el-input>
    <span v-if="rowId == scope.row.id && scope.$index !== createRow">
     <el-input
      size="small"
      placeholder=""
      style="text-align:center"
      v-model="scope.row.name"
      controls-position="right"
      ></el-input>
     </span>
  <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
   {{ scope.row.name }} 
   </span>

        </template>
    </el-table-column>
    <el-table-column
      label="Vehicle Full Name"
      width="300"
      prop="full_name">
    <template slot-scope="scope">
     <el-input
      size="small"
      v-if="scope.$index == createRow"
      placeholder=""
      style="text-align:center"
      v-model="scope.row.full_name"
      controls-position="right"
      ></el-input>
    <span v-if="rowId == scope.row.id && scope.$index !== createRow">
     <el-input
      size="small"
      placeholder=""
      style="text-align:center"
      v-model="scope.row.full_name"
      controls-position="right"
      ></el-input>
       
       
       </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.full_name }}
      </span>

    </template>

    </el-table-column>
      <el-table-column
      label="SINS or Subcategories"      
      width="250"
      prop="contract_sub_category_id">

      <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.contract_sub_category_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder=""

      >
        <el-option
          v-for="item in sinsOptions"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow &&
        (scope.row.contract_sub_category && scope.row.contract_sub_category.name !== null)">
       {{ scope.row.contract_sub_category.name }}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="Contracting Agency"
      width="175"
      prop="contract_agency_id">

    <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.contract_agency_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder=""

      >
        <el-option
          v-for="item in contractAgencyOptions"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
    <span v-if="rowId !== scope.row.id && scope.$index !== createRow &&
      (scope.row.contract_agency && scope.row.contract_agency.name !== null)">
      {{ scope.row.contract_agency.name }}
      </span>
      </template>
    </el-table-column>
    <el-table-column
      label="Vehicle Type"
      width="125"
      prop="contract_vehicle_type_id">
     <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.contract_vehicle_type_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder=""

      >
        <el-option
          v-for="item in vehicleTypes"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow &&
        (scope.row.contract_vehicle_type && scope.row.contract_vehicle_type.name !== null)">
       {{ scope.row.contract_vehicle_type.name }}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="Contract Number"
      width="125"
      prop="contract_number">

    <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.contract_number"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        default-first-option
        placeholder=""

      >
        <el-option
          v-for="item in contractNumber"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
       {{ scope.row.contract_number}}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="Ceiling"
      width="175"
      prop="ceiling">
      <template slot-scope="scope">
     <el-input
      size="small"
      v-if="scope.$index == createRow"
      type="number"
      placeholder=""
      style="text-align:center"
      v-model="scope.row.ceiling"
      controls-position="right"
      ></el-input>
      <span v-if="rowId == scope.row.id && scope.$index !== createRow">
     <el-input
      size="small"      
      type="number"
      placeholder=""
      style="text-align:center"
      v-model="scope.row.ceiling"
      controls-position="right"
      ></el-input>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.ceiling }}
      </span>
    </template>
    </el-table-column>

    <el-table-column
      label="Base Period Start"
      width="100"
      prop="base_period_start">
     <template slot-scope="scope">
        <v2-date-picker
          name="Date"       
          v-if="scope.$index == createRow"
          v-model="bpStart"  
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
         <v2-date-picker
          name="Date"    
          v-model="scope.row.base_period_start"     
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
    <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ moment(scope.row.base_period_start).format("MM-DD-YYYY") }}
      </span>
     </template>
   </el-table-column>
    <el-table-column
      label="Base Period End"
      width="100"
      prop="base_period_end">
         <template slot-scope="scope">
        <v2-date-picker
          name="Date"       
          v-if="scope.$index == createRow"
          v-model="bpEnd"  
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
         <v2-date-picker
          name="Date"    
          v-model="scope.row.base_period_end"     
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
     <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ moment(scope.row.base_period_end).format("MM-DD-YYYY") }}
      </span>
     </template>
    </el-table-column>
     <el-table-column
      label="Option Period Start"
      width="100"
      prop="option_period_start">
       <template slot-scope="scope">
        <v2-date-picker
          name="Date"       
          v-if="scope.$index == createRow"
          v-model="opStart"  
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
         <v2-date-picker
          name="Date"    
          v-model="scope.row.option_period_start"     
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
    <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ moment(scope.row.option_period_start).format("MM-DD-YYYY") }}
      </span>
     </template>
    </el-table-column>
       <el-table-column
      label="Option Period End"
      width="100"
      prop="option_period_end">
      <template slot-scope="scope">
        <v2-date-picker
          name="Date"       
          v-if="scope.$index == createRow"
          v-model="opEnd"  
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
         <v2-date-picker
          name="Date"    
          v-model="scope.row.option_period_end"     
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
    <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ moment(scope.row.option_period_end).format("MM-DD-YYYY") }}
      </span>
     </template>
    </el-table-column>
    <el-table-column
     label="Actions"
      width="95"
      fixed="right"
      align="center"
      >
       <template slot-scope="scope">
         <el-button
        type="default"
        @click="saveContractVehicle(scope.$index, scope.row)"
        v-if="scope.$index == rowIndex" 
        v-tooltip="`Save`" 
        class="bg-primary btn-sm text-light mx-0">               
        <i class="far fa-save"></i>
        </el-button>
      <el-button 
        type="default" 
        v-tooltip="`Cancel Edit`"       
        v-if="scope.$index == rowIndex"
        @click.prevent="cancelEdits(scope.$index, scope.row)"  
        class="bg-secondary btn-sm text-light mx-0">
      <i class="fas fa-ban"></i>
        </el-button>
         <el-button
          type="default"
           v-tooltip="`Edit`" 
          class="bg-light btn-sm"
           v-if="(scope.$index !== rowIndex) && (scope.$index !== createRow)"
          @click="editMode(scope.$index, scope.row)"><i class="fal fa-edit text-primary"></i>
          </el-button>
        <el-button
          type="default"
          @click="saveContractVehicle(scope.$index, scope.row)"
          v-if="scope.$index == createRow" 
          v-tooltip="`Save`" 
          class="bg-primary btn-sm text-light mx-0">               
        <i class="far fa-save"></i>
        </el-button>
       </template>
    </el-table-column>
  </el-table>
      </div>
      </div>


 
</template>
    
<script>
import { helpers } from 'chart.js';
import { mapGetters, mapMutations, mapActions } from "vuex";

export default {
  name: "PortfolioVehicles",
  components: {
  },
    data() {    
      return {
        nothing: true,
        rowIndex: null, 
        rowId: null, 
        tabPosition: 'bottom',
        bpStart: "",
        bpEnd: "",
        opStart: "",
        opEnd: "",
        search: '',
    };
  },
  methods: {
    ...mapMutations([
       "SET_CONTRACT_VEHICLES_STATUS"
    ]),
    ...mapActions([
      "createContractVehicle",
      "fetchContractVehicles",
      "updateContractVehicle",
      "deleteContractVehicle",
    ]),
  editMode(index, rows) {
    this.rowIndex = index,
     console.log(rows);
       console.log(this.createRow);
    this.rowId = rows.id
  },  
  saveContractVehicle(index, rows){
    this.rowIndex = null;
    this.rowId = null;
    let id = null;
    
    if (rows.id) {
      id = rows.id
      this.bpStart = rows.base_period_start;
      this.bpEnd = rows.base_period_end;
      this.opStart = rows.option_period_start;
      this.opEnd = rows.option_period_end;   
    }
    // Row edit action will occur here
  let contractVehicleData = {
        cVehicleData: {
          name: rows.name,
          fullName: rows.full_name,
          subCatId: rows.contract_sub_category_id,
          cAgencyId: rows.contract_agency_id,        
          type: rows.contract_vehicle_type_id,
          cNumber: rows.contract_number,         
          ceiling: rows.ceiling,
          bp_startDate: this.bpStart,
          bp_endDate: this.bpEnd,
          op_startDate: this.opStart,
          op_endDate: this.opEnd,
      },
    };
    console.log(contractVehicleData)
    if (id){
      this.updateContractVehicle({...contractVehicleData, id})
      console.log(contractVehicleData)
    } else {
      this.createContractVehicle({...contractVehicleData})     
    }
  }, 
  cancelEdits(index, rows) {
    this.rowIndex = null;
    this.rowId = null;
       
  },
  backHomeBtn() {
      window.location.pathname = "/";
  },    
  handleDelete(index, row) {
    console.log(index, row);
  }
  },
  mounted() {
    // this.fetchContractVehicles()
  },
  computed: {
    ...mapGetters([
      "contractProjects",
       //Contract Vehicles
      "contractVehiclesStatus",
      "contractVehicles",
      "contractVehiclesLoaded",
    ]),   
    tableData(){
      if (this.contractVehicles && this.contractVehicles.length > 0){
        let data = this.contractVehicles
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
       console.log(lastItem)
      return lastItem

    },
contractAgencyOptions(){
    if (this.contractVehicles && this.contractVehicles.length > 0){
      let uniqueAgencies = _.uniq(this.contractVehicles.filter(t => t.contract_agency_id))
      let agencies = uniqueAgencies.map(t => t.contract_agency).filter(t => t && t.id && t !== undefined && t !== null)
      let unique = [];
      // console.log(naics)
      agencies.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
      return unique
    }
  },
  sinsOptions(){
      if (this.contractVehicles && this.contractVehicles.length > 0){
      let uniqueSins = _.uniq(this.contractVehicles.filter(t => t.contract_sub_category_id))
      let sins = uniqueSins.map(t => t.contract_sub_category).filter(t => t && t.id && t !== undefined && t !== null)
      let unique = [];
      // console.log(naics)
      sins.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
      return unique
    }
  },
  vehicleTypes(){
      if (this.contractVehicles && this.contractVehicles.length > 0){
      let uniqueTypes = _.uniq(this.contractVehicles.filter(t => t.contract_vehicle_type_id))
      let types = uniqueTypes.map(t => t.vehicle_type).filter(t => t && t.id && t !== undefined && t !== null)
      let unique = [];
      // console.log(naics)
      types.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
      return unique
     }
    },
    contractNumber(){
     if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueContractNums = this.contractProjects.filter(t => t.number)
        let contractNums = uniqueContractNums.map(t => t.number).filter(t => t !== null)
        return _.uniq(contractNums.map(t => t))
      }
    },
  },
  watch: {
     contractVehiclesStatus: {
      handler() {
        if (this.contractVehiclesStatus == 200) {
          this.$message({
            message: `Vehicle data saved successfully.`,
            type: "success",
            showClose: true,
          });
          this.SET_CONTRACT_VEHICLES_STATUS(0);
          this.fetchContractVehicles();
          this.bpStart = "";
          this.bpEnd = "";
          this.opStart = "";
          this.opEnd = "";   
        }
      },
    },  
    
  },
};
</script>
    
<style scoped lang="scss">
  .bottomTabs{
    position: absolute;
    bottom: 2.5%;
    width: 100%;
  }
/deep/.el-table {
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