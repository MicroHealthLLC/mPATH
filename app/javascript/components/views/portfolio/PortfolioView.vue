<template>
<div class="container-fluid m-2">
  <el-tabs type="border-card" @tab-click="handleClick">
  <el-tab-pane label="Portfolio Overview" class="p-3">
    <div class="row pt-2">
    <div class="col-6 py-0 pl-0">         
      <!-- Actual Portfolio name will be dynamic value of organization name   -->
        <h3 class="d-inline mr-2 programName" >MicroHealth BO Portfolio</h3>   
        <h3 v-if="portfolioObj !== null" class="d-inline">
          <el-popover
          placement="top-start"
          title="Project #"
          width="200"
          trigger="hover"
          content="This is the total number of programs in your portfolio.">
        <b class="badge bg-secondary text-light badge-pill" slot="reference"> {{ programCount }}</b>
        </el-popover>
      </h3>      
    
  </div>
   </div>

    <div class="row">
      <div class="col px-0" :class="[isMapView ? 'col-6' : '']" >
          <el-card
            class="box-card mb-2"
            style="background-color:#fff"
            data-cy="task_summary"
          >      
            <div class="row">
              <div class="col pl-2" :class="[isMapView ? 'pb-1 pl-3' : '']">              
                <h5 class="d-inline">TASKS</h5>
                <h5  class="d-inline">
                  <span class="badge bg-secondary text-light badge-pill float-right">{{
                   
                  }}</span>
                </h5>
                <hr class="mb-half"/>


              </div>
            </div>
             <div>
               <div class="row text-center">
                <div class="col-3 p-0 mb-0">
                  
                  <span class="d-block" v-tooltip="`COMPLETE`" ><i class="fas fa-clipboard-check text-success"></i></span>
                  <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">COMPLETE</span>
                    <!-- <span class="d-block smallerFont">COMPLETE</span> -->

                </div>
                 <div class="col-3 p-0 mb-0">
                  <span class="d-block" v-tooltip="`IN PROGRESS`"><i class="far fa-tasks text-primary"></i></span>
                     <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont"> IN PROGRESS</span>           
                </div>
                 <div class="col-3 p-0 mb-0">
                   <span class="d-block" v-tooltip="`OVERDUE`"><font-awesome-icon icon="calendar" class="text-danger"  /></span>
                    <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">OVERDUE </span>               
                </div>
                 <div class="col-3 p-0 mb-0">
                   <span class="d-block" v-tooltip="`ONGOING`"><i class="fas fa-retweet text-success"></i></span>
                    <span :class="[isMapView ? 'd-none' : 'd-block']" class="smallerFont">ONGOING </span>    
                </div>       
              </div>

                <!-- <div class="row text-center mt-0" :class="[filteredTasks.length > 0 ? '' : 'pb-3']">
                <div class="col-3 pb-0 mb-0">
                   <h4 class="">{{
                    taskVariation.completed.count
                  }}</h4>         
                </div>
                 <div class="col-3 pb-0 mb-0">
                  <h4>{{
                    taskVariation.inProgress.count
                  }}</h4>        
                </div>
                 <div class="col-3 pb-0 mb-0">
                   <h4>{{ taskVariation.overdue.count }}
                     </h4>
                                    
                </div>
                 <div class="col-3 pb-0 mb-0">
                  <h4>{{
                    taskVariation.ongoing.length
                  }}</h4>          
                </div>        
                </div>       -->

             
              <div >
                 <el-collapse id="roll_up" class="taskCard">
                  <el-collapse-item title="..." name="1">
                <div class="row mt-1 text-center">
                <div class="col p-0  mb-0">                  
                       NO DATA TO DISPLAY
                </div>             
              </div>        
                  </el-collapse-item>
                </el-collapse>
              </div>
            </div>

      
          </el-card>

      </div>
      <div class="col" :class="[isMapView ? 'col-6' : '']">
            <el-card
            class="box-card mb-2"
            style="background-color:#fff"
            data-cy="issue_summary"
          >
            <div class="row">
              <div class="col" :class="[isMapView ? 'pb-1' : '']">
                <h5 class="d-inline">ISSUES</h5>
                <h5 class="d-inline">
                 
                </h5>
                <hr class="mb-half"/>
              </div>
            </div>

        
        
          </el-card>
      </div>
      <div class="col px-0" :class="[isMapView ? 'col-6 pt-1' : '']" >
          <el-card
              class="box-card"
              style="background-color:#fff"
              data-cy="risk_summary"
            >
              <div class="row">
                <div class="col pb-0" :class="[isMapView ? 'pb-1' : '']">
                  <h5 class="d-inline">RISKS</h5>
                  <h5 class="d-inline">
                    <span class="badge bg-secondary text-light badge-pill float-right">{{
                      
                    }}</span>
                  </h5>
                  <hr class="mb-half" />
                </div>
              </div>           
            </el-card>
      </div>
      <div class="col-2" :class="[isMapView ? 'col-6 pt-1' : '']" >
          <el-card
              class="box-card"
              style="background-color:#fff"
            
            >
              <div class="row">
                <div class="col pb-0">
                  <h6 class="d-inline">LESSONS LEARNED</h6>                 
                  <hr />
                </div>
              </div>
             
            
            </el-card>
      </div>

    </div>
      <div class="row">
      <div class="col px-0" :class="[isMapView ? 'col-6' : '']" >
          <el-card
            class="box-card mb-2"
            style="background-color:#fff"
            data-cy="task_summary"
          >      
            <div class="row">
              <div class="col pl-2" :class="[isMapView ? 'pb-1 pl-3' : '']">              
                <h5 class="d-inline">PROGRAMS</h5>
                <h5  class="d-inline">
                  <span class="badge bg-secondary text-light badge-pill float-right">{{
                   programCount
                  }}</span>
                </h5>
                <hr class="mb-half"/>

                 <ul v-for="(item, index) in programObj"  :key="index" >              
                 <li class="p-2"> <router-link :to="`/programs/${item.id}/sheet`" style="cursor:pointer">{{ item.name }}</router-link> </li>    
                 </ul>

              </div>
            </div>

      
          </el-card>

      </div>
      <div class="col" :class="[isMapView ? 'col-6' : '']">
            <el-card
            class="box-card mb-2"
            style="background-color:#fff"
            data-cy="issue_summary"
          >
            <div class="row">
              <div class="col" :class="[isMapView ? 'pb-1' : '']">
                <h5 class="d-inline">COOL DATA</h5>
                <h5 class="d-inline">
                 
                </h5>
                <hr class="mb-half"/>
              </div>
            </div>

        
        
          </el-card>
      </div>
  
   

    </div>


  </el-tab-pane>
   <el-tab-pane label="Portfolio Breakdown " class="p-3">
     <div v-if="portfolioObj !== null">
      <div class="mb-2 float-right"> 
        <button class="btn btn-md btn-info"> PROGRAMS: {{ programCount }}</button>
      </div>
        <div class="pb-2 table-div" :load="log(JSON.stringify(portfolioObj.data.projects))" >
          <div v-if="portfolioObj !== null" class="grid-container">
            <el-card class="list-group-item text-center" style="min-height: 150px" v-for="(item, index) in programObj"  :key="index" >              
             
               <span class="p-2" > {{ item.name }} </span>          
            </el-card>
          </div>         
      </div>
     </div>

  </el-tab-pane>
   <el-tab-pane label="Portfolio Analytics" class="p-3">
     Coming Soon

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
      showMore: true,
      today: new Date().toISOString().slice(0, 10),
    };
  },
   mounted() {    
    axios
      .get('/api/v1/portfolio/programs.json')
      .then(response => (this.portfolioObj = response))
  },
  computed: {
    ...mapGetters([
  
    ]),
     projectObj() {
        return this.currentProject.facilities
      },
     projectObj() {
        return this.currentProject.facilities
      },

    isPortfolioView() {
      return this.$route.name.includes("Portfolio");
    }, 
    isMapView() {
      return this.$route.name.includes("Map");
    },
    isSheetsView() {
      return this.$route.name.includes("Sheet");
    },
    programCount(){
      // if (this.projectObj !== null)
      return this.portfolioObj.data.projects.length
    },
    programObj(){
      // if (this.projectObj !== null)
      return this.portfolioObj.data.projects
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
</style>
