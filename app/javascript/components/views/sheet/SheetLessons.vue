<template>
  <div>
    <div class="pl-3 w-70">
      <el-input type="search" placeholder="Search Lessons" v-model="search">
        <el-button slot="prepend" icon="el-icon-search"></el-button>
      </el-input>
    </div>
    <div class="wrapper mt-3 p-3">
      <button class="btn btn-md btn-primary addLessonBtn mr-3" @click="addLesson">
        <font-awesome-icon icon="plus-circle" />
        Add Lesson
      </button>
      <div class="float-right">
      <button
        v-tooltip="`Export to PDF`"
        @click.prevent="exportToPdf"
        class="btn btn-md mr-1 exportBtns text-light">
        <font-awesome-icon icon="file-pdf"/>
      </button>
      <button
        v-tooltip="`Export to Excel`"
        @click.prevent="exportToExcel('table', 'Lessons Learned')"
        class="btn btn-md mr-1 exportBtns text-light">
        <font-awesome-icon icon="file-excel"/>
      </button>
        <!-- <button
        v-tooltip="`Show More/Show Less`"
        @click.prevent="showAllToggle"
        class="btn btn-md mr-1 showAll text-light"          >
        <span v-if="getToggleRACI">
        <font-awesome-icon icon="user" />
        </span>
          <span v-else>
        <font-awesome-icon icon="users"/>
          </span>
        </button> -->
      <button class="ml-2 btn btn-md btn-info total-table-btns" data-cy="lessons_total">
        Total: {{projectLessons.length}}
      </button>
    </div>
      <div style="margin-bottom:50px" data-cy="lessons_table">
      <table v-if="projectLessons.length > 0" class="my-3 w-100" id="lessonsPdf" ref="table">
        <colgroup></colgroup>
        <tr class="table-head">
          <th @click="sortLessons('title')">Lesson</th>
          <th @click="sortLessonsByDate">Date</th>
          <th @click="sortLessons('description')">Description</th>
          <th>Added By</th>
          <th>Last Update</th>
        </tr>
        <tr
          v-for="lesson in filteredLessons"
          :key="lesson.id"
          @click="openLesson(lesson.id)"
          @mouseup.right="openContextMenu($event, lesson)"
          @contextmenu.prevent=""
        >
          <td>{{ lesson.title }}</td>
          <td>{{ formatDate(new Date(lesson.date)) }}</td>
          <td>{{ lesson.description }}</td>
          <td>{{ author(lesson.user_id) }}</td>
          <td>I am the last update</td>
        </tr>
      </table>
       <div class="float-right mb-4 mt-2 font-sm">
          <div class="simple-select d-inline-block text-right font-sm">
              <span>Displaying </span>
                  <el-select
                  v-model="C_LessonsPerPage"
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
            <span class="mr-1 pr-3" style="border-right:solid 1px lightgray">Per Page </span>
              <button class="btn btn-sm page-btns" @click="prevPage"><i class="fas fa-angle-left"></i></button>
              <button class="btn btn-sm page-btns" :load="log( Math.ceil(filteredLessons))" id="page-count"> {{ currentPage }} of {{ Math.ceil(projectLessons.length / C_LessonsPerPage.value) }} </button>
              <button class="btn btn-sm page-btns" @click="nextPage"><i class="fas fa-angle-right"></i></button>
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
import {jsPDF} from "jspdf"
import 'jspdf-autotable'

export default {
  components: {
    LessonContextMenu,
  },
  data() {
    return {
      activeSortValue: "",
      sortAsc: false,
      showContextMenu: false,
      currentPage:1,
      clickedLesson: {},
      search: "",
      uri :'data:application/vnd.ms-excel;base64,',
      template:'<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="https://www.w3.org/TR/2018/SPSD-html401-20180327/"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
      base64: function(s){ return window.btoa(unescape(encodeURIComponent(s))) },
      format: function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) }
    };
  },
  methods: {
    ...mapActions(["fetchProjectLessons"]),
    ...mapMutations(['setLessonsPerPageFilter']),
    addLesson() {
      this.$router.push(
        `/programs/${this.$route.params.programId}/sheet/projects/${this.$route.params.projectId}/lessons/new`
      );
    },
    exportToPdf() {
        const doc = new jsPDF("l")
        const html =  this.$refs.table.innerHTML
        doc.autoTable({html: "#lessonsPdf"})
        doc.save("Lessons Learned.pdf")
      
    },
    exportToExcel(table, name){
        if (!table.nodeType) table = this.$refs.table
        var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML}
        window.location.href = this.uri + this.base64(this.format(this.template, ctx))
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
    log(e){
      console.log("this is projectLesson: " + e)
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
        console.log(`Sorting by ${value}: Ascending`);

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
        console.log(`Sorting by ${value}: Descending`);

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
    nextPage:function() {
        if((this.currentPage*this.C_LessonsPerPage.value) < this.projectLessons.length) this.currentPage++;
      },
    prevPage:function() {
        if(this.currentPage > 1) this.currentPage--;
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
        console.log("Sorting by date: Ascending");
        // Sort descending
      } else {
        this.projectLessons.sort(
          (lesson1, lesson2) => new Date(lesson1.date) - new Date(lesson2.date)
        );
        console.log("Sorting by date: Descending");
      }
      // Store active sort value
      this.activeSortValue = "date";
    },
    author(id) {
      return this.activeProjectUsers.find((user) => user.id == id).fullName;
    },
    openContextMenu(e, lesson) {
      this.clickedLesson = lesson;
      e.preventDefault();
      this.$refs.menu.open(e);
    },
  },
  computed: {
    ...mapGetters([
      "activeProjectUsers",
      "contentLoaded",
      "lessonsLoaded", 
      "projectLessons",
      "getLessonsPerPageFilterOptions",
      "getLessonsPerPageFilter",
    ]),
     C_LessonsPerPage: {
        get() {
          return this.getLessonsPerPageFilter || {id: 5, name: '5', value: 5}
        },
        set(value) {
          this.setLessonsPerPageFilter(value)
        }
     },
    filteredLessons() {
      return this.projectLessons.filter((lesson) =>
        lesson.title.toLowerCase().match(this.search.toLowerCase())
      ).filter((row, index) => {
        let start = (this.currentPage-1)*this.C_LessonsPerPage.value;
        let end = this.currentPage*this.C_LessonsPerPage.value;
        if(index >= start && index < end) return true;
        return this.end
       })
    },
  },
  mounted() {
    this.fetchProjectLessons(this.$route.params);
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
}
.page-btns.active  {
    background-color: rgba(211, 211, 211, 10%);
    border:none !important;
 }
 .addLessonBtn, .exportBtns, .showAll {
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
 }
 .exportBtns, .showAll {
    transition: all .2s ease-in-out;
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
    font-size: 0.70rem;
    color: #383838;
 }
 td {
    padding: 6px;
    font-size: 14px;
    color: #606266;
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
</style>
