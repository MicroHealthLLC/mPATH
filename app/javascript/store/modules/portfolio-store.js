import axios from "axios";

const portfolioModule = {
  state: () => ({
    portfolioWatchedTasksToggle: true,
    portfolioBriefedTasksToggle: true,
    portfolioImportantTasksToggle: true,
    showCount: true,  
   
    programNameFilter: null,
    portfolioCategoriesFilter: null,

    portfolio_tasks: [],
    portfolio_tasks_loaded: true,

    portfolio_issues: [],
    portfolio_issues_loaded: true,

    portfolio_risks: [],
    portfolio_risks_loaded: true,

    portfolio_lessons: [],
    portfolio_lessons_loaded: true,

    portfolio_programs: [],
    portfolio_programs_loaded: true,


    // Flags Work throughout CLient faSolarPanel...move to new store
// 7 States
    hideComplete: false,
    hideInprogress: false,
    hideDraft: false,
    hideOverdue: false,
    hideOngoing: false,
    hideOnhold: false,
    hidePlanned: false,

// 3 TAGS
    hideBriefed: false,
    hideImportant: false,
    hideWatched: false,

  
  }),
  actions: {
    fetchPortfolioPrograms({commit}) {
      commit("TOGGLE_PORTFOLIO_PROGRAMS_LOADED", false);
      // Send GET request for all lessons contained within a project
      axios({
        method: "GET",
        url: `/api/v1/portfolio/programs`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          // Mutate state with response from back end      
          commit("SET_PORTFOLIO_PROGRAMS", res.data);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_PORTFOLIO_PROGRAMS_LOADED", true);
        });
    },  
    fetchPortfolioTasks({commit}) {
        commit("TOGGLE_PORTFOLIO_TASKS_LOADED", false);
        // Send GET request for all lessons contained within a project
        axios({
          method: "GET",
          url: `/api/v1/portfolio/tasks`,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((res) => {
            // Mutate state with response from back end
            commit("SET_PORTFOLIO_TASKS", res.data);
          })
          .catch((err) => {
            console.log(err);
          })
          .finally(() => {
            commit("TOGGLE_PORTFOLIO_TASKS_LOADED", true);
          });
      },  
    fetchPortfolioIssues({commit}) {
        commit("TOGGLE_PORTFOLIO_ISSUES_LOADED", false);
        // Send GET request for all lessons contained within a project
        axios({
          method: "GET",
          url: `/api/v1/portfolio/issues`,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((res) => {
            // Mutate state with response from back end
            commit("SET_PORTFOLIO_ISSUES", res.data);
          })
          .catch((err) => {
            console.log(err);
          })
          .finally(() => {
            commit("TOGGLE_PORTFOLIO_ISSUES_LOADED", true);
          });
      },  
     fetchPortfolioRisks({commit}) {
        commit("TOGGLE_PORTFOLIO_RISKS_LOADED", false);
        // Send GET request for all lessons contained within a project
        axios({
          method: "GET",
          url: `/api/v1/portfolio/risks`,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((res) => {
            // Mutate state with response from back end
            commit("SET_PORTFOLIO_RISKS", res.data);
          })
          .catch((err) => {
            console.log(err);
          })
          .finally(() => {
            commit("TOGGLE_PORTFOLIO_RISKS_LOADED", true);
          });
       },
       fetchPortfolioLessons({commit}) {
        commit("TOGGLE_PORTFOLIO_LESSONS_LOADED", false);
        // Send GET request for all lessons contained within a project
        axios({
          method: "GET",
          url: `/api/v1/portfolio/lessons`,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((res) => {
            // Mutate state with response from back end
            commit("SET_PORTFOLIO_LESSONS", res.data);
          })
          .catch((err) => {
            console.log(err);
          })
          .finally(() => {
            commit("TOGGLE_PORTFOLIO_LESSONS_LOADED", true);
          });
       },
  },
  mutations: {
    setPortfolioWatchedTasksToggle: (state, showAll) => state.portfolioWatchedTasksToggle = showAll,
    setPortfolioImportantTasksToggle: (state, showAll) => state.portfolioImportantTasksToggle = showAll,
    setPortfolioBriefedTasksToggle: (state, showAll) => state.portfolioBriefedTasksToggle = showAll,
    setShowCount: (state, count) => state.showCount = count,

   
    SET_PORTFOLIO_PROGRAMS: (state, portfolio_programs) => state.portfolio_programs = portfolio_programs,
    TOGGLE_PORTFOLIO_PROGRAMS_LOADED: (state, loaded ) => state.portfolio_programs_loaded = loaded,

    SET_PORTFOLIO_TASKS: (state, portfolio_tasks) => state.portfolio_tasks = portfolio_tasks,
    TOGGLE_PORTFOLIO_TASKS_LOADED: (state, loaded ) => state.portfolio_tasks_loaded = loaded,

    SET_PORTFOLIO_ISSUES: (state, portfolio_issues) => state.portfolio_issues = portfolio_issues,
    TOGGLE_PORTFOLIO_ISSUES_LOADED: (state, loaded ) => state.portfolio_issues_loaded = loaded,

    SET_PORTFOLIO_RISKS: (state, portfolio_risks) => state.portfolio_risks = portfolio_risks,
    TOGGLE_PORTFOLIO_RISKS_LOADED: (state, loaded ) => state.portfolio_risks_loaded = loaded,

    SET_PORTFOLIO_LESSONS: (state, portfolio_lessons) => state.portfolio_lessons = portfolio_lessons,
    TOGGLE_PORTFOLIO_LESSONS_LOADED: (state, loaded ) => state.portfolio_lessons_loaded = loaded,
   
    setProgramNameFilter: (state, filter) => state.programNameFilter = filter,
    setPortfolioCategoriesFilter: (state, filter) => state.portfolioCategoriesFilter = filter,

     // Flags Work throughout CLient faSolarPanel...move to new store
     
    //  7 States
    setHideComplete: (state, complete) => state.hideComplete = complete,
    setHideInprogress: (state, inprogress) => state.hideInprogress = inprogress,
    setHideDraft: (state, draft) => state.hideDraft = draft,
    setHidePlanned: (state, planned) => state.hidePlanned = planned,
    setHideOverdue: (state, overdue) => state.hideOverdue = overdue,
    setHideOngoing: (state, ongoing) => state.hideOngoing = ongoing,
    setHideOnhold: (state, onhold) => state.hideOnhold = onhold,

    // 3 Tags
    setHideBriefed: (state, briefed) => state.hideBriefed = briefed,
    setHideImportant: (state, important) => state.hideImportant = important,
    setHideWatched: (state, watched) => state.hideWatched = watched,
  },
  getters: {
    getPortfolioWatchedTasksToggle: state => state.portfolioWatchedTasksToggle,
    getPortfolioImportantTasksToggle: state => state.portfolioImportantTasksToggle,
    getPortfolioBriefedTasksToggle: state => state.portfolioBriefedTasksToggle, 
    
    portfolioPrograms: state => state.portfolio_programs, 
    portfolioProgramsLoaded: state => state.portfolio_programs_loaded,

    portfolioTasks: state => state.portfolio_tasks,
    portfolioTasksLoaded: state => state.portfolio_tasks_loaded,

    portfolioIssues: state => state.portfolio_issues,
    portfolioIssuesLoaded: state => state.portfolio_issues_loaded,

    portfolioRisks: state => state.portfolio_risks,
    portfolioRisksLoaded: state => state.portfolio_risks_loaded,

    portfolioLessons: state => state.portfolio_lessons,
    portfolioLessonsLoaded: state => state.portfolio_lessons_loaded,

    programNameFilter: state => state.programNameFilter,
    portfolioCategoriesFilter: state => state.portfolioCategoriesFilter,

    getShowCount: (state) => state.showCount,

  
     // Flags Work throughout CLient faSolarPanel...move to new store

    //  7 States
    getHideComplete: (state) => state.hideComplete,
    getHideInprogress: (state) => state.hideInprogress,
    getHideOverdue: (state) => state.hideOverdue,
    getHideOngoing: (state) => state.hideOngoing,
    getHidePlanned: (state) => state.hidePlanned,
    getHideDraft: (state) => state.hideDraft,
    getHideOnhold: (state) => state.hideOnhold,

    // 3 Tags
    getHideWatched: (state) => state.hideWatched,
    getHideBriefed: (state) => state.hideBriefed,
    getHideImportant: (state) => state.hideImportant,




  },
};


export default portfolioModule;
