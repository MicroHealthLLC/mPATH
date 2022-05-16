const contractStore = {


  state: () => ({
   
  }),

  actions: {
  // GET Contract Project Data
  // GET Vehicles Data
  // GET POC DATA

  // POST (new) Contract Data
  // POST (new) Vehicles Data
  // POST (new) POC Data

  // UPDATE Contract Data
  // UPDATE Vehicles
  // UPDATE POC Data

  // DELETE Contract Data
  // DELETE Vehicles Data
  // DELETE POC Data

  // GET REQUESTS
    fetchContractData({ commit }, id ) {
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
    setCurrTaskPage: (state, value) => state.curr_task_page = value,
  },

  getters: {
    
  },
};

export default contractStore;
