import axios from "axios";

const portfolioModule = {
  state: () => ({
    portfolioWatchedTasksToggle: true,
    portfolioBriefedTasksToggle: true,
    portfolioImportantTasksToggle: true,
    showCount: true,  
   
    programNameFilter: null,

    portfolioNameFilter: null,

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

    portfolio_users: [],
    portfolio_users_loaded: true,
    portfolioUsersFilter: null,

    portfolio_statuses: [],
    portfolio_statuses_loaded: true,
    portfolioStatusesFilter: null,
    
    portfolio_programs_filter: [],
    portfolio_loaded: true,


// Portfolio Stages
    portfolio_task_stages: [],
    portfolio_task_stages_loaded: true,
    portfolioTaskStagesFilter: null,

    portfolio_issue_stages: [],
    portfolio_issue_stages_loaded: true,
    portfolioIssueStagesFilter: null,

    portfolio_risk_stages: [],
    portfolio_risk_stages_loaded: true,
    portfolioRiskStagesFilter: null,

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
    // fetchPortfolioProgramsFilter({commit}) {
    //   commit("TOGGLE_PORTFOLIO_LOADED", false);
    //   // Send GET request for all lessons contained within a project
    //   axios({
    //     method: "GET",
    //     url: `/api/v1/filter_data/programs`,
    //     headers: {
    //       "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
    //         .attributes["content"].value,
    //     },
    //   })
    //     .then((res) => {
    //       // Mutate state with response from back end  
    //     console.log("portfoi" + res)
    //       commit("SET_PORTFOLIO_PROGRAMS_FILTER", res.data);
    //     })
    //     .catch((err) => {
    //       console.log(err);
    //     })
    //     .finally(() => {
    //       commit("TOGGLE_PORTFOLIO_LOADED", true);
    //     });
    // }, 
    fetchPortfolioPrograms({commit}) {
      commit("TOGGLE_PORTFOLIO_PROGRAMS_LOADED", false);
      // Send GET request for all lessons contained within a project
      axios({
        method: "GET",
        url: `/api/v1/filter_data/programs`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          //  console.log("portfoi" + JSON.stringify(res.data))
          // Mutate state with response from back end      
          commit("SET_PORTFOLIO_PROGRAMS", res.data.portfolio_filters);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_PORTFOLIO_PROGRAMS_LOADED", true);
        });
    },
    fetchPortfolioUsers({commit}) {
      commit("TOGGLE_PORTFOLIO_USERS_LOADED", false);
      // Send GET request for all lessons contained within a project
      axios({
        method: "GET",
        url: `/api/v1/filter_data/users`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          // Mutate state with response from back end    
          commit("SET_PORTFOLIO_USERS", res.data.users);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_PORTFOLIO_USERS_LOADED", true);
        });
    },
    fetchPortfolioStatuses({commit}) {
      commit("TOGGLE_PORTFOLIO_STATUSES_LOADED", false);
      // Send GET request for all lessons contained within a project
      axios({
        method: "GET",
        url: `/api/v1/filter_data/statuses`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
 
          // Mutate state with response from back end    
             commit("SET_PORTFOLIO_STATUSES", res.data.statuses);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_PORTFOLIO_STATUSES_LOADED", true);
        });
    },
    fetchPortfolioTaskStages({commit}) {
      commit("TOGGLE_PORTFOLIO_TASK_STAGES_LOADED", false);
      // Send GET request for all lessons contained within a project
      axios({
        method: "GET",
        url: `/api/v1/filter_data/stages.json?resource=task`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
           // Mutate state with response from back end           
          commit("SET_PORTFOLIO_TASK_STAGES", res.data.stages);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_PORTFOLIO_TASK_STAGES_LOADED", true);
        });
    },
    fetchPortfolioIssueStages({commit}) {
      commit("TOGGLE_PORTFOLIO_ISSUE_STAGES_LOADED", false);
      // Send GET request for all lessons contained within a project
      axios({
        method: "GET",
        url: `/api/v1/filter_data/stages.json?resource=issue`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          // Mutate state with response from back end    
        commit("SET_PORTFOLIO_ISSUE_STAGES", res.data.stages);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_PORTFOLIO_ISSUE_STAGES_LOADED", true);
        });
    },
    fetchPortfolioRiskStages({commit}) {
      commit("TOGGLE_PORTFOLIO_RISK_STAGES_LOADED", false);
      // Send GET request for all lessons contained within a project
      axios({
        method: "GET",
        url: `/api/v1/filter_data/stages.json?resource=risk`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
        // Mutate state with response from back end    
          commit("SET_PORTFOLIO_RISK_STAGES", res.data.stages);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_PORTFOLIO_RISK_STAGES_LOADED", true);
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

    SET_PORTFOLIO_PROGRAMS_FILTER: (state, portfolio_programs_filter) => state.portfolio_programs_filter = portfolio_programs_filter,
    TOGGLE_PORTFOLIO_PROGRAMS_FILTER_LOADED: (state, loaded ) => state.portfolio_programs_filter_loaded = loaded,

   
    SET_PORTFOLIO_PROGRAMS: (state, portfolio_programs) => state.portfolio_programs = portfolio_programs,
    TOGGLE_PORTFOLIO_PROGRAMS_LOADED: (state, loaded ) => state.portfolio_programs_loaded = loaded,

    // PORTFOLIO USERS
    SET_PORTFOLIO_USERS: (state, portfolio_users) => state.portfolio_users = portfolio_users,
    TOGGLE_PORTFOLIO_USERS_LOADED: (state, loaded ) => state.portfolio_users_loaded = loaded,   
    setPortfolioUsersFilter: (state, portfolioUsersFilter) => state.portfolioUsersFilter = portfolioUsersFilter,

    // PORTFOLIO PROJECT STATUSES
    SET_PORTFOLIO_STATUSES: (state, portfolio_statuses) => state.portfolio_statuses = portfolio_statuses,
    TOGGLE_PORTFOLIO_STATUSES_LOADED: (state, loaded ) => state.portfolio_statuses_loaded = loaded,
    setPortfolioStatusesFilter: (state, portfolioStatusesFilter) => state.portfolioStatusesFilter = portfolioStatusesFilter,

    // PORTFOLIO STAGES (TASKS, ISSUES, RISKS)
    SET_PORTFOLIO_TASK_STAGES: (state, portfolio_task_stages) => state.portfolio_task_stages = portfolio_task_stages,
    TOGGLE_PORTFOLIO_TASK_STAGES_LOADED: (state, loaded ) => state.portfolio_task_stages_loaded = loaded,   
    setPortfolioTaskStagesFilter: (state, portfolioTaskStagesFilter) => state.portfolioTaskStagesFilter = portfolioTaskStagesFilter,

    SET_PORTFOLIO_ISSUE_STAGES: (state, portfolio_issue_stages) => state.portfolio_issue_stages = portfolio_issue_stages,
    TOGGLE_PORTFOLIO_ISSUE_STAGES_LOADED: (state, loaded ) => state.portfolio_issue_stages_loaded = loaded,   
    setPortfolioIssueStagesFilter: (state, portfolioIssueStagesFilter) => state.portfolioIssueStagesFilter = portfolioIssueStagesFilter,


    SET_PORTFOLIO_RISK_STAGES: (state, portfolio_risk_stages) => state.portfolio_risk_stages = portfolio_risk_stages,
    TOGGLE_PORTFOLIO_RISK_STAGES_LOADED: (state, loaded ) => state.portfolio_risk_stages_loaded = loaded,   
    setPortfolioRiskStagesFilter: (state, portfolioRiskStagesFilter) => state.portfolioRiskStagesFilter = portfolioRiskStagesFilter,


    // PORTFOLIO TASKS
    SET_PORTFOLIO_TASKS: (state, portfolio_tasks) => state.portfolio_tasks = portfolio_tasks,
    TOGGLE_PORTFOLIO_TASKS_LOADED: (state, loaded ) => state.portfolio_tasks_loaded = loaded,

    // PORTFOLIO ISSUES
    SET_PORTFOLIO_ISSUES: (state, portfolio_issues) => state.portfolio_issues = portfolio_issues,
    TOGGLE_PORTFOLIO_ISSUES_LOADED: (state, loaded ) => state.portfolio_issues_loaded = loaded,

    
    // PORTFOLIO RISKS
    SET_PORTFOLIO_RISKS: (state, portfolio_risks) => state.portfolio_risks = portfolio_risks,
    TOGGLE_PORTFOLIO_RISKS_LOADED: (state, loaded ) => state.portfolio_risks_loaded = loaded,

    SET_PORTFOLIO_LESSONS: (state, portfolio_lessons) => state.portfolio_lessons = portfolio_lessons,
    TOGGLE_PORTFOLIO_LESSONS_LOADED: (state, loaded ) => state.portfolio_lessons_loaded = loaded,
   
    setProgramNameFilter: (state, filter) => state.programNameFilter = filter,
    setPortfolioNameFilter: (state, filter) => state.portfolioNameFilter = filter,

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

    // GETTER FOR PORTFOLIO USERS
    portfolioUsers: state => state.portfolio_users, 
    portfolioUsersLoaded: state => state.portfolio_users_loaded,
    portfolioUsersFilter: state => state.portfolioUsersFilter,

    // GETTER FOR PORTFOLIO STAGES
    portfolioTaskStages: state => state.portfolio_task_stages, 
    portfolioTaskStagesLoaded: state => state.portfolio_task_stages_loaded,
    portfolioTaskStagesFilter: state => state.portfolioTaskStagesFilter,

    portfolioIssueStages: state => state.portfolio_issue_stages, 
    portfolioIssueStagesLoaded: state => state.portfolio_issue_stages_loaded,
    portfolioIssueStagesFilter: state => state.portfolioIssueStagesFilter,


    portfolioRiskStages: state => state.portfolio_risk_stages, 
    portfolioRiskStagesLoaded: state => state.portfolio_risk_stages_loaded,
    portfolioRiskStagesFilter: state => state.portfolioRiskStagesFilter,


    // GETTER FOR PORTFOLIO STATUSES

    portfolioStatuses: state => state.portfolio_statuses, 
    portfolioStatusesLoaded: state => state.portfolio_statuses_loaded,
    portfolioStatusesFilter: state => state.portfolioStatusesFilter,
    
    portfolioProgramsFilter: state => state.portfolio_programs_filter, 
    portfolioProgramsFilterLoaded: state => state.portfolio_programs_filter_loaded,

    portfolioTasks: state => state.portfolio_tasks,
    portfolioTasksLoaded: state => state.portfolio_tasks_loaded,

    portfolioIssues: state => state.portfolio_issues,
    portfolioIssuesLoaded: state => state.portfolio_issues_loaded,

    portfolioRisks: state => state.portfolio_risks,
    portfolioRisksLoaded: state => state.portfolio_risks_loaded,

    portfolioLessons: state => state.portfolio_lessons,
    portfolioLessonsLoaded: state => state.portfolio_lessons_loaded,

    programNameFilter: state => state.programNameFilter,
    portfolioNameFilter: state => state.portfolioNameFilter,
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
