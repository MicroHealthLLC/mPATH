import axios from "axios";
import {API_BASE_PATH} from './../../mixins/utils'
const formData = new FormData();
const effortStore = {
    state: () => ({

      //Program Level Effort
      program_efforts: [],
      program_efforts_status: 0,
      program_efforts_loaded: true,

      program_task_effort: [],
      program_task_effort_status: 0,
      program_task_effort_loaded: true,

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
      commit("TOGGLE_EFFORTS_LOADED", false);  
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/programs/${programId}/projects/${projectId}/efforts`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_EFFORTS", res.data.efforts);
          commit("SET_EFFORTS_STATUS", res.status);
          console.log(res.data)
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_EFFORTS_LOADED", true);
        });
    },
    fetchProgramEfforts({ commit },  {programId, date}) {
      commit("TOGGLE_PROGRAM_EFFORTS_LOADED", false);    
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
          commit("SET_PROGRAM_EFFORTS", res.data.efforts);
          console.log(res.data)
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_PROGRAM_EFFORTS_LOADED", true);
        });
    },
    fetchProgramEffortReport({ commit },  {programId, date}) {
      commit("TOGGLE_PROGRAM_TASK_EFFORT_LOADED", false);    
  //  console.log(programId)
      axios({
        method: "GET",
        url:  `${API_BASE_PATH}/programs/project_efforts/${programId}`,
        params:  {
                 program_id:  programId,         
                 date_of_week: date,
                 filter_by: 'project'           
                },
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_PROGRAM_TASK_EFFORT", res.data.efforts);
          console.log(res.data.efforts)
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_PROGRAM_TASK_EFFORT_LOADED", true);
        });
    },


      //Create Individual Effort
    createEffort({ commit }, { effortData }) {
      commit("TOGGLE_EFFORTS_LOADED", false);
      
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
          // commit("SET_EFFORT", res.data.effort);
          commit("SET_EFFORTS", res.data.efforts);       
          console.log(res)
          commit("SET_EFFORT_STATUS", res.status);
          commit("SET_EFFORTS_STATUS", res.status);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_EFFORTS_LOADED", true);
        });
    },
       // Date of eek query oming from Program Level User Report
       fetchDateOfWeekQuery({ commit }, { programId, date } ) {
        console.log(programId, date)
        commit("TOGGLE_EFFORTS_LOADED", false);      
        axios({
          method: "GET",
          url: `${API_BASE_PATH}/programs/project_efforts/${programId}?program_id=${programId}&date_of_week=${date}`,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((res) => {
            commit("SET_EFFORTS", res.data.efforts);
            commit("SET_WEEK_QUERY_STATUS", res.status);
            console.log(res.data)
          })
          .catch((err) => {
            console.log("Error",err);
          })
          .finally(() => {
            commit("TOGGLE_EFFORTS_LOADED", true);
          });
      },

    //Update Individual Effort
    updateEffort({ commit }, {  effortData }) {
      commit("TOGGLE_EFFORT_LOADED", false);
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
          commit("SET_EFFORT", res.data.efforts);
           commit("SET_EFFORTS", res.data.efforts);          
        commit("SET_EFFORT_STATUS", res.status);
          commit("SET_EFFORTS_STATUS", res.status);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_EFFORT_LOADED", true);
        });
      },
    },
    mutations: {

      //Program Efforts
      SET_PROGRAM_EFFORTS: (state, value) => (state.program_efforts = value),
      SET_PROGRAM_EFFORTS_STATUS: (state, status) => (state.program_efforts_status = status), 
      TOGGLE_PROGRAM_EFFORTS_LOADED: (state, loaded) => (state.program_efforts_loaded = loaded),

      //Program Task Effort Report
      SET_PROGRAM_TASK_EFFORT: (state, value) => (state.program_task_effort = value),
      SET_PROGRAM_TASK_EFFORT_STATUS: (state, status) => (state.program_task_effort_status = status), 
      TOGGLE_PROGRAM_TASK_EFFORT_LOADED: (state, loaded) => (state.program_task_effort_loaded = loaded),

      //Individual Efforts
      SET_EFFORT: (state, value) => (state.effort = value),
      SET_EFFORT_STATUS: (state, status) => (state.effort_status = status), 
      TOGGLE_EFFORT_LOADED: (state, loaded) => (state.effort_loaded = loaded),

      //All Efforts
      SET_EFFORTS: (state, value) => (state.efforts = value),
      SET_EFFORTS_STATUS: (state, status) => (state.efforts_status = status), 
      TOGGLE_EFFORTS_LOADED: (state, loaded) => (state.efforts_loaded = loaded),

      SET_WEEK_QUERY_STATUS: (state, status) => (state.week_query_status = status), 



    },
    getters: {
     //Individual Efforts  
     effort: (state) => state.effort, 
     effortLoaded: (state) => state.effort_loaded,
     effortStatus: (state) => state.effort_status,


     //All Efforts
     efforts: (state) => state.efforts, 
     effortsStatus: (state) => state.efforts_status,
     effortsLoaded: (state) => state.efforts_loaded,

     //Program Efforts
     programEfforts: (state) => state.program_efforts,
     programEffortsStatus: (state) => state.program_efforts_status,
     programEffortsLoaded: (state) => state.program_efforts_loaded,

      //Program Efforts
     programTaskEffort: (state) => state.program_task_effort,
     programTaskEffortStatus: (state) => state.program_task_effort_status,
     programTaskEffortLoaded: (state) => state.program_task_effort_loaded,

    weekQueryStatus: (state) => state.week_query_status
    },
  };
  
  export default effortStore;