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
      <el-menu-item @click="openTask">Open</el-menu-item>
      <hr />
      <el-menu-item
        v-if="$route.params.projectId"
        @click="createDuplicate"
        :disabled="!isAllowed('write', 'tasks')"
        >Duplicate</el-menu-item
      >
      <el-submenu index="1" v-if="$route.params.projectId">
        <template slot="title">Duplicate to... </template>
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
              @click="duplicateSelectedTasks"
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
      <el-submenu index="2" :disabled="!isAllowed('delete', 'tasks')"  v-if="$route.params.projectId">
        <template slot="title"> Move to...</template>
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
      <el-menu-item @click="deleteTask" :disabled="!isAllowed('delete', 'tasks')"
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
    // facilityGroups: Array,
    task: Object,
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
    ...mapGetters(["currentProject", "getUnfilteredFacilities", "projectContracts", "filteredFacilityGroups",]),
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
                (facility) => this.isAllowedFacility("write", 'task_project_context_menu', {facility_project_id: facility.id}) && facility.facility.id !== this.task.facilityId
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
      // debugger
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
                    (contract) => this.isAllowedFacility("write", 'task_contract_context_menu', {project_contract_id: contract.projectContractId} ) && contract.projectContractId !== this.task.projectContractId
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
                    (vehicle) => this.isAllowedFacility("write", 'task_vehicle_context_menu', {project_contract_vehicle_id: vehicle.projectContractVehicleId} ) && vehicle.projectContractVehicleId !== this.task.projectContractVehicleId
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
    },
  },
  methods: {
    ...mapActions(["taskDeleted"]),
    ...mapMutations(["updateTasksHash", "updateContractTasks", "updateVehicleTasks"]),
    log(e){
      console.log(e)
    },
    isAllowed(salut) {
      return this.checkPrivileges("task_form", salut, this.$route)
    },
    isAllowedFacility(salut, module, extraData) {
      return this.checkPrivileges(module, salut, this.$route, extraData)  
    },
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
    openTask() {
      this.$emit("open-task", this.task);
      this.close();
    },
    moveTask(task, facilityProjectId) {
      // if (!this.isAllowed("write", 'tasks')) return;
      this.$validator.validate().then((success) => {
        if (!success || this.loading) {
          this.showErrors = !success;
          return;
        }

        this.loading = true;
        let formData = new FormData();
      
        if (this.$route.params.contractId) {
             formData.append("task[project_contract_id]", task.projectContractId);
         } else if (this.$route.params.vehicleId) {
             formData.append("task[project_contract_vehicle_id]", task.projectContractVehicleId);
         } else {
             formData.append("task[facility_project_id]", facilityProjectId);
         }

         let url;
         let method;
        if (this.$route.params.contractId) {
             method = "PATCH";
             url =  `${API_BASE_PATH}/project_contracts/${this.$route.params.contractId}/tasks/${this.task.id}.json`;
         } else if (this.$route.params.vehicleId) {
             method = "PATCH";
             url =  `${API_BASE_PATH}/project_contract_vehicles/${this.$route.params.vehicleId}/tasks/${this.task.id}.json`;
         } else {
             method = "PUT";
             url = `${API_BASE_PATH}/programs/${this.currentProject.id}/projects/${task.facilityId}/tasks/${task.id}.json`;
         }
         let callback = "task-updated";

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
            let responseTask = humps.camelizeKeys(response.data.task);
            this.$emit(callback, responseTask);

           if (this.$route.params.contractId){
               this.updateContractTasks({ task: responseTask });
            } else if (this.$route.params.vehicleId){
               this.updateVehicleTasks({ task: responseTask });
            } else {
              this.updateFacilities(
              responseTask,
              facilityProjectId
            );
            }           
            MessageDialogService.showDialog({
              response: response
            });
          })
          .catch((err) => {
            console.log("Error",err);
          })
          .finally(() => {
            this.loading = false;
            this.updateTasksHash({ task: task, action: "delete" });
             this.updateContractTasks({ task: task, action: "delete" });
             this.updateVehicleTasks({ task: task, action: "delete" });
          });
      });
    },
    updateFacilities(updatedTask, id) {
      var facilities = this.getUnfilteredFacilities;

      facilities.forEach((facility) => {
        if (facility.facilityProjectId === id) {
          facility.tasks.push(updatedTask);
        }
      });
    },
  updateContracts(updatedTask) {
      var contracts = this.currentProject.contracts;
      contracts.forEach((c) => {       
          c.tasks.push(updatedTask);
    
      });
    },
    updateVehicles(updatedTask) {
      var vehicles = this.currentProject.vehicles;
      vehicles.forEach((c) => {       
          c.tasks.push(updatedTask);
    
      });
    },
    updateFacilityTask(task) {
      var facilities = this.getUnfilteredFacilities;

      var facilityIndex = facilities.findIndex(
        (item) => item.facilityProjectId === task.facilityProjectId
      );

      facilities[facilityIndex].tasks.push(task);
    },
    createDuplicate() {
      let url;
      if (this.$route.params.contractId) {
          url =  `${API_BASE_PATH}/contracts/${this.$route.params.contractId}/tasks/${this.task.id}/create_duplicate.json`;
      } if (this.$route.params.vehicleId) {
          url =  `${API_BASE_PATH}/vehicles/${this.$route.params.vehicleId}/tasks/${this.task.id}/create_duplicate.json`;
      } else {
          url = `${API_BASE_PATH}/programs/${this.currentProject.id}/projects/${this.task.facilityId}/tasks/${this.task.id}/create_duplicate.json`;
      }
      let method = "POST";
      let callback = "task-created";

      let formData = new FormData();
      formData.append("id", this.task.id);

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
          let responseTask = humps.camelizeKeys(response.data.task);
          this.$emit(callback, humps.camelizeKeys(response.data.task));

          if (this.$route.params.contractId){
              this.updateContractTasks({
               task: responseTask 
              });
            } else if (this.$route.params.vehicleId){
              this.updateVehicleTasks({
               task: responseTask 
              });
            } else {
              this.updateFacilityTask(
              responseTask,
              this.task.facilityProjectId
             );
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
    selectAllNodes() {
      this.$refs.duplicatetree.setCheckedNodes(this.treeFormattedData);
    },
    clearAllNodes() {
      this.$refs.duplicatetree.setCheckedNodes([]);
    },
    move(node) {
      this.moveTask(this.task, node.id);
        console.log(node.id)
        console.log(this.task)
      
      // if (!node.hasOwnProperty("children")) {
      //   this.moveTask(this.task, node.id);
      //   // console.log(node.id)
      // }
    },
    duplicateSelectedTasks() {
      this.submitted = true;

      var facilityNodes = this.$refs.duplicatetree
        .getCheckedNodes()
        .filter((item) => !item.hasOwnProperty("children"));

      var ids = facilityNodes.map((facility) => facility.id);

      let url;
      if (this.$route.params.contractId) {
          url =  `${API_BASE_PATH}/contracts/${this.$route.params.contractId}/tasks/${this.task.id}/create_bulk_duplicate?`;
      } else if (this.$route.params.vehicleId) {
          url =  `${API_BASE_PATH}/vehicles/${this.$route.params.vehicleId}/tasks/${this.task.id}/create_bulk_duplicate?`;
      } else {
          url = `${API_BASE_PATH}/programs/${this.currentProject.id}/projects/${this.task.facilityId}/tasks/${this.task.id}/create_bulk_duplicate?`;
      }
     
      let method = "POST";
      let callback = "task-created";

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
          url += `vehicle_ids[]=${id}`;
        } else if (index !== 0 && this.$route.params.vehicleId)  {
          url += `&vehicle_ids[]=${id}`;
        }
      });

      let formData = new FormData();
          formData.append("id", this.task.id);
      if ( this.$route.params.contractId){
         formData.append("contract_ids", ids);
      } else if ( this.$route.params.vehicleId){
         formData.append("vehicle_ids", ids);
      } else {
       formData.append("facility_project_ids", ids);
      } 

  // debugger
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
          // let responseTask ;
          this.$emit(callback, humps.camelizeKeys(response.data.task) );
          // debugger
                     
         if (this.$route.params.contractId){
            response.data.tasks.forEach((task) => {
                 console.log(`task: ${task}`)
                this.updateContractTasks({
                task: humps.camelizeKeys(task)
               });
              });
           
         } else if (this.$route.params.vehicleId){
            response.data.tasks.forEach((task) => {
                 console.log(`task: ${task}`)
                this.updateVehicleTasks({
                task: humps.camelizeKeys(task)
               });
              });
           
         } else {
           response.data.tasks.forEach((task) => {
              this.updateFacilityTask(
              humps.camelizeKeys(task),
              task.facilityProjectId
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
    deleteTask() {
      // console.log(this.task)
      let task = this.task
      let programId = this.$route.params.programId
      this.$confirm(`Are you sure you want to delete ${this.task.text}?`, 'Confirm Delete', {
          confirmButtonText: 'Delete',
          cancelButtonText: 'Cancel',
          type: MessageDialogService.msgTypes.WARNING
        }).then(() => {
          this.taskDeleted({task, programId}).then((value) => {
            if (value === 'Success') {
              MessageDialogService.showDialog({
                message: `${this.task.text} was deleted successfully.`,
                
                
              });
            }
          });
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
}.context-menu-inner{
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