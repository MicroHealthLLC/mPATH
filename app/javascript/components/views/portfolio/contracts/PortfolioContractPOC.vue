<template> 
 <div>
 <el-tabs type="border-card" @tab-click="handleClick">
  <el-tab-pane class="px-3"  style="postion:relative" label="CONTRACTS" >      
    <div style="height:72vh; overflow-y:auto" class="portfolio-contracts-module" >
      <el-table
        :data="tableData"
        border
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
          prop="pm_contract_poc_ids">
        <template slot-scope="scope" >
          <span v-if="isEditing && _isallowed('write') && rowIndex == scope.$index">
      <el-popover
        placement="top-start"
        width="400"
        v-if="pocOptions"
        trigger="hover"
        >
        <p v-if="scope.row.pm_contract_poc_ids"> 
          {{ scope.row.pm_contract_poc_ids.map(t => t.name).join(',') }} 
      </p>
      
         <el-select        
            v-model="scope.row.pm_contract_poc_ids"       
            :load="log(scope.row.pm_contract_poc_ids)"
            filterable       
            multiple  
            track-by="id"        
            value-key="id"        
            class="w-100"
            slot="reference"
            default-first-option
            placeholder="Select Contract Program Manager POC"
            size="small"
          >
          <el-option
            v-for="item in pocOptions"
            :key="item.id"
            :label="item.name"
            :value="item"
          >
          </el-option>
          </el-select>
          </el-popover>    
          </span>
          <span v-else>
        <el-popover
        placement="top-start"
        width="400"
        v-if="pocOptions"
        trigger="hover"
        >
        <div class="row" v-if="scope.row.pm_contract_poc_ids">
          <div class="col" v-for="poc, i in scope.row.pm_contract_poc_ids" :key="i">
           <p><b>{{poc.name}}</b></p> 
           <p><small class="d-block"><b>Email:</b></small> 
            {{poc.email}}
          </p> 
           <p><small class="d-block"><b>Mobile Number:</b></small>            
            {{poc.mobile_number}}
          </p> 
          <p><small  class="d-block"><b>Work Number:</b></small>    
            {{poc.work_number}}
          </p>  
          </div>
        </div>
          <span 
          slot="reference"
          v-if="scope.row.pm_contract_poc_ids"> 
          {{ scope.row.pm_contract_poc_ids.map(t => t.name).join(',  ') }} 
          </span>
          </el-popover>
          </span> 
          </template>
        </el-table-column>
        
        <el-table-column    
          label="Government COR POC/ Prime POC"
          width="420"
          prop="gov_contract_poc_ids">
        <template slot-scope="scope" >
        <span v-if="isEditing && _isallowed('write') && rowIndex == scope.$index">
        <el-popover
        placement="top-start"
        v-if="pocOptions"
        width="400"
        trigger="hover"
        >
        <p v-if="scope.row.gov_contract_poc_ids"> 
          {{ scope.row.gov_contract_poc_ids.map(t => t.name).join(',') }} 
       </p>  
          
         <el-select
            v-model="scope.row.gov_contract_poc_ids"       
            :load="log(scope.row.gov_contract_poc_ids)"
            filterable       
            multiple  
            track-by="id"        
            value-key="id"        
            class="w-100"
            slot="reference"
            default-first-option
            placeholder="Select Government COR/PRIME  POC"
            size="small"
          >
          <el-option
            v-for="item in pocOptions"
            :key="item.id"
            :label="item.name"
            :value="item"
          >
          </el-option>
          </el-select>
          </el-popover> 
          </span>  
          <span v-else>
          <el-popover
            placement="top-start"
            width="400"
            v-if="pocOptions"
            trigger="hover"
            >
          <div class="row" v-if="scope.row.gov_contract_poc_ids">
          <div class="col" v-for="poc, i in scope.row.gov_contract_poc_ids" :key="i">
           <p><b>{{poc.name}}</b></p> 
           <p><small class="d-block"><b>Email:</b></small> 
            {{poc.email}}
          </p> 
           <p><small class="d-block"><b>Mobile Number:</b></small>            
            {{poc.mobile_number}}
          </p> 
          <p><small  class="d-block"><b>Work Number:</b></small>    
            {{poc.work_number}}
          </p>  
          </div>
        </div>
          <span 
          slot="reference"
          v-if="scope.row.gov_contract_poc_ids"> 
          {{ scope.row.gov_contract_poc_ids.map(t => t.name).join(',  ') }} 
          </span>
          </el-popover>
          </span> 
          </template>
        </el-table-column>
      
        <el-table-column    
          label="Contract Office POC"
          width="420"
          prop="co_contract_poc_ids">
        <template slot-scope="scope" >
        <span v-if="isEditing && _isallowed('write') && rowIndex == scope.$index">
        <el-popover
          placement="top-start"
          width="400"
          v-if="pocOptions"
          trigger="hover"
          >
          <p v-if="scope.row.pm_contract_poc_ids"> 
          {{ scope.row.pm_contract_poc_ids.map(t => t.name).join(',') }} 
          </p>    
          <el-select
            v-model="scope.row.co_contract_poc_ids"       
            :load="log(scope.row.co_contract_poc_ids)"
            filterable       
            multiple  
            track-by="id"        
            value-key="id"        
            class="w-100"
            slot="reference"
            default-first-option
            placeholder="Select Contract Office POC"
            size="small"
          >
          <el-option
            v-for="item in pocOptions"
            :key="item.id"
            :label="item.name"
            :value="item"
          >
          </el-option>
          </el-select>
          </el-popover> 
        </span>
          <span v-else>
          <el-popover
          placement="top-start"
          width="400"
          v-if="pocOptions"
          trigger="hover"
          >
          <div class="row" v-if="scope.row.co_contract_poc_ids">
          <div class="col" v-for="poc, i in scope.row.co_contract_poc_ids" :key="i">
           <p><b>{{poc.name}}</b></p> 
           <p><small class="d-block"><b>Email:</b></small> 
            {{poc.email}}
          </p> 
           <p><small class="d-block"><b>Mobile Number:</b></small>            
            {{poc.mobile_number}}
          </p> 
          <p><small  class="d-block"><b>Work Number:</b></small>    
            {{poc.work_number}}
          </p>  
          </div>
        </div>
          <span 
          slot="reference"
          v-if="scope.row.co_contract_poc_ids"> 
          {{ scope.row.co_contract_poc_ids.map(t => t.name).join(',  ') }} 
          </span>
          </el-popover>     
          </span> 
          </template>
        </el-table-column>

      <el-table-column
          label="Actions"
          v-if="_isallowed('write')"
          width="100"
          fixed="right"
          align="center">
      <template slot-scope="scope">
            <el-button
            size="mini"
            type="default"
            @click="saveContractPOCs(scope.$index, scope.row)"
            v-if="scope.$index == rowIndex"
            v-tooltip="`Save`" 
            class="bg-primary text-light px-2">               
            <i class="far fa-save"></i>
            </el-button>
          <el-button 
            type="default" 
            size="mini"
            v-tooltip="`Cancel Edit`"       
            v-if="scope.$index == rowIndex"
            @click.prevent="cancelEdits(scope.$index, scope.row)"  
            class="bg-secondary text-light px-2">
          <i class="fas fa-ban"></i>
            </el-button>
              <el-button
              size="mini"
              type="default"
              v-tooltip="`Edit`" 
              class="bg-light px-2"
              v-if="scope.$index !== rowIndex && (_isallowed('write'))"
              @click="editMode(scope.$index, scope.row)"><i class="fal fa-edit text-primary"></i>
              </el-button> 
            </template>

        </el-table-column>
      </el-table>       
    </div>
  </el-tab-pane>
  <el-tab-pane class="px-3"  style="postion:relative" label="VEHICLES">
    <div style="height:72vh; overflow-y:auto" class="portfolio-contracts-module" >  
      <el-table
        :data="vehicleTableData"
        border
        >       
        <el-table-column
          fixed
          label="Vehicle Nickname"
          width="400"
          prop="name">
        </el-table-column>

        <el-table-column    
          label="Contract Program Manager POC"
          width="420"
          prop="pm_contract_poc_ids">
        <template slot-scope="scope" >
          <span v-if="v_isEditing && _isallowed('write') && v_rowIndex == scope.$index">
        <el-popover
          placement="top-start"
          width="400"
          v-if="pocOptions"
          trigger="hover"
          >
          <p v-if="scope.row.pm_contract_poc_ids"> 
            {{ scope.row.pm_contract_poc_ids.map(t => t.name).join(',') }} 
        </p>
        
          <el-select
            v-model="scope.row.pm_contract_poc_ids"
            :load="log(scope.row.pm_contract_poc_ids)"
            filterable       
            multiple  
            track-by="id"        
            value-key="id"        
            class="w-100"
            slot="reference"
            default-first-option
            placeholder="Select Contract Program Manager POC"
            size="small"
          >
          <el-option
            v-for="item in pocOptions"
            :key="item.id"
            :label="item.name"
            :value="item"
          >
          </el-option>
          </el-select>
          </el-popover>    
          </span>
          <span v-else>
          <el-popover
          placement="top-start"
          width="400"
          v-if="pocOptions"
          trigger="hover"
          >
         <div class="row" v-if="scope.row.pm_contract_poc_ids">
          <div class="col" v-for="poc, i in scope.row.pm_contract_poc_ids" :key="i">
           <p><b>{{poc.name}}</b></p> 
           <p><small class="d-block"><b>Email:</b></small> 
            {{poc.email}}
          </p> 
           <p><small class="d-block"><b>Mobile Number:</b></small>            
            {{poc.mobile_number}}
          </p> 
          <p><small  class="d-block"><b>Work Number:</b></small>    
            {{poc.work_number}}
          </p>  
          </div>
        </div>
          <span 
          slot="reference"
          v-if="scope.row.pm_contract_poc_ids"> 
          {{ scope.row.pm_contract_poc_ids.map(t => t.name).join(',  ') }} 
          </span>
          </el-popover>
          </span> 
          </template>
        </el-table-column>
        
        <el-table-column    
          label="Government COR POC/ Prime POC"
          width="420"
          prop="gov_contract_poc_ids">
        <template slot-scope="scope" >
        <span v-if="v_isEditing && _isallowed('write') && v_rowIndex == scope.$index">
        <el-popover
        placement="top-start"
        v-if="pocOptions"
        width="400"
        trigger="hover"
        >
        <p v-if="scope.row.gov_contract_poc_ids"> 
          {{ scope.row.gov_contract_poc_ids.map(t => t.name).join(',') }} 
       </p>          
         <el-select
            v-model="scope.row.gov_contract_poc_ids"       
            :load="log(scope.row.gov_contract_poc_ids)"
            filterable       
            multiple  
            track-by="id"        
            value-key="id"        
            class="w-100"
            slot="reference"
            default-first-option
            placeholder="Select Government COR/PRIME  POC"
            size="small"
          >
          <el-option
            v-for="item in pocOptions"
            :key="item.id"
            :label="item.name"
            :value="item"
          >
          </el-option>
          </el-select>
          </el-popover> 
          </span>  
          <span v-else>
          <el-popover
            placement="top-start"
            width="400"
            v-if="pocOptions"
            trigger="hover"
            >
          <div class="row" v-if="scope.row.gov_contract_poc_ids">
          <div class="col" v-for="poc, i in scope.row.gov_contract_poc_ids" :key="i">
           <p><b>{{poc.name}}</b></p> 
           <p><small class="d-block"><b>Email:</b></small> 
            {{poc.email}}
          </p> 
           <p><small class="d-block"><b>Mobile Number:</b></small>            
            {{poc.mobile_number}}
          </p> 
          <p><small  class="d-block"><b>Work Number:</b></small>    
            {{poc.work_number}}
          </p>  
          </div>
        </div>
          <span 
          slot="reference"
          v-if="scope.row.gov_contract_poc_ids"> 
          {{ scope.row.gov_contract_poc_ids.map(t => t.name).join(',  ') }} 
          </span>
          </el-popover>
          </span> 
          </template>
        </el-table-column>
      
        <el-table-column    
          label="Contract Office POC"
          width="420"
          prop="co_contract_poc_ids">
        <template slot-scope="scope" >
        <span v-if="v_isEditing && _isallowed('write') && v_rowIndex == scope.$index">
        <el-popover
          placement="top-start"
          width="400"
          v-if="pocOptions"
          trigger="hover"
          >
          <p v-if="scope.row.pm_contract_poc_ids"> 
          {{ scope.row.pm_contract_poc_ids.map(t => t.name).join(',') }} 
          </p>         
          <el-select
            v-model="scope.row.co_contract_poc_ids"       
            :load="log(scope.row.co_contract_poc_ids)"
            filterable       
            multiple  
            track-by="id"        
            value-key="id"        
            class="w-100"
            slot="reference"
            default-first-option
            placeholder="Select Contract Office POC"
            size="small"
          >
          <el-option
            v-for="item in pocOptions"
            :key="item.id"
            :label="item.name"
            :value="item"
          >
          </el-option>
          </el-select>
          </el-popover> 
        </span>
          <span v-else>
          <el-popover
          placement="top-start"
          width="400"
          v-if="pocOptions"
          trigger="hover"
          >
          <div class="row" v-if="scope.row.co_contract_poc_ids">
          <div class="col" v-for="poc, i in scope.row.co_contract_poc_ids" :key="i">
           <p><b>{{poc.name}}</b></p> 
           <p><small class="d-block"><b>Email:</b></small> 
            {{poc.email}}
          </p> 
           <p><small class="d-block"><b>Mobile Number:</b></small>            
            {{poc.mobile_number}}
          </p> 
          <p><small  class="d-block"><b>Work Number:</b></small>    
            {{poc.work_number}}
          </p>  
          </div>
        </div>
          <span 
          slot="reference"
          v-if="scope.row.co_contract_poc_ids"> 
          {{ scope.row.co_contract_poc_ids.map(t => t.name).join(',  ') }} 
          </span>
          </el-popover>     
          </span> 
          </template>
        </el-table-column>

      <el-table-column
          label="Actions"
          v-if="_isallowed('write')"
          width="100"
          fixed="right"
          align="center">
         <template slot-scope="scope">
            <el-button
            size="mini"
            type="default"
            @click="saveVehiclePOCs(scope.$index, scope.row)"
            v-if="scope.$index == v_rowIndex"
            v-tooltip="`Save`" 
            class="bg-primary text-light px-2">               
            <i class="far fa-save"></i>
            </el-button>
          <el-button 
           size="mini"
            type="default" 
            v-tooltip="`Cancel Edit`"       
            v-if="scope.$index == v_rowIndex"
            @click.prevent="v_cancelEdits(scope.$index, scope.row)"  
            class="bg-secondary text-light px-2">
          <i class="fas fa-ban"></i>
            </el-button>
              <el-button
              size="mini"
              type="default"
              v-tooltip="`Edit`" 
              class="bg-light px-2"
              v-if="scope.$index !== v_rowIndex && (_isallowed('write'))"
              @click="v_editMode(scope.$index, scope.row)"><i class="fal fa-edit text-primary"></i>
              </el-button> 
            </template>

        </el-table-column>
      </el-table>
          
    </div>
  </el-tab-pane>
  </el-tabs>
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
        isEditing: false,     
        v_isEditing: false,   
        nothing: true,
        rowIndex: null, 
        rowId: null, 
        rowData: null,
        v_rowIndex: null, 
        v_rowId: null, 
        v_rowData: null,
        tabPosition: 'bottom',
        search: '',
    };
  },
  methods: {
  ...mapMutations([
    "SET_CONTRACT_PROJECT_STATUS",
    "SET_CONTRACT_VEHICLE_STATUS"
  ]),
  ...mapActions([
    "updateContractProject",
    "updateContractVehicle",
    "fetchContractProjects",
    "fetchContractVehicles",
    "fetchContractPOCs",
  ]),  
  log(e){
   console.log(e)
  },
  _isallowed(salut) {    
     return this.checkPortfolioContractPrivileges("PortfolioContracts", salut, this.$route, {settingType: 'Contracts'})
  }, 
  handleClick(tab, event) {
    console.log(tab, event)
   },
  saveContractPOCs(index, row){
    this.rowIndex = null;
    this.rowId = null;
    let contractProjectData = {
        cProjectData: {
          pm_poc_ids: row.pm_contract_poc_ids.map(t => t.id),
          gov_poc_ids: row.gov_contract_poc_ids.map(t => t.id),
          co_poc_ids: row.co_contract_poc_ids.map(t => t.id),     
        },
      };
      let id = row.id
      console.log(contractProjectData)
      this.updateContractProject({...contractProjectData, id})    
  },
  saveVehiclePOCs(index, row){
    this.v_rowIndex = null;
    this.v_rowId = null;
    let vehicleProjectData = {
        cVehicleData: {
          pm_poc_ids: row.pm_contract_poc_ids.map(t => t.id),
          gov_poc_ids: row.gov_contract_poc_ids.map(t => t.id),
          co_poc_ids: row.co_contract_poc_ids.map(t => t.id),     
        },
      };
      let id = row.id
      console.log(vehicleProjectData)
      this.updateContractVehicle({...vehicleProjectData, id})    
  },
  backHomeBtn() {
    window.location.pathname = "/";
  },    
  editMode(index, rows) {    
    this.rowIndex = index,
    this.isEditing = true,
    this.rowId = rows.id  
  },  
  cancelEdits(index, rows) {
    this.rowIndex = null;
    this.rowId = null;
    this.isEditing = false
    this.fetchContractProjects();
  },
  v_editMode(index, rows) {    
    this.v_rowIndex = index,
    this.v_isEditing = true,
    this.v_rowId = rows.id  
  },  
  v_cancelEdits(index, rows) {
    this.v_rowIndex = null;
    this.v_rowId = null;
    this.v_isEditing = false
    this.fetchContractVehicles();
  },      
  },
  mounted() {
    this.fetchContractPOCs()
  },
  computed: {
    ...mapGetters([
     "contractProjects",
     "contractVehicleStatus",
     "contractProjectStatus",
     "contractVehiclesLoaded",
     "contractProjectsLoaded",
     "contractPOCs",
     "contractVehicles"
    ]), 
  tableData(){
    if (this.contractProjectsLoaded && this.contractProjects && this.contractProjects.length > 0){    
       return this.contractProjects
     }      
    }, 
   vehicleTableData(){
      if (this.contractVehiclesLoaded && this.contractVehicles && this.contractVehicles.length > 0){
        return this.contractVehicles 
      }  
    },
   pocOptions(){
     if (this.contractPOCs && this.contractPOCs.length > 0){
        return this.contractPOCs.map(t => t).filter(pocs => pocs && pocs.id && pocs.name !== null )
      }
    },
  },
  watch: {
    contractProjectStatus: {
      handler() {
        if (this.contractProjectStatus == 200) {
          MessageDialogService.showDialog({
            message: `Contract POC saved successfully.`,
            
            
          });
          this.SET_CONTRACT_PROJECT_STATUS(0);
          this.fetchContractProjects();
        }
      },
    }, 
    contractVehicleStatus: {
      handler() {
        if (this.contractVehicleStatus == 200) {
          MessageDialogService.showDialog({
            message: `Vehicle POC data saved successfully.`,
            
            
          });
          this.SET_CONTRACT_VEHICLE_STATUS(0);
          this.fetchContractVehicles();
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
::v-deep.el-table {
    th {
      color: #383838;
    }
  }    
</style>