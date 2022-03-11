import http from "./../../common/http";
import axios from "axios";
import { API_BASE_PATH } from "./../../mixins/utils";

const settingsStore = {
  state: () => ({
    show_admin_btn: false,
    user_status: true,
    edit_contract_sheet: false, 
    contract_table: [],
    group_filter: null,
    transfer_data: [],
    new_groups: [], 
    checked_portfolio_groups: [],
    checked_groups:[],
    portfolio_users: [],
    contract: {},
    contracts: [],
    check_all: false, 
    client_types: [],
    pop_days_remaining: null,
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
    portfolio_users_loaded: true,
    program_users_loaded: true,
    program_users:[],

    added_program_users_loaded:true, 
    group_status: 0,
    new_user_status: 0,
    new_contract_group_filter: null,
    new_user_loaded: true,
    new_user_id: null,
    edit_user_data:[],
    add_users_to_program:[],
    add_users_to_program_status:0,
    edit_user_data_status:0
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
      commit("TOGGLE_GROUPS_LOADED", false);
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
   updateGroupName({ commit }, { id, newNameData }) {
      commit("TOGGLE_GROUPS_LOADED", false);
      let formData = new FormData();
      // console.log(newNameData.name)
      formData.append("facility_group[name]", newNameData.name); //Required
      axios({
        method: "PUT",
        url: `${API_BASE_PATH}/facility_groups/${id}`,
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
    //
    removeOrDeleteGroup({ commit }, { g }) {
      commit("TOGGLE_GROUPS_LOADED", false);
      // Utilize utility function to prep Lesson form data
      let formData = new FormData();
      formData.append("project_id", g.programId)
      axios({
        method: "DELETE",
        url: `${API_BASE_PATH}/facility_groups/${g.id}`,
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
   updateGroup({ commit }, { groupData }) {
    //WORK IN PROGRESS (1/24/2022):  This action is to push pre-existing groups into facility_groups array
      commit("TOGGLE_GROUPS_LOADED", false);
      // Utilize utility function to prep Lesson form data
      let formData = portfolioGroupData(groupData);
      // console.log(groupData)

      axios({
        method: "PUT",
        url: `${API_BASE_PATH}/facility_groups/bulk_project_update`,
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
    fetchPortfolioUsers({ commit }) {
      commit("TOGGLE_USERS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/users`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_PORTFOLIO_USERS", res.data);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_USERS_LOADED", true);
        });
    },
    fetchProgramUsers({ commit }, id) {
      commit("TOGGLE_PROGRAM_USERS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/users.json?project_id=${id}`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_PROGRAM_USERS", res.data);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_PROGRAM_USERS_LOADED", true);
        });
    },
    updateUserData({ commit }, { userData }) {
      commit("TOGGLE_PROGRAM_USERS_LOADED", false);
      let formData = new FormData();
      console.log(userData)
      formData.append("user[first_name]", userData.fName)
      formData.append("user[last_name]", userData.lName)
      formData.append("user[email]", userData.email)
      formData.append("user[title]", userData.title)
      formData.append("user[organization_id]", userData.org)
      formData.append("user[address]", userData.address)
      formData.append("user[phone_number]", userData.phNumber)
      axios({
        method: "PATCH",
        url: `${API_BASE_PATH}/users/${userData.id}`,
        data: formData, 
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_EDIT_USER_DATA", res.data);
          commit("SET_EDIT_USER_DATA_STATUS", res.status);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_PROGRAM_USERS_LOADED", true);
        });
    },
    addUsersToProgram({ commit }, { addedUsers }) {
      commit("TOGGLE_ADDED_PROGRAM_USERS_LOADED", false);
      console.log(addedUsers);
      let formData = new FormData();

      formData.append("program_id", addedUsers.programId);
      
      addedUsers.userIds.forEach((ids) => {
        formData.append("user_ids[]",ids);
      });

      axios({
        method: "POST",
        url: `${API_BASE_PATH}/users/add_to_program`,
        data: formData, 
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_ADD_USERS_TO_PROGRAM", res.data);
          commit("SET_ADD_USERS_TO_PROGRAM_STATUS", res.status);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_ADDED_PROGRAM_USERS_LOADED", true);
        });
    },
    createNewUser({ commit }, { newUser }) {
       commit("TOGGLE_NEW_USER_LOADED", false);   
      //  console.log(newUser.fName)   
       let formData = new FormData();
        formData.append("user[first_name]", newUser.fName)
        formData.append("user[last_name]", newUser.lName)
        formData.append("user[email]", newUser.email)
        axios({
          method: "POST",
          url: `${API_BASE_PATH}/users`,
          data: formData,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((res) => {
            commit("SET_NEW_USER", res.data);
            console.log(res.data)
            commit("SET_NEW_USER_STATUS", res.status);
          })
          .catch((err) => {
            console.log(err);
          })
          .finally(() => {
            commit("TOGGLE_NEW_USER_LOADED", true);
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
          console.log(err);
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
          console.log(err);
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
          console.log(err);
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
          console.log(err);
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
          console.log(err);
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
          console.log(err);
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
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACTS_LOADED", true);
        });
    },
    fetchClientTypes({ commit }) {
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/contract_data/contract_client_types`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CLIENT_TYPES", res.data);
        })
        .catch((err) => {
          console.log(err);
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
          console.log(err);
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
          console.log(err);
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
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACTS_LOADED", true);
        });
    },
    fetchGroups({ commit }, id) {
      commit("TOGGLE_GROUPS_LOADED", false);
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/facility_groups?program_id=${id}`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_GROUPS", res.data.facility_groups);   
          commit("SET_TRANSFER_DATA", res.data.program_group_ids);        
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
          console.log(contract, id);
        })
        .catch((err) => {
          console.log(err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACTS_LOADED", true);
        });
    },
    deleteContract({ commit }, id) {
      return new Promise((resolve, reject) => {
        http
          .delete(`${API_BASE_PATH}/contracts/${id}`)
          .then((res) => {
            resolve(res.status);
          }).catch((err) => {
            console.log(err);
            reject();
          });
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
    SET_EDIT_CONTRACT_SHEET: (state, value) => (state.edit_contract_sheet = value),
    SET_CONTRACT: (state, contract) => (state.contract = contract),
    SET_CONTRACTS: (state, value) => (state.contracts = value),
    SET_CLIENT_TYPES: (state, value) => (state.client_types = value),
    SET_NEW_GROUPS: (state, value) => (state.new_groups = value),
    SET_TRANSFER_DATA: (state, value) => (state.transfer_data = value),
    SET_CONTRACT_STATUS: (state, status) => (state.contract_status = status),
    TOGGLE_CONTRACT_LOADED: (state, loaded) => (state.contract_loaded = loaded),
    TOGGLE_CONTRACTS_LOADED: (state, loaded) =>
      (state.contracts_loaded = loaded),
    TOGGLE_USERS_LOADED: (state, loaded) => (state.portfolio_users_loaded = loaded),
    TOGGLE_PROGRAM_USERS_LOADED: (state, loaded) => (state.program_users_loaded = loaded),
    TOGGLE_ADDED_PROGRAM_USERS_LOADED: (state, loaded) => (state.added_program_users_loaded = loaded),
    SET_CONTRACT_GROUP_TYPES: (state, loaded) =>
      (state.contract_group_types = loaded),
    SET_CUSTOMER_AGENCIES_FILTER: (state, loaded) =>
      (state.customer_agencies_filter = loaded),
    SET_CONTRACT_STATUSES_FILTER: (state, loaded) =>
      (state.contract_statuses_filter = loaded),
    SET_CURRENT_POP: (state, value) => (state.current_pop = value),
    SET_PRIME: (state, value) => (state.prime = value),
    SET_CHECKED_PORTFOLIO_GROUPS: (state, value)=> (state.checked_portfolio_groups = value),  
    SET_CHECK_ALL: (state, value) => (state.check_all = value), 
    SET_CONTRACT_CLASSIFICATIONS: (state, value) =>
      (state.contract_classifications = value),

    SET_USER_STATUS: (state, value) => (state.user_status = value),  
    SET_VEHICLES: (state, value) => (state.vehicle_filter = value),
    SET_VEHICLE_NUMBERS: (state, value) => (state.vehicle_number = value),
    SET_SUBCONTRACT_NUMBER: (state, value) =>
      (state.subcontract_number = value),
    SET_CONTRACT_NUMBER: (state, value) => (state.contract_number = value),
    SET_NEW_USER: (state, value) => (state.new_user_id = value),
    SET_DAYS_REMAINING: (state, value) => (state.pop_days_remaining = value),
    SET_GROUP: (state, value) => (state.group = value),
    SET_GROUPS: (state, value) => (state.groups = value),
    SET_PORTFOLIO_USERS: (state, value) => (state.portfolio_users = value),

    SET_PROGRAM_USERS: (state, value) => (state.program_users = value),
    SET_GROUP_STATUS: (state, status) => (state.group_status = status),
    TOGGLE_GROUP_LOADED: (state, loaded) => (state.group_loaded = loaded),

    SET_NEW_USER_STATUS: (state, status) => (state.new_user_status = status),

    SET_EDIT_USER_DATA: (state, value) => (state.edit_user_data = value),

    TOGGLE_NEW_USER_LOADED: (state, loaded) => (state.new_user_loaded = loaded),
    SET_EDIT_USER_DATA_STATUS:(state, status) => (state.edit_user_data_status = status),
    SET_CHECKED_GROUPS: (state, value) => (state.checked_groups = value),
    SET_ADD_USERS_TO_PROGRAM: (state, value) => (state.add_users_to_program = value),
    SET_ADD_USERS_TO_PROGRAM_STATUS: (state, status) => (state.add_users_to_program_status = status),

      
  },

  getters: {
    contract: (state) => state.contract,
    contracts: (state) => state.contracts,
    contractStatus: (state) => state.contract_status,
    getNewContractGroupFilter: (state) => state.new_contract_group_filter,    
    getClientTypes: (state) => state.client_types,
    getDaysRemaining: (state) => state.pop_days_remaining,
    editContractSheet: (state) => state.edit_contract_sheet,
    getCustomerAgenciesFilter: (state) => state.customer_agencies_filter,
    getContractStatusesFilter: (state) => state.contract_statuses_filter,
    getContractClassifications: (state) => state.contract_classifications,
    getCurrentPop: (state) => state.current_pop,
    getPrime: (state) => state.prime,
    getNewGroups: (state) => state.new_groups,
    getCheckAll: (state) => state.check_all,
    getCheckedGroups: (state) => state.checked_groups,

    getNewUserId:(state) => state.new_user_id,
    getEditUserData: (state) => state.edit_user_data,

    getCheckedPortfolioGroups: (state) => state.checked_portfolio_groups,

    getVehicles: (state) => state.vehicle_filter,
    getVehicleNumbers: (state) => state.vehicle_number,
    getSubcontractNumbers: (state) => state.subcontract_number,
    getContractNumbers: (state) => state.contract_number,

    getUserStatus: (state) => state.user_status,
    editUserDataStatus:(state) => state.edit_user_data_status,

    getTransferData: (state) => state.transfer_data, 
    getContractGroupTypes: (state) => state.contract_group_types,
    group: (state) => state.group,
    groups: (state) => state.groups,
    getPortfolioUsers: (state) => state.portfolio_users,
    programUsersLoaded: (state) => state.program_users_loaded,
    programUsers: (state) => state.program_users,
    groupStatus: (state) => state.group_status,
    groupsLoaded: (state) => state.groups_loaded,
    portfolioUsersLoaded: (state) => state.portfolio_users_loaded,
    addedProgramUsersLoaded: (state) => state.added_program_users_loaded,

    newUserStatus: (state) => state.new_user_status,
    addedUsersToProgramStatus: (state) => state.add_users_to_program_status,
    getAddedUsersToProgram: (state) => state.add_users_to_program,

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
  // console.log(contract)
  let formData = new FormData();
  // Append all required form data
  if (contract.id) {
    formData.append("contract[id]", contract.id);
    formData.append("facility_group_name", contract.facility_group_name);
  }
  formData.append("contract[facility_group_id]", contract.facility_group_id);
  formData.append("contract[contract_type_id]", contract.contract_type_id);
  formData.append("contract[project_id]", contract.project_id); //Required; This is actually the Program ID
  formData.append("contract[project_code]", contract.project_code);
  formData.append("contract[nickname]", contract.nickname); //Required
  formData.append("contract[total_subcontracts]", contract.total_subcontracts); //Required
  formData.append("contract[name]", contract.name); //Required
  formData.append("contract[notes]", contract.notes);
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
  formData.append(
    "contract[contract_client_type_id]",
    contract.contract_client_type_id
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

const portfolioGroupData = (groupData) => {
  let formData = new FormData();
  groupData.ids.forEach((ids) => {
    formData.append("facility_group_ids[]",ids);
  });
  formData.append("program_id", groupData.programId);
  return formData;
};

const newGroupName = (newNameData) => {
let formData = new FormData();
console.log(newNameData.name)
formData.append("facility_group[name]", newNameData.name); //Required
}

export default settingsStore;
