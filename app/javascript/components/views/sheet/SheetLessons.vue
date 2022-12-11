<template>
  <div v-if="contentLoaded" class="mt-1 ml-1">
    <div v-if="_isallowed('read')">
      <div class="d-flex align-item-center w-60 float-right filters-wrapper">
        <div class="ml-3 risk-search-bar w-100">
          <label data-v-076a3755="" class="font-sm mb-0"><span data-v-076a3755="" style="visibility: hidden;">|</span></label>
          <el-input type="search" placeholder="Search Lessons" v-model="search">
            <el-button slot="prepend" icon="el-icon-search"></el-button>
          </el-input>
        </div>
        <div class="ml-2">
          <label class="font-sm mb-0"><span style="visibility:hidden">|</span></label> 
          <span class="filterToggleWrapper mr-1 p-1" @click.prevent="toggleAdvancedFilter" v-tooltip="`Advanced Filters`">
            <i class="fas fa-sliders-h p-2"></i>      
          </span>    
        </div>
        <div class="mx-1 w-75">
          <label class="font-sm my-0">Process Area</label>
          <el-select
            v-model="C_taskTypeFilter"
            class="w-100"
            track-by="name"
            value-key="id"
            multiple
            clearable
            placeholder="Select Process Area"
            >
            <el-option
              v-for="item in taskTypes"
              :value="item"
              :key="item.id"
              :label="item.name"
              >
            </el-option>
          </el-select>
        </div>
      </div>
      <div class="wrapper mt-3 p-3">
        <div class="d-inline ">
          <span class="text-center">  
            <span class="d-inline">  
              <button
                v-if="_isallowed('write')"
                class="btn btn-md btn-primary addLessonBtn mr-5 float-left"
                @click="addLesson"
              >
                <font-awesome-icon icon="plus-circle" />
                Add Lesson
              </button>
              <span class="font-sm pr-2 hideLabels"> STATES TO DISPLAY </span>
              <span class="statesCol d-inline-block p-1 mr-2">
                <div class="pr-2 font-sm text-center d-inline-block icons" :class="[getHideComplete == true ? 'light':'']" @click.prevent="toggleComplete" >                              
                  <span class="d-block">
                    <i class="fas fa-clipboard-check" :class="[getHideComplete == true ? 'light':'text-success']"></i>
                  </span>      
                  <span class="smallerFont">COMPLETE</span>
                  <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{variation.completed.count}}</h6>  
                </div>              
                <div class="pr-2 font-sm text-center d-inline-block icons"  :class="[getHideDraft == true ? 'light':'']"  @click.prevent="toggleDraft" >                              
                  <span class="d-block">
                    <i class="fas fa-pencil-alt"  :class="[getHideDraft == true ? 'light':'text-warning']"></i>
                  </span>      
                  <span class="smallerFont">DRAFT</span>
                  <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.drafts.count }}</h6>
                </div>
              </span>
  
              <span class="pl-4 pr-2 font-sm hideLabels">FOCUS</span>
              <span class="tagCol d-inline-block p-1">
                <div class="pr-2 font-sm text-center d-inline-block icons" :class="[getHideImportant == true ? '':'light']" @click.prevent="toggleImportant">                              
                  <span class="d-block">
                    <i class="fas fa-star" :class="[getHideImportant == true ? 'text-warning':'light']"></i>
                  </span>      
                  <span class="smallerFont">IMPORTANT</span>
                  <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.important.count }}</h6>
                </div>
                <div class="pr-2 font-sm text-center d-inline-block icons" :class="[getHideBriefed == true ? '':'light']" @click.prevent="toggleBriefed">                              
                  <span class="d-block">
                    <i class="fas fa-presentation" :class="[getHideBriefed == true ? 'text-primary':'']"></i>
                  </span>      
                  <span class="smallerFont">BRIEFINGS</span>
                  <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.briefings.count }}</h6>
                </div>
              </span>            
            </span> 
          </span>     
        </div>
        <div class="d-inline-block ml-3">
          <!-- <v-app id="app"> -->
          <v-checkbox     
            v-model="C_showCountToggle"     
            class="d-inline-block"  
            @click.prevent="showCounts"   
            :label="`Show Counts`"
            ></v-checkbox>
          <!-- </v-app> -->
        </div>
        <div class="float-right">
          <button
            v-tooltip="`Export to PDF`"
            @click.prevent="exportToPdf"
            class="btn btn-md mr-1 exportBtns text-light"
          >
            <font-awesome-icon icon="file-pdf" />
          </button>
          <button
            v-tooltip="`Export to Excel`"
            @click.prevent="exportToExcel('table', 'Lessons Learned')"
            class="btn btn-md mr-1 exportBtns text-light"
          >
            <font-awesome-icon icon="file-excel" />
          </button>
          <button
            class="ml-2 btn btn-md btn-info total-table-btns"
            data-cy="lessons_total"
          >
            Total: {{ filteredLessons.filtered.lessons.length }}
          </button>
        </div>
        <!-- Lessons Learned Table -->
        <div style="margin-bottom:50px" data-cy="lessons_table">
          <table
            v-if="filteredLessons.filtered.lessons.length > 0"
            class="table table-sm table-bordered stickyTableHeader mb-3"
            id="lessonsPdf"
          >
            <colgroup>
            <col class="lessCol" />
            <col class="dateCol" />
            <col class="addedByCol" />
            <col class="descriptionCol" />
            <col class="flagsCol" />
            <col class="lastUpdateCol" />             
            </colgroup>      
            <tr class="thead" style="background-color:#ededed;">
              <th class="sort-th" @click="sort('title')" >Lesson
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'title'">
                  <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'title'">
                  <i class="fas fa-sort-up"></i></span>
                  <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'title'">
                  <i class="fas fa-sort-up"></i></span>
                  <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'title'">
                  <i class="fas fa-sort-down"></i></span>
                  <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'title'">
                  <i class="fas fa-sort-down"></i></span>
              </th>
              <th class="sort-th" @click="sort('date')" >Date Added
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'date'">
                  <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'date'">
                  <i class="fas fa-sort-up"></i></span>
                  <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'date'">
                  <i class="fas fa-sort-up"></i></span>
                  <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'date'">
                  <i class="fas fa-sort-down"></i></span>
                  <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'date'">
                  <i class="fas fa-sort-down"></i></span>
              </th>
              <th class="sort-th" @click="sort('added_by')" >Added By
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'added_by'">
                  <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'added_by'">
                  <i class="fas fa-sort-up"></i></span>
                  <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'added_by'">
                  <i class="fas fa-sort-up"></i></span>
                  <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'added_by'">
                  <i class="fas fa-sort-down"></i></span>
                  <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'added_by'">
                  <i class="fas fa-sort-down"></i></span>
              </th>
                <th class="sort-th" @click="sort('description')" >Description
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'description'">
                  <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'description'">
                  <i class="fas fa-sort-up"></i></span>
                  <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'description'">
                  <i class="fas fa-sort-up"></i></span>
                  <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'description'">
                  <i class="fas fa-sort-down"></i></span>
                  <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'description'">
                  <i class="fas fa-sort-down"></i></span>
              </th>
                <th class="sort-th">Flags
                
              </th>
                <th class="sort-th" @click="sort('notes_updated_at')" >Last Update
                <span class="inactive-sort-icon scroll" v-if="currentSort !== 'notes_updated_at'">
                  <i class="fas fa-sort"></i></span>
                <span class="sort-icon scroll" v-if="currentSortDir === 'asc' && currentSort === 'notes_updated_at'">
                  <i class="fas fa-sort-up"></i></span>
                  <span class="inactive-sort-icon scroll" v-if="currentSortDir !== 'asc' && currentSort === 'notes_updated_at'">
                  <i class="fas fa-sort-up"></i></span>
                  <span class="sort-icon scroll" v-if="currentSortDir ==='desc' && currentSort === 'notes_updated_at'">
                  <i class="fas fa-sort-down"></i></span>
                  <span class="inactive-sort-icon scroll" v-if="currentSortDir !=='desc' && currentSort === 'notes_updated_at'">
                  <i class="fas fa-sort-down"></i></span>
              </th>
            </tr>
            <tbody>
              <tr
                v-for="lesson in  sortedLessonTable"
                :key="lesson.id"
                @click="openLesson(lesson.id)"
                @mouseup.right="openContextMenu($event, lesson)"
                @contextmenu.prevent=""
              >
                <td>{{ lesson.title }}</td>
                <td class="text-center">{{ formatDate(new Date(lesson.date)) }}</td>
                <td class="text-center">{{ lesson.created_by.full_name }}</td>
                <td><span class="truncate-line-five">{{ lesson.description }}</span></td>
                <td class="text-center">
                  <span v-if="lesson.important == true" v-tooltip="`Important`">
                    <i class="fas fa-star text-warning mr-1"></i
                  ></span>
                  <span v-if="lesson.reportable" v-tooltip="`Briefings`"
                    ><i class="fas fa-presentation mr-1 text-primary"></i>
                  </span>
                  <span v-if="lesson.draft == true" v-tooltip="`Draft`"
                    > <i class="fas fa-pencil-alt text-warning"></i>
                  </span>
                  <span v-if="!lesson.draft" v-tooltip="`Complete`"
                    > <i class="fas fa-clipboard-check text-success"></i>
                  </span>
                  <span
                    v-if="
                      lesson.important == false &&
                        lesson.reportable == false &&
                        lesson.draft == false
                    "
                  >
                  
                  </span>
                </td>
                <td v-if="lesson.notes.length > 0">       
                  <span  class="toolTip" v-tooltip="('By: ' + lesson.last_update.user)" > 
                  {{ moment(lesson.last_update.created_at).format('DD MMM YYYY, h:mm a')}} <br>         
                  </span> 
                  <span class="truncate-line-five">
                    {{lesson.last_update.body}}
                  </span>         
                </td>  
                <td v-else >No Updates</td>      
              </tr>
            </tbody>
          </table>
          <div v-else class="text-danger font-lg mt-4">No Lessons found...</div>
        </div>
        <!-- Lessons Per Page Toggle -->
        <div
          v-if="filteredLessons.filtered.lessons.length > 0"
          class="text-right mb-4 mt-2 font-sm"
        >
          <div class="simple-select d-inline-block text-right font-sm">
            <span>Displaying </span>
            <el-select
              v-model="lessonsPerPage"
              class="w-33"
              track-by="value"
              value-key="id"
            >
              <el-option
                v-for="item in getLessonsPerPageFilterOptions"
                :value="item"
                :key="item.id"
                :label="item.name"
              >
              </el-option>
            </el-select>
          </div>
          <span class="mr-1 pr-3" style="border-right:solid 1px lightgray"
            >Per Page
          </span>
          <button class="btn btn-sm page-btns" @click="prevPage">
            <i class="fas fa-angle-left"></i>
          </button>
          <button class="btn btn-sm page-btns" id="page-count">
            {{ currentPage }} of
            {{ Math.ceil( this.filteredLessons.filtered.lessons.length / lessonsPerPage.value) }}
          </button>
          <button class="btn btn-sm page-btns" @click="nextPage">
            <i class="fas fa-angle-right"></i>
          </button>
        </div>
      </div>
    </div>
    <div v-else class="text-danger mx-2 mt-2">
      <h5> <i>Sorry, you don't have read-permissions for this tab! Please click on any available tab.</i></h5>
    </div>
    <table
        v-if="filteredLessons.filtered.lessons.length > 0"
        class="table table-sm table-bordered table-striped"
        ref="table" id="lessonsSheetsList1"
        style="display:none"
      >
      <thead>
        <tr style="background-color:#ededed">
          <th>Lesson</th>
          <th>Date Added</th>
          <th>Added By</th>
          <th>Description</th>
          <th style="width:50%">Flags</th>
          <th>Last Update</th>
        </tr>
      </thead>
      <tbody>
        <tr  v-for="lesson in filteredLessons.filtered.lessons" :key="lesson.id">
          <td>{{ lesson.title }}</td>
          <td>{{ formatDate(new Date(lesson.date)) }}</td>
          <td>{{ lesson.created_by.full_name }}</td>
          <td>{{ lesson.description }}</td>
          <td class="text-center" style="text-align:center">
            <span v-if="lesson.important == true">Important</span>
            <span v-if="lesson.reportable == true">Briefings</span>
            <span v-if="lesson.draft == true">Draft</span>
            <span v-if="!lesson.draft">Complete</span>
            <span v-if="
                  lesson.important == false &&
                  lesson.draft == false &&
                  lesson.reportable == false"
                  >
            </span>
          </td>
          <td v-if="lesson.notes.length > 0">
            <span v-tooltip="('By: ' + lesson.last_update.user.fullName)">
            {{ moment(lesson.last_update.createdAt).format('DD MMM YYYY, h:mm a')}} <br>
            </span>
            <span>
              {{lesson.last_update.body}}
            </span>
          </td>
          <td v-else >No Updates</td>
        </tr>
      </tbody>
    </table>
    <!-- The context-menu appears only if table row is right-clicked -->
    <LessonContextMenu
      :lesson="clickedLesson"
      :display="showContextMenu"
      routeName="SheetLessonForm"
      ref="menu"
    >
    </LessonContextMenu>
  </div>
</template>

<script>
import { mapActions, mapGetters, mapMutations } from "vuex";
import LessonContextMenu from "./../../shared/LessonContextMenu.vue";
import { jsPDF } from "jspdf";
import "jspdf-autotable";
import moment from "moment";
import { counter } from '@fortawesome/fontawesome-svg-core';
Vue.prototype.moment = moment;

export default {
  components: {
    LessonContextMenu,
  },
  data() {
    return {
      activeSortValue: "",
      sortAsc: false,
      currentSort:'text',
      currentSortDir:'asc',
      showContextMenu: false,
      clickedLesson: {},
      search: "",
      uri: "data:application/vnd.ms-excel;base64,",
      template:
        '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="https://www.w3.org/TR/2018/SPSD-html401-20180327/"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
      base64(s) {
        return window.btoa(unescape(encodeURIComponent(s)));
      },
      format(s, c) {
        return s.replace(/{(\w+)}/g, function(m, p) {
          return c[p];
        });
      },
    };
  },
  methods: {
    ...mapActions(["fetchProjectLessons"]),
    ...mapMutations([
      "setLessonsPerPageFilter",
      'setShowCount',
      'setTaskTypeFilter',
      'setCurrentLessonPage',
      'setShowAdvancedFilter',
      // 2 States
      'setHideComplete',
      'setHideDraft',
      // 2 Tags
      'setHideImportant',
      'setHideBriefed',      
      ]),
    addLesson() {
      this.$router.push(
        `/programs/${this.$route.params.programId}/sheet/projects/${this.$route.params.projectId}/lessons/new`
      );
    },
    sort:function(s) {
      //if s == current sort, reverse
      if(s === this.currentSort) {
        this.currentSortDir = this.currentSortDir==='asc'?'desc':'asc';
      }
        this.currentSort = s;
      },
    exportToPdf() {
      const doc = new jsPDF("l");
      const html = this.$refs.table.innerHTML;
      doc.autoTable({ html: "#lessonsSheetsList1" });
      doc.save("Lessons Learned.pdf");
    },
    exportToExcel(table, name) {
      if (!table.nodeType) table = this.$refs.table;
      var ctx = { worksheet: name || "Worksheet", table: table.innerHTML };
      var link = document.createElement('a');
      link.setAttribute('href', this.uri + this.base64(this.format(this.template, ctx)));
      link.setAttribute('download', 'Lessons Learned.xls');
      link.click();
    },
    log(e){
      // console.log("this is Lessons length: " + e)
    },
    openLesson(id) {
      this.$router.push({
        name: "SheetLessonForm",
        params: {
          programId: this.$route.params.programId,
          projectId: this.$route.params.projectId,
          lessonId: id,
        },
      });
    },
  
    // TODO: Work this logic into sortLessons
    nextPage() {
      if (
        this.currentPage * this.lessonsPerPage.value <
        this.filteredLessons.filtered.lessons.length
      )
        this.currentPage++;
    },
    prevPage() {
      if (this.currentPage > 1) this.currentPage--;
    },
    openContextMenu(e, lesson) {
      this.clickedLesson = lesson;
      e.preventDefault();
      this.$refs.menu.open(e);
    },
   _isallowed(salut) {
        return this.checkPrivileges("SheetLessons", salut, this.$route)

        // var programId = this.$route.params.programId;
        // var projectId = this.$route.params.projectId
        // let fPrivilege = this.$projectPrivileges[programId][projectId]
        // let permissionHash = {"write": "W", "read": "R", "delete": "D"}
        // let s = permissionHash[salut]
        // return  fPrivilege.lessons.includes(s);      
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
    toggleAdvancedFilter() {
        this.setShowAdvancedFilter(!this.getShowAdvancedFilter);
    },
    showCounts(){
      this.setShowCount(!this.getShowCount)       
    },
  },
  computed: {
    ...mapGetters([
      'contentLoaded',
      'lessonsLoaded',
      'projectLessons',
      'currentLessonPage',
      'getLessonsPerPageFilterOptions',
      'getLessonsPerPageFilter',
      'getShowCount',
      'getShowAdvancedFilter',
      'filterDataForAdvancedFilter',
      'taskTypeFilter',
      'taskTypes',
      // 2 States
      'getHideComplete',       
      'getHideDraft',   
      // 2 Tags      
      'getHideImportant',
      'getHideBriefed',
    ]),
    currentPage:{
       get() {
        return this.currentLessonPage
      },
      set(value) {
        this.setCurrentLessonPage(value);
      },
    },
    C_taskTypeFilter: {
      get() {
        return this.taskTypeFilter
      },
      set(value) {
        this.setTaskTypeFilter(value)
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
   filteredLessons() {
      // Returns filtered lessons based on search value from input
      let milestoneIds = _.map(this.C_taskTypeFilter, 'id')
      let valid = true
      let advancedFilterlessons = _.filter(this.projectLessons, (resource) => {
        valid = valid && this.filterDataForAdvancedFilter([resource], 'sheetLessons')
        if (milestoneIds.length > 0) valid = valid && milestoneIds.includes(resource.task_type_id)
        return valid
      })
      return {
      unfiltered: {
       lessons:  advancedFilterlessons
        .filter((lesson) => {
          if (this.search !== "") {
            return lesson.title.toLowerCase().match(this.search.toLowerCase());
          } else return true;
        })
      },
        filtered : {
          lessons: advancedFilterlessons.filter(lesson => {
        // Filtering 3 Lesson States        
        if (this.getHideDraft) {
          return !lesson.draft
        } else return true
      }).filter(lesson => {
          if (this.search !== "") {
            return lesson.title.toLowerCase().match(this.search.toLowerCase());
          } else return true;
      }).filter(lesson => {
         if (this.getHideComplete) {
          return lesson.draft
        } else return true
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
   sortedLessonTable:function() {
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
    let start = (this.currentPage-1)*this.lessonsPerPage.value;
    let end = this.currentPage*this.lessonsPerPage.value;
    if(index >= start && index < end) return true;
    return this.end
  });
  },
   variation() {
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

      };
    },
    lessonsPerPage: {
      get() {
        return this.getLessonsPerPageFilter || { id: 5, name: "5", value: 5 };
      },
      set(value) {
        this.setLessonsPerPageFilter(value);
      },
    },
 
  },
  mounted() {
    // GET request action to retrieve all lessons for project
    //  console.log(this.filteredLessons.filtered.lessons)
    this.fetchProjectLessons(this.$route.params);
  },
  // watch: {
  //   lessonsLoaded: {
  //     handler(loaded1, loaded2) {
  //       if (loaded1) {
  //         this.sortLessons("title");
  //       }
  //     },
  //   },
  // },
};
</script>

<style lang="scss" scoped>
.wrapper {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  border: 1px solid #dee2e6;
}
  table {
    table-layout: fixed;
    width: 100%;
    position: relative;
    margin-bottom: 0 !important;
  }
.table-head {
  background-color: #ededed;
  text-align: center;
  th {
    border: 1px solid #dee2e6;
  }
}
td {
  border: 1px solid #dee2e6;
  vertical-align: top;
}
.page-btns.active {
  background-color: rgba(211, 211, 211, 10%);
  border: none !important;
}
.addLessonBtn,
.exportBtns,
.showAll {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.exportBtns,
.showAll {
  transition: all 0.2s ease-in-out;
  background-color: #41b883;
}
#page-count {
  width: auto !important;
  cursor: default;
}
th {
  text-align: center;
  letter-spacing: 0.2em;
  padding: 10px;
  font-size: 0.7rem;
  color: #383838;
}
td {
  padding: 6px;
  font-size: 14px;
  color: #606266;
  overflow-wrap: break-word;
}
tr:hover {
  background-color: #cdecf5;
  cursor: pointer;
}
.w-70 {
  float: right;
  margin-top: -50px;
}
@media screen and (max-width: 1500px) {
  .w-70 {
    width: 65% !important;
  }
}
.date-col {
  width: 10%;
}
.added-by-col,
.flags-col {
  width: 10%;
}
.lesson-col {
  width: 20%;
}
.desc-col {
  width: 20%;
}
.last-update-col {
  width: 27.5%;
}
.sort-icon-arrow {
  color: #c0c4cc;
  transform: scale(1.2);
}
.top-arrow {
  position: relative;
  left: 7px;
}
.down-arrow {
  left: -2px;
  position: relative;
}
.sort-asc,
.sort-dsc {
  color: #17a2b8;
}

.tagCol {
  border-radius: 4px;
  background-color: #f8f9fa;
  border: .5px solid lightgray;
}
  
i, .icons {
  cursor: pointer;
  -webkit-touch-callout: none;
  -webkit-user-select: none;
  -khtml-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}
.statesCol {
  border-radius: 4px; 
  border: .5px solid lightgray;

}

.lessCol {
  width: 20%;
}
.dateCol{
  width: 10% ;
}
.addedByCol{
  width: 10% ;
}
.descriptionCol{
  width: 20%;
}
.flagsCol{
  width: 10%;
}
.lastUpdateCol  {
  width: 30%;
}
.hideLabels {
  font-weight: 600;
}
.smallerFont {
  font-size: 10px;
}
::v-deep.v-input__slot {
  display: inline;
  .v-label {
   font-family: 'FuturaPTBook';
  //  font-weight: 600;
   color: #007bff !important;
  }
}
  @media screen and (max-width: 1550px) {
  .hideLabels {
    display: none !important;
  }
}
.date-chip {
  background-color: #6c757d !important;
  font-size: 0.75rem;
  padding: 1px;
  color: #fff;
  border-radius: 3px;
  width: fit-content;
}
.truncate-line-five
{
  display: -webkit-box;
  -webkit-line-clamp: 5;
  -webkit-box-orient: vertical;  
  overflow: hidden;
  &:hover
  {
    display: -webkit-box;
    -webkit-line-clamp: unset;
    overflow: hidden;
  }
}
.filters-wrapper {
    float: right;
    margin-top: -80px;
}
@media screen and (max-width: 1500px) {
  .filters-wrapper {
      width: 65% !important;
  }
}

</style>
