<template>
  <div
    class="context-menu"
    v-show="show"
    :style="style"
    ref="context"
    tabindex="0"
    @focusout="clickOutside"
  >
    <div>
      <div class="d-flex justify-content-end pt-2 pr-2">
        <i class="el-icon-error" title="Close" @click="close"></i>
      </div>
      <div class="menu-subwindow-title">Select Related {{ item }}s</div>
      <el-input
        class="filter-input"
        :placeholder="
          `Filter ${item.charAt(0).toUpperCase() + item.slice(1)}s...`
        "
        v-model="filterTree"
      ></el-input>
      <el-tree
        ref="relatedtree"
        :data="treeFormattedData"
        :props="defaultProps"
        :filter-node-method="filterNode"
        :expand-on-click-node="true"
        @check-change="toggleSubmitBtn"
        show-checkbox
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

export default {
  name: "RelatedTaskMenu",
  props: {
    display: Boolean, // prop detect if we should show context menu,
    facilities: Array,
    facilityGroups: Array,
    relatedTasks: Array,
    relatedIssues: Array,
    relatedRisks: Array,
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
      var relatedRiskIds = this.relatedRisks.map((risk) => risk.id);

      this.facilityGroups.forEach((group, index) => {
        data.push({
          // Project Groups
          id: index,
          label: group.name,
          children: [
            //Projects
            ...group.facilities
              .filter(
                (facility) => this.item && facility[this.item + "s"].length > 0
              )
              .map((facility) => {
                if (this.item == "task") {
                  return {
                    id: facility.facilityProjectId,
                    label: facility.facilityName,
                    children: [
                      // Project Tasks
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
                } else if (this.item == "issue") {
                  return {
                    id: facility.facilityProjectId,
                    label: facility.facilityName,
                    children: [
                      // Project Issues
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
                } else {
                  return {
                    id: facility.facilityProjectId,
                    label: facility.facilityName,
                    children: [
                      // Project Risks
                      ...facility.risks
                        .filter((risk) => !relatedRiskIds.includes(risk.id))
                        .map((risk) => {
                          return {
                            id: risk.id,
                            label: risk.text,
                            risk: risk,
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
        
        this.$permissions.lessons[salut];
    },
  },
  methods: {
    // closes context menu
    close() {
      this.clearAllNodes();
      this.item = "";
      this.filterTree = "";
      this.show = false;
      this.left = 0;
      this.top = 0;
    },
    open(evt, item) {
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
      } else if (this.item == "issue") {
        var issues = nodes.map((issue) => issue.issue);
        this.$emit("add-related-issues", issues);
      } else {
        var risks = nodes.map((risk) => risk.risk);
        this.$emit("add-related-risks", risks);
      }
    },
    filterNode(value, data) {
      if (!value) return true;
      return data.label.toLowerCase().indexOf(value.toLowerCase()) !== -1;
    },
    toggleSubmitBtn() {
      this.submitted = false;
    },
    clickOutside(e) {
      if (!e.relatedTarget) {
        this.close();
      }
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
  text-transform: capitalize;
  font-size: 14px;
  text-align: center;
  margin-top: 10px;
}
</style>
