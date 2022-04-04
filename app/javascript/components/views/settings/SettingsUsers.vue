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
             <i class="fal fa-users mr-1 text-secondary"></i> USERS
            <span
              v-if="programUsers && programUsers.length"
              class="ml-2 pb-1 badge badge-secondary badge-pill pill"
              >{{ programUsers.length }}
            </span>
            <span v-else class="ml-2 pb-1 badge badge-secondary badge-pill pill"
              >{{ 0 }}
            </span>
          </h4>
        </el-breadcrumb>
        <div class="my-1 pb-2 buttonWrapper container-fluid">
          <div class="row px-0">
                     <!-- <div
              class="col-6"
              >
              <el-button
                @click.prevent="openCreateUser"
                v-if="_isallowed('write')"
                class="bg-primary text-light mb-2"
              >
               <i class="fas fa-user-plus mr-1"></i> Create New User
              </el-button>
               <el-button
                @click.prevent="addUser"
                  v-if="_isallowed('write')"
                class="bg-success text-light mb-2"
              > -->
                <div
              class="col-6"
              >
              <el-button
                @click.prevent="openCreateUser"             
                class="bg-primary text-light mb-2"
              >
               <i class="fas fa-user-plus mr-1"></i> Create New User
              </el-button>
               <el-button
                @click.prevent="addUser"                  
                class="bg-success text-light mb-2"
              >
            <i class="fas fa-users-medical mr-1"></i> Add User(s) to Program
              </el-button>
            </div>
            <div class="col-6">
              <el-input
                type="search"
                placeholder="Search Users"
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
      
     
    <div class="container-fluid mt-2 mx-0">
    <!-- <div  
        v-loading="!programUsersLoaded"
        v-if="_isallowed('read')"
        element-loading-text="Fetching your data. Please wait..."
        element-loading-spinner="el-icon-loading"     
        class=""> -->
         <div  
        v-loading="!programUsersLoaded"
        element-loading-text="Fetching your data. Please wait..."
        element-loading-spinner="el-icon-loading"     
        class=""> 
        <el-table
        v-if="programUsers && programUsers.length > 0"
       :data="
            programUsers
            .filter(
                (data) =>
                !search ||
                data.full_name.toLowerCase().includes(search.toLowerCase())
            )
            .reverse()
        "
        highlight-current-row
        :row-key="row => row.id"
        :expand-row-keys="expandRowKeys"
        @expand-change="handleExpandChange" 
        style="width: 100%"
        height="450"
        :default-sort="{ prop: 'last_name', order: 'ascending'}"  
        >
        <el-table-column prop="first_name" sortable label="First Name"> </el-table-column>
        <el-table-column prop="last_name" sortable label="Last Name"> </el-table-column>
     
     
        <!--BEGIN Expandable Column Containing Priveleges Info -->
         <!-- END Expandable Column Containing Priveleges Info -->


        <el-table-column label="Actions"  align="right">
            <template slot-scope="scope" >
            <el-button  
                type="default" 
                v-tooltip="`Edit User info`"  
               @click.prevent="openEditUser(scope.$index, scope.row)"
                class="bg-light btn-sm">
                <i class="fal fa-edit text-primary" ></i>    
            </el-button> 
            <el-button  
            type="default" 
            v-tooltip="`Manage User Privileges`"
            @click.prevent="openUserRoleDialog(scope.$index, scope.row)" 
            v-if="scope.$index !== rowIndex"
            class="bg-primary text-light btn-sm">
              <i class="fal fa-user-lock mr-1 text-light"></i> 
            </el-button>  
        
        <!-- USe this attribute when functionaloty gets built in -->
                  <!-- @click.prevent="removeUser(scope.$index, scope.row)"    -->
            <!-- <el-button
            type="default"  
            class="bg-light btn-sm"         
             v-tooltip="`Remove User`"  
            >
            <i class="fas fa-user-slash"></i>               
            </el-button> -->
    
            <!-- <el-button type="primary" @click="handleEditRow(scope.$index)">Edit</el-button> -->
            </template>
        </el-table-column>
      
        </el-table>
    </div>
       <!-- <div v-else class="text-danger mx-2 mt-5">
        <h5> <i>Sorry, you don't have read-permissions for this page! Please contact your Program Administrator for access.</i></h5>
       </div> -->
    </div>
      <el-dialog
        :visible.sync="newUserDialogVisible"
        append-to-body
        center
        class="p-0 users"       
      >
      <span slot="title" class="text-left">
        <h5 class="text-dark"><i class="fas fa-user-plus mr-2"></i>Create New User </h5>
      </span>
      <form accept-charset="UTF-8">
       <div class="container">
        <div class="row">  
          <div class="col-12 pb-0">
            <label class="mb-0 pb-0 text-dark"
              >First Name<span style="color: #dc3545">*</span> </label
            >
            <el-input
              class="mb-2 pl-1"
              v-model="firstName"
              placeholder="Enter First Name"
              rows="1"
              />        
          </div>
        </div>
        <div class="row">     
        <div class="col-12 pb-0">
          <label class="mb-0 pb-0 text-dark"
              >Last Name <span style="color: #dc3545">*</span></label
            >
            <el-input
              v-model="lastName"
              class="mb-2 pl-1"
              placeholder="Enter Last Name"
              rows="1"    
            />          
        </div>
        </div>      
        <div class="row">
          <div class="col-12 pb-0">
            <label class="mb-0 pb-0 text-dark"
              >Email<span style="color: #dc3545">*</span></label>
            <el-input
              name="email"
              v-model="email"
              placeholder="Enter Email"
              v-validate="'email'"
              :class="{ 'error': errors.has('email') }"
              rows="1"  
              class="mb-2 pl-1"        
            />            
          </div>
        </div>
        <div class="row">
          <div class="col-12 py-1 text-right" style="line-height:6">
            <button
            @click.prevent="createUser"
            v-show="email && lastName && firstName && !createAnotherUserBtn"
            class="btn btn-md bg-primary text-light modalBtns"
            v-tooltip="`Save New User`"               
          >
          <i class="fal fa-save"></i> 
        </button>
        <button
          type="default"   
          v-tooltip="`Create another user`"     
          @click.prevent="createAnotherUser"          
          v-if="email && lastName && firstName && createAnotherUserBtn"
          class="btn btn-md btn-primary text-light modalBtns"
          >
          <i class="far fa-plus-circle"></i>
          </button>
          <button
            @click.prevent="cancelAddNewUser"
            class="btn btn-md bg-secondary text-light ml-0 modalBtns"
            v-tooltip="`Close`"               
          >
          <i class="fas fa-ban"></i> 
        </button>
          </div>        
        </div>
        </div>  
      </form>      

      </el-dialog>
      <el-dialog
        :visible.sync="dialogVisible"
        append-to-body
        center
        class="p-0 users"       
      >
       <span slot="title" class="text-left">
        <h5 class="text-dark"><i class="fas fa-users-medical mr-2"></i>Add User(s) To Program</h5>
      </span>
      <div class="container" >      
        <div class="row">
        
          <div class="col-12"  v-if="portfolioUsersOnly && portfolioUsersOnly.length > 0">
          <label class="font-md mb-0">Search and select Users</label>
              <el-select
                v-model="portfolioUsers"
                class="w-100"
                track-by="id"
                value-key="id"
                :multiple="true"               
                clearable
                placeholder="Enter name"     
                filterable
              >
                <el-option
                  v-for="item in portfolioUsersOnly"
                  :value="item"
                  :key="item.id"
                  :label="item.full_name"
                >
                </el-option>
              </el-select>              
            <div class="text-right">
              <button
                type="default"   
                v-tooltip="`Save Users`"   
                @click.prevent="addPortfolioUsersToProgram" 
                v-if="portfolioUsers.length > 0 && !addMoreUsersBtn"
                class="btn btn-md btn-primary text-light mt-3 modalBtns"
                >
                  <i class="fal fa-save"></i> 
              </button>
               <button
                type="default"   
                v-tooltip="`Add more users`"     
                 @click.prevent="addMoreUsers"          
                v-if="portfolioUsers && addMoreUsersBtn"
                class="btn btn-md btn-primary text-light mt-3 modalBtns"
                >
              <i class="far fa-plus-circle"></i>
              </button>
               <button
                @click.prevent="cancelAddUser"
                class="btn btn-md bg-secondary text-light mt-3 ml-0 modalBtns"
                v-tooltip="`Close`"               
              >
               <i class="fas fa-ban"></i> 
              </button>
              </div>
          </div> 


         <div class="col-12" v-else>
             No Portfolio Users Found
         
         
          <div class="text-right">
          <button
            @click.prevent="cancelAddUser"
            class="btn btn-md bg-secondary text-light mt-3 ml-0 modalBtns"
            v-tooltip="`Close`"               
          >
            <i class="fas fa-ban"></i> 
          </button>
         </div>   


        </div>    



        </div>

      </div>
      </el-dialog>

    <el-dialog
      :visible.sync="editUserDialogVisible"
      append-to-body
      center
      class="p-0 users"       
        >
      <span slot="title" class="text-left">
        <h5 class="text-dark"> <i class="fas fa-edit mr-1"></i>Edit User </h5>
      </span>
      <div class="container pt-0">  
        <div class="row">
          <div class="col-12 pt-0">
             <form accept-charset="UTF-8">
                <FormTabs
                class="mb-3"
                :current-tab="currentTab"
                :tabs="tabs"
                 @on-change-tab="onChangeTab"
              />
                <div v-show="currentTab == 'tab1'" class="tab_1">
               <label class="mb-0 pb-0 text-dark"
                >First Name </label
              >
              <el-input
                class="mb-2 pl-1"
                v-model="rowUser.first_name"
                rows="1"
                />
               <label class="mb-0 pb-0 text-dark"
                >Last Name</label
              >
              <el-input
                v-model="rowUser.last_name"
                class="mb-2 pl-1"
                 rows="1"    
              />
             <label class="mb-0 pb-0 text-dark"
                >Position</label
              >
               <el-input
                v-model="rowUser.title"
                class="mb-2 pl-1"
                rows="1"               
              />
              <label class="mb-0 pb-0 text-dark"
                >Organization</label
              >
               <el-input
                v-model="rowUser.organization"
                disabled
                class="mb-2 pl-1"
                rows="1"               
              />
                </div>
              <div v-show="currentTab == 'tab2'" class="tab_2">
               <label class="mb-0 pb-0 text-dark"
                >Email</label>
               <el-input
                name="email"
                v-model="rowUser.email"
                v-validate="'email'"
                placeholder="Enter updated email here"
                rows="1"  
                class="mb-2 pl-1"        
                :class="{ 'error': errors.has('email') }"
              />

               <label class="mb-0 pb-0 text-dark"
                >Phone Number</label>
               <el-input
                v-model="rowUser.phone_number"
                disabled
                placeholder="Enter updated phone number here"
                rows="1"  
                class="mb-2 pl-1"        
              />
               <label class="mb-0 pb-0 text-dark"
                >Address</label>
               <el-input
                v-model="rowUser.address"
                disabled
                placeholder="Enter updated address here"
                rows="1"  
                class="mb-2 pl-1"        
              />
               </div>
                  <div v-show="currentTab == 'tab3'" class="tab_3 w-70">
               <h6 style="color:#383838">mPATH User since: </h6>            
                {{ moment(rowUser.created_at).format("DD MMM YYYY, h:mm a") }}
            
               <br>
                <h6 class="mt-3" style="color:#383838">mPATH User Id#:</h6>      
                {{ rowUser.id }}         
                 </div>

      <div class="my-3 float-right">
         <button
            @click.prevent="saveUserEdits"
            class="btn btn-md bg-primary text-light mr-2 modalBtns"
            v-tooltip="`Save New User`"               
          >
          <i class="fal fa-save"></i>
        </button>
          <button
            @click.prevent="cancelEdits"
           class="btn btn-md bg-secondary text-light modalBtns"
            v-tooltip="`Close`"               
          >
         <i class="fas fa-ban"></i>
        </button>
      </div>
           </form>
          </div> 
                
        </div>    
      </div>
    </el-dialog>

      <el-dialog
      :visible.sync="openUserRoles"
      append-to-body
      center
      class="p-0 userRoles"       
        >
      <span slot="title" class="text-left add-groups-header ">
        <h5 style="color:#383838" v-if="userData"> 
          <i class="fal fa-user-lock mr-1 mb-3 bootstrap-purple-text"></i>  {{ userData.full_name }}
        </h5> 
     </span>
      <div class="container-fluid p-2">
            <div class="mt-0 row">
            <div class="col-5 pt-0">
             <label class="font-md mb-0 d-flex">Assign Project Role </label>
             <el-select
              v-model="projectRoleNames"
              filterable           
              class="w-100"
              clearable
              track-by="id"
              value-key="id"
              placeholder="Search and select Role"          
            >
             <el-option
                v-for="item in getRoles.filter(t => t.type_of == 'projects')"
                :value="item"
                :key="item.id"
                :label="item.name"
              >
              </el-option>
            </el-select>
              </div>
           <div class="col-5 pt-0">
              <label class="font-md mb-0 d-flex">Associate Projects to Role </label>
             <el-select
              v-model="associatedProjects"
              multiple
              filterable           
              class="w-100"
              clearable
              track-by="id"
              value-key="id"
              placeholder="Search and select Projects to Associate"          
            >
              <el-option
                v-for="item in projectNames"
                :value="item"
                :key="item.facilityProjectId"
                :label="item.facilityName"
              >
              </el-option>
            </el-select>
          
             
              </div>
                <div class="col-2 pt-0">
              <label class="font-md mb-0 d-flex" style="visibility:hidden">|</label>
                              
                <el-button
                type="default"    
                @click="saveProjectUserRole()"          
                v-if="projectRoleNames && associatedProjects && associatedProjects.length > 0"
                v-tooltip="`Confirm`" 
               class="bg-light btn-sm">               
               <i class="fal fa-clipboard-list mr-1 mh-green-text"></i>Confirm Project Role
               </el-button>     
              </div>             
             
            </div>
           <div class="my-3 row">
            <div class="col-5 pt-0">
             <label class="font-md mb-0 d-flex">Assign Contract Role </label>
             <el-select
              v-model="contractRoleNames"
              filterable           
              class="w-100"
              clearable
              track-by="id"
              value-key="id"
              placeholder="Search and select role"          
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
           <div class="col-5 pt-0">
              <label class="font-md mb-0 d-flex">Associate Contracts to Role </label>
             <el-select
              v-model="associatedContracts"
              filterable           
              class="w-100"
              multiple
              clearable
              track-by="id"
              value-key="id"
              placeholder="Search and select Contracts to Associate"          
            >
              <el-option
                v-for="item in contractNames"
                :value="item"
                :key="item.id"
                :label="item.nickname"
              >
              </el-option>
            </el-select>
          
             
              </div>
                <div class="col-2 pt-0">
              <label class="font-md mb-0 d-flex" style="visibility:hidden">|</label>
                              
               <el-button
                type="default"
                @click="saveContractUserRole()"
                v-if="contractRoleNames && associatedContracts && associatedContracts.length > 0"
                v-tooltip="`Confirm`" 
                class="bg-light btn-sm">           
               <i class="far fa-file-contract mr-1 mh-orange-text"></i> Confirm Contract Role
               </el-button> 
      
              </div>             
             
            </div>
           <div class="mt-0 row">
            <div class="col-5 text-center pt-0">
             <label class="font-md mb-0 d-flex">Assign Admin Role </label>
             <el-select
              v-model="adminRoleNames"
              filterable           
              class="w-100"
              clearable
              track-by="id"
              value-key="id"
              placeholder="Search and select role"          
            >
             <el-option
                v-for="item in getRoles.filter(t => t.type_of == 'admin')"
                :value="item"
                :key="item.id"
                :label="item.name"
              >
              </el-option>
            </el-select>
              </div>
           <!-- <div class="col-5 pt-0">
              <label class="font-md mb-0 d-flex">Associate Contracts to Role </label>
             <el-select
              v-model="associatedContracts"
              filterable           
              class="w-100"
              multiple
              clearable
              track-by="id"
              value-key="id"
              placeholder="Search and select Contracts to Associate"          
            >
              <el-option
                v-for="item in contractNames"
                :value="item"
                :key="item.id"
                :label="item.nickname"
              >
              </el-option>
            </el-select>
          
             
              </div> -->
                <div class="col-2 pt-0">
              <label class="font-md mb-0 d-flex" style="visibility:hidden">|</label>
                              
               <el-button
                type="default"
                @click="saveAdminUserRole()"
                v-if="adminRoleNames"
                v-tooltip="`Confirm`" 
                class="bg-light btn-sm">           
        
              <i class="fa-solid fa-user-shield mr-1 bootstrap-purple-text"></i>Confirm Admin Role 
               </el-button> 
      
              </div>             
             
            </div>
      <div class="mt-4 row">
        <div class="col-12 pt-0">
        <el-table
          v-if="projectUsers && projectUsers.length > 0"
          :data="projectUsers.filter(
                  (data) =>
                    !searchRoleUsers || 
                    data.role_name.toLowerCase().includes(searchRoleUsers.toLowerCase())
                )"    
          style="width: 100%"
          border
          :header-cell-style="{ background: '#EDEDED' }"
        >
          <!-- || data.facility_id == projectNames.map(t => t.id).facilityName.toLowerCase().includes(searchRoleUsers.toLowerCase()) -->
          <!-- || 
                    this.currentProject.facilities.filter(t => t.facilityId == data.facility_id).map(n => n.facilityName.toLowerCase().includes(searchRoleUsers.toLowerCase())) -->
     
      
        <el-table-column prop="role_name"  sortable label="Roles">
            <template slot-scope="scope">
              <span v-if="scope.row.facility_project_id">
             <i class="fal fa-clipboard-list mr-1 mh-green-text"></i>  {{scope.row.role_name}}   
              </span>
              <span v-else-if="scope.row.contract_id">
               <i class="far fa-file-contract mr-1 mh-orange-text"></i>  {{scope.row.role_name}}
               </span>
                 <span v-else>
             <i class="fa-solid fa-user-shield mr-1 bootstrap-purple-text"></i>  {{scope.row.role_name}}
               </span>


            </template>
        
        </el-table-column>
        <el-table-column
            prop="projects"
            sortable
            filterable
            label="Associations"
        >      
           <template slot-scope="scope">
              <span v-if="scope.row.facility_project_id && projectNames">
               {{ projectNames.filter(t => t.facilityProjectId == scope.row.facility_project_id).map(t => t.facilityName)[0]}}
                 <!-- {{ projectNames.filter(t => t.facilityId == scope.row.facility_id).map(t => t)}} -->
              </span>
                 <span v-if="scope.row.contract_id && contractNames">
                 {{ contractNames.filter(t => t.id == scope.row.contract_id).map(t => t.nickname)[0]  }}
              </span>

            </template>


        </el-table-column> 
    <el-table-column
  
        align="right">
        <template slot="header" slot-scope="scope">
          <el-input
            v-model="searchRoleUsers"
            size="mini"
            placeholder="Search User Roles"/>
        </template>
          </el-table-column>
       </el-table>
        <span v-else>
          No Roles Assigned To This User
        </span>
          <div class="text-right mt-3">
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
    

</div>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
import SettingsSidebar from "./SettingsSidebar.vue";
import FormTabs from "../../shared/FormTabs.vue"
export default {
  name: "SettingsUsers",
  components: {
    SettingsSidebar,
    FormTabs
  },
    data() {    
      return {
        search:"",
        expandRowKeys: [],
        projId: null, 
        userData: null, 
        searchRoleUsers: '',
        autoCompleteSearch:"",
         currentTab: "tab1",
            tabs: [
        {
          label: "Basic Info",
          key: "tab1",
          closable: false,
          // form_fields: [
          //   "Task Name",
          //   "Description",
          //   "Start Date",
          //   "Process Area",
          //   "Stage",
          //   "Start Date",
          //   "Date Closed",
          // ],
        },
        {
          label: "Contact Info",
          key: "tab2",
          closable: false,
          // form_fields: ["Responsible", "Accountable", "Consulted", "Informed"],
        },
        {
          label: "Misc",
          key: "tab3",
          closable: false,
          // form_fields: ["Checklists"],
        },      
      ],
        firstName:'',
        lastName:'',
        email:'',
        addMoreUsersBtn: false, 
        rowIndex: null,
        programId: this.$route.params.programId,
        rowId: null,
        addedUsers: [],
        rowUser: {},
        userPrivileges: {},
        portfolioUsers:[],
        programNameList: [],
        newUserValidation: null, 
        inactiveUser: false, 
        activeUser: true,
        //toggle used by autocomplete
        toggle: false,
        //dialogVisible used by el-dialogue popup
        dialogVisible: false,
        openUserRoles: false, 
        createAnotherUserBtn: false, 
        editUserDialogVisible: false,
        newUserDialogVisible: false,
        privilegesProfileVisible: false
    };
  },
  methods: {
...mapMutations([
    "SET_USER_STATUS",
    "SET_NEW_USER_STATUS",
    "SET_ADD_USERS_TO_PROGRAM",
    "SET_PROGRAM_USERS",
    "SET_ADD_USERS_TO_PROGRAM_STATUS",
    "SET_EDIT_USER_DATA_STATUS",
    "SET_PROJECT_ROLE_NAMES",
    "SET_ADMIN_ROLE_NAMES",
    "SET_CONTRACT_ROLE_NAMES",
    "SET_ASSOCIATED_CONTRACTS",
    "SET_ASSOCIATED_PROJECTS",
    "SET_ADD_USER_TO_ROLE_STATUS"

    ]),
  ...mapActions([
    "fetchPortfolioUsers", 
    "fetchProgramUsers",
    "fetchRoles",
    "addUserToRole",
    "fetchCurrentProject",
    "createNewUser", 
    "updateUserData", 
    "addUsersToProgram"
    ]),
    handleExpandChange(row, expandedRows) {   
			this.projId = row.id;
      this.projUserObj = row
			const lastId = this.expandRowKeys[0];
			// disable mutiple row expanded 
			this.expandRowKeys = this.projId  === lastId ? [] : [this.projId];  
      // if (this.projectUsers && this.projectUsers.length > 0) {
          console.log(this.contractNames)
      // }
   
		},
   _isallowed(salut) {
      return this.checkPrivileges("SettingsUsers", salut, this.$route)
   },
  saveProjectUserRole(index, rows){
    let projectIds = this.associatedProjects.map(t => t.facilityProjectId)
    let projectUserRoleData = {
          userData: {
            roleId: this.projectRoleNames.id,
            userId: this.projId,
            programId: this.$route.params.programId, 
            projectIds: projectIds, 
            userRoles: true        
         },
      };
      this.addUserToRole({
        ...projectUserRoleData,
      });
   
    },
    saveContractUserRole(index, rows){
    let contractIds = this.associatedContracts.map(t => t.id)
    let projectUserRoleData = {
          userData: {
            roleId: this.contractRoleNames.id,
            userId: this.projId,
            programId: this.$route.params.programId, 
            contractIds: contractIds, 
            userRoles: true        
         },
      };
      this.addUserToRole({
        ...projectUserRoleData,
      });
    },
   saveAdminUserRole(index, rows){
    let projectUserRoleData = {
          userData: {
            roleId: this.adminRoleNames.id,
            userId: this.projId,
            programId: this.$route.params.programId,      
            adminRole: true        
         },
      };
      // console.log(projectUserRoleData)
      this.addUserToRole({
        ...projectUserRoleData,
      });
    },
    onChangeTab(tab) {
      this.currentTab = tab ? tab.key : "tab1";
    },
     handleClick(tab, event) { 
        //Route redirecting incase we want to assign url paths to each tab
        // if(tab.index == 1) {
        //  this.$router.push({ name: "SettingsRolesProjects" })
        // }    
   
    },
    addRoleToUser(index, rows){
      console.log(rows)
    },
    associateUserRole(index, rows){
      console.log(rows)
    },
   addPortfolioUsersToProgram(){
     if (this.portfolioUsers && this.portfolioUsers.length > 0) {
      let uIds = []
       for(let i = 0; i < this.portfolioUsers.length; i++) {
            uIds.push(this.portfolioUsers[i].id)
       }     
      // console.log(uIds)
      let addedUsersAr = {
        addedUsers: {
           programId: this.programId,
           userIds: uIds,      
        },
      };
     this.addUsersToProgram({
        ...addedUsersAr,
      });
     }
   },
   addUser() {
      this.dialogVisible = true; 
      // console.log(this.portfolioUsersOnly)
    },
    addMoreUsers(){
      this.portfolioUsers = [];
      this.addMoreUsersBtn = false;
    },
    openCreateUser(){
      this.newUserDialogVisible = true
    },
    openUserRoleDialog(index, rows){
      this.projId = rows.id
      this.fetchRoles(this.$route.params.programId)     
      this.openUserRoles = true    
      this.userData = rows       
      console.log(this.projectNames)
    },
    closeUserRoles() {
      this.openUserRoles = false;
    },
    createAnotherUser(){
      this.createAnotherUserBtn = false;
      this.lastName = '',
      this.firstName = '',
      this.email = ''   
    },
    createUser() {
      let newUserData = {
        newUser: {
           fName: this.firstName,
           lName: this.lastName,
           email: this.email,
           pId: this.programId
        },
      };
      this.createNewUser({
        ...newUserData,
      });
      // this.hideSaveBtn = true;
    },
    openEditUser(index, rows){
      this.editUserDialogVisible = true;
      this.rowUser = rows
      // console.log(rows)
       console.log(this.projectUsers.length)
    },
   saveUserEdits() {
    let editUserData = {
     userData: {
          fName: this.rowUser.first_name,
          lName: this.rowUser.last_name,
          email: this.rowUser.email,
          title: this.rowUser.title,
          id:    this.rowUser.id,
          // org:   this.rowUser.organizationId,
          phNumber: this.rowUser.phone_number,
          address: this.rowUser.address,
          },
      };
      this.updateUserData({
        ...editUserData   
      });
    },
    cancelEdits() {
      this.editUserDialogVisible = false;
      this.rowIndex = null;
      this.rowId = null;
      // this.hideSaveBtn = false;
    },
    cancelAddNewUser() {
      this.newUserDialogVisible = false;
    },
    cancelAddUser() {
      this.dialogVisible = false;
      this.portfolioUsers = [];
    },
    editMode(index, rows) {
      this.rowIndex = index;
      this.rowId = rows.id;
    },
    userActiveStatus(index, rows) {
      if(rows.status == "inactive"){
         this.activeUser == false
      }
     
    },
  },
  mounted() {
   if (this.programUsers.length <= 0)    {
        this.fetchProgramUsers(this.$route.params.programId)
      }
    if (this.getPortfolioUsers.length <= 0)    {
      this.fetchPortfolioUsers()
    }  

  },
  computed: {
    ...mapGetters([
        "contentLoaded",
        "currentProject",
        "getPortfolioUsers",
        "activeProjectUsers",
        "newUserStatus",
        "getRoles",
        "getNewUserId",
        "getProjectRoleNames",
        "getContractRoleNames",
        "getAdminRoleNames",
        "getAssociatedProjects",
        "getAssociatedContracts",
        "getAddedUsersToProgram",
        "addedUsersToProgramStatus",
        "editUserDataStatus",
        "portfolioUsersLoaded",
        "programUsers",
        "programUsersLoaded",
        "addUserToRoleStatus"
    ]),
    portfolioUsersOnly(){
    if (this.getPortfolioUsers && this.getPortfolioUsers.length > 0 && 
          this.programUsers && this.programUsers.length > 0
          ){  
        let programUserIds = this.programUsers.map(p => p.id)
        return this.getPortfolioUsers.filter(u => !programUserIds.includes(u.id) )     
      }     
     },
   projectRoleNames: {     
     get() {
       return this.getProjectRoleNames
      },
      set(value) {
         this.SET_PROJECT_ROLE_NAMES(value)
         console.log(value)
        }      
    },
   associatedProjects: {     
      get() {
       return this.getAssociatedProjects
      },
      set(value) {
         this.SET_ASSOCIATED_PROJECTS(value)
         console.log(value)
        }      
    },
    associatedContracts: {     
     get() {
       return this.getAssociatedContracts
      },
     set(value) {
        this.SET_ASSOCIATED_CONTRACTS(value)
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
   adminRoleNames: {     
     get() {
       return this.getAdminRoleNames
      },
      set(value) {
         this.SET_ADMIN_ROLE_NAMES(value)
         console.log(value)
        }      
    },
    projectNames(){
      if(this.currentProject)
      if (this.currentProject.facilities && this.currentProject.facilities.length > 0)

      {
       return this.currentProject.facilities.map(t => t)
      }
    },
    contractNames(){
      if(this.currentProject)
      if (this.currentProject.contracts && this.currentProject.contracts.length > 0)
      {
        return this.currentProject.contracts.map(t => t)
      }
    },
   projectUsers(){
      if(this.getRoles && this.getRoles.length > 0 ){   
        let roleUsers = this.getRoles.map(t => t.role_users).filter(t => t.length > 0)   
       if (this.projId)  {
            return [].concat.apply([], roleUsers).filter(t => this.projId == t.user_id)
        } else return [].concat.apply([], roleUsers)
       
      }
    },
    backToSettings() {
      return `/programs/${this.$route.params.programId}/settings`;
    },
    },
  watch: { 
    newUserStatus: {
      handler() {
        if (this.newUserStatus == 200) {
          this.$message({
            message: ` ${this.firstName + this.lastName } successfully added to your program.`,
            type: "success",
            showClose: true,
          })
       
          if (this.getNewUserId && this.getNewUserId.msg) {
              let addedUserId = {
                addedUsers: {
                programId: this.programId,
                userIds: [this.getNewUserId.msg],      
                  },
               }
             this.addUsersToProgram(addedUserId);
          }
          this.SET_NEW_USER_STATUS(0);
          this.fetchProgramUsers(this.$route.params.programId);
          // this.fetchCurrentProject(this.$route.params.programId);          
          this.createAnotherUserBtn = true;       
        }
      },
    },
    editUserDataStatus: {
      handler() {
        if (this.editUserDataStatus == 200) {
          this.$message({
            message: `Successfully updated user`,
            type: "success",
            showClose: true,
          });
          this.SET_EDIT_USER_DATA_STATUS(0);
          this.fetchProgramUsers(this.programId);
          this.editUserDialogVisible = false;
        }
      },
    },
    addedUsersToProgramStatus: {
      handler() {
        if (this.addedUsersToProgramStatus == 200) {
         if (this.portfolioUsers.length > 0){
          this.$message({
            message: `${this.portfolioUsers.length} user(s) successfully added to your program.`,
            type: "success",
            showClose: true,
          });
          }
          this.addMoreUsersBtn = true;
          this.SET_ADD_USERS_TO_PROGRAM_STATUS(0);
          this.fetchProgramUsers(this.programId);         
        
        }
      },
    },
    addUserToRoleStatus: {
      handler() {
        if (this.addUserToRoleStatus == 204) {
          this.$message({
            message: `Succesfully assigned user to role(s)role.`,
            type: "success",
            showClose: true,
          });  
          this.fetchRoles(this.$route.params.programId)         
          this.SET_ADD_USER_TO_ROLE_STATUS(0);         
          this.SET_ASSOCIATED_PROJECTS([])
          this.SET_ASSOCIATED_CONTRACTS([])
          this.SET_PROJECT_ROLE_NAMES([])
          this.SET_ADMIN_ROLE_NAMES([])
          this.SET_CONTRACT_ROLE_NAMES([])
        }
      },
    },   
   
  },
};
</script>

<style scoped lang="scss">
.right-panel {
  height: calc(100vh - 100px);
  overflow-y: auto;
}
.buttonWrapper {
  border-bottom: lightgray solid 1px;
}
/deep/.el-dialog {
  width: 30%;  
}
.users {
  /deep/.el-dialog__body {
  padding-top: 0 !important;
  padding-bottom: 0 !important;
 }
}
/deep/.el-dialog__close.el-icon.el-icon-close{
  display: none;
}
/deep/.el-dialog__header.users{
  padding: 0;
}
/deep/.el-table th.el-table__cell > .cell, .priviLabel {
  color: #212529;
  font-size: 1.1rem;
}
.userRoles {
  /deep/.el-dialog__body {
  padding-top: 0 !important;
 }
 /deep/.el-dialog {
  width: 55%;
  }
}
.modalBtns {
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
}
.auto-complete-wrapper {
  justify-content: center;
  align-items: center;
  position: relative;
  input {
    width: 100%;
    border: none;
    height: 38px;
    padding-left: 10px;
    padding-right: -10px;
    box-shadow: inset 0 0 0 1px #b2b2b2;
    border-radius: 4px;
    background: transparent;
    transition: all .2s ease;
    &:focus {
      outline: none;
      box-shadow: inset 0 0 0 2px #DD9036;
    }
  }
h5 {
   word-break: break-word;
}
  .rowPrivileges {
    overflow-x: auto;
  }
  .spanInput{
    background-color: #F5F7FA;
    // border-color: #E4E7ED;
    color: #C0C4CC;
    border-radius: 4px;
    border:solid 1px #E4E7ED; 
  }
  .results {
    position: absolute;
    max-height: 300px;
    overflow-y: auto;
    width: 100%;
    background: #fff;  box-shadow: 0 10px 20px rgba(0,0,0,0.19), 0 6px 6px rgba(0,0,0,0.23);
    .result {     
      padding:  12px 0.75rem;
      &:hover {
        background: #efefef;
      }
    }
  }
}

</style>