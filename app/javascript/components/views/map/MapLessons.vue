<template>
  <div>
    <div class="my-3">
      <el-input type="search" placeholder="Search Lessons" v-model="search">
        <el-button slot="prepend" icon="el-icon-search"></el-button>
      </el-input>
    </div>
    <div v-if="contentLoaded">
      <button class="btn btn-md btn-primary mr-3" @click="addLesson">
        <font-awesome-icon icon="plus-circle" />
        Add Lesson
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
        <div class="font-lg card-title">{{ lesson.title }}</div>
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
      search: "",
      clickedLesson: {},
      showContextMenu: false,
    };
  },
  methods: {
    ...mapActions(["fetchProjectLessons"]),
    addLesson() {
      this.$router.push(
        `/programs/${this.$route.params.programId}/map/projects/${this.$route.params.projectId}/lessons/new`
      );
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
</style>
