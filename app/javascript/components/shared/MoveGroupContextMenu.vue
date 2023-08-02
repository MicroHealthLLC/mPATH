<template>
    <div
      class="context-menu"
      v-show="show"
      :load="log(currentProject)"
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
            <div class="menu-subwindow-title px-2">Duplicate <span class="text-info px-1"> {{ sourceGroupName }}</span> group to Another Program</div>
            <el-input
              class="filter-input"
              :placeholder="placeholder"
              v-model="filterTree"
            ></el-input>
            <el-tree        
              :data="treeFormattedData"
              :props="defaultProps"
              :filter-node-method="filterNode"
              @node-click="duplicateSelection" 
              ref="duplicatetree"
              node-key="id"
            >
            </el-tree>
            <div class="context-menu-btns">
              <button
                class="btn btn-sm btn-success ml-2"
                @click="confirmGroupDuplicate" 
                :disabled="submitDisabled"
              >
                Confirm Duplicate
              </button>  
            </div>
          </div>
        </el-submenu>
        <hr />   
        <el-submenu index="2" v-if="$route.params.programId">
          <template slot="title"><i class="far fa-share-from-square pr-1"></i> Move Group to Another Program</template>
          <div>
            <div class="menu-subwindow-title px-2">Move <span class="text-info px-1"> {{ sourceGroupName }}</span> group to Another Program</div>
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
      ...mapGetters(["currentProject", "getUnfilteredFacilities", "projectContracts", "filteredFacilityGroups", "authorizedPortfolioPrograms", "moveGroupStatus", "duplicateGroupStatus"]),
      // get position of context menu
      style() {
        return {
          top: this.top + "px",
          left: this.left + "px",
        };
      },
      sourceGroupName(){
        if(this.currentProject && this.currentProject.facilities  && this.currentProject.facilities.length > 0 && this.groupId){
          return this.currentProject.facilities.filter(t => t.facilityGroupId == this.groupId)[0].facility.facilityGroupName
        }
      },
      placeholder(){
        if(this.$route.params.contractId){
          return "Filter Contracts"
        } else if(this.$route.params.vehicleId){
          return "Filter Vehicles"
        } else return "Filter Programs & Groups"
      },
     treeFormattedData() {
      if(this.authorizedPortfolioPrograms && this.authorizedPortfolioPrograms.length > 0){
        let data = [];
        this.authorizedPortfolioPrograms.filter(t => t.program_id != this.$route.params.programId).forEach((program, index) => {
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
      ...mapActions(["taskDeleted", "fetchAuthorizedPortfolioPrograms", "moveGroup", "duplicateGroup","fetchCurrentProject"]),
      ...mapMutations(["updateTasksHash", "updateContractTasks", "updateVehicleTasks", "SET_MOVE_GROUP_STATUS", "SET_DUPLICATE_GROUP_STATUS"]),
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
      move(node) {
      console.log("move", node)
      this.target_program_id = node.program_id  
      },
      duplicateSelection(node) {
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
      confirmGroupDuplicate(){
      let data = {
          group:{
            groupId: this.groupId,
            sourceProgramId: this.$route.params.programId,
            targetProgramId: this.target_program_id
          }           
        }
        this.duplicateGroup({...data})
        console.log("this works", data)
      },   
      filterNode(value, data) {
        if (!value) return true;
        console.log(data)
        console.log(value)
        return data.label.toLowerCase().indexOf(value.toLowerCase()) !== -1;
      }, 
      toggleSubmitBtn() {
        this.submitted = false;
      },
    },
    mounted() {
    this.fetchAuthorizedPortfolioPrograms()
    this.fetchCurrentProject(this.$route.params.programId); 
    },
    watch: {
      filterTree(value) {
        console.log(value)
        this.$refs.duplicatetree.filter(value);
        this.$refs.movetree.filter(value);
      },
      sourceGroupName(){
        if(this.sourceGroupName){
          return this.sourceGroupName
        } else return 'Group'
      },
      moveGroupStatus: {
      handler() {
        if (this.moveGroupStatus == 200) {
          console.log("Group move worked")
          MessageDialogService.showDialog({
            message: `Group moved successfully.`,
            
            
          });
          this.SET_MOVE_GROUP_STATUS(0);
          this.fetchCurrentProject(this.$route.params.programId);      
        } 
        if (this.moveGroupStatus == 401 ) {        
          MessageDialogService.showDialog({
          message: `Sorry. You need to be a Program Admin in target program to make this move.`,
          type: MessageDialogService.msgTypes.WARNING
        }); 
        this.SET_MOVE_GROUP_STATUS(0);
        }
        if (this.moveGroupStatus == 406 ) {
          MessageDialogService.showDialog({
          message: `Warning.  Group successfully moved, but not all projects were included.`,
          type: "info"
        }); 
        this.SET_MOVE_GROUP_STATUS(0);
        this.fetchCurrentProject(this.$route.params.programId);      
        }
        if (this.moveGroupStatus == 500 ) {        
          MessageDialogService.showDialog({
          message: `Sorry. This group already exists in target program.`,
          type: MessageDialogService.msgTypes.WARNING
        }); 
        this.SET_MOVE_GROUP_STATUS(0);
        }                
      },
      },
      duplicateGroupStatus: {
      handler() {
        if (this.duplicateGroupStatus == 200) {
          console.log("Group move worked")
          MessageDialogService.showDialog({
            message: `Group duplicated successfully.`,
            
            
          });
          this.SET_DUPLICATE_GROUP_STATUS(0);
          this.fetchCurrentProject(this.$route.params.programId);      
        } 
        if (this.duplicateGroupStatus == 401 ) {        
          MessageDialogService.showDialog({
          message: `Sorry. You need to be a Program Admin in target program to duplicate.`,
          type: MessageDialogService.msgTypes.WARNING
        }); 
        this.SET_DUPLICATE_GROUP_STATUS(0);
        }
        if (this.duplicateGroupStatus == 406 ) {
          MessageDialogService.showDialog({
          message: `Warning.  Group successfully duplicated, but not all projects were included.`,
          type: "info"
        }); 
        this.SET_DUPLICATE_GROUP_STATUS(0);
        this.fetchCurrentProject(this.$route.params.programId);      
        }
        if (this.duplicateGroupStatus == 500 ) {        
          MessageDialogService.showDialog({
          message: `Sorry. This group already exists in target program.`,
          type: MessageDialogService.msgTypes.WARNING
        }); 
        this.SET_DUPLICATE_GROUP_STATUS(0);
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
  }
  .context-menu-inner{
    width: 17.5vw;
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
    max-width: 400px;
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