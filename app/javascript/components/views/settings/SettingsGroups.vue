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
            <i class="fal fa-network-wired mr-1 mh-blue-text"></i> GROUPS
            <span
              v-if="tableData && tableData.length"
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
            <div
              class="col-6"  
                    
            > 
              <el-button
                @click.prevent="addGroup"
                 v-if="_isallowed('write')"    
                class="bg-primary text-light mb-2"
              >
                <i class="far fa-plus-circle mr-1"></i> Create Group
              </el-button>
              <el-button
                @click.prevent="openPortfolioGroup"
                 v-if="_isallowed('write')"    
                class="bg-success text-light mb-2"
              >
                <i class="far fa-plus-circle mr-1"></i> Add Portfolio Group(s)
              </el-button>
            </div>
            <div class="col-6">
              <el-input
                type="search"
                placeholder="Search Groups"
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
          class="contractForm p-0 createNewGroup"
        >
              <span slot="title" class="text-left add-groups-header">
                <h5 class="text-dark"> <i class="far fa-plus-circle mr-1"></i>Create Program Group </h5>
              </span>
          <form accept-charset="UTF-8">
            <div class="form-group mx-3">
           <el-input
                v-model="newGroupName"
                placeholder="Enter new Group Name"
                rows="1"
                name="Group Name"
              />
            </div>
            <div class="right mr-2">
              <button
                @click.prevent="createNewGroup"
                v-show="newGroupName"
                class="btn btn-md bg-primary text-light  modalBtns"
                v-tooltip="`Save New Group`"
                :class="[hideSaveBtn ? 'd-none' : '']"
              >
                <i class="fal fa-save"></i>
              </button>
              <button
                @click.prevent="cancelCreateGroup"
                class="btn btn-md bg-secondary text-light modalBtns"
                v-tooltip="`Cancel`"               
                :class="[hideSaveBtn ? 'd-none' : '']"
              >
               <i class="fas fa-ban"></i> 
              </button>
              <button
                @click.prevent="addAnotherGroup"
                 v-tooltip="`Add Another Group`"     
                :class="[!hideSaveBtn ? 'd-none' : '']"
                class="btn btn-md bg-primary text-light modalBtns"
              >
                <i class="far fa-plus-circle"></i>
              </button>
              <button
                @click.prevent="closeAddGroupBtn"
                v-tooltip="`Cancel`"
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
          v-if="groups && groups.length > 0"
        >
          <div>
            <template>
              <div class="sticky">
              <div class="row"> 
               <div slot="title" class="col-8 pr-0 text-left">
                <h5 class="text-dark addGroupsHeader"> <i class="fal fa-network-wired mr-2 mh-blue-text"></i>Select Portfolio Group(s) to Add </h5>
              </div>
           <div class="col-7 pt-0 text-left">
            <el-input
            type="search"
            placeholder="Search Groups"
            aria-label="Search"
            class="w-100"
            aria-describedby="search-addon"
            v-model="searchGroups"
            data-cy=""
          >
            <el-button slot="prepend" icon="el-icon-search"></el-button>
          </el-input>
          </div>
                <div class="col pt-0 text-right">
                  <el-button
                    class="confirm-save-group-names btn text-light bg-primary modalBtns"
                    v-tooltip="`Save Group(s)`"
                    @click.prevent="importGroupName"
                    :disabled="portfolioGroups.length <= 0"
                  >
                    <i class="fal fa-save"></i>
                  </el-button>
                  <el-button
                    @click.prevent="closeImportGroupBtn"
                    v-tooltip="`Cancel`"
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
              ><i>Check all Groups</i></el-checkbox
            >
            <div style="margin: 15px 0;"></div>
            <el-checkbox-group v-model="checkedPortfolioGroups">
              <div class="row">
                <div class="col-4">
                  <el-checkbox
                    v-for="group in portfolioGroups.filter(g => g.is_portfolio)"
                    :label="group.id"
                    class="d-flex"
                    :key="group.id"
                    >{{ group.name }}</el-checkbox
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
              :default-sort="{ prop: 'name', order: 'ascending'}"  
            >
          
              <el-table-column prop="name" sortable label="Groups">
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
                       <span v-if="props.row.isPortfolio" v-tooltip="`Portfolio Group`"><i class="fas fa-circle mr-2 text-success fs-50"></i></span> 
                        {{ props.row.name }}
                       

                      </span>
                    </div>
                  </div>
                </template>
              </el-table-column>
               <el-table-column>
              <template slot-scope="props">
              <span v-if="props.row.isDefault">
                <small><em>Default Group</em></small>                        
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
                        class="mr-3"
                        v-if="
                          groupProjects &&
                            groupProjects
                              .map((t) => t.facilityGroupId)
                              .filter((t) => t == props.row.id).length
                        "
                      >
                        {{
                          groupProjects &&
                            groupProjects
                              .map((t) => t.facilityGroupId)
                              .filter((t) => t == props.row.id).length
                        }}
                      </span>
                      <span class="mr-3" v-else>
                        {{ 0 }}
                      </span>
                      <i
                        class="far fa-file-contract mr-1 mh-orange-text"
                        v-tooltip="`Contracts`"
                      ></i>
                      <span
                      class="mr-3"
                        v-if="
                          groupContracts && groupContracts.length > 0 &&
                            groupContracts
                              .map((t) => t && t.facility_group && t.facility_group.id)
                              .filter((t) => t == props.row.id).length
                        "
                      >
                        {{
                          groupContracts
                            .map((t) => t.facility_group.id)
                            .filter((t) => t == props.row.id).length
                        }}
                      </span>
                      <span class="mr-3" v-else>
                        {{ 0 }}
                      </span>
                      <i
                        class="far fa-car mr-1 text-info"
                        v-tooltip="`Vehicles`"
                      ></i>
                      <span
                        v-if="
                          groupVehicles && groupVehicles.length > 0 &&
                            groupVehicles
                              .map((t) => t && t.facility_group_id)
                              .filter((t) => t == props.row.id).length
                        "
                      >
                        {{
                          groupVehicles
                            .map((t) => t.facility_group.id)
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
                          :load="log(groupProjects)"
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
                              groupContracts && groupContracts.length > 0 &&
                                groupContracts
                                  .map((t) => t && t.facility_group)
                                  
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
                        <span v-if="groupContracts && groupContracts.length > 0">
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
                      <div class="col">
                        <h5 class="mh-orange-text">
                          Vehicles
                          <span
                            v-if="
                              groupVehicles && groupVehicles.length > 0 &&
                                groupVehicles
                                  .map((t) => t && t.facility_group)
                                  
                            "
                            class="badge badge-secondary badge-pill pill"
                            >{{
                              groupVehicles
                                .map((t) => t.facility_group_id)
                                .filter((t) => t == props.row.id).length
                            }}
                          </span>
                          <span
                            v-else
                            class="badge badge-secondary badge-pill pill"
                            >{{ 0 }}
                          </span>
                        </h5>
                        <span v-if="groupVehicles && groupVehicles.length > 0">
                          <ul class="pl-3 mb-0">
                            <li
                              v-for="(item, i) in groupVehicles.filter(
                                (t) => t.facility_group_id == props.row.id
                              )"
                              :key="i"
                            >
                              {{ item.contract_vehicle.name }}
                            </li>
                          </ul>
                        </span>
                      </div>
                    </div>
                  </div>
                </template>
              </el-table-column>
              <el-table-column label="Actions"  align="right" v-if="_isallowed('delete') || _isallowed('write')">
                <template slot-scope="scope">
                  <el-button
                    size="small"
                    type="default"
                    v-tooltip="`Save`"
                    @click.prevent="saveEdits(scope.$index, scope.row)"
                    v-if="
                      scope.$index == rowIndex
                    "
                    class="bg-primary btn-sm text-light"
                  >
                    <i class="far fa-save"></i>
                  </el-button>
                  <el-button
                    size="small"
                    type="default"
                    v-tooltip="`Cancel Edit`"
                    v-if="
                      scope.$index == rowIndex 
                    "
                    @click.prevent="cancelEdits(scope.$index, scope.row)"
                    class="bg-secondary  btn-sm text-light"
                  >
                    <i class="fas fa-ban"></i>
                  </el-button>
                  <el-button
                    size="small"
                    type="default"
                    v-tooltip="`Edit Program Group`"
                    @click.prevent="editMode(scope.$index, scope.row)"
                    v-if="
                      !scope.row.isPortfolio &&
                      scope.$index !== rowIndex &&  _isallowed('write')
                    "
                    class="bg-light btn-sm "
                  >
                    <i class="fal fa-edit text-primary"></i>
                  </el-button>
                  <el-button
                   size="small"
                    type="default" 
                    class="bg-light btn-sm"
                    v-tooltip="'Remove Portfolio Group'"            
                    @click.prevent="removeGroup(scope.$index, scope.row)"
                    v-if="
                      scope.$index !== rowIndex &&
                        scope.row.isPortfolio && _isallowed('delete')
                    "        
                  >                  
                    <i class="fa-light fa-circle-minus text-danger"></i>                   
                  </el-button>
                  <el-button
                    size="small"
                    type="default" 
                    v-tooltip="'Delete Program Group'"            
                    @click.prevent="removeGroup(scope.$index, scope.row)"
                    v-if="!scope.row.isDefault &&
                      scope.$index !== rowIndex &&
                        !scope.row.isPortfolio && _isallowed('delete')
                    "
                    class="bg-light btn-sm"
                  >    
                <i class="far fa-trash-alt text-danger "></i>                           
                  </el-button>
                  
                </template>
              </el-table-column>
              
            </el-table>
          </div>
            <div v-else class="text-danger mx-2 mt-5">
              <h5> <i>Sorry, you don't have read-permissions for this page! Please contact your Program Administrator for access.</i></h5>
            </div>
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
// List of all Portfolio Groups (Just the names) this.groups  ---DONE
// Button for Add Protfolio Groups  --DONE
// Filter out Groups that were created at Program Level -- DONE
// If I click on group, it saves the names to Program table and Portfolio Group stays checked
// It will not contain groups that were created in Program -- DONE
import { mapGetters, mapMutations, mapActions } from "vuex";
import SettingsSidebar from "./SettingsSidebar.vue";
import FormTabs from "../../shared/FormTabs.vue";
export default {
  name: "SettingsGroups",
  components: {
    SettingsSidebar,
    FormTabs,
  },

    data() {    
      return {
      searchGroups: '',
      currentFacility: {},
      dialogVisible: false,
      dialog2Visible: false,
      isIndeterminate: true,
      currentTab: "tab1",
      currentFacilityGroup: {},
      componentKey: 0,
      confirmTransfer: false,
      rowIndex: null,
      rowId: null,
      transferGroupBack: null,
      newGroupName: null,
      programId: this.$route.params.programId,
      hideSaveBtn: false,
      search: "",
      selectedProjectGroup: null,
      expanded: {
        id: "",
      },
    };
  },
  methods: {
    ...mapMutations([
      "setProjectGroupFilter",
      "setContractTable",
      "setGroupFilter",
      "SET_GROUP_STATUS",
      "SET_TRANSFER_DATA",
      "SET_NEW_GROUPS",
      "SET_CHECKED_PORTFOLIO_GROUPS",
      "SET_CHECK_ALL",
      "SET_CHECKED_GROUPS",
    ]),
    ...mapActions([
      "createGroup",
      "fetchFacilityGroups",
      "updateGroupName",
      "removeOrDeleteGroup",
      "updateGroup",
      "fetchGroups",
      "fetchContracts",
      "fetchVehicles",
      "fetchCurrentProject",
    ]),
    log(e){
      console.log(e)
    },
       tableRowClassName({row, rowIndex}) {
        if (!row.isPortfolio) {
          return 'warning-row';
        } 
    },
   cancelCreateGroup() {
      this.dialogVisible = false;
    },
    addAnotherGroup() {
      this.C_projectGroupFilter = null;
      this.newGroupName = null;
      this.hideSaveBtn = false;
    },
    handleCheckAllChange() {
      this.isIndeterminate = false;
    },
    reRenderTable() {
      this.componentKey += 1;
    },
    closeAddGroupBtn() {
      this.dialogVisible = false;
      this.hideSaveBtn = false;
    },
    editMode(index, rows) {
      this.rowIndex = index;
      this.rowId = rows.id;
    },
    closeImportGroupBtn() {
      this.dialog2Visible = false;
      this.SET_CHECKED_PORTFOLIO_GROUPS([0]);
    },
    addGroup() {
      this.dialogVisible = true;
      this.newGroupName = null;
      this.C_projectGroupFilter = null;
    },
    openPortfolioGroup() {
      this.dialog2Visible = true;
      console.log(this.groupContracts)
     },
    onChangeTab(tab) {
      this.currentTab = tab ? tab.key : "tab1";
      // console.log(this.currentTab)
    },
    saveEdits(index, rows) {
       let id = rows.id;
      let groupNameData = {
        newNameData: {
          name: rows.name,
        },
        project_id: this.$route.params.programId,
      };
      this.updateGroupName({
        ...groupNameData,
        id        
      });
      this.rowIndex = null;
      this.rowId = null;
    },
    cancelEdits(index, rows) {
      this.rowIndex = null;
      this.rowId = null;
      // console.log(this.facilityGroups)
    },
    createNewGroup() {
      let groupData = {
        group: {
          name: this.newGroupName,
          project_id: this.$route.params.programId,
        },
      };
      this.createGroup({
        ...groupData,
      });
      this.hideSaveBtn = true;
    },
    removeGroup(index, rows) {
      // let id = [rows.id];
      let group = {
        g: {
          id: rows.id,
          programId: this.$route.params.programId,
          },
       };      
    if(rows.isPortfolio){
      this.$confirm(
        `Are you sure you want to remove ${rows.name} from your program?`,
        "Confirm Remove",
        {
          confirmButtonText: "Remove",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
       ).then(() => {
        this.removeOrDeleteGroup({ ...group });
      });
      } else 
       this.$confirm(
        `Are you sure you want to delete ${rows.name} from your program?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
       ).then(() => {
        this.removeOrDeleteGroup({ ...group });
      });     
    },
    importGroupName() {
      let data = this.checkedPortfolioGroups;
      if (this.facilityGroups && this.facilityGroups.length > 0) {
        let savedGroups = this.facilityGroups.map((g) => g.id);
        for (let i = 0; i <= this.facilityGroups.length; i++) {
          if (savedGroups[i] !== undefined) {
            data.push(savedGroups[i]);
          }
        }
      }
      let group = {
        groupData: {
          ids: [...new Set(data)],
          programId: this.$route.params.programId,
        },
      };

      this.updateGroup({
        ...group,
      });
      this.confirmTransfer = false;
    },
    handleClick(tab, event) {
      console.log(tab, event);
    },
    _isallowed(salut) {
     return this.checkPrivileges("SettingsGroups", salut, this.$route, {settingType: "Groups"})    
    },
  },
  mounted() {
  if(this.groups && this.groups.length <= 0){
    this.fetchGroups(this.$route.params.programId);
    }
    this.fetchContracts(this.$route.params.programId);
    this.fetchVehicles(this.$route.params.programId);  
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "facilities",
      "groups",
      "contracts",
      "vehicles",
      "groupStatus",
      "getNewGroups",
      "getTransferData",
      "getContractTable",
      "getGroupFilter",
      "getProjectGroupFilter",
      "facilityGroupFacilities",
      "facilityGroups",
      "currentProject",
      "getCheckedPortfolioGroups",
      "getCheckAll",
      "getCheckedGroups",
    ]),
    // checkedGroups:{
    //   get(){
    //     return this.getCheckedGroups;
    //   },
    //   set(value){
    //     this.SET_CHECKED_GROUPS(value)
    //   }
    // },
    checkedPortfolioGroups: {
      get() {
        return this.getCheckedPortfolioGroups;
      },
      set(value) {
        let checkedCount = value.length;

        // this.SET_CHECK_ALL(checkedCount === this.portfolioGroups.length);
        this.SET_CHECKED_PORTFOLIO_GROUPS(value);
        this.isIndeterminate =
          checkedCount > 0 && checkedCount < this.portfolioGroups.length;
      },
    },
    checkAll: {
      get() {
        return this.getCheckAll;
      },
      set(value) {
        // console.log(value);
        this.SET_CHECK_ALL(value);
        if (value == true) {
          let checkGroups = this.groups.map((group) => group.id);
          this.SET_CHECKED_PORTFOLIO_GROUPS(checkGroups);
        } else if (value == false) {
          this.SET_CHECKED_PORTFOLIO_GROUPS([0]);
        }
      },
    },
    backToSettings() {
      return `/programs/${this.$route.params.programId}/settings`;
    },
    C_groupFilter: {
      get() {
        return this.getGroupFilter;
      },
      set(value) {
        // console.log(value)
        this.setGroupFilter(value);
      },
    },

    // generateData() {
    //   const data = [];
    //   // let newGroup = [];
    //   let eachGroup = (eachGroup = this.groups.map((g) => g));
    //   if (this.groups && this.groups.length > 0) {
    //     for (let i = 0; i <= this.groups.length; i++) {
    //       if (eachGroup[i] !== undefined) {
    //         data.push({
    //           key: eachGroup[i].id,
    //           label: eachGroup[i].name,
    //           // disabled: eachGroup[i].id == this.inheritedGroups[i]
    //         });
    //       }
    //     }
    //   }
    //   return [...new Set(data)];
    // },

    // myProgramGroups() {
    //   const data = this.getCheckedPortfolioGroups;
    //   if (this.groups && this.groups.length > 0) {
    //     let myInheritedGroups = this.groups.filter(
    //       (t) => t && t.id == data.map((t) => t)
    //     );
    //     for (let i = 0; i <= myInheritedGroups.length; i++) {
    //       if (myInheritedGroups[i] !== undefined) {
    //         data.push(myInheritedGroups[i].id);
    //         console.log(myInheritedGroups[i]);
    //       }
    //     }
    //   }

    //   return [...new Set(data)];
    // },
    // transferData: {
    //   get() {
    //     return [...new Set(this.myProgramGroups)];
    //   },
    //   set(value) {
    //     this.SET_TRANSFER_DATA(value);
    //     if (
    //       this.groups &&
    //       this.groups.length > 0
    //       //  this.getTransferData &&
    //       //  this.getTransferData.length > 0
    //     ) {
    //       let newGroups = this.groups.filter((u) =>
    //         this.getTransferData.includes(u.id)
    //       );
    //       this.SET_NEW_GROUPS([newGroups]);
    //     }
    //   },
    // },
    portfolioGroups() {
      //Removes current Program  Groups from checkbox options in Add Protfolio Group popup
      if (this.groups && this.groups.length > 0) {
       let filteredGroups = this.groups.filter(
          (pG) => !this.tableData.map((g) => g.id).includes(pG.id))
       let data = filteredGroups.sort((a, b) => a.name.localeCompare(b.name)).filter(t => {
          if (this.searchGroups !== '' && t) {           
              return (            
                t.name.toLowerCase().match(this.searchGroups.toLowerCase()) 
              ) 
          } else return true
          })
          return data
      }
    },
    tableData() {
      if (this.facilityGroups && this.facilityGroups.length > 0) {
        return this.facilityGroups;
      } else return [];
    },
    groupProjects() {
      let facilities = this.facilities.filter(f => f.facilityName != "" || f.facilityName != null)
      if (
        facilities &&
        facilities.length &&
        facilities.length > 0
      ) {
        return facilities;
      }
    },
    groupContracts() {
    let contracts = this.contracts.filter(f => f.name != "" && f.name != null && f.name != 'null')
     if (contracts && contracts.length > 0) {
          // console.log(contracts)
          return contracts
      } else return []
    },
    groupVehicles() {
      let vehicles = this.vehicles.filter(f => f.contract_vehicle.name != "" && f.contract_vehicle.name != null && f.contract_vehicle.name != 'null')
     if (vehicles && vehicles.length > 0) {
          // console.log(vehicles)
          return vehicles
      } else return []
    },
    // groupContracts() {
      // contracts array no longer in currentProject response
    //   if (
    //     this.currentProject &&
    //     this.currentProject.contracts &&
    //     this.currentProject.contracts.length > 0
    //   ) {
    //     return this.currentProject.contracts;
    //   }
    // },
    C_projectGroupFilter: {
      get() {
        return this.getProjectGroupFilter;
      },
      set(value) {
        // console.log(value)
        this.setProjectGroupFilter(value);
      },
    },
  },
  watch: {
    contentLoaded: {
      handler() {
        if (this.$route.params.projectId) {
          this.currentFacility = this.facilities.find(
            (facility) => facility.facilityId == this.$route.params.projectId
          );
        }
      },
    },
    groupStatus: {
      handler() {
        if (this.groupStatus == 200) {
          MessageDialogService.showDialog({
            message: `Saved successfully.`,
            
            
          });
          this.SET_GROUP_STATUS(0);
          this.fetchGroups(this.$route.params.programId);
          this.fetchCurrentProject(this.$route.params.programId);
          this.fetchContracts(this.$route.params.programId);
          this.fetchVehicles(this.$route.params.programId)
          //  this.newGroupName =
        }
      },
    },
    facilities: {
      handler() {
        this.currentFacility = this.facilities.find(
          (facility) => facility.facilityId == this.$route.params.projectId
        );
      },
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
::v-deep.el-table th.el-table__cell > .cell {
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
::v-deep.el-table__row .el-input .el-input__inner {
  border-style: none;
}
::v-deep.el-table {
  font-size: 16px;
}
::v-deep.hover-row .el-input .el-input__inner {
  border-style: solid;
}

.container {
  margin-left: 50px;
}

// Move el-transfer styles to Common file if more files require same CSS
::v-deep.el-transfer-panel {
  width: 400px;
  padding-bottom: 30px;
}
::v-deep.el-transfer-panel__header {
  font-size: 1.5rem;
  text-transform: uppercase;
  font-weight: 600 !important;
}
::v-deep.el-transfer-panel__body {
  min-height: 400px;
  margin-bottom: 30px;
}
::v-deep.el-transfer-panel__list {
  min-height: 425px;
}
::v-deep.el-checkbox__input.is-disabled + span.el-checkbox__label {
  color: #1d336f !important;
  cursor: default;
}
::v-deep.el-transfer-panel .el-transfer-panel__header {
  background-color: #ededed;
}
::v-deep.el-table {
   .warning-row {
    background: oldlace;
  }

  ::placeholder {
    /* Chrome, Firefox, Opera, Safari 10.1+ */
    color: lightgray;
    font-family: "FuturaPTBook";
  }
}
::v-deep.el-input__inner {
  font-size: 1.1rem;
}

::v-deep.el-button.confirm-save-group-names {
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
.addGroupsHeader, h5 {
  line-height: 2.2;
  word-break: break-word;
}

.portfolioNames {
  ::v-deep.el-dialog__header {
    padding-top: 0 !important;
  }
  ::v-deep.el-dialog__headerbtn {
    display: none;
  }

  ::v-deep.el-dialog__body {
    padding-top: 0 !important;
    height: 68vh; 
  }

  ::v-deep.el-checkbox-group {
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
.createNewGroup{
  ::v-deep.el-dialog__body {
  padding-top: 0 !important;
 }
 ::v-deep.el-dialog {
  width: 30%;  
 }
}

::v-deep.el-dialog__close.el-icon.el-icon-close{
  display: none;
}
.add-groups-header{
  background-color: #fff;
}
.modalBtns {
  box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
}
.fs-50{
font-size: .50rem;
}
.program-sphere {
  width: 10px;
  height: 10px;
  border-radius: 50%;  
  background: -webkit-radial-gradient(65% 15%, circle, white 1px, aqua 3%, darkblue 60%, aqua 100%); 
  background: -moz-radial-gradient(65% 15%, circle, white 1px, aqua 3%, darkblue 60%, aqua 100%); 
  background: -o-radial-gradient(65% 15%, circle, white 1px, aqua 3%, darkblue 60%, aqua 100%);
  background: radial-gradient(circle at 65% 15%, white 1px, aqua 3%, darkblue 60%, aqua 100%); 
}
</style>
