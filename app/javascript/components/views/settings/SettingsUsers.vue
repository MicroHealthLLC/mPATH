<template>
<div 
  v-loading="!programUsers"
  element-loading-spinner="el-icon-loading"
  element-loading-background="rgba(0, 0, 0, 0.8)" class="row">
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
              :class="{ 'd-none': !_isallowedProgramSettings('write') }"
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
    <div  
        v-loading="!programUsersLoaded"
        element-loading-text="Fetching your data. Please wait..."
        element-loading-spinner="el-icon-loading"
        element-loading-background="rgba(0, 0, 0, 0.8)"
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
        style="width: 100%"
        height="450"
        :default-sort="{ prop: 'last_name', order: 'ascending'}"  
        >
        <el-table-column prop="first_name" sortable label="First Name"> </el-table-column>
        <el-table-column prop="last_name" sortable label="Last Name"> </el-table-column>
     
     
        <!--BEGIN Expandable Column Containing Priveleges Info -->
         <el-table-column type="expand" label="Privileges" width="100">
       <div class="">
        <el-table
          :data="projectsTable"
          style="width: 100%"
          border
          :header-cell-style="{ background: '#EDEDED' }"
        >
        <el-table-column prop="role"  sortable label="Roles">
        
        </el-table-column>
        <el-table-column
            prop="projects"
            sortable
            filterable
            label="Associations"
        >        
        </el-table-column> 
        <el-table-column icon="el-user" align="center"  width="75">
            <!-- <template slot-scope="scope" > -->
              <!-- USe this attribute when functionaloty gets built in -->
                  <!-- @click.prevent="removeUser(scope.$index, scope.row)"    -->
        <span v-tooltip="`Manage Privileges`">
            <i class="fas fa-user-lock"></i>               
            </span>
    
            <!-- <el-button type="primary" @click="handleEditRow(scope.$index)">Edit</el-button> -->
            <!-- </template> -->
        </el-table-column>   
        </el-table>
     

          </div>
        <!-- </template> -->
        </el-table-column>
        <!-- END Expandable Column Containing Priveleges Info -->


        <el-table-column label="Actions"  align="right">
            <template slot-scope="scope" >
            <el-button  
                type="default" 
                v-tooltip="`Edit User info`"  
               @click.prevent="openEditUser(scope.$index, scope.row)"
                class="bg-light">
                <i class="fal fa-edit text-primary" ></i>    
            </el-button> 
        
        <!-- USe this attribute when functionaloty gets built in -->
                  <!-- @click.prevent="removeUser(scope.$index, scope.row)"    -->
            <el-button
            type="default"  
            class="bg-light"         
             v-tooltip="`Remove User`"  
            >
            <i class="fas fa-user-slash"></i>               
            </el-button>
    
            <!-- <el-button type="primary" @click="handleEditRow(scope.$index)">Edit</el-button> -->
            </template>
        </el-table-column>
      
        </el-table>
    </div>
    </div>
      <el-dialog
        :visible.sync="newUserDialogVisible"
        append-to-body
        center
        class="p-0 users"       
      >
      <span slot="title" class="text-left">
        <h4 class="text-dark"><i class="fas fa-user-plus mr-2"></i>Add New User </h4>
      </span>
      <form accept-charset="UTF-8">
       <div class="container">        
        <div class="row">       
          <div class="col-6">
            <label class="mb-0 pb-0 text-dark"
              >First Name </label
            >
            <el-input
              class="mb-2 pl-1"
              v-model="firstName"
              placeholder="Enter First Name"
              rows="1"
              />        
          </div>
          <div class="col-6">
            <label class="mb-0 pb-0 text-dark"
                >Last Name</label
              >
              <el-input
                v-model="lastName"
                class="mb-2 pl-1"
                placeholder="Enter Last Name"
                rows="1"    
              />          
          </div>
        </div>
        <div class="row mt-0">
          <div class="col-6">
            <label class="mb-0 pb-0 text-dark"
              >Email</label>
            <el-input
              v-model="email"
              placeholder="Enter Email"
              rows="1"  
              class="mb-2 pl-1"        
            />            
          </div>
            <div class="col-6 py-1 text-right" style="line-height:6">
           <button
            @click.prevent="createUser"
            v-show="email && lastName && firstName"
            class="btn btn-md bg-primary text-light modalBtns"
            v-tooltip="`Save New User`"               
          >
          <i class="fal fa-save"></i> 
        </button>
         <button
            @click.prevent="cancelAddNewUser"
           class="btn btn-md bg-secondary text-light ml-0 modalBtns"
            v-tooltip="`Cancel`"               
          >
         <i class="fas fa-ban"></i> 
        </button>
          </div>
        
        </div>  
        <!-- <div class="mt-3 text-right">
          <button
            @click.prevent="createUser"
            class="btn btn-sm bg-primary text-light mr-2 modalBtns"
            v-tooltip="`Save New User`"               
          >
          <i class="fal fa-save mr-1"></i> SAVE
        </button>
         <button
            @click.prevent="cancelAddNewUser"
           class="btn btn-sm bg-secondary text-light modalBtns"
            v-tooltip="`Cancel`"               
          >
         <i class="fas fa-ban mr-1"></i> CANCEL
        </button>
        </div>       -->
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
        <h4 class="text-dark"><i class="fas fa-users-medical mr-2"></i>Add User(s) To Program</h4>
      </span>
      <div class="container" v-if="portfolioUsersOnly && portfolioUsersOnly.length > 0">      
        <div class="row">
          <div class="col-12">
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
                v-if="this.portfolioUsers.length > 0"
                class="btn btn-md btn-primary text-light mt-3 modalBtns"
                >
                  <i class="fal fa-save"></i> 
              </button>
               <button
                @click.prevent="cancelAddUser"
                class="btn btn-md bg-secondary text-light mt-3 ml-0 modalBtns"
                v-tooltip="`Cancel`"               
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
        <h4 class="text-dark"> <i class="fas fa-edit mr-1"></i>Edit User </h4>
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
                v-model="rowUser.email"
                placeholder="Enter updated email here"
                rows="1"  
                class="mb-2 pl-1"        
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
    </div>

    </div>
    

</div>
</template>

<script>
//DEVELOPMENT NOTES FEB 2022 (Erase After Release)
// Create route for SettingsUsers
//1. Create table with all Program Users
//2. Table should have search bar 
//3. Table rows should be editable
//4  Table rows should have two buttons (Btn 1: Edit button, Btn 2: Privileges Settings btn )
//5. When I click on row edit button, modal should contain personal info form
//6. When I click on row privileges button, I should be redirected to Privileges page of the indivudual user

//ADD USER DIALOG BOX

//1.  I want to search for users by first name or last name
//2.  I want search box to autopopulate my entry incase I don't know the entire spelling
//    The search box should have a "add name" button next to it so I can click on button and add name to the list if users I want to add to my program
//3.  I want a collapsed box that opens directory of names just incase I forget the spelling of a name
//4. 

//PRIVILEGES
//1. This will consist of editable tables
//2. An Admin Table?, Projects Table, and Contracts Table
// each table will be comprised of two columns
//3. First Column will list Projects/Contract/or Admin
//4. Second column will be for Roles (with "Roles" header)

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
        projectsTable: [
        {          
          role: 'project-read', 
          projects: 'Project A, Project B, Project C'
        }, {
          role: 'project-write', 
          projects: 'Project D, Project E, Project F'
        }, {
           role: 'project-delete', 
          projects: 'Project D, Project E, Project F'
       }, {
          role: 'project-admin', 
          projects: 'Project D, Project E, Project F'
        }, 
        {          
          role: 'contract-read', 
          contracts: 'Contract A, Contract B, Contract C'
        }, {
          role: 'contract-write', 
          contracts: 'Contract D, Contract E, Contract F'
        }, {
           role: 'contract-delete', 
          contracts: 'Contract D, Contract E, Contract F'
       }, {
          role: 'contract-admin', 
          contracts: 'Contract D, Contract E, Contract F'
        }, 
        ],
        firstName:'',
        lastName:'',
        email:'',
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
    "SET_EDIT_USER_DATA_STATUS"

    ]),
  ...mapActions([
    "fetchPortfolioUsers", 
    "fetchProgramUsers", 
    "fetchCurrentProject",
    "createNewUser", 
    "updateUserData", 
    "addUsersToProgram"
    ]),
    onChangeTab(tab) {
      this.currentTab = tab ? tab.key : "tab1";
    },
     handleClick(tab, event) { 
        //Route redirecting incase we want to assign url paths to each tab
        // if(tab.index == 1) {
        //  this.$router.push({ name: "SettingsRolesProjects" })
        // }    
   
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
    openCreateUser(){
      this.newUserDialogVisible = true
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
      console.log(rows)
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
        "getNewUserId",
        "getAddedUsersToProgram",
        "addedUsersToProgramStatus",
         "editUserDataStatus",
         "portfolioUsersLoaded",
         "programUsers",
         "programUsersLoaded"
    ]),
    portfolioUsersOnly(){
    if (this.getPortfolioUsers && this.getPortfolioUsers.length > 0 && 
          this.programUsers && this.programUsers.length > 0
          ){  
        let programUserIds = this.programUsers.map(p => p.id)
        return this.getPortfolioUsers.filter(u => !programUserIds.includes(u.id) )     
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
          this.lastName = '',
          this.firstName = '',
          this.email = ''
          this.newUserDialogVisible = false;
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

          this.SET_ADD_USERS_TO_PROGRAM_STATUS(0);
          this.fetchProgramUsers(this.programId);
          this.portfolioUsers = [];
          this.dialogVisible = false;
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