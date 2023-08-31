import http from "./../../common/http";
import axios from "axios";
import { API_BASE_PATH } from "./../../mixins/utils";
import AuthorizationService from "./../../services/authorization_service";

const settingsStore = {
  state: () => ({
    show_admin_btn: false,
    show_create_row: false,
    user_status: true,
    edit_contract_sheet: false,
    edit_vehicle_sheet: false,
    contract_table: [],
    vehicle_table: [],
    group_filter: null,
    transfer_data: [],
    new_groups: [],
    checked_portfolio_groups: [],
    checked_portfolio_projects: [],
    checked_groups: [],
    checked_projects: [],
    portfolio_users: [],
    portfolio_users_status: 0,
    contract: {},
    contracts: [],
    vehicles: [],
    vehicle: {},
    check_all: false,
    check_all_projects: false,
    client_types: [],
    pop_days_remaining: null,
    contract_loaded: true,
    contracts_loaded: true,
    vehicles_loaded: true,
    vehicle_loaded: true,
    contract_status: 0,
    contracts_status: 0,
    vehicles_status: 0,
    vehicle_status: 0,
    export_project_status: 0,
    duplicate_group_status: 0,
    duplicate_project_status: 0,
    move_group_status: 0,
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
    vehicle_type_filter: 0,
    contract_group_types: {},
    vehicle_group_types: {},

    portfolio_projects: [],
    portfolio_projects_loaded: true,
    portfolio_projects_status: 0,

    program_settings_projects: [],
    program_settings_projects_loaded: true,
    program_settings_projects_status: 0,

    remove_portfolio_projects_status: 0,

    group: {},
    groups: [],
    group_loaded: true,
    groups_loaded: true,
    group_status: 0,

    is_editting_role: false,
    edit_user_data: [],
    add_users_to_program: [],
    add_users_to_program_status: 0,
    edit_user_data_status: 0,
    portfolio_users_loaded: true,
    program_users_loaded: true,
    program_users: [],
    program_users_status: 0,
    added_program_users_loaded: true,
    new_user_status: 0,

    new_contract_group_filter: null,
    new_vehicle_group_filter: null,
    new_user_loaded: true,
    new_user_id: null,

    //ROLES STATES
    roles: [],
    role: {},
    roles_loaded: true,
    new_role_loaded: true,
    roles_status: 0,
    new_role_status: 0,
    updated_role_status: 0,
    updated_project_role_status: 0,
    updated_contract_role_status: 0,
    bulk_update_role_status: 0,
    bulk_update_user_role_loaded: true,
    add_user_to_role: [],
    add_user_to_role_loaded: true,
    add_user_to_role_status: 0,
    remove_role_status: 0,
    remove_project_role_status: 0,
    remove_contract_role_status: 0,
    remove_vehicle_role_status: 0,
    remove_admin_role_status: 0,
    role_removed: true,

    //PROJECT USER ROLES
    project_role_users: [],
    users_project_roles: [],
    project_role_names: [],
    bulk_project_role_names: [],
    bulk_contract_role_names: [],
    assigned_project_users: [],
    assigned_contract_users: [],
    assigned_vehicle_users: [],
    users_contract_roles: [],
    users_admin_roles: [],
    users_vehicle_roles: [],

    //VEHICLE USER ROLES
    vehicle_role_names: [],
    vehicle_role_users: [],

    //CONTRACT USER ROLES
    contract_role_users: [],
    contract_role_names: [],

    //ADMIN USER ROLES
    admin_role_users: [],
    admin_role_names: [],

    associated_projects: [],
    associated_contracts: [],
    associated_vehicles: [],
  }),
  actions: {
    createContract({ commit }, { contract }) {
      // Displays loader on front end
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Utilize utility function to prep Lesson form data
      let formData = contractFormData(contract);

      axios({
        method: "POST",
        url: `${API_BASE_PATH}/contracts?project_id=${contract.project_id}`,
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
      commit("TOGGLE_GROUPS_LOADED", false);
      let formData = groupFormData(group);
     

      axios({
        method: "POST",
        url: `${API_BASE_PATH}/program_settings/facility_groups`,
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
    moveGroup({ commit }, { group }) {

      let formData = new FormData();
      
      console.log(group);
      commit("TOGGLE_GROUPS_LOADED", false);

      formData.append("facility_group_id", group.groupId);
      formData.append("source_program_id", group.sourceProgramId);
      formData.append("target_program_id", group.targetProgramId);
      axios({
        method: "POST",
        url: `${API_BASE_PATH}/facility_groups/move_to_program.json`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {   
          commit("SET_GROUP", res.data.facility_groups);
          if(res){
            console.log(res);
            commit("SET_MOVE_GROUP_STATUS", res.status);
          }     
        })
        .catch((err) => {
          if (err.response) {
            // Request made and server responded
            console.log(err.response.data);
            commit("SET_MOVE_GROUP_STATUS", err.response.status);
            console.log(err.response.status);
            // console.log(error.response.headers);
          } else if (err.request) {
            // The request was made but no response was received
            console.log(err.request);
          }
        })
        .finally(() => {
          commit("TOGGLE_GROUPS_LOADED", true);
        });
    },
    duplicateGroup({ commit }, { group }) {

      let formData = new FormData();
      console.log(group);
      commit("TOGGLE_GROUPS_LOADED", false);
      formData.append("facility_group_id", group.groupId);
      formData.append("source_program_id", group.sourceProgramId);
      formData.append("target_program_id", group.targetProgramId);

      axios({
        method: "POST",
        url: `${API_BASE_PATH}/facility_groups/duplicate_to_program.json`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_GROUP", res.data.facility_groups);
          // commit("SET_GROUP_STATUS", res.status);
         
          if(res){
            console.log(res);
            commit("SET_DUPLICATE_GROUP_STATUS", res.status);
          }   
        })
        .catch((err) => {
          if (err.response) {
            // Request made and server responded
            console.log(err.response.data);
            commit("SET_DUPLICATE_GROUP_STATUS",  err.response.status);
            console.log(err.response.status);
            // console.log(error.response.headers);
          } else if (err.request) {
            // The request was made but no response was received
            console.log(err.request);
          }
         
        })
        .finally(() => {
          commit("TOGGLE_GROUPS_LOADED", true);
        });
    },
    exportProject({ commit }, { project }) {
      let formData = new FormData();
      console.log(project)
      commit("TOGGLE_GROUPS_LOADED", false);

      formData.append("facility_id", project.projectId);
      formData.append("source_program_id", project.sourceProgramId);
      formData.append("target_program_id", project.targetProgramId);
      formData.append("target_facility_group_id", project.targetGroupId);

      axios({
        method: "POST",
        url: `${API_BASE_PATH}/facilities/move_to_program.json`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
        if(res){
            console.log(res);
            commit("SET_EXPORT_PROJECT_STATUS", res.status);
          }   
        })
        .catch((err) => {
          console.log("Error",err);    
          if (err.response) {
            // Request made and server responded
            console.log(err.response.data);
            commit("SET_EXPORT_PROJECT_STATUS",err.response.status);
            console.log(err.response.status);
            // console.log(error.response.headers);
          } else if (err.request) {
            // The request was made but no response was received
            console.log(err.request);
          }
        })
        .finally(() => {
          commit("TOGGLE_GROUPS_LOADED", true);
        });
    },
    duplicateProject({ commit }, { project }) {
      let formData = new FormData();
      console.log(project)
      commit("TOGGLE_GROUPS_LOADED", false);
      formData.append("facility_id", project.projectId);
      formData.append("source_program_id", project.sourceProgramId);
      formData.append("target_program_id", project.targetProgramId);
      formData.append("target_facility_group_id", project.targetGroupId);
      axios({
        method: "POST",
        url: `${API_BASE_PATH}/facilities/duplicate_to_program.json`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          if(res){
            console.log(res);
            commit("SET_DUPLICATE_PROJECT_STATUS", res.status);
          }   
        })
        .catch((err) => {
          console.log("Error",err);    
          if (err.response) {
            // Request made and server responded
            console.log(err.response.data);
            commit("SET_DUPICATE_PROJECT_STATUS",err.response.status);
            console.log(err.response.status);
            // console.log(error.response.headers);
          } else if (err.request) {
            // The request was made but no response was received
            console.log(err.request);
          }
        })
        .finally(() => {
          commit("TOGGLE_GROUPS_LOADED", true);
        });
    },
    updateGroupName({ commit }, { id, newNameData, project_id }) {
      commit("TOGGLE_GROUPS_LOADED", false);
      let formData = new FormData();
      // console.log(newNameData.name)
      formData.append("facility_group[name]", newNameData.name); //Required
      formData.append("project_id", project_id);
      axios({
        method: "PUT",
        url: `${API_BASE_PATH}/program_settings/facility_groups/${id}`,
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
    removeContract({ commit }, { g }) {
      commit("TOGGLE_CONTRACT_LOADED", false);
      console.log(g);
      axios({
        method: "DELETE",
        url: `${API_BASE_PATH}/program_settings/contracts/${g.id}?project_id=${g.pId}`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT", res.data.contracts);
          commit("SET_CONTRACT_STATUS", res.status);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACT_LOADED", true);
        });
    },
    removeVehicle({ commit }, { g }) {
      commit("TOGGLE_VEHICLE_LOADED", false);
      console.log(g);
      axios({
        method: "DELETE",
        url: `${API_BASE_PATH}/program_settings/contract_vehicles/${g.id}?project_id=${g.pId}`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_VEHICLE", res.data.vehicles);
          commit("SET_VEHICLE_STATUS", res.status);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_VEHICLE_LOADED", true);
        });
    },
    //
    removeOrDeleteGroup({ commit }, { g }) {
      commit("TOGGLE_GROUPS_LOADED", false);
      let formData = new FormData();
      formData.append("project_id", g.programId);
      axios({
        method: "DELETE",
        url: `${API_BASE_PATH}/program_settings/facility_groups/${g.id}`,
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
    removePortfolioProject({ commit }, { fpId, pId }) {
      commit("TOGGLE_PROGRAM_PROJECTS", false);
      axios({
        method: "DELETE",
        url: `${API_BASE_PATH}/program_settings/facilities/remove_facility_project?facility_project_id=${fpId}&project_id=${pId}`,
        // data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_PROGRAM_PROJECTS", res.data.facilities);
          // console.log(res)
          commit("SET_REMOVE_PORTFOLIO_PROJECTS_STATUS", res.status);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_PROGRAM_PROJECTS_LOADED", true);
        });
    },
    //*****************ROLES ACTIONS BELOW*******************

    //FETCH ROLES
    fetchRoles({ commit }, id) {
      commit("TOGGLE_ROLES_LOADED", false);

      axios({
        method: "GET",
        url: `${API_BASE_PATH}/program_settings/roles?project_id=${id}`,
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
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_ROLES_LOADED", true);
        });
    },

    //POST NEW ROLE
    createRole({ commit }, { role }) {
      let formData = new FormData();
      // console.log(role)
      formData.append("role[name]", role.name); //Required
      formData.append("role[project_id]", role.pId);
      formData.append("role[type_of]", role.type);
      formData.append("role[user_id]", role.uId);
      role.rp.forEach((p) => {
        formData.append("role[role_privileges][][privilege]", p.privilege);
        formData.append("role[role_privileges][][role_type]", p.role_type);
        formData.append("role[role_privileges][][name]", p.name);
      });

      commit("TOGGLE_NEW_ROLE_LOADED", false);
      axios({
        method: "POST",
        url: `${API_BASE_PATH}/program_settings/roles?project_id=${role.pId}&all=true`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_ROLE", res.data);
          //  console.log(res.data)
          commit("SET_NEW_ROLE_STATUS", res.status);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_NEW_ROLE_LOADED", true);
        });
    },
    // UPDATE ROLE
    updateRole({ commit }, { role }) {
      let formData = new FormData();
      // console.log(role)
      formData.append("role[name]", role.name); //Required
      formData.append("role[id]", role.id); //Required
      formData.append("role[project_id]", role.pId);
      formData.append("role[type_of]", role.type);
      formData.append("role[user_id]", role.uId);
      role.rp.forEach((p) => {
        formData.append("role[role_privileges][][privilege]", p.privilege);
        formData.append("role[role_privileges][][role_type]", p.role_type);
        formData.append("role[role_privileges][][name]", p.name);
        formData.append("role[role_privileges][][id]", p.id);
      });
      commit("TOGGLE_NEW_ROLE_LOADED", false);
      axios({
        method: "PUT",
        url: `${API_BASE_PATH}/program_settings/roles/${role.id}?project_id=${role.pId}&all=true`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          //  commit("SET_ROLE", res.data);
          commit("SET_ROLE", res.data);
          // console.log(res.data.role.type_of)
          if (res.data && res.data.role.type_of == "admin") {
            commit("SET_UPDATED_ROLE_STATUS", res.status);
          }
          if (res.data && res.data.role.type_of == "project") {
            commit("SET_UPDATED_PROJECT_ROLE_STATUS", res.status);
          }
          if (res.data && res.data.role.type_of == "contract") {
            commit("SET_UPDATED_CONTRACT_ROLE_STATUS", res.status);
          }
          AuthorizationService.getRolePrivileges();
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_NEW_ROLE_LOADED", true);
        });
    },
    //ADD USER TO ROLE
    addUserToRole({ commit }, { userData }) {
      // let formData =  userRoleData(userData);
      //console.log(userData);
      let formData = new FormData();
      if (userData.projectIds) {
        userData.projectIds.forEach((ids) => {
          formData.append("role_users[][user_id]", userData.userId);
          formData.append("role_users[][project_id]", userData.programId);
          formData.append("role_users[][role_id]", userData.roleId);
          formData.append("role_users[][facility_project_id]", ids);
        });
      }

      if (userData.contractIds) {
        userData.contractIds.forEach((ids) => {
          formData.append("role_users[][user_id]", userData.userId);
          formData.append("role_users[][project_id]", userData.programId);
          formData.append("role_users[][role_id]", userData.roleId);
          formData.append("role_users[][project_contract_id]", ids);
        });
      }

      if (userData.vehicleIds) {
        userData.vehicleIds.forEach((ids) => {
          formData.append("role_users[][user_id]", userData.userId);
          formData.append("role_users[][project_id]", userData.programId);
          formData.append("role_users[][role_id]", userData.roleId);
          formData.append("role_users[][project_contract_vehicle_id]", ids);
        });
      }

      if (userData.adminRole) {
        formData.append("role_users[][user_id]", userData.userId);
        formData.append("role_users[][project_id]", userData.programId);
        formData.append("role_users[][role_id]", userData.roleId);
      }

      if (userData.userIds) {
        userData.userIds.forEach((ids) => {
          formData.append("role_users[][user_id]", ids);
          formData.append("role_users[][project_id]", userData.programId);
          if (userData.roleId) {
            formData.append("role_users[][role_id]", userData.roleId);
          }
          if (userData.projectId) {
            formData.append(
              "role_users[][facility_project_id]",
              userData.projectId
            );
          }
          if (userData.contractId) {
            formData.append(
              "role_users[][project_contract_id]",
              userData.contractId
            );
          }
          if (userData.vehicleId) {
            formData.append(
              "role_users[][project_contract_vehicle_id]",
              userData.vehicleId
            );
          }
        });
      }
      commit("TOGGLE_NEW_ROLE_LOADED", false);
      axios({
        method: "POST",
        url: `${API_BASE_PATH}/program_settings/roles/${userData.roleId}/add_users?project_id=${userData.programId}&all=true`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          //  commit("SET_ADD_USER_TO_ROLE", res.data.roles);
          commit("SET_NEW_ROLE", res);
          // console.log(res)
          commit("SET_ADD_USER_TO_ROLE_STATUS", res.status);
          AuthorizationService.getRolePrivileges();
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_ADD_USER_TO_ROLE_LOADED", true);
        });
    },
    //REMOVE USER FROM ROLE OR PROJECT OR CONTRACT
    removeUserRole({ commit }, { userData }) {
      // let formData =  userRoleData(userData);
      let formData = new FormData();
      console.log(userData)

      if (userData.removeRole) {
        formData.append("user_id", userData.userId);
        formData.append("project_id", userData.programId);
        formData.append("role_id", userData.roleId);
      }

      if (userData.projectIds) {
        formData.append("role_from_users", true);
        userData.projectIds.forEach((ids) => {
          formData.append("user_id", userData.userId);
          formData.append("project_id", userData.programId);
          formData.append("role_id", userData.roleId);
          formData.append("facility_project_id[]", ids);
        });
      }

      if (userData.contractIds) {
        formData.append("role_from_users", true);
        userData.contractIds.forEach((ids) => {
          formData.append("user_id", userData.userId);
          formData.append("project_id", userData.programId);
          formData.append("role_id", userData.roleId);
          formData.append("project_contract_id[]", ids);
        });
      }
      if (userData.vehicleIds) {
        formData.append("role_from_users", true);
        userData.vehicleIds.forEach((ids) => {
          formData.append("user_id", userData.userId);
          formData.append("project_id", userData.programId);
          formData.append("role_id", userData.roleId);
          formData.append("project_contract_vehicle_id[]", ids);
        });
      }
      if (userData.adminRole || userData.adminRoleIndex) {
        formData.append("role_from_users", true);
        formData.append("user_id[]", userData.userId);
        formData.append("project_id", userData.programId);
        formData.append("role_id", userData.roleId);
      }

      if (userData.userIds) {
        // formData.append("role_from_users", true);
        userData.userIds.forEach((ids) => {
          formData.append("user_id[]", ids);
          // formData.append("project_id", userData.programId)
          if (userData.roleId) {
            formData.append("role_id", userData.roleId);
          }
          if (userData.projectId) {
            formData.append("users_from_project_role", true);
            formData.append("facility_project_id", userData.projectId);
          }
          if (userData.contractId) {
            formData.append("users_from_contract_role", true);
            formData.append("project_contract_id", userData.contractId);
          }
          if (userData.vehicleId) {
            formData.append("users_from_contract_role", true);
            formData.append("project_contract_vehicle_id", userData.vehicleId);
          }
        });
      }

      commit("TOGGLE_ROLE_REMOVED", false);
      axios({
        method: "POST",
        url: `${API_BASE_PATH}/program_settings/roles/remove_role?project_id=${userData.programId}&all=true`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
           console.log(res)
          //  commit("SET_ADD_USER_TO_ROLE", res.data.roles);
          // commit("SET_NEW_ROLE", res);
          AuthorizationService.getRolePrivileges();
          if (
            userData.projectIds ||
            userData.contractIds ||
            userData.vehicleIds ||
            userData.adminRole ||
            userData.removeRole
          ) {
            console.log("removed from ProgramSettingUsers");
            commit("SET_REMOVE_ROLE_STATUS", res.status);
          }
          if (userData.adminRoleIndex) {
            console.log("removed from ProgramSettingRoles");
            commit("SET_REMOVE_ADMIN_ROLE_STATUS", res.status);
          }

          if (userData.userIds && userData.projectId) {
            console.log("removed from ProgramSettingProjects");
            commit("SET_REMOVE_PROJECT_ROLE_STATUS", res.status);
          }

          if (userData.userIds && userData.contractId) {
            console.log("removed from ProgramSettingContracts");
            commit("SET_REMOVE_CONTRACT_ROLE_STATUS", res.status);
          }

          if (userData.userIds && userData.vehicleId) {
            console.log("removed from ProgramSettingVehicles");
            commit("SET_REMOVE_VEHICLE_ROLE_STATUS", res.status);
          }
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_ROLE_REMOVED", true);
        });
    },
    bulkUpdateUserRoles({ commit }, { userData }) {
      // let formData =  userRoleData(userData);

      let formData = new FormData();
      userData.roleUserIds.forEach((id) => {
        formData.append("role_user_ids[]", id);
      });
      formData.append("project_id", userData.programId);
      formData.append("role_id", userData.roleId);
      formData.append("old_role_id", userData.oldRoleId);
      userData.userIds.forEach((id) => {
        formData.append("user_ids[]", id);
      });
      console.log(userData);

      commit("TOGGLE_NEW_ROLE_LOADED", false);
      axios({
        method: "POST",
        url: `${API_BASE_PATH}/program_settings/roles/update_role_users`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_NEW_ROLE", res);
          console.log(res);
          commit("SET_ADD_USER_TO_ROLE_STATUS", res.status);
          AuthorizationService.getRolePrivileges();
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_ADD_USER_TO_ROLE_LOADED", true);
        });
    },

    //*****************ROLES ACTIONS ABOVE*******************

    updateGroup({ commit }, { groupData }) {
      commit("TOGGLE_GROUPS_LOADED", false);
      // Utilize utility function to prep Lesson form data
      let formData = portfolioGroupData(groupData);
      // console.log(groupData)

      axios({
        method: "PUT",
        url: `${API_BASE_PATH}/program_settings/facility_groups/bulk_project_update`,
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
    updateProjects({ commit }, { groupData }) {
      commit("TOGGLE_PROGRAM_SETTINGS_PROJECTS_LOADED", false);
      // Utilize utility function to prep Lesson form data
      let formData = portfolioProjectsData(groupData);
      axios({
        method: "PUT",
        url: `${API_BASE_PATH}/program_settings/facilities/bulk_projects_update?project_id=${groupData.programId}`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_PROGRAM_SETTINGS_PROJECTS", res.data.facilities);
          console.log(res.data);
          commit("SET_PROGRAM_SETTINGS_PROJECTS_STATUS", res.status);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_PROGRAM_SETTINGS_PROJECTS_LOADED", true);
        });
    },
    fetchContract({ commit }, { id, programId }) {
      console.log(id, programId);
      commit("TOGGLE_CONTRACT_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/program_settings/contracts/${id}?project_id=${programId}`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACT", res.data.contract);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACT_LOADED", true);
        });
    },
    fetchContracts({ commit }, id) {
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/program_settings/contracts?project_id=${id}`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CONTRACTS", res.data.contracts);
          // console.log(res.data.contracts);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_CONTRACTS_LOADED", true);
        });
    },
    fetchVehicle({ commit }, { id, programId }) {
      console.log(id, programId);
      commit("TOGGLE_VEHICLE_LOADED", false);
      // Retrieve vehicle by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/program_settings/contract_vehicles/${id}?project_id=${programId}`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_VEHICLE", res.data.vehicle);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_VEHICLE_LOADED", true);
        });
    },
    fetchVehicles({ commit }, id) {
      commit("TOGGLE_VEHICLES_LOADED", false);
      // Retrieve vehicle by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/program_settings/contract_vehicles?project_id=${id}`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_VEHICLES", res.data.contract_vehicles);
          //console.log(res.data.contract_vehicles);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_VEHICLES_LOADED", true);
        });
    },
    fetchPortfolioUsers({ commit }, id) {
      commit("TOGGLE_USERS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/program_settings/users?program_id=${id}&all=true`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_PORTFOLIO_USERS", res.data);
        })
        .catch((err) => {
          console.log("Error",err);
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
        url: `${API_BASE_PATH}/program_settings/users.json?program_id=${id}`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_PROGRAM_USERS", res.data);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_PROGRAM_USERS_LOADED", true);
        });
    },
      updateUserData({ commit }, { userData, program_id }) {
      commit("TOGGLE_PROGRAM_USERS_LOADED", false);
      let formData = new FormData();
      console.log(userData);
      formData.append("user[first_name]", userData.fName);
      formData.append("user[last_name]", userData.lName);
      formData.append("user[email]", userData.email);
      formData.append("user[title]", userData.title);
      formData.append("user[organization_id]", userData.org);
      formData.append("user[address]", userData.address);
      formData.append("user[phone_number]", userData.phNumber);
      formData.append("program_id", program_id);
      axios({
        method: "PATCH",
        url: `${API_BASE_PATH}/program_settings/users/${userData.id}`,
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
          console.log("Error",err);
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
        formData.append("user_ids[]", ids);
      });

      axios({
        method: "POST",
        url: `${API_BASE_PATH}/program_settings/users/add_to_program`,
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
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_ADDED_PROGRAM_USERS_LOADED", true);
        });
    },
    createNewUser({ commit }, { newUser }) {
      commit("TOGGLE_NEW_USER_LOADED", false);
      //  console.log(newUser.fName)
      let formData = new FormData();
      formData.append("user[first_name]", newUser.fName);
      formData.append("user[last_name]", newUser.lName);
      formData.append("user[email]", newUser.email);
      formData.append("program_id", newUser.pId);
      axios({
        method: "POST",
        url: `${API_BASE_PATH}/program_settings/users`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_NEW_USER", res.data);
          console.log(res.data);
          commit("SET_NEW_USER_STATUS", res.status);
        })
        .catch((err) => {
          console.log("Error",err);
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
        url: `${API_BASE_PATH}/program_settings/contract_data/contract_types`,
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
    fetchVehicleGroupTypes({ commit }) {
      commit("TOGGLE_VEHICLES_LOADED", false);
      // Retrieve vehicle by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/vehicle_data/vehicle_types`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_VEHICLE_GROUP_TYPES", res.data);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_VEHICLES_LOADED", true);
        });
    },
    fetchClassificationTypes({ commit }) {
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/program_settings/contract_data/contract_classification`,
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
        url: `${API_BASE_PATH}/program_settings/contract_data/contract_customeres`,
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
        url: `${API_BASE_PATH}/program_settings/contract_data/contract_current_pop`,
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
        url: `${API_BASE_PATH}/program_settings/contract_data/contract_prime`,
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
    /* fetchVehicles({ commit }) {
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/program_settings/contract_data/contract_vehicles`,
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
    }, */
    fetchVehicleNumbers({ commit }) {
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/program_settings/contract_data/contract_vehicle_number`,
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
    fetchClientTypes({ commit }) {
      commit("TOGGLE_CONTRACTS_LOADED", false);
      // Retrieve contract by id
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/program_settings/contract_data/contract_client_types`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_CLIENT_TYPES", res.data);
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
        url: `${API_BASE_PATH}/program_settings/contract_data/contract_number`,
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
        url: `${API_BASE_PATH}/program_settings/contract_data/subcontract_number`,
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
        url: `${API_BASE_PATH}/program_settings/contract_data/contract_statuses`,
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
    fetchGroups({ commit }, id) {
      commit("TOGGLE_GROUPS_LOADED", false);
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/program_settings/facility_groups?project_id=${id}&all=true`,
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
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_GROUPS_LOADED", true);
        });
    },
    fetchPortfolioProjects({ commit }, id) {
      commit("TOGGLE_PORTFOLIO_PROJECTS_LOADED", false);
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/program_settings/facilities?project_id=${id}`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit(
            "SET_PORTFOLIO_PROJECTS",
            res.data.facilities.filter((t) => t.status == "active")
          );
          // console.log(res.data.facilities.filter(t => t.status == "active").length);
          // console.log(res.data.facilities.length);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_PORTFOLIO_PROJECTS_LOADED", true);
        });
    },
    fetchProgramSettingsProjects({ commit }, id) {
      commit("TOGGLE_PROGRAM_SETTINGS_PROJECTS_LOADED", false);
      axios({
        method: "GET",
        url: `${API_BASE_PATH}/program_settings/facilities?project_id=${id}`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_PROGRAM_SETTINGS_PROJECTS", res.data.facilities);
          // console.log(res.data.facilities);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_PROGRAM_SETTINGS_PROJECTS_LOADED", true);
        });
    },
    updateContract({ commit }, { contract, id }) {
      // Displays loader on front end
      commit("TOGGLE_CONTRACTS_LOADED", false);
      let formData = new FormData();
      // Utilize utility function to prep Lesson form data
      // let formData = contractFormData(contract);
      formData.append("project_id", contract.programId);
      formData.append(
        "project_contract[facility_group_id]",
        contract.facility_group_id
      );
      axios({
        method: "PUT",
        url: `${API_BASE_PATH}/program_settings/contracts/${id}`,
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
    deleteContract({ commit }, id) {
      return new Promise((resolve, reject) => {
        http
          .delete(`${API_BASE_PATH}/program_settings/contracts/${id}`)
          .then((res) => {
            MessageDialogService.showDialog({
              response: res
            });
            resolve(res.status);
          })
          .catch((err) => {
            console.log("Error",err);
            reject();
          });
      });
    },
    updateVehicle({ commit }, { vehicle, id }) {
      console.log("vehicles")
      // Displays loader on front end
      commit("TOGGLE_VEHICLES_LOADED", false);
      let formData = new FormData();
      // Utilize utility function to prep Lesson form data
      // let formData = vehicleFormData(vehicle);
      formData.append("project_id", vehicle.programId);
      formData.append(
        "project_contract_vehicle[facility_group_id]",
        vehicle.facility_group_id
      );
      axios({
        method: "PUT",
        url: `${API_BASE_PATH}/program_settings/contract_vehicles/${id}`,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_VEHICLE", res.data.vehicle);
          commit("SET_VEHICLE_STATUS", res.status);
          console.log(vehicle, id);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_VEHICLES_LOADED", true);
        });
    },
    deleteVehicle({ commit }, id) {
      return new Promise((resolve, reject) => {
        http
          .delete(`${API_BASE_PATH}/program_settings/contract_vehicles/${id}`)
          .then((res) => {
            MessageDialogService.showDialog({
              response: res
            });
            resolve(res.status);
          })
          .catch((err) => {
            console.log("Error",err);
            reject();
          });
      });
    }, 
    removeProgramUser({ commit }, { userData }) {
      commit("TOGGLE_PROGRAM_USERS_LOADED", false);
      let formData = new FormData();

      formData.append("program_id", userData.programId);
      formData.append("user_id", userData.id);

      axios({
        method: "DELETE",
        data: formData,
        url: `${API_BASE_PATH}/program_settings/users/remove_from_program`,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((res) => {
          commit("SET_PROGRAM_USERS", res.data);
          commit("SET_PROGRAM_USERS_STATUS", res.status);
        })
        .catch((err) => {
          console.log("Error",err);
        })
        .finally(() => {
          commit("TOGGLE_PROGRAM_USERS_LOADED", true);
        });
    },
    deleteProgramProject({ commit }, { programId, id }) {
      return new Promise((resolve, reject) => {
        http
          .delete(`${API_BASE_PATH}/program_settings/facilities/${id}?project_id=${programId}`)
          .then((res) => {
            MessageDialogService.showDialog({
              response: res
            });
            resolve(res.status);
          })
          .catch((err) => {
            console.log("Error",err);
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

    // VEHICLES
    setVehicleTypeFilter: (state, value) => (state.vehicle_type_filter = value),
    setVehicleTable: (state, value) => (state.vehicle_table = value),
    setNewVehicleGroupFilter: (state, loaded) =>
      (state.new_vehicle_group_filter = loaded),

    SET_IS_EDITTING_ROLE: (state, value) => (state.is_editting_role = value),
    SET_PROJECT_ROLE_USERS: (state, value) =>
      (state.project_role_users = value),
    SET_ASSIGNED_PROJECT_USERS: (state, value) =>
      (state.assigned_project_users = value),
    SET_ASSIGNED_CONTRACT_USERS: (state, value) =>
      (state.assigned_contract_users = value),

    SET_USERS_PROJECT_ROLES: (state, value) =>
      (state.users_project_roles = value),
    SET_USERS_CONTRACT_ROLES: (state, value) =>
      (state.users_contract_roles = value),
    SET_USERS_ADMIN_ROLES: (state, value) => (state.users_admin_roles = value),
    SET_PROJECT_ROLE_NAMES: (state, value) =>
      (state.project_role_names = value),
    SET_BULK_PROJECT_ROLE_NAMES: (state, value) =>
      (state.bulk_project_role_names = value),
    SET_BULK_CONTRACT_ROLE_NAMES: (state, value) =>
      (state.bulk_contract_role_names = value),
    SET_CONTRACT_ROLE_USERS: (state, value) =>
      (state.contract_role_users = value),
    SET_CONTRACT_ROLE_NAMES: (state, value) =>
      (state.contract_role_names = value),

    // VEHICLES
    SET_ASSIGNED_VEHICLE_USERS: (state, value) =>
      (state.assigned_vehicle_users = value),
    SET_BULK_VEHICLE_ROLE_NAMES: (state, value) =>
      (state.bulk_vehicle_role_names = value),
    SET_VEHICLE_ROLE_USERS: (state, value) =>
      (state.vehicle_role_users = value),
    SET_VEHICLE_ROLE_NAMES: (state, value) =>
      (state.vehicle_role_names = value),
    SET_USERS_VEHICLE_ROLES: (state, value) =>
      (state.users_vehicle_roles = value),
    SET_ASSOCIATED_VEHICLES: (state, value) =>
      (state.associated_vehicles = value),
    SET_EDIT_VEHICLE_SHEET: (state, value) =>
      (state.edit_vehicle_sheet = value),

    SET_ADMIN_ROLE_USERS: (state, value) => (state.admin_role_users = value),
    SET_ADMIN_ROLE_NAMES: (state, value) => (state.admin_role_names = value),

    SET_ASSOCIATED_PROJECTS: (state, value) =>
      (state.associated_projects = value),
    SET_ASSOCIATED_CONTRACTS: (state, value) =>
      (state.associated_contracts = value),

    SET_EDIT_CONTRACT_SHEET: (state, value) =>
      (state.edit_contract_sheet = value),

    SET_SHOW_CREATE_ROW: (state, value) => (state.show_create_row = value),
    SET_CONTRACT: (state, contract) => (state.contract = contract),
    SET_CONTRACTS: (state, value) => (state.contracts = value),
    SET_CONTRACTS_STATUS: (state, value) => (state.contracts_status = value),
    SET_CLIENT_TYPES: (state, value) => (state.client_types = value),
    SET_NEW_GROUPS: (state, value) => (state.new_groups = value),
    SET_TRANSFER_DATA: (state, value) => (state.transfer_data = value),
    SET_CONTRACT_STATUS: (state, status) => (state.contract_status = status),
    TOGGLE_CONTRACT_LOADED: (state, loaded) => (state.contract_loaded = loaded),
    TOGGLE_CONTRACTS_LOADED: (state, loaded) =>
      (state.contracts_loaded = loaded),

    // VEHICLES
    SET_VEHICLE: (state, value) => (state.vehicle = value),
    SET_VEHICLE_STATUS: (state, value) => (state.vehicle_status = value),
    SET_VEHICLES_STATUS: (state, value) => (state.vehicles_status = value),
    TOGGLE_VEHICLE_LOADED: (state, loaded) => (state.vehicle_loaded = loaded),
    TOGGLE_VEHICLES_LOADED: (state, loaded) => (state.vehicles_loaded = loaded),
    SET_VEHICLES: (state, value) => (state.vehicles = value),

    //ROLES MUTATIONS
    TOGGLE_ROLES_LOADED: (state, loaded) => (state.roles_loaded = loaded),
    SET_ROLES: (state, value) => (state.roles = value),
    SET_ROLE: (state, value) => (state.role = value),
    TOGGLE_NEW_ROLE_LOADED: (state, loaded) => (state.new_role_loaded = loaded),
    SET_NEW_ROLE_STATUS: (state, status) => (state.new_role_status = status),
    SET_UPDATED_ROLE_STATUS: (state, status) =>
      (state.updated_role_status = status),
    SET_UPDATED_PROJECT_ROLE_STATUS: (state, status) =>
      (state.updated_project_role_status = status),
    SET_UPDATED_CONTRACT_ROLE_STATUS: (state, status) =>
      (state.updated_contract_role_status = status),
    SET_UPDATED_VEHICLE_ROLE_STATUS: (state, status) =>
      (state.updated_vehicle_role_status = status),
    TOGGLE_ADD_USER_TO_ROLE_LOADED: (state, loaded) =>
      (state.add_user_to_role_loaded = loaded),
    TOGGLE_BULK_UPDATE_USER_ROLE_LOADED: (state, loaded) =>
      (state.bulk_update_user_role_loaded = loaded),

    SET_ADD_USER_TO_ROLE_STATUS: (state, status) =>
      (state.add_user_to_role_status = status),
    SET_BULK_UPDATE_ROLE_STATUS: (state, status) =>
      (state.bulk_update_role_status = status),

    SET_REMOVE_ROLE_STATUS: (state, status) =>
      (state.remove_role_status = status),
    SET_REMOVE_PROJECT_ROLE_STATUS: (state, status) =>
      (state.remove_project_role_status = status),
    SET_REMOVE_CONTRACT_ROLE_STATUS: (state, status) =>
      (state.remove_contract_role_status = status),
    SET_REMOVE_VEHICLE_ROLE_STATUS: (state, status) =>
      (state.remove_vehicle_role_status = status),
    SET_REMOVE_ADMIN_ROLE_STATUS: (state, status) =>
      (state.remove_admin_role_status = status),
    TOGGLE_ROLE_REMOVED: (state, loaded) => (state.role_removed = loaded),

    //USERS MUTATIONS
    TOGGLE_USERS_LOADED: (state, loaded) =>
      (state.portfolio_users_loaded = loaded),
    TOGGLE_PROGRAM_USERS_LOADED: (state, loaded) =>
      (state.program_users_loaded = loaded),
    TOGGLE_ADDED_PROGRAM_USERS_LOADED: (state, loaded) =>
      (state.added_program_users_loaded = loaded),
    SET_NEW_USER_STATUS: (state, status) => (state.new_user_status = status),
    SET_EDIT_USER_DATA: (state, value) => (state.edit_user_data = value),
    TOGGLE_NEW_USER_LOADED: (state, loaded) => (state.new_user_loaded = loaded),
    SET_EDIT_USER_DATA_STATUS: (state, status) =>
      (state.edit_user_data_status = status),
    SET_ADD_USERS_TO_PROGRAM: (state, value) =>
      (state.add_users_to_program = value),
    SET_ADD_USERS_TO_PROGRAM_STATUS: (state, status) =>
      (state.add_users_to_program_status = status),

    SET_CONTRACT_GROUP_TYPES: (state, loaded) =>
      (state.contract_group_types = loaded),
    SET_CUSTOMER_AGENCIES_FILTER: (state, loaded) =>
      (state.customer_agencies_filter = loaded),
    SET_CONTRACT_STATUSES_FILTER: (state, loaded) =>
      (state.contract_statuses_filter = loaded),
    SET_CURRENT_POP: (state, value) => (state.current_pop = value),
    SET_PRIME: (state, value) => (state.prime = value),
    SET_CHECKED_PORTFOLIO_GROUPS: (state, value) =>
      (state.checked_portfolio_groups = value),
    SET_CHECKED_PORTFOLIO_PROJECTS: (state, value) =>
      (state.checked_portfolio_projects = value),
    SET_CHECK_ALL: (state, value) => (state.check_all = value),
    SET_CHECK_ALL_PROJECTS: (state, value) =>
      (state.check_all_projects = value),
    SET_CONTRACT_CLASSIFICATIONS: (state, value) =>
      (state.contract_classifications = value),

    SET_VEHICLE_GROUP_TYPES: (state, loaded) =>
      (state.vehicle_group_types = loaded),
    SET_VEHICLE_STATUSES_FILTER: (state, loaded) =>
      (state.vehicle_statuses_filter = loaded),
    SET_VEHICLE_CLASSIFICATIONS: (state, value) =>
      (state.vehicle_classifications = value),

    SET_USER_STATUS: (state, value) => (state.user_status = value),
    //SET_VEHICLES: (state, value) => (state.vehicle_filter = value),
    //SET_VEHICLE_NUMBERS: (state, value) => (state.vehicle_number = value),
    SET_SUBCONTRACT_NUMBER: (state, value) =>
      (state.subcontract_number = value),
    SET_CONTRACT_NUMBER: (state, value) => (state.contract_number = value),
    SET_VEHICLE_NUMBER: (state, value) => (state.vehicle_number = value),
    SET_NEW_USER: (state, value) => (state.new_user_id = value),
    SET_DAYS_REMAINING: (state, value) => (state.pop_days_remaining = value),

    SET_PORTFOLIO_PROJECTS: (state, value) =>
      (state.portfolio_projects = value),
    SET_GROUP: (state, value) => (state.group = value),
    SET_GROUPS: (state, value) => (state.groups = value),
    SET_PORTFOLIO_USERS: (state, value) => (state.portfolio_users = value),
    SET_PORTFOLIO_USERS_STATUS: (state, value) =>
      (state.portfolio_users_status = value),

    SET_PROGRAM_USERS: (state, value) => (state.program_users = value),
    SET_PROGRAM_USERS_STATUS: (state, value) =>
      (state.program_users_status = value),
    SET_GROUP_STATUS: (state, status) => (state.group_status = status),
    SET_MOVE_GROUP_STATUS: (state, value) => (state.move_group_status = value),
    SET_EXPORT_PROJECT_STATUS: (state, value) => (state.export_project_status = value),

    SET_DUPLICATE_GROUP_STATUS: (state, value) => (state.duplicate_group_status = value),
    SET_DUPLICATE_PROJECT_STATUS: (state, value) => (state.duplicate_project_status = value),

    SET_PORTFOLIO_PROJECTS_STATUS: (state, status) =>
      (state.portfolio_projects_status = status),

    SET_PROGRAM_SETTINGS_PROJECTS: (state, value) =>
      (state.program_settings_projects = value),
    SET_PROGRAM_SETTINGS_PROJECTS_STATUS: (state, status) =>
      (state.program_settings_projects_status = status),
    SET_REMOVE_PORTFOLIO_PROJECTS_STATUS: (state, status) =>
      (state.remove_portfolio_projects_status = status),
    TOGGLE_PROGRAM_SETTINGS_PROJECTS_LOADED: (state, loaded) =>
      (state.program_settings_projects_loaded = loaded),

    TOGGLE_GROUP_LOADED: (state, loaded) => (state.group_loaded = loaded),
    TOGGLE_GROUPS_LOADED: (state, loaded) => (state.groups_loaded = loaded),
    SET_CHECKED_GROUPS: (state, value) => (state.checked_groups = value),
    TOGGLE_PORTFOLIO_PROJECTS_LOADED: (state, loaded) =>
      state.portfolio_projects_loaded,
  },

  getters: {
    //ROLES GETTERS
    getRole: (state) => state.role,
    getRoles: (state) => state.roles,
    getProjectRoleUsers: (state) => state.project_role_users,
    getAssignedProjectUsers: (state) => state.assigned_project_users,
    getAssignedContractUsers: (state) => state.assigned_contract_users,
    getAssignedVehicleUsers: (state) => state.assigned_vehicle_users,

    getUsersProjectRoles: (state) => state.users_project_roles,
    getUsersContractRoles: (state) => state.users_contract_roles,
    getUsersAdminRoles: (state) => state.users_admin_roles,

    getProjectRoleNames: (state) => state.project_role_names,
    getBulkProjectRoleNames: (state) => state.bulk_project_role_names,
    getBulkContractRoleNames: (state) => state.bulk_contract_role_names,

    isEdittingRole: (state) => state.is_editting_role,

    bulkUpdateRoleStatus: (state) => state.bulk_update_role_status,

    getContractRoleUsers: (state) => state.contract_role_users,
    getContractRoleNames: (state) => state.contract_role_names,

    getAdminRoleUsers: (state) => state.admin_role_users,
    getAdminRoleNames: (state) => state.admin_role_names,

    getAssociatedProjects: (state) => state.associated_projects,
    getAssociatedContracts: (state) => state.associated_contracts,
    getAssociatedVehicles: (state) => state.associated_vehicles,

    getRolesLoaded: (state) => state.roles_loaded,
    newRoleStatus: (state) => state.new_role_status,
    updatedRoleStatus: (state) => state.updated_role_status,
    updatedProjectRoleStatus: (state) => state.updated_project_role_status,
    updatedContractRoleStatus: (state) => state.updated_contract_role_status,
    getAddUserToRole: (state) => state.add_user_to_role,
    addUserToRoleStatus: (state) => state.add_user_to_role_status,
    removeRoleStatus: (state) => state.remove_role_status,
    removeAdminRoleStatus: (state) => state.remove_admin_role_status,
    removeProjectRoleStatus: (state) => state.remove_project_role_status,
    removeContractRoleStatus: (state) => state.remove_contract_role_status,
    showCreateRow: (state) => state.show_create_row,

    getUsersVehicleRoles: (state) => state.users_vehicle_roles,
    getBulkVehicleRoleNames: (state) => state.bulk_vehicle_role_names,
    getVehicleRoleUsers: (state) => state.vehicle_role_users,
    getVehicleRoleNames: (state) => state.vehicle_role_names,
    
    updatedVehicleRoleStatus: (state) => state.updated_vehicle_role_status,
    removeVehicleRoleStatus: (state) => state.remove_vehicle_role_status,

    contract: (state) => state.contract,
    contracts: (state) => state.contracts,
    contractStatus: (state) => state.contract_status,
    contractsStatus: (state) => state.contracts_status,
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
    getCheckAllProjects: (state) => state.check_all_projects,
    getCheckedGroups: (state) => state.checked_groups,

    vehicle: (state) => state.vehicle,
    vehicleStatus: (state) => state.vehicle_status,
    getNewVehicleGroupFilter: (state) => state.new_vehicle_group_filter,
    editVehicleSheet: (state) => state.edit_vehicle_sheet,
    getVehicleStatusesFilter: (state) => state.vehicle_statuses_filter,
    getVehicleClassifications: (state) => state.vehicle_classifications,
    getVehicleGroupTypes: (state) => state.vehicle_group_types,
    getVehicleTable: (state) => state.vehicle_table,
    vehicleLoaded: (state) => state.vehicle_loaded,
    vehiclesLoaded: (state) => state.vehicles_loaded,
    vehicles: (state) => state.vehicles,
    vehiclesStatus: (state) => state.vehicles_status,

    moveGroupStatus: (state) => state.move_group_status,
    exportProjectStatus: (state) => state.export_project_status,

    duplicateGroupStatus: (state) => state.duplicate_group_status,
    duplicateProjectStatus: (state) => state.duplicate_project_status,

    getNewUserId: (state) => state.new_user_id,
    getEditUserData: (state) => state.edit_user_data,

    getCheckedPortfolioGroups: (state) => state.checked_portfolio_groups,
    getCheckedPortfolioProjects: (state) => state.checked_portfolio_projects,

    getVehicles: (state) => state.vehicle_filter,
    getVehicleNumbers: (state) => state.vehicle_number,
    getSubcontractNumbers: (state) => state.subcontract_number,
    getContractNumbers: (state) => state.contract_number,

    getUserStatus: (state) => state.user_status,
    editUserDataStatus: (state) => state.edit_user_data_status,

    getTransferData: (state) => state.transfer_data,
    getContractGroupTypes: (state) => state.contract_group_types,
    group: (state) => state.group,
    groups: (state) => state.groups,

    programSettingsProjects: (state) => state.program_settings_projects,
    programProjectsSettingsLoaded: (state) =>
      state.program_settings_projects_loaded,
    bulkProjectAddStatus: (state) => state.program_settings_projects_status,

    portfolioProjects: (state) => state.portfolio_projects,
    portfolioProjectsLoaded: (state) => state.portfolio_projects_loaded,

    getPortfolioUsers: (state) => state.portfolio_users,
    getPortfolioUsersStatus: (state) => state.portfolio_users_status,
    programUsersLoaded: (state) => state.program_users_loaded,
    programUsers: (state) => state.program_users,
    programUsersStatus: (state) => state.program_users_status,
    groupStatus: (state) => state.group_status,
    portfolioProjectsStatus: (state) => state.portfolio_projects_status,
    programProjectsStatus: (state) => state.program_projects_status,
    removePortfolioProjectsStatus: (state) =>
      state.remove_portfolio_projects_status,
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
    getVehicleTypeFilter: (state) => state.vehicle_type_filter,
    facilityGroupContracts: (state, getters) => (group) => {
      return {
        contracts: {
          b: getters.contracts
            .filter((f) => f.facilityGroup && f.facilityGroup.id == group.id)
            .sort((a, b) => a.name.localeCompare(b.name)),
        },
      };
    },
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
  formData.append("contract[project_id]", contract.project_id); //Required; This is actually the Program ID

  // formData.append("contract[id]", contract.id);

  return formData;
};

/* const vehicleFormData = (vehicle) => {
  // console.log(vehicle)
  let formData = new FormData();
  // Append all required form data
  if (vehicle.id) {
    formData.append("vehicle[id]", vehicle.id);
    formData.append("facility_group_name", vehicle.facility_group_name);
  }
  formData.append("vehicle[facility_group_id]", vehicle.facility_group_id);
  formData.append("vehicle[project_id]", vehicle.project_id); //Required; This is actually the Program ID

  // formData.append("vehicle[id]", vehicle.id);

  return formData;
}; */

const groupFormData = (group) => {
  let formData = new FormData();
  // Append all required form data
  formData.append("facility_group[name]", group.name); //Required
  formData.append("facility_group[status]", group.status); //Required
  formData.append("facility_group[project_id]", group.project_id); //Required; This is actually the Program ID
  formData.append("project_id", group.project_id); //Required; This is actually the Program ID

  return formData;
};

const portfolioGroupData = (groupData) => {
  let formData = new FormData();
  groupData.ids.forEach((ids) => {
    formData.append("facility_group_ids[]", ids);
  });
  formData.append("project_id", groupData.programId);
  return formData;
};

const portfolioProjectsData = (groupData) => {
  let formData = new FormData();
  groupData.ids.forEach((ids) => {
    formData.append("facility_ids[]", ids);
  });
  formData.append("project_id", groupData.programId);
  return formData;
};

const newGroupName = (newNameData) => {
  let formData = new FormData();
  console.log(newNameData.name);
  formData.append("facility_group[name]", newNameData.name); //Required
};

//ROLE FORM DATA
// const newRoleData = (roleData) => {

// }

//ADD USER TO ROLE FORM DATA
// const userRoleData = (userData) => {
//   let formData = new FormData();
//   formData.append("role_users[role_id]", userData.roleId)
//   formData.append("role_users[user_id]", userData.userId)
//   formData.append("role_users[project_id]", userData.programId)
//   formData.append("role_users[facility_id]", userData.projectId)
//   formData.append("role_users[contract_id]", userData.contractId)
// }
export default settingsStore;
