<template>
   <div style="height:80vh" class="portfolio-contracts-module">
      <div  style="height: 100%; overflow-y:auto">
     <el-table
    :data="tableData.filter(data => !search || data.name.toLowerCase().includes(search.toLowerCase()))"
    border
    height="800"
    style="width: 95%">
    <el-table-column
      fixed
      label="Code"
      width="55"
      prop="charge_code">
    </el-table-column>
    <el-table-column
      fixed
      label="Project Name"
      width="200"
      prop="project_name">
      <template slot-scope="scope">
        <el-input
          size="small"
          v-if="scope.$index == createRow"
          placeholder="Enter Project Name"
          style="text-align:center"
          v-model="scope.row.project_name"
          controls-position="right"
        ></el-input>
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
        <el-input
          size="small"
          placeholder="Enter Project Name"
          style="text-align:center"
          v-model="scope.row.project_name"
          controls-position="right"
          ></el-input>
        </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
        {{ scope.row.project_name }} 
        </span>
        </template>
     </el-table-column>
     <el-table-column
    
      label="Customer"
      width="200"
      prop="customer_name">
     <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.customer_name"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder="Select or enter Customer Name"

      >
        <el-option
          v-for="item in customerOptions"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.customer_name }}
      </span>
      </template>
    </el-table-column>
   
  
     <el-table-column
      label="Contract Start Date"
      width="100"
      prop="contract_start_date">
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
      {{ scope.row.contract_start_date }}
      </span>
     </template>
    </el-table-column>
     <el-table-column
      label="Contract End Date"
      width="100"
      prop="contract_end_date">
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
      {{ scope.row.contract_end_date }}
      </span>
     </template>
    </el-table-column>
     <el-table-column
      label="Total Contract Value"
       width="115"
      prop="total_contract_val">
     <template slot-scope="scope">
     <el-input
      size="small"
      v-if="scope.$index == createRow"
      type="number"
      placeholder="Enter Total Contract Value"
      style="text-align:center"
      v-model="scope.row.total_contract_val"
      controls-position="right"
      ></el-input>
      <span v-if="rowId == scope.row.id && scope.$index !== createRow">
     <el-input
      size="small"      
      type="number"
      placeholder="Enter Total Contract Value"
      style="text-align:center"
      v-model="scope.row.total_contract_val"
      controls-position="right"
      ></el-input>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.total_contract_val }}
      </span>
    </template>

    </el-table-column>
    <el-table-column
      label="Total Funded Value"
       width="115"
      prop="total_funded_val">
     <template slot-scope="scope">
     <el-input
      size="small"
      v-if="scope.$index == createRow"
      type="number"
      placeholder="Enter Total Funded Value"
      style="text-align:center"
      v-model="scope.row.total_funded_val"
      controls-position="right"
      ></el-input>
      <span v-if="rowId == scope.row.id && scope.$index !== createRow">
     <el-input
      size="small"      
      type="number"
      placeholder="Enter Total Funded Value"
      style="text-align:center"
      v-model="scope.row.total_funded_val"
      controls-position="right"
      ></el-input>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.total_funded_val }}
      </span>
    </template>

    </el-table-column>
  
     <el-table-column
      label="Billings to Date"
       width="115"
      prop="billings_to_date">
     <template slot-scope="scope">
     <el-input
      size="small"
      v-if="scope.$index == createRow"
      type="number"
      placeholder="Enter Billings to Date"
      style="text-align:center"
      v-model="scope.row.billings_to_date"
      controls-position="right"
      ></el-input>
      <span v-if="rowId == scope.row.id && scope.$index !== createRow">
     <el-input
      size="small"      
      type="number"
      placeholder="Enter Billings to Date"
      style="text-align:center"
      v-model="scope.row.billings_to_date"
      controls-position="right"
      ></el-input>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.billings_to_date }}
      </span>
    </template>
    </el-table-column>   
     <el-table-column
      label="%Completed"
       width="115"
      >
      <template slot-scope="scope">
     <span v-if="scope.$index !== createRow">
      {{Math.trunc(scope.row.billings_to_date / scope.row.total_contract_val)}}%
     </span>
      </template>
    </el-table-column>
    <el-table-column
      label="Funded Remaining"
       width="115"
      >
       <template slot-scope="scope">
        <span v-if="scope.$index !== createRow">
         {{ (scope.row.total_funded_val - scope.row.billings_to_date).toFixed(2) }}
        </span>     
       </template>       
    </el-table-column>
    <el-table-column
      label="Total Backlog (Sum of A & B)"
       width="115"
      >
     <template slot-scope="scope">
      <span v-if="scope.$index !== createRow">
      {{ (scope.row.total_contract_val - scope.row.billings_to_date).toFixed(2) }}
      </span>
       </template>

    </el-table-column>
     <el-table-column
      label="Notes/Questions"
       width="300"
      >
    </el-table-column>
    <el-table-column
      label="Actions"
      width="95"
      fixed="right"
      align="center">
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
import { mapGetters, mapMutations, mapActions } from "vuex";

export default {
  name: "PortfolioContractBacklog",
  components: {
  
  },

    data() {    
      return {
        nothing: true,
        rowIndex: null, 
        rowId: null, 
        tabPosition: 'bottom',
         awardToNums: [ 
                       'VAT4NG-012-003', 
                       '140D0418F0001',
                       'HQMMMBCKG0',
                       'DIA-008-002'
                       ],
       primeOrSub: [ 
                      'Prime', 
                       'Sub',
                         ],                     
       contractNumber:   [ 
                      'GS35F413BA ', 
                      '47QRAA-18-D-0098',
                      'N0017819D8115',
                      'HHSM-500-2017-00038I',
                      'W911QY-18-D-0109'
                        ],
        vehicleOptions: [ 
                       'NA', 
                       'GSA IT-70',
                       'GSA PSS MOBIS',
                       'VETS II',
                       'CIOSP3-8a'
                       ],
        customerOptions: [ 
                       'Favor TechConsulting, LLC', 
                       'Security & Exchange Commission',
                       'Accolade, Inc.',
                       'Department of Energy',
                       'American Systems',
                       'Health & Human Services'
                       ],
        naicsOptions: [ 
                       'NA', 
                       '541611-$16.5M',
                       '541512-$30M',
                       '541512',
                       '519190'
                       ],
        awardTypes:   [ 
                      'NA', 
                      'SDVOSB',
                      'SBA 8a',
                       ],
        pops:          [ 
                      'Base Period',
                      'Base + 2 OYs',
                      'Base + 4 OYs', 
                      'Yearly',
                      '6 mo Base + 1 OY',
                      '9 mo BP + 1 OY',
                       ],

       currentPops:   [ 
                      'Base',
                      'OY1',
                      'OY2',
                      'OY3',
                      'OY4',
                      'Year1',
                      'Year2',
                      'Year3',
                        ],
       contractTypes:  [ 
                      'FFP/FFPU',
                      'FFP', 
                      'T&M',
                       ],
        contractsArray: [{
          id:0,
          charge_code: '1053',
          customer_name: 'Favor TechConsulting, LLC',
          project_name: 'FTC HPS Admin',         
          vehicle: 'NA',
          contract_num:'2017-006-T4NG-SC',
          award_to_num: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 734365.35,
          total_funded_val: 7999430.32,
          total_contract_val: 7999430.32,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:1,
          charge_code: '1062',
          customer_name: 'Interagency Program Office',
          project_name: 'IPO Data Gap',
          vehicle: 'GSA IT-70',
          contract_num:'GS-35F-413BA',
          award_to_num: '140D0418F0001',
          naics: '541512-$30M',
          award_type: 'SDVOSB',
          contract_type: 'F&M',
          prime_or_sub: 'Prime',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 58740.30,
          total_funded_val: 3790169.51,
          total_contract_val: 22888267.36,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:2,
          charge_code: '1079',
          project_name: '3M SEDTS 3',
          customer_name: '3M',
          vehicle: 'NA',
          contract_num:'NA',
          award_to_num: 'HQMMMBCKG0',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Prime',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 467434.03,
          total_funded_val: 15645643.23,
          total_contract_val: 256423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:3,
          charge_code: '1090',
          project_name: 'FTC DIA TO8',
          vehicle: 'NA',
          customer_name: 'Security & Exchange Commission',
          contract_num:'2017-006-T4NG-SC',
          award_to_num: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 2423434.03,
          total_funded_val: 5645643.23,
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:4,
          charge_code: '1053',
          project_name: 'FTC HPS Admin',
          vehicle: 'GSA PSS MOBIS',
          contract_num:'2017-006-T4NG-SC',
          customer_name: '3M',
          award_to_num: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 2423434.03,
          total_funded_val: 5645643.23,
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:5,
          charge_code: '1053',
          project_name: 'FTC HPS Admin',          
          customer_name: '3M',
          vehicle: 'GSA PSS MOBIS',
          contract_num:'2017-006-T4NG-SC',
          award_to_num: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 2423434.03,
          total_funded_val: 5645643.23,
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:6,
          charge_code: '1053',
          project_name: 'FTC HPS Admin',
          customer_name: 'Favor TechConsulting, LLC',
          vehicle: 'NA',
          contract_num:'2017-006-T4NG-SC',
          award_to_num: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 2423434.03,
          total_funded_val: 5645643.23,
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:7,
          charge_code: '1053',
          project_name: 'FTC HPS Admin',
          vehicle: 'NA',
          customer_name: 'Favor TechConsulting, LLC',
          contract_num:'2017-006-T4NG-SC',
          award_to_num: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 2423434.03,
          total_funded_val: 5645643.23,
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:8,
          charge_code: '1053',
          project_name: 'FTC HPS Admin',
          vehicle: 'NA',
          contract_num:'2017-006-T4NG-SC',
          customer_name: 'Favor TechConsulting, LLC',
          award_to_num: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 2423434.03,
          total_funded_val: 5645643.23,
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:9,
          charge_code: '1053',
          project_name: 'FTC HPS Admin',
          customer_name: 'Favor TechConsulting, LLC',
          vehicle: 'NA',
          contract_num:'2017-006-T4NG-SC',
          award_to_num: 'VAT4NG-012-003',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 2423434.03,
          total_funded_val: 5645643.23,
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022',
        }, {
          id:10,
          charge_code: '4002',
          project_name: 'DoS PHIMS Task Order 2',
          vehicle: 'NA',
          contract_num:'19AQMM19D0147',
          award_to_num: '19AQMM21F3765',
          customer_name: 'Department of State',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 2423434.03,
          total_funded_val: 5645643.23,
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022', 
        }, {
          id:11,
           charge_code: '4004',
          project_name: 'DoS PHIMS Task Order 4',
          vehicle: 'NA',
          contract_num:'19AQMM19D0147',
          award_to_num: '19AQMM21F3765',
          customer_name: 'Department of State',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 2423434.03,
          total_funded_val: 5645643.23,
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022', 
        }, {
          id:12,
         charge_code: '4005',
          project_name: 'DoS PHIMS Task Order 5',
          vehicle: 'NA',
          contract_num:'19AQMM19D0147',
          award_to_num: '19AQMM21F3765',
          customer_name: 'Department of State',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 2423434.03,
          total_funded_val: 5645643.23,
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022', 
        }, {
          id:13,
          charge_code: '4006',
          project_name: 'DoS PHIMS Task Order 6',
          vehicle: 'NA',
          contract_num:'19AQMM19D0147',
          award_to_num: '19AQMM21F3765',
          customer_name: 'Department of State',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 2423434.03,
          total_funded_val: 5645643.23,
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022', 
        }, {
          id:14,
          charge_code: '4007',
          project_name: 'DoS PHIMS Task Order 7',
          vehicle: 'NA',
          contract_num:'19AQMM19D0147',
          award_to_num: '19AQMM21F3765',
          customer_name: 'Department of State',
          naics: 'NA',
          award_type: 'NA',
          contract_type: 'FFP',
          prime_or_sub: 'Sub',
          contract_start_date: '6/19/2021',
          contract_end_date: '8/27/2022',
          billings_to_date: 2423434.03,
          total_funded_val: 5645643.23,
          total_contract_val: 2423434.03,
          pops: 'Base + 4 OYs',
          current_pop: 'OY4 extension',
          current_pop_start_date: '1/19/2022',
          current_pop_end_date: '8/27/2022', 
        }],
        search: '',
    };
  },
  methods: {
    ...mapMutations([
     
    ]),
    ...mapActions([
      
    ]),  
  backHomeBtn() {
      window.location.pathname = "/";
    },
 editMode(index, rows) {
    this.rowIndex = index,
     console.log(rows);
       console.log(this.createRow);
    this.rowId = rows.id
  },  
  saveEdits(){
    // Row edit action will occur here
    this.rowIndex = null;
    this.rowId = null;
  }, 
  saveNewRow(){
    // Row create action will occur here
    //After save, dont forget to push new empty object to append new create row
    this.rowIndex = null;
    this.rowId = null;
  },
  cancelEdits(index, rows) {
    this.rowIndex = null;
    this.rowId = null;
       
  },    
  handleEdit(index, row) {
        console.log(index, row);
      },
  handleDelete(index, row) {
    console.log(index, row);
  }
  },
  mounted() {
    
  },
  computed: {
    ...mapGetters([
     
    ]),   
   tableData(){
      if (this.contractsArray && this.contractsArray.length > 0){
        let data = this.contractsArray
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
    th {
      color: #383838;
    }
  }    
</style>