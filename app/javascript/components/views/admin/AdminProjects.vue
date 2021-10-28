<template>
  <div
    v-loading="!contentLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)"
    class="row"
  >
    <div class="col-md-2">
      <ProjectSidebar
        :current-facility-group="currentFacilityGroup"
        :expanded="expanded"
        :current-facility="currentFacility"
        @on-expand-facility-group="expandFacilityGroup"
        @on-expand-facility="showFacility"
      />
    </div>
   <div class="col-md-10">
  <div class="right-panel">  
  <h5 class="mt-3 mb-5">  <i class="far fa-cog mr-2"></i>PROJECTS</h5>
   
      <font-awesome-icon icon="plus-circle" class="mr-1" />
  
    <form
      @submit.prevent="saveNewContract"    
      accept-charset="UTF-8"    
      >
    <div class="form-group mx-4">
        <label class="font-md"
        >Project Group<span style="color: #dc3545">*</span></label
        >
         <el-select
            class="w-100"
            v-model="value" 
            track-by="id"
            value-key="id"
            name="Project Group"         
            placeholder="Select Project Group"
          >
          <el-option
          v-for="item in filteredFacilityGroups"
          :key="item.id"
          :label="item.name"
          :value="item">
        </el-option>
          
          </el-select>
       </div>
       <div class="form-group mx-4">
          <label class="font-md"
            >Program Name <span style="color: #dc3545">*</span></label
          >
          <el-input
            type="textarea"
            v-model="contractNameText"
            placeholder="Enter contract name here"          
            rows="1"          
            name="Program Name"
          />
       </div>
         

  </form>
    
      <!-- <div v-if="currentFacility" class="d-inline"> <h5 class="text-center">{{ currentFacility.facilityName }} </h5></div> -->
       <div class="pr-3">   
          <router-view
            :key="$route.path"
            :facility="currentFacility"
            :facilityGroup="currentFacilityGroup"
          ></router-view>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { mapGetters, mapMutations } from "vuex";
import ProjectSidebar from "../../shared/ProjectSidebar";
export default {
  name: "AdminProjects",
  components: {
    ProjectSidebar
  },
  data() {
    return {
      currentFacility: {},
      currentFacilityGroup: {},
        projectNameText: '',
        selectedProjectGroup: null, 
        projectName: "",
        newProjectName: '',
        newProjectGroupName: '',
        contractNameText: '',
      value:'',
      expanded: {
        id: "",
      },
    };
  },
  methods: {
   ...mapMutations(['setProjectGroupFilter']), 
    expandFacilityGroup(group) {
      if (group.id == this.expanded.id) {
        this.expanded.id = "";
      } else {
        this.expanded.id = group.id;
        this.currentFacilityGroup = group;
        // this.currentFacility = this.facilityGroupFacilities(group)[0] || {};
      }
    },
    showFacility(facility) {
      this.currentFacility = facility;
    },
    handleClick(tab, event) {
        console.log(tab, event);
    },
    saveNewProject(e){
      e.preventDefault();     
      let formData = new FormData();
      formData.append("facility[facility_name]", this.newProjectName)
      if(this.C_projectGroupFilter !== null ){
       formData.append("facility[facility_group_id]", this.C_projectGroupFilter.id)      
      }        
      formData.append('facility[address]', '18 Boon Rd, Stow, MA 01775, USA')
      formData.append('facility[lat]', '42.4114459')
      formData.append('facility[lng]', '-71.5128223')
      formData.append('facility[point_of_contact]', 'Juan Rivera')
      formData.append('facility[phone_number]', '+16789009876')
      formData.append('facility[country_code]', "US")
      formData.append('facility[email]', 'test@test.com')
      formData.append('facility[status]', "active")
      formData.append('facility[project_ids][]', this.$route.params.programId)
      formData.append('commit', 'Create Project')
       let url = `/admin/facilities`;
        let method = "POST";
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
            // var responseRisk = humps.camelizeKeys(response.data.risk);
            // this.loadRisk(responseRisk);
            //this.$emit(callback, responseRisk);
            // this.updateRisksHash({ risk: responseRisk });
            if (response.status === 200) {
              this.$message({
                message: `New Project ${this.newProjectName} has been saved successfully.`,
                type: "success",
                showClose: true,
              })   
        
       }
     })
    },
    saveNewProjectGroup(e){
      e.preventDefault();     
      let formData = new FormData();
      formData.append("facility_group[name]", this.newProjectGroupName); 
      formData.append("facility_group[status]", "active"); 
      formData.append("commit", "Create Project Group");  
      
        let url = `/admin/facility_groups`;
        let method = "POST";
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
           if (response.status === 200) {
              this.$message({
                message: `New Project Group ${this.newProjectGroupName} has been saved successfully.`,
                type: "success",
                showClose: true,
              })   
        
       }
     })
    }
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "facilities",
      'getProjectGroupFilter',
      "facilityGroupFacilities",
      'filteredFacilityGroups'
    ]),
  },
     C_projectGroupFilter: {
      get() {
        return this.getProjectGroupFilter;
      },
      set(value) {
        // console.log(value)
        this.setProjectGroupFilter(value);
      },
    },
  beforeMount() {
    if (this.contentLoaded && this.$route.params.projectId) {
      this.currentFacility = this.facilities.find(
        (facility) => facility.facilityId == this.$route.params.projectId
      );
    }
  },
  watch: {
    contentLoaded: {
      handler() {
        if (this.$route.params.projectId) {
          this.currentFacility = this.facilities.find(
            (facility) => facility.facilityId == this.$route.params.projectId
          );
        }
      },
    },
    currentFacility: {
      handler() {
        this.currentFacilityGroup = this.facilityGroups.find(
          (group) => group.id == this.currentFacility.facility.facilityGroupId
        );

        this.expanded.id = this.currentFacilityGroup.id;
      },
    },
    facilities: {
      handler() {
        this.currentFacility = this.facilities.find(
          (facility) => facility.facilityId == this.$route.params.projectId
        );
      },
    },
  },
};
</script>

<style scoped lang="scss">
.fa-calendar {
  font-size: x-large; 
}
.tabs {
  background-color: #ededed;
  border-top: solid 0.3px #ededed;
  width: min-content;
  display: flex;
  box-shadow: 0 2.5px 2.5px rgba(0, 0, 0, 0.19), 0 3px 3px rgba(0, 0, 0, 0.23);
  .tab {
    cursor: pointer;
    padding: 7px 10px;
    border-radius: 0.1rem;
    font-weight: 500;
    letter-spacing: 1;
    transition: auto;
    font-size: 75%;
  }
  .active {
    color: #fff !important;
    background-color: #383838 !important;
  }
}
a {
  color: unset;
  text-decoration: unset;
}
.right-panel {
  height: calc(100vh - 100px);
  overflow-y: auto;
}
</style>