<template>
<div class="container-fluid mt-5 mx-3">
  <!-- Actual Portfolio name will be dynamic value of organization name   -->
<div>
 <h3 class="d-inline programName" >MicroHealth BO Portfolio</h3>
 <span class="float-right mr-4"><button style="cursor:pointer"><i class="far fa-times-circle"></i></button> </span>
  </div>
  <el-tabs class="mt-2 mr-3 " type="border-card" @tab-click="handleClick">
  <el-tab-pane label="Portfolio View" class="p-3">
     <el-tabs class="mt-1" type="border-card" @tab-click="handleClick">
       <!-- TASKS -->
     <el-tab-pane label="Tasks" class="p-3">
             <div class="row pt-2 text-center w-50 tcard">
          
                <div class="pb-0 pl-2 pr-4 mb-0">                  
                  <span class="d-block" v-tooltip="`COMPLETE`" ><i class="fas fa-clipboard-check text-success"></i></span>
                  <span class="smallerFont">COMPLETE</span>
                   <h4 class="d-block">12</h4>  
                </div>
                 <div class="py-0 px-4 mb-0">
                  <span class="d-block" v-tooltip="`IN PROGRESS`"><i class="far fa-tasks text-primary"></i></span>
                     <span class="smallerFont">IN PROGRESS</span> 
                     <h4 class="d-block">64</h4>  
                </div>
                 <div class="py-0 px-4 mb-0">
                   <span class="d-block" v-tooltip="`OVERDUE`"><font-awesome-icon icon="calendar" class="text-danger"  /></span>
                    <span class="smallerFont">OVERDUE </span> 
                    <h4 class="d-block">64</h4>                     
                </div>
                 <div class="py-0 px-4 mb-0">
                   <span class="d-block" v-tooltip="`ONGOING`"><i class="fas fa-retweet text-success"></i></span>
                    <span class="smallerFont">ONGOING </span>    
                      <h4 class="d-block">34</h4>  
                </div> 
                 <div class="py-0 px-4  mb-0">
                  
                  <span class="d-block" v-tooltip="`PLANNED`"><font-awesome-icon icon="calendar-check" class="text-secondary font-md"  /></span>
                      <span class="smallerFont">PLANNED</span>
                        <h4 class="d-block">10</h4>  
                </div>
                 <div class="py-0 px-4 mb-0">
                 <span  v-tooltip="`ON HOLD`" class="d-block"><i class="fas fa-pause-circle text-primary font-md"></i></span>
                     <span class="smallerFont">ON HOLD</span> 
                       <h4 class="d-block">42</h4>            
                </div>
                 <div class="py-0 px-4 mb-0">
                <span  v-tooltip="`DRAFTS`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                     <span class="smallerFont">DRAFTS</span>   
                       <h4 class="d-block">6</h4>              
                </div> 
            
              </div>

    <div class="row text-center mt-3" v-if="programObj !== null"> 
         
    <el-table
    :data="programObj"  
    class="mt-4 table-bordered"
    style="width: 100%">
    <el-table-column
      fixed
      prop="name"
      sortable
      label="Program"
      width="300">
    </el-table-column>
    <el-table-column
      prop="project"
       sortable
      label="Project"
      width="300">
    </el-table-column>
    <el-table-column
      prop="task"
       sortable
      label="Task"
      width="300">
    </el-table-column>
    <el-table-column
      prop="category"
      label="Category"
       sortable
      width="200">
    </el-table-column>
    <el-table-column
      prop="startDate"
      label="Start Date"
       sortable
      width="100">
    </el-table-column>
    <el-table-column
      prop="dueDate"
      label="Due Date"
       sortable
      width="100">
    </el-table-column>
     <el-table-column
      prop="users"
      label="Assigned Users"
       sortable
      width="200">
    </el-table-column>
    <el-table-column
      prop="progress"
      sortable
      label="Progress"
      width="100">
    </el-table-column>
    <el-table-column
      prop="flags"
      label="Flags"
       sortable
      width="150">
    </el-table-column>
     <el-table-column
      prop="lastUpdate"
      label="Last Update"
       sortable
      width="300">
    </el-table-column>
    <!-- <el-table-column
      fixed="right"
      label="Operations"
      width="120"> -->
      <!-- <template slot-scope="scope">
        <el-button @click="handleClick" type="text" size="small">Detail</el-button>
        <el-button type="text" size="small">Edit</el-button>
      </template> -->
    <!-- </el-table-column> -->
  </el-table>
     
              
    </div>       


               
     </el-tab-pane>
      <el-tab-pane label="Issues" class="p-3">
             <div class="row pt-2 text-center w-50 tcard">
          
                <div class="pb-0 pl-2 pr-4 mb-0">                  
                  <span class="d-block" v-tooltip="`COMPLETE`" ><i class="fas fa-clipboard-check text-success"></i></span>
                  <span class="smallerFont">COMPLETE</span>
                   <h4 class="d-block">19</h4>  
                </div>
                 <div class="py-0 px-4 mb-0">
                  <span class="d-block" v-tooltip="`IN PROGRESS`"><i class="far fa-tasks text-primary"></i></span>
                     <span class="smallerFont">IN PROGRESS</span> 
                     <h4 class="d-block">4</h4>  
                </div>
                 <div class="py-0 px-4 mb-0">
                   <span class="d-block" v-tooltip="`OVERDUE`"><font-awesome-icon icon="calendar" class="text-danger"  /></span>
                    <span class="smallerFont">OVERDUE </span> 
                    <h4 class="d-block">62</h4>                     
                </div>
                
                 <div class="py-0 px-4  mb-0">                  
                  <span class="d-block" v-tooltip="`PLANNED`"><font-awesome-icon icon="calendar-check" class="text-secondary font-md"  /></span>
                      <span class="smallerFont">PLANNED</span>
                        <h4 class="d-block">11</h4>  
                </div>
                 <div class="py-0 px-4 mb-0">
                 <span  v-tooltip="`ON HOLD`" class="d-block"><i class="fas fa-pause-circle text-primary font-md"></i></span>
                     <span class="smallerFont">ON HOLD</span> 
                       <h4 class="d-block">42</h4>            
                </div>
                 <div class="py-0 px-4 mb-0">
                <span  v-tooltip="`DRAFTS`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                     <span class="smallerFont">DRAFTS</span>   
                       <h4 class="d-block">6</h4>              
                </div> 
            
              </div>

                 <div class="row text-center mt-3" v-if="programObj !== null">      
    <el-table
    :data="programObj"
    stripe
    class="mt-4 table-bordered"
    style="width: 100%">
    <el-table-column
      fixed
      prop="name"
      sortable
      label="Program"
      width="300">
    </el-table-column>
    <el-table-column
      prop="project"
      label="Project"
       sortable
      width="300">
    </el-table-column>
    <el-table-column
      prop="issue"
      label="Issue"
       sortable
      width="300">
    </el-table-column>
    <el-table-column
      prop="category"
       sortable
      label="Category"
      width="200">
    </el-table-column>
    <el-table-column
      prop="startDate"
      label="Start Date"
       sortable
      width="100">
    </el-table-column>
    <el-table-column
      prop="dueDate"
      label="Due Date"
       sortable
      width="100">
    </el-table-column>
     <el-table-column
      prop="users"
      label="Assigned Users"
       sortable
      width="200">
    </el-table-column>
    <el-table-column
      prop="progress"
      sortable
      label="Progress"
      width="100">
    </el-table-column>
    <el-table-column
      prop="flags"
      label="Flags"
       sortable
      width="150">
    </el-table-column>
     <el-table-column
      prop="lastUpdate"
      label="Last Update"
       sortable
      width="300">
    </el-table-column>
    <!-- <el-table-column
      fixed="right"
      label="Operations"
      width="120"> -->
      <!-- <template slot-scope="scope">
        <el-button @click="handleClick" type="text" size="small">Detail</el-button>
        <el-button type="text" size="small">Edit</el-button>
      </template> -->
    <!-- </el-table-column> -->
  </el-table>
     
              
    </div>        

     </el-tab-pane>
     <el-tab-pane label="Risks" class="p-3">
            <div class="row pt-2 text-center w-50 tcard">
          
                <div class="pb-0 pl-2 pr-4 mb-0">                  
                  <span class="d-block" v-tooltip="`COMPLETE`" ><i class="fas fa-clipboard-check text-success"></i></span>
                  <span class="smallerFont">COMPLETE</span>
                   <h4 class="d-block">122</h4>  
                </div>
                 <div class="py-0 px-4 mb-0">
                  <span class="d-block" v-tooltip="`IN PROGRESS`"><i class="far fa-tasks text-primary"></i></span>
                     <span class="smallerFont">IN PROGRESS</span> 
                     <h4 class="d-block">624</h4>  
                </div>
                 <div class="py-0 px-4 mb-0">
                   <span class="d-block" v-tooltip="`OVERDUE`"><font-awesome-icon icon="calendar" class="text-danger"  /></span>
                    <span class="smallerFont">OVERDUE </span> 
                    <h4 class="d-block">55</h4>                     
                </div>
                 <div class="py-0 px-4 mb-0">
                   <span class="d-block" v-tooltip="`ONGOING`"><i class="fas fa-retweet text-success"></i></span>
                    <span class="smallerFont">ONGOING </span>    
                      <h4 class="d-block">32</h4>  
                </div> 
                 <div class="py-0 px-4  mb-0">
                  
                  <span class="d-block" v-tooltip="`PLANNED`"><font-awesome-icon icon="calendar-check" class="text-secondary font-md"  /></span>
                      <span class="smallerFont">PLANNED</span>
                        <h4 class="d-block">10</h4>  
                </div>
                 <div class="py-0 px-4 mb-0">
                 <span  v-tooltip="`ON HOLD`" class="d-block"><i class="fas fa-pause-circle text-primary font-md"></i></span>
                     <span class="smallerFont">ON HOLD</span> 
                       <h4 class="d-block">42</h4>            
                </div>
                 <div class="py-0 px-4 mb-0">
                <span  v-tooltip="`DRAFTS`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                     <span class="smallerFont">DRAFTS</span>   
                       <h4 class="d-block">6</h4>              
                </div> 
            
              </div>

      <div class="row text-center mt-3" v-if="programObj !== null">      
      <el-table
      :data="programObj"
      stripe
      class="mt-4 table-bordered"
      style="width: 100%">
      <el-table-column
        fixed
        prop="name"
        sortable
        label="Program"
        width="300">
      </el-table-column>
      <el-table-column
        prop="project"
        label="Project"
         sortable
        width="300">
      </el-table-column>
      <el-table-column
        prop="risk"
        label="Risk"
         sortable
        width="300">
      </el-table-column>
      <el-table-column
        prop="category"
        label="Category"
         sortable
        width="200">
      </el-table-column>
      <el-table-column
        prop="startDate"
        label="Start Date"
         sortable
        width="100">
      </el-table-column>
      <el-table-column
        prop="dueDate"
         sortable
        label="Due Date"
        width="100">
      </el-table-column>
      <el-table-column
        prop="users"
        label="Assigned Users"
         sortable
        width="200">
      </el-table-column>
      <el-table-column
        prop="progress"
        sortable
        label="Progress"
        width="100">
      </el-table-column>
      <el-table-column
        prop="flags"
        label="Flags"
         sortable
        width="150">
      </el-table-column>
      <el-table-column
        prop="lastUpdate"
        label="Last Update"
         sortable
        width="300">
      </el-table-column>
      <!-- <el-table-column
        fixed="right"
        label="Operations"
        width="120"> -->
        <!-- <template slot-scope="scope">
          <el-button @click="handleClick" type="text" size="small">Detail</el-button>
          <el-button type="text" size="small">Edit</el-button>
        </template> -->
      <!-- </el-table-column> -->
    </el-table>
      
                
      </div>         

     </el-tab-pane>
    <el-tab-pane label="Lessons Learned" class="p-3">
           <div class="row pt-2 text-center w-50 tcard">
          
                <div class="pb-0 pl-2 pr-4 mb-0">                  
                  <span class="d-block" v-tooltip="`COMPLETE`" ><i class="fas fa-clipboard-check text-success"></i></span>
                  <span class="smallerFont">COMPLETE</span>
                   <h4 class="d-block">12</h4>  
                </div>
                 <div class="py-0 px-4 mb-0">
                  <span class="d-block" v-tooltip="`IN PROGRESS`"><i class="far fa-tasks text-primary"></i></span>
                     <span class="smallerFont">IN PROGRESS</span> 
                     <h4 class="d-block">64</h4>  
                </div>
                 <div class="py-0 px-4 mb-0">
                   <span class="d-block" v-tooltip="`OVERDUE`"><font-awesome-icon icon="calendar" class="text-danger"  /></span>
                    <span class="smallerFont">OVERDUE </span> 
                    <h4 class="d-block">64</h4>                     
                </div>
                 <div class="py-0 px-4 mb-0">
                   <span class="d-block" v-tooltip="`ONGOING`"><i class="fas fa-retweet text-success"></i></span>
                    <span class="smallerFont">ONGOING </span>    
                      <h4 class="d-block">34</h4>  
                </div> 
                 <div class="py-0 px-4  mb-0">
                  
                  <span class="d-block" v-tooltip="`PLANNED`"><font-awesome-icon icon="calendar-check" class="text-secondary font-md"  /></span>
                      <span class="smallerFont">PLANNED</span>
                        <h4 class="d-block">10</h4>  
                </div>
                 <div class="py-0 px-4 mb-0">
                 <span  v-tooltip="`ON HOLD`" class="d-block"><i class="fas fa-pause-circle text-primary font-md"></i></span>
                     <span class="smallerFont">ON HOLD</span> 
                       <h4 class="d-block">42</h4>            
                </div>
                 <div class="py-0 px-4 mb-0">
                <span  v-tooltip="`DRAFTS`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                     <span class="smallerFont">DRAFTS</span>   
                       <h4 class="d-block">6</h4>              
                </div> 
            
              </div>

        <div class="row text-center mt-3" v-if="programObj !== null">      
        <el-table
        :data="programObj"
        stripe
        class="mt-4 table-bordered"
        style="width: 100%">
        <el-table-column
          fixed
          prop="name"
          sortable
          label="Program"
          width="300">
        </el-table-column>
        <el-table-column
          prop="project"
          label="Project"
          sortable
          width="300">
        </el-table-column>
        <el-table-column
          prop="lesson"
          sortable
          label="Lessons Learned"
          width="300">
        </el-table-column>
        <el-table-column
          prop="date"
          label="Date"
          sortable
          width="200">
        </el-table-column>
        <el-table-column
          prop="addeBy"
          label="Added By"
          sortable
          width="100">
        </el-table-column>
        <el-table-column
          prop="description"
          label="Description"
          sortable
          width="300">
        </el-table-column>
        <el-table-column
          prop="flags"
          label="Flags"
          sortable
          width="200">
        </el-table-column>
        <el-table-column
          prop="lastUpdate"
          label="Last Update"
          sortable
          width="300">
        </el-table-column>
        <!-- <el-table-column
          fixed="right"
          label="Operations"
          width="120"> -->
          <!-- <template slot-scope="scope">
            <el-button @click="handleClick" type="text" size="small">Detail</el-button>
            <el-button type="text" size="small">Edit</el-button>
          </template> -->
        <!-- </el-table-column> -->
      </el-table>
        
                  
        </div>        

     </el-tab-pane>
     </el-tabs>
    <div class="row pt-2">
    <div class="col-6 py-0 pl-0">      
    
       
          <!-- <el-popover
          placement="top-start"
          title="Project #"
          width="200"
          trigger="hover"
          content="This is the total number of programs in your portfolio.">
        <b class="badge bg-secondary text-light badge-pill" slot="reference"> </b>
        </el-popover> -->

    
  </div>
   </div>

   

 </el-tab-pane> 
   <el-tab-pane label="Portfolio Analytics" class="p-3">
   </el-tab-pane>
    </el-tabs>
  <!-- {{portfolioObj}} -->
</div>
</template>

<script>
import axios from 'axios';
import Loader from "../../shared/loader.vue";
import { mapGetters, mapActions } from "vuex";
export default {
  name: "PortfolioView",
  props: ["from"],
  components: {
    Loader,
  },
  data() {
    return {
      showLess: "Show More",
      portfolioObj: null,
      programId: null,
      closeWindow:'',
      showMore: true,
      today: new Date().toISOString().slice(0, 10),
    };
  },
   mounted() { 
     $( "#nav-wrap" ).hide();  
    axios
      .get('/api/v1/portfolio/programs.json')
      .then(response => (this.portfolioObj = response))    
      
    if (this.portfolioObj !== null) {
     console.log(this.portfolioObj.data)
     }
  },
  computed: {
    ...mapGetters([
  
    ]),
    //  projectObj() {
       
    //     return this.currentProject.facilities
    //   },
    isPortfolioView() {
      return this.$route.name.includes("Portfolio");
    }, 
    isMapView() {
      return this.$route.name.includes("Map");
    },
    isSheetsView() {
      return this.$route.name.includes("Sheet");
    },
    // programCount(){
      
    //   return this.portfolioObj.data.projects.length
    
    // },
    programObj(){     
      if (this.portfolioObj !== null) {
      return this.portfolioObj.data.projects
      }
    }, 
  
  },
  methods: {
    
    log(e){
      console.log("this is Lessons" + e)
    },
    getProgramId(id){
      this.programId = id
      console.log(id)
    }, 

    handleClick(tab, event) {
        console.log(tab, event);
    },
    // programRoute() {      
    //     return  ;
    // },
     facilityGroupProgress(f_group) {
      let ids = _.map(this.filteredFacilities("active"), "id");
      let mean =
        _.meanBy(
          _.filter(
            f_group.facilities,
            (f) =>
              ids.includes(f.facilityId) &&
              f.projectId == this.currentProject.id
          ),
          "progress"
        ) || 0;
      return Number(mean.toFixed(0));
    },
  },
   watch: {
    $route(to, from) {
      this.$store && this.$store.commit("nullifyTasksForManager");
    },
  },
};
</script>

<style scoped lang="scss">
.badge-color {
  height: 12px;
  padding-top: 2px;
}
.box-card {
  min-height: 150px;
}
.proj-type {
  display: inline;
  border-radius: 2px;
  padding: 4px;
  color: #fff;
  font-size: small;
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.fac-proj-status,
.tasks,
.issues,
.fac-groups {
  border-radius: 2px;
  background-color: #fff;
  box-shadow: 0 5px 5px rgba(0, 0, 0, 0.19), 0 3px 3px rgba(0, 0, 0, 0.23);
}
ul > li {
  display: inline-block !important;
  /* You can also add some margins here to make it look prettier */
  zoom: 1;
  *display: inline;
  /* this fix is needed for IE7- */
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
.green, .filterGreen {
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
.red,
.orange,
.green,
.grey,
.grey2,
.yellow {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.grey2 {
  border-radius: 3px;
}

.underline {
  text-decoration: underline;
}
.ongoing-bg {
  background-color: #e9ecef;
  border-radius: 0.25rem;
  font-size: 0.75rem;
  height: 20px;
}
.smallerFont {
  font-size: 10px;
}
.btn-info {
  box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
}

/deep/.el-collapse-item__header, /deep/.el-collapse-item__wrap  {
  border-bottom: none !important;
}

/deep/.el-card__body {
    padding-bottom: 0 !important;
}
/deep/.el-collapse-item__header {
  font-size: 2rem;
  }

/deep/.el-collapse-item__arrow, /deep/.el-icon-arrow-right {
  display: none;
}
.programName {
  font-variant: small-caps;
}
.giantNumber {
  font-size: 3.7rem;
}
.giantMapView {
  font-size: 3.25rem;
}

ul {
  margin-bottom: 0.5rem;
}
  // table {
  //   table-layout: fixed;
  //   width: 100%;
  //   color: #606266;
  //   position: relative;
  //   margin-bottom: 0 !important;
  // }
/deep/.el-table {
    padding-top: 0px;    
    width: 100%;
    margin-bottom: 6px;
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
    border-top: solid #ededed 1.8px;    
  }
/deep/.el-table {
  th {
    background-color: #ededed !important;
    text-align: center;     
    font-size: 0.70rem;
    color: #383838;
    }
  }
.programNoBadge {
  box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
}
.tcard {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, .10);
}
th {
  font-size: .75rem;
}
</style>
