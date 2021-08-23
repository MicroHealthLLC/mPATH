<template>
  <div v-if="contentLoaded">
    <div class="d-flex align-item-center w-70 float-right filters-wrapper">
      <div class="ml-3 risk-search-bar w-100">
        <label data-v-076a3755="" class="font-sm mb-0"><span data-v-076a3755="" style="visibility: hidden;">|</span></label>
        <el-input type="search" placeholder="Search Lessons" v-model="search">
          <el-button slot="prepend" icon="el-icon-search"></el-button>
        </el-input>
      </div>
      <div class="mx-1 w-75">
        <label class="font-sm my-0">Process Area</label>
        <el-select
          v-model="C_taskTypeFilter"
          class="w-100"
          track-by="name"
          value-key="id"
          multiple
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
  
            <span class="pl-4 pr-2 font-sm hideLabels">TAG FOCUS</span>
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
          class="mb-3 w-100"
          id="lessonsPdf"
          ref="table"
        >
          <tr class="table-head">
            <th class="lesson-col" @click="sortLessons('title')">
              Lesson
              <span class="float-right"
                ><div class="d-flex d-inline-flex">
                  <div class="top-arrow">
                     <i class="fas fa-sort-up sort-icon-arrow"
                       :class="{                    
                        'sort-asc': sortAsc && activeSortValue == 'title',
                      }"
                    ></i>
                  </div>
                  <div class="down-arrow">
                      <i class="fas fa-sort-down sort-icon-arrow"
                       :class="{
                        'sort-dsc': !sortAsc && activeSortValue == 'title',
                      }"
                    ></i>
                  </div></div
              ></span>
            </th>
            <th class="date-col" @click="sortLessonsByDate">
              Date
              <span class="float-right"
                ><div class="d-flex d-inline-flex">
                  <div class="top-arrow">
                     <i class="fas fa-sort-up sort-icon-arrow"
                       :class="{
                        'sort-asc': sortAsc && activeSortValue == 'date',
                      }"
                     ></i>
                   </div>
                  <div class="down-arrow">
                    <i class="fas fa-sort-down sort-icon-arrow"
                         :class="{
                        'sort-dsc': !sortAsc && activeSortValue == 'date',
                      }"
                    ></i>
                  
                  </div></div
              ></span>
            </th>
            <th
              class="added-by-col"
              @click="sortLessonsNested('created_by', 'full_name')"
            >
              Added By
              <span class="float-right"
                ><div class="d-flex d-inline-flex">
                  <div class="top-arrow">
                     <i class="fas fa-sort-up sort-icon-arrow"                
                      :class="{
                        'sort-asc': sortAsc && activeSortValue == 'created_by',
                      }"
                    ></i>
                  </div>
                  <div class="down-arrow">
                    <i class="fas fa-sort-down sort-icon-arrow"
                       :class="{
                        'sort-dsc': !sortAsc && activeSortValue == 'created_by',
                      }"
                    ></i>
                  </div></div
              ></span>
            </th>
            <th class="desc-col">
              Description
            </th>
            <th class="flags-col">
              Flags
            </th>
            <th class="update-col" @click="sortUpdates">
              Last Update
              <span class="float-right"
                ><div class="d-flex d-inline-flex">
                  <div class="top-arrow">
                     <i class="fas fa-sort-up sort-icon-arrow"
                       :class="{
                        'sort-asc': sortAsc && activeSortValue == 'updates',
                      }"
                    ></i>
                  </div>
                  <div class="down-arrow">
                   <i class="fas fa-sort-down sort-icon-arrow"
                       :class="{
                        'sort-dsc': !sortAsc && activeSortValue == 'updates',
                      }"
                    ></i>
                  </div></div
              ></span>
            </th>
          </tr>
          <tr
            v-for="lesson in filteredLessons.filtered.lessons"
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
               <span v-if="lesson.draft == false" v-tooltip="`Complete`"
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
            <td>
              <span v-if="lesson.last_update.body"
                ><div
                  class="date-chip"
                  v-tooltip="'By: ' + lesson.last_update.user"
                >
                  {{
                    moment(lesson.last_update.created_at).format(
                      "DD MMM YYYY, h:mm a"
                    )
                  }}
                </div>
                <span class="truncate-line-five">
                  {{ lesson.last_update.body }}
                </span>
              </span>
              <span v-else>No Updates</span>
            </td>
          </tr>
        </table>

        <div v-else class="text-danger font-lg mt-4">No Lessons found...</div>

        <!-- Lessons Per Page Toggle -->
        <div
          v-if="filteredLessons.filtered.lessons.length > 0"
          class="float-right mb-4 mt-2 font-sm"
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
            {{ Math.ceil(projectLessons.length / lessonsPerPage.value) }}
          </button>
          <button class="btn btn-sm page-btns" @click="nextPage">
            <i class="fas fa-angle-right"></i>
          </button>
        </div>
      </div>
    </div>
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
import LessonContextMenu from "./../../shared/LessonContextMenu";
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
      showContextMenu: false,
      currentPage: 1,
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
    exportToPdf() {
      const doc = new jsPDF("l");
      const html = this.$refs.table.innerHTML;
      doc.autoTable({ html: "#lessonsPdf" });
      doc.save("Lessons Learned.pdf");
    },
    exportToExcel(table, name) {
      if (!table.nodeType) table = this.$refs.table;
      var ctx = { worksheet: name || "Worksheet", table: table.innerHTML };
      window.location.href =
        this.uri + this.base64(this.format(this.template, ctx));
    },
    // log(e){
    //   console.log("this is Lessons obj: " + e)
    // },
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
    sortLessons(value) {
      // Determine whether to sort lessons ascending or descending
      if (this.activeSortValue !== value || !this.sortAsc) {
        this.sortAsc = true;
      } else {
        this.sortAsc = false;
      }
      // Sort ascending
      if (this.sortAsc) {
        this.projectLessons.sort((lesson1, lesson2) => {
          if (lesson1[value].toUpperCase() < lesson2[value].toUpperCase()) {
            return -1;
          } else if (
            lesson1[value].toUpperCase() > lesson2[value].toUpperCase()
          ) {
            return 1;
          } else {
            return 0;
          }
        });
        // Sort descending
      } else {
        this.projectLessons.sort((lesson1, lesson2) => {
          if (lesson1[value].toUpperCase() < lesson2[value].toUpperCase()) {
            return 1;
          } else if (
            lesson1[value].toUpperCase() > lesson2[value].toUpperCase()
          ) {
            return -1;
          } else {
            return 0;
          }
        });
      }
      // Store active sort value
      this.activeSortValue = value;
    },
    // TODO: Work this logic into sortLessons
    sortLessonsNested(value1, value2) {
      // Determine whether to sort lessons ascending or descending
      if (this.activeSortValue !== value1 || !this.sortAsc) {
        this.sortAsc = true;
      } else {
        this.sortAsc = false;
      }
      // Sort ascending
      if (this.sortAsc) {
        this.projectLessons.sort((lesson1, lesson2) => {
          if (
            lesson1[value1][value2]?.toUpperCase() <
            lesson2[value1][value2]?.toUpperCase()
          ) {
            return -1;
          } else if (
            lesson1[value1][value2]?.toUpperCase() >
            lesson2[value1][value2]?.toUpperCase()
          ) {
            return 1;
          } else {
            return 0;
          }
        });
        // Sort descending
      } else {
        this.projectLessons.sort((lesson1, lesson2) => {
          if (
            lesson1[value1][value2]?.toUpperCase() <
            lesson2[value1][value2]?.toUpperCase()
          ) {
            return 1;
          } else if (
            lesson1[value1][value2]?.toUpperCase() >
            lesson2[value1][value2]?.toUpperCase()
          ) {
            return -1;
          } else {
            return 0;
          }
        });
      }
      // Store active sort value
      this.activeSortValue = value1;
    },
    nextPage() {
      if (
        this.currentPage * this.lessonsPerPage.value <
        this.projectLessons.length
      )
        this.currentPage++;
    },
    prevPage() {
      if (this.currentPage > 1) this.currentPage--;
    },
    sortLessonsByDate() {
      // Determine whether to sort lessons ascending or descending
      if (this.activeSortValue !== "date" || !this.sortAsc) {
        this.sortAsc = true;
      } else {
        this.sortAsc = false;
      }
      // Sort ascending
      if (this.sortAsc) {
        this.projectLessons.sort(
          (lesson1, lesson2) => new Date(lesson2.date) - new Date(lesson1.date)
        );
        // Sort descending
      } else {
        this.projectLessons.sort(
          (lesson1, lesson2) => new Date(lesson1.date) - new Date(lesson2.date)
        );
      }
      // Store active sort value
      this.activeSortValue = "date";
    },
    sortUpdates() {
      // Determine whether to sort lessons ascending or descending
      if (this.activeSortValue !== "updates" || !this.sortAsc) {
        this.sortAsc = true;
      } else {
        this.sortAsc = false;
      }
      // Is used to replace empty values
      let oldDate = new Date("12-31-1980");
      // Sort ascending
      if (this.sortAsc) {
        this.projectLessons.sort((lesson1, lesson2) => {
          if (!lesson1.notes_updated_at[0]) {
            lesson1.notes_updated_at = oldDate;
          }
          if (!lesson2.notes_updated_at[0]) {
            lesson2.notes_updated_at = oldDate;
          }

          return (
            new Date(lesson2.notes_updated_at) -
            new Date(lesson1.notes_updated_at)
          );
        });
        // Sort descending
      } else {
        this.projectLessons.sort((lesson1, lesson2) => {
          if (!lesson1.notes_updated_at[0]) {
            lesson1.notes_updated_at = oldDate;
          }
          if (!lesson2.notes_updated_at[0]) {
            lesson2.notes_updated_at = oldDate;
          }

          return (
            new Date(lesson1.notes_updated_at) -
            new Date(lesson2.notes_updated_at)
          );
        });
      }
      // Store active sort value
      this.activeSortValue = "updates";
    },
    openContextMenu(e, lesson) {
      this.clickedLesson = lesson;
      e.preventDefault();
      this.$refs.menu.open(e);
    },
   _isallowed(salut) {
        var programId = this.$route.params.programId;
        var projectId = this.$route.params.projectId
        let fPrivilege = this.$projectPrivileges[programId][projectId]
        let permissionHash = {"write": "W", "read": "R", "delete": "D"}
        let s = permissionHash[salut]
        return  fPrivilege.lessons.includes(s);      
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
    showCounts(){
      this.setShowCount(!this.getShowCount)       
    },
    // _isallowed(privilege) {
    //   return (
    //     
    //     this.$permissions.lessons[privilege]
    //   );
    // },
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "lessonsLoaded",
      "projectLessons",
      "getLessonsPerPageFilterOptions",
      "getLessonsPerPageFilter",
      'getShowCount',
      'taskTypeFilter',
      'taskTypes',
      // 2 States
      'getHideComplete',       
      'getHideDraft',   
      // 2 Tags      
      'getHideImportant',
      'getHideBriefed',
    ]),
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
      return {
      unfiltered: {
       lessons:  this.projectLessons
        .filter((lesson) =>
          lesson.title.toLowerCase().match(this.search.toLowerCase())
        )
        .filter(lesson => {
        if(milestoneIds.length > 0) {
          return milestoneIds.includes(lesson.task_type_id)
        } else return true;
        }).filter((lesson, index) => {
          let start = (this.currentPage - 1) * this.lessonsPerPage.value;
          let end = this.currentPage * this.lessonsPerPage.value;
          if (index >= start && index < end) return true;
          return this.end;
        }) 
          },
        filtered : {
          lessons: this.projectLessons.filter(lesson => {
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
    this.fetchProjectLessons(this.$route.params);
  },
  watch: {
    lessonsLoaded: {
      handler(loaded1, loaded2) {
        if (loaded1) {
          this.sortLessons("title");
        }
      },
    },
  },
};
</script>

<style lang="scss" scoped>
.wrapper {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  border: 1px solid #dee2e6;
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
.hideLabels {
  font-weight: 600;
}
.smallerFont {
  font-size: 10px;
}
/deep/.v-input__slot {
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
    margin-top: -85px;
}
@media screen and (max-width: 1500px) {
  .filters-wrapper {
      width: 65% !important;
  }
}

</style>
