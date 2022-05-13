<template> 
 <div style="height:80vh" class="portfolio-contracts-module">
   <div  style="height: 100%; overflow-y:auto">
  <el-table
    :data="tableData.filter(data => !search || data.name.toLowerCase().includes(search.toLowerCase()))"
    border
    height="800"
    >
    <el-table-column
      fixed
      label="Code"
      width="55"
      prop="charge_code">
    </el-table-column>
    <el-table-column
      fixed
      label="Project Name"
      width="400"
      prop="project_name">
     </el-table-column>
       <el-table-column    
      label="Contract Program Manager POC"
      width="420"
      prop="contract_pm_poc">
     <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.contract_pm_poc"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder="Select or enter Contract Program Manager POC"
      >
        <el-option
          v-for="item in contractPM"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.contract_pm_poc }}
      </span>
      </template>
    </el-table-column>
     <el-table-column    
      label="Government COR POC/ Prime POC"
      width="420"
      prop="government_poc">
     <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.government_poc"
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
          v-for="item in govCorPoC"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.government_poc }}
      </span>
      </template>
    </el-table-column>
   
     <el-table-column    
      label="Contract Office POC"
      width="420"
      prop="contract_office_poc">
     <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.contract_office_poc"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        placeholder="Select or enter Contracting Office POC"

      >
        <el-option
          v-for="item in contractingOfficePoc"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.contract_office_poc }}
      </span>
      </template>
    </el-table-column>
   <el-table-column
      label="Actions"
      width="100"
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
  name: "PortfolioContractPOC",
  components: {
  
  },

    data() {    
      return {
        nothing: true,
        rowIndex: null, 
        rowId: null, 
        tabPosition: 'bottom',
        contractPM:          [ 
                      'Michael Holmes',
                      'Monica Lee',
                      'Gloria Walker', 
                      'Justin Spears',            
                       ],
        govCorPoC:     [ 
                      'Rishan Chandarana',
                      'Michael Zrimm',
                      'Andrew Lee',
                      'Matthew Terrill',
                      'Aaron Taylor'                
                        ],
       contractingOfficePoc:  [ 
                      'FTC Contracting',
                      'DOI', 
                      'Mary Hogoboom',
                       ],
        tableData: [{
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
          contract_pm_poc: 'Michael Holmes',
          government_poc:  'Andrew Lee',
          contract_office_poc: 'FTC Contracting',
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
          contract_pm_poc: 'Michael Holmes',
          government_poc:  'Andrew Lee',
          contract_office_poc: 'FTC Contracting',
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
          contract_pm_poc: 'Michael Holmes',
          government_poc:  'Andrew Lee',
          contract_office_poc: 'FTC Contracting',
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
          contract_pm_poc: 'Michael Holmes',
          government_poc:  'Andrew Lee',
          contract_office_poc: 'FTC Contracting',
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
          contract_pm_poc: 'Michael Holmes',
          government_poc:  'Andrew Lee',
          contract_office_poc: 'FTC Contracting',
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
          contract_pm_poc: 'Michael Holmes',
          government_poc:  'Andrew Lee',
          contract_office_poc: 'FTC Contracting',
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
          contract_pm_poc: 'Michael Holmes',
          government_poc:  'Andrew Lee',
          contract_office_poc: 'FTC Contracting',
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
          contract_pm_poc: 'Michael Holmes',
          government_poc:  'Andrew Lee',
          contract_office_poc: 'FTC Contracting',
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
          contract_pm_poc: 'Michael Holmes',
          government_poc:  'Andrew Lee',
          contract_office_poc: 'FTC Contracting',
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
          contract_pm_poc: 'Michael Holmes',
          government_poc:  'Andrew Lee',
          contract_office_poc: 'FTC Contracting',
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
  },
  mounted() {
    
  },
  computed: {
    ...mapGetters([
     
    ]),  
  // tableData(){
  //     if (this.pocArray && this.pocArray.length > 0){
  //       let data = this.pocArray
  //       data.push({})
  //       return data
  //    }
  //   },
  //   createRow(){
  //     let lastItem = this.tableData.length - 1
  //      console.log(lastItem)
  //     return lastItem

  //   }, 
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