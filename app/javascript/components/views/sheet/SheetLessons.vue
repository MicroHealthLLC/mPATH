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
      <table class="my-3">
        <colgroup></colgroup>
        <tr class="table-head">
          <th @click="sortLessons('title')">Lesson</th>
          <th @click="sortLessonsByDate">Date</th>
          <th @click="sortLessons('description')">Description</th>
          <th>Added By</th>
          <th>Last Update</th>
        </tr>
        <tr v-for="lesson in lessons" :key="lesson.id" @click="openLesson">
          <td>{{ lesson.title }}</td>
          <td>{{ lesson.date }}</td>
          <td>{{ lesson.description }}</td>
          <td>Someone</td>
          <td>I am the last update</td>
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
import { mapActions, mapGetters } from "vuex";

export default {
  data() {
    return {
      lessons: [
        {
          id: 1,
          title: "Z Lesson 1",
          description:
            "Lorem ipsum dolor sit amet consectetur, adipisicing elit. Quae, ipsa.",
          date: "5/12/2021",
          stage: "Stage 1",
          assign_users: [],
          successes: [],
          failures: [],
          best_practices: [],
          files: [],
          links: [],
          update: [],
        },
        {
          id: 2,
          title: "Ultra Lesson 2",
          description: "Amet consectetur, adipisicing elit. Quae, ipsa.",
          date: "5/5/2021",
          stage: "Stage 2",
          assign_users: [],
          successes: [],
          failures: [],
          best_practices: [],
          files: [],
          links: [],
          update: [],
        },
        {
          id: 3,
          title: "Super Lesson 3",
          description: "Dues adipisicing elit. Quae, ipsa.",
          date: "11/20/2026",
          stage: "Stage 2",
          assign_users: [],
          successes: [],
          failures: [],
          best_practices: [],
          files: [],
          links: [],
          update: [],
        },
      ],
      activeSortValue: "",
      sortAsc: false,
    };
  },
  methods: {
    ...mapActions(["fetchProjectLessons"]),
    addLesson() {
      this.$router.push(
        `/programs/${this.$route.params.programId}/sheet/projects/${this.$route.params.projectId}/lessons/new`
      );
    },
    openLesson() {
      console.log("OPENING LESSON");
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

        this.lessons = this.lessons.sort((lesson1, lesson2) => {
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

        this.lessons = this.lessons.sort((lesson1, lesson2) => {
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
        this.lessons = this.lessons.sort(
          (lesson1, lesson2) => new Date(lesson2.date) - new Date(lesson1.date)
        );
        console.log("Sorting by date: Ascending");
        // Sort descending
      } else {
        this.lessons = this.lessons.sort(
          (lesson1, lesson2) => new Date(lesson1.date) - new Date(lesson2.date)
        );
        console.log("Sorting by date: Descending");
      }
      // Store active sort value
      this.activeSortValue = "date";
    },
  },
  computed: {
    ...mapGetters(["lessonsLoaded"]),
  },
  mounted() {
    console.log(this.$permissions)
    console.log("Lessons Loaded: " + this.lessonsLoaded);
    
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
