<template>
<div>
 <el-table 
  v-if="tableData && tableData.length > 0"  
  :data="tableData"   
  height="450"
  class="crudRow"
 :row-class-name="showHideCreateRow"
  >
  <el-table-column
    fixed
    prop="role"
    label="Projects Role"
    width="250">

  <template slot-scope="scope">
  <span v-if="scope.$index == 0">
    <el-input
    size="small"         
    style="font-style: italic; color: red"
    v-model="newRoleName"
    placeholder="Enter New Role Name"
    controls-position="right"
  >
  </el-input>
  </span>
  <span v-else>
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

    <span 
      @click.prevent.stop="analyticsRead(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isAnalyticsRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isAnalyticsRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span>

    <span v-if="scope.$index !== 0">
        <span 
        v-if="scope.row.role_privileges.map(t => t.role_type)[0] == project.analytics && 
        scope.row.role_privileges.map(t => t.privilege)[0].includes('R')"  
        > 
          <!-- {{ scope.row.role_privileges.map(t => t.role_type)[0]}}  = 'projects_analytics'  -->
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
       <span 
      @click.prevent.stop="analyticsWrite(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isAnalyticsWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isAnalyticsWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span>

    <span 
      v-if="scope.$index !== 0"  
      >
      <span 
      v-if="scope.row.role_privileges.map(t => t.role_type)[0] == project.analytics && 
      scope.row.role_privileges.map(t => t.privilege)[0].includes('W')"  
      >
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
       <span 
      @click.prevent.stop="analyticsDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isAnalyticsDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isAnalyticsDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span>

       <span v-if="scope.$index !== 0">
          <span 
          v-if="scope.row.role_privileges.map(t => t.role_type)[0] == project.analytics && 
          scope.row.role_privileges.map(t => t.privilege)[0].includes('D')"  
          >
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
       <span 
      @click.prevent.stop="tasksRead(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isTasksRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isTasksRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span>

        <span v-if="scope.$index !== 0">
          <span 
          v-if="scope.row.role_privileges.map(t => t.role_type)[1] == project.tasks && 
          scope.row.role_privileges.map(t => t.privilege)[1].includes('R')"  
          >
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
      <span 
       @click.prevent.stop="tasksWrite(scope.$index, scope.row)"
       v-if="scope.$index == 0">
       <span v-if="isTasksWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isTasksWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
      </span>

        <span v-if="scope.$index !== 0 ">
          <span 
          v-if="scope.row.role_privileges.map(t => t.role_type)[1] == project.tasks && 
          scope.row.role_privileges.map(t => t.privilege)[1].includes('W')"  
          >
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
      <span 
      @click.prevent.stop="tasksDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isTasksDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isTasksDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span>

        <span v-if="scope.$index !== 0">
          <span 
          v-if="scope.row.role_privileges.map(t => t.role_type)[1] == project.tasks && 
          scope.row.role_privileges.map(t => t.privilege)[1].includes('D')"  
          >
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
      <span 
      @click.prevent.stop="issuesRead(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isIssuesRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isIssuesRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span>

    <span v-if="scope.$index !== 0">
      <span 
      v-if="scope.row.role_privileges.map(t => t.role_type)[2] == project.issues && 
      scope.row.role_privileges.map(t => t.privilege)[2].includes('R')"  
      >
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
     <span 
      @click.prevent.stop="issuesWrite(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isIssuesWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isIssuesWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span>

    <span v-if="scope.$index !== 0">
      <span 
      v-if="scope.row.role_privileges.map(t => t.role_type)[2] ==  project.issues && 
      scope.row.role_privileges.map(t => t.privilege)[2].includes('W')"  
      >
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
       <span 
      @click.prevent.stop="issuesDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isIssuesDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isIssuesDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span>

    <span 
      v-if="scope.$index !== 0">
      <span 
      v-if="scope.row.role_privileges.map(t => t.role_type)[2] == project.issues && 
      scope.row.role_privileges.map(t => t.privilege)[2].includes('D')"  
      >
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
    <span 
      @click.prevent.stop="risksRead(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isRisksRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isRisksRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span>

    <span v-if="scope.$index !== 0" >
      <span 
      v-if="scope.row.role_privileges.map(t => t.role_type)[3] == project.risks && 
      scope.row.role_privileges.map(t => t.privilege)[3].includes('R')"  
      >
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
      <span 
      @click.prevent.stop="risksWrite(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isRisksWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isRisksWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span>

    <span v-if="scope.$index !== 0">
      <span 
      v-if="scope.row.role_privileges.map(t => t.role_type)[3] == project.risks && 
      scope.row.role_privileges.map(t => t.privilege)[3].includes('W')"  
      >
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
        <span 
      @click.prevent.stop="risksDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isRisksDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isRisksDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span>

    <span v-if="scope.$index !== 0">
      <span 
      v-if="scope.row.role_privileges.map(t => t.role_type)[3] == project.risks && 
      scope.row.role_privileges.map(t => t.privilege)[3].includes('D')"  
      >
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
     <span 
      @click.prevent.stop="notesRead(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isNotesRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isNotesRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span>

    <span v-if="scope.$index !== 0">
      <span 
      v-if="scope.row.role_privileges.map(t => t.role_type)[4] == project.notes && 
      scope.row.role_privileges.map(t => t.privilege)[4].includes('R')"  
      >
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
       <span 
      @click.prevent.stop="notesWrite(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isNotesWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isNotesWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span>

    <span v-if="scope.$index !== 0">
      <span 
      v-if="scope.row.role_privileges.map(t => t.role_type)[4] == project.notes && 
      scope.row.role_privileges.map(t => t.privilege)[4].includes('W')"  
      >
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
       <span 
      @click.prevent.stop="notesDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isNotesDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isNotesDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span>

    <span v-if="scope.$index !== 0">
      <span 
      v-if="scope.row.role_privileges.map(t => t.role_type)[4] == project.notes && 
      scope.row.role_privileges.map(t => t.privilege)[4].includes('D')"  
      >
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
       <span 
      @click.prevent.stop="lessonsRead(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isLessonsRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isLessonsRead">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span>

    <span v-if="scope.$index !== 0">
      <span 
      v-if="scope.row.role_privileges.map(t => t.role_type)[5] == project.lessons && 
      scope.row.role_privileges.map(t => t.privilege)[5].includes('R')"  
      >
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
          <span 
      @click.prevent.stop="lessonsWrite(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isLessonsWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isLessonsWrite">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span>

    <span v-if="scope.$index !== 0">
      <span 
      v-if="scope.row.role_privileges.map(t => t.role_type)[5] ==  project.lessons && 
      scope.row.role_privileges.map(t => t.privilege)[5].includes('W')"  
      >
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
          <span 
      @click.prevent.stop="lessonsDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isLessonsDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isLessonsDelete">
        <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
        </span>
    </span>

    <span v-if="scope.$index !== 0">
      <span 
      v-if="scope.row.role_privileges.map(t => t.role_type)[5] ==  project.lessons && 
      scope.row.role_privileges.map(t => t.privilege)[5].includes('D')"  
      >
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
      v-tooltip="`Save edits`"
      v-if="showCreateRow === true && scope.$index == 0 && newRoleName"
      @click.prevent="saveNewRole(scope.$index, scope.row)"
        class="bg-primary btn-sm text-light"
      >
    <i class="far fa-save"></i>
    </el-button>
    <el-button
       type="default"
      @click.prevent="cancelCreateRole(scope.$index, scope.row)"
      v-if="showCreateRow === true && scope.$index == 0"
      class="bg-secondary btn-sm text-light ml-1 "
      v-tooltip="`Cancel`"                  
    >
      <i class="fas fa-ban"></i> 
    </el-button>
    <el-button
      type="default"
      @click.prevent="test(scope.$index, scope.row)"
      v-if="!scope.$index == 0"
      disabled
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
    label="Projects Role"
    width="250">

  <template slot-scope="scope">
  <span >
    <el-input
    size="small"    
    placeholder="Enter New Role Name"     
    style="font-style: italic; color: red"
    v-model="newRoleName"
    controls-position="right"
  >
  </el-input>
  </span>
  

    </template>
  </el-table-column>

  <el-table-column label="Analytics">
    <el-table-column
      prop="read"
      label="Read"
      width="75">

    <template slot-scope="scope">

    <span 
      @click.prevent.stop="analyticsRead(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isAnalyticsRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isAnalyticsRead">
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
      @click.prevent.stop="analyticsWrite(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isAnalyticsWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isAnalyticsWrite">
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
      @click.prevent.stop="analyticsDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isAnalyticsDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isAnalyticsDelete">
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
       <span 
      @click.prevent.stop="tasksRead(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isTasksRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isTasksRead">
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
      @click.prevent.stop="tasksWrite(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isTasksWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isTasksWrite">
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
      @click.prevent.stop="tasksDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isTasksDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isTasksDelete">
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
      <span 
      @click.prevent.stop="issuesRead(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isIssuesRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isIssuesRead">
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
      @click.prevent.stop="issuesWrite(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isIssuesWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isIssuesWrite">
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
      @click.prevent.stop="issuesDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isIssuesDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isIssuesDelete">
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
    <span 
      @click.prevent.stop="risksRead(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isRisksRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isRisksRead">
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
      @click.prevent.stop="risksWrite(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isRisksWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isRisksWrite">
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
      @click.prevent.stop="risksDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isRisksDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isRisksDelete">
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
     <span 
      @click.prevent.stop="notesRead(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isNotesRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isNotesRead">
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
      @click.prevent.stop="notesWrite(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isNotesWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isNotesWrite">
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
      @click.prevent.stop="notesDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isNotesDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isNotesDelete">
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
       <span 
      @click.prevent.stop="lessonsRead(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isLessonsRead">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isLessonsRead">
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
      @click.prevent.stop="lessonsWrite(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isLessonsWrite">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isLessonsWrite">
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
      @click.prevent.stop="lessonsDelete(scope.$index, scope.row)"
      v-if="scope.$index == 0">
       <span v-if="isLessonsDelete">
        <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
        </span>
         <span v-if="!isLessonsDelete">
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
      v-tooltip="`Save edits`"
      v-if="showCreateRow === true && scope.$index == 0"
      @click.prevent="saveNewRole(scope.$index, scope.row)"
      class="bg-primary btn-sm text-light"
      >
    <i class="far fa-save"></i>
    </el-button>
    <el-button
       type="default"
      @click.prevent="cancelCreateRole(scope.$index, scope.row)"
      v-if="showCreateRow === true && scope.$index == 0"
      class="bg-secondary btn-sm text-light"
      v-tooltip="`Cancel`"                  
    >
      <i class="fas fa-ban"></i> 
    </el-button>
    <!-- <el-button
      type="default"
       v-if="showCreateRow === false && scope.$index !== 0"
      @click.prevent="test(scope.$index, scope.row)"
      class="bg-light btn-sm"
      v-tooltip="`Edit Role`"
    >
      <i class="fal fa-edit text-primary"></i>
    </el-button> -->
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

       newRoleName: "",
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
        analyticsPriv: [],
        tasksPriv: [],
        issuesPriv: [],
        risksPriv: [],
        lessonsPriv: [],
        notesPriv: [],
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
    ...mapMutations(["SET_NEW_ROLE_STATUS", "SET_SHOW_CREATE_ROW"]),
  ...mapActions(["fetchRoles", "createRole"]),
  analyticsRead() {
    this.isAnalyticsRead = !this.isAnalyticsRead
    if(this.isAnalyticsRead && !this.analyticsPriv.map(t => t).includes("R") ){
        this.analyticsPriv.push(..."R")
    } else if (!this.isAnalyticsRead) {
        this.analyticsPriv = this.analyticsPriv.filter(t => t !== "R")
    }
      console.log(`analytics: ${this.analyticsPriv}`)

    },
  analyticsWrite() {
    this.isAnalyticsWrite = !this.isAnalyticsWrite
    if(this.isAnalyticsWrite && !this.analyticsPriv.map(t => t).includes("W") ){
        this.analyticsPriv.push(..."W")
    } else if (!this.isAnalyticsWrite) {
        this.analyticsPriv = this.analyticsPriv.filter(t => t !== "W")
    }
      console.log(`analytics: ${this.analyticsPriv}`)

    },
  analyticsDelete() {
  this.isAnalyticsDelete = !this.isAnalyticsDelete
  if(this.isAnalyticsDelete && !this.analyticsPriv.map(t => t).includes("D") ){
      this.analyticsPriv.push(..."D")
  } else if (!this.isAnalyticsDelete) {
      this.analyticsPriv = this.analyticsPriv.filter(t => t !== "D")
  }
    console.log(`analytics: ${this.analyticsPriv}`)

  },
tasksRead() {
 this.isTasksRead =  !this.isTasksRead
  if(this.isTasksRead && !this.tasksPriv.map(t => t).includes("R") ){
    this.tasksPriv.push(..."R")
  } else if (!this.isTasksRead) {
      this.tasksPriv = this.tasksPriv.filter(t => t !== "R")
  }
    console.log(`tasks: ${this.tasksPriv}`)

    },
tasksWrite() {
 this.isTasksWrite =  !this.isTasksWrite
  if(this.isTasksWrite && !this.tasksPriv.map(t => t).includes("W") ){
    this.tasksPriv.push(..."W")
  } else if (!this.isTasksWrite) {
      this.tasksPriv = this.tasksPriv.filter(t => t !== "W")
  }
    console.log(`tasks: ${this.tasksPriv}`)

},
tasksDelete() {
 this.isTasksDelete =  !this.isTasksDelete
  if(this.isTasksDelete && !this.tasksPriv.map(t => t).includes("D") ){
    this.tasksPriv.push(..."D")
  } else if (!this.isTasksDelete) {
      this.tasksPriv = this.tasksPriv.filter(t => t !== "D")
  }
    console.log(`tasks: ${this.tasksPriv}`)

 },
issuesRead() {
  this.isIssuesRead= !this.isIssuesRead
  if(this.isIssuesRead && !this.issuesPriv.map(t => t).includes("R") ){
     this.issuesPriv.push(..."R")
  } else if (!this.isIssuesRead) {
     this.issuesPriv = this.issuesPriv.filter(t => t !== "R")
  }
    console.log(`issues: ${this.issuesPriv}`)

},
issuesWrite() {
  this.isIssuesWrite = !this.isIssuesWrite
  if(this.isIssuesWrite && !this.issuesPriv.map(t => t).includes("W") ){
     this.issuesPriv.push(..."W")
  } else if (!this.isIssuesWrite) {
     this.issuesPriv = this.issuesPriv.filter(t => t !== "W")
  }
    console.log(`issues: ${this.issuesPriv}`)

},
issuesDelete() {
  this.isIssuesDelete = !this.isIssuesDelete
  if(this.isIssuesDelete && !this.issuesPriv.map(t => t).includes("D") ){
     this.issuesPriv.push(..."D")
  } else if (!this.isIssuesDelete) {
     this.issuesPriv = this.issuesPriv.filter(t => t !== "D")
  }
    console.log(`issues: ${this.issuesPriv}`)

},
risksRead() {
  this.isRisksRead = !this.isRisksRead
  if(this.isRisksRead && !this.risksPriv.map(t => t).includes("R") ){
     this.risksPriv.push(..."R")
  } else if (!this.isRisksRead) {
     this.risksPriv = this.risksPriv.filter(t => t !== "R")
  }
  console.log(`risks: ${this.risksPriv}`)

},
risksWrite() {
  this.isRisksWrite = !this.isRisksWrite
  if(this.isRisksWrite && !this.risksPriv.map(t => t).includes("W") ){
     this.risksPriv.push(..."W")
  } else if (!this.isRisksWrite) {
     this.risksPriv = this.risksPriv.filter(t => t !== "W")
  }
    console.log(`risks: ${this.risksPriv}`)

},
risksDelete() {
  this.isRisksDelete = !this.isRisksDelete
  if(this.isRisksDelete && !this.risksPriv.map(t => t).includes("D") ){
     this.risksPriv.push(..."D")
  } else if (!this.isRisksDelete) {
     this.risksPriv = this.risksPriv.filter(t => t !== "D")
  }
    console.log(`risks: ${this.risksPriv}`)

},

//LESSONS//
lessonsRead() {
  this.isLessonsRead = !this.isLessonsRead
  if(this.isLessonsRead && !this.lessonsPriv.map(t => t).includes("R") ){
     this.lessonsPriv.push(..."R")
  } else if (!this.isLessonsRead) {
     this.lessonsPriv = this.lessonsPriv.filter(t => t !== "R")
  }
  console.log(`lessons: ${this.lessonsPriv}`)

},
lessonsWrite() {
  this.isLessonsWrite = !this.isLessonsWrite
  if(this.isLessonsWrite && !this.lessonsPriv.map(t => t).includes("W") ){
     this.lessonsPriv.push(..."W")
  } else if (!this.isLessonsWrite) {
     this.lessonsPriv = this.lessonsPriv.filter(t => t !== "W")
  }
  console.log(`lessons: ${this.lessonsPriv}`)

},
lessonsDelete() {
  this.isLessonsDelete = !this.isLessonsDelete
  if(this.isLessonsDelete && !this.lessonsPriv.map(t => t).includes("D") ){
     this.lessonsPriv.push(..."D")
  } else if (!this.isLessonsDelete) {
     this.lessonsPriv = this.lessonsPriv.filter(t => t !== "D")
  }
  console.log(`lessons: ${this.lessonsPriv}`)

},

//NOTES
notesRead() {
  this.isNotesRead = !this.isNotesRead
  if(this.isNotesRead && !this.notesPriv.map(t => t).includes("R") ){
     this.notesPriv.push(..."R")
  } else if (!this.isNotesRead) {
     this.notesPriv = this.notesPriv.filter(t => t !== "R")
  }
    console.log(`notes: ${this.notesPriv}`)

},

notesWrite() {
  this.isNotesWrite = !this.isNotesWrite
  if(this.isNotesWrite && !this.notesPriv.map(t => t).includes("W") ){
     this.notesPriv.push(..."W")
  } else if (!this.isNotesWrite) {
     this.notesPriv = this.notesPriv.filter(t => t !== "W")
  }
    console.log(`notes: ${this.notesPriv}`)

},

notesDelete() {
  this.isNotesDelete = !this.isNotesDelete
  if(this.isNotesDelete && !this.notesPriv.map(t => t).includes("D") ){
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
 cancelCreateRole(rows, index) {
  //  console.log(this.table)
    this.SET_SHOW_CREATE_ROW(!this.showCreateRow);
   },
    closeAddRole() {
      this.addRoleDialogOpen = false;
    },
    test(rows, index){

      console.log(rows)
      console.log(index)
    },
  saveNewRole(rows, index){
        let newRoleData = {
        role: {
           name: this.newRoleName,
           uId: '',
           type: 'project',
           pId: this.$route.params.programId,
            rp: [
              {
                privilege: this.analyticsPriv.join(''),
                role_type: "project_analytics",
                name: this.newRoleName, 
              }, 
              {
                privilege: this.tasksPriv.join(''),
                role_type: "project_tasks",
                name: this.newRoleName, 
              },
              {
                privilege: this.issuesPriv.join(''),
                role_type: "project_issues",
                name: this.newRoleName, 
              },
              {
                privilege: this.risksPriv.join(''),
                role_type: "project_risks",
                name: this.newRoleName, 
              }, 
             {
                privilege: this.notesPriv.join(''),
                role_type: "project_notes",
                name: this.newRoleName, 
              }, 
              {
                privilege: this.lessonsPriv.join(''),
                role_type: "project_lessons",
                name: this.newRoleName, 
              },
            ],
        },
      };
      this.createRole({
        ...newRoleData,
      });
      console.log(this.project.tasks)
      this.newRoleName = ""
      this.SET_SHOW_CREATE_ROW(!this.showCreateRow)
      this.newRoleName = ""
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
    },
    handleClick(tab, event) { 
             // Route redirecting incase we want to assign url paths to each tab
        // if(tab.index == 1) {
        //  this.$router.push({ name: "SettingsRolesProjects" })
        // }   
   
    },

   },
  mounted() {
    this.fetchRoles(this.$route.params.programId)
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
  },
  computed: {
    ...mapGetters([
        "contentLoaded",
        "currentProject",
        "getPortfolioUsers",
        "activeProjectUsers",
        "newRoleStatus",
        "getRoles",
        "showCreateRow"
    ]),
    project(){
      return {
        analytics: 'project_analytics',
        tasks: 'project_tasks',
        issues: 'project_issues',
        risks: 'project_risks',
        lessons: 'project_lessons',
        notes: 'project_notes'
      }
    },
     backToSettings() {
      return `/programs/${this.$route.params.programId}/settings`;
    },
     tableData(){
      if(this.getRoles && this.getRoles.length > 0){
        console.log(this.getRoles)
        return this.getRoles.filter(role => role.type_of == 'project')
        }  
       } 
    },
  watch: { 
    newRoleStatus: {
      handler() {
        if (this.newRoleStatus == 200) {
          this.$message({
            message: `New role successfully added to your program.`,
            type: "success",
            showClose: true,
          });
          this.SET_NEW_ROLE_STATUS(0);
          this.fetchRoles(this.$route.params.programId)
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
  /deep/.el-input__inner{
  border: 1px solid #d9534f;
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