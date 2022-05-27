<template>
  <div class="container-fluid mt-3 mx-3">       
    <div style="height:85px">
      <span @click.prevent="backHomeBtn">
        <img
          class="mb-2"
          style="width: 147px;cursor:pointer"
          :src="require('../../../../../assets/images/microhealthllc.png')"
        />
        <!-- <h3 class="d-inline mt-1 programName">{{ this.$portfolio_heading }}</h3> -->
      </span>
      <span class="float-right mr-4">
        <button
          class="portfolioHomeBtn mh-orange btn btn-sm"
          style="cursor: pointer"
          @click.prevent="backHomeBtn"
        >
          <i class="fas fa-home text-light"></i>
        </button>
      </span>
    </div>

  <el-tabs :tab-position="tabPosition" type="border-card"  class="bottomTabs"  @tab-click="handleClick">
    <el-tab-pane label=""
    v-loading="!contractVehiclesLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    >
     <span slot="label"> <i class="fa-solid fa-car mr-1" :class="[ pane0? 'mh-green-text' : 'txt-secondary']"></i>
     VEHICLES
     </span>
      <PortfolioVehicles/>
    </el-tab-pane>
    
    <el-tab-pane
    v-loading="!contractProjectsLoaded"
    element-loading-text="Fetching your data. Please wait..."
    element-loading-spinner="el-icon-loading"
    >
     <span slot="label"> <i class="far fa-file-contract mr-1" :class="[ pane1? 'mh-orange-text' : 'txt-secondary']"></i>CONTRACT DETAILS</span>
    <div style="height:80vh" class="portfolio-contracts-module">
      <div  style="height: 100%; overflow-y:auto">
    <el-table
    :data="tableData"
    border
    height="800"
    style="width: 95%">
    <el-table-column
      fixed
      label="Code"
      width=""
      prop="charge_code">
      <template slot-scope="scope">
        <el-input
          size="small"
          v-if="scope.$index == createRow"
          class="p-0"
          style="text-align:center"
          v-model="scope.row.charge_code"
          controls-position="right"
        ></el-input>
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
        <el-input
          size="small"
          style="text-align:center"
          class="p-0"
          v-model="scope.row.charge_code"
          controls-position="right"
          ></el-input>
        </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
        {{ scope.row.charge_code }} 
        </span>
        </template>
    </el-table-column>
    <el-table-column
      fixed
      label="Project Name"
      width="200"
      prop="name">
      <template slot-scope="scope">
        <el-input
          size="small"
          v-if="scope.$index == createRow"
          style="text-align:center"
          v-model="scope.row.name"
          controls-position="right"
        ></el-input>
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
        <el-input
          size="small"
          style="text-align:center"
          v-model="scope.row.name"
          controls-position="right"
          ></el-input>
        </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
        {{ scope.row.name }} 
        </span>
        </template>
     </el-table-column>
     <el-table-column    
      label="Customer"
      width="200"
      prop="contract_customer_id">
     <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.contract_customer_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        placeholder=""
        clearable
        allow-create
        default-first-option
        >
        <el-option
          v-for="item in customerOptions"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow 
      && (scope.row.contract_customer && scope.row.contract_customer.name !== null)">
      {{ scope.row.contract_customer.name }}
      </span>
      </template>
    </el-table-column>
      <el-table-column    
      label="Vehicle/ Schedule"
      width="125"
      prop="contract_vehicle">
       <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.contract_vehicle_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        placeholder=""
        default-first-option
       >
        <el-option
          v-for="item in vehicleOptions"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow && 
      (scope.row.contract_vehicle && scope.row.contract_vehicle.name !== null)">
      {{ scope.row.contract_vehicle.name }}
      </span>
      </template>
    </el-table-column>
      <el-table-column
      label="Contract #"
      width="125"
      prop="number">
    <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.number"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        placeholder=""
        clearable
        allow-create
        default-first-option
      >
        <el-option
          v-for="item in contractNumber"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow &&
       (scope.row.number && scope.row.number.name !== null)">
      {{ scope.row.number }}
      </span>
      </template>
    </el-table-column>
    <el-table-column
      label="Award/TO #"
      width="125"
      prop="contract_award_to_id">
       <template slot-scope="scope" >
     <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.contract_award_to_id"
        filterable       
        track-by="id" 
        placeholder=""       
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
      >
        <el-option
          v-for="item in awardToNums"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow &&
        (scope.row.contract_award_to && scope.row.contract_award_to.name !== null)">
      {{ scope.row.contract_award_to.name }}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="NAICS"
      width="70"
      prop="contract_naic_id">
     <template slot-scope="scope" >
      <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.contract_naic_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        placeholder=""
        clearable
        allow-create
        default-first-option
      >
        <el-option
          v-for="item in naicsOptions"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow &&
        (scope.row.contract_naic && scope.row.contract_naic.name !== null)">
      {{ scope.row.contract_naic.name }}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="Award Type"
      width="70"
      prop="contract_award_type_id">
      <template slot-scope="scope" >
      <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.contract_award_type_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        placeholder=""
        allow-create
        default-first-option
      >
        <el-option
          v-for="item in awardTypes"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow &&
        (scope.row.contract_award_type && scope.row.contract_award_type.name !== null)">
      {{ scope.row.contract_award_type.name }}
      </span>
      </template>
    </el-table-column>
    <el-table-column
      label="Contract Type"
      width="75"
      prop="contract_type_id">
      <template slot-scope="scope" >
      <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.contract_type_id"
        filterable       
        track-by="name" 
        placeholder=""       
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
      >
        <el-option
          v-for="item in contractTypes"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow  &&
        (scope.row.contract_type && scope.row.contract_type.name !== null)">
      {{ scope.row.contract_type.name }}
      </span>
      </template>
    </el-table-column>
      <el-table-column
      label="Prime vs Sub"
      width="55"
      prop="prime_or_sub">
     <template slot-scope="scope" >
      <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.prime_or_sub"
        track-by="name"  
        placeholder=""      
        value-key="id"
        class="w-100"
        clearable
        default-first-option
        >
        <el-option
          v-for="item in primeOrSub"
          :key="item"
          :label="item"
          :value="item"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.prime_or_sub }}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="Contract Start Date"
      width="100"
      prop="contract_start_date">
       <template slot-scope="scope">
        <v2-date-picker
          name="Date"       
          v-if="scope.$index == createRow"
          v-model="contractStartDate"
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
       <span v-if="rowId == scope.row.id && scope.$index !== createRow">
         <v2-date-picker
          name="Date"     
          v-model="scope.row.contract_start_date"  
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
     <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ moment(scope.row.contract_start_date).format("MM-DD-YYYY") }}
      </span>
     </template>
    </el-table-column>
     <el-table-column
      label="Contract End Date"
      width="100"
      prop="contract_end_date">
      <template slot-scope="scope">
        <v2-date-picker
          name="Date"     
          v-model="contractEndDate"  
          v-if="scope.$index == createRow"
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
         <v2-date-picker
          name="Date"     
          v-model="scope.row.contract_end_date"  
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow" >
      {{ moment(scope.row.contract_end_date).format("MM-DD-YYYY") }}
      </span>
     </template>
    </el-table-column>
     <el-table-column
      label="Total Contract Value"
       width="115"
      prop="total_contract_value">
     <template slot-scope="scope">
     <el-input
      size="small"
      v-if="scope.$index == createRow"
      type="number"
      style="text-align:center"
      v-model="scope.row.total_contract_value"
      controls-position="right"
      ></el-input>
      <span v-if="rowId == scope.row.id && scope.$index !== createRow">
     <el-input
      size="small"      
      type="number"
      style="text-align:center"
      v-model="scope.row.total_contract_value"
      controls-position="right"
      ></el-input>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.total_contract_value }}
      </span>
    </template>

    </el-table-column>
    <el-table-column
      label="PoP's"
       width="100"
      prop="contract_pop_id">
      <template slot-scope="scope" >
      <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.contract_pop_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        placeholder=""
        clearable
        allow-create
        default-first-option
        >
        <el-option
          v-for="item in pops"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow &&
        (scope.row.contract_pop && scope.row.contract_pop.name !== null)">
      {{ scope.row.contract_pop.name }}
      </span>
      </template>
    </el-table-column>
     <el-table-column
      label="Current PoP"
      width="100"
      prop="contract_current_pop_id">
    <template slot-scope="scope" >
      <span v-if="rowId == scope.row.id || scope.$index == createRow">
       <el-select
        v-model="scope.row.contract_current_pop_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        placeholder=""
        clearable
        allow-create
        default-first-option
       >
        <el-option
          v-for="item in currentPops"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow &&
        (scope.row.contract_current_pop && scope.row.contract_current_pop.name !== null)">
      {{ scope.row.contract_current_pop.name }}
      </span>
      </template>
    </el-table-column>
    <el-table-column
      label="Contract PoP Start Date"
       width="100"
      prop="contract_current_pop_start_date">
      <template slot-scope="scope">
        <v2-date-picker
          name="Date"   
          v-model="popStartDate"      
          v-if="scope.$index == createRow"
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
         <v2-date-picker
          name="Date"   
          v-model="scope.row.contract_current_pop_start_date"          
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
    <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ moment(scope.row.contract_current_pop_start_date).format('MM-DD-YYYY') }}
      </span>
     </template>
    </el-table-column>
       <el-table-column
      label="Contract PoP End Date"
       width="100"
      prop="contract_current_pop_end_date">
     <template slot-scope="scope">
     <v2-date-picker
          name="Date" 
          v-model="popEndDate"        
          v-if="scope.$index == createRow"
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
         <v2-date-picker
          name="Date"  
          v-model="scope.row.contract_current_pop_end_date"       
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
    <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ moment(scope.row.contract_current_pop_end_date).format('MM-DD-YYYY') }}
      </span>
     </template>
    </el-table-column>
    <el-table-column
      label="Actions"
      width="120"
      fixed="right"
      align="center">
   <template slot-scope="scope">
      <el-button
        type="default"
        @click="saveContractProject(scope.$index, scope.row)"
        v-if="scope.$index == rowIndex" 
        v-tooltip="`Save`" 
        class="bg-primary btn-sm text-light mx-0">               
        <i class="far fa-save"></i>
        </el-button>
      <el-button 
        type="default" 
        v-tooltip="`Cancel Edit`"       
        v-if="scope.$index == rowIndex"
        @click.prevent="cancelEdits(scope.$index, scope.row)"  
        class="bg-secondary btn-sm text-light mx-0">
      <i class="fas fa-ban"></i>
        </el-button>
         <el-button
          type="default"
           v-tooltip="`Edit`" 
          class="bg-light btn-sm"
           v-if="(scope.$index !== rowIndex) && (scope.$index !== createRow)"
          @click="editMode(scope.$index, scope.row)"><i class="fal fa-edit text-primary"></i>
          </el-button>
          <el-button
          type="default"
           v-tooltip="`Delete`" 
          class="bg-light btn-sm"
           v-if="(scope.$index !== rowIndex) && (scope.$index !== createRow)"
          @click="deleteContractProj(scope.$index, scope.row)"><i class="far fa-trash-alt text-danger "></i>   
          </el-button>
        <el-button
          type="default"
          @click="saveContractProject(scope.$index, scope.row)"
          v-if="scope.$index == createRow" 
          v-tooltip="`Save`" 
          class="bg-primary btn-sm text-light mx-0">               
        <i class="far fa-save"></i>
        </el-button>
       </template>

    </el-table-column>
  </el-table>
      <el-dialog
        :visible.sync="pocDialogVisible"
        append-to-body
        center
        class="p-0 users"       
      >
       <span slot="title" class="text-left">
        <h5 class="text-dark"><i class="fa-solid fa-address-card mr-2"></i>Manage Contract POCs</h5>
      </span>
      <div class="container" >      
        <div class="row">        
       <div class="col-12" v-if="pocData">
       <el-table
        :data="pocData"
        border
        height="400"
        style="width: 95%">
        <el-table-column
          fixed
          label="Name"
          width="150"
          prop="name">
          <template slot-scope="scope">
            <el-input
              size="small"
              v-if="scope.$index == pocCreateRow"
              style="text-align:center"
              placeholder=""
              v-model="scope.row.name"
              controls-position="right"
            ></el-input>
            <span v-if="pocRowId == scope.row.id && scope.$index !== pocCreateRow">
            <el-input
              size="small"
              style="text-align:center"
              placeholder=""
              v-model="scope.row.name"
              controls-position="right"
              ></el-input>
            </span>
          <span v-if="pocRowId !== scope.row.id && scope.$index !== pocCreateRow">
            {{ scope.row.name }} 
            </span>
            </template>
        </el-table-column>
        <el-table-column
          label="POC Title"
          width="150"
          prop="title">
          <template slot-scope="scope">
            <el-input
              size="small"
              v-if="scope.$index == pocCreateRow"
              placeholder=""
              style="text-align:center"
              v-model="scope.row.title"
              controls-position="right"
            ></el-input>
            <span v-if="pocRowId == scope.row.id && scope.$index !== pocCreateRow">
            <el-input
              size="small"
              placeholder=""
              style="text-align:center"
              v-model="scope.row.title"
              controls-position="right"
              ></el-input>
            </span>
          <span v-if="pocRowId !== scope.row.id && scope.$index !== pocCreateRow">
            {{ scope.row.title }} 
            </span>
            </template>
        </el-table-column>    
        <el-table-column
          label="Email"
          width="300"
          prop="email">
          <template slot-scope="scope">
            <el-input
              size="small"
              v-if="scope.$index == pocCreateRow"
              placeholder=""
              style="text-align:center"
              v-model="scope.row.email"
              controls-position="right"
            ></el-input>
            <span v-if="pocRowId == scope.row.id && scope.$index !== pocCreateRow">
            <el-input
              size="small"
              placeholder=""
              style="text-align:center"
              v-model="scope.row.email"
              controls-position="right"
              ></el-input>
            </span>
          <span v-if="pocRowId !== scope.row.id && scope.$index !== pocCreateRow">
            {{ scope.row.email }} 
            </span>
            </template>
        </el-table-column>
        <el-table-column
          label="POC Work Phone #"
          width="175"
          prop="work_number">
          <template slot-scope="scope">
            <el-input
              size="small"
              v-if="scope.$index == pocCreateRow"
              placeholder=""
              style="text-align:center"
              v-model="scope.row.work_number"
              controls-position="right"
            ></el-input>
            <span v-if="pocRowId == scope.row.id && scope.$index !== pocCreateRow">
            <el-input
              size="small"
              placeholder=""
              style="text-align:center"
              v-model="scope.row.work_number"
              controls-position="right"
              ></el-input>
            </span>
          <span v-if="pocRowId !== scope.row.id && scope.$index !== pocCreateRow">
            {{ scope.row.work_number }} 
            </span>
            </template>
        </el-table-column>
        <el-table-column
          label="POC Mobile Phone #"
          width="175"
          prop="title">
          <template slot-scope="scope">
            <el-input
              size="small"
              v-if="scope.$index == pocCreateRow"
              placeholder=""
              style="text-align:center"
              v-model="scope.row.mobile_number"
              controls-position="right"
            ></el-input>
            <span v-if="pocRowId == scope.row.id && scope.$index !== pocCreateRow">
            <el-input
              size="small"
              placeholder=""
              style="text-align:center"
              v-model="scope.row.mobile_number"
              controls-position="right"
              ></el-input>
            </span>
          <span v-if="pocRowId !== scope.row.id && scope.$index !== pocCreateRow">
            {{ scope.row.mobile_number }} 
            </span>
            </template>
        </el-table-column>
        <el-table-column
          label="Notes"
          width="350"
          prop="notes">
          <template slot-scope="scope">
            <el-input
              size="small"
              v-if="scope.$index == pocCreateRow"
              placeholder=""
              style="text-align:center"
              v-model="scope.row.notes"
              controls-position="right"
            ></el-input>
            <span v-if="pocRowId == scope.row.id && scope.$index !== pocCreateRow">
            <el-input
              size="small"
              placeholder=""
              style="text-align:center"
              v-model="scope.row.notes"
              controls-position="right"
              ></el-input>
            </span>
          <span v-if="pocRowId !== scope.row.id && scope.$index !== pocCreateRow">
            {{ scope.row.notes }} 
            </span>
            </template>
        </el-table-column>
        <el-table-column
          label="Actions"
          width="95"
          fixed="right"
          align="center">
         <template slot-scope="scope">
          <el-button
            type="default"
            @click="saveContractPOC(scope.$index, scope.row)"
            v-if="scope.$index == pocRowIndex" 
            v-tooltip="`Save`" 
            class="bg-primary btn-sm text-light mx-0">               
            <i class="far fa-save"></i>
            </el-button>
          <el-button 
            type="default" 
            v-tooltip="`Cancel Edit`"       
            v-if="scope.$index == pocRowIndex"
            @click.prevent="cancelPocEdits(scope.$index, scope.row)"  
            class="bg-secondary btn-sm text-light mx-0">
          <i class="fas fa-ban"></i>
            </el-button>
            <el-button
              type="default"
              v-tooltip="`Edit`" 
              class="bg-light btn-sm"
              v-if="(scope.$index !== pocRowIndex) && (scope.$index !== pocCreateRow)"
              @click="editPocRow(scope.$index, scope.row)"><i class="fal fa-edit text-primary"></i>
              </el-button>
            <el-button
              type="default"
              @click="saveContractPOC(scope.$index, scope.row)"
              v-if="scope.$index == pocCreateRow" 
              v-tooltip="`Save`" 
              class="bg-primary btn-sm text-light mx-0">               
            <i class="far fa-save"></i>
            </el-button>
          </template>

        </el-table-column>
       </el-table>
    
       </div> 
        </div>

      </div>
      </el-dialog>

      </div>
      </div>
    </el-tab-pane>
 
    <el-tab-pane>
    <span slot="label"> <i class="fa-solid fa-book mr-1" :class="[ pane2? 'mh-blue-text' : 'txt-secondary']"></i>
     CONTRACT BACKLOG
     </span> 
    <PortfolioContractBacklog/>
    </el-tab-pane>
   <el-tab-pane>
    <span slot="label"> <i class="fa-solid fa-user mr-1" :class="[ pane3? 'bootstrap-purple-text' : 'txt-secondary']"></i>
    <i v-tooltip="`Manage POCs`" class="far fa-plus-circle mr-1" :class="[ pane3? 'bootstrap-purple-text' : 'd-none']" @click="openPocModal"></i> 
    CONTRACT POC   
    </span>  
    <PortfolioContractPOC/>    
    </el-tab-pane>
    <el-tab-pane>
    <span slot="label">  <i class="fa-solid fa-calendar-xmark mr-1" :class="[ pane4? 'text-danger' : 'txt-secondary']"></i>
    EXPIRED CONTRACTS
    </span>
   <PortfolioExpiredContracts/>
    </el-tab-pane>
  </el-tabs>
  </div>
      
</template>
    
<script>
//Create Vehicles Does not work error: undefined method `permit' for nil:NilClass
// Create POCs doesn;t work error:  app/models/user.rb:49:in `can_contract_data?' param is missing or the value is empty: contract_project_poc
// import CurrencyInput from "./CurrencyInput.vue";
import { mapGetters, mapMutations, mapActions } from "vuex";
import PortfolioVehicles from "./PortfolioVehicles.vue";
import PortfolioContractBacklog from "./PortfolioContractBacklog.vue";
import PortfolioContractPOC from "./PortfolioContractPOC.vue";
import PortfolioExpiredContracts from "./PortfolioExpiredContracts.vue";
// import ProgramTaskForm from "./ProgramTaskForm.vue";
// import ProgramLessons from "./ProgramLessons.vue";

export default {
  name: "PortfolioContracts",
  components: {
    PortfolioVehicles,  
    PortfolioExpiredContracts,
    PortfolioContractBacklog,
    PortfolioContractPOC,
    // CurrencyInput,
  },
    data() {    
      return {
        contractStartDate: "",
        contractEndDate: "",
        popStartDate: "",
        popEndDate: "",
        nothing: true,
        pocDialogVisible: false,
        rowIndex: null, 
        rowId: null, 
        pocRowIndex: null, 
        pocRowId: null, 
        pane0: true, 
        pane1: false, 
        pane2: false, 
        pane3: false, 
        pane4: false, 
        tabPosition: 'bottom',      
        pocsArray: [{
          id: 0,
          poc_name: 'David Pumphrey',
          poc_title: 'Program Manager',
          poc_email: 'david.pumphrey@microhealthllc.com',
          poc_work_num: 8753334567,
          poc_mobile_num: 8753334567,
          notes:'Lorem ipsum dolor sit amet, consectetur adipiscing eliua.',
        }, {
          id: 1,
          poc_name: 'Michael Holmes',
          poc_title: 'Program Manager',
          poc_email: 'michael.holmes@microhealthllc.com',
          poc_work_num: 8753334567,
          poc_mobile_num: 8753334567,
          notes:'Lorem ipsum dolor sit amet, consectetur adipiscing eliua.',
        }, {
          id: 2,
          poc_name: 'Phillip Edmonds',
          poc_title: 'Program Manager',
          poc_email: 'phillip.edmonds.pumphrey@microhealthllc.com',
          poc_work_num: 8753334567,
          poc_mobile_num: 8753334567,
          notes:'Lorem ipsum dolor sit amet, consectetur adipiscing eliua.',
         }],

        search: '',
    };
  },
  setup() {
    const schema = Yup.object({
      amount: Yup.number().required().max(1000).min(100),
    });

    return {
      schema,
      currencyOptions: {
        currency: "USD",
      },
    };
  },
  methods: {
    ...mapMutations([
     "SET_CONTRACT_PROJECT_STATUS",
     "SET_CONTRACT_POCS_STATUS"
    ]),
    ...mapActions([
      //Contract Projects
      "createContractProject",
      "fetchContractProjects",
      "updateContractProject",
      "deleteContractProject",
      //POCs
      "createContractPOC",
      "fetchContractPOCs",
      "updateContractPOC",
      "deleteContractPOC",
      //Vehicles
      "fetchContractVehicles"
    ]),  
  backHomeBtn() {
      window.location.pathname = "/";
    }, 
  log(e){
    // console.log(e)
  } ,
  openPocModal(){
    this.pocDialogVisible = true;
    this.fetchContractPOCs()
  },   
  editMode(index, rows) {
    this.rowIndex = index,
    this.rowId = rows.id
  }, 
  editPocRow(index, rows) {
    this.pocRowIndex = index,
    this.pocRowId = rows.id
  },  
  saveNewPocRow(){
    // Row create action will occur here
    //After save, dont forget to push new empty object to append new create row
     this.pocRowIndex = null;
    this.pocRowId = null;
  },
  deleteContractProj(index, rows) {
        this.$confirm(
        `Are you sure you want to delete ${rows.name} from your Contract Projects?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: "warning",
        }
       ).then(() => {
        this.deleteContractProject(rows.id);
      });     
    },
  saveContractProject(index, row){
    this.rowIndex = null;
    this.rowId = null;
    let id = null;
    
    if (row.id) {
      id = row.id
      this.contractStartDate = row.contract_start_date
      this.contractEndDate = row.contract_end_date
      this.popStartDate = row.contract_current_pop_start_date;
      this.popEndDate = row.contract_current_pop_end_date;   
    }
    let contractProjectData = {
          cProjectData: {
            charge_code: row.charge_code,
            name: row.name,   
            prime_or_sub: row.prime_or_sub,
            contract_customer_id: row.contract_customer_id, 
            contract_start_date: this.contractStartDate,
            contract_end_date: this.contractEndDate,
            total_contract_value: row.total_contract_value,
            contract_current_pop_start_date: this.popStartDate,
            contract_current_pop_end_date: this.popEndDate,
            contract_vehicle_id: row.contract_vehicle_id,
            number:  row.number,
            contract_naic_id: row.contract_naic_id,
            contract_award_type_id: row.contract_award_type_id,
            contract_award_to_id: row.contract_award_to_id,
            contract_type_id: row.contract_type_id,
            contract_pop_id: row.contract_pop_id,
            contract_current_pop_id: row.contract_current_pop_id,        
        },
      };
    console.log(contractProjectData)
    if (id){
      this.updateContractProject({...contractProjectData, id})
    } else {
      this.createContractProject({...contractProjectData})     
    }
   
  },
  saveContractPOC(index, row){
    this.pocRowIndex = null;
    this.pocRowId = null;
    let contractPOCdata = {
          cPOCsData: {
            name: row.name, 
            pocType: row.poc_type, 
            email: row.email, 
            title: row.title, 
            workNum: row.work_number, 
            mobileNum: row.mobile_number, 
            notes: row.notes,             
        },
      };
    console.log(contractPOCdata)
    if (row.id){
       let id = row.id
       this.updateContractPOC({...contractPOCdata, id})
    } else {
      this.createContractPOC({...contractPOCdata})
    }
   
  },
  cancelPocEdits() {
    this.pocRowIndex = null;
    this.pocRowId = null;
       
  },
  cancelEdits(index, rows) {
    this.rowIndex = null;
    this.rowId = null;
       
  },
  handleDelete(index, row) {
    console.log(index, row);
  },
  handleClick(tab, event) {
    if (tab.paneName == 0){
       this.pane0 = true;
       this.pane1 = false;
       this.pane2 = false;
       this.pane3 = false;
       this.pane4 = false;
    }
    if (tab.paneName == 1){
       this.pane0 = false;
       this.pane1 = true;
       this.pane2 = false;
       this.pane3 = false;
       this.pane4 = false;
    }
    if (tab.paneName == 2){
       this.pane0 = false;
       this.pane1 = false;
       this.pane2 = true;
       this.pane3 = false;
       this.pane4 = false;
    }
    if (tab.paneName == 3){
       this.fetchContractPOCs()
       this.pane0 = false;
       this.pane1 = false;
       this.pane2 = false;
       this.pane3 = true;
       this.pane4 = false;
    }
   if (tab.paneName == 4){
       this.pane0 = false;
       this.pane1 = false;
       this.pane2 = false;
       this.pane3 = false;
       this.pane4 = true;
    } 
   }  
  },
  mounted() {
    this.fetchContractProjects()
    this.fetchContractVehicles()
  },
  computed: {
    ...mapGetters([
      //Contract Projects 
      "contractProjectStatus",
      "contractProjects",
      "contractProjectsLoaded",
      //POCs 
      "contractPOCs",
      "contractPOCsStatus",  
      "contractPOCsLoaded",
      //Vehicles
      "contractVehicles",
      "contractVehiclesLoaded",

    ]),   
  tableData(){
      if (this.contractProjects && this.contractProjects.length > 0){
        let data = this.contractProjects   
         data.push({})
         return data    
     } else {
        let data = []
         data.push({})
         return data
     }      
    },
    createRow(){
      let lastItem = this.tableData.length - 1
      //  console.log(lastItem)
      return lastItem
    },
    pocData(){
      if (this.contractPOCs && this.contractPOCs.length > 0){
       let data = this.contractPOCs  
         data.push({})
         return data    
     } else {
        let data = []
         data.push({})
         return data
     }      
    },
    pocCreateRow(){
      let lastItem = this.pocData.length - 1
      //  console.log(lastItem)
      return lastItem
    },
    awardToNums(){
      if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueAwardTOs = _.uniq(this.contractProjects.filter(t => t.contract_award_to_id))
        let awardTos = uniqueAwardTOs.map(t => t.contract_award_to).filter(t => t !== undefined)
        let unique = [];
        // console.log(awardTos)
        awardTos.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
         return unique
      }
    },
    primeOrSub(){
      return ['Prime', 'Sub']
    },                  
    contractNumber(){
     if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueContractNums = this.contractProjects.filter(t => t.number)
        let contractNums = uniqueContractNums.map(t => t.number).filter(t => t !== null)
        return _.uniq(contractNums.map(t => t))
      }
    },
    // vehicleOptions is foreign key value and must come from contract_vehicles data, not from contractProjects
    vehicleOptions(){
     if (this.contractVehicles && this.contractVehicles.length > 0){
        let vehicles = this.contractVehicles.filter(t => t && t.id)
        // let unique = [];
        // // console.log(vehicles)
        // vehicles.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
        return vehicles
      }
    },
    customerOptions(){
     if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueCustomerOptions = _.uniq(this.contractProjects.filter(t => t.contract_customer_id))
        let customers = uniqueCustomerOptions.map(t => t.contract_customer).filter(t => t !== undefined)
        let unique = [];
        // console.log(customers)
        customers.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
        return unique
      }
    },
    naicsOptions(){
     if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueNaics = _.uniq(this.contractProjects.filter(t => t.contract_naic_id))
        let naics = uniqueNaics.map(t => t.contract_naic).filter(t => t && t.id && t !== undefined && t !== null)
        let unique = [];
        // console.log(naics)
        naics.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
        return unique
      }
    },
    awardTypes(){
      if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueAwardTypes = _.uniq(this.contractProjects.filter(t => t.contract_award_type_id))
        let awardType = uniqueAwardTypes.map(t => t.contract_award_type).filter(t => t && t.id && t !== undefined && t !== null)
        let unique = [];
        // console.log(awardType)
        awardType.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
        return unique
      }
    },
    pops(){
      if (this.contractProjects && this.contractProjects.length > 0){
        let uniquePoPs = _.uniq(this.contractProjects.filter(t => t.contract_pop_id))
        let pops = uniquePoPs.map(t => t.contract_pop).filter(t => t && t.id && t !== undefined && t !== null)
        let unique = [];
        // console.log(pops)
        pops.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
         return unique
      }
    },
    currentPops(){
      if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueCurrentPoPs = _.uniq(this.contractProjects.filter(t => t.contract_current_pop_id))
        let currentPoPs = uniqueCurrentPoPs.map(t => t.contract_current_pop).filter(t => t && t.id && t !== undefined && t !== null)
        let unique = [];
        // console.log(currentPoPs)
        currentPoPs.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
         return unique
      }
    },
    contractTypes(){
     if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueContractTypes = _.uniq(this.contractProjects.filter(t => t.contract_type_id))
        let contractTypes = uniqueContractTypes.map(t => t.contract_type).filter(t => t && t.id && t !== undefined && t !== null)
        let unique = [];
        // console.log(contractTypes)
        contractTypes.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
         return unique
      }
    },
  },
  watch: {
    contractProjectStatus: {
      handler() {
        if (this.contractProjectStatus == 200) {
          this.$message({
            message: `Contract Project saved successfully.`,
            type: "success",
            showClose: true,
          });
          this.contractStartDate = "";
          this.contractEndDate = "";
          this.popStartDate = "";
          this.popEndDate = "";
          this.SET_CONTRACT_PROJECT_STATUS(0);
          this.fetchContractProjects();
        }
      },
    }, 
    contractPOCsStatus: {
      handler() {
        if (this.contractPOCsStatus == 200) {
          this.$message({
            message: `POC data saved successfully.`,
            type: "success",
            showClose: true,
          });
          this.SET_CONTRACT_POCS_STATUS(0);
          this.fetchContractPOCs();
          this.fetchContractProjects();
        }
      },
    },     
  },
};
</script>
    
<style scoped lang="scss">
  .bottomTabs{
    position: absolute;
    bottom: 2.5%;
    width: 100%;
  }
/deep/.el-input__inner {
  padding: 1px 1px 1px 1px;
}
/deep/.el-table {
    font-size: 13px !important;
    th.el-table__cell>.cell {
      word-break: break-word;
      font-size: .88rem;
    }
    th {
      color: #383838;
    }

    tr, td {
      word-break: break-word;
    }


  }    
</style>