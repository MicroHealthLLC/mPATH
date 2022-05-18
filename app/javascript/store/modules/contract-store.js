const contractStore = {


  state: () => ({
    associated_contracts: [],
    associated_contracts_loaded: true,
    associated_contracts_status: 0,

    contract_data: [],
    contract_data_loaded: true,
    contract_data_status: 0,
   
  }),

  actions: {
  // GET Contract Project Data
  // GET Vehicles Data
  // GET POC DATA

  // POST (new) Contract Data
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
    fetchContractData({ commit }) {
      commit("TOGGLE_CONTRACT_DATA_LOADED", false);
   
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/contract_data/get_contract_data`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT_DATA", res.data);
          // console.log(res.data.roles)
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACT_DATA_LOADED", true);
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
    newContractData({ commit }, id ) {
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
    updateContractData({ commit }, id ) {
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

    SET_CONTRACT_DATA: (state, value) => (state.contract_data = value),
    SET_CONTRACT_DATA_STATUS: (state, status) => (state.contract_data_status = status), 
    TOGGLE_CONTRACT_DATA_LOADED: (state, loaded) => (state.contract_data_loaded = loaded),
  },

  getters: {
   associatedContracts: (state) => state.associated_contracts,
   associatedContractsStatus: (state) => state.associated_contracts_status,

   contractData: (state) => state.contract_data, 
   contractDataStatus: (state) => state.contract_data_status,

  },
};

export default contractStore;
