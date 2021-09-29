<template>
<div class="box-shadow py-2"  style="postion:relative" :load="log(programLessons)">
  <el-dialog :visible.sync="dialogVisible" append-to-body center class="portfolioDialogMode">
    <template slot="title">
    <div v-if="dynamicObj.length > 0 && dynamicObj[currentLessonSlide] !== undefined" class="container-fluid">
      <h3 class="pl-2 pr-5 mt-3 d-inline-block mh-blue px-3 text-light" style="cursor:pointer; position:absolute; left:0; top:0">{{ action }}</h3>
        <div v-for="number in [currentLessonSlide]" :key="number" >
        <div class="row justify-content-center">
          <div class="col-3 pb-0">
              <img
                class="mb-0"
                style="width: 125px"
                :src="require('../../../../assets/images/mpath.png')"
              />
          </div>
          <div class="col-5 text-center px-3 py-2">                 
         
            <span  v-if="dynamicObj[currentLessonSlide].completed" v-tooltip="`Completed`"
              ><i
                class="fas fa-clipboard-check text-success mr-1" style="font-size:1.8rem"
              ></i
            ></span>
             <span
                v-if="!dynamicObj[currentLessonSlide].draft"
                v-tooltip="`Completed`"
              ><i
                class="fas fa-clipboard-check text-success mr-1" style="font-size:1.8rem"
              ></i
            ></span>
         
            <span  v-if="dynamicObj[currentLessonSlide].draft == true" v-tooltip="`Draft`">
              <i class="fas fa-pencil-alt mr-1 text-warning" style="font-size:1.8rem"></i
            ></span>
           
                <span v-if="dynamicObj[currentLessonSlide].title"> 
                <h2 class="mt-2 d-inline text-truncate breakWord">{{ dynamicObj[currentLessonSlide].title }}</h2>
              </span>
                </div>
                    <div class="col-3 mt-3">
                    <img
                        style="width: 145px"
                      :src="require('../../../../assets/images/microhealthllc.png')"
                    />
                </div>
            </div>

                  <div class="row pt-3 justify-content-center">

                    <div class="col-3 text-center slideCol leftProgramCol">                                          
                    
                
                      <div class="col py-2">  
                      
                      <h6 class="mh-orange leftColLabel text-light">PROGRAM</h6>
                      <h4>{{dynamicObj[currentLessonSlide].program_name}}</h4>
                    </div>    
                
                    <div class="col truncate-line-two">    
                          <h6 class="leftColLabel text-light mh-orange">PROJECT GROUP</h6>
                      <h4> {{dynamicObj[currentLessonSlide].project_group}}  </h4>
                                                    
                    </div>  
            
                      <div class="col py-2">    
                          <h6 class="leftColLabel text-light mh-orange">PROJECT</h6>
                      <h4>{{ dynamicObj[currentLessonSlide].project_name}}  </h4>                                                                 
                    </div>  

                        <div class="col">    
                          <h6 class="leftColLabel mh-blue text-light">PROCESS AREA</h6>
                      <h4 v-if="dynamicObj[currentLessonSlide].category" >{{ dynamicObj[currentLessonSlide].category}}  </h4> 
                      <h4 v-else> -- </h4>                                                                
                    </div>  

                  </div>    
                  
                                          
                  <div class="col-5 text-center  mx-4 p-0" v-if="dynamicObj[currentLessonSlide] !== undefined">
                  <div class="lastUpdateCol">                                
                    <h3 class="mh-green text-light d-block">LAST UPDATE</h3>
                    <div style="height:300px; overflow-y:auto">
                    <span  v-if="dynamicObj[currentLessonSlide].notes_updated_at.length > 0">                    
                    <span>
                      <br>
                      <h4 class="px-3"> <em>{{ dynamicObj[currentLessonSlide].notes[dynamicObj[currentLessonSlide].notes.length - 1].body }}</em></h4>
                    </span>
                      <span
                      class="px-2"                                                                 
                      >
                      <h6 class="mt-2">{{
                        moment(dynamicObj[currentLessonSlide].notes_updated_at[0]).format(
                          "DD MMM YYYY, h:mm a "
                        ) + ' By: ' +
                        dynamicObj[currentLessonSlide].notes[dynamicObj[currentLessonSlide].notes.length - 1].user.full_name
                      }} 
                      </h6>
                    </span>
                      </span>
                      <span v-else>
                        <br>
                        <h4 class="px-3" style="color:lightgray"><em>NO UPDATES</em></h4>
                      </span>
                  </div>  
                  </div> 
           
                  </div>


                      <div class="col-3 mh-blue text-center text-light slideCol"  v-if="dynamicObj[currentLessonSlide] !== undefined">                                          
                                   
                      <div class="col pt-2">  
                        <i class="fas fa-calendar text-light d-block pb-1" style="font-size:2.8rem"></i>
                      <span v-if="dynamicObj[currentLessonSlide].date" class="d-inline-block"> <h5>{{ moment(dynamicObj[currentLessonSlide].date).format( "DD MMM YYYY") }}</h5></span>

                    </div>    
                
                
                      <div class="col mt-3 truncate-line-two">      
                      <i class="fas fa-user d-block text-light" style="font-size:2.8rem"></i>
                            <span class="truncate-line-two" v-if="dynamicObj[currentLessonSlide].added_by"><h4>Added By:  {{ dynamicObj[currentLessonSlide].added_by }}</h4></span>
                                                              
                    </div>               
                  </div>  
                 </div>   
                  
              </div>
          
          </div>
          <div slot="footer" class="dialog-footer-left"  v-if="dynamicObj[currentLessonSlide] !== undefined">                       
              <el-button class="elBtn tagsBtn py-1 text-light mr-2" > <h5 class="d-inline px-2 text-dark">FOCUS FLAGS: </h5>
                <span
              v-if="dynamicObj[currentLessonSlide].watched == true"
              v-tooltip="`On Watch`"
              ><i class="fas fa-eye mr-1 text-dark" style="font-size:1.5rem"></i
            ></span> 
            <span
              v-if="dynamicObj[currentLessonSlide].important == true"
              v-tooltip="`Important`"
            >
              <i class="fas fa-star text-warning mr-1 " style="font-size:1.5rem"></i
            ></span> 
            <span v-if="dynamicObj[currentLessonSlide].reportable" v-tooltip="`Briefings`">
              <i class="fas fa-presentation mr-1 text-primary" style="font-size:1.5rem"></i
            ></span>                
              
              
              </el-button>
            
          </div>

          <div slot="footer" class="dialog-footer">
          <el-button class="mh-orange elBtn text-light" @click.prevent="previousLesson"><i class="far fa-chevron-left" style="font-size:1.35rem"></i></el-button>
          <el-button class="bg-secondary elBtn text-light" ><span style="font-size:1.35rem"><span>{{ action }}</span> {{ currentLessonSlide + 1 }} of {{ dynamicObj.length}}</span></el-button>                      
          <el-button class="mh-orange elBtn text-light"  @click.prevent="nextLesson"><i class="far fa-chevron-right" style="font-size:1.35rem"></i></el-button>
          </div>
          </template>
</el-dialog>

<div class="row py-1 pr-2">
<div class="col-10 px-1 pt-2">
    <!-- <div class="pb-0 pl-2 pr-4 mb-0 d-inline-flex">  
        <button class="btn btn-info btn-md">Add Task</button> 
        </div> -->

    <div class="pb-0 pl-2 pr-4 mb-0 d-inline-flex">
    <span class=""
        ><label class="font-sm px-2 mt-4 d-block"
        >STATES TO DISPLAY</label
        >
    </span>

    <span class="d-flex statesCol mr-3 px-3 py-2">
        <div
        class="pr-4 text-center icons"
        :class="[getHideComplete == true ? 'light' : '']"
        @click.prevent="toggleComplete"
        >
        <span class="d-block">
            <i
            class="fas fa-clipboard-check"
            :class="[
                getHideComplete == true ? 'light' : 'text-success',
            ]"
            ></i>
        </span>
        <span class="smallerFont">COMPLETE</span>
        <h5
            :class="[
            getShowCount == false ? 'd-none' : 'd-block',
            ]"
        >
            {{ lessonVariation.completed.count }}
        </h5>
        </div>
  
        <div
        class="text-center icons"
        :class="[getHideDraft == true ? 'light' : '']"
        @click.prevent="toggleDraft"
        >
        <span class="d-block">
            <i
            class="fas fa-pencil-alt"
            :class="[
                getHideDraft == true ? 'light' : 'text-warning',
            ]"
            ></i>
        </span>
        <span class="smallerFont">DRAFTS</span>
        <h5
            :class="[
            getShowCount == false ? 'd-none' : 'd-block',
            ]"
        >
            {{ lessonVariation.drafts.count }}
        </h5>
        </div>
    </span>

    <span class=""
        ><label class="font-sm mt-4 pr-2"><b>FOCUS</b></label>
    </span>
    <span class="tagsCol d-flex px-3 py-2">
       <div
        class="px-4 text-center icons"
        :class="[getHideImportant == true ? '' : 'light']"
        @click.prevent="toggleImportant"
        >
        <span class="d-block">
            <i
            class="fas fa-star"
            :class="[
                getHideImportant == true ? 'text-warning' : 'light',
            ]"
            ></i>
        </span>
        <span class="smallerFont">IMPORTANT</span>
        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="important" v-model="C_hideImportantTasks">     -->
        <h5
            :class="[
            getShowCount == false ? 'd-none' : 'd-block',
            ]"
        >
            {{ lessonVariation.important.count }}
        </h5>
        </div>
        <div
        class="text-center icons"
        :class="[getHideBriefed == true ? '' : 'light']"
        @click.prevent="toggleBriefed"
        >
        <span class="d-block">
            <i
            class="fas fa-presentation"
            :class="[
                getHideBriefed == true ? 'text-primary' : 'light',
            ]"
            ></i>
        </span>
        <span class="smallerFont">BRIEFINGS </span>
        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="briefed" v-model="C_hideBriefedTasks">   -->
        <h5
            :class="[
            getShowCount == false ? 'd-none' : 'd-block',
            ]"
        >
            {{ lessonVariation.briefings.count }}
        </h5>
        </div>
    </span>
    </div>
    <template>
    <v-checkbox     
    v-model="C_showCountToggle"     
    class="d-inline-block portfolio"  
    @click.prevent="showCounts"   
    :label="`Show Counts`"
></v-checkbox>
    </template>
</div>

<div class="col-2 pl-0 pr-2">
    <span class="btnRow d-flex">
    <button
        v-tooltip="`Presentation Mode`"
        @click.prevent="openPresentation"
        class="btn btn-md presentBtn mr-1 mh-blue text-light"
    >
        <i class="fas fa-presentation"></i>
    </button>
    <button
        v-tooltip="`Export to PDF`"
        @click.prevent="exportTasksToPdf"
        class="btn btn-md exportBtns text-light"
    >
        <i class="far fa-file-pdf"></i>
    </button>
    <button
        v-tooltip="`Export to Excel`"
        @click.prevent="
        exportTasksToExcel('table', 'Portfolio Tasks')
        "
        class="btn btn-md mx-1 exportBtns text-light"
    >
        <i class="far fa-file-excel"></i>
    </button>
    <button
        class="btn text-light btn-md mh-orange px-1 profile-btns portfolioResultsBtn"
    >
        RESULTS: {{ filteredLessons.filtered.lessons.length }}
    </button></span
    >
</div>
</div>

<div
class="row text-center mt-2 pr-3"
style="postion:relative" 
v-if="filteredLessons.filtered.lessons.length > 0"
>
<div class="px-3 tableFixHead" >
    <table
    class="table table-sm table-bordered"
    ref="table"
    id="portTasks"                   
    >
    <thead style="background-color: #ededed">    
        <th class="pl-1 sort-th twenty" @click="sortCol1('project_group')">
        Project Group
        <span
            class="inactive-sort-icon scroll"
            v-if="currentSortCol1 !== 'project_group'"
        >
            <i class="fas fa-sort"></i
        ></span>
        <span
            class="sort-icon main scroll"
            v-if="
            currentSortDir1 === 'asc' && currentSortCol1 === 'project_group'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir1 !== 'asc' && currentSortCol1 === 'project_group'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="sort-icon main scroll"
            v-if="
            currentSortDir1 === 'desc' && currentSortCol1 === 'project_group'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir1 !== 'desc' && currentSortCol1 === 'project_group'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        </th> 
        <th class="pl-1 sort-th twenty" @click="sortCol2('project_name')">
        Project 
        <span
            class="inactive-sort-icon scroll"
            v-if="currentSortCol2 !== 'facilityName'"
        >
            <i class="fas fa-sort"></i
        ></span>
        <span
            class="sort-icon main scroll"
            v-if="
            currentSortDir2 === 'asc' && currentSortCol2 === 'project_name'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir2 !== 'asc' && currentSortCol2 === 'project_name'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="sort-icon main scroll"
            v-if="
            currentSortDir2 === 'desc' && currentSortCol2 === 'project_name'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir2 !== 'desc' && currentSortCol2 === 'project_name'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        </th>                 
        <th class="pl-1 sort-th" @click="sort('title')">
            Lessons Learned
            <span
              class="inactive-sort-icon scroll"
              v-if="currentSort !== 'title'"
            >
              <i class="fas fa-sort"></i
            ></span>
            <span
              class="sort-icon scroll"
              v-if="
                currentSortDir === 'asc' && currentSort === 'title'
              "
            >
              <i class="fas fa-sort-up"></i
            ></span>
            <span
              class="inactive-sort-icon scroll"
              v-if="
                currentSortDir !== 'asc' && currentSort === 'title'
              "
            >
              <i class="fas fa-sort-up"></i
            ></span>
            <span
              class="sort-icon scroll"
              v-if="
                currentSortDir === 'desc' && currentSort === 'title'
              "
            >
              <i class="fas fa-sort-down"></i
            ></span>
            <span
              class="inactive-sort-icon scroll"
              v-if="
                currentSortDir !== 'desc' && currentSort === 'title'
              "
            >
              <i class="fas fa-sort-down"></i
            ></span>
        </th> 
        <th
          class="sort-th twenty"
          @click="sort('notes_updated_at')"
          style="min-width: 300px"
        >
        Last Update
        <span
            class="inactive-sort-icon scroll"
            v-if="currentSort !== 'notes_updated_at'"
        >
            <i class="fas fa-sort"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'asc' &&
            currentSort === 'notes_updated_at'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'asc' &&
            currentSort === 'notes_updated_at'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'desc' &&
            currentSort === 'notes_updated_at'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'desc' &&
            currentSort === 'notes_updated_at'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        </th>
        <th
        class="pl-1 sort-th"
        style="min-width: 325px"
        @click="sort('description')"
      >
        Description
        <span
          class="inactive-sort-icon scroll"
          v-if="currentSort !== 'description'"
        >
          <i class="fas fa-sort"></i
        ></span>
        <span
          class="sort-icon scroll"
          v-if="
            currentSortDir === 'asc' &&
            currentSort === 'description'
          "
        >
          <i class="fas fa-sort-up"></i
        ></span>
        <span
          class="inactive-sort-icon scroll"
          v-if="
            currentSortDir !== 'asc' &&
            currentSort === 'description'
          "
        >
          <i class="fas fa-sort-up"></i
        ></span>
        <span
          class="sort-icon scroll"
          v-if="
            currentSortDir === 'desc' &&
            currentSort === 'description'
          "
        >
          <i class="fas fa-sort-down"></i
        ></span>
        <span
          class="inactive-sort-icon scroll"
          v-if="
            currentSortDir !== 'desc' &&
            currentSort === 'description'
          "
        >
          <i class="fas fa-sort-down"></i
        ></span>
        </th>
        <th class="sort-th" @click="sort('added_by')">
          Added By
          <span
            class="inactive-sort-icon scroll"
            v-if="currentSort !== 'added_by'"
          >
            <i class="fas fa-sort"></i
          ></span>
          <span
            class="sort-icon scroll"
            v-if="
              currentSortDir === 'asc' &&
              currentSort === 'added_by'
            "
          >
            <i class="fas fa-sort-up"></i
          ></span>
          <span
            class="inactive-sort-icon scroll"
            v-if="
              currentSortDir !== 'asc' &&
              currentSort === 'added_by'
            "
          >
            <i class="fas fa-sort-up"></i
          ></span>
          <span
            class="sort-icon scroll"
            v-if="
              currentSortDir === 'desc' &&
              currentSort === 'added_by'
            "
          >
            <i class="fas fa-sort-down"></i
          ></span>
          <span
            class="inactive-sort-icon scroll"
            v-if="
              currentSortDir !== 'desc' &&
              currentSort === 'added_by'
            "
          >
            <i class="fas fa-sort-down"></i
          ></span>
        </th>
        <th
          class="sort-th"
          @click="sort('created_at')"
          style="min-width: 140px"
        >
          Date Added
          <span
            class="inactive-sort-icon scroll"
            v-if="currentSort !== 'created_at'"
          >
            <i class="fas fa-sort"></i
          ></span>
          <span
            class="sort-icon scroll"
            v-if="
              currentSortDir === 'asc' &&
              currentSort === 'created_at'
            "
          >
            <i class="fas fa-sort-up"></i
          ></span>
          <span
            class="inactive-sort-icon scroll"
            v-if="
              currentSortDir !== 'asc' &&
              currentSort === 'created_at'
            "
          >
            <i class="fas fa-sort-up"></i
          ></span>
          <span
            class="sort-icon scroll"
            v-if="
              currentSortDir === 'desc' &&
              currentSort === 'created_at'
            "
          >
            <i class="fas fa-sort-down"></i
          ></span>
          <span
            class="inactive-sort-icon scroll"
            v-if="
              currentSortDir !== 'desc' &&
              currentSort === 'created_at'
            "
          >
            <i class="fas fa-sort-down"></i
          ></span>
        </th>  
        <th style="min-width: 145px">Flags</th>
        <th class="pl-1 sort-th twenty" @click="sort('category')">
        Process Area
        <span
            class="inactive-sort-icon scroll"
            v-if="currentSort !== 'category'"
        >
            <i class="fas fa-sort"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'asc' &&
            currentSort === 'category'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'asc' &&
            currentSort === 'category'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'desc' &&
            currentSort === 'category'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'desc' &&
            currentSort === 'category'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        </th>
       
           
    </thead>
    <tbody>
        <tr v-for="(lesson, index) in sortedLessons" :key="index" class="portTable taskHover" @click="openLesson(lesson)">
     
          <td>{{ lesson.project_group }}</td>
          <td>{{ lesson.project_name }}</td>
          <td>{{ lesson.title }}</td>
          <td>
            <span
              class="text-left"
              v-if="lesson.notes_updated_at.length > 0"
            >
              <span
                class="toolTip"
                v-tooltip="
                  'By: ' +
                  lesson.notes[lesson.notes.length - 1].user
                    .full_name
                "
              >
                {{
                  moment(lesson.notes_updated_at[0]).format(
                    "DD MMM YYYY, h:mm a"
                  )
                }}
              </span>
              <br />
              <span class="truncate-line-five">
                {{ lesson.notes[lesson.notes.length - 1].body }}
              </span>
            </span>
              <span class="text-left" v-else>No Update</span>
          </td>
          <td>
            <span class="truncate-line-five">{{
              lesson.description
            }}</span>
          </td>
          <td>{{ lesson.added_by }}</td>
          <td>
          {{ moment(lesson.created_at).format("DD MMM YYYY") }}
        </td>
       
      <td class="text-center">
        <span v-if="lesson.draft == true" v-tooltip="`Draft`">
          <i class="fas fa-pencil-alt text-warning"></i
        ></span>
        <span
          v-if="lesson.draft == false"
          v-tooltip="`Completed`"
        >
          <i class="fas fa-clipboard-check text-success"></i
        ></span>
        <span
          v-if="lesson.important == true"
          v-tooltip="`Important`"
        >
          <i class="fas fa-star text-warning mr-1"></i
        ></span>
        <span
          v-if="lesson.reportable"
          v-tooltip="`Briefings`"
        >
          <i class="fas fa-presentation mr-1 text-primary"></i
        ></span>

        <span
          v-if="
            lesson.important == false &&
            lesson.reportable == false &&
            lesson.draft == false
          "
        >
          <!-- No flags at this time          -->
        </span>
      </td>
      <td>
        <span v-if="lesson.category">{{
          lesson.category
        }}</span>
        <span v-else> --- </span>
      </td>

        </tr>
    </tbody>
    </table>
<!-- EXPORT (Display:None) -->
<!-- <table
class="table table-bordered w-100"
id="portTasks1"
style="display:none"        
>
<thead>      
<tr style="background-color:#ededed">
<th>Task</th>
<th>Process Area</th>
<th>Project</th>
<th>Start Date</th>
<th>Due Date</th>
<th>Assigned Users</th>
<th>Progress</th>        
<th>Flags</th>
<th>Last Update</th>
</tr>
<tr></tr>
</thead>
<tbody v-for="(p, i) in validTaskPrograms" :key="i">  
<tr id="program">  <th scope="row"><b>{{ p }}</b></th></tr>
<tr v-for="(task, index) in sortedTasks" :key="index" v-if="task.program_name == p">            
<td>{{ task.text }}</td>
<td>{{ task.category }}</td>
<td> {{ task.project_name}} </td>
<td>
<span v-if="task.ongoing && !task.closed && task.startDate == null || undefined">
    <i class="fas fa-retweet text-success"></i>
</span>
<span v-else-if="task.ongoing && task.closed && task.startDate == null || undefined">
    <i class="fas fa-retweet text-secondary"></i>
    </span>
<span v-else>{{
    moment(task.startDate).format("DD MMM YYYY") 
}}</span>
</td>
    <td>
<span v-if="task.ongoing && !task.closed" v-tooltip="`Ongoing`"
    ><i class="fas fa-retweet text-success"></i
></span>
    <span v-else-if="task.completed && (task.dueDate == null || task.dueDate == undefined)"></span>
<span
    v-else-if="task.onHold && task.dueDate == null"
    v-tooltip="`On Hold (w/no Due Date)`"
    ><i class="fas fa-pause-circle text-primary"></i
></span>

<span v-else>{{
    moment(task.dueDate).format("DD MMM YYYY")
}}</span>
</td>
    <td>{{ task.users }}</td>

    <td>                          
    <span v-if="task.ongoing && !task.closed" v-tooltip="`Ongoing`"
    ><i class="fas fa-retweet text-success"></i
></span>
<span v-else-if="task.closed" v-tooltip="`Ongoing: Closed`"
    ><i class="fas fa-retweet text-secondary"></i
></span>

    <span v-else>
{{ task.progress + "%" }}
    </span>
</td>
<td class="text-center">
<span v-if="task.is_overdue" v-tooltip="`Overdue`">
    Overdue
    </span>
<span v-if="task.completed" v-tooltip="`Completed`"
    >
    Completed
    </span>
<span
    v-if="task.ongoing == true && !task.closed"
    v-tooltip="`Ongoing`"
    >Ongoing</span>
<span
    v-if="task.closed"
    v-tooltip="`Ongoing: Closed`"
    >Ongoing</span>
<span
    v-if="task.onHold == true"
    v-tooltip="`On Hold`"
>
    On Hold
    </span>
<span v-if="task.draft == true" v-tooltip="`Draft`">
    Draft
    </span>          

<span v-if="task.planned" v-tooltip="`Planned`">
    Planned
    </span>
<span
    v-if="task.inProgress"
    v-tooltip="`In Progress`"
>
In Progress
    </span>
</td>
<td
class="text-left"
v-if="task.notesUpdatedAt.length > 0"
>
<span
    class="toolTip"
    v-tooltip="
    'By: ' +
    task.notes[task.notes.length - 1].user.full_name
    "
>
    {{
    moment(task.notesUpdatedAt[0]).format(
        "DD MMM YYYY, h:mm a"
    )
    }}
</span>
<br />
<span class="truncate-line-five">
    {{ task.notes[task.notes.length - 1].body }}
</span>
</td>
<td class="text-left" v-else>No Update</td> 
</tr>
</tbody>
</table> -->

</div>
<div class="ml-auto mb-4 mt-2 font-sm">
    <div class="simple-select d-inline-block text-right font-sm">
    <span class="mr-1">Displaying </span>
    <el-select
        v-model="C_lessonsPerPage"
        class="w-33"
        track-by="value"
        value-key="id"
    >
        <el-option
        v-for="item in getLessonsPerPageOptions"
        :value="item"
        :key="item.id"
        :label="item.name"
        >
        </el-option>
    </el-select>
    </div>
    <span
    class="mr-1 pr-3"
    style="border-right: solid 1px lightgray"
    >Per Page
    </span>
    <button class="btn btn-sm page-btns" @click="prevPage">
    <i class="fas fa-angle-left"></i>
    </button>
    <button class="btn btn-sm page-btns" id="page-count">
    {{ currentPage }} of
    {{
        Math.ceil(
        filteredLessons.filtered.lessons.length / this.C_lessonsPerPage.value
        )
    }}
    </button>
    <button class="btn btn-sm page-btns" @click="nextPage">
    <i class="fas fa-angle-right"></i>
    </button>
</div>
</div>
<!-- <div v-else-if="!portfolioTasksLoaded" class="load-spinner spinner-border"></div> -->
<div v-else class="mt-5">NO RESULTS TO DISPLAY

    
</div>
</div>
</template>

<script>

import {mapGetters, mapMutations, mapActions} from 'vuex'
// import LessonForm from "./../../dashboard/lessons/LessonForm";

export default {
  name: "ProgramLessons",
  data() {
    return {
      showLess: "Show More",
      showMore: true,
      today: new Date().toISOString().slice(0, 10),
      currentSort: "text",
      dialogVisible: false,
      currentLessonSlide : 0, 
      dynamicObj: {},
      action: '',   
      currentSortCol1: "project_group",
      currentSortCol2: "project_name",
      // currentSortIssueRisk: "title",
      currentSortDir: "asc",
      currentSortDir1: "asc",
      currentSortDir2: "asc",
      facility_project_ids:[],
    };
  },
  computed: {
    ...mapGetters([
    "contentLoaded",
    "currentProject",
    'currLessonPage',
    "lessonsLoaded",
    "projectLessons",
    "programLessons",
    'projects',
    'searchLessons',
    "facilities",
    "facilityCount",
    "facilityGroupFacilities",
    'programCategoriesFilter',
    "facilityProgress",
    "filterDataForAdvancedFilter",
    'projectGroupsFilter',
    "filteredAllIssues",
    "filteredAllLessons",
    "filteredAllTasks",
    "filteredFacilities",
    "filteredFacilityGroups",
    "getAllFilterNames",
    "getFilterValue",
    "getTaskIssueUserFilter",
    'getLessonsPerPageOptions',
    "getUnfilteredFacilities",
    "issueSeverityFilter",
    "issueStageFilter",
    "issueTypeFilter",
    "issueTypes",
    "issueUserFilter",
    "myActionsFilter",
    "onWatchFilter",
    "riskStageFilter",
    "statuses",
    "taskStageFilter",
    "taskTypeFilter",
    "taskTypes",
    "taskTypes",
    "taskUserFilter",
    'getShowAdvancedFilter',
    'getShowCount',

    // USED in PRogram Viewer
    'getLessonsPerPage',
    // 7 States
    'getHideComplete',
    'getHideInprogress',
    'getHidePlanned',
    'getHideOngoing',
    'getHideOnhold',
    'getHideDraft',
    'getHideOverdue',
    // 3 Tags
    'getHideWatched',
    'getHideImportant',
    'getHideBriefed',
    ]),
    currentTab: {
      get() {        
        return this.portfolioTab 
      },
      set(value) {
        if(value === 'issues') {
            this.setCurrTab('#tab-issues')
        } else if (value === 'risks') {
            this.setCurrTab('#tab-risks')
        } else if (value === 'lessons') {
            this.setCurrTab('#tab-lessons')
        } else 
          this.setCurrTab('#tab-tasks')
          this.setPortfolioTab(value)
      }
  },
    C_showCountToggle: {                  
        get() {
         return this.getShowCount                
        },
        set(value) {
          this.setShowCount(value) ||  this.setShowCount(!this.getShowCount)
        }
        
      },

  currentPage:{
       get() {
        return this.currLessonPage
      },
      set(value) {
        this.setCurrLessonPage(value);
      },
    },
   C_lessonsPerPage: {
      get() {
        return this.getLessonsPerPage || {id: 15, name: '15', value: 15}
      },
      set(value) {
        this.setLessonsPerPageFilter(value)
       }
     },
    C_facilityCount() {         
      return this.facilityGroup
      
        ? this.facilityGroupFacilities(this.facilityGroup).length
        : this.facilityCount; 
      
    },
    ProgramView() {
     return `/programs/${this.$route.params.programId}/dataviewer`
    },
    filteredLessons() {
      let lessons = this.programLessons 
      .filter(lesson => {
        // debugger
      if (this.projectGroupsFilter && this.projectGroupsFilter.length > 0) { 
         this.facility_project_ids = [];
         let val = this.projectGroupsFilter
         for(let k = 0; k < val.length; k++){
        if(val[k].program_id){
        this.facility_project_ids = this.facility_project_ids.concat(val[k].all_facility_project_ids)
        }else if(val[k].project_group_id){
         this.facility_project_ids = this.facility_project_ids.concat(val[k].all_facility_project_ids)
        }else if(val[k].project_id){
        this.facility_project_ids.push(val[k].facility_project_id)
        }
      }
       return this.facility_project_ids.includes(lesson.facility_project_id)
      } else return true
        }).filter((l) => {
          if (this.searchLessons !== "") {
            // console.log(issue)
            return (
              l.title.toLowerCase().match(this.searchLessons.toLowerCase()) ||
              l.category
                .toLowerCase()
                .match(this.searchLessons.toLowerCase()) ||
              l.project_group
                .toLowerCase()
                .match(this.searchLessons.toLowerCase()) ||
              l.project_name
                .toLowerCase()
                .match(this.searchLessons.toLowerCase()) ||
              l.added_by.toLowerCase().match(this.searchLessons.toLowerCase())
            );
          } else return true;
          // Filtering 7 Task States
        })
        .filter((l) => {
          if (this.programCategoriesFilter.length > 0) {
            let category = this.programCategoriesFilter.map((t) => t);
            return category.includes(l.category);
          } else return true;
        })
     
      return {
      unfiltered: {      
       lessons, 
      },
        filtered : {
          lessons: lessons.filter(lesson => {
        // Filtering 3 Lesson States        
        if (this.getHideDraft) {
          return !lesson.draft
        } else return true
  
      }).filter(lesson => {
         if (this.getHideComplete) {
          return lesson.draft
        } else return true
      }).filter(lesson => {
         if (this.getHideBriefed && !this.getHideImportant ) {
          return lesson.reportable
        }
        if (this.getHideBriefed && this.getHideImportant) {          
           return lesson.reportable + lesson.important
        } else return true
         
      }).filter(lesson => {
         if (this.getHideImportant && !this.getHideBriefed) {
          return lesson.important
        } if (this.getHideImportant && this.getHideBriefed) {
          return lesson.important + lesson.reportable
       } else return true              
        })
      } 
    }
   },
   sortedLessons:function() {
    return this.filteredLessons.filtered.lessons.sort((a,b) => { 
    let modifier = 1;   
    if(this.currentSortDir === 'desc') modifier = -1;
    if (typeof a[this.currentSort] === "string" && typeof b[this.currentSort] === "string" ) {
      if (typeof a[this.currentSort] === "string" || typeof b[this.currentSort] === "string" ) {
          if (a[this.currentSort].toLowerCase() < b[this.currentSort].toLowerCase()) return -1 * modifier;
    if (a[this.currentSort].toLowerCase() > b[this.currentSort].toLowerCase()) return 1 * modifier;
      }
    } else 
    if (a[this.currentSort] < b[this.currentSort]) return -1 * modifier;
    if (a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
    return 0;
      }).filter((row, index) => {
    let start = (this.currentPage-1)*this.C_lessonsPerPage.value;
    let end = this.currentPage*this.C_lessonsPerPage.value;
    if(index >= start && index < end) return true;
    return this.end
  });
  },
   lessonVariation() {
     let drafts = _.filter(
     this.filteredLessons.unfiltered.lessons,
        (t) => t && t.draft == true
      );  
      let important = _.filter(
      this.filteredLessons.unfiltered.lessons,
        (t) => t && t.important == true
      ); 
     let briefings = _.filter(
       this.filteredLessons.unfiltered.lessons,
        (t) => t && t.reportable == true
      );
     let completed = _.filter(
        this.filteredLessons.unfiltered.lessons,
        (t) => t && t.draft == false 
      );
     return {
       important: {
          count: important.length,             
        },
        briefings: {
          count: briefings.length,          
        },
        drafts: {
          count: drafts.length,          
        },
        completed: {
          count: completed.length,
          // percentage: Math.round(completed_percent),
        },  
        count: {
         val: completed.length + drafts.length
          
        }
    }
   },
    filteredTasks() {
      let typeIds = _.map(this.taskTypeFilter, "id");
      let stageIds = _.map(this.taskStageFilter, "id");
      let tasks = this.facilityGroup
        ? _.flatten(
            _.map(this.facilityGroupFacilities(this.facilityGroup), "tasks")
          )
        : this.filteredAllTasks;
      let taskIssueUsers = this.getTaskIssueUserFilter;
      _.filter(tasks, (resource) => {
        let valid = true;
        let userIds = [
          ..._.map(resource.checklists, "userId"),
          resource.userIds,
        ];
        if (taskIssueUsers.length > 0) {
          valid =
            valid &&
            userIds.some((u) => _.map(taskIssueUsers, "id").indexOf(u) !== -1);
        }
        //TODO: For performance, send the whole tasks array instead of one by one
        valid =
          valid &&
          this.filterDataForAdvancedFilter([resource], "facilityRollupTasks");
        if (stageIds.length > 0)
          valid = valid && stageIds.includes(resource.taskStageId);
        if (typeIds.length > 0)
          valid = valid && typeIds.includes(resource.taskTypeId);
        return valid;
      })
  return {
       unfiltered: {
            tasks
            },
       filtered: {
         tasks:  tasks.filter(t => {
        if (this.getHideOverdue == true) {          
         return t.isOverdue == false
       } else return true

      }).filter(t => {
      if (this.getHideComplete == true) { 
        return !t.completed
      } else return true

      }).filter(t => {
      if (this.getHidePlanned == true) { 
        return t.planned == false
      } else return true

      }).filter(t => {
      if (this.getHideOnhold == true) { 
        return t.onHold == false
      } else return true

      }).filter(t => {
      if (this.getHideInprogress == true) { 
        return t.inProgress == false
      } else return true

      }).filter(t => {
       if (this.getHideDraft == true){
         return t.draft == false
       } else return true   


      }).filter(t => {
      if (this.getHideOngoing == true) {
        return t.ongoing == false
      } else return true       

      }).filter(t => {
        if (this.getHideBriefed && !this.getHideWatched && !this.getHideImportant ) {
        return t.reportable
      }
      if (this.getHideBriefed && this.getHideWatched && !this.getHideImportant) {          
          return t.reportable + t.watched

      } if (this.getHideBriefed && this.getHideWatched && this.getHideImportant) {          
          return t.reportable + t.watched + t.important
      } else return true

      }).filter(t => {
        // This and last 2 filters are for Filtered Tags
         if (this.getHideWatched && !this.getHideBriefed && !this.getHideImportant) {
           return t.watched
        } if (this.getHideWatched && !this.getHideBriefed && this.getHideImportant) {
           return t.watched + t.important
        } if (this.getHideWatched && this.getHideBriefed && !this.getHideImportant) {          
           return  t.watched + t.reportable
        } if (this.getHideWatched && this.getHideBriefed && this.getHideImportant) {          
           return  t.watched + t.reportable + t.important
        } else return true          
       
      }).filter(t => {
         if (this.getHideImportant && !this.getHideBriefed && !this.getHideWatched) {
          return t.important
        } if (this.getHideImportant && this.getHideBriefed && !this.getHideWatched) {
          return t.important + t.reportable
       } if (this.getHideImportant && this.getHideBriefed && this.getHideWatched) {
          return t.important + t.reportable + t.watched
        } else return true           
       }),  
        }
       }     
    },
      sortedTasks:function() {
        return this.filteredTasks.filtered.tasks.sort((a,b) => {
        let modifier = 1;

        if (this.currentSortDir1 === "desc") modifier = -1;
        if (a[this.currentSortCol1] < b[this.currentSortCol1]) return -1 * modifier;
        if (a[this.currentSortCol1] > b[this.currentSortCol1]) return 1 * modifier;
        
        if (this.currentSortDir2 === "desc") modifier = -1;
        if (a[this.currentSortCol2] < b[this.currentSortCol2]) return -1 * modifier;
        if (a[this.currentSortCol2] > b[this.currentSortCol2]) return 1 * modifier;

        if (this.currentSortDir === "desc") modifier = -1;
        if (typeof a[this.currentSort] === "string" && typeof b[this.currentSort] === "string" ) {
                if (typeof a[this.currentSort] === "string" || typeof b[this.currentSort] === "string" ) {
                if (a[this.currentSort].toLowerCase() < b[this.currentSort].toLowerCase()) return -1 * modifier;
            if (a[this.currentSort].toLowerCase() > b[this.currentSort].toLowerCase()) return 1 * modifier;
                }
            } else 
        if (a[this.currentSort] < b[this.currentSort]) return -1 * modifier;
        if (a[this.currentSort] > b[this.currentSort]) return 1 * modifier;        
        return 0;

           }).filter((row, index) => {
          let start = (this.currentPage-1)*this.C_tasksPerPage.value;
          let end = this.currentPage*this.C_tasksPerPage.value;
          if(index >= start && index < end) return true;
          return this.end
        });
    },
   
  },
  methods: {
      ...mapActions([
     'fetchProgramLessons'
     ]), 
    ...mapMutations([
        'setAdvancedFilter',
        'setTaskIssueProgressStatusFilter',
        'setTaskIssueOverdueFilter',
        'setTaskTypeFilter',
        'setMyActionsFilter',
        'setCurrTab',
        'setPortfolioTab',
        'setCurrentPage',
        'setOnWatchFilter',
        'setToggleRACI',
        'setShowAdvancedFilter',
        'setTaskForManager',
        'setShowCount',
        'setCurrLessonPage',

        // Used in Program Viewer
        'setTasksPerPageFilter',
        // 7 States
        'setHideComplete',
        'setHideInprogress',
        'setHidePlanned',
        'setHideOverdue',
        'setHideOngoing',
        'setHideOnhold',
         'setHideDraft',
        // 3 Tags
        'setHideWatched',
        'setHideImportant',
        'setHideBriefed',
      ]),
    beforeClose(done) {
    	this.dialogVisible = false;
      done();
    },
  openLesson(lesson) {       
      this.$router.push({
      name: "ProgramLessonForm",
      params: {
        programId: lesson.program_id,
        projectId: lesson.project_id,
        // id: lesson.id,
        lessonId: lesson.id, 
      },
    });
    // console.log(this.$route.params)
    },
   openPresentation(){
      this.dialogVisible = true; 
      this.currentLessonSlide = 0 
      this.dynamicObj = this.filteredLessons.filtered.lessons
      },
    nextLesson(){
      this.isSlidingToPrevious = false
      if(this.currentLessonSlide == this.dynamicObj.length-1){
          this.currentLessonSlide = 0;
      }else{
          this.currentLessonSlide += 1;
      }
    },
    previousLesson(){ 
        this.isSlidingToPrevious = true
        if(this.currentLessonSlide == 0){
            this.currentLessonSlide = this.dynamicObj.length-1;
        }else{
            this.currentLessonSlide-=1;
        }
    },
      showCounts(){
        this.setShowCount(!this.getShowCount)       
      },

    showLessToggle() {
      this.showLess = "Show Less";
    },
    toggleWatched(){
    this.setHideWatched(!this.getHideWatched)    
    },
    toggleImportant(){
    this.setHideImportant(!this.getHideImportant)    
    },
    toggleBriefed(){
        this.setHideBriefed(!this.getHideBriefed)    
    },
    toggleComplete(){
    this.setHideComplete(!this.getHideComplete)    
    },
    toggleDraft(){
    this.setHideDraft(!this.getHideDraft)    
    },
    togglePlanned(){
        this.setHidePlanned(!this.getHidePlanned)    
    },
    toggleInprogress(){
    this.setHideInprogress(!this.getHideInprogress)    
    },
    toggleOngoing(){
        this.setHideOngoing(!this.getHideOngoing)    
    },
    toggleOnhold(){
        this.setHideOnhold(!this.getHideOnhold)    
    },
    toggleOverdue(){
    //  this.setAdvancedFilter({id: 'overdue', name: 'Overdue', value: "overdue", filterCategoryId: 'overDueFilter', filterCategoryName: 'Action Overdue'}) 
    this.setHideOverdue(!this.getHideOverdue)    
    },
    log(e){
      // console.log(e)
    },
    handleClick(tab, event) {
        // console.log(tab, event);
    },
  sort: function (s) {
     //if s == current sort, reverse
      if (s === this.currentSort) {
        this.currentSortDir = this.currentSortDir === "asc" ? "desc" : "asc";
      }
      this.currentSort = s; 
    },
   sortI: function (s) {
      //if s == current sort, reverse
      if (s === this.currentSort) {
        this.currentSortDir = this.currentSortDir === "asc" ? "desc" : "asc";
      }
      this.currentSort = s;
    },
   sortCol1: function (s) {
     //if s == current sort, reverse
      if (s === this.currentSortCol1) {
        this.currentSortDir1 = this.currentSortDir1 === "asc" ? "desc" : "asc";
      }
      this.currentSortCol1 = s; 
      this.currentSort = "";
    },
   sortCol2: function (s) {
     //if s == current sort, reverse
      if (s === this.currentSortCol2) {
        this.currentSortDir2 = this.currentSortDir2 === "asc" ? "desc" : "asc";
      }
       this.currentSortCol2 = s; 
       this.currentSort = "";
    },
    nextPage:function() {
        if((this.currentPage*this.C_tasksPerPage.value) < this.filteredLessons.filtered.lessons) this.currentPage++;
      },
    prevPage:function() {
       if(this.currentPage > 1) this.currentPage--;
    },

     facilityGroupProgress(f_group) {
      let ids = _.map(this.filteredFacilities("active"), "id");
      let mean =
        _.meanBy(
          _.filter(
            f_group.facilities,
            (f) =>
              ids.includes(f.facilityId) &&
              f.projectId == this.currentProject.id
          ),
          "progress"
        ) || 0;
      return Number(mean.toFixed(0));
    },
  },
  mounted() {
    this.fetchProgramLessons(this.$route.params)  
  },
};
</script>

<style scoped></style>
