<template>
<div class="container-fluid mt-3 mx-3">
  <!-- Actual Portfolio name will be dynamic value of organization name   -->
<div>
<span> <img class="mb-2" style="width:40px" :src="require('../../../../assets/images/mpathcircles.JPG')" /> 
<h3 class="d-inline mt-1 programName" >MicroHealth BO Portfolio</h3>
</span>
   <span class="float-right mr-4">
    <button style="cursor:pointer" @click.prevent="closeWindow">
      <i class="far fa-times-circle"></i>
    </button> 
   </span>
  </div>
  <el-tabs class="mt-1 mr-3 " type="border-card" @tab-click="handleClick">
  <el-tab-pane label="Portfolio View" class="p-3">
     <el-tabs class="mt-1" type="border-card" @tab-click="handleClick">
       <!-- TASKS -->
     <el-tab-pane class="p-3">
         <template slot="label" class="text-right">
           TASKS
           <span class="badge badge-secondary badge-pill">
              <span v-if="tasksObj">{{ tasksObj.length }}</span>
          </span>   
          </template>
             <div class="row pt-2">
               <div class="col-6 py-0">
                <div class="pb-0 pl-2 pr-4 mb-0 d-inline-flex">     
                  <div class="pr-4 text-center">             
                  <span class="d-block" v-tooltip="`COMPLETE`" ><i class="fas fa-clipboard-check text-success"></i></span>
                  <span class="smallerFont">COMPLETE</span>
                   <h4 class="d-block">{{ taskVariation.completed.count }}</h4>  
                  </div>
                  <div class="pr-4 text-center">
                   <span class="d-block" v-tooltip="`IN PROGRESS`"><i class="far fa-tasks text-primary"></i></span>
                     <span class="smallerFont">IN PROGRESS</span> 
                     <h4 class="d-block">{{ taskVariation.inProgress.count }}</h4>  
                  </div>
                   <div class="pr-4 text-center">
                  <span class="d-block" v-tooltip="`OVERDUE`"><font-awesome-icon icon="calendar" class="text-danger"  /></span>
                    <span class="smallerFont">OVERDUE </span> 
                    <h4 class="d-block"> {{ taskVariation.overdue.count }}  </h4>    
                  </div>

                    <div class="pr-4 text-center">
                   <span class="d-block" v-tooltip="`ONGOING`"><i class="fas fa-retweet text-success"></i></span>
                    <span class="smallerFont">ONGOING </span>    
                    <h4 class="d-block"> <span v-if="tasksObj">{{ taskVariation.ongoing.count }}</span></h4>  
                 </div> 
                   <div class="pr-4 text-center">  
                      <span class="d-block" v-tooltip="`PLANNED`"><font-awesome-icon icon="calendar-check" class="text-secondary font-md"  /></span>
                      <span class="smallerFont">PLANNED</span>
                        <h4 class="d-block"> <span v-if="tasksObj">{{ taskVariation.planned.count }}</span></h4>  
                </div>
                  <div class="pr-4 text-center">
                     <span  v-tooltip="`ON HOLD`" class="d-block"><i class="fas fa-pause-circle text-primary font-md"></i></span>
                     <span class="smallerFont">ON HOLD</span> 
                       <h4 class="d-block">{{ taskVariation.onHoldT.count }}</h4>            
                </div>
                 <div class="pr-5 text-center">
                  <span  v-tooltip="`DRAFTS`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                  <span class="smallerFont">DRAFTS</span>   
                        <h4 class="d-block">{{  taskVariation.taskDrafts.count }}</h4>              
                </div> 
                </div>
              </div>

             <div class="col-3 text-center py-0">
                <label class="font-sm mb-0">Filter by Tag</label>
               <div class="px-4 mb-0 py-2 bg-light tagsCol d-inline-flex">     
                  <div class="text-center">             
                  <span class="d-block" v-tooltip="`${ taskVariation.watched.count }`" ><i class="fas fa-eye"></i></span>
                  <span class="smallerFont">ON WATCH</span>
                   <input class="d-block m-auto" type="checkbox" style="">              
                   <!-- <h4 class="d-block">{{ taskVariation.watched.count }}</h4>   -->
                  </div>
                  <div class="px-5 text-center">
                   <span class="d-block" v-tooltip="`${ taskVariation.important.count }`"><i class="fas fa-star text-warning"></i></span>
                     <span class="smallerFont">IMPORTANT</span> 
                       <input class="d-block m-auto" type="checkbox" style="">    
                     <!-- <h4 class="d-block">{{ taskVariation.important.count }}</h4>   -->
                  </div>
                   <div class="text-center">
                  <span class="d-block" v-tooltip="`${ taskVariation.briefings.count }`"> <i class="fas fa-presentation text-primary"></i></span>
                    <span class="smallerFont">BRIEFINGS </span> 
                      <input class="d-block m-auto" type="checkbox" style="">  
                    <!-- <h4 class="d-block"> {{ taskVariation.briefings.count }}  </h4>     -->
                  </div>
               </div>
             </div>

             <div class="col-3 py-0">
                <label class="font-sm mb-0">Programs</label>
                <el-select 
                                 
                    class="w-100" 
                    track-by="name" 
                    filterable
                    value-key="id"
                    multiple                                                                                                                                               
                    placeholder="Search and select Programs"
                  >
                  <el-option 
                                                                  
                                                               
                    >
                  </el-option>
                  </el-select> 
              </div>
              </div>

            <div class="row text-center mt-2" v-if="tasksObj !== null"> 
              <!-- TASKS TABLE -->
            <el-table
              :data="pagedTableData"  
              class="mt-4"
              border
              style="width: 100%">
            <el-table-column
              fixed
              prop="program_name"
              sortable
              :sort-method="test"
              label="Program"
              width="250">
            </el-table-column>
            <el-table-column
              prop="project_name"
              fixed
              sortable
              label="Project"
              width="225">
            </el-table-column>
            <el-table-column
              prop="text"
              fixed
              sortable
              label="Task"
              width="225">
            </el-table-column>
            <el-table-column
              prop="category"
              label="Category"
              sortable
              width="200">
            </el-table-column>
            <el-table-column
              prop="start_date"
              label="Start Date"
              sortable
              width="120">
            </el-table-column>
            <el-table-column
              prop="due_date"
              label="Due Date"
              sortable
              width="120">
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
              prop="last_update"
              fixed="right"
              label="Last Update"
              sortable
              width="250">
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
             <div class="float-right mt-2">
          <el-pagination
            
            @current-change="setPage"
            layout="prev, pager, next"
            :page-size="pageSize"
            :total="tasksObj.length">
          </el-pagination>
          </div>   


               
     </el-tab-pane>
      <el-tab-pane class="p-3">  
          <template slot="label" class="text-right">
           ISSUES
           <span class="badge badge-secondary badge-pill">
           <span v-if="issuesObj">{{ issuesObj.length }}</span>
          </span>   
          </template>      
             <div class="row pt-2 text-center w-50">          
                <div class="pb-0 pl-2 pr-4 mb-0">                  
                  <span class="d-block" v-tooltip="`COMPLETE`" ><i class="fas fa-clipboard-check text-success"></i></span>
                  <span class="smallerFont">COMPLETE</span>
                   <h4 class="d-block"> {{ issueVariation.completed.count }}</h4>  
                </div>
                 <div class="py-0 px-4 mb-0">
                  <span class="d-block" v-tooltip="`IN PROGRESS`"><i class="far fa-tasks text-primary"></i></span>
                     <span class="smallerFont">IN PROGRESS</span> 
                     <h4 class="d-block"> {{ issueVariation.inProgress.count }}</h4>  
                </div>
                 <div class="py-0 px-4 mb-0">
                   <span class="d-block" v-tooltip="`OVERDUE`"><font-awesome-icon icon="calendar" class="text-danger"  /></span>
                    <span class="smallerFont">OVERDUE </span> 
                    <h4 class="d-block">{{ issueVariation.overdue.count }}</h4>                     
                </div>
                
                 <div class="py-0 px-4  mb-0">                  
                  <span class="d-block" v-tooltip="`PLANNED`"><font-awesome-icon icon="calendar-check" class="text-secondary font-md"  /></span>
                      <span class="smallerFont">PLANNED</span>
                        <h4 class="d-block">{{ issueVariation.planned.count }}</h4>  
                </div>
                 <div class="py-0 px-4 mb-0">
                 <span  v-tooltip="`ON HOLD`" class="d-block"><i class="fas fa-pause-circle text-primary font-md"></i></span>
                     <span class="smallerFont">ON HOLD</span> 
                       <h4 class="d-block"> {{ issueVariation.onHoldI.count }}</h4>            
                </div>
                 <div class="py-0 px-4 mb-0">
                <span  v-tooltip="`DRAFTS`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                     <span class="smallerFont">DRAFTS</span>   
                       <h4 class="d-block"> {{ issueVariation.issueDrafts.count }}</h4>              
                </div> 
            
              </div>
  <!-- ISSUES TABLE -->

          <div class="row text-center mt-2" v-if="issuesObj !== null">      
            <el-table
              :data="issuesObj"
              border
              class="mt-4"
              style="width: 100%">
            <el-table-column
              fixed
              prop="program_name"
              sortable
              label="Program"
              width="250">
            </el-table-column>
            <el-table-column
              prop="project_name"
              label="Project"
              fixed
              sortable
              width="250">
            </el-table-column>
            <el-table-column
              prop="title"
              label="Issue"
              sortable
              fixed
              width="250">
            </el-table-column>
            <el-table-column
              prop="category"
              sortable
              label="Category"
              width="200">
            </el-table-column>
            <el-table-column
              prop="start_date"
              label="Start Date"
              sortable
              width="120">
            </el-table-column>
            <el-table-column
              prop="due_date"
              label="Due Date"
              sortable
              width="120">
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
              prop="last_update"
              label="Last Update"
              sortable
              fixed="right"
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
     <el-tab-pane class="p-3">
           <template slot="label" class="text-right">
           RISKS
           <span class="badge badge-secondary badge-pill">
              <span v-if="risksObj">{{ risksObj.length }}</span>
          </span>   
          </template>
            <div class="row pt-2 text-center w-50">
          
                <div class="pb-0 pl-2 pr-4 mb-0">                  
                  <span class="d-block" v-tooltip="`COMPLETE`" ><i class="fas fa-clipboard-check text-success"></i></span>
                  <span class="smallerFont">COMPLETE</span>
                   <h4 class="d-block"> {{ riskVariation.completed.count }}</h4>  
                </div>
                 <div class="py-0 px-4 mb-0">
                  <span class="d-block" v-tooltip="`IN PROGRESS`"><i class="far fa-tasks text-primary"></i></span>
                     <span class="smallerFont">IN PROGRESS</span> 
                     <h4 class="d-block"> {{ riskVariation.inProgress.count }}</h4>  
                </div>
                 <div class="py-0 px-4 mb-0">
                   <span class="d-block" v-tooltip="`OVERDUE`"><font-awesome-icon icon="calendar" class="text-danger"  /></span>
                    <span class="smallerFont">OVERDUE </span> 
                    <h4 class="d-block"> {{ riskVariation.overdue.count }}</h4>                     
                </div>
                 <div class="py-0 px-4 mb-0">
                   <span class="d-block" v-tooltip="`ONGOING`"><i class="fas fa-retweet text-success"></i></span>
                    <span class="smallerFont">ONGOING </span>    
                      <h4 class="d-block">{{ riskVariation.ongoing.count }}</h4>  
                </div> 
                 <div class="py-0 px-4  mb-0">
                  
                  <span class="d-block" v-tooltip="`PLANNED`"><font-awesome-icon icon="calendar-check" class="text-secondary font-md"  /></span>
                      <span class="smallerFont">PLANNED</span>
                        <h4 class="d-block">{{ riskVariation.planned.count }}</h4>  
                </div>
                 <div class="py-0 px-4 mb-0">
                 <span  v-tooltip="`ON HOLD`" class="d-block"><i class="fas fa-pause-circle text-primary font-md"></i></span>
                     <span class="smallerFont">ON HOLD</span> 
                       <h4 class="d-block">{{riskVariation.onHoldR.count }}</h4>            
                </div>
                 <div class="py-0 px-4 mb-0">
                <span  v-tooltip="`DRAFTS`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                     <span class="smallerFont">DRAFTS</span>   
                       <h4 class="d-block">{{ riskVariation.riskDrafts.count }}</h4>              
                </div> 
            
              </div>
<!-- RISKS TABLE -->
      <div class="row text-center mt-2" v-if="risksObj !== null">      
          <el-table
          :data="risksObj"
          border
          class="mt-4"
          style="width: 100%">
          <el-table-column
            fixed
            prop="program_name"
            sortable
            label="Program"
            width="250">
          </el-table-column>
          <el-table-column
            prop="project_name"
            label="Project"
            sortable
            fixed
            width="220">
          </el-table-column>
          <el-table-column
            prop="text"
            label="Risk"
            sortable
            fixed
            width="220">
          </el-table-column>
          <el-table-column
            prop="category"
            label="Category"
            sortable
            width="200">
          </el-table-column>
          <el-table-column
            prop="start_date"
            label="Start Date"
            sortable
            width="120">
          </el-table-column>
          <el-table-column
            prop="due_date"
            sortable
            label="RA Due Date"
            width="135">
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
            prop="last_update"
            label="Last Update"
            fixed="right"
            sortable
            width="250">
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
    <el-tab-pane class="p-3">
          <template slot="label" class="text-right">
           LESSONS LEARNED
           <span class="badge badge-secondary badge-pill">
           14
          </span>   
          </template>
           <div class="row pt-2 text-center w-50">          
                <div class="pb-0 pl-2 pr-4 mb-0">                  
                  <span class="d-block" v-tooltip="`COMPLETE`" ><i class="fas fa-clipboard-check text-success"></i></span>
                  <span class="smallerFont">COMPLETE</span>
                   <h4 class="d-block">12</h4>  
                </div>
            
                 <div class="py-0 px-4 mb-0">
                <span  v-tooltip="`DRAFTS`" class="d-block"><i class="fas fa-pencil-alt text-warning font-md"></i></span>
                     <span class="smallerFont">DRAFTS</span>   
                       <h4 class="d-block">6</h4>              
                </div>             
              </div>
      
    <!-- LESSONS LEARNED TABLE -->
        <div class="row text-center mt-2" v-if="programObj !== null">      
          <el-table
          :data="programObj"
          border
          class="mt-4"
          style="width: 100%">
          <el-table-column
            fixed
            prop="name"
            sortable
            label="Program"
            width="250">
          </el-table-column>
          <el-table-column
            prop="project"
            label="Project"
            fixed
            sortable
            width="250">
          </el-table-column>
          <el-table-column
            prop="lesson"
            sortable
            fixed
            label="Lessons Learned"
            width="250">
          </el-table-column>
          <el-table-column
            prop="date"
            label="Date"
            sortable
            width="120">
          </el-table-column>
          <el-table-column
            prop="addeBy"
            label="Added By"
            sortable
            width="200">
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
            fixed="right"
            width="250">
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
   <el-tab-pane disabled  label="Portfolio Analytics (Coming Soon)" class="p-3">
    
   </el-tab-pane>
    </el-tabs>

 <div class="mhLogo"> <img class="mb-2" style="width:125px" :src="require('../../../../assets/images/microhealthllc.png')" /></div>
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
      portfolioData: null, 
      tasksData: null, 
      issuesData: null, 
      risksData: null, 
      programId: null, 
      programName: null, 
      page: 1,
      pageSize: 10,
      tasksRequest: axios.get("/api/v1/portfolio/tasks"),
      issuesRequest: axios.get("/api/v1/portfolio/issues"),
      risksRequest: axios.get("/api/v1/portfolio/risks"),
      portfolioRequest: axios.get("/api/v1/portfolio/programs.json"),
      showMore: true,
      today: new Date().toISOString().slice(0, 10),
    };
  },
   mounted() { 
      axios.all([this.tasksRequest, this.issuesRequest, this.risksRequest, this.portfolioRequest]).then(axios.spread((...responses) => {
          this.tasksData = responses[0]
          this.issuesData = responses[1]
          this.risksData = responses[2]
          this.portfolioData = responses[3].data.projects
         })).catch(errors => {
  
    })
   
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
      if (this.portfolioData !== null) {
      return this.portfolioData
      }
    }, 
    tasksObj(){     
      if (this.tasksData !== null) {
      return this.tasksData.data
      }
    }, 
    issuesObj(){     
      if (this.issuesData !== null) {
      return this.issuesData.data
      }
    }, 
    risksObj(){     
      if (this.risksData !== null) {
      return this.risksData.data
      }
    }, 
     pagedTableData() {
       if (this.tasksObj && this.tasksObj !== undefined)
       return this.tasksObj.slice(this.pageSize * this.page - this.pageSize, this.pageSize * this.page)
     },
   taskVariation() {
      let planned = _.filter(
        this.tasksObj,
        (t) => t && t.draft == false && t.start_date && t.start_date > this.today 
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let taskDrafts = _.filter(
        this.tasksObj,
        (t) => t && t.draft == true
      );  
      let important = _.filter(
        this.tasksObj,
        (t) => t && t.important == true
      ); 
        let briefings = _.filter(
        this.tasksObj,
        (t) => t && t.reportable == true
      );
      let watched = _.filter(
        this.tasksObj,
        (t) => t && t.watched == true
      );
              
      let completed = _.filter(
        this.tasksObj,
        (t) => t && t.progress && t.progress == 100 
      );
      let inProgress = _.filter(
        this.tasksObj,
        (t) => t && t.progress < 100 && t.start_date <= this.today 
      );
     let onHoldT = _.filter(this.tasksObj, (t) => t && t.on_hold == true );
     let ongoing = _.filter(this.tasksObj, (t) => t && t.ongoing == true );
      // let completed_percent = this.getAverage(
      //   completed.length,
      //   this.tasksObj.length
      // );
      // let inProgress_percent = this.getAverage(
      //   inProgress.length,
      //   this.tasksObj.length
      // );
      let overdue = _.filter(this.tasksObj, (t) => t && t.due_date < this.today);
      // let overdue_percent = this.getAverage(
      //   overdue.length,
      //   this.tasksObj.length
      // );
     
      return {
        planned: {
          count: planned.length, 
          plannedTs: planned            
        },
        important: {
          count: important.length,             
        },
        briefings: {
          count: briefings.length,          
        },
        watched: {
          count: watched.length,          
        },
        onHoldT: {
          count: onHoldT.length,          
        },
        taskDrafts: {
          count: taskDrafts.length,          
        },
        completed: {
          count: completed.length,
          // percentage: Math.round(completed_percent),
        },      
        inProgress: {
          count: inProgress.length - planned.length,
          // percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          // percentage: Math.round(overdue_percent),
        },
        ongoing: {
          count: ongoing.length
        },     
      };
    },
     issueVariation() {
      let planned = _.filter(
        this.issuesObj,
        (t) => t && t.draft == false && t.start_date && t.start_date > this.today 
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let issueDrafts = _.filter(
        this.issuesObj,
        (t) => t && t.draft == true
      );      
      let completed = _.filter(
        this.issuesObj,
        (t) => t && t.progress && t.progress == 100 
      );
      let inProgress = _.filter(
        this.issuesObj,
        (t) => t && t.progress < 100 && t.start_date <= this.today 
      );
     let onHoldI = _.filter(this.issuesObj, (t) => t && t.on_hold == true );
     let overdue = _.filter(this.issuesObj, (t) => t && t.due_date < this.today);
    
      return {
        planned: {
          count: planned.length, 
          plannedTs: planned            
        },
        onHoldI: {
          count: onHoldI.length,          
        },
        issueDrafts: {
          count: issueDrafts.length,          
        },
        completed: {
          count: completed.length,
          // percentage: Math.round(completed_percent),
        },      
        inProgress: {
          count: inProgress.length - planned.length,
          // percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          // percentage: Math.round(overdue_percent),
        },
       };
    },
    riskVariation() {
      let planned = _.filter(
        this.risksObj,
        (t) => t && t.draft == false && t.start_date && t.start_date > this.today 
          // (t) => t && t.startDate && t.startDate > this.today 
      );     
     let riskDrafts = _.filter(
        this.risksObj,
        (t) => t && t.draft == true
      );      
      let completed = _.filter(
        this.risksObj,
        (t) => t && t.progress && t.progress == 100 
      );
      let inProgress = _.filter(
        this.risksObj,
        (t) => t && t.progress < 100 && t.start_date <= this.today 
      );
     let onHoldR = _.filter(this.risksObj, (t) => t && t.on_hold == true );
     let ongoing = _.filter(this.risksObj, (t) => t && t.ongoing == true );
     let overdue = _.filter(this.risksObj, (t) => t && t.due_date < this.today);
      return {
        planned: {
          count: planned.length, 
          plannedTs: planned            
        },
        onHoldR: {
          count: onHoldR.length,          
        },
        riskDrafts: {
          count: riskDrafts.length,          
        },
        completed: {
          count: completed.length,
          // percentage: Math.round(completed_percent),
        },      
        inProgress: {
          count: inProgress.length - planned.length,
          // percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          // percentage: Math.round(overdue_percent),
        },
        ongoing: {
          count: ongoing.length
        },     
      };
    },



  },
  methods: {
    
    log(e){
      console.log("this is Lessons" + e)
    },
    test(a,b) {
      this.programName = this.tasksObj. map(t => t.program_name) 
      // let name = this.tasksObj.program_name
       if (a[this.programName] <  b[this.programName]) return -1;
       if (a[this.programName] > b[this.programName]) return 1;
       return 0;  
    },
    setPage (val) {
      this.page = val
    },
    getProgramId(id){
      this.programId = id
      console.log(id)
    }, 
    closeWindow(){
     window.close()
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
    color: #383838;
    }
  }
.programNoBadge {
  box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
}
.tcard {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, .10);
}
.mhLogo {
  position: fixed;
  bottom: 1%;
  right: 1.5%;
  z-index: 10;
}
.tagsCol {
  border-radius: 4px;
  border: .5px solid lightgray;
}
.fa-times-circle {
  font-size: 1.40rem;
  font-weight: 400;
  transition: all .2s ease-in;
  // box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
  //   0 3px 3px rgba(56, 56, 56, 0.23);
}
.fa-times-circle:hover {
  transform: scale(1.25); 
}

</style>
