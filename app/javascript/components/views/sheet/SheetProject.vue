<template>
 <div id="facility-sheets" data-cy="facility_sheets">
    <div v-if="contentLoaded" class="position-sticky">
      <div>
        <div>
          <div v-if="_isallowed('read')" class="container-fluid px-0 mx-1">            
            <div class="row filterDiv">      
               <div class="text-center filterLabel underline"><small class="px-2 bg">FILTERS </small></div>        
                <div class="col filterCol text-right">                 
                  <div
                  class="d-inline-block mr-1"
                    v-for="(filterArray, index) in getAllFilterNames"
                    :key="index"  
                  >
                    <span class="d-inline" v-if="getFilterValue(filterArray[0])">
                   
                        <span class="filter-green d-inline font-sm text-light px-2">{{ getFilterValue(filterArray[0]) }}</span>
                  
                    </span>
                  </div>
                </div>
            </div>
                 <div class="row row-1 mt-2">
    
              <div class="col-4">
                <div class="box-card my-el-card p-3" style="position:relative">
                  <div class="row">
                    <div class="col">
                      <p>PROJECT GROUP:</p>
                      <p>COMPLETION DATE:</p>
                      <p>
                        STATUS:
                        <span>
                          <small
                            v-if="!facility.statusId && _isallowed('write')"
                            class="ml-2 d-inline text-danger"
                            style="position:absolute"
                          >
                            Must be updated before you can enter a Completion
                            Date!
                          </small>
                        </span>
                      </p>
                    </div>

                    <div class="col">
                      <p
                       v-if="facility && facility.facility"
                        class="badge badge-secondary badge-pill font-weight-light"
                      >
                        {{ facility.facility.facilityGroupName }}
                      </p>
                      <div class="simple-select">
                        <v2-date-picker
                          v-model="dueDate"
                          value-type="YYYY-MM-DD"
                          format="DD MMM YYYY"
                          class="w-100 vue2-datepicker"
                          @input="onChange"
                          placeholder="DD MM YYYY"
                          :disabled="!_isallowed('write') || !facility.statusId"
                        />
                      </div>

                      <div class="el-dropdown-wrapper my-2">
                        <el-select
                          v-model="statusId"
                          track-by="id"
                          class="w-100"
                          @change="onChange"
                          :disabled="!_isallowed('write')"
                          placeholder="Select Project Status"
                        >
                          <el-option
                            v-for="item in statuses"
                            :label="item.name"
                            :key="item.id"
                            :value="item.id"
                          >
                          </el-option>
                        </el-select>
                      </div>
                    </div>
                  </div>
                  <button
                    v-if="_isallowed('write') && DV_updated"
                    class="btn btn-secondary mt-2 btn-sm apply-btn w-100"
                    @click="updateFacility"
                    :disabled="!DV_updated"
                  >
                    Apply
                  </button>
                </div>
              </div>  
              <div
                v-show="isSheetsView" 
                v-if="project"
                class="col-4"
                data-cy="date_set_filter"
              >
                <el-card class="box-card" style="background-color: #fafafa">
                  <div class="row">
                    <div class="col pb-0">
                      <h5 class="d-inline" style="font-weight: 600">CONTACT</h5>                     
                    </div>
                  </div>
                  <div class="row">
                    <div class="col font-sm">
                      <p class="mt-1 mb-0">
                        <span class="fbody-icon mr-2"
                          ><i class="far fa-id-badge"></i
                        ></span>
                        <!-- <span v-if="facility && facility.facility.pointOfContact">
                          {{ facility.facility.pointOfContact }}
                        </span> -->
                        <span class="d-inline">
                          <el-input
                            v-model="project.pointOfContact"
                            placeholder="Enter Point of Contact name"
                            name="Poc"
                            class="w-75"
                          />
                        </span>
                      </p>
                      <p class="mt-1 mb-0" v-if="project && project.address">
                        <span class="fbody-icon"
                          ><i class="fas fa-map-marker"></i
                        ></span>
                        <span>{{ project.address || "N/A" }}</span>
                      </p>
                      <p class="mt-1 mb-0">
                        <span class="fbody-icon mr-1"
                          ><i class="fas fa-phone"></i
                        ></span>
                        <!-- <span v-if="facility && facility.facility.phoneNumber !== null">
                          {{ facility.facility.phoneNumber }}
                        </span> -->
                         <span class="d-inline">
                          <el-input
                            v-model="project.phoneNumber"
                            placeholder="Enter Point of Contact phone number"
                            name="phoneNo"
                            class="w-75"
                          />
                        </span>
                      </p>
                      <p class="mt-1">
                        <span class="fbody-icon"
                          ><i class="far fa-envelope"></i
                        ></span>
                        <!-- <span  v-if=" facility && facility.facility.email">
                          {{ facility.facility.email  }}
                        </span> -->
                         <span class="d-inline">
                          <el-input
                            v-model="project.email"
                            placeholder="Enter Point of Contact email"
                            name="email"
                            class="w-75"
                          />
                        </span>


                      </p>
                    </div>
                  </div>                
                    <button 
                      :disabled="!project.pointOfContact"
                      :class="{'d-none': edit}"
                     class="btn btn-sm bg-primary text-light px-2 py-0 updateBtn"
                     @click.prevent="updateContactInfo">Save</button>
                     <button 
                      :class="{'d-none': !edit}"
                     class="btn btn-sm bg-dark text-light px-2 py-0 updateBtn"
                     @click.prevent="editBtn">Update</button>
                    <!-- <button class="btn btn-sm mh-blue text-light px-2 py-0 updateBtn" @click.prevent="updateContactInfo">Edit</button> -->
                
                </el-card>
              </div>
             </div>
                     
          </div>
          <div v-else class="text-danger mx-2 my-4">
            You don't have permission to read!
          </div>
        </div>
      </div>
    </div>
    <div v-else></div>
  </div>

</template>

<script>
import axios from "axios";
import http from "../../../common/http";
import { mapGetters, mapMutations, mapActions } from "vuex";
import Loader from "../../shared/loader";
import { API_BASE_PATH } from "./../../../mixins/utils";

export default {
  name: "SheetProject",
  components: {
    Loader,
  },
  props: ["currentFacility", "facility"],
  data() {
    return {
      dueDate: "",
      statusId: 0,
      edit: true,
      today:  new Date().toISOString().slice(0, 10),
      loading: true,
      DV_updated: false,
      notesQuery: "",
      _selected: null,
      _categories: null,

    };
  },
  beforeMount(){
     
  },
  mounted() {
    this.dueDate = this.facility.dueDate;
    this.statusId = this.facility.statusId;
    this.fetchProjectLessons(this.$route.params);
  },
  methods: {
    ...mapActions(["fetchProjectLessons", "fetchCurrentProject"]),
    ...mapMutations(["setTaskTypeFilter", "updateFacilityHash", "setContactInfoForm"]),
    editBtn(){
      this.edit = false
    },
    updateContactInfo() {
      let formData = new FormData();
          formData.append("facility[point_of_contact]", this.project.pointOfContact);  
          formData.append("facility[phone_number]", this.project.phoneNumber);
          formData.append("facility[email]",this.project.email);
    
      // formData.append("commit", "Update Project");
      // let url = `/admin/facilities/${this.$route.params.projectId}`;
      let url = `${API_BASE_PATH}/programs/${this.$route.params.programId}/projects/${this.$route.params.projectId}`; 
      let method = "PUT";
      axios({
        method: method,
        url: url,
        data: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .attributes["content"].value,
        },
      }).then((response) => {
        if (response.status === 200) {
          this.$message({
            message: `Edits has been saved successfully.`,
            type: "success",
            showClose: true,
          });
          this.fetchCurrentProject(this.$route.params.programId)
          this.edit = true
        }
      });
    },
    updateFacility(e) {
      if (e.target) e.target.blur();
      if (!this._isallowed("write") || !this.DV_updated) return;
      this.DV_updated = false;
      let data = {
        facility: {
          statusId: this.statusId,
          dueDate: this.dueDate,
        },
      };
      // Used to update state
      let updatedFacility = Object.assign(this.facility, {
        statusId: this.statusId,
        dueDate: this.dueDate,
        projectStatus: this.statuses.find(
          (status) => status.id === this.statusId
        ).name,
      });
      http
        .put(
          `/projects/${this.currentProject.id}/facilities/${this.$route.params.projectId}.json`,
          data
        )
        .then((res) => {
          this.updateFacilityHash(updatedFacility);
          if (res.status === 200) {
            this.$message({
              message: `${res.data.facility.facilityName} was saved successfully.`,
              type: "success",
              showClose: true,
            });
          }
        })
        .catch((err) => {
          console.error(err);
        });
    },
    log(e){
      console.log(e)
    },
     _isallowed(salut) {
        var programId = this.$route.params.programId;
        var projectId = this.$route.params.projectId
        let fPrivilege = this.$projectPrivileges[programId][projectId]
        let permissionHash = {"write": "W", "read": "R", "delete": "D"}
        let s = permissionHash[salut]
        return  fPrivilege.overview.includes(s);      
    },
    isBlockedStatus(status) {
      return (
        status &&
        status.name.toLowerCase().includes("complete") &&
        this.facility.progress < 100
      );
    },
    // log(e){
    //   console.log("getAllFilterNames" + e)
    // },
   onChange() {
      this.$nextTick(() => {
        this.DV_updated = true;
      });
    },
  },
  computed: {
    ...mapGetters([
      "facilityGroupFacilities",    
      "getAllFilterNames",
      "contactInfoForm",
      "getFilterValue",
      "contentLoaded",
      "currentProject",     
      "statuses",    
      "facilities",
      "getUnfilteredFacilities",
    ]),
    selectedStatus: {
      get() {
        return this.facility.statusId; //this.$data._selected
      },
      set(value) {
        this.$data._selected = value;
        // this.facility.statusId = value
        // console.log(value)
        if (value) {
          this.$nextTick(() => {
            this.DV_updated = true;
          });
          this.facility.statusId = value;
        }
      },
    },

    C_taskTypeFilter: {
      get() {
        return this.taskTypeFilter;
      },
      set(value) {
        //  console.log(" C_taskTypeFilter set value: " + value)
        this.setTaskTypeFilter(value);
      },
    },
    C_contactInfo: {
      get() {
        return this.contactInfoForm;
      },
      set(value) {
        //  console.log(" C_taskTypeFilter set value: " + value)
        this.setContactInfoForm(value);
      },
    },
    project(){
      if (this.facility){
        return this.facility.facility
      }
    },
    isMapView() {
      return this.$route.name.includes("Map");
    },
    isSheetsView() {
      return this.$route.name.includes("Sheet");
    },
  },
  watch: {
    contentLoaded: {
      handler() {
        this.dueDate = this.facility.dueDate;
        this.statusId = this.facility.statusId;
         this.facility = this.currentProject.facilities.find(
            (facility) => facility.facilityId == this.$route.params.projectId
         );
      },
    },
     facility: {
      handler() {
      if(this.$route.params.projectId){
        this.facility = this.currentProject.facilities.find(
            (facility) => facility.facilityId == this.$route.params.projectId
         );
      }
      },
    },
   },
 
};
</script>

<style lang="scss" scoped>
.f-head {
  word-break: break-word;
  text-overflow: ellipsis;
}
.f-notes {
  border: 1px solid #ccc;
  padding: 5px 10px;
  border-radius: 5px;
  overflow: auto;
  min-height: 20vh;
  max-height: 34vh;
}
.f-show-btn {
  font-size: 12px;
  font-style: italic;
  display: flex;
  flex-direction: row-reverse;
}
.custom-tab {
  background-color: #ededed !important;
  width: auto;
  text-transform: uppercase;
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.apply-btn,
.red,
.orange,
.green,
.grey,
.grey2,
.yellow {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.pg-content {
  width: 100%;
  height: 20px;
  font-size: 14px;
  font-weight: bold;
}
.vue-tabs {
  margin-top: 15px;
}
.vdp-datepicker {
  width: 100%;
}
.search-tab {
  width: 80%;
}
.displayNone {
  display: none !important;
}
.fa-building {
  font-size: large !important;
  color: #383838 !important;
}
.updateBtn{
  position: absolute;
  right: 24px;
  bottom: 20px
}
.close-sidebar-btn {
  z-index: 800;
  cursor: pointer;
  display: flex;
  position: absolute;
  left: 0;
  top: 0;
  background: #fff;
  padding: 5px;
}
.my-el-card {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}
.vue2-datepicker /deep/ .mx-input:disabled {
  color: #555;
  background-color: #fff;
}
.simple-select /deep/ .multiselect {
  .multiselect__placeholder {
    text-overflow: ellipsis;
  }
}
.fac-sum {
  border-radius: 2px;
  padding: 8px;
  margin-bottom: 8px;
  background-color: #fff;
  box-shadow: 0 5px 5px rgba(0, 0, 0, 0.19), 0 3px 3px rgba(0, 0, 0, 0.23);
}
.grey {
  background-color: lightgray;
}
.grey2 {
  background-color: #ededed;
}
.yellow {
  background-color: yellow;
}
.orange {
  background-color: #f0ad4e;
}
.green {
  background-color: rgb(92, 184, 92);
}
.red {
  background-color: #d9534f;
}
.red,
.orange,
.green,
.grey {
  color: white;
  border-radius: 3px;
}
.grey2 {
  border-radius: 3px;
}
.risk-card-title {
  font-size: 1rem;
}
.font-12 {
  font-size: 12px;
}
.mt-neg-4 {
  margin-top: -4px;
}
.underline {
  text-decoration: underline;
}
.smallerFont {
  font-size: 10px;
}
/deep/.el-collapse-item__header, /deep/.el-collapse-item__wrap  {
  border-bottom: none !important;
}
/deep/.el-card__body {
    padding-bottom: 0 !important;
}
/deep/.el-progress-circle {
  height: 100px !important;
  width: 100px !important;
}
/deep/.el-collapse-item__header {
  font-size: 2rem;
  }
/deep/.el-collapse-item__arrow, /deep/.el-icon-arrow-right {
  display: none;
}
.giantNumber {
  font-size: 3.7rem;
}
.halfRem{
  margin-top: 0.5rem;
  margin-bottom: 0.5rem;
}
.hide {
  visibility: hidden;
}
.relative {
  position: relative;
}
.absolute {
  position: absolute;
  top:7%;
  left:0;
}
.progressLabel {
  position: absolute;
}
.pill {
  position: absolute;
  top: 10%;
  right: 1%;
}
.filterDiv {
  position:fixed;
  top: 130px;
  right: 9.5%;
  width: 20%;
  border-radius: 4px; 
  border: .5px solid #383838;
  overflow-y: auto;
}
.filterLabel {
  position: fixed;
}
.filterCol {
  height: 70px;
}
@media screen and (min-width: 1550px) {
  .filterDiv {
    right: 8.5%;
  }
}
</style>