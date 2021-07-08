// import axios from "axios";

const portfolioModule = {
  state: () => ({
    portfolioWatchedTasksToggle: true,
    portfolioBriefedTasksToggle: true,
    portfolioImportantTasksToggle: true,
    portfolioPrograms: new Array,
  }),
  actions: {
   
  
  },
  mutations: {
    setPortfolioWatchedTasksToggle: (state, showAll) => state.portfolioWatchedTasksToggle = showAll,
    setPortfolioImportantTasksToggle: (state, showAll) => state.portfolioImportantTasksToggle = showAll,
    setPortfolioBriefedTasksToggle: (state, showAll) => state.portfolioBriefedTasksToggle = showAll,
    setPortfolioPrograms: (state, portfolioPrograms) => state.portfolioPrograms = portfolioPrograms,
  },
  getters: {
    getPortfolioWatchedTasksToggle: state => state.portfolioWatchedTasksToggle,
    getPortfolioImportantTasksToggle: state => state.portfolioImportantTasksToggle,
    getPortfolioBriefedTasksToggle: state => state.portfolioBriefedTasksToggle, 
    getPortfolioPrograms: state => state.portfolioPrograms, 
  },
};


export default portfolioModule;
