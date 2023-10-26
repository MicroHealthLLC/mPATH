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
      <el-menu-item @click="openLesson(lesson.id)">Open</el-menu-item>
      <hr />
      <el-menu-item
        @click="deleteSelectedLesson"
        :disabled="!_isallowed('delete')"
        >Delete</el-menu-item
      >
    </el-menu>
  </div>
</template>

<script>
import { mapGetters, mapActions, mapMutations } from "vuex";

export default {
  name: "LessonContextMenu",
  props: {
    display: Boolean, // prop detect if we should show context menu,
    facilities: Array,
    facilityGroups: Array,
    lesson: Object,
    routeName: String,
  },
  data() {
    return {
      left: 0, // left position
      top: 0, // top position
      show: false, // affect display of context menu
      defaultPrivileges:{
        admin: ['R', 'W', 'D'],
        contracts: ['R', 'W', 'D'],
        vehicles: ['R', 'W', 'D'],
        facility_id: this.$route.params.contractId,
        issues: ['R', 'W', 'D'],
        lessons: ['R', 'W', 'D'],
        notes: ['R', 'W', 'D'],
        overview: ['R', 'W', 'D'],
        risks: ['R', 'W', 'D'],
        tasks: ['R', 'W', 'D'],
        }, 
    };
  },
  computed: {
    ...mapGetters(["getUnfilteredFacilities"]),
    style() {
      return {
        top: this.top + "px",
        left: this.left + "px",
      };
    },
  },
  methods: {
    ...mapActions(["deleteLesson", "deleteContractLesson", "deleteVehicleLesson"]),
    close() {
      this.show = false;
      this.left = 0;
      this.top = 0;
    },
    open(evt) {
      // updates position of context menu
      this.left = evt.pageX || evt.clientX;
      this.top = evt.pageY || evt.clientY;
      //Prevents menu from getting clipped on right side of window
      if (evt.clientX > window.innerWidth / 2) {
        this.left -= 195;
      }
      // make element focused
      Vue.nextTick(() => this.$el.focus());
      this.show = true;
    },
    openLesson(id) {

      if(this.$route.params.projectId){
        this.$router.push({
        name: this.routeName,
        params: {
          programId: this.$route.params.programId,
          projectId: this.$route.params.projectId,
          lessonId: id,
        },
      });

      } else if (this.$route.params.contractId){
        this.$router.push({
        name: this.routeName,
        params: {
          programId: this.$route.params.programId,
          contractId: this.$route.params.contractId,
          lessonId: id,
        },
      });
      } else if (this.$route.params.vehicleId){
        this.$router.push({
        name: this.routeName,
        params: {
          programId: this.$route.params.programId,
          vehicleId: this.$route.params.vehicleId,
          lessonId: id,
        },
      });
      }
      this.close();
    },
    deleteSelectedLesson() {
      if (this.$route.params.projectId){
      this.$confirm(
        `Are you sure you want to delete ${this.lesson.title}?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
      )
        .then(() => {
          this.deleteLesson({ id: this.lesson.id, ...this.$route.params });
        })
        .catch(() => {
          MessageDialogService.showDialog({
            type: MessageDialogService.msgTypes.INFO,            message: "Delete canceled",
            
          });
        });

      } else if (this.$route.params.contractId){
            this.$confirm(
        `Are you sure you want to delete ${this.lesson.title}?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
      )
        .then(() => {
          this.deleteContractLesson({ id: this.lesson.id, ...this.$route.params });
          // Move this message to store
          MessageDialogService.showDialog({
            message: `${this.lesson.title} is successfully deleted.`,
            
            
          });
        })
        .catch(() => {
          MessageDialogService.showDialog({
            type: MessageDialogService.msgTypes.INFO,            message: "Delete canceled",
            
          });
        });        
      } else if (this.$route.params.vehicleId){
            this.$confirm(
        `Are you sure you want to delete ${this.lesson.title}?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
      )
        .then(() => {
          this.deleteVehicleLesson({ id: this.lesson.id, ...this.$route.params });
          // Move this message to store
          MessageDialogService.showDialog({
            message: `${this.lesson.title} is successfully deleted.`,
            
            
          });
        })
        .catch(() => {
          MessageDialogService.showDialog({
            type: MessageDialogService.msgTypes.INFO,            message: "Delete canceled",
            
          });
        });        
      }   
    },
     _isallowed(salut) {
        return this.checkPrivileges("LessonContextMenu", salut, this.$route)

      //  if (this.$route.params.contractId) {
      //     return this.defaultPrivileges      
      //   } else {
      //   let fPrivilege = this.$projectPrivileges[this.$route.params.programId][this.$route.params.projectId]    
      //   let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      //   let s = permissionHash[salut]
      //   return fPrivilege.lessons.includes(s); 
      //   }         
      },
   // Temporary _isallowed method until contract projectPrivileges is fixed
    //  _isallowed(salut) {
    //     var programId = this.$route.params.programId;
    //     var projectId = this.$route.params.projectId
    //     let fPrivilege = this.$projectPrivileges[programId][projectId]
    //     let permissionHash = {"write": "W", "read": "R", "delete": "D"}
    //     let s = permissionHash[salut]
    //     return  fPrivilege.lessons.includes(s);      
    // },
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
