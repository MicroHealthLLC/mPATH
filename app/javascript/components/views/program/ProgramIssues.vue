<template>
<div class="box-shadow py-2"  style="postion:relative" :load="log(filteredIssues.filtered.issues)">
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
            {{ issueVariation.completed.count }}
        </h5>
        </div>

        <div
        class="pr-4 text-center icons"
        :class="[getHideInprogress == true ? 'light' : '']"
        @click.prevent="toggleInprogress"
        >
        <span class="d-block">
            <i
            class="far fa-tasks"
            :class="[
                getHideInprogress == true ? 'light' : 'text-primary',
            ]"
            ></i>
        </span>
        <span class="smallerFont">IN PROGRESS</span>
        <h5
            :class="[
            getShowCount == false ? 'd-none' : 'd-block',
            ]"
        >
            {{ issueVariation.inProgress.count }}
        </h5>
        </div>

        <div
        class="pr-4 text-center icons"
        :class="[getHideOverdue == true ? 'light' : '']"
        @click.prevent="toggleOverdue"
        >
        <span class="d-block">
            <i
            class="fas fa-calendar"
            :class="[
                getHideOverdue == true ? 'light' : 'text-danger',
            ]"
            ></i>
        </span>
        <span class="smallerFont">OVERDUE </span>
        <h5
            :class="[
            getShowCount == false ? 'd-none' : 'd-block',
            ]"
        >
            {{ issueVariation.overdue.count }}
        </h5>
        </div>   
        <div
        class="pr-4 text-center icons"
        :class="[getHidePlanned == true ? 'light' : '']"
        @click.prevent="togglePlanned"
        >
        <span class="d-block">
            <i
            class="fas fa-calendar-check"
            :class="[
                getHidePlanned == true ? 'light' : 'text-info',
            ]"
            ></i>
        </span>
        <span class="smallerFont">PLANNED</span>
        <h5
            :class="[
            getShowCount == false ? 'd-none' : 'd-block',
            ]"
        >
            <span v-if="filteredIssues.filtered.issues">{{
            issueVariation.planned.count
            }}</span>
        </h5>
        </div>

        <div
        class="pr-4 text-center icons"
        :class="[getHideOnhold  == true ? 'light' : '']"
        @click.prevent="toggleOnhold"
        >
        <span class="d-block">
            <i
            class="fas fa-pause-circle"
            :class="[
                getHideOnhold  == true ? 'light' : 'text-primary',
            ]"
            ></i>
        </span>
        <span class="smallerFont">ON HOLD</span>
        <h5
            :class="[
            getShowCount == false ? 'd-none' : 'd-block',
            ]"
        >
            {{ issueVariation.onHold.count }}
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
            {{ issueVariation.issueDrafts.count }}
        </h5>
        </div>
    </span>

    <span class=""
        ><label class="font-sm mt-4 pr-2"><b>FOCUS</b></label>
    </span>
    <span class="tagsCol d-flex px-3 py-2">
        <div
        class="text-center icons"
        :class="[getHideWatched == true ? '' : 'light']"
        @click.prevent="toggleWatched"
        >
        <span class="d-block">
            <i class="fas fa-eye"></i>
        </span>
        <span class="smallerFont">ON WATCH</span>
        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="watched" v-model="C_hideWatchedTasks">               -->
        <h5
            :class="[
            getShowCount == false ? 'd-none' : 'd-block',
            ]"
        >
            {{ issueVariation.watched.count }}
        </h5>
        </div>
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
            {{ issueVariation.important.count }}
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
            {{ issueVariation.briefings.count }}
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
        RESULTS: {{ filteredIssues.filtered.issues.length }}
    </button></span
    >
</div>
</div>

<div
class="row text-center mt-2 pr-3"
style="postion:relative" 
v-if="filteredIssues.filtered.issues.length > 0"
>
<div class="px-3 tableFixHead" >
    <table
    class="table table-sm table-bordered"
    ref="table"
    id="portTasks"                   
    >
    <thead style="background-color: #ededed">    
        <th class="pl-1 sort-th twenty" @click="sortCol1('projectGroup')">
        Project Group
        <span
            class="inactive-sort-icon scroll"
            v-if="currentSortCol1 !== 'projectGroup'"
        >
            <i class="fas fa-sort"></i
        ></span>
        <span
            class="sort-icon main scroll"
            v-if="
            currentSortDir1 === 'asc' && currentSortCol1 === 'projectGroup'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir1 !== 'asc' && currentSortCol1 === 'projectGroup'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="sort-icon main scroll"
            v-if="
            currentSortDir1 === 'desc' && currentSortCol1 === 'projectGroup'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir1 !== 'desc' && currentSortCol1 === 'projectGroup'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        </th> 
        <th class="pl-1 sort-th twenty" @click="sortCol2('facilityName')">
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
            currentSortDir2 === 'asc' && currentSortCol2 === 'facilityName'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir2 !== 'asc' && currentSortCol2 === 'facilityName'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="sort-icon main scroll"
            v-if="
            currentSortDir2 === 'desc' && currentSortCol2 === 'facilityName'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir2 !== 'desc' && currentSortCol2 === 'facilityName'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        </th>                 
        <th class="pl-1 sort-th twenty" @click="sort('text')">
        Issue
        <span
            class="inactive-sort-icon scroll"
            v-if="currentSort !== 'text'"
        >
            <i class="fas fa-sort"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'asc' && currentSort === 'text'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'asc' && currentSort === 'text'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'desc' && currentSort === 'text'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'desc' && currentSort === 'text'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        </th>

        <th
        class="sort-th twenty"
        @click="sort('notesUpdatedAt')"
        style="min-width: 300px"
        >
        Last Update
        <span
            class="inactive-sort-icon scroll"
            v-if="currentSort !== 'notesUpdatedAt'"
        >
            <i class="fas fa-sort"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'asc' &&
            currentSort === 'notesUpdatedAt'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'asc' &&
            currentSort === 'notesUpdatedAt'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'desc' &&
            currentSort === 'notesUpdatedAt'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'desc' &&
            currentSort === 'notesUpdatedAt'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        </th>

        <th
        class="sort-th"
        style="min-width: 140px"
        @click="sort('startDate')"
        >
        Start Date
        <span
            class="inactive-sort-icon scroll"
            v-if="currentSort !== 'startDate'"
        >
            <i class="fas fa-sort"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'asc' &&
            currentSort === 'startDate'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'asc' &&
            currentSort === 'startDate'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'desc' &&
            currentSort === 'startDate'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'desc' &&
            currentSort === 'startDate'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        </th>
        <th
        class="sort-th"
        style="min-width: 140px"
        @click="sort('dueDate')"
        >
        Due Date
        <span
            class="inactive-sort-icon scroll"
            v-if="currentSort !== 'dueDate'"
        >
            <i class="fas fa-sort"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'asc' &&
            currentSort === 'dueDate'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'asc' &&
            currentSort === 'dueDate'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'desc' &&
            currentSort === 'dueDate'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'desc' &&
            currentSort === 'dueDate'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        </th>
        <th class="sort-th p-1">
        <span class="py-2 d-inline-block">Assigned Users</span>
        </th>
        <th
        class="sort-th"
        style="min-width: 115px"
        @click="sort('progress')"
        >
        Progress
        <span
            class="inactive-sort-icon scroll"
            v-if="currentSort !== 'progress'"
        >
            <i class="fas fa-sort"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'asc' &&
            currentSort === 'progress'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'asc' &&
            currentSort === 'progress'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'desc' &&
            currentSort === 'progress'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'desc' &&
            currentSort === 'progress'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        </th>
        <th class="non-sort-th" style="min-width: 145px">
        Flags
        </th>
        <th class="pl-1 sort-th twenty" @click="sort('taskTypeName')">
        Process Area
        <span
            class="inactive-sort-icon scroll"
            v-if="currentSort !== 'taskTypeName'"
        >
            <i class="fas fa-sort"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'asc' &&
            currentSort === 'taskTypeName'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'asc' &&
            currentSort === 'taskTypeName'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'desc' &&
            currentSort === 'taskTypeName'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'desc' &&
            currentSort === 'taskTypeName'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        </th>
    </thead>
    <tbody>
        <tr v-for="(issue, index) in sortedIssues" :key="index" class="portTable taskHover" >
    
    
        <td>{{ issue.projectGroup }}</td>
        <td>{{ issue.facilityName }}</td>
        <td>{{ issue.title }}</td>
        <td
            class="text-left"
            v-if="issue.notesUpdatedAt.length > 0"
        >
            <span
            class="toolTip"
            v-tooltip="
                'By: ' +
                issue.notes[issue.notes.length - 1].user.fullName
            "
            >
            {{
                moment(issue.notesUpdatedAt[0]).format(
                "DD MMM YYYY, h:mm a"
                )
            }}
            </span>
            <br />
            <span class="truncate-line-five">
            {{ issue.notes[issue.notes.length - 1].body }}
            </span>
        </td>
        <!-- <td v-else class="twentyTwo">No Updates</td> -->
        <td class="text-left" v-else>No Update</td>

        <td>
           
            
            {{ moment(issue.startDate).format("DD MMM YYYY") }}

        </td>
        <td>
           
            <span v-if="issue.completed && (issue.dueDate == null || issue.dueDate == undefined)"></span>
            <span
            v-else-if="issue.onHold && issue.dueDate == null"
            v-tooltip="`On Hold (w/no Due Date)`"
            ><i class="fas fa-pause-circle text-primary"></i
            ></span>
            <span v-else>{{
            moment(issue.dueDate).format("DD MMM YYYY")
            }}</span>
        </td>
        <td>{{ issue.userNames }}</td>
        <td>                          
           
        
            {{ issue.progress + "%" }}
          
        </td>
        <td class="text-center">
            <span v-if="issue.isOverdue" v-tooltip="`Overdue`">
            <i class="fas fa-calendar text-danger mr-1"></i
            ></span>
            <span v-if="issue.completed" v-tooltip="`Completed`"
            ><i
                class="fas fa-clipboard-check text-success mr-1"
            ></i
            ></span>
           
           
            <span
            v-if="issue.onHold == true"
            v-tooltip="`On Hold`"
            >
            <i class="fas fa-pause-circle mr-1 text-primary"></i
            ></span>
            <span v-if="issue.draft == true" v-tooltip="`Draft`">
            <i class="fas fa-pencil-alt mr-1 text-warning"></i
            ></span>
            <span
            v-if="issue.watched == true"
            v-tooltip="`On Watch`"
            ><i class="fas fa-eye mr-1"></i
            ></span>
            <span
            v-if="issue.important == true"
            v-tooltip="`Important`"
            >
            <i class="fas fa-star text-warning mr-1"></i
            ></span>
            <span v-if="issue.reportable" v-tooltip="`Briefings`">
            <i class="fas fa-presentation mr-1 text-primary"></i
            ></span>
            <span v-if="issue.planned" v-tooltip="`Planned`">
            <i class="fas fa-calendar-check text-info mr-1"></i
            ></span>
            <span
            v-if="issue.inProgress"
            v-tooltip="`In Progress`"
            >
            <i class="far fa-tasks text-primary mr-1"></i
            ></span>

        </td>
        <td>{{ issue.taskTypeName }}</td>
        </tr>
    </tbody>
    </table>

</div>
<div class="ml-auto mb-4 mt-2 font-sm">
    <div class="simple-select d-inline-block text-right font-sm">
    <span class="mr-1">Displaying </span>
    <el-select
      v-model="C_issuesPerPage"
      class="w-33"
      track-by="value"
      value-key="id"
      >
      <el-option
      v-for="item in getIssuesPerPageOptions"
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
        filteredIssues.filtered.issues.length / this.C_issuesPerPage.value
        )
    }}
    </button>
    <button class="btn btn-sm page-btns" @click="nextPage">
    <i class="fas fa-angle-right"></i>
    </button>
</div>
</div>
<!-- <div v-else-if="!portfolioTasksLoaded" class="load-spinner spinner-bordeC_issuesPerPager"></div> -->
<div v-else class="mt-5">NO RESULTS TO DISPLAY

    
</div>
</div>
</template>

<script>

import {mapGetters, mapMutations, mapActions} from 'vuex'
// import LessonForm from "./../../dashboard/lessons/LessonForm";

export default {
  name: "ProgramIssues",
  data() {
    return {
      showLess: "Show More",
      showMore: true,
      today: new Date().toISOString().slice(0, 10),
      currentSort: "title",  
      currentSortCol1: "projectGroup",
      currentSortCol2: "facilityName",
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
    'currIssuePage',
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
    "filteredAllRisks",
    "filteredAllTasks",
    "filteredFacilities",
    "filteredFacilityGroups",
    "getAllFilterNames",
    "getFilterValue",
    "getTaskIssueUserFilter",
    "getIssuesPerPage",
    'getIssuesPerPageOptions',
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
    'getTasksPerPage',
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
    projectObj() {
    return this.currentProject.facilities
    },
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
    C_issuesPerPage: {
        get() {
          return this.getIssuesPerPage || {id: 15, name: '15', value: 15}
        },
        set(value) {
          this.setIssuesPerPageFilter(value)
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
    C_taskTypeFilter: {
      get() {
        return this.taskTypeFilter;
      },
      set(value) {
        this.setTaskTypeFilter(value);
      },
    },
    C_myTasks: {
      get() {
        return _.map(this.myActionsFilter, "value").includes("tasks");
      },
    },
    C_myIssues: {
      get() {
        return _.map(this.myActionsFilter, "value").includes("issues");
      },
    },
    C_onWatchTasks: {
      get() {
        return _.map(this.onWatchFilter, "value").includes("tasks");
      },
    },
    C_onWatchIssues: {
      get() {
        return _.map(this.onWatchFilter, "value").includes("issues");
      },
    },
 currentPage:{
       get() {
        return this.currIssuePage
      },
      set(value) {
        this.setCurrIssuePage(value);
      },
    },

    C_facilityCount() {         
      return this.facilityGroup
      
        ? this.facilityGroupFacilities(this.facilityGroup).length
        : this.facilityCount; 
      
    },
    C_facilityProgress() {
      return this.facilityGroup
        ? Number(
            _.meanBy(
              this.facilityGroupFacilities(this.facilityGroup),
              "progress"
            ) || 0
          ).toFixed(0)
        : this.facilityProgress;
    },
    isMapView() {
      return this.$route.name.includes("Map");
    },
    isSheetsView() {
      return this.$route.name.includes("Sheet");
    },
    ProgramView() {
     return `/programs/${this.$route.params.programId}/dataviewer`
    },
    filteredIssues() {
      let typeIds = _.map(this.issueTypeFilter, "id");
      let stageIds = _.map(this.issueStageFilter, "id");
      let severityIds = _.map(this.issueSeverityFilter, "id");
      let issues = this.facilityGroup
        ? _.flatten(
            _.map(this.facilityGroupFacilities(this.facilityGroup), "issues")
          )
        : this.filteredAllIssues;

      let taskIssueUsers = this.getTaskIssueUserFilter;
       _.filter(issues, (resource) => {
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
          this.filterDataForAdvancedFilter([resource], "facilityRollupIssues");
        if (typeIds.length > 0)
          valid = valid && typeIds.includes(resource.issueTypeId);
        if (severityIds.length > 0)
          valid = valid && severityIds.includes(resource.issueSeverityId);
        if (stageIds.length > 0)
          valid = valid && stageIds.includes(resource.issueStageId);
        return valid;
      });
        return {
       unfiltered: {
            issues
            },
       filtered: {
         issues:  issues.filter(t => {
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
    sortedIssues:function() {
        return this.filteredIssues.filtered.issues.sort((a,b) => {
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
           let start = (this.currentPage-1)*this.C_issuesPerPage.value;
          let end = this.currentPage*this.C_issuesPerPage.value;
          if(index >= start && index < end) return true;
          return this.end
        });
    },
    issueTaskCATEGORIES() {
      let issues = new Array();
      let group = _.groupBy(this.filteredIssues, "taskTypeName");
      for (let type in group) {
        if (!type || type == "null") continue;
        issues.push({
          name: type,
          count: group[type].length,
          progress: Number((_.meanBy(group[type], "progress") || 0).toFixed(0)),
        });
      }
      return issues;
    },
     
    activeFacilitiesByStatus() {
      return this.facilityGroup
        ? this.facilityGroupFacilities(this.facilityGroup).length
        : this.filteredFacilities("active").length;
    },
    inactiveFacilitiesByStatus() {
      return this.facilityGroup
        ? this.facilityGroupFacilities(this.facilityGroup, "inactive").length
        : this.filteredFacilities("inactive").length;
    },
    projectStatuses() {
      let statuses = [];

      if (this.contentLoaded && this.facilities.length > 0) {
        this.statuses.forEach((status) => {
          // Find number of facilities with current status
          let count = this.facilities
            .filter((facility) => facility.projectStatus === status.name)
            .reduce((total) => total + 1, 0);
          // Insert status into projectStatuses for use Project Status card
          statuses.push({
            name: status.name,
            color: status.color,
            length: count,
            progress: Math.floor((count / this.facilities.length) * 100),
          });
        });
      }

      return statuses;
    },
    currentTaskTypes() {
      let names =
        this.taskTypeFilter &&
        this.taskTypeFilter.length &&
        _.map(this.taskTypeFilter, "name");
      let taskTypes = new Array();
      for (let type of this.taskTypes) {
        let tasks = _.filter(
          this.filteredIssues,
          (t) => t.taskTypeId == type.id
        );
        taskTypes.push({
          name: type.name,
          _display:
            tasks.length > 0 && (names ? names.includes(type.name) : true),
          length: tasks.length,
          progress: Number(_.meanBy(tasks, "progress").toFixed(0)),
        });
      }
      return taskTypes;
    },
    currentIssueTypes() {
      let names =
        this.issueTypeFilter &&
        this.issueTypeFilter.length &&
        _.map(this.issueTypeFilter, "name");
      let issueTypes = new Array();
      for (let type of this.issueTypes) {
        let issues = _.filter(
          this.filteredIssues,
          (t) => t.issueTypeId == type.id
        );
        issueTypes.push({
          name: type.name,
          _display:
            (names ? names.includes(type.name) : true) && issues.length > 0,
          length: issues.length,
          progress: Number(_.meanBy(issues, "progress").toFixed(0)),
        });
      }
      return issueTypes;
    },
  
     issueVariation() {
     let planned = _.filter(
        this.filteredIssues.unfiltered.issues,
        (t) => t && t.planned == true    
      );     
      let issueDrafts = _.filter(
        this.filteredIssues.unfiltered.issues,
         (t) => t && t.draft == true 
      );  
      let important = _.filter(
      this.filteredIssues.unfiltered.issues,
          (t) => t && t.important
      );
      let briefings = _.filter(
      this.filteredIssues.unfiltered.issues,
          (t) => t && t.reportable
      ); 
      let watched = _.filter(
      this.filteredIssues.unfiltered.issues,
          (t) => t && t.watched 
      );        
      let completed = _.filter(
        this.filteredIssues.unfiltered.issues,
        (t) => t && t.completed == true
      );
      let completed_percent = this.getAverage(
        completed.length,
        this.filteredIssues.unfiltered.issues.length
      ); 
       let inProgress = _.filter(
        this.filteredIssues.unfiltered.issues,
        (t) => t && t.inProgress == true 
        );
      let onHold = _.filter(
        this.filteredIssues.unfiltered.issues,
        (t) => t && t.onHold == true 
      );
      let inProgress_percent = this.getAverage(
        inProgress.length,
        this.filteredIssues.unfiltered.issues.length
      );
      let overdue = _.filter(this.filteredIssues.unfiltered.issues, (t) => t && t.isOverdue);
      let overdue_percent = this.getAverage(
        overdue.length,
        this.filteredIssues.unfiltered.issues.length
      );
      return {
        planned: {
          count: planned.length,          
        },
        onHold: {
          count: onHold.length,          
        },
        issueDrafts: {
          count: issueDrafts.length,          
        },
        watched: {
          count: watched.length,          
        },
       important: {
          count: important.length,             
        },
        completed: {
          count: completed.length,
          percentage: Math.round(completed_percent),
        },
        briefings: {
          count: briefings.length,          
        },
        completed: {
          count: completed.length,
          percentage: Math.round(completed_percent),
        },
        inProgress: {
          count: inProgress.length,
          percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          percentage: Math.round(overdue_percent),
        },
      };
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
        'setCurrIssuePage',
        'setOnWatchFilter',
        'setToggleRACI',
        'setShowAdvancedFilter',
        'setTaskForManager',
        'setShowCount',
          // Used in Program Viewer
        'setIssuesPerPageFilter',
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
    //     if(this.tasksObj.filtered.issues && this.tasksObj.filtered.issues.length < 1){
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
   nextPage:function() {
      if((this.currentPage*this.C_issuesPerPage.value) < this.filteredIssues.filtered.issues.length) this.currentPage++;
    },
    prevPage:function() {
      if(this.currentPage > 1) this.currentPage--;
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
