<template>
<div class="box-shadow py-2"  style="postion:relative" :load="log(programLessons)">
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
        <!-- <button
        v-tooltip="`Presentation Mode`"
        @click.prevent="openTpresentation"
        class="btn btn-md presentBtn mr-1 mh-blue text-light"
    >
        <i class="fas fa-presentation"></i>
    </button> -->
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
        <tr v-for="(lesson, index) in sortedLessons" :key="index" class="portTable taskHover" @click="openTask(task)">
     
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
      currentSortCol1: "project_group",
      currentSortCol2: "project_name",
      // currentSortIssueRisk: "title",
      currentSortDir: "asc",
      currentSortDir1: "asc",
      currentSortDir2: "asc",
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
    "facilities",
    "facilityCount",
    "facilityGroupFacilities",
    "facilityProgress",
    "filterDataForAdvancedFilter",
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
      // Returns filtered lessons based on search value from input

      let milestoneIds = _.map(this.C_taskTypeFilter, 'id')
      return {
      unfiltered: {
      
       lessons:  this.programLessons
        // .filter((lesson) =>
        //   lesson.title.toLowerCase().match(this.search.toLowerCase())
        // )
        .filter(lesson => {
        if(milestoneIds.length > 0) {
          return milestoneIds.includes(lesson.task_type_id)
        } else return true;
        })
      },
        filtered : {
          lessons: this.programLessons.filter(lesson => {
        // Filtering 3 Lesson States        
        if (this.getHideDraft) {
          return !lesson.draft
        } else return true
  
      }).filter(lesson => {
         if (this.getHideComplete) {
          return lesson.draft
        } else return true
      }).filter(lesson => {
        if(milestoneIds.length > 0) {
          return milestoneIds.includes(lesson.task_type_id)
        } else return true;
      // Filtering 3 Task Tags
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
          handleClick(tab, event) {
            console.log(tab);
    //   let tab_id = $(event.target).attr("id")
    //   if(tab_id == "tab-tasks" || tab.name == 'tasks'){
    //     this.currentTab = 'tasks'
    //     if(this.tasksObj.filtered.tasks && this.tasksObj.filtered.tasks.length < 1){
    //       this.fetchPortfolioTasks();
    //     }
        
    //   }else if(tab_id == "tab-issues"  || tab.name == 'issues'){
    //     this.currentTab = 'issues'
    //     if(this.issuesObj.filtered.issues && this.issuesObj.filtered.issues.length < 1){
    //       this.fetchPortfolioIssues();  
    //     }
    //   }else if(tab_id == "tab-risks"  || tab.name == 'risks'){
    //     this.currentTab = 'risks'
    //     if(this.risksObj.filtered.risks && this.risksObj.filtered.risks.length < 1){
    //       this.fetchPortfolioRisks();
    //     }
        
    //   }else if(tab_id == "tab-lessons"  || tab.name == 'lessons'){
    //     this.currentTab = 'lessons'
    //     if(this.lessonsObj.filtered.lessons && this.lessonsObj.filtered.lessons.length < 1){
    //       this.fetchPortfolioLessons();
    //     }
    //   } 
    
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
        if((this.currentPage*this.C_tasksPerPage.value) < this.filteredTasks.filtered.tasks.length) this.currentPage++;
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
