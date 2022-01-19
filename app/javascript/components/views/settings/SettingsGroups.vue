<template>
  <div 
   v-loading="!contentLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)"
    class="row">
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
     <i class="fal fa-network-wired mr-1 mh-orange-text"></i>  GROUPS
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
 <div class="my-1 pb-2 buttonWrapper container-fluid">
  <div class="row px-0">
    <div class="col">
    <el-button @click.prevent="addGroup" class="bg-primary text-light mb-2"> 
    <i class="far fa-plus-circle mr-1"></i> Add Group
    </el-button>
     </div>    
     <div class="col-5"  v-show="currentTab == 'tab2'">     
        <!-- <el-input
          type="search"          
          placeholder="Search Group"
          aria-label="Search"            
          aria-describedby="search-addon"    
          v-model="search"
          data-cy=""
      >
        <el-button slot="prepend" icon="el-icon-search"></el-button>
      </el-input>   -->
      </div>  
  </div>
 </div>
  <el-dialog :visible.sync="dialogVisible" append-to-body center class="contractForm p-0">
     <form
      accept-charset="UTF-8"    
      >      
       <div class="form-group mx-3">
          <label class="font-md"
            >New Group Name <span style="color: #dc3545">*</span></label
          >
          <el-input
            type="textarea"
            v-model="newGroupName"
            placeholder="Enter new Group name here"          
            rows="1"          
            name="Group Name"
          />
       </div>
      <div class="right mr-2">
        <button 
          @click.prevent="saveGroup"
          :disabled="!newGroupName"  
          class="btn btn-sm bg-primary text-light mr-2" 
          :class="[hideSaveBtn ? 'd-none': '']">
          Save
       </button>       
        <button 
          @click.prevent="addAnotherGroup" 
          :class="[!hideSaveBtn ? 'd-none': '']" 
          class="btn btn-sm bg-primary text-light mr-2">
          <i class="far fa-plus-circle mr-1"></i> Add Another Group
        </button>
        <button 
          @click.prevent="closeAddGroupBtn" 
          class="btn btn-sm bg-danger text-light mr-2" 
          :class="[!hideSaveBtn ? 'd-none': '']">
          Close
        </button>
        </div>
    </form>
   </el-dialog> 
   <FormTabs
    :current-tab="currentTab"
    :tabs="tabs"
    class="pl-3"
    :allErrors="errors"
    @on-change-tab="onChangeTab"
  />
    <div v-show="currentTab == 'tab1'" class="container mt-2 mx-0">
      <div>
        <el-transfer
        class="pl-1 pt-3"
        v-if="currentProject && transferData"
        :titles="['Portfolio Groups','My Program Groups']"
        v-model="transferData"
        :data="generateData">
      </el-transfer>

      </div>
    </div>
      <div v-show="currentTab == 'tab2'" class="container mt-2 mx-0">
   <div
    v-loading="!contentLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)"
    class=""
  > 
  <el-table 
   v-if="tableData"
   :header-cell-style="{ background: '#EDEDED' }"
   :data="tableData.filter(data => !search || data.name.toLowerCase().includes(search.toLowerCase())).reverse()" 
   style="width: 100%"  height="475"
   >
    <el-table-column type="expand">
      <template slot-scope="props">
       <div class="container">
       <div class="row">
     
      <div class="col">
       <h5 class="mh-orange-text"> Projects 
         <span 
         v-if="props.row.facilities && props.row.facilities.length"
          class="badge badge-secondary badge-pill pill"
          >{{ props.row.facilities.length }}
        </span>
         <span 
          v-else
          class="badge badge-secondary badge-pill pill"
          >{{ 0 }}
        </span>    
        </h5>
        <ul class="pl-3">
          <li v-for="item, i in props.row.facilities" :key="i">
              {{ item.facilityName }}
          </li>
        </ul>
       </div>        
        <div class="col" v-if="groupContracts">
        <h5 class="mh-orange-text"> Contracts
          <span  
          v-if="groupContracts && groupContracts.map(t => t.facilityGroupId).filter(t => t == props.row.id).length"   
            class="badge badge-secondary badge-pill pill"
            >{{ groupContracts.map(t => t.facilityGroupId).filter(t => t == props.row.id).length }}
            
          </span>
            <span 
            v-else
            class="badge badge-secondary badge-pill pill"
            >{{ 0 }}
          </span>
          </h5>
        <ul class="pl-3">
            <li v-for="item, i in groupContracts.filter(t => t.facilityGroupId == props.row.id)" :key="i" >
              {{ item.nickname }} 
            </li>
          </ul>

        </div>
       </div>
       </div>
      
      </template>
    </el-table-column>
    <el-table-column prop="name" sortable label="Groups">
    <template slot-scope="props">
    {{props.row.name}}  
      <span class="ml-5 mr-2" v-if="props.row.facilities && props.row.facilities.length">
        <i class="fal fa-clipboard-list mr-1 mh-green-text"></i>{{ props.row.facilities.length }} 
        </span> 
          <span class="ml-5 mr-2" v-else>
        <i class="fal fa-clipboard-list mr-1 mh-green-text"></i>{{0}}
        </span> 
    <span v-if="groupContracts && groupContracts.map(t => t.facilityGroupId).filter(t => t == props.row.id).length" >
      <i class="far fa-file-contract mr-1 mh-orange-text"></i>{{  groupContracts.map(t => t.facilityGroupId).filter(t => t == props.row.id).length  }}
    </span>
        <span  v-else>
        <i class="far fa-file-contract mr-1 mh-orange-text"></i>{{0}}
        </span> 
    </template>
    </el-table-column>  
      <el-table-column
      align="right">
      <template slot="header" slot-scope="scope">
        <el-input
          v-model="search"
          class="groupSearch"
          placeholder="Search Group names"/>
      </template>
         </el-table-column>
   </el-table>   
  
   </div> 
 
      </div>
    </div> 
     <!-- <div class="col-md-8" > -->
       <!-- <div class="right-panel">
       
       </div> -->
    <!-- </div> -->
  </div>
  </div>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
import SettingsSidebar from "./SettingsSidebar.vue";
import FormTabs from "../../shared/FormTabs.vue"
export default {
  name: "SettingsGroups",
  components: {
    SettingsSidebar,
    FormTabs
  },
    data() {    
      return {
        currentFacility: {},
        dialogVisible: false,
        currentTab: "tab1",
      tabs: [
        {
          label: "MANAGE GROUPS",
          key: "tab1",
          closable: false,
        },
        {
          label: "TABLE",
          key: "tab2",
          closable: false,
        },
       ],
        contracts: null,
        currentFacilityGroup: {},
        newGroupName: null,
        programId: this.$route.params.programId,
        hideSaveBtn: false,
        search:'',
        selectedProjectGroup: null, 
        expanded: {
          id: "",
       },
      };
  },
  methods: {
   ...mapMutations(['setProjectGroupFilter', 'setContractTable','setGroupFilter', 'SET_GROUP_STATUS', 'SET_TRANSFER_DATA']), 
   ...mapActions(["createGroup", "fetchFacilityGroups", "updateGroup"]),
   addAnotherGroup() {
      this.C_projectGroupFilter = null;
      this.newGroupName = null;
      this.hideSaveBtn = false;  
    },
    closeAddGroupBtn() {
      this.dialogVisible = false;
      this.hideSaveBtn = false;
    },
    addGroup(){     
      this.dialogVisible = true;    
      this.newGroupName = null;
      this.C_projectGroupFilter = null;     
    },
    onChangeTab(tab) {
      this.currentTab = tab ? tab.key : "tab1";     
    },
    saveGroup() {
        let groupData = {
          group: {
            name: this.newGroupName,
            project_id: this.$route.params.programId,
            status: 'active',
          }
        }
         this.createGroup({
            ...groupData,
          })         
          this.hideSaveBtn = true;
          // this.fetchFacilityGroups()
        
    },
    handleClick(tab, event) {
        // console.log(tab, event);
    },
   
  },

  computed: {
    ...mapGetters([
      "contentLoaded",
      "facilities",
      "groups",
      "groupStatus",
      "getTransferData",
      'getContractTable',
      'getGroupFilter',
      'getProjectGroupFilter',
      "facilityGroupFacilities",
      'facilityGroups',
      'currentProject'
    ]), 
   backToSettings(){
     return `/programs/${this.$route.params.programId}/settings`  
    },

    generateData(){
      const data = [];
      if(this.facilityGroups && this.facilityGroups.length > 0){
        let eachGroup = this.facilityGroups.map(g => g)
       for (let i = 0; i <= this.facilityGroups.length; i++) {
          if (eachGroup[i] !== undefined) {
           data.push({
            key: eachGroup[i].id,
            label: eachGroup[i].name,  
            disabled: eachGroup[i].projectId == this.$route.params.programId     
            });
           }           
         }
         return data;
        }     
      },
     C_groupFilter: {
      get() {
        return this.getGroupFilter;
      },
      set(value) {
        // console.log(value)
        this.setGroupFilter(value);
      },
    },
    tableData() {
      if (
        // this.projectsLoaded &&
        this.facilityGroups &&
         this.facilityGroups.length > 0
      ) {
        return this.facilityGroups
      }
    },
    myProgramGroups(){
      const data = this.getTransferData;
      if (this.facilityGroups && this.facilityGroups.length > 0) {
        let myGroups = this.facilityGroups.filter(t => t.projectId == this.$route.params.programId)
       
       for (let i = 0; i <= myGroups.length; i++) {
          if (myGroups[i] !== undefined) {
              data.push(myGroups[i].id);
           }           
         }
       return data;
     }
    },
    transferData: {
      get() {      
        return this.myProgramGroups     
      },
      set(value) {
        console.log(`transferData setter value: ${value}`)
        this.SET_TRANSFER_DATA(value);
      },
    },
    groupContracts(){
       if (
        this.currentProject &&
         this.currentProject.contracts &&
          this.currentProject.contracts.length > 0
      ) {
        return this.currentProject.contracts
        }
    },  
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
    groupStatus: {
      handler() {
        if (this.groupStatus == 200) {
          this.$message({
            message: `${this.newGroupName} was saved successfully.`,
            type: "success",
            showClose: true,
          });
          // this.SET_GROUP_STATUS(0);
          this.fetchFacilityGroups(); 
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
}
/deep/.el-table {
  font-size: 16px;
}
/deep/.hover-row .el-input .el-input__inner{
  border-style:solid;   
}
/deep/.el-dialog {
  width:30%;
  border-top: solid 5px  #1D336F !important;
}
.container {
  margin-left: 50px;
}

// Move el-transfer styles to Common file if more files require same CSS
/deep/.el-transfer-panel{
  width: 400px;
}
/deep/.el-transfer-panel__header {
  font-size: 1.5rem;
  text-transform: uppercase;
  font-weight: 600 !important;
}
/deep/.el-transfer-panel__body {
  min-height: 400px ;
}
/deep/.el-transfer-panel__list {
  height: 425px;
}
/deep/.el-checkbox__input.is-disabled+span.el-checkbox__label {
    color: #1D336F !important;
    cursor: default;
}
/deep/.el-transfer-panel .el-transfer-panel__header {
  background-color: #ededed;
}
/deep/.el-table { 
  ::placeholder {
    /* Chrome, Firefox, Opera, Safari 10.1+ */
  color: lightgray;
  font-family: 'FuturaPTBook';
  }
}
 

// :-ms-input-placeholder { /* Internet Explorer 10-11 */
//   color: red;
// }

// ::-ms-input-placeholder { /* Microsoft Edge */
//   color: red;
// }



</style>