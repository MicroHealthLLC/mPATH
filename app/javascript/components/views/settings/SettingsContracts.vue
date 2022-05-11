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
            <div class="col">
              <el-button
                v-if="_isallowed('write')"
                @click.prevent="addContract"
                class="bg-success text-light mb-2"
              >
                <i class="far fa-plus-circle mr-1"></i> Add Existing Contract(s)
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
        v-loading="!contractsLoaded"
        element-loading-text="Fetching your data. Please wait..."
        element-loading-spinner="el-icon-loading"
        element-loading-background="rgba(0, 0, 0, 0.8)" 
        class=""
         v-if="_isallowed('read')"
        >
          <el-table
            v-if="tableData"  
            :load="log(groupList)"  
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
              prop="facility_group_name"
	            filterable
              label="Group"
            >
              <template slot-scope="scope">

                <el-select
                v-model="scope.row.facility_group_id"
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
               <span v-if="scope.row.facility_group_name">
                 {{ scope.row.facility_group_name }}
               </span>
            </span>

              </template>
            </el-table-column>
           <el-table-column label="Actions" align="right">
              <template slot-scope="scope">
                <el-button
                  type="default"
                  v-tooltip="`Manage User(s)`"
                  @click.prevent="addUserRole(scope.$index, scope.row)"
                  v-if="scope.$index !== rowIndex"
                  class="bg-primary text-light btn-sm">
                    <i class="fas fa-users-medical mr-1"></i>
                </el-button>
                <el-button
                  type="default"
                  v-if="
                    scope.$index == rowIndex 
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
                    scope.$index == rowIndex
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
                    scope.$index !== rowIndex
                  "
                  class="bg-light btn-sm"
                >
                  <i class="fal fa-edit text-primary"></i>
                  </el-button>
                  <!-- <el-button
                  v-if="scope.$index !== rowIndex"
                  type="default"
                  v-tooltip="`Delete Contract`"
                  @click.prevent="
                    deleteSelectedContract(scope.$index, scope.row)
                  "
                  class="bg-light btn-sm"
                >
                  <i class="far fa-trash-alt text-danger"></i>
                </el-button> -->
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
        <div v-else class="text-danger mx-2 mt-5">
        <h5> <i>Sorry, you don't have read-permissions for this page! Please contact your Program Administrator for access.</i></h5>
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
          class="addUserRole p-0"         
        >
        <span slot="title" class="text-left add-groups-header ">
        <h5 style="color:#383838" v-if="contractData"> 
            <i class="far fa-file-contract mr-1 mb-2 mh-orange-text"></i>  {{ contractData.nickname }}
        </h5> 
        </span>
           <div class="container-fluid p-0">

             <div class="pl-3 mt-0 row">
            <div class="col-5 pt-0 pl-0">
             <label class="font-md mb-0 d-flex">Add User(s) To Contract</label>
             <el-select
              v-model="contractRoleUsers"
              filterable           
              class="w-100"
              clearable
              multiple
              track-by="id"
              value-key="id"
              placeholder="Search and select Project Users"          
            >
              <el-option
                v-for="item in viableContractUsers"
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
                v-for="item in getRoles.filter(t => t.type_of == 'contract' && t.name !== 'crud-row-contract-20220407')"
                :value="item"
                :key="item.id"
                :label="item.name"
              >
              </el-option>
            </el-select>
          
             
              </div>
                <div class="col-2 pt-0 text-right">
              <label class="font-md mb-0 d-flex" style="visibility:hidden">|</label>
                              
                <el-button
                type="default"
                @click="saveContractUserRole()"
                v-if="contractRoleNames && contractRoleUsers"
                v-tooltip="`Confirm`" 
                class="bg-primary btn-sm text-light">               
               <i class="far fa-save"></i>
               </el-button>
      
              </div>

              
             
            </div>
      
      <div class="mt-4 row">
        <div class="col-12 pt-0"> 
           <el-table
            v-loading="!getRolesLoaded"
            element-loading-spinner="el-icon-loading" 
            v-if="contractUsers && contractUsers.roleIds && contractUsers.roleIds.length > 0"
            :header-cell-style="{ background: '#EDEDED' }"
            :data="contractUsers.roleIds"   
            height="375"
            width="100%"
            > 
           <el-table-column  prop="user_full_name"
              sortable
              width="200"
              filterable
              label="Users">
              <template slot-scope="scope">
              <span v-if="contractUsers.data.map(t => t.role_id == scope.row)" >  
                 {{ contractUsers.data.filter(t => t.role_id == scope.row).map(t => t.role_name)[0] }}
                  <!-- {{ scope.row}}   -->
                </span>
              </template>

            </el-table-column>
            <el-table-column  prop="role_name"
              sortable
              width="675"
              filterable
              label="Roles">
             <template slot-scope="scope">
               <span v-if="scope.$index !== rowIndex_1" >        
              <span  v-for="(item, i) in contractUsers.data" :key="i">    
                <span v-if="(item.user_id && programUsers.map(t => t.id == item.user_id)) && item.role_id == scope.row &&                  
                  programUsers.filter(t => item.user_id == t.id).map(t => t.fullName).length > 0" class="userNames" >   
                 {{ programUsers.filter(t => item.user_id == t.id).map(t => t.fullName).join()}}                
                </span>               
              </span>
           
             </span>
             <span v-if="isEditingRoles && scope.$index == rowIndex_1" >
             <el-select
              v-model="assignedContractUsers" 
              :disabled="assignedContractUsers && assignedContractUsers.length <= 0"
              filterable                         
              class="w-100 el-popper"
              :popper-append-to-body="false"
              popper-class="select-popper"   
              clearable
              multiple
              track-by="id"
              value-key="id"
              placeholder="No Users Assigned to this Project"          
            >
              <el-option
                v-for="item in programUsers"
                :value="item"
                :key="item.id"
                :label="item.fullName"
              >
              </el-option>
            </el-select>
         
             </span>
              </template>


            </el-table-column>

       <el-table-column
        width="125"
        align="right"
      >
        <!-- <template slot="header" slot-scope="scope">
          <el-input
            v-model="searchRoleUsers"
            size="mini"
            placeholder="Enter User or Role Name"/>
        </template> -->
        <template slot-scope="scope">
           <el-button
            type="default"
            @click="saveRemoveUsers(scope.$index, scope.row)"
            v-if="isEditingRoles   && scope.$index == rowIndex_1"
            v-tooltip="`Save`" 
            class="bg-primary btn-sm text-light">               
            <i class="far fa-save"></i>
               </el-button>
          <el-button  
          type="default" 
          v-if="scope.$index !== rowIndex_1"
          v-tooltip="`Remove User(s) from Project`"
          @click.prevent="editUsers(scope.$index, scope.row)"           
          class="bg-danger text-light btn-sm">
         <i class="fal fa-user-lock mr-1 text-light"></i> 
          </el-button>  
            <el-button  
            type="default" 
            v-if="isEditingRoles && scope.$index == rowIndex_1"
            v-tooltip="`Cancel`"
            @click.prevent="cancelEditRoles(scope.$index, scope.row)"             
          class="btn btn-sm bg-secondary text-light">
            <i class="fas fa-ban"></i> 
          </el-button>  
           
        </template>
      </el-table-column>
          </el-table>     
        <span  class="" v-else>
            No Users Assigned
          </span>

          <div class="right mt-3">
          <button
          @click.prevent="closeUserRoles"
          class="btn btn-md bg-secondary text-light modalBtns"
          v-tooltip="`Close`"                  
        >
          <i class="fas fa-ban"></i> 
        </button>
            </div>   
        </div>
      </div>
          </div>
   
        </el-dialog>
    </div>
  </div>
</template>

<script>

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
      rowIndex_1: null, 
      isEditingRoles: false,
      roleRowId: null, 
      userids: null, 
      expandRowKeys: [],
      currentFacility: {},
      contractData: null, 
      // currentContract: {},
      dialogVisible: false,
      openUserPrivilegesDialog: false, 
      // contractData: {},
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
    this.fetchContracts(this.$route.params.programId);
    this.fetchRoles(this.$route.params.programId)
    // if(this.groups && this.groups.length <= 0){
    this.fetchGroups(this.$route.params.programId);
    // }
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
      "SET_CONTRACT_ROLE_NAMES",
      "SET_ASSIGNED_CONTRACT_USERS",
      "SET_REMOVE_CONTRACT_ROLE_STATUS"   
    ]),
    ...mapActions([
      "fetchCurrentProject",
      "createContract",
      "fetchContracts",
      "fetchGroups",
      "updateContract",
      "deleteContract",
      "addUserToRole", 
      "fetchRoles",
      "removeUserRole"
    ]),
    _isallowed(salut) {
        return this.checkPrivileges("SettingsContracts", salut, this.$route, {settingType: 'Contracts'})
    }, 
    log(e){
      // console.log('tableData:',  e)
    },
    editUsers(index, rowData){
      this.userids = this.contractUsers.data.filter(t => t.role_id == rowData)
      this.SET_ASSIGNED_CONTRACT_USERS(this.assignedUsers)
      this.rowIndex_1 = index;
      this.roleRowId = rowData
      this.isEditingRoles = true;
      console.log(this.userids)
    },
    saveRemoveUsers(index, rowData){     
      let user_ids = this.assignedContractUsers.map(t => t.id);
      let assigned =  this.assignedUsers.map(t => t.id);   
      let ids = assigned.filter(t => !user_ids.includes(t)); 
      let projectUserRoleData = {
                userData: {
                  roleId: rowData,
                  contractId: this.projId,
                  programId: this.$route.params.programId, 
                  userIds: ids,   
              },
            };
            // console.log(projectUserRoleData)
            this.removeUserRole({
              ...projectUserRoleData,
            });     
    },
    cancelEditRoles(index, rowData){
    this.isEditingRoles = false;
    this.roleRowId = null;
    this.rowIndex_1 = null;
    },
   saveContractUserRole(index, rows){
    let user_ids = this.contractRoleUsers.map(t => t.id)
    let contractUserRoleData = {
          userData: {
            roleId:    this.contractRoleNames.id,
            userIds:    user_ids,
            programId: this.$route.params.programId, 
            contractId: this.projId          
         },
      };
      console.log(contractUserRoleData)
      this.addUserToRole({
        ...contractUserRoleData,
      });
    },
   closeUserRoles() {
   this.openUserPrivilegesDialog = false;
    },
    addUserRole(index, rows) {
      this.openUserPrivilegesDialog = true
      this.projId = rows.id
      this.contractData = rows
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
      console.log(contractData)
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
          facility_group_id: rows.facility_group_id,
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
      alert("Add Contracts functionality under development")
    //  if(this.contracts && this.contracts.length > 0){
    //   console.log(this.contracts)
    // }
    //   this.dialogVisible = true;
    //   this.C_newContractGroupFilter = null;
    //   this.contractNameText = "";
    //   this.contractNicknameText = "";
    },
    openUserPrivileges(index, rows) {
      this.openUserPrivilegesDialog = true;
      this.contractData = rows
    },
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "getRolesLoaded",
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
       "removeContractRoleStatus",
      "currentProject",
       "getAssignedContractUsers"
    ]),
    backToSettings() {
      return `/programs/${this.$route.params.programId}/settings`;
    },
    tableData() {
     if (this.contracts && this.contracts.length > 0 && this.facilityGroups) {
        // let groups = this.facilityGroups.map(g => g.id)
        let contracts = this.contracts.map(cp => cp)
        let programContracts = contracts.filter((u) => u.project_id == this.$route.params.programId );
        let contractData = programContracts
          .map((t) => t)
          .filter((td) => {
            //  console.log(td)
            if (
              this.C_projectGroupFilter &&
              this.C_projectGroupFilter.length > 0
            ) {
              let group = this.C_projectGroupFilter.map((t) => t.id);
              return group.includes(td.facility_group_id);
            } else return true;
          });
          if (contractData.length > 0){
              return contractData;
          } else return []
      
      }
    },
  contractUsers(){
  if(this.getRoles && this.getRoles.length > 0 ){   
    let roleUsers = this.getRoles.map(t => t.role_users).filter(t => t.length > 0)   
    if (this.projId)  {
      let groupByRoles = [].concat.apply([], roleUsers).filter(t => this.projId == t.contract_id)   
      // const reducedRoles = groupByRoles.reduce((acc, { role_id, role_name, user_full_name, user_id, facility_project_id }) => (
      //     { 
      //       ...acc, 
      //       [role_id]: acc[role_id] ? [ ...acc[role_id], { role_name, user_full_name, user_id, facility_project_id }] : [ { role_name, user_full_name, user_id, facility_project_id } ],
      //     }
      // ), {});
      console.log(groupByRoles)
          return {
                  data: groupByRoles,
                  roleIds: _.uniq(groupByRoles.map(t => t.role_id)),
                  }
      } else return [].concat.apply([], roleUsers)       
    }
    },
    assignedUsers(){
    //   //  Commenting out this setter which is executed in the handleExpandChange() method.  Useful if we want saved users to populate dropdown upon loading
      if(this.programUsers && this.contractUsers && this.contractUsers.data && this.contractUsers.data.length > 0){        
        let tableUserIds = this.userids.map(t => t.user_id)      
        return this.programUsers.filter(t => tableUserIds.includes(t.id))        
      }
    },
  assignedContractUsers: {     
     get() {
       return this.getAssignedContractUsers
      },
      set(value) {
         this.SET_ASSIGNED_CONTRACT_USERS(value)
         console.log(value)
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
   programUsers(){
      if (this.currentProject){
         if (this.currentProject.users && this.currentProject.users.length > 0){
           return this.currentProject.users.filter(t => t)
       }
      }       
    },
   viableContractUsers(){
      if (this.programUsers && this.contractUsers && this.contractUsers.data){
        let assignedUserIds = this.contractUsers.data.map(t => t.user_id)
       return this.programUsers.filter(t => !assignedUserIds.includes(t.id))
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
          this.fetchContracts(this.$route.params.programId);
          this.fetchCurrentProject(this.$route.params.programId);
        }
      },
    },
    removeContractRoleStatus: {
      handler() {
        if (this.removeContractRoleStatus == 204  || this.removeContractRoleStatus == 200) {
          this.$message({
            message: `Succesfully removed user(s) from role.`,
            type: "success",
            showClose: true,
          });  
          this.fetchRoles(this.$route.params.programId)   
          this.SET_REMOVE_CONTRACT_ROLE_STATUS(0);   
          this.isEditingRoles = false;
          this.rowIndex_1 = null;
         }
      },
    },    
      addUserToRoleStatus: {
      handler() {
        if (this.addUserToRoleStatus == 204 || this.addUserToRoleStatus == 200) {
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
/deep/.el-popper {
 .select-popper {
    display: none;
  }
}
.userNames{
  // background-color: #F8F9FA;
  border-radius: .25rem;
  margin-right: 2px;
  padding: 1px 3px ;
  border: solid lightgray .75px;
}
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
.addUserRole {
  /deep/.el-dialog__body {
  padding-top: 0 !important;
 }
 /deep/.el-dialog {
  width: 55%;
  }
}
</style>
