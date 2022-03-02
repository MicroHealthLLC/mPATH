<template>
<div 
  v-loading="!contentLoaded"
  element-loading-text="Fetching your data. Please wait..."
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
             <i class="fas fa-users mr-1 text-secondary"></i> USERS
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
              <i class="fas fa-users mr-1"></i>  Add Exisiting User(s)
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
        v-loading="!programUsers"
        element-loading-text="Fetching your data. Please wait..."
        element-loading-spinner="el-icon-loading"
        element-loading-background="rgba(0, 0, 0, 0.8)"
        class="">
        <el-table
        v-if="programUsers && programUsers.length > 0"
        :data="
            userData
            .filter(
                (data) =>
                !search ||
                data.full_name.toLowerCase().includes(search.toLowerCase())
            )
            .reverse()
        "
        style="width: 100%"
        height="450"
        >
        <el-table-column prop="first_name"  sortable label="First Name">
            <template slot-scope="scope">       
            <el-input
            size="small"
            v-if="rowId == scope.row.id"
            style="text-align:center"
            v-model="scope.row.firstName"
            controls-position="right"
            ></el-input>
            <span v-else> {{ scope.row.first_name }}</span>
            </template>
        </el-table-column>
        <el-table-column
            prop="last_name"
            sortable
            filterable
            label="Last Name"
        >
            <template slot-scope="scope">
            {{ scope.row.last_name}}
            <!-- <el-input
                size="small"
                style="text-align:center"
                v-model="scope.row.facilityGroupName"
            ></el-input> -->
            </template>
        </el-table-column>
     
     
        <!--BEGIN Expandable Column Containing Priveleges Info -->
         <el-table-column type="expand" label="Privileges" width="100">
       <!-- <template slot-scope="scope"> -->
       <!-- <div class="container-fluid pt-0"> 
         <div class="row rowPrivileges" >      -->
   
          <!-- Privileges Table 1 -->
      <div class="">
      <el-table
        :data="projectsTable"
        style="width: 100%"
        border
        :header-cell-style="{ background: '#EDEDED' }"
      >
      <el-table-column prop="role"  sortable label="Project Roles">
      
      </el-table-column>
      <el-table-column
          prop="projects"
          sortable
          filterable
          label="Projects"
      >        
      </el-table-column> 
       <el-table-column label="Actions" align="center"  width="75">
          <!-- <template slot-scope="scope" > -->
            <!-- USe this attribute when functionaloty gets built in -->
                <!-- @click.prevent="removeUser(scope.$index, scope.row)"    -->
       <span v-tooltip="`Manage Project Privileges`">
          <i class="fas fa-user-lock"></i>               
          </span>
  
          <!-- <el-button type="primary" @click="handleEditRow(scope.$index)">Edit</el-button> -->
          <!-- </template> -->
      </el-table-column>   
      </el-table>
      <!-- Table 2 -->
        <el-table
            :data="contractsTable"
            style="width: 100%"
            border
            :header-cell-style="{ background: '#dda769' }"
            >
          <el-table-column prop="role"  sortable label="Contract Roles">
          
          </el-table-column>
          <el-table-column
              prop="contracts"
              sortable
              filterable
              label="Contracts"
          >
          </el-table-column>
          <el-table-column label="Actions"  align="center" width="75">
              <!-- <template slot-scope="scope" > -->
              <!-- USe this attribute when functionaloty gets built in -->
                    <!-- @click.prevent="removeUser(scope.$index, scope.row)"    -->
              <span v-tooltip="`Manage Contract Privileges`">
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
        
        </div>  
        <div class="mt-3 text-right">
          <button
            @click.prevent="createUser"
            class="btn btn-sm bg-primary text-light mr-2 modalBtns"
            v-tooltip="`Save New User`"               
          >
          <i class="fal fa-save mr-1"></i> SAVE
        </button>
         <button
            @click.prevent="cancelAddNewUser"
           class="btn btn-sm bg-danger text-light modalBtns"
            v-tooltip="`Cancel`"               
          >
         <i class="fal fa-window-close mr-1"></i> CANCEL
        </button>
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
      <div class="container">      
        <div class="row">
          <div class="col-12">
          <label class="font-md mb-0">Search and select Users</label>
              <el-select
                v-model="portfolioUsers"
                class="w-100"
                v-if="getPortfolioUsers.length > 0 && programUsers"
                track-by="id"
                value-key="id"
                :multiple="true"
                clearable
                placeholder="Enter name"     
                filterable
              >
                <el-option
                  v-for="item in getPortfolioUsers.filter(u => !programUsers.map(p => p.id).includes(u.id))"
                  :value="item"
                  :key="item.id"
                  :label="item.full_name"
                >
                </el-option>
              </el-select>
            <button
                type="default"            
                class="btn btn-primary text-light mt-3 float-right modalBtns"
               >
                <i class="far fa-plus-circle mr-1"></i> Add Users to Program
            </button>
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
      <div class="container">  
        <div class="row">
          <div class="col-12">
             <form accept-charset="UTF-8">
               <label class="mb-0 pb-0 text-dark"
                >First Name </label
              >
              <el-input
                class="mb-2 pl-1"
                v-model="rowUser.first_name"
                placeholder="Enter new Group name here"
                rows="1"
                />
               <label class="mb-0 pb-0 text-dark"
                >Last Name</label
              >
              <el-input
                v-model="rowUser.last_name"
                class="mb-2 pl-1"
                placeholder="Enter new Group name here"
                rows="1"    
              />
             <label class="mb-0 pb-0 text-dark"
                >Title</label
              >
               <el-input
                v-model="rowUser.title"
                class="mb-2 pl-1"
                rows="1"               
              />
               <label class="mb-0 pb-0 text-dark"
                >Email</label>
               <el-input
                v-model="rowUser.email"
                placeholder="Enter new Group name here"
                rows="1"  
                class="mb-2 pl-1"        
              />

      <div class="my-3 float-right">
         <button
            @click.prevent="saveUserEdits"
            class="btn btn-sm bg-primary text-light mr-2 modalBtns"
            v-tooltip="`Save New User`"               
          >
          <i class="fal fa-save mr-1"></i>SAVE
        </button>
          <button
            @click.prevent="cancelEdits"
           class="btn btn-sm bg-danger text-light modalBtns"
            v-tooltip="`Close`"               
          >
         <i class="fal fa-window-close mr-1"></i> CLOSE
        </button>
      </div>
           </form>
          </div> 
                
        </div>    
      </div>
    </el-dialog>

  <!-- Permissions Profile modal -->
    <!-- <el-dialog
        :visible.sync="privilegesProfileVisible"
        append-to-body
        center
        class="p-0 users"       
      >
      <span slot="title" class="text-left">
        <h4 class="text-dark"> <i class="fal fa-user-lock mr-2 bootstrap-purple-text"></i>PRIVILEGES PROFILE </h4>
      </span>

       <div class="container pt-0"> 
         <div class="row">       
          <div class="col-6 py-0" v-if="userPrivileges">
     
         <h5 class="text-dark" style="text-decoration:underline" >User: {{ userPrivileges.full_name}}</h5>
          </div>
       
        </div>       
        <div class="row">       
          <div class="col-6">
        <el-table
          :data="projectsTable"
          style="width: 100%"
          border
        >
        <el-table-column prop="project"  sortable label="Project">
        
        </el-table-column>
        <el-table-column
            prop="role"
            sortable
            filterable
            label="Role"
        >
        
         
        </el-table-column>

    
        </el-table>
        
          </div>
          <div class="col-6">
         <el-table
          :data="projectsTable"
          style="width: 100%"
          border
        >
        <el-table-column prop="project"  sortable label="Contracts">
        
        </el-table-column>
        <el-table-column
            prop="role"
            sortable
            filterable
            label="Role"
        >
        
         
        </el-table-column>

    
        </el-table>
             
          </div>
        </div>
     
    
       </div>
     
        
        

      </el-dialog>
     -->
    </div>

    </div>
    

</div>
</template>

<script>
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
export default {
  name: "SettingsUsers",
  components: {
    SettingsSidebar,
  },


    data() {    
      return {
        search:"",
        autoCompleteSearch:"",
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
        ],
        contractsTable: [
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
      "SET_NEW_USER_STATUS"
    ]),
  ...mapActions(["fetchPortfolioUsers", "createNewUser", "updateUserData"]),
    selectResult(user) {
      this.autoCompleteSearch = user.fullName;
    },
     handleClick(tab, event) { 
        //Route redirecting incase we want to assign url paths to each tab
        // if(tab.index == 1) {
        //  this.$router.push({ name: "SettingsRolesProjects" })
        // }    
   
    },
   addUser() {
      this.dialogVisible = true; 
    },
    // contractsHeader(){
    //   return ''
    // },
    openCreateUser(){
      this.newUserDialogVisible = true
    },
    createUser() {
      let newUserData = {
        newUser: {
           fName: this.firstName,
           lName: this.lastName,
           email: this.email,
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
    openUserPrivileges(index, rows){
      this.privilegesProfileVisible = true;
      this.userPrivileges = rows
      console.log(rows)
  
    },
   saveUserEdits() {
     let editUserData = {
        userData: {
          fName: this.rowUser.first_name,
          lName: this.rowUser.last_name,
          email: this.rowUser.email,
          title: this.rowUser.title,
          id:    this.rowUser.id
        },
      };
      this.updateUserData({
        ...editUserData   
      });
      // this.rowIndex = null;
      // this.rowId = null;
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
        "newUserStatus"
    ]),
    userData(){
      if(this.getPortfolioUsers && this.getPortfolioUsers.length > 0){
      return this.getPortfolioUsers
     }       
    },
    programUsers(){
     if(this.currentProject && this.currentProject.users && this.currentProject.users.length > 0) {
     if(this.getPortfolioUsers && this.getPortfolioUsers.length > 0){
      // return this.getPortfolioUsers.filter(u => this.currentProject.users.map(cP => cP.id).includes(u.id))
       return this.currentProject.users.filter(u =>  this.getPortfolioUsers.map(cP => cP.id).includes(u.id))
       }  
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
          });
          this.SET_NEW_USER_STATUS(0);
          this.lastName = '',
          this.firstName = '',
          this.email = ''
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