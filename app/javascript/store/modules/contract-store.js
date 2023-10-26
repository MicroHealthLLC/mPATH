import http from "./../../common/http";
import axios from "axios";
import { API_BASE_PATH } from "./../../mixins/utils";

const contractStore = {


  state: () => ({
    associated_contracts: [],
    associated_contracts_status: 0,
    associated_contracts_loaded: true,

    associated_vehicles: [],
    associated_vehicles_status: 0,
    associated_vehicles_loaded: true, 

    contract_data_options: [],
    contract_data_options_loaded: true,

   //CONTRACT PROJECTS DATA
    contract_projects: [],
    contract_project_status: 0,
    contract_projects_loaded: true,

    //CONTRACT PROJECTS DATA
    contract_project: {},
    contract_project_status: 0,
    contract_project_loaded: true,
    
    //VEHICLES
    contract_vehicle: {},
    contract_vehicle_status: 0,
    contract_vehicle_loaded: true,

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
    fetchContractProjects({ commit }, id) {
      commit("TOGGLE_CONTRACT_PROJECTS_LOADED", false);
      
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/portfolio/contract_project_data?project_id=${id}`,
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
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACT_PROJECTS_LOADED", true);
        });
    },
    fetchContractVehicles({ commit }, id) {
      commit("TOGGLE_CONTRACT_VEHICLES_LOADED", false);
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/portfolio/contract_vehicles?project_id=${id}`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT_VEHICLES", res.data.contract_vehicles);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACT_VEHICLES_LOADED", true);
        });
    },
    fetchContractDataOptions({ commit }) {
      commit("TOGGLE_CONTRACT_DATA_OPTIONS_LOADED", false);   
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/program_settings/contract_data/get_contract_data`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT_DATA_OPTIONS", res.data);
          })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACT_DATA_OPTIONS_LOADED", true);
        });
    },
    fetchContractPOCs({ commit } ) {
      commit("TOGGLE_CONTRACT_POCS_LOADED", false);   
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/portfolio/contract_project_pocs`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT_POCS", res.data.contract_project_pocs);
          // console.log(res.data.roles)
        })
        .catch((err) => {
          console.log("Error",err);
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
      if(cProjectData.notes){
        formData.append("contract_project_data[notes]", cProjectData.notes)   
      } 
      if(cProjectData.contract_vehicle_id){
        formData.append("contract_project_data[contract_vehicle_id]", cProjectData.contract_vehicle_id)   
      }
      if(cProjectData.contract_award_to_id){
        formData.append("contract_project_data[contract_award_to_id]", cProjectData.contract_award_to_id)
      }
      if(cProjectData.number){
        formData.append("contract_project_data[contract_number_id]", cProjectData.number)
      }
      formData.append("contract_project_data[contract_type_id]", cProjectData.contract_type_id)
      formData.append("contract_project_data[contract_award_type_id]", cProjectData.contract_award_type_id)
      formData.append("contract_project_data[contract_pop_id]", cProjectData.contract_pop_id)
      formData.append("contract_project_data[contract_current_pop_id]", cProjectData.contract_current_pop_id)
      formData.append("contract_project_data[contract_naic_id]", cProjectData.contract_naic_id)
      
    axios({
      method: "POST",
      url: `${API_BASE_PATH}/portfolio/contract_project_data`,
      data: formData,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .attributes["content"].value,
      },
    })
      .then((res) => {
        commit("SET_CONTRACT_PROJECT", res.data.contract_project_data);
        commit("SET_CONTRACT_PROJECT_STATUS", res.status);
      })
      .catch((err) => {
        console.log("Error",err);
      })
      .finally(() => {
        commit("TOGGLE_CONTRACT_PROJECT_LOADED", true);
      });
    },
    createContractVehicle({ commit }, { cVehicleData }) {
      commit("TOGGLE_CONTRACT_VECHILE_LOADED", false);
      let formData = new FormData();
      console.log(cVehicleData)
        formData.append("contract_vehicle[name]",  cVehicleData.name);
        formData.append("contract_vehicle[full_name]", cVehicleData.fullName);
        formData.append("contract_vehicle[contract_sub_category_id]", cVehicleData.subCatId);
        formData.append("contract_vehicle[contract_agency_id]", cVehicleData.cAgencyId);
        formData.append("contract_vehicle[contract_vehicle_type_id]", cVehicleData.type);
        formData.append("contract_vehicle[contract_number_id]", cVehicleData.contract_number_id);
        formData.append("contract_vehicle[ceiling]", cVehicleData.ceiling);
        if (cVehicleData.cafFees){
          formData.append("contract_vehicle[caf_fees]", cVehicleData.cafFees);
        }
        if (cVehicleData.subprime_name){
          formData.append("contract_vehicle[subprime_name]", cVehicleData.subprime_name);
        }
        // prime
        if (cVehicleData.prime_name){
          formData.append("contract_vehicle[prime_name]", cVehicleData.prime_name);
        }
        // contract_name
        if (cVehicleData.contract_name){
          formData.append("contract_vehicle[contract_name]", cVehicleData.contract_name);
        }
        formData.append("contract_vehicle[base_period_start]", cVehicleData.bp_startDate);
        formData.append("contract_vehicle[base_period_end]", cVehicleData.bp_endDate);
        formData.append("contract_vehicle[option_period_start]", cVehicleData.op_startDate);
        formData.append("contract_vehicle[option_period_end]", cVehicleData.op_endDate);  
      axios({
        method: "POST",
        url: `${API_BASE_PATH}/portfolio/contract_vehicles`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT_VEHICLE", res.data.contract_vehicles);
          commit("SET_CONTRACT_VEHICLE_STATUS", res.status);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACT_VEHICLE_LOADED", true);
        });
    },
    createContractPOC({ commit }, { cPOCsData }) {
      commit("TOGGLE_CONTRACT_POCS_LOADED", false);
      let formData = new FormData();
      console.log(cPOCsData)
        formData.append("contract_project_poc[name]", cPOCsData.name);
        // formData.append("contract_project_poc[poc_type]", cPOCsData.pocType);
      
        if(cPOCsData.email){
          formData.append("contract_project_poc[email]", cPOCsData.email);
        }
        if(cPOCsData.title){
          formData.append("contract_project_poc[title]", cPOCsData.title);
        }
        if(cPOCsData.workNum){
          formData.append("contract_project_poc[work_number]", cPOCsData.workNum);
        }
       if (cPOCsData.mobileNum){
          formData.append("contract_project_poc[mobile_number]", cPOCsData.mobileNum);
       }
       if(cPOCsData.notes){
        formData.append("contract_project_poc[notes]", cPOCsData.notes);
       }       
      axios({
        method: "POST",
        url: `${API_BASE_PATH}/portfolio/contract_project_pocs`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT_POCS", res.data.contract_project_pocs);
          commit("SET_CONTRACT_POCS_STATUS", res.status);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACT_POCS_LOADED", true);
        });
    },
    associateContractToProgram({ commit }, { contract } ) {
      commit("TOGGLE_ASSOCIATED_CONTRACTS_LOADED", false);
  //  console.log(contract)
      axios({
        method: "POST",
        url: `${API_BASE_PATH}/program_settings/programs/add_contract`,
        data: {id: contract.programId, contract_id: contract.id},
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
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_ASSOCIATED_CONTRACTS_LOADED", true);
        });
      },
      associateVehicleToProgram({ commit }, { vehicle } ) {
        commit("TOGGLE_ASSOCIATED_VEHICLES_LOADED", false);
        axios({
          method: "POST",
          url: `${API_BASE_PATH}/program_settings/programs/add_contract_vehicle`,
          data: {id: vehicle.programId, contract_vehicle_id: vehicle.id},
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((res) => {
            commit("SET_ASSOCIATED_VEHICLES", res.data);
            commit("SET_ASSOCIATED_VEHICLES_STATUS", res.status);
            // console.log(res.data.roles)
          })
          .catch((err) => {
            console.log("Error",err);
          })
          .finally(() => {
            commit("TOGGLE_ASSOCIATED_VEHICLES_LOADED", true);
          });
        },
        // UPDATE REQUESTS
  updateIgnoreExpired({ commit }, { cProjectData, id }) {
    commit("TOGGLE_CONTRACT_PROJECT_LOADED", false);
    let formData = new FormData();
    console.log(cProjectData)
    formData.append("contract_project_data[ignore_expired]", cProjectData.isExpired)    
    axios({
      method: "PUT",
      url: `${API_BASE_PATH}/portfolio/contract_project_data/${id}`,
      data: formData,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .attributes["content"].value,
      },
    })
      .then((res) => {
        commit("SET_CONTRACT_PROJECT", res.data.contract_project_data);
        commit("SET_CONTRACT_PROJECT_STATUS", res.status);
      })
      .catch((err) => {
        console.log("Error",err);
      })
      .finally(() => {
        commit("TOGGLE_CONTRACT_PROJECT_LOADED", true);
      });
  },
  // UPDATE REQUESTS
  updateContractProject({ commit }, { cProjectData, id }) {
    commit("TOGGLE_CONTRACT_PROJECT_LOADED", false);
    let formData = new FormData();
      formData.append("contract_project_data[id]", id);
      formData.append("contract_project_data[charge_code]", cProjectData.charge_code);
      formData.append("contract_project_data[name]", cProjectData.name)
      formData.append("contract_project_data[contract_customer_id]", cProjectData.contract_customer_id)
      formData.append("contract_project_data[prime_or_sub]", cProjectData.prime_or_sub)
      formData.append("contract_project_data[total_contract_value]", cProjectData.total_contract_value)
      if(cProjectData.contract_start_date){
        formData.append("contract_project_data[contract_start_date]", cProjectData.contract_start_date)
      }
      if(cProjectData.contract_end_date){
        formData.append("contract_project_data[contract_end_date]", cProjectData.contract_end_date)
      }
      if(cProjectData.contract_current_pop_start_date){
        formData.append("contract_project_data[contract_current_pop_start_date]", cProjectData.contract_current_pop_start_date)
      }
      if(cProjectData.contract_current_pop_end_date){
        formData.append("contract_project_data[contract_current_pop_end_date]", cProjectData.contract_current_pop_end_date)
      }
      
      formData.append("contract_project_data[contract_type_id]", cProjectData.contract_type_id)
      formData.append("contract_project_data[contract_award_type_id]", cProjectData.contract_award_type_id)
      formData.append("contract_project_data[contract_pop_id]", cProjectData.contract_pop_id)
      formData.append("contract_project_data[contract_current_pop_id]", cProjectData.contract_current_pop_id)
      formData.append("contract_project_data[contract_naic_id]", cProjectData.contract_naic_id)
      
      if(cProjectData.notes){
        formData.append("contract_project_data[notes]", cProjectData.notes)   
      } else {
        formData.append("contract_project_data[notes]", "") 
      }
      
      formData.append("contract_project_data[contract_naic_id]", cProjectData.contract_naic_id)    
      
      if(cProjectData.contract_vehicle_id){
        formData.append("contract_project_data[contract_vehicle_id]", cProjectData.contract_vehicle_id)   
      }
      
      if(cProjectData.contract_award_to_id){
        formData.append("contract_project_data[contract_award_to_id]", cProjectData.contract_award_to_id)
      }
      
      if(cProjectData.number){
        formData.append("contract_project_data[contract_number_id]", cProjectData.number)
      }

      if(cProjectData.expiredStatus){
        console.log(cProjectData.expired)
        formData.append("contract_project_data[ignore_expired]", cProjectData.expired)
      }

      if(cProjectData.co_poc_ids && cProjectData.co_poc_ids.length > 0){
        cProjectData.co_poc_ids.forEach((ids) => {
          formData.append("contract_project_data[co_contract_poc_ids][]", ids)
        });
      } else {
        formData.append("contract_project_data[co_contract_poc_ids][]", '')
      }

      if(cProjectData.gov_poc_ids && cProjectData.gov_poc_ids.length > 0){
        cProjectData.gov_poc_ids.forEach((ids) => {
          formData.append("contract_project_data[gov_contract_poc_ids][]", ids)
        });
      } else {
        formData.append("contract_project_data[gov_contract_poc_ids][]", '')
      }

      if(cProjectData.pm_poc_ids && cProjectData.pm_poc_ids.length > 0){      
        cProjectData.pm_poc_ids.forEach((ids) => {
          formData.append("contract_project_data[pm_contract_poc_ids][]", ids)
        });
      } else {
        formData.append("contract_project_data[pm_contract_poc_ids][]", '')
      } 

      formData.append("contract_project_data[total_founded_value]", cProjectData.tfv)
      formData.append("contract_project_data[billings_to_date]", cProjectData.btd)
      formData.append("contract_project_data[comments]", cProjectData.notes)

      axios({
        method: "PUT",
        url: `${API_BASE_PATH}/portfolio/contract_project_data/${id}`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
      .then((res) => {
        commit("SET_CONTRACT_PROJECT", res.data.contract_project_data);
        commit("SET_CONTRACT_PROJECT_STATUS", res.status);
      })
      .catch((err) => {
        console.log("Error",err);
      })
      .finally(() => {
        commit("TOGGLE_CONTRACT_PROJECT_LOADED", true);
      });
  },
  updateContractVehicle({ commit }, { cVehicleData, id } ) {    
    commit("TOGGLE_CONTRACT_VEHICLE_LOADED", false);   
    console.log(id)
    let formData = new FormData();
    formData.append("contract_vehicle[id]", id);
    formData.append("contract_vehicle[name]",  cVehicleData.name);
    formData.append("contract_vehicle[full_name]", cVehicleData.fullName);
    formData.append("contract_vehicle[contract_sub_category_id]", cVehicleData.subCatId);
    formData.append("contract_vehicle[contract_agency_id]", cVehicleData.cAgencyId);
    formData.append("contract_vehicle[contract_vehicle_type_id]", cVehicleData.type);
    formData.append("contract_vehicle[contract_number_id]", cVehicleData.contract_number_id);
    formData.append("contract_vehicle[ceiling]", cVehicleData.ceiling);
    if (cVehicleData.cafFees){
      formData.append("contract_vehicle[caf_fees]", cVehicleData.cafFees);
    }
    if (cVehicleData.subprime_name){
      formData.append("contract_vehicle[subprime_name]", cVehicleData.subprime_name);
    }
    // prime
    if (cVehicleData.prime_name){
      formData.append("contract_vehicle[prime_name]", cVehicleData.prime_name);
    }
    // contract_name
    if (cVehicleData.contract_name){
      formData.append("contract_vehicle[contract_name]", cVehicleData.contract_name);
    }
    if(cVehicleData.co_poc_ids && cVehicleData.co_poc_ids.length > 0){
      cVehicleData.co_poc_ids.forEach((ids) => {
        formData.append("contract_vehicle[co_contract_poc_ids][]", ids)
      });
    } else {
      formData.append("contract_vehicle[co_contract_poc_ids][]", '')
    }

    if(cVehicleData.gov_poc_ids && cVehicleData.gov_poc_ids.length > 0){
      cVehicleData.gov_poc_ids.forEach((ids) => {
        formData.append("contract_vehicle[gov_contract_poc_ids][]", ids)
      });
    } else {
      formData.append("contract_vehicle[gov_contract_poc_ids][]", '')
    }

    if(cVehicleData.pm_poc_ids && cVehicleData.pm_poc_ids.length > 0){      
      cVehicleData.pm_poc_ids.forEach((ids) => {
        formData.append("contract_vehicle[pm_contract_poc_ids][]", ids)
      });
    } else {
      formData.append("contract_vehicle[pm_contract_poc_ids][]", '')
    } 
    formData.append("contract_vehicle[base_period_start]", cVehicleData.bp_startDate);
    formData.append("contract_vehicle[base_period_end]", cVehicleData.bp_endDate);
    formData.append("contract_vehicle[option_period_start]", cVehicleData.op_startDate);
    formData.append("contract_vehicle[option_period_end]", cVehicleData.op_endDate);  
    axios({
      method: "PUT",
      url: `${API_BASE_PATH}/portfolio/contract_vehicles/${id}`,
      data: formData, 
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .attributes["content"].value,
      },
    })
      .then((res) => {
        commit("SET_CONTRACT_VEHICLE", res.data.contract_vehicles);
        commit("SET_CONTRACT_VEHICLE_STATUS", res.status);
      })
      .catch((err) => {
        console.log("Error",err);
      })
      .finally(() => {
        commit("TOGGLE_CONTRACT_VEHICLE_LOADED", true);
      });
  },
  updateContractPOC({ commit }, { cPOCsData, id }) {
  commit("TOGGLE_CONTRACT_POCS_LOADED", false);
  let formData = new FormData();
  console.log(cPOCsData)
    formData.append("contract_project_poc[name]", cPOCsData.name);
    formData.append("contract_project_poc[poc_type]", cPOCsData.pocType);
    if(cPOCsData.email){
      formData.append("contract_project_poc[email]", cPOCsData.email);
    }
    formData.append("contract_project_poc[title]", cPOCsData.title);
    formData.append("contract_project_poc[work_number]", cPOCsData.workNum);
    formData.append("contract_project_poc[mobile_number]", cPOCsData.mobileNum);
    formData.append("contract_project_poc[notes]", cPOCsData.notes);
  axios({
    method: "PUT",
    url: `${API_BASE_PATH}/portfolio/contract_project_pocs/${id}`,
    data: formData,
    headers: {
      "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
        .attributes["content"].value,
    },
  })
    .then((res) => {
      commit("SET_CONTRACT_POCS", res.data.contract_project_pocs);
      commit("SET_CONTRACT_POCS_STATUS", res.status);
    })
    .catch((err) => {
      console.log("Error",err);
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
      url: `${API_BASE_PATH}/portfolio/contract_project_data/${id}`,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .attributes["content"].value,
      },
    })
      .then((res) => {
        commit("SET_CONTRACT_PROJECT", res.data.contract_project_data);
        commit("SET_CONTRACT_PROJECT_STATUS", res.status);
      })
      .catch((err) => {
        console.log("Error",err);
      })
      .finally(() => {
        commit("TOGGLE_CONTRACT_PROJECT_LOADED", true);
      });
    },
    deleteContractVehicle({ commit }, id ) {
        commit("TOGGLE_CONTRACT_VEHICLE_LOADED", false);
      
        axios({
          method: "DELETE",
          url: `${API_BASE_PATH}/portfolio/contract_vehicles/${id}`,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((res) => {
            commit("SET_CONTRACT_VEHICLE", res.data.contract_vehicles);
            commit("SET_CONTRACT_VEHICLE_STATUS", res.status);
          })
          .catch((err) => {
            console.log("Error",err);
          })
          .finally(() => {
            commit("TOGGLE_CONTRACT_VEHICLE_LOADED", true);
          });
    },
    deleteContractPOC({ commit }, id ) {
      commit("TOGGLE_CONTRACT_POCS_LOADED", false);
    
      axios({
        method: "DELETE",
        url: `${API_BASE_PATH}/portfolio/contract_project_pocs/${id}`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT_POCS", res.data.contract_project_pocs);
          commit("SET_CONTRACT_POCS_STATUS", res.status);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACT_POCS_LOADED", true);
        });
  },
  },
  mutations: {
    SET_ASSOCIATED_CONTRACTS: (state, value) => (state.associated_contracts = value),
    SET_ASSOCIATED_CONTRACTS_STATUS: (state, status) => (state.associated_contracts_status = status),   
    TOGGLE_ASSOCIATED_CONTRACTS_LOADED: (state, loaded) => (state.associated_contracts_loaded = loaded),

    SET_ASSOCIATED_VEHICLES: (state, value) => (state.associated_vehicles = value),
    SET_ASSOCIATED_VEHICLES_STATUS: (state, status) => (state.associated_vehicles_status = status),
    TOGGLE_ASSOCIATED_VEHICLES_LOADED: (state, loaded) => (state.associated_vehicles_loaded = loaded),

    TOGGLE_CONTRACT_DATA_OPTIONS_LOADED: (state, loaded) => (state.contract_data_options_loaded = loaded),

    SET_CONTRACT_DATA_OPTIONS: (state, options) => (state.contract_data_options = options),
    //CONTRACT PROJECTS DATA
    SET_CONTRACT_PROJECTS: (state, value) => (state.contract_projects = value),
    SET_CONTRACT_PROJECT_STATUS: (state, status) => (state.contract_project_status = status), 
    TOGGLE_CONTRACT_PROJECTS_LOADED: (state, loaded) => (state.contract_projects_loaded = loaded),

    SET_CONTRACT_PROJECT: (state, value) => (state.contract_project = value),
    TOGGLE_CONTRACT_PROJECT_LOADED: (state, loaded) => (state.contract_project_loaded = loaded),

    //VEHICLES
    SET_CONTRACT_VEHICLES: (state, value) => (state.contract_vehicles = value),
    SET_CONTRACT_VEHICLES_STATUS: (state, status) => (state.contract_vehicles_status = status), 
    TOGGLE_CONTRACT_VEHICLES_LOADED: (state, loaded) => (state.contract_vehicles_loaded = loaded),

    SET_CONTRACT_VEHICLE: (state, value) => (state.contract_vehicle = value),
    SET_CONTRACT_VEHICLE_STATUS: (state, status) => (state.contract_vehicle_status = status), 
    TOGGLE_CONTRACT_VEHICLE_LOADED: (state, loaded) => (state.contract_vehicle_loaded = loaded),

    //POCS
    SET_CONTRACT_POCS: (state, value) => (state.contract_pocs = value),
    SET_CONTRACT_POCS_STATUS: (state, status) => (state.contract_pocs_status = status), 
    TOGGLE_CONTRACT_POCS_LOADED: (state, loaded) => (state.contract_pocs_loaded = loaded),
  },

  getters: {
   associatedContracts: (state) => state.associated_contracts,
   associatedContractsStatus: (state) => state.associated_contracts_status,

   associatedVehicles: (state) => state.associated_vehicles,
   associatedVehiclesStatus: (state) => state.associated_vehicles_status,


   //CONTRACT PROJECTS DATA
   contractProjects: (state) => state.contract_projects, 
   contractProjectStatus: (state) => state.contract_project_status,
   contractProjectsLoaded: (state) => state.contract_projects_loaded,

   contractProject: (state) => state.contract_project, 
   contractProjectLoaded: (state) => state.contract_project_loaded,

   //VEHICLES
   contractVehicles: (state) => state.contract_vehicles, 
   contractVehiclesStatus: (state) => state.contract_vehicles_status,
   contractVehiclesLoaded: (state) => state.contract_vehicles_loaded,

   contractVehicle: (state) => state.contract_vehicle, 
   contractVehicleStatus: (state) => state.contract_vehicle_status,
   contractVehicleLoaded: (state) => state.contract_vehicle_loaded,

   //POCS
   contractPOCs: (state) => state.contract_pocs, 
   contractPOCsStatus: (state) => state.contract_pocs_status,
   contractPOCsLoaded: (state) => state.contract_pocs_loaded,

   contractDataOptions: (state) => state.contract_data_options
  },
};

export default contractStore;
