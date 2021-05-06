<template>
  <div
    class="context-menu"
    v-show="show"
    :style="style"
    ref="context"
    tabindex="0"
    @mouseleave="close"
  >
    <div>
      <div class="menu-subwindow-title">Select Related {{ item }}s</div>
      <el-input
        class="filter-input"
        :placeholder="`Filter ${item}s...`"
        v-model="filterTree"
      ></el-input>
      <el-tree
        :data="treeFormattedData"
        :props="defaultProps"
        :filter-node-method="filterNode"
        @check-change="toggleSubmitBtn"
        show-checkbox
        ref="relatedtree"
        node-key="id"
      >
      </el-tree>
      <div class="context-menu-btns">
        <button
          class="btn btn-sm btn-primary ml-2"
          @click.prevent="addRelatedItems"
          :disabled="submitDisabled"
        >
          Submit
        </button>
        <button
          class="btn btn-sm btn-outline-secondary ml-2"
          @click.prevent="clearAllNodes"
        >
          Clear All
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from "vue";
import { mapGetters, mapActions, mapMutations } from "vuex";
import axios from "axios";
import humps from "humps";

export default {
  name: "RelatedContextMenu",
  props: {
    display: Boolean, // prop detect if we should show context menu,
    facilities: Array,
    facilityGroups: Array,
    task: Object,
    relatedTasks: Array,
    relatedIssues: Array,
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
      item: "",
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
      var relatedTaskIds = this.relatedTasks.map((task) => task.id);
      var relatedIssueIds = this.relatedIssues.map((issue) => issue.id);

      this.facilityGroups.forEach((group, index) => {
        data.push({
          id: index,
          label: group.name,
          children: [
            ...group.facilities
              .filter(
                (facility) => facility.facility.id !== this.task.facilityId
              )
              .filter((facility) => this.item && facility[this.item + "s"].length > 0)
              .map((facility) => {
                if (this.item == "task") {
                  return {
                    id: facility.facilityProjectId,
                    label: facility.facilityName,
                    children: [
                      ...facility.tasks
                        .filter((task) => !relatedTaskIds.includes(task.id))
                        .map((task) => {
                          return {
                            id: task.id,
                            label: task.text,
                            task: task,
                          };
                        }),
                    ],
                  };
                } else {
                  return {
                    id: facility.facilityProjectId,
                    label: facility.facilityName,
                    children: [
                      ...facility.issues
                        .filter((issue) => !relatedIssueIds.includes(issue.id))
                        .map((issue) => {
                          return {
                            id: issue.id,
                            label: issue.title,
                            issue: issue,
                          };
                        }),
                    ],
                  };
                }
              }),
          ],
        });
      });

      return [...data];
    },
    submitDisabled() {
      if (this.$refs.relatedtree) {
        return (
          this.$refs.relatedtree.getCheckedNodes().length === 0 ||
          this.submitted
        );
      } else {
        return this.submitted;
      }
    },
    isAllowed() {
      return (salut) =>
        this.$currentUser.role == "superadmin" ||
        this.$permissions.tasks[salut];
    },
  },
  methods: {
    // closes context menu
    close() {
      this.clearAllNodes();
      this.item = "";
      this.show = false;
      this.left = 0;
      this.top = 0;
    },
    open(evt, item) {
      console.log(item);
      this.item = item;
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
    clearAllNodes() {
      this.$refs.relatedtree.setCheckedNodes([]);
    },
    addRelatedItems() {
      this.submitted = true;

      var nodes = this.$refs.relatedtree
        .getCheckedNodes()
        .filter((item) => !item.hasOwnProperty("children"));

      if (this.item == "task") {
        var tasks = nodes.map((task) => task.task);
        this.$emit("add-related-tasks", tasks);
      } else {
        var issues = nodes.map((issue) => issue.issue);
        this.$emit("add-related-issues", issues);
      }
    },
    filterNode(value, data) {
      if (!value) return true;
      return data.label.toLowerCase().indexOf(value.toLowerCase()) !== -1;
    },
    toggleSubmitBtn() {
      this.submitted = false;
    },
  },
  watch: {
    filterTree(value) {
      this.$refs.relatedtree.filter(value);
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
