import axios from "axios";

const settingsStore = {
  state: () => ({
    show_admin_btn: false,
    contract_table: [],
    group_filter: null,
    contract: {},
    contract_loaded: true,
    contracts_loaded: true,
    contract_status: 0,
    contract_type_filter: null, 
    contracts: [],
  
  }),
  actions: {
    createContract({ commit }, { contract }) {
      // Displays loader on front end
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Utilize utility function to prep Lesson form data
      let formData = contractFormData(contract);

      axios({
        method: "POST",
        url: `/api/v1/contracts`,
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
    fetchContract({ commit }, { contractId }) {
      commit("TOGGLE_CONTRACT_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `/api/v1/contracts/${contractId}.json`,
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
      url: `/api/v1/contracts.json`,
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

},
  updateContract({ commit }, { contract, programId, contractId }) {
    // Displays loader on front end
    commit("TOGGLE_CONTRACTS_LOADED", false);
    // Utilize utility function to prep Lesson form data
    let formData = contractFormData(contract);

    axios({
      method: "PATCH",
      url: `/api/v1/programs/${programId}/contracts/${contractId}`,
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
  mutations: {
    setShowAdminBtn: (state, value) => state.show_admin_btn = value,
    setContractTypeFilter: (state, value) => state.contract_type_filter = value,
    setContractTable: (state, value) => state.contract_table = value,
    setGroupFilter: (state, value) => state.group_filter = value,
    SET_CONTRACT: (state, contract) => (state.contract = contract),
    TOGGLE_CONTRACT_LOADED: (state, loaded) => (state.contract_loaded = loaded),
    TOGGLE_CONTRACTS_LOADED: (state, loaded) => (state.contracts_loaded = loaded),
    SET_CONTRACT_STATUS: (state, status) => (state.contract_status = status),
    SET_CONTRACTS: (state, value) => (state.contracts = value),
  },

  getters: {
    contract: (state) => state.contract,
    contracts: (state) => state.contracts,
    getShowAdminBtn: state => state.show_admin_btn, 
    getContractTable: state => state.contract_table, 
    getGroupFilter: state => state.group_filter, 
    getContractTypeFilter: state => state.contract_type_filter,
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
  formData.append("contract[contract_type_id]", contract.contract_type_id); // Required
  formData.append("contract[project_code]", contract.project_code); // Required
  formData.append("contract[contract_nickname]", contract.contract_nickname); // Required
  formData.append("contract[contract_status_id]", contract.contract_status_id); // Required
  formData.append("contract[contract_name_customer_id]", contract.contract_name_customer_id); // Required
  formData.append("contract[contract_vehicle_id]", contract.contract_vehicle_id); // Required
  formData.append("contract[contract_vehicle_number_id]", contract.contract_vehicle_number_id); // Required
  formData.append("contract[contract_number_id]", contract.contract_number_id); // Required
  formData.append("contract[contract_classification_id]", contract.contract_classification_id); // Required
  formData.append("contract[subcontract_number_id]", contract.subcontract_number_id); // Required
  formData.append("contract[contract_prime_id]", contract.contract_prime_id); // Required
  formData.append("contract[contract_current_pop_id]", contract.contract_current_pop_id); // Required
  formData.append("contract[current_pop_start_time]", contract.current_pop_start_time); // Required
  formData.append("contract[current_pop_end_time]", contract.current_pop_end_time); // Required
  formData.append("contract[days_remaining]", contract.days_remaining); // Required
  formData.append("contract[total_contract_value]", contract.total_contract_value); // Required
  formData.append("contract[current_pop_value]", contract.current_pop_value); // Required
  formData.append("contract[current_pop_funded]", contract.current_pop_funded); // Required
  formData.append("contract[total_contract_funded]", contract.total_contract_funded); // Required
  formData.append("contract[start_date]", contract.start_date); // Required
  formData.append("contract[end_date]", contract.end_date); // Required
 
  return formData;
};

export default settingsStore;
