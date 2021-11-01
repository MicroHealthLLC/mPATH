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
    <el-breadcrumb separator-class="el-icon-arrow-right" class="mt-3 mb-4">
     <el-breadcrumb-item :to="backToSettings">
      <span style="cursor:pointer"><i class="far fa-cog mr-1"></i> PROGRAM SETTINGS </span>
     </el-breadcrumb-item>
     <h4 class="mt-4 ml-3"> 
     <i class="fal fa-network-wired mr-1 mh-orange-text"></i>  GROUPS
      </h4>
    </el-breadcrumb>

   
<div class="my-1 pb-2 buttonWrapper">
    <el-button @click.prevent="addGroup" class="bg-primary text-light mb-2" style="position:absolute"> 
    <i class="far fa-plus-circle mr-1"></i> Add Group
    </el-button>
     <div class="mb-2 mr-2 ml-auto d-flex" style="width:75%">
        <el-select
          class="w-100 mr-2"
          v-model="C_groupFilter" 
          track-by="id"
          value-key="id"
          multiple
          filterable
          clearable
          name="Project Group"         
          placeholder="Filter Group"
          >
          <el-option
          v-for="item in filteredFacilityGroups"
          :key="item.id"
          :label="item.name"
          :value="item">
        </el-option>
          
          </el-select>
        <el-input
          type="search"          
          placeholder="Search Group"
          aria-label="Search"            
          aria-describedby="search-addon"    
          v-model="search"
          data-cy=""
      >
        <el-button slot="prepend" icon="el-icon-search"></el-button>
      </el-input>     
      </div>
  </div>
  
   <el-table :data="filteredFacilityGroups.filter(data => !search || data.name.toLowerCase().includes(search.toLowerCase()))" style="width: 100%"  height="450">
    <el-table-column type="expand">
      <template slot-scope="props">
       <div class="container">
       <div class="row">
     
      <div class="col">
       <h5 class="mh-orange-text"> Projects 
         <span 
          class="badge badge-secondary badge-pill pill"
          >{{ props.row.facilities.length }}
        </span>
        </h5>
        <ul class="pl-3">
          <li v-for="item, i in props.row.facilities" :key="i">
              {{ item.facilityName }}
          </li>

        </ul>


       </div>      
      
       <div class="col">
     <h5 class="mh-orange-text"> Contracts
         <span 
          class="badge badge-secondary badge-pill pill"
          >{{ props.row.facilities.length }}
        </span>
        </h5>
       <ul class="pl-3">
          <li v-for="item, i in props.row.facilities" :key="i">
              {{ item.facilityName }}
          </li>
        </ul>

       </div>

       </div>

       </div>
      
      </template>
    </el-table-column>
    <el-table-column prop="name" sortable label="Groups"></el-table-column>
   </el-table>  
   <el-dialog :visible.sync="dialogVisible" append-to-body center class="contractForm p-0">
     <form
      accept-charset="UTF-8"    
      >      
       <div class="form-group mx-4">
          <label class="font-md"
            >New Group Name <span style="color: #dc3545">*</span></label
          >
          <el-input
            type="textarea"
            v-model="newGroupName"
            placeholder="Enter new Group name here"          
            rows="1"          
            name="Group Name"
          />
       </div>
      <div class="right mr-2">
        <el-button @click.prevent="saveGroup" class="bg-primary text-light mr-2">Save</el-button>
        </div>
    </form>
   </el-dialog>
    
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
  name: "AdminGroups",
  components: {
    ProjectSidebar
  },
  data() {
    return {
      currentFacility: {},
      dialogVisible: false,
      currentFacilityGroup: {},
      newGroupName: null,
      search:'',
      selectedProjectGroup: null, 
       expanded: {
        id: "",
      },
    };
  },
  methods: {
   ...mapMutations(['setProjectGroupFilter', 'setContractTable','setGroupFilter']), 
    expandFacilityGroup(group) {
      if (group.id == this.expanded.id) {
        this.expanded.id = "";
      } else {
        this.expanded.id = group.id;
        this.currentFacilityGroup = group;
        // this.currentFacility = this.facilityGroupFacilities(group)[0] || {};
      }
    },
   saveGroup(e){
      e.preventDefault();     
      let formData = new FormData();
      if (this.newGroupName !== null){
      formData.append("facility_group[name]", this.newGroupName); 
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
                message: `" ${this.newGroupName} ", has been saved successfully.`,
                type: "success",
                showClose: true,
              }),  
              this.dialogVisible = false  
          }
     })
      }
      else {
            this.$message({
                message: `Please enter new Group name`,
                type: "warning",
                showClose: true,
              })        
      }      
    },
    showFacility(facility) {
      this.currentFacility = facility;
    },
    handleClick(tab, event) {
        console.log(tab, event);
    },    
    addGroup(){
      this.dialogVisible = true;    
      this.newGroupName = null;
    },
   
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "facilities",
      'getContractTable',
      'getGroupFilter',
      'getProjectGroupFilter',
      "facilityGroupFacilities",
      'filteredFacilityGroups',
      'currentProject'
    ]), 
   backToSettings(){
     return `/programs/${this.$route.params.programId}/settings`  
    }, 
      // Filter for Projects Table
    C_groupFilter: {
      get() {
        return this.getGroupFilter;
      },
      set(value) {
        // console.log(value)
        this.setGroupFilter(value);
      },
    },
    // Filter when adding new Project
     C_projectGroupFilter: {
      get() {
        return this.getProjectGroupFilter;
      },
      set(value) {
        // console.log(value)
        this.setProjectGroupFilter(value);
      },
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
.buttonWrapper {
  border-bottom: lightgray solid 1px;
}
.right{
  text-align: right;
}
.fa-calendar {
  font-size: x-large; 
}
/deep/.el-table th.el-table__cell>.cell {
  color: #212529;
  font-size: 1.15rem;
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
/deep/.el-table__row .el-input .el-input__inner{
  border-style:none;
}
/deep/.el-table {
  font-size: 16px;
}
/deep/.hover-row .el-input .el-input__inner{
  border-style:solid;   
}
/deep/.el-dialog {
  width:30%;
  border-top: solid 5px  #1D336F !important;
}
.container {
  margin-left: 50px;
}


</style>