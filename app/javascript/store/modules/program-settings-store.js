import axios from "axios";
import { API_BASE_PATH } from "../../mixins/utils";

const programSettingsStore = {
  state: () => ({
    show_admin_btn: false,
    contract_table: [],
    group_filter: null,
    contract: {},
    contracts: [],
    contract_loaded: true,
    contracts_loaded: true,
    contract_status: 0,
    customer_agencies_filter: null,
    contract_statuses_filter: null,
    contract_classifications: [],
    vehicle_filter: null,
    vehicle_number: null,
    contract_number: null,
    subcontract_number: null,
    prime: null,
    current_pop: [],
    contract_type_filter: 0,
    contract_group_types: {},
    group: {},
    groups: [],
    group_loaded: true,
    groups_loaded: true,
    group_status: 0,
    new_contract_group_filter: [],
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
          console.log("Error",err);
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
          console.log("Error",err);
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
          console.log("Error",err);
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
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACTS_LOADED", true);
        });
    },
    fetchContractGroupTypes({ commit }) {
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/contract_data/contract_types`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT_GROUP_TYPES", res.data);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACTS_LOADED", true);
        });
    },
    fetchClassificationTypes({ commit }) {
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/contract_data/contract_classification`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT_CLASSIFICATIONS", res.data);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACTS_LOADED", true);
        });
    },
    fetchCustomerAgencies({ commit }) {
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/contract_data/contract_customeres`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CUSTOMER_AGENCIES_FILTER", res.data);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACTS_LOADED", true);
        });
    },
    fetchCurrentPop({ commit }) {
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/contract_data/contract_current_pop`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CURRENT_POP", res.data);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACTS_LOADED", true);
        });
    },
    fetchPrime({ commit }) {
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/contract_data/contract_prime`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_PRIME", res.data);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACTS_LOADED", true);
        });
    },
    fetchVehicles({ commit }) {
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/contract_data/contract_vehicles`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_VEHICLES", res.data);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACTS_LOADED", true);
        });
    },
    fetchVehicleNumbers({ commit }) {
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/contract_data/contract_vehicle_number`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_VEHICLE_NUMBERS", res.data);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACTS_LOADED", true);
        });
    },
    fetchContractNumber({ commit }) {
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/contract_data/contract_number`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT_NUMBER", res.data);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACTS_LOADED", true);
        });
    },
    fetchSubcontractNumbers({ commit }) {
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/contract_data/subcontract_number`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_SUBCONTRACT_NUMBER", res.data);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACTS_LOADED", true);
        });
    },
    fetchContractStatuses({ commit }) {
      commit("TOGGLE_CONTRACTS_LOADED", false);
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/contract_data/contract_statuses`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT_STATUSES_FILTER", res.data);
          // console.log(res.data)
        })
        .catch((err) => {
          console.log("Error",err);
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
          console.log("Error",err);
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
          console.log(contract, id);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACTS_LOADED", true);
        });
    },
  },

  mutations: {
    setShowAdminBtn: (state, value) => (state.show_admin_btn = value),
    setContractTypeFilter: (state, value) =>
      (state.contract_type_filter = value),
    setContractTable: (state, value) => (state.contract_table = value),
    setGroupFilter: (state, value) => (state.group_filter = value),
    setNewContractGroupFilter: (state, loaded) =>
      (state.new_contract_group_filter = loaded),

    SET_CONTRACT: (state, contract) => (state.contract = contract),
    SET_CONTRACTS: (state, value) => (state.contracts = value),
    SET_CONTRACT_STATUS: (state, status) => (state.contract_status = status),
    TOGGLE_CONTRACT_LOADED: (state, loaded) => (state.contract_loaded = loaded),
    TOGGLE_CONTRACTS_LOADED: (state, loaded) =>
      (state.contracts_loaded = loaded),

    SET_CONTRACT_GROUP_TYPES: (state, loaded) =>
      (state.contract_group_types = loaded),
    SET_CUSTOMER_AGENCIES_FILTER: (state, loaded) =>
      (state.customer_agencies_filter = loaded),
    SET_CONTRACT_STATUSES_FILTER: (state, loaded) =>
      (state.contract_statuses_filter = loaded),
    SET_CURRENT_POP: (state, value) => (state.current_pop = value),
    SET_PRIME: (state, value) => (state.prime = value),

    SET_CONTRACT_CLASSIFICATIONS: (state, value) =>
      (state.contract_classifications = value),

    SET_VEHICLES: (state, value) => (state.vehicle_filter = value),
    SET_VEHICLE_NUMBERS: (state, value) => (state.vehicle_number = value),
    SET_SUBCONTRACT_NUMBER: (state, value) =>
      (state.subcontract_number = value),
    SET_CONTRACT_NUMBER: (state, value) => (state.contract_number = value),

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
    getNewContractGroupFilter: (state) => state.new_contract_group_filter,

    getCustomerAgenciesFilter: (state) => state.customer_agencies_filter,
    getContractStatusesFilter: (state) => state.contract_statuses_filter,
    getContractClassifications: (state) => state.contract_classifications,
    getCurrentPop: (state) => state.current_pop,
    getPrime: (state) => state.prime,

    getVehicles: (state) => state.vehicle_filter,
    getVehicleNumbers: (state) => state.vehicle_number,
    getSubcontractNumbers: (state) => state.subcontract_number,
    getContractNumbers: (state) => state.contract_number,

    getContractGroupTypes: (state) => state.contract_group_types,
    group: (state) => state.group,
    groups: (state) => state.groups,
    groupStatus: (state) => state.group_status,
    groupsLoaded: (state) => state.groups_loaded,

    getShowAdminBtn: (state) => state.show_admin_btn,
    getContractTable: (state) => state.contract_table,
    getGroupFilter: (state) => state.group_filter,
    contractLoaded: (state) => state.contract_loaded,
    contractsLoaded: (state) => state.contracts_loaded,
    getContractTypeFilter: (state) => state.contract_type_filter,
    getContractGroupOptions: (state, getters) => {
      let options = [
        {
          id: 1,
          name: "Prime Contract",
        },
        {
          id: 2,
          name: "Non Prime Contract",
        },
        {
          id: 3,
          name: "Prime Vehicles and ID IQs",
        },
      ];
      return options;
    },
  },
};

const contractFormData = (contract) => {
  let formData = new FormData();
  // Append all required form data
  if (contract.id) {
    formData.append("contract[id]", contract.id);
    formData.append("facility_group_name", contract.facility_group_name);
  }
  formData.append("contract[facility_group_id]", contract.facility_group_id);
  formData.append("contract[contract_type_id]", contract.contract_type_id); //Required
  formData.append("contract[project_id]", contract.project_id); //Required; This is actually the Program ID
  formData.append("contract[project_code]", contract.project_code);
  formData.append("contract[nickname]", contract.nickname); //Required
  formData.append("contract[name]", contract.name); //Required
  formData.append("contract[contract_status_id]", contract.contract_status_id);
  formData.append(
    "contract[contract_customer_id]",
    contract.contract_customer_id
  );
  formData.append(
    "contract[contract_vehicle_id]",
    contract.contract_vehicle_id
  );
  formData.append(
    "contract[contract_vehicle_number_id]",
    contract.contract_vehicle_number_id
  );
  formData.append("contract[contract_number_id]", contract.contract_number_id);
  formData.append(
    "contract[contract_classification_id]",
    contract.contract_classification_id
  );
  formData.append(
    "contract[subcontract_number_id]",
    contract.subcontract_number_id
  );
  formData.append("contract[contract_prime_id]", contract.contract_prime_id);
  formData.append(
    "contract[contract_current_pop_id]",
    contract.contract_current_pop_id
  );
  formData.append(
    "contract[current_pop_start_time]",
    contract.current_pop_start_time
  );
  formData.append(
    "contract[current_pop_end_time]",
    contract.current_pop_end_time
  );
  formData.append("contract[days_remaining]", contract.days_remaining);
  formData.append(
    "contract[total_contract_value]",
    contract.total_contract_value
  );
  formData.append("contract[current_pop_value]", contract.current_pop_value);
  formData.append("contract[current_pop_funded]", contract.current_pop_funded);
  formData.append(
    "contract[total_contract_funded]",
    contract.total_contract_funded
  );
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

export default programSettingsStore;
