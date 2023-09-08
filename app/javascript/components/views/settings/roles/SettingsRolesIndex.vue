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
            <i class="fal fa-user-lock mr-1 bootstrap-purple-text"></i> Roles
            <span
              v-if="getRoles && getRoles.length > 0"
              class="ml-2 pb-1 badge badge-secondary badge-pill pill"
            >
              <!-- -3 value to account for crud roles at index 0 that are not in use -->
              {{ getRoles.length }}
            </span>
          </h4>
        </el-breadcrumb>
        <div class="my-1 pb-2 buttonWrapper container-fluid">
          <div class="row px-0">
            <!-- <div
              class="col-6"
              :class="{ 'd-none': !_isallowed('write') }"
            >               
              <el-button
                @click.prevent="addRole"
                :disabled="isEditting"
                class="bg-primary text-light mb-2"
              >
               <i class="far fa-plus-circle mr-1"></i>Create Role
              </el-button>
            </div> -->
          </div>
        </div>

        <div class="container-fluid mt-2 mx-0">
          <div
            v-loading="!getRolesLoaded"
            v-if="_isallowed('read')"
            element-loading-text="Fetching your data. Please wait..."
            element-loading-spinner="el-icon-loading"
            element-loading-background="rgba(0, 0, 0, 0.8)"
            class=""
          >
            <el-tabs
              class="mt-1 mr-3"
              type="border-card"
              @tab-click="handleClick"
            >
              <el-tab-pane class="px-3" style="postion:relative">
                <template slot="label" class="text-right" v-if="true">
                  ADMIN
                  <span class="badge badge-secondary badge-pill">
                    <span v-if="tableData">{{ tableData.length }}</span>
                  </span>
                </template>
                <div class="" :class="{ 'd-none': !_isallowed('write') }">
                  <el-button
                    @click.prevent="addRole"
                    :disabled="isEditting"
                    class="bg-primary text-light mb-3"
                  >
                    <i class="far fa-plus-circle mr-1"></i>Create Role
                  </el-button>
                </div>
                <el-table
                  v-if="tableData && tableData.length > 0"
                  :data="tableData"
                  height="450"
                  class="crudRow"
                >
                  <el-table-column
                    fixed
                    prop="name"
                    label="Admin Role"
                    width="340"
                  >
                    <template slot-scope="scope">
                      <span
                        v-if="
                          (scope.$index == currentRow && isEditting) ||
                            (scope.$index == 0 &&
                              isEditting &&
                              scope.row.newRow)
                        "
                      >
                        <el-input
                          size="small"
                          placeholder="Enter Role Name"
                          style="font-style: italic; color: red"
                          v-model="scope.row.name"
                          controls-position="right"
                        >
                        </el-input>
                      </span>
                      <span v-else>
                        <span
                          v-show="
                            scope.row.name == 'program-admin-not-users' ||
                              scope.row.name == 'program-admin' ||
                              scope.row.name == 'program-admin-not-contract'
                          "
                          style="color: #dc3545; font-size: 15px"
                          >*
                        </span>
                        {{ scope.row.name }}
                      </span>
                    </template>
                  </el-table-column>
                  <el-table-column label="Groups">
                    <el-table-column prop="groupsRead" label="Read" width="85">
                      <template slot-scope="scope">
                        <span
                          v-if="
                            currentRow !== scope.$index && !scope.row.newRow
                          "
                        >
                          <span
                            v-if="
                              scope.row.role_privileges
                                .map(
                                  (t) =>
                                    t.privilege.includes('R') && t.role_type
                                )
                                .includes('program_setting_groups')
                            "
                          >
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>

                        <span
                          v-if="
                            (isEditting && currentRow == scope.$index) ||
                              (scope.$index == 0 &&
                                isEditting &&
                                scope.row.newRow)
                          "
                          @click.prevent.stop="
                            groupsRead(scope.$index, scope.row)
                          "
                        >
                          <span v-if="isGroupsRead">
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                      </template>
                    </el-table-column>

                    <el-table-column
                      prop="groupsWrite"
                      label="Write"
                      width="85"
                    >
                      <template slot-scope="scope">
                        <!-- <span
              @click.prevent.stop="groupsWrite(scope.$index, scope.row)"
              v-if="scope.$index == 0 && isEditting && scope.row.newRow"
              >
                <span v-if="isGroupsWrite">
                <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
                </span>
                  <span v-if="!isGroupsWrite">
                <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
                </span>
              </span> -->
                        <span
                          v-if="
                            currentRow !== scope.$index && !scope.row.newRow
                          "
                        >
                          <span
                            v-if="
                              scope.row.role_privileges
                                .map(
                                  (t) =>
                                    t.privilege.includes('W') && t.role_type
                                )
                                .includes('program_setting_groups')
                            "
                          >
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>

                        <span
                          v-if="
                            (isEditting && currentRow == scope.$index) ||
                              (scope.$index == 0 &&
                                isEditting &&
                                scope.row.newRow)
                          "
                          @click.prevent.stop="
                            groupsWrite(scope.$index, scope.row)
                          "
                        >
                          <span v-if="isGroupsWrite">
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                      </template>
                    </el-table-column>

                    <el-table-column
                      prop="groupsDelete"
                      label="Delete"
                      width="85"
                    >
                      <template slot-scope="scope">
                        <!-- <span
              @click.prevent.stop="groupsDelete(scope.$index, scope.row)"
                 v-if="scope.$index == 0 && isEditting && scope.row.newRow"
              >
                <span v-if="isGroupsDelete">
                <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
                </span>
                  <span v-if="!isGroupsDelete">
                <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
                </span>
              </span> -->
                        <span
                          v-if="
                            currentRow !== scope.$index && !scope.row.newRow
                          "
                        >
                          <span
                            v-if="
                              scope.row.role_privileges
                                .map(
                                  (t) =>
                                    t.privilege.includes('D') && t.role_type
                                )
                                .includes('program_setting_groups')
                            "
                          >
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                        <span
                          v-if="
                            (isEditting && currentRow == scope.$index) ||
                              (scope.$index == 0 &&
                                isEditting &&
                                scope.row.newRow)
                          "
                          @click.prevent.stop="
                            groupsDelete(scope.$index, scope.row)
                          "
                        >
                          <span v-if="isGroupsDelete">
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                      </template>
                    </el-table-column>
                  </el-table-column>
                  <el-table-column label="Projects">
                    <el-table-column
                      prop="projectsRead"
                      label="Read"
                      width="85"
                    >
                      <template slot-scope="scope">
                        <!-- <span
          @click.prevent.stop="projectsRead(scope.$index, scope.row)"
             v-if="scope.$index == 0 && isEditting && scope.row.newRow"
          >
            <span v-if="isProjectsRead">
            <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
            </span>
              <span v-if="!isProjectsRead">
            <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
            </span>
          </span> -->
                        <span
                          v-if="
                            currentRow !== scope.$index && !scope.row.newRow
                          "
                        >
                          <span
                            v-if="
                              scope.row.role_privileges
                                .map(
                                  (t) =>
                                    t.privilege.includes('R') && t.role_type
                                )
                                .includes('program_setting_projects')
                            "
                          >
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                        <span
                          v-if="
                            (isEditting && currentRow == scope.$index) ||
                              (scope.$index == 0 &&
                                isEditting &&
                                scope.row.newRow)
                          "
                          @click.prevent.stop="
                            projectsRead(scope.$index, scope.row)
                          "
                        >
                          <span v-if="isProjectsRead">
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                      </template>
                    </el-table-column>
                    <el-table-column
                      prop="projectsWrite"
                      label="Write"
                      width="85"
                    >
                      <template slot-scope="scope">
                        <!-- <span
          @click.prevent.stop="projectsWrite(scope.$index, scope.row)"
            v-if="scope.$index == 0 && isEditting && scope.row.newRow"
          >
            <span v-if="isProjectsWrite">
            <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
            </span>
              <span v-if="!isProjectsWrite">
            <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
            </span>
          </span> -->
                        <span
                          v-if="
                            currentRow !== scope.$index && !scope.row.newRow
                          "
                        >
                          <span
                            v-if="
                              scope.row.role_privileges
                                .map(
                                  (t) =>
                                    t.privilege.includes('W') && t.role_type
                                )
                                .includes('program_setting_projects')
                            "
                          >
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                        <span
                          v-if="
                            (isEditting && currentRow == scope.$index) ||
                              (scope.$index == 0 &&
                                isEditting &&
                                scope.row.newRow)
                          "
                          @click.prevent.stop="
                            projectsWrite(scope.$index, scope.row)
                          "
                        >
                          <span v-if="isProjectsWrite">
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                      </template>
                    </el-table-column>
                    <el-table-column
                      prop="projectsDelete"
                      label="Delete"
                      width="85"
                    >
                      <template slot-scope="scope">
                        <!-- <span
          @click.prevent.stop="projectsDelete(scope.$index, scope.row)"
             v-if="scope.$index == 0 && isEditting && scope.row.newRow"
          >
          <span v-if="isProjectsDelete">
          <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
          </span>
            <span v-if="!isProjectsDelete">
          <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
          </span>
          </span> -->
                        <span
                          v-if="
                            currentRow !== scope.$index && !scope.row.newRow
                          "
                        >
                          <span
                            v-if="
                              scope.row.role_privileges
                                .map(
                                  (t) =>
                                    t.privilege.includes('D') && t.role_type
                                )
                                .includes('program_setting_projects')
                            "
                          >
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                        <span
                          v-if="
                            (isEditting && currentRow == scope.$index) ||
                              (scope.$index == 0 &&
                                isEditting &&
                                scope.row.newRow)
                          "
                          @click.prevent.stop="
                            projectsDelete(scope.$index, scope.row)
                          "
                        >
                          <span v-if="isProjectsDelete">
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                      </template>
                    </el-table-column>
                  </el-table-column>
                  <el-table-column label="Contracts/Vehicles">
                    <el-table-column
                      prop="contractsRead"
                      label="Read"
                      width="85"
                    >
                      <template slot-scope="scope">
                        <!-- <span @click.prevent.stop="contractsRead(scope.$index, scope.row)"   
            v-if="scope.$index == 0 && isEditting && scope.row.newRow"
            >
              <span v-if="isContractsRead">
              <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
              </span>
                <span v-if="!isContractsRead">
              <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
              </span>
            </span> -->

                        <span
                          v-if="
                            currentRow !== scope.$index && !scope.row.newRow
                          "
                        >
                          <span
                            v-if="
                              scope.row.role_privileges
                                .map(
                                  (t) =>
                                    t.privilege.includes('R') && t.role_type
                                )
                                .includes('program_setting_contracts')
                            "
                          >
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>

                        <span
                          v-if="
                            (isEditting && currentRow == scope.$index) ||
                              (scope.$index == 0 &&
                                isEditting &&
                                scope.row.newRow)
                          "
                          @click.prevent.stop="
                            contractsRead(scope.$index, scope.row)
                          "
                        >
                          <span v-if="isContractsRead">
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                      </template>
                    </el-table-column>
                    <el-table-column
                      prop="contractsWrite"
                      label="Write"
                      width="85"
                    >
                      <template slot-scope="scope">
                        <!-- <span
              @click.prevent.stop="contractsWrite(scope.$index, scope.row)"
                 v-if="scope.$index == 0 && isEditting && scope.row.newRow"
              >
              <span v-if="isContractsWrite">
              <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
              </span>
                <span v-if="!isContractsWrite">
              <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
              </span>
            </span> -->

                        <span
                          v-if="
                            currentRow !== scope.$index && !scope.row.newRow
                          "
                        >
                          <span
                            v-if="
                              scope.row.role_privileges
                                .map(
                                  (t) =>
                                    t.privilege.includes('W') && t.role_type
                                )
                                .includes('program_setting_contracts')
                            "
                          >
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                        <span
                          v-if="
                            (isEditting && currentRow == scope.$index) ||
                              (scope.$index == 0 &&
                                isEditting &&
                                scope.row.newRow)
                          "
                          @click.prevent.stop="
                            contractsWrite(scope.$index, scope.row)
                          "
                        >
                          <span v-if="isContractsWrite">
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                      </template>
                    </el-table-column>
                    <el-table-column
                      prop="contractsDelete"
                      label="Delete"
                      width="85"
                    >
                      <template slot-scope="scope">
                        <!-- <span @click.prevent.stop="contractsDelete(scope.$index, scope.row)"
            v-if="scope.$index == 0 && isEditting && scope.row.newRow">
              <span v-if="isContractsDelete">
              <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
              </span>
            <span v-if="!isContractsDelete">
              <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
              </span>
          </span> -->
                        <span
                          v-if="
                            currentRow !== scope.$index && !scope.row.newRow
                          "
                        >
                          <span
                            v-if="
                              scope.row.role_privileges
                                .map(
                                  (t) =>
                                    t.privilege.includes('D') && t.role_type
                                )
                                .includes('program_setting_contracts')
                            "
                          >
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                        <span
                          v-if="
                            (isEditting && currentRow == scope.$index) ||
                              (scope.$index == 0 &&
                                isEditting &&
                                scope.row.newRow)
                          "
                          @click.prevent.stop="
                            contractsDelete(scope.$index, scope.row)
                          "
                        >
                          <span v-if="isContractsDelete">
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                      </template>
                    </el-table-column>
                  </el-table-column>
                  <el-table-column label="Users/Roles">
                    <el-table-column prop="usersRead" label="Read" width="85">
                      <template slot-scope="scope">
                        <!-- <span
            @click.prevent.stop="usersRead(scope.$index, scope.row)"
              v-if="scope.$index == 0 && isEditting && scope.row.newRow"
            >
            <span v-if="isUsersRead">
            <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
            </span>
              <span v-if="!isUsersRead">
            <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
            </span>
            </span> -->

                        <span
                          v-if="
                            currentRow !== scope.$index && !scope.row.newRow
                          "
                        >
                          <span
                            v-if="
                              scope.row.role_privileges
                                .map(
                                  (t) =>
                                    t.privilege.includes('R') && t.role_type
                                )
                                .includes('program_setting_users_roles')
                            "
                          >
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                        <span
                          v-if="
                            (isEditting && currentRow == scope.$index) ||
                              (scope.$index == 0 &&
                                isEditting &&
                                scope.row.newRow)
                          "
                          @click.prevent.stop="
                            usersRead(scope.$index, scope.row)
                          "
                        >
                          <span v-if="isUsersRead">
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                      </template>
                    </el-table-column>
                    <el-table-column prop="usersWrite" label="Write" width="85">
                      <template slot-scope="scope">
                        <!-- <span
            @click.prevent.stop="usersWrite(scope.$index, scope.row)"
            v-if="scope.$index == 0 && isEditting && scope.row.newRow"
            >
            <span v-if="isUsersWrite">
            <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
            </span>
              <span v-if="!isUsersWrite">
            <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
            </span>
          </span> -->

                        <span
                          v-if="
                            currentRow !== scope.$index && !scope.row.newRow
                          "
                        >
                          <span
                            v-if="
                              scope.row.role_privileges
                                .map(
                                  (t) =>
                                    t.privilege.includes('W') && t.role_type
                                )
                                .includes('program_setting_users_roles')
                            "
                          >
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                        <span
                          v-if="
                            (isEditting && currentRow == scope.$index) ||
                              (scope.$index == 0 &&
                                isEditting &&
                                scope.row.newRow)
                          "
                          @click.prevent.stop="
                            usersWrite(scope.$index, scope.row)
                          "
                        >
                          <span v-if="isUsersWrite">
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                      </template>
                    </el-table-column>
                    <el-table-column
                      prop="usersDelete"
                      label="Delete"
                      width="85"
                    >
                      <template slot-scope="scope">
                        <!-- <span
            @click.prevent.stop="usersDelete(scope.$index, scope.row)"
              v-if="scope.$index == 0 && isEditting && scope.row.newRow"
            >
            
            <span v-if="isUsersDelete">
            <i class="el-icon-success text-success" style="font-size: 1.35rem"></i>     
            </span>
              <span v-if="!isUsersDelete">
            <i class="el-icon-error text-secondary" style="font-size: 1.35rem"></i>      
            </span>
          </span> -->

                        <span
                          v-if="
                            currentRow !== scope.$index && !scope.row.newRow
                          "
                        >
                          <span
                            v-if="
                              scope.row.role_privileges
                                .map(
                                  (t) =>
                                    t.privilege.includes('D') && t.role_type
                                )
                                .includes('program_setting_users_roles')
                            "
                          >
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                        <span
                          v-if="
                            (isEditting && currentRow == scope.$index) ||
                              (scope.$index == 0 &&
                                isEditting &&
                                scope.row.newRow)
                          "
                          @click.prevent.stop="
                            usersDelete(scope.$index, scope.row)
                          "
                        >
                          <span v-if="isUsersDelete">
                            <i
                              class="el-icon-success text-success"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                          <span v-else>
                            <i
                              class="el-icon-error text-secondary"
                              style="font-size: 1.35rem"
                            ></i>
                          </span>
                        </span>
                      </template>
                    </el-table-column>
                  </el-table-column>
                  <el-table-column                               
                    label="Actions"
                    fixed="right"
                    width="125"
                    class="text-center"
                  >
                 <template slot-scope="scope">
                     
                      <el-button
                        type="default"
                        size="small"
                        v-tooltip="`Manage Admin Role User(s)`"
                        v-if="!isEditting"
                        @click.prevent="addUserRole(scope.$index, scope.row)"
                        class="bg-primary text-light btn-sm px-2"
                      >
                        <i class="fas fa-users-medical mr-1"></i>
                      </el-button>
                      <el-button
                        type="default"
                        size="small"
                        v-tooltip="`Save role`"
                        v-if="
                          (isEditting && currentRow == scope.$index) ||
                            (scope.$index == 0 &&
                              isEditting &&
                              scope.row.newRow &&
                              scope.row.name)
                        "
                        @click.prevent="saveNewRole(scope.$index, scope.row)"
                        class="bg-primary btn-sm text-light"
                      >
                        <i class="far fa-save"></i>
                      </el-button>
                      <el-button
                        size="small"
                        type="default"
                        @click.prevent="editRole(scope.$index, scope.row)"
                        v-if="
                          !isEditting &&
                            scope.row.name !== 'program-admin-not-users' &&
                            scope.row.name !== 'program-admin' &&
                            scope.row.name !== 'program-admin-not-contract' &&
                            _isallowed('write')
                        "
                        class="bg-light btn-sm px-2 ml-1"
                        v-tooltip="`Edit Role`"
                      >
                        <i class="fal fa-edit text-primary"></i>
                      </el-button>

                      <el-button
                        type="default"
                        size="small"
                        @click.prevent="cancelEditRole(scope.$index, scope.row)"
                        v-if="isEditting && currentRow == scope.$index"
                        class="bg-secondary btn-sm text-light ml-1"
                        v-tooltip="`Cancel Edit`"
                      >
                        <i class="fas fa-ban"></i>
                      </el-button>
                      <el-button
                        type="default"
                        size="small"
                        @click.prevent="
                          cancelCreateRole(scope.$index, scope.row)
                        "
                        v-if="
                          scope.$index == 0 && isEditting && scope.row.newRow
                        "
                        class="bg-light btn-sm"
                        v-tooltip="`Cancel Create`"
                      >
                      <i class="fas fa-ban"></i>
                      </el-button>
                    </template>
                    </el-table-column>  
                 </el-table>
              </el-tab-pane>
              <el-tab-pane class="px-3" style="postion:relative">
                <template slot="label" class="text-right" v-if="true">
                  PROJECTS
                  <span class="badge badge-secondary badge-pill">
                    <span v-if="tableCounts && tableCounts.n">{{
                      tableCounts.n.projects
                    }}</span>
                  </span>
                </template>
                <SettingsRolesProjects />
              </el-tab-pane>
              <el-tab-pane class="px-3" style="postion:relative">
                <template slot="label" class="text-right" v-if="true">
                  CONTRACTS/VEHICLES
                  <span class="badge badge-secondary badge-pill">
                    <span v-if="tableCounts && tableCounts.n">{{
                      tableCounts.n.contracts
                    }}</span>
                  </span>
                </template>
                <SettingsRolesContracts />
              </el-tab-pane>
              <h6
                class="mt-2 mb-0 text-right"
                style="color: gray; font-size: 13px"
              >
                <span style="color: #dc3545; font-size: 15px">*</span> Default
                roles cannot be edited.
              </h6>
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

          <el-dialog
            :visible.sync="rolesVisible"
            append-to-body
            center
            class="contractForm p-0 addUserRole user-role-modal"
          >
            <span slot="title" class="text-left add-groups-header ">
              <h5 style="color:#383838" v-if="roleRowData">
                <i class="fal fa-user-lock mr-2 mb-2 bootstrap-purple-text"></i
                >{{ roleRowData.name }}
              </h5>
            </span>
            <div class="container-fluid p-0">
              <div class="mt-0 row"  v-if="viableAdminUsers && viableAdminUsers.length > 0 && _isallowed('write')">
                <div class="col-9 py-0">
                  <label class="font-md mb-0 d-flex"
                    >Add User(s) to this Role
                  </label>
                  <el-select
                    v-model="adminRoleUsers"
                    filterable
                    class="w-100"
                    clearable
                    multiple
                    track-by="id"
                    value-key="id"
                    placeholder="Search and select Users for this Role"
                  >
                    <el-option
                      v-for="item in viableAdminUsers"
                      :value="item"
                      :key="item.id"
                      :label="item.full_name || item.name"
                    >
                    </el-option>
                  </el-select>
                </div>

                <div class="col-3 text-right pt-0">
                  <label class="font-md mb-0 d-flex" style="visibility:hidden"
                    >|</label
                  >
                  <el-button
                    type="default"
                    @click="saveProjectUserRole()"
                    v-if="adminRoleUsers && adminRoleUsers.length > 0"
                    v-tooltip="`Save`"
                    class="bg-primary btn-sm text-light"
                  >
                    <i class="far fa-save"></i>
                  </el-button>
                </div>
              </div>
               <div class="pl-3 mt-0 row" v-if="getRolesLoaded && contentLoaded && viableAdminUsers && viableAdminUsers.length <= 0">
                There are currently no program users to assign to this role.  You can either add new program users from portfolio or remove desired user from current role.
            </div>

              <!-- <div class="mt-0 row">
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
             </div> -->
              <div class="mt-4 row">
                <div class="col-12 pt-0">
                  <span class="text-danger"
                    ><em
                      >Note: Users may only be assigned one Admin role per
                      program.</em
                    >
                  </span>
                  <el-table
                    v-loading="!getRolesLoaded"
                    element-loading-spinner="el-icon-loading"
                    v-if="adminUsers && adminUsers.length > 0"
                    :header-cell-style="{ background: '#EDEDED' }"
                    :data="adminUsers"
                    height="300"
                    width="auto"
                    class=""
                  >
                    <el-table-column
                      prop="user_full_name"
                      sortable
                      filterable
                      label="Users"
                    >
                      <template slot-scope="scope">
                        <!-- <span>
                {{ scope.row  }}  -->
                        <span
                          v-if="
                            scope.row && roleId && roleId == scope.row.role_id
                          "
                        >
                          {{ scope.row.user_full_name }}
                          <!-- {{ JSON.stringify(scope.row.user_full_name).replace(/]|[['"]/g, ' ') }} -->
                          <!-- {{ scope.row.role_id}} -->
                        </span>
                      </template>
                    </el-table-column>
                    <!-- <el-table-column  prop="role_name"
              sortable
              filterable
              label="Roles">
              <template slot-scope="scope">
              <span v-if="projId && projId == scope.row.facility_id && scope.row.role_name">
                  {{ scope.row.role_name }}  
      
            
              </span>
              </template>
            </el-table-column> -->

                    <el-table-column align="right">
                      <template slot-scope="scope">
                        <el-button
                          size="mini"
                          type="default"
                          @click="saveRemoveUsers(scope.$index, scope.row)"
                          v-if="
                            isEditingRoles &&
                              scope.$index == rowIndex_1
                          "
                          v-tooltip="`Save`"
                          class="bg-primary btn-sm text-light"
                        >
                          <i class="far fa-save"></i>
                        </el-button>
                        <el-button
                          type="default"
                          size="mini"
                          v-if="scope.$index !== rowIndex_1 && (_isallowed('delete'))"
                          v-tooltip="`Remove User from role`"
                          @click.prevent="editUsers(scope.$index, scope.row)"
                          class="bg-danger text-light btn-sm px-2"
                        >
                          <i class="fal fa-user-lock mr-1 text-light"></i>
                        </el-button>
                        <el-button
                          size="mini"
                          type="default"
                          v-if="isEditingRoles && scope.$index == rowIndex_1"
                          v-tooltip="`Cancel`"
                          @click.prevent="
                            cancelEditRoles(scope.$index, scope.row)
                          "
                          class="btn btn-sm bg-secondary text-light"
                        >
                          <i class="fas fa-ban"></i>
                        </el-button>
                      </template>
                    </el-table-column>
                  </el-table>
                  <p class="mt-2" v-else>
                    No Users Assigned
                  </p>

                  <div class="text-right mt-3">
                    <button
                      @click.prevent="closeUserRoles"
                      class="btn btn-md bg-secondary text-light modalBtns"
                      v-tooltip="`Cancel`"
                    >
                      <i class="fas fa-ban"></i>
                    </button>
                  </div>
                  <!-- </el-collapse-item>
        </el-collapse>  -->
                </div>
              </div>
            </div>
          </el-dialog>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
import SettingsSidebar from "../SettingsSidebar.vue";
import SettingsRolesProjects from "./SettingsRolesProjects.vue";
import SettingsRolesContracts from "./SettingsRolesContracts.vue";
import { faSlidersH } from "@fortawesome/free-solid-svg-icons";
import AuthorizationService from '../../../../services/authorization_service'

export default {
  name: "SettingsRolesIndex",
  components: {
    SettingsSidebar,
    SettingsRolesProjects,
    SettingsRolesContracts,
  },
  data() {
    return {
      rolesVisible: false,
      roleId: null,
      removedUserName: null,
      updatedAdminRole: null,
      isEditting: false,
      rowIndex_1: null,
      isEditingRoles: false,
      roleRowId: null,
      currentRow: null,
      searchRoleUsers: "",
      roleRowData: null,
      addRoleDialogOpen: false,
      tableRoleData: [],
      isGroupsRead: true,
      isGroupsWrite: true,
      isGroupsDelete: true,
      isProjectsRead: true,
      isProjectsWrite: true,
      isProjectsDelete: true,
      isContractsRead: true,
      isContractsWrite: true,
      isContractsDelete: true,
      isUsersRead: true,
      isUsersWrite: true,
      isUsersDelete: true,
      programAdminPriv: [],
      groupsPriv: [],
      projectsPriv: [],
      contractsPriv: [],
      usersPriv: [],
    };
  },
  methods: {
    ...mapMutations([
      "SET_NEW_ROLE_STATUS",
      "SET_UPDATED_ROLE_STATUS",
      "SET_SHOW_CREATE_ROW",
      "SET_PROJECT_ROLE_USERS",
      "SET_ADD_USER_TO_ROLE_STATUS",
      "SET_REMOVE_ADMIN_ROLE_STATUS",
    ]),
    ...mapActions([
      "fetchRoles",
      "fetchProgramUsers",
      "createRole",
      "addUserToRole",
      "updateRole",
      "removeUserRole",
    ]),
    _isallowed(salut) {
      return this.checkPrivileges("SettingsRolesIndex", salut, this.$route, {
        settingType: "Users",
      });
    },
    saveProjectUserRole(index, rows) {
      let user_ids = this.adminRoleUsers.map((t) => t.id);
      let projectUserRoleData = {
        userData: {
          roleId: this.roleId,
          userIds: user_ids,
          programId: this.$route.params.programId,
        },
      };
      // console.log(projectUserRoleData)
      this.addUserToRole({
        ...projectUserRoleData,
      });
    },
    saveRemoveUsers(index, rowData) {
      this.removedUserName = rowData.user_full_name;
      let projectUserRoleData = {
        userData: {
          roleId: rowData.role_id,
          programId: this.$route.params.programId,
          userId: [rowData.user_id],
          adminRoleIndex: true,
        },
      };
      this.removeUserRole({
        ...projectUserRoleData,
      });
    },
    editUsers(index, rowData) {
      this.rowIndex_1 = index;
      this.roleRowId = rowData;
      this.isEditingRoles = true;
    },
    cancelEditRoles(index, rowData) {
      this.isEditingRoles = false;
      this.roleRowId = null;
      this.rowIndex_1 = null;
    },
    addUserRole(index, rows) {
      if (this.programUsers.length < 1) {
        this.fetchProgramUsers(this.$route.params.programId);
      }
      this.rolesVisible = true;
      this.roleId = rows.id;
      this.roleRowData = rows;
      console.log(this.adminUsers);
    },
    groupsRead(index, rowData) {
      this.isGroupsRead = !this.isGroupsRead;
      if (
        this.isGroupsRead &&
        (!this.groupsPriv.map((t) => t).includes("R") ||
          !rowData.role_privileges
            .map((t) => t.privilege.includes("R") && t.role_type)
            .includes("program_setting_groups"))
      ) {
        this.groupsPriv.push(..."R");
      } else if (!this.isGroupsRead) {
        this.groupsPriv = this.groupsPriv.filter((t) => t !== "R");
      }
      console.log(`groups: ${this.groupsPriv}`);
    },
    groupsWrite(index, rowData) {
      this.isGroupsWrite = !this.isGroupsWrite;
      if (
        this.isGroupsWrite &&
        (!this.groupsPriv.map((t) => t).includes("W") ||
          !rowData.role_privileges
            .map((t) => t.privilege.includes("W") && t.role_type)
            .includes("program_setting_groups"))
      ) {
        this.groupsPriv.push(..."W");
      } else if (!this.isGroupsWrite) {
        this.groupsPriv = this.groupsPriv.filter((t) => t !== "W");
      }
      console.log(`groups: ${this.groupsPriv}`);
    },
    groupsDelete(index, rowData) {
      this.isGroupsDelete = !this.isGroupsDelete;
      if (
        this.isGroupsDelete &&
        (!this.groupsPriv.map((t) => t).includes("D") ||
          !rowData.role_privileges
            .map((t) => t.privilege.includes("D") && t.role_type)
            .includes("program_setting_groups"))
      ) {
        this.groupsPriv.push(..."D");
      } else if (!this.isGroupsDelete) {
        this.groupsPriv = this.groupsPriv.filter((t) => t !== "D");
      }
      console.log(`groups: ${this.groupsPriv}`);
    },
    projectsRead(index, rowData) {
      this.isProjectsRead = !this.isProjectsRead;
      if (
        this.isProjectsRead &&
        (!this.projectsPriv.map((t) => t).includes("R") ||
          !rowData.role_privileges
            .map((t) => t.privilege.includes("R") && t.role_type)
            .includes("program_setting_projects"))
      ) {
        this.projectsPriv.push(..."R");
      } else if (!this.isProjectsRead) {
        this.projectsPriv = this.projectsPriv.filter((t) => t !== "R");
      }
      console.log(`projects: ${this.projectsPriv}`);
    },
    projectsWrite(index, rowData) {
      this.isProjectsWrite = !this.isProjectsWrite;
      if (
        this.isProjectsWrite &&
        (!this.projectsPriv.map((t) => t).includes("W") ||
          !rowData.role_privileges
            .map((t) => t.privilege.includes("W") && t.role_type)
            .includes("program_setting_projects"))
      ) {
        this.projectsPriv.push(..."W");
      } else if (!this.isProjectsWrite) {
        this.projectsPriv = this.projectsPriv.filter((t) => t !== "W");
      }
      console.log(`projects: ${this.projectsPriv}`);
    },
    projectsDelete(index, rowData) {
      this.isProjectsDelete = !this.isProjectsDelete;
      if (
        this.isProjectsDelete &&
        (!this.projectsPriv.map((t) => t).includes("D") ||
          !rowData.role_privileges
            .map((t) => t.privilege.includes("D") && t.role_type)
            .includes("program_setting_projects"))
      ) {
        this.projectsPriv.push(..."D");
      } else if (!this.isProjectsDelete) {
        this.projectsPriv = this.projectsPriv.filter((t) => t !== "D");
      }
      console.log(`projects: ${this.projectsPriv}`);
    },
    contractsRead(index, rowData) {
      this.isContractsRead = !this.isContractsRead;
      if (
        this.isContractsRead &&
        (!this.contractsPriv.map((t) => t).includes("R") ||
          !rowData.role_privileges
            .map((t) => t.privilege.includes("R") && t.role_type)
            .includes("program_setting_contracts"))
      ) {
        this.contractsPriv.push(..."R");
      } else if (!this.isContractsRead) {
        this.contractsPriv = this.contractsPriv.filter((t) => t !== "R");
      }
      console.log(`contracts: ${this.contractsPriv}`);
    },
    contractsWrite(index, rowData) {
      this.isContractsWrite = !this.isContractsWrite;
      if (
        this.isContractsWrite &&
        (!this.contractsPriv.map((t) => t).includes("W") ||
          !rowData.role_privileges
            .map((t) => t.privilege.includes("W") && t.role_type)
            .includes("program_setting_contracts"))
      ) {
        this.contractsPriv.push(..."W");
      } else if (!this.isContractsWrite) {
        this.contractsPriv = this.contractsPriv.filter((t) => t !== "W");
      }
      console.log(`contracts: ${this.contractsPriv}`);
    },
    contractsDelete(index, rowData) {
      this.isContractsDelete = !this.isContractsDelete;
      if (
        this.isContractsDelete &&
        (!this.contractsPriv.map((t) => t).includes("D") ||
          !rowData.role_privileges
            .map((t) => t.privilege.includes("D") && t.role_type)
            .includes("program_setting_contracts"))
      ) {
        this.contractsPriv.push(..."D");
      } else if (!this.isContractsDelete) {
        this.contractsPriv = this.contractsPriv.filter((t) => t !== "D");
      }
      console.log(`contracts: ${this.contractsPriv}`);
    },
    usersRead(index, rowData) {
      this.isUsersRead = !this.isUsersRead;
      if (
        this.isUsersRead &&
        (!this.usersPriv.map((t) => t).includes("R") ||
          !rowData.role_privileges
            .map((t) => t.privilege.includes("R") && t.role_type)
            .includes("program_setting_users_roles"))
      ) {
        this.usersPriv.push(..."R");
      } else if (!this.isUsersRead) {
        this.usersPriv = this.usersPriv.filter((t) => t !== "R");
      }
      console.log(`users: ${this.usersPriv}`);
    },
    usersWrite(index, rowData) {
      this.isUsersWrite = !this.isUsersWrite;
      if (
        this.isUsersWrite &&
        (!this.usersPriv.map((t) => t).includes("W") ||
          !rowData.role_privileges
            .map((t) => t.privilege.includes("W") && t.role_type)
            .includes("program_setting_users_roles"))
      ) {
        this.usersPriv.push(..."W");
      } else if (!this.isUsersWrite) {
        this.usersPriv = this.usersPriv.filter((t) => t !== "W");
      }
      console.log(`users: ${this.usersPriv}`);
    },
    usersDelete(index, rowData) {
      this.isUsersDelete = !this.isUsersDelete;
      if (
        this.isUsersDelete &&
        (!this.usersPriv.map((t) => t).includes("D") ||
          !rowData.role_privileges
            .map((t) => t.privilege.includes("D") && t.role_type)
            .includes("program_setting_users_roles"))
      ) {
        this.usersPriv.push(..."D");
      } else if (!this.isUsersDelete) {
        this.usersPriv = this.usersPriv.filter((t) => t !== "D");
      }
      console.log(`users: ${this.usersPriv}`);
    },
    // showHideCreateRow(row, index){
    //   // console.log(row.rowIndex)
    //     return row.rowIndex == 0 && !this.showCreateRow ? 'd-none' : '';
    // },
    closeAddRole() {
      this.addRoleDialogOpen = false;
    },
    editRole(index, rowData) {
      this.groupsPriv = [];
      (this.projectsPriv = []),
        (this.contractsPriv = []),
        (this.usersPriv = []),
        (this.isEditting = true);
      this.currentRow = index;
      // console.log(this.groupsPriv)
      // GROUPS
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("R") && t.role_type)
          .includes("program_setting_groups")
      ) {
        this.isGroupsRead = false;
      }
      if (
        rowData.role_privileges
          .map((t) => t.privilege.includes("R") && t.role_type)
          .includes("program_setting_groups")
      ) {
        this.groupsPriv.push(..."R");
        this.isGroupsRead = true;
      }
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("W") && t.role_type)
          .includes("program_setting_groups")
      ) {
        this.isGroupsWrite = false;
      }
      if (
        rowData.role_privileges
          .map((t) => t.privilege.includes("W") && t.role_type)
          .includes("program_setting_groups")
      ) {
        this.groupsPriv.push(..."W");
        this.isGroupsWrite = true;
      }
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("D") && t.role_type)
          .includes("program_setting_groups")
      ) {
        this.isGroupsDelete = false;
      }
      if (
        rowData.role_privileges
          .map((t) => t.privilege.includes("D") && t.role_type)
          .includes("program_setting_groups")
      ) {
        this.groupsPriv.push(..."D");
        this.isGroupsDelete = true;
      }
      // PROJECTS
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("R") && t.role_type)
          .includes("program_setting_projects")
      ) {
        this.isProjectsRead = false;
      }
      if (
        rowData.role_privileges
          .map((t) => t.privilege.includes("R") && t.role_type)
          .includes("program_setting_projects")
      ) {
        this.projectsPriv.push(..."R");
        this.isProjectsRead = true;
      }
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("W") && t.role_type)
          .includes("program_setting_projects")
      ) {
        this.isProjectsWrite = false;
      }
      if (
        rowData.role_privileges
          .map((t) => t.privilege.includes("W") && t.role_type)
          .includes("program_setting_projects")
      ) {
        this.projectsPriv.push(..."W");
        this.isProjectsWrite = true;
      }
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("D") && t.role_type)
          .includes("program_setting_projects")
      ) {
        this.isProjectsDelete = false;
      }
      if (
        rowData.role_privileges
          .map((t) => t.privilege.includes("D") && t.role_type)
          .includes("program_setting_projects")
      ) {
        this.projectsPriv.push(..."D");
        this.isProjectsDelete = true;
      }
      //CONTRACTS
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("R") && t.role_type)
          .includes("program_setting_contracts")
      ) {
        this.isContractsRead = false;
      }
      if (
        rowData.role_privileges
          .map((t) => t.privilege.includes("R") && t.role_type)
          .includes("program_setting_contracts")
      ) {
        this.contractsPriv.push(..."R");
        this.isContractsRead = true;
      }
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("W") && t.role_type)
          .includes("program_setting_contracts")
      ) {
        this.isContractsWrite = false;
      }
      if (
        rowData.role_privileges
          .map((t) => t.privilege.includes("W") && t.role_type)
          .includes("program_setting_contracts")
      ) {
        this.contractsPriv.push(..."W");
        this.isContractsWrite = true;
      }
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("D") && t.role_type)
          .includes("program_setting_contracts")
      ) {
        this.isContractsDelete = false;
      }
      if (
        rowData.role_privileges
          .map((t) => t.privilege.includes("D") && t.role_type)
          .includes("program_setting_contracts")
      ) {
        this.contractsPriv.push(..."D");
        this.isContractsDelete = true;
      }
      //Users
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("R") && t.role_type)
          .includes("program_setting_users_roles")
      ) {
        this.isUsersRead = false;
      }
      if (
        rowData.role_privileges
          .map((t) => t.privilege.includes("R") && t.role_type)
          .includes("program_setting_users_roles")
      ) {
        this.usersPriv.push(..."R");
        this.isUsersRead = true;
      }
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("W") && t.role_type)
          .includes("program_setting_users_roles")
      ) {
        this.isUsersWrite = false;
      }
      if (
        rowData.role_privileges
          .map((t) => t.privilege.includes("W") && t.role_type)
          .includes("program_setting_users_roles")
      ) {
        this.usersPriv.push(..."W");
        this.isUsersWrite = true;
      }
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("D") && t.role_type)
          .includes("program_setting_users_roles")
      ) {
        this.isUsersDelete = false;
      }
      if (
        rowData.role_privileges
          .map((t) => t.privilege.includes("D") && t.role_type)
          .includes("program_setting_users_roles")
      ) {
        this.usersPriv.push(..."D");
        this.isUsersDelete = true;
      }
    },
    cancelEditRole(index, rowData) {
      this.isEditting = false;
      this.currentRow = null;
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("R") && t.role_type)
          .includes("program_setting_groups")
      ) {
        this.isGroupsRead = !this.isGroupsRead;
      }
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("W") && t.role_type)
          .includes("program_setting_groups")
      ) {
        this.isGroupsWrite = !this.isGroupsWrite;
      }
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("D") && t.role_type)
          .includes("program_setting_groups")
      ) {
        this.isGroupsDelete = !this.isGroupsDelete;
      }

      // PROJECTS
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("R") && t.role_type)
          .includes("program_setting_projects")
      ) {
        this.isProjectsRead = !this.isProjectsRead;
      }
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("W") && t.role_type)
          .includes("program_setting_projects")
      ) {
        this.isProjectsWrite = !this.isProjectsWrite;
      }
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("D") && t.role_type)
          .includes("program_setting_projects")
      ) {
        this.isProjectsDelete = !this.isProjectsDelete;
      }
      //CONTRACTS
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("R") && t.role_type)
          .includes("program_setting_contracts")
      ) {
        this.isContractsRead = !this.isContractsRead;
      }
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("W") && t.role_type)
          .includes("program_setting_contracts")
      ) {
        this.isContractsWrite = !this.isContractsWrite;
      }
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("D") && t.role_type)
          .includes("program_setting_contracts")
      ) {
        this.isContractsDelete = !this.isContractsDelete;
      }

      //Users
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("R") && t.role_type)
          .includes("program_setting_users_roles")
      ) {
        this.isUsersRead = !this.isUsersRead;
      }
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("W") && t.role_type)
          .includes("program_setting_users_roles")
      ) {
        this.isUsersWrite = !this.isUsersWrite;
      }
      if (
        !rowData.role_privileges
          .map((t) => t.privilege.includes("D") && t.role_type)
          .includes("program_setting_users_roles")
      ) {
        this.isUsersDelete = !this.isUsersDelete;
      }
    },
    cancelCreateRole() {
      this.tableData.shift({});
      this.isEditting = false;
      this.currentRow = null;
    },
    addRole() {
      // this.SET_SHOW_CREATE_ROW(!this.showCreateRow);
      this.tableData.unshift({
        name: "",
        newRow: true,
        role_privileges: [],
        role_users: [],
        type_of: "admin",
      });
      this.isEditting = true;
      (this.isGroupsRead = true),
        (this.isGroupsWrite = true),
        (this.isGroupsDelete = true),
        (this.isProjectsRead = true),
        (this.isProjectsWrite = true),
        (this.isProjectsDelete = true),
        (this.isContractsRead = true),
        (this.isContractsWrite = true),
        (this.isContractsDelete = true),
        (this.isUsersRead = true),
        (this.isUsersWrite = true),
        (this.isUsersDelete = true);
      this.groupsPriv.push(..."R");
      this.groupsPriv.push(..."W");
      this.groupsPriv.push(..."D");
      this.projectsPriv.push(..."R");
      this.projectsPriv.push(..."W");
      this.projectsPriv.push(..."D");
      this.contractsPriv.push(..."R");
      this.contractsPriv.push(..."W");
      this.contractsPriv.push(..."D");
      this.usersPriv.push(..."R");
      this.usersPriv.push(..."W");
      this.usersPriv.push(..."D");
    },
    closeUserRoles() {
      this.rolesVisible = false;
      this.isEditingRoles = false;
      this.roleRowId = null;
      this.rowIndex_1 = null;
      this.SET_PROJECT_ROLE_USERS([]);
    },
    // cancelCreateRole() {
    //   this.SET_SHOW_CREATE_ROW(!this.showCreateRow);
    // },
    saveNewRole(index, rowData) {
      console.log(rowData);
      let roleData = {};
      if (rowData.id) {
        roleData = {
          role: {
            name: rowData.name,
            id: rowData.id,
            uId: rowData.user_id,
            pId: this.$route.params.programId,
            type: "admin",
            rp: [
              {
                privilege: this.groupsPriv.join(""),
                role_type: "program_setting_groups",
                name: rowData.name,
                id: rowData.role_privileges[0].id,
              },
              {
                privilege: this.usersPriv.join(""),
                role_type: "program_setting_users_roles",
                name: rowData.name,
                id: rowData.role_privileges[1].id,
              },
              {
                privilege: this.projectsPriv.join(""),
                role_type: "program_setting_projects",
                name: rowData.name,
                id: rowData.role_privileges[2].id,
              },
              {
                privilege: this.contractsPriv.join(""),
                role_type: "program_setting_contracts",
                name: rowData.name,
                id: rowData.role_privileges[3].id,
              },
            ],
          },
        };
        this.updateRole({
          ...roleData,
        });
        console.log(roleData);
      } else {
        let roleData = {
          role: {
            name: rowData.name,
            uId: "",
            type: "admin",
            //  role_users: [{}],
            pId: this.$route.params.programId,
            rp: [
              {
                privilege: this.groupsPriv.join(""),
                role_type: "program_setting_groups",
                name: rowData.name,
              },
              {
                privilege: this.usersPriv.join(""),
                role_type: "program_setting_users_roles",
                name: rowData.name,
              },
              {
                privilege: this.projectsPriv.join(""),
                role_type: "program_setting_projects",
                name: rowData.name,
              },
              {
                privilege: this.contractsPriv.join(""),
                role_type: "program_setting_contracts",
                name: rowData.name,
              },
            ],
          },
        };
        this.createRole({
          ...roleData,
        });

        // this.SET_SHOW_CREATE_ROW(!this.showCreateRow)
      }
      this.isEditting = false;
      this.currentRow = null;
    },
    handleClick(tab, event) {
      if (tab) {
        this.isEditting = false;
      }
    },
  },
  mounted() {
    this.fetchRoles(this.$route.params.programId);
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "getRolesLoaded",
      "programUsers",
      "currentProject",
      "getPortfolioUsers",
      "activeProjectUsers",
      "getProjectRoleUsers",
      "addUserToRoleStatus",
      "showCreateRow",
      "newRoleStatus",
      "updatedRoleStatus",
      "getRoles",
      "removeAdminRoleStatus",
      "new",
    ]),
    otherThanProgramAdminRoles() {
      if (this.adminRoleUsers) {
        if (this.adminRoleUsers.length > 0) {
          return this.adminRoleUsers.filter(
            (t) =>
              t.type_of == "admin" &&
              t.id != AuthorizationService.program_admin_role.id
          );
        }
      }
    },
    adminRoleUsers: {
      get() {
        console.log(this.getProjectRoleUsers);
        return this.getProjectRoleUsers;
      },
      set(value) {
        this.SET_PROJECT_ROLE_USERS(value);
        console.log(value);
      },
    },
    programRoleUsers() {
      if (this.programUsers) {
        if (this.programUsers.length > 0) {
          return this.programUsers.map((t) => t);
        }
      }
    },
    allAdminUsers() {
      if (this.getRoles && this.getRoles.length > 0) {
        let adminRolesOnly = this.getRoles.filter((t) => t.type_of == "admin");
        let roleUsers = adminRolesOnly
          .map((t) => t.role_users)
          .filter((t) => t.length > 0);
        let data = [].concat.apply([], roleUsers).filter((user) => {
          if (this.searchRoleUsers !== "" && user) {
            // console.log(task)
            return user.user_full_name
              .toLowerCase()
              .match(this.searchRoleUsers.toLowerCase());
          } else return true;
        });
        return data;
      }
    },
    adminUsers() {
      if (this.getRoles && this.getRoles.length > 0) {
        let roleUsers = this.getRoles
          .map((t) => t.role_users)
          .filter((t) => t.length > 0);
        let data = [].concat
          .apply([], roleUsers)
          .filter((t) => {
            if (this.roleId && t.project_id == this.$route.params.programId) {
              return this.roleId == t.role_id;
            }
          })
          .filter((user) => {
            if (this.searchRoleUsers !== "" && user) {
              // console.log(task)
              return user.user_full_name
                .toLowerCase()
                .match(this.searchRoleUsers.toLowerCase());
            } else return true;
          });
        return data;
      }
    },
    viableAdminUsers() {
      if (this.programRoleUsers && this.adminUsers) {
        let assignedUserIds = this.allAdminUsers.map((t) => t.user_id);
        // console.log(this.programRoleUsers.filter(t => !assignedUserIds.includes(t.id)))
        return this.programRoleUsers.filter(
          (t) => !assignedUserIds.includes(t.id)
        );
      }
    },
    backToSettings() {
      return `/programs/${this.$route.params.programId}/settings`;
    },
    tableData() {
      if (this.getRoles && this.getRoles.length > 0) {
        return this.getRoles.filter(
          (role) => role.type_of == "admin" || role.type_of == ""
        );
      }
    },
    tableCounts() {
      if (this.getRoles && this.getRoles.length > 0) {
        return {
          n: {
            // -1 value after length to account for crud row at index 0 that isn't used
            contracts: this.getRoles.filter(
              (role) => role.type_of == "contract"
            ).length,
            projects: this.getRoles.filter((role) => role.type_of == "project")
              .length,
          },
        };
      }
    },
  },
  watch: {
    newRoleStatus: {
      handler() {
        if (this.newRoleStatus == 200) {
          MessageDialogService.showDialog({
            message: `New role successfully added to your program.`,
            
            
          });
          this.SET_NEW_ROLE_STATUS(0);
          this.fetchRoles(this.$route.params.programId);
          this.isEditting = false;
          this.currentRow = null;
          // this.isProgramAdminRead = true,
          // this.isProgramAdminWrite = true,
          // this.isProgramAdminDelete = true

          (this.isGroupsRead = true),
            (this.isGroupsWrite = true),
            (this.isGroupsDelete = true),
            (this.isProjectsRead = true),
            (this.isProjectsWrite = true),
            (this.isProjectsDelete = true),
            (this.isContractsRead = true),
            (this.isContractsWrite = true),
            (this.isContractsDelete = true),
            (this.isUsersRead = true),
            (this.isUsersWrite = true),
            (this.isUsersDelete = true),
            // this.programAdminPriv = []
            (this.groupsPriv = []),
            (this.projectsPriv = []),
            (this.contractsPriv = []),
            (this.usersPriv = []);
          // if (this.isProgramAdminRead && this.isProgramAdminWrite && this.isProgramAdminDelete ) {
          //   this.programAdminPriv.push(..."R")
          //   this.programAdminPriv.push(..."W")
          //   this.programAdminPriv.push(..."D")

          // }
          if (this.isGroupsRead && this.isGroupsWrite && this.isGroupsDelete) {
            this.groupsPriv.push(..."R");
            this.groupsPriv.push(..."W");
            this.groupsPriv.push(..."D");
          }
          if (
            this.isProjectsRead &&
            this.isProjectsWrite &&
            this.isProjectsDelete
          ) {
            this.projectsPriv.push(..."R");
            this.projectsPriv.push(..."W");
            this.projectsPriv.push(..."D");
          }
          if (
            this.isContractsRead &&
            this.isContractsWrite &&
            this.isContractsDelete
          ) {
            this.contractsPriv.push(..."R");
            this.contractsPriv.push(..."W");
            this.contractsPriv.push(..."D");
          }
          if (this.isUsersRead && this.isUsersWrite && this.isUsersDelete) {
            this.usersPriv.push(..."R");
            this.usersPriv.push(..."W");
            this.usersPriv.push(..."D");
          }
        }
      },
    },
    updatedRoleStatus: {
      handler() {
        if (this.updatedRoleStatus == 200) {
          MessageDialogService.showDialog({
            message: `Role successfully updated.`,
            
            
          });
          console.log("updatedRole in Admin");
          this.SET_UPDATED_ROLE_STATUS(0);
          this.fetchRoles(this.$route.params.programId);
          this.currentRow = null;
          this.isEditting = false;
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
          this.fetchRoles(this.$route.params.programId);
          this.SET_PROJECT_ROLE_USERS([]);
        }
      },
    },
    removeAdminRoleStatus: {
      handler() {
        if(this.removeAdminRoleStatus == 406){
           MessageDialogService.showDialog({
            message: `Programs must have at least one program-admin assigned. Before removing ${this.removedUserName} from this role, please assign another program-admin.`,
            
            
          });
        } else if (
          this.removeAdminRoleStatus == 200 ||
          this.removeAdminRoleStatus == 204
        ) {
          MessageDialogService.showDialog({
            message: `Succesfully removed Admin role from ${this.removedUserName} .`,
            
            
          });
          this.fetchRoles(this.$route.params.programId);
          this.SET_REMOVE_ADMIN_ROLE_STATUS(0);
          this.isEditingRoles = false;
          this.rowIndex_1 = null;
        }
        
      },
    },
  },
};
</script>

<style scoped lang="scss">
.right-panel {
  height: calc(100vh - 100px);
  overflow-y: auto;
}
::v-deep.el-dialog__close.el-icon.el-icon-close {
  display: none;
}
.addRoleDialog {
  ::v-deep.el-dialog__body {
    padding-top: 0 !important;
  }
  ::v-deep.el-dialog__header {
    padding-bottom: 0 !important;
  }
}
.buttonWrapper {
  border-bottom: lightgray solid 1px;
}
::v-deep.el-dialog__header.users {
  padding: 0;
}
::v-deep.el-table th.el-table__cell > .cell {
  color: #383838;
  //   font-size: .9rem;
  text-align: center;
}
.user-role-modal {
  ::v-deep.el-table__header,
  .el-table {
    width: auto !important;
  }
}
.modalBtns {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.crudRow {
  ::v-deep.el-input__inner {
    border: 1px solid #d9534f;
  }
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
