<template>
  <div>
    <div>
      <form accept-charset="UTF-8">
        <div class="mt-2  d-flex align-items-center">
          <!-- Breadcrumbs and form buttons -->
          <div>
            <h5 class="mb-0">
              <span style="font-size: 16px; margin-right: 10px"
                ><i class="fas fa-building"></i
              ></span>
              <router-link v-if="contentLoaded" :to="projectNameLink"
                >PROJECT NAME</router-link
              >
              <el-icon
                class="el-icon-arrow-right"
                style="font-size: 12px"
              ></el-icon>
              <router-link
                :to="
                  `/programs/${this.$route.params.programId}//projects/${this.$route.params.projectId}/lessons`
                "
                >Lessons</router-link
              >
              <el-icon
                class="el-icon-arrow-right"
                style="font-size: 12px"
              ></el-icon>
              <span style="color: gray">(Lesson Name)</span>
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
              data-cy="task_close_btn"
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
          <span style="color: #dc3545; font-size: 15px">*</span> Indicates
          required fields
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
              class="w-100"
              track-by="id"
              clearable
              filterable
              value-key="id"
              placeholder="Search and select user"
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
              class="w-100"
              track-by="id"
              value-key="id"
              name="Category"
              placeholder="Select Category"
            >
              <!-- TODO: Adjust taskTypes to categoryTypes -->
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
              class="w-100"
              clearable
              track-by="id"
              value-key="id"
              placeholder="Select Stage"
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
          <h1>RELATED</h1>
        </div>
        <!-- Successes Tab -->
        <div v-show="currentTab == 'tab3'">
          <h1>SUCCESSES</h1>
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
      </form>
    </div>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import FormTabs from "./../../shared/FormTabs";

export default {
  components: {
    FormTabs,
  },
  data() {
    return {
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
    };
  },
  methods: {
    onChangeTab(tab) {
      this.currentTab = tab ? tab.key : "tab1";
    },
  },
  computed: {
    ...mapGetters(["contentLoaded", "activeProjectUsers", "taskTypes"]),
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
        return `/programs/${this.$route.params.programId}/${this.tab}`;
      }
    },
  },
};
</script>

<style></style>
