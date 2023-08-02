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
     <i class="fal fa-cloud ml-2 mr-1 text-info"></i>  
      MPATH CLOUD DATA (TESTING)
      </h4>
    </el-breadcrumb>  
     <div class="row px-0">
    <div class="col">
      <el-button @click.prevent="addDataBtn" class="bg-primary text-light mb-2"> 
      <i class="far fa-plus-circle mr-1"></i> Add Your Data
      </el-button>
     </div>   
     </div> 
     <div v-if="globalContracts.length > 0">
   <el-table
     :data="globalContracts"
      style="width: 100%"
      height="450"
      >
      <el-table-column
        prop="contractName"
        label="Contract Name"
        width="300">
      </el-table-column>
      <el-table-column
        prop="programName"
        label="Program Name"
         width="300"
        >
      </el-table-column>
       <el-table-column
        prop="mpathInstance"
        label="mPATH Organization">
      </el-table-column>
   <!-- <el-table-column
      label="Operations">
      <template slot-scope="scope">
        <el-button
          size="mini"
          @click="handleEdit(scope.$index, scope.row)">Edit</el-button>
        <el-button
          size="mini"
          type="danger"
          @click="handleDelete(scope.$index, scope.row)">Delete</el-button>
      </template>
    </el-table-column> -->
    
  </el-table>

     </div>
     <div v-else>
       NO DATA
     </div>
    <div class="w-50">
         <el-dialog :visible.sync="dialogVisible" append-to-body center class="contractForm p-0">
     <form
      accept-charset="UTF-8"
      @submit.prevent="onSubmit"
     
      >      
       <div class="form-group mx-3">
          <label class="font-md"
            >Contract Name </label
          >
          <el-input
            type="textarea"
            v-model="form.name"
            placeholder="Enter your name here"          
            rows="1"          
            name="Program Name"
          />
       </div>
   
        <div class="right mr-2">
        <button 
          type="submit"
          class="btn btn-sm bg-primary text-light mr-2" 
          >
          Save
        </button>       
     

        </div>
    </form>
   </el-dialog>
  </div> 
</div>

  
    </div>
  </div>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
import SettingsSidebar from "./SettingsSidebar.vue";
import { createUser, deleteUser, dbCollection } from "../../../packs/firebase";


export default {
  name: "TestCloudData",
  components: {
   SettingsSidebar
  },
  data() {
    return {
      currentFacility: {},
     
      globalContracts: [],
        form: {
          name: '',
          program: '',
          org:  this.$mpath_instance,
        },
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
      // this.fetchContracts()
      let contracts = []
      this.globalContracts = dbCollection().get().then(querySnapshot => {
       contracts = querySnapshot.docs.map(doc => doc.data())
        this.globalContracts = contracts
    })
   
    //   return users

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
  
    handleEdit(index, row) {
    console.log(index, row);
    },
    handleDelete(index, row) {
    console.log(index, row);
        deleteUser(row.id)
    },

   async onSubmit ()  {
         const formData = {
            contractName: this.form.name,
            programName: this.currentProject.name, 
            mpathInstance: this.form.org

          }
        await createUser({...formData})
        return { formData },
        this.form.name = ""      

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
    addDataBtn(){
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
      "facilityGroupFacilities",
      'facilityGroups',
      'currentProject'
    ]), 
     backToSettings() {
      return `/programs/${this.$route.params.programId}/settings`;
    },
   tableData(){
      if(this.contracts[0] && this.contracts[0].length > 0 ){
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
  beforeMount() {
    if (this.contentLoaded && this.$route.params.contractId) {
      this.currentContract = this.contracts[0].find(
        (c) => c.id == this.$route.params.contractId
      );
    }
  },
  watch: {
    contractStatus: {
      handler() {
        if (this.contractStatus == 200 && this.contractNameText) {
          MessageDialogService.showDialog({
            message: `Contract saved successfully.`,
            
            
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
::v-deep.el-table th.el-table__cell>.cell {
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
</style>