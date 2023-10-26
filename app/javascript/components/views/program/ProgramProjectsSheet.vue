<template>
 <div class="my-1 pb-2 buttonWrapper container-fluid">
  <div class="row px-0 mb-2">
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
            v-for="item in facilityGroups"
            :key="item.id"
            :label="item.name"
            :value="item"
          >
          </el-option>
        </el-select>
      </div>
  </div>
      
  <div
   v-if="projectData"
    v-loading="!contentLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)" 
  >
    <hr class="mt-2 mb-0">
    <el-table
      :key="componentKey"   
      v-if="projectData && projectData.length > 0"
      :data="projectData.filter((data) => !search ||
        data.facilityName.toLowerCase().includes(search.toLowerCase())).reverse()"
      style="width: 100%"
      height="500"
      stripe
    >
      <el-table-column 
        prop="facilityName"  
        sortable 
        label="Project" 
        fixed  
        width="230"
        >
        <template slot-scope="scope">
          <!-- <el-input
            size="small"
            style="text-align:center"
            v-model="scope.row.facilityName"
            controls-position="right"
          ></el-input> -->
          {{ scope.row.facilityName }}
        </template>
      </el-table-column>
          <el-table-column 
            prop="address"  
            sortable 
            label="Address" 
            width="250">
            <template slot-scope="scope">
              <!-- <el-input
                size="small"
                style="text-align:center"
                v-if="scope.row.address"
                v-model="scope.row.address"
                controls-position="right"
              ></el-input>

               <span v-else> <i> Edit in Program Settings </i> </span> -->
             <span v-if="scope.row.address">
               {{ scope.row.address }} 
            </span>
           <span v-else> <i> Not Available </i> </span>
            </template>
          </el-table-column>
          <el-table-column 
                prop="pointOfContact"  
                sortable 
                label="Point Of Contact" 
                width="200">
            <template slot-scope="scope">
              <!-- <el-input
                size="small"
                style="text-align:center"
                v-if="scope.row.pointOfContact"
                v-model="scope.row.pointOfContact"
                controls-position="right"
              ></el-input>
              <span v-else> <i> Edit in Program Settings </i> </span> -->

              <span v-if="scope.row.pointOfContact">
               {{ scope.row.pointOfContact }}
            </span>
           <span v-else> <i> Not Available </i> </span>
            </template>
          </el-table-column>
          <el-table-column 
            prop="email"  
            sortable 
            label="POC Email" 
            width="200"
            >
            <template slot-scope="scope">
              <!-- <el-input
                size="small"
                style="text-align:center"
                v-model="scope.row.email"
                v-if="scope.row.email"
                controls-position="right"
              ></el-input>
              <span v-else> <i> Edit in Program Settings </i> </span> -->

            <span v-if="scope.row.email">
               {{ scope.row.email }}
            </span>
           <span v-else> <i> Not Available </i> </span>
            </template>
          </el-table-column>
          <el-table-column 
            prop="phoneNumber"  
            sortable 
            label="Phone Number" 
            width="200">
            <template slot-scope="scope">
              <!-- <el-input
                size="small"
                style="text-align:center"
                v-if="scope.row.phoneNumber"
                v-model="scope.row.phoneNumber"
                controls-position="right"
              ></el-input>
              <span v-else> <i> Edit in Program Settings </i> </span> -->
            <span v-if="scope.row.phoneNumber">
               {{ scope.row.phoneNumber }}
            </span>
           <span v-else> <i> Not Available </i> </span>
            </template>
          </el-table-column>
          <el-table-column
            prop="facilityGroupName"
            sortable
            filterable
            label="Group"
            width="230"
          >
            <template slot-scope="scope">
              <!-- <el-input
                size="small"
                style="text-align:center"
                v-model="scope.row.facilityGroupName"
              ></el-input> -->
            <span v-if="scope.row.facilityGroupName">
               {{ scope.row.facilityGroupName }}
            </span>
           <span v-else> <i> Not Available </i> </span>
            </template>
         
            
          </el-table-column>
          <el-table-column label="Actions"  width="300">
            <template slot-scope="scope">
              <!-- <el-button
                type="default"
                @click="saveEdits(scope.$index, scope.row)"
                class="bg-primary text-light"
                >Save</el-button
              >
           -->
              <el-button
                type="default"
                v-tooltip="`Go to Project`"
                @click.prevent="goToProject(scope.$index, scope.row)"
                class="bg-light"
              >
               <i class="fal fa-clipboard-list mh-green-text" style="font-size:1rem"></i> 
               <i class="fas fa-arrow-alt-circle-right ml-1 text-success"></i>
              </el-button>
       
              <!-- <el-button type="primary" @click="handleEditRow(scope.$index)">Edit</el-button> -->
            </template>
          </el-table-column>
    </el-table>
  </div>

     <span v-else class="mt-5">
      NO DATA TO DISPLAY   
     </span>
  </div> 
</template>

<script>
import axios from "axios";
import { mapActions, mapGetters, mapMutations } from "vuex";
import { API_BASE_PATH } from "./../../../mixins/utils";

export default {
  name: "ProgramProjectsSheet",
  props: ["currentFacility", "facility"],
  data() {
    return {
      dialogVisible: false,
      componentKey: 0,
      programId: this.$route.params.programId,
      search: "",
      projectId: null, 
      selectedProjectGroup: null,
      newProjectNameText: "",
      value: "",
     };
  },
  methods: {
    ...mapActions(["fetchFacilities", "fetchCurrentProject"]),
    ...mapMutations(["setProjectGroupFilter", "setGroupFilter"]),
    goToProject(index, rows) {
      console.log(index)
      console.log(rows)
      console.log("isMapView: " + this.isMapView)
      if (this.isMapView) {
        this.$router.push(`/programs/${this.$route.params.programId}/map/projects/${rows.id.toString()}`)
      } else {
        this.$router.push({
          name: "SheetProject",
          params: {
            programId: this.$route.params.programId,
            projectId: rows.id.toString(),
          },
        });
      }
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
          MessageDialogService.showDialog({
            message: `New Project ${this.newProjectName} has been saved successfully.`,
            
            
          });
          this.dialogVisible = false;
          this.fetchCurrentProject(this.programId)
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
          MessageDialogService.showDialog({
            message: `Edits has been saved successfully.`,
            
            
          });
          this.fetchCurrentProject(this.programId)
        }
      });
    },
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "currentProject",
      "projectsLoaded",
      "facilities",
      "facilityGroups",
      "tableData",
      "getProjectGroupFilter",
      "getGroupFilter",
      "facilityGroupFacilities",
      "filteredFacilityGroups",
    ]),
    isMapView() {
      return this.$route.name.includes("Map");
    },
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
    projectData() {
      if (
        // this.projectsLoaded &&
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
::v-deep.el-table th.el-table__cell > .cell {
  color: #212529;
  font-size: 1rem;
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
::v-deep.hover-row .el-input .el-input__inner {
  border-style: none;
}
::v-deep.el-dialog {
  width: 30%;
  border-top: solid 5px #1d336f !important;
}
::v-deep.el-table {
  .el-input__inner {
    font-size: 16px !important;
  }
    overflow-x: auto !important;

}
::v-deeptd.el-table__cell{
  word-wrap: break-word;
  word-break: break-all;
  table-layout: fixed;
}
.overflowX {
  overflow-x: auto !important;
}
::v-deep.el-dialog__close.el-icon.el-icon-close {
  background-color: #dc3545;
  border-radius: 50%;
  color: white;
  padding: 2px;
  font-size: 0.7rem;
}
</style>

