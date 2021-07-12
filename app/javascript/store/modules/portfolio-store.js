import axios from "axios";

const portfolioModule = {
  state: () => ({
    portfolioWatchedTasksToggle: true,
    portfolioBriefedTasksToggle: true,
    portfolioImportantTasksToggle: true,
    portfolioPrograms: null,
    programNameFilter: [],

    portfolio_tasks: [],
    portfolio_tasks_loaded: true,

    portfolio_issues: [],
    portfolio_issues_loaded: true,

    portfolio_risks: [],
    portfolio_risks_loaded: true,
  }),
  actions: {
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
  },
  mutations: {
    setPortfolioWatchedTasksToggle: (state, showAll) => state.portfolioWatchedTasksToggle = showAll,
    setPortfolioImportantTasksToggle: (state, showAll) => state.portfolioImportantTasksToggle = showAll,
    setPortfolioBriefedTasksToggle: (state, showAll) => state.portfolioBriefedTasksToggle = showAll,
    setPortfolioPrograms: (state, portfolioPrograms) => state.portfolioPrograms = portfolioPrograms,

    SET_PORTFOLIO_TASKS: (state, portfolio_tasks) => state.portfolio_tasks = portfolio_tasks,
    TOGGLE_PORTFOLIO_TASKS_LOADED: (state, loaded ) => state.portfolio_tasks_loaded = loaded,

    SET_PORTFOLIO_ISSUES: (state, portfolio_issues) => state.portfolio_issues = portfolio_issues,
    TOGGLE_PORTFOLIO_ISSUES_LOADED: (state, loaded ) => state.portfolio_issues_loaded = loaded,

    SET_PORTFOLIO_RISKS: (state, portfolio_risks) => state.portfolio_risks = portfolio_risks,
    TOGGLE_PORTFOLIO_RISKS_LOADED: (state, loaded ) => state.portfolio_risks_loaded = loaded,
   
    setProgramNameFilter: (state, filter) => state.programNameFilter = filter,
  },
  getters: {
    getPortfolioWatchedTasksToggle: state => state.portfolioWatchedTasksToggle,
    getPortfolioImportantTasksToggle: state => state.portfolioImportantTasksToggle,
    getPortfolioBriefedTasksToggle: state => state.portfolioBriefedTasksToggle, 
    getPortfolioPrograms: state => state.portfolioPrograms, 

    portfolioTasks: state => state.portfolio_tasks,
    portfolioTasksLoaded: state => state.portfolio_tasks_loaded,

    portfolioIssues: state => state.portfolio_issues,
    portfolioIssuesLoaded: state => state.portfolio_issues_loaded,

    portfolioRisks: state => state.portfolio_risks,
    portfolioRisksLoaded: state => state.portfolio_risks_loaded,

    getProgramNameFilter: state => state.programNameFilter,
  },
};


export default portfolioModule;
