import axios from "axios";

const lessonModule = {
  state: () => ({
    lesson: {}, // Current lesson loaded in form
    project_lessons: [],
    program_lessons: [],
    lessons_loaded: false,
  }),

  actions: {
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
        .finally(() => {
          commit("TOGGLE_LESSONS_LOADED");
        });
    },
    fetchLesson({ commit }, { id, programId, projectId }) {
      console.log(id);
      console.log(programId);
      console.log(projectId);
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
          console.log(res);
          // Mutate state with response from back end
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_LESSONS_LOADED");
        });
    },
    addLesson({ commit }, { lesson, programId, projectId }) {
      console.log(lesson);
      console.log(programId);
      console.log(projectId);
      // Add new lesson
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
          // TODO: Write mutation code
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {});
    },
    updateLesson({ commit }, { lesson, programId, projectId }) {
      // Update a lesson with changes
      axios({
        method: "PUT",
        url: `/api/v1/programs/${programId}/projects/${projectId}/lessons/${lesson.id}`,
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
    deleteLesson({ commit }, { lesson, programId, projectId }) {
      // Delete a single lesson
      axios({
        method: "DELETE",
        url: `/api/v1/programs/${programId}/projects/${projectId}/lessons/${lesson.id}`,
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
    lesson: (state) => state.lesson,
    projectLessons: (state) => state.project_lessons,
    programLessons: (state) => state.program_lessons,
    lessonsLoaded: (state) => state.lessons_loaded,
  },
};

export default lessonModule;
