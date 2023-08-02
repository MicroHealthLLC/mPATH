<template>
    <div
      class="context-menu"
       v-show="show"
      :style="style"
      ref="context"
      tabindex="0"
      @mouseleave="close"
      :load="log(sourceProjectName)"
      
    >
      <el-menu collapse class="context-menu-inner">
        <hr />
        <el-submenu index="1" v-if="$route.params.programId">
          <template slot="title"><i class="fa-sharp fa-copy pr-1"></i> Duplicate Project to Another Program </template>
          <div>
            <div class="menu-subwindow-title px-2">Duplicate <span class="text-info px-1"> {{ sourceProjectName }}</span> to Another Program</div>
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
                @click="confirmProjectDuplicate"  
               :disabled="submitDisabled"
              >
                Confirm Dupllicate
              </button>          
            </div>
          </div>
        </el-submenu>
        <hr />   
        <el-submenu index="2" v-if="$route.params.programId">
          <template slot="title"><i class="far fa-share-from-square pr-1"></i> Move Project to Another Program</template>
          <div>
            <div class="menu-subwindow-title px-2">Move <span class="text-info px-1"> {{ sourceProjectName }}</span> to Another Program</div>
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
              class="filter-tree"            
              @node-click="move"
            >
            </el-tree>
             <div class="context-menu-btns">
              <button
                class="btn btn-sm btn-success ml-2"
                @click="confirmProjectMove"         
              >
                Confirm Move
              </button>
                      
            </div>
          </div>
        </el-submenu>
      </el-menu> 
    </div>
</template>


<script>
  import Vue from "vue";
  import { mapGetters, mapActions, mapMutations } from "vuex";
  
  export default {
    name: "MoveProjectContextMenu",
    props: {
      display: Boolean, // prop detect if we should show context menu,
      facilities: Array,    
      projectId: Number   
    },
    data() {
      return {
        left: 0, // left position
        top: 0, // top position
        show: false, // affect display of context menu
        target_program_id: null, 
        target_group_id: null, 
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
      ...mapGetters([
        "currentProject",
        "getUnfilteredFacilities",
        "projectContracts",
        "filteredFacilityGroups", 
        "portfolioPrograms",
        "exportProjectStatus",
        "duplicateProjectStatus",
        "authorizedPortfolioPrograms"
      ]),
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
      sourceProjectName(){
        if(this.currentProject && this.currentProject.facilities  && this.currentProject.facilities.length > 0 && this.projectId){
          return this.currentProject.facilities.filter(t => t.facilityId == this.projectId)[0].facilityName
        }
      },
     treeFormattedData() {
      if(this.authorizedPortfolioPrograms && this.authorizedPortfolioPrograms.length > 0){
        let data = [];
        this.authorizedPortfolioPrograms.filter(t => t.program_id != this.$route.params.programId).forEach((program, index) => {    
          data.push({
            id: index,
            label: program.label,      
            targetProgramId: program.program_id,       
            children: [
              ...program.children          
                .map((group) => {
                  return {
                    id: group.project_group_id,
                    targetGroupId: group.project_group_id,
                    targetProgramId: program.program_id,        
                    label: group.label,
                  };
                }),
            ],
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
      ...mapActions([
        "taskDeleted", 
        "fetchAuthorizedPortfolioPrograms",
        "exportProject", 
        "duplicateProject", 
        "fetchCurrentProject"
      ]),
      ...mapMutations([
        "updateTasksHash",
        "updateContractTasks", 
        "updateVehicleTasks", 
        "SET_EXPORT_PROJECT_STATUS", 
        "SET_DUPLICATE_PROJECT_STATUS"
      ]),
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
      updateFacilities(updatedTask, id) {
        var facilities = this.getUnfilteredFacilities;
  
        facilities.forEach((facility) => {
          if (facility.facilityProjectId === id) {
            facility.tasks.push(updatedTask);
          }
        });
      },
      clearAllNodes() {
        this.$refs.duplicatetree.setCheckedNodes([]);
      },
      move(node) {
      console.log("move", node)
      this.target_program_id = node.targetProgramId,
      this.target_group_id = node.targetGroupId      
      },
      duplicateSelection(node) {
        console.log("move", node)
        this.target_program_id = node.targetProgramId,
        this.target_group_id = node.targetGroupId      
      },
      confirmProjectMove(){
      let data = {
          project:{
            projectId: this.projectId ,
            sourceProgramId: this.$route.params.programId,
            targetProgramId: this.target_program_id,
            targetGroupId: this.target_group_id
          }           
        }
         if(this.$route.params.projectId == this.projectId){
            this.$router.push(`/programs/${this.$route.params.programId}/sheet/`)
          } 
        this.exportProject({...data})
        console.log("this works", data)
      },
      confirmProjectDuplicate(){
      let data = {
          project:{
            projectId: this.projectId ,
            sourceProgramId: this.$route.params.programId,
            targetProgramId: this.target_program_id,
            targetGroupId: this.target_group_id
          }           
        }
       this.duplicateProject({...data})
        console.log("this works", data)
      },
    filterNode(value, data) {
        if (!value) return true;
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
        this.$refs.duplicatetree.filter(value);
        this.$refs.movetree.filter(value);
      },
      sourceProjectName(){
        if(this.sourceProjectName){
          return this.sourceProjectName
        } else return 'Project'
      },
      exportProjectStatus: {
      handler() {
        if (this.exportProjectStatus == 200) {
          MessageDialogService.showDialog({
            message: `Project moved successfully.`,
            
            
          });
          this.SET_EXPORT_PROJECT_STATUS(0);               
          this.fetchCurrentProject(this.$route.params.programId);  
        }
        if (this.exportProjectStatus == 401 ) {        
          MessageDialogService.showDialog({
          message: `Sorry. You need to be a Program Admin in target program to make this move.`,
          type: MessageDialogService.msgTypes.WARNING
        }); 
        this.SET_EXPORT_PROJECT_STATUS(0);
        }    
        if (this.exportProjectStatus == 406 ) {        
          MessageDialogService.showDialog({
          message: `Sorry. This project already exists in target program.`,
          type: MessageDialogService.msgTypes.WARNING
        }); 
        this.SET_EXPORT_PROJECT_STATUS(0);
        }   
        if (this.exportProjectStatus == 404 ) {        
          MessageDialogService.showDialog({
          message: `Sorry. Something went wrong.`,
          type: "danger"
        }); 
        this.SET_EXPORT_PROJECT_STATUS(0);
        }              
      },
    },
    duplicateProjectStatus: {
      handler() {
        if (this.duplicateProjectStatus == 200) {
          MessageDialogService.showDialog({
            message: `Project duplicate successful.`,
            
            
          });
          this.SET_DUPLICATE_PROJECT_STATUS(0);
          this.fetchCurrentProject(this.$route.params.programId);      
        }
        if (this.duplicateGroupStatus == 401 ) {        
          MessageDialogService.showDialog({
          message: `Sorry. You need to be a Program Admin in target program to duplicate.`,
          type: MessageDialogService.msgTypes.WARNING
        }); 
        this.SET_DUPLICATE_PROJECT_STATUS(0);
        }
        if (this.duplicateGroupStatus == 404 ) {
          MessageDialogService.showDialog({
          message: `Sorry.  Something went wrong.`,
          type: "danger"
        }); 
        this.SET_DUPLICATE_PROJECT_STATUS(0);
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
  </style>