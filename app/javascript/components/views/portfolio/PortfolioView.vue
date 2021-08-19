<template>
  <div class="container-fluid mt-3 mx-3">
    <!-- Actual Portfolio name will be dynamic value of organization name   -->
    <div>
      <span>
        <img
          class="mb-2"
          style="width: 40px"
          :src="require('../../../../assets/images/mpathcircles.JPG')"
        />
        <h3 class="d-inline mt-1 programName">{{ this.$portfolio_heading }}</h3>
      </span>
      <span class="float-right mr-4">
        <button style="cursor: pointer" @click.prevent="closeWindow">
          <i class="far fa-times-circle"></i>
        </button>
      </span>
    </div>
    <el-tabs class="mt-1 mr-3" type="border-card">
      <el-tab-pane label="PORTFOLIO DATA VIEWER" class="p-3">
        <!-- El-Dialog is the Presentation.  This component is dynamically populated based on tab.  Thus, it appears just once in the file. -->
           
             <el-dialog :visible.sync="dialogVisible" append-to-body center>
                        <template slot="title">
                        <div v-if="dynamicObj.length > 0 && dynamicObj[currentTaskSlide] !== undefined" class="container-fluid">
                          <h3 class="pl-2 pr-5 mt-3 d-inline-block mh-blue px-3 text-light" style="cursor:pointer; position:absolute; left:0; top:0">{{ action }}</h3>
                           <div v-for="number in [currentTaskSlide]" :key="number" >
                           <div class="row justify-content-center">
                             <div class="col-3 pb-0">
                                 <img
                                    class="mb-0"
                                    style="width: 125px"
                                    :src="require('../../../../assets/images/mpath.png')"
                                  />
                             </div>
                             <div class="col-5 text-center px-3 py-2"  v-if="dynamicObj[currentTaskSlide]">
                              
                        
                              
                          <span v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].is_overdue" v-tooltip="`Overdue`">
                            <i class="fas fa-calendar text-danger mr-1" style="font-size:1.8rem"></i
                          ></span>
                          <span  v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].completed" v-tooltip="`Completed`"
                            ><i
                              class="fas fa-clipboard-check text-success mr-1" style="font-size:1.8rem"
                            ></i
                          ></span>
                          <span
                             v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].ongoing == true && dynamicObj[currentTaskSlide].closed == false"
                            v-tooltip="`Ongoing`"
                            ><i class="fas fa-retweet mr-1 text-success" style="font-size:1.8rem"></i
                          ></span>
                          <span
                             v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].closed"
                            v-tooltip="`Ongoing: Closed`"
                            ><i class="fas fa-retweet mr-1 text-secondary" style="font-size:1.8rem"></i
                          ></span>
                          <span
                             v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].on_hold == true"
                            v-tooltip="`On Hold`"
                          >
                            <i class="fas fa-pause-circle mr-1 text-primary" style="font-size:1.8rem"></i
                          ></span>
                          <span  v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].draft == true" v-tooltip="`Draft`">
                            <i class="fas fa-pencil-alt mr-1 text-warning" style="font-size:1.8rem"></i
                          ></span>
                         <span  v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].planned" v-tooltip="`Planned`">
                            <i class="fas fa-calendar-check text-info mr-1" style="font-size:1.8rem"></i
                          ></span>
                          <span
                             v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].in_progress"
                            v-tooltip="`In Progress`"
                          >
                            <i class="far fa-tasks text-primary mr-1" style="font-size:1.8rem"></i
                          ></span>

                          <span v-if="dynamicObj[currentTaskSlide].text"> 
                              <h2 class="mt-2 d-inline text-truncate">{{ dynamicObj[currentTaskSlide].text }}</h2>
                            </span>
                              <span v-if="dynamicObj[currentTaskSlide].title"> 
                              <h2 class="mt-2 d-inline text-truncate">{{ dynamicObj[currentTaskSlide].title }}</h2>
                            </span>
                             </div>
                                 <div class="col-3 mt-3">
                                 <img
                                     style="width: 145px"
                                    :src="require('../../../../assets/images/microhealthllc.png')"
                                  />
                             </div>
                          </div>

                               <div class="row pt-3 justify-content-center">

                                  <div class="col-3 text-center slideCol leftProgramCol">                                          
                                  
                             
                                   <div class="col py-2">  
                                    
                                    <h6 class="mh-orange leftColLabel text-light">PROGRAM</h6>
                                    <h4 v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].program_name">{{dynamicObj[currentTaskSlide].program_name}}</h4>
                                  </div>    
                              
                                  <div class="col truncate-line-two">    
                                       <h6 class="leftColLabel text-light mh-orange">PROJECT GROUP</h6>
                                   <h4 v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].project_group_name"> {{dynamicObj[currentTaskSlide].project_group_name}}  </h4>
                                                                 
                                  </div>  
                          
                                   <div class="col py-2">    
                                       <h6 class="leftColLabel text-light mh-orange">PROJECT</h6>
                                    <h4  v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].project_name">{{ dynamicObj[currentTaskSlide].project_name}}  </h4>                                                                 
                                  </div>  

                                     <div class="col">    
                                       <h6 class="leftColLabel mh-blue text-light">PROCESS AREA</h6>
                                    <h4 v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].category" >{{ dynamicObj[currentTaskSlide].category}}  </h4> 
                                    <h4 v-else> -- </h4>                                                                
                                  </div>  

                                </div>    
                               
                                                       
                                <div class="col-5 text-center lastUpdateCol mx-4 pt-0 px-0" v-if="dynamicObj[currentTaskSlide] !== undefined">
                                 <h3 class="mh-green text-light d-block">LAST UPDATE</h3>
                                 <div style="height:350px; overflow-y:auto">
                                 <span  v-if="dynamicObj[currentTaskSlide].notes_updated_at.length > 0">                    
                                  <span>
                                    <br>
                                   <h4 class="px-3"> <em>{{ dynamicObj[currentTaskSlide].notes[dynamicObj[currentTaskSlide].notes.length - 1].body }}</em></h4>
                                  </span>
                                   <span
                                    class="toolTip timeStamp px-2"                                                                 
                                   >
                                    <h5>{{
                                      moment(dynamicObj[currentTaskSlide].notes_updated_at[0]).format(
                                        "DD MMM YYYY, h:mm a "
                                      ) + ' By: ' +
                                     dynamicObj[currentTaskSlide].notes[dynamicObj[currentTaskSlide].notes.length - 1].user.full_name
                                    }} 
                                    </h5>
                                  </span>
                                   </span>
                                   <span v-else>
                                     <br>
                                      <h4 class="px-3" style="color:lightgray"><em>NO UPDATES</em></h4>
                                   </span>
                               </div>   

                                </div>


                                    <div class="col-3 mh-blue text-center text-light slideCol"  v-if="dynamicObj[currentTaskSlide] !== undefined">                                          
                                  
                             
                                   <div class="col pt-2" v-if="dynamicObj !== lessonsObj" >  
                                     <i class="fas fa-calendar text-light d-block pb-1" style="font-size:2.8rem"></i>
                                    <span v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].start_date" class="d-inline-block"> <h5>{{ moment(dynamicObj[currentTaskSlide].start_date).format( "DD MMM YYYY") }}</h5></span> 
                                    <span v-else> -- </span>
                                    - 
                                     <span v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].due_date" class="d-inline-block"> <h5> {{ moment(dynamicObj[currentTaskSlide].due_date).format("DD MMM YYYY") }}</h5></span>
                                     <span v-else>  </span>
                                    
                                  </div>    
                                  <div class="col pt-2" v-if="dynamicObj == lessonsObj" >  
                                     <i class="fas fa-calendar text-light d-block pb-1" style="font-size:2.8rem"></i>
                                    <span v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].date" class="d-inline-block"> <h5>{{ moment(dynamicObj[currentTaskSlide].date).format( "DD MMM YYYY") }}</h5></span>
  
                                  </div>    
                              
                              
                                    <div class="col mt-4 truncate-line-two" v-if="dynamicObj == lessonsObj" >      
                                   <i class="fas fa-user d-block text-light" style="font-size:2.8rem"></i>
                                          <span class="truncate-line-two" v-if="dynamicObj[currentTaskSlide].added_by"><h4>Added By:  {{ dynamicObj[currentTaskSlide].added_by }}</h4></span>
                                                                            
                                  </div>  
                          
                                   <div class="col mt-4 truncate-line-two">      
                                   <i class="fas fa-users d-block text-light" style="font-size:2.8rem"></i>
                                          <span class="truncate-line-two" v-if="dynamicObj[currentTaskSlide].users.length > 0"><h4> {{ dynamicObj[currentTaskSlide].users }}</h4></span>
                                          <span v-else> <h4>No Assignments</h4></span>                                        
                                  </div>  
             
                                   <div class="col" v-if="dynamicObj !== lessonsObj && !dynamicObj[currentTaskSlide].ongoing" >                               
                                                               
                                         <span :class="{ 'text-light': dynamicObj[currentTaskSlide].progress <= 0 }">
                                          <el-progress
                                            type="circle"
                                            class="py-2"                          
                                            :percentage="Math.round(dynamicObj[currentTaskSlide].progress)"
                                          ></el-progress>
                                          </span>
                                         <h4>{{action }} PROGRESS</h4>
                                        </div>          
                                      </div>    
  
                               </div>   
                               
                           </div>
                        
                        </div>
                        <div slot="footer" class="dialog-footer-left"  v-if="dynamicObj[currentTaskSlide] !== undefined">                       
                            <el-button class="elBtn tagsBtn py-1 text-light mr-2" > <h5 class="d-inline px-2 text-dark">TAGS: </h5>
                             <span
                            v-if="dynamicObj[currentTaskSlide].watched == true"
                            v-tooltip="`On Watch`"
                            ><i class="fas fa-eye mr-1 text-dark" style="font-size:1.5rem"></i
                          ></span> 
                          <span
                            v-if="dynamicObj[currentTaskSlide].important == true"
                            v-tooltip="`Important`"
                          >
                            <i class="fas fa-star text-warning mr-1 " style="font-size:1.5rem"></i
                          ></span> 
                          <span v-if="dynamicObj[currentTaskSlide].reportable" v-tooltip="`Briefings`">
                            <i class="fas fa-presentation mr-1 text-primary" style="font-size:1.5rem"></i
                          ></span>                
                            
                            
                            </el-button>
                         
                        </div>

                        <div slot="footer" class="dialog-footer">
                        <el-button class="mh-orange elBtn text-light" @click.prevent="previousTask"><i class="far fa-chevron-left" style="font-size:1.35rem"></i></el-button>
                        <el-button class="bg-secondary elBtn text-light" ><span style="font-size:1.35rem"><span>{{ action }}</span> {{ currentTaskSlide + 1 }} of {{ dynamicObj.length}}</span></el-button>                      
                        <el-button class="mh-orange elBtn text-light"  @click.prevent="nextTask"><i class="far fa-chevron-right" style="font-size:1.35rem"></i></el-button>
                        </div>
                        </template>
                        </el-dialog>
           <div class="row pb-4">
              <div class="col-4 py-2">
                <div class="w-100 d-flex">
                  <div class="d font-sm mt-2 mr-2">SEARCH</div>
                  <div class="w-100" v-if="currentTab == 'tasks'">
                  <el-input
                    type="search"
                    placeholder="Enter Tasks Search Criteria"
                    v-model="search_tasks"
                  >
                    <el-button slot="prepend" icon="el-icon-search"></el-button>
                  </el-input>
                  </div>
                   <div class="w-100" v-if="currentTab == 'issues'">
                  <el-input
                    type="search"
                    placeholder="Enter Issues Search Criteria"
                    v-model="search_issues"
                  >
                    <el-button slot="prepend" icon="el-icon-search"></el-button>
                  </el-input>
                  </div>
                <div class="w-100" v-if="currentTab == 'risks'">
                  <el-input
                    type="search"
                    placeholder="Enter Risks Search Criteria"
                    v-model="search_risks"
                  >
                    <el-button slot="prepend" icon="el-icon-search"></el-button>
                  </el-input>
                  </div>
                   <div class="w-100" v-if="currentTab == 'lessons'">
                  <el-input
                    type="search"
                    placeholder="Enter Lessons Search Criteria"
                    v-model="search_lessons"
                  >
                    <el-button slot="prepend" icon="el-icon-search"></el-button>
                  </el-input>
                  </div>


                </div>
              </div>

              <div class="col-4 py-2">
                <div class="d-flex w-100">          
                  <div class="font-sm px-0 mt-2 mr-2">PROGRAM<span class="invi">i</span>FILTER</div>           
                   <template>
                    <treeselect  
                    placeholder="Search and select" 
                    :multiple="true" 
                    @input="updateProgramFilterValue"
                    :value="C_portfolioNamesFilter"
                    :options="portfolioPrograms" 
                    v-model="C_portfolioNamesFilter"
                    track-by="name"      
                    :limit="3"              
                    :maxHeight="200"
                    :limitText="count => `...`"     
                    valueFormat="object"
                    />      
                     <!-- <treeselect-value :value="C_portfolioNamesFilter" />    -->
                 </template>              
                </div>         
              </div>
              <div class="col-4 pl-0 py-2">
                <div class="d-flex w-100">
                  <div class="font-sm mr-2 mt-2">PROCESS AREA</div>
                  <template>
                    <el-select
                      v-model="C_categoryNameFilter"
                      class="w-75"
                      track-by="name"
                      value-key="id"
                      multiple
                      placeholder="Select Process Area"
                    >
                      <el-option
                        v-for="item in C_categories"
                        :value="item"
                        :key="item"
                        :label="item"
                      >
                      </el-option>
                    </el-select>
                  </template>
                </div>
              </div>
            </div>

        <el-tabs class="mt-1" type="border-card" @tab-click="handleClick">
          
          <!-- TASKS -->
          <el-tab-pane class="pt-2" name="tasks">
            <template
              slot="label"
              class="text-right"              
              v-if="true"
            >
              TASKS
              <span class="badge badge-secondary badge-pill">
                <span>{{ portfolioCounts.tasks_count }}</span>
              </span>
            </template>

         
            <div class="box-shadow py-3">
              <div class="row pt-3 pr-2 pb-1">
                <div class="col-10 px-1 pt-2">
                  <!-- <div class="pb-0 pl-2 pr-4 mb-0 d-inline-flex">  
                     <button class="btn btn-info btn-md">Add Task</button> 
                     </div> -->

                  <div class="pb-0 pl-2 pr-4 mb-0 d-inline-flex">
                    <span class=""
                      ><label class="font-sm px-2 mt-4 d-block"
                        >STATES TO DISPLAY</label
                      >
                    </span>

                    <span class="d-flex statesCol mr-3 px-3 py-2">
                      <div
                        class="pr-4 text-center icons"
                        :class="[hideComplete == true ? 'light' : '']"
                        @click.prevent="toggleComplete"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-clipboard-check"
                            :class="[
                              hideComplete == true ? 'light' : 'text-success',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">COMPLETE</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ taskVariation.completed.count }}
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideInprogress == true ? 'light' : '']"
                        @click.prevent="toggleInprogress"
                      >
                        <span class="d-block">
                          <i
                            class="far fa-tasks"
                            :class="[
                              hideInprogress == true ? 'light' : 'text-primary',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">IN PROGRESS</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ taskVariation.inProgress.count }}
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideOverdue == true ? 'light' : '']"
                        @click.prevent="toggleOverdue"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-calendar"
                            :class="[
                              hideOverdue == true ? 'light' : 'text-danger',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">OVERDUE </span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ taskVariation.overdue.count }}
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideOngoing == true ? 'light' : '']"
                        @click.prevent="toggleOngoing"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-retweet"
                            :class="[
                              hideOngoing == true ? 'light' : 'text-success',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">ONGOING </span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          <span v-if="tasksObj">{{
                            taskVariation.ongoing.count
                          }}<span
                            v-tooltip="`Ongoing: Closed`"
                            v-if="taskVariation.ongoingClosed.count > 0"
                            style="color:lightgray"
                            >({{
                              taskVariation.ongoingClosed.count
                              }})
                           </span>
                        </span>
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hidePlanned == true ? 'light' : '']"
                        @click.prevent="togglePlanned"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-calendar-check"
                            :class="[
                              hidePlanned == true ? 'light' : 'text-info',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">PLANNED</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          <span v-if="tasksObj">{{
                            taskVariation.planned.count
                          }}</span>
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideOnhold == true ? 'light' : '']"
                        @click.prevent="toggleOnhold"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-pause-circle"
                            :class="[
                              hideOnhold == true ? 'light' : 'text-primary',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">ON HOLD</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ taskVariation.onHoldT.count }}
                        </h5>
                      </div>
                      <div
                        class="text-center icons"
                        :class="[hideDraft == true ? 'light' : '']"
                        @click.prevent="toggleDraft"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-pencil-alt"
                            :class="[
                              hideDraft == true ? 'light' : 'text-warning',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">DRAFTS</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ taskVariation.taskDrafts.count }}
                        </h5>
                      </div>
                    </span>

                    <span class=""
                      ><label class="font-sm mt-4 pr-2"><b>TAG FOCUS</b></label>
                    </span>
                    <span class="tagsCol d-flex px-3 py-2">
                      <div
                        class="text-center icons"
                        :class="[hideWatched == true ? '' : 'light']"
                        @click.prevent="toggleWatched"
                      >
                        <span class="d-block">
                          <i class="fas fa-eye"></i>
                        </span>
                        <span class="smallerFont">ON WATCH</span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="watched" v-model="C_hideWatchedTasks">               -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ taskVariation.watched.count }}
                        </h5>
                      </div>
                      <div
                        class="px-4 text-center icons"
                        :class="[hideImportant == true ? '' : 'light']"
                        @click.prevent="toggleImportant"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-star"
                            :class="[
                              hideImportant == true ? 'text-warning' : 'light',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">IMPORTANT</span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="important" v-model="C_hideImportantTasks">     -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ taskVariation.important.count }}
                        </h5>
                      </div>
                      <div
                        class="text-center icons"
                        :class="[hideBriefed == true ? '' : 'light']"
                        @click.prevent="toggleBriefing"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-presentation"
                            :class="[
                              hideBriefed == true ? 'text-primary' : 'light',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">BRIEFINGS </span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="briefed" v-model="C_hideBriefedTasks">   -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ taskVariation.briefings.count }}
                        </h5>
                      </div>
                    </span>
                  </div>
                  <template>
                    <el-checkbox v-model="C_showCountToggle"
                      >Show Counts</el-checkbox
                    >
                  </template>
                </div>

                <div class="col-2 px-0">
                  <span class="btnRow">
                     <button
                      v-tooltip="`Briefing Mode`"
                      @click.prevent="openTpresentation"
                      class="btn btn-md presentBtn mr-1 mh-blue text-light"
                    >
                      <i class="fas fa-presentation"></i>
                    </button>
                    <button
                      v-tooltip="`Export to PDF`"
                      @click.prevent="exportTasksToPdf"
                      class="btn btn-md exportBtns text-light"
                    >
                      <i class="far fa-file-pdf"></i>
                    </button>
                    <button
                      v-tooltip="`Export to Excel`"
                      @click.prevent="
                        exportTasksToExcel('table', 'Portfolio Tasks')
                      "
                      class="btn btn-md exportBtns text-light"
                    >
                      <i class="far fa-file-excel"></i>
                    </button>
                    <button
                      class="btn text-light btn-md mh-orange px-1 profile-btns"
                    >
                      RESULTS: {{ tasksObj.length }}
                    </button></span
                  >
                </div>
              </div>

              <div
                class="row text-center mt-2 pr-3"
                v-if="tasksObj !== null && tasksObj.length > 0"
              >
                <div class="xTable px-3" style="overflow-x: auto">
                  <table
                    class="table table-sm mt-3 stickyTableHeader table-bordered"
                    ref="table"
                    id="portTasks"
                  >
                    <thead style="background-color: #ededed">
                      <th class="sort-th twenty" @click="sort('program_name')">
                        Program Name
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'program_name'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="sort-th twenty" @click="sort('project_name')">
                        Project Name
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== ''"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="pl-1 sort-th twenty" @click="sort('text')">
                        Task
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'text'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' && currentSort === 'text'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' && currentSort === 'text'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' && currentSort === 'text'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' && currentSort === 'text'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>

                      <th
                        class="sort-th twenty"
                        @click="sort('notes_updated_at')"
                        style="min-width: 300px"
                      >
                        Last Update
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'notes_updated_at'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>

                      <th
                        class="sort-th"
                        style="min-width: 140px"
                        @click="sort('start_date')"
                      >
                        Start Date
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'start_date'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'start_date'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'start_date'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'start_date'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'start_date'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th
                        class="sort-th"
                        style="min-width: 140px"
                        @click="sort('due_date')"
                      >
                        Due Date
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'due_date'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'due_date'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'due_date'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'due_date'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'due_date'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="sort-th p-1">
                        <span class="py-2 d-inline-block">Assigned Users</span>
                      </th>
                      <th
                        class="sort-th"
                        style="min-width: 115px"
                        @click="sort('progress')"
                      >
                        Progress
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'progress'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'progress'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'progress'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'progress'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'progress'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="non-sort-th" style="min-width: 145px">
                        Flags
                      </th>
                      <th class="pl-1 sort-th twenty" @click="sort('category')">
                        Process Area
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'category'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                    </thead>
                    <tbody>
                      <tr v-for="(task, index) in sortedTasks" :key="index" class="taskHover">
                   
                        <td>{{ task.program_name }}</td>
                        <td>{{ task.project_name }}</td>
                        <td>{{ task.text }}</td>
                        <td
                          class="text-left"
                          v-if="task.notes_updated_at.length > 0"
                        >
                          <span
                            class="toolTip"
                            v-tooltip="
                              'By: ' +
                              task.notes[task.notes.length - 1].user.full_name
                            "
                          >
                            {{
                              moment(task.notes_updated_at[0]).format(
                                "DD MMM YYYY, h:mm a"
                              )
                            }}
                          </span>
                          <br />
                          <span class="truncate-line-five">
                            {{ task.notes[task.notes.length - 1].body }}
                          </span>
                        </td>
                        <!-- <td v-else class="twentyTwo">No Updates</td> -->
                        <td class="text-left" v-else>No Update</td>

                        <td>
                          {{ moment(task.start_date).format("DD MMM YYYY") }}
                        </td>
                        <td>
                          <span v-if="task.ongoing && !task.closed" v-tooltip="`Ongoing`"
                            ><i class="fas fa-retweet text-success"></i
                          ></span>
                          <span
                            v-else-if="task.on_hold && task.due_date == null"
                            v-tooltip="`On Hold (w/no Due Date)`"
                            ><i class="fas fa-pause-circle text-primary"></i
                          ></span>
                          <span v-else>{{
                            moment(task.due_date).format("DD MMM YYYY")
                          }}</span>
                        </td>
                        <td>{{ task.users }}</td>
                        <td>                          
                           <span v-if="task.ongoing && !task.closed" v-tooltip="`Ongoing`"
                            ><i class="fas fa-retweet text-success"></i
                          ></span>
                          <span v-else-if="task.closed" v-tooltip="`Ongoing: Closed`"
                            ><i class="fas fa-retweet text-secondary"></i
                          ></span>
                          
                           <span v-else>
                          {{ task.progress + "%" }}
                           </span>
                        </td>
                        <td class="text-center">
                          <span v-if="task.is_overdue" v-tooltip="`Overdue`">
                            <i class="fas fa-calendar text-danger mr-1"></i
                          ></span>
                          <span v-if="task.completed" v-tooltip="`Completed`"
                            ><i
                              class="fas fa-clipboard-check text-success mr-1"
                            ></i
                          ></span>
                          <span
                            v-if="task.ongoing == true && !task.closed"
                            v-tooltip="`Ongoing`"
                            ><i class="fas fa-retweet mr-1 text-success"></i
                          ></span>
                          <span
                            v-if="task.closed"
                            v-tooltip="`Ongoing: Closed`"
                            ><i class="fas fa-retweet mr-1 text-secondary"></i
                          ></span>
                          <span
                            v-if="task.on_hold == true"
                            v-tooltip="`On Hold`"
                          >
                            <i class="fas fa-pause-circle mr-1 text-primary"></i
                          ></span>
                          <span v-if="task.draft == true" v-tooltip="`Draft`">
                            <i class="fas fa-pencil-alt mr-1 text-warning"></i
                          ></span>
                          <span
                            v-if="task.watched == true"
                            v-tooltip="`On Watch`"
                            ><i class="fas fa-eye mr-1"></i
                          ></span>
                          <span
                            v-if="task.important == true"
                            v-tooltip="`Important`"
                          >
                            <i class="fas fa-star text-warning mr-1"></i
                          ></span>
                          <span v-if="task.reportable" v-tooltip="`Briefings`">
                            <i class="fas fa-presentation mr-1 text-primary"></i
                          ></span>
                          <span v-if="task.planned" v-tooltip="`Planned`">
                            <i class="fas fa-calendar-check text-info mr-1"></i
                          ></span>
                          <span
                            v-if="task.in_progress"
                            v-tooltip="`In Progress`"
                          >
                            <i class="far fa-tasks text-primary mr-1"></i
                          ></span>

                          <!-- <span v-if="
                      task.important == false &&
                      task.reportable == false &&
                      task.watched == false &&
                      task.ongoing == false && 
                      task.isOverdue == false &&
                      task.onHold == false &&  
                      task.draft == false && 
                      task.progress < 100 "             
                    >
                       
              </span>               -->
                        </td>
                        <td>{{ task.category }}</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <div class="ml-auto mb-4 mt-2 font-sm">
                  <div class="simple-select d-inline-block text-right font-sm">
                    <span class="mr-1">Displaying </span>
                    <el-select
                      v-model="C_tasksPerPage"
                      class="w-33"
                      track-by="value"
                      value-key="id"
                    >
                      <el-option
                        v-for="item in getTasksPerPageFilterOptions"
                        :value="item"
                        :key="item.id"
                        :label="item.name"
                      >
                      </el-option>
                    </el-select>
                  </div>
                  <span
                    class="mr-1 pr-3"
                    style="border-right: solid 1px lightgray"
                    >Per Page
                  </span>
                  <button class="btn btn-sm page-btns" @click="prevPage">
                    <i class="fas fa-angle-left"></i>
                  </button>
                  <button class="btn btn-sm page-btns" id="page-count">
                    {{ currentPage }} of
                    {{
                      Math.ceil(
                        this.tasksObj.length / this.C_tasksPerPage.value
                      )
                    }}
                  </button>
                  <button class="btn btn-sm page-btns" @click="nextPage">
                    <i class="fas fa-angle-right"></i>
                  </button>
                </div>
              </div>
              <div v-else class="mt-5">NO RESULTS TO DISPLAY</div>
            </div>
          </el-tab-pane>
          <el-tab-pane class="pt-2"  name="issues">
            <template slot="label" class="text-right">
              ISSUES
              <span class="badge badge-secondary badge-pill">
                <span>{{ portfolioCounts.issues_count }}</span>
              </span>
            </template>

            <!-- <div class="row pb-4">
              <div class="col-4 py-2">
            <div class="w-100 d-flex">
               <div class="d font-sm mt-2 mr-2">SEARCH</div>              
              <el-input type="search" placeholder="Enter Search Criteria" v-model="search_issues" >
                <el-button slot="prepend" icon="el-icon-search"></el-button>
              </el-input>
              </div>
               </div>
               
            <div  class="col-4 pl-0 py-2" >   
            <div class="d-flex w-100">
            <div class="font-sm px-0 mt-2 mr-2">PROGRAM<span class="invi">i</span>FILTER</div>           
                   <template>
                    <treeselect  
                    placeholder="Search and select" 
                    :multiple="true" 
                    :match-keys= "['facility_project_id', 'id', 'label']"
                    :limit="3"
                    :limitText="count => `...`"     
                    track-by="name"                            
                    :options="portfolioPrograms" 
                    valueFormat="object"
                    v-model="C_portfolioIssueNamesFilter"
                    />         
                 </template>              
                </div>      
              </div> 
                  <div  class="col-4 pl-0 py-2">   
                <div class="d-flex w-100">                  
                  <div class="font-sm mr-2 mt-2">CATEGORY FILTER</div>           
                   <template>
                  <el-select 
                    v-model="C_categoryNameFilter"                    
                    class="w-75" 
                    track-by="name" 
                    value-key="id"
                    multiple                                                                                                                                               
                    placeholder="Select Process Area"
                  >
                  <el-option 
                    v-for="item in C_i_categories"                                                     
                    :value="item"   
                    :key="item"
                    :label="item"                                                  
                    >                   
                      </el-option>
                    </el-select>
                  </template>
                </div>
              </div>
            </div> -->

            <div class="box-shadow pt-3 pb-1">
              <div class="row pt-3 pb-1 pr-2">
                <div class="col-10 px-1 pt-2">
                  <div class="pb-0 pl-2 pr-4 mb-0 d-inline-flex">
                    <span class=""
                      ><label class="font-sm px-2 mt-4 d-block"
                        >STATES TO DISPLAY</label
                      >
                    </span>

                    <span class="d-flex statesCol mr-3 px-3 py-2">
                      <div
                        class="pr-4 text-center icons"
                        :class="[hideComplete == true ? 'light' : '']"
                        @click.prevent="toggleComplete"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-clipboard-check"
                            :class="[
                              hideComplete == true ? 'light' : 'text-success',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">COMPLETE</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ issueVariation.completed.count }}
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideInprogress == true ? 'light' : '']"
                        @click.prevent="toggleInprogress"
                      >
                        <span class="d-block">
                          <i
                            class="far fa-tasks"
                            :class="[
                              hideInprogress == true ? 'light' : 'text-primary',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">IN PROGRESS</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ issueVariation.inProgress.count }}
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideOverdue == true ? 'light' : '']"
                        @click.prevent="toggleOverdue"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-calendar"
                            :class="[
                              hideOverdue == true ? 'light' : 'text-danger',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">OVERDUE </span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ issueVariation.overdue.count }}
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hidePlanned == true ? 'light' : '']"
                        @click.prevent="togglePlanned"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-calendar-check"
                            :class="[
                              hidePlanned == true ? 'light' : 'text-info',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">PLANNED</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          <span v-if="issuesObj">{{
                            issueVariation.planned.count
                          }}</span>
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideOnhold == true ? 'light' : '']"
                        @click.prevent="toggleOnhold"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-pause-circle"
                            :class="[
                              hideOnhold == true ? 'light' : 'text-primary',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">ON HOLD</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ issueVariation.onHoldI.count }}
                        </h5>
                      </div>

                      <div
                        class="text-center icons"
                        :class="[hideDraft == true ? 'light' : '']"
                        @click.prevent="toggleDraft"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-pencil-alt"
                            :class="[
                              hideDraft == true ? 'light' : 'text-warning',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">DRAFTS</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ issueVariation.issueDrafts.count }}
                        </h5>
                      </div>
                    </span>

                    <span class=""
                      ><label class="font-sm mt-4 pr-2"><b>TAG FOCUS</b></label>
                    </span>
                    <span class="tagsCol d-flex px-3 py-2">
                      <div
                        class="text-center icons"
                        :class="[hideWatched == true ? '' : 'light']"
                        @click.prevent="toggleWatched"
                      >
                        <span class="d-block">
                          <i class="fas fa-eye"></i>
                        </span>
                        <span class="smallerFont">ON WATCH</span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="watched" v-model="C_hideWatchedissues">               -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ issueVariation.watched.count }}
                        </h5>
                      </div>
                      <div
                        class="px-4 text-center icons"
                        :class="[hideImportant == true ? '' : 'light']"
                        @click.prevent="toggleImportant"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-star"
                            :class="[
                              hideImportant == true ? 'text-warning' : 'light',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">IMPORTANT</span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="important" v-model="C_hideImportantissues">     -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ issueVariation.important.count }}
                        </h5>
                      </div>
                      <div
                        class="text-center icons"
                        :class="[hideBriefed == true ? '' : 'light']"
                        @click.prevent="toggleBriefing"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-presentation"
                            :class="[hideBriefed == true ? 'text-primary' : '']"
                          ></i>
                        </span>
                        <span class="smallerFont">BRIEFINGS </span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="briefed" v-model="C_hideBriefedissues">   -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ issueVariation.briefings.count }}
                        </h5>
                      </div>
                    </span>
                  </div>
                  <template>
                    <el-checkbox v-model="C_showCountToggle"
                      >Show Counts</el-checkbox
                    >
                  </template>
                </div>

                <div class="col-2 px-0">
                  <span class="btnRow">
                      <button
                      v-tooltip="`Briefing Mode`"
                      @click.prevent="openIpresentation"
                      class="btn btn-md presentBtn mr-1 text-light mh-blue"
                    >
                      <i class="fas fa-presentation"></i>
                    </button>
                    <button
                      v-tooltip="`Export to PDF`"
                      @click.prevent="exportIssuesToPdf"
                      class="btn btn-md exportBtns text-light"
                    >
                      <i class="far fa-file-pdf"></i>
                    </button>
                    <button
                      v-tooltip="`Export to Excel`"
                      @click.prevent="
                        exportIssuesToExcel('table', 'Portfolio Issues')
                      "
                      class="btn btn-md exportBtns text-light"
                    >
                      <i class="far fa-file-excel"></i>
                    </button>
                    <button
                      class="btn text-light btn-md mh-orange px-1 profile-btns"
                    >
                      RESULTS: {{ issuesObj.length }}
                    </button>
                  </span>
                </div>
              </div>
            </div>
           
            <div
              class="row text-center mt-1 pr-3"
              v-if="issuesObj !== null && issuesObj.length > 0"
            >
              <div class="xTable px-3" style="overflow-x: auto">
                <table
                  class="table table-sm mt-3 stickyTableHeader table-bordered"
                  ref="issueTable"
                  id="portIssues"
                >
                  <thead style="background-color: #ededed">
                    <th class="sort-th twenty" @click="sortI('program_name')">
                      Program Name
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSort !== 'program_name'"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'asc' &&
                          currentSort === 'program_name'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'asc' &&
                          currentSort === 'program_name'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'desc' &&
                          currentSort === 'program_name'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'desc' &&
                          currentSort === 'program_name'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>
                    <th class="sort-th twenty" @click="sortI('project_name')">
                      Project Name
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSort !== ''"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'asc' &&
                          currentSort === 'project_name'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'asc' &&
                          currentSort === 'project_name'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'desc' &&
                          currentSort === 'project_name'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'desc' &&
                          currentSort === 'project_name'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>
                    <th class="pl-1 sort-th twenty" @click="sortI('title')">
                      Issue
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSort !== 'title'"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'asc' && currentSort === 'title'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'asc' && currentSort === 'title'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'desc' && currentSort === 'title'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'desc' && currentSort === 'title'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>

                    <th
                      class="sort-th"
                      style="min-width: 300px"
                      @click="sortI('notes_updated_at')"
                    >
                      Last Update
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSort !== 'notes_updated_at'"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'asc' &&
                          currentSort === 'notes_updated_at'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'asc' &&
                          currentSort === 'notes_updated_at'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'desc' &&
                          currentSort === 'notes_updated_at'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'desc' &&
                          currentSort === 'notes_updated_at'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>
                    <th class="pl-1 sort-th" @click="sortI('issue_type')">
                      Issue Type
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSort !== 'issue_type'"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'asc' &&
                          currentSort === 'issue_type'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'asc' &&
                          currentSort === 'issue_type'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'desc' &&
                          currentSort === 'issue_type'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'desc' &&
                          currentSort === 'issue_type'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>

                    <th class="pl-1 sort-th" @click="sortI('issue_severity')">
                      Issue Severity
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSort !== 'issue_severity'"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'asc' &&
                          currentSort === 'issue_severity'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'asc' &&
                          currentSort === 'issue_severity'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'desc' &&
                          currentSort === 'issue_severity'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'desc' &&
                          currentSort === 'issue_severity'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>
                    <th
                      class="sort-th"
                      style="min-width: 140px"
                      @click="sort('start_date')"
                    >
                      Start Date
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSort !== 'start_date'"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'asc' &&
                          currentSort === 'start_date'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'asc' &&
                          currentSort === 'start_date'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'desc' &&
                          currentSort === 'start_date'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'desc' &&
                          currentSort === 'start_date'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>
                    <th
                      class="sort-th"
                      style="min-width: 140px"
                      @click="sort('due_date')"
                    >
                      Due Date
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSort !== 'due_date'"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'asc' && currentSort === 'due_date'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'asc' && currentSort === 'due_date'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'desc' &&
                          currentSort === 'due_date'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'desc' &&
                          currentSort === 'due_date'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>
                    <th class="sort-th p-1">
                      <span class="py-2 d-inline-block">Assigned Users</span>
                    </th>
                    <th
                      class="sort-th"
                      style="min-width: 115px"
                      @click="sortI('progress')"
                    >
                      Progress
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSort !== 'progress'"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'asc' && currentSort === 'progress'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'asc' && currentSort === 'progress'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'desc' &&
                          currentSort === 'progress'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'desc' &&
                          currentSort === 'progress'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>
                    <th class="non-sort-th" style="min-width: 145px">Flags</th>
                    <th class="pl-1 sort-th" @click="sort('category')">
                      Process Area
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="currentSort !== 'category'"
                      >
                        <i class="fas fa-sort"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'asc' && currentSort === 'category'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'asc' && currentSort === 'category'
                        "
                      >
                        <i class="fas fa-sort-up"></i
                      ></span>
                      <span
                        class="sort-icon scroll"
                        v-if="
                          currentSortDir === 'desc' &&
                          currentSort === 'category'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                      <span
                        class="inactive-sort-icon scroll"
                        v-if="
                          currentSortDir !== 'desc' &&
                          currentSort === 'category'
                        "
                      >
                        <i class="fas fa-sort-down"></i
                      ></span>
                    </th>
                  </thead>
                  <tbody>
                    <tr v-for="(issue, index) in sortedIssues" :key="index">
                      <td>{{ issue.program_name }}</td>
                      <td>{{ issue.project_name }}</td>
                      <td>{{ issue.title }}</td>
                      <td
                        class="text-left"
                        v-if="issue.notes_updated_at.length > 0"
                      >
                        <span
                          class="toolTip"
                          v-tooltip="
                            'By: ' +
                            issue.notes[issue.notes.length - 1].user.full_name
                          "
                        >
                          {{
                            moment(issue.notes_updated_at[0]).format(
                              "DD MMM YYYY, h:mm a"
                            )
                          }}
                        </span>
                        <br />
                        <span class="truncate-line-five">
                          {{ issue.notes[issue.notes.length - 1].body }}
                        </span>
                      </td>
                      <!-- <td v-else class="twentyTwo">No Updates</td> -->
                      <td class="text-left" v-else>No Update</td>
                      <td>{{ issue.issue_type }}</td>
                      <td>{{ issue.issue_severity }}</td>
                      <td>
                        {{ moment(issue.start_date).format("DD MMM YYYY") }}
                      </td>
                      <td>
                        <span
                          v-if="issue.on_hold && issue.due_date == null"
                          v-tooltip="`On Hold (w/no Due Date)`"
                          ><i class="fas fa-pause-circle text-primary"></i
                        ></span>
                        <span v-else
                          >{{ moment(issue.due_date).format("DD MMM YYYY") }}
                        </span>
                      </td>
                      <td>{{ issue.users }}</td>
                      <td>{{ issue.progress + "%" }}</td>
                      <td class="text-center">
                        <span v-if="issue.is_overdue" v-tooltip="`Overdue`">
                          <i class="fas fa-calendar mr-1 text-danger"></i>
                        </span>
                        <span v-if="issue.completed" v-tooltip="`Completed`"
                          ><i
                            class="fas fa-clipboard-check text-success mr-1"
                          ></i
                        ></span>
                        <span
                          v-if="issue.on_hold == true"
                          v-tooltip="`On Hold`"
                        >
                          <i class="fas fa-pause-circle mr-1 text-primary"></i
                        ></span>
                        <span v-if="issue.draft == true" v-tooltip="`Draft`">
                          <i class="fas fa-pencil-alt text-warning"></i
                        ></span>
                        <span
                          v-if="issue.watched == true"
                          v-tooltip="`On Watch`"
                          ><i class="fas fa-eye mr-1"></i
                        ></span>
                        <span
                          v-if="issue.important == true"
                          v-tooltip="`Important`"
                        >
                          <i class="fas fa-star text-warning mr-1"></i
                        ></span>
                        <span v-if="issue.reportable" v-tooltip="`Briefings`">
                          <i class="fas fa-presentation mr-1 text-primary"></i
                        ></span>
                        <span v-if="issue.planned" v-tooltip="`Planned`">
                          <i class="fas fa-calendar-check text-info mr-1"></i
                        ></span>
                        <span
                          v-if="issue.in_progress"
                          v-tooltip="`In Progress`"
                        >
                          <i class="far fa-tasks text-primary mr-1"></i
                        ></span>
                      </td>

                      <td>
                        <span v-if="issue.category">{{ issue.category }}</span>
                        <span v-else> --- </span>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <div class="ml-auto mb-4 mt-2 font-sm">
                <div class="simple-select d-inline-block text-right font-sm">
                  <span class="mr-1">Displaying </span>
                  <el-select
                    v-model="C_issuesPerPage"
                    class="w-33"
                    track-by="value"
                    value-key="id"
                  >
                    <el-option
                      v-for="item in getIssuesPerPageFilterOptions"
                      :value="item"
                      :key="item.id"
                      :label="item.name"
                    >
                    </el-option>
                  </el-select>
                </div>
                <span
                  class="mr-1 pr-3"
                  style="border-right: solid 1px lightgray"
                  >Per Page
                </span>
                <button class="btn btn-sm page-btns" @click="prevIssuesPage">
                  <i class="fas fa-angle-left"></i>
                </button>
                <button class="btn btn-sm page-btns" id="page-count">
                  {{ currentIssuesPage }} of
                  {{
                    Math.ceil(
                      this.issuesObj.length / this.C_issuesPerPage.value
                    )
                  }}
                </button>
                <button class="btn btn-sm page-btns" @click="nextIssuesPage">
                  <i class="fas fa-angle-right"></i>
                </button>
              </div>
            </div>
            <div v-else class="mt-5">NO RESULTS TO DISPLAY</div>
          </el-tab-pane>

          <!-- RISKS TAB STARTS HERE -->

          <el-tab-pane class="pt-2" name="risks">
            <template
              slot="label"
              class="text-right"
              v-if="risksObj && risksObj !== undefined"
            >
              RISKS
              <span class="badge badge-secondary badge-pill">
                <span>{{ portfolioCounts.risks_count }}</span>
                <!-- <span v-if="getPortfolioWatchedTasksToggle">{{ tasksObj.length }}</span>
                <span v-if="!getPortfolioWatchedTasksToggle"> {{filterOutWatched.length }}</span> -->
              </span>
            </template>

            <!-- <div class="row pb-4">
              <div class="col-4 py-2">
             <div class="w-100 d-flex">
              <div class="d font-sm mt-2 mr-2">SEARCH</div>                
              <el-input type="search" placeholder="Enter Search Criteria" v-model="search_risks" >
                <el-button slot="prepend" icon="el-icon-search"></el-button>
              </el-input>             
               </div>
              </div>
            <div  class="col-4 py-2">   
            <div class="d-flex w-100">

               <div class="font-sm px-0 mt-2 mr-2">PROGRAM<span class="invi">i</span>FILTER</div>           
                   <template>
                    <treeselect  
                    placeholder="Search and select" 
                    :multiple="true"     
                    :limit="3"
                    :match-keys= "['facility_project_id', 'id', 'label']"
                    :limitText="count => `...`"            
                    track-by="name"  
                   :options="portfolioPrograms" 
                    valueFormat="object"
                    v-model="C_portfolioRiskNamesFilter"
                    />         
                 </template>              
                </div>      
              </div> 
                  <div  class="col-4 pl-0 py-2">   
                <div class="d-flex w-100">                  
                  <div class="font-sm mr-2 mt-2">CATEGORY FILTER</div>           
                   <template>
                  <el-select 
                    v-model="C_categoryNameFilter"                    
                    class="w-75" 
                    track-by="name" 
                    value-key="id"
                    multiple                                                                                                                                               
                    placeholder="Select Process Area"
                  >
                  <el-option 
                    v-for="item in C_r_categories"                                                     
                    :value="item"   
                    :key="item"
                    :label="item"                                                  
                    >
                   </el-option>
                    </el-select>
                  </template>
                </div>
              </div>
            </div> -->

            <div class="box-shadow py-3">
              <div class="row pt-3 pb-1 pr-2">
                <div class="col-10 px-1 pt-2">
                  <div class="pb-0 pl-2 pr-4 mb-0 d-inline-flex">
                    <span class=""
                      ><label class="font-sm px-2 mt-4 d-block"
                        >STATES TO DISPLAY</label
                      >
                    </span>

                    <span class="d-flex statesCol mr-3 px-3 py-2">
                      <div
                        class="pr-4 text-center icons"
                        :class="[hideComplete == true ? 'light' : '']"
                        @click.prevent="toggleComplete"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-clipboard-check"
                            :class="[
                              hideComplete == true ? 'light' : 'text-success',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">COMPLETE</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ riskVariation.completed.count }}
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideInprogress == true ? 'light' : '']"
                        @click.prevent="toggleInprogress"
                      >
                        <span class="d-block">
                          <i
                            class="far fa-tasks"
                            :class="[
                              hideInprogress == true ? 'light' : 'text-primary',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">IN PROGRESS</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ riskVariation.inProgress.count }}
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideOverdue == true ? 'light' : '']"
                        @click.prevent="toggleOverdue"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-calendar"
                            :class="[
                              hideOverdue == true ? 'light' : 'text-danger',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">OVERDUE </span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ riskVariation.overdue.count }}
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideOngoing == true ? 'light' : '']"
                        @click.prevent="toggleOngoing"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-retweet"
                            :class="[
                              hideOngoing == true ? 'light' : 'text-success',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">ONGOING </span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          <span v-if="risksObj">{{
                            riskVariation.ongoing.count
                          }}<span
                            v-tooltip="`Ongoing: Closed`"
                            v-if="riskVariation.ongoingClosed.count > 0"
                            style="color:lightgray"
                            >({{riskVariation.ongoingClosed.count}})
                           </span>                         
                          </span>
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hidePlanned == true ? 'light' : '']"
                        @click.prevent="togglePlanned"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-calendar-check"
                            :class="[
                              hidePlanned == true ? 'light' : 'text-info',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">PLANNED</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          <span v-if="risksObj">{{
                            riskVariation.planned.count
                          }}</span>
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[hideOnhold == true ? 'light' : '']"
                        @click.prevent="toggleOnhold"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-pause-circle"
                            :class="[
                              hideOnhold == true ? 'light' : 'text-primary',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">ON HOLD</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ riskVariation.onHoldR.count }}
                        </h5>
                      </div>

                      <div
                        class="text-center icons"
                        :class="[hideDraft == true ? 'light' : '']"
                        @click.prevent="toggleDraft"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-pencil-alt"
                            :class="[
                              hideDraft == true ? 'light' : 'text-warning',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">DRAFTS</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ riskVariation.riskDrafts.count }}
                        </h5>
                      </div>
                    </span>

                    <span class=""
                      ><label class="font-sm mt-4 pr-2"><b>TAG FOCUS</b></label>
                    </span>
                    <span class="tagsCol d-flex px-3 py-2">
                      <div
                        class="text-center icons"
                        :class="[hideWatched == true ? '' : 'light']"
                        @click.prevent="toggleWatched"
                      >
                        <span class="d-block">
                          <i class="fas fa-eye"></i>
                        </span>
                        <span class="smallerFont">ON WATCH</span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="watched" v-model="C_hideWatchedTasks">               -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ riskVariation.watched.count }}
                        </h5>
                      </div>
                      <div
                        class="px-4 text-center icons"
                        :class="[hideImportant == true ? '' : 'light']"
                        @click.prevent="toggleImportant"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-star"
                            :class="[
                              hideImportant == true ? 'text-warning' : 'light',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">IMPORTANT</span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="important" v-model="C_hideImportantTasks">     -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ riskVariation.important.count }}
                        </h5>
                      </div>
                      <div
                        class="text-center icons"
                        :class="[hideBriefed == true ? '' : 'light']"
                        @click.prevent="toggleBriefing"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-presentation"
                            :class="[
                              hideBriefed == true ? 'text-primary ' : 'light',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">BRIEFINGS </span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="briefed" v-model="C_hideBriefedTasks">   -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ riskVariation.briefings.count }}
                        </h5>
                      </div>
                    </span>
                  </div>
                  <template>
                    <el-checkbox v-model="C_showCountToggle"
                      >Show Counts</el-checkbox
                    >
                  </template>
                </div>

                <div class="col-2 px-0">
                  <span class="btnRow">
                     <button
                      v-tooltip="`Briefing Mode`"
                      @click.prevent="openRpresentation"
                      class="btn btn-md mr-1 text-light mh-blue presentBtn"
                    >
                      <i class="fas fa-presentation"></i>
                    </button>
                    <button
                      v-tooltip="`Export to PDF`"
                      @click.prevent="exportRisksToPdf"
                      class="btn btn-md exportBtns text-light"
                    >
                      <i class="far fa-file-pdf"></i>
                    </button>
                    <button
                      v-tooltip="`Export to Excel`"
                      @click.prevent="
                        exportRisksToExcel('table', 'Portfolio Risks')
                      "
                      class="btn btn-md exportBtns text-light"
                    >
                      <i class="far fa-file-excel"></i>
                    </button>
                    <button
                      class="btn text-light btn-md mh-orange px-1 profile-btns"
                    >
                      RESULTS: {{ risksObj.length }}
                    </button>
                  </span>
                </div>
              </div>
              <div
                class="row text-center mt-2 pr-3"
                v-if="risksObj !== null && risksObj.length > 0"
              >
                <div class="xTable px-3" style="overflow-x: auto">
                  <table
                    class="table table-sm mt-3 stickyTableHeader table-bordered"
                    ref="riskTable"
                    id="portRisks"
                  >
                    <thead style="background-color: #ededed">
                      <th class="sort-th twenty" @click="sort('program_name')">
                        Program Name
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'program_name'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="sort-th twenty" @click="sort('project_name')">
                        Project Name
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== ''"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="pl-1 sort-th twenty" @click="sort('text')">
                        Risk
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'text'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' && currentSort === 'text'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' && currentSort === 'text'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' && currentSort === 'text'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' && currentSort === 'text'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th
                        class="sort-th"
                        style="min-width: 300px"
                        @click="sort('notes_updated_at')"
                      >
                        Last Update
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'notes_updated_at'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>

                      <th class="sort-th" @click="sort('risk_approach')">
                        Risk Approach
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'risk_approach'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'risk_approach'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'risk_approach'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'risk_approach'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'risk_approach'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="sort-th" @click="sort('priority_level')">
                        Priority Level
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'priority_level'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'priority_level'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'priority_level'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'priority_level'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'priority_level'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th
                        class="sort-th"
                        style="min-width: 140px"
                        @click="sort('start_date')"
                      >
                        Start Date
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'start_date'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'start_date'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'start_date'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'start_date'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'start_date'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th
                        class="sort-th"
                        @click="sort('due_date')"
                        style="min-width: 145px"
                      >
                        Risk Approach Due Date
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'due_date'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'due_date'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'due_date'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'due_date'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'due_date'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="sort-th p-1">
                        <span class="py-2 d-inline-block">Assigned Users</span>
                      </th>
                      <th
                        class="sort-th"
                        style="min-width: 115px"
                        @click="sort('progress')"
                      >
                        Progress
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'progress'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'progress'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'progress'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'progress'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'progress'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="non-sort-th" style="min-width: 145px">
                        Flags
                      </th>
                      <th class="pl-1 sort-th" @click="sort('category')">
                        Process Area
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'category'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                    </thead>
                    <tbody>
                      <tr v-for="(risk, index) in sortedRisks" :key="index">
                        <td>{{ risk.program_name }}</td>
                        <td>{{ risk.project_name }}</td>
                        <td>{{ risk.text }}</td>
                        <td
                          class="text-left"
                          v-if="risk.notes_updated_at.length > 0"
                        >
                          <span
                            class="toolTip"
                            v-tooltip="
                              'By: ' +
                              risk.notes[risk.notes.length - 1].user.full_name
                            "
                          >
                            {{
                              moment(risk.notes_updated_at[0]).format(
                                "DD MMM YYYY, h:mm a"
                              )
                            }}
                          </span>
                          <br />
                          <span class="truncate-line-five">
                            {{ risk.notes[risk.notes.length - 1].body }}
                          </span>
                        </td>
                        <!-- <td v-else class="twentyTwo">No Updates</td> -->
                        <td class="text-left" v-else>No Update</td>

                        <td>
                          {{
                            risk.risk_approach.charAt(0).toUpperCase() +
                            risk.risk_approach.slice(1)
                          }}
                        </td>
                        <td>
                          <span
                            v-if="risk.priority_level == 'Very Low'"
                            class="gray2"
                            >Very Low</span
                          >
                          <span
                            v-else-if="risk.priority_level == 'Low'"
                            class="green1"
                            >Low</span
                          >
                          <span
                            v-else-if="risk.priority_level == 'Moderate'"
                            class="yellow1"
                            >Moderate</span
                          >
                          <span
                            v-else-if="risk.priority_level == 'High'"
                            class="orange1"
                            >High</span
                          >
                          <span
                            v-else-if="risk.priority_level == 'Extreme'"
                            class="red1"
                            >Extreme</span
                          >
                        </td>
                        <td>
                          {{ moment(risk.start_date).format("DD MMM YYYY") }}
                        </td>
                        <td>
                          <span v-if="risk.ongoing && !risk.closed" v-tooltip="`Ongoing`"
                            ><i class="fas fa-retweet text-success"></i
                          ></span>
                          <span
                            v-else-if="risk.on_hold && risk.due_date == null"
                            v-tooltip="`On Hold (w/no Due Date)`"
                            ><i class="fas fa-pause-circle text-primary"></i
                          ></span>
                          <span v-else>{{
                            moment(risk.due_date).format("DD MMM YYYY")
                          }}</span>
                        </td>
                        <td>{{ risk.users }}</td>
                        <td>
                           <span v-if="risk.ongoing && !risk.closed" v-tooltip="`Ongoing`"
                            ><i class="fas fa-retweet text-success"></i
                          ></span>
                           <span v-else-if="risk.closed" v-tooltip="`Ongoing: Closed`"
                            ><i class="fas fa-retweet text-secondary"></i
                          ></span>
                          <span v-else>
                          {{ risk.progress + "%" }}
                          </span>
                          
                          
                          </td>
                        <td class="text-center">
                          <span v-if="risk.is_overdue" v-tooltip="`Overdue`"
                            ><i class="fas fa-calendar mr-1 text-danger"></i
                          ></span>
                          <span v-if="risk.completed" v-tooltip="`Completed`"
                            ><i
                              class="fas fa-clipboard-check mr-1 text-success"
                            ></i
                          ></span>
                          <span
                            v-if="risk.ongoing == true && !risk.closed"
                            v-tooltip="`Ongoing`"
                            ><i class="fas fa-retweet text-success"></i
                          ></span>
                          <span
                            v-if="risk.closed == true"
                            v-tooltip="`Ongoing: Closed`"
                            ><i class="fas fa-retweet text-secondary"></i
                          ></span>
                          <span
                            v-if="risk.on_hold == true"
                            v-tooltip="`On Hold`"
                          >
                            <i class="fas fa-pause-circle mr-1 text-primary"></i
                          ></span>
                          <span v-if="risk.draft == true" v-tooltip="`Draft`">
                            <i class="fas fa-pencil-alt text-warning"></i
                          ></span>
                          <span
                            v-if="risk.watched == true"
                            v-tooltip="`On Watch`"
                            ><i class="fas fa-eye mr-1"></i
                          ></span>
                          <span
                            v-if="risk.important == true"
                            v-tooltip="`Important`"
                          >
                            <i class="fas fa-star text-warning mr-1"></i
                          ></span>
                          <span v-if="risk.reportable" v-tooltip="`Briefings`">
                            <i class="fas fa-presentation mr-1 text-primary"></i
                          ></span>
                          <span v-if="risk.planned" v-tooltip="`Planned`">
                            <i class="fas fa-calendar-check text-info mr-1"></i
                          ></span>
                          <span
                            v-if="risk.in_progress"
                            v-tooltip="`In Progress`"
                          >
                            <i class="far fa-tasks text-primary mr-1"></i
                          ></span>
                        </td>
                        <td>{{ risk.category }}</td>
                        <!-- <td v-if="risk.last_update !== null">{{risk.last_update.body}}</td> -->
                      </tr>
                    </tbody>
                  </table>
                </div>
                <div class="ml-auto mb-4 mt-2 font-sm">
                  <div class="simple-select d-inline-block text-right font-sm">
                    <span class="mr-1">Displaying </span>
                    <el-select
                      v-model="C_risksPerPage"
                      class="w-33"
                      track-by="value"
                      value-key="id"
                    >
                      <el-option
                        v-for="item in getRisksPerPageFilterOptions"
                        :value="item"
                        :key="item.id"
                        :label="item.name"
                      >
                      </el-option>
                    </el-select>
                  </div>
                  <span
                    class="mr-1 pr-3"
                    style="border-right: solid 1px lightgray"
                    >Per Page
                  </span>
                  <button class="btn btn-sm page-btns" @click="prevRisksPage">
                    <i class="fas fa-angle-left"></i>
                  </button>
                  <button class="btn btn-sm page-btns" id="page-count">
                    {{ currentRisksPage }} of
                    {{
                      Math.ceil(
                        this.risksObj.length / this.C_risksPerPage.value
                      )
                    }}
                  </button>
                  <button class="btn btn-sm page-btns" @click="nextRisksPage">
                    <i class="fas fa-angle-right"></i>
                  </button>
                </div>
              </div>

              <div v-else class="mt-5">NO RESULTS TO DISPLAY</div>
            </div>
          </el-tab-pane>

          <el-tab-pane class="pt-2"  name="lessons">
            <template slot="label" class="text-right">
              LESSONS LEARNED
              <span class="badge badge-secondary badge-pill">
                {{ portfolioCounts.lessons_count }}
              </span>
            </template>

            <!-- <div class="row pb-4">
              <div class="col-4 py-2">
                <div class="w-100 d-flex">
                  <div class="d font-sm mt-2 mr-2">SEARCH</div>
                  <el-input
                    type="search"
                    placeholder="Enter Search Criteria"
                    v-model="search_lessons"
                  >
                    <el-button slot="prepend" icon="el-icon-search"></el-button>
                  </el-input>
                </div>
              </div>

              <div class="col-4 py-2">
                <div class="d-flex w-100">   
               <div class="font-sm px-0 mt-2 mr-2">PROGRAM<span class="invi">i</span>FILTER</div>           
                   <template>
                    <treeselect  
                    placeholder="Search and select" 
                    :limit="3"
                    :match-keys= "['facility_project_id', 'id', 'label']"
                    :limitText="count => `...`"     
                    :multiple="true" 
                    track-by="name"  
                   :options="portfolioPrograms" 
                    valueFormat="object"
                    v-model="C_portfolioLessonNamesFilter"
                    />         
                 </template>              
                </div>              
              </div> 
                       <div  class="col-4 pl-0 py-2">   
                <div class="d-flex w-100">                  
                  <div class="font-sm mr-2 mt-2">CATEGORY FILTER</div>           
                   <template>
                  <el-select 
                    v-model="C_categoryNameFilter"                    
                    class="w-75" 
                    track-by="name" 
                    value-key="id"
                    multiple                                                                                                                                             
                    placeholder="Select Process Area"
                  >
                  <el-option 
                    v-for="item in C_l_categories"                                                     
                    :value="item"   
                    :key="item"
                    :label="item"                                                  
                    >
                   </el-option>
                    </el-select>
                  </template>
                </div>
              </div>
            </div> -->

            <div class="box-shadow py-3">
              <div class="row pt-3 pb-1 pr-2">
                <div class="col-10 px-1 pt-2">
                  <div class="pb-0 pl-2 pr-4 mb-0 d-inline-flex">
                    <span class=""
                      ><label class="font-sm px-2 mt-4 d-block"
                        >STATES TO DISPLAY</label
                      >
                    </span>
                    <span class="d-flex statesCol mr-3 px-3 py-2">
                      <div
                        class="pr-4 text-center icons"
                        :class="[hideComplete == true ? 'light' : '']"
                        @click.prevent="toggleComplete"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-clipboard-check"
                            :class="[
                              hideComplete == true ? 'light' : 'text-success',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">COMPLETE</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ lessonVariation.completed.count }}
                        </h5>
                      </div>
                      <div
                        class="text-center icons"
                        :class="[hideDraft == true ? 'light' : '']"
                        @click.prevent="toggleDraft"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-pencil-alt"
                            :class="[
                              hideDraft == true ? 'light' : 'text-warning',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">DRAFTS</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ lessonVariation.lessonDrafts.count }}
                        </h5>
                      </div>
                    </span>

                    <span class=""
                      ><label class="font-sm mt-4 pr-2"><b>TAG FOCUS</b></label>
                    </span>
                    <span class="tagsCol d-flex px-3 py-2">
                      <!-- <div class="text-center icons" :class="[hideWatchedLessons == true ? '':'light']" @click.prevent="toggleWatchedL"   >             
                 <span class="d-block">
                      <i class="fas fa-eye" ></i>
                 </span>                  
                  <span class="smallerFont">ON WATCH</span>                 
                   <h5 :class="[getShowCount == false ? 'd-none' : 'd-block']">{{ lessonVariation.watched.count }}</h5>  
                  </div> -->
                      <div
                        class="pr-4 text-center icons"
                        :class="[hideImportant == true ? '' : 'light']"
                        @click.prevent="toggleImportant"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-star"
                            :class="[
                              hideImportant == true ? 'text-warning' : 'light',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">IMPORTANT</span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="important" v-model="C_hideImportantTasks">     -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ lessonVariation.important.count }}
                        </h5>
                      </div>
                      <div
                        class="text-center icons"
                        :class="[hideBriefed == true ? '' : 'light']"
                        @click.prevent="toggleBriefing"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-presentation"
                            :class="[
                              hideBriefed == true ? 'text-primary ' : 'light',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">BRIEFINGS </span>
                        <!-- <input class="d-block m-auto" type="checkbox" id="checkbox" value="briefed" v-model="C_hideBriefedTasks">   -->
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          {{ lessonVariation.briefings.count }}
                        </h5>
                      </div>
                    </span>
                  </div>
                  <template>
                    <el-checkbox v-model="C_showCountToggle"
                      >Show Counts</el-checkbox
                    >
                  </template>
                </div>
                <div class="col-2 px-0">
                  <span class="btnRow">
                   <button
                      v-tooltip="`Briefing Mode`"
                      @click.prevent="openLpresentation"
                      class="btn btn-md presentBtn mr-1 text-light mh-blue"
                    >
                      <i class="fas fa-presentation text-primary"></i>
                    </button>
                    <button
                      v-tooltip="`Export to PDF`"
                      @click.prevent="exportLessonsToPdf"
                      class="btn btn-md exportBtns text-light"
                    >
                      <i class="far fa-file-pdf"></i>
                    </button>
                    <button
                      v-tooltip="`Export to Excel`"
                      @click.prevent="
                        exportLessonsToExcel('table', 'Portfolio Lessons')
                      "
                      class="btn btn-md exportBtns text-light"
                    >
                      <i class="far fa-file-excel"></i>
                    </button>
                    <button
                      class="btn text-light btn-md mh-orange px-1 profile-btns"
                    >
                      RESULTS: {{ lessonsObj.length }}
                    </button>
                  </span>
                </div>
              </div>

              <div
                class="row text-center mt-2 pr-3"
                v-if="lessonsObj !== null && lessonsObj.length > 0"
              >
                <div class="xTable px-3" style="overflow-x: auto">
                  <table
                    class="table table-sm mt-3 stickyTableHeader table-bordered"
                    ref="lessonTable"
                    id="portLessons"
                  >
                    <thead style="background-color: #ededed">
                      <th class="sort-th twenty" @click="sortL('program_name')">
                        Program Name
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'program_name'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'program_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="sort-th twenty" @click="sortL('project_name')">
                        Project Name
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== ''"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'project_name'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th class="pl-1 sort-th" @click="sortL('title')">
                        Lessons Learned
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'title'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' && currentSort === 'title'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' && currentSort === 'title'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' && currentSort === 'title'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' && currentSort === 'title'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th
                        class="sort-th"
                        style="min-width: 300px"
                        @click="sort('notes_updated_at')"
                      >
                        Last Update
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'notes_updated_at'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'notes_updated_at'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th
                        class="pl-1 sort-th"
                        style="min-width: 325px"
                        @click="sortL('description')"
                      >
                        Description
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'description'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'description'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'description'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'description'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'description'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <!-- <th class="sort-th p-1">
                 <span class="py-2 d-inline-block">Assigned Users</span>
              </th> -->
                      <th class="sort-th" @click="sortL('added_by')">
                        Added By
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'added_by'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'added_by'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'added_by'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'added_by'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'added_by'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th
                        class="sort-th"
                        @click="sortL('created_at')"
                        style="min-width: 140px"
                      >
                        Date Added
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'created_at'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'created_at'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'created_at'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'created_at'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'created_at'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th style="min-width: 145px">Flags</th>
                      <th class="pl-1 sort-th" @click="sort('category')">
                        Process Area
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'category'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'category'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                    </thead>
                    <tbody>
                      <tr v-for="(lesson, index) in sortedLessons" :key="index">
                        <td>{{ lesson.program_name }}</td>
                        <td>{{ lesson.project_name }}</td>
                        <td>{{ lesson.title }}</td>
                        <td
                          class="text-left"
                          v-if="lesson.notes_updated_at.length > 0"
                        >
                          <span
                            class="toolTip"
                            v-tooltip="
                              'By: ' +
                              lesson.notes[lesson.notes.length - 1].user
                                .full_name
                            "
                          >
                            {{
                              moment(lesson.notes_updated_at[0]).format(
                                "DD MMM YYYY, h:mm a"
                              )
                            }}
                          </span>
                          <br />
                          <span class="truncate-line-five">
                            {{ lesson.notes[lesson.notes.length - 1].body }}
                          </span>
                        </td>
                        <!-- <td v-else class="twentyTwo">No Updates</td> -->
                        <td class="text-left" v-else>No Update</td>
                        <td>
                          <span class="truncate-line-five">{{
                            lesson.description
                          }}</span>
                        </td>
                        <td>{{ lesson.added_by }}</td>
                        <td>
                          {{ moment(lesson.created_at).format("DD MMM YYYY") }}
                        </td>
                        <td class="text-center">
                          <span v-if="lesson.draft == true" v-tooltip="`Draft`">
                            <i class="fas fa-pencil-alt text-warning"></i
                          ></span>
                          <span
                            v-if="lesson.draft == false"
                            v-tooltip="`Draft`"
                          >
                            <i class="fas fa-clipboard-check text-success"></i
                          ></span>
                          <span
                            v-if="lesson.important == true"
                            v-tooltip="`Important`"
                          >
                            <i class="fas fa-star text-warning mr-1"></i
                          ></span>
                          <span
                            v-if="lesson.reportable"
                            v-tooltip="`Briefings`"
                          >
                            <i class="fas fa-presentation mr-1 text-primary"></i
                          ></span>

                          <span
                            v-if="
                              lesson.important == false &&
                              lesson.reportable == false &&
                              lesson.draft == false
                            "
                          >
                            <!-- No flags at this time          -->
                          </span>
                        </td>
                        <td>
                          <span v-if="lesson.category">{{
                            lesson.category
                          }}</span>
                          <span v-else> --- </span>
                        </td>

                        <!-- <td> {{ lesson.progress }} </td> -->
                      </tr>
                    </tbody>
                  </table>
                </div>
                <div class="ml-auto mb-4 mt-2 font-sm">
                  <div class="simple-select d-inline-block text-right font-sm">
                    <span class="mr-1">Displaying </span>
                    <el-select
                      v-model="C_lessonsPerPage"
                      class="w-33"
                      track-by="value"
                      value-key="id"
                    >
                      <el-option
                        v-for="item in getLessonsPerPageFilterOptions"
                        :value="item"
                        :key="item.id"
                        :label="item.name"
                      >
                      </el-option>
                    </el-select>
                  </div>
                  <span
                    class="mr-1 pr-3"
                    style="border-right: solid 1px lightgray"
                    >Per Page
                  </span>
                  <button class="btn btn-sm page-btns" @click="prevLessonsPage">
                    <i class="fas fa-angle-left"></i>
                  </button>
                  <button class="btn btn-sm page-btns" id="page-count">
                    {{ currentLessonsPage }} of
                    {{
                      Math.ceil(
                        this.lessonsObj.length / this.C_lessonsPerPage.value
                      )
                    }}
                  </button>
                  <button class="btn btn-sm page-btns" @click="nextLessonsPage">
                    <i class="fas fa-angle-right"></i>
                  </button>
                </div>
              </div>
              <div v-else class="mt-5">NO RESULTS TO DISPLAY</div>
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
      <el-tab-pane
        disabled
        label="PORTFOLIO ANALYTICS (Coming Soon)"
        class="p-3"
      >
      </el-tab-pane>
    </el-tabs>
  </div>
  <!-- </div> -->
</template>

<script>

import axios from 'axios'
import Loader from "../../shared/loader.vue";
import { jsPDF } from "jspdf";
import "jspdf-autotable";
import moment from "moment";
Vue.prototype.moment = moment;
import { mapGetters, mapActions, mapMutations } from "vuex";

// We just use `setTimeout()` here to simulate an async operation
// instead of requesting a real API server for demo purpose.
const simulateAsyncOperation = fn => {
  setTimeout(fn, 2000)
}

export default {
  name: "PortfolioView",
  props: ["from"],
  components: {
    Loader
  },
  data() {
    return {
      showLess: "Show More",
      activeName: 'tasks',
      dialogVisible: false,
      taskRow: {}, 
      action: '',
      dynamicObj: {},
      currentTaskSlide : 0,
      isSlidingToPrevious : false,
      taskIndex: null, 
      search_tasks: "",
      search_issues: "",
      search_risks: "",
      search_lessons: "",
      currentSort: "program_name",
      currentSortDir: "asc",
      currentTab: 'tasks',
      currentPage: 1,
      // selectedProgram: this.C_programNameFilter,
      currentIssuesPage: 1,
      currentRisksPage: 1,
      currentLessonsPage: 1,
      // tSlide: this.tasksObj[this.currentTaskSlide],
      loadIssues: false,
      loadRisks: false,
      loadLessons: false,

      // 3 Tags for Tasks
      hideWatched: false,
      hideImportant: false,
      hideBriefed: false,

      hideDraft: false,
      hideComplete: false,
      hideOngoing: false,
      hideInprogress: false,
      hideOverdue: false,
      hidePlanned: false,
      hideOnhold: false,

      programId: null,
      programName: null,
      page: 1,
      pageSize: 10,
      showMore: true,
      today: new Date().toISOString().slice(0, 10),

      facility_project_ids: [],

      uri: "data:application/vnd.ms-excel;base64,",
      template:
        '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="https://www.w3.org/TR/2018/SPSD-html401-20180327/"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
      base64: function (s) {
        return window.btoa(unescape(encodeURIComponent(s)));
      },
      format: function (s, c) {
        return s.replace(/{(\w+)}/g, function (m, p) {
          return c[p];
        });
      },
    };
  },
  mounted() {
    this.fetchPortfolioPrograms();
    this.fetchPortfolioCounts();
    this.$nextTick(function () {
      // Code that will run only after the
      // entire view has been rendered
      $("#tab-tasks").trigger('click');
    })
    
    // this.fetchPortfolioTasks();
    // this.fetchPortfolioIssues();
    // this.fetchPortfolioRisks();
    // this.fetchPortfolioLessons();
  },
  computed: {
    ...mapGetters([
      'getPortfolioWatchedTasksToggle', 
      'getPortfolioBriefedTasksToggle',
       'getMyAssignmentsFilter',
      'getTasksPerPageFilterOptions',
      'getIssuesPerPageFilterOptions',
      'getRisksPerPageFilterOptions',
      'getLessonsPerPageFilterOptions',
      'getPortfolioImportantTasksToggle', 
      'getTasksPerPageFilter',    
      'getIssuesPerPageFilter',  
      'getRisksPerPageFilter', 
      'getLessonsPerPageFilter', 
      'getShowCount',
      'portfolioNameFilter',
      'portfolioRiskNameFilter',
      'facilityDueDateFilter',
      'noteDateFilter',
      'taskIssueDueDateFilter',
      'activeProjectUsers',
      'programNameFilter',
      'portfolioTasksLoaded',
      'taskTypes',
      'portfolioCategoriesFilter',
      'portfolioTasks',
      'portfolioCounts',
      'portfolioIssues',
      'portfolioRisks', 
      'portfolioLessons',
      'portfolioPrograms', 
      'facilityProgressFilter',
      'programProgressFilter',
      'portfolioUsers',
      'portfolioUsersFilter',
      'portfolioStatuses',
      'portfolioStatusesFilter',
      'portfolioTaskStages',
      'portfolioIssueStages',
      'portfolioRiskStages',
      'portfolioTaskStagesFilter',
      'portfolioIssueStagesFilter',
      'portfolioRiskStagesFilter',
      'portfolioIssueTypes',
      'portfolioIssueTypesFilter',
      'portfolioIssueSeverities',
      'portfolioIssueSeveritiesFilter',
      'portfolioRiskPriorities',
      'portfolioRiskPrioritiesFilter',
      'portfolioRiskApproaches',
      'portfolioRiskApproachesFilter',
      'taskIssueProgressFilter'
    ]),

   sortedTasks:function() {
          return this.tasksObj.sort((a,b) => {
          let modifier = 1;
          if (this.currentSortDir === "desc") modifier = -1;
          if (a[this.currentSort] < b[this.currentSort]) return -1 * modifier;
          if (a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
          return 0;
        })
        .filter((row, index) => {
          let start = (this.currentPage - 1) * this.C_tasksPerPage.value;
          let end = this.currentPage * this.C_tasksPerPage.value;
          if (index >= start && index < end) return true;
          return this.end;
        });
    },
    sortedIssues: function () {
      return this.issuesObj
        .sort((a, b) => {
          let modifier = 1;
          if (this.currentSortDir === "desc") modifier = -1;
          if (a[this.currentSort] < b[this.currentSort]) return -1 * modifier;
          if (a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
          return 0;
        })
        .filter((row, index) => {
          let start = (this.currentIssuesPage - 1) * this.C_issuesPerPage.value;
          let end = this.currentIssuesPage * this.C_issuesPerPage.value;
          if (index >= start && index < end) return true;
          return this.end;
        });
    },
    sortedRisks: function () {
      return this.risksObj
        .sort((a, b) => {
          let modifier = 1;
          if (this.currentSortDir === "desc") modifier = -1;
          if (a[this.currentSort] < b[this.currentSort]) return -1 * modifier;
          if (a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
          return 0;
        })
        .filter((row, index) => {
          let start = (this.currentRisksPage - 1) * this.C_risksPerPage.value;
          let end = this.currentRisksPage * this.C_risksPerPage.value;
          if (index >= start && index < end) return true;
          return this.end;
        });
    },
    sortedLessons: function () {
      return this.lessonsObj
        .sort((a, b) => {
          let modifier = 1;
          if (this.currentSortDir === "desc") modifier = -1;
          if (a[this.currentSort] < b[this.currentSort]) return -1 * modifier;
          if (a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
          return 0;
        })
        .filter((row, index) => {
          let start =
            (this.currentLessonsPage - 1) * this.C_lessonsPerPage.value;
          let end = this.currentLessonsPage * this.C_lessonsPerPage.value;
          if (index >= start && index < end) return true;
          return this.end;
        });
    },
    validStages() {
      return this.portfolioTasks.filter((t) => {
        return t.task_stage !== null && t.task_stage !== "";
      });
    },
    tasksObj() {
      if(this.currentTab != 'tasks')
        return []
      return this.portfolioTasks
        .filter((task) => {
          return this.facility_project_ids.length < 1 ? true : this.facility_project_ids.includes(task.facility_project_id)
        })
        .filter((task) => {
          if (this.C_portfolioUsersFilter.length > 0) {
            let users = this.C_portfolioUsersFilter.map((t) => t.name);
            let taskObjUsers = task.task_users.map((t) => t.name);
            return users.some((element) => taskObjUsers.includes(element));
          } else return true;
        })
        .filter((task) => {
          let taskIssueProgress = this.taskIssueProgressFilter;
          if (taskIssueProgress && taskIssueProgress[0]) {
            var min = taskIssueProgress[0].value.split("-")[0];
            var max = taskIssueProgress[0].value.split("-")[1];
            return task.progress >= min && task.progress <= max;
          } else return true;
        })
        .filter((task) => {
          let taskIssueDueDates = this.taskIssueDueDateFilter;
          if (
            taskIssueDueDates &&
            taskIssueDueDates[0] &&
            taskIssueDueDates[1]
          ) {
            let startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD");
            let endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD");
            let valid = true;
            let nDate = moment(task.due_date, "YYYY-MM-DD");
            valid = nDate.isBetween(startDate, endDate, "days", true);
            return valid;
          } else return true;
        })
        .filter((task) => {
          let projectGroupDueDates = this.facilityDueDateFilter;
          if (
            projectGroupDueDates &&
            projectGroupDueDates[0] &&
            projectGroupDueDates[1]
          ) {
            let startDate = moment(projectGroupDueDates[0], "YYYY-MM-DD");
            let endDate = moment([1], "YYYY-MM-DD");
            let valid = true;
            let nDate = moment(task.due_date, "YYYY-MM-DD");
            valid = nDate.isBetween(startDate, endDate, "days", true);
            return valid;
          } else return true;
        })
        .filter((task) => {
          let noteDates = this.noteDateFilter;
          if (noteDates && noteDates[0] && noteDates[1]) {
            let startDate = moment(noteDates[0], "YYYY-MM-DD");
            let endDate = moment(noteDates[1], "YYYY-MM-DD");
            let _notesCreatedAt = _.map(task.notes, "created_at");
            let valid = task.notes.length > 0;
            for (let createdAt of _notesCreatedAt) {
              let nDate = moment(createdAt, "YYYY-MM-DD");
              valid = nDate.isBetween(startDate, endDate, "days", true);
              return valid;
            }
          } else return true;
        })
        .filter((task) => {
          let projectProgress = this.facilityProgressFilter;
          // let valid = Boolean(task && task.hasOwnProperty('progress'))
          if (projectProgress && projectProgress[0]) {
            var min = projectProgress[0].value.split("-")[0];
            var max = projectProgress[0].value.split("-")[1];
            return task.project_progress >= min && task.project_progress <= max;
          } else return true;
        })
        .filter((task) => {
          let programProgress = this.programProgressFilter;
          if (programProgress && programProgress[0]) {
            var min = programProgress[0].value.split("-")[0];
            var max = programProgress[0].value.split("-")[1];
            return task.program_progress >= min && task.program_progress <= max;
          } else return true;
        })
        .filter((task) => {
          // return task.task_stage !== null && task.task_stage !== ''
          if (this.C_portfolioTaskStageFilter.length > 0) {
            let stages = this.C_portfolioTaskStageFilter.map((t) => t.name);
            return stages.includes(task.task_stage);
          } else return true;
        })
        .filter((task) => {
          if (this.C_portfolioStatusesFilter.length > 0) {
            let status = this.C_portfolioStatusesFilter.map((t) => t.name);
            return status.includes(task.project_status);
          } else return true;
        })
        .filter((task) => {
          if (this.C_categoryNameFilter.length > 0) {
            let category = this.C_categoryNameFilter.map((t) => t);
            return category.includes(task.category);
          } else return true;
        })
        .filter((task) => {
          if (this.search_tasks !== "") {
            return (
              task.text.toLowerCase().match(this.search_tasks.toLowerCase()) ||
              task.category
                .toLowerCase()
                .match(this.search_tasks.toLowerCase()) ||
              task.program_name
                .toLowerCase()
                .match(this.search_tasks.toLowerCase()) ||
              task.project_name
                .toLowerCase()
                .match(this.search_tasks.toLowerCase()) ||
              task.users.toLowerCase().match(this.search_tasks.toLowerCase())
            );
          } else return true;
          // Filtering 7 Task States
        })
        .filter((task) => {
          if (this.hideDraft) {
            return !task.draft;
          } else return true;
        })
        .filter((task) => {
          if (this.hideOnhold) {
            return !task.on_hold;
          } else return true;
        })
        .filter((task) => {
          if (this.hideOngoing) {
            return !task.ongoing;
          } else return true;
        })
        .filter((task) => {
          if (this.hideInprogress) {
            return !task.in_progress;
          } else return true;
        })
        .filter((task) => {
          if (this.hidePlanned) {
            return !task.planned;
          } else return true;
        })
        .filter((task) => {
          if (this.hideOverdue) {
            return !task.is_overdue;
          } else return true;
        })
        .filter((task) => {
          if (this.hideComplete) {
            return !task.completed;
          } else return true;
          // Filtering 3 Task Tags
        })
        .filter((task) => {
          if (this.hideBriefed && !this.hideWatched && !this.hideImportant) {
            return task.reportable;
          }
          if (this.hideBriefed && this.hideWatched && !this.hideImportant) {
            return task.reportable + task.watched;
          }
          if (this.hideBriefed && this.hideWatched && this.hideImportant) {
            return task.reportable + task.watched + task.important;
          } else return true;
        })
        .filter((task) => {
          // This and last 2 filters are for Filtered Tags
          if (this.hideWatched && !this.hideBriefed && !this.hideImportant) {
            return task.watched;
          }
          if (this.hideWatched && !this.hideBriefed && this.hideImportant) {
            return task.watched + task.important;
          }
          if (this.hideWatched && this.hideBriefed && !this.hideImportant) {
            return task.watched + task.reportable;
          }
          if (this.hideWatched && this.hideBriefed && this.hideImportant) {
            return task.watched + task.reportable + task.important;
          } else return true;
        })
        .filter((task) => {
          if (this.hideImportant && !this.hideBriefed && !this.hideWatched) {
            return task.important;
          }
          if (this.hideImportant && this.hideBriefed && !this.hideWatched) {
            return task.important + task.reportable;
          }
          if (this.hideImportant && this.hideBriefed && this.hideWatched) {
            return task.important + task.reportable + task.watched;
          } else return true;
        });
    },
    issuesObj() {
      if(this.currentTab != 'issues')
        return []
      return this.portfolioIssues
        .filter((issue) => {
           return this.facility_project_ids.length < 1 ? true : this.facility_project_ids.includes(issue.facility_project_id)
        })
        .filter((issue) => {
          if (this.C_categoryNameFilter.length > 0) {
            let category = this.C_categoryNameFilter.map((t) => t);
            return category.includes(issue.category);
          } else return true;
        })
        .filter((issue) => {
          let taskIssueDueDates = this.taskIssueDueDateFilter;
          if (
            taskIssueDueDates &&
            taskIssueDueDates[0] &&
            taskIssueDueDates[1]
          ) {
            let startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD");
            let endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD");
            let valid = true;
            let nDate = moment(issue.due_date, "YYYY-MM-DD");
            valid = nDate.isBetween(startDate, endDate, "days", true);
            return valid;
          } else return true;
        })
        .filter((issue) => {
          let noteDates = this.noteDateFilter;
          if (noteDates && noteDates[0] && noteDates[1]) {
            let startDate = moment(noteDates[0], "YYYY-MM-DD");
            let endDate = moment(noteDates[1], "YYYY-MM-DD");
            let _notesCreatedAt = _.map(issue.notes, "created_at");
            let valid = issue.notes.length > 0;
            for (let createdAt of _notesCreatedAt) {
              let nDate = moment(createdAt, "YYYY-MM-DD");
              valid = nDate.isBetween(startDate, endDate, "days", true);
              return valid;
            }
          } else return true;
        })
        .filter((issue) => {
          let taskIssueProgress = this.taskIssueProgressFilter;
          if (taskIssueProgress && taskIssueProgress[0]) {
            var min = taskIssueProgress[0].value.split("-")[0];
            var max = taskIssueProgress[0].value.split("-")[1];
            return issue.progress >= min && issue.progress <= max;
          } else return true;
        })
        .filter((issue) => {
          let projectProgress = this.facilityProgressFilter;
          if (projectProgress && projectProgress[0]) {
            var min = projectProgress[0].value.split("-")[0];
            var max = projectProgress[0].value.split("-")[1];
            return (
              issue.project_progress >= min && issue.project_progress <= max
            );
          } else return true;
        })
        .filter((issue) => {
          let programProgress = this.programProgressFilter;
          if (programProgress && programProgress[0]) {
            var min = programProgress[0].value.split("-")[0];
            var max = programProgress[0].value.split("-")[1];
            return (
              issue.program_progress >= min && issue.program_progress <= max
            );
          } else return true;
        })
        .filter((issue) => {
          if (this.C_portfolioStatusesFilter.length > 0) {
            let status = this.C_portfolioStatusesFilter.map((t) => t.name);
            return status.includes(issue.project_status);
          } else return true;
        })
        .filter((issue) => {
          // return task.task_stage !== null && task.task_stage !== ''
          if (this.C_portfolioIssueStageFilter.length > 0) {
            let stages = this.C_portfolioIssueStageFilter.map((t) => t.name);
            return stages.includes(issue.issue_stage);
          } else return true;
        })
        .filter((issue) => {
          // return task.task_stage !== null && task.task_stage !== ''
          if (this.C_portfolioIssueSeverityFilter.length > 0) {
            let stages = this.C_portfolioIssueSeverityFilter.map((t) => t.name);
            return stages.includes(issue.issue_severity);
          } else return true;
        })
        .filter((issue) => {
          if (this.C_portfolioUsersFilter.length > 0) {
            let users = this.C_portfolioUsersFilter.map((t) => t.name);
            let issueObjUsers = issue.issue_users.map((t) => t.name);
            // console.log(users.some(element => taskObjUsers.includes(element)))
            return users.some((element) => issueObjUsers.includes(element));
          } else return true;
        })
        .filter((issue) => {
          if (this.C_portfolioIssueTypesFilter.length > 0) {
            let types = this.C_portfolioIssueTypesFilter.map((t) => t.name);
            return types.includes(issue.issue_type);
          } else return true;
        })
        .filter((issue) => {
          if (this.search_issues !== "") {
            return (
              issue.title
                .toLowerCase()
                .match(this.search_issues.toLowerCase()) ||
              issue.issue_severity
                .toLowerCase()
                .match(this.search_issues.toLowerCase()) ||
              issue.issue_type
                .toLowerCase()
                .match(this.search_issues.toLowerCase()) ||
              // Process Area not included as it is not a requirement for Issues and null values will break search filter
              // issue.category.toLowerCase().match(this.search_issues.toLowerCase()) ||
              issue.program_name
                .toLowerCase()
                .match(this.search_issues.toLowerCase()) ||
              issue.project_name
                .toLowerCase()
                .match(this.search_issues.toLowerCase()) ||
              issue.users.toLowerCase().match(this.search_issues.toLowerCase())
            );
          } else return true;
        })
        .filter((issue) => {
          if (this.hideDraft) {
            return !issue.draft;
          } else return true;
        })
        .filter((issue) => {
          if (this.hideOnhold) {
            return !issue.on_hold;
          } else return true;
        })
        .filter((issue) => {
          if (this.hideOverdue) {
            return !issue.is_overdue;
          } else return true;
        })
        .filter((issue) => {
          if (this.hideComplete) {
            return !issue.completed;
          } else return true;
        })
        .filter((issue) => {
          if (this.hideInprogress) {
            return !issue.in_progress;
          } else return true;
        })
        .filter((issue) => {
          if (this.hidePlanned) {
            return !issue.planned;
          } else return true;
          // Filtering 3 Issues Tags
        })
        .filter((issue) => {
          if (this.hideBriefed && !this.hideWatched && !this.hideImportant) {
            return issue.reportable;
          }
          if (this.hideBriefed && this.hideWatched && !this.hideImportant) {
            return issue.reportable + issue.watched;
          }
          if (this.hideBriefed && this.hideWatched && this.hideImportant) {
            return issue.reportable + issue.watched + issue.important;
          } else return true;
        })
        .filter((issue) => {
          if (this.hideWatched && !this.hideBriefed && !this.hideImportant) {
            return issue.watched;
          }
          if (this.hideWatched && !this.hideBriefed && this.hideImportant) {
            return issue.watched + issue.important;
          }
          if (this.hideWatched && this.hideImportant && !this.hideBriefed) {
            return issue.important + issue.watched;
          }
          if (this.hideWatched && this.hideImportant && this.hideBriefed) {
            return issue.important + issue.watched + issue.reportable;
          } else return true;
        })
        .filter((issue) => {
          if (this.hideImportant && !this.hideBriefed && !this.hideWatched) {
            return issue.important;
          }
          if (this.hideImportant && this.hideBriefed && !this.hideWatched) {
            return issue.important + issue.reportable;
          }
          if (this.hideImportant && this.hideBriefed && this.hideWatched) {
            return issue.important + issue.reportable + issue.watched;
          } else return true;
        });
    },
    risksObj() {
      if(this.currentTab != 'risks')
        return []
      return this.portfolioRisks
        .filter((risk) => {       
          return this.facility_project_ids.length < 1 ? true : this.facility_project_ids.includes(risk.facility_project_id)
        })
        .filter((risk) => {
          let projectProgress = this.facilityProgressFilter;
          if (projectProgress && projectProgress[0]) {
            var min = projectProgress[0].value.split("-")[0];
            var max = projectProgress[0].value.split("-")[1];
            return risk.project_progress >= min && risk.project_progress <= max;
          } else return true;
        })
        .filter((risk) => {
          let noteDates = this.noteDateFilter;
          if (noteDates && noteDates[0] && noteDates[1]) {
            let startDate = moment(noteDates[0], "YYYY-MM-DD");
            let endDate = moment(noteDates[1], "YYYY-MM-DD");
            let _notesCreatedAt = _.map(risk.notes, "created_at");
            let valid = risk.notes.length > 0;
            for (let createdAt of _notesCreatedAt) {
              let nDate = moment(createdAt, "YYYY-MM-DD");
              valid = nDate.isBetween(startDate, endDate, "days", true);
              return valid;
            }
          } else return true;
        })
        .filter((risk) => {
          let taskIssueDueDates = this.taskIssueDueDateFilter;
          if (
            taskIssueDueDates &&
            taskIssueDueDates[0] &&
            taskIssueDueDates[1]
          ) {
            let startDate = moment(taskIssueDueDates[0], "YYYY-MM-DD");
            let endDate = moment(taskIssueDueDates[1], "YYYY-MM-DD");
            let valid = true;
            let nDate = moment(risk.due_date, "YYYY-MM-DD");
            valid = nDate.isBetween(startDate, endDate, "days", true);
            return valid;
          } else return true;
        })
        .filter((risk) => {
          let programProgress = this.programProgressFilter;
          if (programProgress && programProgress[0]) {
            var min = programProgress[0].value.split("-")[0];
            var max = programProgress[0].value.split("-")[1];
            return risk.program_progress >= min && risk.program_progress <= max;
          } else return true;
        })
        .filter((risk) => {
          let taskIssueProgress = this.taskIssueProgressFilter;
          if (taskIssueProgress && taskIssueProgress[0]) {
            var min = taskIssueProgress[0].value.split("-")[0];
            var max = taskIssueProgress[0].value.split("-")[1];
            return risk.progress >= min && risk.progress <= max;
          } else return true;
        })
        .filter((risk) => {
          if (this.C_portfolioStatusesFilter.length > 0) {
            let status = this.C_portfolioStatusesFilter.map((t) => t.name);
            return status.includes(risk.project_status);
          } else return true;
        })
        .filter((risk) => {
          if (this.C_categoryNameFilter.length > 0) {
            let category = this.C_categoryNameFilter.map((t) => t);
            return category.includes(risk.category);
          } else return true;
        })
        .filter((risk) => {
          if (this.C_portfolioUsersFilter.length > 0) {
            let users = this.C_portfolioUsersFilter.map((t) => t.name);
            let riskObjUsers = risk.risk_users.map((t) => t.name);
            return users.some((element) => riskObjUsers.includes(element));
          } else return true;
        })
        .filter((risk) => {
          if (this.C_portfolioRiskStageFilter.length > 0) {
            let stages = this.C_portfolioRiskStageFilter.map((t) => t.name);
            return stages.includes(risk.risk_stage);
          } else return true;
        })
        .filter((risk) => {
          if (this.C_riskPriorityLevelFilter.length > 0) {
            let priority = this.C_riskPriorityLevelFilter.map((t) => t.name);
            return priority.includes(risk.priority_level);
          } else return true;
        })
        .filter((risk) => {
          if (this.C_riskApproachFilter.length > 0) {
            let approach = this.C_riskApproachFilter.map((t) => t.name);
            return approach.includes(risk.risk_approach);
          } else return true;
        })
        .filter((risk) => {
          if (this.search_risks !== "") {
            return (
              risk.text.toLowerCase().match(this.search_risks.toLowerCase()) ||
              risk.category
                .toLowerCase()
                .match(this.search_risks.toLowerCase()) ||
              risk.risk_approach
                .toLowerCase()
                .match(this.search_risks.toLowerCase()) ||
              risk.program_name
                .toLowerCase()
                .match(this.search_risks.toLowerCase()) ||
              risk.project_name
                .toLowerCase()
                .match(this.search_risks.toLowerCase()) ||
              risk.users.toLowerCase().match(this.search_risks.toLowerCase())
            );
          } else return true;
        })
        .filter((risk) => {
          if (this.hideDraft) {
            return !risk.draft;
          } else return true;
        })
        .filter((risk) => {
          if (this.hideOnhold) {
            return !risk.on_hold;
          } else return true;
        })
        .filter((risk) => {
          if (this.hideInprogress) {
            return !risk.in_progress;
          } else return true;
        })
        .filter((risk) => {
          if (this.hidePlanned) {
            return !risk.planned;
          } else return true;
        })
        .filter((risk) => {
          if (this.hideOverdue) {
            return !risk.is_overdue;
          } else return true;
        })
        .filter((risk) => {
          if (this.hideOngoing) {
            return !risk.ongoing;
          } else return true;
        })
        .filter((risk) => {
          if (this.hideComplete) {
            return !risk.completed;
          } else return true;
        })
        .filter((risk) => {
          if (this.hideBriefed && !this.hideWatched && !this.hideImportant) {
            return risk.reportable;
          }
          if (this.hideBriefed && this.hideWatched && !this.hideImportant) {
            return risk.reportable + risk.watched;
          }
          if (this.hideBriefed && this.hideWatched && this.hideImportant) {
            return risk.reportable + risk.watched + risk.important;
          } else return true;
        })
        .filter((risk) => {
          if (this.hideWatched && !this.hideBriefed && !this.hideImportant) {
            return risk.watched;
          }
          if (this.hideWatched && !this.hideBriefed && this.hideImportant) {
            return risk.watched + risk.important;
          }
          if (this.hideWatched && this.hideImportant && !this.hideBriefed) {
            return risk.important + risk.watched;
          }
          if (this.hideWatched && this.hideImportant && this.hideBriefed) {
            return risk.important + risk.watched + risk.reportable;
          } else return true;
        })
        .filter((risk) => {
          if (this.hideImportant && !this.hideBriefed && !this.hideWatched) {
            return risk.important;
          }
          if (this.hideImportant && this.hideBriefed && !this.hideWatched) {
            return risk.important + risk.reportable;
          }
          if (this.hideImportant && this.hideBriefed && this.hideWatched) {
            return risk.important + risk.reportable + risk.watched;
          } else return true;
        });
    },
    lessonsObj() {
      if(this.currentTab != 'lessons')
        return []
      return this.portfolioLessons
        .filter((lesson) => {
           return this.facility_project_ids.length < 1 ? true : this.facility_project_ids.includes(lesson.facility_project_id)
        })
        .filter((lesson) => {
          if (this.C_portfolioUsersFilter.length > 0) {
            let users = this.C_portfolioUsersFilter.map((t) => t.name);
            let lessonObjUsers = lesson.added_by;
            // console.log(users.some(element => taskObjUsers.includes(element)))
            return users.some((element) => lessonObjUsers.includes(element));
          } else return true;
        })
        .filter((lesson) => {
          if (this.C_categoryNameFilter.length > 0) {
            let category = this.C_categoryNameFilter.map((t) => t);
            return category.includes(lesson.category);
          } else return true;
        })
        .filter((lesson) => {
          let noteDates = this.noteDateFilter;
          if (noteDates && noteDates[0] && noteDates[1]) {
            let startDate = moment(noteDates[0], "YYYY-MM-DD");
            let endDate = moment(noteDates[1], "YYYY-MM-DD");
            let _notesCreatedAt = _.map(lesson.notes, "created_at");
            let valid = lesson.notes.length > 0;
            for (let createdAt of _notesCreatedAt) {
              let nDate = moment(createdAt, "YYYY-MM-DD");
              valid = nDate.isBetween(startDate, endDate, "days", true);
              return valid;
            }
          } else return true;
        })
        .filter((lesson) => {
          // if (this.search_lessons !== "" && lesson.category && lesson.category !== null) {
          if (this.search_lessons !== "") {
            return (
              lesson.title
                .toLowerCase()
                .match(this.search_lessons.toLowerCase()) ||
              lesson.program_name
                .toLowerCase()
                .match(this.search_lessons.toLowerCase()) ||
              lesson.project_name
                .toLowerCase()
                .match(this.search_lessons.toLowerCase()) ||
              lesson.added_by
                .toLowerCase()
                .match(this.search_lessons.toLowerCase())
            );
          } else return true;
        })
        .filter((lesson) => {
          // Filtering 3 Lesson States
          if (this.hideDraft) {
            return !lesson.draft;
          } else return true;
        })
        .filter((lesson) => {
          if (this.hideComplete) {
            return lesson.draft;
          } else return true;

          // Filtering 3 Task Tags
        })
        .filter((lesson) => {
          if (this.hideBriefed && !this.hideImportant) {
            return lesson.reportable;
          }
          if (this.hideBriefed && this.hideWatched && this.hideImportant) {
            return lesson.reportable + lesson.watched + lesson.important;
          } else return true;
        })
        .filter((lesson) => {
          if (this.hideImportant && !this.hideBriefed) {
            return lesson.important;
          }
          if (this.hideImportant && this.hideBriefed) {
            return lesson.important + lesson.reportable;
          } else return true;
        });
    },
    taskVariation() {
      let planned = _.filter(this.portfolioTasks, (t) => t && t.planned);
      let taskDrafts = _.filter(
        this.portfolioTasks,
        (t) => t && t.draft == true
      );
      let important = _.filter(
        this.portfolioTasks,
        (t) => t && t.important == true
      );
      let briefings = _.filter(
        this.portfolioTasks,
        (t) => t && t.reportable == true
      );
      let watched = _.filter(
        this.portfolioTasks,
        (t) => t && t.watched == true
      );

      let completed = _.filter(this.portfolioTasks, (t) => t && t.completed);
      let inProgress = _.filter(this.portfolioTasks, (t) => t && t.in_progress);
      let onHoldT = _.filter(
        this.portfolioTasks,
        (t) => t && t.on_hold == true
      );
      let ongoing = _.filter(
        this.portfolioTasks,
        (t) => t && t.ongoing == true
      );
      let ongoingClosed = _.filter(
        this.portfolioTasks,
        (t) => t && t.closed == true
      );
      let overdue = _.filter(
        this.portfolioTasks,
        (t) => t && t.is_overdue == true
      );

      return {
        planned: {
          count: planned.length,
          plannedTs: planned,
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
          count: inProgress.length,
          // percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          // percentage: Math.round(overdue_percent),
        },
        ongoingClosed: {
          count: ongoingClosed.length,
        },
        ongoing: {
          count: ongoing.length,
        },
      };
    },
    issueVariation() {
      let planned = _.filter(
        this.portfolioIssues,
        (t) => t && t.planned == true
        // (t) => t && t.startDate && t.startDate > this.today
      );
      let issueDrafts = _.filter(
        this.portfolioIssues,
        (t) => t && t.draft == true
      );
      let completed = _.filter(this.portfolioIssues, (t) => t && t.completed);
      let inProgress = _.filter(
        this.portfolioIssues,
        (t) => t && t.in_progress == true
      );
      let onHoldI = _.filter(
        this.portfolioIssues,
        (t) => t && t.on_hold == true
      );
      let overdue = _.filter(
        this.portfolioIssues,
        (t) => t && t.is_overdue == true
      );
      let important = _.filter(
        this.portfolioIssues,
        (t) => t && t.important == true
      );
      let briefings = _.filter(
        this.portfolioIssues,
        (t) => t && t.reportable == true
      );
      let watched = _.filter(
        this.portfolioIssues,
        (t) => t && t.watched == true
      );

      return {
        planned: {
          count: planned.length,
          plannedTs: planned,
        },
        onHoldI: {
          count: onHoldI.length,
        },
        issueDrafts: {
          count: issueDrafts.length,
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
        completed: {
          count: completed.length,
          // percentage: Math.round(completed_percent),
        },
        inProgress: {
          count: inProgress.length,
          // percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          // percentage: Math.round(overdue_percent),
        },
      };
    },
    filterOutWatched() {
      return _.filter(this.tasksObj, (t) => t && t.watched == false);
    },
    riskVariation() {
      let planned = _.filter(
        this.portfolioRisks,
        (t) => t && t.planned == true
        // (t) => t && t.startDate && t.startDate > this.today
      );
      let riskDrafts = _.filter(
        this.portfolioRisks,
        (t) => t && t.draft == true
      );
      let important = _.filter(
        this.portfolioRisks,
        (t) => t && t.important == true
      );
      let briefings = _.filter(
        this.portfolioRisks,
        (t) => t && t.reportable == true
      );
      let watched = _.filter(
        this.portfolioRisks,
        (t) => t && t.watched == true
      );
      let completed = _.filter(
        this.portfolioRisks,
        (t) => t && t.completed == true
      );
      let inProgress = _.filter(
        this.portfolioRisks,
        (t) => t && t.in_progress == true
      );
      let onHoldR = _.filter(
        this.portfolioRisks,
        (t) => t && t.on_hold == true
      );
      let ongoing = _.filter(
        this.portfolioRisks,
        (t) => t && t.ongoing == true
      );
      let ongoingClosed = _.filter(
        this.portfolioRisks,
        (t) => t && t.closed == true
      );
      let overdue = _.filter(
        this.portfolioRisks,
        (t) => t && t.is_overdue == true
      );
      return {
        planned: {
          count: planned.length,
          plannedTs: planned,
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
          count: inProgress.length,
          // percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          // percentage: Math.round(overdue_percent),
        },
        ongoingClosed: {
          count: ongoingClosed.length,
        },
        ongoing: {
          count: ongoing.length,
        },
      };
    },
    lessonVariation() {
      let lessonDrafts = _.filter(
        this.portfolioLessons,
        (t) => t && t.draft == true
      );
      let important = _.filter(
        this.lessonsObj,
        (t) => t && t.important == true
      );
      let briefings = _.filter(
        this.lessonsObj,
        (t) => t && t.reportable == true
      );
      let completed = _.filter(
        this.portfolioLessons,
        (t) => t && t.draft == false
      );
      return {
        important: {
          count: important.length,
        },
        briefings: {
          count: briefings.length,
        },
        lessonDrafts: {
          count: lessonDrafts.length,
        },
        completed: {
          count: completed.length,
          // percentage: Math.round(completed_percent),
        },
      };
    },
    C_showCountToggle: {
      get() {
        return this.getShowCount;
      },
      set(value) {
        this.setShowCount(value) || this.setShowCount(!this.getShowCount);
      },
    },
    C_portfolioUsersFilter: {
      get() {
        return this.portfolioUsersFilter;
      },
      set(value) {
        this.setPortfolioUsersFilter(value);
      },
    },
    C_portfolioNamesFilter: {
      get() {
        return this.portfolioNameFilter;
      },
      set(value) {
        this.facility_project_ids = [];
        // console.log(value)
        for(let k = 0; k < value.length; k++){
          // this.searchChildren(value[k]);
          // if(value[k].children && value[k].children.length > 0){
          //   if(value[k].all_facility_project_ids && value[k].all_facility_project_ids.length > 0){
          //     this.facility_project_ids = this.facility_project_ids.concat(value[k].all_facility_project_ids)
          //   }
          // }
          if(value[k].program_id){
            this.facility_project_ids = this.facility_project_ids.concat(value[k].all_facility_project_ids)
            break
          }else if(value[k].project_group_id){
            this.facility_project_ids = this.facility_project_ids.concat(value[k].all_facility_project_ids)
          }else if(value[k].project_id){
            this.facility_project_ids.push(value[k].facility_project_id)
          }
        }
        this.facility_project_ids = _.uniq(this.facility_project_ids)
        // console.log("------")
        // console.log(this.facility_project_ids)
        this.setPortfolioNameFilter(value);
      },
    },
    C_portfolioIssueTypesFilter: {
      get() {
        return this.portfolioIssueTypesFilter;
      },
      set(value) {
        this.setPortfolioIssueTypesFilter(value);
      },
    },
    C_portfolioStatusesFilter: {
      get() {
        return this.portfolioStatusesFilter;
      },
      set(value) {
        this.setPortfolioStatusesFilter(value);
      },
    },
    C_riskPriorityLevelFilter: {
      get() {
        return this.portfolioRiskPrioritiesFilter;
      },
      set(value) {
        this.setPortfolioRiskPrioritiesFilter(value);
      },
    },

    C_riskApproachFilter: {
      get() {
        return this.portfolioRiskApproachesFilter;
      },
      set(value) {
        this.setPortfolioRiskApproachesFilter(value);
      },
    },
    C_programNames() {
      return this.portfolioPrograms;
    },
    C_categories() {
      let category = this.portfolioTasks;
      return [
        ...new Set(
          category
            .filter((item) => item.category != null)
            .map((item) => item.category)
        ),
      ];
    },
    C_i_categories() {
      let category = this.portfolioIssues;
      return [
        ...new Set(
          category
            .filter((item) => item.category != null)
            .map((item) => item.category)
        ),
      ];
    },
    C_r_categories() {
      let category = this.portfolioRisks;
      return [
        ...new Set(
          category
            .filter((item) => item.category != null)
            .map((item) => item.category)
        ),
      ];
    },
    C_l_categories() {
      let category = this.portfolioLessons;
      return [
        ...new Set(
          category
            .filter((item) => item.category != null)
            .map((item) => item.category)
        ),
      ];
    },
    C_programNameFilter: {
      get() {
        return this.programNameFilter;
      },
      set(value) {
        // console.log(value)
        this.setProgramNameFilter(value);
      },
    },
    C_portfolioTaskStageFilter: {
      get() {
        return this.portfolioTaskStagesFilter;
      },
      set(value) {
        this.setPortfolioTaskStagesFilter(value);
      },
    },
    C_portfolioIssueStageFilter: {
      get() {
        return this.portfolioIssueStagesFilter;
      },
      set(value) {
        this.setPortfolioIssueStagesFilter(value);
      },
    },
    C_portfolioIssueSeverityFilter: {
      get() {
        return this.portfolioIssueSeveritiesFilter;
      },
      set(value) {
        this.setPortfolioIssueSeveritiesFilter(value);
      },
    },
    C_portfolioRiskStageFilter: {
      get() {
        return this.portfolioRiskStagesFilter;
      },
      set(value) {
        this.setPortfolioRiskStagesFilter(value);
      },
    },

    C_categoryNameFilter: {
      get() {
        return this.portfolioCategoriesFilter;
      },
      set(value) {
        // console.log(value)
        this.setPortfolioCategoriesFilter(value);
      },
    },
    C_hideWatchedTasks: {
      get() {
        return this.getPortfolioWatchedTasksToggle;
      },
      set() {
        this.setPortfolioWatchedTasksToggle(
          !this.getPortfolioWatchedTasksToggle
        );
      },
    },
    C_hideImportantTasks: {
      get() {
        return this.getPortfolioImportantTasksToggle;
      },
      set() {
        this.setPortfolioImportantTasksToggle(
          !this.getPortfolioImportantTasksToggle
        );
      },
    },
    C_issuesPerPage: {
      get() {
        return this.getIssuesPerPageFilter || { id: 15, name: "15", value: 15 };
      },
      set(value) {
        this.setIssuesPerPageFilter(value);
      },
    },
    C_tasksPerPage: {
      get() {
        return this.getTasksPerPageFilter || { id: 15, name: "15", value: 15 };
      },
      set(value) {
        this.setTasksPerPageFilter(value);
      },
    },
    C_risksPerPage: {
      get() {
        return this.getRisksPerPageFilter || { id: 15, name: "15", value: 15 };
      },
      set(value) {
        this.setRisksPerPageFilter(value);
      },
    },
    C_lessonsPerPage: {
      get() {
        return (
          this.getLessonsPerPageFilter || { id: 15, name: "15", value: 15 }
        );
      },
      set(value) {
        this.setLessonsPerPageFilter(value);
      },
    },
    C_hideBriefedTasks: {
      get() {
        return this.getPortfolioBriefedTasksToggle;
      },
      set() {
        this.setPortfolioBriefedTasksToggle(
          !this.getPortfolioBriefedTasksToggle
        );
      },
    },
  },
  methods: {
    ...mapMutations([
      "setPortfolioWatchedTasksToggle",
      "setPortfolioNameFilter",
      "setPortfolioRiskNameFilter",
      "setTaskIssueUserFilter",
      "setPortfolioUsersFilter",
      "setTasksPerPageFilter",
      "setTaskIssueProgressFilter",
      "setIssuesPerPageFilter",
      "setRisksPerPageFilter",
      "setLessonsPerPageFilter",
      "setPortfolioBriefedTasksToggle",
      "setPortfolioImportantTasksToggle",
      "setPortfolioCategoriesFilter",
      "setPortfolioStatuses",
      "setPortfolioStatusesFilter",
      "setPortfolioUsers",
      "setPortfolioTaskStages",
      "setPortfolioTaskStagesFilter",
      "setPortfolioIssueStages",
      "setPortfolioIssueStagesFilter",
      "setPortfolioIssueSeverities",
      "setPortfolioIssueSeveritiesFilter",
      "setPortfolioRiskStages",
      "setPortfolioRiskStagesFilter",
      "setPortfolioUsersFilter",
      "setProgramNameFilter",
      "setPortfolioIssueTypes",
      "setPortfolioIssueTypesFilter",
      "setTaskTypeFilter",
      "setShowCount",
      "setPortfolioRiskPriorities",
      "setPortfolioRiskPrioritiesFilter",
      "setPortfolioRiskApproaches",
      "setPortfolioRiskApproachesFilter",
      "setProgramProgressFilter",
      "setFacilityProgressFilter",
      "setNoteDateFilter",
      "setTaskIssueDueDateFilter",
      "setFacilityDueDateFilter",
      'updateProgramFilterValue'
    ]),
    ...mapActions([
      "fetchPortfolioTasks",
      "fetchPortfolioIssues",
      "fetchPortfolioCounts",
      "fetchPortfolioRisks",
      "fetchPortfolioLessons",
      "fetchPortfolioPrograms",
      ]),
    log(e) {
      //  console.log("number" + e)
    },
    beforeClose(done) {
    	this.dialogVisible = false;
      done();
    },
    // NOTE: WIP
    programAjaxFilterOptions({ action, parentNode, callback }) {
      // Typically, do the AJAX stuff here.
      // Once the server has responded,
      // assign children options to the parent node & call the callback.
      
      if (action === LOAD_CHILDREN_OPTIONS) {
        switch (parentNode.id) {
        case 'success': {
          simulateAsyncOperation(() => {
            parentNode.children = [ {
              id: 'child',
              label: 'Child option',
            } ]
            callback()
          })
          break
        }
        case 'no-children': {
          simulateAsyncOperation(() => {
            parentNode.children = []
            callback()
          })
          break
        }
        case 'failure': {
          simulateAsyncOperation(() => {
            callback(new Error('Failed to load options: network error.'))
          })
          break
        }
        default: /* empty */
        }
      }
    },
    searchChildren: function (node) {
      // console.log("start", new Date() )
      if (node.children && node.children.length > 0) {

        for(let k = 0; k < node.children.length; k++){
          this.searchChildren(node.children[k]);
        }
        
      } else {
        this.facility_project_ids.push(node.facility_project_id);
      }
      // console.log("end",new Date() )
    },
    openTpresentation(){
      this.dialogVisible = true; 
      this.currentTaskSlide = 0 
      this.dynamicObj = this.tasksObj  
      this.action = "TASK"   
    },
   openIpresentation(){
      this.dialogVisible = true; 
      this.currentTaskSlide = 0 
      this.dynamicObj = this.issuesObj;
      this.action = "ISSUE"       
    },
    openRpresentation(){
      this.dialogVisible = true; 
      this.currentTaskSlide = 0 
      this.dynamicObj = this.risksObj;
      this.action = "RISK"       
    },
    openLpresentation(){
      this.dialogVisible = true; 
      this.currentTaskSlide = 0 
      this.dynamicObj = this.lessonsObj;
      this.action = "LESSON"       
    },
    nextTask(){
      this.isSlidingToPrevious = false
      if(this.currentTaskSlide == this.dynamicObj.length-1){
          this.currentTaskSlide = 0;
      }else{
          this.currentTaskSlide += 1;
      }
    },
    previousTask(){ 
        this.isSlidingToPrevious = true
        if(this.currentTaskSlide == 0){
            this.currentTaskSlide=this.dynamicObj.length-1;
        }else{
            this.currentTaskSlide-=1;
        }
    },
    showCountToggle() {
      this.getShowCount(!this.getShowCount);
    },
    sort: function (s) {
     //if s == current sort, reverse
      if (s === this.currentSort) {
        this.currentSortDir = this.currentSortDir === "asc" ? "desc" : "asc";
      }
      this.currentSort = s;
    },
    nextPage: function () {
      if (this.currentPage * this.C_tasksPerPage.value < this.tasksObj.length)
        this.currentPage++;
    },
    prevPage: function () {
      if (this.currentPage > 1) this.currentPage--;
    },
    sortI: function (s) {
      //if s == current sort, reverse
      if (s === this.currentSort) {
        this.currentSortDir = this.currentSortDir === "asc" ? "desc" : "asc";
      }
      this.currentSort = s;
    },
    nextIssuesPage: function () {
      if (
        this.currentIssuesPage * this.C_issuesPerPage.value <
        this.issuesObj.length
      )
        this.currentIssuesPage++;
    },
    prevIssuesPage: function () {
      if (this.currentIssuesPage > 1) this.currentIssuesPage--;
    },
    sortR: function (s) {
      //if s == current sort, reverse
      if (s === this.currentSort) {
        this.currentSortDir = this.currentSortDir === "asc" ? "desc" : "asc";
      }
      this.currentSort = s;
    },
    nextRisksPage: function () {
      if (
        this.currentRisksPage * this.C_risksPerPage.value <
        this.risksObj.length
      )
        this.currentRisksPage++;
    },
    prevRisksPage: function () {
      if (this.currentRisksPage > 1) this.currentRisksPage--;
    },
    sortL: function (s) {
      //if s == current sort, reverse
      if (s === this.currentSort) {
        this.currentSortDir = this.currentSortDir === "asc" ? "desc" : "asc";
      }
      this.currentSort = s;
    },
    nextLessonsPage: function () {
      if (
        this.currentLessonsPage * this.C_lessonsPerPage.value <
        this.lessonsObj.length
      )
        this.currentLessonsPage++;
    },
    prevLessonsPage: function () {
      if (this.currentLessonsPage > 1) this.currentLessonsPage--;
    },
    exportTasksToPdf() {
      const doc = new jsPDF("l");
      const html = this.$refs.table.innerHTML;
      doc.autoTable({ html: "#portTasks" });
      doc.save("Portfolio_Task_List.pdf");
    },
    exportTasksToExcel(table, name) {
      if (!table.nodeType) table = this.$refs.table;
      var ctx = { worksheet: name || "Worksheet", table: table.innerHTML };
      window.location.href =
        this.uri + this.base64(this.format(this.template, ctx));
    },
    exportIssuesToPdf() {
      const doc = new jsPDF("l");
      const html = this.$refs.table.innerHTML;
      doc.autoTable({ html: "#portIssues" });
      doc.save("Portfolio_Issues_Log.pdf");
    },
    exportIssuesToExcel(issueTable, name) {
      if (!issueTable.nodeType) issueTable = this.$refs.issueTable;
      var ctx = { worksheet: name || "Worksheet", table: issueTable.innerHTML };
      window.location.href =
        this.uri + this.base64(this.format(this.template, ctx));
    },
    exportRisksToPdf() {
      const doc = new jsPDF("l");
      const html = this.$refs.table.innerHTML;
      doc.autoTable({ html: "#portRisks" });
      doc.save("Portfolio_Risk_List.pdf");
    },
    exportRisksToExcel(riskTable, name) {
      if (!riskTable.nodeType) riskTable = this.$refs.riskTable;
      var ctx = { worksheet: name || "Worksheet", table: riskTable.innerHTML };
      window.location.href =
        this.uri + this.base64(this.format(this.template, ctx));
    },
    exportLessonsToPdf() {
      const doc = new jsPDF("l");
      const html = this.$refs.table.innerHTML;
      doc.autoTable({ html: "#portLessons" });
      doc.save("Portfolio_Lessons_List.pdf");
    },
    exportLessonsToExcel(lessonTable, name) {
      if (!lessonTable.nodeType) lessonTable = this.$refs.lessonTable;
      var ctx = {
        worksheet: name || "Worksheet",
        table: lessonTable.innerHTML,
      };
      window.location.href =
        this.uri + this.base64(this.format(this.template, ctx));
    },
    log(e) {
      //  console.log("Users" + e)
    },
    // Toggle for 3 Action Tags
    toggleWatched() {
      this.hideWatched = !this.hideWatched;
    },
    toggleBriefing() {
      this.hideBriefed = !this.hideBriefed;
    },
    toggleImportant() {
      this.hideImportant = !this.hideImportant;
    },
    // Toggle for 7 Action States
    toggleComplete() {
      this.hideComplete = !this.hideComplete;
    },
    toggleInprogress() {
      this.hideInprogress = !this.hideInprogress;
    },
    toggleOverdue() {
      this.hideOverdue = !this.hideOverdue;
    },
    toggleOngoing() {
      this.hideOngoing = !this.hideOngoing;
    },
    toggleDraft() {
      this.hideDraft = !this.hideDraft;
    },
    togglePlanned() {
      this.hidePlanned = !this.hidePlanned;
    },
    toggleOnhold() {
      this.hideOnhold = !this.hideOnhold;
    },
    toggleOverdue() {
      this.hideOverdue = !this.hideOverdue;
    },

    setPage(val) {
      this.page = val;
    },
    getProgramId(id) {
      this.programId = id;
      // console.log(id);
    },
    closeWindow() {
      window.close();
    },
    handleClick(tab, event) {
            // console.log(tab);
      let tab_id = $(event.target).attr("id")
      if(tab_id == "tab-tasks" || tab.name == 'tasks'){
        this.currentTab = 'tasks'
        if(this.tasksObj && this.tasksObj.length < 1){
          this.fetchPortfolioTasks();
        }
        
      }else if(tab_id == "tab-issues"  || tab.name == 'issues'){
        this.currentTab = 'issues'
        if(this.issuesObj && this.issuesObj.length < 1){
          this.fetchPortfolioIssues();
        }
      }else if(tab_id == "tab-risks"  || tab.name == 'risks'){
        this.currentTab = 'risks'
        if(this.risksObj && this.risksObj.length < 1){
          this.fetchPortfolioRisks();
        }
        
      }else if(tab_id == "tab-lessons"  || tab.name == 'lessons'){
        this.currentTab = 'lessons'
        if(this.lessonsObj && this.lessonsObj.length < 1){
          this.fetchPortfolioLessons();
        }
      } 
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
.green,
.filterGreen {
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
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}

// /deep/.el-collapse-item__header, /deep/.el-collapse-item__wrap  {
//   border-bottom: none !important;
// }

// /deep/.el-card__body {
//     padding-bottom: 0 !important;
// }
// /deep/.el-collapse-item__header {
//   font-size: 2rem;
//   }

// /deep/.el-collapse-item__arrow, /deep/.el-icon-arrow-right {
//   display: none;
// }
.programName {
  font-variant: small-caps;
}
.giantNumber {
  font-size: 3.7rem;
}
.giantMapView {
  font-size: 3.25rem;
}
i,
.icons {
  cursor: pointer;
  -webkit-touch-callout: none;
  -webkit-user-select: none;
  -khtml-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}
ul {
  margin-bottom: 0.5rem;
}



.box-shadow {
  border-top: #ededed double 0.5px;
}

/deep/.el-table {
  padding-top: 0px;
  width: 100%;
  margin-bottom: 6px;

  border-top: solid #ededed 1.8px;
}
/deep/.el-table {
  th {
    background-color: #ededed !important;
    text-align: center;
    color: #383838;
  }
}

th {
  font-size: 0.8rem !important;
}
.programNoBadge {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
}
.tcard {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}
.mhLogo {
  position: fixed;
  bottom: 1%;
  right: 1.5%;
  z-index: 10;
}
.tagsCol {
  border-radius: 4px;
  background-color: #f8f9fa;
  border: 0.5px solid lightgray;
}

.statesCol {
  border-radius: 4px;
  border: 0.5px solid lightgray;
}
.fa-times-circle {
  font-size: 1.4rem;
  font-weight: 400;
  transition: all 0.2s ease-in;
  // box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
  //   0 3px 3px rgba(56, 56, 56, 0.23);
}
.fa-times-circle:hover {
  transform: scale(1.25);
}
.countBtn {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
  position: absolute;
  right: 1%;
}
.light {
  color: lightgray;
}
table {
  position: relative;
  margin-bottom: 0 !important;
}
.stickyTableHeader {
  position: sticky;
  position: -webkit-sticky;
  z-index: 10;
  justify-content: center;
  left: 15;
  top: 0;
}
.page-btns {
  width: 20px;
  line-height: 1 !important;
  border: none !important;
  height: 25px;
  margin-right: 1px;
  background-color: white;
  color: #383838;
  cursor: pointer;
}
.page-btns:hover {
  background-color: #ededed;
}
#page-count {
  width: auto !important;
  cursor: default;
}
.page-btns.active {
  background-color: rgba(211, 211, 211, 10%);
  border: none !important;
}

.ten {
  width: 10%;
}
//  .loaderRow {

//  }

.fifteen {
  width: 15%;
}

.twenty {
  width: 20%;
}
.btnRow {
  position: absolute;
  bottom: 45%; 
}
.sort-th {
  min-width: 190px;
}
.profile-btns {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
    0 3px 3px rgba(56, 56, 56, 0.23);
  cursor: default;
}

.el-select-dropdown__item {
  font-size: 14px;
  display: block !important;
  padding: 0 20px;
  position: relative;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  color: #606266;
  height: 34px;
  line-height: 34px;
  -webkit-box-sizing: border-box;
  box-sizing: border-box;
  cursor: pointer;
}

.red1 {
  background-color: #d9534f;
}

.yellow1 {
  background-color: yellow;
  color: #383838;
  display: block;
}

.orange1 {
  background-color: #f0ad4e;
}

.green1 {
  background-color: rgb(92, 184, 92);
}

.gray2 {
  background-color: #ededed;
}

.green1,
.orange1,
.red1,
.yellow1,
.gray2 {
  display: inline;
  border-radius: 2px;
  padding: 1px 1px;
  box-shadow: 0 1px 2.5px rgba(56, 56, 56, 0.19),
    0 1.5px 1.5px rgba(56, 56, 56, 0.23);
}
  .taskHover:hover {
    cursor: pointer;
    background-color: rgba(91, 192, 222, 0.3);
  }

.font-sm {
  font-weight: 600;
}
.green1,
.orange1,
.red1 {
  color: #fff;
}
/deep/.el-input__inner {
  height: 40px;
}
.truncate-line-two {
  display: -webkit-box;
  -webkit-line-clamp: 5;
  -webkit-box-orient: vertical;
  overflow: hidden;
  &:hover {
    display: -webkit-box;
    -webkit-line-clamp: unset;
  }
}
.invi {
  color: #fff;
}

/deep/.vue-treeselect__multi-value-item {
  background-color: #41b883;
  color: white;
}
/deep/.vue-treeselect__value-remove {
  color: rgba(56, 56, 56, 0.5);
}

/deep/.el-dialog {
  height: 100vh;
  width:100vw;
  padding: 20px;
  position: fixed;
  border-top: solid 15px #1D336F;
  border-bottom: solid 15px #1D336F;
  margin-top: 0 !important;
}
.dialog-footer {
  text-align: center;
  position: absolute;
  bottom: 15px;
  right: 35px;
}

.dialog-footer-left {
  text-align: center;
  position: absolute;
  bottom: 15px;
  left: 35px;
}

.slideCol {
  // position:absolute; 
  // top:50px; 
  border-radius:0.25rem;
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
  0 3px 3px rgba(56, 56, 56, 0.23);
}

.leftProgramCol {
  border: solid #DD9036 2px;
}
.elBtn {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
  0 3px 3px rgba(56, 56, 56, 0.23);
}

// .presentBtn {
//  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
//   0 3px 3px rgba(56, 56, 56, 0.23);
// }
.lastUpdateCol {
  // position:absolute;
  // right: 60px;
  // width: 60%;
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
  0 3px 3px rgba(56, 56, 56, 0.23);
  border: solid #9EC64C 2px;
  border-radius: 0.25rem; 
  }

.truncate-line-five
{
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;  
  overflow: hidden;
  &:hover
  {
    display: -webkit-box;
    -webkit-line-clamp: unset;
  }
}
.tagsBtn {
  border-radius: 0.25rem;
  border: solid 1.5px #1D336F;
}
.timeStamp {
  position: absolute;
  bottom: 0.5rem;
  right: 0.5rem;
}
/deep/.el-progress-circle {
  height: 90px;
  width: 90px;
}

.leftColLabel {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19),
  0 3px 3px rgba(56, 56, 56, 0.23);
  display: inline-block;
  padding: 0.25rem 1rem;
}

/deep/.el-progress__text {
  color:  #f8f9fa;
}
/deep/.el-dialog__headerbtn {
  margin-right: 1.5rem;
}

/deep/.vue-treeselect__placeholder {
  font-style: FuturaPTBook;
}

</style>