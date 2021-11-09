import axios from "axios";
import {API_BASE_PATH} from './../../mixins/utils'

const settingsStore = {
  state: () => ({
    show_admin_btn: false,
    contract_table: [],
    group_filter: null,
    contract: {},
    contracts: [],
    contract_loaded: true,
    contracts_loaded: true,
    contract_status: 0,
    contract_type_filter: null, 
   
    group: {},
    groups: [],
    group_loaded: true,
    groups_loaded: true,
    group_status: 0,
  
  }),
  actions: {
    createContract({ commit }, { contract }) {
      // Displays loader on front end
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Utilize utility function to prep Lesson form data
      let formData = contractFormData(contract);

      axios({
        method: "POST",
        url: `${API_BASE_PATH}/contracts`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT", res.data.contract);
          commit("SET_CONTRACT_STATUS", res.status);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACTS_LOADED", true);
        });
    },
    createGroup({ commit }, { group }) {
      // Displays loader on front end
      commit("TOGGLE_GROUPS_LOADED", false);
      // Utilize utility function to prep Lesson form data
      let formData = groupFormData(group);

      axios({
        method: "POST",
        url: `${API_BASE_PATH}/facility_groups`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_GROUP", res.data.facility_groups);
          commit("SET_GROUP_STATUS", res.status);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_GROUPS_LOADED", true);
        });
    },
    fetchContract({ commit }, { contractId }) {
      commit("TOGGLE_CONTRACT_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/contracts/${contractId}.json`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT", res.data);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACT_LOADED", true);
        });
    },
  fetchContracts({ commit }) {
    commit("TOGGLE_CONTRACTS_LOADED", false);
    // Retrieve contract by id
    axios({
      method: "GET",
      url: `${API_BASE_PATH}/contracts.json`,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .attributes["content"].value,
      },
    })
      .then((res) => {
        commit("SET_CONTRACTS", res.data.contracts);
      })
      .catch((err) => {
        console.log(err);
      })
      .finally(() => {
        commit("TOGGLE_CONTRACTS_LOADED", true);
      });
  },
  fetchGroups({ commit }) {
    commit("TOGGLE_GROUPS_LOADED", false);
      axios({
      method: "GET",
      url: `${API_BASE_PATH}/facility_groups.json`,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .attributes["content"].value,
      },
    })
      .then((res) => {
        commit("SET_GROUPS", res.data.facility_groups);
      })
      .catch((err) => {
        console.log(err);
      })
      .finally(() => {
        commit("TOGGLE_GROUPS_LOADED", true);
      });
  },
  updateContract({ commit }, { contract, id }) {
    // Displays loader on front end
    commit("TOGGLE_CONTRACTS_LOADED", false);
    // Utilize utility function to prep Lesson form data
    let formData = contractFormData(contract);

    axios({
      method: "PATCH",
      url: `${API_BASE_PATH}/contracts/${id}`,
      data: formData,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .attributes["content"].value,
      },
    })
      .then((res) => {
        commit("SET_CONTRACT", res.data.contract);
        commit("SET_CONTRACT_STATUS", res.status);
        console.log(res)
      })
      .catch((err) => {
        console.log(err);
      })
      .finally(() => {
        commit("TOGGLE_CONTRACTS_LOADED", true);
      });
  },

},
 
  mutations: {
    setShowAdminBtn: (state, value) => state.show_admin_btn = value,
    setContractTypeFilter: (state, value) => state.contract_type_filter = value,
    setContractTable: (state, value) => state.contract_table = value,
    setGroupFilter: (state, value) => state.group_filter = value,

    SET_CONTRACT: (state, contract) => (state.contract = contract),
    SET_CONTRACTS: (state, value) => (state.contracts = value),
    SET_CONTRACT_STATUS: (state, status) => (state.contract_status = status),    
    TOGGLE_CONTRACT_LOADED: (state, loaded) => (state.contract_loaded = loaded),
    TOGGLE_CONTRACTS_LOADED: (state, loaded) => (state.contracts_loaded = loaded),
    
   
    SET_GROUP: (state, value) => (state.group = value),
    SET_GROUPS: (state, value) => (state.groups = value),    
    SET_GROUP_STATUS: (state, status) => (state.group_status = status),
    TOGGLE_GROUP_LOADED: (state, loaded) => (state.group_loaded = loaded),
    TOGGLE_GROUPS_LOADED: (state, loaded) => (state.groups_loaded = loaded),
  },

  getters: {
    contract: (state) => state.contract,
    contracts: (state) => state.contracts,
    contractStatus: (state) => state.contract_status,

    group: (state) => state.group,
    groups: (state) => state.groups,  
    groupStatus: (state) => state.group_status,
    groupsLoaded: (state) => state.groups_loaded,

    getShowAdminBtn: state => state.show_admin_btn, 
    getContractTable: state => state.contract_table, 
    getGroupFilter: state => state.group_filter, 
    getContractTypeFilter: state => state.contract_type_filter,
    contractsLoaded: (state) => state.contracts_loaded,
    getContractTypeFilterFilterOptions: (state, getters) => {
      var options = [
        {id: 1, name: '5', value: 1},
        {id: 15, name: '15', value: 15},
        {id: 25, name: '25', value: 25},
        {id: 50, name: '50', value: 50},
        {id: 100, name: '100', value: 100},
      ]
      return options;
    },
  },
};

const contractFormData = (contract) => {
  let formData = new FormData();
  // Append all required form data
  formData.append("contract[contract_type_id]", contract.contract_type_id); //Required
  formData.append("contract[facility_group_id]", contract.facility_group_id); 
  formData.append("contract[project_id]", contract.project_id); //Required; This is actually the Program ID
  formData.append("contract[project_code]", contract.project_code); 
  formData.append("contract[contract_nickname]", contract.contract_nickname); //Required
  formData.append("contract[contract_status_id]", contract.contract_status_id); 
  formData.append("contract[contract_name_customer_id]", contract.contract_name_customer_id);
  formData.append("contract[contract_vehicle_id]", contract.contract_vehicle_id); 
  formData.append("contract[contract_vehicle_number_id]", contract.contract_vehicle_number_id);
  formData.append("contract[contract_number_id]", contract.contract_number_id); 
  formData.append("contract[contract_classification_id]", contract.contract_classification_id); 
  formData.append("contract[subcontract_number_id]", contract.subcontract_number_id); 
  formData.append("contract[contract_prime_id]", contract.contract_prime_id); 
  formData.append("contract[contract_current_pop_id]", contract.contract_current_pop_id); 
  formData.append("contract[current_pop_start_time]", contract.current_pop_start_time); 
  formData.append("contract[current_pop_end_time]", contract.current_pop_end_time); 
  formData.append("contract[days_remaining]", contract.days_remaining); 
  formData.append("contract[total_contract_value]", contract.total_contract_value); 
  formData.append("contract[current_pop_value]", contract.current_pop_value); 
  formData.append("contract[current_pop_funded]", contract.current_pop_funded);
  formData.append("contract[total_contract_funded]", contract.total_contract_funded);
  formData.append("contract[start_date]", contract.start_date); 
  formData.append("contract[end_date]", contract.end_date); 
  // formData.append("contract[id]", contract.id); 
 
  return formData;
};

const groupFormData = (group) => {
  let formData = new FormData();
  // Append all required form data
  formData.append("facility_group[name]", group.name); //Required
  formData.append("facility_group[status]", group.status); //Required
  formData.append("facility_group[project_id]", group.project_id); //Required; This is actually the Program ID
   return formData;
};

export default settingsStore;
