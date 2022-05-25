import http from "./../../common/http";
import axios from "axios";
import { API_BASE_PATH } from "./../../mixins/utils";

const contractStore = {


  state: () => ({
    associated_contracts: [],
    associated_contracts_loaded: true,
    associated_contracts_status: 0,

    contract_projects: [],
    contract_projects_loaded: true,
    contract_project_status: 0,
   
  }),

  actions: {
  // GET Contract Project Data  **DONE**
  // GET Vehicles Data
  // GET POC DATA

  // POST (new) Contract Data  **DONE**
  // POST (new) Vehicles Data
  // POST (new) POC Data
  // POST Associate Contract to Program

  // UPDATE Contract Data
  // UPDATE Vehicles
  // UPDATE POC Data

  // DELETE Contract Data
  // DELETE Vehicles Data
  // DELETE POC Data

  // GET REQUESTS
    fetchContractProjects({ commit }) {
      commit("TOGGLE_CONTRACT_PROJECTS_LOADED", false);
   
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/contract_project_data`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT_PROJECTS", res.data.contract_project_data);
          // console.log(res.data.roles)
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACT_PROJECTS_LOADED", true);
        });
    },
    fetchVehiclesData({ commit }, id ) {
      commit("TOGGLE_ROLES_LOADED", false);
   
      axios({
        method: "GET",
        url: ``,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_ROLES", res.data.roles);
          // console.log(res.data.roles)
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_ROLES_LOADED", true);
        });
    },
    fetchPOCData({ commit }, id ) {
      commit("TOGGLE_ROLES_LOADED", false);
   
      axios({
        method: "GET",
        url: ``,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_ROLES", res.data.roles);
          // console.log(res.data.roles)
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_ROLES_LOADED", true);
        });
    },
  // POST REQUESTS
  createContractProject({ commit }, { cProjectData }) {
    commit("TOGGLE_CONTRACT_PROJECT_LOADED", false);
    let formData = new FormData();
    console.log(cProjectData)
      formData.append("contract_project_data[charge_code]", cProjectData.charge_code);
      formData.append("contract_project_data[name]", cProjectData.name)
      formData.append("contract_project_data[contract_customer_id]", cProjectData.contract_customer_id)
      formData.append("contract_project_data[prime_or_sub]", cProjectData.prime_or_sub)
      formData.append("contract_project_data[total_contract_value]", cProjectData.total_contract_value)
      formData.append("contract_project_data[contract_start_date]", cProjectData.contract_start_date)
      formData.append("contract_project_data[contract_end_date]", cProjectData.contract_end_date)
      formData.append("contract_project_data[contract_current_pop_start_date]", cProjectData.contract_current_pop_start_date)
      formData.append("contract_project_data[contract_current_pop_end_date]", cProjectData.contract_current_pop_end_date)
      formData.append("contract_project_data[contract_vehicle_id]", cProjectData.contract_vehicle_id)     
      formData.append("contract_project_data[contract_award_to_id]", cProjectData.contract_award_to_id)
      formData.append("contract_project_data[number]", cProjectData.number)
      formData.append("contract_project_data[contract_type_id]", cProjectData.contract_type_id)
      formData.append("contract_project_data[contract_award_type_id]", cProjectData.contract_award_type_id)
      formData.append("contract_project_data[contract_pop_id]", cProjectData.contract_pop_id)
      formData.append("contract_project_data[contract_current_pop_id]", cProjectData.contract_current_pop_id)
      formData.append("contract_project_data[contract_naic_id]", cProjectData.contract_naic_id)
      
    axios({
      method: "POST",
      url: `${API_BASE_PATH}/contract_project_data`,
      data: formData,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .attributes["content"].value,
      },
    })
      .then((res) => {
        commit("SET_CONTRACT_PROJECTS", res.data.contract_project_data);
        commit("SET_CONTRACT_PROJECT_STATUS", res.status);
      })
      .catch((err) => {
        console.log(err);
      })
      .finally(() => {
        commit("TOGGLE_CONTRACT_PROJECT_LOADED", true);
      });
    },
    newVehiclesData({ commit }, id ) {
    commit("TOGGLE_ROLES_LOADED", false);
 
    axios({
      method: "POST",
      url: ``,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .attributes["content"].value,
      },
    })
      .then((res) => {
        commit("SET_ROLES", res.data.roles);
        // console.log(res.data.roles)
      })
      .catch((err) => {
        console.log(err);
      })
      .finally(() => {
        commit("TOGGLE_ROLES_LOADED", true);
      });
    },
    newPOCData({ commit }, id ) {
    commit("TOGGLE_ROLES_LOADED", false);
 
    axios({
      method: "POST",
      url: ``,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .attributes["content"].value,
      },
    })
      .then((res) => {
        commit("SET_ROLES", res.data.roles);
        // console.log(res.data.roles)
      })
      .catch((err) => {
        console.log(err);
      })
      .finally(() => {
        commit("TOGGLE_ROLES_LOADED", true);
      });
    },
    associateContractToProgram({ commit }, { contract } ) {
      commit("TOGGLE_ASSOCIATED_CONTRACTS_LOADED", false);
   
      axios({
        method: "POST",
        url: `${API_BASE_PATH}/contracts/{${contract.id}/add_contract?project_id=${contract.programId}`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_ASSOCIATED_CONTRACTS", res.data);
          commit("SET_ASSOCIATED_CONTRACTS_STATUS", res.status);
          // console.log(res.data.roles)
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_ASSOCIATED_CONTRACTS_LOADED", true);
        });
      },

  // UPDATE REQUESTS
  updateContractProject({ commit }, { cProjectData, id }) {
    commit("TOGGLE_CONTRACT_PROJECT_LOADED", false);
    let formData = new FormData();
    console.log(cProjectData)
      formData.append("contract_project_data[charge_code]", cProjectData.charge_code);
      formData.append("contract_project_data[name]", cProjectData.name)
      formData.append("contract_project_data[contract_customer_id]", cProjectData.contract_customer_id)
      formData.append("contract_project_data[prime_or_sub]", cProjectData.prime_or_sub)
      formData.append("contract_project_data[total_contract_value]", cProjectData.total_contract_value)
      formData.append("contract_project_data[contract_start_date]", cProjectData.contract_start_date)
      formData.append("contract_project_data[contract_end_date]", cProjectData.contract_end_date)
      formData.append("contract_project_data[contract_current_pop_start_date]", cProjectData.contract_current_pop_start_date)
      formData.append("contract_project_data[contract_current_pop_end_date]", cProjectData.contract_current_pop_end_date)
      formData.append("contract_project_data[contract_vehicle_id]", cProjectData.contract_vehicle_id)     
      formData.append("contract_project_data[contract_award_to_id]", cProjectData.contract_award_to_id)
      formData.append("contract_project_data[number]", cProjectData.number)
      formData.append("contract_project_data[contract_type_id]", cProjectData.contract_type_id)
      formData.append("contract_project_data[contract_award_type_id]", cProjectData.contract_award_type_id)
      formData.append("contract_project_data[contract_pop_id]", cProjectData.contract_pop_id)
      formData.append("contract_project_data[contract_current_pop_id]", cProjectData.contract_current_pop_id)
      formData.append("contract_project_data[contract_naic_id]", cProjectData.contract_naic_id)
      
    axios({
      method: "PUT",
      url: `${API_BASE_PATH}/contract_project_data/${id}`,
      data: formData,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .attributes["content"].value,
      },
    })
      .then((res) => {
        commit("SET_CONTRACT_PROJECTS", res.data.contract_project_data);
        commit("SET_CONTRACT_PROJECT_STATUS", res.status);
      })
      .catch((err) => {
        console.log(err);
      })
      .finally(() => {
        commit("TOGGLE_CONTRACT_PROJECT_LOADED", true);
      });
    },
    updateVehiclesData({ commit }, id ) {
    commit("TOGGLE_ROLES_LOADED", false);
  
    axios({
      method: "PUT",
      url: ``,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .attributes["content"].value,
      },
    })
      .then((res) => {
        commit("SET_ROLES", res.data.roles);
        // console.log(res.data.roles)
      })
      .catch((err) => {
        console.log(err);
      })
      .finally(() => {
        commit("TOGGLE_ROLES_LOADED", true);
      });
    },
    updatePOCData({ commit }, id ) {
    commit("TOGGLE_ROLES_LOADED", false);
  
    axios({
      method: "PUT",
      url: ``,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .attributes["content"].value,
      },
    })
      .then((res) => {
        commit("SET_ROLES", res.data.roles);
        // console.log(res.data.roles)
      })
      .catch((err) => {
        console.log(err);
      })
      .finally(() => {
        commit("TOGGLE_ROLES_LOADED", true);
      });
    },

  // DELETE REQUESTS
    deleteContractData({ commit }, id ) {
        commit("TOGGLE_ROLES_LOADED", false);
      
        axios({
          method: "PUT",
          url: ``,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((res) => {
            commit("SET_ROLES", res.data.roles);
            // console.log(res.data.roles)
          })
          .catch((err) => {
            console.log(err);
          })
          .finally(() => {
            commit("TOGGLE_ROLES_LOADED", true);
          });
    },
    deleteVehiclesData({ commit }, id ) {
        commit("TOGGLE_ROLES_LOADED", false);
      
        axios({
          method: "PUT",
          url: ``,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((res) => {
            commit("SET_ROLES", res.data.roles);
            // console.log(res.data.roles)
          })
          .catch((err) => {
            console.log(err);
          })
          .finally(() => {
            commit("TOGGLE_ROLES_LOADED", true);
          });
    },
    deletePOCData({ commit }, id ) {
        commit("TOGGLE_ROLES_LOADED", false);
      
        axios({
          method: "PUT",
          url: ``,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((res) => {
            commit("SET_ROLES", res.data.roles);
            // console.log(res.data.roles)
          })
          .catch((err) => {
            console.log(err);
          })
          .finally(() => {
            commit("TOGGLE_ROLES_LOADED", true);
          });
    },
  },
  mutations: {
    SET_ASSOCIATED_CONTRACTS: (state, value) => (state.associated_contracts = value),
    SET_ASSOCIATED_CONTRACTS_STATUS: (state, status) => (state.associated_contracts_status = status),   
    TOGGLE_ASSOCIATED_CONTRACTS_LOADED: (state, loaded) => (state.associated_contracts_loaded = loaded),

    SET_CONTRACT_PROJECTS: (state, value) => (state.contract_projects = value),
    SET_CONTRACT_PROJECT_STATUS: (state, status) => (state.contract_project_status = status), 
    TOGGLE_CONTRACT_PROJECTS_LOADED: (state, loaded) => (state.contract_projects_loaded = loaded),
  },

  getters: {
   associatedContracts: (state) => state.associated_contracts,
   associatedContractsStatus: (state) => state.associated_contracts_status,

   contractProjects: (state) => state.contract_projects, 
   contractProjectStatus: (state) => state.contract_project_status,
   contractProjectsLoaded: (state) => state.contract_projects_loaded

  },
};

export default contractStore;
