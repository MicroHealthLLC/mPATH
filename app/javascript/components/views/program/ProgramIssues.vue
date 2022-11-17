<template>
<div class="box-shadow py-2"  style="postion:relative">
   <el-dialog :visible.sync="dialogVisible" append-to-body center class="portfolioDialogMode">
      <template slot="title">
      <div v-if="dynamicObj.length > 0 && dynamicObj[currentIssueSlide] !== undefined" class="container-fluid">
         <h5 class="pl-2 mt-3 d-inline-block px-3 mh-blue text-light" style="cursor:pointer; position:absolute; left:0; top:0">
          <span v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].projectContractId">
            <i class="far fa-file-contract text-light py-2 mr-1"></i> </span>
          <span v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].projectContractVehicleId">
          <i class="far fa-car text-light py-2 mr-1"></i> </span>
          <span v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].projectId">
            <i class="fal fa-clipboard-list text-light py-2 mr-1"></i>
          </span>
          ISSUE
          </h5>
          <div v-for="number in [currentIssueSlide]" :key="number" >
          <div class="row justify-content-center">
            <div class="col-3 pb-0">
                <img
                  class="mb-0"
                  style="width: 125px"
                  :src="require('../../../../assets/images/mpath.png')"
                />
            </div>
      <div class="col-5 text-center px-3 py-2" v-if="dynamicObj[currentIssueSlide]">     
            
        <span v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].isOverdue" v-tooltip="`Overdue`">
          <i class="fas fa-calendar text-danger mr-1" style="font-size:1.8rem"></i
        ></span>
        <span  v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].completed" v-tooltip="`Completed`"
          ><i
            class="fas fa-clipboard-check text-success mr-1" style="font-size:1.8rem"
          ></i
        ></span>
          
        <span
            v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].onHold == true"
          v-tooltip="`On Hold`"
        >
          <i class="fas fa-pause-circle mr-1 text-primary" style="font-size:1.8rem"></i
        ></span>
        <span  v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].draft == true" v-tooltip="`Draft`">
          <i class="fas fa-pencil-alt mr-1 text-warning" style="font-size:1.8rem"></i
        ></span>
        <span  v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].planned" v-tooltip="`Planned`">
          <i class="fas fa-calendar-check text-info mr-1" style="font-size:1.8rem"></i
        ></span>
        <span
            v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].inProgress"
          v-tooltip="`In Progress`"
        >
          <i class="far fa-tasks text-primary mr-1" style="font-size:1.8rem"></i
        ></span>

          <span v-if="dynamicObj[currentIssueSlide].title"> 
            <h2 class="mt-2 d-inline text-truncate breakWord">{{ dynamicObj[currentIssueSlide].title }}</h2>
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
                  <h4 v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].programName">{{dynamicObj[currentIssueSlide].programName}}</h4>
                </div>    
            
                <div class="col truncate-line-two">    
                      <h6 class="leftColLabel text-light mh-orange">GROUP</h6>
                  <h4 v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].projectGroup"> {{dynamicObj[currentIssueSlide].projectGroup}}  </h4>
                  <h4 v-else>Unassigned</h4>                   
                </div>  
        
                  <div class="col py-2">   
                     <span v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].projectContractId">                                      
                      <h6 class="leftColLabel text-light mh-orange">CONTRACT</h6>
                      <h4  v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].contractNickname">{{ dynamicObj[currentIssueSlide].contractNickname}}  </h4>  
                    </span> 
                    <span v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].projectContractVehicleId">                                      
                      <h6 class="leftColLabel text-light mh-orange">VEHICLE</h6>
                      <h4  v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].vehicleNickname">{{ dynamicObj[currentIssueSlide].vehicleNickname}}  </h4>  
                    </span> 
                    <span v-else>
                        <h6 class="leftColLabel text-light mh-orange">PROJECT</h6>
                        <h4  v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].facilityName">{{ dynamicObj[currentIssueSlide].facilityName}}  </h4>      
                    </span>

          
                                                                                
                </div>  

                    <div class="col">    
                      <h6 class="leftColLabel mh-blue text-light">PROCESS AREA</h6>
                  <h4 v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].taskTypeName" >{{ dynamicObj[currentIssueSlide].taskTypeName}}  </h4> 
                  <h4 v-else> -- </h4>                                                                
                </div>  

              </div>    
              
                                      
              <div class="col-5 text-center  mx-4 p-0" v-if="dynamicObj[currentIssueSlide] !== undefined">
              <div class="lastUpdateCol">                                
                <h3 class="mh-green text-light d-block">LAST UPDATE</h3>
                <div style="height:300px; overflow-y:auto">
                <span  v-if="dynamicObj[currentIssueSlide].notes.length > 0">                    
                <span>
                  <br>
                  <h4 class="px-3"> <em>{{ dynamicObj[currentIssueSlide].lastUpdate.body }}</em></h4>
                </span>
                  <span
                  class="px-2"                                                                 
                  >
                  <h6 class="mt-2">{{
                    moment(dynamicObj[currentIssueSlide].lastUpdate.createdAt).format(
                      "DD MMM YYYY, h:mm a "
                    ) + ' By: ' +
                    dynamicObj[currentIssueSlide].lastUpdate.user.fullName
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
                                      
            <div class="wrap d-flex">
              <div class="issueTypes mt-3 px-0 w-50 mr-2 pt-0">
              <h6 class="bg-secondary text-light py-1 d-block">ISSUE TYPE</h6>
                <div style="height:45px; overflow-y:auto">
                  <h4 class="px-3">{{ dynamicObj[currentIssueSlide].issueType }}</h4>
              </div>
            </div>
              <div class="issueTypes mt-3 px-0 pt-0 ml-2 w-50">

              <h6 class="text-light bg-secondary py-1 d-block">ISSUE SEVERITY</h6>
                <div style="height:45px; overflow-y:auto">
                  <h4 class="px-3">{{ dynamicObj[currentIssueSlide].issueSeverity }}</h4>
              </div>
            </div>
            </div>
          </div>


                  <div class="col-3 mh-blue text-center text-light slideCol"  v-if="dynamicObj[currentIssueSlide] !== undefined">                                          
                      <div class="col pt-2">  
                    <i class="fas fa-calendar text-light d-block pb-1" style="font-size:2.8rem"></i>
                  <span v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].startDate" class="d-inline-block"> <h5>{{ moment(dynamicObj[currentIssueSlide].startDate).format( "DD MMM YYYY") }}</h5></span> 
                  <span v-else> -- </span>
                  - 
                    <span v-if="dynamicObj[currentIssueSlide] && dynamicObj[currentIssueSlide].dueDate" class="d-inline-block"> <h5> {{ moment(dynamicObj[currentIssueSlide].dueDate).format("DD MMM YYYY") }}</h5></span>
                    <span v-else>  </span>
                  
                </div>    
                              
                  <div class="col mt-3 truncate-line-two">
                  <i class="fas fa-users d-block text-light" style="font-size:2.8rem"></i>
                        <span class="truncate-line-two" v-if="dynamicObj[currentIssueSlide].users.length > 0"><h4> {{ dynamicObj[currentIssueSlide].userNames }}</h4></span>
                        <span v-else> <h4>No Assignments</h4></span>                                        
                </div>  

                  <div class="col" v-if="!dynamicObj[currentIssueSlide].ongoing" >                               
                                              
                  <span :class="{ 'text-light': dynamicObj[currentIssueSlide].progress <= 0 }">
                  <el-progress
                    type="circle"
                    class="py-2 text-light"                          
                    :percentage="Math.round(dynamicObj[currentIssueSlide].progress)"
                  ></el-progress>
                  </span>
                  <h4>ISSUE PROGRESS</h4>
                </div>     
              </div>   

              </div>   
              
          </div>
      
      </div>
      <div slot="footer" class="dialog-footer-left"  v-if="dynamicObj[currentIssueSlide] !== undefined">                       
          <el-button class="elBtn tagsBtn py-1 text-light mr-2" > <h5 class="d-inline px-2 text-dark">FOCUS FLAGS: </h5>
            <span
          v-if="dynamicObj[currentIssueSlide].watched == true"
          v-tooltip="`On Watch`"
          ><i class="fas fa-eye mr-1 text-dark" style="font-size:1.5rem"></i
        ></span> 
        <span
          v-if="dynamicObj[currentIssueSlide].important == true"
          v-tooltip="`Important`"
        >
          <i class="fas fa-star text-warning mr-1 " style="font-size:1.5rem"></i
        ></span> 
        <span v-if="dynamicObj[currentIssueSlide].reportable" v-tooltip="`Briefings`">
          <i class="fas fa-presentation mr-1 text-primary" style="font-size:1.5rem"></i
        ></span>                
          
          
          </el-button>
        
      </div>

      <div slot="footer" class="dialog-footer">
      <el-button class="mh-orange elBtn text-light" @click.prevent="previousTask"><i class="far fa-chevron-left" style="font-size:1.35rem"></i></el-button>
      <el-button class="bg-secondary elBtn text-light" ><span style="font-size:1.35rem"><span> ISSUE </span> {{ currentIssueSlide + 1 }} of {{ dynamicObj.length}}</span></el-button>                      
      <el-button class="mh-orange elBtn text-light"  @click.prevent="nextTask"><i class="far fa-chevron-right" style="font-size:1.35rem"></i></el-button>
      </div>
      </template>
  </el-dialog>
<div class="row py-1 pr-2">
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
            {{ issueVariation.completed.count }}
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
            {{ issueVariation.inProgress.count }}
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
            {{ issueVariation.overdue.count }}
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
            <span v-if="filteredIssues.filtered.issues">{{
            issueVariation.planned.count
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
            {{ issueVariation.onHold.count }}
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
            {{ issueVariation.issueDrafts.count }}
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
            {{ issueVariation.watched.count }}
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
            {{ issueVariation.important.count }}
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
            {{ issueVariation.briefings.count }}
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
        @click.prevent="openPresentation"
        class="btn btn-md presentBtn mr-1 mh-blue text-light"
        :disabled="filteredIssues.filtered.issues.length == 0"
    >
        <i class="fas fa-presentation"></i>
    </button>
    <button
        v-tooltip="`Export to PDF`"
        @click.prevent="exportIssuesToPdf"
        class="btn btn-md exportBtns text-light"
        :disabled="filteredIssues.filtered.issues.length == 0"
    >
        <i class="far fa-file-pdf"></i>
    </button>
    <button
        v-tooltip="`Export to Excel`"
        @click.prevent="
        exportIssuesToExcel('table', 'Program Issues')
        "
        class="btn btn-md mx-1 exportBtns text-light"
        :disabled="filteredIssues.filtered.issues.length == 0"
    >
        <i class="far fa-file-excel"></i>
    </button>
    <button
        class="btn text-light btn-md mh-orange px-1 profile-btns portfolioResultsBtn"
    >
        RESULTS: {{ filteredIssues.filtered.issues.length }}
    </button></span
    >
</div>
</div>
<!-- <ProjectContractSwitch /> -->
<div
class="row mt-3 pr-3"
style="postion:relative" 
v-if="filteredIssues.filtered.issues.length > 0"
>
<div class="px-3 tableFixHead" >
    <table
    class="table table-sm table-bordered"
    ref="table"
    id="portIssues"                   
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
      <th v-if="getShowProjectStats == 0" class="pl-1 sort-th twenty" @click="sortCol2('facilityName')">
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
      <th v-if="getShowProjectStats == 1" class="pl-1 sort-th twenty" @click="sortCol2('contractName')">
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
      <th v-if="getShowProjectStats == 2" class="pl-1 sort-th twenty" @click="sortCol2('name')">
        Nickname 
        <span
          class="inactive-sort-icon scroll"
          v-if="currentSortCol2 !== 'name'"
        >
          <i class="fas fa-sort"></i
        ></span>
        <span
          class="sort-icon main scroll"
          v-if="
            currentSortDir2 === 'asc' && currentSortCol2 === 'name'
          "
        >
          <i class="fas fa-sort-up"></i
        ></span>
        <span
          class="inactive-sort-icon scroll"
          v-if="
            currentSortDir2 !== 'asc' && currentSortCol2 === 'name'
          "
        >
          <i class="fas fa-sort-up"></i
        ></span>
        <span
          class="sort-icon main scroll"
          v-if="
            currentSortDir2 === 'desc' && currentSortCol2 === 'name'
          "
        >
          <i class="fas fa-sort-down"></i
        ></span>
        <span
          class="inactive-sort-icon scroll"
          v-if="
            currentSortDir2 !== 'desc' && currentSortCol2 === 'name'
          "
        >
          <i class="fas fa-sort-down"></i
        ></span>
      </th>                   
      <th class="pl-1 sort-th twenty" @click="sort('title')">
      Issue
      <span
          class="inactive-sort-icon scroll"
          v-if="currentSort !== 'text'"
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
      class="sort-th twenty"
      @click="sort('issueType')"
      style="min-width: 140px"
      >
      Issue Type
      <span
          class="inactive-sort-icon scroll"
          v-if="currentSort !== 'issueType'"
      >
          <i class="fas fa-sort"></i
      ></span>
      <span
          class="sort-icon scroll"
          v-if="
          currentSortDir === 'asc' &&
          currentSort === 'issueType'
          "
      >
          <i class="fas fa-sort-up"></i
      ></span>
      <span
          class="inactive-sort-icon scroll"
          v-if="
          currentSortDir !== 'asc' &&
          currentSort === 'issueType'
          "
      >
          <i class="fas fa-sort-up"></i
      ></span>
      <span
          class="sort-icon scroll"
          v-if="
          currentSortDir === 'desc' &&
          currentSort === 'issueType'
          "
      >
          <i class="fas fa-sort-down"></i
      ></span>
      <span
          class="inactive-sort-icon scroll"
          v-if="
          currentSortDir !== 'desc' &&
          currentSort === 'issueType'
          "
      >
          <i class="fas fa-sort-down"></i
      ></span>
      </th>
      <th
      class="sort-th twenty"
        style="min-width: 140px"
      @click="sort('issueSeverity')"
      >
      Issue Severity
      <span
          class="inactive-sort-icon scroll"
          v-if="currentSort !== 'issueSeverity'"
      >
          <i class="fas fa-sort"></i
      ></span>
      <span
          class="sort-icon scroll"
          v-if="
          currentSortDir === 'asc' &&
          currentSort === 'issueSeverity'
          "
      >
          <i class="fas fa-sort-up"></i
      ></span>
      <span
          class="inactive-sort-icon scroll"
          v-if="
          currentSortDir !== 'asc' &&
          currentSort === 'issueSeverity'
          "
      >
          <i class="fas fa-sort-up"></i
      ></span>
      <span
          class="sort-icon scroll"
          v-if="
          currentSortDir === 'desc' &&
          currentSort === 'issueSeverity'
          "
      >
          <i class="fas fa-sort-down"></i
      ></span>
      <span
          class="inactive-sort-icon scroll"
          v-if="
          currentSortDir !== 'desc' &&
          currentSort === 'issueSeverity'
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
      <th class="pl-1 sort-th twenty" @click="sort('taskTypeName')">
      Process Area
      <span
          class="inactive-sort-icon scroll"
          v-if="currentSort !== 'taskTypeName'"
      >
          <i class="fas fa-sort"></i
      ></span>
      <span
          class="sort-icon scroll"
          v-if="
          currentSortDir === 'asc' &&
          currentSort === 'taskTypeName'
          "
      >
          <i class="fas fa-sort-up"></i
      ></span>
      <span
          class="inactive-sort-icon scroll"
          v-if="
          currentSortDir !== 'asc' &&
          currentSort === 'taskTypeName'
          "
      >
          <i class="fas fa-sort-up"></i
      ></span>
      <span
          class="sort-icon scroll"
          v-if="
          currentSortDir === 'desc' &&
          currentSort === 'taskTypeName'
          "
      >
          <i class="fas fa-sort-down"></i
      ></span>
      <span
          class="inactive-sort-icon scroll"
          v-if="
          currentSortDir !== 'desc' &&
          currentSort === 'taskTypeName'
          "
      >
          <i class="fas fa-sort-down"></i
      ></span>
      </th>
    </thead>
    <tbody>
        <tr v-for="(issue, index) in sortedIssues" :key="index" class="portTable taskHover" @click="openIssue(issue)">
        <td v-if="issue.projectGroup">{{ issue.projectGroup }}</td>
        <td v-else>Unassigned</td>
        <td>{{ issue.facilityName || issue.contractNickname || issue.vehicleNickname }}</td>
        <td>{{ issue.title }}</td>
        <td>
         <span v-if="issue.notes.length > 0">       
          <span  class="toolTip" v-tooltip="('By: ' + issue.lastUpdate.user.fullName)" > 
          {{ moment(issue.lastUpdate.createdAt).format('DD MMM YYYY, h:mm a')}} <br>         
          </span> 
          <span class="truncate-line-five">
            {{ issue.lastUpdate.body }}
          </span>         
          </span>  
          <span v-else>No Update</span>
        </td>
   
       
        <td>{{ issue.issueType }}</td>
        <td>{{ issue.issueSeverity }}</td>
        <td class="text-center">           
            {{ moment(issue.startDate).format("DD MMM YYYY") }}
        </td>
        <td class="text-center">
           
            <span v-if="issue.completed && (issue.dueDate == null || issue.dueDate == undefined)"></span>
            <span
            v-else-if="issue.onHold && issue.dueDate == null"
            v-tooltip="`On Hold (w/no Due Date)`"
            ><i class="fas fa-pause-circle text-primary"></i
            ></span>
            <span v-else>{{
            moment(issue.dueDate).format("DD MMM YYYY")
            }}</span>
        </td>
        <td>{{ issue.userNames }}</td>
        <td class="text-center">                          
           
        
            {{ issue.progress + "%" }}
          
        </td>
        <td class="text-center">
            <span v-if="issue.isOverdue" v-tooltip="`Overdue`">
            <i class="fas fa-calendar text-danger mr-1"></i
            ></span>
            <span v-if="issue.completed" v-tooltip="`Completed`"
            ><i
                class="fas fa-clipboard-check text-success mr-1"
            ></i
            ></span>
           
           
            <span
            v-if="issue.onHold == true"
            v-tooltip="`On Hold`"
            >
            <i class="fas fa-pause-circle mr-1 text-primary"></i
            ></span>
            <span v-if="issue.draft == true" v-tooltip="`Draft`">
            <i class="fas fa-pencil-alt mr-1 text-warning"></i
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
            v-if="issue.inProgress"
            v-tooltip="`In Progress`"
            >
            <i class="far fa-tasks text-primary mr-1"></i
            ></span>

        </td>
        <td>
          <span v-if="issue.taskTypeName">{{
            issue.taskTypeName
          }}</span>
          <span v-else> --- </span>
        </td>
        </tr>
    </tbody>
    </table>
      
       <table
        class="table table-bordered w-100"
        id="portIssues1"     
        style="display:none"          
        >
         <thead>      
        <tr style="background-color:#ededed">
            <th>Issue</th>
            <th>Issue Type</th>
            <th>Project</th>
            <th>Issue Severity</th>
            <th>Start Date</th>
            <th>Due Date</th>
            <th>Assigned Users</th>
            <th>Progress</th>
            <th>Flags</th>
            <th>Last Update</th>
        </tr>
          <tr></tr>
      </thead>
      <tbody v-for="(p, i) in validIssuesProjectGroups" :key="i">  
        <tr class="text-center">  <th scope="row">{{ p }}</th></tr>
           <tr v-for="(issue, index) in filteredIssues.filtered.issues" :key="index" v-if="issue.projectGroup == p">            
              <td>{{ issue.title }}</td>
              <td>{{ issue.issueType }}</td>
              <td>{{ issue.facilityName }}</td>
              <td>{{ issue.issueSeverity }}</td>
               <td>
                    {{ moment(issue.startDate).format("DD MMM YYYY") }}
                  </td>
                  <td>
                    <span
                      v-if="issue.onHold && issue.dueDate == null"
                      v-tooltip="`On Hold (w/no Due Date)`"
                      ><i class="fas fa-pause-circle text-primary"></i
                    ></span>
                    <span v-else-if="issue.completed && (issue.dueDate == null || issue.dueDate == undefined)"></span>
                    <span v-else
                      >{{ moment(issue.dueDate).format("DD MMM YYYY") }}
                    </span>
                  </td>
                  <td>{{ issue.userNames }}</td>
                  <td>{{ issue.progress + "%" }}</td>
                  <td class="text-center">
                    <span v-if="issue.isOverdue" v-tooltip="`Overdue`">
                      Overdue
                    </span>
                    <span v-if="issue.completed" v-tooltip="`Completed`">
                      Completed</span>
                    <span
                      v-if="issue.onHold == true"
                      v-tooltip="`On Hold`"
                    >
                     On Hold
                    </span>
                    <span v-if="issue.draft == true" v-tooltip="`Draft`">
                     Draft
                     </span>
                 
                    <span v-if="issue.planned" v-tooltip="`Planned`">
                      Planned
                     </span>
                    <span
                      v-if="issue.inProgress"
                      v-tooltip="`In Progress`"
                    >
                     In Progress
                    </span>
                  </td>
                    <td>
                    <span v-if="issue.notes.length > 0">       
                    <span  class="toolTip" v-tooltip="('By: ' + issue.lastUpdate.user.fullName)" > 
                    {{ moment(issue.lastUpdate.createdAt).format('DD MMM YYYY, h:mm a')}} <br>         
                    </span> 
                    <span class="truncate-line-five">
                      {{ issue.lastUpdate.body }}
                    </span>         
                    </span>  
                    <span class="text-left" v-else>No Update</span>
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
      v-for="item in getIssuesPerPageOptions"
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
        filteredIssues.filtered.issues.length / this.C_issuesPerPage.value
        )
    }}
    </button>
    <button class="btn btn-sm page-btns" @click="nextPage">
    <i class="fas fa-angle-right"></i>
    </button>
</div>
</div>
<!-- <div v-else-if="!portfolioTasksLoaded" class="load-spinner spinner-bordeC_issuesPerPager"></div> -->
<div v-else class="mt-5">NO RESULTS TO DISPLAY

    
</div>
</div>
</template>

<script>

import {mapGetters, mapMutations, mapActions} from 'vuex'
// import ProjectContractSwitch from "./ProjectContractSwitch.vue"
import { jsPDF } from "jspdf";
import "jspdf-autotable";

export default {
  name: "ProgramIssues",
  // components:{ ProjectContractSwitch },
  data() {
    return {
      showLess: "Show More",
      showMore: true,
      search_issues: 'tet',
      today: new Date().toISOString().slice(0, 10),
      currentSort: "title",  
      dialogVisible: false,
      currentIssueSlide: 0, 
      dynamicObj: {},
      currentSortCol1: "projectGroup",
      currentSortCol2: "facilityName",
      // currentSortIssueRisk: "title",
      currentSortDir: "asc",
      currentSortDir1: "asc",
      currentSortDir2: "asc",
      facility_project_ids:[],
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
    'searchIssues',
    'getShowProjectStats',
    'currIssuePage',
    "lessonsLoaded",
    "projectLessons",
    'programCategoriesFilter',
    "programLessons",
    'projects',
    'projectGroupsFilter',
    "facilities",
    "facilityCount",
    "facilityGroupFacilities",
    "facilityProgress",
    "filterDataForAdvancedFilter",
    "filteredAllIssues",
    "filteredAllContractIssues",
    "filteredAllVehicleIssues",
    "filteredAllRisks",
    "filteredAllTasks",
    "filteredFacilities",
    "filteredFacilityGroups",
    "getAllFilterNames",
    "getFilterValue",
    "getTaskIssueUserFilter",
    "getIssuesPerPage",
    'getIssuesPerPageOptions',
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
    'getTasksPerPage',
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
    C_programCategoryFilter: {
      get() {
        return this.programCategoriesFilter;
      },
      set(value) {
        // console.log(value)
        this.setProgramCategoriesFilter(value);
      },
    },
    stateIssues(){
      if(this.getShowProjectStats == false){
        return this.filteredAllIssues
      } else return this.filteredAllContractIssues
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
  validIssuesProjectGroups(){
      let name = this.filteredIssues.filtered.issues;
      return _.uniq(name.map(item => item.projectGroup))      
    },
    C_issuesPerPage: {
        get() {
          return this.getIssuesPerPage || {id: 15, name: '15', value: 15}
        },
        set(value) {
          this.setIssuesPerPageFilter(value)
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
        return this.currIssuePage
      },
      set(value) {
        this.setCurrIssuePage(value);
      },
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
    filteredIssues() {
    let allIssues = this.filteredAllIssues
     if (this.getShowProjectStats == 1){
       allIssues = this.filteredAllContractIssues
     }
     if (this.getShowProjectStats == 2){
       allIssues = this.filteredAllVehicleIssues
     }
     let issues = allIssues.filter(issue => {
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
       return this.facility_project_ids.includes(issue.facilityProjectId)
      } else return true
       }).filter((issue) => {
          if (this.searchIssues !== "" && issue && issue.title) {
            // console.log(issue)
            return (
              issue.title.toLowerCase().match(this.searchIssues.toLowerCase()) ||
              issue.issueType
                .toLowerCase()
                .match(this.searchIssues.toLowerCase()) ||
              issue.projectGroup
                .toLowerCase()
                .match(this.searchIssues.toLowerCase()) ||
              // issue.facilityName
              //   .toLowerCase()
              //   .match(this.searchIssues.toLowerCase()) ||
              issue.userNames.toLowerCase().match(this.searchIssues.toLowerCase())
            );
          } else return true;
          // Filtering 7 Task States
        })
        .filter((issue) => {
          if (this.programCategoriesFilter && this.programCategoriesFilter.length > 0) {
           let category = this.programCategoriesFilter.map((t) => t.id);
            return category.includes(issue.taskTypeId);
          } else return true;
        })  
       return {
       unfiltered: {
            issues
            },
       filtered: {
         issues:  issues.filter(t => {
        if (this.getHideOverdue == true) {          
         return t.isOverdue == false
       } else return true

      }).filter(t => {
      if (this.getHideComplete == true) { 
        return t.completed == false
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
    sortedIssues:function() {
        return this.filteredIssues.filtered.issues.sort((a,b) => {
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
           let start = (this.currentPage-1)*this.C_issuesPerPage.value;
          let end = this.currentPage*this.C_issuesPerPage.value;
          if(index >= start && index < end) return true;
          return this.end
        });
    },
    
     issueVariation() {
     let planned = _.filter(
        this.filteredIssues.unfiltered.issues,
        (t) => t && t.planned == true    
      );     
      let issueDrafts = _.filter(
        this.filteredIssues.unfiltered.issues,
         (t) => t && t.draft == true 
      );  
      let important = _.filter(
      this.filteredIssues.unfiltered.issues,
          (t) => t && t.important
      );
      let briefings = _.filter(
      this.filteredIssues.unfiltered.issues,
          (t) => t && t.reportable
      ); 
      let watched = _.filter(
      this.filteredIssues.unfiltered.issues,
          (t) => t && t.watched 
      );        
      let completed = _.filter(
        this.filteredIssues.unfiltered.issues,
        (t) => t && t.completed == true
      );
      let completed_percent = this.getAverage(
        completed.length,
        this.filteredIssues.unfiltered.issues.length
      ); 
       let inProgress = _.filter(
        this.filteredIssues.unfiltered.issues,
        (t) => t && t.inProgress == true 
        );
      let onHold = _.filter(
        this.filteredIssues.unfiltered.issues,
        (t) => t && t.onHold == true 
      );
      let inProgress_percent = this.getAverage(
        inProgress.length,
        this.filteredIssues.unfiltered.issues.length
      );
      let overdue = _.filter(this.filteredIssues.unfiltered.issues, (t) => t && t.isOverdue);
      let overdue_percent = this.getAverage(
        overdue.length,
        this.filteredIssues.unfiltered.issues.length
      );
      return {
        planned: {
          count: planned.length,          
        },
        onHold: {
          count: onHold.length,          
        },
        issueDrafts: {
          count: issueDrafts.length,          
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
        'setPortfolioTab',
        'setCurrIssuePage',
        'setOnWatchFilter',
        'setToggleRACI',
        'setShowAdvancedFilter',
        'setTaskForManager',
        'setShowCount',
          // Used in Program Viewer
        'setIssuesPerPageFilter',
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
   openIssue(issue) {   
    if (this.getShowProjectStats == 0){
      this.$router.push({
        name: "ProgramIssueForm",
        params: {
          programId: issue.projectId,
          projectId: issue.facilityId,
          issueId: issue.id,
        },
        });
      }    
      if (this.getShowProjectStats == 1){
        this.$router.push({
          name: "ProgramContractIssueForm",
          params: {
          programId: this.$route.params.programId,
          contractId: issue.projectContractId,
          issueId: issue.id,
          },
          });
        }  
        if (this.getShowProjectStats == 2){
        this.$router.push({
          name: "ProgramVehicleIssueForm",
          params: {
          programId: this.$route.params.programId,
          vehicleId: issue.projectContractVehicleId,
          issueId: issue.id,
          },
          });
        }      
    },
  exportIssuesToPdf() {
      const doc = new jsPDF("l");
       console.log( this.$refs.table)
      const html = this.$refs.table.innerHTML;
   
      doc.autoTable({ 
        html: "#portIssues1",       
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
      doc.save("Program_Issues_Log.pdf");
    },
    exportIssuesToExcel(table, name) {
      if (!table.nodeType) table = this.$refs.table;
      var ctx = { worksheet: name || "Worksheet", table: table.innerHTML };
      window.location.href =
        this.uri + this.base64(this.format(this.template, ctx));
    },
    openPresentation(){
      this.dialogVisible = true; 
      this.currentIssueSlide = 0 
      this.dynamicObj = this.filteredIssues.filtered.issues
      },
    nextTask(){
      this.isSlidingToPrevious = false
      if(this.currentIssueSlide == this.dynamicObj.length-1){
          this.currentIssueSlide = 0;
      }else{
          this.currentIssueSlide += 1;
      }
    },
    previousTask(){ 
        this.isSlidingToPrevious = true
        if(this.currentIssueSlide == 0){
            this.currentIssueSlide = this.dynamicObj.length-1;
        }else{
            this.currentIssueSlide-=1;
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
      // console.log(e)
    },
    handleClick(tab, event) {
        // console.log(tab, event);
    },
   nextPage:function() {
      if((this.currentPage*this.C_issuesPerPage.value) < this.filteredIssues.filtered.issues.length) this.currentPage++;
    },
    prevPage:function() {
      if(this.currentPage > 1) this.currentPage--;
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
