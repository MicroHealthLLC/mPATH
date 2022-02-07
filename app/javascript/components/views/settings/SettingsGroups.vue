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
    <div class="col-6">
    <el-button @click.prevent="addGroup" class="bg-primary text-light mb-2"> 
    <i class="far fa-plus-circle mr-1"></i> Create New Group
    </el-button>
    <el-button @click.prevent="openPortfolioGroup" class="bg-success text-light mb-2"> 
    <i class="far fa-plus-circle mr-1"></i> Add Portfolio Group
    </el-button>
    </div>    
     <div class="col-6" >     
        <el-input
          type="search"          
          placeholder="Search Groups"
          aria-label="Search"            
          aria-describedby="search-addon"    
          v-model="search"
          data-cy=""
      >
        <el-button slot="prepend" icon="el-icon-search"></el-button>
      </el-input>  
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
          @click.prevent="createNewGroup"
          :disabled="!newGroupName"  
          class="btn btn-sm bg-primary text-light mr-2" 
          v-tooltip="`Save`"
          :class="[hideSaveBtn ? 'd-none': '']">
        <i class="fal fa-save mr-2"></i>
       </button>       
        <button 
          @click.prevent="addAnotherGroup" 
          :class="[!hideSaveBtn ? 'd-none': '']" 
          class="btn btn-sm bg-primary text-light mr-2">
          <i class="far fa-plus-circle mr-1"></i> Add Another Group
        </button>
        <button 
          @click.prevent="closeAddGroupBtn" 
          v-tooltip="`Close`"
          class="btn btn-sm bg-danger text-light mr-2" 
          :class="[!hideSaveBtn ? 'd-none': '']">
        <i class="fal fa-window-close"></i>
        </button>
        </div>
    </form>
   </el-dialog> 
    <el-dialog :visible.sync="dialog2Visible" append-to-body center class="portfolioNames p-0" v-if="groups && groups.length > 0">

   <div>
    <template >
    <div class="sticky">
      <el-button-group>
        <el-button 
          class="confirm-save-group-names btn text-light" 
          v-tooltip="`Save Group(s)`"
          @click.prevent="importGroupName" 
          :disabled="portfolioGroups.length <= 0">
        <i class="fal fa-save"></i>
        </el-button>
        <el-button
          @click.prevent="closeImportGroupBtn" 
           v-tooltip="`Close`"
          class="btn mh-blue text-light" >
        <i class="fal fa-window-close"></i>
        </el-button>
      </el-button-group>
    </div>
    </template>
        <el-checkbox :indeterminate="isIndeterminate" v-model="checkAll" @change="handleCheckAllChange"><i>Check all Groups</i></el-checkbox>
  <div style="margin: 15px 0;"></div>
  <el-checkbox-group v-model="checkedPortfolioGroups"> 
  <div class="row">
    <div class="col-4">
      <el-checkbox v-for="group in portfolioGroups" :label="group.id" :key="group.id">{{ group.name }}</el-checkbox>
    </div>
  </div>
  </el-checkbox-group>
   </div>
    
   </el-dialog> 
     <div class="container-fluid mt-2 mx-0">
   <div
    v-loading="!contentLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)"
    class="mt-4"
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
           v-if="groupProjects && groupProjects.map(t => t.facilityGroupId).filter(t => t == props.row.id).length  > 0"
            class="badge badge-secondary badge-pill pill"
            >{{ groupProjects && groupProjects.map(t => t.facilityGroupId).filter(t => t == props.row.id).length }}
          </span>
            <span 
            v-else
            class="badge badge-secondary badge-pill pill"
            >{{ 0 }}
          </span>
          </h5>
        <span v-if="groupProjects">
        <ul class="pl-3" v-for="item, i in groupProjects.filter(t => t.facilityGroupId == props.row.id)" :key="i"   >
            <li> 
              {{ item.facilityName }} 
            </li>
          </ul>
          </span>
       </div>        
        <div class="col" >
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
          <span v-if="groupContracts">
        <ul class="pl-3">
            <li v-for="item, i in groupContracts.filter(t => t.facilityGroupId == props.row.id)" :key="i" >
              {{ item.nickname  }} 
            </li>
          </ul>
          </span>
        </div>
       </div>
       </div>
      
      </template>
    </el-table-column>
    <el-table-column prop="name" sortable label="Groups">
    <template slot-scope="props">
   

<div class="row">
  <div class="col-9">

  <el-input size="small"
    v-if="rowId == props.row.id"
    style="text-align:center"
    v-model="props.row.name" controls-position="right">
  </el-input>
  <span v-else> {{ props.row.name }}</span>
</div>
</div>  
    </template>
    </el-table-column>  
      <el-table-column
      label="Counts"
     >
  <template slot-scope="props">
     <div class="row">

<div class="col">
  <i class="fal fa-clipboard-list mr-1 mh-green-text" v-tooltip="`Projects`"></i>
   <span class="mr-4"  v-if="groupProjects && groupProjects.map(t => t.facilityGroupId).filter(t => t == props.row.id).length">
  {{  groupProjects && groupProjects.map(t => t.facilityGroupId).filter(t => t == props.row.id).length }} 
  </span> 
  <span class="mr-4" v-else>
  {{0}}
  </span> 
   <i class="far fa-file-contract mr-1 mh-orange-text" v-tooltip="`Contracts`"></i>
   <span v-if="groupContracts && groupContracts.map(t => t.facilityGroupId).filter(t => t == props.row.id).length" >
     {{  groupContracts.map(t => t.facilityGroupId).filter(t => t == props.row.id).length  }}
    </span>
    <span  v-else>
    {{0}}
    </span> 
</div>
</div>
  </template>
   </el-table-column>

     <el-table-column label="Actions" >
      <template slot-scope="scope" >
      <el-button 
        type="default" 
        v-tooltip="`Save`"
        @click.prevent="saveEdits(scope.$index, scope.row)"  
        v-if="scope.$index == rowIndex" 
        class="bg-primary text-light">
        <i class="far fa-save"></i>
        </el-button>
         <el-button 
        type="default" 
        v-tooltip="`Cancel Edit`"       
        v-if="scope.$index == rowIndex" 
        @click.prevent="cancelEdits(scope.$index, scope.row)"  
        class="bg-secondary text-light">
      <i class="fas fa-ban"></i>
        </el-button>
      <el-button  
        type="default" 
        v-tooltip="`Edit Group Name`"
        @click.prevent="editMode(scope.$index, scope.row)" 
        v-if="scope.$index !== rowIndex" 
        class="bg-light">
        <i class="fal fa-edit text-primary" ></i>
          </el-button> 
        <el-button  
        type="default" 
        v-tooltip="`Remove Group`"
        @click.prevent="removeGroup(scope.$index, scope.row)" 
        v-if="scope.$index !== rowIndex" 
        class="bg-light">
         <i class="far fa-trash-alt text-danger"></i>
          </el-button> 
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

// List of all Portfolio Groups (Just the names) this.groups  ---DONE
// Button for Add Protfolio Groups  --DONE
// Filter out Groups that were created at Program Level -- DONE
// If I click on group, it saves the names to Program table and Portfolio Group stays checked
// It will not contain groups that were created in Program -- DONE
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
        // checkAll: false,
        // checkedCities: ['Shanghai', 'Beijing'],
        isIndeterminate: true,
        dialogVisible: false,
        dialog2Visible: false,
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
        componentKey: 0,
        confirmTransfer: false,
        rowIndex: null,
        rowId: null,
        transferGroupBack: null,
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
   ...mapMutations([
     'setProjectGroupFilter', 
     'setContractTable',
     'setGroupFilter', 
     'SET_GROUP_STATUS', 
     'SET_TRANSFER_DATA', 
     'SET_NEW_GROUPS', 
     'SET_CHECKED_PORTFOLIO_GROUPS',
     "SET_CHECK_ALL",
     "SET_CHECKED_GROUPS"
     ]), 
   ...mapActions(["createGroup", "fetchFacilityGroups", "updateGroupName","updateGroup", "fetchGroups", "fetchCurrentProject"]),

   addAnotherGroup() {
      this.C_projectGroupFilter = null;
      this.newGroupName = null;
      this.hideSaveBtn = false;  
    },
     handleCheckAllChange() {
      //  if (this.groups && this.groups.length > 0) {
      //     let checkGroups = this.groups.map(group => group.id)
      //     if(val){
      //       this.SET_CHECKED_GROUPS(checkGroups);
      //     }         
          this.isIndeterminate = false;
      //  }
       
      },
    reRenderTable() {
      this.componentKey += 1;
    },  
    closeAddGroupBtn() {
      this.dialogVisible = false;
      this.hideSaveBtn = false;
    },
    editMode(index, rows) {
      this.rowIndex = index
      this.rowId = rows.id
    },
    closeImportGroupBtn() {
      this.dialog2Visible = false;
      this.SET_CHECKED_PORTFOLIO_GROUPS([0])
    },
    addGroup(){     
      this.dialogVisible = true;    
      this.newGroupName = null;
      this.C_projectGroupFilter = null;     
    },
   openPortfolioGroup(){     
      this.dialog2Visible = true;    
      // this.newGroupName = null;
      // this.C_projectGroupFilter = null;     
    },
    onChangeTab(tab) {
      this.currentTab = tab ? tab.key : "tab1"; 
      // console.log(this.currentTab) 
    },
    saveEdits(index, rows) {
      // console.log(`index: ${index}`)
      //    console.log(rows)
        let id = rows.id;
        let groupNameData = {
            newNameData: {
            name: rows.name,
          }
     }
    this.updateGroupName({
        ...groupNameData, id
      })
       this.rowIndex = null;
       this.rowId = null;
    },
    cancelEdits(index, rows) {
       this.rowIndex = null;
       this.rowId = null;
    },
    createNewGroup() {
    let groupData = {
      group: {
        name: this.newGroupName,
        project_id: this.$route.params.programId,        
      }
     }
      this.createGroup({
        ...groupData,
      })       
      this.hideSaveBtn = true;       
    }, 
  removeGroup(index, rows) { 
    let id = [rows.id]
    let group = {    
          groupData: {
            ids: this.tableData.map(row => row.id).filter(r => !id.includes(r)),
            programId: this.$route.params.programId,           
          }
        }
      this.$confirm(`Are you sure you want to remove ${rows.name}?`, 'Confirm Remove', {
          confirmButtonText: 'Remove',
          cancelButtonText: 'Cancel',
          type: 'warning'
        }).then(() => {this.updateGroup({...group})});  
    },
  importGroupName() {
    let data = this.checkedPortfolioGroups
    if (this.facilityGroups && this.facilityGroups.length > 0){ 
        let savedGroups = this.facilityGroups.map(g => g.id)
       for (let i = 0; i <= this.facilityGroups.length; i++) {
          if (savedGroups[i] !== undefined) {
           data.push(savedGroups[i]);         
           }           
         }
     }  
     let group = {    
          groupData: {
            ids: [ ...new Set (data)],
            programId: this.$route.params.programId,           
          }
        }
  
      this.updateGroup({
        ...group,
      }) 
     this.confirmTransfer = false
    },
    handleClick(tab, event) {
        console.log(tab, event);
    },
   
  },
  mounted(){
  this.fetchGroups(this.$route.params.programId)
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "facilities",
      "groups",
      "groupStatus",
      "getNewGroups",
      "getTransferData",
      'getContractTable',
      'getGroupFilter',
      'getProjectGroupFilter',
      "facilityGroupFacilities",
      'facilityGroups',
      'currentProject',
      'getCheckedPortfolioGroups',
      "getCheckAll",
      "getCheckedGroups"
    ]), 
  // checkedGroups:{
  //   get(){
  //     return this.getCheckedGroups;
  //   },
  //   set(value){
  //     this.SET_CHECKED_GROUPS(value)
  //   }
  // },
  checkedPortfolioGroups:{
     get() {   
       return this.getCheckedPortfolioGroups;
      },
      set(value) {
      let checkedCount = value.length;

      // this.SET_CHECK_ALL(checkedCount === this.portfolioGroups.length);
      this.SET_CHECKED_PORTFOLIO_GROUPS(value);    
      this.isIndeterminate = checkedCount > 0 && checkedCount < this.portfolioGroups.length;        
      }
    },
    checkAll:{
     get() {
        return this.getCheckAll;
      },
      set(value) {
        console.log(value)
         this.SET_CHECK_ALL(value);     
         if(value == true)   {
          let checkGroups = this.groups.map(group => group.id)
          this.SET_CHECKED_PORTFOLIO_GROUPS(checkGroups)
         } else if (value == false){
            this.SET_CHECKED_PORTFOLIO_GROUPS([0])
         } 
      }       
    },
    backToSettings(){
     return `/programs/${this.$route.params.programId}/settings`  
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

     generateData(){
  
      const data = [];
      // let newGroup = [];
      let eachGroup = eachGroup = this.groups.map(g => g)
      if(this.groups && this.groups.length > 0 ){
        
       for (let i = 0; i <= this.groups.length; i++) {
          if (eachGroup[i] !== undefined) {
           data.push({
            key: eachGroup[i].id,
            label: eachGroup[i].name,  
            // disabled: eachGroup[i].id == this.inheritedGroups[i]
            });
         
           }           
         }
        
        }
      return [ ...new Set (data)];
      },

    myProgramGroups(){
      const data = this.getCheckedPortfolioGroups ;
      if (this.groups && this.groups.length > 0 ) { 
         let myInheritedGroups = this.groups.filter(t => t && t.id == data.map(t => t))   
        for (let i = 0; i <= myInheritedGroups.length; i++) {  
              if (myInheritedGroups[i] !== undefined) {    
            data.push(myInheritedGroups[i].id); 
            console.log(myInheritedGroups[i]) 
              }         
         }
      }     
     
       return [...new Set(data)] 
    },
    transferData: {
      get() {     
       return [...new Set(this.myProgramGroups)]          
      },
      set(value) {
        this.SET_TRANSFER_DATA(value);
         if (
        this.groups &&        
         this.groups.length > 0 
        //  this.getTransferData && 
        //  this.getTransferData.length > 0
         )
         {     
        let newGroups = this.groups.filter(u => this.getTransferData.includes(u.id))
        this.SET_NEW_GROUPS([newGroups])
         }
      },
    },
   portfolioGroups() {
     //Removes current Program  Groups from checkbox options in Add Protfolio Group popup
     if (this.groups && this.groups.length > 0){ 
          return this.groups.filter(pG => !this.tableData.map(g => g.id).includes(pG.id))
       }
     },
     tableData() {
       if (
        this.facilityGroups &&        
         this.facilityGroups.length > 0
    
         ){
           return this.facilityGroups
         } else return []

     },
    groupProjects(){
       if (
        this.facilities &&
         this.facilities.length && 
         this.facilities.length > 0
      ) {
        return this.facilities
        }
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
            message: `Saved successfully.`,
            type: "success",
            showClose: true,
          });
          this.SET_GROUP_STATUS(0);
          this.fetchGroups(this.$route.params.programId);
          this.fetchCurrentProject(this.$route.params.programId) 
          //  this.newGroupName =
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
  padding-bottom:30px;
}
/deep/.el-transfer-panel__header {
  font-size: 1.5rem;
  text-transform: uppercase;
  font-weight: 600 !important;
}
/deep/.el-transfer-panel__body {
  min-height: 400px ;
  margin-bottom: 30px;
}
/deep/.el-transfer-panel__list {
  min-height: 425px;
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
/deep/.el-input__inner {
  font-size: 1.1rem;
}

/deep/.el-button.confirm-save-group-names {
background-color: rgba(40, 167, 69, 1);
}

label.el-checkbox {
  margin-top: 15px;
}

div.sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 0;
  text-align: right;
  padding-top: 10px;
}
 

.portfolioNames {
/deep/.el-dialog__header {
padding-top: 0 !important;
}
/deep/.el-dialog__headerbtn {display: none;}

/deep/.el-dialog__body {
padding-top: 0 !important;
 }
}

// :-ms-input-placeholder { /* Internet Explorer 10-11 */
//   color: red;
// }

// ::-ms-input-placeholder { /* Microsoft Edge */
//   color: red;
// }



</style>