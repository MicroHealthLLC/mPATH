<template>
<!-- 
1.  Change button method handle
2.  On click, default text will be replaced by input box

-->
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
            <i class="fal fa-user-lock mr-1 bootstrap-purple-text"></i> Roles
            <span  
              v-if="tableData"          
              class="ml-2 pb-1 badge badge-secondary badge-pill pill"
              >{{ tableData.length }}
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
                @click.prevent="addRole"
                class="bg-primary text-light mb-2"
              >
               <i class="far fa-plus-circle mr-1"></i>Create New Role
              </el-button>
            </div>
         
          </div>
        </div>
      
     
    <div class="container-fluid mt-2 mx-0">
      
    <div  
    v-loading="!contentLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)"
    class="">

<el-tabs class="mt-1 mr-3" type="border-card"  @tab-click="handleClick">
    <el-tab-pane class="p-3"  style="postion:relative"  label="ADMIN">
    <el-table    
        v-if="tableData && tableData.length > 0"  
        :data="tableData"   
        height="450"
        :row-class-name="showHideCreateRow"
        >
    <el-table-column
      fixed
      prop="name"
      label="Admin Role"
      width="340">
    <template slot-scope="scope">
  <span v-if="scope.$index == 0">
    <el-input
    size="small"         
    style="font-style: italic; color: red"
    v-model="newRoleName"
    controls-position="right"
  >
  </el-input>
  </span> 
  <span v-else>
    {{ scope.row.name }}
  </span>

    </template>

    </el-table-column>
        <el-table-column label="Assigned Users" width="125" type="expand">

          
        </el-table-column>
    <el-table-column label="Program Admin">
      <el-table-column
        prop="read"
        label="Read"
        width="75">

      <template slot-scope="scope">
        <span
        class="watch_action clickable mx-2"      
        @click.prevent.stop="programAdminRead(scope.$index, scope.row)"    
          >
        <span 
        v-if="scope.row.read">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.read">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>   
        </span>    
       </template>
      </el-table-column>
       <el-table-column
        prop="write"
        label="Write"
        width="75">
        <template slot-scope="scope">
        <span
        class="watch_action clickable mx-2"
       
        @click.prevent.stop="programAdminWrite(scope.$index, scope.row)"    
          >
        <span 
        v-if="scope.row.write">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.write">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>   
        </span>    
       </template>
      </el-table-column>
      <el-table-column
        prop="delete"
        label="Delete"
       width="75">
       <template slot-scope="scope">
        <span
        class="watch_action clickable mx-2"
        
        @click.prevent.stop="programAdminDelete(scope.$index, scope.row)"    
          >
        <span 
        v-if="scope.row.delete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.delete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
        </span>       
       </template>
      </el-table-column>

    </el-table-column> -->
      <el-table-column label="Program Settings" >
        <el-table-column label="Groups">
            <el-table-column
            prop="groupsRead"
            label="Read"
            width="75">
        <template slot-scope="scope" >
        <span 
        v-if="scope.row.groupsRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.groupsRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>
        <el-table-column
        prop="groupsWrite"
        label="Write"
        width="75">
        <template slot-scope="scope">
        <span 
        v-if="scope.row.groupsWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.groupsWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>
        <el-table-column
            prop="groupsDelete"
            label="Delete"
           width="75">
       <template slot-scope="scope">
        <span 
        v-if="scope.row.groupsDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.groupsDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>
        </el-table-column>

        <el-table-column label="Projects">
            <el-table-column
            prop="projectsRead"
            label="Read"
            width="75">
       <template slot-scope="scope">
        <span 
        v-if="scope.row.projectsRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.projectsRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
            
        </el-table-column>
        <el-table-column
            prop="projectsWrite"
            label="Write"
            width="75">
       <template slot-scope="scope">
        <span 
        v-if="scope.row.projectsWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.projectsWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
            
        </el-table-column>
        <el-table-column
            prop="projectsDelete"
            label="Delete"
            width="75">
       <template slot-scope="scope">
        <span 
        v-if="scope.row.projectsDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.projectsDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>
        </el-table-column>


        <el-table-column label="Contracts">
            <el-table-column
            prop="contractsRead"
            label="Read"
            width="75">
        <template slot-scope="scope">
        <span 
        v-if="scope.row.contractsRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.contractsRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>
        <el-table-column
            prop="contractsWrite"
            label="Write"
            width="75">
        <template slot-scope="scope">
        <span 
        v-if="scope.row.contractsWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.contractsWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>
        <el-table-column
            prop="contractsDelete"
            label="Delete"
            width="75">
       <template slot-scope="scope">
        <span 
        v-if="scope.row.contractsDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.contractsDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>
        </el-table-column>


        <el-table-column label="Users" >
        <el-table-column
            prop="usersRead"
            label="Read"
           width="75">
        <template slot-scope="scope">
        <span 
        v-if="scope.row.usersRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.usersRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>
        <el-table-column
            prop="usersWrite"
            label="Write"
            width="75">
        <template slot-scope="scope">
        <span 
        v-if="scope.row.usersWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.usersWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>
        <el-table-column
            prop="usersDelete"
            label="Delete"
            width="75">
        <template slot-scope="scope">
        <span 
        v-if="scope.row.usersDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.usersDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>

        
        </el-table-column>      
      </el-table-column> 
        <el-table-column 
          fixed="right" 
          label="Actions"
          class="text-center "
          width="120">
           <template slot-scope="scope">
          <el-button
          type="default"
          v-tooltip="`Save edits`"
          v-if="showCreateRow === true && scope.$index == 0"
          @click.prevent="saveNewRole(scope.$index, scope.row)"
           class="bg-primary btn-sm text-light"
          >
        <i class="far fa-save"></i>
        </el-button>
        <el-button
          type="default"
          @click.prevent="test(scope.$index, scope.row)"
          class="bg-light btn-sm"
          v-tooltip="`Edit Role`"
        >
          <i class="fal fa-edit text-primary"></i>
        </el-button>
           </template>
          
         </el-table-column> 
    </el-table>






       <el-table    
        v-else  
        :data="firstRole"   
        height="450"
        :row-class-name="showHideCreateRow"
        >
    <el-table-column
      fixed
      prop="role"
      label="Admin Role"
      width="340">
 <template slot-scope="scope">
  <span>
    <el-input
    size="small"         
    style="font-style: italic; color: red"
    v-model="newRoleName"
    controls-position="right"
  >
  </el-input>
  </span>
 </template>

    </el-table-column>
        <el-table-column label="Assigned Users" width="125" type="expand">

          
        </el-table-column>
    <el-table-column label="Program Admin">
      <el-table-column
        prop="read"
        label="Read"
        width="75">

      <template slot-scope="scope">
        <span
        class="watch_action clickable mx-2"      
        @click.prevent.stop="programAdminRead(scope.$index, scope.row)"    
          >
        <span 
        v-if="scope.row.read">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.read">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>   
        </span>    
       </template>
      </el-table-column>
       <el-table-column
        prop="write"
        label="Write"
        width="75">
        <template slot-scope="scope">
        <span
        class="watch_action clickable mx-2"
       
        @click.prevent.stop="programAdminWrite(scope.$index, scope.row)"    
          >
        <span 
        v-if="scope.row.write">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.write">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>   
        </span>    
       </template>
      </el-table-column>
      <el-table-column
        prop="delete"
        label="Delete"
       width="75">
       <template slot-scope="scope">
        <span
        class="watch_action clickable mx-2"
        
        @click.prevent.stop="programAdminDelete(scope.$index, scope.row)"    
          >
        <span 
        v-if="scope.row.delete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.delete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
        </span>       
       </template>
      </el-table-column>

    </el-table-column> -->
      <el-table-column label="Program Settings" >
        <el-table-column label="Groups">
            <el-table-column
            prop="groupsRead"
            label="Read"
            width="75">
        <template slot-scope="scope" >
        <span 
        v-if="scope.row.groupsRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.groupsRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>
        <el-table-column
        prop="groupsWrite"
        label="Write"
        width="75">
        <template slot-scope="scope">
        <span 
        v-if="scope.row.groupsWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.groupsWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>
        <el-table-column
            prop="groupsDelete"
            label="Delete"
           width="75">
       <template slot-scope="scope">
        <span 
        v-if="scope.row.groupsDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.groupsDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>
        </el-table-column>

        <el-table-column label="Projects">
            <el-table-column
            prop="projectsRead"
            label="Read"
            width="75">
       <template slot-scope="scope">
        <span 
        v-if="scope.row.projectsRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.projectsRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
            
        </el-table-column>
        <el-table-column
            prop="projectsWrite"
            label="Write"
            width="75">
       <template slot-scope="scope">
        <span 
        v-if="scope.row.projectsWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.projectsWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
            
        </el-table-column>
        <el-table-column
            prop="projectsDelete"
            label="Delete"
            width="75">
       <template slot-scope="scope">
        <span 
        v-if="scope.row.projectsDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.projectsDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>
        </el-table-column>


        <el-table-column label="Contracts">
            <el-table-column
            prop="contractsRead"
            label="Read"
            width="75">
        <template slot-scope="scope">
        <span 
        v-if="scope.row.contractsRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.contractsRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>
        <el-table-column
            prop="contractsWrite"
            label="Write"
            width="75">
        <template slot-scope="scope">
        <span 
        v-if="scope.row.contractsWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.contractsWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>
        <el-table-column
            prop="contractsDelete"
            label="Delete"
            width="75">
       <template slot-scope="scope">
        <span 
        v-if="scope.row.contractsDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.contractsDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>
        </el-table-column>


        <el-table-column label="Users" >
        <el-table-column
            prop="usersRead"
            label="Read"
           width="75">
        <template slot-scope="scope">
        <span 
        v-if="scope.row.usersRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.usersRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>
        <el-table-column
            prop="usersWrite"
            label="Write"
            width="75">
        <template slot-scope="scope">
        <span 
        v-if="scope.row.usersWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.usersWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>
        <el-table-column
            prop="usersDelete"
            label="Delete"
            width="75">
        <template slot-scope="scope">
        <span 
        v-if="scope.row.usersDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
        <span 
        v-show="!scope.row.usersDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>       
       </template>
        </el-table-column>

        
        </el-table-column>      
      </el-table-column> 


        <el-table-column 
          fixed="right" 
          label="Actions"
          class="text-center "
          width="120">
           <template slot-scope="scope">
          <el-button
          type="default"
          v-tooltip="`Save edits`"
          v-if="showCreateRow === true && scope.$index == 0"
          @click.prevent="saveNewRole(scope.$index, scope.row)"
           class="bg-primary btn-sm text-light"
          >
        <i class="far fa-save"></i>
        </el-button>
        <el-button
          type="default"
          @click.prevent="test(scope.$index, scope.row)"
          class="bg-light btn-sm"
          v-tooltip="`Edit Role`"
        >
          <i class="fal fa-edit text-primary"></i>
        </el-button>
           </template>
          
         </el-table-column> 
    </el-table> 
    </el-tab-pane>
     <el-tab-pane class="p-3"  style="postion:relative"  label="PROJECTS">
          <SettingsRolesProjects/>
     </el-tab-pane>
      <el-tab-pane class="p-3"  style="postion:relative"  label="CONTRACTS">
          <SettingsRolesContracts/>
     </el-tab-pane>
</el-tabs>
    </div>
      
    </div>
    </div>

    </div>
    

</div>
</template>

<script>
 

import { mapGetters, mapMutations, mapActions } from "vuex";
import SettingsSidebar from "../SettingsSidebar.vue";
import SettingsRolesProjects from "./SettingsRolesProjects.vue"
import SettingsRolesContracts from "./SettingsRolesContracts.vue"
export default {
  name: "SettingsRolesIndex",
  components: {
    SettingsSidebar,
    SettingsRolesProjects,
    SettingsRolesContracts
  },
    data() {    
      return {
       addRoleDialogOpen: false, 
       showCreateRow: false, 
       newRoleName: "Enter New Role Name",
        firstRole: [
          {
          role: 'Enter New Role Name',        
          read: true,
          write: true,
          delete: false,  

          groupsRead: true, 
          groupsWrite: true, 
          groupsDelete: true, 
          
          projectsRead: true, 
          projectsWrite: true, 
          projectsDelete: true, 
          
          contractsRead: true, 
          contractsWrite: true, 
          contractsDelete: true, 

          usersRead: true, 
          usersWrite: true, 
          usersDelete: true, 
         }
        ],
        usersArray: [
          {
          id: 2,        
          email: "",
          first_name: "Joe",
          last_name: "Smith", 
          full_name:"Joe Smith", 
          title: "",
          roles: [
              {
              role_name: 'role_one',
              role_id: 1,
              contract_ids: [67, 45, 78, 99],
              project_ids:[5, 4, 78, 90]
              },{
              role_name: 'role_two',
              role_id: 2,
              contract_ids: [3, 5, 6, 8, 9],
              project_ids:[123, 56, 32, 58]
              },{
              role_name: 'role_three',
              role_id: 3,
              contract_ids: [3, 5, 6, 8, 9],
              project_ids:[123, 56, 32, 58]

              }
          ],          
         },{
          id: 3,        
          email: "",
          first_name: "Jane",
          last_name: "Summers", 
          full_name:"Jane Summers", 
          title: "",
          roles: [
              {
              role_name: 'role_one',
              role_id: 1,
              contract_ids: [],
              project_ids:[]
              },{
              role_name: 'role_two',
              role_id: 2,
              contract_ids: [3, 5, 6, 8, 9],
              project_ids:[123, 56, 32, 58]
              },{
              role_name: 'role_three',
              role_id: 3,
              contract_ids: [3, 5, 6, 8, 9],
              project_ids:[123, 56, 32, 58]

              }
          ],          
         },
         
         
         ],
         newRoleRow: [{
          role: 'Enter Name',        
          read: true,
          write: true,
          delete: false,  

          groupsRead: true, 
          groupsWrite: true, 
          groupsDelete: true, 
          
          projectsRead: true, 
          projectsWrite: true, 
          projectsDelete: true, 
          
          contractsRead: true, 
          contractsWrite: true, 
          contractsDelete: true, 

          usersRead: true, 
          usersWrite: true, 
          usersDelete: true, 
        },]
      }
  },
  methods: {
    ...mapMutations(["SET_NEW_ROLE_STATUS"]),
  ...mapActions(["fetchRoles", "createRole"]),
    programAdminRead(rows, index) {
        // console.log(index) 
      index.read = !index.read
    },
    // createNewRole() {
    //   let newRoleData = {
    //     roleData: {
    //        name: this.roleName,
    //        uId: this.userId,
    //        pId: this.$$route.params.programId,
    //        rp: [
    //           {
    //             privilege: this.privilege,
    //             role_type: this.roleType,
    //             name: this.rpName, 
    //           }
    //        ],
    //     },
    //   };
    //   this.createRole({
    //     ...newRoleData,
    //   });
    //   // this.hideSaveBtn = true;
    // },
    showHideCreateRow(row, index){   
      // console.log(row.rowIndex)    
        return row.rowIndex == 0 && !this.showCreateRow ? 'd-none' : '';
    },
    programAdminWrite(rows, index) {
     index.write = !index.write
    },
     programAdminDelete(rows, index) {
      index.delete = !index.delete
    },
    addRole(){
      // this.addRoleDialogOpen = true
      this.showCreateRow = !this.showCreateRow     
    },
    closeAddRole() {
      this.addRoleDialogOpen = false;
    },
    test(rows, index){
    
      console.log(rows)
      console.log(index)
// console.log(index)
// console.log(rows)
// console.log(index)
    },
  saveNewRole(rows, index){
        let newRoleData = {
        role: {
           name: this.newRoleName,
           uId: '',
          //  role_users: [{}],
           pId: this.$route.params.programId,
            rp: [
              {
                privilege: "RWD",
                role_type: "program_admin",
                name: "program_test", 
              }, 
              {
                privilege: "RWD",
                role_type: "groups",
                name: "program_test", 
              },
              {
                privilege: "RWD",
                role_type: "users",
                name: "program_test", 
              },
              {
                privilege: "RWD",
                role_type: "projects",
                name: "program_test", 
              }, 
              {
                privilege: "RWD",
                role_type: "contracts",
                name: "program_test", 
              },
            ],
        },
      };
      this.createRole({
        ...newRoleData,
      });
     this.showCreateRow = !this.showCreateRow
    },
    handleClick(tab, event) { 
        //Route redirecting incase we want to assign url paths to each tab
        // if(tab.index == 1) {
        //  this.$router.push({ name: "SettingsRolesProjects" })
        // }    
   
    },

   },
  mounted() {
 this.fetchRoles(this.$route.params.programId)
 if (this.getRoles && this.getRoles.length > 0){
 console.log(this.getRoles)
 }

  },
  computed: {
    ...mapGetters([
        "contentLoaded",
        "currentProject",
        "getPortfolioUsers",
        "activeProjectUsers",
        "newRoleStatus",
        "getRoles",
        "new"
    ]),
     backToSettings() {
      return `/programs/${this.$route.params.programId}/settings`;
    },
    tableData(){
      if(this.getRoles && this.getRoles.length > 0)
      return this.getRoles
    },
    },
  watch: { 
    newRoleStatus: {
      handler() {
        if (this.newRoleStatus == 200) {
          this.$message({
            message: `successfully added to your program.`,
            type: "success",
            showClose: true,
          });
          this.SET_NEW_ROLE_STATUS(0);
          this.fetchRoles(this.$route.params.programId)
          // this.lastName = '',
          // this.firstName = '',
          // this.email = ''
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
/deep/.el-dialog__close.el-icon.el-icon-close {
  display: none;
}
.addRoleDialog {
  /deep/.el-dialog__body {
  padding-top: 0 !important;
 }
 /deep/.el-dialog__header{
  padding-bottom: 0 !important;  
 } 
}
.buttonWrapper {
  border-bottom: lightgray solid 1px;
}
/deep/.el-dialog__header.users{
  padding: 0;
}
/deep/.el-table th.el-table__cell > .cell {
  color: #383838;
//   font-size: .9rem;
  text-align: center;
}
.modalBtns {
  box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
}
/deep/.el-input__inner{
  border: 1px solid #d9534f;
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