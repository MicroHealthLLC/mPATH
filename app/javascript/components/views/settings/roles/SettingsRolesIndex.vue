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
            <i class="fal fa-user-lock mr-1 bootstrap-purple-text"></i> Roles
            <span  
              v-if="tableData"          
              class="ml-2 pb-1 badge badge-secondary badge-pill pill"
              >{{ tableData.length - 1 }}
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
         @click.prevent.stop="programAdminRead(scope.$index, scope.row)"
          v-if="scope.$index == 0">
   
        <span v-if="isProgramAdminRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isProgramAdminRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
     </span> 

        <span 
        v-if="scope.$index !== 0 && scope.row.role_privileges.map(t => t.privilege)[0]"  
        >
        <span 
        v-if="scope.row.role_privileges.map(t => t.role_type == 'program_admin') && 
        scope.row.role_privileges.map(t => t.privilege)[0].includes('R')"  
        >
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
 
         </span>
       <span 
        v-if="scope.row.role_privileges.map(t => t.role_type == 'program_admin') && 
        !scope.row.role_privileges.map(t => t.privilege)[0].includes('R')">
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
         v-if="scope.$index == 0"      
        @click.prevent.stop="programAdminWrite(scope.$index, scope.row)"    
          >

        <span v-if="isProgramAdminWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
      
         <span v-if="!isProgramAdminWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>   
       
        </span>        
      
        <span 
        v-if="scope.$index !== 0 && scope.row.role_privileges.map(t => t.privilege)[0]"  
        >
        <span 
        v-if="scope.row.role_privileges.map(t => t.role_type == 'program_admin') && 
        scope.row.role_privileges.map(t => t.privilege)[0].includes('W')"  
        >
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
 
         </span>
       <span 
        v-if="scope.row.role_privileges.map(t => t.role_type == 'program_admin') && 
        !scope.row.role_privileges.map(t => t.privilege)[0].includes('W')">
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
        v-if="scope.$index == 0"          
        @click.prevent.stop="programAdminDelete(scope.$index, scope.row)"    
          >
       
        <span v-if="isProgramAdminDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
       <span v-if="!isProgramAdminDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
       
        </span>  
        
         <span 
        v-if="scope.$index !== 0 && scope.row.role_privileges.map(t => t.privilege)[0]"  
        >
        <span 
        v-if="scope.row.role_privileges.map(t => t.role_type == 'program_admin') && 
        scope.row.role_privileges.map(t => t.privilege)[0].includes('D')"  
        >
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
 
         </span>
       <span 
        v-if="scope.row.role_privileges.map(t => t.role_type == 'program_admin') && 
        !scope.row.role_privileges.map(t => t.privilege)[0].includes('D')">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>   
        </span>    


       </template>
      </el-table-column>

    </el-table-column> 
      <el-table-column label="Program Settings" >

        <!-- 1.  Bring all methods to this column, 
        2.  Bring all methods to Scripts -->
<el-table-column label="Groups">
    <el-table-column
    prop="groupsRead"
    label="Read"
    width="75">
<template slot-scope="scope" >


<span
 @click.prevent.stop="groupsRead(scope.$index, scope.row)"
 v-if="scope.$index == 0"
>

  <span v-if="isGroupsRead">
  <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
  </span>
    <span v-if="!isGroupsRead">
  <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
  </span>
</span>

   <span 
    v-if="scope.$index !== 0 && scope.row.role_privileges.map(t => t.privilege)[1]"  
    >
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'groups') && 
    scope.row.role_privileges.map(t => t.privilege)[1].includes('R')"  
    >
    <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'groups') && 
    !scope.row.role_privileges.map(t => t.privilege)[1].includes('R')">
    <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
    </span>   
   </span>    

  </template>
  </el-table-column>
  <el-table-column
  prop="groupsWrite"
  label="Write"
  width="75">
  <template slot-scope="scope">
    <span
    @click.prevent.stop="groupsWrite(scope.$index, scope.row)"
    v-if="scope.$index == 0"
    >
      <span v-if="isGroupsWrite">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
      </span>
        <span v-if="!isGroupsWrite">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>
    </span>
  <span 
    v-if="scope.$index !== 0 && scope.row.role_privileges.map(t => t.privilege)[1]"  
    >
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'groups') && 
    scope.row.role_privileges.map(t => t.privilege)[1].includes('W')"  
    >
    <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'groups') && 
    !scope.row.role_privileges.map(t => t.privilege)[1].includes('W')">
    <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
    </span>   
   </span>    

  </template>
  </el-table-column>
  <el-table-column
    prop="groupsDelete"
    label="Delete"
    width="75">
<template slot-scope="scope">
    <span
    @click.prevent.stop="groupsDelete(scope.$index, scope.row)"
    v-if="scope.$index == 0"
    >
      <span v-if="isGroupsDelete">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
      </span>
        <span v-if="!isGroupsDelete">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>
    </span>
  <span 
    v-if="scope.$index !== 0 && scope.row.role_privileges.map(t => t.privilege)[1]"  
    >
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'groups') && 
    scope.row.role_privileges.map(t => t.privilege)[1].includes('D')"  
    >
    <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'groups') && 
    !scope.row.role_privileges.map(t => t.privilege)[1].includes('D')">
    <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
    </span>   
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
 @click.prevent.stop="projectsRead(scope.$index, scope.row)"
 v-if="scope.$index == 0"
>

  <span v-if="isProjectsRead">
  <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
  </span>
    <span v-if="!isProjectsRead">
  <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
  </span>
</span>
  <span 
    v-if="scope.$index !== 0 && scope.row.role_privileges.map(t => t.privilege)[2]"  
    >
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'projects') && 
    scope.row.role_privileges.map(t => t.privilege)[2].includes('R')"  
    >
    <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'projects') && 
    !scope.row.role_privileges.map(t => t.privilege)[2].includes('R')">
    <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
    </span>   
   </span>      

      
   </template>
            
</el-table-column>
<el-table-column
    prop="projectsWrite"
    label="Write"
    width="75">
<template slot-scope="scope">

<span
 @click.prevent.stop="projectsWrite(scope.$index, scope.row)"
 v-if="scope.$index == 0"
>

  <span v-if="isProjectsWrite">
  <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
  </span>
    <span v-if="!isProjectsWrite">
  <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
  </span>
</span>
     <span 
    v-if="scope.$index !== 0 && scope.row.role_privileges.map(t => t.privilege)[2]"  
    >
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'projects') && 
    scope.row.role_privileges.map(t => t.privilege)[2].includes('W')"  
    >
    <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'projects') && 
    !scope.row.role_privileges.map(t => t.privilege)[2].includes('W')">
    <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
    </span>   
   </span> 
       </template>
            
        </el-table-column>
        <el-table-column
          prop="projectsDelete"
          label="Delete"
          width="75">
       <template slot-scope="scope">


    <span
    @click.prevent.stop="projectsDelete(scope.$index, scope.row)"
    v-if="scope.$index == 0"
    >

      <span v-if="isProjectsDelete">
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
      </span>
        <span v-if="!isProjectsDelete">
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>
    </span>
  <span 
    v-if="scope.$index !== 0 && scope.row.role_privileges.map(t => t.privilege)[2]"  
    >
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'projects') && 
    scope.row.role_privileges.map(t => t.privilege)[2].includes('D')"  
    >
    <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'projects') && 
    !scope.row.role_privileges.map(t => t.privilege)[2].includes('D')">
    <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
    </span>   
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

       <span @click.prevent.stop="contractsRead(scope.$index, scope.row)" v-if="scope.$index == 0">
         <span v-if="isContractsRead">
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
          </span>
            <span v-if="!isContractsRead">
          <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
          </span>
        </span>

    <span 
    v-if="scope.$index !== 0 && scope.row.role_privileges.map(t => t.privilege)[3]"  
    >
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'contracts') && 
    scope.row.role_privileges.map(t => t.privilege)[3].includes('R')"  
    >
    <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'contracts') && 
    !scope.row.role_privileges.map(t => t.privilege)[3].includes('R')">
    <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
    </span>   
   </span> 



       </template>
        </el-table-column>
        <el-table-column
            prop="contractsWrite"
            label="Write"
            width="75">
        <template slot-scope="scope">
          <span
          @click.prevent.stop="contractsWrite(scope.$index, scope.row)"
          v-if="scope.$index == 0"
          >
          <span v-if="isContractsWrite">
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
          </span>
            <span v-if="!isContractsWrite">
          <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
          </span>
        </span>

  <span 
    v-if="scope.$index !== 0 && scope.row.role_privileges.map(t => t.privilege)[3]"  
    >
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'contracts') && 
    scope.row.role_privileges.map(t => t.privilege)[3].includes('W')"  
    >
    <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'contracts') && 
    !scope.row.role_privileges.map(t => t.privilege)[3].includes('W')">
    <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
    </span>   
   </span> 

            
          
       </template>
        </el-table-column>
        <el-table-column
            prop="role_privileges"
            label="Delete"
            width="75">
       <template slot-scope="scope">


   <span @click.prevent.stop="contractsDelete(scope.$index, scope.row)" v-if="scope.$index == 0">

          <span v-if="isContractsDelete">
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
          </span>
        <span v-if="!isContractsDelete">
          <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
          </span>
     </span>
  <span 
    v-if="scope.$index !== 0 && scope.row.role_privileges.map(t => t.privilege)[3]"  
    >
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'contracts') && 
    scope.row.role_privileges.map(t => t.privilege)[3].includes('D')"  
    >
    <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'contracts') && 
    !scope.row.role_privileges.map(t => t.privilege)[3].includes('D')">
    <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
    </span>   
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
          @click.prevent.stop="usersRead(scope.$index, scope.row)"
          v-if="scope.$index == 0"
          >

          <span v-if="isUsersRead">
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
          </span>
            <span v-if="!isUsersRead">
          <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
          </span>
          </span>

  <span 
    v-if="scope.$index !== 0 && scope.row.role_privileges.map(t => t.privilege)[4]"  
    >
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'users') && 
    scope.row.role_privileges.map(t => t.privilege)[4].includes('R')"  
    >
    <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'users') && 
    !scope.row.role_privileges.map(t => t.privilege)[4].includes('R')">
    <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
    </span>   
   </span> 
 
       </template>
        </el-table-column>
        <el-table-column
            prop="usersWrite"
            label="Write"
            width="75">
        <template slot-scope="scope">

           <span
          @click.prevent.stop="usersWrite(scope.$index, scope.row)"
          v-if="scope.$index == 0"
          >

          <span v-if="isUsersWrite">
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
          </span>
            <span v-if="!isUsersWrite">
          <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
          </span>
        </span>

     
  <span 
    v-if="scope.$index !== 0 && scope.row.role_privileges.map(t => t.privilege)[4]"  
    >
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'users') && 
    scope.row.role_privileges.map(t => t.privilege)[4].includes('W')"  
    >
    <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'users') && 
    !scope.row.role_privileges.map(t => t.privilege)[4].includes('W')">
    <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
    </span>   
   </span> 
 
       </template>
        </el-table-column>
        <el-table-column
            prop="usersDelete"
            label="Delete"
            width="75">
        <template slot-scope="scope">

          <span
          @click.prevent.stop="usersDelete(scope.$index, scope.row)"
          v-if="scope.$index == 0"
          >
          
          <span v-if="isUsersDelete">
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
          </span>
            <span v-if="!isUsersDelete">
          <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
          </span>
        </span>

  <span 
    v-if="scope.$index !== 0 && scope.row.role_privileges.map(t => t.privilege)[4]"  
    >
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'users') && 
    scope.row.role_privileges.map(t => t.privilege)[4].includes('D')"  
    >
    <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
    <span 
    v-if="scope.row.role_privileges.map(t => t.role_type == 'users') && 
    !scope.row.role_privileges.map(t => t.privilege)[4].includes('D')">
    <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
    </span>   
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
        @click.prevent.stop="programAdminReadCreate(scope.$index, scope.row)"    
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
        isProgramAdminRead: true,
        isProgramAdminWrite: true,
        isProgramAdminDelete: true,

        isGroupsRead: true,
        isGroupsWrite: true,
        isGroupsDelete: true,

        isProjectsRead: true,
        isProjectsWrite: true,
        isProjectsDelete: true,

        isContractsRead: true,
        isContractsWrite: true,
        isContractsDelete: true,

        isUsersRead: true,
        isUsersWrite: true,
        isUsersDelete: true,

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
        programAdminPriv: [],
        groupsPriv: [],
        projectsPriv: [],
        contractsPriv: [],
        usersPriv: [],
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
    programAdminRead() {
      this.isProgramAdminRead = !this.isProgramAdminRead  
      if(this.isProgramAdminRead && !this.programAdminPriv.map(t => t).includes("R") ){
         this.programAdminPriv.push(..."R")
      } else if (!this.isProgramAdminRead) {
         this.programAdminPriv = this.programAdminPriv.filter(t => t !== "R")
      }
       console.log(`program: ${this.programAdminPriv}`)

    },
    programAdminWrite() {
      this.isProgramAdminWrite = !this.isProgramAdminWrite 
     if(this.isProgramAdminWrite && !this.programAdminPriv.map(t => t).includes("W") ){
       this.programAdminPriv.push(..."W")
      } else if (!this.isProgramAdminWrite) {
         this.programAdminPriv = this.programAdminPriv.filter(l => l !== "W")
         }
      console.log(`program: ${this.programAdminPriv}`)
    },
    programAdminDelete() {
      this.isProgramAdminDelete = !this.isProgramAdminDelete
    if(this.isProgramAdminDelete && !this.programAdminPriv.map(t => t).includes("D") ){
       this.programAdminPriv.push(..."D")
      } else if (!this.isProgramAdminDelete) {
         this.programAdminPriv = this.programAdminPriv.filter(l => l !== "D")
         }
      
      
     console.log(`program: ${this.programAdminPriv}`)
    },
  groupsRead() {
 this.isGroupsRead =  !this.isGroupsRead
  if(this.isGroupsRead && !this.groupsPriv.map(t => t).includes("R") ){
    this.groupsPriv.push(..."R")
  } else if (!this.isGroupsRead) {
      this.groupsPriv = this.groupsPriv.filter(t => t !== "R")
  }
    console.log(`groups: ${this.groupsPriv}`)

    },
   groupsWrite() {
      this.isGroupsWrite = !this.isGroupsWrite
     if(this.isGroupsWrite && !this.groupsPriv.map(t => t).includes("W") ){
      this.groupsPriv.push(..."W")
      } else if (!this.isGroupsWrite) {
         this.groupsPriv = this.groupsPriv.filter(l => l !== "W")
         }
      console.log(`groups: ${this.groupsPriv}`)
    },
    groupsDelete() {
      this.isGroupsDelete = !this.isGroupsDelete
    if(this.isGroupsDelete && !this.groupsPriv.map(t => t).includes("D") ){
      this.groupsPriv.push(..."D")
      } else if (!this.isGroupsDelete) {
         this.groupsPriv = this.groupsPriv.filter(l => l !== "D")
         }
     console.log(`groups: ${this.groupsPriv}`)
    },


  projectsRead() {
  this.isProjectsRead = !this.isProjectsRead
  if(this.isProjectsRead && !this.projectsPriv.map(t => t).includes("R") ){
     this.projectsPriv.push(..."R")
  } else if (!this.isProjectsRead) {
     this.projectsPriv = this.projectsPriv.filter(t => t !== "R")
  }
    console.log(`projects: ${this.projectsPriv}`)

    },
  projectsWrite() {
    this.isProjectsWrite = !this.isProjectsWrite
     if(this.isProjectsWrite && !this.projectsPriv.map(t => t).includes("W") ){
      this.projectsPriv.push(..."W")
      } else if (!this.isProjectsWrite) {
        this.projectsPriv = this.projectsPriv.filter(l => l !== "W")
         }
      console.log(`projects: ${this.projectsPriv}`)
    },
   projectsDelete() {
      this.isProjectsDelete = !this.isProjectsDelete
    if(this.isProjectsDelete && !this.projectsPriv.map(t => t).includes("D") ){
      this.projectsPriv.push(..."D")
      } else if (!this.isProjectsDelete) {
        this.projectsPriv = this.projectsPriv.filter(l => l !== "D")
         }
      
      
     console.log(`projects: ${this.projectsPriv}`)
    },

  contractsRead() {
  this.isContractsRead = !this.isContractsRead
  if(this.isContractsRead && !this.contractsPriv.map(t => t).includes("R") ){
     this.contractsPriv.push(..."R")
  } else if (!this.isContractsRead) {
     this.contractsPriv = this.contractsPriv.filter(t => t !== "R")
  }
    console.log(`contracts: ${this.contractsPriv}`)

    },
   contractsWrite() {
      this.isContractsWrite = !this.isContractsWrite 
     if( this.isContractsWrite  && !this.contractsPriv.map(t => t).includes("W") ){
      this.contractsPriv.push(..."W")
      } else if (!this.isContractsWrite) {
        this.contractsPriv = this.contractsPriv.filter(l => l !== "W")
         }
       console.log(`contracts: ${this.contractsPriv}`)
    },
    contractsDelete() {
      this.isContractsDelete = !this.isContractsDelete
    if(this.isContractsDelete && !this.contractsPriv.map(t => t).includes("D") ){
       this.contractsPriv.push(..."D")
      } else if (!this.isContractsDelete) {
         this.contractsPriv = this.contractsPriv.filter(l => l !== "D")
         }
     console.log(`contracts: ${this.contractsPriv}`)
    },
 usersRead() {
    this.isUsersRead = !this.isUsersRead
     if(this.isUsersRead && !this.usersPriv.map(t => t).includes("R") ){
      this.usersPriv.push(..."R")
      } else if (!this.isUsersRead) {
         this.usersPriv = this.usersPriv.filter(l => l !== "R")
      }
      console.log(`users: ${this.usersPriv}`)

    },
   usersWrite() {
      this.isUsersWrite = !this.isUsersWrite
      if(this.isUsersWrite && !this.usersPriv.map(t => t).includes("W") ){
      this.usersPriv.push(..."W")
      } else if (!this.isUsersWrite) {
         this.usersPriv = this.usersPriv.filter(l => l !== "W")
         }     
      console.log(`users: ${this.usersPriv}`)
    },
    usersDelete() {
      this.isUsersDelete = !this.isUsersDelete
    if(this.isUsersDelete && !this.usersPriv.map(t => t).includes("D") ){
      this.usersPriv.push(..."D")
      } else if (!this.isUsersDelete) {
         this.usersPriv = this.usersPriv.filter(l => l !== "D")
         }
      console.log(`users: ${this.usersPriv}`)
    },
    showHideCreateRow(row, index){   
      // console.log(row.rowIndex)    
        return row.rowIndex == 0 && !this.showCreateRow ? 'd-none' : '';
    },
    addRole(){
      // this.addRoleDialogOpen = true
      this.showCreateRow = !this.showCreateRow  
     console.log(this.getRoles)  
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
     console.log(`program: ${this.programAdminPriv}`)
  console.log(`groups: ${this.groupsPriv}`)
    console.log(`projects: ${this.projectsPriv}`)
       console.log(`contracts: ${this.contractsPriv}`)
          console.log(`users: ${this.usersPriv}`)
        let newRoleData = {
        role: {
           name: this.newRoleName,
           uId: '',
          //  role_users: [{}],
           pId: this.$route.params.programId,
            rp: [
              {
                privilege: this.programAdminPriv.join(''),
                role_type: "program_admin",
                name: "program_test", 
              }, 
              {
                privilege: this.groupsPriv.join(''),
                role_type: "groups",
                name: "program_test", 
              },
              {
                privilege: this.usersPriv.join(''),
                role_type: "users",
                name: "program_test", 
              },
              {
                privilege: this.projectsPriv.join(''),
                role_type: "projects",
                name: "program_test", 
              }, 
              {
                privilege: this.contractsPriv.join(''),
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

 if (this.isProgramAdminRead && this.isProgramAdminWrite && this.isProgramAdminDelete ) {
      this.programAdminPriv.push(..."R") 
      this.programAdminPriv.push(..."W")  
      this.programAdminPriv.push(..."D") 
             
     }
 if (this.isGroupsRead && this.isGroupsWrite && this.isGroupsDelete) {
      this.groupsPriv.push(..."R")     
      this.groupsPriv.push(..."W")     
      this.groupsPriv.push(..."D")       
     }
  if (this.isProjectsRead && this.isProjectsWrite && this.isProjectsDelete) {
      this.projectsPriv.push(..."R")     
      this.projectsPriv.push(..."W")     
      this.projectsPriv.push(..."D")       
  }
  if (this.isContractsRead && this.isContractsWrite && this.isContractsDelete) {
     this.contractsPriv.push(..."R")     
     this.contractsPriv.push(..."W")     
     this.contractsPriv.push(..."D")       
  }
  if (this.isUsersRead && this.isUsersWrite && this.isUsersDelete) {
      this.usersPriv.push(..."R")     
      this.usersPriv.push(..."W")     
      this.usersPriv.push(..."D")       
    }
 console.log(`program: ${this.programAdminPriv}`)
  console.log(`groups: ${this.groupsPriv}`)
    console.log(`projects: ${this.projectsPriv}`)
       console.log(`contracts: ${this.contractsPriv}`)
          console.log(`users: ${this.usersPriv}`)
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
            message: `${this.newRoleName} successfully added to your program.`,
            type: "success",
            showClose: true,
          });
          this.SET_NEW_ROLE_STATUS(0);
          this.fetchRoles(this.$route.params.programId)
          this.newRoleName = "Enter New Role Name"
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