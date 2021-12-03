<template>
  <div class="row">
     <div class="col-md-2">
      <SettingsSidebar/>
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

   
 <div class="my-1 pb-2 buttonWrapper container-fluid">
  <div class="row px-0">
    <div class="col">
    <el-button @click.prevent="addGroup" class="bg-primary text-light mb-2"> 
    <i class="far fa-plus-circle mr-1"></i> Add Group
    </el-button>
     </div>    
     <div class="col-5">     
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
      <!-- <div class="col pl-0">   
        <el-select
          class="w-100 mx-2"
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
      </div> -->
  </div>
 </div>
   <div
    v-loading="!contentLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)"
    class=""
  >
   <el-table 
   v-if="tableData && tableData.length > 0"
   :data="tableData.filter(data => !search || data.name.toLowerCase().includes(search.toLowerCase())).reverse()" 
   style="width: 100%"  height="475"
   >
    <el-table-column type="expand">
      <template slot-scope="props">
       <div class="container">
       <div class="row">
     
      <div class="col">
       <h5 class="mh-orange-text"> Projects 
         <span 
         v-if="props.row.facilities && props.row.facilities.length"
          class="badge badge-secondary badge-pill pill"
          >{{ props.row.facilities.length }}
        </span>
         <span 
          v-else
          class="badge badge-secondary badge-pill pill"
          >{{ 0 }}
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
          v-if="props.row.contracts && props.row.contracts.length"
           class="badge badge-secondary badge-pill pill"
          >{{ props.row.contracts.length }}
        </span>
           <span 
          v-else
          class="badge badge-secondary badge-pill pill"
          >{{ 0 }}
        </span>
        </h5>
       <ul class="pl-3">
          <li v-for="item, i in props.row.contracts" :key="i">
              {{ item.nickname }}
          </li>
        </ul>

       </div>

       </div>

       </div>
      
      </template>
    </el-table-column>
    <el-table-column prop="name" sortable label="Groups">
  <template slot-scope="props">
   {{props.row.name}}  
    <span class="ml-5 mr-2" v-if="props.row.facilities &&props.row.facilities.length">
      <i class="fal fa-clipboard-list mr-1 mh-green-text"></i>{{ props.row.facilities.length }} 
      </span> 
        <span class="ml-5 mr-2" v-else>
      <i class="fal fa-clipboard-list mr-1 mh-green-text"></i>{{0}}
      </span> 
  <span  v-if="props.row.contracts && props.row.contracts.length">
    <i class="far fa-file-contract mr-1 mh-orange-text"></i>{{ props.row.contracts.length }}
  </span>
      <span  v-else>
       <i class="far fa-file-contract mr-1 mh-orange-text"></i>{{0}}
      </span> 
  </template>

    </el-table-column>
    
    
   </el-table>  
   </div>
   <el-dialog :visible.sync="dialogVisible" append-to-body center class="contractForm p-0">
     <form
      accept-charset="UTF-8"    
      >      
       <div class="form-group mx-3">
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
        <el-button 
          @click.prevent="saveGroup"
          :disabled="!newGroupName"  
          class="bg-primary text-light mr-2" 
          :class="[hideSaveBtn ? 'd-none': '']">
          Save
       </el-button>       
        <el-button 
          @click.prevent="addAnotherGroup" 
          :class="[!hideSaveBtn ? 'd-none': '']" 
          class="bg-primary text-light mr-2">
          <i class="far fa-plus-circle mr-1"></i> Add Another Group
        </el-button>
        <el-button 
          @click.prevent="closeAddGroupBtn" 
          class="bg-danger text-light mr-2" 
          :class="[!hideSaveBtn ? 'd-none': '']">
          Close
        </el-button>
        </div>
    </form>
   </el-dialog>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
import SettingsSidebar from "./SettingsSidebar.vue";
export default {
  name: "SettingsGroups",
  components: {
    SettingsSidebar
  },
  data() {
    return {
      currentFacility: {},
      dialogVisible: false,
      currentFacilityGroup: {},
      newGroupName: null,
      programId: this.$route.params.programId,
      hideSaveBtn: false,
      search:'',
      selectedProjectGroup: null, 
       expanded: {
        id: "",
      },
    };
  },
  methods: {
   ...mapMutations(['setProjectGroupFilter', 'setContractTable','setGroupFilter', 'SET_GROUP_STATUS']), 
   ...mapActions(["createGroup", "fetchFacilityGroups", "updateGroup"]),
   addAnotherGroup() {
      this.C_projectGroupFilter = null;
      this.newGroupName = null;
      this.hideSaveBtn = false;  
    },
    closeAddGroupBtn() {
      this.dialogVisible = false;
      this.hideSaveBtn = false;
    },
    addGroup(){
      this.dialogVisible = true;    
      this.newGroupName = null;
      this.C_projectGroupFilter = null;     
    },
    saveGroup() {
        let groupData = {
          group: {
            name: this.newGroupName,
            project_id: this.$route.params.programId,
            status: 'active',
          }
        }
         this.createGroup({
            ...groupData,
          })
          this.fetchFacilityGroups();
          this.hideSaveBtn = true;
        
    },
    handleClick(tab, event) {
        // console.log(tab, event);
    },
   
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "facilities",
      "groups",
      "groupStatus",
      'getContractTable',
      'getGroupFilter',
      'getProjectGroupFilter',
      "facilityGroupFacilities",
      'facilityGroups',
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
    tableData() {
      if (
        // this.projectsLoaded &&
        this.facilityGroups &&
        this.facilityGroups.length > 0
      ) {
        return this.facilityGroups
      }
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
mounted() {
  //  this.fetchFacilityGroups()
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
    groupStatus: {
      handler() {
        if (this.groupStatus == 200) {
          this.$message({
            message: `${this.newGroupName} was saved successfully.`,
            type: "success",
            showClose: true,
          });
          this.SET_GROUP_STATUS(0);
          this.fetchFacilityGroups();        
        }
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