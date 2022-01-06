<template>
  <div
    class="context-menu"
    v-show="show"
    :style="style"
    ref="context"
    tabindex="0"
    @mouseleave="close"
  >
    <el-menu collapse>
      <el-menu-item @click="openIssue">Open</el-menu-item>
      <hr />
      <el-menu-item
        @click="createDuplicate"
        :disabled="!isAllowed('write', 'issues')"
        >Duplicate</el-menu-item
      >
      <el-submenu index="1" :disabled="!isAllowed('write', 'issues')">
        <template slot="title">
          <span slot="title">Duplicate to...</span>
        </template>
        <div>
          <div class="menu-subwindow-title">Duplicate to...</div>
          <el-input
            class="filter-input"
            placeholder="Filter Projects..."
            v-model="filterTree"
          ></el-input>
          <el-tree
            :data="treeFormattedData"
            :props="defaultProps"
            :filter-node-method="filterNode"
            @check-change="toggleSubmitBtn"
            show-checkbox
            ref="duplicatetree"
            node-key="id"
          >
          </el-tree>
          <div class="context-menu-btns">
            <button
              class="btn btn-sm btn-success ml-2"
              @click="duplicateSelectedIssues"
              :disabled="submitDisabled"
            >
              Submit
            </button>
            <button class="btn btn-sm btn-primary ml-2" @click="selectAllNodes">
              Select All
            </button>
            <button
              class="btn btn-sm btn-outline-secondary ml-2"
              @click="clearAllNodes"
            >
              Clear All
            </button>
          </div>
        </div>
      </el-submenu>
      <hr />
      <el-submenu index="2" :disabled="!isAllowed('write', 'issues')">
        <template slot="title">
          <span slot="title">Move to...</span>
        </template>
        <div>
          <div class="menu-subwindow-title">Move to...</div>
          <el-input
            class="filter-input"
            placeholder="Filter Projects..."
            v-model="filterTree"
          ></el-input>
          <el-tree
            :data="treeFormattedData"
            :props="defaultProps"
            :filter-node-method="filterNode"
            ref="movetree"
            @node-click="move"
          >
          </el-tree>
        </div>
      </el-submenu>
      <hr />
      <el-menu-item @click="deleteIssue" :disabled="!isAllowed('delete', 'issues')"
        >Delete</el-menu-item
      >
    </el-menu>
  </div>
</template>

<script>
import Vue from "vue";
import { mapGetters, mapActions, mapMutations } from "vuex";
import axios from "axios";
import humps from "humps";
import {API_BASE_PATH} from './../../mixins/utils'

export default {
  name: "ContextMenu",
  props: {
    display: Boolean, // prop detect if we should show context menu,
    facilities: Array,
    facilityGroups: Array,
    issue: Object,
  },
  data() {
    return {
      left: 0, // left position
      top: 0, // top position
      show: false, // affect display of context menu
       defaultPrivileges:{
        admin: ['R', 'W', 'D'],
        contracts: ['R', 'W', 'D'],
        facility_id: this.$route.params.contractId,
        issues: ['R', 'W', 'D'],
        lessons: ['R', 'W', 'D'],
        notes: ['R', 'W', 'D'],
        overview: ['R', 'W', 'D'],
        risks: ['R', 'W', 'D'],
        tasks: ['R', 'W', 'D'],
      }, 
      defaultProps: {
        children: "children",
        label: "label",
        disabled: "disabled",
      },
      filterTree: "",
      submitted: false,
    };
  },
  computed: {
    ...mapGetters(["currentProject", "getUnfilteredFacilities"]),
    // get position of context menu
    style() {
      return {
        top: this.top + "px",
        left: this.left + "px",
      };
    },
    treeFormattedData() {
      var data = [];

      this.facilityGroups.forEach((group, index) => {
        data.push({
          id: index,
          label: group.name,
          children: [
            ...group.facilities
              .filter(
                (facility) => this.isAllowedFacility("write", 'issues', facility.facility.id) && facility.facility.id !== this.issue.facilityId
              )
              .map((facility) => {
                return {
                  id: facility.facilityProjectId,
                  label: facility.facilityName,
                };
              }),
          ],
        });
      });

      return [...data];
    },
    submitDisabled() {
      if (this.$refs.duplicatetree) {
        return (
          this.$refs.duplicatetree.getCheckedNodes().length === 0 ||
          this.submitted
        );
      } else {
        return this.submitted;
      }
    }
  },
  methods: {
    ...mapActions(["issueDeleted"]),
    ...mapMutations(["updateIssuesHash"]),
    isAllowed(salut) {
       if (this.$route.params.contractId) {
          return this.defaultPrivileges      
        } else {
        let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
        let permissionHash = {"write": "W", "read": "R", "delete": "D"}
        let s = permissionHash[salut]
        return fPrivilege.issues.includes(s); 
        }         
     },
     isAllowedFacility(salut, module, facility_id) {
       if (this.$route.params.contractId) {
          return this.defaultPrivileges
        } else {
          let fPrivilege = this.$projectPrivileges[this.$route.params.programId][facility_id]
          let permissionHash = {"write": "W", "read": "R", "delete": "D"}
          let s = permissionHash[salut];
          return fPrivilege[module].includes(s);
        }
      },
    // isAllowed(salut, module) {
    //   var programId = this.$route.params.programId;
    //   var projectId = this.$route.params.projectId
    //   let fPrivilege = this.$projectPrivileges[programId][projectId]
    //   let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    //   let s = permissionHash[salut]
    //   return  fPrivilege[module].includes(s); 
    // },
    // closes context menu
    close() {
      this.show = false;
      this.left = 0;
      this.top = 0;
    },
    open(evt) {
      // updates position of context menu
      this.left = evt.pageX || evt.clientX;
      this.top = evt.pageY || evt.clientY;
      //Prevents menu from getting clipped below window
      if (evt.clientY > window.innerHeight / 2) {
        this.top -= 200;
      }
      //Prevents menu from getting clipped on right side of window
      if (evt.clientX > window.innerWidth / 2) {
        this.left -= 195;
      }
      // make element focused
      // @ts-ignore
      Vue.nextTick(() => this.$el.focus());
      this.show = true;
    },
    openIssue() {
      this.$emit("open-issue", this.issue);
      this.close();
    },
    moveIssue(issue, facilityProjectId) {
      if (!this.isAllowed("write", 'issues')) return;
      this.$validator.validate().then((success) => {
        if (!success || this.loading) {
          this.showErrors = !success;
          return;
        }

        this.loading = true;
        let formData = new FormData();

        formData.append("issue[facility_project_id]", facilityProjectId);

        let url = `${API_BASE_PATH}/programs/${this.currentProject.id}/projects/${issue.facilityId}/issues/${issue.id}.json`;
        let method = "PUT";
        let callback = "issue-updated";

        axios({
          method: method,
          url: url,
          data: formData,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
              .attributes["content"].value,
          },
        })
          .then((response) => {
            this.$emit(callback, humps.camelizeKeys(response.data.issue));
            this.updateFacilities(
              humps.camelizeKeys(response.data.issue),
              facilityProjectId
            );
            if (response.status === 200) {
              this.$message({
                message: `${issue.title} was moved successfully.`,
                type: "success",
                showClose: true,
              });
            }
          })
          .catch((err) => {
            this.$message({
              message: `Unable to move ${issue.title}. Please try again.`,
              type: "error",
              showClose: true,
            });
            // var errors = err.response.data.errors
            console.log(err);
          })
          .finally(() => {
            this.loading = false;
            this.updateIssuesHash({ issue: issue, action: "delete" });
          });
      });
    },
    updateFacilities(updatedIssue, id) {
      var facilities = this.getUnfilteredFacilities;

      facilities.forEach((facility) => {
        if (facility.facilityProjectId === id) {
          facility.issues.push(updatedIssue);
        }
      });
    },
    updateFacilityIssue(issue) {
      var facilities = this.getUnfilteredFacilities;

      var facilityIndex = facilities.findIndex(
        (item) => item.facilityProjectId === issue.facilityProjectId
      );

      facilities[facilityIndex].issues.push(issue);
    },
    createDuplicate() {
      let url = `${API_BASE_PATH}/programs/${this.currentProject.id}/projects/${this.issue.facilityId}/issues/${this.issue.id}/create_duplicate.json`;
      let method = "POST";
      let callback = "issue-created";

      let formData = new FormData();
      formData.append("id", this.issue.id);

      axios({
        method: method,
        url: url,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((response) => {
          this.$emit(callback, humps.camelizeKeys(response.data.issue));
          this.updateFacilityIssue(
            humps.camelizeKeys(response.data.issue),
            this.issue.facilityProjectId
          );
          if (response.status === 200) {
            this.$message({
              message: `${this.issue.title} was duplicated successfully.`,
              type: "success",
              showClose: true,
            });
          }
        })
        .catch((err) => {
          this.$message({
            message: `Unable to duplicate ${this.issue.title}. Please try again.`,
            type: "error",
            showClose: true,
          });
          // var errors = err.response.data.errors
          console.log(err);
        })
        .finally(() => {
          // this.loading = false
        });
    },
    selectAllNodes() {
      this.$refs.duplicatetree.setCheckedNodes(this.treeFormattedData);
    },
    clearAllNodes() {
      this.$refs.duplicatetree.setCheckedNodes([]);
    },
    move(node) {
      if (!node.hasOwnProperty("children")) {
        this.moveIssue(this.issue, node.id);
      }
    },
    duplicateSelectedIssues() {
      this.submitted = true;

      var facilityNodes = this.$refs.duplicatetree
        .getCheckedNodes()
        .filter((item) => !item.hasOwnProperty("children"));

      var ids = facilityNodes.map((facility) => facility.id);

      let url = `${API_BASE_PATH}/programs/${this.currentProject.id}/projects/${this.issue.facilityId}/issues/${this.issue.id}/create_bulk_duplicate?`;
      let method = "POST";
      let callback = "issue-created";

      ids.forEach((id, index) => {
        if (index === 0) {
          url += `facility_project_ids[]=${id}`;
        } else {
          url += `&facility_project_ids[]=${id}`;
        }
      });

      let formData = new FormData();
      formData.append("id", this.issue.id);
      formData.append("facility_project_ids", ids);

      axios({
        method: method,
        url: url,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      })
        .then((response) => {
          this.$emit(callback, humps.camelizeKeys(response.data.issue));

          response.data.issues.forEach((issue) => {
            this.updateFacilityIssue(
              humps.camelizeKeys(issue),
              issue.facilityProjectId
            );
          });
          if (response.status === 200) {
            this.$message({
              message: `${this.issue.title} was duplicated successfully to selected projects.`,
              type: "success",
              showClose: true,
            });
          }
        })
        .catch((err) => {
          this.$message({
            message: `Unable to duplicate ${this.issue.title} to selected projects. Please try again.`,
            type: "error",
            showClose: true,
          });
          // var errors = err.response.data.errors
          console.log(err);
        })
        .finally(() => {
          // this.loading = false
        });
    },
    filterNode(value, data) {
      if (!value) return true;
      return data.label.toLowerCase().indexOf(value.toLowerCase()) !== -1;
    },
    deleteIssue() {
      this.$confirm(`Are you sure you want to delete ${this.issue.title}?`, 'Confirm Delete', {
          confirmButtonText: 'Delete',
          cancelButtonText: 'Cancel',
          type: 'warning'
        }).then(() => {
          this.issueDeleted(this.issue).then((value) => {
            if (value === 'Success') {
              this.$message({
                message: `${this.issue.title} was deleted successfully.`,
                type: "success",
                showClose: true,
              });
            }
          })
        }).catch(() => {
          this.$message({
            type: 'info',
            message: 'Delete canceled',
            showClose: true
          });          
        });
    },
    toggleSubmitBtn() {
      this.submitted = false;
    },
  },
  watch: {
    filterTree(value) {
      this.$refs.duplicatetree.filter(value);
      this.$refs.movetree.filter(value);
    },
  },
};
</script>

<style lang="scss" scoped>
.context-menu {
  position: fixed;
  background: white;
  z-index: 999;
  outline: none;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
  cursor: pointer;
}
hr {
  margin: 0;
}
.el-menu-item {
  padding: 10px;
  line-height: unset;
  height: unset;
  text-align: center;
  overflow-x: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
  &:hover {
    background-color: rgba(91, 192, 222, 0.3);
  }
}
.context-menu-btns,
.filter-input {
  padding: 10px;
}
.el-menu-item {
  padding-right: 30px;
}
.el-tree {
  padding: 10px;
  max-width: 300px;
  max-height: 300px;
  overflow-y: auto;
}
.menu-subwindow-title {
  font-size: 14px;
  text-align: center;
  margin-top: 10px;
}
</style>