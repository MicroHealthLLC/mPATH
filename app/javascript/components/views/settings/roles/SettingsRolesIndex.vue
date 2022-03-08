<template>
<div
    v-loading="!contentLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)"
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
      
                class="bg-success text-light mb-2"
              >
              <i class="fas fa-users mr-1"></i>  Add New Role
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
        :data="tableData"   
        height="450"
        >
    <el-table-column
      fixed
      prop="role"
      label="Admin Role"
      width="340">
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

    </el-table-column>
      <el-table-column label="Program Settings" >
        <el-table-column label="Groups">
            <el-table-column
            prop="groupsRead"
            label="Read"
            width="75">
        <template slot-scope="scope">
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
       tableData: [{
          role: 'program-admin',        
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
        }, {
          role: 'program-admin-not-users',        
          read: false,
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

          usersRead: false, 
          usersWrite: false, 
          usersDelete: false, 
        },]
      }
  },
  methods: {
    ...mapMutations([]),
  ...mapActions([]),
    programAdminRead(rows, index) {
        // console.log(index) 
      index.read = !index.read
    },
    programAdminWrite(rows, index) {
     index.write = !index.write
    },
     programAdminDelete(rows, index) {
      index.delete = !index.delete
    },
    handleClick(tab, event) { 
        //Route redirecting incase we want to assign url paths to each tab
        // if(tab.index == 1) {
        //  this.$router.push({ name: "SettingsRolesProjects" })
        // }    
   
    },

   },
  mounted() {
 
  },
  computed: {
    ...mapGetters([
        "contentLoaded",
        "currentProject",
        "getPortfolioUsers",
        "activeProjectUsers",
        "newUserStatus"
    ]),
     backToSettings() {
      return `/programs/${this.$route.params.programId}/settings`;
    },
    },
  watch: { 
    // newUserStatus: {
    //   handler() {
    //     if (this.newUserStatus == 200) {
    //       this.$message({
    //         message: ` ${this.firstName + this.lastName } successfully added to your program.`,
    //         type: "success",
    //         showClose: true,
    //       });
    //       this.SET_NEW_USER_STATUS(0);
    //       this.lastName = '',
    //       this.firstName = '',
    //       this.email = ''
    //     }
    //   },
    // },
   
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
/deep/.el-table th.el-table__cell > .cell {
  color: #383838;
//   font-size: .9rem;
  text-align: center;
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