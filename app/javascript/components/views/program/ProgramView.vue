<template>
<div>
  <div class="backBtn">  
      <span class="float-right">
        <router-link :to="goBack">
        <button class="portfolioHomeBtn mh-orange btn btn-sm" style="cursor: pointer" @click="resetFlags">
          <i class="fal fa-arrow-alt-left text-light"></i>
        </button>
        </router-link>
      </span>
    </div>
  <div class="container-fluid mx-3 portfolioView_main" 
    v-loading="!contentLoaded"
    element-loading-text="Fetching Program Viewer data. Please wait..."
    :class="[!contentLoaded ? 'vh100': '']"
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)" 
  >     
  <el-tabs class="mt-1 mr-3" type="border-card">
    <el-tab-pane class="p-3"  style="postion:relative" >
        <template slot="label" class="text-right" v-if="contentLoaded">
              <span class="allCaps">{{ currentProject.name }} Data Viewer </span>
            
            </template>
               <el-dialog :visible.sync="dialogVisible" append-to-body center class="portfolioDialogMode">
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
                             <div class="col-5 text-center px-3 py-2" v-if="dynamicObj[currentTaskSlide]">
                              
                        
                              
                          <span v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].isOverdue" v-tooltip="`Overdue`">
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
                             v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].onHold == true"
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
                             v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].inProgress"
                            v-tooltip="`In Progress`"
                          >
                            <i class="far fa-tasks text-primary mr-1" style="font-size:1.8rem"></i
                          ></span>

                            <span v-if="dynamicObj[currentTaskSlide].text"> 
                              <h2 class="mt-2 d-inline text-truncate breakWord">{{ dynamicObj[currentTaskSlide].text }}</h2>
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
                                    <h4 v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].programName">{{dynamicObj[currentTaskSlide].programName}}</h4>
                                  </div>    
                              
                                  <div class="col truncate-line-two">    
                                       <h6 class="leftColLabel text-light mh-orange">PROJECT GROUP</h6>
                                   <h4 v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].projectGroup"> {{dynamicObj[currentTaskSlide].projectGroup}}  </h4>
                                                                 
                                  </div>  
                          
                                   <div class="col py-2">    
                                       <h6 class="leftColLabel text-light mh-orange">PROJECT</h6>
                                    <h4  v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].facilityName">{{ dynamicObj[currentTaskSlide].facilityName}}  </h4>                                                                 
                                  </div>  

                                     <div class="col">    
                                       <h6 class="leftColLabel mh-blue text-light">PROCESS AREA</h6>
                                    <h4 v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].taskType" >{{ dynamicObj[currentTaskSlide].taskType}}  </h4> 
                                    <h4 v-else> -- </h4>                                                                
                                  </div>  

                                </div>    
                               
                                                       
                                <div class="col-5 text-center  mx-4 p-0" v-if="dynamicObj[currentTaskSlide] !== undefined">
                                <div class="lastUpdateCol">                                
                                 <h3 class="mh-green text-light d-block">LAST UPDATE</h3>
                                 <div style="height:300px; overflow-y:auto">
                                 <span  v-if="dynamicObj[currentTaskSlide].notes.length > 0">                    
                                  <span>
                                    <br>
                                   <h4 class="px-3"> <em>{{ dynamicObj[currentTaskSlide].lastUpdate.body }}</em></h4>
                                  </span>
                                   <span
                                    class="px-2"                                                                 
                                   >
                                    <h6 class="mt-2">{{
                                      moment(dynamicObj[currentTaskSlide].lastUpdate.createdAt).format(
                                        "DD MMM YYYY, h:mm a "
                                      ) + ' By: ' +
                                     dynamicObj[currentTaskSlide].lastUpdate.user.fullName
                                    }} 
                                    </h6>
                                  </span>
                                   </span>
                                   <span v-else>
                                     <br>
                                      <h4 class="px-3" style="color:lightgray"><em>NO UPDATES</em></h4>
                                   </span>
                               </div>  
                                </div> 
                                                       
                                 <div class="issueTypes mt-3" v-if="dynamicObj == filteredTasks.filtered.tasks">

                                 <h6 class="bg-secondary text-light py-1 d-block">TASK DESCRIPTION</h6>
                                   <div style="height:100px; overflow-y:auto">
                                      <h4 class="px-3">{{ dynamicObj[currentTaskSlide].description }}</h4>
                                  </div>
                               </div>

                                </div>


                                    <div class="col-3 mh-blue text-center text-light slideCol"  v-if="dynamicObj[currentTaskSlide] !== undefined">                                          
                                        <div class="col pt-2">  
                                     <i class="fas fa-calendar text-light d-block pb-1" style="font-size:2.8rem"></i>
                                    <span v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].startDate" class="d-inline-block"> <h5>{{ moment(dynamicObj[currentTaskSlide].startDate).format( "DD MMM YYYY") }}</h5></span> 
                                    <span v-else> -- </span>
                                    - 
                                     <span v-if="dynamicObj[currentTaskSlide] && dynamicObj[currentTaskSlide].dueDate" class="d-inline-block"> <h5> {{ moment(dynamicObj[currentTaskSlide].dueDate).format("DD MMM YYYY") }}</h5></span>
                                     <span v-else>  </span>
                                    
                                  </div>    
                                                
                                   <div class="col mt-3 truncate-line-two">
                                   <i class="fas fa-users d-block text-light" style="font-size:2.8rem"></i>
                                          <span class="truncate-line-two" v-if="dynamicObj[currentTaskSlide].users.length > 0"><h4> {{ dynamicObj[currentTaskSlide].userNames }}</h4></span>
                                          <span v-else> <h4>No Assignments</h4></span>                                        
                                  </div>  
             
                                   <div class="col" v-if="!dynamicObj[currentTaskSlide].ongoing" >                               
                                                               
                                    <span :class="{ 'text-light': dynamicObj[currentTaskSlide].progress <= 0 }">
                                    <el-progress
                                      type="circle"
                                      class="py-2 text-light"                          
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
                            <el-button class="elBtn tagsBtn py-1 text-light mr-2" > <h5 class="d-inline px-2 text-dark">FOCUS FLAGS: </h5>
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
             <div class="row pb-4" v-if="currentProject && currentProject.contracts || contentLoaded" >
              <div class="col-3 py-2" :class="{'d-none': !_isallowed('read') || currentProject.contracts.length <= 0 }">
                <div class="w-100">
                <div class="d font-sm mt-2 mr-2" style="visibility:hidden">SEARCH</div>
                <el-button-group >
                  <el-button :class="[ !getShowProjectStats ? 'lightBtn' : 'inactive']" @click.prevent="showProjectStats">  
                    <i class="fal fa-clipboard-list mr-1" :class="[ getShowProjectStats ? 'inactive' : 'mh-green-text']"></i>
                    PROJECTS
                    <!-- <span 
                      v-if="currentProject && currentProject.facilities"
                      class="ml-1 badge badge-secondary badge-pill pill"
                      >{{ currentProject.facilities.length }}
                      </span> -->
                  </el-button>
                  <el-button :class="[ getShowProjectStats ? 'lightBtn' : 'inactive']" @click.prevent="showContractStats"> 
                    <i class="far fa-file-contract mr-1" :class="[ getShowProjectStats == false ? 'inactive' : 'mh-orange-text']"></i>
                    CONTRACTS
                    <!-- <span 
                      v-if="currentProject && currentProject.contracts"
                      class="ml-1 badge badge-secondary badge-pill pill"
                      >{{ currentProject.contracts.length }}
                      </span> -->
                  </el-button>
                </el-button-group>                
                </div>
              </div>
              <div class="col-3 py-2">
              <div class="w-100">
                          <div class="d font-sm mt-2 mr-2">SEARCH</div>
                          <div class="w-100"  v-if="currentTab == '#tab-tasks'">
                          <el-input
                            type="search"
                            placeholder="Enter Tasks Search Criteria"
                            v-model="search_tasks"
                          >
                            <el-button slot="prepend" icon="el-icon-search"></el-button>
                          </el-input>
                          </div>
                          <div class="w-100" v-if="currentTab == '#tab-issues'">
                          <el-input
                            type="search"
                            placeholder="Enter Issues Search Criteria"
                            v-model="issuesQuery"
                          >
                            <el-button slot="prepend" icon="el-icon-search"></el-button>
                          </el-input>
                          </div>
                        <div class="w-100" v-if="currentTab == '#tab-risks'">
                          <el-input
                            type="search"
                            placeholder="Enter Risks Search Criteria"
                            v-model="risksQuery"
                          >
                            <el-button slot="prepend" icon="el-icon-search"></el-button>
                          </el-input>
                          </div>
                          <div class="w-100" v-if="currentTab == '#tab-lessons'">
                          <el-input
                            type="search"
                            placeholder="Enter Lessons Search Criteria"
                            v-model="lessonsQuery"
                          >
                            <el-button slot="prepend" icon="el-icon-search"></el-button>
                          </el-input>
                          </div>


              </div>

              </div>
              <div class="col-3 py-2">
                <div class="w-100">          
                  <div class="font-sm px-0 mt-2 mr-2">PROGRAM<span class="invi">i</span>FILTER</div>           
                   <template>
                       <!-- <treeselect  
                    placeholder="Search and select" 
                    
                    valueFormat="object"
                    />       -->
                    <treeselect  
                    placeholder="Search and select" 
                    :multiple="true"                 
                    :options="programProjectGroups"                
                    :value="C_projectGroupsFilter" 
                    v-model="C_projectGroupsFilter"            
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
              <div class="col-3 pl-0 py-2">
                <div class="w-100 pr-3">
                  <div class="font-sm mr-2 mt-2">PROCESS AREA</div>
                  <template>
                    <el-select
                      v-model="C_programCategoryFilter"
                      class="w-100"
                      track-by="name"
                      value-key="id"
                      multiple
                      clearable
                      placeholder="Select Process Area"
                    >
                        <el-option
                        v-for="item in taskTypes"
                        :value="item"
                        :key="item.id"
                        :label="item.name"
                      >
                      <!-- <el-option
                        v-for="item in C_categories"
                        :value="item"
                        :key="item"
                        :label="item"
                      > -->
                      </el-option>
                    </el-select>
                  </template>
                </div>
              </div>
            </div>
      <el-tabs class="mt-1 mr-3" type="border-card" @tab-click="handleClick">
        <el-tab-pane class="pt-2" style="postion:relative" name="tasks"               
           >
             <template
                slot="label"
                class="text-right"      
                v-if="true"  
             >
                TASKS
                <span class="badge badge-secondary badge-pill">
                 <span v-if="!getShowProjectStats">{{ filteredAllTasks.length }}</span>
                 <span v-else>{{ filteredAllContractTasks.length }}</span>
                </span>
            </template>

               <div class="box-shadow py-2"  style="postion:relative"  >
              <div class="row py-1 pr-2">
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
                        :class="[getHideComplete == true ? 'light' : '']"
                        @click.prevent="toggleComplete"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-clipboard-check"
                            :class="[
                              getHideComplete == true ? 'light' : 'text-success',
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
                        :class="[getHideInprogress == true ? 'light' : '']"
                        @click.prevent="toggleInprogress"
                      >
                        <span class="d-block">
                          <i
                            class="far fa-tasks"
                            :class="[
                              getHideInprogress == true ? 'light' : 'text-primary',
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
                        :class="[getHideOverdue == true ? 'light' : '']"
                        @click.prevent="toggleOverdue"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-calendar"
                            :class="[
                              getHideOverdue == true ? 'light' : 'text-danger',
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
                        :class="[getHideOngoing == true ? 'light' : '']"
                        @click.prevent="toggleOngoing"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-retweet"
                            :class="[
                             getHideOngoing == true ? 'light' : 'text-success',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">ONGOING </span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          <span v-if="filteredTasks.filtered.tasks">{{
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
                        :class="[getHidePlanned == true ? 'light' : '']"
                        @click.prevent="togglePlanned"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-calendar-check"
                            :class="[
                              getHidePlanned == true ? 'light' : 'text-info',
                            ]"
                          ></i>
                        </span>
                        <span class="smallerFont">PLANNED</span>
                        <h5
                          :class="[
                            getShowCount == false ? 'd-none' : 'd-block',
                          ]"
                        >
                          <span v-if="filteredTasks.filtered.tasks">{{
                            taskVariation.planned.count
                          }}</span>
                        </h5>
                      </div>

                      <div
                        class="pr-4 text-center icons"
                        :class="[getHideOnhold  == true ? 'light' : '']"
                        @click.prevent="toggleOnhold"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-pause-circle"
                            :class="[
                              getHideOnhold  == true ? 'light' : 'text-primary',
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
                        :class="[getHideDraft == true ? 'light' : '']"
                        @click.prevent="toggleDraft"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-pencil-alt"
                            :class="[
                              getHideDraft == true ? 'light' : 'text-warning',
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
                      ><label class="font-sm mt-4 pr-2"><b>FOCUS</b></label>
                    </span>
                    <span class="tagsCol d-flex px-3 py-2">
                      <div
                        class="text-center icons"
                        :class="[getHideWatched == true ? '' : 'light']"
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
                        :class="[getHideImportant == true ? '' : 'light']"
                        @click.prevent="toggleImportant"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-star"
                            :class="[
                              getHideImportant == true ? 'text-warning' : 'light',
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
                        :class="[getHideBriefed == true ? '' : 'light']"
                        @click.prevent="toggleBriefed"
                      >
                        <span class="d-block">
                          <i
                            class="fas fa-presentation"
                            :class="[
                              getHideBriefed == true ? 'text-primary' : 'light',
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
                  <v-checkbox     
                  v-model="C_showCountToggle"     
                  class="d-inline-block portfolio"  
                  @click.prevent="showCounts"   
                  :label="`Show Counts`"
                ></v-checkbox>
                  </template>
                </div>

                <div class="col-2 pl-0 pr-2">
                  <span class="btnRow d-flex">
                     <button
                      v-tooltip="`Presentation Mode`"
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
                      class="btn btn-md mx-1 exportBtns text-light"
                    >
                      <i class="far fa-file-excel"></i>
                    </button>
                    <button
                      class="btn text-light btn-md mh-orange px-1 profile-btns portfolioResultsBtn"
                    >
                      RESULTS: {{ filteredTasks.filtered.tasks.length }}
                    </button></span
                  >
                </div>
              </div>
              <!-- <ProjectContractSwitch /> -->
              <div
                class="row mt-3 pr-3"
                style="postion:relative" 
                v-if="filteredTasks.filtered.tasks.length > 0"
              >
               
                <div class="px-3 tableFixHead" >
                  <table
                    class="table table-sm table-bordered"
                    ref="table"
                    id="portTasks"                   
                  >
                    <thead style="background-color: #ededed">    
                        <th class="pl-1 sort-th twenty" @click="sortCol1('projectGroup')">
                        Group
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSortCol1 !== 'projectGroup'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon main scroll"
                          v-if="
                            currentSortDir1 === 'asc' && currentSortCol1 === 'projectGroup'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir1 !== 'asc' && currentSortCol1 === 'projectGroup'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon main scroll"
                          v-if="
                            currentSortDir1 === 'desc' && currentSortCol1 === 'projectGroup'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir1 !== 'desc' && currentSortCol1 === 'projectGroup'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th> 
                       <th v-if="!getShowProjectStats" class="pl-1 sort-th twenty" @click="sortCol2('facilityName')">
                        Project Name 
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSortCol2 !== 'facilityName'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon main scroll"
                          v-if="
                            currentSortDir2 === 'asc' && currentSortCol2 === 'facilityName'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir2 !== 'asc' && currentSortCol2 === 'facilityName'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon main scroll"
                          v-if="
                            currentSortDir2 === 'desc' && currentSortCol2 === 'facilityName'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir2 !== 'desc' && currentSortCol2 === 'facilityName'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>  
                         <th v-if="getShowProjectStats" class="pl-1 sort-th twenty" @click="sortCol2('contractNickname')">
                        Contract Name 
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSortCol2 !== 'contractNickname'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon main scroll"
                          v-if="
                            currentSortDir2 === 'asc' && currentSortCol2 === 'contractNickname'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir2 !== 'asc' && currentSortCol2 === 'contractNickname'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon main scroll"
                          v-if="
                            currentSortDir2 === 'desc' && currentSortCol2 === 'contractNickname'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir2 !== 'desc' && currentSortCol2 === 'contractNickname'
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
                        @click="sort('notesUpdatedAt')"
                        style="min-width: 300px"
                      >
                        Last Update
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'notesUpdatedAt'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'notesUpdatedAt'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'notesUpdatedAt'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'notesUpdatedAt'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'notesUpdatedAt'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>

                      <th
                        class="sort-th"
                        style="min-width: 140px"
                        @click="sort('startDate')"
                      >
                        Start Date
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'startDate'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'startDate'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'startDate'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'startDate'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'startDate'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                      <th
                        class="sort-th"
                        style="min-width: 140px"
                        @click="sort('dueDate')"
                      >
                        Due Date
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'dueDate'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'dueDate'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'dueDate'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'dueDate'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'dueDate'
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
                      <th class="pl-1 sort-th twenty" @click="sort('taskType')">
                        Process Area
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="currentSort !== 'taskType'"
                        >
                          <i class="fas fa-sort"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'asc' &&
                            currentSort === 'taskType'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'asc' &&
                            currentSort === 'taskType'
                          "
                        >
                          <i class="fas fa-sort-up"></i
                        ></span>
                        <span
                          class="sort-icon scroll"
                          v-if="
                            currentSortDir === 'desc' &&
                            currentSort === 'taskType'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                        <span
                          class="inactive-sort-icon scroll"
                          v-if="
                            currentSortDir !== 'desc' &&
                            currentSort === 'taskType'
                          "
                        >
                          <i class="fas fa-sort-down"></i
                        ></span>
                      </th>
                    </thead>
                    <tbody>
                      <tr v-for="(task, index) in sortedTasks" :key="index" class="portTable taskHover" @click="openTask(task)">
                   
                   
                        <td>{{ task.projectGroup }}</td>
                        <td>{{ task.facilityName || task.contractNickname }}</td>
                        <td>{{ task.text }}</td>
                        <td
                          v-if="task.notes.length > 0"
                        >
                          <span
                            class="toolTip"
                            v-tooltip="
                              'By: ' +
                              task.lastUpdate.user.fullName
                            "
                          >
                            {{
                              moment(task.lastUpdate.createdAt).format(
                                "DD MMM YYYY, h:mm a"
                              )
                            }}
                          </span>
                          <br />
                          <span class="truncate-line-five">
                            {{ task.lastUpdate.body }}
                          </span>
                        </td>
                        <!-- <td v-else class="twentyTwo">No Updates</td> -->
                        <td v-else>No Update</td>

                        <td class="text-center">
                         <span v-if="task.ongoing && !task.closed && task.startDate == null || undefined">
                           <i class="fas fa-retweet text-success"></i>
                         </span>
                          <span v-else-if="task.ongoing && task.closed && task.startDate == null || undefined">
                           <i class="fas fa-retweet text-secondary"></i>
                             </span>
                         <span v-else>{{
                           moment(task.startDate).format("DD MMM YYYY") 
                          }}</span>
                        </td>
                        <td class="text-center">
                          <span v-if="task.ongoing && !task.closed" v-tooltip="`Ongoing`"
                            ><i class="fas fa-retweet text-success"></i
                          ></span>
                          <span v-else-if="task.completed && (task.dueDate == null || task.dueDate == undefined)"></span>
                          <span
                            v-else-if="task.onHold && task.dueDate == null"
                            v-tooltip="`On Hold (w/no Due Date)`"
                            ><i class="fas fa-pause-circle text-primary"></i
                          ></span>
                          <span v-else>{{
                            moment(task.dueDate).format("DD MMM YYYY")
                          }}</span>
                        </td>
                        <td>{{ task.userNames }}</td>
                        <td class="text-center">                          
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
                          <span v-if="task.isOverdue" v-tooltip="`Overdue`">
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
                            v-if="task.onHold == true"
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
                            v-if="task.inProgress"
                            v-tooltip="`In Progress`"
                          >
                            <i class="far fa-tasks text-primary mr-1"></i
                          ></span>

                        </td>
                        <td>{{ task.taskType }}</td>
                      </tr>
                    </tbody>
                  </table>
        <table
          class="table table-bordered w-100"
          id="portTasks1"
          style="display:none"        
        >
         <thead>      
        <tr style="background-color:#ededed">
          <th>Task</th>
          <th>Process Area</th>
          <th>Project</th>
          <th>Start Date</th>
          <th>Due Date</th>
          <th>Assigned Users</th>
          <th>Progress</th>        
          <th>Flags</th>
          <th>Last Update</th>
        </tr>
          <tr></tr>
      </thead>
      <tbody v-for="(p, i) in validTaskProjectGroups" :key="i">  
        <tr id="program">  <th scope="row"><b>{{ p }}</b></th></tr>
           <tr v-for="(task, index) in filteredTasks.filtered.tasks" :key="index" v-if="task.projectGroup == p">            
              <td>{{ task.text }}</td>
              <td>{{ task.taskType }}</td>
              <td> {{ task.facilityName}} </td>
                <td>
                <span v-if="task.ongoing && !task.closed && task.startDate == null || undefined">
                  <i class="fas fa-retweet text-success"></i>
                </span>
                <span v-else-if="task.ongoing && task.closed && task.startDate == null || undefined">
                  <i class="fas fa-retweet text-secondary"></i>
                    </span>
                <span v-else>{{
                  moment(task.startDate).format("DD MMM YYYY") 
                }}</span>
              </td>
                  <td>
                <span v-if="task.ongoing && !task.closed" v-tooltip="`Ongoing`"
                  ><i class="fas fa-retweet text-success"></i
                ></span>
                 <span v-else-if="task.completed && (task.dueDate == null || task.dueDate == undefined)"></span>
                <span
                  v-else-if="task.onHold && task.dueDate == null"
                  v-tooltip="`On Hold (w/no Due Date)`"
                  ><i class="fas fa-pause-circle text-primary"></i
                ></span>
                
                <span v-else>{{
                  moment(task.dueDate).format("DD MMM YYYY")
                }}</span>
              </td>
                  <td>{{ task.userNames }}</td>

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
                <span v-if="task.isOverdue" v-tooltip="`Overdue`">
                 Overdue
                 </span>
                <span v-if="task.completed" v-tooltip="`Completed`"
                  >
                  Completed
                  </span>
                <span
                  v-if="task.ongoing == true && !task.closed"
                  v-tooltip="`Ongoing`"
                  >Ongoing</span>
                <span
                  v-if="task.closed"
                  v-tooltip="`Ongoing: Closed`"
                  >Ongoing</span>
                <span
                  v-if="task.onHold == true"
                  v-tooltip="`On Hold`"
                >
                 On Hold
                 </span>
                <span v-if="task.draft == true" v-tooltip="`Draft`">
                   Draft
                 </span>          
               
                <span v-if="task.planned" v-tooltip="`Planned`">
                 Planned
                 </span>
                <span
                  v-if="task.inProgress"
                  v-tooltip="`In Progress`"
                >
                In Progress
                 </span>
              </td>
              <td v-if="task.notes.length > 0">       
          <span  class="toolTip" v-tooltip="('By: ' + task.lastUpdate.user.fullName)" > 
          {{ moment(task.lastUpdate.createdAt).format('DD MMM YYYY, h:mm a')}} <br>         
          </span> 
          <span>
            {{task.lastUpdate.body}}
          </span>         
        </td>  
         <td v-else >No Updates</td>      
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
                        v-for="item in getTasksPerPageOptions"
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
                      filteredTasks.filtered.tasks.length / this.C_tasksPerPage.value
                      )
                    }}
                  </button>
                  <button class="btn btn-sm page-btns" @click="nextPage">
                    <i class="fas fa-angle-right"></i>
                  </button>
                </div>
              </div>
              <!-- <div v-else-if="!portfolioTasksLoaded" class="load-spinner spinner-border"></div> -->
              <div v-else class="mt-5">NO RESULTS TO DISPLAY
 
                  
              </div>
            </div>

        </el-tab-pane>

        <el-tab-pane class="pt-2"  name="issues"             
          >
            <template slot="label" class="text-right">
              ISSUES
              <span class="badge badge-secondary badge-pill">
                 <span v-if="!getShowProjectStats">{{ filteredAllIssues.length }}</span>
                 <span v-else>{{ filteredAllContractIssues.length }}</span>
              </span>
            </template>
            <ProgramIssues />
         </el-tab-pane>

        <el-tab-pane class="pt-2" name="risks"          
           
          >
            <template
              slot="label"
              class="text-right"             
            >
              RISKS
              <span class="badge badge-secondary badge-pill">
                 <span v-if="!getShowProjectStats">{{ filteredAllRisks.length }}</span>
                 <span v-else>{{ filteredAllContractRisks.length }}</span>
               </span>
            </template>
            <ProgramRisks />
         </el-tab-pane>

        <el-tab-pane class="pt-2"  name="lessons"          
          >
            <template slot="label" class="text-right">
              LESSONS LEARNED
              <span class="badge badge-secondary badge-pill">
                {{  programLessonsCount.total_count  }}
              </span>
            </template>
            <ProgramLessons />

         </el-tab-pane>

      </el-tabs>
    </el-tab-pane>
  </el-tabs>
   
  <!-- {{currentProject}} -->
  </div>
</div>
</template>

<script>

import {mapGetters, mapMutations, mapActions} from 'vuex'
import ProgramIssues from "./ProgramIssues.vue";
import ProgramRisks from "./ProgramRisks.vue";
import ProgramTaskForm from "./ProgramTaskForm.vue";
import ProgramLessons from "./ProgramLessons.vue";
// import ProjectContractSwitch from "./ProjectContractSwitch.vue"
import { jsPDF } from "jspdf";
import "jspdf-autotable";
Vue.component('treeselect', VueTreeselect.Treeselect)

export default {
  name: "ProgramView",
   components: {
    ProgramIssues,
    ProgramRisks,
    ProgramLessons,
    // ProjectContractSwitch
  },
  data() {
    return {
      showLess: "Show More",
      showMore: true,
      today: new Date().toISOString().slice(0, 10),
      currentSort: "text",
      dialogVisible: false,
      currentTaskSlide : 0, 
      dynamicObj: {},
      action: '', 
      search_tasks: '',
      currentSortCol1: "projectGroup",
      currentSortCol2: "facilityName",
      // currentSortIssueRisk: "title",
      currentSortDir: "asc",
      currentSortDir1: "asc",
      currentSortDir2: "asc",
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
  computed: {
    ...mapGetters([
    "contentLoaded",
    "currentProject",
    'programCategoriesFilter',
    'currTaskPage',
    'getShowProjectStats',
    'searchIssues',
    'searchRisks',
    'searchLessons',
    'currProgramTab',
    'portfolioCategoriesFilter',
    'portfolioPrograms',
    "lessonsLoaded",
    "projectLessons",
    "programLessonsCount",
    'projects',
    "facilities",
    "facilityCount",
    "facilityGroupFacilities",
    "facilityProgress",
    "filterDataForAdvancedFilter",
    "filteredAllIssues",
    "filteredAllRisks",
    "filteredAllTasks",
    "filteredAllContractTasks",
    "filteredAllContractRisks",
    "filteredAllContractIssues",
    "filteredFacilities",
    "filteredFacilityGroups",
    "getAllFilterNames",
    "getFilterValue",
    "getTaskIssueUserFilter",
    'getTasksPerPage',
    'getTasksPerPageOptions',
    "getUnfilteredFacilities",
    "issueSeverityFilter",
    "issueStageFilter",
    "issueTypeFilter",
    "issueTypes",
    "issueUserFilter",
    "myActionsFilter",
    "onWatchFilter",
    "riskStageFilter",
    "statuses",
    "taskStageFilter",
    "taskTypeFilter",
    "taskTypes",
    "taskUserFilter",
    'getShowAdvancedFilter',
    'projectGroupsFilter',
    'getShowCount',
    'getIssuesPerPageFilterOptions',
    // 7 States
    'getHideComplete',
    'getHideInprogress',
    'getHidePlanned',
    'getHideOngoing',
    'getHideOnhold',
    'getHideDraft',
    'getHideOverdue',
    // 3 Tags
    'getHideWatched',
    'getHideImportant',
    'getHideBriefed',
    ]),
    goBack() {
      var backRoute = localStorage.getItem('backRoute');
      localStorage.getItem('backRoute');
      if (backRoute) {
        return `/programs/${this.$route.params.programId}/` + backRoute;
      } else {
        return `/programs/${this.$route.params.programId}/sheet`;
      }
    },
   projectObj() {
    return this.currentProject.facilities
    },
    C_projectGroupsFilter: {
      get() {
        return this.projectGroupsFilter;
      },
      set(value) {
        this.setProjectGroupsFilter(value);
        this.setProjectGroupIds()
      },
    },
    programProjectGroups(){
      if (this.portfolioPrograms){
      let pp = this.portfolioPrograms
      return pp.filter(p => p.program_id == this.$route.params.programId)
      }     
    },
    issuesQuery:{
      get(){
        return this.searchIssues
      },
      set(value){
        // console.log(value)
        this.setSearchIssues(value)
      }
    },
    risksQuery:{
      get(){
        return this.searchRisks
      },
      set(value){
        // console.log(value)
        this.setSearchRisks(value)
      }
    },
    lessonsQuery:{
      get(){
        return this.searchLessons
      },
      set(value){
        // console.log(value)
        this.setSearchLessons(value)
      }
    },
     currentTab: {
      get() {        
        return this.currProgramTab
      },
      set(value) {
        // console.log(value)
        if(value === '#tab-issues') {
            this.setCurrProgramTab('#tab-issues')
        } else if (value === '#tab-risks') {
            this.setCurrProgramTab('#tab-risks')
        } else if (value === '#tab-lessons') {
            this.setCurrProgramTab('#tab-lessons')
        } else 
          this.setCurrProgramTab('#tab-tasks')
          // this.setPortfolioTab(value)
      }
  },
    C_showCountToggle: {                  
        get() {
         return this.getShowCount                
        },
        set(value) {
          this.setShowCount(value) ||  this.setShowCount(!this.getShowCount)
        }
        
      },
    C_programCategoryFilter: {
      get() {
        return this.programCategoriesFilter;
      },
      set(value) {
        // console.log(value)
        this.setProgramCategoriesFilter(value);
      },
    },
    C_categories() {
    let categories = this.filteredAllTasks  
      return _.uniq(categories.map(c => c.taskType))
    },
    validTaskProjectGroups(){
      let name = this.sortedTasks;
      return _.uniq(name.map(item => item.projectGroup))      
    },
    C_myTasks: {
      get() {
        return _.map(this.myActionsFilter, "value").includes("tasks");
      },
    },
    C_myIssues: {
      get() {
        return _.map(this.myActionsFilter, "value").includes("issues");
      },
    },
    C_onWatchTasks: {
      get() {
        return _.map(this.onWatchFilter, "value").includes("tasks");
      },
    },
    C_onWatchIssues: {
      get() {
        return _.map(this.onWatchFilter, "value").includes("issues");
      },
    },

   C_tasksPerPage: {
      get() {
        return this.getTasksPerPage || {id: 15, name: '15', value: 15}
      },
      set(value) {
        this.setTasksPerPageFilter(value)
       }
     },
   currentPage:{
       get() {
        return this.currTaskPage
      },
      set(value) {
        this.setCurrTaskPage(value);
      },
    },
    C_facilityCount() {         
      return this.facilityGroup
      
        ? this.facilityGroupFacilities(this.facilityGroup).projects.a.length
        : this.facilityCount; 
      
    },
   projectContractToggle:{     
     get(){
       return this.getShowProjectStats
     },
     set(e){
       if(this.getShowProjectStats == false){
        // console.log(this.getShowProjectStats)
        this.setShowProjectStats(!this.getShowProjectStats)
          // console.log(this.getShowProjectStats)
      } else if(this.getShowProjectStats == true){
        this.setShowProjectStats(!this.getShowProjectStats)
     } else return
     console.log(e)

     }
    },
    C_facilityProgress() {
      return this.facilityGroup
        ? Number(
            _.meanBy(
                this.facilityGroupFacilities(this.facilityGroup).projects.a,
              "progress"
            ) || 0
          ).toFixed(0)
        : this.facilityProgress;
    },
    isMapView() {
      return this.$route.name.includes("Map");
    },
    isSheetsView() {
      return this.$route.name.includes("Sheet");
    },
    ProgramView() {
     return `/programs/${this.$route.params.programId}/dataviewer`
    },
    filteredTasks() {
     let allTasks = this.filteredAllTasks
     if (this.getShowProjectStats){
       allTasks = this.filteredAllContractTasks
     }
     let tasks = allTasks.filter(t => {
          if (this.facility_project_ids.length > 0) {                
            return this.facility_project_ids.includes(t.facilityProjectId) 
          } else return true
          }).filter((task) => {
          if (this.search_tasks !== '' && task && task.text) {
            console.log(task)
            return (            
              task.text.toLowerCase().match(this.search_tasks.toLowerCase()) ||       
              task.taskType
                .toLowerCase()
                .match(this.search_tasks.toLowerCase()) ||
              task.projectGroup
                .toLowerCase()
                .match(this.search_tasks.toLowerCase()) ||
              // task.facilityName
              //   .toLowerCase()
              //   .match(this.search_tasks.toLowerCase()) ||
              //  task.contractNickname
              //   .toLowerCase()
              //   .match(this.search_tasks.toLowerCase()) ||
              task.userNames.toLowerCase().match(this.search_tasks.toLowerCase())
            );
          } else return true;
          // Filtering 7 Task States
        })
        .filter((task) => {
          if (this.C_programCategoryFilter && this.C_programCategoryFilter.length > 0) {
            let category = this.C_programCategoryFilter.map((t) => t.id);
            return category.includes(task.taskTypeId);
          } else return true;
        })
  return {

       unfiltered: {
            tasks
            },
       filtered: {
         tasks:  tasks.filter(t => {
      if (this.getHideOverdue == true) {          
         return t.isOverdue == false
       } else return true  
      }).filter(t => {
      if (this.getHideComplete == true) { 
        return !t.completed
      } else return true
   

      }).filter(t => {
      if (this.getHidePlanned == true) { 
        return t.planned == false
      } else return true

      }).filter(t => {
      if (this.getHideOnhold == true) { 
        return t.onHold == false
      } else return true

      }).filter(t => {
      if (this.getHideInprogress == true) { 
        return t.inProgress == false
      } else return true

      }).filter(t => {
       if (this.getHideDraft == true){
         return t.draft == false
       } else return true   


      }).filter(t => {
      if (this.getHideOngoing == true) {
        return t.ongoing == false
      } else return true       

      }).filter(t => {
        if (this.getHideBriefed && !this.getHideWatched && !this.getHideImportant ) {
        return t.reportable
      }
      if (this.getHideBriefed && this.getHideWatched && !this.getHideImportant) {          
          return t.reportable + t.watched

      } if (this.getHideBriefed && this.getHideWatched && this.getHideImportant) {          
          return t.reportable + t.watched + t.important
      } else return true

      }).filter(t => {
        // This and last 2 filters are for Filtered Tags
         if (this.getHideWatched && !this.getHideBriefed && !this.getHideImportant) {
           return t.watched
        } if (this.getHideWatched && !this.getHideBriefed && this.getHideImportant) {
           return t.watched + t.important
        } if (this.getHideWatched && this.getHideBriefed && !this.getHideImportant) {          
           return  t.watched + t.reportable
        } if (this.getHideWatched && this.getHideBriefed && this.getHideImportant) {          
           return  t.watched + t.reportable + t.important
        } else return true          
       
      }).filter(t => {
         if (this.getHideImportant && !this.getHideBriefed && !this.getHideWatched) {
          return t.important
        } if (this.getHideImportant && this.getHideBriefed && !this.getHideWatched) {
          return t.important + t.reportable
       } if (this.getHideImportant && this.getHideBriefed && this.getHideWatched) {
          return t.important + t.reportable + t.watched
        } else return true           
       }),  
        }
       }   
          
    },
      sortedTasks:function() {
        return this.filteredTasks.filtered.tasks.sort((a,b) => {
        let modifier = 1;
        if (this.currentSortDir1 === "desc") modifier = -1;
        if (a[this.currentSortCol1] < b[this.currentSortCol1]) return -1 * modifier;
        if (a[this.currentSortCol1] > b[this.currentSortCol1]) return 1 * modifier;
        
        if (this.currentSortDir2 === "desc") modifier = -1;
        if (a[this.currentSortCol2] < b[this.currentSortCol2]) return -1 * modifier;
        if (a[this.currentSortCol2] > b[this.currentSortCol2]) return 1 * modifier;

        if (this.currentSortDir === "desc") modifier = -1;
        if (typeof a[this.currentSort] === "string" && typeof b[this.currentSort] === "string" ) {
                if (typeof a[this.currentSort] === "string" || typeof b[this.currentSort] === "string" ) {
                if (a[this.currentSort].toLowerCase() < b[this.currentSort].toLowerCase()) return -1 * modifier;
            if (a[this.currentSort].toLowerCase() > b[this.currentSort].toLowerCase()) return 1 * modifier;
                }
            } else 
        if (a[this.currentSort] < b[this.currentSort]) return -1 * modifier;
        if (a[this.currentSort] > b[this.currentSort]) return 1 * modifier;        
        return 0;

           }).filter((row, index) => {
          let start = (this.currentPage-1)*this.C_tasksPerPage.value;
          let end = this.currentPage*this.C_tasksPerPage.value;
          if(index >= start && index < end) return true;
          return this.end
        });
    },

    taskVariation() {
    let planned = _.filter(
        this.filteredTasks.unfiltered.tasks,
        (t) => t && t.planned == true
        // (t) => t && t.startDate && t.startDate > this.today 
    );     
    let taskDrafts = _.filter(
        this.filteredTasks.unfiltered.tasks,
        (t) => t && t.draft == true
    );      
    let completed = _.filter(
        this.filteredTasks.unfiltered.tasks,
        (t) => t && t.completed == true
    );
    let completed_percent = this.getAverage(
        completed.length,
        this.filteredTasks.unfiltered.tasks.length
    );
    let inProgress = _.filter(
        this.filteredTasks.unfiltered.tasks,
        (t) => t && t.inProgress == true
    );
    let onHoldT = _.filter(
        this.filteredTasks.unfiltered.tasks,
        (t) => t && t.onHold == true
    );
    let important = _.filter(
    this.filteredTasks.unfiltered.tasks,
        (t) => t && t.important
    );
    let briefings = _.filter(
    this.filteredTasks.unfiltered.tasks,
        (t) => t && t.reportable
    ); 
    let watched = _.filter(
    this.filteredTasks.unfiltered.tasks,
        (t) => t && t.watched 
    );             
    let inProgress_percent = this.getAverage(
        inProgress.length,
        this.filteredTasks.unfiltered.tasks.length
    );
    let overdue = _.filter(this.filteredTasks.unfiltered.tasks, (t) => t && t.isOverdue);
    let overdue_percent = this.getAverage(
    overdue.length,
    this.filteredTasks.unfiltered.tasks.length
    );
    let ongoing = _.filter(this.filteredTasks.unfiltered.tasks, (t) => t && t.ongoing );
    let ongoingClosed = _.filter(this.filteredTasks.unfiltered.tasks, (t) => t && t.closed );
      return {
        planned: {
          count: planned.length, 
          plannedTs: planned            
        },
        onHoldT: {
          count: onHoldT.length,          
        },
        taskDrafts: {
          count: taskDrafts.length,          
        },
       watched: {
          count: watched.length,          
        },
       important: {
          count: important.length,             
        },
        completed: {
          count: completed.length,
          percentage: Math.round(completed_percent),
        },
        briefings: {
          count: briefings.length,          
        },
      
        inProgress: {
          count: inProgress.length,
          percentage: Math.round(inProgress_percent),
        },
        overdue: {
          count: overdue.length,
          percentage: Math.round(overdue_percent),
        },
        ongoingClosed: {
          count: ongoingClosed.length      
        },
        ongoing:  {
          count: ongoing.length      
        },   
      };
    },
  
  },
  methods: {
      ...mapActions([
     'fetchProgramLessonCounts',
     'fetchPortfolioPrograms'
     ]), 
    ...mapMutations([
        'setAdvancedFilter',
        'setTaskIssueProgressStatusFilter',
        'setTaskIssueOverdueFilter',
        'setTaskTypeFilter',
        'setShowProjectStats',
        'setSearchIssues',
        'setSearchRisks',
        'setSearchLessons',
        'setProjectGroupsFilter',
        'setProgramCategoriesFilter',
        'setMyActionsFilter',
        'setCurrTab',
        'setPortfolioTab',
        'setCurrProgramTab',
        'setCurrTaskPage',
        'setOnWatchFilter',
        'setPortfolioCategoriesFilter',
        'setToggleRACI',
        'setShowAdvancedFilter',
        'setTaskForManager',
        'setShowCount',
        // Used in Program Viewer
        'setTasksPerPageFilter',
        // 7 States
        'setHideComplete',
        'setHideInprogress',
        'setHidePlanned',
        'setHideOverdue',
        'setHideOngoing',
        'setHideOnhold',
         'setHideDraft',
        // 3 Tags
        'setHideWatched',
        'setHideImportant',
        'setHideBriefed',
      ]),
     _isallowed(salut) {
      let pPrivilege = this.$programPrivileges[this.$route.params.programId]        
      let permissionHash = {"write": "W", "read": "R", "delete": "D"}
      let s = permissionHash[salut]
      return pPrivilege.contracts.includes(s);     
    },
    showContractStats(){
     if(this.getShowProjectStats == false){
        this.setShowProjectStats(!this.getShowProjectStats)
     } else return
     
    },
    showProjectStats(){
      if(this.getShowProjectStats == true){
        // console.log(this.getShowProjectStats)
        this.setShowProjectStats(!this.getShowProjectStats)
          // console.log(this.getShowProjectStats)
      } else return
    },
      exportTasksToPdf() {
      const doc = new jsPDF("l");
         console.log( this.$refs.table)
      const html = this.$refs.table.innerHTML;
      doc.autoTable({ 
        html: "#portTasks1",       
        didParseCell: function(hookData) {  
          // console.log(hookData)      
          if (hookData.section == 'head')    {
              hookData.cell.styles.fillColor = "383838"; 
              hookData.cell.styles.textColor = [255, 255, 255];   
          }          
            for (const t of Object.values(hookData.table.body)) {   
                if (t.raw.length === 1){
                  // console.log("yes") 
                   for (const s of Object.values(t.cells)) {
                           s.styles.fontStyle = 'bold'; 
                           s.styles.textColor = [255, 255, 255];      
                           s.styles.fillColor = [2, 117, 216];   
                   }
                     
            }            
         }
      }
    });
      doc.save("Program_Task_List.pdf");
    },
    exportTasksToExcel(table, name) {
      if (!table.nodeType) table = this.$refs.table;
      var ctx = { worksheet: name || "Worksheet", table: table.innerHTML };
      window.location.href =
        this.uri + this.base64(this.format(this.template, ctx));
    },
    handleClick(tab, event) {
       let tab_id = $(event.target).attr("id")          
      if(tab_id == "tab-tasks" || tab.name == 'tasks'){
        this.currentTab = '#tab-tasks'  
      }else if(tab_id == "tab-issues" || tab.name == 'issues'){
        this.currentTab = '#tab-issues'
      }else if(tab_id == "tab-risks"  || tab.name == 'risks'){
        this.currentTab = '#tab-risks'
      }else if(tab_id == "tab-lessons"  || tab.name == 'lessons'){
        this.currentTab = '#tab-lessons'       
      } 
    },
    beforeClose(done) {
    	this.dialogVisible = false;
      done();
    },
   openTask(task) {   
    if(!this.getShowProjectStats){
      this.$router.push({
      name: "ProgramTaskForm",   
        params: {
          programId: task.projectId,
          projectId: task.facilityId,
          taskId: task.id,
        },
      });
      }
     if(this.getShowProjectStats) {
       this.$router.push({
        name: "ProgramContractTaskForm", 
          params: {
          programId: this.$route.params.programId,
          contractId: task.contractId,
          taskId: task.id,
        },
       }); 
      }
    },
    openTpresentation(){
      this.dialogVisible = true; 
      this.currentTaskSlide = 0 
      this.dynamicObj = this.filteredTasks.filtered.tasks
      this.action = "TASK"   
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
    setProjectGroupIds(){
      this.facility_project_ids = [];
      let value = this.projectGroupsFilter
          // console.log(value)
      if(!value){
        return
      }
      for(let k = 0; k < value.length; k++){
        if(value[k].program_id){
          this.facility_project_ids = this.facility_project_ids.concat(value[k].all_facility_project_ids)
        }else if(value[k].project_group_id){
          this.facility_project_ids = this.facility_project_ids.concat(value[k].all_facility_project_ids)
        }else if(value[k].project_id){
          this.facility_project_ids.push(value[k].facility_project_id)
        }
      }
      this.facility_project_ids = _.uniq(this.facility_project_ids)
        // console.log(this.facility_project_ids)
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
    // backBtn() {      
    //   return `/programs/${this.$route.params.programId}/sheet`;
    // },
    backBtn() {
      window.location.pathname = `/programs/${this.$route.params.programId}/sheet`
    },
      showCounts(){
        this.setShowCount(!this.getShowCount)       
      },
    setValueNull(val) {
        this.setTaskTypeFilter('');
    },
    showLessToggle() {
      this.showLess = "Show Less";
    },
    resetFlags(){  
    if(this.getHidePlanned){
    this.setHidePlanned(!this.getHidePlanned)   
    } else this.setHidePlanned(this.getHidePlanned)  
        
    if(this.getHideOnhold){
    this.setHideOnhold(!this.getHideOnhold)   
    } else this.setHideOnhold(this.getHideOnhold)  
        
    if(this.getHideDraft){
    this.setHideDraft(!this.getHideDraft)   
    } else this.setHideDraft(this.getHideDraft)          
      
    if(this.getHideComplete){
    this.setHideComplete(!this.getHideComplete)   
    } else this.setHideComplete(this.getHideComplete)           
        
    if(this.getHideInprogress){
    this.setHideInprogress(!this.getHideInprogress)  
    } else this.setHideInprogress(this.getHideInprogress)            
          
    if(this.getHideOngoing){
    this.setHideOngoing(!this.getHideOngoing)   
    } else this.setHideOngoing(this.getHideOngoing)  
          
    if(this.getHideOverdue){
    this.setHideOverdue(!this.getHideOverdue)   
    } else this.setHideOverdue(this.getHideOverdue) 
 },

    toggleWatched(){
    this.setHideWatched(!this.getHideWatched)    
    },
    toggleImportant(){
    this.setHideImportant(!this.getHideImportant)    
    },
    toggleBriefed(){
        this.setHideBriefed(!this.getHideBriefed)    
    },
    toggleComplete(){
    this.setHideComplete(!this.getHideComplete)    
    },
    toggleDraft(){
    this.setHideDraft(!this.getHideDraft)    
    },
    togglePlanned(){
        this.setHidePlanned(!this.getHidePlanned)    
    },
    toggleInprogress(){
    this.setHideInprogress(!this.getHideInprogress)    
    },
    toggleOngoing(){
        this.setHideOngoing(!this.getHideOngoing)    
    },
    toggleOnhold(){
        this.setHideOnhold(!this.getHideOnhold)    
    },
    toggleOverdue(){
    //  this.setAdvancedFilter({id: 'overdue', name: 'Overdue', value: "overdue", filterCategoryId: 'overDueFilter', filterCategoryName: 'Action Overdue'}) 
    this.setHideOverdue(!this.getHideOverdue)    
    },
    log(e){
      // console.log(e)
    },
  sort: function (s) {
     //if s == current sort, reverse
      if (s === this.currentSort) {
        this.currentSortDir = this.currentSortDir === "asc" ? "desc" : "asc";
      }
      this.currentSort = s; 
    },
   sortCol1: function (s) {
     //if s == current sort, reverse
      if (s === this.currentSortCol1) {
        this.currentSortDir1 = this.currentSortDir1 === "asc" ? "desc" : "asc";
      }
      this.currentSortCol1 = s; 
      // this.currentSort = "";
    },
   sortCol2: function (s) {
     //if s == current sort, reverse
      if (s === this.currentSortCol2) {
        this.currentSortDir2 = this.currentSortDir2 === "asc" ? "desc" : "asc";
      }
       this.currentSortCol2 = s; 
      //  this.currentSort = "";
    },
    nextPage:function() {
        if((this.currentPage*this.C_tasksPerPage.value) < this.filteredTasks.filtered.tasks.length) this.currentPage++;
      },
    prevPage:function() {
       if(this.currentPage > 1) this.currentPage--;
    },

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
  beforeMount(){
  this.fetchProgramLessonCounts(this.$route.params)  
  },
  mounted() {
    this.fetchPortfolioPrograms();    
        this.$nextTick(function () {
      // Code that will run only after the
      // entire view has been rendered
     $(this.currProgramTab).trigger('click');
      // this.fetchPortfolioCounts();
      this.setProjectGroupIds()
    })
  },
};
</script>

<style scoped lang="scss">
.backBtn {
  z-index: 1040;
  top:1rem;
  position:absolute;
  right: 1rem;
  background-color: #fff;
  z-index: 1045;
  width: 350px;
}
/deep/.el-switch__label, .el-switch__label--left {
  color: lightgray;
}
/deep/.el-switch__label, .el-switch__label--right {
  color: lightgray;
}
/deep/.el-switch__label.is-active, .el-switch__label--left {
  color: #383838;
}
/deep/.vue-treeselect__control {
  height: 40px !important;
}
.lightBtn {
  background-color: #ededed;
}
.inactive {
  color: lightgray ;
}

</style>
