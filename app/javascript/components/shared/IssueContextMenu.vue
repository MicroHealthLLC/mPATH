<template>
  <div
    class="context-menu"
    v-show="show"
    :style="style"
    ref="context"
    tabindex="0"
    @mouseleave="close"
  >
    <el-menu collapse class="context-menu-inner">
      <el-menu-item @click="openIssue">Open</el-menu-item>
      <hr />
      <el-menu-item
       v-if="$route.params.projectId"
        @click="createDuplicate"
        :disabled="!isAllowed('write', 'issues')"
        >Duplicate</el-menu-item
      >
      <el-submenu index="1" v-if="$route.params.projectId">
        <template slot="title">Duplicate to...
        </template>
        <div>
          <div class="menu-subwindow-title">Duplicate to...</div>
          <el-input
            class="filter-input"
            :placeholder="placeholder"
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
      <el-submenu index="2" :disabled="!isAllowed('delete', 'issues')"  v-if="$route.params.projectId">
        <template slot="title">Move to...
        </template>
        <div>
          <div class="menu-subwindow-title">Move to...</div>
          <el-input
            class="filter-input"
            :placeholder="placeholder"
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
    ...mapGetters(["currentProject", "getUnfilteredFacilities", "filteredFacilityGroups"]),
    // get position of context menu
    style() {
      return {
        top: this.top + "px",
        left: this.left + "px",
      };
    },
    placeholder(){
      if(this.$route.params.contractId){
        return "Filter Contracts"
      } else if(this.$route.params.vehicleId){
        return "Filter Vehicles"
      } else return "Filter Projects"
    },
    treeFormattedData() {
    if(this.$route.params.projectId){
        let data = [];
        this.filteredFacilityGroups.forEach((group, index) => {
          data.push({
            id: index,
            label: group.name,
            children: [
              ...group.facilities
                .filter(
                  (facility) => this.isAllowedFacility("write", 'issue_project_context_menu', {facility_project_id: facility.id}) && facility.facility.id !== this.issue.facilityId
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
    }
       if(this.$route.params.contractId){
          let data = [];
        let contractGroups = this.currentProject.contracts
          this.facilityGroups.forEach((group, index) => {
            data.push({
              id: index,
              label: group.name,         
              children: [
                  ...contractGroups.filter(t => t.facilityGroup.id == group.id)
                  .filter(
                    (contract) => this.isAllowedFacility("write", 'issue_contract_context_menu', {project_contract_id: contract.projectContractId}) && contract.projectContractId !== this.issue.projectContractId
                  )
                  .map((contract) => {
                    return {
                      id: contract.projectContractId,
                      label: contract.name,
                    };
                  }),
              ],
            });
          });
          // debugger
      return [...data];    
     }

     if(this.$route.params.vehicleId){
          let data = [];
        let vehicleGroups = this.currentProject.vehicles
          this.facilityGroups.forEach((group, index) => {
            data.push({
              id: index,
              label: group.name,         
              children: [
                  ...vehicleGroups.filter(t => t.facilityGroup.id == group.id)
                  .filter(
                    (vehicle) => this.isAllowedFacility("write", 'issue_vehicle_context_menu', {project_contract_vehicle_id: vehicle.projectContractVehicleId}) && vehicle.projectContractVehicleId !== this.issue.projectContractVehicleId
                  )
                  .map((vehicle) => {
                    return {
                      id: vehicle.projectContractVehicleId,
                      label: vehicle.name,
                    };
                  }),
              ],
            });
          });
          // debugger
      return [...data];    
     }
   
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
    ...mapMutations(["updateIssuesHash", "updateContractIssues", "updateVehicleIssues"]),
    isAllowed(salut) {
      return this.checkPrivileges("issue_form", salut, this.$route)
     },
     isAllowedFacility(salut, module, extraData) {
      return this.checkPrivileges(module, salut, this.$route, extraData)  
    },
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
      // if (!this.isAllowed("write", 'issues')) return;
      this.$validator.validate().then((success) => {
        if (!success || this.loading) {
          this.showErrors = !success;
          return;
        }

        this.loading = true;
        let formData = new FormData();

        if (this.$route.params.contractId) {
           formData.append("issue[contract_id]", facilityProjectId);
         } else if (this.$route.params.vehicleId) {
           formData.append("issue[contract_vehicle_id]", facilityProjectId);
         } else {
            formData.append("issue[facility_project_id]", facilityProjectId);
         }
        let url;
        let method;
        if (this.$route.params.contractId) {
             method = "PATCH";
             url =  `${API_BASE_PATH}/project_contracts/${issue.projectContractId}/issues/${issue.id}.json`;
              console.log(`issue.id: ${issue.projectContractId}`)
         } else if (this.$route.params.vehicleId) {
             method = "PATCH";
             url =  `${API_BASE_PATH}/project_contract_vehicles/${issue.projectContractVehicleId}/issues/${issue.id}.json`;
              console.log(`issue.id: ${issue.projectContractVehicleId}`)
         } else {
             method = "PUT";
             url = `${API_BASE_PATH}/programs/${this.currentProject.id}/projects/${issue.facilityId}/issues/${issue.id}.json`;
         }
     
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
            let responseIssue = humps.camelizeKeys(response.data.issue)
            debugger
            this.$emit(callback, responseIssue );
            
           if (this.$route.params.contractId){
               this.updateContractIssues({ issue: responseIssue });
            } else if (this.$route.params.vehicleId){
               this.updateVehicleIssues({ issue: responseIssue });
            } else {
            this.updateFacilities(
              humps.camelizeKeys(response.data.issue),
              facilityProjectId
             );
            }            
            MessageDialogService.showDialog({
              response: response
            });
          })
          .catch((err) => {
            // var errors = err.response.data.errors
            console.log("Error",err);
          })
          .finally(() => {
            this.loading = false;
            this.updateIssuesHash({ issue: issue, action: "delete" });
            this.updateContractIssues({ issue: issue, action: "delete" });
            this.updateVehicleIssues({ issue: issue, action: "delete" });
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
      let url;
      if (this.$route.params.contractId) {
          url =  `${API_BASE_PATH}/contracts/${this.$route.params.contractId}/issues/${this.issue.id}/create_duplicate.json`;
      } else if (this.$route.params.vehicleId) {
          url =  `${API_BASE_PATH}/vehicles/${this.$route.params.vehicleId}/issues/${this.issue.id}/create_duplicate.json`;
      } else {
          url =`${API_BASE_PATH}/programs/${this.currentProject.id}/projects/${this.issue.facilityId}/issues/${this.issue.id}/create_duplicate.json`;
      }
      
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
          let responseIssue = humps.camelizeKeys(response.data.issue)
      
          this.$emit(callback, responseIssue );
          
          if (this.$route.params.contractId){
              this.updateContractIssues({
               issue: responseIssue 
              });
            } else if (this.$route.params.vehicleId){
              this.updateVehicleIssues({
               issue: responseIssue 
              });
            } else {
             this.updateFacilityIssue(
            responseIssue,
            this.issue.facilityProjectId
            );
          }
          MessageDialogService.showDialog({
            response: response
          });
        })
        .catch((err) => {
          // var errors = err.response.data.errors
          console.log("Error",err);
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
        console.log(node.id)
      }
    },
    duplicateSelectedIssues() {
      this.submitted = true;

      var facilityNodes = this.$refs.duplicatetree
        .getCheckedNodes()
        .filter((item) => !item.hasOwnProperty("children"));

      var ids = facilityNodes.map((facility) => facility.id);

      
      let url;
      if (this.$route.params.contractId) {
          url =  `${API_BASE_PATH}/contracts/${this.$route.params.contractId}/issues/${this.issue.id}/create_bulk_duplicate?`;
      } else if (this.$route.params.vehicleId) {
          url =  `${API_BASE_PATH}/vehicles/${this.$route.params.vehicleId}/issues/${this.issue.id}/create_bulk_duplicate?`;
      } else {
          url = `${API_BASE_PATH}/programs/${this.currentProject.id}/projects/${this.issue.facilityId}/issues/${this.issue.id}/create_bulk_duplicate?`;
      }

      let method = "POST";
      let callback = "issue-created";

  
      ids.forEach((id, index) => {
        if (index === 0 && this.$route.params.projectId) {
          url += `facility_project_ids[]=${id}`;
        } else if (index !== 0 && this.$route.params.projectId)  {
          url += `&facility_project_ids[]=${id}`;
        } if (index === 0 && this.$route.params.contractId) {
          url += `contract_ids[]=${id}`;
        } else if (index !== 0 && this.$route.params.contractId)  {
          url += `&contract_ids[]=${id}`;
        } if (index === 0 && this.$route.params.vehicleId) {
          url += `contract_vehicle_ids[]=${id}`;
        } else if (index !== 0 && this.$route.params.vehicleId)  {
          url += `&contract_vehicle_ids[]=${id}`;
        } 
      });

     let formData = new FormData();
         formData.append("id", this.issue.id);

      if ( this.$route.params.contractId){
         formData.append("contract_ids", ids); 
      } else if ( this.$route.params.vehicleId){
         formData.append("contract_vehicle_ids", ids); 
      } else {
          formData.append("facility_project_ids", ids);      
      } 

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

       if (this.$route.params.contractId){
            response.data.issues.forEach((issue) => {
                //  console.log(`task: ${task}`)
                this.updateContractIssues({
                issue: humps.camelizeKeys(issue)
               });
              });
           
         } else if (this.$route.params.vehicleId){
            response.data.issues.forEach((issue) => {
                //  console.log(`task: ${task}`)
                this.updateVehicleIssues({
                issue: humps.camelizeKeys(issue)
               });
              });
           
         } else {
             response.data.issues.forEach((issue) => {
            this.updateFacilityIssue(
              humps.camelizeKeys(issue),
              issue.facilityProjectId
            );
          });
         }
          MessageDialogService.showDialog({
            response: response              
          });
        })
        .catch((err) => {
          console.log("Error",err);
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
      let issue = this.issue
      let programId = this.$route.params.programId
      this.$confirm(`Are you sure you want to delete ${issue.title}?`, 'Confirm Delete', {
          confirmButtonText: 'Delete',
          cancelButtonText: 'Cancel',
          type: MessageDialogService.msgTypes.WARNING
        }).then(() => {
          this.issueDeleted({ issue, programId }).then((value) => {
            if (value === 'Success') {
              MessageDialogService.showDialog({
                message: `${issue.title} was deleted successfully.`,
                
                
              });
            }
          })
        }).catch(() => {
          MessageDialogService.showDialog({
            type: MessageDialogService.msgTypes.INFO,            message: 'Delete canceled',
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
.context-menu-inner{
  width: 10vw;
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