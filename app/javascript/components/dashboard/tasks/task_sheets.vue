
<template>
  <div id="task-sheets">
    <table class="table table-sm table-bordered table-striped">
      <tr
        v-if="!loading"
        class="mx-3 mb-3 mt-2 py-4 edit-action"
        @click.prevent="editTask"
        data-cy="task_row"
        @mouseup.right="openContextMenu"
        @contextmenu.prevent=""
      >
        <td class="sixteen">{{ task.text }}</td>
        <td class="ten">{{ task.taskType }}</td>
        <td class="eight">{{ formatDate(task.startDate) }}</td>
        <td class="eight">{{ formatDate(task.dueDate) }}</td>
        <td class="ten" v-if="task.userNames.length >= 0">
          {{ task.userNames }}
        </td>
        <td class="ten" v-else></td>
        <td class="ten">{{ task.progress + "%" }}</td>
        <td class="ten" v-if="task.dueDate <= now"><h5>x</h5></td>
        <td class="ten" v-else></td>
        <td class="eight" v-if="task.watched == true"><h5>x</h5></td>
        <td class="eight" v-else></td>
        <td class="twenty" v-if="task.notes.length > 0">
          By: {{ task.notes[0].user.fullName }} on
          {{ moment(task.notes[0].createdAt).format("DD MMM YYYY, h:mm a") }}:
          {{ task.notes[0].body }}
        </td>
        <td v-else class="twenty">No Updates</td>
      </tr>
      <!-- The context-menu appears only if table row is right-clicked -->
      <context-menu :display="showContextMenu" ref="menu">
        <el-menu collapse>
          <el-menu-item @click="editTask">Open</el-menu-item>
          <el-menu-item @click="createDuplicate">Duplicate</el-menu-item>
          <hr>
          <el-submenu index="1">
            <template slot="title">
              <span slot="title">Duplicate to...</span>
            </template>
            <div ref="treeMenu">
              <el-tree
                :data="treeFormattedData"
                :props="defaultProps"
                show-checkbox
                ref="duplicatetree"
                node-key="id"
              >
              </el-tree>
              <div class="context-menu-btns">
                <button class="btn btn-sm btn-success ml-2" @click="getCheckedNodes">Submit</button>
                <button class="btn btn-sm btn-outline-secondary ml-2" @click="closeTree($refs.duplicatetree)">Cancel</button>
              </div>
            </div>
          </el-submenu>
          <el-submenu index="2">
            <template slot="title">
              <span slot="title">Move to...</span>
            </template>
            <div>
              <el-tree
                :data="treeFormattedData"
                :props="defaultProps"
                ref="movetree"
                @node-click="move"
              >
              </el-tree>
            </div>
          </el-submenu>
        </el-menu>
      </context-menu>
    </table>

    <sweet-modal
      class="task_form_modal"
      ref="taskFormModal"
      :hide-close-button="true"
      :blocking="true"
    >
      <div v-if="has_task" class="w-100">
        <task-form
          v-if="Object.entries(DV_edit_task).length"
          :facility="facility"
          :task="DV_edit_task"
          title="Edit Task"
          @task-updated="updateRelatedTaskIssue"
          @on-close-form="onCloseForm"
          class="form-inside-modal"
        ></task-form>

        <issue-form
          v-if="Object.entries(DV_edit_issue).length"
          :facility="facility"
          :issue="DV_edit_issue"
          @issue-updated="updateRelatedTaskIssue"
          @on-close-form="onCloseForm"
          class="form-inside-modal"
        ></issue-form>
      </div>
    </sweet-modal>
  </div>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
import { SweetModal } from "sweet-modal-vue";
import TaskForm from "./task_form";
import IssueForm from "./../issues/issue_form";
import ContextMenu from "../../shared/ContextMenu";
import moment from "moment";
import axios from "axios";
import humps from "humps";
Vue.prototype.moment = moment;

export default {
  name: "TaskSheets",
  components: {
    TaskForm,
    IssueForm,
    SweetModal,
    ContextMenu,
  },
  props: {
    fromView: {
      type: String,
      default: "map_view",
    },
    task: Object,
  },
  data() {
    return {
      loading: true,
      now: new Date().toISOString(),
      DV_task: {},
      DV_edit_task: {},
      DV_edit_issue: {},
      has_task: false,
      showContextMenu: false,
      defaultProps: {
        children: "children",
        label: "label",
        disabled: "disabled"
      },
    };
  },
  mounted() {
    if (this.task) {
      this.loading = false;
      this.DV_task = this.task;
    }
  },
  methods: {
    closeTree(tree) {
      console.log(tree)
    },
    move(node) {
      if (!node.hasOwnProperty('children')) {
        this.moveTask(this.task, node.id)
      }    
    },
    getCheckedNodes() {
      var facilityNodes = this.$refs.duplicatetree.getCheckedNodes().filter(item => !item.hasOwnProperty('children'));
      
      facilityNodes.forEach(facility => console.log("Duplicate task to : " + facility.label))
    },
    ...mapMutations(["updateTasksHash", "setTaskForManager"]),
    ...mapActions(["taskDeleted", "taskUpdated", "updateWatchedTasks"]),
    deleteTask() {
      var confirm = window.confirm(
        `Are you sure, you want to delete "${this.DV_task.text}"?`
      );
      if (!confirm) {
        return;
      }
      this.taskDeleted(this.DV_task);
    },
    openSubTask(subTask) {
      let task = this.currentTasks.find((t) => t.id == subTask.id);
      if (!task) return;
      this.has_task = Object.entries(task).length > 0;
      this.DV_edit_task = task;
      this.$refs.taskFormModal && this.$refs.taskFormModal.open();
    },
    openSubIssue(subIssue) {
      let issue = this.currentIssues.find((t) => t.id == subIssue.id);
      if (!issue) return;
      this.has_task = Object.entries(issue).length > 0;
      this.DV_edit_issue = issue;
      this.$refs.taskFormModal && this.$refs.taskFormModal.open();
    },
    editTask() {
      if (this.fromView == "map_view") {
        this.$emit("edit-task", this.DV_task);
      } else if (this.fromView == "manager_view") {
        this.setTaskForManager({ key: "task", value: this.DV_task });
      } else {
        this.has_task = Object.entries(this.DV_task).length > 0;
        this.DV_edit_task = this.DV_task;
        this.$refs.taskFormModal && this.$refs.taskFormModal.open();
      }
    },
    onCloseForm() {
      this.$refs.taskFormModal && this.$refs.taskFormModal.close();
      this.has_task = false;
      this.DV_edit_task = {};
      this.DV_edit_issue = {};
    },
    toggleWatched() {
      if (this.DV_task.watched) {
        var confirm = window.confirm(
          `Are you sure, you want to remove this task from on-watch?`
        );
        if (!confirm) {
          return;
        }
      }
      this.DV_task = { ...this.DV_task, watched: !this.DV_task.watched };
      this.updateWatchedTasks(this.DV_task);
    },
    updateRelatedTaskIssue(task) {
      this.taskUpdated({
        facilityId: task.facilityId,
        projectId: task.projectId,
        cb: () => this.onCloseForm(),
      });
    },
    getTask(task) {
      return this.currentTasks.find((t) => t.id == task.id) || {};
    },
    getIssue(issue) {
      return this.currentIssues.find((t) => t.id == issue.id) || {};
    },
    openContextMenu(e) {
      e.preventDefault();
      this.$refs.menu.open(e);
    },
    moveTask(task, facilityProjectId) {
      if (!this._isallowed("write")) return;
      this.$validator.validate().then((success) => {
        if (!success || this.loading) {
          this.showErrors = !success;
          return;
        }

        this.loading = true;
        let formData = new FormData();

        formData.append("task[facility_project_id]", facilityProjectId);

        let url = `/projects/${this.currentProject.id}/facilities/${task.facilityId}/tasks/${task.id}.json`;
        let method = "PUT";
        let callback = "task-updated";

        var beforeSaveTask = task;

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
            if (beforeSaveTask.facilityId && beforeSaveTask.projectId)
              this.$emit(callback, humps.camelizeKeys(beforeSaveTask));
            this.$emit(callback, humps.camelizeKeys(response.data.task));
            this.updateFacilities(
              humps.camelizeKeys(response.data.task),
              facilityProjectId
            );
          })
          .catch((err) => {
            // var errors = err.response.data.errors
            console.log(err);
          })
          .finally(() => {
            this.loading = false;
            this.updateTasksHash({ task: task, action: "delete" });
          });
      });
    },
    updateFacilities(updatedTask, id) {
      var facilities = this.facilities;

      facilities.forEach((facility) => {
        if (facility.facilityProjectId === id) {
          facility.tasks.push(updatedTask);
        }
      });
      console.log("Task was moved.")
    },
    updateFacilityTask(task) {
      var facilities = this.facilities;

      var facilityIndex = facilities.findIndex(item => item.facilityProjectId === task.facilityProjectId);

      facilities[facilityIndex].tasks.push(task);
      console.log("Task was duplicated.")

    },
    createDuplicate() {
        let url = `/projects/${this.currentProject.id}/facilities/${this.DV_task.facilityId}/tasks/${this.DV_task.id}/create_duplicate.json`
        let method = "POST"
        let callback = "task-created"

        let formData = new FormData()
        formData.append('id', this.DV_task.id)

        axios({
          method: method,
          url: url,
          data: formData,
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').attributes['content'].value
          }
        })
        .then((response) => {
          this.$emit(callback, humps.camelizeKeys(response.data.task))
          this.updateFacilityTask(
              humps.camelizeKeys(response.data.task),
              this.DV_task.facilityProjectId
            );
        })
        .catch((err) => {
          // var errors = err.response.data.errors
          console.log(err)
        })
        .finally(() => {
          // this.loading = false
        })
      },
  },
  computed: {
    treeFormattedData() {
      var data = [];

      this.facilityGroups.forEach((group, index) => {
        data.push({
          id: index,
          label: group.name,
          children: [...group.facilities.map(facility => {
            return {
              id: facility.facilityProjectId,
              label: facility.facilityName
            }
          })],
        });
      });

      return [...data]    
    },
    ...mapGetters([
      "facilities",
      "facilityGroups",
      "managerView",
      "currentTasks",
      "currentIssues",
      "viewPermit",
      "currentProject",
      "getUnfilteredFacilities",
    ]),
    _isallowed() {
      return (salut) =>
        this.$currentUser.role == "superadmin" ||
        this.$permissions.tasks[salut];
    },
    is_overdue() {
      return (
        this.DV_task.progress !== 100 &&
        new Date(this.DV_task.dueDate).getTime() < new Date().getTime()
      );
    },
    facility() {
      return this.facilities.find((f) => f.id == this.DV_task.facilityId);
    },
    facilityGroup() {
      return this.facilityGroups.find(
        (f) => f.id == this.facility.facilityGroupId
      );
    },
    C_editForManager() {
      return (
        this.managerView.task && this.managerView.task.id == this.DV_task.id
      );
    },
  },
  watch: {
    task: {
      handler(value) {
        this.DV_task = Object.assign({}, value);
      },
      deep: true,
    },
  },
};
</script>

<style lang="scss" scoped>
.t_actions {
  display: flex;
  align-items: center;
  justify-content: space-between;
  span {
    font-size: 13px;
  }
  .empty_box,
  .check_box {
    font-size: 16px;
  }
}
table {
  table-layout: fixed;
  width: 100%;
  margin-bottom: 0 !important;
  overflow: auto;
}
.eight {
  width: 8%;
}
.ten {
  width: 10%;
}
.sixteen {
  width: 16%;
}
.twenty {
  width: 20%;
}
.pg-content {
  width: 100%;
  height: 20px;
  font-weight: bold;
}
td {
  overflow-wrap: break-word;
}
.task_form_modal.sweet-modal-overlay {
  z-index: 10000001;
}
.task_form_modal.sweet-modal-overlay /deep/ .sweet-modal {
  min-width: 30vw;
  max-height: 80vh;
  .sweet-content {
    padding-top: 30px;
    text-align: unset;
  }
  .modal_close_btn {
    display: flex;
    position: absolute;
    top: 20px;
    right: 30px;
    font-size: 20px;
    cursor: pointer;
  }
  .fa-long-arrow-alt-right {
    margin-bottom: 1rem !important;
    margin-left: 1rem !important;
    height: 0.8em !important;
  }
  .onHover:hover {
    cursor: pointer !important;
    background-color: rgba(91, 192, 222, 0.3) !important;
    border-left: solid rgb(91, 192, 222) !important;
  }
  .form-inside-modal {
    form {
      position: inherit !important;
    }
  }
}
hr {
  margin: 0;
}
.dropdown-context-menu {
  // max-height: 200px;
  // max-width: 200px;
  overflow-y: scroll;
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
#first-menu-item {
  font-weight: bold;
  &:hover {
    background-color: unset;
  }
}
.context-menu-btns {
  padding: 10px;
}
.el-menu-item {
  padding-right: 30px;
}
.el-tree {
  padding: 10px;
  max-width: 300px;
  max-height: 300px;
  overflow-y: scroll;
}
</style>
