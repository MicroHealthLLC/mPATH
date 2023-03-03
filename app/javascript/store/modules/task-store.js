import axios from "axios";
import {API_BASE_PATH} from './../../mixins/utils'
const formData = new FormData();
const taskStore = {
    state: () => ({

      //Program Level Effort
      program_efforts: [],
      program_efforts_status: 0,
      program_efforts_loaded: true,

      //All efforts
      efforts: [],
      efforts_status: 0,
      efforts_loaded: true,

      //Individual efforts
      effort: {},
      effort_status: 0,
      effort_loaded: true,

      week_query_status: 0,
    }),
    actions: {
    // Get  All Efforts
    fetchEfforts({ commit }, { programId, projectId } ) {
      commit("TOGGLE_TIMESHEETS_LOADED", false);      


      axios({
        method: "GET",
        url: `${API_BASE_PATH}/programs/${programId}/projects/${projectId}/efforts`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_TIMESHEETS", res.data.efforts);
          commit("SET_TIMESHEETS_STATUS", res.status);
          console.log(res.data)
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_TIMESHEETS_LOADED", true);
        });
    },
    fetchProgramEfforts({ commit },  {programId, date}) {
      commit("TOGGLE_PROGRAM_TIMESHEETS_LOADED", false);    
  //  console.log(programId)
      axios({
        method: "GET",
        url:  `${API_BASE_PATH}/programs/project_efforts/${programId}`,
        params:  {
                 program_id:  programId,         
                 date_of_week: date          
                },
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_PROGRAM_TIMESHEETS", res.data.efforts);
          console.log(res.data)
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_PROGRAM_TIMESHEETS_LOADED", true);
        });
    },

      //Create Individual Effort
    createEffort({ commit }, { effortData }) {
      commit("TOGGLE_TIMESHEET_LOADED", false);
      
      console.log(effortData)
        formData.append("effort[hours]",  effortData.hours);
        formData.append("effort[date_of_week]",  effortData.week);
        formData.append("effort[task_id]",  effortData.taskId);
        formData.append("effort[user_id]",  effortData.userId);   
       
      axios({
        method: "POST",
        url: `${API_BASE_PATH}/programs/${effortData.programId}/projects/${effortData.projectId}/efforts`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          console.log(res.status)
          commit("SET_TIMESHEET", res.data.effort);
          commit("SET_TIMESHEETS", res.data.efforts);       
          console.log(res)
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
       // Date of eek query oming from Program Level User Report
       fetchDateOfWeekQuery({ commit }, { programId, date } ) {
        console.log(programId, date)
        commit("TOGGLE_TIMESHEETS_LOADED", false);      
        axios({
          method: "GET",
          url: `${API_BASE_PATH}/programs/project_efforts/${programId}?program_id=${programId}&date_of_week=${date}`,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((res) => {
            commit("SET_TIMESHEETS", res.data.efforts);
            commit("SET_WEEK_QUERY_STATUS", res.status);
            console.log(res.data)
          })
          .catch((err) => {
            console.log(err);
          })
          .finally(() => {
            commit("TOGGLE_TIMESHEETS_LOADED", true);
          });
      },

    //Update Individual Effort
    updateEffort({ commit }, {  effortData }) {
      commit("TOGGLE_TIMESHEET_LOADED", false);
      formData.append("effort[hours]",  effortData.hours);
      formData.append("effort[date_of_week]",  effortData.week);
      formData.append("effort[task_id]",  effortData.taskId);
      formData.append("effort[user_id]",  effortData.userId);     
        axios({
          method: "PUT",
          url: `${API_BASE_PATH}/programs/${effortData.programId}/projects/${effortData.projectId}/efforts/${effortData.id}`,
          data: formData,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
        .then((res) => {
          commit("SET_TIMESHEET", res.data.efforts);
           commit("SET_TIMESHEETS", res.data.efforts);          
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

      //Program Efforts
      SET_PROGRAM_TIMESHEETS: (state, value) => (state.program_efforts = value),
      SET_PROGRAM_TIMESHEETS_STATUS: (state, status) => (state.program_efforts_status = status), 
      TOGGLE_PROGRAM_TIMESHEETS_LOADED: (state, loaded) => (state.program_efforts_loaded = loaded),

      //Individual Efforts
      SET_TIMESHEET: (state, value) => (state.effort = value),
      SET_TIMESHEET_STATUS: (state, status) => (state.effort_status = status), 
      TOGGLE_TIMESHEET_LOADED: (state, loaded) => (state.effort_loaded = loaded),

      //All Efforts
      SET_TIMESHEETS: (state, value) => (state.efforts = value),
      SET_TIMESHEETS_STATUS: (state, status) => (state.efforts_status = status), 
      TOGGLE_TIMESHEETS_LOADED: (state, loaded) => (state.efforts_loaded = loaded),

      SET_WEEK_QUERY_STATUS: (state, status) => (state.week_query_status = status), 



    },
    getters: {
     //Individual Efforts  
     timeSheet: (state) => state.effort, 
     timeSheetLoaded: (state) => state.effort_loaded,
     timeSheetStatus: (state) => state.effort_status,


     //All Efforts
     efforts: (state) => state.efforts, 
     timeSheetsStatus: (state) => state.efforts_status,
     timeSheetsLoaded: (state) => state.efforts_loaded,

     //Program Efforts
     programEfforts: (state) => state.program_efforts,
     programEffortsStatus: (state) => state.program_efforts_status,
     programTimeSheetsLoaded: (state) => state.program_efforts_loaded,

    weekQueryStatus: (state) => state.week_query_status
    },
  };
  
  export default taskStore;
  