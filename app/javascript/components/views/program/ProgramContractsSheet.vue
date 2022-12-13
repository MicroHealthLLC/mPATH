<template>
 <div class="my-1 pb-2 buttonWrapper container-fluid">
  <div class="row px-0 mb-2">
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
  <div
    v-if="tableData"
    v-loading="!contentLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)"
   >
   <hr class="mt-2 mb-0">
   <el-table 
    :data="tableData.filter(data => !search || data.name.toLowerCase().includes(search.toLowerCase())).reverse()" 
    height="500"
    stripe
    style="width:100%" 
    >
    <el-table-column 
      prop="name"  
      sortable  
      width="200"
      label="Project Name"
      > 
   </el-table-column>
  <el-table-column    
    label="Customer"
    prop="contractCustomerId">
      <template slot-scope="scope" >
      <span v-if="scope.row.contractCustomer && scope.row.contractCustomer.name !== null">
        {{ scope.row.contractCustomer.name }}
        </span>
      </template>
    </el-table-column>
      <el-table-column
      label="Contract #"
      prop="contractNumberId">
      <template slot-scope="scope" >
      <span v-if="scope.row.contractNumber && scope.row.contractNumber.name !== null">
      {{ scope.row.contractNumber.name}}
      </span>
      </template>
      </el-table-column>
      <el-table-column
        label="Award/TO #"  
        prop="contractAwardToId">
        <template slot-scope="scope" >
        <span v-if="scope.row.contractAwardTo && scope.row.contractAwardTo.name !== null">
        {{ scope.row.contractAwardTo.name }}
        </span>
        </template>
      </el-table-column>
      <el-table-column
        prop="facilityGroup"
        sortable
        filterable
        label="Group"
      >
        <template slot-scope="scope">
          <span v-if="scope.row.facilityGroup && scope.row.facilityGroup.name">
              {{ scope.row.facilityGroup.name }}
            </span> 
      
        </template>
    </el-table-column>
     <el-table-column 
      label="Actions"     
      width="300"      
      >
        <template slot-scope="scope">
  
        <el-button
          v-tooltip="`Go to Contract`"
          type="default"       
          @click.prevent="goToContract(scope.$index, scope.row)"
          class="bg-light"
        >
         <i class="far fa-file-contract mh-orange-text" style="font-size:1rem"></i> 
        <i class="fas fa-arrow-alt-circle-right ml-1 text-success"></i>
        </el-button>   
        </template>
    </el-table-column>  
   </el-table>   
  </div>
   <span v-else class="mt-5">
      NO DATA TO DISPLAY   
   </span>
</div>

</template>

<script>

import { mapGetters, mapMutations, mapActions } from "vuex";
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
     'setEditContractSheet',
     'setGroupFilter', 
     'SET_EDIT_CONTRACT_SHEET',
     'SET_CONTRACT_STATUS',
     'setContractTypeFilter',
     'setNewContractGroupFilter',
     'SET_CONTRACT_GROUP_TYPES'
     ]), 
   ...mapActions([]),
    _isallowed(salut) {
        return this.checkPrivileges("ProgramContractsSheet", salut, this.$route)

        // let pPrivilege = this.$programPrivileges[this.$route.params.programId]        
        // let permissionHash = {"write": "W", "read": "R", "delete": "D"}
        // let s = permissionHash[salut]
        // return pPrivilege.contracts.includes(s);     
      },
    goToContract(index, rows){        
      //Needs to be optimzed using router.push.  However, Project Sidebar file has logic that affects this routing
      this.$router.push({
        name: "SheetContract",
        params: {
          programId: this.$route.params.programId,
          contractId: rows.projectContractId.toString(),          
        },
      });
    
    },
    editContract(){
      if(this.editContractSheet == false){
        console.log(this.editContractSheet)
        this.SET_EDIT_CONTRACT_SHEET(!this.editContractSheet)
          console.log(this.editContractSheet)
      } else return
    },
    saveContract() {
      if(this.editContractSheet == true){
        console.log(this.editContractSheet)
       this.SET_EDIT_CONTRACT_SHEET(!this.editContractSheet)
          console.log(this.editContractSheet)
      } else return
    //  TO DO: Write logic to listen for onchange event.  If nothing edited, use default value
    //  if (rows && rows !== undefined) {
        let id = rows.id;
        let contractData = {
          contract: {
            nickname: rows.nickname,
            facility_group_name: rows.facilityGroupName,  
            facility_group_id: rows.facilityGroupId,  
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
      "projectContracts",
      'editContractSheet',
      'getContractTable',
      'getProjectGroupFilter',
      'getGroupFilter',
      'facilityGroups',
      'currentProject'
    ]), 
    tableData(){
      if(this.projectContracts &&
         this.projectContracts.length > 0 
         ){
     let contractData = this.projectContracts.map(t => t)
      .filter((td) => {
        //  console.log(td)
          if (this.C_projectGroupFilter && this.C_projectGroupFilter.length > 0 ) {
            let group = this.C_projectGroupFilter.map((t) => t.id);
            return group.includes(td.facilityGroup.id);
           
          } else return true;
        });
       return contractData
      }    
   },
   groupsArr(){
      if (this.currentProject && this.currentProject.facilityGroups.length > 0 ){   
       return this.currentProject.facilityGroups
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
::v-deep.el-table th.el-table__cell>.cell {
  color: #212529;
  font-size: .85rem;
  word-break: normal;
}
td, th {
  overflow-wrap: break-word !important;
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
::v-deep.el-table__row .el-input .el-input__inner{
  border-style:none;
  font-size: 16px !important;
}
::v-deep.hover-row .el-input .el-input__inner{
  border-style:solid;   
}
::v-deep.el-dialog {
  width:30%;
  border-top: solid 5px  #1D336F !important;
}
::v-deep.el-table {
  .el-input__inner { 
  font-size: 16px !important;
  }
}
::v-deep.el-dialog__close.el-icon.el-icon-close {
  background-color: #DC3545;
    border-radius: 50%;
    color: white;
    padding: 2px;
    font-size: .7rem;
}
.light {
  background-color: lightgray;
  color: lightgray;
}
.overflowX {
  overflow-x: scroll !important;
}
.truncate-line-five
{
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;  
  overflow: hidden;
  &:hover
  {
    display: -webkit-box;
    -webkit-line-clamp: unset;
  }
}
</style>