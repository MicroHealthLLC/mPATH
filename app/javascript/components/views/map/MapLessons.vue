<template>
  <div>
    <div class="my-3">
      <el-input type="search" placeholder="Search Lessons" v-model="search">
        <el-button slot="prepend" icon="el-icon-search"></el-button>
      </el-input>
    </div>
    <div v-if="contentLoaded">
      <button v-if="_isallowed('write')" class="btn btn-md addLessonBtn btn-primary mr-3" @click="addLesson">
        <font-awesome-icon icon="plus-circle" />
        Add Lesson
      </button>

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
      
      <hr class="mb-3" />
      <el-card
        v-for="(lesson, index) in filteredLessons"
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
      <div v-show="filteredLessons.length < 1" class="text-danger font-lg mt-4">
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
     <table style="display:none" class="table table-sm table-bordered" ref="table" id="lessonsPdf">
      <thead>
        <tr>
          <th>Lesson</th>
          <th>Date</th>
          <th>Added By</th>
          <th>Description</th>
          <th>Flags</th>  
          <th>Last Update</th>
         
        </tr>
      </thead>
      <tbody>
         <tr
            v-for="lesson in filteredLessons"
            :key="lesson.id"
            @click="openLesson(lesson.id)"
            @mouseup.right="openContextMenu($event, lesson)"
            @contextmenu.prevent=""
          >
            <td>{{ lesson.title }}</td>
            <td class="text-center">{{ formatDate(new Date(lesson.date)) }}</td>
            <td class="text-center">{{ lesson.created_by.full_name }}</td>
            <td>{{ lesson.description }}</td>
            <td class="text-center">
              <span v-if="lesson.important == true" v-tooltip="`Important`">
                <i class="fas fa-star text-warning mr-1"></i
              ></span>
              <span v-if="lesson.reportable" v-tooltip="`Briefings`"
                ><font-awesome-icon icon="flag" class="text-primary mr-1"
              /></span>
              <span v-if="lesson.draft == true" v-tooltip="`Draft`"
                ><font-awesome-icon icon="pencil-alt" class="text-warning"
              /></span>
              <span
                v-if="
                  lesson.important == false &&
                    lesson.reportable == false &&
                    lesson.draft == false
                "
              >
                No flags at this time
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
                {{ lesson.last_update.body }}</span
              >
              <span v-else>No Updates</span>
            </td>
        </tr>
        
      </tbody>
    </table>
  </div>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import LessonContextMenu from "./../../shared/LessonContextMenu";
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
    //TODO: change the method name of isAllowed
    _isallowed(salut) {
      var programId = this.$route.params.programId;
      var projectId = this.$route.params.projectId
      let fPrivilege = this.$projectPrivileges[programId][projectId]
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return  fPrivilege.lessons.includes(s); 
    },
    addLesson() {
      this.$router.push(
        `/programs/${this.$route.params.programId}/map/projects/${this.$route.params.projectId}/lessons/new`
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
    ]),
    filteredLessons() {
      return this.projectLessons.filter((lesson) =>
        lesson.title.toLowerCase().match(this.search.toLowerCase())
      );
    },
  },
  mounted() {
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
</style>
