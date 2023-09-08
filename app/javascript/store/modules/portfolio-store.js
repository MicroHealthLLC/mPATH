import axios from "axios";

const portfolioModule = {
  state: () => ({
    portfolioWatchedTasksToggle: true,
    portfolioBriefedTasksToggle: true,
    portfolioImportantTasksToggle: true,
    showCount: true,  
    portfolio_tab: '', 
    curr_tab: '#tab-tasks', 
    facility_project_ids: [],

    current_page: 1,
    current_issue_page: 1,
    current_risk_page: 1,
    current_lesson_page: 1,

    programNameFilter: null,

    portfolioNameFilter: null,
    portfolio_programs: [],
    portfolio_programs_loaded: true,

    authorized_portfolio_programs: [],
    authorized_portfolio_programs_loaded: true,

    portfolioCategoriesFilter: null,

    portfolio_categories: [],
    portfolio_categories_loaded: true,

    // PORTFOLIO COUNTS
    portfolio_counts: {},
    portfolio_counts_loaded: true,

    // PORTFOLIO TASKS
    portfolio_tasks: [],
    portfolio_tasks_loaded: true,

    // This one handles the individual edit tasks when clicking on Task row in Portfolio table
    portfolio_task: {},
    portfolio_task_loaded: true,

      // This one handles the individual edit issues when clicking on Task row in Portfolio table
    portfolio_issue: {},
    portfolio_issue_loaded: true,

        // This one handles the individual edit risks when clicking on Task row in Portfolio table
    portfolio_risk: {},
    portfolio_risk_loaded: true,


    // This one handles the individual edit risks when clicking on Task row in Portfolio table
    portfolio_lesson: {},
    portfolio_lesson_loaded: true,

    // PORTFOLIO ISSUES
    portfolio_issue_types: [],
    portfolio_issue_types_loaded: true,
    portfolioIssueTypesFilter: null,

    portfolio_issue_severities: [],
    portfolio_issue_severities_loaded: true,
    portfolioIssueSeveritiesFilter: null,

    portfolio_issues: [],
    portfolio_issues_loaded: true,

   // PORTFOLIO RISKS
    portfolio_risks: [],
    portfolio_risks_loaded: true,

    // Risk Approaches
    portfolio_risk_approaches: [],
    portfolio_risk_approaches_loaded: true,
    portfolioRiskApproachesFilter: null,

    // Risk Priority Levels
    portfolio_risk_priorities: [],
    portfolio_risk_priorities_loaded: true,
    portfolioRiskPrioritiesFilter: null,


    // PORTFOLIO LESSONS
    portfolio_lessons: [],
    portfolio_lessons_loaded: true,

     portfolio_users: [],
    portfolio_users_loaded: true,
    portfolioUsersFilter: null,

    portfolio_statuses: [],
    portfolio_statuses_loaded: true,
    portfolioStatusesFilter: null,

    portfolio_programs_filter: [],
    portfolio_loaded: true,
  

    portfolio_lesson_loaded: true,

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

    portfolio_lesson_stages: [],
    portfolio_lesson_stages_loaded: true,
    portfolioLessonStagesFilter: null,


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
    fetchPortfolioCounts({commit}) {
      commit("TOGGLE_PORTFOLIO_COUNTS_LOADED", false);
      // Send GET request for all lessons contained within a project
      axios({
        method: "GET",
        url: `/api/v1/portfolio/tab_counts`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          // Mutate state with response from back end
          // console.log("port counts" + res.data.tasks_count)
           commit("SET_PORTFOLIO_COUNTS", res.data);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_PORTFOLIO_COUNTS_LOADED", true);
        });
    }, 
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
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_PORTFOLIO_PROGRAMS_LOADED", true);
        });
    },
    fetchAuthorizedPortfolioPrograms({commit}) {
      commit("TOGGLE_AUTHORIZED_PORTFOLIO_PROGRAMS_LOADED", false);
      // Send GET request for all lessons contained within a project
      axios({
        method: "GET",
        url: `/api/v1/filter_data/program_admin_programs`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
         commit("SET_AUTHORIZED_PORTFOLIO_PROGRAMS", res.data.portfolio_filters);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_AUTHORIZED_PORTFOLIO_PROGRAMS_LOADED", true);
        });
    },
    fetchPortfolioCategories({commit}) {
      commit("TOGGLE_PORTFOLIO_CATEGORIES_LOADED", false);
      // Send GET request for all lessons contained within a project
      axios({
        method: "GET",
        url: `/api/v1/filter_data/categories`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          //  console.log("portfoi" + res.data)
          // Mutate state with response from back end      
          commit("SET_PORTFOLIO_CATEGORIES", res.data.categories);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_PORTFOLIO_CATEGORIES_LOADED", true);
        });
    },
    fetchPortfolioAssignees({commit}) {
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
          console.log("Error",err);
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
          console.log("Error",err);
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
          // console.log(res.data)
           // Mutate state with response from back end   
          commit("SET_PORTFOLIO_TASK_STAGES", res.data);
        })
        .catch((err) => {
          console.log("Error",err);
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
        commit("SET_PORTFOLIO_ISSUE_STAGES", res.data);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_PORTFOLIO_ISSUE_STAGES_LOADED", true);
        });
    },
    fetchPortfolioIssueSeverities({commit}) {
      commit("TOGGLE_PORTFOLIO_ISSUE_SEVERITIES_LOADED", false);
      // Send GET request for all lessons contained within a project
      axios({
        method: "GET",
        url: `/api/v1/filter_data/issue_severities.json`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          // Mutate state with response from back end    
        commit("SET_PORTFOLIO_ISSUE_SEVERITIES", res.data.issue_severities);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_PORTFOLIO_ISSUE_SEVERITIES_LOADED", true);
        });
    },
    fetchPortfolioIssueTypes({commit}) {
      commit("TOGGLE_PORTFOLIO_ISSUE_TYPES_LOADED", false);
      // Send GET request for all lessons contained within a project
      axios({
        method: "GET",
        url: `/api/v1/filter_data/issue_types.json`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          // Mutate state with response from back end    
        commit("SET_PORTFOLIO_ISSUE_TYPES", res.data.issue_types);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_PORTFOLIO_ISSUE_TYPES_LOADED", true);
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
          commit("SET_PORTFOLIO_RISK_STAGES", res.data);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_PORTFOLIO_RISK_STAGES_LOADED", true);
        });
    },
    fetchPortfolioRiskApproaches({commit}) {
      commit("TOGGLE_PORTFOLIO_RISK_APPROACHES_LOADED", false);
      // Send GET request for all lessons contained within a project
      axios({
        method: "GET",
        url: `/api/v1/filter_data/risk_approaches.json`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
        // Mutate state with response from back end    
          commit("SET_PORTFOLIO_RISK_APPROACHES", res.data.risk_approaches);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_PORTFOLIO_RISK_APPROACHES_LOADED", true);
        });
    },
    fetchPortfolioRiskPriorities({commit}) {
      commit("TOGGLE_PORTFOLIO_RISK_PRIORITIES_LOADED", false);
      // Send GET request for all lessons contained within a project
      axios({
        method: "GET",
        url: `/api/v1/filter_data/risk_priority_level.json`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
        // Mutate state with response from back end    
        // console.log( res.data.risk_approaches)
          commit("SET_PORTFOLIO_RISK_PRIORITIES", res.data.risk_priorities);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_PORTFOLIO_RISK_PRIORITIES_LOADED", true);
        });
    },
    fetchPortfolioTasks({commit}, {page}) {
        commit("TOGGLE_PORTFOLIO_TASKS_LOADED", false);
        // Send GET request for all lessons contained within a project
        axios({
          method: "GET",
          url: `/api/v1/portfolio/tasks?pagination=true&page=${page}&per_page=3000`,
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
            console.log("Error",err);
          })
          .finally(() => {
            commit("TOGGLE_PORTFOLIO_TASKS_LOADED", true);
          });
      },  
     fetchPortfolioTask({commit}, { id, programId, projectId } ) {
        commit("TOGGLE_PORTFOLIO_TASK_LOADED", false);
        // Send GET request for all lessons contained within a project
        axios({
          method: "GET",
          url: `/api/v1/programs/${programId}/projects/${projectId}/tasks/${id}.json`,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((res) => {
            // Mutate state with response from back end
            // console.log(res.data.task)
             commit("SET_PORTFOLIO_TASK", res.data.task);
          })
          .catch((err) => {
            console.log("Error",err);
          })
          .finally(() => {
            commit("TOGGLE_PORTFOLIO_TASK_LOADED", true);
          });
      },  
    fetchPortfolioIssues({commit}, { page }) {
        commit("TOGGLE_PORTFOLIO_ISSUES_LOADED", false);
        // Send GET request for all lessons contained within a project
        axios({
          method: "GET",
          url: `/api/v1/portfolio/issues?pagination=true&page=${page}&per_page=3000`,
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
            console.log("Error",err);
          })
          .finally(() => {
            commit("TOGGLE_PORTFOLIO_ISSUES_LOADED", true);
          });
      },  
      fetchPortfolioIssue({commit}, { id, programId, projectId } ) {
        commit("TOGGLE_PORTFOLIO_ISSUE_LOADED", false);
        // Send GET request for all issues contained within a project
        axios({
          method: "GET",
          url: `/api/v1/programs/${programId}/projects/${projectId}/issues/${id}.json`,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((res) => {
            // Mutate state with response from back end
            // console.log(res.data.issue)
             commit("SET_PORTFOLIO_ISSUE", res.data.issue);
          })
          .catch((err) => {
            console.log("Error",err);
          })
          .finally(() => {
            commit("TOGGLE_PORTFOLIO_ISSUE_LOADED", true);
          });
      },  
      fetchPortfolioRisks({commit}, { page }) {
        commit("TOGGLE_PORTFOLIO_RISKS_LOADED", false);
        // Send GET request for all lessons contained within a project
        axios({
          method: "GET",
          url: `/api/v1/portfolio/risks?pagination=true&page=${page}&per_page=3000`,
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
            console.log("Error",err);
          })
          .finally(() => {
            commit("TOGGLE_PORTFOLIO_RISKS_LOADED", true);
          });
       },
       fetchPortfolioRisk({commit}, { id, programId, projectId } ) {
        commit("TOGGLE_PORTFOLIO_RISK_LOADED", false);
        // Send GET request for all risks contained within a project
        axios({
          method: "GET",
          url: `/api/v1/programs/${programId}/projects/${projectId}/risks/${id}.json`,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((res) => {
            // Mutate state with response from back end
            // console.log(res.data.risk)
             commit("SET_PORTFOLIO_RISK", res.data.risk);
          })
          .catch((err) => {
            console.log("Error",err);
          })
          .finally(() => {
            commit("TOGGLE_PORTFOLIO_RISK_LOADED", true);
          });
      },  
       fetchPortfolioLessons({commit}, { page }) {
        commit("TOGGLE_PORTFOLIO_LESSONS_LOADED", false);
        // Send GET request for all lessons contained within a project
        axios({
          method: "GET",
          url: `/api/v1/portfolio/lessons?pagination=true&page=${page}&per_page=2000`,
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
            console.log("Error",err);
          })
          .finally(() => {
            commit("TOGGLE_PORTFOLIO_LESSONS_LOADED", true);
          });
       },
       fetchPortfolioLesson({commit}, { id, programId, projectId } ) {
        commit("TOGGLE_PORTFOLIO_LESSON_LOADED", false);
        // Send GET request for all risks contained within a project
        axios({
          method: "GET",
          url: `/api/v1/programs/${programId}/projects/${projectId}/lessons/${id}.json`,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((res) => {
            // Mutate state with response from back end
         
             commit("SET_PORTFOLIO_LESSON", res.data.lesson);
          })
          .catch((err) => {
            console.log("Error",err);
          })
          .finally(() => {
            commit("TOGGLE_PORTFOLIO_LESSON_LOADED", true);
          });
      }, 
      fetchPortfolioLessonStages({commit}) {
        commit("TOGGLE_PORTFOLIO_LESSON_STAGES_LOADED", false);
        // Send GET request for all lessons contained within a project
        axios({
          method: "GET",
          url: `/api/v1/filter_data/stages.json?resource=lesson`,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((res) => {
          // Mutate state with response from back end    
            commit("SET_PORTFOLIO_LESSON_STAGES", res.data);
          })
          .catch((err) => {
            console.log("Error",err);
          })
          .finally(() => {
            commit("TOGGLE_PORTFOLIO_LESSON_STAGES_LOADED", true);
          });
      },
  },
  mutations: {
    setPortfolioWatchedTasksToggle: (state, showAll) => state.portfolioWatchedTasksToggle = showAll,
    setPortfolioImportantTasksToggle: (state, showAll) => state.portfolioImportantTasksToggle = showAll,
    setPortfolioBriefedTasksToggle: (state, showAll) => state.portfolioBriefedTasksToggle = showAll,
    setShowCount: (state, count) => state.showCount = count,

    setPortfolioTab: (state, tab) => state.portfolio_tab = tab,
    setCurrTab: (state, tab) => state.curr_tab = tab, 
    updateProgramFilterValue: (state, value) =>  state.programNameFilter = value,

    setFacilityProjectIds: (state, value) => state.facility_project_ids = value,

    SET_PORTFOLIO_PROGRAMS_FILTER: (state, portfolio_programs_filter) => state.portfolio_programs_filter = portfolio_programs_filter,
    TOGGLE_PORTFOLIO_PROGRAMS_FILTER_LOADED: (state, loaded ) => state.portfolio_programs_filter_loaded = loaded,

    
    SET_AUTHORIZED_PORTFOLIO_PROGRAMS: (state, authorized_portfolio_programs) => state.authorized_portfolio_programs = authorized_portfolio_programs,
    TOGGLE_AUTHORIZED_PORTFOLIO_PROGRAMS_LOADED: (state, loaded ) => state.authorized_portfolio_programs_loaded = loaded,

    setCurrentPage: (state, value) => state.current_page = value,
    setCurrentIssuePage: (state, value) => state.current_issue_page = value,
    setCurrentRiskPage: (state, value) => state.current_risk_page = value,
    setCurrentLessonPage: (state, value) => state.current_lesson_page = value,
  
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


    //PORTFOLIO RISKS
    SET_PORTFOLIO_RISK_APPROACHES: (state, portfolio_risk_approaches) => state.portfolio_risk_approaches = portfolio_risk_approaches,
    TOGGLE_PORTFOLIO_RISK_APPROACHES_LOADED: (state, loaded ) => state.portfolio_risk_approaches_loaded = loaded,   
    setPortfolioRiskApproachesFilter: (state, portfolioRiskApproachesFilter) => state.portfolioRiskApproachesFilter = portfolioRiskApproachesFilter,

    SET_PORTFOLIO_RISK_PRIORITIES: (state, portfolio_risk_priorities) => state.portfolio_risk_priorities = portfolio_risk_priorities,
    TOGGLE_PORTFOLIO_RISK_PRIORITIES_LOADED: (state, loaded ) => state.portfolio_risk_priorities_loaded = loaded,   
    setPortfolioRiskPrioritiesFilter: (state, portfolioRiskPrioritiesFilter) => state.portfolioRiskPrioritiesFilter = portfolioRiskPrioritiesFilter,

    SET_PORTFOLIO_RISK_STAGES: (state, portfolio_risk_stages) => state.portfolio_risk_stages = portfolio_risk_stages,
    TOGGLE_PORTFOLIO_RISK_STAGES_LOADED: (state, loaded ) => state.portfolio_risk_stages_loaded = loaded,   
    setPortfolioRiskStagesFilter: (state, portfolioRiskStagesFilter) => state.portfolioRiskStagesFilter = portfolioRiskStagesFilter,

    SET_PORTFOLIO_LESSON_STAGES: (state, portfolio_lesson_stages) => state.portfolio_lesson_stages = portfolio_lesson_stages,
    TOGGLE_PORTFOLIO_LESSON_STAGES_LOADED: (state, loaded ) => state.portfolio_lesson_stages_loaded = loaded,   
    TOGGLE_PORTFOLIO_LESSON_LOADED: (state, loaded ) => state.portfolio_lesson_loaded = loaded,   
    setPortfolioLessonStagesFilter: (state, portfolioLessonStagesFilter) => state.portfolioLessonStagesFilter = portfolioLessonStagesFilter,

    SET_PORTFOLIO_CATEGORIES: (state, portfolio_categories) => state.portfolio_categories = portfolio_categories,
    TOGGLE_PORTFOLIO_CATEGORIES_LOADED: (state, loaded ) => state.portfolio_categories_loaded = loaded,  

    // PORTFOLIO COUNTS
    SET_PORTFOLIO_COUNTS: (state, portfolio_counts) => state.portfolio_counts = portfolio_counts,
    TOGGLE_PORTFOLIO_COUNTS_LOADED: (state, loaded ) => state.portfolio_counts_loaded = loaded,

    // PORTFOLIO TASKS
    SET_PORTFOLIO_TASKS: (state, portfolio_tasks) => state.portfolio_tasks = portfolio_tasks, 
    TOGGLE_PORTFOLIO_TASKS_LOADED: (state, loaded ) => state.portfolio_tasks_loaded = loaded,

    SET_PORTFOLIO_TASK: (state, portfolio_task) => state.portfolio_task = portfolio_task,
    TOGGLE_PORTFOLIO_TASK_LOADED: (state, loaded ) => state.portfolio_task_loaded = loaded,

    // PORTFOLIO ISSUES
    SET_PORTFOLIO_ISSUES: (state, portfolio_issues) => state.portfolio_issues = portfolio_issues,
    TOGGLE_PORTFOLIO_ISSUES_LOADED: (state, loaded ) => state.portfolio_issues_loaded = loaded,


    SET_PORTFOLIO_ISSUE: (state, portfolio_issue) => state.portfolio_issue = portfolio_issue,
    TOGGLE_PORTFOLIO_ISSUE_LOADED: (state, loaded ) => state.portfolio_issue_loaded = loaded,

    SET_PORTFOLIO_ISSUE_TYPES: (state, portfolio_issue_types) => state.portfolio_issue_types = portfolio_issue_types,
    TOGGLE_PORTFOLIO_ISSUE_TYPES_LOADED: (state, loaded ) => state.portfolio_issue_types_loaded = loaded,   
    setPortfolioIssueTypesFilter: (state, portfolioIssueTypesFilter) => state.portfolioIssueTypesFilter = portfolioIssueTypesFilter,


    SET_PORTFOLIO_ISSUE_SEVERITIES: (state, portfolio_issue_severities) => state.portfolio_issue_severities = portfolio_issue_severities,
    TOGGLE_PORTFOLIO_ISSUE_SEVERITIES_LOADED: (state, loaded ) => state.portfolio_issue_severities_loaded = loaded,   
    setPortfolioIssueSeveritiesFilter: (state, portfolioIssueSeveritiesFilter) => state.portfolioIssueSeveritiesFilter = portfolioIssueSeveritiesFilter,


    // PORTFOLIO RISKS
    SET_PORTFOLIO_RISKS: (state, portfolio_risks) => state.portfolio_risks = portfolio_risks,
    SET_PORTFOLIO_RISK: (state, portfolio_risk) => state.portfolio_risk = portfolio_risk,
    TOGGLE_PORTFOLIO_RISKS_LOADED: (state, loaded ) => state.portfolio_risks_loaded = loaded,
    TOGGLE_PORTFOLIO_RISK_LOADED: (state, loaded ) => state.portfolio_risk_loaded = loaded,

    SET_PORTFOLIO_LESSONS: (state, portfolio_lessons) => state.portfolio_lessons = portfolio_lessons,    
    SET_PORTFOLIO_LESSON: (state, portfolio_lesson) => state.portfolio_lesson = portfolio_lesson,
    TOGGLE_PORTFOLIO_LESSONS_LOADED: (state, loaded ) => state.portfolio_lessons_loaded = loaded,
    TOGGLE_PORTFOLIO_LESSON_LOADED: (state, loaded ) => state.portfolio_lesson_loaded = loaded,

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

    portfolioTab: state => state.portfolio_tab, 
    currTab: state => state.curr_tab,

    portfolioPrograms: state => state.portfolio_programs, 
    portfolioProgramsLoaded: state => state.portfolio_programs_loaded,

    facility_project_ids: state => state.facility_project_ids, 

    currentTaskPage: state => state.current_page, 
    currentIssuePage: state => state.current_issue_page, 
    currentRiskPage: state => state.current_risk_page, 
    currentLessonPage: state => state.current_lesson_page, 

    // GETTER FOR PORTFOLIO USERS
    portfolioUsers: state => state.portfolio_users, 
    portfolioUsersLoaded: state => state.portfolio_users_loaded,
    portfolioUsersFilter: state => state.portfolioUsersFilter,

    portfolioCategories: state => state.portfolio_categories,    
    portfolioLessonStages: state => state.portfolio_lesson_stages, 
    portfolioCategoriesLoaded: state => state.portfolio_categories_loaded,

    // GETTER FOR PORTFOLIO STAGES
    portfolioTaskStages: state => state.portfolio_task_stages, 
    portfolioTaskStagesLoaded: state => state.portfolio_task_stages_loaded,
    portfolioTaskStagesFilter: state => state.portfolioTaskStagesFilter,

    portfolioIssueStages: state => state.portfolio_issue_stages, 
    portfolioIssueStagesLoaded: state => state.portfolio_issue_stages_loaded,
    portfolioIssueStagesFilter: state => state.portfolioIssueStagesFilter,

    portfolioIssueTypes: state => state.portfolio_issue_types, 
    portfolioIssueTypesLoaded: state => state.portfolio_issue_types_loaded,
    portfolioIssueTypesFilter: state => state.portfolioIssueTypesFilter,

    portfolioIssueSeverities: state => state.portfolio_issue_severities, 
    portfolioIssueSeveritiesLoaded: state => state.portfolio_issue_severities_loaded,
    portfolioIssueSeveritiesFilter: state => state.portfolioIssueSeveritiesFilter,


    // GETTER FOR PORTFOLIO RISKS
    portfolioRiskStages: state => state.portfolio_risk_stages, 
    portfolioRiskStagesLoaded: state => state.portfolio_risk_stages_loaded,
    portfolioRiskStagesFilter: state => state.portfolioRiskStagesFilter,

    portfolioLessonStagesLoaded: state => state.portfolio_lesson_stages_loaded,
    portfolioLessonStagesFilter: state => state.portfolioLessonStagesFilter,



    portfolioRiskApproaches: state => state.portfolio_risk_approaches, 
    portfolioRiskApproachesLoaded: state => state.portfolio_risk_approaches_loaded,
    portfolioRiskApproachesFilter: state => state.portfolioRiskApproachesFilter,

    portfolioRiskPriorities: state => state.portfolio_risk_priorities, 
    portfolioRiskPrioritiesLoaded: state => state.portfolio_risk_priorities_loaded,
    portfolioRiskPrioritiesFilter: state => state.portfolioRiskPrioritiesFilter,


    // GETTER FOR PORTFOLIO STATUSES

    portfolioStatuses: state => state.portfolio_statuses, 
    portfolioStatusesLoaded: state => state.portfolio_statuses_loaded,
    portfolioStatusesFilter: state => state.portfolioStatusesFilter,

    portfolioCounts: state => state.portfolio_counts,
    portfolioCountsLoaded: state => state.portfolio_counts_loaded,


    portfolioProgramsFilter: state => state.portfolio_programs_filter, 
    portfolioProgramsFilterLoaded: state => state.portfolio_programs_filter_loaded,

    
    authorizedPortfolioPrograms: state => state.authorized_portfolio_programs, 
    authorizedPortfolioProgramsLoaded: state => state.authorized_portfolio_programs_loaded,


    portfolioTasks: state => state.portfolio_tasks,
    portfolioTask: state => state.portfolio_task,
    portfolioTaskLoaded: state => state.portfolio_task_loaded,
    portfolioTasksLoaded: state => state.portfolio_tasks_loaded,

    portfolioIssues: state => state.portfolio_issues,
    portfolioIssue: state => state.portfolio_issue,
    portfolioIssuesLoaded: state => state.portfolio_issues_loaded,
    portfolioIssueLoaded: state => state.portfolio_issue_loaded,

    portfolioRisks: state => state.portfolio_risks,
    portfolioRisk: state => state.portfolio_risk,
    portfolioRisksLoaded: state => state.portfolio_risks_loaded,
    portfolioRiskLoaded: state => state.portfolio_risk_loaded,

    portfolioLessons: state => state.portfolio_lessons,
    portfolioLesson: state => state.portfolio_lesson,
    portfolioLessonsLoaded: state => state.portfolio_lessons_loaded,

    portfolioLessonLoaded: state => state.portfolio_lesson_loaded,

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