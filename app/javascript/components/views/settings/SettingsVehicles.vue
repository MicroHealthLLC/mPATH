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
            <i class="fal fa-car mr-1 text-info"></i> VEHICLES
            <span
              v-if="tableData || subTableData"
              class="ml-2 pb-1 badge badge-secondary badge-pill pill"
              >{{ tableData.length + subTableData.length }}
            </span>
            <span v-else class="ml-2 pb-1 badge badge-secondary badge-pill pill"
              >{{ 0 }}
            </span>
          </h4>
        </el-breadcrumb>
        <div class="my-1 pb-2 buttonWrapper container-fluid">
          <div class="row px-0">
            <div class="col">
              <el-button
                v-if="_isallowed('write')"
                @click.prevent="addVehicle"
                class="bg-success text-light mb-2"
              >
                <i class="far fa-plus-circle mr-1"></i> Add Existing Vehicle(s)
              </el-button>
            </div>
            <div class="col-5">
              <el-input
                type="search"
                placeholder="Search by Vehicle Name, SINS/Subcategories, Contract Agency, or Type"
                aria-label="Search"
                class="pr-0"
                aria-describedby="search-addon"
                v-model="search"
                data-cy=""
              >
                <el-button slot="prepend" icon="el-icon-search"></el-button>
              </el-input>
            </div>
            <div class="col pl-0">
              <el-select
                class="w-100 mx-2"
                v-model="C_projectGroupFilter"
                track-by="id"
                value-key="id"
                multiple
                filterable
                clearable
                name="Project Group"
                placeholder="Filter Vehicles By Group"
              >
                <el-option
                  v-for="item in groupList"
                  :key="item.id"
                  :label="item.name"
                  :value="item"
                >
                </el-option>
              </el-select>
            </div>
          </div>
        </div>
        <div
          v-loading="!vehiclesLoaded"
          element-loading-text="Fetching your data. Please wait..."
          element-loading-spinner="el-icon-loading"
          element-loading-background="rgba(0, 0, 0, 0.8)"
          class=""
          v-if="_isallowed('read')"
        >
          <el-tabs type="border-card" @tab-click="handleClick">
            <el-tab-pane class="p-3" style="postion:relative" label="PRIME">
              <el-table
                v-if="tableData"           
                :data="
                  tableData
                    .filter(
                      (data) =>
                        !search ||
                        data.contract_vehicle.name
                          .toLowerCase()
                          .includes(search.toLowerCase()) ||
                        data.contract_vehicle.full_name
                          .toLowerCase()
                          .includes(search.toLowerCase()) ||
                        data.contract_vehicle.contract_agency.name
                          .toLowerCase()
                          .includes(search.toLowerCase()) ||
                        data.contract_vehicle.contract_sub_category.name
                          .toLowerCase()
                          .includes(search.toLowerCase()) ||
                        data.contract_vehicle.contract_vehicle_type.name
                          .toLowerCase()
                          .includes(search.toLowerCase())
                    )
                    .reverse()
                "
                style="width: 100%"
                highlight-current-row
                height="450"
                ref="table"
                :row-key="(row) => row.id"
                :expand-row-keys="expandRowKeys"
                @expand-change="handleExpandChange"
                :default-sort="{ prop: 'name', order: 'ascending' }"
              >
                <el-table-column prop="prime_name" label="Prime">
                  <template slot-scope="scope">
                    <span v-if="scope.row.contract_vehicle.prime_name">
                      {{ scope.row.contract_vehicle.prime_name }}
                    </span>
                    <span v-else>
                      MicroHealth, LLC
                    </span>
                  </template>
                </el-table-column>
                <el-table-column prop="name" label="Vehicle Nickname">
                  <template slot-scope="scope">
                    <span v-if="scope.row.contract_vehicle.name">
                      {{ scope.row.contract_vehicle.name }}
                    </span>
                  </template>
                </el-table-column>
                <el-table-column label="Vehicle Full Name">
                  <template slot-scope="scope">
                    <span v-if="scope.row.contract_vehicle.full_name">
                      {{ scope.row.contract_vehicle.full_name }}
                    </span>
                  </template>
                </el-table-column>
                <!-- <el-table-column label="SINS or Subcategories">
              <template slot-scope="scope">
                <span
                  v-if="
                    scope.row.contract_vehicle.contract_sub_category &&
                      scope.row.contract_vehicle.contract_sub_category
                        .name !== null
                  "
                >
                  {{
                    scope.row.contract_vehicle.contract_sub_category.name
                  }}
                </span>
              </template>
            </el-table-column> -->
                <el-table-column label="Contracting Agency">
                  <template slot-scope="scope">
                    <span
                      v-if="
                        scope.row.contract_vehicle.contract_agency &&
                          scope.row.contract_vehicle.contract_agency.name !==
                            null
                      "
                    >
                      {{ scope.row.contract_vehicle.contract_agency.name }}
                    </span>
                  </template>
                </el-table-column>
                <el-table-column label="Vehicle Type">
                  <template slot-scope="scope">
                    <span
                      v-if="
                        scope.row.contract_vehicle.contract_vehicle_type &&
                          scope.row.contract_vehicle.contract_vehicle_type
                            .name !== null
                      "
                    >
                      {{
                        scope.row.contract_vehicle.contract_vehicle_type.name
                      }}
                    </span>
                  </template>
                </el-table-column>
                <el-table-column
                  prop="facility_group"
                  sortable
                  filterable
                  label="Group"
                >
                  <template slot-scope="scope">
                    <el-select
                      v-model="scope.row.facility_group_id"
                      class="w-100"
                      v-if="rowId == scope.row.contract_vehicle.id"
                      filterable
                      track-by="id"
                      clearable
                      value-key="id"
                      placeholder="Search and select Group"
                    >
                      <el-option
                        v-for="item in facilityGroups"
                        :value="item.id"
                        :key="item.id"
                        :label="item.name"
                      >
                      </el-option>
                    </el-select>

                    <span v-else>
                      <span
                        v-if="
                          scope.row.facility_group &&
                            scope.row.facility_group.name &&
                            rowId !== scope.row.contract_vehicle.id
                        "
                      >
                        {{ scope.row.facility_group.name }}
                      </span>
                    </span>
                    <!-- <el-input
                size="small"
                style="text-align:center"
                v-model="scope.row.facilityGroupName"
              ></el-input> -->
                  </template>
                </el-table-column>
                <el-table-column label="Actions" align="right">
                  <template slot-scope="scope">
                    <span class="px-0">                     
                      <el-button
                        size="small"
                        type="default"
                        v-tooltip="`Change Group`"
                        @click.prevent="editMode(scope.$index, scope.row)"
                        v-if="scope.$index !== rowIndex && _isallowed('write')"
                        class="bg-light btn-sm px-2"
                      >
                        <i class="fal fa-network-wired mh-blue-text"></i>
                      </el-button>
                      <el-button
                        size="small"
                        type="default"
                        v-tooltip="`Manage User(s)`"
                        @click.prevent="addUserRole(scope.$index, scope.row)"
                        v-if="scope.$index !== rowIndex"
                        class="bg-primary text-light btn-sm px-2"
                      >
                        <i class="fas fa-users-medical"></i>
                      </el-button>
                      <el-button
                        size="small"
                        type="default"
                        v-if="scope.$index == rowIndex"
                        @click.prevent="saveEdits(scope.$index, scope.row)"
                        v-tooltip="`Save`"
                        class="bg-primary btn-sm text-light px-2"
                      >
                        <i class="far fa-save"></i>
                      </el-button>
                      <el-button
                        size="small"
                        type="default"
                        v-tooltip="`Cancel Edit`"
                        v-if="scope.$index == rowIndex"
                        @click.prevent="cancelEdits(scope.$index, scope.row)"
                        class="bg-secondary btn-sm text-light px-2"
                      >
                        <i class="fas fa-ban"></i>
                      </el-button>
                      <el-button
                        type="default"
                        size="small"
                        class="bg-light btn-sm px-2"
                        v-tooltip="'Remove Vehicle'"
                        @click.prevent="
                          removeVehicleBtn(scope.$index, scope.row)
                        "
                        v-if="scope.$index !== rowIndex && _isallowed('write')"
                      >
                        <i class="fa-light fa-circle-minus text-danger"></i>
                      </el-button>
                      <el-button
                       size="small"
                        type="default"
                        v-tooltip="`Go To Vehicle`"
                        v-if="
                          _isallowedContracts(
                            scope.row.id, // should be scope.row.project_contract_vehicle_id but returns undefined
                            'read'
                          )
                        "
                        @click.prevent="goToVehicle(scope.$index, scope.row)"
                        class="bg-success text-light btn-sm"
                      >
                        <i class="fas fa-arrow-alt-circle-right"></i>
                      </el-button>
                    </span>
                    <!-- <el-button type="primary" @click="handleEditRow(scope.$index)">Edit</el-button> -->
                  </template>
                </el-table-column>
              </el-table>
            </el-tab-pane>
            <el-tab-pane
              class="p-3"
              style="postion:relative"
              label="SUBCONTRACT"
            >
              <el-table
                v-if="subTableData"
                :data="
                  subTableData
                    .filter(
                      (data) =>
                        !search ||
                        data.contract_vehicle.name
                          .toLowerCase()
                          .includes(search.toLowerCase()) ||
                        data.contract_vehicle.full_name
                          .toLowerCase()
                          .includes(search.toLowerCase()) ||
                        data.contract_vehicle.contract_agency.name
                          .toLowerCase()
                          .includes(search.toLowerCase()) ||
                        data.contract_vehicle.subprime_name
                          .toLowerCase()
                          .includes(search.toLowerCase()) ||
                        data.contract_vehicle.contract_vehicle_type.name
                          .toLowerCase()
                          .includes(search.toLowerCase())
                    )
                    .reverse()
                "
                style="width: 100%"
                highlight-current-row
                height="450"
                ref="table"
                :row-key="(row) => row.id"
                :expand-row-keys="expandRowKeys"
                @expand-change="handleExpandChange"
                :default-sort="{ prop: 'name', order: 'ascending' }"
              >
                <el-table-column prop="subprime_name" label="Subcontract Prime">
                  <template slot-scope="scope">
                    <span v-if="scope.row.contract_vehicle.subprime_name">
                      {{ scope.row.contract_vehicle.subprime_name }}
                    </span>
                  </template>
                </el-table-column>
                <el-table-column prop="name" label="Vehicle Nickname">
                  <template slot-scope="scope">
                    <span v-if="scope.row.contract_vehicle.name">
                      {{ scope.row.contract_vehicle.name }}
                    </span>
                  </template>
                </el-table-column>
                <el-table-column label="Vehicle Full Name">
                  <template slot-scope="scope">
                    <span v-if="scope.row.contract_vehicle.full_name">
                      {{ scope.row.contract_vehicle.full_name }}
                    </span>
                  </template>
                </el-table-column>
                <el-table-column label="Contract Name">
                  <template slot-scope="scope">
                    <span v-if="scope.row.contract_vehicle.contract_name">
                      {{ scope.row.contract_vehicle.contract_name }}
                    </span>
                  </template>
                </el-table-column>
                <el-table-column label="Contracting Agency" width="150">
                  <template slot-scope="scope">
                    <span
                      v-if="
                        scope.row.contract_vehicle.contract_agency &&
                          scope.row.contract_vehicle.contract_agency.name !==
                            null
                      "
                    >
                      {{ scope.row.contract_vehicle.contract_agency.name }}
                    </span>
                  </template>
                </el-table-column>
                <el-table-column label="Vehicle Type" width="150">
                  <template slot-scope="scope">
                    <span
                      v-if="
                        scope.row.contract_vehicle.contract_vehicle_type &&
                          scope.row.contract_vehicle.contract_vehicle_type
                            .name !== null
                      "
                    >
                      {{
                        scope.row.contract_vehicle.contract_vehicle_type.name
                      }}
                    </span>
                  </template>
                </el-table-column>
                <el-table-column
                  prop="facility_group"
                  sortable
                  filterable
                  label="Group"
                >
                  <template slot-scope="scope">
                    <el-select
                      v-model="scope.row.facility_group_id"
                      class="w-100"
                      v-if="rowId == scope.row.contract_vehicle.id"
                      filterable
                      track-by="id"
                      clearable
                      value-key="id"
                      placeholder="Search and select Group"
                    >
                      <el-option
                        v-for="item in facilityGroups"
                        :value="item.id"
                        :key="item.id"
                        :label="item.name"
                      >
                      </el-option>
                    </el-select>

                    <span v-else>
                      <span
                        v-if="
                          scope.row.facility_group &&
                            scope.row.facility_group.name &&
                            rowId !== scope.row.contract_vehicle.id
                        "
                      >
                        {{ scope.row.facility_group.name }}
                      </span>
                    </span>
                    <!-- <el-input
                size="small"
                style="text-align:center"
                v-model="scope.row.facilityGroupName"
              ></el-input> -->
                  </template>
                </el-table-column>
                <el-table-column label="Actions" align="right">
                  <template slot-scope="scope">                   
                    <el-button
                     size="small"
                      type="default"
                      v-tooltip="`Change Group`"
                      @click.prevent="editMode(scope.$index, scope.row)"
                      v-if="scope.$index !== rowIndex && _isallowed('write')"
                      class="bg-light btn-sm px-2"
                    >
                      <i class="fal fa-network-wired mh-blue-text"></i>
                    </el-button>
                    <el-button
                      size="small"
                      type="default"
                      v-tooltip="`Manage User(s)`"
                      @click.prevent="addUserRole(scope.$index, scope.row)"
                      v-if="scope.$index !== rowIndex"
                      class="bg-primary text-light btn-sm px-2"
                    >
                      <i class="fas fa-users-medical mr-1"></i>
                    </el-button>
                    <el-button
                      size="small"
                      type="default"
                      v-if="scope.$index == rowIndex"
                      @click.prevent="saveEdits(scope.$index, scope.row)"
                      v-tooltip="`Save`"
                      class="bg-primary btn-sm text-light px-2"
                    >
                      <i class="far fa-save"></i>
                    </el-button>
                     <el-button
                      size="small"
                      type="default"
                      v-tooltip="`Cancel Edit`"
                      v-if="scope.$index == rowIndex"
                      @click.prevent="cancelEdits(scope.$index, scope.row)"
                      class="bg-secondary btn-sm text-light px-2"
                    >
                      <i class="fas fa-ban"></i>
                    </el-button>
                    <el-button
                      size="small"
                      type="default"
                      class="bg-light btn-sm px-2"
                      v-tooltip="'Remove Vehicle'"
                      @click.prevent="removeVehicleBtn(scope.$index, scope.row)"
                      v-if="scope.$index !== rowIndex && _isallowed('write')"
                    >
                      <i class="fa-light fa-circle-minus text-danger"></i>
                    </el-button>
                    <el-button
                      size="small"
                      type="default"
                      v-tooltip="`Go To Vehicle`"
                      v-if="_isallowedContracts(scope.row.id, 'read')"
                      @click.prevent="goToVehicle(scope.$index, scope.row)"
                      class="bg-success text-light btn-sm px-2"
                    >
                      <i class="fas fa-arrow-alt-circle-right"></i>
                    </el-button>
                  </template>
                </el-table-column>
              </el-table>
            </el-tab-pane>
          </el-tabs>
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
        :visible.sync="openUserPrivilegesDialog"
        append-to-body
        center
        class="addUserRole p-0"
      >
        <span slot="title" class="text-left add-groups-header ">
          <h5 style="color:#383838" v-if="vehicleData">
            <i class="far fa-car mr-1 mb-2 text-info"></i>
            {{ vehicleData.contract_vehicle.name }}
          </h5>
        </span>
        <div class="container-fluid p-0">
          <div
            class="pl-3 mt-0 row"
            v-if="
              viableVehicleUsers &&
                viableVehicleUsers.length > 0 &&
                _isallowed('write')
            "
          >
            <div class="col-5 pt-0 pl-0">
              <label class="font-md mb-0 d-flex">Add User(s) To Vehicle</label>
              <el-select
                v-model="contractRoleUsers"
                filterable
                class="w-100"
                clearable
                multiple
                track-by="id"
                value-key="id"
                placeholder="Search and select Project Users"
              >
                <el-option
                  v-for="item in viableVehicleUsers"
                  :value="item"
                  :key="item.id"
                  :label="item.fullName"
                >
                </el-option>
              </el-select>
            </div>
            <div class="col-5 pt-0">
              <label class="font-md mb-0 d-flex"
                >Select Role for User(s)
              </label>
              <el-select
                v-model="contractRoleNames"
                filterable
                class="w-100"
                clearable
                track-by="id"
                value-key="id"
                placeholder="Search and select Project Users"
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
            <div class="col-2 pt-0 text-right">
              <label class="font-md mb-0 d-flex" style="visibility:hidden"
                >|</label
              >

              <el-button
               size="small"
                type="default"
                @click="saveVehicleUserRole()"
                v-if="contractRoleNames && contractRoleUsers"
                v-tooltip="`Confirm`"
                class="bg-primary btn-sm text-light"
              >
                <i class="far fa-save"></i>
              </el-button>
            </div>
          </div>
          <div
            class="pl-3 mt-0 row"
            v-if="
              getRolesLoaded &&
                contentLoaded &&
                viableVehicleUsers &&
                viableVehicleUsers.length <= 0
            "
          >
            There are currently no program users to assign to this vehicle. You
            can either add new program users from portfolio or remove desired
            user from current role in this vehicle.
          </div>
          <div class="mt-4 row">
            <div class="col-12 pt-0">
              <el-table
                v-loading="!getRolesLoaded"
                element-loading-spinner="el-icon-loading"
                v-if="
                  contractUsers &&
                    contractUsers.roleIds &&
                    contractUsers.roleIds.length > 0
                "
                :header-cell-style="{ background: '#EDEDED' }"
                :data="contractUsers.roleIds"
                height="375"
                width="100%"
              >
                <el-table-column
                  prop="user_full_name"
                  width="200"
                  sortable
                  filterable
                  label="Role"
                >
                  <template slot-scope="scope">
                    <span
                      v-if="
                        (contractUsers.data.map(
                          (t) => t.role_id == scope.row
                        ) &&
                          scope.$index !== rowIndex_1) ||
                          (scope.$index == rowIndex_1 && isEditingRoles)
                      "
                    >
                      {{
                        contractUsers.data
                          .filter((t) => t.role_id == scope.row)
                          .map((t) => t.role_name)[0]
                      }}
                    </span>
                    <span v-if="changeRoleMode && scope.$index == rowIndex_1">
                      <el-select
                        v-if="bulkChangeContractRoleNames.id"
                        v-model="bulkChangeContractRoleNames"
                        filterable
                        class="w-100"
                        track-by="id"
                        value-key="id"
                      >
                        <el-option
                          v-for="item in getRoles.filter(
                            (t) => t.type_of == 'contract'
                          )"
                          :value="item"
                          :key="item.id"
                          :label="item.name"
                        >
                        </el-option>
                      </el-select>
                      <el-select
                        v-if="
                          currentRoleName && !bulkChangeContractRoleNames.id
                        "
                        v-model="currentRoleName"
                        filterable
                        class="w-100"
                        track-by="id"
                        value-key="id"
                      >
                        <el-option
                          v-for="item in getRoles.filter(
                            (t) => t.type_of == 'contract'
                          )"
                          :value="item"
                          :key="item.id"
                          :label="item.name"
                        >
                        </el-option>
                      </el-select>
                      <!-- {{ scope.row}}   -->
                    </span>
                  </template>
                </el-table-column>
                <el-table-column
                  prop="role_name"
                  width="675"
                  sortable
                  filterable
                  label="Users"
                >
                  <template slot-scope="scope">
                    <span v-if="scope.$index !== rowIndex_1 || changeRoleMode">
                      <span v-for="(item, i) in contractUsers.data" :key="i">
                        <span
                          v-if="
                            item.user_id &&
                              programUsers.map((t) => t.id == item.user_id) &&
                              item.role_id == scope.row &&
                              programUsers
                                .filter((t) => item.user_id == t.id)
                                .map((t) => t.fullName).length > 0
                          "
                          class="userNames"
                        >
                          {{
                            programUsers
                              .filter((t) => item.user_id == t.id)
                              .map((t) => t.fullName)
                              .join()
                          }}
                        </span>
                      </span>
                    </span>
                    <span v-if="isEditingRoles && scope.$index == rowIndex_1">
                      <el-select
                        v-model="assignedContractUsers"
                        :disabled="
                          assignedContractUsers &&
                            assignedContractUsers.length <= 0
                        "
                        filterable
                        class="w-100 el-popper"
                        :popper-append-to-body="false"
                        popper-class="select-popper"
                        clearable
                        multiple
                        track-by="id"
                        value-key="id"
                        placeholder="No Users Assigned to this Project"
                      >
                        <el-option
                          v-for="item in programUsers"
                          :value="item"
                          :key="item.id"
                          :label="item.fullName"
                        >
                        </el-option>
                      </el-select>
                    </span>
                  </template>
                </el-table-column>
                <el-table-column
                  width="145"
                  fixed="right"
                  align="center"
                  v-if="_isallowed('delete') || _isallowed('write')"
                >
                  <template slot-scope="scope" class="px-0">
                    <el-button
                      size="small"
                      type="default"
                      @click="bulkChangeRole(scope.$index, scope.row)"
                      v-if="scope.$index !== rowIndex_1 && _isallowed('write')"
                      v-tooltip="`Change Role`"
                      class="bg-light btn-sm mx-0 px-2"
                    >
                      <i class="fa-solid fa-users-gear text-primary"></i>
                    </el-button>
                    <el-button
                      size="small"
                      type="default"
                      @click="saveBulkChangeRole(scope.$index, scope.row)"
                      v-if="
                        scope.$index == rowIndex_1 &&
                          changeRoleMode &&
                          (bulkChangeContractRoleNames.id ||
                            currentRoleName.id) &&
                          scope.row !== bulkChangeContractRoleNames.id &&
                          scope.row !== currentRoleName.id
                      "
                      v-tooltip="`Save`"
                      class="bg-primary btn-sm text-light mx-0 px-2"
                    >
                      <i class="far fa-save"></i>
                    </el-button>
                    <el-button
                      size="small"
                      type="default"
                      @click="saveRemoveUsers(scope.$index, scope.row)"
                      v-if="isEditingRoles && scope.$index == rowIndex_1"
                      v-tooltip="`Save`"
                      class="bg-primary btn-sm text-light px-2"
                    >
                      <i class="far fa-save"></i>
                    </el-button>
                    <el-button
                      size="small"
                      type="default"
                      v-if="scope.$index !== rowIndex_1 && _isallowed('delete')"
                      v-tooltip="`Remove all users from this role`"
                      @click.prevent="removeAllUsers(scope.$index, scope.row)"
                      class="bg-danger btn-sm mx-0 px-2"
                    >
                      <i class="fa-solid fa-users-slash mr-1 text-light"></i>
                    </el-button>
                    <el-button
                      size="small"
                      type="default"
                      v-if="scope.$index !== rowIndex_1 && _isallowed('delete')"
                      v-tooltip="`Remove user(s) from this role`"
                      @click.prevent="editUsers(scope.$index, scope.row)"
                      class="bg-danger text-light btn-sm mx-0 px-2"
                    >
                      <i class="fa-solid fa-user-slash text-light"></i>
                    </el-button>
                    <el-button
                     size="small"
                      type="default"
                      v-if="isEditingRoles && scope.$index == rowIndex_1"
                      v-tooltip="`Cancel`"
                      @click.prevent="cancelEditRoles(scope.$index, scope.row)"
                      class="btn btn-sm bg-secondary text-light px-2"
                    >
                      <i class="fas fa-ban"></i>
                    </el-button>
                    <el-button
                      size="small"
                      type="default"
                      v-if="changeRoleMode && scope.$index == rowIndex_1"
                      v-tooltip="`Cancel`"
                      @click.prevent="
                        cancelBulkChangeRole(scope.$index, scope.row)
                      "
                      class="btn btn-sm bg-secondary text-light mx-0 px-2"
                    >
                      <i class="fas fa-ban"></i>
                    </el-button>
                  </template>
                </el-table-column>
              </el-table>
              <span class="" v-else>
                No Users Assigned
              </span>

              <div class="right mt-3">
                <button
                  @click.prevent="closeUserRoles"
                  class="btn btn-md bg-secondary text-light modalBtns"
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
        :visible.sync="vehicleDialogVisible"
        append-to-body
        center
        class="contractForm addVehicle p-0"
      >
        <div class="row mb-3">
          <div class="col-5">
            <span slot="title" class="text-left add-groups-header ">
              <h5 class="text-dark">
                <i class="far fa-plus-circle mr-1 mb-3"></i>Add Existing Vehicle
              </h5>
            </span>
          </div>
          <div class="col-7 text-right">
            <el-input
              type="search"
              placeholder="Search by Vehicle Name, SINS/Subcategories, Contract Agency, or Type"
              aria-label="Search"
              class="w-100"
              aria-describedby="search-addon"
              v-model="searchContractVehiclesData"
              data-cy=""
            >
              <el-button slot="prepend" icon="el-icon-search"></el-button>
            </el-input>
          </div>
        </div>
        <template>
          <div
            v-loading="!contractVehiclesLoaded"
            element-loading-text="Fetching your data. Please wait..."
            element-loading-spinner="el-icon-loading"
            element-loading-background="rgba(0, 0, 0, 0.8)"
            class="addVehicleModal"
          >
            <el-tabs type="border-card" @tab-click="handleClick">
              <el-tab-pane class="p-3" style="postion:relative" label="PRIME">
                <el-table
                  :data="allVehicles"
                  v-if="allVehicles && allVehicles.length > 0"
                  style="width: 100%"
                >
                  <el-table-column prop="prime_name" label="Prime">
                    <template slot-scope="scope">
                      <span v-if="scope.row.prime_name">
                        {{ scope.row.prime_name }}
                      </span>
                      <span v-else>
                        MicroHealth, LLC.
                      </span>
                    </template>
                  </el-table-column>
                  <el-table-column prop="name" label="Vehicle Nickname">
                  </el-table-column>
                  <el-table-column label="Vehicle Full Name">
                    <template slot-scope="scope">
                      <span v-if="scope.row.full_name">
                        {{ scope.row.full_name }}
                      </span>
                    </template>
                  </el-table-column>
                  <!-- <el-table-column label="SINS or Subcategories">
                <template slot-scope="scope">
                  <span
                    v-if="
                      scope.row.contract_sub_category &&
                        scope.row.contract_sub_category.name !== null
                    "
                  >
                    {{ scope.row.contract_sub_category.name }}
                  </span>
                </template>
              </el-table-column> -->
                  <el-table-column label="Contracting Agency">
                    <template slot-scope="scope">
                      <span
                        v-if="
                          scope.row.contract_agency &&
                            scope.row.contract_agency.name !== null
                        "
                      >
                        {{ scope.row.contract_agency.name }}
                      </span>
                    </template>
                  </el-table-column>
                  <el-table-column label="Vehicle Type">
                    <template slot-scope="scope">
                      <span
                        v-if="
                          scope.row.contract_vehicle_type &&
                            scope.row.contract_vehicle_type.name !== null
                        "
                      >
                        {{ scope.row.contract_vehicle_type.name }}
                      </span>
                    </template>
                  </el-table-column>
                  <el-table-column label="Actions" fixed="right" align="right">
                    <template slot-scope="scope">
                      <el-button
                        size="small"
                        type="default"
                        v-tooltip="`Add Vehicle`"
                        @click.prevent="
                          addExistingVehicle(scope.$index, scope.row)
                        "
                        class="bg-primary text-light btn-sm"
                      >
                        <i class="far fa-plus-circle"></i>
                      </el-button>
                    </template>
                  </el-table-column>
                </el-table>
                <span class="mt-3" v-else>
                  <h4><em>There are currently no vehicles to display</em></h4>
                </span>
              </el-tab-pane>

              <el-tab-pane
                class="p-3"
                style="postion:relative"
                label="SUBCONTRACT"
              >
                <el-table
                  :data="allSubVehicles"
                  v-if="allSubVehicles && allSubVehicles.length > 0"
                  style="width: 100%"
                >
                  <el-table-column
                    prop="subprime_name"
                    label="Subcontract Prime"
                  >
                  </el-table-column>
                  <el-table-column prop="name" label="Vehicle Nickname">
                  </el-table-column>
                  <el-table-column label="Contract Name">
                    <template slot-scope="scope">
                      <span v-if="scope.row.contract_name">
                        {{ scope.row.contract_name }}
                      </span>
                    </template>
                  </el-table-column>
                  <el-table-column label="Vehicle Full Name">
                    <template slot-scope="scope">
                      <span v-if="scope.row.full_name">
                        {{ scope.row.full_name }}
                      </span>
                    </template>
                  </el-table-column>
                  <el-table-column label="Contracting Agency">
                    <template slot-scope="scope">
                      <span
                        v-if="
                          scope.row.contract_agency &&
                            scope.row.contract_agency.name !== null
                        "
                      >
                        {{ scope.row.contract_agency.name }}
                      </span>
                    </template>
                  </el-table-column>
                  <el-table-column label="Vehicle Type">
                    <template slot-scope="scope">
                      <span
                        v-if="
                          scope.row.contract_vehicle_type &&
                            scope.row.contract_vehicle_type.name !== null
                        "
                      >
                        {{ scope.row.contract_vehicle_type.name }}
                      </span>
                    </template>
                  </el-table-column>
                  <el-table-column label="Actions" fixed="right">
                    <template slot-scope="scope">
                      <el-button
                       size="small"
                        type="default"
                        v-tooltip="`Add Vehicle`"
                        @click.prevent="
                          addExistingVehicle(scope.$index, scope.row)
                        "
                        class="bg-primary text-light btn-sm"
                      >
                        <i class="far fa-plus-circle"></i>
                      </el-button>
                    </template>
                  </el-table-column>
                </el-table>
                <span class="mt-3" v-else>
                  <h4><em>There are currently no vehicles to display</em></h4>
                </span>
              </el-tab-pane>
            </el-tabs>
          </div>
        </template>
      </el-dialog>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
import SettingsSidebar from "./SettingsSidebar.vue";
// import { createUser, deleteUser, dbCollection } from "../../../packs/firebase";
export default {
  name: "SettingsVehicles",
  props: ["currentContract"],
  components: {
    SettingsSidebar,
  },
  data() {
    return {
      today: new Date().toISOString().slice(0, 10),
      currentRoleName: {},
      searchContractVehiclesData: "",
      newGroup: null,
      vehicleDialogVisible: false,
      rowIndex_1: null,
      isEditingRoles: false,
      roleRowId: null,
      userids: null,
      changeRoleMode: false,
      expandRowKeys: [],
      currentFacility: {},
      vehicleData: null,
      dialogVisible: false,
      openUserPrivilegesDialog: false,
      currentFacilityGroup: {},
      rowIndex: null,
      rowId: null,
      projId: null,
      projectNameText: "",
      searchRoleUsers: "",
      search: "",
      searchContractUsers: "",
      hideSaveBtn: false,
      contractNameText: "",
      contractNicknameText: "",
      showPrime: true,
      expanded: {
        id: "",
      },

      //contractVehicles: [],
      //projectVehicles: [],
    };
  },
  mounted() {
    //if (Vue.prototype.$contractPrivilegesRoles) {
    //  console.log(Vue.prototype.$contractPrivilegesRoles);
    //}

    //this.fetchContractVehicles(this.$route.params.programId);
    this.fetchVehicles(this.$route.params.programId);
    this.fetchRoles(this.$route.params.programId);
    if (this.groups && this.groups.length <= 0) {
      this.fetchGroups(this.$route.params.programId);
    }
  },
  methods: {
    ...mapMutations([
      "setProjectGroupFilter",
      "setContractTable",
      "setGroupFilter",
      "SET_VEHICLE_STATUS",
      "setContractTypeFilter",
      "setNewContractGroupFilter",
      "SET_CONTRACT_GROUP_TYPES",
      "SET_ADD_USER_TO_ROLE_STATUS",
      "SET_CONTRACT_ROLE_USERS",
      "SET_CONTRACT_ROLE_NAMES",
      "SET_BULK_CONTRACT_ROLE_NAMES",
      "SET_ASSIGNED_CONTRACT_USERS",
      "SET_REMOVE_CONTRACT_ROLE_STATUS",
      "SET_REMOVE_VEHICLE_ROLE_STATUS",
      "SET_ASSOCIATED_VEHICLES_STATUS",
      "SET_CONTRACTS_STATUS",
    ]),
    ...mapActions([
      "fetchContractVehicles",
      "fetchVehicles",
      "fetchVehicleProjects",
      "fetchCurrentProject",
      "createContract",
      "fetchGroups",
      "updateVehicle",
      "deleteContract",
      "addUserToRole",
      "fetchRoles",
      "removeUserRole",
      "associateVehicleToProgram",
      "removeVehicle",
      "deleteVehicle",
      "projectContracts",
      "bulkUpdateUserRoles",
    ]),
    _isallowed(salut) {
      return this.checkPrivileges("SettingsVehicles", salut, this.$route, {
        settingType: "Contracts",
      });
    },
    handleClick(tab, event) {
      console.log(tab);
      console.log(`${("event:", event)}`);
    },
    _isallowedContracts(c, salut) {
      //console.log(c);
      return this.checkPrivileges(
        "ProjectSettingVehicleList",
        salut,
        this.$route,
        { method: "isallowedVehicles", project_contract_vehicle_id: c }
      );
    },
    editUsers(index, rowData) {
      console.log(rowData);
      this.userids = this.contractUsers.data.filter(
        (t) => t.role_id == rowData
      );
      console.log(this.userids);
      this.SET_ASSIGNED_CONTRACT_USERS(this.assignedUsers);
      this.rowIndex_1 = index;
      this.roleRowId = rowData;
      this.isEditingRoles = true;
      // console.log(this.userids)
    },
    saveRemoveUsers(index, rowData) {
      let user_ids = this.assignedContractUsers.map((t) => t.id);
      let assigned = this.assignedUsers.map((t) => t.id);
      let ids = assigned.filter((t) => !user_ids.includes(t));
      let projectUserRoleData = {
        userData: {
          roleId: rowData,
          vehicleId: this.projId,
          programId: this.$route.params.programId,
          userIds: ids,
        },
      };
      console.log(projectUserRoleData);
      this.removeUserRole({
        ...projectUserRoleData,
      });
    },
    bulkChangeRole(index, rowData) {
      this.currentRoleName = this.getRoles
        .filter((t) => t.id == rowData)
        .map((t) => t)[0];
      this.changeRoleMode = true;
      this.rowIndex_1 = index;
      this.roleRowId = rowData;
    },
    saveBulkChangeRole(index, rowData) {
      this.userids = this.contractUsers.data.filter(
        (t) => t.role_id == rowData
      );
      this.SET_ASSIGNED_CONTRACT_USERS(this.assignedUsers);
      let old_role = this.getRoles
        .filter((t) => t.id == rowData)
        .map((t) => t)[0];
      let new_role;
      if (this.bulkChangeContractRoleNames.id) {
        new_role = this.bulkChangeContractRoleNames;
      } else new_role = this.currentRoleName;
      let user_ids = this.assignedContractUsers.map((t) => t.id);
      let ids = this.assignedContractUsers
        .map((t) => t.id)
        .filter((t) => user_ids.includes(t));
      let roleUsers = this.contractUsers.data.filter(
        (t) => t.role_id == rowData
      );
      // debugger
      let projectUserRoleData = {
        userData: {
          roleId: new_role.id,
          roleUserIds: roleUsers.map((t) => t.id),
          userIds: ids,
          programId: this.$route.params.programId,
        },
      };
      console.log(ids);
      this.bulkUpdateUserRoles({
        ...projectUserRoleData,
      });
    },
    // saveBulkChangeRole(index, rowData){
    // let user_ids = this.assignedContractUsers.map(t => t.id);
    // this.SET_ASSIGNED_CONTRACT_USERS(this.assignedUsers)
    // let user_ids = this.assignedContractUsers.map(t => t.id);
    // let ids = this.assignedUsers.map(t => t.id).filter(t => user_ids.includes(t));
    //   let projectUserRoleData = {
    //             userData: {
    //               roleId: rowData,
    //               contractId: this.projId,
    //               programId: this.$route.params.programId,
    //               userIds: ids,
    //           },
    //         };

    //          console.log(this.assignedUsers)
    //         this.removeUserRole({
    //           ...projectUserRoleData,
    //         }).then(() => {
    //           let user_ids = this.assignedContractUsers.map(t => t.id);
    //           let ids = this.assignedUsers.map(t => t.id).filter(t => user_ids.includes(t));
    //           let contractUserRoleData = {
    //               userData: {
    //                 roleId:  this.bulkChangeContractRoleNames.id,
    //                 userIds:  ids,
    //                 programId: this.$route.params.programId,
    //                 contractId: this.projId
    //             },
    //           };
    //         this.addUserToRole({
    //           ...contractUserRoleData,
    //         });
    //      });
    // },
    removeAllUsers(index, rowData) {
      this.userids = this.contractUsers.data.filter(
        (t) => t.role_id == rowData
      );
      this.SET_ASSIGNED_CONTRACT_USERS(this.assignedUsers);
      this.$confirm(
        `Are you sure you want to remove all users from this vehicle role?`,
        "Confirm Remove",
        {
          confirmButtonText: "Remove",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
      ).then(() => {
        let user_ids = this.assignedContractUsers.map((t) => t.id);
        let ids = this.assignedUsers
          .map((t) => t.id)
          .filter((t) => user_ids.includes(t));
        let projectUserRoleData = {
          userData: {
            roleId: rowData,
            vehicleId: this.projId,
            programId: this.$route.params.programId,
            userIds: ids,
          },
        };

        console.log(this.assignedUsers);
        this.removeUserRole({
          ...projectUserRoleData,
        });
      });
    },
    cancelEditRoles(index, rowData) {
      this.isEditingRoles = false;
      this.roleRowId = null;
      this.rowIndex_1 = null;
    },
    cancelBulkChangeRole() {
      this.changeRoleMode = false;
      this.roleRowId = null;
      this.rowIndex_1 = null;
      this.bulkChangeContractRoleNames = {};
    },
    saveVehicleUserRole(index, rows) {
      let user_ids = this.contractRoleUsers.map((t) => t.id);
      console.log(this.contractRoleUsers);
      console.log(this.contractRoleNames);
      let contractUserRoleData = {
        userData: {
          roleId: this.contractRoleNames.id,
          userIds: user_ids,
          programId: this.$route.params.programId,
          vehicleId: this.projId,
        },
      };
      console.log(contractUserRoleData);
      this.addUserToRole({
        ...contractUserRoleData,
      });
    },
    closeUserRoles() {
      this.openUserPrivilegesDialog = false;
      this.isEditingRoles = false;
      this.roleRowId = null;
      this.rowIndex_1 = null;
    },
    addUserRole(index, rows) {
      console.log(rows);
      this.openUserPrivilegesDialog = true;
      this.projId = rows.id;
      this.vehicleData = rows;
    },
    addExistingVehicle(index, rows) {
      //console.log(rows)
      let vehicleData = {
        vehicle: {
          id: rows.id,
          programId: this.$route.params.programId,
        },
      };
      this.associateVehicleToProgram({ ...vehicleData });
    },
    goToVehicle(index, rows) {
      console.log(rows);
      let programId = this.$route.params.programId;
      //Needs to be optimzed using router.push.  However, Project Sidebar file has logic that affects this routing
      // window.location.pathname = `/programs/${this.$route.params.programId}/sheet/contracts/${rows.project_contract_id}/`
      this.$router.push({
        name: "SheetVehicle",
        params: {
          programId: programId,
          vehicleId: rows.id,
        },
      });
      this.fetchCurrentProject(programId);
    },
    handleExpandChange(row, expandedRows) {
      this.projId = row.contract_vehicle.id;
      const lastId = this.expandRowKeys[0];
      // disable mutiple row expanded
      this.expandRowKeys = this.projId === lastId ? [] : [this.projId];
    },
    removeVehicleBtn(index, rows) {
      console.log(rows);
      console.log(this.$route);
      // let id = [rows.id];
      let vehicle = {
        g: {
          id: rows.id,
          pId: this.$route.params.programId,
        },
      };

      this.$confirm(
        `Are you sure you want to remove ${rows.contract_vehicle.name} from your program?`,
        "Confirm Remove",
        {
          confirmButtonText: "Remove",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
      ).then(() => {
        this.removeVehicle({ ...vehicle });
      });
    },
    // DO NOT DELETE This async method.  It is code for firebase cloud functionality
    //  async onSubmit ()  {
    //      const formData = {
    //         contractName: this.contractNameText,
    //         programName: this.currentProject.name,
    //         mpathInstance: this.$mpath_instance

    //       }
    //     await createUser({...formData})
    //     return { formData }

    saveEdits(index, rows) {
      let id = rows.id;
      let vehicleData = {
        vehicle: {
          facility_group_id: rows.facility_group_id,
          programId: this.$route.params.programId,
        },
      };
      // this.setNewContractGroupFilter(rows.facility_group_id);
      this.updateVehicle({
        ...vehicleData,
        id,
      });
      // console.log(groupId)
      this.rowIndex = null;
      this.rowId = null;
    },
    cancelEdits(index, rows) {
      this.rowIndex = null;
      this.rowId = null;
    },
    editMode(index, rows) {
      console.log(rows);
      this.newGroup = null;
      this.rowIndex = index;
      this.rowId = rows.contract_vehicle.id;
    },
    deleteSelectedVehicle(index, rows) {
      let id = rows.contract_vehicles.id;
      this.$confirm(
        `Are you sure you want to delete ${rows.contract_vehicles.name}?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
      ).then(() => {
        this.deleteVehicle(id).then((value) => {
          if (value === 200) {
            this.fetchVehicles();
            MessageDialogService.showDialog({
              message: `${rows.contract_vehicles.name} was deleted successfully.`,
              
              
            });
          }
        });
      });
    },
    closeAddContractBtn() {
      this.dialogVisible = false;
      this.hideSaveBtn = false;
    },
    addVehicle() {
      this.vehicleDialogVisible = true;
      this.fetchContractVehicles(this.$route.params.programId);
    },
    /* openUserPrivileges(index, rows) {
      this.openUserPrivilegesDialog = true;
      this.vehicleData = rows;
    }, */
  },
  computed: {
    ...mapGetters([
      "getContractGroupTypes",
      "getNewContractGroupFilter",
      "contracts",
      "groups",
      "getRoles",
      "addUserToRoleStatus",
      "getContractRoleUsers",
      "getContractRoleNames",
      "getBulkContractRoleNames",
      "getTransferData",
      "getContractTable",
      "getProjectGroupFilter",
      "getGroupFilter",
      "getNewGroups",
      "facilityGroups",
      "removeVehicleRoleStatus",
      "currentProject",
      "getAssignedContractUsers",
      "contractProjects",
      "associatedVehiclesStatus",
      "contractVehiclesLoaded",
      "vehicleStatus",
      "getRolesLoaded",
      "contentLoaded",
      "vehiclesLoaded",

      // Vehicles
      "contractVehicles",
      "contractVehiclesLoaded",
      "vehicles",
      //"contractVehiclesProjects",
      //"contractVehiclesProjectsLoaded",
    ]),
    backToSettings() {
      return `/programs/${this.$route.params.programId}/settings`;
    },
    tableData() {
      //Need to add filter for associated contracts only
      if (this.vehicles && this.vehicles.length > 0) {
        let con = this.vehicles.filter(
          (t) => t && t !== "null" && !t.contract_vehicle.is_subprime && t.contract_vehicle !== 'null'
        );

        return con.filter((td) => {
          if (
            this.C_projectGroupFilter &&
            this.C_projectGroupFilter.length > 0
          ) {
            let group = this.C_projectGroupFilter.map((t) => t.name);
            return group.includes(td.facility_group.name);
          } else return true;
        });
      } else return [];
    },
    subTableData() {
      //Need to add filter for associated contracts only
      if (this.vehicles && this.vehicles.length > 0) {
        let con = this.vehicles.filter(
          (t) => t && t !== "null" && t.contract_vehicle.is_subprime && t.contract_vehicle !== 'null'
        );
        return con.filter((td) => {
          if (
            this.C_projectGroupFilter &&
            this.C_projectGroupFilter.length > 0
          ) {
            let group = this.C_projectGroupFilter.map((t) => t.name);
            return group.includes(td.facility_group.name);
          } else return true;
        });
      } else return [];
    },
    allVehicles() {
      //console.log(this.tableData)
      if (
        (this.tableData && this.tableData == []) ||
        this.tableData.length == 0
      ) {
        if (this.contractVehicles && this.contractVehicles.length > 0) {
          console.log(this.contractVehicles.filter((t) => t && !t.is_subprime));
          return this.contractVehicles.filter((t) => t && !t.is_subprime && t !== 'null');
        }
      } else if (
        this.contractVehicles &&
        this.contractVehicles.length > 0 &&
        this.tableData &&
        this.tableData.length > 0
      ) {
        let associatedContractVehiclesIds = this.tableData.map(
          (t) => t.contract_vehicle.id
        );
        let primeVehicles = this.contractVehicles.filter(
          (t) => t && !t.is_subprime
        );
        let data = primeVehicles
          .filter((t) => {
            if (this.searchContractVehiclesData !== "" && t) {
              return (
                t.name
                  .toLowerCase()
                  .match(this.searchContractVehiclesData.toLowerCase()) ||
                t.full_name
                  .toLowerCase()
                  .match(this.searchContractVehiclesData.toLowerCase()) ||
                t.contract_sub_category.name
                  .toLowerCase()
                  .match(this.searchContractVehiclesData.toLowerCase()) ||
                t.contract_vehicle_type.name
                  .toLowerCase()
                  .match(this.searchContractVehiclesData.toLowerCase()) ||
                t.contract_agency.name
                  .toLowerCase()
                  .match(this.searchContractVehiclesData.toLowerCase())
              );
            } else return true;
          })
          .filter((t) => {
            console.log("t:", t);
            return !associatedContractVehiclesIds.includes(t.id);
          });
        return data;
      }
    },
    allSubVehicles() {
      //console.log(this.tableData)
      if (
        (this.subTableData && this.subTableData == []) ||
        this.subTableData.length == 0
      ) {
        if (this.contractVehicles && this.contractVehicles.length > 0) {
          return this.contractVehicles.filter((t) => t && t.is_subprime && t !== 'null');
        }
      } else if (
        this.contractVehicles &&
        this.contractVehicles.length > 0 &&
        this.subTableData &&
        this.subTableData.length > 0
      ) {
        let associatedContractVehiclesIds = this.subTableData.map(
          (t) => t.contract_vehicle.id
        );
        let subprimeVehicles = this.contractVehicles.filter(
          (t) => t && t.is_subprime
        );
        let data = subprimeVehicles
          .filter((t) => {
            if (this.searchContractVehiclesData !== "" && t) {
              return (
                t.name
                  .toLowerCase()
                  .match(this.searchContractVehiclesData.toLowerCase()) ||
                t.full_name
                  .toLowerCase()
                  .match(this.searchContractVehiclesData.toLowerCase()) ||
                t.contract_name
                  .toLowerCase()
                  .match(this.searchContractVehiclesData.toLowerCase()) ||
                t.subprime_name
                  .toLowerCase()
                  .match(this.searchContractVehiclesData.toLowerCase()) ||
                t.contract_vehicle_type.name
                  .toLowerCase()
                  .match(this.searchContractVehiclesData.toLowerCase()) ||
                t.contract_agency.name
                  .toLowerCase()
                  .match(this.searchContractVehiclesData.toLowerCase())
              );
            } else return true;
          })
          .filter((t) => {
            console.log("t:", t);
            return !associatedContractVehiclesIds.includes(t.id);
          });
        return data;
      }
    },
    contractUsers() {
      if (this.getRoles && this.getRoles.length > 0) {
        let roleUsers = this.getRoles
          .map((t) => t.role_users)
          .filter((t) => t.length > 0);
        if (this.projId) {
          let groupByRoles = [].concat
            .apply([], roleUsers)
            .filter((t) => this.projId == t.project_contract_vehicle_id);
          return {
            data: groupByRoles,
            roleIds: _.uniq(groupByRoles.map((t) => t.role_id)),
          };
        } else return [].concat.apply([], roleUsers);
      }
    },
    assignedUsers() {
      //   //  Commenting out this setter which is executed in the handleExpandChange() method.  Useful if we want saved users to populate dropdown upon loading
      if (
        this.programUsers &&
        this.contractUsers &&
        this.contractUsers.data &&
        this.contractUsers.data.length > 0
      ) {
        let tableUserIds = this.userids.map((t) => t.user_id);
        return this.programUsers.filter((t) => tableUserIds.includes(t.id));
      }
    },
    assignedContractUsers: {
      get() {
        return this.getAssignedContractUsers;
      },
      set(value) {
        this.SET_ASSIGNED_CONTRACT_USERS(value);
        console.log(value);
      },
    },
    groupList() {
      if (
        this.groups &&
        this.groups.length > 0 &&
        this.facilityGroups &&
        this.facilityGroups.length > 0
      ) {
        let programGroupIds = this.facilityGroups.map((t) => t.id);
        return this.groups.filter((u) => programGroupIds.includes(u.id));
      } else return [];
    },
    C_typeFilter: {
      get() {
        return this.getContractGroupTypes;
      },
      set(value) {
        this.SET_CONTRACT_GROUP_TYPES(value);
      },
    },
    // Filter when adding new Project
    C_projectGroupFilter: {
      get() {
        return this.getGroupFilter;
      },
      set(value) {
        // console.log(value)
        this.setGroupFilter(value);
      },
    },
    programUsers() {
      if (this.currentProject) {
        if (this.currentProject.users && this.currentProject.users.length > 0) {
          return this.currentProject.users.filter((t) => t);
        } else return [];
      }
    },
    viableVehicleUsers() {
      if (this.programUsers && this.contractUsers && this.contractUsers.data) {
        let assignedUserIds = this.contractUsers.data.map((t) => t.user_id);
        return this.programUsers.filter((t) => !assignedUserIds.includes(t.id));
      }
    },
    contractRoleUsers: {
      get() {
        return this.getContractRoleUsers;
      },
      set(value) {
        this.SET_CONTRACT_ROLE_USERS(value);
      },
    },
    contractRoleNames: {
      get() {
        return this.getContractRoleNames;
      },
      set(value) {
        this.SET_CONTRACT_ROLE_NAMES(value);
      },
    },
    bulkChangeContractRoleNames: {
      get() {
        return this.getBulkContractRoleNames;
      },
      set(value) {
        this.SET_BULK_CONTRACT_ROLE_NAMES(value);
      },
    },
    C_newContractGroupFilter: {
      get() {
        return this.getNewContractGroupFilter;
      },
      set(value) {
        // console.log(value)
        this.setNewContractGroupFilter(value);
      },
    },
  },
  watch: {
    vehicleStatus: {
      handler() {
        if (this.vehicleStatus == 200) {
          MessageDialogService.showDialog({
            message: `Vehicle saved successfully.`,
            
            
          });
          this.newGroup = null;
          this.SET_VEHICLE_STATUS(0);
          this.fetchVehicles(this.$route.params.programId);
          this.fetchCurrentProject(this.$route.params.programId);
        }
      },
    },
    vehiclesStatus: {
      handler() {
        if (this.vehiclesStatus == 200) {
          MessageDialogService.showDialog({
            message: `Successfully removed vehicle from program.`,
            
            
          });
          this.SET_VEHICLES_STATUS(0);
          this.fetchVehicles(this.$route.params.programId);
          this.fetchContractVehicles(this.$route.params.programId);
          this.fetchCurrentProject(this.$route.params.programId);
        }
      },
    },
    associatedVehiclesStatus: {
      handler() {
        if (this.associatedVehiclesStatus == 200) {
          MessageDialogService.showDialog({
            message: `Vehicle successfully added to program.`,
            
            
          });
          this.SET_ASSOCIATED_VEHICLES_STATUS(0);
          this.fetchContractVehicles(this.$route.params.programId);
          this.fetchVehicles(this.$route.params.programId);
          this.fetchCurrentProject(this.$route.params.programId);
        }
      },
    },
    removeVehicleRoleStatus: {
      handler() {
        if (
          this.removeVehicleRoleStatus == 204 ||
          this.removeVehicleRoleStatus == 200
        ) {
          MessageDialogService.showDialog({
            message: `Succesfully removed user(s) from role.`,
            
            
          });
          this.fetchRoles(this.$route.params.programId);
          this.SET_REMOVE_VEHICLE_ROLE_STATUS(0);
          this.isEditingRoles = false;
          this.rowIndex_1 = null;
          this.changeRoleMode = false;
          this.fetchCurrentProject(this.$route.params.programId);
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
            message: `Succesfully added user/role to project.`,
            
            
          });
          this.SET_ADD_USER_TO_ROLE_STATUS(0);
          this.fetchCurrentProject(this.$route.params.programId);
          this.fetchRoles(this.$route.params.programId);
          this.SET_CONTRACT_ROLE_NAMES([]);
          this.SET_BULK_CONTRACT_ROLE_NAMES([]);
          this.SET_CONTRACT_ROLE_USERS([]);
          this.rowIndex_1 = null;
          this.roleRowId = null;
          this.changeRoleMode = false;
        }
      },
    },
  },
};
</script>

<style scoped lang="scss">
.addVehicleModal {
  min-height: 300px;
}

::v-deep.el-popper {
  .select-popper {
    display: none;
  }
}

.userNames {
  // background-color: #F8F9FA;
  border-radius: 0.25rem;
  margin-right: 2px;
  padding: 1px 3px;
  border: solid lightgray 0.75px;
}

.buttonWrapper {
  border-bottom: lightgray solid 1px;
}

.modalBtns {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}

::v-deep.el-collapse-item__header {
  padding-left: 1.5rem;
}

.right {
  text-align: right;
}

::v-deep.el-table__header,
.el-table {
  width: auto !important;
}

.fa-calendar {
  font-size: x-large;
}

::v-deep.el-table th.el-table__cell > .cell {
  color: #212529;
  font-size: 1rem;
  word-break: break-word;
}

.contractUsers {
  ::v-deep.el-dialog {
    width: 60% !important;

    ::v-deep.el-dialog__body {
      padding-top: 0;
    }
  }
}

// ::v-deep.el-dialog.contractUsers{
//  width: 60% !important;
//   }
// .contractUsers{
//  ::v-deep.el-dialog__body {
//    padding-top: 0;
//  }
// }
.tabs {
  background-color: #ededed;
  border-top: solid 0.3px #ededed;
  width: min-content;
  display: flex;
  box-shadow: 0 2.5px 2.5px rgba(0, 0, 0, 0.19), 0 3px 3px rgba(0, 0, 0, 0.23);

  .tab {
    cursor: pointer;
    padding: 7px 10px;
    border-radius: 0.1rem;
    font-weight: 500;
    letter-spacing: 1;
    transition: auto;
    font-size: 75%;
  }

  .active {
    color: #fff !important;
    background-color: #383838 !important;
  }
}

a {
  color: unset;
  text-decoration: unset;
}

.right-panel {
  height: calc(100vh - 100px);
  overflow-y: auto;
}

::v-deep.el-input__inner {
  font-weight: 300 !important;
}

::v-deep.el-table__row .el-input .el-input__inner {
  border-style: none;
  font-size: 16px !important;
}

::v-deep.hover-row .el-input .el-input__inner {
  border-style: solid;
}

::v-deep.el-dialog.addVehicle {
  width: 60%;
}

.addVehicle {
  ::v-deep.el-dialog__body {
    padding-top: 0 !important;
  }
}

::v-deep.el-dialog__close.el-icon.el-icon-close {
  display: none;
}

::v-deep.el-table {
  .el-input__inner {
    font-size: 16px !important;
  }
}

::v-deep.el-dialog__close.el-icon.el-icon-close {
  background-color: #dc3545;
  border-radius: 50%;
  color: white;
  padding: 2px;
  font-size: 0.7rem;
}

.addUserRole {
  ::v-deep.el-dialog__body {
    padding-top: 0 !important;
  }

  ::v-deep.el-dialog {
    width: 55%;
  }
}
</style>
