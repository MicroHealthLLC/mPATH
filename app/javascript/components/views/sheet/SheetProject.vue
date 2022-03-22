<template>
 <div id="facility-sheets" data-cy="facility_sheets">
    <div v-if="contentLoaded" class="position-sticky">
      <div>
        <div>
          <div v-if="_isallowed('read')" class="container-fluid px-0 mx-1">            
            <div class="row filterDiv" v-show="isSheetsView">      
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

                  <hr class="mb-6 mt-4" /> 

                   <div class="d-flex pt-1 mb-1 justify-content-start">
                  <FormTabs
                    :current-tab="currentTab"
                    :tabs="tabs"
                    :allErrors="errors"
                    @on-change-tab="onChangeTab"
                  />
                </div>
             <div v-show="currentTab == 'tab1'" class="container mt-2 mx-0">
           
             <div class="row row-1 mt-3">    
              <div :class="[isMapView ? 'col-10' : 'col-5']">
               <div class="row"> 
                   <div class="col pt-2 text-right">     
                  <button
                    v-if="_isallowed('write')"
                    class="btn btn-primary text-light mt-1 btn-sm apply-btn"
                    :class="{'disabledBtn': !DV_updated }"
                    @click="updateFacility"  
                    :disabled="!DV_updated"             
                  >
                    Apply
                  </button>
                 </div>
                </div>
                <div class="row">              
                  <div class="col-6">  
                  <h6>GROUP NAME:</h6>

                  </div>
                  <div class="col-6" v-if="facility && facility.facility" >  
                   <b> {{ facility.facility.facilityGroupName }}  </b>
                 </div>            
                </div>   


                 <div class="row">              
                  <div class="col-6">  
                   <h6>COMPLETION DATE:</h6>
                  </div>
                  <div class="col-6 pt-0">  
                     <div class="simple-select">
                        <v2-date-picker
                          v-model="dueDate"
                          value-type="YYYY-MM-DD"
                          format="DD MMM YYYY"
                          class="w-100 vue2-datepicker mt-2"
                          @input="onChange"
                          placeholder="DD MM YYYY"
                          :disabled="!_isallowed('write') || !facility.statusId"
                        />
                      </div>

                 </div>            
                </div>   


                <div class="row">              
                  <div class="col-6">  
                      <h6>
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
                      </h6>

                  </div>
                  <div class="col-6">  
                    <div class="el-dropdown-wrapper">
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

              
              </div>  
           
             </div>

             </div>

      <div v-show="currentTab == 'tab2'" class="container mt-2 mx-0">
        <div class="row row-1 mt-3">    
        <div
          v-if="project"
          :class="[isMapView ? 'col-10' : '']"
          class="col-5"
          data-cy="date_set_filter"
        > 
        <div class="row pt-0 pb-2" :class="{'addHeight': !project.address}">
          <div class="col pt-0 text-right">
          <button 
            :disabled="!project.pointOfContact"
            :class="{'d-none': edit}"
            class="btn btn-primary text-light mt-1 btn-sm apply-btn"        
            @click.prevent="updateContactInfo">Save</button>
            <button 
            :class="{'d-none': !edit}"
              class="btn btn-info text-light mt-1 btn-sm apply-btn"                  
            @click.prevent="editBtn">Update
            </button>
          </div>
        </div>     
        <div class="row">
        <div class="col-1 pb-0 font-sm">
          <p>
              <span class="fbody-icon mr-2"
              ><i class="fas fa-user"></i
            ></span>
          </p>
        </div>
         <div class="col-11 pb-0 font-sm">
          <p>
               <el-input
                v-model="project.pointOfContact"
                placeholder="Enter Point of Contact name"
                name="Poc"
                :class="{'nonEditMode' : edit }"
              />
          </p>
        </div>

        </div>
      <div class="row" v-if="project && project.address">
        <div class="col-1 pb-0 font-sm">
          <p>
            <span class="fbody-icon"
              ><i class="fas fa-map-marker mr-3"></i
            ></span>
         
          </p>
        </div>
         <div class="col-11 pb-0 font-sm">
          <p>
            <span>{{ project.address || "N/A" }}</span>
          </p>
        </div>
       </div>


       <div class="row">
        <div class="col-1 pb-0 font-sm">
          <p>
               <span class="fbody-icon mr-1"
              ><i class="fas fa-phone"></i
            ></span>
          </p>
        </div>
         <div class="col-11 pb-0 font-sm">
          <p>
              <el-input
                v-model="project.phoneNumber"
                placeholder="Enter Point of Contact phone number"
                name="phoneNo"
               :class="{'nonEditMode' : edit }"
              />
          </p>
        </div>

        </div>
       <div class="row">
        <div class="col-1 pb-0 font-sm">
          <p>
             <span class="fbody-icon"
              ><i class="far fa-envelope"></i
            ></span>
          </p>
        </div>
         <div class="col-11 pb-0 font-sm">
          <p>
            <el-input
                v-model="project.email"
                placeholder="Enter Point of Contact email"
                name="email"
                :class="{'nonEditMode' : edit }"
              />
          </p>
        </div>

        </div>

       
        </div>
        </div>     
      </div>
               <div v-show="currentTab == 'tab3'" class="container mt-2 mx-0">
              <div class="row row-1 mt-3">    
              <div :class="[isMapView ? 'col-10' : 'col-5']">
                   <div class="row">
                    <div class="col ml-4">
                     <h5 class="d-inline" style="font-weight: 600"> 
                        <i class="far fa-file-contract mr-2 mh-orange-text"></i> 
                        Coming Soon
                      </h5>      
                    </div>
                  </div>                
                </div>  
         
             </div>
            

              </div>
      
                     
          </div>
          <div v-else class="text-danger mx-2 mt-5">
            <h5> <i>Sorry, you don't have read-permissions for this tab! Please click on any available tab.</i></h5>
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
import FormTabs from "../../shared/FormTabs.vue";
import { API_BASE_PATH } from "./../../../mixins/utils";

export default {
  name: "SheetProject",
  components: {
    Loader,
    FormTabs,
  },
  props: ["currentFacility", "facility"],
  data() {
    return {
      dueDate: "",
      statusId: 0,
      currentTab: "tab1",
      tabs: [
        {
          label: "Info",
          key: "tab1",
          closable: false,
        },
        {
          label: "Contact",
          key: "tab2",
          closable: false,
        },
        {
          label: "Contracts",
          key: "tab3",
          closable: false,
          },
      ],
      edit: true,
      today:  new Date().toISOString().slice(0, 10),
      loading: true,
      DV_updated: false,
      notesQuery: "",
      _selected: null,
      _categories: null
    };
  },
  mounted() {
  if (this.contentLoaded) {
      this.dueDate = this.facility.dueDate;
      this.statusId = this.facility.statusId;
    }
  },
  methods: {
    ...mapActions(["fetchCurrentProject"]),
    ...mapMutations(["setTaskTypeFilter", "updateFacilityHash", "setContactInfoForm"]),
    editBtn(){
      this.edit = false
    },
    onChangeTab(tab) {
      this.currentTab = tab ? tab.key : "tab1";     
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
         `${API_BASE_PATH}/programs/${this.$route.params.programId}/projects/${this.$route.params.projectId}.json`,
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
     _isallowed(salut) {
        return this.checkPrivileges("SheetProject", salut, this.$route)

        // var programId = this.$route.params.programId;
        // var projectId = this.$route.params.projectId
        // let fPrivilege = this.$projectPrivileges[programId][projectId]
        // let permissionHash = {"write": "W", "read": "R", "delete": "D"}
        // let s = permissionHash[salut]
        // return  fPrivilege.overview.includes(s);      
    }, 
    isBlockedStatus(status) {
      return (
        status &&
        status.name.toLowerCase().includes("complete") &&
        this.facility.progress < 100
      );
    },
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
.addHeight{
  margin-top: 30px;
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
.disabledBtn{
  background-color: #ededed;
  color: darkgray !important;
  border: solid lightgray .05px;
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
.nonEditMode {
  /deep/.el-input__inner {
  border: none;
  background-color: #fafafa;  
  pointer-events:none;
  }
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