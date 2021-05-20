import axios from "axios";

const lessonModule = {
  state: () => ({
    project_lessons: [],
    program_lessons: [],
    lessons_loaded: false,
  }),

  actions: {
    fetchProjectLessons({ commit }, { programId, projectId }) {
      // Send GET request for all projects contained within a project
      axios({
        method: "GET",
        url: `/api/v1/programs/${programId}/projects/${projectId}/lessons.json`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          console.log(res);
          // Mutate state with response from back end
          commit("SET_PROJECT_LESSONS", res.data.lessons);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_LESSONS_LOADED");
        });
    },
    fetchProgramLessons() {
      // Get all lessons for a single program
    },
    addLesson({ commit }, {lesson, programId, projectId}) {
      console.log(lesson)
      console.log(programId);
      console.log(projectId);

      axios({
        method: "POST",
        url: `/api/v1/programs/${programId}/projects/${projectId}/lessons`,
        data: lesson,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          // TODO: Write mutation code
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {});
    },
    updateLesson({ commit }, lesson, programId, projectId) {
      axios({
        method: "PUT",
        url: `/programs/${programId}/projects/${projectId}/lessons/${lesson.id}`,
        data: lesson,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          // TODO: Write mutation code
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {});
    },
    deleteLesson() {
      axios({
        method: "DELETE",
        url: `/programs/${programId}/projects/${projectId}/lessons/${lesson.id}`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          // TODO: Write mutation code
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {});
    },
  },
  mutations: {
    SET_PROJECT_LESSONS: (state, lessons) => (state.project_lessons = lessons),
    SET_PROGRAM_LESSONS: (state, lessons) => (state.project_lessons = lessons),
    TOGGLE_LESSONS_LOADED: (state) =>
      (state.lessons_loaded = !state.lessons_loaded),
  },
  getters: {
    projectLessons: (state) => state.project_lessons,
    programLessons: (state) => state.program_lessons,
    lessonsLoaded: (state) => state.lessons_loaded,
  },
};

export default lessonModule;
