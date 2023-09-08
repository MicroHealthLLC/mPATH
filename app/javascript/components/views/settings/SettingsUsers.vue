<template>
  <div class="row">
    <div class="col-md-2">
      <SettingsSidebar />
    </div>
    <div class="col-md-10">
      <div class="right-panel">
        <el-breadcrumb separator-class="el-icon-arrow-right" class="mt-3 mb-4">
          <el-breadcrumb-item :to="backToSettings">
            <span style="cursor:pointer"
              ><i class="far fa-cog mr-1"></i> PROGRAM SETTINGS
            </span>
          </el-breadcrumb-item>
          <h4 class="mt-4 ml-3">
            <i class="fal fa-users mr-1 text-secondary"></i> USERS
            <span
              v-if="programUsers && programUsers.length"
              class="ml-2 pb-1 badge badge-secondary badge-pill pill"
              >{{ programUsers.length }}
            </span>
            <span v-else class="ml-2 pb-1 badge badge-secondary badge-pill pill"
              >{{ 0 }}
            </span>
          </h4>
        </el-breadcrumb>
        <div class="my-1 pb-2 buttonWrapper container-fluid">
          <div class="row px-0">
            <div class="col-6" v-if="_isallowed('write')">
              <el-button
                @click.prevent="openCreateUser"
                class="bg-primary text-light mb-2"
              >
                <i class="fas fa-user-plus mr-1"></i> Create User
              </el-button>
              <el-button
                @click.prevent="addUser"
                class="bg-success text-light mb-2"
              >
                <i class="fas fa-users-medical mr-1"></i> Add User(s) to Program
              </el-button>
            </div>
            <div class="col-6">
              <el-input
                type="search"
                placeholder="Search Users"
                aria-label="Search"
                aria-describedby="search-addon"
                v-model="search"
                data-cy=""
              >
                <el-button slot="prepend" icon="el-icon-search"></el-button>
              </el-input>
            </div>
          </div>
        </div>

        <div class="container-fluid mt-2 mx-0">
          <div
            v-loading="!programUsersLoaded"
            v-if="_isallowed('read')"
            element-loading-text="Fetching your data. Please wait..."
            element-loading-spinner="el-icon-loading"
            class=""
          >
            <el-table
              v-if="programUsers && programUsers.length > 0"
              :data="
                programUsers
                  .filter(
                    (data) =>
                      !search ||
                      data.full_name
                        .toLowerCase()
                        .includes(search.toLowerCase())
                  )
                  .reverse()
              "
              highlight-current-row
              :row-key="(row) => row.id"
              :expand-row-keys="expandRowKeys"
              @expand-change="handleExpandChange"
              style="width: 100%"
              height="450"
              :default-sort="{ prop: 'last_name', order: 'ascending' }"
            >
              <el-table-column prop="first_name" sortable label="First Name">
              </el-table-column>
              <el-table-column prop="last_name" sortable label="Last Name">
              </el-table-column>
              <el-table-column label="Roles">
             
                <template slot-scope="scope">
                <span v-if="projectUsers" >        
                {{ [...new Set(projectUsers.data.filter(t => t.user_id === scope.row.id).map(t => t.role_name))].join(', ')}}          
                </span>
                </template>
          
              </el-table-column>

              <!--BEGIN Expandable Column Containing Priveleges Info -->
              <!-- END Expandable Column Containing Priveleges Info -->

              <el-table-column label="Actions" align="right">
                <template slot-scope="scope">
                  <el-button
                    size="small"
                    type="default"
                    v-tooltip="`Manage User Roles`"
                    @click.prevent="openUserRoleDialog(scope.$index, scope.row)"
                    v-if="scope.$index !== rowIndex"
                    class="bg-primary text-light btn-sm"
                  >
                    <i class="fal fa-user-lock mr-1 text-light"></i>
                  </el-button>
                  <el-button
                    type="default"
                    size="small"
                    v-tooltip="`Remove User from Program`"
                    @click.prevent="removeUser(scope.$index, scope.row)"
                    v-if="scope.$index !== rowIndex && _isallowed('delete')"
                    class="bg-light btn-sm"
                  >
                    <i class="fal fa-user-slash text-danger"></i>
                  </el-button>
                  <el-button
                    type="default"
                    size="small"
                    v-tooltip="`Edit User info`"
                    v-if="_isallowed('write')"
                    @click.prevent="openEditUser(scope.$index, scope.row)"
                    class="bg-light btn-sm"
                  >
                    <i class="fal fa-edit text-primary"></i>
                  </el-button>
                  <!-- USe this attribute when functionaloty gets built in -->
                  <!-- @click.prevent="removeUser(scope.$index, scope.row)"    -->
                  <!-- <el-button
            type="default"  
            class="bg-light btn-sm"         
             v-tooltip="`Remove User`"  
            >
            <i class="fas fa-user-slash"></i>               
            </el-button> -->

                  <!-- <el-button type="primary" @click="handleEditRow(scope.$index)">Edit</el-button> -->
                </template>
              </el-table-column>
            </el-table>
          </div>
          <div v-else class="text-danger mx-2 mt-5">
            <h5>
              <i
                >Sorry, you don't have read-permissions for this page! Please
                contact your Program Administrator for access.</i
              >
            </h5>
          </div>
        </div>
        <el-dialog
          :visible.sync="newUserDialogVisible"
          append-to-body
          center
          class="p-0 users"
        >
          <span slot="title" class="text-left">
            <h5 class="text-dark">
              <i class="fas fa-user-plus mr-2"></i>Create User
            </h5>
          </span>
          <form accept-charset="UTF-8">
            <div class="container">
              <div class="row">
                <div class="col-12 pb-0">
                  <label class="mb-0 pb-0 text-dark"
                    >First Name<span style="color: #dc3545">*</span>
                  </label>
                  <el-input
                    class="mb-2 pl-1"
                    v-model="firstName"
                    placeholder="Enter First Name"
                    rows="1"
                  />
                </div>
              </div>
              <div class="row">
                <div class="col-12 pb-0">
                  <label class="mb-0 pb-0 text-dark"
                    >Last Name <span style="color: #dc3545">*</span></label
                  >
                  <el-input
                    v-model="lastName"
                    class="mb-2 pl-1"
                    placeholder="Enter Last Name"
                    rows="1"
                  />
                </div>
              </div>
              <div class="row">
                <div class="col-12 pb-0">
                  <label class="mb-0 pb-0 text-dark"
                    >Email<span style="color: #dc3545">*</span></label
                  >
                  <el-input
                    name="email"
                    v-model="email"
                    placeholder="Enter Email"
                    v-validate="'email'"
                    :class="{ error: errors.has('email') }"
                    rows="1"
                    class="mb-2 pl-1"
                  />
                </div>
              </div>
              <div class="row">
                <div class="col-12 py-1 text-right" style="line-height:6">
                  <button
                    @click.prevent="createUser"
                    v-show="
                      email && lastName && firstName && !createAnotherUserBtn
                    "
                    class="btn btn-md bg-primary text-light modalBtns"
                    v-tooltip="`Save`"
                  >
                    <i class="fal fa-save"></i>
                  </button>
                  <button
                    type="default"
                    v-tooltip="`Create another user`"
                    @click.prevent="createAnotherUser"
                    v-if="
                      email && lastName && firstName && createAnotherUserBtn
                    "
                    class="btn btn-md btn-primary text-light modalBtns"
                  >
                    <i class="far fa-plus-circle"></i>
                  </button>
                  <button
                    @click.prevent="cancelAddNewUser"
                    class="btn btn-md bg-secondary text-light ml-0 modalBtns"
                    v-tooltip="`Cancel`"
                  >
                    <i class="fas fa-ban"></i>
                  </button>
                </div>
              </div>
            </div>
          </form>
        </el-dialog>
        <el-dialog
          :visible.sync="dialogVisible"
          append-to-body
          center
          class="p-0 users"
        >
          <span slot="title" class="text-left">
            <h5 class="text-dark">
              <i class="fas fa-users-medical mr-2"></i>Add User(s) To Program
            </h5>
          </span>
          <div class="container">
            <div class="row">
              <div class="col-12" v-if="portfolioUsersOnly">
                <label class="font-md mb-0"
                  >Select from
                  <span class="badge badge-secondary badge-pill pill">
                    {{ portfolioUsersOnly.length }}
                  </span>
                  Portfolio Users
                </label>
                <el-select
                  v-model="portfolioUsers"
                  class="w-100"
                  track-by="id"
                  value-key="id"
                  :multiple="true"
                  clearable
                  placeholder="Enter name"
                  filterable
                >
                  <el-option
                    v-for="item in portfolioUsersOnly"
                    :value="item"
                    :key="item.id"
                    :label="item.name || item.full_name"
                  >
                  </el-option>
                </el-select>
                <div class="text-right">
                  <button
                    type="default"
                    v-tooltip="`Save Users`"
                    @click.prevent="addPortfolioUsersToProgram"
                    v-if="portfolioUsers.length > 0 && !addMoreUsersBtn"
                    class="btn btn-md btn-primary text-light mt-3 modalBtns"
                  >
                    <i class="fal fa-save"></i>
                  </button>
                  <button
                    type="default"
                    v-tooltip="`Add more users`"
                    @click.prevent="addMoreUsers"
                    v-if="portfolioUsers && addMoreUsersBtn"
                    class="btn btn-md btn-primary text-light mt-3 modalBtns"
                  >
                    <i class="far fa-plus-circle"></i>
                  </button>
                  <button
                    @click.prevent="cancelAddUser"
                    class="btn btn-md bg-secondary text-light mt-3 ml-0 modalBtns"
                    v-tooltip="`Cancel`"
                  >
                    <i class="fas fa-ban"></i>
                  </button>
                </div>
              </div>

              <div class="col-12" v-else>
                No Portfolio Users Found

                <div class="text-right">
                  <button
                    @click.prevent="cancelAddUser"
                    class="btn btn-md bg-secondary text-light mt-3 ml-0 modalBtns"
                    v-tooltip="`Cancel`"
                  >
                    <i class="fas fa-ban"></i>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </el-dialog>

        <el-dialog
          :visible.sync="editUserDialogVisible"
          append-to-body
          center
          class="p-0 users"
        >
          <span slot="title" class="text-left">
            <h5 class="text-dark"><i class="fas fa-edit mr-1"></i>Edit User</h5>
          </span>
          <div class="container pt-0">
            <div class="row">
              <div class="col-12 pt-0">
                <form accept-charset="UTF-8">
                  <FormTabs
                    class="mb-3"
                    :current-tab="currentTab"
                    :tabs="tabs"
                    @on-change-tab="onChangeTab"
                  />
                  <div v-show="currentTab == 'tab1'" class="tab_1">
                    <label class="mb-0 pb-0 text-dark">First Name </label>
                    <el-input
                      class="mb-2 pl-1"
                      v-model="rowUser.first_name"
                      rows="1"
                    />
                    <label class="mb-0 pb-0 text-dark">Last Name</label>
                    <el-input
                      v-model="rowUser.last_name"
                      class="mb-2 pl-1"
                      rows="1"
                    />
                    <label class="mb-0 pb-0 text-dark">Position</label>
                    <el-input
                      v-model="rowUser.title"
                      class="mb-2 pl-1"
                      rows="1"
                    />
                    <label class="mb-0 pb-0 text-dark">Organization</label>
                    <el-input
                      v-model="rowUser.organization"
                      disabled
                      class="mb-2 pl-1"
                      rows="1"
                    />
                  </div>
                  <div v-show="currentTab == 'tab2'" class="tab_2">
                    <label class="mb-0 pb-0 text-dark">Email</label>
                    <el-input
                      name="email"
                      v-model="rowUser.email"
                      v-validate="'email'"
                      placeholder="Enter updated email here"
                      rows="1"
                      class="mb-2 pl-1"
                      :class="{ error: errors.has('email') }"
                    />

                    <label class="mb-0 pb-0 text-dark">Phone Number</label>
                    <el-input
                      v-model="rowUser.phone_number"
                      disabled
                      placeholder="Enter updated phone number here"
                      rows="1"
                      class="mb-2 pl-1"
                    />
                    <label class="mb-0 pb-0 text-dark">Address</label>
                    <el-input
                      v-model="rowUser.address"
                      disabled
                      placeholder="Enter updated address here"
                      rows="1"
                      class="mb-2 pl-1"
                    />
                  </div>
                  <div v-show="currentTab == 'tab3'" class="tab_3 w-70">
                    <h6 style="color:#383838">mPATH User since:</h6>
                    {{
                      moment(rowUser.created_at).format("DD MMM YYYY, h:mm a")
                    }}

                    <br />
                    <h6 class="mt-3" style="color:#383838">mPATH User Id#:</h6>
                    {{ rowUser.id }}
                  </div>

                  <div class="my-3 float-right">
                    <button
                      @click.prevent="saveUserEdits"
                      class="btn btn-md bg-primary text-light mr-2 modalBtns"
                      v-tooltip="`Save`"
                    >
                      <i class="fal fa-save"></i>
                    </button>
                    <button
                      @click.prevent="cancelEdits"
                      class="btn btn-md bg-secondary text-light modalBtns"
                      v-tooltip="`Cancel`"
                    >
                      <i class="fas fa-ban"></i>
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </el-dialog>

        <el-dialog
          :visible.sync="openUserRoles"
          append-to-body
          center
          class="p-0 userRoles"
        >
          <span slot="title" class="text-left add-groups-header ">
            <h5 style="color:#383838">
              <i class="fal fa-user-lock mr-1 mb-3 bootstrap-purple-text"></i>
              <b>Assigned Roles</b>
              <span class="badge badge-secondary badge-pill">
                <span v-if="projectUsers || assignedAdminRoles">{{
                  projectUsers.roleIds.length + assignedAdminRoles.length
                }}</span>
              </span>
            </h5>
          </span>
          <div class="roleUser mh-orange text-light" v-if="userData">
            <span class="p-2">
              <i class="fas fa-user mr-1"></i> {{ userData.full_name }}
            </span>
          </div>

          <div class="row mb-3" v-if="_isallowed('write')">
            <div class="col-7">
              <el-button-group>
                <el-button
                  type="default"
                  class="bg-light btn-sm"
                  @click.prevent="assignProjectRole"
                >
                  <i class="fal fa-clipboard-list mr-1 mh-green-text"></i>
                  Assign Project Role
                </el-button>
                <el-button
                  type="default"
                  class="bg-light btn-sm"
                  @click.prevent="assignContractRole"
                >
                  <i class="far fa-file-contract mr-1 mh-orange-text"></i>
                  Assign Contract Role
                </el-button>
                <el-button
                  type="default"
                  class="bg-light btn-sm"
                  @click.prevent="assignVehicleRole"
                >
                  <i class="fal fa-car mr-1 text-info"></i>
                  Assign Vehicle Role
                </el-button>
                <!-- <el-button 
          type="default"
          class="bg-light btn-sm"        
          @click.prevent="assignAdminRole"   
           >
          <i class="fa-solid fa-user-shield mr-1 bootstrap-purple-text"></i>   
              Manage Admin Role
          </el-button>             -->
              </el-button-group>
            </div>
            <div class="col-5 text-right">
              <el-input
                type="search"
                placeholder="Search Roles"
                aria-label="Search"
                class="w-100"
                aria-describedby="search-addon"
                v-model="searchRoleUsers"
                data-cy=""
              >
                <el-button slot="prepend" icon="el-icon-search"></el-button>
              </el-input>
            </div>
          </div>
          <div
            v-loading="!getRolesLoaded"
            style="width: 100%"
            element-loading-spinner="el-icon-loading"
            element-loading-text="Fetching or Updating data. Please wait..."
          >
            <el-table
              v-if="
                projectUsers &&
                  projectUsers.data &&
                  projectUsers.roleIds.length > 0
              "
              :data="projectUsers.roleIds"
              height="375"
              class="usersTable"
              width="100%"
              border
              :header-cell-style="{ background: '#EDEDED' }"
            >
              <el-table-column
                prop="role_name"
                sortable
                label="Roles"
                width="200"
              >
                <template slot-scope="scope">
                  <!-- ADMIN ROLE ICON 
             <i class="fa-solid fa-user-shield mr-1 bootstrap-purple-text"></i>  
                          PROJECT ROLE ICON 
             <i class="fal fa-clipboard-list mr-1 mh-green-text"></i> 
                        CONTRACT ROLE ICON 
             <i class="far fa-file-contract mr-1 mh-orange-text"></i>   
                                                                              -->
                  <span
                    v-if="projectUsers.data.map((t) => t.role_id == scope.row)"
                  >
                    {{
                      projectUsers.data
                        .filter((t) => t.role_id == scope.row)
                        .map((t) => t.role_name)[0]
                    }}
                  </span>
                </template>
              </el-table-column>
              <el-table-column
                v-if="_isallowed('delete')"
                width="675"
                prop="projects"
                sortable
                filterable
                label="Associations"
              >
                <template slot-scope="scope">
                  <span v-if="scope.$index !== rowIndex_1">
                    <span v-for="(item, i) in projectUsers.data" :key="i">
                      <!-- {{item}}   -->
                      <span
                        v-if="
                          projectNames &&
                            item.facility_project_id &&
                            projectNames.map(
                              (t) =>
                                t.facilityProjectId == item.facility_project_id
                            ) &&
                            item.role_id == scope.row &&
                            projectNames
                              .filter(
                                (t) =>
                                  item.facility_project_id ==
                                  t.facilityProjectId
                              )
                              .map((t) => t.facilityName).length > 0
                        "
                        class="projectNames"
                      >
                        {{
                          projectNames
                            .filter(
                              (t) =>
                                item.facility_project_id == t.facilityProjectId
                            )
                            .map((t) => t.facilityName)
                            .join()
                        }}
                      </span>
                      <span
                        v-if="
                          contractNames &&
                            item.project_contract_id &&
                            contractNames.map(
                              (t) =>
                                t.project_contract_id ==
                                item.project_contract_id
                            ) &&
                            item.role_id == scope.row &&
                            contractNames
                              .filter(
                                (t) =>
                                  t.project_contract_id ==
                                  item.project_contract_id
                              )
                              .map((t) => t.name).length > 0
                        "
                        class="projectNames"
                      >
                        {{
                          contractNames
                            .filter(
                              (t) =>
                                t.project_contract_id ==
                                item.project_contract_id
                            )
                            .map((t) => t.name)
                            .join()
                        }}
                      </span>
                      <span
                        v-if="
                          vehicleNames &&
                            item.project_contract_vehicle_id &&
                            vehicleNames.map(
                              (t) =>
                                t.id ==
                                item.project_contract_vehicle_id
                            ) &&
                            item.role_id == scope.row &&
                            vehicleNames
                              .filter(
                                (t) =>
                                  t.id ==
                                  item.project_contract_vehicle_id
                              )
                              .map((t) => t.contract_vehicle.name).length > 0
                        "
                        class="projectNames"
                      >
                        {{
                          vehicleNames
                            .filter(
                              (t) =>
                                t.id ==
                                item.project_contract_vehicle_id
                            )
                            .map((t) => t.contract_vehicle.name)
                            .join()
                        }}
                      </span>
                    </span>
                  </span>
                  <span v-if="isEditingRoles && scope.$index == rowIndex_1">
                    <el-select
                      v-model="projectRoleUsers"
                      v-if="!isEditingContractRoles"
                      :popper-append-to-body="false"
                      filterable
                      multiple
                      class="w-100 el-popper"
                      track-by="id"
                      placeholder="No projects assigned to this role"
                      value-key="id"
                      popper-class="select-popper"
                    >
                      <el-option
                        v-for="item in projectNames"
                        :value="item"
                        :key="item.facilityProjectId"
                        :label="item.facilityName"
                      >
                      </el-option>
                    </el-select>
                  </span>
                  <span
                    v-if="isEditingContractRoles && scope.$index == rowIndex_1"
                  >
                    <el-select
                      v-model="contractRoleUsers"
                      v-if="!isEditingRoles"
                      filterable
                      multiple
                      class="w-100 el-popper"
                      track-by="id"
                      value-key="id"
                      :popper-append-to-body="false"
                      popper-class="select-popper"
                    >
                      <el-option
                        v-for="item in contractNames"
                        :value="item"
                        :key="'C'+item.project_contract_id"
                        :label="item.name"
                      >
                      </el-option>
                      <el-option
                        v-for="item in vehicleNames"
                        :value="item"
                        :key="'V'+item.id"
                        :label="item.contract_vehicle.name"
                      >
                      </el-option>
                    </el-select>
                  </span>
                  <!-- <span
                    v-if="isEditingVehicleRoles && scope.$index == rowIndex_1"
                  >
                    <el-select
                      v-model="contractRoleUsers"
                      v-if="!isEditingRoles && !isEditingContractRoles"
                      filterable
                      multiple
                      class="w-100 el-popper"
                      track-by="id"
                      value-key="id"
                      :popper-append-to-body="false"
                      popper-class="select-popper"
                    >
                      <el-option
                        v-for="item in vehicleNames"
                        :value="item"
                        :key="item.id"
                        :label="item.contract_vehicle.name"
                      >
                      </el-option>
                    </el-select>
                  </span> -->
                </template>
              </el-table-column>
              <el-table-column
                v-else
                width="800"
                prop="projects"
                sortable
                filterable
                label="Associations"
              >
                <template slot-scope="scope">
                  <span v-if="scope.$index !== rowIndex_1">
                    <span v-for="(item, i) in projectUsers.data" :key="i">
                      <!-- {{item}}   -->
                      <span
                        v-if="
                          projectNames &&
                            item.facility_project_id &&
                            projectNames.map(
                              (t) =>
                                t.facilityProjectId == item.facility_project_id
                            ) &&
                            item.role_id == scope.row &&
                            projectNames
                              .filter(
                                (t) =>
                                  item.facility_project_id ==
                                  t.facilityProjectId
                              )
                              .map((t) => t.facilityName).length > 0
                        "
                        class="projectNames"
                      >
                        {{
                          projectNames
                            .filter(
                              (t) =>
                                item.facility_project_id == t.facilityProjectId
                            )
                            .map((t) => t.facilityName)
                            .join()
                        }}
                      </span>
                      <span
                        v-if="
                          contractNames &&
                            item.project_contract_id &&
                            contractNames.map(
                              (t) =>
                                t.project_contract_id ==
                                item.project_contract_id
                            ) &&
                            item.role_id == scope.row &&
                            contractNames
                              .filter(
                                (t) =>
                                  t.project_contract_id ==
                                  item.project_contract_id
                              )
                              .map((t) => t.name).length > 0
                        "
                        class="projectNames"
                      >
                        {{
                          contractNames
                            .filter(
                              (t) =>
                                t.project_contract_id ==
                                item.project_contract_id
                            )
                            .map((t) => t.name)
                            .join()
                        }}
                      </span>
                    </span>
                  </span>
                  <span v-if="isEditingRoles && scope.$index == rowIndex_1">
                    <el-select
                      v-model="projectRoleUsers"
                      v-if="!isEditingContractRoles"
                      :popper-append-to-body="false"
                      filterable
                      multiple
                      class="w-100 el-popper"
                      track-by="id"
                      placeholder="No projects assigned to this role"
                      value-key="id"
                      popper-class="select-popper"
                    >
                      <el-option
                        v-for="item in projectNames"
                        :value="item"
                        :key="item.facilityProjectId"
                        :label="item.facilityName"
                      >
                      </el-option>
                    </el-select>
                  </span>
                  <span
                    v-if="isEditingContractRoles && scope.$index == rowIndex_1"
                  >
                    <el-select
                      v-model="contractRoleUsers"
                      v-if="!isEditingRoles"
                      filterable
                      multiple
                      class="w-100 el-popper"
                      track-by="id"
                      value-key="id"
                      :popper-append-to-body="false"
                      popper-class="select-popper"
                    >
                      <el-option
                        v-for="item in contractNames"
                        :value="item"
                        :key="'C'+item.project_contract_id"
                        :label="item.name"
                      >
                      </el-option>
                      <el-option
                        v-for="item in vehicleNames"
                        :value="item"
                        :key="'V'+item.id"
                        :label="item.contract_vehicle.name"
                      >
                      </el-option>
                    </el-select>
                  </span>
                </template>
              </el-table-column>
              <el-table-column
                width="125"
                align="center"
                v-if="_isallowed('delete')"
              >
                <!-- <template slot="header" slot-scope="scope">
            <el-input
              v-model="searchRoleUsers"
              size="mini"
              placeholder="Enter User or Role Name"/>
          </template> -->
                <template slot-scope="scope">
                  <el-button
                    size="mini"
                    type="default"
                    v-if="
                      (isEditingRoles || isEditingContractRoles) &&
                        scope.$index == rowIndex_1 &&
                        _isallowed('delete')
                    "
                    @click.prevent="removeAssociations(scope.$index, scope.row)"
                    v-tooltip="`Save`"
                    class="bg-primary btn-sm text-light"
                  >
                    <i class="far fa-save"></i>
                  </el-button>
                  <el-button
                    size="mini"
                    type="default"
                    v-if="scope.$index !== rowIndex_1 && _isallowed('delete')"
                    @click.prevent="removeRole(scope.$index, scope.row)"
                    v-tooltip="`Remove Role`"
                    class="bg-light btn-sm"
                  >
                    <i class="far fa-trash-alt text-danger "></i>
                  </el-button>
                  <el-button
                    size="mini"
                    type="default"
                    v-tooltip="`Remove Association(s)`"
                    @click.prevent="editRoles(scope.$index, scope.row)"
                    v-if="scope.$index !== rowIndex_1 && _isallowed('delete')"
                    class="bg-danger text-light px-2"
                  >
                    <i class="fal fa-user-lock mr-1 text-light"></i>
                    <!-- <i class="fal fa-user-gear mr-1 text-light"></i>  -->
                  </el-button>
                  <el-button
                   size="mini"
                    type="default"
                    v-if="
                      (isEditingRoles || isEditingContractRoles) &&
                        scope.$index == rowIndex_1
                    "
                    v-tooltip="`Cancel`"
                    @click.prevent="cancelEditRoles(scope.$index, scope.row)"
                    class="btn btn-sm bg-secondary text-light"
                  >
                    <i class="fas fa-ban"></i>
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
            <span v-else>
              No Project or Contract Roles Assigned to this User
            </span>
          </div>

          <!-- PROJECT ROLES DIALOG -->
          <el-dialog
            :visible.sync="assignProle"
            append-to-body
            center
            class="p-0 users"
          >
            <!-- <div class="roleUser" v-if="userData">
         <span class="p-3"> <i class="fas fa-user mr-1"></i> {{ userData.full_name }}  </span>
     </div> -->
            <div class="mt-0 row">
              <div class="col-12 pt-0">
                <label class="font-md mb-0 d-flex">Assign Project Role </label>
                <el-select
                  v-model="projectRoleNames"
                  filterable
                  class="w-100"
                  clearable
                  track-by="id"
                  value-key="id"
                  placeholder="Search and select Role"
                >
                  <el-option
                    v-for="item in getRoles.filter(
                      (t) =>
                        t.type_of == 'project' &&
                        t.name !== 'crud-row-project-20220407'
                    )"
                    :value="item"
                    :key="item.id"
                    :label="item.name"
                  >
                  </el-option>
                </el-select>
              </div>
            </div>
            <div class="mt-2 row">
              <div class="col-12 pt-0">
                <span v-if="filteredProjects && filteredProjects.length > 0">
                  <label class="font-md mb-0 d-flex"
                    >Associate Projects to Role
                  </label>
                  <el-select
                    v-model="associatedProjects"
                    multiple
                    filterable
                    class="w-100"
                    clearable
                    track-by="id"
                    value-key="id"
                    placeholder="Search and select Projects to Associate"
                  >
                    <el-option
                      v-for="item in filteredProjects"
                      :value="item"
                      :key="item.facilityProjectId"
                      :label="item.facilityName"
                    >
                    </el-option>
                  </el-select>
                </span>
                <span class="mt-3" v-else>
                  User has role(s) assigned to all projects (or no projects
                  available). To change role, first remove association.
                </span>
              </div>
            </div>
            <div class="mt-2 row">
              <div class="col pt-1">
                <el-button
                 size="mini"
                  type="default"
                  @click="saveProjectUserRole()"
                  v-if="
                    projectRoleNames &&
                      associatedProjects &&
                      associatedProjects.length > 0
                  "
                  v-tooltip="`Save`"
                  class="btn btn-sm bg-primary text-light"
                >
                  <i class="fal fa-save"></i>
                </el-button>
              </div>
              <div class="col text-right pt-1">
                <el-button
                  size="mini"
                  type="default"
                  @click.prevent="closeProjectRoles"
                  class="btn btn-sm bg-secondary text-light modalBtns"
                  v-tooltip="`Cancel`"
                >
                  <i class="fas fa-ban"></i>
                </el-button>
              </div>
            </div>
          </el-dialog>
          <!-- CONTRACT ROLES DIALOG -->
          <el-dialog
            :visible.sync="assignCrole"
            append-to-body
            center
            class="p-0 users"
          >
            <!-- <div class="roleUser" v-if="userData">
         <span class="p-3"> <i class="fas fa-user mr-1"></i> {{ userData.full_name }}  </span>
     </div> -->
            <div class="mt-0 row">
              <div class="col-12 pt-0">
                <label class="font-md mb-0 d-flex">Assign Contract Role </label>
                <el-select
                  v-model="contractRoleNames"
                  filterable
                  class="w-100"
                  clearable
                  track-by="id"
                  value-key="id"
                  placeholder="Search and select role"
                >
                  <el-option
                    v-for="item in getRoles.filter(
                      (t) =>
                        t.type_of == 'contract' &&
                        t.name !== 'crud-row-contract-20220407'
                    )"
                    :value="item"
                    :key="item.id"
                    :label="item.name"
                  >
                  </el-option>
                </el-select>
              </div>
            </div>
            <div class="mt-3 row">
              <div class="col-12 pt-0">
                <span v-if="filteredContracts && filteredContracts.length > 0">
                  <label class="font-md mb-0 d-flex"
                    >Associate Contracts to Role
                  </label>
                  <el-select
                    v-model="associatedContracts"
                    filterable
                    class="w-100"
                    multiple
                    clearable
                    track-by="id"
                    value-key="id"
                    placeholder="Search and select Contracts to Associate"
                  >
                    <el-option
                      v-for="item in filteredContracts"
                      :value="item"
                      :key="item.project_contract_id"
                      :label="item.name"
                    >
                    </el-option>
                  </el-select>
                </span>
                <span class="mt-3" v-else>
                  User has role(s) assigned to all contracts (or no contracts
                  available). To change role, first remove association.
                </span>
              </div>
            </div>
            <div class="mt-2 row">
              <div class="col pt-1">
                <el-button
                 size="mini"
                  type="default"
                  @click="saveContractUserRole()"
                  v-if="
                    contractRoleNames &&
                      associatedContracts &&
                      associatedContracts.length > 0
                  "
                  v-tooltip="`Save`"
                  class="btn btn-sm bg-primary"
                >
                  <i class="fal fa-save text-light"></i>
                </el-button>
              </div>
              <div class="col text-right pt-1">
                <el-button
                 size="mini"
                  type="default"
                  @click.prevent="closeContractRoles"
                  class="btn btn-sm bg-secondary text-light modalBtns"
                  v-tooltip="`Cancel`"
                >
                  <i class="fas fa-ban"></i>
                </el-button>
              </div>
            </div>
          </el-dialog>

          <!-- VEHICLE ROLES DIALOG -->
          <el-dialog
            :visible.sync="assignVrole"
            append-to-body
            center
            class="p-0 users"
          >
            <!-- <div class="roleUser" v-if="userData">
         <span class="p-3"> <i class="fas fa-user mr-1"></i> {{ userData.full_name }}  </span>
     </div> -->
            <div class="mt-0 row">
              <div class="col-12 pt-0">
                <label class="font-md mb-0 d-flex">Assign Vehicle Role</label>
                <el-select
                  v-model="vehicleRoleNames"
                  filterable
                  class="w-100"
                  clearable
                  track-by="id"
                  value-key="id"
                  placeholder="Search and select role"
                >
                  <el-option
                    v-for="item in getRoles.filter(
                      (t) =>
                        t.type_of == 'contract' &&
                        t.name !== 'crud-row-contract-20220407'
                    )"
                    :value="item"
                    :key="item.id"
                    :label="item.name"
                  >
                  </el-option>
                </el-select>
              </div>
            </div>
            <div class="mt-3 row">
              <div class="col-12 pt-0">
                <span v-if="filteredVehicles && filteredVehicles.length > 0">
                  <label class="font-md mb-0 d-flex"
                    >Associate Vehicle to Role
                  </label>
                  <el-select
                    v-model="associatedVehicles"
                    filterable
                    class="w-100"
                    multiple
                    clearable
                    track-by="id"
                    value-key="id"
                    placeholder="Search and select Vehicles to Associate"
                  >
                    <el-option
                      v-for="item in filteredVehicles"
                      :value="item"
                      :key="item.id"
                      :label="item.contract_vehicle.name"
                    >
                    </el-option>
                  </el-select>
                </span>
                <span class="mt-3" v-else>
                  User has role(s) assigned to all vehicles (or no vehicles
                  available). To change role, first remove association.
                </span>
              </div>
            </div>
            <div class="mt-2 row">
              <div class="col pt-1">
                <el-button
                  size="mini"
                  type="default"
                  @click="saveVehicleUserRole()"
                  v-if="
                    vehicleRoleNames &&
                      associatedVehicles &&
                      associatedVehicles.length > 0
                  "
                  v-tooltip="`Save`"
                  class="btn btn-sm bg-primary"
                >
                  <i class="fal fa-save text-light"></i>
                </el-button>
              </div>
              <div class="col text-right pt-1">
                <el-button
                 size="mini"
                  type="default"
                  @click.prevent="closeVehicleRoles"
                  class="btn btn-sm bg-secondary text-light modalBtns"
                  v-tooltip="`Cancel`"
                >
                  <i class="fas fa-ban"></i>
                </el-button>
              </div>
            </div>
          </el-dialog>
          <!-- ADMIN ROLES DIALOG -->

          <el-dialog
            :visible.sync="assignArole"
            append-to-body
            center
            class="p-0 users"
          >
            <!-- <div class="roleUser" v-if="userData">
         <span class="p-3"> <i class="fas fa-user mr-1"></i> {{ userData.full_name }}  </span>
     </div> -->
            <div class="mt-0 row">
              <div class="col-12 pt-0">
                <label class="font-md mb-0 d-flex">Manage Admin Role </label>
                <el-select
                  v-model="adminRoleUsers"
                  filterable
                  class="w-100"
                  clearable
                  track-by="id"
                  value-key="id"
                  placeholder="Search and select role"
                >
                  <el-option
                    v-for="item in getRoles.filter(
                      (t) => t.type_of == 'admin' && t.name !== 'crud-row-admin'
                    )"
                    :value="item"
                    :key="item.id"
                    :label="item.name"
                  >
                  </el-option>
                </el-select>
              </div>
            </div>

            <div class="mt-2 row">
              <div class="col pt-1">
                <el-button
                  size="mini"
                  type="default"
                  @click="saveAdminUserRole()"
                  v-if="adminRoleUsers"
                  v-tooltip="`Save`"
                  class="btn btn-sm bg-primary text-light"
                >
                  <i class="fal fa-save"></i>
                </el-button>
                <el-button
                  size="mini"
                  type="default"
                  @click="removeAssociations()"
                  v-if="
                    !adminRoleUsers &&
                      assignedAdminRoles &&
                      assignedAdminRoles[0]
                  "
                  v-tooltip="`Remove Admin Role from User`"
                  class="btn btn-sm bg-danger text-light"
                >
                  <i class="fal fa-user-lock mr-1 text-light"></i>
                </el-button>
              </div>
              <div class="col text-right pt-1">
                <el-button
                  size="mini"
                  type="default"
                  @click.prevent="closeAdminRoles"
                  class="btn btn-sm bg-secondary text-light modalBtns"
                  v-tooltip="`Cancel`"
                >
                  <i class="fas fa-ban"></i>
                </el-button>
              </div>
            </div>
          </el-dialog>
          <div class="row mt-3">
            <div class="col-9 text-left">
              <span v-if="assignedAdminRoles && assignedAdminRoles[0]">
                <i
                  class="fa-solid fa-user-shield bootstrap-purple-text"
                  v-tooltip="`Admin Role`"
                ></i>
                {{ assignedAdminRoles[0].name }}
              </span>
            </div>
            <div class="col text-right">
              <button
                @click.prevent="closeUserRoles"
                class="btn btn-sm bg-secondary text-light modalBtns"
                v-tooltip="`Cancel`"
              >
                <i class="fas fa-ban"></i>
              </button>
            </div>
          </div>
        </el-dialog>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
import SettingsSidebar from "./SettingsSidebar.vue";
import FormTabs from "../../shared/FormTabs.vue";
import { faSlash } from "@fortawesome/free-solid-svg-icons";
export default {
  name: "SettingsUsers",
  components: {
    SettingsSidebar,
    FormTabs,
  },
  data() {
    return {
      search: "",
      roleRowId: null,
      isEditingRoles: false,
      expandRowKeys: [],
      isEditingAdminRoles: false,
      isEditingContractRoles: false,
      //isEditingVehicleRoles: false,
      editRoleRowData: null,
      projId: null,
      userData: null,
      searchRoleUsers: "",
      autoCompleteSearch: "",
      currentTab: "tab1",
      tabs: [
        {
          label: "Basic Info",
          key: "tab1",
          closable: false,
          // form_fields: [
          //   "Task Name",
          //   "Description",
          //   "Start Date",
          //   "Process Area",
          //   "Stage",
          //   "Start Date",
          //   "Date Closed",
          // ],
        },
        {
          label: "Contact Info",
          key: "tab2",
          closable: false,
          // form_fields: ["Responsible", "Accountable", "Consulted", "Informed"],
        },
        {
          label: "Misc",
          key: "tab3",
          closable: false,
          // form_fields: ["Checklists"],
        },
      ],
      firstName: "",
      lastName: "",
      email: "",
      addMoreUsersBtn: false,
      rowIndex: null,
      rowIndex_1: null,
      programId: this.$route.params.programId,
      rowId: null,
      addedUsers: [],
      rowUser: {},
      userPrivileges: {},
      portfolioUsers: [],
      programNameList: [],
      newUserValidation: null,
      inactiveUser: false,
      activeUser: true,
      //toggle used by autocomplete
      toggle: false,
      //dialogVisible used by el-dialogue popup
      dialogVisible: false,
      openUserRoles: false,
      createAnotherUserBtn: false,
      assignProle: false,
      assignCrole: false,
      assignVrole: false,
      assignArole: false,
      editUserDialogVisible: false,
      newUserDialogVisible: false,
      privilegesProfileVisible: false,
    };
  },
  methods: {
    ...mapMutations([
      "SET_USER_STATUS",
      "SET_NEW_USER_STATUS",
      "SET_ADD_USERS_TO_PROGRAM",
      "SET_PROGRAM_USERS",
      "SET_ADD_USERS_TO_PROGRAM_STATUS",
      "SET_EDIT_USER_DATA_STATUS",
      "SET_PROJECT_ROLE_NAMES",
      "SET_ADMIN_ROLE_NAMES",
      "SET_VEHICLE_ROLE_NAMES",
      "SET_CONTRACT_ROLE_NAMES",
      "SET_ASSOCIATED_CONTRACTS",
      "SET_ASSOCIATED_VEHICLES",
      "SET_ASSOCIATED_PROJECTS",
      "SET_ADD_USER_TO_ROLE_STATUS",
      "SET_USERS_PROJECT_ROLES",
      "SET_USERS_CONTRACT_ROLES",
      "SET_USERS_VEHICLE_ROLES",
      "SET_USERS_ADMIN_ROLES",
      "SET_REMOVE_ROLE_STATUS",
      "SET_PROGRAM_USERS_STATUS",
    ]),
    ...mapActions([
      "fetchPortfolioUsers",
      "fetchProgramUsers",
      "fetchRoles",
      "fetchContracts",
      "fetchVehicles",
      "addUserToRole",
      "fetchCurrentProject",
      "createNewUser",
      "updateUserData",
      "removeUserRole",
      "removeProgramUser",
      "addUsersToProgram",
    ]),
    handleExpandChange(row, expandedRows) {
      this.projId = row.id;
      this.projUserObj = row;
      const lastId = this.expandRowKeys[0];
      // disable mutiple row expanded
      this.expandRowKeys = this.projId === lastId ? [] : [this.projId];
    },
    _isallowed(salut) {
      return this.checkPrivileges("SettingsUsers", salut, this.$route, {
        settingType: "Users",
      });
    },
    log(e) {
        console.log(`${e}`)
    },
    removeAssociations(index, rowData) {
      if (this.isEditingRoles) {
        let projIds = this.projectRoleUsers.map((t) => t.facilityProjectId);
        let assigned = this.assignedUserProjects.map(
          (t) => t.facilityProjectId
        );
        let ids = assigned.filter((t) => !projIds.includes(t));
        let projectUserRoleData = {
          userData: {
            roleId: rowData,
            userId: this.userData.id,
            programId: this.$route.params.programId,
            projectIds: ids,
          },
        };
        // console.log(ids)
        this.removeUserRole({
          ...projectUserRoleData,
        });
      }
      if (this.isEditingContractRoles) {
        let cIds = this.contractRoleUsers.filter((f) => "billings_to_date" in f).map((t) => t.project_contract_id);
        let vIds = this.contractRoleUsers.filter((f) => !("billings_to_date" in f)).map((t) => t.id);       
        let assignedContracts = this.assignedUserContracts.map((t) => t.project_contract_id).filter((f) => f !== undefined);
        let assignedVehicles = this.assignedUserContracts.filter((f) => !("billings_to_date" in f)).map((t) => t.id);
        let aCids = assignedContracts.filter((t) => !cIds.includes(t));
        if (aCids && aCids.length > 0 ) {
          let cProjectUserRoleData = {
            userData: {
              roleId: rowData,
              userId: this.userData.id,
              programId: this.$route.params.programId,
              contractIds: aCids,
            }
          }
          this.removeUserRole({
          ...cProjectUserRoleData,
        });
        }
        let aVids = assignedVehicles.filter((t) => !vIds.includes(t));
        if (aVids && aVids.length > 0) {
          let vProjectUserRoleData = {
            userData: {
              roleId: rowData,
              userId: this.userData.id,
              programId: this.$route.params.programId,
              vehicleIds: aVids,
            }
          }
          this.removeUserRole({
          ...vProjectUserRoleData,
        });
        }
      }
    },
    removeRole(index, rowData) {
      let projectUserRoleData = {
        userData: {
          removeRole: true,
          roleId: rowData,
          userId: this.userData.id,
          programId: this.$route.params.programId,
        },
      };

      this.$confirm(
        `Removing role will also remove all assocations.  Are you sure you want to remove this role?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
      ).then(() => {
        this.removeUserRole({
          ...projectUserRoleData,
        });
      });
    },
    editRoles(index, rowData) {
      this.roleRowId = rowData;
      this.editRoleRowData = rowData;
      this.rowIndex_1 = index;
      this.SET_USERS_PROJECT_ROLES(this.assignedUserProjects);
      this.SET_USERS_CONTRACT_ROLES(this.assignedUserContracts);
      this.SET_USERS_VEHICLE_ROLES(this.assignedUserVehicles);
      if ((this.assignedUserContracts && this.assignedUserContracts.length > 0) 
      || (this.assignedUserVehicles && this.assignedUserVehicles.length > 0)) {
        this.isEditingContractRoles = true;
      }
      if (this.assignedUserProjects && this.assignedUserProjects.length > 0) {
        this.isEditingRoles = true;
      }
      //console.log(this.contractRoleUsers)
    },
    editAdminRole() {
      this.isEditingAdminRoles = true;
    },
    cancelEditRoles(index, rowData) {
      this.isEditingRoles = false;
      this.isEditingContractRoles = false;
      //this.isEditingVehicleRoles = false;
      this.isEditingAdminRoles = false;
      this.rowIndex_1 = null;
    },
    saveProjectUserRole(index, rows) {
      let projectIds = this.associatedProjects.map((t) => t.facilityProjectId);
      let projectUserRoleData = {
        userData: {
          roleId: this.projectRoleNames.id,
          userId: this.projId,
          programId: this.$route.params.programId,
          projectIds: projectIds,
          userRoles: true,
        },
      };
      this.addUserToRole({
        ...projectUserRoleData,
      });
    },
    saveContractUserRole(index, rows) {
      let contractIds = this.associatedContracts.map(
        (t) => t.project_contract_id
      );
      let projectUserRoleData = {
        userData: {
          roleId: this.contractRoleNames.id,
          userId: this.projId,
          programId: this.$route.params.programId,
          contractIds: contractIds,
          userRoles: true,
        },
      };
      // console.log(contractIds)
      this.addUserToRole({
        ...projectUserRoleData,
      });
    },
    saveVehicleUserRole(index, rows) {
      let vehicleIds = this.associatedVehicles.map(
        (t) => t.id
      );
      let projectUserRoleData = {
        userData: {
          roleId: this.vehicleRoleNames.id,
          userId: this.projId,
          programId: this.$route.params.programId,
          vehicleIds: vehicleIds,
          userRoles: true,
        },
      };
    //  console.log(vehicleIds)
    //   console.log(this.associatedVehicles)
    //    console.log(this.contractRoleNames)
    //      console.log(this.vehicleRoleNames)
      this.addUserToRole({
        ...projectUserRoleData,
      });
    },
    saveAdminUserRole(index, rows) {
      let projectUserRoleData = {
        userData: {
          roleId: this.adminRoleUsers.id,
          userId: this.projId,
          programId: this.$route.params.programId,
          adminRole: true,
        },
      };
      // console.log(projectUserRoleData)
      this.addUserToRole({
        ...projectUserRoleData,
      });
    },
    onChangeTab(tab) {
      this.currentTab = tab ? tab.key : "tab1";
    },
    handleClick(tab, event) {
      //Route redirecting incase we want to assign url paths to each tab
      // if(tab.index == 1) {
      //  this.$router.push({ name: "SettingsRolesProjects" })
      // }
    },
    addRoleToUser(index, rows) {
      // console.log(rows)
    },
    associateUserRole(index, rows) {
      // console.log(rows)
    },
    addPortfolioUsersToProgram() {
      if (this.portfolioUsers && this.portfolioUsers.length > 0) {
        let uIds = [];
        for (let i = 0; i < this.portfolioUsers.length; i++) {
          uIds.push(this.portfolioUsers[i].id);
        }
        // console.log(uIds)
        let addedUsersAr = {
          addedUsers: {
            programId: this.programId,
            userIds: uIds,
          },
        };
        this.addUsersToProgram({
          ...addedUsersAr,
        });
      }
    },
    addUser() {
      this.dialogVisible = true;
      // console.log(this.portfolioUsersOnly)
      //  console.log(this.programUsers)
    },
    assignProjectRole() {
      this.assignProle = true;
    },
    assignContractRole() {
      this.assignCrole = true;
    },
    assignVehicleRole() {
      this.assignVrole = true;
    },
    assignAdminRole() {
      this.assignArole = true;
      this.isEditingAdminRoles = true;
      if (this.assignedAdminRoles && this.getRoles.length > 0) {
        this.SET_USERS_ADMIN_ROLES(this.assignedAdminRoles[0]);
      }
    },
    addMoreUsers() {
      this.portfolioUsers = [];
      this.addMoreUsersBtn = false;
    },
    openCreateUser() {
      this.newUserDialogVisible = true;
    },
    openUserRoleDialog(index, rows) {
      this.projId = rows.id;
    
    // console.log(this.projectUsers)
        //console.log(rows)
      this.openUserRoles = true;
      this.userData = rows;
      this.fetchContracts(this.$route.params.programId);
      this.fetchVehicles(this.$route.params.programId);
    },
    closeUserRoles() {
      this.openUserRoles = false;      
    },
    closeProjectRoles() {
      this.assignProle = false;
    },
    closeContractRoles() {
      this.assignCrole = false;
    },
    closeVehicleRoles() {
      this.assignVrole = false;
    },
    closeAdminRoles() {
      this.assignArole = false;
      this.SET_USERS_ADMIN_ROLES([]);
    },
    closeEditAdminRoles() {
      this.isEditingAdminRoles = false;
    },
    createAnotherUser() {
      this.createAnotherUserBtn = false;
      (this.lastName = ""), (this.firstName = ""), (this.email = "");
    },
    createUser() {
      let newUserData = {
        newUser: {
          fName: this.firstName,
          lName: this.lastName,
          email: this.email,
          pId: this.programId,
        },
      };
      this.createNewUser({
        ...newUserData,
      });
      // this.hideSaveBtn = true;
    },
    openEditUser(index, rows) {
      this.editUserDialogVisible = true;
      this.rowUser = rows;
      // console.log(rows)
      //  console.log(this.projectUsers.length)
    },
    removeUser(index, rows) {
      let projectUserRoleData = {
        userData: {
          id: rows.id,
          programId: this.$route.params.programId,
        },
      };
      this.$confirm(
        `Are you sure you want to remove ${rows.full_name} from your Program?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
      ).then(() => {
        this.removeProgramUser({ ...projectUserRoleData });
      });
    },
    saveUserEdits() {
      let editUserData = {
        program_id: this.$route.params.programId,
        userData: {
          fName: this.rowUser.first_name,
          lName: this.rowUser.last_name,
          email: this.rowUser.email,
          title: this.rowUser.title,
          id: this.rowUser.id,
          // org:   this.rowUser.organizationId,
          phNumber: this.rowUser.phone_number,
          address: this.rowUser.address,
        },
      };
      this.updateUserData({
        ...editUserData,
      });
    },
    cancelEdits() {
      this.editUserDialogVisible = false;
      this.rowIndex = null;
      this.rowId = null;
      // this.hideSaveBtn = false;
    },
    cancelAddNewUser() {
      this.newUserDialogVisible = false;
    },
    cancelAddUser() {
      this.dialogVisible = false;
      this.portfolioUsers = [];
    },
    editMode(index, rows) {
      this.rowIndex = index;
      this.rowId = rows.id;
    },
    userActiveStatus(index, rows) {
      if (rows.status == "inactive") {
        this.activeUser == false;
      }
    },
  },
  mounted() {
    if (this.programUsers.length <= 0) {
      this.fetchProgramUsers(this.$route.params.programId);     
    }
    if (this.getRoles && this.getRoles.length <= 0) {
        this.fetchRoles(this.$route.params.programId);
      }
    this.fetchPortfolioUsers(this.$route.params.programId);
  },
  computed: {
    ...mapGetters([
      "programUsersStatus",
      "contentLoaded",
      "currentProject",
      "contracts",
      "vehicles",
      "getPortfolioUsers",
      "activeProjectUsers",
      "newUserStatus",
      "getRoles",
      "getRolesLoaded",
      "getNewUserId",
      "getProjectRoleNames",
      "getContractRoleNames",
      "getVehicleRoleNames",
      "getAdminRoleNames",
      "getAssociatedProjects",
      "getAssociatedContracts",
      "getAssociatedVehicles",
      "getAddedUsersToProgram",
      "addedUsersToProgramStatus",
      "editUserDataStatus",
      "portfolioUsersLoaded",
      "programUsers",
      "programUsersLoaded",
      "addUserToRoleStatus",
      "getUsersProjectRoles",
      "getUsersContractRoles",
      "getUserVehicleRoles",
      "getUsersAdminRoles",
      "removeRoleStatus",
    ]),
    portfolioUsersOnly() {
      //line 231
      if (
        this.getPortfolioUsers &&
        this.programUsers &&
        this.programUsers.length > 0
      ) {
        let programUserIds = this.programUsers.map((p) => p.id);
        return this.getPortfolioUsers.filter(
          (u) => !programUserIds.includes(u.id)
        );
      }
    },
    projectRoleNames: {
      get() {
        return this.getProjectRoleNames;
      },
      set(value) {
        this.SET_PROJECT_ROLE_NAMES(value);
        //  console.log(value)
      },
    },
    associatedProjects: {
      get() {
        return this.getAssociatedProjects;
      },
      set(value) {
        this.SET_ASSOCIATED_PROJECTS(value);
        //  console.log(value)
      },
    },
    associatedContracts: {
      get() {
        return this.getAssociatedContracts;
      },
      set(value) {
        this.SET_ASSOCIATED_CONTRACTS(value);
        //  console.log(value)
      },
    },
    associatedVehicles: {
      get() {
        return this.getAssociatedVehicles;
      },
      set(value) {
        this.SET_ASSOCIATED_VEHICLES(value);
        //  console.log(value)
      },
    },
    contractRoleNames: {
      get() {
        return this.getContractRoleNames;
      },
      set(value) {
        this.SET_CONTRACT_ROLE_NAMES(value);
        //  console.log(value)
      },
    },
     vehicleRoleNames: {
      get() {
        return this.getVehicleRoleNames;
      },
      set(value) {
        this.SET_VEHICLE_ROLE_NAMES(value);
        //  console.log(value)
      },
    }, 
    adminRoleNames: {
      get() {
        return this.getAdminRoleNames;
      },
      set(value) {
        this.SET_ADMIN_ROLE_NAMES(value);
        //  console.log(value)
      },
    },
    projectNames() {
      if (this.currentProject)
        if (
          this.currentProject.facilities &&
          this.currentProject.facilities.length > 0
        ) {
          return this.currentProject.facilities.map((t) => t);
        }
    },
    filteredProjects() {
      if (
        this.projectUsers &&
        this.projectUsers.data &&
        this.projectNames &&
        this.projectNames.length > 0
      ) {
        let roleProjectIds = this.projectUsers.data.map(
          (t) => t.facility_project_id
        );
        //console.log(this.projectNames)
        return this.projectNames.filter(
          (t) => !roleProjectIds.includes(t.facilityProjectId)
        );
      }
    },
    contractNames() {
      //console.log(this.contracts);
      if (this.contracts) {
        if (this.contracts.length > 0) {
          //  console.log(this.contracts.map(t => t))
          return this.contracts.map((t) => t);
        }
      }
    },
    vehicleNames() {
      //console.log(this.vehicles);
      if (this.vehicles) {
        if (this.vehicles.length > 0) {
          //  console.log(this.contracts.map(t => t))
          return this.vehicles.map((t) => t);
        }
      }
    },
    filteredContracts() {
      if (
        this.projectUsers &&
        this.projectUsers.data &&
        this.contractNames &&
        this.contractNames.length > 0
      ) {
        //console.log(this.contractNames)
        let roleProjectIds = this.projectUsers.data.map(
          (t) => t.project_contract_id
        );
        return this.contractNames.filter(
          (t) => !roleProjectIds.includes(t.project_contract_id)
        );
      }
    },
    filteredVehicles() {
      if (
        this.projectUsers &&
        this.projectUsers.data &&
        this.vehicleNames &&
        this.vehicleNames.length > 0
      ) {
         //console.log(this.projectUsers)
         //console.log(this.projectUsers.data)
         //console.log(this.vehicleNames)
        let roleProjectIds = this.projectUsers.data.map(
         (t) => t.project_contract_vehicle_id
        );
        //console.log(roleProjectIds)
        return this.vehicleNames.filter(
          (t) => !roleProjectIds.includes(t.id)
        ); 
      }
    },
    admin_role_names() {
      if (this.getRoles && this.getRoles.length > 0) {
        let adminRoles = this.getRoles.filter((t) => t.type_of == "admin");
        return adminRoles;
      }
    },
    associatedRoles() {
      if (this.getRoles && this.getRoles.length > 0) {
        let adminRoles = this.getRoles.filter(
          (t) => t.type_of == "project" || t.type_of == "contract"
        );
        return adminRoles;
      }
    },
    filteredAdminRoleUsers() {
      if (this.admin_role_names && this.admin_role_names.length > 0) {
        let roleUsers = this.getRoles
          .map((t) => t.role_users)
          .filter((t) => t.length > 0);
        let data = [].concat.apply([], roleUsers).filter((t) => {
          if (this.projId) {
            return this.projId == t.user_id;
          } else return true;
        });
        return data;
      }
    },
    projectUsers() {
      if (this.associatedRoles && this.associatedRoles.length > 0) {
        let roleUsers = this.associatedRoles
          .map((t) => t.role_users)
          .filter((t) => t.length > 0);
        let data = [].concat
          .apply([], roleUsers)
          .filter((t) => {
            if (this.projId) {         
              return this.projId == t.user_id;
            } else return true;
          })
          .filter((role) => {
            if (this.searchRoleUsers !== "" && role) {
              return role.role_name
                .toLowerCase()
                .match(this.searchRoleUsers.toLowerCase());
            } else return true;
          });
        //  console.log(_.uniq(data.filter(t => t.project_id == this.$route.params.programId).map(t => t.role_id)))
        return {
          data: data,
          dataRow: data.filter((t) => this.roleRowId == t.role_id),
          roleIds: _.uniq(
            data
              .filter(
                (t) =>
               
                  t.project_id == this.$route.params.programId &&
                  (t.facility_project_id || t.project_contract_id || t.project_contract_vehicle_id)
              )
              .map((t) => t.role_id)
          ),
          roleNames: _.uniq(data.map((t) => t.role_name)),
        };
      }
    },
    assignedUserProjects() {
      if (this.projectNames && this.projectNames.length > 0) {
        let ids = this.projectUsers.data.filter(
          (t) => t.role_id == this.roleRowId
        );
        let tableProjectIds = ids.map((t) => t.facility_project_id);
        let filteredProjects = this.projectNames.filter((t) =>
          tableProjectIds.includes(t.facilityProjectId)
        );
        // console.log(filteredProjects)
        return filteredProjects;
      }
    },
    assignedAdminRoles() {
      if (
        this.filteredAdminRoleUsers &&
        this.admin_role_names &&
        this.admin_role_names.length > 0
      ) {
        let ids = this.filteredAdminRoleUsers.map((t) => t.role_id);
        let filteredAdminRoles = this.admin_role_names.filter((t) =>
          ids.includes(t.id)
        );
        return filteredAdminRoles;
      }
    },
    assignedUserContracts() {
      let assignedUserContractsVehicles = [];
      if (this.contractNames && this.contractNames.length > 0) {
        let ids = this.projectUsers.data.filter(
          (t) => t.role_id == this.roleRowId
        );
        //console.log(ids)
        let tableContractIds = ids.map((t) => t.project_contract_id);
        let filteredContracts = this.contractNames.filter((t) =>
          tableContractIds.includes(t.project_contract_id)
        );
        if (this.assignedUserVehicles && this.assignedUserVehicles.length > 0) {
          assignedUserContractsVehicles.push(filteredContracts);
          assignedUserContractsVehicles.push(this.assignedUserVehicles)
          return assignedUserContractsVehicles.flat()
        } else {
          return filteredContracts;
        }
        
      }
    },
    assignedUserVehicles() {
      if (this.vehicleNames && this.vehicleNames.length > 0) {
        let ids = this.projectUsers.data.filter(
          (t) => t.role_id == this.roleRowId
        );
        //console.log(ids);
        let tableVehicleIds = ids.map((t) => t.project_contract_vehicle_id);
        let filteredVehicles = this.vehicleNames.filter((t) =>
          tableVehicleIds.includes(t.id)
        );
        return filteredVehicles;
      }
    },
    projectRoleUsers: {
      get() {
        return this.getUsersProjectRoles;
      },
      set(value) {
        this.SET_USERS_PROJECT_ROLES(value);
        //  console.log(value)
      },
    },
    contractRoleUsers: {
      get() {
        return this.getUsersContractRoles;
      },
      set(value) {
        this.SET_USERS_CONTRACT_ROLES(value);
        //  console.log(value)
      },
    },
    vehicleRoleUsers: {
      get() {
        return this.getUsersVehiclesRoles;
      },
      set(value) {
        this.SET_USERS_VEHICLE_ROLES(value);
        //  console.log(value)
      },
    },
    adminRoleUsers: {
      get() {
        return this.getUsersAdminRoles;
      },
      set(value) {
        this.SET_USERS_ADMIN_ROLES(value);
        //  console.log(value)
      },
    },
    projectRoles() {
      if (this.getRoles && this.getRoles.length > 0) {
        let roleUsers = this.getRoles
          .map((t) => t.type_of == "project" && t.role_users)
          .filter((t) => t.length > 0);
        if (this.projId) {
          return [].concat
            .apply([], roleUsers)
            .filter((t) => this.projId == t.user_id);
        } else return [].concat.apply([], roleUsers);
      }
    },
    contractRoles() {
      if (this.getRoles && this.getRoles.length > 0) {
        let roleUsers = this.getRoles
          .map((t) => t.type_of == "contract" && t.role_users)
          .filter((t) => t.length > 0);
        if (this.projId) {
          return [].concat
            .apply([], roleUsers)
            .filter((t) => this.projId == t.user_id);
        } else return [].concat.apply([], roleUsers);
      }
    },
    backToSettings() {
      return `/programs/${this.$route.params.programId}/settings`;
    },
  },
  watch: { 
    openUserRoles:{
      handler() {
        if (this.openUserRoles == false) {
          this.projId = null;
          this.fetchRoles(this.$route.params.programId);
        }
      }
    },
    newUserStatus: {
      handler() {
        if (this.newUserStatus == 200) {
          MessageDialogService.showDialog({
            message: ` ${this.firstName +
              this.lastName} successfully added to your program.`,
            
            
          });

          if (this.getNewUserId && this.getNewUserId.msg) {
            let addedUserId = {
              addedUsers: {
                programId: this.programId,
                userIds: [this.getNewUserId.msg],
              },
            };
            this.addUsersToProgram(addedUserId);
          }
          this.SET_NEW_USER_STATUS(0);
          this.fetchProgramUsers(this.$route.params.programId);
          // this.fetchCurrentProject(this.$route.params.programId);
          this.createAnotherUserBtn = true;
          // this.dialogVisible = false;
        }
      },
    },
    editUserDataStatus: {
      handler() {
        if (this.editUserDataStatus == 200) {
          MessageDialogService.showDialog({
            message: `Successfully updated user`,
            
            
          });
          this.SET_EDIT_USER_DATA_STATUS(0);
          this.fetchProgramUsers(this.programId);
          this.editUserDialogVisible = false;
        }
      },
    },
    addedUsersToProgramStatus: {
      handler() {
        if (this.addedUsersToProgramStatus == 200) {
          if (this.portfolioUsers.length > 0) {
            MessageDialogService.showDialog({
              message: `${this.portfolioUsers.length} user(s) successfully added to your program.`,
              
              
            });
          }
          this.addMoreUsersBtn = true;
          this.SET_ADD_USERS_TO_PROGRAM_STATUS(0);
          this.fetchProgramUsers(this.programId);
        }
      },
    },
    programUsersStatus: {
      handler() {
        if (this.programUsersStatus == 200) {
          MessageDialogService.showDialog({
            message: `Successfully removed user from program.`,
            
            
          });
          this.fetchProgramUsers(this.programId);
          this.SET_PROGRAM_USERS_STATUS(0);
        }
      },
    },
    addUserToRoleStatus: {
      handler() {
        if (
          this.addUserToRoleStatus == 204 ||
          this.addUserToRoleStatus == 200
        ) {
          MessageDialogService.showDialog({
            message: `Succesfully assigned user to role(s).`,
            
            
          });
          this.assignProle = false;
          this.assignCrole = false;
          this.assignArole = false;
          this.assignVrole = false;
          this.SET_USERS_ADMIN_ROLES([]);
          this.fetchRoles(this.$route.params.programId);
          this.SET_ADD_USER_TO_ROLE_STATUS(0);
          this.SET_ASSOCIATED_PROJECTS([]);
          this.SET_ASSOCIATED_CONTRACTS([]);
          this.SET_ASSOCIATED_VEHICLES([]);
          this.SET_PROJECT_ROLE_NAMES([]);
          this.SET_ADMIN_ROLE_NAMES([]);
          this.SET_CONTRACT_ROLE_NAMES([]);
          this.SET_VEHICLE_ROLE_NAMES([]);
        }
      },
    },
    removeRoleStatus: {
      handler() {
        if (this.removeRoleStatus == 204 || this.removeRoleStatus == 200) {
          MessageDialogService.showDialog({
            message: `Succesfully removed association(s) from role.`,
            
            
          });
          this.assignArole = false;
          this.fetchRoles(this.$route.params.programId);
          this.SET_REMOVE_ROLE_STATUS(0);
          this.isEditingRoles = false;
          this.isEditingContractRoles = false;
          //this.isEditingVehicleRoles = false;
          this.isEditingAdminRoles = false;
          this.rowIndex_1 = null;
        }
      },
    },
  },
};
</script>

<style scoped lang="scss">
.projectNames {
  // background-color: #F8F9FA;
  border-radius: 0.25rem;
  margin-right: 2px;
  padding: 1px 3px;
  border: solid lightgray 0.75px;
}
::v-deep.el-popper {
  .select-popper {
    display: none;
  }
}

::v-deep.el-table__body-wrapper {
  overflow-y: visible;
}
.right-panel {
  height: calc(100vh - 100px);
  overflow-y: auto;
}
.roleUser {
  position: absolute;
  right: 0;
  top: 0;
}
.buttonWrapper {
  border-bottom: lightgray solid 1px;
}

::v-deep.el-table.usersTable {
  display: -webkit-box;
  -webkit-line-clamp: 4;
  -webkit-box-orient: vertical;
  overflow: hidden;
  &:hover {
    display: -webkit-box;
    -webkit-line-clamp: unset;
  }
}

::v-deep.el-dialog {
  width: 30%;
}
.users {
  ::v-deep.el-dialog__body {
    padding-top: 0 !important;
    padding-bottom: 0 !important;
  }
}
::v-deep.el-dialog__close.el-icon.el-icon-close {
  display: none;
}
::v-deep.el-dialog__header.users {
  padding: 0;
}
::v-deep.el-table th.el-table__cell > .cell,
.priviLabel {
  color: #212529;
  font-size: 1.1rem;
}
.userRoles {
  ::v-deep.el-dialog__body {
    padding-top: 0 !important;
  }
  ::v-deep.el-dialog {
    width: 55%;
  }
  ::v-deep.el-dialog__header {
    padding-bottom: 0 !important;
  }
}
.modalBtns {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.auto-complete-wrapper {
  justify-content: center;
  align-items: center;
  position: relative;
  input {
    width: 100%;
    border: none;
    height: 38px;
    padding-left: 10px;
    padding-right: -10px;
    box-shadow: inset 0 0 0 1px #b2b2b2;
    border-radius: 4px;
    background: transparent;
    transition: all 0.2s ease;
    &:focus {
      outline: none;
      box-shadow: inset 0 0 0 2px #dd9036;
    }
  }
  h5 {
    word-break: break-word;
  }
  .rowPrivileges {
    overflow-x: auto;
  }
  .spanInput {
    background-color: #f5f7fa;
    // border-color: #E4E7ED;
    color: #c0c4cc;
    border-radius: 4px;
    border: solid 1px #e4e7ed;
  }
  .results {
    position: absolute;
    max-height: 300px;
    overflow-y: auto;
    width: 100%;
    background: #fff;
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.19), 0 6px 6px rgba(0, 0, 0, 0.23);
    .result {
      padding: 12px 0.75rem;
      &:hover {
        background: #efefef;
      }
    }
  }
}
</style>
