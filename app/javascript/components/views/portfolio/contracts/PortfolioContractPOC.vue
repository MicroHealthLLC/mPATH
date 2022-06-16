<template> 
 <div style="height:80vh" class="portfolio-contracts-module">
   <div  style="height: 100%; overflow-y:auto">
  <el-table
    :data="tableData"
    border
    height="800"
    >
    <el-table-column
      fixed
      label="Code"
      width=""
      prop="charge_code">
    </el-table-column>
    <el-table-column
      fixed
      label="Project Name"
      width="400"
      prop="name">
     </el-table-column>

     <el-table-column    
      label="Contract Program Manager POC"
      width="420"
      prop="pm_contract_poc_id">
     <template slot-scope="scope" >
  <span v-if=" _isallowed('write')">
   <el-popover
    placement="top-start"
    width="400"
    trigger="hover"
    >
   <p v-if="scope.row.pm_contract_poc_id && pocOptions.filter(t => t && t.name).find(t => t.id == scope.row.pm_contract_poc_id )"> 
   {{ pocOptions.filter(t => t && t.name).find(t => t.id == scope.row.pm_contract_poc_id ).name }} 
   </p>
   <p v-if="scope.row.pm_contract_poc_id && pocOptions.filter(t => t && t.email).find(t => t.id == scope.row.pm_contract_poc_id )"> 
     <small><b>Email:</b></small>
    {{ pocOptions.filter(t => t && t.email).find(t => t.id == scope.row.pm_contract_poc_id ).email }} </p>
   <p v-if="scope.row.pm_contract_poc_id && pocOptions.filter(t => t && t.work_number).find(t => t.id == scope.row.pm_contract_poc_id )"> 
       <small><b>Work Number:</b></small>
       {{ pocOptions.filter(t => t && t.work_number).find(t => t.id == scope.row.pm_contract_poc_id ).work_number }}</p>
   <p v-if="scope.row.pm_contract_poc_id && pocOptions.filter(t => t && t.mobile_number).find(t => t.id == scope.row.pm_contract_poc_id )"> 
      <small><b>Mobile Number:</b></small>
   {{  pocOptions.filter(t => t && t.mobile_number).find(t => t.id == scope.row.pm_contract_poc_id ).mobile_number}} 
   </p>
   
    <el-select
        v-model="scope.row.pm_contract_poc_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        slot="reference"
        default-first-option
        placeholder="Select Contract Program Manager POC"
      >
        <el-option
          v-for="item in pocOptions"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
       </el-popover>    
      </span>
      <span v-else>
    <el-popover
    placement="top-start"
    width="400"
    trigger="hover"
    >
    <p v-if="scope.row.pm_contract_poc_id && pocOptions.filter(t => t && t.name).find(t => t.id == scope.row.pm_contract_poc_id )"> 
    {{ pocOptions.filter(t => t && t.name).find(t => t.id == scope.row.pm_contract_poc_id ).name }} 
    </p>
    <p v-if="scope.row.pm_contract_poc_id && pocOptions.filter(t => t && t.email).find(t => t.id == scope.row.pm_contract_poc_id )"> 
      <small><b>Email:</b></small>
      {{ pocOptions.filter(t => t && t.email).find(t => t.id == scope.row.pm_contract_poc_id ).email }} </p>
    <p v-if="scope.row.pm_contract_poc_id && pocOptions.filter(t => t && t.work_number).find(t => t.id == scope.row.pm_contract_poc_id )"> 
        <small><b>Work Number:</b></small>
        {{ pocOptions.filter(t => t && t.work_number).find(t => t.id == scope.row.pm_contract_poc_id ).work_number }}</p>
    <p v-if="scope.row.pm_contract_poc_id && pocOptions.filter(t => t && t.mobile_number).find(t => t.id == scope.row.pm_contract_poc_id )"> 
        <small><b>Mobile Number:</b></small>
    {{  pocOptions.filter(t => t && t.mobile_number).find(t => t.id == scope.row.pm_contract_poc_id ).mobile_number}} 
    </p>
      <span 
      slot="reference"
      v-if="scope.row.pm_contract_poc_id && pocOptions.filter(t => t && t.name).find(t => t.id == scope.row.pm_contract_poc_id )"> 
      {{ pocOptions.filter(t => t && t.name).find(t => t.id == scope.row.pm_contract_poc_id ).name }} 
      </span>
      </el-popover>
      </span> 
      </template>
     </el-table-column>
    
    <el-table-column    
      label="Government COR POC/ Prime POC"
      width="420"
      prop="gov_contract_poc_id">
     <template slot-scope="scope" >
    <span v-if=" _isallowed('write')">
    <el-popover
    placement="top-start"
    width="400"
    trigger="hover"
    >
   <p v-if="scope.row.gov_contract_poc_id && pocOptions.filter(t => t && t.name).find(t => t.id == scope.row.gov_contract_poc_id )"> 
      {{ pocOptions.filter(t => t && t.name).find(t => t.id == scope.row.gov_contract_poc_id ).name }}
   </p>
   <p v-if="scope.row.gov_contract_poc_id && pocOptions.filter(t => t && t.email).find(t => t.id == scope.row.gov_contract_poc_id )">
      {{ pocOptions.filter(t => t && t.email).find(t => t.id == scope.row.gov_contract_poc_id ).email }} 
    </p>
    <p v-if="scope.row.gov_contract_poc_id && pocOptions.filter(t => t && t.work_number).find(t => t.id == scope.row.gov_contract_poc_id )">
     <small><b>Work Number:</b></small>
       {{ pocOptions.filter(t => t && t.work_number).find(t => t.id == scope.row.gov_contract_poc_id ).work_number }}
    </p>
  <p v-if="scope.row.gov_contract_poc_id && pocOptions.filter(t => t && t.mobile_number).find(t => t.id == scope.row.gov_contract_poc_id )"> 
        <small><b>Mobile Number:</b></small>
   {{  pocOptions.filter(t => t && t.mobile_number).find(t => t.id == scope.row.gov_contract_poc_id ).mobile_number}} 
   </p>
      
      
      <el-select
        v-model="scope.row.gov_contract_poc_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        slot="reference"
        default-first-option
        placeholder="Select Government COR POC or Prime POC"
      >
        <el-option
         v-for="item in pocOptions"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </el-popover> 
       </span>  
      <span v-else>
        <el-popover
        placement="top-start"
        width="400"
        trigger="hover"
        >
      <p v-if="scope.row.gov_contract_poc_id && pocOptions.filter(t => t && t.name).find(t => t.id == scope.row.gov_contract_poc_id )"> 
          {{ pocOptions.filter(t => t && t.name).find(t => t.id == scope.row.gov_contract_poc_id ).name }}
      </p>
        <p v-if="scope.row.gov_contract_poc_id && pocOptions.filter(t => t && t.email).find(t => t.id == scope.row.gov_contract_poc_id )">
        <small><b>Email:</b></small>
        {{ pocOptions.filter(t => t && t.email).find(t => t.id == scope.row.gov_contract_poc_id ).email }} 
       </p>
        <p v-if="scope.row.gov_contract_poc_id && pocOptions.filter(t => t && t.work_number).find(t => t.id == scope.row.gov_contract_poc_id )">
        <small><b>Work Number:</b></small>
          {{ pocOptions.filter(t => t && t.work_number).find(t => t.id == scope.row.gov_contract_poc_id ).work_number }}
        </p>
      <p v-if="scope.row.gov_contract_poc_id && pocOptions.filter(t => t && t.mobile_number).find(t => t.id == scope.row.gov_contract_poc_id )"> 
            <small><b>Mobile Number:</b></small>
      {{  pocOptions.filter(t => t && t.mobile_number).find(t => t.id == scope.row.gov_contract_poc_id ).mobile_number}} 
      </p>
          <span
           slot="reference"
           v-if="scope.row.gov_contract_poc_id && pocOptions.filter(t => t && t.name).find(t => t.id == scope.row.gov_contract_poc_id )"> 
            {{ pocOptions.filter(t => t && t.name).find(t => t.id == scope.row.gov_contract_poc_id ).name }}
        </span>
    </el-popover> 
      </span> 
      </template>
    </el-table-column>
   
     <el-table-column    
      label="Contract Office POC"
      width="420"
      prop="co_contract_poc_id">
     <template slot-scope="scope" >
      <span v-if=" _isallowed('write')">
    <el-popover
      placement="top-start"
      width="400"
      trigger="hover"
      >
       <p v-if="scope.row.co_contract_poc_id && pocOptions.filter(t => t && t.name).find(t => t.id == scope.row.co_contract_poc_id )"> 
      {{ pocOptions.filter(t => t && t.name).find(t => t.id == scope.row.co_contract_poc_id ).name }}
      </p>
    <p v-if="scope.row.co_contract_poc_id && pocOptions.filter(t => t && t.email).find(t => t.id == scope.row.co_contract_poc_id )">
         <small><b>Email:</b></small>
      {{ pocOptions.filter(t => t && t.email).find(t => t.id == scope.row.co_contract_poc_id ).email }} 
     </p> 
     <p v-if="scope.row.co_contract_poc_id && pocOptions.filter(t => t && t.work_number).find(t => t.id == scope.row.co_contract_poc_id )">
     <small><b>Work Number:</b></small>
       {{ pocOptions.filter(t => t && t.work_number).find(t => t.id == scope.row.co_contract_poc_id ).work_number }}
      </p>
       <p v-if="scope.row.co_contract_poc_id && pocOptions.filter(t => t && t.mobile_number).find(t => t.id == scope.row.co_contract_poc_id )"> 
        <small><b>Mobile Number:</b></small>
      {{  pocOptions.filter(t => t && t.mobile_number).find(t => t.id == scope.row.co_contract_poc_id ).mobile_number}} 
       </p>
       <el-select
        v-model="scope.row.co_contract_poc_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        slot="reference"
        default-first-option
        placeholder="Select Contracting Office POC"

      >
        <el-option
          v-for="item in pocOptions"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </el-popover> 
    </span>
      <span v-else>
      <el-popover
      placement="top-start"
      width="400"
      trigger="hover"
      >
       <p v-if="scope.row.co_contract_poc_id && pocOptions.filter(t => t && t.name).find(t => t.id == scope.row.co_contract_poc_id )"> 
      {{ pocOptions.filter(t => t && t.name).find(t => t.id == scope.row.co_contract_poc_id ).name }}
      </p> 
      <p v-if="scope.row.co_contract_poc_id && pocOptions.filter(t => t && t.email).find(t => t.id == scope.row.co_contract_poc_id )">
      <small><b>Email:</b></small>
      {{ pocOptions.filter(t => t && t.email).find(t => t.id == scope.row.co_contract_poc_id ).email }} 
     </p> 
    
     <p v-if="scope.row.co_contract_poc_id && pocOptions.filter(t => t && t.work_number).find(t => t.id == scope.row.co_contract_poc_id )">
     <small><b>Work Number:</b></small>
       {{ pocOptions.filter(t => t && t.work_number).find(t => t.id == scope.row.co_contract_poc_id ).work_number }}
      </p>
       <p v-if="scope.row.co_contract_poc_id && pocOptions.filter(t => t && t.mobile_number).find(t => t.id == scope.row.co_contract_poc_id )"> 
        <small><b>Mobile Number:</b></small>
      {{  pocOptions.filter(t => t && t.mobile_number).find(t => t.id == scope.row.co_contract_poc_id ).mobile_number}} 
       </p>
       <span 
        slot="reference"
       v-if="scope.row.co_contract_poc_id && pocOptions.filter(t => t && t.name).find(t => t.id == scope.row.co_contract_poc_id )"> 
      {{ pocOptions.filter(t => t && t.name).find(t => t.id == scope.row.co_contract_poc_id ).name }}
      </span>

      </el-popover>     
      </span> 
      </template>
     </el-table-column>

   <el-table-column
      label="Actions"
      v-if="_isallowed('write') || _isallowed('delete')"
      width="100"
      fixed="right"
      align="center">
   <template slot-scope="scope">
        <el-button
        type="default"
        @click="saveContractPOCs(scope.$index, scope.row)"
        v-if="(_isallowed('write'))"
        v-tooltip="`Save`" 
        class="bg-primary btn-sm text-light mx-0">               
        <i class="far fa-save"></i>
        </el-button>
      <!-- <el-button 
        type="default" 
        v-tooltip="`Cancel Edit`"       
        v-if="scope.$index == rowIndex"
        @click.prevent="cancelEdits(scope.$index, scope.row)"  
        class="bg-secondary btn-sm text-light mx-0">
      <i class="fas fa-ban"></i>
        </el-button> -->
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
        search: '',
    };
  },
  methods: {
  ...mapMutations([
    "SET_CONTRACT_PROJECT_STATUS"
  ]),
  ...mapActions([
    "updateContractProject",
    "fetchContractProjects",
    "fetchContractPOCs",
  ]),  
  log(e){
   console.log(e)
  },
  _isallowed(salut) {    
     return this.checkPortfolioContractPrivileges("PortfolioContracts", salut, this.$route, {settingType: 'Contracts'})
  }, 
  saveContractPOCs(index, row){
    this.rowIndex = null;
    this.rowId = null;
    let pm;
    let gov;
    let co;
    if (!row.pm_contract_poc_id){
      pm = ''
    } else pm = row.pm_contract_poc_id
    
    if (!row.gov_contract_poc_id){
      gov = ''
    } else gov = row.gov_contract_poc_id
    
    if (!row.co_contract_poc_id || row.co_contract_poc_id == ''){
      co = ''
    } else co = row.co_contract_poc_id

    let contractProjectData = {
          cProjectData: {
            pm_poc_id: pm,
            gov_poc_id: gov,
            co_poc_id: co,        
        },
      };
      let id = row.id
       console.log(row)
      console.log("pm: ", pm)
            console.log("gov: ", gov)
          console.log("co: ", co)
      this.updateContractProject({...contractProjectData, id})    
  },
  backHomeBtn() {
      window.location.pathname = "/";
    },    
  editMode(index, rows) {
    
    this.rowIndex = index,
     console.log(this.pocOptions);
      console.log(this.tableData);
    this.rowId = rows.id
  },  
  saveEdits(){
   // Row edit action will occur here
    this.rowIndex = null;
    this.rowId = null;
  }, 
  cancelEdits(index, rows) {
    this.rowIndex = null;
    this.rowId = null;
  },    
  },
  mounted() {
    this.fetchContractPOCs()
  },
  computed: {
    ...mapGetters([
     "contractProjects",
     "contractPOCs"
    ]), 
  tableData(){
    if (this.contractProjects && this.contractProjects.length > 0){
      let validProjects = this.contractProjects.filter(t => t && t.id)
       return validProjects
     }      
    }, 
  pocOptions(){
     if (this.contractPOCs && this.contractPOCs.length > 0){
        return this.contractPOCs.map(t => t).filter(pocs => pocs && pocs.id && pocs.name !== null )
      }
    },
     pocOption(){
     if (this.contractPOCs && this.contractPOCs.length > 0){
        return this.contractPOCs.map(t => t)
      }
     },
  },
  watch: {
   contractProjectStatus: {
      handler() {
        if (this.contractProjectStatus == 200) {
          this.$message({
            message: `Contract POCs saved successfully.`,
            type: "success",
            showClose: true,
          });
          this.SET_CONTRACT_PROJECT_STATUS(0);
          this.fetchContractProjects();
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
    th {
      color: #383838;
    }
  }    
</style>