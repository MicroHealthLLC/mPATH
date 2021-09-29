const programStore = {
  state: () => ({
    curr_task_page: 1,
    curr_issue_page: 1,
    curr_risk_page: 1,
    curr_lesson_page: 1,

    curr_program_tab: '#tab-tasks', 

    search_issues: '',
    search_risks: '',
    search_lessons: '',

    tasks_per_page_filter: null,
    risks_per_page_filter: null,
    lessons_per_page_filter: null,
    issues_per_page_filter: null,

    project_groups_filter: null,
    project_group_ids: [], 

    program_categories_filter: null,

  
  }),

  actions: {},
  mutations: {
    setCurrTaskPage: (state, value) => state.curr_task_page = value,
    setCurrIssuePage: (state, value) => state.curr_issue_page = value,
    setCurrRiskPage: (state, value) => state.curr_risk_page = value,
    setCurrLessonPage: (state, value) => state.curr_lesson_page = value,

    setSearchIssues: (state, value) => state.search_issues = value,
    setSearchRisks: (state, value) => state.search_risks = value,
    setSearchLessons: (state, value) => state.search_lessons = value,

    setProgramCategoriesFilter: (state, filter) => state.program_categories_filter = filter,

    setProjectGroupIds:  (state, value) => state.project_group_ids = value,

    setCurrProgramTab: (state, tab) => state.curr_program_tab = tab, 

    setTasksPerPageFilter: (state, filter) => state.tasks_per_page_filter = filter,
    setIssuesPerPageFilter: (state, filter) => state.issues_per_page_filter = filter,
    setRisksPerPageFilter: (state, filter) => state.risks_per_page_filter = filter,
    setLessonsPerPageFilter: (state, filter) => state.lessons_per_page_filter = filter,

    setProjectGroupsFilter: (state, filter) => state.project_groups_filter = filter,
  },

  getters: {
    currTaskPage: state => state.curr_task_page, 
    currIssuePage: state => state.curr_issue_page, 
    currRiskPage: state => state.curr_risk_page, 
    currLessonPage: state => state.curr_lesson_page, 

    searchIssues: state => state.search_issues,
    searchRisks: state => state.search_risks, 
    searchLessons: state => state.search_lessons,  

    programCategoriesFilter: state => state.program_categories_filter, 

    projectGroupsFilter: state => state.project_groups_filter,
    projectGroupIds: state => state.project_group_ids,

    currProgramTab: state => state.curr_program_tab,

    getTasksPerPage: state => state.tasks_per_page_filter,
    getTasksPerPageOptions: (state, getters) => {
      var options = [
        {id: 5, name: '5', value: 5},
        {id: 15, name: '15', value: 15},
        {id: 25, name: '25', value: 25},
        {id: 50, name: '50', value: 50},
        {id: 100, name: '100+', value: 100},
      ]
      return options;
    },
    getIssuesPerPage: state => state.issues_per_page_filter,
    getIssuesPerPageOptions: (state, getters) => {
      var options = [
        {id: 5, name: '5', value: 5},
        {id: 15, name: '15', value: 15},
        {id: 25, name: '25', value: 25},
        {id: 50, name: '50', value: 50},
        {id: 100, name: '100+', value: 100},
      ]
      return options;
    },

    getRisksPerPage: state => state.risks_per_page_filter,
    getRisksPerPageOptions: (state, getters) => {
      var options = [
        {id: 5, name: '5', value: 5},
        {id: 15, name: '15', value: 15},
        {id: 25, name: '25', value: 25},
        {id: 50, name: '50', value: 50},
        {id: 100, name: '100+', value: 100},
      ]
      return options;
    },
    getLessonsPerPage: state => state.lessons_per_page_filter,
    getLessonsPerPageOptions: (state, getters) => {
      var options = [
        {id: 5, name: '5', value: 5},
        {id: 15, name: '15', value: 15},
        {id: 25, name: '25', value: 25},
        {id: 50, name: '50', value: 50},
        {id: 100, name: '100+', value: 100},
      ]
      return options;
    },
  },
};

export default programStore;
