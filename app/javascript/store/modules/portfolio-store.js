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
  
  },
  mutations: {
    setPortfolioWatchedTasksToggle: (state, showAll) => state.portfolioWatchedTasksToggle = showAll,
    setPortfolioImportantTasksToggle: (state, showAll) => state.portfolioImportantTasksToggle = showAll,
    setPortfolioBriefedTasksToggle: (state, showAll) => state.portfolioBriefedTasksToggle = showAll,
    setPortfolioPrograms: (state, portfolioPrograms) => state.portfolioPrograms = portfolioPrograms,
    SET_PORTFOLIO_TASKS: (state, portfolio_tasks) => state.portfolio_tasks = portfolio_tasks,
    TOGGLE_PORTFOLIO_TASKS_LOADED: (state, loaded ) => state.portfolio_tasks_loaded = loaded,
    setProgramNameFilter: (state, filter) => state.programNameFilter = filter,
  },
  getters: {
    getPortfolioWatchedTasksToggle: state => state.portfolioWatchedTasksToggle,
    getPortfolioImportantTasksToggle: state => state.portfolioImportantTasksToggle,
    getPortfolioBriefedTasksToggle: state => state.portfolioBriefedTasksToggle, 
    getPortfolioPrograms: state => state.portfolioPrograms, 
    portfolioTasks: state => state.portfolio_tasks,
    portfolioTasksLoaded: state => state.portfolio_tasks_loaded,
    getProgramNameFilter: state => state.programNameFilter,
  },
};


export default portfolioModule;
