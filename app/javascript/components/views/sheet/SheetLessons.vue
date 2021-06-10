<template>
  <div>
    <div class="my-3">
      <el-input type="search" placeholder="Search Lessons" v-model="search">
        <el-button slot="prepend" icon="el-icon-search"></el-button>
      </el-input>
    </div>
    <div class="wrapper p-3">
      <button class="btn btn-md btn-primary mr-3" @click="addLesson">
        <font-awesome-icon icon="plus-circle" />
        Add Lesson
      </button>
      <table v-if="projectLessons.length > 0" class="my-3 w-100">
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

      <div v-else class="text-danger alt-text mt-4">No Lessons found...</div>
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
import { mapActions, mapGetters } from "vuex";
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
      clickedLesson: {},
      search: "",
    };
  },
  methods: {
    ...mapActions(["fetchProjectLessons"]),
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
</style>
