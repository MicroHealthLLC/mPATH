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
      prop="vehicle">
    <template slot-scope="scope">
    <el-input
      size="small"
      v-if="scope.$index == createRow"
      placeholder="Enter Vehicle"
      style="text-align:center"
      v-model="scope.row.vehicle"
      controls-position="right"
    ></el-input>
    <span v-if="rowId == scope.row.id && scope.$index !== createRow">
     <el-input
      size="small"
      placeholder="Enter Vehicle Full Name"
      style="text-align:center"
      v-model="scope.row.vehicle"
      controls-position="right"
      ></el-input>
     </span>
  <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
   {{ scope.row.vehicle }} 
   </span>

        </template>
    </el-table-column>
    <el-table-column
      label="Vehicle Full Name"
      width="300"
      prop="vehicle_full_name">
    <template slot-scope="scope">
     <el-input
      size="small"
      v-if="scope.$index == createRow"
      placeholder="Enter Vehicle Full Name"
      style="text-align:center"
      v-model="scope.row.vehicle_full_name"
      controls-position="right"
      ></el-input>
    <span v-if="rowId == scope.row.id && scope.$index !== createRow">
     <el-input
      size="small"
      placeholder="Enter Vehicle Full Name"
      style="text-align:center"
      v-model="scope.row.vehicle_full_name"
      controls-position="right"
      ></el-input>
       
       
       </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.vehicle_full_name }}
      </span>

    </template>

    </el-table-column>
      <el-table-column
      label="SINS or Subcategories"      
      width="250"
      prop="sins_or_subs">

      <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.sins_or_subs"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder="Select or enter SINS or Subcategory"

      >
        <el-option
          v-for="item in sinsOptions"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
 <span v-if="rowId !== scope.row.id && scope.$index !== createRow">

  {{ scope.row.sins_or_subs }}

      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="Contracting Agency"
      width="175"
      prop="contracting_agency">

    <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.contracting_agency"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder="Select or enter Contracting Agency"

      >
        <el-option
          v-for="item in contractAgencyOptions"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
  <span v-if="rowId !== scope.row.id && scope.$index !== createRow">

  {{ scope.row.contracting_agency }}

      </span>
      </template>
    </el-table-column>
    <el-table-column
      label="Vehicle Type"
      width="125"
      prop="vehicle_type">
     <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.vehicle_type"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder="Select or enter Vehicle Type"

      >
        <el-option
          v-for="item in vehicleTypes"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
       {{ scope.row.vehicle_type }}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="Contract Number"
      width="125"
      prop="contract_num">

    <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.contract_num"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder="Select or enter Contract Number"

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
       {{ scope.row.contract_num}}
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
      placeholder="Enter Ceiling"
      style="text-align:center"
      v-model="scope.row.ceiling"
      controls-position="right"
      ></el-input>
      <span v-if="rowId == scope.row.id && scope.$index !== createRow">
     <el-input
      size="small"      
      type="number"
      placeholder="Enter Ceiling"
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
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
         <v2-date-picker
          name="Date"       
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
    <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.base_period_start }}
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
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
         <v2-date-picker
          name="Date"       
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
    <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.base_period_end }}
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
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
         <v2-date-picker
          name="Date"       
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
    <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.option_period_start }}
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
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
         <v2-date-picker
          name="Date"       
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
    <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.option_period_end }}
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
        @click="saveEdits(scope.$index, scope.row)"
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
          @click="saveNewRow(scope.$index, scope.row)"
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
        sinsOptions: [ 
                       '8(a), SDVOSB, SB', 
                       'SDVOSB',
                       'SIN 132-51 - Information Technology Professional Services and 132-56 (Health IT SIN) ',
                       'Small Business'
                       ],
       contractAgencyOptions: [ 
                       'Naval Sea Systems Command (NAVSEA)', 
                       'General Services Administration ',
                       'Centers for Medicare & Medicaid Services (CMS)',
                       'Federal Aviation Administration (FAA)'
                       ],
       vehicleTypes:   [ 
                      'Federal Supply Schedule', 
                      'IDIQ ',
                      'GWAC',
                      'BPA issued as MOA'
                       ],

      contractNumber:   [ 
                       '000-33340-3', 
                       'ZPPPP-18F0001',
                       'ZZ-VVBCKG0',
                       'CCCC-008-002'
                        ],
        vehicleArray: [{
          id: 0,
          vehicle: 'NBC IT-7489',
          vehicle_full_name: "GSA Schedule ZZZ",
          sins_or_subs:"SIN 132-51 - Information Technology Professional Services and 132-56 (Health IT SIN) ",
          contracting_agency: "General Services Administration",        
          vehicle_type: 'Federal Supply Schedule',
          contract_num: "7(b) ZZZ TYI",         
          ceiling: 250242442,
          base_period_start: '2016-05-03',
          base_period_end: '2016-05-03',
          option_period_start: '2016-05-03',
          option_period_end: '2016-05-03',
          }, {
          id: 1,
          vehicle: 'NBC IT-7489',
          vehicle_full_name: "GSA Schedule ZZZ",
          sins_or_subs:"SIN 132-51 - Information Technology Professional Services and 132-56 (Health IT SIN) ",
          contracting_agency: "General Services Administration",        
          vehicle_type: 'Federal Supply Schedule',
          contract_num: "7(b) ZZZ TYI",         
          ceiling: 1299242442,
          base_period_start: '2016-05-03',
          base_period_end: '2016-05-03',
          option_period_start: '2016-05-03',
          option_period_end: '2016-05-03',
        }, {
          id: 2,
          vehicle: 'NBC IT-7489',
          vehicle_full_name: "GSA Schedule ZZZ",
          sins_or_subs:"SIN 132-51 - Information Technology Professional Services and 132-56 (Health IT SIN) ",
          contracting_agency: "General Services Administration",        
          vehicle_type: 'Federal Supply Schedule',
          contract_num: "7(b) ZZZ TYI",               
          ceiling: 250242442,
          base_period_start: '2016-05-03',
          base_period_end: '2016-05-03',
          option_period_start: '2016-05-03',
          option_period_end: '2016-05-03',
        }, {
           id: 3,
          vehicle: 'NBC IT-7489',
          vehicle_full_name: "GSA Schedule ZZZ",
          sins_or_subs:"SIN 132-51 - Information Technology Professional Services and 132-56 (Health IT SIN) ",
          contracting_agency: "General Services Administration",        
          vehicle_type: 'Federal Supply Schedule',
          contract_num: "7(b) ZZZ TYI",         
          ceiling: 250242442,
          base_period_start: '2016-05-03',
          base_period_end: '2016-05-03',
          option_period_start: '2016-05-03',
          option_period_end: '2016-05-03',
        }, {
          id: 4,
         vehicle: 'NBC IT-7489',
          vehicle_full_name: "GSA Schedule ZZZ",
          sins_or_subs:"SIN 132-51 - Information Technology Professional Services and 132-56 (Health IT SIN) ",
          contracting_agency: "General Services Administration",        
          vehicle_type: 'Federal Supply Schedule',
          contract_num: "7(b) ZZZ TYI",         
          ceiling: 3457442,
          base_period_start: '2016-05-03',
          base_period_end: '2016-05-03',
          option_period_start: '2016-05-03',
          option_period_end: '2016-05-03',
        }, {
          id: 5,
           vehicle: 'NBC IT-7489',
          vehicle_full_name: "GSA Schedule ZZZ",
          sins_or_subs:"SIN 132-51 - Information Technology Professional Services and 132-56 (Health IT SIN) ",
          contracting_agency: "General Services Administration",        
          vehicle_type: 'Federal Supply Schedule',
          contract_num: "7(b) ZZZ TYI",         
          ceiling: 250242442,
          base_period_start: '2016-05-03',
          base_period_end: '2016-05-03',
          option_period_start: '2016-05-03',
          option_period_end: '2016-05-03',
        }, {
          id: 6,
          vehicle: 'NBC IT-7489',
          vehicle_full_name: "GSA Schedule ZZZ",
          sins_or_subs:"SIN 132-51 - Information Technology Professional Services and 132-56 (Health IT SIN) ",
          contracting_agency: "General Services Administration",        
          vehicle_type: 'Federal Supply Schedule',
          contract_num: "7(b) ZZZ TYI",         
          ceiling: 478442,
          base_period_start: '2016-05-03',
          base_period_end: '2016-05-03',
          option_period_start: '2016-05-03',
          option_period_end: '2016-05-03',
        }, {
          id: 7,
           vehicle: 'NBC IT-7489',
          vehicle_full_name: "GSA Schedule ZZZ",
          sins_or_subs:"SIN 132-51 - Information Technology Professional Services and 132-56 (Health IT SIN) ",
          contracting_agency: "General Services Administration",        
          vehicle_type: 'Federal Supply Schedule',
          contract_num: "7(b) ZZZ TYI",         
          ceiling: 3350242442,
          base_period_start: '2016-05-03',
          base_period_end: '2016-05-03',
          option_period_start: '2016-05-03',
          option_period_end: '2016-05-03',
        }, {
          id: 8,
          vehicle: 'NBC IT-7489',
          vehicle_full_name: "GSA Schedule ZZZ",
          sins_or_subs:"SIN 132-51 - Information Technology Professional Services and 132-56 (Health IT SIN) ",
          contracting_agency: "General Services Administration",        
          vehicle_type: 'Federal Supply Schedule',
          contract_num: "7(b) ZZZ TYI",         
          ceiling: 125022442,
          base_period_start: '2016-05-03',
          base_period_end: '2016-05-03',
          option_period_start: '2016-05-03',
          option_period_end: '2016-05-03',
        }, {
          id:9, 
          vehicle: 'NBC IT-7489',
          vehicle_full_name: "GSA Schedule ZZZ",
          sins_or_subs:"SIN 132-51 - Information Technology Professional Services and 132-56 (Health IT SIN) ",
          contracting_agency: "General Services Administration",        
          vehicle_type: 'Federal Supply Schedule',
          contract_num: "7(b) ZZZ TYI",         
          ceiling: '$25,000,000,000.00',
          base_period_start: '2016-05-03',
          base_period_end: '2016-05-03',
          option_period_start: '2016-05-03',
          option_period_end: '2016-05-03',
         }, {
          id: 10, 
           vehicle: 'NBC IT-7489',
          vehicle_full_name: "GSA Schedule ZZZ",
          sins_or_subs:"SIN 132-51 - Information Technology Professional Services and 132-56 (Health IT SIN) ",
          contracting_agency: "General Services Administration",        
          vehicle_type: 'Federal Supply Schedule',
          contract_num: "7(b) ZZZ TYI",         
          ceiling: 125022442,
          base_period_start: '2016-05-03',
          base_period_end: '2016-05-03',
          option_period_start: '2016-05-03',
          option_period_end: '2016-05-03', 
        }
        ],
        search: '',
    };
  },
  methods: {
    ...mapMutations([
     
    ]),
    ...mapActions([
      "fetchContractProjects"
    ]),
  editMode(index, rows) {
    this.rowIndex = index,
     console.log(rows);
       console.log(this.createRow);
    this.rowId = rows.id
  },  
  saveEdits(index, rows){
    // Row edit action will occur here
  let updatedContractData = {
        contractData: {
          id: rows.id,
          id: 0,
          vehicle: rows.vehicle,
          vehicle_full_name: rows.vehicle_full_name,
          sins_or_subs: rows.sins_or_subs,
          contracting_agency: rows.contracting_agency,        
          vehicle_type: rows.vehicle_type,
          contract_num: rows.contract_num,         
          ceiling: rows.ceiling,
          base_period_start: rows.base_period_start,
          base_period_end: rows.base_period_start,
          option_period_start: rows.option_period_start,
          option_period_end: rows.option_period_end
      },
    };
    console.log(updatedContractData)
    // this.updateContractData({
    //   ...updatedContractData,
    // });   
    console.log(index, rows);
    this.rowIndex = null;
    this.rowId = null;
  }, 
  saveNewRow(index, rows){
    // Row create action will occur here
    //After save, dont forget to push new empty object to append new create row
      let newContractData = {
        contractData: {
          vehicle: rows.vehicle,
          vehicle_full_name: rows.vehicle_full_name,
          sins_or_subs: rows.sins_or_subs,
          contracting_agency: rows.contracting_agency,        
          vehicle_type: rows.vehicle_type,
          contract_num: rows.contract_num,         
          ceiling: rows.ceiling,
          base_period_start: rows.base_period_start,
          base_period_end: rows.base_period_start,
          option_period_start: rows.option_period_start,
          option_period_end: rows.option_period_end
      },
    };
    console.log(newContractData)
    // this.createContractData({
    //   ...newContractData,
    // }); 
    // this.tableData.push({})
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
    this.fetchContractProjects()
  },
  computed: {
    ...mapGetters([
     
    ]),   
    tableData(){
      if (this.vehicleArray && this.vehicleArray.length > 0){
        let data = this.vehicleArray
        data.push({})
        return data
     }
    },
    createRow(){
      let lastItem = this.tableData.length - 1
     console.log(lastItem)
    return lastItem

    },
  },
  watch: {
   
  
    
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