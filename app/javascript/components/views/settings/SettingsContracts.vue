<template>
  <div 
   class="row"
  >
    <div class="col-md-2">
      <SettingsSidebar />
    </div>
    <div class="col-md-10">
      <div class="right-panel">
        <el-breadcrumb separator-class="el-icon-arrow-right" class="mt-3 mb-4">
          <el-breadcrumb-item :to="backToSettings">
            <span style="cursor:pointer"
              ><i class="far fa-cog mr-1"></i> PROGRAM SETTINGS
            </span>
          </el-breadcrumb-item>
          <h4 class="mt-4 ml-3">
            <i class="far fa-file-contract ml-2 mr-1 mh-orange-text"></i>
            CONTRACTS
            <span
              v-if="tableData && tableData.length"
              class="ml-2 pb-1 badge badge-secondary badge-pill pill"
              >{{ tableData.length }}
            </span>
            <span v-else class="ml-2 pb-1 badge badge-secondary badge-pill pill"
              >{{ 0 }}
            </span>
          </h4>
        </el-breadcrumb>
        <div class="my-1 pb-2 buttonWrapper container-fluid">
          <div class="row px-0">
            <div class="col" v-if="_isallowedProgramSettings('write')">
              <el-button
                @click.prevent="addContract"
                class="bg-primary text-light mb-2"
              >
                <i class="far fa-plus-circle mr-1"></i> Create Contract
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
                  v-for="item in groupList"
                  :key="item.id"
                  :label="item.name"
                  :value="item"
                >
                </el-option>
              </el-select>
            </div>
          </div>
        </div>
        <div       
        v-loading="!contentLoaded"
        element-loading-text="Fetching your data. Please wait..."
        element-loading-spinner="el-icon-loading"
        element-loading-background="rgba(0, 0, 0, 0.8)" 
        class=""
        >
          <el-table
            v-if="tableData && _isallowedProgramSettings('read')"    
            :data="
              tableData
                .filter(
                  (data) =>
                    !search ||
                    data.nickname.toLowerCase().includes(search.toLowerCase())
                )
                .reverse()
            "
            style="width: 100%"
            highlight-current-row
            height="450"
            ref="table"
            :row-key="row => row.id"
            :expand-row-keys="expandRowKeys"
		      	@expand-change="handleExpandChange" 
            :default-sort="{ prop: 'nickname', order: 'ascending'}"        
          >
            <el-table-column prop="nickname" sortable label="Contract">
              <template slot-scope="scope">
                <el-input
                  size="small"
                  v-if="rowId == scope.row.id"
                  style="text-align:center"
                  v-model="scope.row.nickname"
                  controls-position="right"
                >
                </el-input>
                <span v-else> {{ scope.row.nickname }}</span>
              </template>
            </el-table-column>
            <el-table-column
              sortable
	      filterable
              label="Group"
            >
              <template slot-scope="scope">

                <el-select
                v-model="scope.row.facilityGroupId"
                class="w-100"
                v-if="rowId == scope.row.id"
                filterable
                track-by="id"
                value-key="id"
                placeholder="Search and select Group"
                >
                <el-option
                  v-for="item in facilityGroups"
                  :value="item.id"
                  :key="item.id"
                  :label="item.name"
                >
                </el-option>
              </el-select>        
            <span v-else>
          {{ facilityGroups.find((c) => c.id == scope.row.facilityGroupId).name }}

            </span>

              </template>
            </el-table-column>
  <!--BEGIN Expandable Column Containing Contract User roles -->
      <el-table-column label="Users" width="100" type="expand">
        <template slot-scope="scope">
        <div class="container-fluid p-2">

             <div class="pl-4 mt-0 row">
            <div class="col-5 pt-0">
             <label class="font-md mb-0 d-flex">Add User(s) To Project </label>
             <el-select
              v-model="contractRoleUsers"
              filterable           
              class="w-100"
              clearable
              track-by="id"
              value-key="id"
              placeholder="Search and select Project Users"          
            >
              <el-option
                v-for="item in programUsers"
                :value="item"
                :key="item.id"
                :label="item.fullName"
              >
              </el-option>
            </el-select>
              </div>
           <div class="col-5 pt-0">
              <label class="font-md mb-0 d-flex">Select Role for User(s) </label>
             <el-select
              v-model="contractRoleNames"
              filterable           
              class="w-100"
              clearable
              track-by="id"
              value-key="id"
              placeholder="Search and select Project Users"          
            >
              <el-option
                v-for="item in getRoles.filter(t => t.type_of == 'contracts')"
                :value="item"
                :key="item.id"
                :label="item.name"
              >
              </el-option>
            </el-select>
          
             
              </div>
                <div class="col-2 pt-0">
              <label class="font-md mb-0 d-flex" style="visibility:hidden">|</label>
                              
                <el-button
                type="default"
                @click="saveContractUserRole()"
                v-if="contractRoleNames && contractRoleUsers"
                v-tooltip="`Confirm`" 
                class="bg-primary btn-sm text-light mr-2">               
                <i class="fa-solid fa-user-unlock mr-1"></i>Confirm
               </el-button>
      
              </div>

              
             
            </div>
      
      <div class="mt-2 row">
        <div class="col-10 pt-0">
 
        <el-collapse id="" class="" v-if="contractUsers && contractUsers.length > 0">
            <el-collapse-item title="SEE PROJECT'S USERS AND ROLES" name="1">
          <el-table
            v-if="contractUsers && contractUsers.length > 0"
            :header-cell-style="{ background: '#EDEDED' }"
            :data="contractUsers.filter(
                  (data) =>
                    !searchRoleUsers || 
                    data.role_name.toLowerCase().includes(searchRoleUsers.toLowerCase()) ||
                    data.user_full_name.toLowerCase().includes(searchRoleUsers.toLowerCase())
                )"           
            height="450"
            width="auto"
            class="px-4"
            > 
           <el-table-column  prop="user_full_name"
              sortable
              filterable
              label="Users">
              <template slot-scope="scope">
              <span v-if="projId && projId == scope.row.facility_id">
                {{ scope.row.user_full_name }}
                  <!-- {{ scope.row.role_id}} -->          
              </span>
              </template>

            </el-table-column>
            <el-table-column  prop="role_name"
              sortable
              filterable
              label="Roles">
              <template slot-scope="scope">
              <span v-if="projId && projId == scope.row.facility_id && scope.row.role_name">
                  {{ scope.row.role_name }}  
               <!-- <el-select
              v-model="scope.row.role_name"
              filterable
              multiple
              class="w-70"
              clearable
              track-by="id"
              value-key="id"
              placeholder="Search and select Project Roles"          
            > -->
             <!-- <el-option
                v-for="item in projectUsers"
                :value="item"
                :key="item.id"
                :label="item.role_name"
              > 
              </el-option> -->
            <!-- </el-select>  -->
            
              </span>
              </template>

            </el-table-column>

    <el-table-column
  
        align="right">
        <template slot="header" slot-scope="scope">
          <el-input
            v-model="searchRoleUsers"
            size="mini"
            placeholder="Enter User or Role Name"/>
        </template>
        <!-- <template slot-scope="scope">
          <el-button
            size="mini"
            @click="handleEdit(scope.$index, scope.row)">Edit</el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.$index, scope.row)">Delete</el-button>
        </template> -->
      </el-table-column>
        
          </el-table> 
         </el-collapse-item>
        </el-collapse> 
        </div>
      </div>
          </div>
         </template>


         </el-table-column>
           <!--END Expandable Column Containing Contract User roles -->


            <el-table-column label="Actions" align="right">
              <template slot-scope="scope">
                <el-button
                  type="default"
                  v-if="
                    scope.$index == rowIndex &&
                      _isallowedProgramSettings('write')
                  "
                  @click.prevent="saveEdits(scope.$index, scope.row)"
                  v-tooltip="`Save`"
                  class="bg-primary btn-sm text-light"
                >
                  <i class="far fa-save"></i>
                </el-button>
                <el-button
                  type="default"
                  v-tooltip="`Cancel Edit`"
                  v-if="
                    scope.$index == rowIndex &&
                      _isallowedProgramSettings('write')
                  "
                  @click.prevent="cancelEdits(scope.$index, scope.row)"
                  class="bg-secondary btn-sm text-light"
                >
                  <i class="fas fa-ban"></i>
                </el-button>
                <el-button
                  type="default"
                  v-tooltip="`Edit Contract Name or Change Group`"
                  @click.prevent="editMode(scope.$index, scope.row)"
                  v-if="
                    scope.$index !== rowIndex &&
                      _isallowedProgramSettings('write')
                  "
                  class="bg-light btn-sm"
                >
                  <i class="fal fa-edit text-primary"></i>
                </el-button>
                 <!-- <el-button
                  type="default"
                  v-tooltip="`See Contract Users`"
                  v-if="scope.$index !== rowIndex"
                  @click.prevent="openUserPrivileges(scope.$index, scope.row)"
                  class="bg-light"
                >
                   <i class="fas fa-users mr-1"></i>
                </el-button> -->

                <el-button
                  v-if="_isallowedProgramSettings('delete') && scope.$index !== rowIndex"
                  type="default"
                  v-tooltip="`Delete Contract`"
                  @click.prevent="
                    deleteSelectedContract(scope.$index, scope.row)
                  "
                  class="bg-light btn-sm"
                >
                  <i class="far fa-trash-alt text-danger"></i>
                </el-button>
                <el-button
                  type="default" 
                    v-tooltip="`Go To Contract`"              
                  @click.prevent="goToContract(scope.$index, scope.row)"
                  class="bg-success text-light btn-sm"
                  >
                  <i class="fas fa-arrow-alt-circle-right"></i>
                </el-button>
                <!-- <el-button type="primary" @click="handleEditRow(scope.$index)">Edit</el-button> -->
              </template>
            </el-table-column>
          </el-table>
        </div>
        <!-- <span v-else class="mt-5">
          NO DATA TO DISPLAY
        </span> -->
        <el-dialog
          :visible.sync="dialogVisible"
          append-to-body
          center
          class="contractForm addContract p-0"
        >
          <span slot="title" class="text-left add-groups-header ">
          <h5 class="text-dark"> <i class="far fa-plus-circle mr-1 mb-3"></i>Create Contract </h5>
        </span>
          <form accept-charset="UTF-8">
            <div class="form-group mx-3">
              <label class="font-md"
                >Contract Name <span style="color: #dc3545">*</span></label
              >
              <el-input            
                v-model="contractNameText"
                placeholder="Enter New Contract Name"
                rows="1"
                name="Program Name"
              />
            </div>
            <div class="form-group mx-3">
              <label class="font-md"
                >Contract Nickname <span style="color: #dc3545">*</span></label
              >
              <el-input              
                v-model="contractNicknameText"
                placeholder="Enter New Contract Nickname"
                rows="1"
                name="Program Name"
              />
            </div>
            <div class="form-group mx-3">
              <label class="font-md">Group</label>
              <el-select
                class="w-100"
                v-model="C_newContractGroupFilter"
                track-by="id"
                value-key="id"
                clearable
                filterable
                name="Project Group"
                placeholder="Search and select Group"
              >
                <el-option
                  v-for="item in groupList"
                  :key="item.id"
                  :label="item.name"
                  :value="item"
                >
                </el-option>
              </el-select>
            </div>
            <div class="right mr-2">
              <button
                @click.prevent="saveNewContract"
                v-if="contractNameText && contractNicknameText"
                class="btn btn-md bg-primary text-light modalBtns"
                v-tooltip="`Save Contract`"
                :class="[hideSaveBtn ? 'd-none' : '']"
              >
               <i class="far fa-save"></i>
              </button>
              <button
                @click.prevent="addAnotherContract"
                :class="[!hideSaveBtn ? 'd-none' : '']"
                v-tooltip="`Add Another Contract`"
                class="btn btn-md bg-primary text-light modalBtns"
              >
                <i class="far fa-plus-circle"></i> 
              </button>
              <button
                @click.prevent="closeAddContractBtn"
                 class="btn btn-md bg-secondary text-light modalBtns"
                v-tooltip="`Close`"                    
              >
             <i class="fas fa-ban"></i> 
              </button>
            </div>
          </form>
        </el-dialog>
      </div>

      <el-dialog
          :visible.sync="openUserPrivilegesDialog"
          append-to-body
          center
          class="contractUsers"
          id="contractUsers p-0"
        >
   
        </el-dialog>
    </div>
  </div>
</template>

<script>
//PRIVILEGES FEATURE REQUIREMENTS

//I want to see a column for roles
//When I click on that column row, row expands to show users of that contract, as well as the roles of the users
//




import { mapGetters, mapMutations, mapActions } from "vuex";
import SettingsSidebar from "./SettingsSidebar.vue";
// import { createUser, deleteUser, dbCollection } from "../../../packs/firebase";
export default {
  name: "SettingsContracts",
  components: {
    SettingsSidebar,
  },
  data() {
    return {
      expandRowKeys: [],
      currentFacility: {},
      // currentContract: {},
      dialogVisible: false,
      openUserPrivilegesDialog: false, 
      contractData: {},
      currentFacilityGroup: {},
      rowIndex: null,
      rowId: null,
      projId: null, 
      projectNameText: "",
      searchRoleUsers: '',
      search: "",
      searchContractUsers:"",
      hideSaveBtn: false,
      contractNameText: "",
      contractNicknameText: "",
      expanded: {
        id: "",
      },    
    };
  },
  mounted() {
    if(this.contracts[0] && this.contracts[0].length <= 0){
    this.fetchContracts();
    }  
    this.fetchRoles(this.$route.params.programId)
    if(this.groups && this.groups.length <= 0){
    this.fetchGroups(this.$route.params.programId);
    }
  },
  methods: {
    ...mapMutations([
      "setProjectGroupFilter",
      "setContractTable",
      "setGroupFilter",
      "SET_CONTRACT_STATUS",
      "setContractTypeFilter",
      "setNewContractGroupFilter",
      "SET_CONTRACT_GROUP_TYPES",
      "SET_ADD_USER_TO_ROLE_STATUS", 
      "SET_CONTRACT_ROLE_USERS",
       "SET_CONTRACT_ROLE_NAMES"   
    ]),
    ...mapActions([
      "fetchCurrentProject",
      "createContract",
      "fetchContracts",
      "fetchGroups",
      "updateContract",
      "deleteContract",
      "addUserToRole", 
      "fetchRoles"
    ]),
    _isallowedProgramSettings(salut) {
      let pPrivilege = this.$programSettingPrivileges[
        this.$route.params.programId
      ];
      let permissionHash = { write: "W", read: "R", delete: "D" };
      let s = permissionHash[salut];
      return pPrivilege.admin_contracts.includes(s);
    },
  saveContractUserRole(index, rows){
    let contractUserRoleData = {
          userData: {
            roleId: this.contractRoleNames.id,
            userId: this.contractRoleUsers.id,
            programId: this.$route.params.programId, 
            projectId: this.projId          
         },
      };
      this.addUserToRole({
        ...contractUserRoleData,
      });
    },
    goToContract(index, rows) {
      //Needs to be optimzed using router.push.  However, Project Sidebar file has logic that affects this routing
      window.location.pathname = `/programs/${this.$route.params.programId}/sheet/contracts/${rows.id}/`
      // this.$router.push({
      //   name: "SheetContract",
      //   params: {
      //     programId: this.$route.params.programId,
      //     contractId: rows.id.toString(),
      //   },
      // });
    },
	  handleExpandChange (row, expandedRows) {
			this.projId = row.id;
			const lastId = this.expandRowKeys[0];
			// disable mutiple row expanded 
			this.expandRowKeys = this.projId  === lastId ? [] : [this.projId];   
		},
    saveNewContract() {
      let groupId = ""
      if (this.C_newContractGroupFilter){
        groupId = this.C_newContractGroupFilter.id
      } 
      let contractData = {
        contract: {
          nickname: this.contractNicknameText,
          name: this.contractNameText,
          facility_group_id: groupId,
          project_id: this.$route.params.programId,
          contract_type_id: this.C_typeFilter,
        },
      };
      this.createContract({
        ...contractData,
      });
      this.hideSaveBtn = true;
      this.fetchCurrentProject(this.$route.params.programId);
      // console.log(contractData)
    },
    // DO NOT DELETE This async method.  It is code for firebase cloud functionality
    //  async onSubmit ()  {
    //      const formData = {
    //         contractName: this.contractNameText,
    //         programName: this.currentProject.name,
    //         mpathInstance: this.$mpath_instance

    //       }
    //     await createUser({...formData})
    //     return { formData }
    //  }

    saveEdits(index, rows) {
      // console.log(rows)
      let id = rows.id;
      let contractData = {
        contract: {
          nickname: rows.nickname,
          name: rows.name,
          facility_group_id: rows.facilityGroupId,
          project_id: this.$route.params.programId,
          id: id,
        },
      };
      // this.setNewContractGroupFilter(rows.facility_group_id);
      this.updateContract({
        ...contractData,
        id,
      });
      this.rowIndex = null;
      this.rowId = null;
    },
    cancelEdits(index, rows) {
      this.rowIndex = null;
      this.rowId = null;
    },
    editMode(index, rows) {
      this.rowIndex = index;
      this.rowId = rows.id;
    },
    deleteSelectedContract(index, rows) {
      let id = rows.id;
      this.$confirm(
        `Are you sure you want to delete ${rows.nickname}?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: "warning",
        }
      ).then(() => {
        this.deleteContract(id).then((value) => {
          if (value === 200) {
            this.fetchContracts();
            this.$message({
              message: `${rows.nickname} was deleted successfully.`,
              type: "success",
              showClose: true,
            });
          }
        });
      });
    },
    addAnotherContract() {
      this.C_newContractGroupFilter = null;
      this.contractNameText = "";
      this.contractNicknameText = "";
      this.hideSaveBtn = false;
    },
    closeAddContractBtn() {
      this.dialogVisible = false;
      this.hideSaveBtn = false;
    },
    addContract() {
      this.dialogVisible = true;
      this.C_newContractGroupFilter = null;
      this.contractNameText = "";
      this.contractNicknameText = "";
    },
    openUserPrivileges(index, rows) {
      this.openUserPrivilegesDialog = true;
      this.contractData = rows
      // this.C_projectGroupFilter = null;
      // this.contractNameText = "";
      // this.contractNicknameText = "";
    },
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "contractsLoaded",
      "getContractGroupTypes",
      "getNewContractGroupFilter",
      "contractStatus",
      "contracts",
      "groups",
      "getRoles",
      "addUserToRoleStatus",
      "getContractRoleUsers",
      "getContractRoleNames",
      "getTransferData",
      "getContractTable",
      "getProjectGroupFilter",
      "getGroupFilter",
      "getNewGroups",
      "facilityGroups",
      "currentProject",
    ]),
    backToSettings() {
      return `/programs/${this.$route.params.programId}/settings`;
    },
    tableData() {
      if (this.currentProject && this.currentProject.contracts.length > 0 && this.facilityGroups) {
        let groups = this.facilityGroups.map(g => g.id)
        let contracts = this.currentProject.contracts.map(cp => cp)
        let programContracts = contracts.filter((u) =>
            groups.includes(u.facilityGroupId)
        );
        let contractData = programContracts
          .map((t) => t)
          .filter((td) => {
            //  console.log(td)
            if (
              this.C_projectGroupFilter &&
              this.C_projectGroupFilter.length > 0
            ) {
              let group = this.C_projectGroupFilter.map((t) => t.id);
              return group.includes(td.facilityGroupId);
            } else return true;
          });
        return contractData;
      }
    },
    groupList() {
    if (
        this.groups &&
        this.groups.length > 0 &&
        this.facilityGroups &&
        this.facilityGroups.length > 0 
      ) {
        let programGroupIds = this.facilityGroups.map((t) => t.id);
        return this.groups.filter((u) => programGroupIds.includes(u.id));
      } else return [];
    },

    C_typeFilter: {
      get() {
        return this.getContractGroupTypes;
      },
      set(value) {
        this.SET_CONTRACT_GROUP_TYPES(value);
      },
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
    contractUsers(){
      if(this.getRoles && this.getRoles.length > 0 ){   
        let roleUsers = this.getRoles.map(t => t.role_users).filter(t => t.length > 0)   
      if (this.projId)  {
            return [].concat.apply([], roleUsers).filter(t => this.projId == t.facility_id)
        } else return [].concat.apply([], roleUsers)
       
      }
    },
    programUsers(){
      if (this.currentProject){
         if (this.currentProject.users && this.currentProject.users.length > 0){
           return this.currentProject.users.filter(t => t)
       }
      }       
    },
    contractRoleUsers: {     
     get() {
       return this.getContractRoleUsers
      },
      set(value) {
         this.SET_CONTRACT_ROLE_USERS(value)
         console.log(value)
        }      
    },
    contractRoleNames: {     
     get() {
       return this.getContractRoleNames
      },
      set(value) {
         this.SET_CONTRACT_ROLE_NAMES(value)
         console.log(value)
        }      
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
          this.fetchCurrentProject(this.$route.params.programId);
        }
      },
    },
      addUserToRoleStatus: {
      handler() {
        if (this.addUserToRoleStatus == 204) {
          this.$message({
            message: `Succesfully added user/role to project.`,
            type: "success",
            showClose: true,
          });         
          this.SET_ADD_USER_TO_ROLE_STATUS(0);
          this.fetchRoles(this.$route.params.programId)  
         this.SET_CONTRACT_ROLE_NAMES([])
          this.SET_CONTRACT_ROLE_USERS([])
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
.modalBtns {
  box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
}
/deep/.el-collapse-item__header {
  padding-left: 1.5rem;
}
.right {
  text-align: right;
}
/deep/.el-table__header, .el-table{
  width: auto !important;
}
.fa-calendar {
  font-size: x-large;
}
/deep/.el-table th.el-table__cell > .cell {
  color: #212529;
  font-size: 1.15rem;
}
.contractUsers { 
  
  /deep/.el-dialog{
 width: 60% !important; 

 /deep/.el-dialog__body {
   padding-top: 0;
 }

  }
  
}
/deep/.el-dialog.contractUsers{
 width: 60% !important; 
  }
.contractUsers{
 /deep/.el-dialog__body {
   padding-top: 0;
 }
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
/deep/.el-input__inner{
  font-weight: 300 !important;
}
/deep/.el-table__row .el-input .el-input__inner {
  border-style: none;
  font-size: 16px !important;
}
/deep/.hover-row .el-input .el-input__inner {
  border-style: solid;
}
/deep/.el-dialog.addContract {
  width: 30%;
}
.addContract {
  /deep/.el-dialog__body {
  padding-top: 0 !important;
 }
}
/deep/.el-dialog__close.el-icon.el-icon-close {
  display: none;
}

/deep/.el-table {
  .el-input__inner {
    font-size: 16px !important;
  }
}
/deep/.el-dialog__close.el-icon.el-icon-close {
  background-color: #dc3545;
  border-radius: 50%;
  color: white;
  padding: 2px;
  font-size: 0.7rem;
}
</style>
