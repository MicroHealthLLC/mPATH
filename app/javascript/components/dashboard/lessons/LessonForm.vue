<template>
  <form @submit.prevent="saveLesson" accept-charset="UTF-8">
    <div class="mt-2  d-flex align-items-center">
      <!-- Breadcrumbs and form buttons -->
      <div>
        <h5 class="mb-0">
          <span style="font-size: 16px; margin-right: 10px"
            ><i class="fas fa-building"></i
          ></span>
          <router-link v-if="contentLoaded" :to="projectNameLink">{{
            facility.facilityName
          }}</router-link>
          <el-icon
            class="el-icon-arrow-right"
            style="font-size: 12px"
          ></el-icon>
          <router-link
            :to="
              `/programs/${this.$route.params.programId}/${tab}/projects/${this.$route.params.projectId}/lessons`
            "
            >Lessons</router-link
          >
          <el-icon
            class="el-icon-arrow-right"
            style="font-size: 12px"
          ></el-icon>
          <span>{{ lesson.title || "(Lesson Name)" }}</span>
        </h5>
      </div>
      <div class="ml-auto d-flex">
        <button class="btn btn-sm sticky-btn btn-primary text-nowrap mr-2">
          Save Lesson
        </button>
        <button disabled class="btn btn-sm sticky-btn btn-primary mr-2">
          Read Only
        </button>
        <button
          class="btn btn-sm sticky-btn btn-outline-secondary mr-1"
          @click.prevent="close"
        >
          Close
        </button>
      </div>
    </div>
    <hr class=" mb-6 mt-2" />
    <!-- Form Navigation Tabs -->
    <div class="d-flex form-group pt-1 mb-1 justify-content-start">
      <FormTabs
        :current-tab="currentTab"
        :tabs="tabs"
        :allErrors="errors"
        @on-change-tab="onChangeTab"
      />
    </div>
    <!-- Required field errors -->
    <h6 class=" mt-4 mb-0" style="color: gray; font-size: 13px">
      <span style="color: #dc3545; font-size: 15px">*</span> Indicates required
      fields
    </h6>
    <div class="fixed-form pt-1">
      <div v-if="errors.items.length > 0" class="text-danger ">
        Please fill the required fields before submitting
        <ul class="error-list ">
          <li
            v-for="(error, index) in errors.all()"
            :key="index"
            v-tooltip="{
              content: 'Field is located on Lesson Info',
              placement: 'left',
            }"
          >
            {{ error }}
          </li>
        </ul>
      </div>
    </div>
    <!-- Lesson Info Tab -->
    <div v-show="currentTab == 'tab1'" class="row mx-0">
      <div class="col-12 px-0">
        <label class="font-md"
          >Lesson Name <span style="color: #dc3545">*</span></label
        >
        <el-input
          name="Lesson Name"
          v-validate="'required'"
          v-model="lesson.title"
          type="text"
          placeholder="Lesson Name"
          :class="{ error: errors.has('Lesson Name') }"
        />
        <div v-show="errors.has('Lesson Name')" class="text-danger">
          {{ errors.first("Name") }}
        </div>
      </div>
      <div class="col-12 px-0">
        <label class="font-md"
          >Description <span style="color: #dc3545">*</span></label
        >
        <el-input
          name="Description"
          type="textarea"
          v-validate="'required'"
          v-model="lesson.description"
          placeholder="Brief description..."
          rows="4"
          :class="{
            error: errors.has('Description'),
          }"
        ></el-input>
        <div v-show="errors.has('Description')" class="text-danger">
          {{ errors.first("Description") }}
        </div>
      </div>

      <div class="col-6 pl-0">
        <label class="font-md"
          >Date <span style="color: #dc3545">*</span></label
        >
        <div :class="{ error: errors.has('Date') }">
          <v2-date-picker
            name="Date"
            v-validate="'required'"
            v-model="lesson.date"
            value-type="YYYY-MM-DD"
            format="DD MMM YYYY"
            placeholder="DD MM YYYY"
            class="w-100"
          />
        </div>
        <div v-show="errors.has('Date')" class="text-danger">
          {{ errors.first("Date") }}
        </div>
      </div>

      <div class="col-6 pr-0">
        <label class="font-md w-100">Submitted By</label>
        <el-select
          v-model="submittedBy"
          class="w-100"
          clearable
          value-key="id"
          placeholder="Search and Select User"
          @change="updateSubmittedBy"
        >
          <el-option
            v-for="user in activeProjectUsers"
            :value="user"
            :key="user.id"
            :label="user.fullName"
          >
          </el-option>
        </el-select>
      </div>

      <div class="col-6 pl-0">
        <label class="font-md w-100">Category</label>
        <el-select
          v-model="category"
          class="w-100"
          value-key="id"
          name="Category"
          placeholder="Select Category"
          @change="updateCategory"
        >
          <!-- taskTypes should be changed to categoryTypes -->
          <el-option
            v-for="category in taskTypes"
            :value="category"
            :key="category.id"
            :label="category.name"
          >
          </el-option>
        </el-select>
      </div>

      <div class="col-6 pr-0">
        <label class="font-md">Stage</label>
        <el-select
          v-model="stage"
          class="w-100"
          clearable
          value-key="id"
          placeholder="Select Stage"
          @change="updateStage"
        >
          <el-option
            v-for="stage in lessonStages"
            :value="stage"
            :key="stage.id"
            :label="stage.name"
          >
          </el-option>
        </el-select>
      </div>
    </div>
    <!-- Related Tab -->
    <div v-show="currentTab == 'tab2'">
      <div class="row mt-2">
        <div class="col">
          Related Tasks
          <span class="clickable" @click="openContextMenu($event, 'task')">
            <i class="fas fa-plus-circle"></i
          ></span>

          <hr class="mt-0" />

          <ul class="text-smaller">
            <li
              class="d-flex justify-content-between align-items-center my-2"
              v-for="(task, index) in relatedTasks"
              :key="index"
            >
              <el-popover placement="right" width="200" trigger="hover">
                <div>
                  <p class="m-0 text-left">
                    <el-tag size="mini">Project Name</el-tag>
                    {{ task.facilityName }}
                  </p>
                </div>
                <router-link
                  :to="
                    `/programs/${$route.params.programId}/${tab}/projects/${task.facilityId}/tasks/${task.id}`
                  "
                  slot="reference"
                  >{{ task.text }}</router-link
                ></el-popover
              >
              <el-button
                size="mini"
                icon="el-icon-delete"
                title="Remove Related Task"
                @click.prevent="removeRelatedTask(task)"
              ></el-button>
            </li>
          </ul>
        </div>
        <div class="col">
          Related Issues
          <span class="clickable" @click="openContextMenu($event, 'issue')">
            <i class="fas fa-plus-circle"></i>
          </span>

          <hr class="mt-0" />

          <ul class="text-smaller">
            <li
              class="d-flex justify-content-between align-items-center my-2"
              v-for="(issue, index) in relatedIssues"
              :key="index"
            >
              <el-popover placement="right" width="200" trigger="hover">
                <div>
                  <p class="m-0 text-left">
                    <el-tag size="mini">Project Name</el-tag>
                    {{ issue.facilityName }}
                  </p>
                </div>
                <router-link
                  :to="
                    `/programs/${$route.params.programId}/${tab}/projects/${issue.facilityId}/issues/${issue.id}`
                  "
                  slot="reference"
                  >{{ issue.title }}</router-link
                ></el-popover
              >
              <el-button
                size="mini"
                icon="el-icon-delete"
                title="Remove Related Issue"
                @click.prevent="removeRelatedIssue(issue)"
              ></el-button>
            </li>
          </ul>
        </div>
        <div class="col">
          Related Risks
          <span class="clickable" @click="openContextMenu($event, 'risk')">
            <i class="fas fa-plus-circle"></i>
          </span>

          <hr class="mt-0" />

          <ul class="text-smaller">
            <li
              class="d-flex justify-content-between align-items-center my-2"
              v-for="(risk, index) in relatedRisks"
              :key="index"
            >
              <el-popover placement="right" width="200" trigger="hover">
                <div>
                  <p class="m-0 text-left">
                    <el-tag size="mini">Project Name</el-tag>
                    {{ risk.facilityName }}
                  </p>
                </div>
                <router-link
                  :to="
                    `/programs/${$route.params.programId}/${tab}/projects/${risk.facilityId}/risks/${risk.id}`
                  "
                  slot="reference"
                  >{{ risk.text }}</router-link
                ></el-popover
              >
              <el-button
                size="mini"
                icon="el-icon-delete"
                title="Remove Related Risk"
                @click.prevent="removeRelatedRisk(risk)"
              ></el-button>
            </li>
          </ul>
        </div>
      </div>
    </div>
    <!-- Successes Tab -->
    <div v-show="currentTab == 'tab3'">
      <label class="font-md">Successes</label>
      <span class="clickable">
        <i class="fas fa-plus-circle"></i>
      </span>

      <el-card
        v-for="(i, index) in [1, 2, 3]"
        :key="index"
        class="success-card mb-3"
      >
        <div class="d-flex justify-content-between">
          <label class="font-md">Findings</label>
          <div class="font-sm">
            <el-tag size="mini"
              ><span class="font-weight-bold">Submitted by:</span> Someone at
              10:30PM on 6/23/2021</el-tag
            >
            <i class="el-icon-delete ml-3"></i>
          </div>
        </div>

        <el-input
          type="textarea"
          placeholder="Please enter findings here..."
        ></el-input>
        <label class="font-md">Recommendation</label>
        <el-input
          type="textarea"
          placeholder="Please recommendation here..."
        ></el-input>
      </el-card>
    </div>
    <!-- Failures Tab -->
    <div v-show="currentTab == 'tab4'">
      <h1>FAILURES</h1>
    </div>
    <!-- Files & Links -->
    <div v-show="currentTab == 'tab5'">
      <h1>FILES AND LINKS</h1>
    </div>
    <!-- Updates Tab -->
    <div v-show="currentTab == 'tab6'">
      <h1>UPDATES</h1>
    </div>
    <RelatedLessonMenu
      :facilities="facilities"
      :facilityGroups="facilityGroups"
      :relatedTasks="[]"
      :relatedIssues="[]"
      :relatedRisks="[]"
      @add-related-tasks="addRelatedTasks"
      @add-related-issues="addRelatedIssues"
      @add-related-risks="addRelatedRisks"
      ref="menu"
    />
  </form>
</template>

<script>
import { mapActions, mapMutations, mapGetters } from "vuex";
import RelatedLessonMenu from "../../shared/RelatedLessonMenu.vue";
import FormTabs from "./../../shared/FormTabs";

export default {
  name: "LessonForm",
  props: ["facility"],
  components: {
    FormTabs,
    RelatedLessonMenu,
  },
  data() {
    return {
      formLoaded: false,
      currentTab: "tab1",
      tabs: [
        {
          label: "Lesson Info",
          key: "tab1",
          closable: false,
          form_fields: [
            "Lesson Name",
            "Description",
            "Submitted By",
            "Date",
            "Category",
            "Stage",
          ],
        },
        {
          label: "Related",
          key: "tab2",
          closable: false,
          form_fields: [
            "Projects",
            "Related Task",
            "Related Issue",
            "Related Risk",
          ],
        },
        {
          label: "Successes",
          key: "tab3",
          closable: false,
          form_fields: [],
        },
        {
          label: "Failures",
          key: "tab4",
          closable: false,
          form_fields: [],
        },
        {
          label: "Files & Links",
          key: "tab5",
          closable: false,
          form_fields: ["Files"],
        },
        {
          label: "Updates",
          key: "tab6",
          closable: false,
          form_fields: [],
        },
      ],
      submittedBy: {},
      category: {},
      stage: {},
      relatedTasks: [],
      relatedIssues: [],
      relatedRisks: [],
    };
  },
  methods: {
    ...mapActions(["addLesson", "fetchLesson", "updateLesson"]),
    ...mapMutations(["SET_LESSON"]),
    saveLesson() {
      this.$validator.validate().then((success) => {
        if (!success) {
          return;
        }

        let formData = new FormData();

        formData.append("lesson[title]", this.lesson.title);
        formData.append("lesson[description]", this.lesson.description);
        formData.append("lesson[date]", this.lesson.date);
        formData.append(
          "lesson[user_id]",
          this.submittedBy ? this.submittedBy.id : null
        );
        formData.append(
          "lesson[task_type_id]",
          this.category ? this.category.id : null
        );
        formData.append("lesson[stage]", this.stage ? this.stage.id : null);
        formData.append("lesson[program_id]", this.$route.params.programId);
        formData.append("lesson[project_id]", this.$route.params.projectId);
        // Load related task ids
        if (this.relatedTasks.length > 0 && this.lesson.sub_task_ids) {
          this.relatedTasks.forEach((task) => {
            formData.append("lesson[sub_task_ids][]", task.id);
          });
        } else if (this.relatedTasks.length > 0) {
          this.relatedTasks.forEach((task) => {
            formData.append("lesson[sub_task_ids][]", task.id);
          });
        } else {
          formData.append("lesson[sub_task_ids][]", []);
        }
        // Load related issue ids
        if (this.relatedIssues.length > 0 && this.lesson.sub_issue_ids) {
          this.relatedIssues.forEach((issue) => {
            formData.append("lesson[sub_issue_ids][]", issue.id);
          });
        } else if (this.relatedIssues.length > 0) {
          this.relatedIssues.forEach((issue) => {
            formData.append("lesson[sub_issue_ids][]", issue.id);
          });
        } else {
          formData.append("lesson[sub_issue_ids][]", []);
        }
        // Load related risk ids
        if (this.relatedRisks.length > 0 && this.lesson.sub_risk_ids) {
          this.relatedRisks.forEach((risk) => {
            formData.append("lesson[sub_risk_ids][]", risk.id);
          });
        } else if (this.relatedRisks.length > 0) {
          this.relatedRisks.forEach((risk) => {
            formData.append("lesson[sub_risk_ids][]", risk.id);
          });
        } else {
          formData.append("lesson[sub_risk_ids][]", []);
        }
        // Check to add or update existing lesson by confirming an id
        if (this.lesson.id) {
          formData.append("lesson[id]", this.lesson.id);
          this.updateLesson({ lesson: formData, ...this.$route.params });
        } else {
          this.addLesson({ lesson: formData, ...this.$route.params });
        }
      });
    },
    close() {
      this.$router.push(
        `/programs/${this.$route.params.programId}/${this.tab}/projects/${this.$route.params.projectId}/lessons`
      );
    },
    onChangeTab(tab) {
      this.currentTab = tab ? tab.key : "tab1";
    },
    updateSubmittedBy(user) {
      this.submittedBy = user;
    },
    updateCategory(category) {
      this.category = category;
    },
    updateStage(stage) {
      this.stage = stage;
    },
    openContextMenu(e, item) {
      e.preventDefault();
      this.$refs.menu.open(e, item);
    },
    addRelatedTasks(tasks) {
      tasks.forEach((task) => this.relatedTasks.push(task));
    },
    removeRelatedTask({ id }) {
      this.relatedTasks.splice(
        this.relatedTasks.findIndex((task) => task.id == id),
        1
      );
    },
    addRelatedIssues(issues) {
      issues.forEach((issue) => this.relatedIssues.push(issue));
    },
    removeRelatedIssue({ id }) {
      this.relatedIssues.splice(
        this.relatedIssues.findIndex((issue) => issue.id == id),
        1
      );
    },
    addRelatedRisks(risks) {
      risks.forEach((risk) => this.relatedRisks.push(risk));
    },
    removeRelatedRisk({ id }) {
      this.relatedRisks.splice(
        this.relatedRisks.findIndex((risk) => risk.id == id),
        1
      );
    },
  },
  computed: {
    ...mapGetters([
      "activeProjectUsers",
      "contentLoaded",
      "facilities",
      "facilityGroups",
      "lesson",
      "lessonStages",
      "taskTypes",
    ]),
    tab() {
      if (this.$route.path.includes("map")) {
        return "map";
      } else if (this.$route.path.includes("sheet")) {
        return "sheet";
      } else if (this.$route.path.includes("lessons")) {
        return "lessons";
      } else {
        return "kanban";
      }
    },
    projectNameLink() {
      if (this.$route.path.includes("lessons")) {
        return `/programs/${this.$route.params.programId}/${this.tab}/projects/${this.$route.params.projectId}`;
      }
    },
  },
  mounted() {
    if (this.$route.params.lessonId && this.$route.params.lessonId != "new") {
      this.fetchLesson({
        id: this.$route.params.lessonId,
        ...this.$route.params,
      });
    }
  },
  beforeDestroy() {
    // Clear current lesson in store
    this.SET_LESSON({});
  },
  watch: {
    lesson: {
      handler(newValue, oldValue) {
        if (this.contentLoaded && Object.keys(oldValue).length === 0) {
          this.updateSubmittedBy(
            this.activeProjectUsers.find(
              (user) => user.id == this.lesson.user_id
            )
          );
          this.updateCategory(
            this.taskTypes.find(
              (category) => category.id == this.lesson.task_type_id
            )
          );
          this.updateStage(
            this.lessonStages.find((stage) => stage.id == this.lesson.stage)
          );
          this.relatedTasks = this.lesson.sub_tasks;
          this.relatedIssues = this.lesson.sub_issues;
          this.relatedRisks = this.lesson.sub_risk_ids.map((id) => {
            return { id: id, text: "No Title Yet", facilityName: "N/A" };
          });
        }
      },
    },
    contentLoaded: {
      handler() {
        if (this.lesson) {
          this.updateSubmittedBy(
            this.activeProjectUsers.find(
              (user) => user.id == this.lesson.user_id
            )
          );
          this.updateCategory(
            this.taskTypes.find(
              (category) => category.id == this.lesson.task_type_id
            )
          );
          this.updateStage(
            this.lessonStages.find((stage) => stage.id == this.lesson.stage)
          );
          this.relatedTasks = this.lesson.sub_tasks;
          this.relatedIssues = this.lesson.sub_issues;
          this.relatedRisks = this.lesson.sub_risk_ids.map((id) => {
            return { id: id, text: "No Title Yet", facilityName: "N/A" };
          });
        }
      },
    },
  },
};
</script>

<style lang="scss" scoped>
a {
  color: #007bff;
}
a:hover {
  text-decoration: unset;
}
.text-smaller {
  font-size: smaller;
}
.success-card {
  background-color: #ededed;
  border-color: lightgray;
}
</style>
