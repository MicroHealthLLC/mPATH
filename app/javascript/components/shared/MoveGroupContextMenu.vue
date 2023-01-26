<template>
    <div
      class="context-menu"
      v-show="show"
      :style="style"
      ref="context"
      tabindex="0"
      @mouseleave="close"
      >
    <!-- Nothing to see here -->
      <el-menu collapse class="context-menu-inner">
        <hr />
        <el-submenu index="1" v-if="$route.params.programId">
          <template slot="title"><i class="fa-sharp fa-copy pr-1"></i> Duplicate Group to Another Program </template>
          <div>
            <div class="menu-subwindow-title">Duplicate Group to Another Program</div>
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
                Save
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
        <el-submenu index="2" v-if="$route.params.programId">
          <template slot="title"><i class="far fa-share-from-square pr-1"></i> Move Group to Another Program</template>
          <div>
            <div class="menu-subwindow-title">Move Group to Another Program</div>
            <el-input
              class="filter-input"
              :placeholder="placeholder"
              v-model="filterTree"
            ></el-input>
            <el-tree
              :data="treeFormattedData"
              class="treeFormattedData"
              :props="defaultProps"
              :filter-node-method="filterNode"
              ref="movetree"       
              @node-click="move"
            >
            </el-tree>
            <div class="context-menu-btns">
              <button
                class="btn btn-sm btn-success ml-2"
                @click="confirmGroupMove"         
              >
                Confirm Move
              </button>
                      
            </div>
          </div>
        </el-submenu>
        <!-- <hr />
        <el-menu-item @click="deleteTask" :disabled="!isAllowed('delete', 'tasks')"
          >Delete</el-menu-item
        > -->
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
    name: "MoveGroupContextMenu",
    props: {
      display: Boolean, // prop detect if we should show context menu,
      group: Object,  
      groupId: Number   
    },
    data() {
      return {
        left: 0, // left position
        top: 0, // top position
        show: false, // affect display of context menu
        target_program_id: null, 
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
      ...mapGetters(["currentProject", "getUnfilteredFacilities", "projectContracts", "filteredFacilityGroups", "portfolioPrograms", "moveGroupStatus"]),
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
        } else return "Filter Programs & Groups"
      },
     treeFormattedData() {
      if(this.portfolioPrograms && this.portfolioPrograms.length > 0){
        let data = [];
        this.portfolioPrograms.filter(t => t.program_id != this.$route.params.programId).forEach((program, index) => {
          // console.log("treeFormattedData", program)    
          data.push({
            id: index,
            program_id: program.program_id,
            label: program.label,        
          });
        });

      return [...data]  
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
      ...mapActions(["taskDeleted", "fetchPortfolioPrograms", "moveGroup", "fetchCurrentProject"]),
      ...mapMutations(["updateTasksHash", "updateContractTasks", "updateVehicleTasks", "SET_MOVE_GROUP_STATUS"]),
      // log(e){
      //   console.log(e)
      // },
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
            if (response.status === 200) {
              this.$message({
                message: `${this.task.text} was duplicated successfully.`,
                type: "success",
                showClose: true,
              });
            }
          })
          .catch((err) => {
            this.$message({
              message: `Unable to duplicate ${this.task.text}. Please try again.`,
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
      console.log("move", node)
      this.target_program_id = node.program_id  
      },
      confirmGroupMove(){
      let data = {
          group:{
            groupId: this.groupId,
            sourceProgramId: this.$route.params.programId,
            targetProgramId: this.target_program_id
          }           
        }
        this.moveGroup({...data})
        console.log("this works", data)
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
            if (response.status === 200) {
              this.$message({
                message: `${this.task.text} was duplicated successfully to selected projects.`,
                type: "success",
                showClose: true,
              });
            }
          })
          .catch((err) => {
            this.$message({
              message: `Unable to duplicate ${this.task.text} to selected projects. Please try again.`,
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
        console.log(data)
        console.log(value)
        return data.label.toLowerCase().indexOf(value.toLowerCase()) !== -1;
      },
      deleteTask() {
        // console.log(this.task)
        let task = this.task
        let programId = this.$route.params.programId
        this.$confirm(`Are you sure you want to delete ${this.task.text}?`, 'Confirm Delete', {
            confirmButtonText: 'Delete',
            cancelButtonText: 'Cancel',
            type: 'warning'
          }).then(() => {
            this.taskDeleted({task, programId}).then((value) => {
              if (value === 'Success') {
                this.$message({
                  message: `${this.task.text} was deleted successfully.`,
                  type: "success",
                  showClose: true,
                });
              }
            });
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
    mounted() {
    this.fetchPortfolioPrograms()
  },
    watch: {
      filterTree(value) {
        console.log(value)
        this.$refs.duplicatetree.filter(value);
        this.$refs.movetree.filter(value);
      },
      moveGroupStatus: {
      handler() {
        if (this.moveGroupStatus == 200) {

          console.log("Group move worked")
          this.$message({
            message: `Group moved successfully.`,
            type: "success",
            showClose: true,
          });
          this.SET_MOVE_GROUP_STATUS(0);
          this.fetchCurrentProject(this.$route.params.programId);      
        }
      },
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
    width: 14.5vw;
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

  ::v-deep .el-tree-node.is-selected {  
   background-color: black !important;
   } 
  

  
  </style>