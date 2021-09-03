<template>
  <form
    @submit.prevent="saveLesson"
    :class="{ _disabled: !lessonsLoaded }"
    accept-charset="UTF-8"
  >
    <div class="mt-2  d-flex align-items-center">
      <!-- Breadcrumbs and form buttons -->
      <div>
        <h5 class="mb-0">
          <span style="font-size: 16px; margin-right: 10px"
            ><i class="fas fa-suitcase"></i
          ></span>
            <router-link v-if="lesson"  :to="
                `/portfolio`
              ">{{
                  lesson.facility_name
            }}            
            </router-link>
          <el-icon
            class="el-icon-arrow-right"
            style="font-size: 12px"
          ></el-icon>
          <router-link
            :to="
              `/portfolio`
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
      <div class="ml-auto d-flex align-items-center">
        <button
          v-if="_isallowed('write')"
          class="btn btn-sm sticky-btn btn-primary text-nowrap btn-shadow mr-2"
        >
          Save Lesson
        </button>
        <button
          v-else
          disabled
          class="btn btn-sm sticky-btn btn-primary text-nowrap btn-shadow mr-2"
        >
          Read Only
        </button>
        <button
          class="btn btn-sm sticky-btn btn-outline-secondary btn-shadow mr-1"
          @click.prevent="close"
        >
          Close
        </button>
      </div>
    </div>
    <hr class=" mb-6 mt-2" />
    <!-- Form Navigation Tabs -->
    <div class="d-flex pt-1 mb-1 justify-content-start">
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
    <div class="pt-1">
      <div v-if="errors.items.length > 0" class="text-danger ">
        Please fill the required fields before submitting
        <ul class="error-list mx-4">
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
    <div v-show="currentTab == 'tab1'" class="row mt-2 mx-0">
      <div class="col-12 px-0">
        <label class="font-md"
          >Lesson Name <span style="color: #dc3545">*</span></label
        >
        <div
          class="toggleWrapper float-right tagsCol"
          :class="{ 'font-sm': isMapView }"
        >
          <span
            v-if="_isallowed('write')"
            class="watch_action clickable mx-2"
            @click.prevent.stop="toggleImportant"
            v-tooltip="`Important`"
          >
            <span v-show="lesson.important">
              <i class="fas fa-star text-warning"></i>
            </span>
            <span v-show="!lesson.important">
              <i class="far fa-star" style="color:lightgray;cursor:pointer"></i>
            </span>
            <small
              :class="{ 'd-none': isMapView }"
              style="vertical-align:text-top"
            >
              Important
            </small>
          </span>

          <span
            v-if="_isallowed('write')"
            class="watch_action clickable mx-2"
            @click.prevent.stop="toggleReportable"
            v-tooltip="`Briefings`" 
          >
            <span v-show="lesson.reportable">
            <i class="fas fa-presentation text-primary"></i>
            </span>
            <span v-show="!lesson.reportable">
              <i class="fas fa-presentation" style="color:lightgray;cursor:pointer"></i>
            </span>

            <small
              :class="{ 'd-none': isMapView }"
              style="vertical-align:text-top"
            >
              Briefings
            </small>
          </span>
          <span
            v-if="_isallowed('write')"
            class="watch_action clickable mx-2"
            @click.prevent.stop="toggleDraft"
            v-tooltip="`Draft`"
          >
            <span  v-show="lesson.draft">
              <i class="fas fa-pencil-alt text-warning"></i>
            </span>
            <span v-show="!lesson.draft">
              <i
                class="fas fa-pencil-alt"
                style="color:lightgray;cursor:pointer"
              ></i>
            </span>

            <small
              :class="{ 'd-none': isMapView }"
              style="vertical-align:text-top"
            >
              Draft
            </small>
          </span>
        </div>

        <el-input
          name="Lesson Name"
          v-validate="'required'"
          v-model="lesson.title"
          type="text"
          placeholder="Lesson Name"
          :class="{ error: errors.has('Lesson Name') }"
          :readonly="!_isallowed('write')"
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
          :readonly="!_isallowed('write')"
        ></el-input>
        <div v-show="errors.has('Description')" class="text-danger">
          {{ errors.first("Description") }}
        </div>
      </div>

      <div class="col-6 pl-0">
        <label class="font-md w-100">Process Area</label>
        <el-select
          v-model="lesson.task_type_id"
          class="w-100"
          value-key="id"
          name="Process Area"
          placeholder="Select Process Area"
          :disabled="!_isallowed('write')"
        >
          <!--TODO: Change taskTypes to categoryTypes -->
          <el-option
            v-for="category in taskTypes"
            :value="category.id"
            :key="category.id"
            :label="category.name"
          >
          </el-option>
        </el-select>
      </div>

      <div class="col-6 pl-0 pr-0">
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
            :disabled="!_isallowed('write')"
          />
        </div>
        <div v-show="errors.has('Date')" class="text-danger">
          {{ errors.first("Date") }}
        </div>
      </div>

      <div class="col-12 p-0">
        <div class="d-flex justify-content-between my-3">
          <label class="font-md">Select Stage</label
          ><button
            v-show="lesson.lesson_stage_id"
            class="btn btn-sm btn-danger btn-shadow font-sm"
            @click.prevent="clearStage"
            :disabled="!this._isallowed('write')"
          >
            Clear Stages
          </button>
        </div>

        <el-steps
          :active="
            lessonStages.findIndex(
              (stage) => stage.id == lesson.lesson_stage_id
            )
          "
          finish-status="success"
          v-model="lesson.lesson_stage_id"
          value-key="id"
          track-by="id"
          :class="{ 'over-six-steps': lessonStages.length >= 6 }"
        >
          <el-step
            v-for="stage in lessonStages"
            :key="stage.id"
            :value="stage"
            :title="stage.name"
            @click.native="changeStage(stage)"
            class="clickable"
          >
          </el-step>
        </el-steps>
      </div>
    </div>
    <!-- Related Tab -->
    <div v-show="currentTab == 'tab2'">
      <div class="row mt-1">
        <div :class="[isMapView ? 'col-12' : 'col']">
          Related Tasks
          <span
            v-if="_isallowed('write')"
            class="clickable"
            @click="openContextMenu($event, 'task')"
          >
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
                    {{ task.project_name || task.facilityName }}
                  </p>
                </div>
                <router-link
                  :to="
                    `/programs/${
                      $route.params.programId
                    }/${tab}/projects/${task.project_id ||
                      task.facilityId}/tasks/${task.id}`
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
                :disabled="!_isallowed('write')"
              ></el-button>
            </li>
          </ul>
        </div>
        <div :class="[isMapView ? 'col-12' : 'col']">
          Related Issues
          <span
            v-if="_isallowed('write')"
            class="clickable"
            @click="openContextMenu($event, 'issue')"
          >
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
                    {{ issue.project_name || issue.facilityName }}
                  </p>
                </div>
                <router-link
                  :to="
                    `/programs/${
                      $route.params.programId
                    }/${tab}/projects/${issue.project_id ||
                      issue.facilityId}/issues/${issue.id}`
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
                :disabled="!_isallowed('write')"
              ></el-button>
            </li>
          </ul>
        </div>
        <div :class="[isMapView ? 'col-12' : 'col']">
          Related Risks
          <span
            v-if="_isallowed('write')"
            class="clickable"
            @click="openContextMenu($event, 'risk')"
          >
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
                    {{ risk.project_name || risk.facilityName }}
                  </p>
                </div>
                <router-link
                  :to="
                    `/programs/${
                      $route.params.programId
                    }/${tab}/projects/${risk.project_id ||
                      risk.facilityId}/risks/${risk.id}`
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
                :disabled="!_isallowed('write')"
              ></el-button>
            </li>
          </ul>
        </div>
      </div>
    </div>
    <!-- Successes Tab -->
    <div v-show="currentTab == 'tab3'" class="mt-2">
      <span>Successes</span>
      <span
        v-if="_isallowed('write')"
        class="clickable"
        @click.prevent="addSuccess"
      >
        <i class="fas fa-plus-circle"></i>
      </span>
      <div class="font-sm" style="color: gray;">
        <label>Successes without findings will be deleted before Lesson is saved</label>
      </div>
      <paginate-links
        v-if="successes.length"
        for="successes"
        class="paginate"
        :show-step-links="true"
        :limit="2"
      ></paginate-links>
      <paginate
        ref="paginator"
        name="successes"
        :list="successes"
        :per="4"
        :key="successes ? successes.length : 1"
      >
        <el-card
          v-for="(success, index) in paginated('successes')"
          :key="index"
          class="success-card mb-3"
        >
          <div class="d-flex justify-content-between">
            <label class="font-md">Findings <span style="color: #dc3545">*</span></label>
            <div class="font-sm">
              <el-tag size="mini"
                ><span class="font-weight-bold">Submitted by:</span>
                <span v-if="success.updated_at"
                  >{{ author(success.user_id) }} on
                  {{ new Date(success.updated_at).toLocaleString() }}</span
                ><span v-else
                  >{{ $currentUser.full_name }} on
                  {{ new Date().toLocaleDateString() }}</span
                ></el-tag
              >
              <i
                class="el-icon-delete clickable ml-3"
                @click="removeSuccess(index)"
                v-if="_isallowed('delete')"
              ></i>
            </div>
          </div>

          <el-input
            v-model="success.finding"
            type="textarea"
            placeholder="Please enter findings here..."
            :readonly="!_isallowed('write')"
          ></el-input>

          <label class="font-md">Recommendation</label>
          <el-input
            v-model="success.recommendation"
            type="textarea"
            placeholder="Please recommendation here..."
            :readonly="!_isallowed('write')"
          ></el-input>
        </el-card>
      </paginate>
    </div>
    <!-- Failures Tab -->
    <div v-show="currentTab == 'tab4'" class="mt-2">
      <span>Failures</span>
      <span
        v-if="_isallowed('write')"
        class="clickable"
        @click.prevent="addFailure"
      >
        <i class="fas fa-plus-circle"></i>
      </span>
      <div class="font-sm" style="color: gray;">
        <label>Failures without findings will be deleted before Lesson is saved</label>
      </div>
      <paginate-links
        v-if="failures.length"
        for="failures"
        class="paginate"
        :show-step-links="true"
        :limit="2"
      ></paginate-links>
      <paginate
        ref="paginator"
        name="failures"
        :list="failures"
        :per="4"
        :key="failures ? failures.length : 1"
      >
        <el-card
          v-for="(failure, index) in paginated('failures')"
          :key="index"
          class="failure-card mb-3"
        >
          <div class="d-flex justify-content-between">
            <label class="font-md">Findings <span style="color: #dc3545">*</span></label>
            <div class="font-sm">
              <el-tag size="mini"
                ><span class="font-weight-bold">Submitted by:</span>
                <span v-if="failure.updated_at"
                  >{{ author(failure.user_id) }} on
                  {{ new Date(failure.updated_at).toLocaleString() }}</span
                ><span v-else
                  >{{ $currentUser.full_name }} on
                  {{ new Date().toLocaleDateString() }}</span
                ></el-tag
              >
              <i
                v-if="_isallowed('delete')"
                class="el-icon-delete clickable ml-3"
                @click="removeFailure(index)"
              ></i>
            </div>
          </div>

          <el-input
            v-model="failure.finding"
            type="textarea"
            placeholder="Please enter findings here..."
            :readonly="!_isallowed('write')"
          ></el-input>

          <label class="font-md">Recommendation</label>
          <el-input
            v-model="failure.recommendation"
            type="textarea"
            placeholder="Please recommendation here..."
            :readonly="!_isallowed('write')"
          ></el-input>
        </el-card>
      </paginate>
    </div>

    <!-- Best Practices Tab -->
    <div v-show="currentTab == 'tab5'" class="mt-2">
      <span>Best Practices</span>
      <span
        v-if="_isallowed('write')"
        class="clickable"
        @click.prevent="addBestPractice"
      >
        <i class="fas fa-plus-circle"></i>
      </span>
      <div class="font-sm" style="color: gray;">
        <label>Best Practices without findings will be deleted before Lesson is saved</label>
      </div>
      <paginate-links
        v-if="bestPractices.length"
        for="bestPractices"
        class="paginate"
        :show-step-links="true"
        :limit="2"
      ></paginate-links>
      <paginate
        ref="paginator"
        name="bestPractices"
        :list="bestPractices"
        :per="4"
        :key="bestPractices ? bestPractices.length : 1"
      >
        <el-card
          v-for="(bestPractice, index) in paginated('bestPractices')"
          :key="index"
          class="best-practice-card mb-3"
        >
          <div class="d-flex justify-content-between">
            <label class="font-md">Findings <span style="color: #dc3545">*</span></label>
            <div class="font-sm">
              <el-tag size="mini"
                ><span class="font-weight-bold">Submitted by:</span>
                <span v-if="bestPractice.updated_at"
                  >{{ author(bestPractice.user_id) }} on
                  {{ new Date(bestPractice.updated_at).toLocaleString() }}</span
                ><span v-else
                  >{{ $currentUser.full_name }} on
                  {{ new Date().toLocaleDateString() }}</span
                ></el-tag
              >
              <i
                v-if="_isallowed('delete')"
                class="el-icon-delete clickable ml-3"
                @click="removeBestPractice(index)"
              ></i>
            </div>
          </div>

          <el-input
            v-model="bestPractice.finding"
            type="textarea"
            placeholder="Please enter findings here..."
            :readonly="!_isallowed('write')"
          ></el-input>

          <label class="font-md">Recommendation</label>
          <el-input
            v-model="bestPractice.recommendation"
            type="textarea"
            placeholder="Please recommendation here..."
            :readonly="!_isallowed('write')"
          ></el-input>
        </el-card>
      </paginate>
    </div>

    <!-- Files & Links Tab -->
    <div v-show="currentTab == 'tab6'" class="row mt-2">
      <div class="col-6">
        <AttachmentInput
          v-if="_isallowed('write')"
          @input="addFile"
          :show-label="true"
          class="mb-3"
        />
        <div v-for="(file, index) in files" :key="index">
          <div
            class="clickable file-name d-flex justify-content-between w-100 py-1"
          >
            <div @click.prevent="downloadFile(file)">
              <font-awesome-icon icon="file" class="mr-2" />{{ file.name }}
            </div>
            <div v-if="_isallowed('delete')" @click="removeFile(file.id, index)">
              <i class="fas fa-times delete-icon"></i>
            </div>
          </div>
        </div>
      </div>
      <div class="col-6">
        <span v-if="_isallowed('write')">Add Link</span>
        <span
          v-if="_isallowed('write')"
          class="clickable"
          @click="addFileLink()"
        >
          <i class="fas fa-plus-circle"></i
        ></span>
        <div v-for="(link, index) in fileLinks" :key="index">
          <div
            v-if="link.id"
            class="d-flex clickable file-name justify-content-between py-1"
          >
            <a class="file-link" :href="link.uri" target="_blank"
              ><div>
                <i class="fas fa-link mr-1"></i>
                {{ link.name }}
              </div></a
            >
            <div
              v-if="_isallowed('delete')"
              @click="removeFileLink(link.id, index)"
            >
              <i class="fas fa-times delete-icon"></i>
            </div>
          </div>
          <div v-else class="d-flex justify-content-between">
            <el-input
              v-model="link.name"
              class="my-1"
              placeholder="Enter link to a site or file"
            ></el-input>
            <div @click="removeFileLink(link.id, index)" class="clickable">
              <i class="fas fa-times delete-icon"></i>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- Updates Tab -->
    <div v-show="currentTab == 'tab7'" class="mt-2">
      <label>Updates</label>
      <span
        v-if="_isallowed('write')"
        class="clickable"
        @click.prevent="addUpdate"
      >
        <i class="fas fa-plus-circle"></i>
      </span>
      <paginate-links
        v-if="updates.length"
        for="updates"
        class="paginate"
        :show-step-links="true"
        :limit="2"
      ></paginate-links>
      <paginate
        ref="paginator"
        name="updates"
        :list="updates"
        :per="4"
        :key="updates ? updates.length : 1"
      >
        <el-card
          v-for="(update, index) in paginated('updates')"
          :key="index"
          class="update-card mb-3"
        >
          <div class="d-flex justify-content-between">
            <label class="font-md">Description</label>
            <div class="font-sm">
              <el-tag size="mini"
                ><span class="font-weight-bold">Submitted by:</span>
                <span v-if="update.updated_at"
                  >{{ update.user.full_name }} on
                  {{ new Date(update.updated_at).toLocaleString() }}</span
                ><span v-else
                  >{{ $currentUser.full_name }} on
                  {{ new Date().toLocaleDateString() }}</span
                ></el-tag
              >
              <i
                v-if="_isallowed('delete')"
                class="el-icon-delete clickable ml-3"
                @click="removeUpdate(index)"
              ></i>
            </div>
          </div>

          <el-input
            v-model="update.body"
            type="textarea"
            placeholder="Please enter Description here..."
            :readonly="!_isallowed('write')"
          ></el-input>
        </el-card>
      </paginate>
    </div>

    <div v-if="!lessonsLoaded" class="load-spinner spinner-border"></div>
    <RelatedLessonMenu
      :facilities="facilities"
      :facilityGroups="facilityGroups"
      :relatedTasks="relatedTasks"
      :relatedIssues="relatedIssues"
      :relatedRisks="relatedRisks"
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
import AttachmentInput from "./../../shared/attachment_input.vue";

export default {
  name: "portfolioLessonForm",
  props: ["facility"],
  components: {
    FormTabs,
    RelatedLessonMenu,
    AttachmentInput,
  },
  data() {
    return {
      formLoaded: false,
      currentTab: "tab1",
      paginate: ["successes", "failures", "bestPractices", "updates"],
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
            "Process Area",
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
          label: "Best Practices",
          key: "tab5",
          closable: false,
          form_fields: [],
        },
        {
          label: "Files & Links",
          key: "tab6",
          closable: false,
          form_fields: ["Files"],
        },
        {
          label: "Updates",
          key: "tab7",
          closable: false,
          form_fields: [],
        },
      ],
      relatedTasks: [],
      relatedIssues: [],
      relatedRisks: [],
      successes: [],
      deleteSuccesses: [],
      failures: [],
      // important: null,
      deleteFailures: [],
      bestPractices: [],
      deleteBestPractices: [],
      updates: [],
      deleteUpdates: [],
      files: [],
      fileLinks: [],
      destroyFileIds: [],
    };
  },
  methods: {
    ...mapActions(["addLesson", "fetchLesson", "updateLesson"]),
    ...mapMutations(["SET_LESSON", "SET_LESSON_STATUS"]),
    saveLesson() {
      this.$validator.validate().then((success) => {
        if (!success) {
          return;
        }
        //removes empty updates, sucesses, failures, and best practices
        this.removeEmptyUpdates()
        this.successes = this.removeEmptySFBP(this.successes)
        this.failures = this.removeEmptySFBP(this.failures)
        this.bestPractices = this.removeEmptySFBP(this.bestPractices)
        let lessonData = {
          lesson: {
            title: this.lesson.title,
            description: this.lesson.description,
            date: this.lesson.date,
            task_type_id: this.lesson.task_type_id,
            lesson_stage_id: this.lesson.lesson_stage_id,
            important: this.lesson.important,
            reportable: this.lesson.reportable,
            draft: this.lesson.draft,
            // Array values below
            sub_task_ids: [...this.relatedTasks.map((task) => task.id)],
            sub_issue_ids: [...this.relatedIssues.map((issue) => issue.id)],
            sub_risk_ids: [...this.relatedRisks.map((risk) => risk.id)],
            successes: [...this.successes, ...this.deleteSuccesses],
            failures: [...this.failures, ...this.deleteFailures],
            best_practices: [
              ...this.bestPractices,
              ...this.deleteBestPractices,
            ],
            notes_attributes: [...this.updates, ...this.deleteUpdates],
            attach_files: [...this.files.filter((file) => !file.id)],
            file_links: [...this.fileLinks.filter((file) => !file.id)],
            destroy_file_ids: [...this.destroyFileIds],
          },
        };

        // Check to add or update existing lesson by confirming an id
        if (this.lesson.id) {
          delete this.$route.params.lesson;
          this.updateLesson({           
            ...lessonData,
            ...this.$route.params,
          });
        } else {
          lessonData.lesson.user_id = this.$currentUser.id;
          this.addLesson({
            ...lessonData,
            ...this.$route.params,
          });
        }
      });
    },
    removeEmptyUpdates(){
      var returnUpdates = [];
      for (let i in this.updates) {
        if(!this.updates[i].body && !this.updates[i]._destroy) continue;
        returnUpdates.push(this.updates[i]);
      }
      this.updates = [...returnUpdates];
    },
    removeEmptySFBP(sFBP){
      var returnSFBP = [];
      for (let i in sFBP) {
        if(!sFBP[i].finding && !sFBP[i]._destroy && !(this.lesson.draft && sFBP[i].recommendation)) continue;
        returnSFBP.push(sFBP[i]);        
      }
      return [...sFBP];
    },
    _isallowed(salut) {
        var programId = this.$route.params.programId;
        var projectId = this.$route.params.projectId
        let fPrivilege = this.$projectPrivileges[programId][projectId]
        let permissionHash = {"write": "W", "read": "R", "delete": "D"}
        let s = permissionHash[salut]
        return  fPrivilege.lessons.includes(s);      
    },
    close() {
       this.$emit("on-close-form");
    },
    onChangeTab(tab) {
      this.currentTab = tab ? tab.key : "tab1";
    },
    openContextMenu(e, item) {
      e.preventDefault();
      if (this._isallowed("write")) {
        this.$refs.menu.open(e, item);
      }
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
    addSuccess() {
      if (this._isallowed("write")) {
        this.successes.unshift({ id: "", finding: "", recommendation: "" });
      }
    },
    removeSuccess(index) {
      this.$confirm(
        "Are you sure you want to remove the selected Success?",
        "Warning",
        {
          confirmButtonText: "Remove",
          cancelButtonText: "Cancel",
          type: "warning",
        }
      )
        .then(() => {
          this.successes[index]._destroy = true;
          this.deleteSuccesses.push(this.successes[index]);
          this.successes.splice(index, 1);
        })
        .catch(() => {});
    },
    addFailure() {
      if (this._isallowed("write")) {
        this.failures.unshift({ id: "", finding: "", recommendation: "" });
      }
    },
    removeFailure(index) {
      this.$confirm(
        "Are you sure you want to remove the selected Failure?",
        "Warning",
        {
          confirmButtonText: "Remove",
          cancelButtonText: "Cancel",
          type: "warning",
        }
      )
        .then(() => {
          this.failures[index]._destroy = true;
          this.deleteFailures.push(this.failures[index]);
          this.failures.splice(index, 1);
        })
        .catch(() => {});
    },
    addBestPractice() {
      if (this._isallowed("write")) {
        this.bestPractices.unshift({ id: "", finding: "", recommendation: "" });
      }
    },
    removeBestPractice(index) {
      this.$confirm(
        "Are you sure you want to remove the selected Best Practice?",
        "Warning",
        {
          confirmButtonText: "Remove",
          cancelButtonText: "Cancel",
          type: "warning",
        }
      )
        .then(() => {
          this.bestPractices[index]._destroy = true;
          this.deleteBestPractices.push(this.bestPractices[index]);
          this.bestPractices.splice(index, 1);
        })
        .catch(() => {});
    },
    addUpdate() {
      this.updates.unshift({ id: "", body: "" });
    },
    removeUpdate(index) {
      this.$confirm(
        "Are you sure you want to remove the selected Update?",
        "Warning",
        {
          confirmButtonText: "Remove",
          cancelButtonText: "Cancel",
          type: "warning",
        }
      )
        .then(() => {
          this.updates[index]._destroy = true;
          this.deleteUpdates.push(this.updates[index]);
          this.updates.splice(index, 1);
        })
        .catch(() => {});
    },
    author(id) {
      return this.projectUsers.find((user) => user.id == id).fullName;
    },
    addFile(files) {
      files.forEach((file) => {
        file.guid = this.guid();
        this.files.push(file);
      });
    },
    addFileLink() {
      this.fileLinks.push({
        name: "",
      });
    },
    removeFile(id, index) {
      this.$confirm(
        `Are you sure you want to delete this file?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: "warning",
        }
      )
        .then(() => {
          this.files.splice(index, 1);
          if (id) {
            this.destroyFileIds.push(id);
          }
        })
        .catch(() => {});
    },
    removeFileLink(id, index) {
      this.$confirm(
        `Are you sure you want to delete this file link?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: "warning",
        }
      )
        .then(() => {
          this.fileLinks.splice(index, 1);
          if (id) {
            this.destroyFileIds.push(id);
          }
        })
        .catch(() => {});
    },
    downloadFile(file) {
      let url = window.location.origin + file.uri;
      window.open(url, "_blank");
    },
    changeStage(stage) {
      if (this.lesson.id && this._isallowed("write")) {
        this.lesson.lesson_stage_id = stage.id;
      } else if (this._isallowed("write")) {
        this.SET_LESSON({ ...this.lesson, lesson_stage_id: stage.id });
      }
    },
    clearStage() {
      this.lesson.lesson_stage_id = null;
    },
    toggleImportant() {
      this.SET_LESSON({ ...this.lesson, important: !this.lesson.important });
    },
    toggleDraft() {
      this.SET_LESSON({ ...this.lesson, draft: !this.lesson.draft });
    },
    toggleReportable() {
      this.SET_LESSON({ ...this.lesson, reportable: !this.lesson.reportable });
    },
    log(e)
    {
      // console.log(""+e);
    },
  },
  computed: {
    ...mapGetters([
      "projectUsers",
      "contentLoaded",
      "facilities",
      "facilityGroups",
      "lesson",
      "lessonsLoaded",
      "lessonStages",
      "lessonStatus",
      "taskTypes",
    ]),
    tab() {
      if (this.$route.path.includes("map")) {
        return "map";
      } else if (this.$route.path.includes("sheet")) {
        return "sheet";
     } else if (this.$route.path.includes("calendar")) {
        return "calendar";
      } else if (this.$route.path.includes("lessons")) {
        return "lessons";
      } else {
        return "kanban";
      }
    },
    projectNameLink() {
      if (this.$route.path.includes("map") || this.$route.path.includes("sheet") ) {
        return `/programs/${this.$route.params.programId}/${this.tab}/projects/${this.$route.params.projectId}/overview`;
      } else {
        return `/programs/${this.$route.params.programId}/${this.tab}`;
      }
    },
    isMapView() {
      return this.$route.name === "MapLessonForm";
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
        if (
          this.contentLoaded &&
          Object.keys(oldValue).length === 0 &&
          this.$route.params.lessonId != "new"
        ) {
          this.relatedTasks = this.lesson.sub_tasks;
          this.relatedIssues = this.lesson.sub_issues;
          this.important = this.lesson.important;
          this.draft = this.lesson.draft;
          this.reportable = this.lesson.reportable;
          this.relatedRisks = this.lesson.sub_risks;
          this.successes = this.lesson.successes;
          this.failures = this.lesson.failures;
          this.bestPractices = this.lesson.best_practices;
          this.updates = this.lesson.notes;
          this.files = this.lesson.attach_files.filter((file) => !file.link);
          this.fileLinks = this.lesson.attach_files.filter((file) => file.link);
        }
      },
    },
    contentLoaded: {
      handler() {
        if (this.lesson) {
          this.relatedTasks = this.lesson.sub_tasks;
          this.relatedIssues = this.lesson.sub_issues;
          this.important = this.lesson.important;
          this.draft = this.lesson.draft;
          this.reportable = this.lesson.reportable;
          this.relatedRisks = this.lesson.sub_risks;
          this.successes = this.lesson.successes;
          this.failures = this.lesson.failures;
          this.bestPractices = this.lesson.best_practices;
          this.updates = this.lesson.notes;
          this.files = this.lesson.attach_files.filter((file) => !file.link);
          this.fileLinks = this.lesson.attach_files.filter((file) => file.link);
        }
      },
    },
    "successes.length"(value, previous) {
      this.$nextTick(() => {
        if (this.$refs.paginator && (value === 1 || previous === 0)) {
          this.$refs.paginator.goToPage(1);
        }
      });
    },
    "failures.length"(value, previous) {
      this.$nextTick(() => {
        if (this.$refs.paginator && (value === 1 || previous === 0)) {
          this.$refs.paginator.goToPage(1);
        }
      });
    },
    "bestPractices.length"(value, previous) {
      this.$nextTick(() => {
        if (this.$refs.paginator && (value === 1 || previous === 0)) {
          this.$refs.paginator.goToPage(1);
        }
      });
    },
    "updates.length"(value, previous) {
      this.$nextTick(() => {
        if (this.$refs.paginator && (value === 1 || previous === 0)) {
          this.$refs.paginator.goToPage(1);
        }
      });
    },
    lessonStatus: {
      handler() {
        if (this.lessonStatus == 200) {
          this.$message({
            message: `${this.lesson.title} was saved successfully.`,
            type: "success",
            showClose: true,
          });
          this.SET_LESSON_STATUS(0);
          //Route to newly created task form page
         
            this.$router.push(
              `/portfolio`
          
        )}
        this.successes = this.lesson.successes;
        this.failures = this.lesson.failures;
        this.bestPractices = this.lesson.best_practices;
        this.updates = this.lesson.notes;
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
.success-card,
.failure-card,
.best-practice-card,
.update-card {
  background-color: #ededed;
  border-color: lightgray;
  border-left: 10px solid #5aaaff;
}
.error-list {
  list-style-type: circle;
  li {
    width: max-content;
  }
}
.paginate-links.successes {
  list-style: none !important;
  user-select: none;
  text-decoration-line: none !important;
  margin-bottom: 18px;
  a {
    width: 20px;
    height: 25px;
    margin-right: 0;
    border-radius: 2px;
    background-color: white;
    box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
      0 3px 3px rgba(56, 56, 56, 0.23);
    color: #383838;
    padding: 5px 12px;
    cursor: pointer;
    text-decoration-line: none !important;
  }
  a:hover {
    background-color: #ededed;
  }
  li.active a {
    font-weight: bold;
    color: #383838;
    background-color: rgba(211, 211, 211, 10%);
  }
  a.active {
    background-color: rgba(211, 211, 211, 10%);
  }
  li.next:before {
    content: " | ";
    margin-right: 13px;
    color: #ddd;
  }
  li.disabled a {
    color: #ccc;
    cursor: no-drop;
  }
  li {
    display: inline !important;
    margin: 1px;
    color: #383838 !important;
  }
}
.text-danger {
  font-size: 13px;
}
.over-six-steps {
  /deep/.el-step__title {
    font-size: 11px !important;
    line-height: 23px !important;
    margin: 5px !important;
  }
}
.tagsCol {
  background-color: #f8f9fa;
  border-radius: 4px;
  border: .5px solid lightgray;
}
.btn-shadow {
  box-shadow: 0 5px 10px rgba(56, 56, 56, 0.19),
    0 1px 1px rgba(56, 56, 56, 0.23);
}
.file-name:hover {
  background-color: #cdecf5;
}
.delete-icon {
  color: #dc3545;
}
.file-link {
  color: unset;
}
</style>
