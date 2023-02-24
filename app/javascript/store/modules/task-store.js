import axios from "axios";
import {API_BASE_PATH} from './../../mixins/utils'
const formData = new FormData();
const taskStore = {
    state: () => ({

      //All timesheets
      timesheets: [],
      timesheets_status: 0,
      timesheets_loaded: true,

      //Individual timesheets
      timesheet: {},
      timesheet_status: 0,
      timesheet_loaded: true,
    }),
    actions: {
    // Get  All Timesheets
    fetchTimesheets({ commit }, { programId, projectId } ) {
      commit("TOGGLE_TIMESHEETS_LOADED", false);      
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/programs/${programId}/projects/${projectId}/timesheets`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_TIMESHEETS", res.data.timesheets);
          console.log(res.data)
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_TIMESHEETS_LOADED", true);
        });
    },

      //Create Individual Timesheet
    createTimesheet({ commit }, { timesheetData }) {
      commit("TOGGLE_TIMESHEET_LOADED", false);
      
      console.log(timesheetData)
        formData.append("timesheet[hours]",  timesheetData.hours);
        formData.append("timesheet[date_of_week]",  timesheetData.week);
        formData.append("timesheet[task_id]",  timesheetData.taskId);
        formData.append("timesheet[user_id]",  timesheetData.userId);   
       
      axios({
        method: "POST",
        url: `${API_BASE_PATH}/programs/${timesheetData.programId}/projects/${timesheetData.projectId}/timesheets`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          console.log(res.status)
          commit("SET_TIMESHEET", res.data.timesheets);
          commit("SET_TIMESHEETS", res.data.timesheets);          
          commit("SET_TIMESHEET_STATUS", res.status);
          commit("SET_TIMESHEETS_STATUS", res.status);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_TIMESHEET_LOADED", true);
        });
    },

    //Update Individual Timesheet
    updateTimesheet({ commit }, {  timesheetData }) {
      commit("TOGGLE_TIMESHEET_LOADED", false);
      // let formData = new FormData();
      formData.append("timesheet[hours]",  timesheetData.hours);
      formData.append("timesheet[date_of_week]",  timesheetData.week);
      formData.append("timesheet[task_id]",  timesheetData.taskId);
      formData.append("timesheet[user_id]",  timesheetData.userId);   
  
        axios({
          method: "PUT",
          url: `${API_BASE_PATH}/programs/${timesheetData.programId}/projects/${timesheetData.projectId}/timesheets/${timesheetId}`,
          data: formData,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
        .then((res) => {
          commit("SET_TIMESHEET", res.data.timesheets);
          commit("SET_TIMESHEETS", res.data.timesheets);          
          commit("SET_TIMESHEET_STATUS", res.status);
          commit("SET_TIMESHEETS_STATUS", res.status);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_TIMESHEET_LOADED", true);
        });
      },
    },
    mutations: {
      //Individual Timesheets
      SET_TIMESHEET: (state, value) => (state.timesheet = value),
      SET_TIMESHEET_STATUS: (state, status) => (state.timesheet_status = status), 
      TOGGLE_TIMESHEET_LOADED: (state, loaded) => (state.timesheet_loaded = loaded),

      //All Timesheets
      SET_TIMESHEETS: (state, value) => (state.timesheets = value),
      SET_TIMESHEETS_STATUS: (state, status) => (state.timesheets_status = status), 
      TOGGLE_TIMESHEETS_LOADED: (state, loaded) => (state.timesheets_loaded = loaded),

    },
    getters: {
     //Individual Timesheets  
     timeSheet: (state) => state.timesheet, 
     timeSheetLoaded: (state) => state.timesheet_loaded,
     timeSheetStatus: (state) => state.timesheet_status,


     //All Timesheets
     timesheets: (state) => state.timesheets, 
     timeSheetsStatus: (state) => state.timesheets_status,
     timeSheetsLoaded: (state) => state.timesheets_loaded,

    },
  };
  
  export default taskStore;
  