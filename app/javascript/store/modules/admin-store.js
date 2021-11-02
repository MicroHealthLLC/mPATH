const adminStore = {
  state: () => ({
    show_admin_btn: false,
    contract_table: [],
    group_filter: null,
    contract: {},
    contracts_loaded: true,
    contract_status: 0,

  
  }),
  actions: {
    fetchContract({ commit }, { programId, contractId }) {
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `/api/v1/programs/${programId}/contracts/${contractId}`,
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
    setContractTable: (state, value) => state.contract_table = value,
    setGroupFilter: (state, value) => state.group_filter = value,
    SET_CONTRACT: (state, contract) => (state.contract = contract),
    TOGGLE_CONTRACTS_LOADED: (state, loaded) => (state.contracts_loaded = loaded),
    SET_CONTRACT_STATUS: (state, status) => (state.contract_status = status),
  },

  getters: {
    contract: (state) => state.contract,
    getShowAdminBtn: state => state.show_admin_btn, 
    getContractTable: state => state.contract_table, 
    getGroupFilter: state => state.group_filter, 
  },
};

const contractFormData = (contract) => {
  let formData = new FormData();
  // Append all required form data
  formData.append("contract[contract_nickname]", contract.contract_nickname); // Required
  formData.append("contract[project_code]", contract.project_code); // Required
 
  return formData;
};

export default adminStore;
