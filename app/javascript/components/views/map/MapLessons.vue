<template>
  <div>
    <div class="d-flex align-item-center justify-content-between w-100 mb-3 mt-3">
      <div class="input-group w-100">
        <el-input type="search" style="height:30px" placeholder="Search Lessons" v-model="search">
          <el-button slot="prepend" icon="el-icon-search"></el-button>
        </el-input>
      </div>
      <div class="ml-1 font-sm w-100">
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
    <div v-if="contentLoaded">
       <span class="d-inline">
      <button v-if="_isallowed('write')" class="btn btn-md addLessonBtn btn-primary mr-2 float-left" @click="addLesson">
        <font-awesome-icon icon="plus-circle" />
        Add Lesson
      </button>
          <span class="d-inline-block tagCol px-2 mr-1">
          <div class="pr-4 text-center d-inline-block icons" :class="[getHideComplete == true ? 'light':'']" @click.prevent="toggleComplete" >                              
            <span class="d-block">
            <i class="fas fa-clipboard-check" :class="[getHideComplete == true ? 'light':'text-success']"></i>
            </span>      
        
            <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{variation.completed.count}}</h6>  
          </div>

          <div class="pr-4 text-center d-inline-block icons"  :class="[getHideDraft == true ? 'light':'']"  @click.prevent="toggleDraft" >                              
            <span class="d-block">
            <i class="fas fa-pencil-alt"  :class="[getHideDraft == true ? 'light':'text-warning']"></i>
            </span>      
  
            <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.drafts.count }}</h6>
          </div>
    
          <div class="pr-4 text-center d-inline-block icons" :class="[getHideImportant == true ? '':'light']" @click.prevent="toggleImportant">                              
            <span class="d-block">
            <i class="fas fa-star" :class="[getHideImportant == true ? 'text-warning':'light']"></i>
            </span>      
  
            <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.important.count }}</h6>
          </div>
          <div class="pr-2 text-center d-inline-block icons" :class="[getHideBriefed == true ? '':'light']" @click.prevent="toggleBriefed">                              
            <span class="d-block">
            <i class="fas fa-presentation" :class="[getHideBriefed == true ? 'text-primary':'']"></i>
            </span>      
            <h6 :class="[getShowCount == false ? 'd-none' : 'd-block']" >{{ variation.briefings.count }}</h6>
          </div>  

          <div class="d-inline-block mx-0">        
            <v-checkbox     
          v-model="C_showCountToggle"     
            class="d-inline-block"  
            @click.prevent="showCounts"   
          v-tooltip="`Show Counts`"
          ></v-checkbox>
          </div>
      </span>
            
   </span>
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
   </div>
      
      <hr class="mb-3" />
      <el-card
        v-for="(lesson, index) in filteredLessons.filtered.lessons"
        :key="index"
        class="lesson-card my-1"
        @click.native="openLesson(lesson.id)"
        @mouseup.right.native="openContextMenu($event, lesson)"
        @contextmenu.prevent=""
      >      
        <div class="font-lg card-title">{{ lesson.title }}
          <span class="float-right">                 
            <span v-show="lesson.important" v-tooltip="`Important`" class="mr-1"> <i class="fas fa-star text-warning"></i></span>
            <span v-show="lesson.reportable" v-tooltip="`Briefings`"><i class="fas fa-presentation mr-1 text-primary"></i></span>          
            <span v-show="lesson.draft" v-tooltip="`Draft`"><i class="fas fa-pencil-alt text-warning mr-1"></i></span>  
            <span v-if="lesson.draft == false" v-tooltip="`Complete`"> <i class="fas fa-clipboard-check text-success"></i></span>              
          </span>
        </div>
        
        <div class="font-sm">
          <span class="fbody-icon mr-2"
            ><i class="fas fa-calendar-alt"></i></span
          >{{ formatDate(new Date(lesson.date)) }}
        </div>
        <div class="font-sm">
          <span class="fbody-icon mr-2"><i class="fas fa-tasks"></i></span
          >{{ category(lesson.task_type_id) }}
        </div>
      </el-card>
      <div v-show="filteredLessons.filtered.lessons.length < 1" class="text-danger font-lg mt-4">
        No Lessons found...
      </div>
    </div>
    <!-- The context-menu appears only if table row is right-clicked -->
    <LessonContextMenu
      :lesson="clickedLesson"
      :display="showContextMenu"
      routeName="MapLessonForm"
      ref="menu"
    >
    </LessonContextMenu>
    <table
        v-if="filteredLessons.filtered.lessons.length > 0"
        class="table table-sm table-bordered table-striped"
        ref="table" id="lessonsMapList1"
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
        <tr v-for="lesson in filteredLessons.filtered.lessons" :key="lesson.id">
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
  </div>
</template>

<script>
import { mapActions, mapGetters, mapMutations } from "vuex";
import LessonContextMenu from "./../../shared/LessonContextMenu.vue";
import { jsPDF } from "jspdf";
import "jspdf-autotable";

export default {
  components: {
    LessonContextMenu,
  },
  data() {
    return {
      search: "",
      clickedLesson: {},
      showContextMenu: false,
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
    //TODO: change the method name of isAllowed
    _isallowed(salut) {
        return this.checkPrivileges("MapLessons", salut, this.$route)

      // var programId = this.$route.params.programId;
      // var projectId = this.$route.params.projectId
      // let fPrivilege = this.$projectPrivileges[programId][projectId]
      // let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      // let s = permissionHash[salut]
      // return  fPrivilege.lessons.includes(s); 
    },
    log(e) {
    console.log(e)
    },
    addLesson() {
      this.$router.push(
        `/programs/${this.$route.params.programId}/map/projects/${this.$route.params.projectId}/lessons/new`
      );
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
    exportToPdf() {
      const doc = new jsPDF("l");
      const html = this.$refs.table.innerHTML;
      doc.autoTable({ html: "#lessonsMapList1" });
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
    openLesson(id) {
      this.$router.push({
        name: "MapLessonForm",
        params: {
          programId: this.$route.params.programId,
          projectId: this.$route.params.projectId,
          lessonId: id,
        },
      });
    },
    category(id) {
      if (id) {
        return this.taskTypes.find((category) => category.id == id).name;
      } else {
        return "N/A";
      }
    },
    openContextMenu(e, lesson) {
      this.clickedLesson = lesson;
      e.preventDefault();
      this.$refs.menu.open(e);
    },
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "lessonsLoaded",
      "projectLessons",
      "taskTypes",
      'taskTypeFilter',
      'filterDataForAdvancedFilter',
      'getShowCount',
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
    },
    C_taskTypeFilter: {
      get() {
        return this.taskTypeFilter
      },
      set(value) {
        this.setTaskTypeFilter(value)
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
      };
    },
    filteredLessons() {
         // Returns filtered lessons based on search value from input
      let milestoneIds = _.map(this.C_taskTypeFilter, 'id')
      let valid = true
      let advancedFilterlessons = _.filter(this.projectLessons, (resource) => {
        valid = valid && this.filterDataForAdvancedFilter([resource], 'mapLessons')
        if (milestoneIds.length > 0) valid = valid && milestoneIds.includes(resource.task_type_id)
        return valid
      })
      return {
      unfiltered: {
        lessons: advancedFilterlessons
        .filter(lesson => {
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
  }
   },
  mounted() {
    console.log(this.filteredLessons.filtered.lessons)
    this.fetchProjectLessons(this.$route.params);
  },
};
</script>

<style lang="scss" scoped>
.lesson-card:hover {
  cursor: pointer;
  box-shadow: 0.5px 0.5px 1px 1px rgba(56, 56, 56, 0.29),
    0 2px 2px rgba(56, 56, 56, 0.23);
  background-color: rgba(91, 192, 222, 0.3);
  border-left: solid #5bc0de;
}
.card-title {
  color: #0275d8;
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

.tagCol {
  border-radius: 4px;
  border: .5px solid lightgray;
  h6 {
  margin-bottom: 0;
 }
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

::v-deep.v-input__slot {
  display: inline;
  .v-label {
   font-family: 'FuturaPTBook';
  //  font-weight: 600;
   color: #007bff !important;
  }
}
::v-deep.v-input__control {
  display: block !important;
}
.hideLabels {
  font-weight: 600;
}
::v-deep.v-input--checkbox{
  margin-top: 0;
}
</style>
