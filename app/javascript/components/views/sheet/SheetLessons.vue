<template>
  <div class="">
    <div class="my-3">
      <el-input type="search" placeholder="Search Lessons">
        <el-button slot="prepend" icon="el-icon-search"></el-button>
      </el-input>
    </div>
    <div class="wrapper p-3">
      <button class="btn btn-md btn-primary mr-3" @click="addLesson">
        <font-awesome-icon icon="plus-circle" />
        Add Lesson
      </button>
      <table class="my-3 w-100">
        <colgroup></colgroup>
        <tr class="table-head">
          <th @click="sortLessons('title')">Lesson</th>
          <th @click="sortLessonsByDate">Date</th>
          <th @click="sortLessons('description')">Description</th>
          <th>Added By</th>
          <th>Last Update</th>
        </tr>
        <tr
          v-for="lesson in projectLessons"
          :key="lesson.id"
          @click="openLesson(lesson.id)"
          @mouseup.right="openContextMenu($event, lesson)"
          @contextmenu.prevent=""
        >
          <td>{{ lesson.title }}</td>
          <td>{{ lesson.date }}</td>
          <td>{{ lesson.description }}</td>
          <td>Someone</td>
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
              <button class="btn btn-sm page-btns" :load="log( Math.ceil(this.projectLessons.length / this.C_LessonsPerPage.value))" id="page-count"> {{ currentPage }} of {{ Math.ceil(this.projectLessons.length / this.C_LessonsPerPage.value) }} </button>
              <button class="btn btn-sm page-btns" @click="nextPage"><i class="fas fa-angle-right"></i></button>
          </div>
    </div>
    <!-- The context-menu appears only if table row is right-clicked -->
    <LessonContextMenu
      :lesson="clickedLesson"
      :display="showContextMenu"
      ref="menu"
    >
    </LessonContextMenu>
  </div>
</template>

<script>
import { mapActions, mapGetters, mapMutations } from "vuex";
import LessonContextMenu from "./../../shared/LessonContextMenu";

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
    openContextMenu(e, lesson) {
      this.clickedLesson = lesson;
      e.preventDefault();
      this.$refs.menu.open(e);
    },
  },
  computed: {
    ...mapGetters([
      "lessonsLoaded", 
      "projectLessons",
      "getLessonsPerPageFilterOptions",
      "getLessonsPerPageFilter",
    ]),
     C_LessonsPerPage: {
        get() {
          return this.getLessonsPerPageFilter || {id: 3, name: '3', value: 3}
        },
        set(value) {
          this.setLessonsPerPageFilter(value)
        }
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
</style>
