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
              v-if="tableData && tableData.length"
              :load="log(tableData)"
              class="ml-2 pb-1 badge badge-secondary badge-pill pill"
              >{{ tableData.length }}
            </span>
            <span v-else class="ml-2 pb-1 badge badge-secondary badge-pill pill"
              >{{ 0 }}
            </span>
          </h4>
        </el-breadcrumb>
        <div class="my-1 pb-2 buttonWrapper container-fluid">
          <div class="row px-0">
            <div class="col-6">
              <el-button
                @click.prevent="addVehicle"
                class="bg-primary text-light mb-2"
              >
                <i class="far fa-plus-circle mr-1"></i> Create Vehicle
              </el-button>
              <el-button
                @click.prevent="openPortfolioVehicle"
                class="bg-success text-light mb-2"
              >
                <i class="far fa-plus-circle mr-1"></i> Add Portfolio Vehicle(s)
              </el-button>
            </div>
            <div class="col-6">
              <el-input
                type="search"
                placeholder="Search Vehicles"
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
        <el-dialog
          :visible.sync="dialogVisible"
          append-to-body
          center
          class="contractForm p-0 createNewVehicle"
        >
          <span slot="title" class="text-left add-groups-header">
            <h5 class="text-dark">
              <i class="far fa-plus-circle mr-1"></i>Create Program Vehicle
            </h5>
          </span>
          <form accept-charset="UTF-8">
            <div class="form-group mx-3">
              <el-input
                v-model="newVehicleName"
                placeholder="Enter new Vehicle Name"
                rows="1"
                name="Vehicle Name"
              />
            </div>
            <div class="right mr-2">
              <button
                @click.prevent="createNewVehicle"
                v-show="newVehicleName"
                class="btn btn-md bg-primary text-light  modalBtns"
                v-tooltip="`Save New Vehicle`"
                :class="[hideSaveBtn ? 'd-none' : '']"
              >
                <i class="fal fa-save"></i>
              </button>
              <button
                @click.prevent="cancelCreateVehicle"
                class="btn btn-md bg-secondary text-light modalBtns"
                v-tooltip="`Close`"
                :class="[hideSaveBtn ? 'd-none' : '']"
              >
                <i class="fas fa-ban"></i>
              </button>
              <button
                @click.prevent="addAnotherVehicle"
                v-tooltip="`Add Another Vehicle`"
                :class="[!hideSaveBtn ? 'd-none' : '']"
                class="btn btn-md bg-primary text-light modalBtns"
              >
                <i class="far fa-plus-circle"></i>
              </button>
              <button
                @click.prevent="closeAddVehicleBtn"
                v-tooltip="`Close`"
                class="btn btn-md bg-secondary text-light modalBtns mr-2"
                :class="[!hideSaveBtn ? 'd-none' : '']"
              >
                <i class="fas fa-ban"></i>
              </button>
            </div>
          </form>
        </el-dialog>
        <el-dialog
          :visible.sync="dialog2Visible"
          append-to-body
          center
          class="portfolioNames p-0"
          v-if="vehicles && vehicles.length > 0"
        >
          <div>
            <template>
              <div class="sticky">
                <div class="row">
                  <div slot="title" class="col-8 pr-0 text-left">
                    <h5 class="text-dark addVehiclesHeader">
                      <i class="fal fa-network-wired mr-2 mh-blue-text"></i
                      >Select Portfolio Vehicle(s) to Add
                    </h5>
                  </div>
                  <div class="col-7 pt-0 text-left">
                    <el-input
                      type="search"
                      placeholder="Search Vehicles"
                      aria-label="Search"
                      class="w-100"
                      aria-describedby="search-addon"
                      v-model="searchVehicles"
                      data-cy=""
                    >
                      <el-button
                        slot="prepend"
                        icon="el-icon-search"
                      ></el-button>
                    </el-input>
                  </div>
                  <div class="col pt-0 text-right">
                    <el-button
                      class="confirm-save-group-names btn text-light bg-primary modalBtns"
                      v-tooltip="`Save Vehicle(s)`"
                      @click.prevent="importVehicleName"
                      :disabled="portfolioVehicles.length <= 0"
                    >
                      <i class="fal fa-save"></i>
                    </el-button>
                    <el-button
                      @click.prevent="closeImportVehicleBtn"
                      v-tooltip="`Close`"
                      class="btn bg-secondary ml-0 text-light modalBtns"
                    >
                      <i class="fas fa-ban"></i>
                    </el-button>
                  </div>
                </div>
              </div>
            </template>
            <el-checkbox
              :indeterminate="isIndeterminate"
              v-model="checkAll"
              @change="handleCheckAllChange"
              ><i>Check all Vehicles</i></el-checkbox
            >
            <div style="margin: 15px 0;"></div>
            <el-checkbox-group v-model="checkedPortfolioVehicles">
              <div class="row">
                <div class="col-4">
                  <el-checkbox
                    v-for="vehicle in portfolioVehicles.filter(
                      (g) => g.is_portfolio
                    )"
                    :label="vehicle.id"
                    class="d-flex"
                    :key="vehicle.id"
                    >{{ vehicle.name }}</el-checkbox
                  >
                </div>
              </div>
            </el-checkbox-group>
          </div>
        </el-dialog>
        <div class="container-fluid mt-2 mx-0">
          <div
            v-loading="!contentLoaded"
            v-if="_isallowed('read')"
            element-loading-text="Fetching your data. Please wait..."
            element-loading-spinner="el-icon-loading"
            element-loading-background="rgba(0, 0, 0, 0.8)"
            class="mt-2"
          >
            <el-table
              v-if="tableData"
              :data="
                tableData
                  .filter(
                    (data) =>
                      !search ||
                      data.name.toLowerCase().includes(search.toLowerCase())
                  )
                  .reverse()
              "
              style="width: 100%"
              height="475"
              highlight-current-row
              :default-sort="{ prop: 'name', order: 'ascending' }"
            >
              <el-table-column prop="name" sortable label="Vehicles">
                <template slot-scope="props">
                  <div class="row">
                    <div class="col-9">
                      <el-input
                        size="small"
                        v-if="rowId == props.row.id"
                        style="text-align:center"
                        v-model="props.row.name"
                        controls-position="right"
                      >
                      </el-input>
                      <span v-else>
                        <span
                          v-if="props.row.isPortfolio"
                          v-tooltip="`Portfolio Vehicle`"
                          ><i class="fas fa-circle mr-2 text-success fs-50"></i
                        ></span>
                        {{ props.row.name }}
                      </span>
                    </div>
                  </div>
                </template>
              </el-table-column>
              <el-table-column>
                <template slot-scope="props">
                  <span v-if="props.row.isDefault">
                    <small><em>Default Vehicle</em></small>
                  </span>
                </template>
              </el-table-column>
              <el-table-column label="Counts" width="165">
                <template slot-scope="props">
                  <div class="row">
                    <div class="col">
                      <i
                        class="fal fa-clipboard-list mr-1 mh-green-text"
                        v-tooltip="`Projects`"
                      ></i>
                      <span
                        class="mr-4"
                        v-if="
                          vehicleProjects &&
                            vehicleProjects
                              .map((t) => t.facilityVehicleId)
                              .filter((t) => t == props.row.id).length
                        "
                      >
                        {{
                          vehicleProjects &&
                            vehicleProjects
                              .map((t) => t.facilityVehicleId)
                              .filter((t) => t == props.row.id).length
                        }}
                      </span>
                      <span class="mr-4" v-else>
                        {{ 0 }}
                      </span>
                      <i
                        class="far fa-file-contract mr-1 mh-orange-text"
                        v-tooltip="`Contracts`"
                      ></i>
                      <span
                        v-if="
                          vehicleContracts &&
                            vehicleContracts.length > 0 &&
                            vehicleContracts
                              .map(
                                (t) =>
                                  t &&
                                  t.facility_vehicle &&
                                  t.facility_vehicle.id
                              )
                              .filter((t) => t == props.row.id).length
                        "
                      >
                        {{
                          vehicleContracts
                            .map((t) => t.facility_vehicle.id)
                            .filter((t) => t == props.row.id).length
                        }}
                      </span>
                      <span v-else>
                        {{ 0 }}
                      </span>
                    </div>
                  </div>
                </template>
              </el-table-column>
              <el-table-column type="expand">
                <template slot-scope="props">
                  <div class="container">
                    <div class="row">
                      <div class="col">
                        <h5 class="mh-orange-text">
                          Projects
                          <span
                            v-if="
                              groupProjects &&
                                groupProjects
                                  .map((t) => t.facilityGroupId)
                                  .filter((t) => t == props.row.id).length > 0
                            "
                            class="badge badge-secondary badge-pill pill"
                            >{{
                              groupProjects &&
                                groupProjects
                                  .map((t) => t.facilityGroupId)
                                  .filter((t) => t == props.row.id).length
                            }}
                          </span>
                          <span
                            v-else
                            class="badge badge-secondary badge-pill pill"
                            >{{ 0 }}
                          </span>
                        </h5>
                        <span v-if="groupProjects">
                          <ul
                            class="pl-3 mb-0"
                            v-for="(item, i) in groupProjects.filter(
                              (t) => t.facilityGroupId == props.row.id
                            )"
                            :key="i"
                          >
                            <li>
                              {{ item.facilityName }}
                            </li>
                          </ul>
                        </span>
                      </div>
                      <div class="col">
                        <h5 class="mh-orange-text">
                          Contracts
                          <span
                            v-if="
                              groupContracts &&
                                groupContracts.length > 0 &&
                                groupContracts.map((t) => t && t.facility_group)
                            "
                            class="badge badge-secondary badge-pill pill"
                            >{{
                              groupContracts
                                .map((t) => t.facility_group.id)
                                .filter((t) => t == props.row.id).length
                            }}
                          </span>
                          <span
                            v-else
                            class="badge badge-secondary badge-pill pill"
                            >{{ 0 }}
                          </span>
                        </h5>
                        <span
                          v-if="groupContracts && groupContracts.length > 0"
                        >
                          <ul class="pl-3 mb-0">
                            <li
                              v-for="(item, i) in groupContracts.filter(
                                (t) => t.facility_group.id == props.row.id
                              )"
                              :key="i"
                            >
                              {{ item.name }}
                            </li>
                          </ul>
                        </span>
                      </div>
                    </div>
                  </div>
                </template>
              </el-table-column>
              <el-table-column
                label="Actions"
                align="right"
                v-if="_isallowed('delete') || _isallowed('write')"
              >
                <template slot-scope="scope">
                  <el-button
                    type="default"
                    v-tooltip="`Save`"
                    @click.prevent="saveEdits(scope.$index, scope.row)"
                    v-if="scope.$index == rowIndex"
                    class="bg-primary btn-sm text-light"
                  >
                    <i class="far fa-save"></i>
                  </el-button>
                  <el-button
                    type="default"
                    v-tooltip="`Cancel Edit`"
                    v-if="scope.$index == rowIndex"
                    @click.prevent="cancelEdits(scope.$index, scope.row)"
                    class="bg-secondary  btn-sm text-light"
                  >
                    <i class="fas fa-ban"></i>
                  </el-button>
                  <el-button
                    type="default"
                    v-tooltip="`Edit Program Vehicle`"
                    @click.prevent="editMode(scope.$index, scope.row)"
                    v-if="
                      !scope.row.isPortfolio &&
                        scope.$index !== rowIndex &&
                        _isallowed('write')
                    "
                    class="bg-light btn-sm "
                  >
                    <i class="fal fa-edit text-primary"></i>
                  </el-button>
                  <el-button
                    type="default"
                    class="bg-light btn-sm"
                    v-tooltip="'Remove Portfolio Vehicle'"
                    @click.prevent="removeVehicle(scope.$index, scope.row)"
                    v-if="
                      scope.$index !== rowIndex &&
                        scope.row.isPortfolio &&
                        _isallowed('delete')
                    "
                  >
                    <i class="fa-light fa-circle-minus text-danger"></i>
                  </el-button>
                  <el-button
                    type="default"
                    v-tooltip="'Delete Program Vehicle'"
                    @click.prevent="removeVehicle(scope.$index, scope.row)"
                    v-if="
                      !scope.row.isDefault &&
                        scope.$index !== rowIndex &&
                        !scope.row.isPortfolio &&
                        _isallowed('delete')
                    "
                    class="bg-light btn-sm"
                  >
                    <i class="far fa-trash-alt text-danger "></i>
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </div>
          <!-- <div v-else class="text-danger mx-2 mt-5">
            <h5>
              <i
                >Sorry, you don't have read-permissions for this page! Please
                contact your Program Administrator for access.</i
              >
            </h5>
          </div> -->
        </div>
      </div>
      <!-- <div class="col-md-8" > -->
      <!-- <div class="right-panel">
       
       </div> -->
      <!-- </div> -->
    </div>
  </div>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
import SettingsSidebar from "./SettingsSidebar.vue";
import FormTabs from "../../shared/FormTabs.vue";
export default {
  name: "SettingsVehicles",
  components: {
    SettingsSidebar,
    FormTabs,
  },

  data() {
    return {
      searchVehicles: "",
      dialogVisible: false,
      dialog2Visible: false,
      isIndeterminate: true,
      currentTab: "tab1",
      currentFacilityVehicle: {},
      componentKey: 0,
      confirmTransfer: false,
      rowIndex: null,
      rowId: null,
      transferVehicleBack: null,
      newVehicleName: null,
      programId: this.$route.params.programId,
      hideSaveBtn: false,
      search: "",
      selectedProjectVehicle: null,
      expanded: {
        id: "",
      },
    };
  },
  methods: {
    ...mapMutations([
      "setProjectVehicleFilter",
      "setContractTable",
      "setVehicleFilter",
      "SET_VEHICLE_STATUS",
      "SET_TRANSFER_DATA",
      "SET_NEW_VEHICLES",
      "SET_CHECKED_PORTFOLIO_VEHICLES",
      "SET_CHECK_ALL",
      "SET_CHECKED_VEHICLES",
    ]),
    ...mapActions([
      "createVehicle",
      "fetchFacilityVehicles",
      "updateVehicleName",
      "removeOrDeleteVehicle",
      "updateVehicle",
      "fetchVehicles",
      "fetchContracts",
      "fetchCurrentProject",
    ]),
    log(e) {
      console.log(e);
    },
    tableRowClassName({ row, rowIndex }) {
      if (!row.isPortfolio) {
        return "warning-row";
      }
    },
    cancelCreateVehicle() {
      this.dialogVisible = false;
    },
    addAnotherVehicle() {
      this.C_projectVehicleFilter = null;
      this.newVehicleName = null;
      this.hideSaveBtn = false;
    },
    handleCheckAllChange() {
      this.isIndeterminate = false;
    },
    reRenderTable() {
      this.componentKey += 1;
    },
    closeAddVehicleBtn() {
      this.dialogVisible = false;
      this.hideSaveBtn = false;
    },
    editMode(index, rows) {
      this.rowIndex = index;
      this.rowId = rows.id;
    },
    closeImportVehicleBtn() {
      this.dialog2Visible = false;
      this.SET_CHECKED_PORTFOLIO_VEHCILES([0]);
    },
    addVehicle() {
      this.dialogVisible = true;
      this.newVehicleName = null;
      this.C_projectVehicleFilter = null;
    },
    openPortfolioVehicle() {
      this.dialog2Visible = true;
      console.log(this.vehicleContracts);
    },
    onChangeTab(tab) {
      this.currentTab = tab ? tab.key : "tab1";
      // console.log(this.currentTab)
    },
    saveEdits(index, rows) {
      let id = rows.id;
      let vehicleNameData = {
        newNameData: {
          name: rows.name,
        },
        project_id: this.$route.params.programId,
      };
      this.updateVehicleName({
        ...vehicleNameData,
        id,
      });
      this.rowIndex = null;
      this.rowId = null;
    },
    cancelEdits(index, rows) {
      this.rowIndex = null;
      this.rowId = null;
      // console.log(this.facilityVehicles)
    },
    createNewVehicle() {
      let vehicleData = {
        vehicle: {
          name: this.newVehicleName,
          project_id: this.$route.params.programId,
        },
      };
      this.createVehicle({
        ...vehicleData,
      });
      this.hideSaveBtn = true;
    },
    removeVehicle(index, rows) {
      // let id = [rows.id];
      let vehicle = {
        g: {
          id: rows.id,
          programId: this.$route.params.programId,
        },
      };
      if (rows.isPortfolio) {
        this.$confirm(
          `Are you sure you want to remove ${rows.name} from your program?`,
          "Confirm Remove",
          {
            confirmButtonText: "Remove",
            cancelButtonText: "Cancel",
            type: "warning",
          }
        ).then(() => {
          this.removeOrDeleteVehicle({ ...vehicle });
        });
      } else
        this.$confirm(
          `Are you sure you want to delete ${rows.name} from your program?`,
          "Confirm Delete",
          {
            confirmButtonText: "Delete",
            cancelButtonText: "Cancel",
            type: "warning",
          }
        ).then(() => {
          this.removeOrDeleteVehicle({ ...vehicle });
        });
    },
    importVehicleName() {
      let data = this.checkedPortfolioVehicles;
      if (this.facilityVehicles && this.facilityVehicles.length > 0) {
        let savedVehicles = this.facilityVehicles.map((g) => g.id);
        for (let i = 0; i <= this.facilityVehicles.length; i++) {
          if (savedVehicles[i] !== undefined) {
            data.push(savedVehicles[i]);
          }
        }
      }
      let vehicle = {
        vehicleData: {
          ids: [...new Set(data)],
          programId: this.$route.params.programId,
        },
      };

      this.updateVehicle({
        ...vehicle,
      });
      this.confirmTransfer = false;
    },
    handleClick(tab, event) {
      console.log(tab, event);
    },
    _isallowed(salut) {
      return this.checkPrivileges("SettingsVehicles", salut, this.$route, {
        settingType: "Vehicles",
      });
    },
  },
  mounted() {
    if (this.vehicles && this.vehicles.length <= 0) {
      this.fetchVehicles(this.$route.params.programId);
    }
    this.fetchContracts(this.$route.params.programId);
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "facilities",
      "vehicles",
      "contracts",
      "getTransferData",
      "getContractTable",
      "currentProject",
    ]),
    backToSettings() {
      return `/programs/${this.$route.params.programId}/settings`;
    },
  },
};
</script>

<style scoped lang="scss">
.right {
  text-align: right;
}
.buttonWrapper {
  border-bottom: lightgray solid 1px;
}
.fa-calendar {
  font-size: x-large;
}
/deep/.el-table th.el-table__cell > .cell {
  color: #212529;
  font-size: 1.15rem;
}
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
/deep/.el-table__row .el-input .el-input__inner {
  border-style: none;
}
/deep/.el-table {
  font-size: 16px;
}
/deep/.hover-row .el-input .el-input__inner {
  border-style: solid;
}

.container {
  margin-left: 50px;
}

// Move el-transfer styles to Common file if more files require same CSS
/deep/.el-transfer-panel {
  width: 400px;
  padding-bottom: 30px;
}
/deep/.el-transfer-panel__header {
  font-size: 1.5rem;
  text-transform: uppercase;
  font-weight: 600 !important;
}
/deep/.el-transfer-panel__body {
  min-height: 400px;
  margin-bottom: 30px;
}
/deep/.el-transfer-panel__list {
  min-height: 425px;
}
/deep/.el-checkbox__input.is-disabled + span.el-checkbox__label {
  color: #1d336f !important;
  cursor: default;
}
/deep/.el-transfer-panel .el-transfer-panel__header {
  background-color: #ededed;
}
/deep/.el-table {
  .warning-row {
    background: oldlace;
  }

  ::placeholder {
    /* Chrome, Firefox, Opera, Safari 10.1+ */
    color: lightgray;
    font-family: "FuturaPTBook";
  }
}
/deep/.el-input__inner {
  font-size: 1.1rem;
}

/deep/.el-button.confirm-save-group-names {
  background-color: rgba(40, 167, 69, 1);
}

label.el-checkbox {
  margin-top: 15px;
}

div.sticky {
  position: -webkit-sticky;
  position: sticky;
  top: 0;
  text-align: right;
  padding-top: 10px;
  z-index: 10;
  background: #fff;
}
.addVehiclesHeader,
h5 {
  line-height: 2.2;
  word-break: break-word;
}

.portfolioNames {
  /deep/.el-dialog__header {
    padding-top: 0 !important;
  }
  /deep/.el-dialog__headerbtn {
    display: none;
  }

  /deep/.el-dialog__body {
    padding-top: 0 !important;
    height: 68vh;
  }

  /deep/.el-checkbox-group {
    overflow-y: auto;
    overflow-x: hidden;
    height: 35vh;
  }
}
.breakWord {
  word-break: break-word !important;
  // white-space: normal !important;
  word-spacing: 2px !important;
}
.createNewVehicle {
  /deep/.el-dialog__body {
    padding-top: 0 !important;
  }
  /deep/.el-dialog {
    width: 30%;
  }
}

/deep/.el-dialog__close.el-icon.el-icon-close {
  display: none;
}
.add-groups-header {
  background-color: #fff;
}
.modalBtns {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.fs-50 {
  font-size: 0.5rem;
}
.program-sphere {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: -webkit-radial-gradient(
    65% 15%,
    circle,
    white 1px,
    aqua 3%,
    darkblue 60%,
    aqua 100%
  );
  background: -moz-radial-gradient(
    65% 15%,
    circle,
    white 1px,
    aqua 3%,
    darkblue 60%,
    aqua 100%
  );
  background: -o-radial-gradient(
    65% 15%,
    circle,
    white 1px,
    aqua 3%,
    darkblue 60%,
    aqua 100%
  );
  background: radial-gradient(
    circle at 65% 15%,
    white 1px,
    aqua 3%,
    darkblue 60%,
    aqua 100%
  );
}
</style>
