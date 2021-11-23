<template>
  <div
    v-loading="!contentLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)"
    class="row"
  >
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
            <i class="fal fa-clipboard-list mr-1 mh-orange-text"></i> PROJECTS
          </h4>
        </el-breadcrumb>

        <div class="my-1 pb-2 buttonWrapper container-fluid">
          <div class="row px-0">
            <div class="col">
              <el-button
                @click.prevent="addProject"
                class="bg-primary text-light mb-2"
              >
                <i class="far fa-plus-circle mr-1"></i> Add Project
              </el-button>
            </div>

            <div class="col">
              <el-input
                type="search"
                placeholder="Search Projects"
                aria-label="Search"
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
                v-model="C_groupFilter"
                track-by="id"
                value-key="id"
                multiple
                filterable
                clearable
                name="Project Group"
                placeholder="Filter Projects By Group"
              >
                <el-option
                  v-for="item in filteredFacilityGroups"
                  :key="item.id"
                  :label="item.name"
                  :value="item"
                >
                </el-option>
              </el-select>
            </div>
          </div>
        </div>

        <el-table
          v-if="tableData && tableData.length > 0"
          :data="
            tableData
              .filter(
                (data) =>
                  !search ||
                  data.facilityName.toLowerCase().includes(search.toLowerCase())
              )
              .reverse()
          "
          style="width: 100%"
          height="450"
        >
          <el-table-column prop="facilityName" sortable label="Project">
            <template slot-scope="scope">
              <el-input
                size="small"
                style="text-align:center"
                v-model="scope.row.facilityName"
                controls-position="right"
              ></el-input>
            </template>
          </el-table-column>
          <el-table-column
            prop="facilityGroupName"
            sortable
            filterable
            label="Group"
          >
            <template slot-scope="scope">
              <el-input
                size="small"
                style="text-align:center"
                :key="componentKey"
                v-model="scope.row.facilityGroupName"
              ></el-input>
            </template>
          </el-table-column>

          <el-table-column label="Actions">
            <template slot-scope="scope">
              <el-button
                type="default"
                @click="saveEdits(scope.$index, scope.row)"
                class="bg-primary text-light"
                >Save</el-button
              >
              <el-button
                type="default"
                @click="goToProject(scope.$index, scope.row)"
                class="bg-success text-light"
              >
                Go To Project <i class="fas fa-arrow-alt-circle-right ml-1"></i>
              </el-button>
              <!-- <el-button type="primary" @click="handleEditRow(scope.$index)">Edit</el-button> -->
            </template>
          </el-table-column>
        </el-table>
        <el-dialog
          :visible.sync="dialogVisible"
          append-to-body
          center
          class="contractForm p-0"
        >
          <form accept-charset="UTF-8">
            <div class="form-group mx-4">
              <label class="font-md"
                >New Project Name <span style="color: #dc3545">*</span></label
              >
              <el-input
                type="textarea"
                v-model="newProjectNameText"
                placeholder="Enter new project name"
                rows="1"
                name="Project Name"
              />
            </div>
            <div class="form-group mx-4">
              <label class="font-md">Group</label>
              <el-select
                class="w-100"
                v-model="C_projectGroupFilter"
                track-by="id"
                value-key="id"
                clearable
                filterable
                name="Project Group"
                placeholder="Select Group"
              >
                <el-option
                  v-for="item in filteredFacilityGroups"
                  :key="item.id"
                  :label="item.name"
                  :value="item"
                >
                </el-option>
              </el-select>
            </div>
            <div class="right mr-2">
              <el-button
                @click.prevent="saveNewProject"
                class="bg-primary text-light mr-2"
                >Save</el-button
              >
            </div>
          </form>
        </el-dialog>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { mapActions, mapGetters, mapMutations } from "vuex";
import SettingsSidebar from "./SettingsSidebar.vue";
import { API_BASE_PATH } from "./../../../mixins/utils";

export default {
  name: "SettingsProjects",
  components: {
    SettingsSidebar,
  },
  data() {
    return {
      dialogVisible: false,
      programId: this.$route.params.programId,
      search: "",
      selectedProjectGroup: null,
      newProjectNameText: "",
      value: "",
      expanded: {
        id: "",
      },
    };
  },
  mounted() {
    if (this.$route.params) {
      this.fetchFacilities(this.$route.params.programId);
    }
  },
  methods: {
    ...mapActions(["fetchFacilities"]),
    ...mapMutations(["setProjectGroupFilter", "setGroupFilter"]),
    goToProject(index, rows) {
      this.$router.push(
        `/programs/${this.$route.params.programId}/sheet/projects/${rows.id}/project`
      );
    },
    addProject() {
      this.dialogVisible = true;
      this.C_projectGroupFilter = null;
      this.newProjectNameText = "";
    },
    saveNewProject(e) {
      e.preventDefault();
      let formData = new FormData();
      formData.append("facility[facility_name]", this.newProjectNameText);
      if (this.C_projectGroupFilter !== null) {
        formData.append(
          "facility[facility_group_id]",
          this.C_projectGroupFilter.id
        );
      }
      formData.append("facility[address]", "18 Boon Rd, Stow, MA 01775, USA");
      formData.append("facility[lat]", "42.4114459");
      formData.append("facility[lng]", "-71.5128223");
      formData.append("facility[point_of_contact]", "Juan Rivera");
      formData.append("facility[phone_number]", "+16789009876");
      formData.append("facility[country_code]", "US");
      formData.append("facility[email]", "test@test.com");
      formData.append("facility[status]", "active");
      formData.append("facility[project_ids][]", this.$route.params.programId);
      formData.append("commit", "Create Project");
      let url = `${API_BASE_PATH}/programs/${this.$route.params.programId}/projects`;
      let method = "POST";
      axios({
        method: method,
        url: url,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      }).then((response) => {
        if (response.status === 200) {
          this.$message({
            message: `New Project ${this.newProjectName} has been saved successfully.`,
            type: "success",
            showClose: true,
          });
          this.dialogVisible = false;
          this.fetchFacilities(this.programId);
        }
      });
    },
    saveEdits(index, rows) {
      let updatedProjectName = rows.facilityName;
      let updatedGroupName = rows.facilityGroupName;
      let projectId = rows.id;
      let formData = new FormData();
      formData.append("facility[facility_name]", updatedProjectName);
      // Need one url to support these two data name edits
      formData.append("facility[facility_group_name]", updatedGroupName);
      let url = `${API_BASE_PATH}/programs/${this.$route.params.programId}/projects/${projectId}`;
      let method = "PUT";
      axios({
        method: method,
        url: url,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      }).then((response) => {
        if (response.status === 200) {
          this.$message({
            message: `Edits has been saved successfully.`,
            type: "success",
            showClose: true,
          });
          this.fetchFacilities(this.programId);
        }
      });
    },
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "projectsLoaded",
      "facilities",
      "getProjectGroupFilter",
      "getGroupFilter",
      "facilityGroupFacilities",
      "filteredFacilityGroups",
    ]),
    // Filter for Projects Table
    C_groupFilter: {
      get() {
        return this.getGroupFilter;
      },
      set(value) {
        // console.log(value)
        this.setGroupFilter(value);
      },
    },
    backToSettings() {
      return `/programs/${this.$route.params.programId}/settings`;
    },
    // Filter when adding new Project
    C_projectGroupFilter: {
      get() {
        return this.getProjectGroupFilter;
      },
      set(value) {
        // console.log(value)
        this.setProjectGroupFilter(value);
      },
    },
    tableData() {
      if (
        this.projectsLoaded &&
        this.facilities &&
        this.facilities.length > 0
      ) {
        return (
          this.facilities
            // .map((f) => f.facility)
            .filter((td) => {
              if (this.C_groupFilter && this.C_groupFilter.length > 0) {
                let group = this.C_groupFilter.map((t) => t.name);
                return group.includes(td.facilityGroupName);
              } else return true;
            })
        );
      }
    },
  },
};
</script>

<style scoped lang="scss">
.buttonWrapper {
  border-bottom: lightgray solid 1px;
}
.right {
  text-align: right;
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
/deep/.hover-row .el-input .el-input__inner {
  border-style: none;
}
/deep/.el-dialog {
  width: 30%;
  border-top: solid 5px #1d336f !important;
}
/deep/.el-table {
  .el-input__inner {
    font-size: 16px !important;
  }
}
/deep/.el-dialog__close.el-icon.el-icon-close {
  background-color: #dc3545;
  border-radius: 50%;
  color: white;
  padding: 2px;
  font-size: 0.7rem;
}
</style>
