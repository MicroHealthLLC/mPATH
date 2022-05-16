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
     <span v-if="rowId == scope.row.id">
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
      <span v-else>
      {{ scope.row.contract_pm_poc }}
      </span>
      </template>
     </el-table-column>
    
    <el-table-column    
      label="Government COR POC/ Prime POC"
      width="420"
      prop="government_poc">
     <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id">
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
      <span v-else>
      {{ scope.row.government_poc }}
      </span>
      </template>
    </el-table-column>
   
     <el-table-column    
      label="Contract Office POC"
      width="420"
      prop="contract_office_poc">
     <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id">
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
      <span v-else>
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
           v-if="scope.$index !== rowIndex"
          @click="editMode(scope.$index, scope.row)"><i class="fal fa-edit text-primary"></i>
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
          charge_code: '422',
          project_name: 'Comptroller Msd',
          contract_pm_poc: 'Michael Holmes',
          government_poc:  'Andrew Lee',
          contract_office_poc: 'FTC Contracting',
        }, {
          id:2,
          charge_code: '422',
          project_name: 'Admin Acme Co',
          contract_pm_poc: 'Michael Holmes',
          government_poc:  'Andrew Lee',
          contract_office_poc: 'FTC Contracting',
        }, {
          id:3,
          charge_code: '422',
          project_name: 'How They M',
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