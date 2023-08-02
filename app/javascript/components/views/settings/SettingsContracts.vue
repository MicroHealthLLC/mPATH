<template>
  <div class="row">
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
              >{{tableData.length }}
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
                placeholder="Search by Project Name, Customer or Contract #"
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
            :data="
              tableData
                .filter(
                  (data) =>
                    !search ||
                    data.name.toLowerCase().includes(search.toLowerCase()) ||
                    data.contract_number.name.toLowerCase().includes(search.toLowerCase()) ||
                    data.contract_customer.name.toLowerCase().includes(search.toLowerCase())
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
            :default-sort="{ prop: 'name', order: 'ascending'}"        
          >
             <el-table-column
              prop="name"
              label="Project Name"
            >
            </el-table-column>
            <el-table-column    
              label="Customer"
              prop="contract_customer_id">
            <template slot-scope="scope" >
            <span v-if="scope.row.contract_customer && scope.row.contract_customer.name !== null">
              {{ scope.row.contract_customer.name }}
              </span>
            </template>
          </el-table-column>
           <el-table-column
            label="Contract #"
            prop="contract_number_id">
          <template slot-scope="scope" >
           <span v-if="scope.row.contract_number && scope.row.contract_number.name !== null">
            {{ scope.row.contract_number.name}}
            </span>
           </template>
           </el-table-column>
          <el-table-column
            label="Award/TO #"
      
            prop="contract_award_to_id">
            <template slot-scope="scope" >
           <span v-if="scope.row.contract_award_to && scope.row.contract_award_to.name !== null">
            {{ scope.row.contract_award_to.name }}
            </span>
            </template>
          </el-table-column>
            <el-table-column
              prop="facility_group"
              sortable
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
                clearable
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
                 <span v-if="scope.row.facility_group && scope.row.facility_group.name && rowId !== scope.row.id">
                    {{ scope.row.facility_group.name }}
                 </span> 
            
               </span>           
            </template>
          </el-table-column>
             <el-table-column label="Actions" align="right">
              <template slot-scope="scope">
              <el-button  
                type="default" 
                size="small"
                v-tooltip="`Change Group`"
                @click.prevent="editMode(scope.$index, scope.row)" 
                v-if="scope.$index !== rowIndex && _isallowed('write')"
                class="bg-light px-2">
                <i class="fal fa-network-wired mh-blue-text"></i>
               </el-button>  
                <el-button
                  type="default"
                  size="small"
                  v-tooltip="`Manage User(s)`"
                  @click.prevent="addUserRole(scope.$index, scope.row)"
                  v-if="scope.$index !== rowIndex"
                  class="bg-primary text-light px-2">
                    <i class="fas fa-users-medical mr-1"></i>
                </el-button>
                <el-button
                  type="default"
                  v-if="
                    scope.$index == rowIndex 
                  "
                  @click.prevent="saveEdits(scope.$index, scope.row)"
                  v-tooltip="`Save`"
                  size="small"
                  class="bg-primary px-2 text-light"
                >
                  <i class="far fa-save"></i>
                </el-button>
                <el-button
                  type="default"
                  size="small"
                  v-tooltip="`Cancel Edit`"
                  v-if="
                    scope.$index == rowIndex
                  "
                  @click.prevent="cancelEdits(scope.$index, scope.row)"
                  class="bg-secondary btn-sm text-light px-2"
                >
                  <i class="fas fa-ban"></i>
                </el-button>
                <el-button
                    :load="log(scope.row)"
                    type="default"        
                    size="small"    
                    class="bg-light btn-sm px-2"
                    v-tooltip="'Remove Contract'"            
                    @click.prevent="removeContractBtn(scope.$index, scope.row)"
                    v-if="scope.$index !== rowIndex && _isallowed('write')"        
                  >                  
                    <i class="fa-light fa-circle-minus text-danger"></i>                   
                  </el-button>          
                <el-button
                  type="default" 
                  size="small"
                  v-tooltip="`Go To Contract`"  
                  v-if="_isallowedContracts(scope.row.project_contract_id, 'read')"  
                  @click.prevent="goToContract(scope.$index, scope.row)"
                  class="bg-success text-light btn-sm px-2"
                  >
                  <i class="fas fa-arrow-alt-circle-right"></i>
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
        <div v-else class="text-danger mx-2 mt-5">
        <h5> <i>Sorry, you don't have read-permissions for this page! Please contact your Program Administrator for access.</i></h5>
       </div>
        <el-dialog
          :visible.sync="contractDialogVisible"
          append-to-body
          center
          class="contractForm addContract p-0"
        >
        
          <div class="row mb-3">
          <div class="col-7">
        <span slot="title" class="text-left add-groups-header ">
          <h5 class="text-dark"> <i class="far fa-plus-circle mr-1 mb-3"></i>Add Exisiting Contract </h5>
        </span>
          </div>
          <div class="col-5 text-right">
            <el-input
            type="search"
            placeholder="Search by Project Name, Customer or Contract #"
            aria-label="Search"
            class="w-100"
            aria-describedby="search-addon"
            v-model="searchContractData"
            data-cy=""
          >
            <el-button slot="prepend" icon="el-icon-search"></el-button>
          </el-input>
          </div>
        </div>
         <template>
    <div       
      v-loading="!contractProjectsLoaded"
      element-loading-text="Fetching your data. Please wait..."
      element-loading-spinner="el-icon-loading"
      element-loading-background="rgba(0, 0, 0, 0.8)" 
      class="addContractModal"
      >
    <el-table
      :data="allContracts"
      v-if="allContracts && allContracts.length > 0"
      style="width: 100%">
    <el-table-column
      prop="name"
      label="Project Name"
      width="180">
    </el-table-column>
    <el-table-column    
      label="Customer"
      width="200"
      prop="contract_customer_id">
     <template slot-scope="scope" >
     <span v-if="(scope.row.contract_customer && scope.row.contract_customer.name !== null)">
      {{ scope.row.contract_customer.name }}
      </span>
      </template>
    </el-table-column>
      <el-table-column
      label="Contract Number"
      width="200"
      prop="contract_number_id">
    <template slot-scope="scope" >
      <span v-if="scope.row.contract_number && scope.row.contract_number.name !== null">
      {{ scope.row.contract_number.name }}
      </span>
      </template>
    </el-table-column>
    <el-table-column
      label="Award/ TO Number"
      width="200"
      prop="contract_award_to_id">
    <template slot-scope="scope" >
     <span v-if="scope.row.contract_award_to && scope.row.contract_award_to.name !== null">
      {{ scope.row.contract_award_to.name }}
      </span>
      </template>
    </el-table-column>
      <el-table-column label="Actions" align="right">
          <template slot-scope="scope">
            <el-button
              type="default"
              data-cy="add_contract_btn"
              v-tooltip="`Add Contract`"
              @click.prevent="addExistingContract(scope.$index, scope.row)"          
              class="bg-primary text-light btn-sm">
              <i class="far fa-plus-circle"></i>  
            </el-button>
          </template>
        </el-table-column>
    </el-table>
    <span class="mt-3" v-else>
      <h4><em>There are currently no contracts to display</em></h4>
    </span>
    </div>  
  </template>
     
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
            <i class="far fa-file-contract mr-1 mb-2 mh-orange-text"></i>  {{ contractData.name }}
        </h5> 
        </span>
           <div class="container-fluid p-0">

             <div class="pl-3 mt-0 row" v-if="viableContractUsers && viableContractUsers.length > 0 && _isallowed('write')" >
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
            <div class="pl-3 mt-0 row" v-if="getRolesLoaded && contentLoaded && viableContractUsers && viableContractUsers.length <= 0">
                There are currently no program users to assign to this contract.  You can either add new program users from portfolio or remove desired user from current role in this contract.
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
              width="200"
              sortable              
              filterable
              label="Role">
              <template slot-scope="scope">
              <span v-if="contractUsers.data.map(t => t.role_id == scope.row) && scope.$index !== rowIndex_1 || scope.$index == rowIndex_1 && isEditingRoles" >  
                 {{ contractUsers.data.filter(t => t.role_id == scope.row).map(t => t.role_name)[0] }}

               </span>
                  <span v-if="changeRoleMode && scope.$index == rowIndex_1" >  
                 <el-select
                  v-if="bulkChangeContractRoleNames.id"
                  v-model="bulkChangeContractRoleNames"
                  filterable           
                  class="w-100"
                  track-by="id"
                  value-key="id"
            
                >
                  <el-option
                    v-for="item in getRoles.filter(t => t.type_of == 'contract')"
                    :value="item"
                    :key="item.id"
                    :label="item.name"
                  >
              </el-option>
              </el-select>
              <el-select
                  v-if="currentRoleName && !bulkChangeContractRoleNames.id" 
                  v-model="currentRoleName"
                  filterable           
                  class="w-100"
                  track-by="id"
                  value-key="id"
            
                >
                  <el-option
                    v-for="item in getRoles.filter(t => t.type_of == 'contract')"
                    :value="item"
                    :key="item.id"
                    :label="item.name"
                  >
              </el-option>
            </el-select>
                  <!-- {{ scope.row}}   -->
                </span>
              </template>

            </el-table-column>
            <el-table-column  prop="role_name"
             width="675"
             sortable              
             filterable
             label="Users">
             <template slot-scope="scope">
               <span v-if="scope.$index !== rowIndex_1 || changeRoleMode" >        
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
             width="145"
             fixed="right"
             align="center"
             v-if="(_isallowed('delete') || _isallowed('write'))" 
            >
            <template slot-scope="scope"  class="px-0">
                <el-button
                  type="default"
                  size="mini"
                  @click="bulkChangeRole(scope.$index, scope.row)"
                  v-if="scope.$index !== rowIndex_1 && _isallowed('write')"
                  v-tooltip="`Change Role`" 
                  class="bg-light btn-sm px-2 mx-0">               
                <i class="fa-solid fa-users-gear text-primary"></i>
                </el-button>
                  <el-button
                  type="default"
                  size="mini"
                  @click="saveBulkChangeRole(scope.$index, scope.row)"
                  v-if="scope.$index == rowIndex_1 && changeRoleMode && (bulkChangeContractRoleNames.id || currentRoleName.id) && 
                  (scope.row !== bulkChangeContractRoleNames.id && scope.row !== currentRoleName.id)"
                  v-tooltip="`Save`" 
                  class="bg-primary px-2 btn-sm text-light mx-0">               
                  <i class="far fa-save"></i>
                </el-button>
                <el-button
                  size="mini"
                  type="default"
                  @click="saveRemoveUsers(scope.$index, scope.row)"
                  v-if="isEditingRoles && scope.$index == rowIndex_1"
                  v-tooltip="`Save`" 
                  class="bg-primary px-2 text-light">               
                  <i class="far fa-save"></i>
                </el-button>
                <el-button  
                type="default" 
                size="mini"
                v-if="scope.$index !== rowIndex_1 && (_isallowed('delete'))"
                v-tooltip="`Remove all users from this role`"  
                @click.prevent="removeAllUsers(scope.$index, scope.row)"                
                class="bg-danger px-2 btn-sm mx-0">
              <i class="fa-solid fa-users-slash mr-1 text-light"></i>
                </el-button>  
                <el-button  
                type="default" 
                size="mini"
                v-if="scope.$index !== rowIndex_1 && (_isallowed('delete'))"
                v-tooltip="`Remove user(s) from this role`"
                @click.prevent="editUsers(scope.$index, scope.row)"           
                class="bg-danger px-2  text-light btn-sm mx-0">
                 <i class="fa-solid fa-user-slash text-light"></i>
                </el-button>  
                  <el-button  
                  type="default" 
                  size="mini"
                  v-if="isEditingRoles && scope.$index == rowIndex_1"
                  v-tooltip="`Cancel`"
                  @click.prevent="cancelEditRoles(scope.$index, scope.row)"             
                class="btn btn-sm px-2  bg-secondary text-light">
                  <i class="fas fa-ban"></i> 
                </el-button> 
                 <el-button  
                  type="default" 
                  size="mini"
                  v-if="changeRoleMode && scope.$index == rowIndex_1"
                  v-tooltip="`Cancel`"
                  @click.prevent="cancelBulkChangeRole(scope.$index, scope.row)"             
                  class="btn btn-sm bg-secondary text-light px-2 mx-0">
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
          v-tooltip="`Cancel`"                  
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
  props: ["currentContract"],
  components: {
    SettingsSidebar,
  },
  data() {
    return {
      today: new Date().toISOString().slice(0, 10),
      currentRoleName:{},
      searchContractData: '',
      newGroup: null, 
      contractDialogVisible: false, 
      rowIndex_1: null, 
      isEditingRoles: false,
      roleRowId: null, 
      userids: null, 
      changeRoleMode: false, 
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
    if (Vue.prototype.$contractPrivilegesRoles){
    console.log(Vue.prototype.$contractPrivilegesRoles)
    }

    this.fetchContracts(this.$route.params.programId)
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
      "SET_CONTRACT_ROLE_NAMES",
      "SET_BULK_CONTRACT_ROLE_NAMES",
      "SET_ASSIGNED_CONTRACT_USERS",
      "SET_REMOVE_CONTRACT_ROLE_STATUS",
      "SET_ASSOCIATED_CONTRACTS_STATUS",
       "SET_CONTRACTS_STATUS"
    ]),
    ...mapActions([
      "fetchCurrentProject",
      "createContract",
      "fetchContractProjects",
      "fetchContracts",
      "fetchGroups",
      "updateContract",
      "deleteContract",
      "addUserToRole", 
      "fetchRoles",
      "removeUserRole",
      "associateContractToProgram",
      "removeContract",
      "projectContracts",
      "bulkUpdateUserRoles"
    ]),
    _isallowed(salut) {
        return this.checkPrivileges("SettingsContracts", salut, this.$route, {settingType: 'Contracts'})
    }, 
    _isallowedContracts(c, salut) {
      console.log(c)
        return this.checkPrivileges("ProjectSettingContractList", salut, this.$route, {method: "isallowedContracts", project_contract_id: c})
    },
    log(e){
      console.log(e)
    },
    editUsers(index, rowData){
      this.userids = this.contractUsers.data.filter(t => t.role_id == rowData)
      this.SET_ASSIGNED_CONTRACT_USERS(this.assignedUsers)
      this.rowIndex_1 = index;
      this.roleRowId = rowData
      this.isEditingRoles = true;
      // console.log(this.userids)
  
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
    bulkChangeRole(index, rowData){
       this.currentRoleName = this.getRoles.filter(t => t.id == rowData).map(t => t)[0];
       this.changeRoleMode = true
       this.rowIndex_1 = index;
       this.roleRowId = rowData
    },
      saveBulkChangeRole(index, rowData){
      this.userids = this.contractUsers.data.filter(t => t.role_id == rowData)
      this.SET_ASSIGNED_CONTRACT_USERS(this.assignedUsers)
      let old_role = this.getRoles.filter(t => t.id == rowData).map(t => t)[0]
      let new_role;
      if(this.bulkChangeContractRoleNames.id) {
        new_role = this.bulkChangeContractRoleNames
      } else new_role = this.currentRoleName
      let user_ids = this.assignedContractUsers.map(t => t.id);
      let ids = this.assignedContractUsers.map(t => t.id).filter(t => user_ids.includes(t)); 
      let roleUsers = this.contractUsers.data.filter(t => t.role_id == rowData)
      // debugger
      let projectUserRoleData = {
          userData: {
            roleId: new_role.id,
            roleUserIds: roleUsers.map(t => t.id),
            userIds: ids,
            programId: this.$route.params.programId,                    
        },
      };
      console.log(ids)
      this.bulkUpdateUserRoles({
        ...projectUserRoleData,
      });
    
    },
    // saveBulkChangeRole(index, rowData){
    // let user_ids = this.assignedContractUsers.map(t => t.id);
    // this.SET_ASSIGNED_CONTRACT_USERS(this.assignedUsers)
    // let user_ids = this.assignedContractUsers.map(t => t.id);
    // let ids = this.assignedUsers.map(t => t.id).filter(t => user_ids.includes(t)); 
    //   let projectUserRoleData = {
    //             userData: {
    //               roleId: rowData,
    //               contractId: this.projId,
    //               programId: this.$route.params.programId, 
    //               userIds: ids,   
    //           },
    //         };
        
    //          console.log(this.assignedUsers)
    //         this.removeUserRole({
    //           ...projectUserRoleData,
    //         }).then(() => {
    //           let user_ids = this.assignedContractUsers.map(t => t.id);
    //           let ids = this.assignedUsers.map(t => t.id).filter(t => user_ids.includes(t)); 
    //           let contractUserRoleData = {
    //               userData: {
    //                 roleId:  this.bulkChangeContractRoleNames.id,
    //                 userIds:  ids,
    //                 programId: this.$route.params.programId, 
    //                 contractId: this.projId  
    //             },
    //           };
    //         this.addUserToRole({
    //           ...contractUserRoleData,
    //         });
    //      });    
    // },
    removeAllUsers(index, rowData){   
       this.userids = this.contractUsers.data.filter(t => t.role_id == rowData)
       this.SET_ASSIGNED_CONTRACT_USERS(this.assignedUsers)
        this.$confirm(
        `Are you sure you want to remove all users from this contract role?`,
        "Confirm Remove",
        {
          confirmButtonText: "Remove",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
       ).then(() => {
       let user_ids = this.assignedContractUsers.map(t => t.id);
       let ids = this.assignedUsers.map(t => t.id).filter(t => user_ids.includes(t)); 
       let projectUserRoleData = {
                userData: {
                  roleId: rowData,
                  contractId: this.projId,
                  programId: this.$route.params.programId, 
                  userIds: ids,   
              },
            };
        
             console.log(this.assignedUsers)
            this.removeUserRole({
              ...projectUserRoleData,
            });     
      });
     
    },
    cancelEditRoles(index, rowData){
    this.isEditingRoles = false;
    this.roleRowId = null;
    this.rowIndex_1 = null;
    },
   cancelBulkChangeRole(){
   this.changeRoleMode = false;
    this.roleRowId = null;
    this.rowIndex_1 = null;
     this.bulkChangeContractRoleNames = {}
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
      // console.log(contractUserRoleData)
      this.addUserToRole({
        ...contractUserRoleData,
      });
    },
   closeUserRoles() {
    this.openUserPrivilegesDialog = false;
    this.isEditingRoles = false;
    this.roleRowId = null;
    this.rowIndex_1 = null;
    },
    addUserRole(index, rows) {
      this.openUserPrivilegesDialog = true
      this.projId = rows.project_contract_id
      this.contractData = rows
    console.log(rows)
    },
    addExistingContract(index, rows) {
    //  console.log(rows)
         let contractData = {
          contract: {
            id: rows.id,            
            programId: this.$route.params.programId, 
          
         },
      };
     this.associateContractToProgram({...contractData})
    },
    goToContract(index, rows) {
      console.log(rows)
      let programId =  this.$route.params.programId
      //Needs to be optimzed using router.push.  However, Project Sidebar file has logic that affects this routing
      // window.location.pathname = `/programs/${this.$route.params.programId}/sheet/contracts/${rows.project_contract_id}/`
      this.$router.push({
        name: "SheetContract",
        params: {
          programId: programId,
          contractId: rows.project_contract_id,
        },
      });
      this.fetchCurrentProject(programId);
    },
	  handleExpandChange (row, expandedRows) {
			this.projId = row.id;
			const lastId = this.expandRowKeys[0];
			// disable mutiple row expanded 
			this.expandRowKeys = this.projId  === lastId ? [] : [this.projId];   
		},
    removeContractBtn(index, rows) {

    // console.log(rows)
      // let id = [rows.id];
      let contract = {
        g: {
          id: rows.project_contract_id,
          pId: this.$route.params.programId,
          },
       };      
 
      this.$confirm(
        `Are you sure you want to remove ${rows.name} from your program?`,
        "Confirm Remove",
        {
          confirmButtonText: "Remove",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
       ).then(() => {
        this.removeContract({ ...contract });
      });
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
    
    saveEdits(index, rows) {
      let id = rows.project_contract_id;
        let contractData = {      
            contract: {
            facility_group_id: rows.facility_group_id,
            programId: this.$route.params.programId,
          },
        };
        // this.setNewContractGroupFilter(rows.facility_group_id);
      this.updateContract({
        ...contractData,
        id,
      });
      // console.log(groupId)
      this.rowIndex = null;
      this.rowId = null;
    },
    cancelEdits(index, rows) {
      this.rowIndex = null;
      this.rowId = null;
    },
    editMode(index, rows) {
      console.log(rows)
      this.newGroup = null;
      this.rowIndex = index;
      this.rowId = rows.id;
    },
    deleteSelectedContract(index, rows) {
      let id = rows.id;
      this.$confirm(
        `Are you sure you want to delete ${rows.name}?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
      ).then(() => {
        this.deleteContract(id).then((value) => {
          if (value === 200) {
            this.fetchContracts();
            MessageDialogService.showDialog({
              message: `${rows.name} was deleted successfully.`,
              
              
            });
          }
        });
      });
    },
   closeAddContractBtn() {
      this.dialogVisible = false;
      this.hideSaveBtn = false;
    },
    addContract() { 
      //  if (this.allContracts  && this.allContracts.length > 0){
      //       console.log(this.allContracts)
      //           console.log('tableData', this.tableData)
      //  }
      console.log(this.tableData)
      this.contractDialogVisible = true;
       this.fetchContractProjects(this.$route.params.programId);
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
      "getBulkContractRoleNames",
      "getTransferData",
      "getContractTable",
      "getProjectGroupFilter",
      "getGroupFilter",
      "getNewGroups",
      "facilityGroups",
      "removeContractRoleStatus",
      "currentProject",
      "getAssignedContractUsers",
      "contractProjects",
      "associatedContractsStatus",
      "contractProjectsLoaded",
      "contractsStatus"
    ]),
    backToSettings() {
      return `/programs/${this.$route.params.programId}/settings`;
    },
 
    tableData(){
      //Need to add filter for associated contracts only
      if (this.contracts && this.contracts.length > 0 ) {
        let con = this.contracts.filter(t => t && t !== 'null')
        return (
              con.filter((td) => {
                if (this.C_projectGroupFilter && this.C_projectGroupFilter.length > 0) {
                  let group = this.C_projectGroupFilter.map((t) => t.name);
                  return group.includes(td.facility_group.name);
                } else return true;
              })
          );
      } else return []
    },
    allContracts(){
      if(this.tableData && this.tableData == [] || this.tableData.length == 0  ){
        if (this.contractProjects && this.contractProjects.length > 0){
              console.log('no table data', this.contractProjects.filter(t => t.contract_end_date > this.today))
        return this.contractProjects.filter(t => t.contract_end_date > this.today)
        }      
      }
      else if (this.contractProjects && this.contractProjects.length > 0 && this.tableData && this.tableData.length > 0){ 
            let associatedContractIds = this.tableData.map(t => t.id)
            let data = this.contractProjects.filter(t => {                     
          if (this.searchContractData !== '' && t) {           
              return (            
                t.name.toLowerCase().match(this.searchContractData.toLowerCase()) || 
                t.contract_number.name.toLowerCase().match(this.searchContractData.toLowerCase()) ||
                t.contract_customer.name.toLowerCase().match(this.searchContractData.toLowerCase())
              ) 
          } else return true
          })
          .filter((t) => {
            return !associatedContractIds.includes(t.id)
          }) 
          .filter( (t) => {
            return t.contract_end_date > this.today || t.ignore_expired == true
          })
          return data       
          }      
    },
    contractUsers(){
    if(this.getRoles && this.getRoles.length > 0 ){   
      let roleUsers = this.getRoles.map(t => t.role_users).filter(t => t.length > 0)   
      if (this.projId)  {
        let groupByRoles = [].concat.apply([], roleUsers).filter(t => this.projId == t.project_contract_id)   
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
       } else return []
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
        }      
    },
    contractRoleNames: {     
     get() {
       return this.getContractRoleNames
      },
      set(value) {
         this.SET_CONTRACT_ROLE_NAMES(value)
        }      
    },
    bulkChangeContractRoleNames: {     
     get() {
       return this.getBulkContractRoleNames
      },
      set(value) {
         this.SET_BULK_CONTRACT_ROLE_NAMES(value)
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
          MessageDialogService.showDialog({
            message: `Contract saved successfully.`,
            
            
          });
          this.newGroup = null;
          this.SET_CONTRACT_STATUS(0);
          this.fetchContracts(this.$route.params.programId);
          this.fetchCurrentProject(this.$route.params.programId);
        }
      },
    },
  contractsStatus: {
      handler() {
        if (this.contractsStatus == 200) {
          MessageDialogService.showDialog({
            message: `Successfully removed contract from program.`,
            
            
          });
          this.SET_CONTRACTS_STATUS(0);
          this.fetchContracts(this.$route.params.programId);
          this.fetchContractProjects(this.$route.params.programId);
           this.fetchCurrentProject(this.$route.params.programId);
        }
      },
    },
    associatedContractsStatus:{
      handler() {
        if (this.associatedContractsStatus == 200) {
          MessageDialogService.showDialog({
            message: `Contract successfully added to program.`,
            
            
          });
          this.SET_ASSOCIATED_CONTRACTS_STATUS(0);
          this.fetchContractProjects(this.$route.params.programId);
          this.fetchContracts(this.$route.params.programId);
          this.fetchCurrentProject(this.$route.params.programId);
        }
      },

    },
    removeContractRoleStatus: {
      handler() {
        if (this.removeContractRoleStatus == 204  || this.removeContractRoleStatus == 200) {
          MessageDialogService.showDialog({
            message: `Succesfully removed user(s) from role.`,
            
            
          });  
          this.fetchRoles(this.$route.params.programId)   
          this.SET_REMOVE_CONTRACT_ROLE_STATUS(0);   
          this.fetchCurrentProject(this.$route.params.programId)
          this.isEditingRoles = false;
          this.rowIndex_1 = null;
          this.changeRoleMode = false
         }
      },
    },    
      addUserToRoleStatus: {
      handler() {
        if (this.addUserToRoleStatus == 204 || this.addUserToRoleStatus == 200) {
          MessageDialogService.showDialog({
            message: `Succesfully added user/role to project.`,
            
            
          });     
          this.fetchCurrentProject(this.$route.params.programId)    
          this.SET_ADD_USER_TO_ROLE_STATUS(0);
          this.fetchRoles(this.$route.params.programId)  
          this.SET_CONTRACT_ROLE_NAMES([])
          this.SET_BULK_CONTRACT_ROLE_NAMES([])
          this.SET_CONTRACT_ROLE_USERS([])
          this.rowIndex_1 = null;
          this.roleRowId = null; 
          this.changeRoleMode = false
        }
      },
    },
  },
};
</script>

<style scoped lang="scss">
.addContractModal{
  min-height: 300px;
}
::v-deep.el-popper {
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
::v-deep.el-collapse-item__header {
  padding-left: 1.5rem;
}
.right {
  text-align: right;
}
::v-deep.el-table__header, .el-table{
  width: auto !important;
}
.fa-calendar {
  font-size: x-large;
}
::v-deep.el-table th.el-table__cell > .cell {
  color: #212529;
  font-size: 1.15rem;
}
.contractUsers { 
  
  ::v-deep.el-dialog{
 width: 60% !important; 

 ::v-deep.el-dialog__body {
   padding-top: 0;
 }

  }
  
}
// ::v-deep.el-dialog.contractUsers{
//  width: 60% !important; 
//   }
// .contractUsers{
//  ::v-deep.el-dialog__body {
//    padding-top: 0;
//  }
// }
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
::v-deep.el-input__inner{
  font-weight: 300 !important;
}
::v-deep.el-table__row .el-input .el-input__inner {
  border-style: none;
  font-size: 16px !important;
}
::v-deep.hover-row .el-input .el-input__inner {
  border-style: solid;
}
::v-deep.el-dialog.addContract {
  width: 30%;
}
.addContract {
  ::v-deep.el-dialog__body {
  padding-top: 0 !important;
 }
}
::v-deep.el-dialog__close.el-icon.el-icon-close {
  display: none;
}

::v-deep.el-table {
  .el-input__inner {
    font-size: 16px !important;
  }
}
::v-deep.el-dialog__close.el-icon.el-icon-close {
  background-color: #dc3545;
  border-radius: 50%;
  color: white;
  padding: 2px;
  font-size: 0.7rem;
}
.addUserRole {
  ::v-deep.el-dialog__body {
  padding-top: 0 !important;
 }
 ::v-deep.el-dialog {
  width: 55%;
  }
}
</style>
