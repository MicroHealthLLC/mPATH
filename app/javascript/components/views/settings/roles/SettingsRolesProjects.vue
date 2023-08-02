<template>
<div>
  <div :class="{ 'd-none': !_isallowed('write') }">               
  <el-button
    @click.prevent="addProjectRole"
    :disabled="isEditting"
    class="bg-primary text-light mb-3"
  >
    <i class="far fa-plus-circle mr-1"></i>Create Role
  </el-button>
    </div>
 <el-table 
  v-if="tableData && tableData.length > 0"  
  :data="tableData"   
  height="450"
  class="crudRow"
  >
  <el-table-column
    fixed
    prop="role"
    label="Projects Role"
    width="250">

  <template slot-scope="scope">
 <span v-if="(scope.$index == currentRow && isEditting) || (scope.$index == 0 && isEditting && scope.row.newRow)">
    <el-input
    size="small"   
    placeholder="Enter Role Name"      
    style="font-style: italic; color: red"
    v-model="scope.row.name"
    controls-position="right"
  >
  </el-input>
  </span> 
  <span v-else>
    <span v-show="
      scope.row.name == 'update-project' ||
      scope.row.name == 'read-project' ||
      scope.row.name == 'contribute-project'"
      style="color: #dc3545; font-size: 15px">*
    </span>   
    {{ scope.row.name }} 
  </span>

    </template>
  </el-table-column>

  <el-table-column label="Analytics">
    <el-table-column
      prop="read"
      label="Read"
      width="75">

    <template slot-scope="scope">
    <span v-if="currentRow !== scope.$index && !scope.row.newRow">
        <span 
          v-if="scope.row.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes(project.analytics)"
        >         
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

        </span>
      <span v-else>
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>   
    </span> 
    <span 
      v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
      @click.prevent.stop="analyticsRead(scope.$index, scope.row)"      
      >
      <span v-if="isAnalyticsRead">  
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
          </span>
      <span v-else>
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
       <!-- <span 
      @click.prevent.stop="analyticsWrite(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isAnalyticsWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isAnalyticsWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span> -->

      <span v-if="currentRow !== scope.$index && !scope.row.newRow">
      <span 
        v-if="scope.row.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes(project.analytics)"
      >
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
    <span v-else>
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>   
    </span>  

       <span 
      v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
      @click.prevent.stop="analyticsWrite(scope.$index, scope.row)"      
      >
      <span v-if="isAnalyticsWrite">  
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
          </span>
      <span v-else>
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
       <!-- <span 
      @click.prevent.stop="analyticsDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isAnalyticsDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isAnalyticsDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span> -->

     <span v-if="currentRow !== scope.$index && !scope.row.newRow">
        <span 
            v-if="scope.row.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes(project.analytics)"
                >
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i> 
  
          </span>
          <span v-else>
          <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
          </span>   
      </span>

      <span 
      v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
      @click.prevent.stop="analyticsDelete(scope.$index, scope.row)"      
      >
      <span v-if="isAnalyticsDelete">  
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
          </span>
      <span v-else>
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>   
      </span>   
      </template>
    </el-table-column>

  </el-table-column>
   <el-table-column label="Tasks">
    <el-table-column
      prop="read"
      label="Read"
      width="75">

    <template slot-scope="scope">
    <!-- <span 
      @click.prevent.stop="tasksRead(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isTasksRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isTasksRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span> -->

     <span v-if="currentRow !== scope.$index && !scope.row.newRow">
        <span 
          v-if="scope.row.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes(project.tasks)"
        >
            <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
    
            </span>
        <span v-else>
            <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
            </span>   
      </span>  
      <span 
       v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
      @click.prevent.stop="tasksRead(scope.$index, scope.row)"      
      >
      <span v-if="isTasksRead">  
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
          </span>
      <span v-else>
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
        <!-- <span 
        @click.prevent.stop="tasksWrite(scope.$index, scope.row)"
        v-if="scope.$index == 0">
        <span v-if="isTasksWrite">
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
          </span>
          <span v-if="!isTasksWrite">
          <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
          </span>
        </span> -->

          <span v-if="currentRow !== scope.$index && !scope.row.newRow">
          <span 
        v-if="scope.row.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes(project.tasks)"
       >
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
  
          </span>
          <span v-else>
          <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
          </span>   
        </span>  
        <span 
          v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
          @click.prevent.stop="tasksWrite(scope.$index, scope.row)"      
          >
        <span v-if="isTasksWrite">  
            <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
            </span>
        <span v-else>
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
      <!-- <span 
      @click.prevent.stop="tasksDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isTasksDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isTasksDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
      </span> -->

       <span v-if="currentRow !== scope.$index && !scope.row.newRow">
       <span 
        v-if="scope.row.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes(project.tasks)"
       >
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
  
          </span>
          <span v-else>
          <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
          </span>   
       </span> 

      <span 
       v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
      @click.prevent.stop="tasksDelete(scope.$index, scope.row)"      
      >
      <span v-if="isTasksDelete">  
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
          </span>
      <span v-else>
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>   
      </span>     
       </template>
    </el-table-column>

  </el-table-column>

     <el-table-column label="Issues">
    <el-table-column
      prop="read"
      label="Read"
      width="75">

    <template slot-scope="scope">
      <!-- <span 
      @click.prevent.stop="issuesRead(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isIssuesRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isIssuesRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span> -->

    <span v-if="currentRow !== scope.$index && !scope.row.newRow">
     <span 
        v-if="scope.row.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes(project.issues)"
       >
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
      <span v-else>
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>   
    </span> 
     <span 
     v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
      @click.prevent.stop="issuesRead(scope.$index, scope.row)"      
      >
      <span v-if="isIssuesRead">  
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
          </span>
      <span v-else>
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
     <!-- <span 
      @click.prevent.stop="issuesWrite(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isIssuesWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isIssuesWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span> -->

    <span v-if="currentRow !== scope.$index && !scope.row.newRow">
    <span 
          v-if="scope.row.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes(project.issues)"
        >
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

        </span>
        <span v-else>
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>   
      </span>    
      <span 
      v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
      @click.prevent.stop="issuesWrite(scope.$index, scope.row)"      
      >
      <span v-if="isIssuesWrite">  
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
          </span>
      <span v-else>
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
       <!-- <span 
      @click.prevent.stop="issuesDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isIssuesDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isIssuesDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
       </span> -->

    
     <span v-if="currentRow !== scope.$index && !scope.row.newRow">
        <span 
          v-if="scope.row.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes(project.issues)"
        >
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

        </span>
        <span v-else>
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>   
      </span> 
      <span 
      v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
      @click.prevent.stop="issuesDelete(scope.$index, scope.row)"      
      >
      <span v-if="isIssuesDelete">  
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
          </span>
      <span v-else>
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>   
      </span>     
      </template>
    </el-table-column>

  </el-table-column>

     <el-table-column label="Risks">
    <el-table-column
      prop="read"
      label="Read"
      width="75">

    <template slot-scope="scope">
    <!-- <span 
      @click.prevent.stop="risksRead(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isRisksRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isRisksRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span> -->

     <span v-if="currentRow !== scope.$index && !scope.row.newRow">
        <span 
        v-if="scope.row.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes(project.risks)"
       >
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
      <span v-else>
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>   
    </span> 
        <span 
        v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
        @click.prevent.stop="risksRead(scope.$index, scope.row)"      
        >
        <span v-if="isRisksRead">  
            <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
            </span>
        <span v-else>
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
      <!-- <span 
      @click.prevent.stop="risksWrite(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isRisksWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isRisksWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span> -->

       <span v-if="currentRow !== scope.$index && !scope.row.newRow">
      <span 
          v-if="scope.row.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes(project.risks)"
        >
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

        </span>
        <span v-else>
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>   
       </span>
       <span 
        v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
        @click.prevent.stop="risksWrite(scope.$index, scope.row)"      
        >
        <span v-if="isRisksWrite">  
            <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
            </span>
        <span v-else>
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
    <!-- <span 
      @click.prevent.stop="risksDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isRisksDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isRisksDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span> -->

         <span v-if="currentRow !== scope.$index && !scope.row.newRow">
            <span 
            v-if="scope.row.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes(project.risks)"
          >
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

          </span>
        <span v-else>
          <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
          </span>   
        </span> 
        <span 
         v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
        @click.prevent.stop="risksDelete(scope.$index, scope.row)"      
        >
        <span v-if="isRisksDelete">  
            <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
            </span>
        <span v-else>
          <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>   
        </span>     
      </template>
    </el-table-column>

  </el-table-column>

     <el-table-column label="Notes">
    <el-table-column
      prop="read"
      label="Read"
      width="75">

    <template slot-scope="scope">
     <!-- <span 
      @click.prevent.stop="notesRead(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isNotesRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isNotesRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span> -->

        <span v-if="currentRow !== scope.$index && !scope.row.newRow">
        <span 
            v-if="scope.row.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes(project.notes)"
          >
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

          </span>
        <span v-else>
          <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
          </span>   
        </span>
        <span 
        v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
        @click.prevent.stop="notesRead(scope.$index, scope.row)"      
        >
        <span v-if="isNotesRead">  
            <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
            </span>
        <span v-else>
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
       <!-- <span 
      @click.prevent.stop="notesWrite(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isNotesWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isNotesWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span> -->

        <span v-if="currentRow !== scope.$index && !scope.row.newRow">
        <span 
          v-if="scope.row.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes(project.notes)"
        >
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       
        </span>
      <span v-else>
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>   
      </span> 
      <span 
        v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
        @click.prevent.stop="notesWrite(scope.$index, scope.row)"      
        >
        <span v-if="isNotesWrite">  
            <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
            </span>
        <span v-else>
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
       <!-- <span 
      @click.prevent.stop="notesDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isNotesDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isNotesDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span> -->

     <span v-if="currentRow !== scope.$index && !scope.row.newRow">
      <span 
          v-if="scope.row.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes(project.notes)"
        >
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

        </span>
      <span v-else>
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>   
      </span> 
      <span 
           v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
        @click.prevent.stop="notesDelete(scope.$index, scope.row)"      
        >
        <span v-if="isNotesDelete">  
            <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
            </span>
        <span v-else>
          <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
          </span>   
      </span>    
      </template>
    </el-table-column>

  </el-table-column>

     <el-table-column label="Lessons">
    <el-table-column
      prop="read"
      label="Read"
      width="75">

    <template slot-scope="scope">
       <!-- <span 
      @click.prevent.stop="lessonsRead(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isLessonsRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isLessonsRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span> -->

      <span v-if="currentRow !== scope.$index && !scope.row.newRow">
      <span 
        v-if="scope.row.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes(project.lessons)"
       >
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
     <span v-else>
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>   
     </span> 
     <span 
      v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
      @click.prevent.stop="lessonsRead(scope.$index, scope.row)"      
      >
      <span v-if="isLessonsRead">  
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
          </span>
      <span v-else>
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
      <!-- <span 
      @click.prevent.stop="lessonsWrite(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isLessonsWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isLessonsWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span> -->

     <span v-if="currentRow !== scope.$index && !scope.row.newRow">
      <span 
        v-if="scope.row.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes(project.lessons)"
       >
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
     <span v-else>
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>   
    </span> 
    <span 
      v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
      @click.prevent.stop="lessonsWrite(scope.$index, scope.row)"      
      >
      <span v-if="isLessonsWrite">  
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
          </span>
      <span v-else>
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
      <!-- <span 
      @click.prevent.stop="lessonsDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isLessonsDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isLessonsDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span> -->

     <span v-if="currentRow !== scope.$index && !scope.row.newRow">
   <span 
        v-if="scope.row.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes(project.lessons)"
       >
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
     <span v-else>
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>   
    </span> 
      <span 
      v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
      @click.prevent.stop="lessonsDelete(scope.$index, scope.row)"      
      >
      <span v-if="isLessonsDelete">  
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
          </span>
      <span v-else>
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>   
      </span>    

      </template>
    </el-table-column>

  </el-table-column>

  <el-table-column label="Efforts">
    <el-table-column
      prop="read"
      label="Read"
      width="75">

    <template slot-scope="scope">

      <span v-if="currentRow !== scope.$index && !scope.row.newRow">
      <span 
        v-if="scope.row.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes(project.efforts)"
       >
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
     <span v-else>
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>   
     </span> 
     <span 
      v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
      @click.prevent.stop="effortsRead(scope.$index, scope.row)"      
      >
      <span v-if="isEffortsRead">  
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
          </span>
      <span v-else>
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
      <!-- <span 
      @click.prevent.stop="lessonsWrite(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isLessonsWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isLessonsWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span> -->

     <span v-if="currentRow !== scope.$index && !scope.row.newRow">
      <span 
        v-if="scope.row.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes(project.lessons)"
       >
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
     <span v-else>
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>   
    </span> 
    <span 
      v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
      @click.prevent.stop="lessonsWrite(scope.$index, scope.row)"      
      >
      <span v-if="isLessonsWrite">  
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
          </span>
      <span v-else>
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
      <!-- <span 
      @click.prevent.stop="lessonsDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isLessonsDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isLessonsDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span> -->

     <span v-if="currentRow !== scope.$index && !scope.row.newRow">
   <span 
        v-if="scope.row.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes(project.lessons)"
       >
      <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>       

      </span>
     <span v-else>
      <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
      </span>   
    </span> 
      <span 
      v-if="(isEditting && currentRow == scope.$index) || (scope.$index == 0 && isEditting && scope.row.newRow)"
      @click.prevent.stop="lessonsDelete(scope.$index, scope.row)"      
      >
      <span v-if="isLessonsDelete">  
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>
          </span>
      <span v-else>
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>   
      </span>    

      </template>
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
      size="small"
      v-tooltip="`Save role`"
      v-if="(isEditting && currentRow == scope.$index) || 
      (scope.$index == 0 && isEditting && scope.row.newRow) && scope.row.name"
      @click.prevent="saveNewRole(scope.$index, scope.row)"
        class="bg-primary btn-sm text-light"
      >
    <i class="far fa-save"></i>
      </el-button>
   
    <el-button
      type="default"
      size="small"
      @click.prevent="editRole(scope.$index, scope.row)"
      v-if="!isEditting &&
      scope.row.name !== 'update-project' &&
      scope.row.name !== 'read-project' && 
      scope.row.name !== 'contribute-project'"
      class="bg-light btn-sm"   
      v-tooltip="`Edit Role`"
    >
      <i class="fal fa-edit text-primary"></i>
      </el-button>

      <el-button
      size="small"
      type="default"
      @click.prevent="cancelEditRole(scope.$index, scope.row)"
      v-if="isEditting && currentRow == scope.$index"
      class="bg-secondary btn-sm text-light ml-1"
      v-tooltip="`Cancel Edit`"                  
    >
      <i class="fas fa-ban"></i> 
      </el-button>
      <el-button
      size="small"
      type="default"
      @click.prevent="cancelCreateRole(scope.$index, scope.row)"
      v-if="scope.$index == 0 && isEditting && scope.row.newRow"
      class="bg-light btn-sm"
      v-tooltip="`Cancel Create`"                  
      >
      <i class="fas fa-ban"></i>
     </el-button>
    </template>
      
      </el-table-column> 
  </el-table>
 
</div>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
export default {
  name: "SettingsRolesProjects",
     data() {    
      return {
        currentRow: null, 
        isEditting: false, 
        addRoleDialogOpen: false, 
        isAnalyticsRead: true,
        isAnalyticsWrite: true,
        isAnalyticsDelete: true,

        isTasksRead: true,
        isTasksWrite: true,
        isTasksDelete: true,

        isIssuesRead: true,
        isIssuesWrite: true,
        isIssuesDelete: true,

        isRisksRead: true,
        isRisksWrite: true,
        isRisksDelete: true,

        isNotesRead: true,
        isNotesWrite: true,
        isNotesDelete: true,

        isLessonsRead: true,
        isLessonsWrite: true,
        isLessonsDelete: true,

        analyticsPriv: [],
        tasksPriv: [],
        issuesPriv: [],
        risksPriv: [],
        lessonsPriv: [],
        notesPriv: [],
        effortsPriv: []
       }
  },
  methods: {
    ...mapMutations([
      "SET_NEW_ROLE_STATUS", 
      "SET_SHOW_CREATE_ROW",
      "SET_UPDATED_PROJECT_ROLE_STATUS",
       ]),
  ...mapActions([
      "fetchRoles",
       "createRole",
       "updateRole"
       ]),
  _isallowed(salut) {
     return this.checkPrivileges("SettingsRolesIndex", salut, this.$route, {settingType: "Projects"})    
  },
  analyticsRead(index, rowData) {
    this.isAnalyticsRead = !this.isAnalyticsRead;
      if(this.isAnalyticsRead && (!this.analyticsPriv.map(t => t).includes("R") || !rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_analytics')) ){
         this.analyticsPriv.push(..."R")
      } else if (!this.isAnalyticsRead) {
          this.analyticsPriv = this.analyticsPriv.filter(t => t !== "R")
      } 
    console.log(`analytics: ${this.analyticsPriv}`)
   },
  analyticsWrite(index, rowData) {
    this.isAnalyticsWrite = !this.isAnalyticsWrite
      if(this.isAnalyticsWrite && (!this.analyticsPriv.map(t => t).includes("W") || !rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_analytics')) ){
         this.analyticsPriv.push(..."W")
      } else if (!this.isAnalyticsWrite) {
          this.analyticsPriv = this.analyticsPriv.filter(t => t !== "W")
      }
    console.log(`analytics: ${this.analyticsPriv}`)
   },
  analyticsDelete(index, rowData) {
    this.isAnalyticsDelete = !this.isAnalyticsDelete;
      if(this.isAnalyticsDelete && (!this.analyticsPriv.map(t => t).includes("D") || !rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_analytics')) ){
         this.analyticsPriv.push(..."D")
      } else if (!this.isAnalyticsDelete) {
          this.analyticsPriv = this.analyticsPriv.filter(t => t !== "D")
      } 
    console.log(`analytics: ${this.analyticsPriv}`)
   },
  tasksRead(index, rowData) {
  this.isTasksRead =  !this.isTasksRead
    if(this.isTasksRead && (!this.tasksPriv.map(t => t).includes("R") || !rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_tasks')) ){
          this.tasksPriv.push(..."R")
        } else if (!this.isTasksRead) {
          this.tasksPriv = this.tasksPriv.filter(t => t !== "R")
        } 
      console.log(`tasks: ${this.tasksPriv}`)

  },
  tasksWrite(index, rowData) {
  this.isTasksWrite =  !this.isTasksWrite
    if(this.isTasksWrite && (!this.tasksPriv.map(t => t).includes("W") || !rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_tasks')) ){
          this.tasksPriv.push(..."W")
        } else if (!this.isTasksWrite) {
          this.tasksPriv = this.tasksPriv.filter(t => t !== "W")
        } 
      console.log(`tasks: ${this.tasksPriv}`)
  },
  tasksDelete(index, rowData) {
  this.isTasksDelete =  !this.isTasksDelete
    if(this.isTasksDelete && (!this.tasksPriv.map(t => t).includes("D") || !rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_tasks')) ){
          this.tasksPriv.push(..."D")
        } else if (!this.isTasksDelete) {
          this.tasksPriv = this.tasksPriv.filter(t => t !== "D")
        } 
      console.log(`tasks: ${this.tasksPriv}`)
  },
  issuesRead(index, rowData) {
    this.isIssuesRead= !this.isIssuesRead
    if(this.isIssuesRead && (!this.issuesPriv.map(t => t).includes("R") || !rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_issues')) ){
          this.issuesPriv.push(..."R")
        } else if (!this.isIssuesRead) {
          this.issuesPriv = this.issuesPriv.filter(t => t !== "R")
        } 
      console.log(`issues: ${this.issuesPriv}`)
  },
  issuesWrite(index, rowData) {
    this.isIssuesWrite = !this.isIssuesWrite
    if(this.isIssuesWrite && (!this.issuesPriv.map(t => t).includes("W") || !rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_issues')) ){
          this.issuesPriv.push(..."W")
        } else if (!this.isIssuesWrite) {
          this.issuesPriv = this.issuesPriv.filter(t => t !== "W")
        } 
      console.log(`issues: ${this.issuesPriv}`)
  },
  issuesDelete(index, rowData) {
  this.isIssuesDelete = !this.isIssuesDelete
    if(this.isIssuesDelete && (!this.issuesPriv.map(t => t).includes("D") || !rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_issues')) ){
          this.issuesPriv.push(..."D")
        } else if (!this.isIssuesDelete) {
          this.issuesPriv = this.issuesPriv.filter(t => t !== "D")
        } 
      console.log(`issues: ${this.issuesPriv}`)
  },
  risksRead(index, rowData) {
    this.isRisksRead = !this.isRisksRead
  if(this.isRisksRead && (!this.risksPriv.map(t => t).includes("R") || !rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_risks')) ){
        this.risksPriv.push(..."R")
        } else if (!this.isRisksRead) {
          this.risksPriv = this.risksPriv.filter(t => t !== "R")
        } 
    console.log(`risks: ${this.risksPriv}`)
  },
  risksWrite(index, rowData) {
    this.isRisksWrite = !this.isRisksWrite
      if(this.isRisksWrite && (!this.risksPriv.map(t => t).includes("W") || !rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_risks')) ){
        this.risksPriv.push(..."W")
        } else if (!this.isRisksWrite) {
          this.risksPriv = this.risksPriv.filter(t => t !== "W")
        } 
      console.log(`risks: ${this.risksPriv}`)
  },
  risksDelete(index, rowData) {
    this.isRisksDelete = !this.isRisksDelete
      if(this.isRisksDelete && (!this.risksPriv.map(t => t).includes("D") || !rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_risks')) ){
        this.risksPriv.push(..."D")
        } else if (!this.isRisksDelete) {
          this.risksPriv = this.risksPriv.filter(t => t !== "D")
        } 
    console.log(`risks: ${this.risksPriv}`)
  },
//LESSONS//
  lessonsRead(index, rowData) {
    this.isLessonsRead = !this.isLessonsRead
    if(this.isLessonsRead && (!this.lessonsPriv.map(t => t).includes("R") || !rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_lessons')) ){
        this.lessonsPriv.push(..."R")
      } else if (!this.isLessonsRead) {
      this.lessonsPriv = this.lessonsPriv.filter(t => t !== "R")
      } 
    console.log(`lessons: ${this.lessonsPriv}`)
  },
  lessonsWrite(index, rowData) {
    this.isLessonsWrite = !this.isLessonsWrite
      if(this.isLessonsWrite && (!this.lessonsPriv.map(t => t).includes("W") || !rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_lessons')) ){
        this.lessonsPriv.push(..."W")
      } else if (!this.isLessonsWrite) {
      this.lessonsPriv = this.lessonsPriv.filter(t => t !== "W")
      } 
    console.log(`lessons: ${this.lessonsPriv}`)

  },
  lessonsDelete(index, rowData) {
    this.isLessonsDelete = !this.isLessonsDelete
    if(this.isLessonsDelete && (!this.lessonsPriv.map(t => t).includes("D") || !rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_lessons')) ){
        this.lessonsPriv.push(..."D")
    } else if (!this.isLessonsDelete) {
      this.lessonsPriv = this.lessonsPriv.filter(t => t !== "D")
    } 
    console.log(`lessons: ${this.lessonsPriv}`)
  },
//NOTES
  notesRead(index, rowData) {
    this.isNotesRead = !this.isNotesRead
    if(this.isNotesRead && (!this.notesPriv.map(t => t).includes("R") || !rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_notes')) ){
        this.notesPriv.push(..."R")
      } else if (!this.isNotesRead) {
      this.notesPriv = this.notesPriv.filter(t => t !== "R")
      }
      console.log(`notes: ${this.notesPriv}`)
  },
  notesWrite(index, rowData) {
    this.isNotesWrite = !this.isNotesWrite
    if(this.isNotesWrite && (!this.notesPriv.map(t => t).includes("W") || !rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_notes')) ){
        this.notesPriv.push(..."W")
      } else if (!this.isNotesWrite) {
      this.notesPriv = this.notesPriv.filter(t => t !== "W")
      }
      console.log(`notes: ${this.notesPriv}`)
  },
  notesDelete(index, rowData) {
    this.isNotesDelete = !this.isNotesDelete
  if(this.isNotesDelete && (!this.notesPriv.map(t => t).includes("D") || !rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_notes')) ){
        this.notesPriv.push(..."D")
      } else if (!this.isNotesDelete) {
      this.notesPriv = this.notesPriv.filter(t => t !== "D")
      }
      console.log(`notes: ${this.notesPriv}`)
  },
  showHideCreateRow(row, index){   
    // console.log(row.rowIndex)    
      return row.rowIndex == 0 && !this.showCreateRow ? 'd-none' : '';
  },
  editRole(index, rowData){
    this.analyticsPriv = [];
    this.tasksPriv = [],
    this.issuesPriv = [],
    this.risksPriv = [], 
    this.notesPriv = [],
    this.lessonsPriv = [],  
    this.isEditting = true;
    this.currentRow = index;
    // ANALYTICS
    if (!rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_analytics')){
        this.isAnalyticsRead = false;
    } 
    if (rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_analytics')) {
        this.analyticsPriv.push(..."R")
        this.isAnalyticsRead = true;
    }
    if (!rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_analytics')) {
         this.isAnalyticsWrite = false
    } 
    if (rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_analytics')) {
        this.analyticsPriv.push(..."W")
        this.isAnalyticsWrite = true;
    }
    if (!rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_analytics')){
        this.isAnalyticsDelete = false;
    }
    if (rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_analytics')){
        this.analyticsPriv.push(..."D")
        this.isAnalyticsDelete = true;
    }

    // TASKS
    if (!rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_tasks')){
        this.isTasksRead = false;
    } 
    if (rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_tasks')) {
        this.tasksPriv.push(..."R");
        this.isTasksRead = true;
    }
    if (!rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_tasks')) {
        this.isTasksWrite =  false;
    } 
    if (rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_tasks')) {
        this.tasksPriv .push(..."W");
        this.isTasksWrite = true;
    }
    if (!rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_tasks')){
        this.isTasksDelete =  false;
    }
    if (rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_tasks')){
        this.tasksPriv.push(..."D");
        this.isTasksDelete = true;
    }

    //ISSUES
    if (!rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_issues')){
        this.isIssuesRead = false;
    } 
    if (rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_issues')) {
          this.issuesPriv.push(..."R");
          this.isIssuesRead= true;
    }
    if (!rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_issues')) {
        this.isIssuesWrite = false;
    } 
    if (rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_issues')) {
          this.issuesPriv.push(..."W");
          this.isIssuesWrite = true;
    }
    if (!rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_issues')){
        this.isIssuesDelete = false;
    }
    if (rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_issues')){
        this.issuesPriv.push(..."D");
        this.isIssuesDelete = true;
    }

          //RISKS
    if (!rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_risks')){
        this.isRisksRead = false;
    } 
    if (rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_risks')) {
        this.risksPriv.push(..."R")
         this.isRisksRead = true;
    }
    if (!rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_risks')) {
        this.isRisksWrite = false;
    } 
    if (rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_risks')) {
        this.risksPriv.push(..."W");
        this.isRisksWrite = true;
    }
    if (!rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_risks')){
        this.isRisksDelete = false;
    }
    if (rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_risks')){
      this.risksPriv.push(..."D");
      this.isRisksDelete = true;
    }
    //LESSONS
    if (!rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_lessons')){
        this.isLessonsRead = false;
    } 
    if (rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_lessons')) {
        this.lessonsPriv.push(..."R");
        this.isLessonsRead = true;
    }
    if (!rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_lessons')) {
        this.isLessonsWrite = false;
    } 
    if (rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_lessons')) {
        this.lessonsPriv.push(..."W");
         this.isLessonsWrite = true;
    }
    if (!rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_lessons')){
        this.isLessonsDelete = false;
    }
    if (rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_lessons')){
          this.lessonsPriv.push(..."D");
          this.isLessonsDelete = true;
    }

    //NOTES
    if (!rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_notes')){
        this.isNotesRead = false;
    } 
    if (rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_notes')) {
          this.notesPriv.push(..."R");
          this.isNotesRead = true;
    }
    if (!rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_notes')) {
        this.isNotesWrite = false;
    } 
    if (rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_notes')) {
        this.notesPriv.push(..."W");
        this.isNotesWrite = true;
    }
    if (!rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_notes')){
        this.isNotesDelete = false;
    }
    if (rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_notes')){
        this.notesPriv.push(..."D");
        this.isNotesDelete = true;
    }

  },
  addProjectRole() {
    // this.SET_SHOW_CREATE_ROW(!this.showCreateRow);
     this.tableData.unshift({     
        name: "",
        newRow: true, 
        role_privileges: [],
        role_users: [],
        type_of: "project",
      });
        this.isEditting = true;
        this.isAnalyticsRead = true,
        this.isAnalyticsWrite = true,
        this.isAnalyticsDelete = true,

        this.isTasksRead = true,
        this.isTasksWrite = true,
        this.isTasksDelete = true,

        this.isIssuesRead = true,
        this.isIssuesWrite = true,
        this.isIssuesDelete = true,

        this.isRisksRead = true,
        this.isRisksWrite = true,
        this.isRisksDelete = true,

        this.isNotesRead = true,
        this.isNotesWrite = true,
        this.isNotesDelete = true,

        this.isLessonsRead = true,
        this.isLessonsWrite = true,
        this.isLessonsDelete = true,

        this.isEffortsRead = true,
        this.isEffortsWrite = true,
        this.isEffortsDelete = true,

        this.analyticsPriv = [],
        this.tasksPriv = [],
        this.issuesPriv = [],
        this.risksPriv = [],
        this.lessonsPriv = [],
        this.notesPriv = []
            
      if (this.isAnalyticsRead && this.isAnalyticsWrite && this.isAnalyticsDelete ) {
          this.analyticsPriv.push(..."R") 
          this.analyticsPriv.push(..."W")  
          this.analyticsPriv.push(..."D") 
                  
          }
      if (this.isTasksRead && this.isTasksWrite && this.isTasksDelete) {
          this.tasksPriv.push(..."R")     
          this.tasksPriv.push(..."W")     
          this.tasksPriv.push(..."D")       
        }
      if (this.isIssuesRead && this.isIssuesWrite && this.isIssuesDelete) {
          this.issuesPriv.push(..."R")     
          this.issuesPriv.push(..."W")     
          this.issuesPriv.push(..."D")       
        }
      if (this.isRisksRead && this.isRisksWrite && this.isRisksDelete) {
          this.risksPriv.push(..."R")     
          this.risksPriv.push(..."W")     
          this.risksPriv.push(..."D")       
        }
      if (this.isLessonsRead && this.isLessonsWrite && this.isLessonsDelete) {
          this.lessonsPriv.push(..."R")     
          this.lessonsPriv.push(..."W")     
          this.lessonsPriv.push(..."D")       
        }
      if (this.isNotesRead && this.isNotesWrite && this.isNotesWrite) {
          this.notesPriv.push(..."R")     
          this.notesPriv.push(..."W")     
          this.notesPriv.push(..."D")       
      }
      if (this.isEffortsRead && this.isEffortsWrite && this.isEffortsWrite) {
          this.effortsPriv.push(..."R")     
          this.effortsPriv.push(..."W")     
          this.effortsPriv.push(..."D")       
      }
 },
  cancelEditRole(index, rowData){    
    this.isEditting = false;
    this.currentRow = null;
    //ANALYTICS
      if (!rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_analytics')){
          this.isAnalyticsRead = !this.isAnalyticsRead    
      }   
      if (!rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_analytics')) {
        this.isAnalyticsWrite = !this.isAnalyticsWrite
      }   
      if (!rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_analytics')){
         this.isAnalyticsDelete = !this.isAnalyticsDelete
      }
    
      //TASKS
      if (!rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_tasks')){
          this.isTasksRead =  !this.isTasksRead 
      } 
      if (!rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_tasks')) {
         this.isTasksWrite =  !this.isTasksWrite
      } 
      if (!rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_tasks')){
          this.isTasksDelete =  !this.isTasksDelete
      }
       //ISSUES
      if (!rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_issues')){
         this.isIssuesRead= !this.isIssuesRead
      } 
      if (!rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_issues')) {
          this.isIssuesWrite = !this.isIssuesWrite
      } 
      if (!rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_issues')){
          this.isIssuesDelete = !this.isIssuesDelete     }
 
     //RISKS
      if (!rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_risks')){
          this.isRisksRead = !this.isRisksRead
      } 
      if (!rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_risks')) {
          this.isRisksWrite = !this.isRisksWrite
      } 
      if (!rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_risks')){
          this.isRisksDelete = !this.isRisksDelete
      }
      //LESSONS
      if (!rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_lessons')){
           this.isLessonsRead = !this.isLessonsRead
      } 
      if (!rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_lessons')) {
          this.isLessonsWrite = !this.isLessonsWrite
      } 
      if (!rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_lessons')){
          this.isLessonsDelete = !this.isLessonsDelete
      }
      //NOTES
      if (!rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_notes')){
          this.isNotesRead = !this.isNotesRead
      } 
      if (!rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_notes')) {
          this.isNotesWrite = !this.isNotesWrite
      } 
      if (!rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_notes')){
          this.isNotesDelete = !this.isNotesDelete
      }

      //Efforts
      if (!rowData.role_privileges.map(t => t.privilege.includes('R') && t.role_type).includes('project_efforts')){
          this.isEffortsRead = !this.isEffortsRead
      } 
      if (!rowData.role_privileges.map(t => t.privilege.includes('W') && t.role_type).includes('project_efforts')) {
          this.isEffortsWrite = !this.isEffortsWrite
      } 
      if (!rowData.role_privileges.map(t => t.privilege.includes('D') && t.role_type).includes('project_efforts')){
          this.isEffortsDelete = !this.isEffortsDelete
      }
  },
  cancelCreateRole(){
    this.tableData.shift({});
    this.isEditting = false
    this.currentRow = null 
  },  
  closeAddRole() {
    this.addRoleDialogOpen = false;
  },
  saveNewRole(index, rowData){
    let roleData = {};  
     if (rowData.id){
        roleData = {
        role: {
           name: rowData.name,
           id:  rowData.id, 
           uId: rowData.user_id,
           pId: this.$route.params.programId,
           type: 'project',
           rp: [
              {
                privilege: this.analyticsPriv.join(''),
                role_type: "project_analytics",
                name: rowData.name,
                id:  rowData.role_privileges[0].id
              }, 
              {
                privilege: this.tasksPriv.join(''),
                role_type: "project_tasks",
                name: rowData.name,
                id:  rowData.role_privileges[1].id
              },
              {
                privilege: this.issuesPriv.join(''),
                role_type: "project_issues",
                name: rowData.name,
                id:  rowData.role_privileges[2].id
              },
              {
                privilege: this.risksPriv.join(''),
                role_type: "project_risks",
                name: rowData.name,
                id:  rowData.role_privileges[3].id
              }, 
             {
                privilege: this.notesPriv.join(''),
                role_type: "project_notes",
                name: rowData.name,
                id:  rowData.role_privileges[4].id
              }, 
              {
                privilege: this.lessonsPriv.join(''),
                role_type: "project_lessons",
                name: rowData.name,
                id:  rowData.role_privileges[5].id
              },
              {
                privilege: this.effortsPriv.join(''),
                role_type: "project_efforts",
                name: rowData.name,
                id:  rowData.role_privileges[5].id
              },
            ],
        },
      };
      this.updateRole({
        ...roleData,
      }); 
        
           console.log(roleData)
      } else {
        let newRoleData = {
        role: {
           name:  rowData.name,
           uId: '',
           type: 'project',
           pId: this.$route.params.programId,
            rp: [
              {
                privilege: this.analyticsPriv.join(''),
                role_type: "project_analytics",
                name:  rowData.name, 
              }, 
              {
                privilege: this.tasksPriv.join(''),
                role_type: "project_tasks",
                name:  rowData.name, 
              },
              {
                privilege: this.issuesPriv.join(''),
                role_type: "project_issues",
                name:  rowData.name, 
              },
              {
                privilege: this.risksPriv.join(''),
                role_type: "project_risks",
                name:  rowData.name, 
              }, 
             {
                privilege: this.notesPriv.join(''),
                role_type: "project_notes",
                name:  rowData.name, 
              }, 
              {
                privilege: this.lessonsPriv.join(''),
                role_type: "project_lessons",
                name:  rowData.name, 
              },
              {
                privilege: this.effortsPriv.join(''),
                role_type: "project_efforts",
                name: rowData.name
              },
            ],
        },
      };
      this.createRole({
        ...newRoleData,
      });

      }   
          this.isEditting = false;
          this.currentRow = null;  
 
    },
   handleClick(tab, event) { 
    if(tab){
        this.isEditting = false;
      }  
    },
  },
  // mounted() {
  //   this.fetchRoles(this.$route.params.programId)
  // },
  computed: {
    ...mapGetters([
        "contentLoaded",
        "currentProject",
        "getPortfolioUsers",
        "activeProjectUsers",
        "newRoleStatus",
        "getRoles",
        "showCreateRow",
         "updatedProjectRoleStatus"
    ]),
    project(){
      return {
        analytics: 'project_analytics',
        tasks: 'project_tasks',
        issues: 'project_issues',
        risks: 'project_risks',
        lessons: 'project_lessons',
        notes: 'project_notes',
        efforts: 'project_efforts'
      }
    },
     backToSettings() {
      return `/programs/${this.$route.params.programId}/settings`;
    },
     tableData(){
      if(this.getRoles && this.getRoles.length > 0){
        // console.log(this.getRoles)
        return this.getRoles.filter(role => role.type_of == 'project')
        }  
       } 
    },
  watch: { 
    newRoleStatus: {
      handler() {
        if (this.newRoleStatus == 200) {
          MessageDialogService.showDialog({
            message: `New role successfully added to your program.`,
            
            
          });
          this.SET_NEW_ROLE_STATUS(0);
          this.fetchRoles(this.$route.params.programId)
         
         }
      },
    },
 
    updatedProjectRoleStatus: {
    handler() {
      if (this.updatedProjectRoleStatus == 200) {
       MessageDialogService.showDialog({
          message: `Role successfully updated.`
        }); 
         console.log("updatedRole in Projects Tab")
        this.isEditting = false;
        this.SET_UPDATED_PROJECT_ROLE_STATUS(0);
        this.fetchRoles(this.$route.params.programId)
        this.currentRow = null;          
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
 .crudRow{
  ::v-deep.el-input__inner{
  border: 1px solid #d9534f;
  }
 }
.buttonWrapper {
  border-bottom: lightgray solid 1px;
}
::v-deep.el-dialog__header.users{
  padding: 0;
}
::v-deep.el-table th.el-table__cell > .cell {
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