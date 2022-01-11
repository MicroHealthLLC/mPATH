<template>
  <div class="row">
   <div class="col-md-12">
  <div class="right-panel">  

 <div class="my-1 pb-2 buttonWrapper container-fluid">
  <div class="row px-0">
    <!-- <div class="col" v-if="_isallowed('write')">
      <el-button @click.prevent="addContract" class="bg-primary text-light mb-2"> 
      <i class="far fa-plus-circle mr-1"></i> Add Contract
      </el-button>
     </div>     -->
     <div class="col">
        <el-input
          type="search"          
          placeholder="Search Contracts"
          aria-label="Search"            
          aria-describedby="search-addon"    
          v-model="search"
          data-cy=""
      >
         <el-button slot="prepend" icon="el-icon-search"></el-button>    
        </el-input>    
     </div> 
       <div class="col pl-0">
         <el-select
          class="w-100 mx-2"
          v-model="C_projectGroupFilter" 
          track-by="id"
          value-key="id"
          multiple
          filterable
          clearable
          name="Project Group"         
          placeholder="Filter Contracts By Group"
          >
          <el-option
          v-for="item in facilityGroups"
          :key="item.id"
          :label="item.name"
          :value="item">
        </el-option>
          
          </el-select>
       </div>
      </div>
  </div>
  <div
    v-if="tableData"
    v-loading="!contentLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)"
    class="">
   <el-table :data="tableData.filter(data => !search || data.nickname.toLowerCase().includes(search.toLowerCase())).reverse()" style="width: 100%"  height="600">
    <el-table-column 
      prop="projectCode"  
      sortable  
      label="Project Code"
      width="200"
      > 
      <template slot-scope="scope">
        <el-input size="small"
          style="text-align:center"
          v-model="scope.row.projectCode" controls-position="right"></el-input>
      </template>
    </el-table-column>   
    <el-table-column 
      prop="nickname"  
      sortable  
      width="200"
      label="Contract Nickname"
      > 
       <template slot-scope="scope">
          <el-input size="small"
            style="text-align:center"
            v-model="scope.row.nickname" controls-position="right"></el-input>
       </template>
    </el-table-column>
    <el-table-column 
      prop="contractType"  
      sortable  
      label="Type" 
      width="200"
      > 
       <template slot-scope="scope">
          <el-input size="small"
            style="text-align:center"
            v-if="scope.row.contractType && scope.row.contractType.name"
            v-model="scope.row.contractType.name" controls-position="right"></el-input>
            <span v-else> <i> Edit in Program Settings </i> </span>
       </template>
    </el-table-column>     
     <el-table-column sortable prop="contractStatus"  label="Status" width="200"> 
       <template slot-scope="scope">
          <el-input size="small"
            style="text-align:center"
            v-if="scope.row.contractStatus && scope.row.contractStatus.name"
            v-model="scope.row.contractStatus.name" controls-position="right"></el-input>
             <span v-else> <i> Edit in Program Settings </i> </span>
       </template>
    </el-table-column>
      <el-table-column prop="name"  sortable  label="Contract Name" width="200"> 
       <template slot-scope="scope">
          <el-input size="small"
            style="text-align:center"
            v-if="scope.row.name"
            v-model="scope.row.name" controls-position="right"></el-input>
            <span v-else> <i> Edit in Program Settings </i> </span>
       </template>
    </el-table-column>
    <el-table-column prop="contractCustomer.name"  sortable  label="Customer (Agency)" width="200"> 
       <template slot-scope="scope">
          <el-input size="small"
            style="text-align:center"
            v-if="scope.row.contractCustomer && scope.row.contractCustomer.name"
            v-model="scope.row.contractCustomer.name" controls-position="right"></el-input>
       </template>
    </el-table-column>
      <el-table-column prop="contractVehicle.name"  sortable  label="Vehicle" width="200"> 
       <template slot-scope="scope">
          <el-input size="small"
            style="text-align:center"
            v-if="scope.row.contractVehicle && scope.row.contractVehicle.name"
            v-model="scope.row.contractVehicle.name" controls-position="right"></el-input>
             <span v-else> <i> Edit in Program Settings </i> </span>
       </template>
    </el-table-column>
        <el-table-column prop="contractVehicleNumber.name"
          sortable 
          label="Pime IDIQ/Vehicle Contract Number"
          width="200"
          > 
       <template slot-scope="scope">
          <el-input size="small"
            style="text-align:center"
            v-if="scope.row.contractVehicleNumber && scope.row.contractVehicleNumber.name"
            v-model="scope.row.contractVehicleNumber.name" controls-position="right"></el-input>
            <span v-else> <i> Edit in Program Settings </i> </span>
       </template>
    </el-table-column>
        <el-table-column 
          prop="contractPrime.name"  
          sortable  
          label="Pime Contract Number/Task Order/PO Number"
          width="200"
          > 
       <template slot-scope="scope">
          <el-input size="small"
            style="text-align:center"
            v-if="scope.row.contractPrime && scope.row.contractPrime.name"
            v-model="scope.row.contractPrime.name" controls-position="right"></el-input>
           <span v-else> <i> Edit in Program Settings </i> </span>
       </template>
      </el-table-column>
          <el-table-column 
          prop="subcontractNumber.name"  
          sortable  
          label="Subcontract Number/PO Number"
          width="200"
          > 
       <template slot-scope="scope">
          <el-input size="small"
            style="text-align:center"
            v-if="scope.row.subcontractNumber && scope.row.subcontractNumber.name"
            v-model="scope.row.subcontractNumber.name" controls-position="right"></el-input>
          <span v-else> <i> Edit in Program Settings </i> </span>
       </template>
    </el-table-column>
    <el-table-column 
      prop="facilityGroupName" 
      sortable 
      filterable 
      label="Group"
      width="200"
      >
          <template slot-scope="scope">
          <el-input size="small"
            style="text-align:center"
            v-model="scope.row.facilityGroupName"></el-input>
       </template>
    </el-table-column>

     <el-table-column label="Actions" fixed="right">
      <template slot-scope="scope" >
      <el-button v-if="_isallowed('write')" type="default" @click.prevent="editContract(scope.$index, scope.row)" class="bg-primary text-light">Save</el-button>
       <el-button v-if="_isallowed('write')" type="default" @click.prevent="goToContract(scope.$index, scope.row)" class="bg-success text-light">Go To Contract  <i class="fas fa-arrow-alt-circle-right ml-1"></i>
        </el-button>
        <!-- <el-button type="primary" @click="handleEditRow(scope.$index)">Edit</el-button> -->
      </template>
    </el-table-column>
  
   </el-table>  
   
  </div>
   <span v-else class="mt-5">
      NO DATA TO DISPLAY   
   </span>
     </div>
    </div>
  </div>
</template>

<script>

// Compare both array objects, if obj a is also in obj b, push key 'yes' into that value[i] else, push key 'no'

// Create two empty arrays
// Push values into array
// Compare arrays


import { mapGetters, mapMutations, mapActions } from "vuex";
import { createUser, deleteUser, dbCollection } from "../../../packs/firebase";
export default {
  name: "ProgramContractsSheet",
  data() {
    return {
      currentFacility: {},
      // currentContract: {},
      dialogVisible: false,
      currentFacilityGroup: {},
      projectNameText: '',
      search: '',
      hideSaveBtn: false,
      contractNameText: '',
      expanded: {
        id: "",
      },
    };
  },
  methods: {
   ...mapMutations([
     'setProjectGroupFilter', 
     'setContractTable', 
     'setGroupFilter', 
     'SET_CONTRACT_STATUS',
     'setContractTypeFilter',
     'setNewContractGroupFilter',
     'SET_CONTRACT_GROUP_TYPES'
     ]), 
   ...mapActions([]),
    _isallowed(salut) {
        let pPrivilege = this.$programPrivileges[this.$route.params.programId]        
        let permissionHash = {"write": "W", "read": "R", "delete": "D"}
        let s = permissionHash[salut]
        return pPrivilege.contracts.includes(s);     
      },
    goToContract(index, rows){        
      //Needs to be optimzed using router.push.  However, Project Sidebar file has logic that affects this routing
      this.$router.push({
        name: "SheetContract",
        params: {
          programId: this.$route.params.programId,
          contractId: rows.id.toString(),          
        },
      });
    
    },
    editContract(index, rows) {
    //  TO DO: Write logic to listen for onchange event.  If nothing edited, use default value
    //  if (rows && rows !== undefined) {
        let id = rows.id;
        let contractData = {
          contract: {
            nickname: rows.nickname,
            facility_group_name: rows.facility_group_name,  
            facility_group_id: rows.facility_group_id,  
            project_id: this.$route.params.programId,
            id:  id    
          }
        }
         this.updateContract({
            ...contractData, id
          })
    },
    addAnotherContract() {
         this.C_projectGroupFilter = null;
         this.contractNameText = "";
         this.hideSaveBtn = false;  
    },
    closeAddContractBtn() {
        this.dialogVisible = false;
        this.hideSaveBtn = false;
    },
    addContract(){
      this.dialogVisible = true;    
      this.C_projectGroupFilter = null;
      this.contractNameText = ""  
    },
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "contractsLoaded",
      "getContractGroupTypes",
      'getNewContractGroupFilter',
      "contractStatus",
      'getContractGroupOptions',
      "contracts",
      'getContractTable',
      'getProjectGroupFilter',
      'getGroupFilter',
      'facilityGroups',
      'currentProject'
    ]), 
    tableData(){
      if(this.currentProject &&
         this.currentProject.contracts.length > 0 
         ){
      let programContracts = this.currentProject.contracts.filter(t => t.projectId == this.$route.params.programId)
      let contractData = programContracts.map(t => t)
      .filter((td) => {
        //  console.log(td)
          if (this.C_projectGroupFilter && this.C_projectGroupFilter.length > 0 ) {
            let group = this.C_projectGroupFilter.map((t) => t.id);
            return group.includes(td.facilityGroupId);
           
          } else return true;
        });
       return contractData
      }    
   },
    C_typeFilter: {
        get() {
          return this.getContractGroupTypes
        },
        set(value) {
          this.SET_CONTRACT_GROUP_TYPES(value)
        }      
      },
    // Filter when adding new Project
     C_projectGroupFilter: {
       get() {
        return this.getGroupFilter;
      },
      set(value) {
        // console.log(value)
        this.setGroupFilter(value);
      },
    },

     C_newContractGroupFilter: {
       get() {
        return this.getNewContractGroupFilter;
      },
      set(value) {
        // console.log(value)
        this.setNewContractGroupFilter(value);
      },
    },
  },
  watch: {
    contractStatus: {
      handler() {
        if (this.contractStatus == 200 && this.contractNameText) {
          this.$message({
            message: `Contract saved successfully.`,
            type: "success",
            showClose: true,
          });     
          this.SET_CONTRACT_STATUS(0);
          this.fetchContracts();
        }
      },
    },  
  },
};
</script>

<style scoped lang="scss">
.buttonWrapper {
  border-bottom: lightgray solid 1px;
}
.right{
  text-align: right;
}
.fa-calendar {
  font-size: x-large; 
}
/deep/.el-table th.el-table__cell>.cell {
  color: #212529;
  font-size: .88rem;
}
.tabs {
  background-color: #ededed;
  border-top: solid 0.3px #ededed;
  width: min-content;
  display: flex;
  box-shadow: 0 2.5px 2.5px rgba(0, 0, 0, 0.19), 0 3px 3px rgba(0, 0, 0, 0.23);
  .tab {
    cursor: pointer;
    padding: 7px 10px;
    border-radius: 0.1rem;
    font-weight: 500;
    letter-spacing: 1;
    transition: auto;
    font-size: 75%;
  }
  .active {
    color: #fff !important;
    background-color: #383838 !important;
  }
}
a {
  color: unset;
  text-decoration: unset;
}
.right-panel {
  height: calc(100vh - 100px);
  overflow-y: auto;
}
/deep/.el-table__row .el-input .el-input__inner{
  border-style:none;
  font-size: 16px !important;
}
/deep/.hover-row .el-input .el-input__inner{
  border-style:solid;   
}
/deep/.el-dialog {
  width:30%;
  border-top: solid 5px  #1D336F !important;
}
/deep/.el-table {
  .el-input__inner { 
  font-size: 16px !important;
  }
}
/deep/.el-dialog__close.el-icon.el-icon-close {
  background-color: #DC3545;
    border-radius: 50%;
    color: white;
    padding: 2px;
    font-size: .7rem;
}
</style>