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
            <i class="fal fa-clipboard-list mr-1 mh-green-text"></i> PROJECTS
            <span 
              v-if="projectData && projectData.length"
              class="ml-2 pb-1 badge badge-secondary badge-pill pill"
              >{{ projectData.length }}
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
            <div class="col" >
              <el-button
                @click.prevent="addProject"
                v-if="_isallowed('write')"
                class="bg-primary text-light mb-2"
              >
                <i class="far fa-plus-circle mr-1"></i> Create Project
              </el-button>
            </div>

            <div class="col">
              <el-input
                type="search"
                placeholder="Search Projects"
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
                v-model="C_groupFilter"
                track-by="id"
                value-key="id"
                multiple
                filterable
                clearable
                name="Project Group"
                placeholder="Filter Projects By Group"
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
    v-if="_isallowed('read')"
    class="">
        <el-table
          :key="componentKey"   
          v-if="projectData && projectData.length > 0"
          :data="
            projectData
              .filter(
                (data) =>
                  !search ||
                  data.facilityName.toLowerCase().includes(search.toLowerCase())
              )
              .reverse()
          "
          style="width: 100%"
          height="450"
          highlight-current-row
          :row-key="row => row.id"
          :expand-row-keys="expandRowKeys"
          @expand-change="handleExpandChange" 
         :default-sort="{ prop: 'facilityName', order: 'ascending'}" 
        >
          <el-table-column prop="facilityName"  sortable label="Project">
            <template slot-scope="scope">
           
           
              <el-input
                size="small"
                v-if="rowId == scope.row.id"
                style="text-align:center"
                v-model="scope.row.facilityName"
                controls-position="right"
              ></el-input>
              <span v-else> {{ scope.row.facilityName }}</span>
            </template>
          </el-table-column>
          <el-table-column
            prop="facilityGroupName"
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
              {{ scope.row.facilityGroupName }}
               </span>
              <!-- <el-input
                size="small"
                style="text-align:center"
                v-model="scope.row.facilityGroupName"
              ></el-input> -->
            </template>
          </el-table-column>
          <el-table-column label="Actions" align="right">
            <template slot-scope="scope">
              <el-button
                type="default"
                @click="saveEdits(scope.$index, scope.row)"
                v-if="scope.$index == rowIndex" 
                v-tooltip="`Save`" 
                class="bg-primary btn-sm text-light">               
               <i class="far fa-save"></i>
               </el-button>
              <el-button 
                type="default" 
                v-tooltip="`Cancel Edit`"       
                v-if="scope.$index == rowIndex"
                @click.prevent="cancelEdits(scope.$index, scope.row)"  
                class="bg-secondary btn-sm text-light">
              <i class="fas fa-ban"></i>
                </el-button>
              <el-button  
                type="default" 
                v-tooltip="`Edit Project Name or Change Group`"
                @click.prevent="editMode(scope.$index, scope.row)" 
                v-if="scope.$index !== rowIndex "
                class="bg-light btn-sm">
                <i class="fal fa-edit text-primary" ></i>
               </el-button>  
                 <el-button  
                type="default" 
                v-tooltip="`Add User(s) to Project`"
                @click.prevent="addUserRole(scope.$index, scope.row)" 
                v-if="scope.$index !== rowIndex "
                class="bg-primary text-light btn-sm">
             <i class="fas fa-users-medical mr-1"></i>
               </el-button>  
          
              <el-button
                type="default"
                v-tooltip="`Go to Project`"
                @click.prevent="goToProject(scope.$index, scope.row)"
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
        <el-dialog
          :visible.sync="dialogVisible"
          append-to-body
          center
          class="contractForm p-0 addProjectDialog"
        >
        <span slot="title" class="text-left add-groups-header ">
          <h5 class="text-dark"> <i class="far fa-plus-circle mr-1 mb-3"></i>Create Project </h5>
        </span>
          <form accept-charset="UTF-8">
            <div class="form-group mx-4">
              <label class="font-md"
                >Project Name <span style="color: #dc3545">*</span></label
              >
              <el-input
               v-model="newProjectNameText"
                placeholder="Enter New Project Name"
                rows="1"
                name="Project Name"
              />
            </div>
            <div class="form-group mx-4">
              <label class="font-md">Group</label>
              <el-select
                class="w-100"
                v-model="C_projectGroupFilter"
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
                @click.prevent="saveNewProject"
                v-show="newProjectNameText"
                v-tooltip="`Save Project`"    
                :class="[hideSaveBtn ? 'd-none' : '']"  
                class="btn btn-md bg-primary text-light modalBtns"
                >  <i class="far fa-save"></i></button
              >
              <button
                @click.prevent="addAnotherProject"
                :class="[!hideSaveBtn ? 'd-none' : '']"
                v-tooltip="`Add Another Project`"
                class="btn btn-md bg-primary text-light modalBtns"
              >
                <i class="far fa-plus-circle"></i> 
              </button>
              <button
                @click.prevent="cancelCreateGroup"
                class="btn btn-md bg-secondary text-light modalBtns"
                v-tooltip="`Close`"                  
              >
               <i class="fas fa-ban"></i> 
              </button>
            </div>
          </form>
        </el-dialog>


         <el-dialog
          :visible.sync="rolesVisible"
          append-to-body
          center
          class="contractForm p-0 addUserRole"
        >
       <span slot="title" class="text-left add-groups-header ">
        <h5 style="color:#383838" v-if="projectRowData"> 
            <i class="fal fa-clipboard-list mr-1 mb-2 mh-green-text"></i> {{ projectRowData.facilityName }}
        </h5> 
        </span>
         <div class="container-fluid p-2">

             <div class="pl-4 mt-0 row">
            <div class="col-5 pt-0">
             <label class="font-md mb-0 d-flex">Add User(s) To Project </label>
             <el-select
              v-model="projectRoleUsers"
              filterable           
              class="w-100"
              clearable
              multiple
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
              v-model="projectRoleNames"
              filterable           
              class="w-100"
              clearable
              track-by="id"
              value-key="id"
              placeholder="Search and select Project Users"          
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
                <div class="col-2 pt-0">
              <label class="font-md mb-0 d-flex" style="visibility:hidden">|</label>
                              
                <el-button
                type="default"
                @click="saveProjectUserRole()"
                v-if="projectRoleNames && projectRoleUsers"
                v-tooltip="`Confirm`" 
                class="bg-ligh btn-sm mr-1">               
                 <i class="fal fa-clipboard-list mr-2 mh-green-text"></i>  Confirm
               </el-button>
      
              </div>             
             
            </div>
      
      <div class="mt-4 row">
        <div class="col-12 pt-0">
 
        <!-- <el-collapse id="" class=""  v-if="projectUsers && projectUsers.length > 0">
            <el-collapse-item title="SEE PROJECT'S USERS AND ROLES" name="1"> -->
          <el-table
            v-if="projectUsers && projectUsers.length > 0"
            :header-cell-style="{ background: '#EDEDED' }"
            :data="projectUsers.filter(
                  (data) =>
                    !searchRoleUsers || 
                    data.role_name.toLowerCase().includes(searchRoleUsers.toLowerCase()) ||
                    data.user_full_name.toLowerCase().includes(searchRoleUsers.toLowerCase())
                )"           
            height="450"
            width="auto"
            class="pl-4"
            > 
           <el-table-column  prop="user_full_name"
              sortable
              filterable
              label="Users">
              <template slot-scope="scope">
              <span v-if="projId && projId == scope.row.facility_project_id">
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
              <span v-if="projId && projId == scope.row.facility_project_id && scope.row.role_name">
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
          <span  class="pl-4" v-else>
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
         <!-- </el-collapse-item>
        </el-collapse>  -->
        </div>
      </div>
          </div>
      
        </el-dialog>
         </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { mapActions, mapGetters, mapMutations } from "vuex";
import SettingsSidebar from "./SettingsSidebar.vue";
import { API_BASE_PATH } from "./../../../mixins/utils";

export default {
  name: "SettingsProjects",
  components: {
    SettingsSidebar
  },
  props: ["currentFacility", "facility"],
  data() {
    return {
      dialogVisible: false,
      rolesVisible: false,
      expandRowKeys: [],      
      componentKey: 0,
      programId: this.$route.params.programId,
      search: "",
      searchRoleUsers: '',
      rowIndex: null,
      rowId: null,
      projId: null, 
      projectRowData: null, 
      hideSaveBtn: false,
      projectId: null, 
      searchContractUsers:"",
      selectedProjectGroup: null,
      newProjectNameText: "",
      value: "",
        contractUser: [
        {          
          user: 'John Doe',
          roles: 'project-write, project-read',
          last_name: 'Doe'
        }, {
          user: 'Bob Dole',
          roles: 'project-write',
          last_name: 'Dole'
        }, {
          user: 'Adam Smith',
          roles: 'project-write, project-read, project-delete',
          last_name: 'Smith'
       }, {
          user: 'Samantha Smith',
          roles: 'project-write, project-read',
          last_name: 'Smith'
        }, {
          user: 'Curtis Smith',
          roles: 'project-write, project-read',
          last_name: 'Smith'
        }, {
          user: 'Daisy Rivera',
          roles: 'project-write, project-read',
          last_name: 'Rivera'
        }, 
       
        ],
     };
  },
 mounted(){
    if(this.groups && this.groups.length <= 0){
    this.fetchGroups(this.$route.params.programId);
    }
    //Move fetchRole back to row click method
  this.fetchRoles(this.$route.params.programId)
  },
  methods: {
    ...mapActions([
      "fetchFacilities", 
      "fetchCurrentProject", 
      "fetchGroups", 
      "addUserToRole", 
      "fetchRoles"
      ]),
    ...mapMutations([
      "setProjectGroupFilter", 
      "setGroupFilter", 
      "SET_ADD_USER_TO_ROLE_STATUS", 
      "SET_PROJECT_ROLE_USERS",
       "SET_PROJECT_ROLE_NAMES"      
      ]),
      goToProject(index, rows) {  
      window.location.pathname = `/programs/${this.programId}/sheet/projects/${rows.id}/`
    },
    cancelCreateGroup() {
      this.dialogVisible = false;
    },
    closeUserRoles() {
      this.rolesVisible = false;
    },
    addAnotherProject() {
      this.C_projectGroupFilter = "";
      this.newProjectNameText = "";
      this.hideSaveBtn = false;
    },
    handleExpandChange (row, expandedRows) {
			this.projId = row.facilityProjectId;
			const lastId = this.expandRowKeys[0];
			this.expandRowKeys = this.projId  === lastId ? [] : [this.projId];   
      //Commenting out setter.  Useful if we want saved users to populate dropdown upon loading
      // this.SET_PROJECT_ROLE_USERS(this.assignedUsers)
		}, 
    addUserRole(index, rows) {
      this.rolesVisible = true
      this.projId = rows.facilityProjectId
      this.projectRowData = rows
      console.log(rows)
    },
    addProject() {
      this.dialogVisible = true;
      this.C_projectGroupFilter = null;
      this.newProjectNameText = "";
    },
    editMode(index, rows) {
      this.rowIndex = index
      this.rowId = rows.id
     },
    saveNewProject(e) {
      e.preventDefault();
      let formData = new FormData();
      formData.append("facility[facility_name]", this.newProjectNameText);
      if (this.C_projectGroupFilter !== null) {
        formData.append(
          "facility[facility_group_id]",
          this.C_projectGroupFilter.id
        );
      }
      formData.append("facility[status]", "active");
      formData.append("facility[project_ids][]", this.$route.params.programId);
      formData.append("commit", "Create Project");
      let url = `${API_BASE_PATH}/programs/${this.$route.params.programId}/projects`;
      let method = "POST";
      axios({
        method: method,
        url: url,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      }).then((response) => {
        if (response.status === 200) {
          this.$message({
            message: `New Project ${this.newProjectName} has been saved successfully.`,
            type: "success",
            showClose: true,
          });
         this.fetchCurrentProject(this.programId)
         this.hideSaveBtn = true;
        }
      });
    },
  cancelEdits(index, rows) {
       this.rowIndex = null;
       this.rowId = null;
       
    },
  saveProjectUserRole(index, rows){
    let userIds = this.projectRoleUsers.map(t => t.id)
    let projectUserRoleData = {
          userData: {
            roleId: this.projectRoleNames.id,
            userIds: userIds,
            programId: this.$route.params.programId, 
            projectId: this.projId          
         },
      };
      this.addUserToRole({
        ...projectUserRoleData,
      });
    },
    saveEdits(index, rows) {
      let updatedProjectName = rows.facilityName;
      let projectId = rows.id;
      let formData = new FormData();
      formData.append("facility[facility_name]", updatedProjectName);
      // Need one url to support these two data name edits
      formData.append("facility[facility_group_id]", rows.facilityGroupId);
      let url = `${API_BASE_PATH}/programs/${this.$route.params.programId}/projects/${projectId}`;
      let method = "PUT";
      axios({
        method: method,
        url: url,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      }).then((response) => {
        if (response.status === 200) {
          this.$message({
            message: `Edits has been saved successfully.`,
            type: "success",
            showClose: true,
          });
          this.fetchCurrentProject(this.programId)
       this.rowIndex = null;
       this.rowId = null;
        }
      });
    },
    _isallowed(salut) {
      return this.checkPrivileges("SettingsProjects", salut, this.$route, {settingType: "Projects"})
   }, 
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "currentProject",
      "projectsLoaded",
      "facilities",
      "facilityGroups",
      "groups",
      "getRoles",
      "getRolesLoaded",
      "getTransferData",
      "getNewGroups",
      "tableData",
      "projectUserRoles",
      "getProjectGroupFilter",
      "getProjectRoleUsers",
       "getProjectRoleNames",     
      "getGroupFilter",
      "facilityGroupFacilities",
      "filteredFacilityGroups",
       "addUserToRoleStatus"
    ]),
    // Filter for Projects Table
    C_groupFilter: {
      get() {
        return this.getGroupFilter;
      },
      set(value) {
        // console.log(value)
        this.setGroupFilter(value);
      },
    },
    projectUsers(){
      if(this.getRoles && this.getRoles.length > 0 ){   
        let roleUsers = this.getRoles.map(t => t.role_users).filter(t => t.length > 0)   
      if (this.projId)  {
            return [].concat.apply([], roleUsers).filter(t => this.projId == t.facility_project_id)
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
  
    groupList() {
     if (
        this.groups &&        
         this.groups.length > 0  &&
         this.getTransferData && 
         this.getTransferData.length > 0
         )
         {
        return this.groups.filter(u => this.getTransferData.includes(u.id))
         } else if (
        this.groups &&        
         this.groups.length > 0  &&
         this.facilityGroups && this.facilityGroups.length > 0 &&
         !this.getTransferData
         )
         {
         let programGroupIds = this.facilityGroups.map(t => t.id)
          return this.groups.filter(u => programGroupIds.includes(u.id))
         } else return []
    }, 

    backToSettings() {
      return `/programs/${this.$route.params.programId}/settings`;
    },
    // Filter when adding new Project
    C_projectGroupFilter: {
      get() {
        return this.getProjectGroupFilter;
      },
      set(value) {
        // console.log(value)
        this.setProjectGroupFilter(value);
      },
    },
    // assignedUsers(){
       //Commenting out this setter which is executed in the handleExpandChange() method.  Useful if we want saved users to populate dropdown upon loading
    //   if(this.programUsers && this.projectUsers && this.projectUsers.length > 0){
    //     return this.programUsers.filter(t => this.projectUsers.map(t => t.user_id).includes(t.id))
    //   }
    // },
    projectRoleUsers: {     
     get() {
       return this.getProjectRoleUsers
      },
      set(value) {
         this.SET_PROJECT_ROLE_USERS(value)
         console.log(value)
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
    projectData() {
      if (
        // this.projectsLoaded &&
        this.facilities &&
        this.facilities.length > 0 
      ) {
        return (
          this.facilities.filter((td) => {
              if (this.C_groupFilter && this.C_groupFilter.length > 0) {
                let group = this.C_groupFilter.map((t) => t.name);
                return group.includes(td.facilityGroupName);
              } else return true;
            })
        );
      }
    },
  },
   watch: { 
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
           this.SET_PROJECT_ROLE_NAMES([])
          this.SET_PROJECT_ROLE_USERS([])
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
.right {
  text-align: right;
}
/deep/.el-collapse-item__header {
  padding-left: 1.5rem;
}
.fa-calendar {
  font-size: x-large;
}
/deep/.el-table th.el-table__cell > .cell {
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
/deep/.el-table__row .el-input .el-input__inner {
  border-style: none;
}
/deep/.el-table__header, .el-table{
  width: auto !important;
}
/deep/.hover-row .el-input .el-input__inner {
  border-style: none;
}
/deep/.el-table {
  .el-input__inner {
    font-size: 16px !important;
    font-weight: 300 !important;
  }
}
/deep/.el-dialog__close.el-icon.el-icon-close {
  display: none;
}
h5 {
  word-break: break-word;
}
.addProjectDialog {
  /deep/.el-dialog__body {
  padding-top: 0 !important;
 }


}
.addUserRole {
  /deep/.el-dialog__body {
  padding-top: 0 !important;
 }
 /deep/.el-dialog {
  width: 55%;
  }
}

.addProjectDialog {
  /deep/.el-dialog__body {
  padding-top: 0 !important;
 }
 /deep/.el-dialog {
  width: 30%;
}
}
</style>
