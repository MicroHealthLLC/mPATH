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
      <div class="menu-subwindow-title">Select Related Task(s)</div>
      <el-input
        class="filter-input"
        placeholder="Filter Tasks..."
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
          @click.prevent="addRelatedTasks"
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
                (facility) => facility.facility.id !== this.task.facilityId
              )
              .map((facility) => {
                return {
                  id: facility.facilityProjectId,
                  label: facility.facilityName,
                  children: [
                    ...facility.tasks.map((task) => {
                      return {
                        id: task.id,
                        label: task.text,
                      };
                    }),
                  ],
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
    },
    isAllowed() {
      return (salut) =>
        this.$currentUser.role == "superadmin" ||
        this.$permissions.tasks[salut];
    },
  },
  methods: {
    ...mapMutations(["updateTasksHash"]),
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
    selectAllNodes() {
      this.$refs.duplicatetree.setCheckedNodes(this.treeFormattedData);
    },
    clearAllNodes() {
      this.$refs.duplicatetree.setCheckedNodes([]);
    },
    addRelatedTasks() {
      this.submitted = true;

      var facilityNodes = this.$refs.duplicatetree
        .getCheckedNodes()
        .filter((item) => !item.hasOwnProperty("children"));

      var ids = facilityNodes.map((facility) => facility.id);

      console.log(facilityNodes);
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
