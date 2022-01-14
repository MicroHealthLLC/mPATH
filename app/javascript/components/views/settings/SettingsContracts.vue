<template>
  <div class="row">
     <div class="col-md-2">
      <SettingsSidebar/>
    </div>
   <div class="col-md-10">
  <div class="right-panel">  
    <el-breadcrumb separator-class="el-icon-arrow-right" class="mt-3 mb-4">
     <el-breadcrumb-item :to="backToSettings">
      <span style="cursor:pointer"><i class="far fa-cog mr-1"></i> PROGRAM SETTINGS </span>
     </el-breadcrumb-item>
     <h4 class="mt-4 ml-3"> 
       <i class="far fa-file-contract ml-2 mr-1 mh-orange-text"></i>  
       CONTRACTS  
       <span 
          v-if="tableData && tableData.length"
          class="ml-2 pb-1 badge badge-secondary badge-pill pill"
          >{{ tableData.length }}
        </span>
         <span 
          v-else
          class="ml-2 pb-1 badge badge-secondary badge-pill pill"
          >{{ 0 }}
        </span>
      </h4>
    </el-breadcrumb>   
 <div class="my-1 pb-2 buttonWrapper container-fluid" v-if="_isallowed('read')">
  <div class="row px-0">
    <div class="col" v-if="_isallowed('write')">
      <el-button @click.prevent="addContract" class="bg-primary text-light mb-2"> 
      <i class="far fa-plus-circle mr-1"></i> Add Contract
      </el-button>
     </div>    
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
   v-if="tableData && _isallowed('read')"
    v-loading="!contentLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)"  
    class="">
   <el-table   
     :data="tableData.filter(data => !search || data.nickname.toLowerCase().includes(search.toLowerCase())).reverse()" 
     style="width: 100%"  
     height="450"
     >
    <el-table-column prop="nickname"  sortable  label="Contract"> 
       <template slot-scope="scope">
          <el-input size="small"
            style="text-align:center"
            v-model="scope.row.nickname" controls-position="right"></el-input>
       </template>


    </el-table-column>
    <el-table-column prop="facility_group_name" sortable filterable label="Group">
          <template slot-scope="scope">
            <el-select
            class="w-100"
            v-model="scope.row.facility_group_id" 
            track-by="id"
            value-key="id"
            clearable
            filterable
            name="Project Group"         
            placeholder="Select Group"
          >
          <el-option
          v-for="item in facilityGroups"
          :key="item.id"
          :label="item.name"
          :value="item.id">
        </el-option>
          
          </el-select>
          <!-- <el-input size="small"
            style="text-align:center"
            v-model="scope.row.facility_group_name"></el-input> -->
       </template>
    </el-table-column>

     <el-table-column label="Actions">
      <template slot-scope="scope" >
      <el-button v-if="_isallowed('write')" type="default" @click.prevent="editContract(scope.$index, scope.row)" class="bg-primary text-light">Save</el-button>
       <el-button v-if="_isallowed('read')" type="default" @click.prevent="goToContract(scope.$index, scope.row)" class="bg-success text-light">Go To Contract  <i class="fas fa-arrow-alt-circle-right ml-1"></i>
        </el-button>
        <!-- <el-button type="primary" @click="handleEditRow(scope.$index)">Edit</el-button> -->
      </template>
    </el-table-column>
  
   </el-table>  
   
  </div>
   <span v-else class="mt-5">
      NO DATA TO DISPLAY   
   </span>
   <el-dialog :visible.sync="dialogVisible" append-to-body center class="contractForm p-0">
     <form
      accept-charset="UTF-8"    
      >      
       <div class="form-group mx-3">
          <label class="font-md"
            >Contract Name <span style="color: #dc3545">*</span></label
          >
          <el-input
            type="textarea"
            v-model="contractNameText"
            placeholder="Enter new contract name here"          
            rows="1"          
            name="Program Name"
          />
       </div>
       <div class="form-group mx-3">
          <label class="font-md"
            >Contract Nickname <span style="color: #dc3545">*</span></label
          >
          <el-input
            type="textarea"
            v-model="contractNicknameText"
            placeholder="Enter new contract name here"          
            rows="1"          
            name="Program Name"
          />
       </div>
       <!-- <div class="form-group mx-3">
          <label class="font-md"
            >Project Group Name <span style="color: #dc3545">*</span></label
          >
           <el-select
           v-model="C_typeFilter"
           class="w-100"
           track-by="id"
           value-key="id"         
           clearable
           placeholder="Select Project Group Name"
           >
          <el-option
            v-for="item in getContractGroupOptions"
            :value="item.id"
            :key="item.id"
            :label="item.name"
            >
          </el-option>
          </el-select>
       </div> -->
       <div class="form-group mx-3">
        <label class="font-md"
        >Group<span style="color: #dc3545">*</span></label
        >
         <el-select
            class="w-100"
            v-model="C_newContractGroupFilter" 
            track-by="id"
            value-key="id"
            clearable
            filterable
            name="Project Group"         
            placeholder="Select Group"
          >
          <el-option
          v-for="item in facilityGroups"
          :key="item.id"
          :label="item.name"
          :value="item">
        </el-option>
          
          </el-select>
       </div>
        <div class="right mr-2">
        <button 
          @click.prevent="saveNewContract"
          v-if="contractNameText && contractNicknameText && C_newContractGroupFilter.id" 
          class="btn btn-sm bg-primary text-light mr-2" 
          :class="[hideSaveBtn ? 'd-none': '']">
          Save
        </button>    
        <button 
          disabled
          v-else
          class="btn btn-sm bg-primary text-light mr-2" 
          >
          Save
        </button>          
        <button 
          @click.prevent="addAnotherContract" 
          :class="[!hideSaveBtn ? 'd-none': '']" 
          class="btn btn-sm bg-primary text-light mr-2">
          <i class="far fa-plus-circle mr-1"></i> Add Another Contract
        </button>
        <button 
          @click.prevent="closeAddContractBtn" 
          class="btn btn-sm bg-danger text-light mr-2"  
          :class="[!hideSaveBtn ? 'd-none': '']">
          Close
        </button>

        </div>
    </form>
   </el-dialog>
    
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
import SettingsSidebar from "./SettingsSidebar.vue";
import { createUser, deleteUser, dbCollection } from "../../../packs/firebase";
export default {
  name: "SettingsContracts",
  components: {
   SettingsSidebar
  },
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
      contractNicknameText: '',
      expanded: {
        id: "",
      },
    };
  },
  mounted() {
     this.fetchContracts();   
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
   ...mapActions(["createContract", "fetchContracts", "updateContract"]),
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
    saveNewContract() {
      this.onSubmit()
        let contractData = {
          contract: {
            nickname: this.contractNicknameText,
            name: this.contractNameText,
            facility_group_id: this.C_newContractGroupFilter.id,
            project_id: this.$route.params.programId,
            contract_type_id: this.C_typeFilter,
          }
        }       
        this.createContract({
            ...contractData,
          })
          this.hideSaveBtn = true;
          console.log(contractData)
    },
     async onSubmit ()  {
         const formData = {
            contractName: this.contractNameText,
            programName: this.currentProject.name, 
            mpathInstance: this.$mpath_instance

          }
        await createUser({...formData})
        return { formData }
    },   
    editContract(index, rows) {
        let id = rows.id;
        let contractData = {
          contract: {
            nickname: rows.nickname,
            name: rows.name,
            // facility_group_name: rows.facility_group_name,  
            facility_group_id: rows.facility_group_id,  
            project_id: this.$route.params.programId,
            id:  id    
          }
        }
        this.setNewContractGroupFilter(rows.facility_group_id)
         this.updateContract({
            ...contractData, id
          })
    },
    addAnotherContract() {
      this.C_projectGroupFilter = null;
      this.contractNameText = "";
      this.contractNicknameText = ""  
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
      this.contractNicknameText = ""  
    },
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "contractsLoaded",
      "getContractGroupTypes",
      'getNewContractGroupFilter',
      "contractStatus",
       "contracts",
      'getContractTable',
      'getProjectGroupFilter',
      'getGroupFilter',
      'facilityGroups',
      'currentProject'
    ]), 
     backToSettings() {
      return `/programs/${this.$route.params.programId}/settings`;
    },
    tableData(){
      if(this.contracts &&
         this.contracts[0] && 
         this.contracts[0].length > 0 
         ){
      let programContracts = this.contracts[0].filter(t => t.project_id == this.$route.params.programId)
      let contractData = programContracts.map(t => t)
      .filter((td) => {
        //  console.log(td)
          if (this.C_projectGroupFilter && this.C_projectGroupFilter.length > 0 ) {
            let group = this.C_projectGroupFilter.map((t) => t.id);
            return group.includes(td.facility_group_id);
           
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
        if (this.contractStatus == 200) {
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
  font-size: 1.15rem;
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