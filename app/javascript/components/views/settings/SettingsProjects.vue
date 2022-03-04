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
            <div class="col" v-if="_isallowedProgramSettings('write')">
              <el-button
                @click.prevent="addProject"
                class="bg-primary text-light mb-2"
              >
                <i class="far fa-plus-circle mr-1"></i> Add Project
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
    element-loading-background="rgba(0, 0, 0, 0.8)"
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
     <!--BEGIN Expandable Column Containing Project User roles -->
      <el-table-column label="Users" width="100" type="expand">
         <template>
          <el-table
         :data="contractUser.filter(
                (data) =>
                  !searchContractUsers ||
                  data.user.toLowerCase().includes(searchContractUsers.toLowerCase())
              )"
          style="width: 100%"
          height="450"
          :default-sort="{ prop: 'last_name', order: 'ascending'}" 

        >
          <el-table-column prop="user"  sortable label="Users">
         </el-table-column>
          <el-table-column
            prop="roles"
            sortable
            filterable
            label="Roles"
          >
            <!-- <template slot-scope="scope"> -->
               <!-- <el-select
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
              </el-select>    -->

              
              <!-- <el-input
                size="small"
                style="text-align:center"
                v-model="scope.row.facilityGroupName"
              ></el-input> -->
            <!-- </template> -->
          </el-table-column>
          <el-table-column>
          <template slot="header" slot-scope="scope">
          <el-input
            v-model="searchContractUsers"
            size="mini"
            placeholder="Search project users"            
            >

              <el-button slot="prepend" icon="el-icon-search"></el-button>
          </el-input>
        </template>
          </el-table-column>

         </el-table>
         </template>

         </el-table-column>
           <!--END Expandable Column Containing Project User roles -->


          <el-table-column label="Actions" align="right">
            <template slot-scope="scope">
              <el-button
                type="default"
                @click="saveEdits(scope.$index, scope.row)"
                v-if="scope.$index == rowIndex && _isallowedProgramSettings('write')" 
                v-tooltip="`Save`" 
                class="bg-primary text-light">               
               <i class="far fa-save"></i>
               </el-button>
              <el-button 
                type="default" 
                v-tooltip="`Cancel Edit`"       
                v-if="scope.$index == rowIndex && _isallowedProgramSettings('write')"
                @click.prevent="cancelEdits(scope.$index, scope.row)"  
                class="bg-secondary text-light">
              <i class="fas fa-ban"></i>
                </el-button>
              <el-button  
                type="default" 
                v-tooltip="`Edit Project Name or Change Group`"
                @click.prevent="editMode(scope.$index, scope.row)" 
                v-if="scope.$index !== rowIndex && _isallowedProgramSettings('write')"
                class="bg-light">
                <i class="fal fa-edit text-primary" ></i>
               </el-button>  
          
              <el-button
                type="default"
                @click.prevent="goToProject(scope.$index, scope.row)"
                class="bg-success text-light"
              >
                Go To Project <i class="fas fa-arrow-alt-circle-right ml-1"></i>
              </el-button>
       
              <!-- <el-button type="primary" @click="handleEditRow(scope.$index)">Edit</el-button> -->
            </template>
          </el-table-column>
        </el-table>
   </div>
        <el-dialog
          :visible.sync="dialogVisible"
          append-to-body
          center
          class="contractForm p-0"
        >
          <form accept-charset="UTF-8">
            <div class="form-group mx-4">
              <label class="font-md"
                >New Project Name <span style="color: #dc3545">*</span></label
              >
              <el-input
                type="textarea"
                v-model="newProjectNameText"
                placeholder="Enter new project name"
                rows="1"
                name="Project Name"
              />
            </div>
            <div class="form-group mx-4">
              <label class="font-md">Group<span style="color: #dc3545">*</span></label>
              <el-select
                class="w-100"
                v-model="C_projectGroupFilter"
                track-by="id"
                value-key="id"
                clearable
                filterable
                name="Project Group"
                placeholder="Select Group"
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
                :disabled="!C_projectGroupFilter && newProjectNameText"
                class="btn btn-sm bg-primary text-light mr-2"
                >Save</button
              >
            </div>
          </form>
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
      expandRowKeys: [],
      componentKey: 0,
      programId: this.$route.params.programId,
      search: "",
      rowIndex: null,
      rowId: null,
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
  },
  methods: {
    ...mapActions(["fetchFacilities", "fetchCurrentProject", "fetchGroups"]),
    ...mapMutations(["setProjectGroupFilter", "setGroupFilter"]),
    goToProject(index, rows) {  
      window.location.pathname = `/programs/${this.programId}/sheet/projects/${rows.id}/`
      // router.push more efficient but programPrivileges errors persist unless reload
      // this.$router.push({
      //   name: "SheetProject",
      //   params: {
      //     programId: this.$route.params.programId,
      //     projectId: rows.id.toString(),          
      //   },
      // });
    },
    handleExpandChange (row, expandedRows) {
			const id = row.id;
			const lastId = this.expandRowKeys[0];
			// disable mutiple row expanded 
			this.expandRowKeys = id === lastId ? [] : [id];
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
          this.dialogVisible = false;
          this.fetchCurrentProject(this.programId)
        }
      });
    },
  cancelEdits(index, rows) {
       this.rowIndex = null;
       this.rowId = null;
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
    _isallowedProgramSettings(salut) {
      let pPrivilege = this.$programSettingPrivileges[this.$route.params.programId]
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return pPrivilege.admin_facilities.includes(s);
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
      "getTransferData",
      "getNewGroups",
      "tableData",
      "getProjectGroupFilter",
      "getGroupFilter",
      "facilityGroupFacilities",
      "filteredFacilityGroups",
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
 
};
</script>

<style scoped lang="scss">
.buttonWrapper {
  border-bottom: lightgray solid 1px;
}
.right {
  text-align: right;
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
/deep/.hover-row .el-input .el-input__inner {
  border-style: none;
}
/deep/.el-dialog {
  width: 30%;
  border-top: solid 5px #1d336f !important;
}
/deep/.el-table {
  .el-input__inner {
    font-size: 16px !important;
    font-weight: 300 !important;
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
