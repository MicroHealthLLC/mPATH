<template>
 <div class="my-1 pb-2 buttonWrapper container-fluid">
  <div class="row px-0 mb-2">
     <div class="col">
        <el-input
          type="search"          
          placeholder="Search Contracts"
          aria-label="Search"            
          aria-describedby="search-addon"    
          v-model="search"
          data-cy=""
      >
         <el-button slot="prepend" icon="el-icon-search"></el-button>    
        </el-input>    
     </div> 
       <div class="col pl-0">
         <el-select
          class="w-100 mx-2"
          v-model="C_projectGroupFilter" 
          track-by="id"
          value-key="id"
          multiple
          filterable
          clearable
          name="Project Group"         
          placeholder="Filter Contracts By Group"
          >
          <el-option
          v-for="item in facilityGroups"
          :key="item.id"
          :label="item.name"
          :value="item">
          </el-option>          
          </el-select>
       </div>
  </div>  
  <div
    v-if="tableData"
    v-loading="!contentLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.8)"
   >
   <hr class="mt-2 mb-0">
   <el-table 
    :data="tableData.filter(data => !search || data.nickname.toLowerCase().includes(search.toLowerCase())).reverse()" 
    height="500"
    stripe
    style="width:100%" 
    >
    <el-table-column 
      prop="projectCode"  
      sortable  
      label="Project Code"
      width="120"
      fixed  
      > 
      <template slot-scope="scope">
        {{ scope.row.projectCode }}
        <!-- <el-input size="small"
          style="text-align:center"
          v-model="scope.row.projectCode" controls-position="right">
        </el-input> -->
      </template>
    </el-table-column>   
    <el-table-column 
      prop="nickname"  
      sortable  
      width="200"
      fixed  
      label="Contract Nickname"
      > 
       <template slot-scope="scope">

         {{ scope.row.nickname }}
          <!-- <el-input size="small"
            style="text-align:center"
            v-model="scope.row.nickname" controls-position="right"></el-input> -->
       </template>
    </el-table-column>
    <!-- TYPE -->
    <el-table-column 
      prop="contractClassification"  
      sortable  
      label="Type" 
      width="200"
      > 
       <template slot-scope="scope">
          <!-- <el-input size="small"
            style="text-align:center"
            v-if="scope.row.contractClassification && scope.row.contractClassification !== null && scope.row.contractClassification.name"
            v-model="scope.row.contractClassification.name" controls-position="right">
          </el-input> -->
            <span 
              v-if="scope.row.contractClassification &&
               scope.row.contractClassification.name && 
                scope.row.contractClassification.name !== 'undefined'
               ">
               {{ scope.row.contractClassification.name }}
            </span>
           <span v-else> <i> Not Available </i> </span>
       </template>
    </el-table-column>
    <!-- STATUS      -->
    <el-table-column sortable prop="contractStatus"  label="Status" width="200"> 
       <template slot-scope="scope">
          <!-- <el-input size="small"
            style="text-align:center"
            v-if="scope.row.contractStatus && scope.row.contractStatus !== null && scope.row.contractStatus.name"
            v-model="scope.row.contractStatus.name" controls-position="right"></el-input> -->
              <span v-if="scope.row.contractStatus && scope.row.contractStatus.name && scope.row.contractStatus.name !== 'undefined'">
             {{ scope.row.contractStatus.name }} 
            </span>
           <span v-else> <i> Not Available </i> </span>
       </template>
    </el-table-column>
    <!-- CONTRACT NAME -->
    <el-table-column prop="name"  sortable  label="Contract Name" width="200"> 
       <template slot-scope="scope">
          <!-- <el-input size="small"
            style="text-align:center"
            v-if="scope.row.name"
            v-model="scope.row.name" controls-position="right"></el-input>
            <span v-else> <i> Edit in Program Settings </i> </span> -->
             <span v-if="scope.row.name && scope.row.name !== 'null'">
               {{ scope.row.name }} 
            </span>
           <span v-else> <i> Not Available </i> </span>
       </template>
    </el-table-column>
    <!-- CUSTOMER (AGENCY) -->
    <el-table-column prop="contractCustomer.name"  sortable  label="Customer (Agency)" width="200"> 
       <template slot-scope="scope">
          <!-- <el-input size="small"
            style="text-align:center"
            v-if="scope.row.contractCustomer && scope.row.contractCustomer !== null && scope.row.contractCustomer.name"
            v-model="scope.row.contractCustomer.name" controls-position="right">
          </el-input> -->
             <span  v-if="scope.row.contractCustomer && scope.row.contractCustomer.name !== 'undefined' && scope.row.contractCustomer.name">
                {{ scope.row.contractCustomer.name }}
            </span>
           <span v-else> <i> Not Available </i> </span>
       </template>
    </el-table-column>
       <!-- CUSTOMER ENTITY -->
        <el-table-column prop="contractClientType.name"  sortable  label="Customer Entity" width="200"> 
       <template slot-scope="scope">
          <!-- <el-input size="small"
            style="text-align:center"
            v-if="scope.row.contractCustomer && scope.row.contractCustomer !== null && scope.row.contractCustomer.name"
            v-model="scope.row.contractCustomer.name" controls-position="right">
          </el-input> -->
             <span  v-if="scope.row.contractClientType && scope.row.contractClientType.name !== 'undefined' && scope.row.contractClientType.name">
                {{ scope.row.contractClientType.name }}
            </span>
           <span v-else> <i> Not Available </i> </span>
       </template>
    </el-table-column>
    <!-- VEHICLE -->
    <el-table-column prop="contractVehicle.name"  sortable  label="Vehicle" width="200"> 
       <template slot-scope="scope">
          <!-- <el-input size="small"
            style="text-align:center"
            v-if="scope.row.contractVehicle && scope.row.contractVehicle.name && scope.row.contractVehicle !== null"
            v-model="scope.row.contractVehicle.name" controls-position="right"></el-input>
             <span v-else> <i> Edit in Program Settings </i> </span> -->
            <span  v-if="scope.row.contractVehicle && scope.row.contractVehicle.name && scope.row.contractVehicle.name !== 'undefined'">
               {{ scope.row.contractVehicle.name }} 
            </span>
           <span v-else> <i> Not Available </i> </span>

       </template>
    </el-table-column>
    <!-- COMMERCIAL / FEDERAL -->
     <!-- <el-table-column prop=""
          sortable 
          label="Commercial/Federal"
          width="200"
          >     
    </el-table-column> -->
    <!-- PRIME IDIQ -->
    <el-table-column prop="contractVehicleNumber.name"
          sortable 
          label="Pime IDIQ/Vehicle Contract Number"
          width="230"
          > 
       <template slot-scope="scope">
          <!-- <el-input size="small"
            style="text-align:center"
            v-if="scope.row.contractVehicleNumber && scope.row.contractVehicleNumber.name && scope.row.contractVehicleNumber !== null"
            v-model="scope.row.contractVehicleNumber.name" controls-position="right"></el-input>
            <span v-else> <i> Edit in Program Settings </i> </span> -->

            <span  v-if="scope.row.contractVehicleNumber && scope.row.contractVehicleNumber.name && scope.row.contractVehicleNumber.name !== 'undefined'">
                {{ scope.row.contractVehicleNumber.name }} 
            </span>
           <span v-else> <i> Not Available </i> </span>

       </template>
    </el-table-column>
    <!-- PRIME CONTRACT NUMBER -->
    <el-table-column 
          prop="contractPrime.name"  
          sortable  
          label="Pime Contract Number/Task Order/PO Number"
          width="230"
          > 
       <template slot-scope="scope">
          <!-- <el-input size="small"
            style="text-align:center"
            v-if="scope.row.contractPrime && scope.row.contractPrime.name && scope.row.contractPrime !== null"
            v-model="scope.row.contractPrime.name" controls-position="right"></el-input>
           <span v-else> <i> Edit in Program Settings </i> </span> -->

            <span    v-if="scope.row.contractPrime && scope.row.contractPrime.name && scope.row.contractPrime.name !== 'undefined'">
              {{ scope.row.contractPrime.name }} 
            </span>
           <span v-else> <i> Not Available </i> </span>
           
       </template>
    </el-table-column>
   
    <!-- SUBCONTRACT NUMBER -->
    <el-table-column 
          prop="subcontractNumber.name"  
          sortable  
          label="Subcontract Number/PO Number"
          width="230"
          > 
       <template slot-scope="scope">
          <!-- <el-input size="small"
            style="text-align:center"
            v-if="scope.row.subcontractNumber && scope.row.subcontractNumber.name && scope.row.subcontractNumber !== null"
            v-model="scope.row.subcontractNumber.name" controls-position="right"></el-input>
          <span v-else> <i> Edit in Program Settings </i> </span> -->

             <span v-if="scope.row.subcontractNumber && scope.row.subcontractNumber.name && scope.row.subcontractNumber.name !== 'undefined'">
              {{ scope.row.subcontractNumber.name }} 
            </span>
           <span v-else> <i> Not Available </i> </span>
       </template>
    </el-table-column>

     <!-- GOVERNEMNT / CLIENT -->
     <!-- <el-table-column prop=""
      sortable 
      label="Government/Client"
      width="200"
      >     
    </el-table-column> -->
   <!-- PRIME-->
     <el-table-column 
      prop="" 
      sortable 
      filterable 
      label="Prime"
      width="230"     
      >     
       <template slot-scope="scope">
          <!-- <el-input size="small"
            style="text-align:center"
            v-if="scope.row.subcontractNumber && scope.row.subcontractNumber.name && scope.row.subcontractNumber !== null"
            v-model="scope.row.subcontractNumber.name" controls-position="right"></el-input>
          <span v-else> <i> Edit in Program Settings </i> </span> -->

             <span v-if="scope.row.contractPrime && scope.row.contractPrime.name && scope.row.contractPrime.name !== 'undefined'">
              {{ scope.row.contractPrime.name }} 
            </span>
           <span v-else> <i> Not Available </i> </span>
       </template>
    </el-table-column>
  <!-- TOTAL Number of Subcontracts to MH-->
     <el-table-column 
      prop="" 
      sortable 
      filterable 
      label="Total Number of Subcontracts"
      width="150"     
      >    
        <template slot-scope="scope">
        <span  v-if="scope.row.totalSubcontracts">
          {{scope.row.totalSubcontracts }} 
        </span>
        <span v-else></span> 
        </template>

    </el-table-column>
  <!-- Contract Start-->
     <el-table-column 
      prop="startDate"  
      sortable  
      width="200"
      label="Contract Start"
      > 
       <template slot-scope="scope">
        <span  v-if="scope.row.startDate">
          {{ moment(scope.row.startDate).format('MM/DD/YYYY') }} 
        </span>
        <span v-else></span>
       </template>
      
    </el-table-column>
      <!-- Contract End-->
     <el-table-column 
      prop="endDate"  
      sortable  
      width="200"
      label="Contract End"
      > 
       <template slot-scope="scope">
        <span  v-if="scope.row.endDate">
            {{ moment(scope.row.endDate).format('MM/DD/YYYY') }} 
        </span>
        <span v-else></span>
       </template>
       
    </el-table-column>
   <!-- Current PoP-->
     <el-table-column 
      prop="contractCurrentPop"  
      sortable  
      width="200"
      label="Current PoP"
      > 
       <template slot-scope="scope">
          <!-- <el-input size="small"
            style="text-align:center"
             v-if="scope.row.contractCurrentPop && scope.row.contractCurrentPop.name && scope.row.contractCurrentPop !== null"
            v-model="scope.row.contractCurrentPop.name" controls-position="right"></el-input> -->
              <span  v-if="scope.row.contractCurrentPop && scope.row.contractCurrentPop.name && scope.row.contractCurrentPop.name !== 'undefined'">
               {{  scope.row.contractCurrentPop.name }} 
            </span>
           <span v-else> <i> Not Available </i> </span>
       </template>
       
    </el-table-column>
     <!-- Start-->
     <el-table-column 
      prop="currentPopStartTime"  
      sortable  
      width="230"
      label="Current PoP Start"
      > 
       <template slot-scope="scope">
          <span v-if="scope.row.currentPopStartTime">
            {{ moment(scope.row.currentPopStartTime).format('MM/DD/YYYY') }} 
          </span>
          <span v-else></span>
       </template>
    </el-table-column>
      <!-- End-->
     <el-table-column 
      prop="currentPopEndTime"  
      sortable  
      width="230"
      label="Current PoP End"
      > 
       <template slot-scope="scope">
          <span v-if="scope.row.currentPopEndTime">
           {{  moment(scope.row.currentPopEndTime).format('MM/DD/YYYY') }}
          </span>
          <span v-else></span>
       </template>
    </el-table-column>
    <!--Days Remaining-->
     <el-table-column 
      prop="daysRemaining"  
      sortable  
      width="200"
      label="Days Remaining"
      > 
       <template slot-scope="scope">
          <!-- <el-input size="small"
            style="text-align:center"
            v-model="scope.row.daysRemaining" controls-position="right"></el-input> -->
        {{scope.row.daysRemaining }}
       </template>
    </el-table-column>
    <!--Total Contract Value-->
     <el-table-column 
      prop="totalContractValue"  
      sortable  
      width="200"
      label="Total Contract Value"
      > 
       <template slot-scope="scope">
          <!-- <el-input size="small"
            style="text-align:center"
            v-model="scope.row.totalContractValue" controls-position="right"></el-input> -->
            ${{ scope.row.totalContractValue }}
       </template>
    </el-table-column>
     <!--Current PoP Value-->
     <el-table-column 
      prop="currentPopValue"  
      sortable  
      width="200"
      label="Current PoP Value"
      > 
       <template slot-scope="scope">
          <!-- <el-input size="small"
            style="text-align:center"
            v-model="scope.row.currentPopValue" controls-position="right"></el-input> -->
         ${{ scope.row.currentPopValue }}

       </template>
    </el-table-column>
     <!--Total PoP Funded-->
     <el-table-column 
      prop="currentPopFunded"  
      sortable  
      width="200"
      label="Total PoP Funded"
      > 
       <template slot-scope="scope">
          <!-- <el-input size="small"
            style="text-align:center"
            v-model="scope.row.currentPopValue" controls-position="right"></el-input> -->
         ${{ scope.row.currentPopFunded }}

       </template>
    </el-table-column>
      <!--Total Funded To Date-->
     <el-table-column 
      prop="totalContractFunded"  
      sortable  
      width="200"
      label="Total Funded To Date"
      > 
       <template slot-scope="scope">
          <!-- <el-input size="small"
            style="text-align:center"
            v-model="scope.row.totalContractFunded" controls-position="right"></el-input> -->
           ${{ scope.row.totalContractFunded }}
       </template>
    </el-table-column>
    <!--Notes-->
     <el-table-column 
      prop="notes" 
      filterable 
      label="Notes"
      width="300"     
      >     
       <template slot-scope="scope">
        <span class="truncate-line-five">
          {{ scope.row.notes }}
        </span>
       </template>
    </el-table-column>
    <el-table-column 
      prop="facilityGroupId" 
      sortable 
      filterable 
      label="Group"
      width="230"     
      >
      <template slot-scope="scope">
        <span v-if="groupsArr">
            {{ groupsArr.find( g => g.id == scope.row.facilityGroupId).name  }}
        </span>
        
       </template>
    </el-table-column>

     <el-table-column 
      label="Actions"     
      width="300"      
      >
        <template slot-scope="scope">
          <!-- THESE COMMENTED OUT  BUTTONS ARE FOR CRUD OPERATIONS -->
        <!-- <el-button
          type="default"  
           class="bg-primary text-light"     
        >
        <i class="far fa-save"></i>
        </el-button>   
        <el-button
          type="default" 
          class="bg-secondary text-light"      
        >
        <i class="far fa-cog"></i>
        </el-button>    -->
    
        <el-button
          v-tooltip="`Go to Contract`"
          type="default"       
          @click.prevent="goToContract(scope.$index, scope.row)"
          class="bg-light"
        >
         <i class="far fa-file-contract mh-orange-text" style="font-size:1rem"></i> 
        <i class="fas fa-arrow-alt-circle-right ml-1 text-success"></i>
        </el-button>   
        </template>
    </el-table-column>  
   </el-table>   
  </div>
   <span v-else class="mt-5">
      NO DATA TO DISPLAY   
   </span>
</div>

</template>

<script>

import { mapGetters, mapMutations, mapActions } from "vuex";
export default {
  name: "ProgramContractsSheet",
  data() {
    return {
      currentFacility: {},
      // currentContract: {},
      dialogVisible: false,
      currentFacilityGroup: {},
      projectNameText: '',
      search: '',
      hideSaveBtn: false,
      contractNameText: '',
      expanded: {
        id: "",
      },
    };
  },
  methods: {
   ...mapMutations([
     'setProjectGroupFilter', 
     'setContractTable', 
     'setEditContractSheet',
     'setGroupFilter', 
     'SET_EDIT_CONTRACT_SHEET',
     'SET_CONTRACT_STATUS',
     'setContractTypeFilter',
     'setNewContractGroupFilter',
     'SET_CONTRACT_GROUP_TYPES'
     ]), 
   ...mapActions([]),
    _isallowed(salut) {
        let pPrivilege = this.$programPrivileges[this.$route.params.programId]        
        let permissionHash = {"write": "W", "read": "R", "delete": "D"}
        let s = permissionHash[salut]
        return pPrivilege.contracts.includes(s);     
      },
    goToContract(index, rows){        
      //Needs to be optimzed using router.push.  However, Project Sidebar file has logic that affects this routing
      this.$router.push({
        name: "SheetContract",
        params: {
          programId: this.$route.params.programId,
          contractId: rows.id.toString(),          
        },
      });
    
    },
    editContract(){
      if(this.editContractSheet == false){
        console.log(this.editContractSheet)
        this.SET_EDIT_CONTRACT_SHEET(!this.editContractSheet)
          console.log(this.editContractSheet)
      } else return
    },
    saveContract() {
      if(this.editContractSheet == true){
        console.log(this.editContractSheet)
       this.SET_EDIT_CONTRACT_SHEET(!this.editContractSheet)
          console.log(this.editContractSheet)
      } else return
    //  TO DO: Write logic to listen for onchange event.  If nothing edited, use default value
    //  if (rows && rows !== undefined) {
        let id = rows.id;
        let contractData = {
          contract: {
            nickname: rows.nickname,
            facility_group_name: rows.facilityGroupName,  
            facility_group_id: rows.facilityGroupId,  
            project_id: this.$route.params.programId,
            id:  id    
          }
        }
         this.updateContract({
            ...contractData, id
          })
    },
    addAnotherContract() {
         this.C_projectGroupFilter = null;
         this.contractNameText = "";
         this.hideSaveBtn = false;  
    },
    closeAddContractBtn() {
        this.dialogVisible = false;
        this.hideSaveBtn = false;
    },
    addContract(){
      this.dialogVisible = true;    
      this.C_projectGroupFilter = null;
      this.contractNameText = ""  
    },
  },
  computed: {
    ...mapGetters([
      "contentLoaded",
      "contractsLoaded",
      "getContractGroupTypes",
      'getNewContractGroupFilter',
      "contractStatus",
      'getContractGroupOptions',
      "contracts",
      'editContractSheet',
      'getContractTable',
      'getProjectGroupFilter',
      'getGroupFilter',
      'facilityGroups',
      'currentProject'
    ]), 
    tableData(){
      if(this.currentProject &&
         this.currentProject.contracts.length > 0 
         ){
      let programContracts = this.currentProject.contracts.filter(t => t.projectId == this.$route.params.programId)
      let contractData = programContracts.map(t => t)
      .filter((td) => {
        //  console.log(td)
          if (this.C_projectGroupFilter && this.C_projectGroupFilter.length > 0 ) {
            let group = this.C_projectGroupFilter.map((t) => t.id);
            return group.includes(td.facilityGroupId);
           
          } else return true;
        });
       return contractData
      }    
   },
   groupsArr(){
      if (this.currentProject && this.currentProject.facilityGroups.length > 0 ){   
       return this.currentProject.facilityGroups
      }    
   },
    C_typeFilter: {
        get() {
          return this.getContractGroupTypes
        },
        set(value) {
          this.SET_CONTRACT_GROUP_TYPES(value)
        }      
      },
    // Filter when adding new Project
     C_projectGroupFilter: {
       get() {
        return this.getGroupFilter;
      },
      set(value) {
        // console.log(value)
        this.setGroupFilter(value);
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
  font-size: .85rem;
  word-break: normal;
}
td, th {
  overflow-wrap: break-word !important;
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
  font-size: 16px !important;
}
/deep/.hover-row .el-input .el-input__inner{
  border-style:solid;   
}
/deep/.el-dialog {
  width:30%;
  border-top: solid 5px  #1D336F !important;
}
/deep/.el-table {
  .el-input__inner { 
  font-size: 16px !important;
  }
}
/deep/.el-dialog__close.el-icon.el-icon-close {
  background-color: #DC3545;
    border-radius: 50%;
    color: white;
    padding: 2px;
    font-size: .7rem;
}
.light {
  background-color: lightgray;
  color: lightgray;
}
.overflowX {
  overflow-x: scroll !important;
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
</style>