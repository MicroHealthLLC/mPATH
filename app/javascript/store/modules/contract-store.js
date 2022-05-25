import http from "./../../common/http";
import axios from "axios";
import { API_BASE_PATH } from "./../../mixins/utils";

const contractStore = {


  state: () => ({
    associated_contracts: [],
    associated_contracts_status: 0,
    associated_contracts_loaded: true,

   //CONTRACT PROJECTS DATA
    contract_projects: [],
    contract_project_status: 0,
    contract_projects_loaded: true,
    
    //VEHICLES
    contract_vehicles: [],
    contract_vehicles_status: 0,
    contract_vehicles_loaded: true,

    //POCS
    contract_pocs: [],
    contract_pocs_status: 0,
    contract_pocs_loaded: true,

   
  }),

  actions: {
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
    fetchContractVehicles({ commit }) {
      commit("TOGGLE_CONTRACT_VEHICLES_LOADED", false);   
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/contract_vehicles`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT_VEHICLES", res.data.contract_vehicles);
          // console.log(res.data.roles)
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACT_VEHICLES_LOADED", true);
        });
    },
    fetchContractPOCs({ commit } ) {
      commit("TOGGLE_CONTRACT_POCS_LOADED", false);   
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/contract_project_pocs`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT_POCS", res.data.contract_vehicles);
          // console.log(res.data.roles)
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACT_POCS_LOADED", true);
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
    createContractVehicle({ commit }, { cVehicleData }) {
      commit("TOGGLE_CONTRACT_VECHILES_LOADED", false);
      let formData = new FormData();
      console.log(cVehicleData)
        formData.append("contract_vehicles[name]",  cVehicleData.name);
        formData.append("contract_vehicles[contract_sub_category_id]", cVehicleData.subCatId);
        formData.append("contract_vehicles[contract_agency_id]", cVehicleData.charge_code);
        formData.append("contract_vehicles[vehicle_type_id]", cVehicleData.charge_code);
      
    //  NEED SCHEMA COLUMNS FOR THESE VALUES
        formData.append("contract_vehicles[full_name]", cVehicleData.fullName);
        formData.append("contract_vehicles[contract_number]", cVehicleData.contractNum);
        formData.append("contract_vehicles[ceiling]", cVehicleData.ceiling);
        formData.append("contract_vehicles[base_period_start_date]", cVehicleData.bp_startDate);
        formData.append("contract_vehicles[base_period_end_date]", cVehicleData.bp_endDate);
        formData.append("contract_vehicles[option_period_start]", cVehicleData.op_startDate);
        formData.append("contract_vehicles[option_period_end]", cVehicleData.op_endDate);  
      axios({
        method: "POST",
        url: `${API_BASE_PATH}/contract_vehicles`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT_VEHICLES", res.data.contract_vehicles);
          commit("SET_CONTRACT_VEHICLES_STATUS", res.status);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACT_VEHICLES_LOADED", true);
        });
    },
    createContractPOC({ commit }, { cPOCsData }) {
      commit("TOGGLE_CONTRACT_POCS_LOADED", false);
      let formData = new FormData();
      console.log(cPOCsData)
        formData.append("contract_project_pocs[name]", cPOCsData.name);
        formData.append("contract_project_pocs[poc_type]", cPOCsData.pocType);
        formData.append("contract_project_pocs[email]", cPOCsData.email);
        formData.append("contract_project_pocs[title]", cPOCsData.title);
        formData.append("contract_project_pocs[work_number]", cPOCsData.workNum);
        formData.append("contract_project_pocs[mobile_number]", cPOCsData.mobileNum);
        formData.append("contract_project_pocs[notes]", cPOCsData.notes);
      axios({
        method: "POST",
        url: `${API_BASE_PATH}/contract_project_pocs`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT_POCS", res.data.contract_pocs);
          commit("SET_CONTRACT_POCS_STATUS", res.status);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACT_POCS_LOADED", true);
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
      formData.append("contract_project_data[co_contract_poc_id]", cProjectData.co_poc_id)
      formData.append("contract_project_data[gov_contract_poc_id]", cProjectData.gov_poc_id)
      formData.append("contract_project_data[pm_contract_poc_id]", cProjectData.pm_poc_id)  
      formData.append("contract_project_data[total_founded_value]", cProjectData.tfv)
      formData.append("contract_project_data[billings_to_date]", cProjectData.btd)      
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
  updateVehiclesData({ commit }, { cVehicleData, id } ) {
    commit("TOGGLE_CONTRACT_VEHICLES_LOADED", false);   
    formData.append("contract_vehicles[name]",  cVehicleData.name);
    formData.append("contract_vehicles[contract_sub_category_id]", cVehicleData.subCatId);
    formData.append("contract_vehicles[contract_agency_id]", cVehicleData.charge_code);
    formData.append("contract_vehicles[vehicle_type_id]", cVehicleData.charge_code);
  
//  NEED SCHEMA COLUMNS FOR THESE VALUES
    formData.append("contract_vehicles[full_name]", cVehicleData.fullName);
    formData.append("contract_vehicles[contract_number]", cVehicleData.contractNum);
    formData.append("contract_vehicles[ceiling]", cVehicleData.ceiling);
    formData.append("contract_vehicles[base_period_start_date]", cVehicleData.bp_startDate);
    formData.append("contract_vehicles[base_period_end_date]", cVehicleData.bp_endDate);
    formData.append("contract_vehicles[option_period_start]", cVehicleData.op_startDate);
    formData.append("contract_vehicles[option_period_end]", cVehicleData.op_endDate);
    axios({
      method: "PUT",
      url: `${API_BASE_PATH}/contract_vehicles/${id}`,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .attributes["content"].value,
      },
    })
      .then((res) => {
        commit("SET_CONTRACT_VEHICLES", res.data.contract_vehicles);
        commit("SET_CONTRACT_VEHICLES_STATUS", res.status);
      })
      .catch((err) => {
        console.log(err);
      })
      .finally(() => {
        commit("TOGGLE_CONTRACT_VEHICLES_LOADED", true);
      });
  },
  updateContractPOC({ commit }, { cPOCsData, id }) {
  commit("TOGGLE_CONTRACT_POCS_LOADED", false);
  let formData = new FormData();
  console.log(cPOCsData)
    formData.append("contract_project_pocs[name]", cPOCsData.name);
    formData.append("contract_project_pocs[poc_type]", cPOCsData.pocType);
    formData.append("contract_project_pocs[email]", cPOCsData.email);
    formData.append("contract_project_pocs[title]", cPOCsData.title);
    formData.append("contract_project_pocs[work_number]", cPOCsData.workNum);
    formData.append("contract_project_pocs[mobile_number]", cPOCsData.mobileNum);
    formData.append("contract_project_pocs[notes]", cPOCsData.notes);
  axios({
    method: "PUT",
    url: `${API_BASE_PATH}/contract_project_pocs/${id}`,
    data: formData,
    headers: {
      "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
        .attributes["content"].value,
    },
  })
    .then((res) => {
      commit("SET_CONTRACT_POCS", res.data.contract_pocs);
      commit("SET_CONTRACT_POCS_STATUS", res.status);
    })
    .catch((err) => {
      console.log(err);
    })
    .finally(() => {
      commit("TOGGLE_CONTRACT_POCS_LOADED", true);
    });
  },
    // DELETE REQUESTS
   deleteContractProject({ commit }, id) {
    commit("TOGGLE_CONTRACT_PROJECT_LOADED", false);
    axios({
      method: "DELETE",
      url: `${API_BASE_PATH}/contract_project_data/${id}`,
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

    //CONTRACT PROJECTS DATA
    SET_CONTRACT_PROJECTS: (state, value) => (state.contract_projects = value),
    SET_CONTRACT_PROJECT_STATUS: (state, status) => (state.contract_project_status = status), 
    TOGGLE_CONTRACT_PROJECTS_LOADED: (state, loaded) => (state.contract_projects_loaded = loaded),

    //VEHICLES
    SET_CONTRACT_VEHICLES: (state, value) => (state.contract_vehicles = value),
    SET_CONTRACT_VEHICLES_STATUS: (state, status) => (state.contract_vehicles_status = status), 
    TOGGLE_CONTRACT_VEHICLES_LOADED: (state, loaded) => (state.contract_vehicles_loaded = loaded),

    //POCS
    SET_CONTRACT_POCS: (state, value) => (state.contract_pocs = value),
    SET_CONTRACT_POCS_STATUS: (state, status) => (state.contract_pocs_status = status), 
    TOGGLE_CONTRACT_POCS_LOADED: (state, loaded) => (state.contract_pocs_loaded = loaded),
  },

  getters: {
   associatedContracts: (state) => state.associated_contracts,
   associatedContractsStatus: (state) => state.associated_contracts_status,

   //CONTRACT PROJECTS DATA
   contractProjects: (state) => state.contract_projects, 
   contractProjectStatus: (state) => state.contract_project_status,
   contractProjectsLoaded: (state) => state.contract_projects_loaded,

   //VEHICLES
   contractVehicles: (state) => state.contract_vehicles, 
   contractVehiclesStatus: (state) => state.contract_vehicles_status,
   contractVehiclesLoaded: (state) => state.contract_vehicles_loaded,

   //POCS
   contractPOCs: (state) => state.contract_pocs, 
   contractPOCsStatus: (state) => state.contract_pocs_status,
   contractPOCsLoaded: (state) => state.contract_pocs_loaded
  },
};

export default contractStore;
