import axios from "axios";

const lessonModule = {
  state: () => ({
    lesson: {}, // Current lesson loaded in form
    project_lessons: [],
    program_lessons: [],
    lesson_stages: [],
    lessons_loaded: true,
    lesson_status: 0,
  }),

  actions: {
    fetchProgramLessons({ commit }, { programId }) {
      // Send GET request for all lessons contained within a program
      axios({
        method: "GET",
        url: `/api/v1/programs/${programId}/lessons.json`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          console.log(res);
          // Mutate state with response from back end
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {});
    },
    fetchProjectLessons({ commit }, { programId, projectId }) {
      // Send GET request for all lessons contained within a project
      axios({
        method: "GET",
        url: `/api/v1/programs/${programId}/projects/${projectId}/lessons.json`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          // Mutate state with response from back end
          commit("SET_PROJECT_LESSONS", res.data.lessons);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {});
    },
    fetchLesson({ commit }, { id, programId, projectId }) {
      commit("TOGGLE_LESSONS_LOADED", false);
      // Retrieve lesson by id
      axios({
        method: "GET",
        url: `/api/v1/programs/${programId}/projects/${projectId}/lessons/${id}.json`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_LESSON", res.data.lesson);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_LESSONS_LOADED", true);
        });
    },
    addLesson({ commit }, { lesson, programId, projectId }) {
      commit("TOGGLE_LESSONS_LOADED", false);
      // Add new lesson
      lesson = {
        lesson: {
          ...lesson,
        },
      };
      axios({
        method: "POST",
        url: `/api/v1/programs/${programId}/projects/${projectId}/lessons.json`,
        data: lesson,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_LESSON", res.data.lesson);
          commit("SET_LESSON_STATUS", res.status);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_LESSONS_LOADED", true);
        });
    },
    updateLesson({ commit }, { lesson, programId, projectId, lessonId }) {
      commit("TOGGLE_LESSONS_LOADED", false);
      // Update a lesson with changes
      lesson = {
        lesson: {
          ...lesson,
        },
      };
      axios({
        method: "PATCH",
        url: `/api/v1/programs/${programId}/projects/${projectId}/lessons/${lessonId}`,
        data: lesson,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_LESSON", res.data.lesson);
          commit("SET_LESSON_STATUS", res.status);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_LESSONS_LOADED", true);
        });
    },
    deleteLesson({ commit }, { id, programId, projectId }) {
      // Delete a single lesson
      axios({
        method: "DELETE",
        url: `/api/v1/programs/${programId}/projects/${projectId}/lessons/${id}.json`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("DELETE_LESSON", id);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {});
    },
  },
  mutations: {
    SET_PROGRAM_LESSONS: (state, lessons) => (state.project_lessons = lessons),
    SET_PROJECT_LESSONS: (state, lessons) => (state.project_lessons = lessons),
    SET_LESSON: (state, lesson) => (state.lesson = lesson),
    DELETE_LESSON: (state, id) => {
      // Find index of lesson to delete
      let index = state.project_lessons.findIndex((lesson) => lesson.id == id);
      // Remove lesson from array
      state.project_lessons.splice(index, 1);
    },
    SET_LESSON_STAGES: (state, lessonStages) =>
      (state.lesson_stages = lessonStages),
    TOGGLE_LESSONS_LOADED: (state, loaded) => (state.lessons_loaded = loaded),
    SET_LESSON_STATUS: (state, status) => (state.lesson_status = status),
  },
  getters: {
    lesson: (state) => state.lesson,
    projectLessons: (state) => state.project_lessons,
    programLessons: (state) => state.program_lessons,
    lessonStages: (state) => state.lesson_stages,
    lessonsLoaded: (state) => state.lessons_loaded,
    lessonStatus: (state) => state.lesson_status,
  },
};

export default lessonModule;
