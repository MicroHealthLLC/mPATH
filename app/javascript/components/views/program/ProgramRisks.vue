<template>
<div class="box-shadow py-2"  style="postion:relative"  >
    <el-dialog :visible.sync="dialogVisible" append-to-body center class="portfolioDialogMode">
        <template slot="title">
        <div v-if="dynamicObj.length > 0 && dynamicObj[currentRiskSlide] !== undefined" class="container-fluid">
          <h3 class="pl-2 pr-5 mt-3 d-inline-block mh-blue px-3 text-light" style="cursor:pointer; position:absolute; left:0; top:0">RISK</h3>
            <div v-for="number in [currentRiskSlide]" :key="number" >
            <div class="row justify-content-center">
              <div class="col-3 pb-0">
                  <img
                    class="mb-0"
                    style="width: 125px"
                    :src="require('../../../../assets/images/mpath.png')"
                  />
              </div>
        <div class="col-5 text-center px-3 py-2" v-if="dynamicObj[currentRiskSlide]">       
              
          <span v-if="dynamicObj[currentRiskSlide].isOverdue" v-tooltip="`Overdue`">
            <i class="fas fa-calendar text-danger mr-1" style="font-size:1.8rem"></i
          ></span>
          <span  v-if="dynamicObj[currentRiskSlide].completed" v-tooltip="`Completed`"
            ><i
              class="fas fa-clipboard-check text-success mr-1" style="font-size:1.8rem"
            ></i
          ></span>
          <span
              v-if="dynamicObj[currentRiskSlide].ongoing == true && dynamicObj[currentRiskSlide].closed == false"
            v-tooltip="`Ongoing`"
            ><i class="fas fa-retweet mr-1 text-success" style="font-size:1.8rem"></i
          ></span>
          <span
              v-if="dynamicObj[currentRiskSlide].closed"
            v-tooltip="`Ongoing: Closed`"
            ><i class="fas fa-retweet mr-1 text-secondary" style="font-size:1.8rem"></i
          ></span>
         
          <span
              v-if="dynamicObj[currentRiskSlide].onHold == true"
            v-tooltip="`On Hold`"
          >
            <i class="fas fa-pause-circle mr-1 text-primary" style="font-size:1.8rem"></i
          ></span>
          <span  v-if="dynamicObj[currentRiskSlide].draft == true" v-tooltip="`Draft`">
            <i class="fas fa-pencil-alt mr-1 text-warning" style="font-size:1.8rem"></i
          ></span>
          <span  v-if="dynamicObj[currentRiskSlide].planned" v-tooltip="`Planned`">
            <i class="fas fa-calendar-check text-info mr-1" style="font-size:1.8rem"></i
          ></span>
          <span
              v-if="dynamicObj[currentRiskSlide].inProgress"
            v-tooltip="`In Progress`"
          >
            <i class="far fa-tasks text-primary mr-1" style="font-size:1.8rem"></i
          ></span>

            <span v-if="dynamicObj[currentRiskSlide].text"> 
              <h2 class="mt-2 d-inline text-truncate breakWord">{{ dynamicObj[currentRiskSlide].text }}</h2>
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
                    <h4>{{dynamicObj[currentRiskSlide].programName}}</h4>
                  </div>    
              
                  <div class="col truncate-line-two">    
                        <h6 class="leftColLabel text-light mh-orange">PROJECT GROUP</h6>
                    <h4> {{dynamicObj[currentRiskSlide].projectGroup}}  </h4>
                                                  
                  </div>  
          
                    <div class="col py-2">    
                        <h6 class="leftColLabel text-light mh-orange">PROJECT</h6>
                    <h4>{{ dynamicObj[currentRiskSlide].facilityName}}  </h4>                                                                 
                  </div>  

                      <div class="col">    
                        <h6 class="leftColLabel mh-blue text-light">PROCESS AREA</h6>
                    <h4 v-if="dynamicObj[currentRiskSlide].taskType" >{{ dynamicObj[currentRiskSlide].category}}  </h4> 
                    <h4 v-else> -- </h4>                                                                
                  </div>  

                </div>    
                
                                        
                <div class="col-5 text-center  mx-4 p-0" v-if="dynamicObj[currentRiskSlide] !== undefined">
                <div class="lastUpdateCol">                                
                  <h3 class="mh-green text-light d-block">LAST UPDATE</h3>
                  <div style="height:300px; overflow-y:auto">
                  <span  v-if="dynamicObj[currentRiskSlide].notes.length > 0">                    
                  <span>
                    <br>
                    <h4 class="px-3"> <em>{{ dynamicObj[currentRiskSlide].lastUpdate.body }}</em></h4>
                  </span>
                    <span
                    class="px-2"                                                                 
                    >
                    <h6 class="mt-2">{{
                      moment(dynamicObj[currentRiskSlide].lastUpdate.createdAt).format(
                        "DD MMM YYYY, h:mm a "
                      ) + ' By: ' +
                      dynamicObj[currentRiskSlide].lastUpdate.user.fullName
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
              
                <div class="issueTypes mt-3">

                  <h6 class="bg-secondary text-light py-1 d-block">RISK DESCRIPTION</h6>
                    <div style="height:100px; overflow-y:auto">
                      <h4 class="px-3">{{ dynamicObj[currentRiskSlide].riskDescription }}</h4>
                  </div>
                </div>
                </div>
                    <div class="col-3 mh-blue text-center text-light slideCol"  v-if="dynamicObj[currentRiskSlide] !== undefined">                                          
                     <div class="col pt-2">  
                      <i class="fas fa-calendar text-light d-block pb-1" style="font-size:2.8rem"></i>
                    <span v-if="dynamicObj[currentRiskSlide] && dynamicObj[currentRiskSlide].startDate" class="d-inline-block"> <h5>{{ moment(dynamicObj[currentRiskSlide].startDate).format( "DD MMM YYYY") }}</h5></span> 
                    <span v-else> -- </span>
                    - 
                      <span v-if="dynamicObj[currentRiskSlide] && dynamicObj[currentRiskSlide].dueDate" class="d-inline-block"> <h5> {{ moment(dynamicObj[currentRiskSlide].dueDate).format("DD MMM YYYY") }}</h5></span>
                      <span v-else>  </span>
                    
                  </div>    
                      
                    <div class="col mt-3 truncate-line-two">
                    <i class="fas fa-users d-block text-light" style="font-size:2.8rem"></i>
                          <span class="truncate-line-two" v-if="dynamicObj[currentRiskSlide].userNames.length > 0"><h4> {{ dynamicObj[currentRiskSlide].userNames }}</h4></span>
                          <span v-else> <h4>No Assignments</h4></span>                                        
                  </div>  

                 <div class="col mt-3">  

                        <h6>RISK APPROACH</h6>                                         
                        <h4 class="text-light labels px-2 d-inline-block"> {{
                          dynamicObj[currentRiskSlide].riskApproach.charAt(0).toUpperCase() +
                          dynamicObj[currentRiskSlide].riskApproach.slice(1)
                          }}</h4>

                      <h6 class="mt-5">PRIORITY LEVEL</h6>  
                          <h4
                          v-if="dynamicObj[currentRiskSlide].priorityLevelName == 'Very Low'"
                          class="gray2 px-1 riskLabels"
                          >Very Low</h4
                        >
                        <h4
                          v-else-if="dynamicObj[currentRiskSlide].priorityLevelName == 'Low'"
                          class="green1 riskLabels px-1"
                          >Low</h4
                        >
                        <h4
                          v-else-if="dynamicObj[currentRiskSlide].priorityLevelName == 'Moderate'"
                          class="yellow1 riskLabels px-1"
                          >Moderate</h4
                        >
                        <h4
                          v-else-if="dynamicObj[currentRiskSlide].priorityLevelName == 'High'"
                          class="orange1 riskLabels px-1"
                          >High</h4
                        >
                        <h4
                          v-else-if="dynamicObj[currentRiskSlide].priorityLevelName == 'Extreme'"
                          class="red1 riskLabels px-1"
                          >Extreme</h4
                        >                                                             
          
                  </div>    
                </div>   

                </div>  
                
            </div>
        
        </div>
        <div slot="footer" class="dialog-footer-left"  v-if="dynamicObj[currentRiskSlide] !== undefined">                       
            <el-button class="elBtn tagsBtn py-1 text-light mr-2" > <h5 class="d-inline px-2 text-dark">FOCUS FLAGS: </h5>
              <span
            v-if="dynamicObj[currentRiskSlide].watched == true"
            v-tooltip="`On Watch`"
            ><i class="fas fa-eye mr-1 text-dark" style="font-size:1.5rem"></i
          ></span> 
          <span
            v-if="dynamicObj[currentRiskSlide].important == true"
            v-tooltip="`Important`"
          >
            <i class="fas fa-star text-warning mr-1 " style="font-size:1.5rem"></i
          ></span> 
          <span v-if="dynamicObj[currentRiskSlide].reportable" v-tooltip="`Briefings`">
            <i class="fas fa-presentation mr-1 text-primary" style="font-size:1.5rem"></i
          ></span>                
            
            
            </el-button>
          
        </div>

        <div slot="footer" class="dialog-footer">
        <el-button class="mh-orange elBtn text-light" @click.prevent="previousRisk"><i class="far fa-chevron-left" style="font-size:1.35rem"></i></el-button>
        <el-button class="bg-secondary elBtn text-light" ><span style="font-size:1.35rem"><span> RISK </span> {{ currentRiskSlide + 1 }} of {{ dynamicObj.length}}</span></el-button>                      
        <el-button class="mh-orange elBtn text-light"  @click.prevent="nextRisk"><i class="far fa-chevron-right" style="font-size:1.35rem"></i></el-button>
        </div>
        </template>
  </el-dialog>
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
            {{ riskVariation.completed.count }}
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
            {{ riskVariation.inProgress.count }}
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
            {{ riskVariation.overdue.count }}
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
        <span v-if="filteredRisks.filtered.risks">{{
          riskVariation.ongoing.count
        }}<span
          v-tooltip="`Ongoing: Closed`"
          v-if="riskVariation.ongoingClosed.count"
          style="color:lightgray"
          >({{
            riskVariation.ongoingClosed.count
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
            <span v-if="filteredRisks.filtered.risks">{{
            riskVariation.planned.count
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
            {{ riskVariation.onHoldR.count }}
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
            {{ riskVariation.riskDrafts.count }}
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
            {{ riskVariation.watched.count }}
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
            {{ riskVariation.important.count }}
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
            {{ riskVariation.briefings.count }}
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
        @click.prevent="openRiskPresentation"
        class="btn btn-md presentBtn mr-1 mh-blue text-light"
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
        exportRisksToExcel('table', 'Program Risks')
        "
        class="btn btn-md mx-1 exportBtns text-light"
    >
        <i class="far fa-file-excel"></i>
    </button>
    <button
        class="btn text-light btn-md mh-orange px-1 profile-btns portfolioResultsBtn"
    >
        RESULTS: {{ filteredRisks.filtered.risks.length }}
    </button></span
    >
</div>
</div>
<!-- <ProjectContractSwitch /> -->
<div
class="row text-center mt-3 pr-3"
style="postion:relative" 
v-if="filteredRisks.filtered.risks.length > 0"
>

<div class="px-3 tableFixHead" >
    <table
    class="table table-sm table-bordered"
    ref="table" 
    id="portRisks"                   
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
      
           <th class="pl-1 sort-th twenty" @click="sort('riskApproach')">
        Risk Approach
        <span
            class="inactive-sort-icon scroll"
            v-if="currentSort !== 'riskApproach'"
        >
            <i class="fas fa-sort"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'asc' && currentSort === 'riskApproach'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'asc' && currentSort === 'riskApproach'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'desc' && currentSort === 'riskApproach'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'desc' && currentSort === 'riskApproach'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        </th>
               <th class="pl-1 sort-th twenty" @click="sort('priorityLevel')">
        Priority Level
        <span
            class="inactive-sort-icon scroll"
            v-if="currentSort !== 'priorityLevel'"
        >
            <i class="fas fa-sort"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'asc' && currentSort === 'priorityLevel'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'asc' && currentSort === 'priorityLevel'
            "
        >
            <i class="fas fa-sort-up"></i
        ></span>
        <span
            class="sort-icon scroll"
            v-if="
            currentSortDir === 'desc' && currentSort === 'priorityLevel'
            "
        >
            <i class="fas fa-sort-down"></i
        ></span>
        <span
            class="inactive-sort-icon scroll"
            v-if="
            currentSortDir !== 'desc' && currentSort === 'priorityLevel'
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
        <tr v-for="(risk, index) in sortedRisks" :key="index" class="portTable taskHover" @click="openRisk(risk)">
        <td>{{ risk.projectGroup }}</td>
        <td>{{ risk.facilityName || risk.contractNickname }}</td>
        <td>{{ risk.text }}</td>        
        <td class="text-left">       
          <span  v-if="risk.notes.length > 0">
          <span  class="toolTip" v-tooltip="('By: ' + risk.lastUpdate.user.fullName)" > 
          {{ moment(risk.lastUpdate.createdAt).format('DD MMM YYYY, h:mm a')}} <br>         
          </span> 
          <span class="truncate-line-five">
            {{ risk.lastUpdate.body }}
          </span>   
          </span>
          <span v-else>No Update</span>      
        </td>  
        <td>
            {{
              risk.riskApproach.charAt(0).toUpperCase() +
              risk.riskApproach.slice(1)
            }}
          </td>
          <td>
            <span
              v-if="risk.priorityLevelName == 'Very Low'"
              class="gray2"
              >Very Low</span
            >
            <span
              v-else-if="risk.priorityLevelName == 'Low'"
              class="green1"
              >Low</span
            >
            <span
              v-else-if="risk.priorityLevelName == 'Moderate'"
              class="yellow1"
              >Moderate</span
            >
            <span
              v-else-if="risk.priorityLevelName == 'High'"
              class="orange1"
              >High</span
            >
            <span
              v-else-if="risk.priorityLevelName == 'Extreme'"
              class="red1"
              >Extreme</span
            >
          </td>
        <td>
            <span v-if="risk.ongoing && !risk.closed && risk.startDate == null || undefined">
            <i class="fas fa-retweet text-success"></i>
            </span>
            <span v-else-if="risk.ongoing && risk.closed && risk.startDate == null || undefined">
            <i class="fas fa-retweet text-secondary"></i>
                </span>
            <span v-else>{{
            moment(risk.startDate).format("DD MMM YYYY") 
            }}</span>
        </td>
        <td>
            <span v-if="risk.ongoing && !risk.closed" v-tooltip="`Ongoing`"
            ><i class="fas fa-retweet text-success"></i
            ></span>
            <span v-else-if="risk.completed && (risk.dueDate == null || risk.dueDate == undefined)"></span>
            <span
            v-else-if="risk.onHold && risk.dueDate == null"
            v-tooltip="`On Hold (w/no Due Date)`"
            ><i class="fas fa-pause-circle text-primary"></i
            ></span>
            <span v-else>{{
            moment(risk.dueDate).format("DD MMM YYYY")
            }}</span>
        </td>
        <td>{{ risk.users.fullName }}</td>
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
            <span v-if="risk.isOverdue" v-tooltip="`Overdue`">
            <i class="fas fa-calendar text-danger mr-1"></i
            ></span>
            <span v-if="risk.completed" v-tooltip="`Completed`"
            ><i
                class="fas fa-clipboard-check text-success mr-1"
            ></i
            ></span>
            <span
            v-if="risk.ongoing == true && !risk.closed"
            v-tooltip="`Ongoing`"
            ><i class="fas fa-retweet mr-1 text-success"></i
            ></span>
            <span
            v-if="risk.closed"
            v-tooltip="`Ongoing: Closed`"
            ><i class="fas fa-retweet mr-1 text-secondary"></i
            ></span>
            <span
            v-if="risk.onHold == true"
            v-tooltip="`On Hold`"
            >
            <i class="fas fa-pause-circle mr-1 text-primary"></i
            ></span>
            <span v-if="risk.draft == true" v-tooltip="`Draft`">
            <i class="fas fa-pencil-alt mr-1 text-warning"></i
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
            v-if="risk.inProgress"
            v-tooltip="`In Progress`"
            >
            <i class="far fa-tasks text-primary mr-1"></i
            ></span>

        </td>
        <td>{{ risk.category }}</td>
        </tr>
    </tbody>
    </table>
    <table
      class="table table-bordered w-100"
      id="portRisks1"
      style="display:none"        
       >
      <thead>      
        <tr style="background-color:#ededed">
          <th>Risk</th>
          <th>Project</th>
          <th>Risk Approach</th>
          <th>Priority Level</th>
          <th>Start Date</th>
          <th>Due Date</th>
          <th>Assigned Users</th>
          <th>Progress</th>    
          <th>Flags</th>        
          <th>Last Update</th>
        </tr>
                    <tr></tr>
        </thead>
        <tbody v-for="(p, i) in validRiskProjectGroups" :key="i">  
          <tr class="text-center">  <th scope="row">{{ p }}</th></tr>
          <tr  v-for="(risk, index) in filteredRisks.filtered.risks" :key="index" v-if="risk.projectGroup == p">            
          <td>{{ risk.text }}</td>
          <td>{{ risk.facilityName}} </td>
          <td>
            {{
              risk.riskApproach.charAt(0).toUpperCase() +
              risk.riskApproach.slice(1)
            }}
          </td>
          <td>
            <span
              v-if="risk.priorityLevelName == 'Very Low'"
              class="gray2"
              >Very Low</span
            >
            <span
              v-else-if="risk.priorityLevelName == 'Low'"
              class="green1"
              >Low</span
            >
            <span
              v-else-if="risk.priorityLevelName == 'Moderate'"
              class="yellow1"
              >Moderate</span
            >
            <span
              v-else-if="risk.priorityLevelName == 'High'"
              class="orange1"
              >High</span
            >
            <span
              v-else-if="risk.priorityLevelName == 'Extreme'"
              class="red1"
              >Extreme</span
            >
          </td>
            <td>
              <span v-if="risk.ongoing && !risk.closed && risk.startDate == null || undefined">
                <i class="fas fa-retweet text-success"></i>
              </span>
              <span v-else-if="risk.ongoing && risk.closed && risk.startDate == null || undefined">
                <i class="fas fa-retweet text-secondary"></i>
              </span>
              <span v-else>{{
                moment(risk.startDate).format("DD MMM YYYY") 
              }}</span>
            </td>
              <td>
                <span v-if="risk.ongoing && !risk.closed" v-tooltip="`Ongoing`"
                  ><i class="fas fa-retweet text-success"></i
                ></span>
                <span v-else-if="risk.completed && (risk.dueDate == null || risk.dueDate == undefined)"></span>
                <span
                  v-else-if="risk.onHold && risk.dueDate == null"
                  v-tooltip="`On Hold (w/no Due Date)`"
                  ><i class="fas fa-pause-circle text-primary"></i
                ></span>
                <span v-else>{{
                  moment(risk.dueDate).format("DD MMM YYYY")
                }}</span>
              </td>
              <td>{{ risk.userNames }}</td>
              <td>
                <span v-if="risk.ongoing && !risk.closed" v-tooltip="`Ongoing`"
                  >
                  Ongoing
                  </span>
                  <span v-else-if="risk.closed" v-tooltip="`Ongoing: Closed`"
                  >
                  Ongoing
                  </span>
                <span v-else>
                {{ risk.progress + "%" }}
                </span>
              </td>
                <td class="text-center">
                <span v-if="risk.isOverdue" v-tooltip="`Overdue`">
                  Overdue
                </span>
                <span v-if="risk.completed" v-tooltip="`Completed`"
                  >
                  Completed
                  </span>
                <span
                  v-if="risk.ongoing == true && !risk.closed"
                  v-tooltip="`Ongoing`"
                  >
                  Ongoing
                  </span>
                <span
                  v-if="risk.closed == true"
                  v-tooltip="`Ongoing: Closed`"
                  >
                  Ongoing
                  </span>
                <span
                  v-if="risk.onHold == true"
                  v-tooltip="`On Hold`"
                >
                  On Hold
                  </span>
                <span v-if="risk.draft == true" v-tooltip="`Draft`">
                  Draft
                </span>
                      
                <span v-if="risk.planned" v-tooltip="`Planned`">
                  Planned
                </span>
                <span
                  v-if="risk.inProgress"
                  v-tooltip="`In Progress`"
                >
                  In Progress
                  </span>
                </td>
             <td v-if="risk.notes.length > 0">       
              <span  class="toolTip" v-tooltip="('By: ' + risk.lastUpdate.user.fullName)" > 
              {{ moment(risk.lastUpdate.createdAt).format('DD MMM YYYY, h:mm a')}} <br>         
              </span> 
              <span class="truncate-line-five">
                {{ risk.lastUpdate.body }}
              </span>         
             </td>  
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
        v-for="item in getRisksPerPageOptions"
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
        filteredRisks.filtered.risks.length / this.C_risksPerPage.value
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
</template>

<script>

import {mapGetters, mapMutations, mapActions} from 'vuex'
import { jsPDF } from "jspdf";
import "jspdf-autotable";
// import ProjectContractSwitch from  "./ProjectContractSwitch.vue"
// import LessonForm from "./../../dashboard/lessons/LessonForm";

export default {
  name: "ProgramRisks",
  // components:{ ProjectContractSwitch },
  data() {
    return {
      showLess: "Show More",
      showMore: true,
      today: new Date().toISOString().slice(0, 10),
      currentSort: "text",  
      dialogVisible: false,
      currentRiskSlide : 0, 
      dynamicObj: {},
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
    'currRiskPage',
    'programCategoriesFilter',
    'projectGroupsFilter',
    "lessonsLoaded",
    'searchRisks',
    "projectLessons",
    "programLessons",
    'projects',
    "facilities",
    "facilityCount",
    "facilityGroupFacilities",
    "facilityProgress",
    "filterDataForAdvancedFilter",
    "filteredAllIssues",
    "filteredAllRisks",
    "filteredAllContractRisks",
    "filteredAllTasks",
    "filteredFacilities",
    "filteredFacilityGroups",
    "getAllFilterNames",
    "getFilterValue",
    "getRiskIssueUserFilter",
    "getTaskIssueUserFilter",
    'getRisksPerPageOptions',
    'getRisksPerPage',
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
    "taskTypes",
    "taskUserFilter",
    'getShowAdvancedFilter',
    'getShowCount',
    'getShowProjectStats',
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
    stateRisks(){
      if(this.getShowProjectStats == false){
        return this.filteredAllRisks
      } else return this.filteredAllContractRisks
    },
    projectObj() {
    return this.currentProject.facilities
    },
     currentTab: {
      get() {        
        return this.portfolioTab 
      },
      set(value) {
        if(value === 'issues') {
            this.setCurrTab('#tab-issues')
        } else if (value === 'risks') {
            this.setCurrTab('#tab-risks')
        } else if (value === 'lessons') {
            this.setCurrTab('#tab-lessons')
        } else 
          this.setCurrTab('#tab-tasks')
          this.setPortfolioTab(value)
      }
    },
    validRiskProjectGroups(){
      let name = this.filteredRisks.filtered.risks;
      return _.uniq(name.map(item => item.projectGroup))      
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
    C_showCountToggle: {                  
        get() {
         return this.getShowCount                
        },
        set(value) {
          this.setShowCount(value) ||  this.setShowCount(!this.getShowCount)
        }
        
      },
    C_taskTypeFilter: {
      get() {
        return this.taskTypeFilter;
      },
      set(value) {
        this.setTaskTypeFilter(value);
      },
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
  currentPage:{
       get() {
        return this.currRiskPage
      },
      set(value) {
        this.setCurrRiskPage(value);
      },
    },
   C_risksPerPage: {
      get() {
        return this.getRisksPerPage || {id: 15, name: '15', value: 15}
      },
      set(value) {
        this.setRisksPerPageFilter(value)
       }
     },
    C_facilityCount() {         
      return this.facilityGroup
      
        ? this.facilityGroupFacilities(this.facilityGroup).length
        : this.facilityCount; 
      
    },
    C_facilityProgress() {
      return this.facilityGroup
        ? Number(
            _.meanBy(
              this.facilityGroupFacilities(this.facilityGroup),
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
  
    issueTaskCATEGORIES() {
      let issues = new Array();
      let group = _.groupBy(this.filteredIssues, "taskTypeName");
      for (let type in group) {
        if (!type || type == "null") continue;
        issues.push({
          name: type,
          count: group[type].length,
          progress: Number((_.meanBy(group[type], "progress") || 0).toFixed(0)),
        });
      }
      return issues;
    },
    filteredRisks() {
    let allRisks = this.filteredAllRisks
     if (this.getShowProjectStats){
       allRisks = this.filteredAllContractRisks
     }
     let risks = allRisks.filter(r => {
     if (this.projectGroupsFilter && this.projectGroupsFilter.length > 0) { 
         this.facility_project_ids = [];
         let val = this.projectGroupsFilter
         for(let k = 0; k < val.length; k++){
        if(val[k].program_id){
        this.facility_project_ids = this.facility_project_ids.concat(val[k].all_facility_project_ids)
        }else if(val[k].project_group_id){
         this.facility_project_ids = this.facility_project_ids.concat(val[k].all_facility_project_ids)
        }else if(val[k].project_id){
        this.facility_project_ids.push(val[k].facility_project_id)
        }
      }
       return this.facility_project_ids.includes(r.facilityProjectId)
      } else return true
       }).filter((r) => {
          if (this.searchRisks !== "" && r && r.text) {
            // console.log(issue)
            return (
              r.text.toLowerCase().match(this.searchRisks.toLowerCase()) ||
              r.riskApproach
                .toLowerCase()
                .match(this.searchRisks.toLowerCase()) ||
              r.projectGroup
                .toLowerCase()
                .match(this.searchRisks.toLowerCase()) ||
              // r.programName
              //   .toLowerCase()
              //   .match(this.searchRisks.toLowerCase()) ||
              // r.facilityName
              //   .toLowerCase()
              //   .match(this.searchRisks.toLowerCase()) ||
              // r.contractNickname
              //   .toLowerCase()
              //   .match(this.searchRisks.toLowerCase()) ||
              r.userNames.toLowerCase().match(this.searchRisks.toLowerCase())
            );
          } else return true;
          // Filtering 7 Task States
        })
        .filter((r) => {
          if (this.programCategoriesFilter.length > 0) {
            let category = this.programCategoriesFilter.map((t) => t);
            return category.includes(r.category);
          } else return true;
        })
     
       return {
       unfiltered: {
           risks
          },
      filtered: {
      risks:  risks.filter(t => {
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
     sortedRisks:function() {
        return this.filteredRisks.filtered.risks.sort((a,b) => {
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
          let start = (this.currentPage-1)*this.C_risksPerPage.value;
          let end = this.currentPage*this.C_risksPerPage.value;
          if(index >= start && index < end) return true;
          return this.end
        });
    },
    riskPriorityLevels() {
      let grey = _.filter(
        this.filteredRisks,
        (t) => t && t.priorityLevelName && t.priorityLevelName == "Very Low"
      );
      let green = _.filter(
        this.filteredRisks,
        (t) => t && t.priorityLevelName && t.priorityLevelName == "Low"
      );
      let yellow = _.filter(
        this.filteredRisks,
        (t) => t && t.priorityLevelName && t.priorityLevelName == "Moderate"
      );
      let orange = _.filter(
        this.filteredRisks,
        (t) => t && t.priorityLevelName && t.priorityLevelName == "High"
      );
      let red = _.filter(
        this.filteredRisks,
        (t) => t && t.priorityLevelName && t.priorityLevelName == "Extreme"
      );
      return {
        grey: grey.length,
        green: green.length,
        yellow: yellow.length,
        orange: orange.length,
        red: red.length,
      };
    },
    activeFacilitiesByStatus() {
      return this.facilityGroup
        ? this.facilityGroupFacilities(this.facilityGroup).length
        : this.filteredFacilities("active").length;
    },
    inactiveFacilitiesByStatus() {
      return this.facilityGroup
        ? this.facilityGroupFacilities(this.facilityGroup, "inactive").length
        : this.filteredFacilities("inactive").length;
    },
    projectStatuses() {
      let statuses = [];

      if (this.contentLoaded && this.facilities.length > 0) {
        this.statuses.forEach((status) => {
          // Find number of facilities with current status
          let count = this.facilities
            .filter((facility) => facility.projectStatus === status.name)
            .reduce((total) => total + 1, 0);
          // Insert status into projectStatuses for use Project Status card
          statuses.push({
            name: status.name,
            color: status.color,
            length: count,
            progress: Math.floor((count / this.facilities.length) * 100),
          });
        });
      }

      return statuses;
    },
    currentTaskTypes() {
      let names =
        this.taskTypeFilter &&
        this.taskTypeFilter.length &&
        _.map(this.taskTypeFilter, "name");
      let taskTypes = new Array();
      for (let type of this.taskTypes) {
        let tasks = _.filter(
          this.filteredTasks,
          (t) => t.taskTypeId == type.id
        );
        taskTypes.push({
          name: type.name,
          _display:
            tasks.length > 0 && (names ? names.includes(type.name) : true),
          length: tasks.length,
          progress: Number(_.meanBy(tasks, "progress").toFixed(0)),
        });
      }
      return taskTypes;
    },
    currentIssueTypes() {
      let names =
        this.issueTypeFilter &&
        this.issueTypeFilter.length &&
        _.map(this.issueTypeFilter, "name");
      let issueTypes = new Array();
      for (let type of this.issueTypes) {
        let issues = _.filter(
          this.filteredIssues,
          (t) => t.issueTypeId == type.id
        );
        issueTypes.push({
          name: type.name,
          _display:
            (names ? names.includes(type.name) : true) && issues.length > 0,
          length: issues.length,
          progress: Number(_.meanBy(issues, "progress").toFixed(0)),
        });
      }
      return issueTypes;
    },
    currentRiskTypes() {
      let names =
        this.taskTypeFilter &&
        this.taskTypeFilter.length &&
        _.map(this.taskTypeFilter, "name");
      let taskTypes = new Array();
      for (let type of this.taskTypes) {
        let risks = _.filter(
          this.filteredRisks,
          (t) => t.taskTypeId == type.id
        );
        taskTypes.push({
          name: type.name,
          _display:
            risks.length > 0 && (names ? names.includes(type.name) : true),
          length: risks.length,
          progress: Number(_.meanBy(risks, "progress").toFixed(0)),
        });
      }
      return taskTypes;
    },
        // Find sum of all valid Tasks, Issues, and Risks (75)
    riskVariation() {
    let planned = _.filter(
        this.filteredRisks.unfiltered.risks,
        (t) => t && t.planned == true
        // (t) => t && t.startDate && t.startDate > this.today 
    );     
    let riskDrafts = _.filter(
        this.filteredRisks.unfiltered.risks,
        (t) => t && t.draft == true
    );      
    let completed = _.filter(
        this.filteredRisks.unfiltered.risks,
        (t) => t && t.completed == true
    );
    let completed_percent = this.getAverage(
        completed.length,
        this.filteredRisks.unfiltered.risks.length
    );
    let inProgress = _.filter(
        this.filteredRisks.unfiltered.risks,
        (t) => t && t.inProgress == true
    );
    let onHoldR = _.filter(
        this.filteredRisks.unfiltered.risks,
        (t) => t && t.onHold == true
    );
    let important = _.filter(
    this.filteredRisks.unfiltered.risks,
        (t) => t && t.important
    );
    let briefings = _.filter(
    this.filteredRisks.unfiltered.risks,
        (t) => t && t.reportable
    ); 
    let watched = _.filter(
    this.filteredRisks.unfiltered.risks,
        (t) => t && t.watched 
    );             
    let inProgress_percent = this.getAverage(
        inProgress.length,
        this.filteredRisks.unfiltered.risks.length
    );
    let overdue = _.filter(this.filteredRisks.unfiltered.risks, (t) => t && t.isOverdue);
    let overdue_percent = this.getAverage(
    overdue.length,
    this.filteredRisks.unfiltered.risks.length
    );
    let ongoing = _.filter(this.filteredRisks.unfiltered.risks, (t) => t && t.ongoing );
    let ongoingClosed = _.filter(this.filteredRisks.unfiltered.risks, (t) => t && t.closed );
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
     'fetchProgramLessons'
     ]), 
    ...mapMutations([
        'setAdvancedFilter',
        'setTaskIssueProgressStatusFilter',
        'setTaskIssueOverdueFilter',
        'setTaskTypeFilter',
        'setMyActionsFilter',
        'setCurrTab',
        'setProjectGroupsFilter',
        'setPortfolioTab',
        'setCurrRiskPage',
        'setOnWatchFilter',
        'setToggleRACI',
        'setShowAdvancedFilter',
        'setTaskForManager',
        'setShowCount',
         'setCurrentPage',

        // Used in Program Viewer
        'setRisksPerPageFilter',
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

    beforeClose(done) {
    	this.dialogVisible = false;
      done();
    },
  openRisk(risk) {    
    if(!this.getShowProjectStats) {
      this.$router.push({
      name: "ProgramRiskForm",
      params: {
        programId: risk.projectId,
        projectId: risk.facilityId,
        riskId: risk.id,
      },
      })
     }
    if(this.getShowProjectStats) {
      this.$router.push({
      name: "ProgramRiskForm",
      params: {
        programId: this.$route.params.programId,
        contractId: risk.contractId,
        riskId: risk.id,
      },
      })
      }    // console.log(this.$route.params)
    },
  exportRisksToPdf() {
      const doc = new jsPDF("l");
      const html = this.$refs.table.innerHTML;
      doc.autoTable({ 
        html: "#portRisks1",       
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
      doc.save("Program_Risk_List.pdf");
    },
    exportRisksToExcel(table, name) {
      if (!table.nodeType) table = this.$refs.table;
      var ctx = { worksheet: name || "Worksheet", table: table.innerHTML };
      window.location.href =
        this.uri + this.base64(this.format(this.template, ctx));
    },
    openRiskPresentation(){
      this.dialogVisible = true; 
      this.currentRiskSlide = 0 
      this.dynamicObj = this.filteredRisks.filtered.risks
     },
    nextRisk(){
      this.isSlidingToPrevious = false
      if(this.currentRiskSlide == this.dynamicObj.length-1){
          this.currentRiskSlide = 0;
      }else{
          this.currentRiskSlide += 1;
      }
    },
    previousRisk(){ 
        this.isSlidingToPrevious = true
        if(this.currentRiskSlide == 0){
            this.currentRiskSlide=this.dynamicObj.length-1;
        }else{
            this.currentRiskSlide-=1;
        }
    },
   showCounts(){
        this.setShowCount(!this.getShowCount)       
      },

    showLessToggle() {
      this.showLess = "Show Less";
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
    //   console.log(e)
    },
    handleClick(tab, event) {
        // console.log(tab, event);
    },
  sort: function (s) {
     //if s == current sort, reverse
      if (s === this.currentSort) {
        this.currentSortDir = this.currentSortDir === "asc" ? "desc" : "asc";
      }
      this.currentSort = s; 
    },
   sortI: function (s) {
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
      this.currentSort = "";
    },
   sortCol2: function (s) {
     //if s == current sort, reverse
      if (s === this.currentSortCol2) {
        this.currentSortDir2 = this.currentSortDir2 === "asc" ? "desc" : "asc";
      }
       this.currentSortCol2 = s; 
       this.currentSort = "";
    },
    nextPage:function() {
        if((this.currentPage*this.C_risksPerPage.value) < this.filteredRisks.filtered.risks.length) this.currentPage++;
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
  mounted() {
    // this.fetchProgramLessons(this.$route.params)  
  },
};
</script>

<style scoped></style>
