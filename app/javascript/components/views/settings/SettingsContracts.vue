<template>
  <div
    v-loading="!contractsLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)"
    class="row"
  >
     <div class="col-md-2">
      <SettingsSidebar/>
    </div>
   <div class="col-md-10">
  <div class="right-panel">  
    <el-breadcrumb separator-class="el-icon-arrow-right" class="mt-3 mb-4">
     <el-breadcrumb-item :to="toSettingsLanding">
      <span style="cursor:pointer"><i class="far fa-cog mr-1"></i> PROGRAM SETTINGS </span>
     </el-breadcrumb-item>
     <h4 class="mt-4 ml-3"> 
       <i class="far fa-file-contract ml-2 mr-1 mh-orange-text"></i>  
       CONTRACTS
      </h4>
    </el-breadcrumb>   
 <div class="my-1 pb-2 buttonWrapper">
    <el-button @click.prevent="addContract" class="bg-primary text-light mb-2" style="position:absolute"> 
    <i class="far fa-plus-circle mr-1"></i> Add Contract
    </el-button>
     <div class="mb-2 mr-2 ml-auto d-flex" style="width:75%">
       <!-- <label>GROUP</label> -->
     
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
         <el-select
          class="w-100 mx-2"
          v-model="C_groupFilter" 
          track-by="id"
          value-key="id"
          multiple
          filterable
          clearable
          name="Project Group"         
          placeholder="Filter Contracts By Group"
          >
          <el-option
          v-for="item in filteredFacilityGroups"
          :key="item.id"
          :label="item.name"
          :value="item">
        </el-option>
          
          </el-select>
      </div>
  </div>
   <el-table :data="tableData.filter(data => !search || data.contract_nickname.toLowerCase().includes(search.toLowerCase())).reverse()" style="width: 100%"  height="450">
    <el-table-column prop="contract_nickname"  sortable  label="Contract"> 
       <template slot-scope="scope">
          <el-input size="small"
            style="text-align:center"
            v-model="scope.row.contract_nickname" controls-position="right"></el-input>
       </template>


    </el-table-column>
    <el-table-column prop="facility_group_name" sortable filterable label="Group">
          <template slot-scope="scope">
          <el-input size="small"
            style="text-align:center"
            v-model="scope.row.facility_group_name"></el-input>
       </template>
    </el-table-column>

     <el-table-column label="Actions">
      <template slot-scope="scope" >
      <el-button type="default" @click="editContract(scope.$index, scope.row)" class="bg-primary text-light">Save</el-button>
       <el-button type="default" @click="goToContract(scope.$index, scope.row)" class="bg-success text-light">
         Go To Contract  <i class="fas fa-arrow-alt-circle-right ml-1"></i>
        </el-button>
        <!-- <el-button type="primary" @click="handleEditRow(scope.$index)">Edit</el-button> -->
      </template>
    </el-table-column>
  
   </el-table>
   <el-dialog :visible.sync="dialogVisible" append-to-body center class="contractForm p-0">
     <form
      accept-charset="UTF-8"    
      >      
       <div class="form-group mx-3">
          <label class="font-md"
            >New Contract Name <span style="color: #dc3545">*</span></label
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
            >Contract Type <span style="color: #dc3545">*</span></label
          >
           <el-select
           v-model="C_typeFilter"
           class="w-100"
           track-by="id"
           value-key="id"         
           clearable
           placeholder="Select Contract Type"
           >
          <el-option
            v-for="item in getContractTypeOptions"
            :value="item.value"
            :key="item.id"
            :label="item.name"
            >
          </el-option>
          </el-select>
       </div>
       <div class="form-group mx-3">
        <label class="font-md"
        >Group</label
        >
         <el-select
            class="w-100"
            v-model="C_projectGroupFilter" 
            track-by="id"
            value-key="id"
            clearable
            filterable
            name="Project Group"         
            placeholder="Select Group"
          >
          <el-option
          v-for="item in filteredFacilityGroups"
          :key="item.id"
          :label="item.name"
          :value="item">
        </el-option>
          
          </el-select>
       </div>
        <div class="right mr-2">
        <el-button @click.prevent="saveNewContract" class="bg-success text-light mr-2" :class="[hideSaveBtn ? 'd-none': '']">Save</el-button>
       
        <el-button @click.prevent="addAnotherContract" :class="[!hideSaveBtn ? 'd-none': '']" class="bg-primary text-light mr-2"><i class="far fa-plus-circle mr-1"></i> Add Another Contract</el-button>

        <el-button @click.prevent="closeAddContractBtn" class="bg-danger text-light mr-2"  :class="[!hideSaveBtn ? 'd-none': '']">Close</el-button>

        </div>
    </form>
   </el-dialog>
    
      <!-- <div v-if="currentFacility" class="d-inline"> <h5 class="text-center">{{ currentFacility.facilityName }} </h5></div> -->
       <div class="pr-3">   
          <router-view
            :key="$route.path"
            :facility="currentFacility"
            :facilityGroup="currentFacilityGroup"
          ></router-view>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { mapGetters, mapMutations, mapActions } from "vuex";
import SettingsSidebar from "./SettingsSidebar.vue";
export default {
  name: "SettingsContracts",
  components: {
   SettingsSidebar
  },
  data() {
    return {
      currentFacility: {},
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
    mounted() {
    this.fetchContracts();   
  },
  methods: {
   ...mapMutations([
     'setProjectGroupFilter', 
     'setContractTable', 
     'setGroupFilter', 
     'SET_CONTRACT_STATUS',
     'setContractTypeFilter'
     ]), 
   ...mapActions(["createContract", "fetchContracts", "updateContract"]),

    showFacility(facility) {
      this.currentFacility = facility;
    },
    handleClick(tab, event) {
        console.log(tab, event);
    }, 
    goToContract(index, rows){        
         this.$router.push(
         `/programs/${this.$route.params.programId}/sheet/contracts/${rows.id}/contract`
      );
    },
    saveNewContract() {
        let contractData = {
          contract: {
            contract_nickname: this.contractNameText,
            facility_group_id: this.C_projectGroupFilter.id,
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
    editContract(index, rows) {
    //  TO DO: Write logic to listen for onchange event.  If nothing edited, use default value
    //  if (rows && rows !== undefined) {
        let id = rows.id;
        let contractData = {
          contract: {
            contract_nickname: rows.contract_nickname,
            contract_type_id: rows.contract_type_id,
            facility_group_name: rows.facility_group_name,  
            facility_group_id: rows.facility_group_id,  
            project_id: this.$route.params.programId,
            id:  id    
          }
        }
         this.updateContract({
            ...contractData, id
          })
          console.log(rows, contractData)
     
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
      "facilities",
      "getContractTypeFilter",
      "getContractTypeOptions",
      "contractStatus",
      "contracts",
      'getContractTable',
      'getProjectGroupFilter',
      'getGroupFilter',
      "facilityGroupFacilities",
      'filteredFacilityGroups',
      'currentProject'
    ]), 
    toSettingsLanding(){
     return `/programs/${this.$route.params.programId}/settings`  
    },
    tableData(){
      if(this.contracts){
      let contractData = this.contracts[0]         
      .filter((td) => {
          if (this.C_groupFilter && this.C_groupFilter.length > 0 ) {
            let group = this.C_groupFilter.map((t) => t.name);
            return group.includes(td.facility_group_id);
          } else return true;
        });
       return contractData
      }    
   },
      // Filter for Projects Table
    C_groupFilter: {
      get() {
        return this.getGroupFilter;
      },
      set(value) {
        // console.log(value)
        this.setGroupFilter(value);
      },
    },
    C_typeFilter: {
        get() {
          return this.getContractTypeFilter
        },
        set(value) {
          this.setContractTypeFilter(value)
        }
      },
    // Filter when adding new Project
     C_projectGroupFilter: {
      get() {
        return this.getProjectGroupFilter;
      },
      set(value) {
        // console.log(value)
        this.setProjectGroupFilter(value);
      },
    },
  },
  beforeMount() {
    if (this.contentLoaded && this.$route.params.projectId) {
      this.currentFacility = this.facilities.find(
        (facility) => facility.facilityId == this.$route.params.projectId
      );
    }
  },
  watch: {
    contentLoaded: {
      handler() {
        if (this.$route.params.projectId) {
          this.currentFacility = this.facilities.find(
            (facility) => facility.facilityId == this.$route.params.projectId
          );
        }
      },
    },
    contractStatus: {
      handler() {
        if (this.contractStatus == 200) {
          this.$message({
            message: `${this.contractNameText} was saved successfully.`,
            type: "success",
            showClose: true,
          });
          this.SET_CONTRACT_STATUS(0);
          this.fetchContracts();
        }
      },
    },
    facilities: {
      handler() {
        this.currentFacility = this.facilities.find(
          (facility) => facility.facilityId == this.$route.params.projectId
        );
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