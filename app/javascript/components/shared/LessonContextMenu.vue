<template>
  <div
    class="context-menu"
    v-show="show"
    :style="style"
    ref="context"
    tabindex="0"
    @mouseleave="close"
  >
    <el-menu collapse>
      <!-- <el-menu-item @click="openLesson">Open</el-menu-item>
      <hr />
      <el-menu-item
        @click="createDuplicate"
        :disabled="!$permissions.lessons.write"
        >Duplicate</el-menu-item
      >
      <el-submenu index="1" :disabled="!$permissions.lessons.write">
        <template slot="title">
          <span slot="title">Duplicate to...</span>
        </template>
        <div>
          <div class="menu-subwindow-title">Duplicate to...</div>
          <el-input
            class="filter-input"
            placeholder="Filter Projects..."
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
              @click="duplicateSelectedLessons"
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
      <el-submenu index="2" :disabled="!$permissions.lessons.write">
        <template slot="title">
          <span slot="title">Move to...</span>
        </template>
        <div>
          <div class="menu-subwindow-title">Move to...</div>
          <el-input
            class="filter-input"
            placeholder="Filter Projects..."
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
      <hr /> -->
      <el-menu-item @click="deleteSelectedLesson">Delete</el-menu-item>
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
    ...mapGetters(["getUnfilteredFacilities"]),
    style() {
      return {
        top: this.top + "px",
        left: this.left + "px",
      };
    },
  },
  methods: {
    ...mapActions(["deleteLesson"]),
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
    deleteSelectedLesson() {
      this.deleteLesson({ id: this.lesson.id, ...this.$route.params });
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
