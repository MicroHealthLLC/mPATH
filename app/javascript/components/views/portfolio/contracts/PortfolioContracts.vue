<template>
  <div class="container-fluid mx-3">       
    <div style="height:85px" class="pt-2">
      <span @click.prevent="backHomeBtn">
        <img         
          style="width: 147px;cursor:pointer"
          :src="require('../../../../../assets/images/microhealthllc.png')"
        />
        <!-- <h3 class="d-inline mt-1 programName">{{ this.$portfolio_heading }}</h3> -->
      </span>
      <span class="float-right mr-4">
        <button
          class="portfolioHomeBtn mh-orange btn"
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
      <div style="height: 80vh; overflow-y:auto">
    <el-table
    :data="tableData"
    border
    height="800"
    style="width: 95%"
    :summary-method="getSummaries"
    show-summary
    >
    <el-table-column
      fixed
      label="Code*"
      width=""
      prop="charge_code">
      <template slot-scope="scope">
        <el-input
          size="small"
          tabindex="1"  
          v-if="_isallowed('write') && scope.$index == createRow"
          class="p-0"
          style="text-align:center"
          v-model="scope.row.charge_code"
          controls-position="right"
        ></el-input>
        <span v-if="_isallowed('write') && rowId == scope.row.id && scope.$index !== createRow">
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
      label="Project Name*"
      width="200"
      >
      <template slot-scope="scope">
        <el-input
          size="small"
          tabindex="2"  
          v-if="_isallowed('write') && scope.$index == createRow"
          style="text-align:center"
          v-model="scope.row.name"
          controls-position="right"
        ></el-input>
        <span v-if="_isallowed('write') && rowId == scope.row.id && scope.$index !== createRow">
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
      label="Customer*"
      width="200"
     >
     <template slot-scope="scope" >
     <span v-if="_isallowed('write') && (rowId == scope.row.id || scope.$index == createRow)">
       <el-select
        tabindex="3"  
        v-model="scope.row.contract_customer_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        placeholder=""
        clearable
        allow-create
        default-first-option
        size="small"
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
      >
       <template slot-scope="scope" >
     <span v-if="_isallowed('write') && (scope.$index == createRow)">
       <el-select
        v-model="scope.row.contract_vehicle_id"
        filterable  
        tabindex="4"       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        placeholder=""
        default-first-option
        size="small"
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
        <span v-if="_isallowed('write') && (rowId == scope.row.id && scope.$index !== createRow)">
        <span v-if="scope.row.contract_vehicle && scope.row.contract_vehicle_id">
       <el-select
        v-model="scope.row.contract_vehicle_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        placeholder=""
        default-first-option
        size="small"
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
     
       <span v-else>
      <el-select
        v-model="blankVehicle"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        allow-create
        placeholder=""
        default-first-option
        size="small"
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
      
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow && 
      (scope.row.contract_vehicle && scope.row.contract_vehicle.name !== null)">
      {{ scope.row.contract_vehicle.name }}
      </span>
      </template>
    </el-table-column>
      <el-table-column
      label="Contract Number**"
      width="125"
     >
    <template slot-scope="scope" >
     <span v-if="_isallowed('write') && (rowId == scope.row.id || scope.$index == createRow)">
       <el-select
        tabindex="5"    
        v-model="scope.row.contract_number_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        placeholder=""
        clearable
        allow-create
        default-first-option
        size="small"
      >
        <el-option
          v-for="item in contractNumbers"
          :key="item.id"
          :label="item.name"
          :value="item.id"
        >
        </el-option>
      </el-select>
      </span>
       <span v-if="rowId !== scope.row.id && scope.$index !== createRow &&
        (scope.row.contract_number && scope.row.contract_number.name !== null)">
       {{ scope.row.contract_number.name }}
      </span>
      </template>
    </el-table-column>
    <el-table-column
      label="Award/ TO Number**"
      width="125"
     >
       <template slot-scope="scope" >
     <span v-if="_isallowed('write') && (rowId == scope.row.id || scope.$index == createRow)">
       <el-select
        tabindex="6"    
        v-model="scope.row.contract_award_to_id"
        filterable       
        track-by="id" 
        placeholder=""       
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        size="small"
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
      label="NAICS*"
      width="70"
      >
     <template slot-scope="scope" >
      <span v-if="_isallowed('write') && (rowId == scope.row.id || scope.$index == createRow)">
       <el-select
        tabindex="7"     
        v-model="scope.row.contract_naic_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        placeholder=""
        clearable
        allow-create
        default-first-option
        size="small"
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
      label="Award Type*"
      width="70"
      >
      <template slot-scope="scope" >
      <span v-if="_isallowed('write') && (rowId == scope.row.id || scope.$index == createRow)">
       <el-select
        tabindex="8"    
        v-model="scope.row.contract_award_type_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        clearable
        placeholder=""
        allow-create
        default-first-option
        size="small"
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
      label="Contract Type*"
      width="75"
      >
      <template slot-scope="scope" >
      <span v-if="_isallowed('write') && (rowId == scope.row.id || scope.$index == createRow)">
       <el-select
        tabindex="9" 
        v-model="scope.row.contract_type_id"
        filterable       
        track-by="name" 
        placeholder=""       
        value-key="id"
        class="w-100"
        clearable
        allow-create
        default-first-option
        size="small"
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
      >
     <template slot-scope="scope" >
      <span v-if="_isallowed('write') && (rowId == scope.row.id || scope.$index == createRow)">
       <el-select
        tabindex="10" 
        v-model="scope.row.prime_or_sub"
        track-by="name"  
        placeholder=""      
        value-key="id"
        class="w-100"
        clearable
        default-first-option
        size="small"
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
      label="Contract Start Date*"
      width="125"
      prop="contract_start_date">
       <template slot-scope="scope">
        <v2-date-picker
          tabindex="11" 
          name="Date"       
          v-if="_isallowed('write') && scope.$index == createRow"
          v-model="newContractStartDate"
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
       <span v-if="_isallowed('write') && (rowId == scope.row.id && scope.$index !== createRow)">
         <v2-date-picker
          name="Date"     
          v-model="contractStartDate"  
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
     <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
        <span v-if="scope.row.contract_start_date == null || scope.row.contract_start_date == undefined">      
        </span>
        <span v-else>
            {{ moment(scope.row.contract_start_date).format("MM-DD-YYYY") }}
        </span>   
      </span>
     </template>
    </el-table-column>
     <el-table-column
      label="Contract End Date*"
      width="125"
      prop="contract_end_date">
      <template slot-scope="scope">
        <v2-date-picker
          tabindex="12" 
          name="Date"     
          v-model="newContractEndDate"  
          v-if="(scope.$index == createRow) && _isallowed('write')"
          :disabled-date="disabledNewContractEndDate"
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        <span v-if="_isallowed('write') && rowId == scope.row.id && scope.$index !== createRow">
         <v2-date-picker
          name="Date"     
          :disabled-date="disabledContractEndDate"
          v-model="contractEndDate"  
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow" >
        <span v-if="scope.row.contract_end_date == null || scope.row.contract_end_date == undefined">      
        </span>
        <span v-else>
            <span v-if="scope.row.ignore_expired == true" v-tooltip="`Exempt from expiration`" >
              <i class="fa-solid fa-calendar-xmark text-success"></i>
            </span>
          {{ moment(scope.row.contract_end_date).format("MM-DD-YYYY") }}
        </span>     
      </span>
     </template>
    </el-table-column>
     <el-table-column
      label="Total Contract Value*"
       width="175"
      prop="total_contract_value">
     <template slot-scope="scope">
     <el-input
      tabindex="13" 
      size="small"
      v-if="_isallowed('write') && scope.$index == createRow "
      type="number"
      step="0.01"  
      style="text-align:center"
      v-model="scope.row.total_contract_value"
      controls-position="right"
      ></el-input>
      <span v-if="_isallowed('write') && (rowId == scope.row.id && scope.$index !== createRow)">
     <el-input
      size="small"    
      :step="0.01"  
      type="number"
      style="text-align:center"
       v-model="scope.row.total_contract_value"
      controls-position="right"
      ></el-input>
      </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      {{ scope.row.total_contract_value | toCurrency }}
      </span>
    </template>

    </el-table-column>
    <el-table-column
      label="PoP's*"
       width="100"
       >
      <template slot-scope="scope" >
      <span v-if="_isallowed('write') && (rowId == scope.row.id || scope.$index == createRow)">
       <el-select
        tabindex="14" 
        v-model="scope.row.contract_pop_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        placeholder=""
        clearable
        allow-create
        default-first-option
        size="small"
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
       >
    <template slot-scope="scope" >
      <span v-if="_isallowed('write') && (rowId == scope.row.id || scope.$index == createRow)">
       <el-select
        tabindex="15" 
        v-model="scope.row.contract_current_pop_id"
        filterable       
        track-by="name"        
        value-key="id"
        class="w-100"
        placeholder=""
        clearable
        allow-create
        default-first-option
        size="small"
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
      label="Contract PoP Start Date*"
       width="100"
      prop="contract_current_pop_start_date">
      <template slot-scope="scope">
        <v2-date-picker
           tabindex="16" 
          name="Date"   
          v-model="newPopStartDate"      
          v-if="scope.$index == createRow  && _isallowed('write')"
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
         <v2-date-picker
          name="Date"   
          v-model="popStartDate"          
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
       <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
          <span v-if="scope.row.contract_current_pop_start_date == null || scope.row.contract_current_pop_start_date == undefined" >        
          </span>
          <span v-else> {{ moment(scope.row.contract_current_pop_start_date).format("MM-DD-YYYY") }}
          </span>      
       </span>
     </template>
    </el-table-column>
       <el-table-column
      label="Contract PoP End Date*"
       width="100"
      prop="contract_current_pop_end_date">
     <template slot-scope="scope">
        <v2-date-picker
        tabindex="16" 
        name="Date" 
        v-model="newPopEndDate"        
        v-if="scope.$index == createRow && _isallowed('write')"
        :disabled-date="disabledNewPoPEndDate"
        value-type="YYYY-MM-DD"                     
        format="M/DD/YYYY"
        class="w-100"
        />
        <span v-if="rowId == scope.row.id && scope.$index !== createRow">
         <v2-date-picker
          name="Date"  
          :disabled-date="disabledPoPEndDate"
          v-model="popEndDate"       
          value-type="YYYY-MM-DD"                     
          format="M/DD/YYYY"
          class="w-100"
          />
        </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
       <span v-if="scope.row.contract_current_pop_end_date == null || scope.row.contract_current_pop_end_date == undefined" >        
          </span>
          <span v-else>  {{ moment(scope.row.contract_current_pop_end_date).format('MM-DD-YYYY') }}
          </span>    
      </span>
     </template>
    </el-table-column>
     <el-table-column
      label="Notes"
      width="350"
      >
      <template slot-scope="scope">
        <el-input
          tabindex="17" 
          size="small"
          v-if="_isallowed('write') && scope.$index == createRow"
          style="text-align:center"
          v-model="scope.row.notes"
          controls-position="right"
        ></el-input>
        <span v-if="_isallowed('write') && rowId == scope.row.id && scope.$index !== createRow">
        <el-input
          size="small"
          style="text-align:center"
          v-model="scope.row.notes"
          controls-position="right"
          ></el-input>
        </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
        {{ scope.row.notes }} 
        </span>
        </template>
     </el-table-column>
    <el-table-column
      label="Actions"
      width="155"
      v-if="_isallowed('write') || _isallowed('delete')"
      fixed="right"
      align="right">
   <template slot-scope="scope">
       <el-button
        size="mini"
        type="default"
        @click="saveContractProject(scope.$index, scope.row)"
        v-if="scope.$index == rowIndex &&  (
          scope.row.charge_code && scope.row.name && scope.row.contract_customer_id && 
          (scope.row.contract_number_id || scope.row.contract_award_to_id) && 
           scope.row.contract_naic_id && scope.row.contract_award_type_id &&
          scope.row.contract_type_id && contractStartDate && contractEndDate &&  scope.row.total_contract_value
          && scope.row.contract_pop_id && popStartDate && popEndDate
          )"  
        v-tooltip="`Save`" 
        class="bg-primary text-light px-2">               
        <i class="far fa-save"></i>
        </el-button>
        <el-popover
          v-if="programNames && (scope.$index !== rowIndex) && (scope.$index !== createRow) &&
          scope.row.associated_projects && scope.row.associated_projects.length > 0"
          placement="left"
          width="auto"
          trigger="hover">         
          <el-button
          size="mini"  
          v-for="item, i in scope.row.associated_projects" :key="i"
          @click="openContractTask(scope.$index, scope.row, programNames.filter(t => item.id == t.program_id)[0].program_id)"   
          >
          <span v-if="programNames.filter(t => item.id == t.program_id)[0]">{{ programNames.filter(t => item.id == t.program_id)[0].label}}</span>
          </el-button>        
          <el-button
          size="mini"
          slot="reference"
          type="default"        
          v-tooltip="`Open Contract Tasks`" 
          class="bg-light text-light mr-2 px-2">               
          <i class="far fa-suitcase text-secondary"></i>
        </el-button>
        </el-popover>        
      <el-button 
        size="mini"
        type="default" 
        v-tooltip="`Cancel Edit`"       
        v-if="scope.$index == rowIndex"
        @click.prevent="cancelEdits(scope.$index, scope.row)"  
        class="bg-secondary text-light px-2">
      <i class="fas fa-ban"></i>
        </el-button>
        <el-button 
        size="mini"
        type="default" 
        v-tooltip="`Remove expiration date exemption`"       
        v-if="scope.$index == rowIndex && scope.row.ignore_expired == true"
        @click.prevent="setIgnoreStatus(scope.$index, scope.row)"  
        class="bg-light px-2">
        <i class="fa-solid fa-calendar-xmark text-danger"></i>
        </el-button>
         <el-button
          size="mini"
          type="default"
           v-tooltip="`Edit`" 
          class="bg-light px-2"
           v-if="(scope.$index !== rowIndex) && (scope.$index !== createRow) && _isallowed('write')"
          @click="editMode(scope.$index, scope.row)"><i class="fal fa-edit text-primary"></i>
          </el-button>
          <el-button
          size="mini"
          type="default"
           v-tooltip="`Delete`" 
          class="bg-light px-2"
           v-if="(scope.$index !== rowIndex) && (scope.$index !== createRow)  && _isallowed('delete')"
          @click="deleteContractProj(scope.$index, scope.row)"><i class="far fa-trash-alt text-danger "></i>   
          </el-button>
        <el-button
          size="mini"
          type="default"
          @click="saveContractProject(scope.$index, scope.row)"
          v-if="scope.$index == createRow && (
          checkEmpty(scope.row.charge_code) && checkEmpty(scope.row.name) && checkEmpty(scope.row.contract_customer_id) && 
          (checkEmpty(scope.row.contract_award_to_id) || checkEmpty(scope.row.contract_number_id)) && 
          checkEmpty(scope.row.contract_naic_id) && checkEmpty(scope.row.contract_award_type_id) &&
          checkEmpty(scope.row.contract_type_id) && newContractStartDate && newContractEndDate &&  checkEmpty(scope.row.total_contract_value)
          && checkEmpty(scope.row.contract_pop_id) && newPopStartDate && newPopEndDate
          )" 
          v-tooltip="`Save`" 
          class="bg-primary text-light px-2">               
        <i class="far fa-save"></i>
        </el-button>
        <el-button 
        size="mini"
        type="default" 
        v-tooltip="`Cancel`"       
        v-if="scope.$index == createRow && (
          scope.row.charge_code || scope.row.name || scope.row.contract_customer_id || scope.row.contract_vehicle_id || scope.row.contract_award_to_id || scope.row.contract_number_id || 
          scope.row.contract_naic_id || scope.row.contract_award_type_id ||
          scope.row.contract_type_id || scope.row.prime_or_sub || newContractStartDate || newContractEndDate ||  scope.row.total_contract_value
          || scope.row.contract_pop_id || scope.row.contract_current_pop_id || newPopStartDate || newPopEndDate || scope.row.notes
          )"
        @click.prevent="cancelNewRow(scope.row)"  
        class="bg-secondary text-light px-2">
      <i class="fas fa-ban"></i>
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
          label="Name*"
          width="150"
          prop="name">
         <template slot-scope="scope" >
         <span v-if="_isallowed('write') && (scope.$index == pocCreateRow)">
          <el-input
          tabindex="1" 
          size="small"
          style="text-align:center"     
          placeholder=""
          v-model="scope.row.name"
          controls-position="right"
          ></el-input>
          </span> 
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
          label="Title"
          width="150"
          prop="title">
          <template slot-scope="scope">
          <el-input
          tabindex="2" 
          size="small"
          v-if="_isallowed('write') && (scope.$index == pocCreateRow)"
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
              tabindex="3" 
              size="small"
               v-if="_isallowed('write') && (scope.$index == pocCreateRow)"
              placeholder=""
              v-model="scope.row.email"
              @blur="validateEmail(scope.row.email)"
              type="email" 
              name="email"
              style="text-align:center"            
              controls-position="right"
            ></el-input>
            <span v-if="pocRowId == scope.row.id && scope.$index !== pocCreateRow">
            <el-input
              size="small"
              type="email" 
              @blur="validateEmail(scope.row.email)"
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
          label="Work Phone #"
          width="175"
          prop="work_number">
          <template slot-scope="scope">
          <el-input
            tabindex="4" 
            size="small"
           v-if="_isallowed('write') && (scope.$index == pocCreateRow)"
            placeholder=""
            style="text-align:center"
            type="text"           
            @input="acceptNumber"
            @blur="validatePhoneNumber(workNumberValNew)"
            v-model="workNumberValNew"
            controls-position="right"
          ></el-input>
          <span v-if="pocRowId == scope.row.id && scope.$index !== pocCreateRow">
          <el-input
            size="small"
            placeholder=""
            type="text"
            style="text-align:center"
             @input="acceptNumber"
             @blur="validatePhoneNumber(workNumberVal)"
            v-model="workNumberVal"
            controls-position="right"
            ></el-input>
            </span>
          <span v-if="pocRowId !== scope.row.id && scope.$index !== pocCreateRow">
            {{ scope.row.work_number }} 
            </span>
            </template>
        </el-table-column>
        <el-table-column
          label="Mobile Phone #"
          width="175"
          prop="mobile_number">
          <template slot-scope="scope">
            <el-input
            tabindex="5" 
            size="small"
            v-if="_isallowed('write') && (scope.$index == pocCreateRow)"
            placeholder=""           
            style="text-align:center"
            @input="acceptNumber"
            @blur="validateMobPhoneNumber(mobNumberValNew)"
            v-model="mobNumberValNew"
            controls-position="right"
          ></el-input>
          <span v-if="pocRowId == scope.row.id && scope.$index !== pocCreateRow">
          <el-input
            size="small"
            placeholder=""          
            style="text-align:center"
            @input="acceptNumber"
            @blur="validateMobPhoneNumber(mobNumberVal)"
            v-model="mobNumberVal"
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
          >
          <template slot-scope="scope">
          <el-input
          tabindex="6" 
          size="small"
          v-if="_isallowed('write') && (scope.$index == pocCreateRow)"
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
          width="115"
           v-if="_isallowed('write') || _isallowed('delete')"
          fixed="right"
          align="center">
         <template slot-scope="scope">
          <el-button
            type="default"
            size="mini"
            @click="saveContractPOC(scope.$index, scope.row)"
            v-if="(_isallowed('write')) && scope.$index == pocRowIndex" 
            v-tooltip="`Save`" 
            class="bg-primary text-light px-2">               
            <i class="far fa-save"></i>
            </el-button>
          <el-button 
            size="mini"
            type="default" 
            v-tooltip="`Cancel Edit`"       
            v-if="scope.$index == pocRowIndex"
            @click.prevent="cancelPocEdits(scope.$index, scope.row)"  
            class="bg-secondary text-light px-2">
          <i class="fas fa-ban"></i>
            </el-button>
            <el-button
              size="mini"
              type="default"
              v-tooltip="`Edit`" 
              class="bg-light px-2"
              v-if="(_isallowed('write')) && (scope.$index !== pocRowIndex) && (scope.$index !== pocCreateRow)"
              @click="editPocRow(scope.$index, scope.row)"><i class="fal fa-edit text-primary"></i>
              </el-button>
              <el-button
              size="mini"
              type="default"
              v-tooltip="`Delete`" 
              class="bg-light px-2"
              v-if="(_isallowed('delete')) && (scope.$index !== pocRowIndex) && (scope.$index !== pocCreateRow)"
              @click="deleteContractPoc(scope.$index, scope.row)"><i class="far fa-trash-alt text-danger "></i>   
              </el-button>
            <el-button
              type="default"
              size="mini"
              @click="saveContractPOC(scope.$index, scope.row)"             
              v-if="(_isallowed('write')) && scope.$index == pocCreateRow && checkEmpty(scope.row.name)" 
              v-tooltip="`Save`" 
              class="bg-primary text-light px-2">               
            <i class="far fa-save"></i>
            </el-button>
            <el-button 
            size="mini"
            type="default" 
            v-tooltip="`Cancel Edit`"       
            v-if="(_isallowed('write')) && scope.$index == pocCreateRow && (scope.row.name || scope.row.title || scope.row.email || scope.row.notes || mobNumberValNew || workNumberValNew)"
            @click.prevent="cancelNewPoc(scope.row)"  
            class="bg-secondary text-light px-2">
          <i class="fas fa-ban"></i>
            </el-button>
          </template>

        </el-table-column>
       </el-table>
    
       </div> 
        </div>

      </div>
      </el-dialog>
      <el-dialog
        :visible.sync="contractProgramsModal"
        append-to-body
        center
        class="p-0 users"       
      >
       TEST
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
    POCS
    </span>  
    <PortfolioContractPOC/>    
    </el-tab-pane>
    <el-tab-pane>
    <span slot="label">  <i class="fa-solid fa-calendar-xmark mr-1" :class="[ pane4? 'text-danger' : 'txt-secondary']"></i>
    EXPIRED CONTRACTS
    </span>
   <PortfolioExpiredContracts/>
    </el-tab-pane>
    <span class="mt-2 requiredFields mr-5">
    *Required fields, 
    </span>
    <span class="mt-2 requiredFields">
    **At least one field required
    </span>
  </el-tabs>

  </div>      
</template>
    
<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
import PortfolioVehicles from "./PortfolioVehicles.vue";
import PortfolioContractBacklog from "./PortfolioContractBacklog.vue";
import PortfolioContractPOC from "./PortfolioContractPOC.vue";
import PortfolioExpiredContracts from "./PortfolioExpiredContracts.vue";
Vue.filter('toCurrency', function (value) {
    if (isNaN(parseFloat(value))) {
        return value;
    }
    var formatter = new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD',
        minimumFractionDigits: 2

    });
    return formatter.format(value);
});
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
        contractProgID: null, 
        programContractRowID: null,
        today: new Date().toISOString().slice(0, 10),
        contractProgramsModal: false, 
        blankVehicle: '',
        totalContractValue: 0,
        workNumberVal: '', 
        sampleArray: [2, 3, 5, 7],
        workNumberValNew: '', 
        mobNumberVal: '', 
        mobNumberValNew: '', 
        isValidWorkNum: null,
        isValidMobNum: null, 
        isValidEmail: null,
        contractStartDate: null,
        contractEndDate: null,
        popStartDate: null,
        popEndDate: null,
        newContractStartDate: null,
        newContractEndDate: null,
        newPopStartDate: null,
        newPopEndDate: null,
        nothing: true,
        pocDialogVisible: false,
        rowIndex: null,  
        rowId: null, 
        pocRowIndex: null, 
        pocRowId: null, 
        email: null, 
        pane0: true, 
        pane1: false, 
        pane2: false, 
        pane3: false, 
        pane4: false, 
        tabPosition: 'bottom',      
        search: '',
    };
  },
  methods: {
    ...mapMutations([
     "SET_CONTRACT_PROJECT_STATUS",
     "SET_CONTRACT_POCS_STATUS"
    ]),
    ...mapActions([
      "fetchContracts",
      "fetchPortfolioPrograms",
      //Contract Projects
      "createContractProject",
      "fetchContractProjects",
      "updateContractProject",
      "deleteContractProject",
      "updateIgnoreExpired",

      //POCs
      "createContractPOC",
      "fetchContractPOCs",
      "updateContractPOC",
      "deleteContractPOC",
      //Vehicles
      "fetchContractVehicles",
      "fetchContractDataOptions"
    ]),
    log(e){
      console.log(e)     
    },
    _isallowed(salut) {
        return this.checkPortfolioContractPrivileges("PortfolioContracts", salut, this.$route, {settingType: 'Contracts'})
    }, 
    getSummaries(param) {
      const { columns, data } = param;
      const sums = [];
      columns.forEach((column, index) => {
        if (index === 0) {
          sums[index] = 'Totals';
          return;
        }
        const values = data.map(item => Number(item[column.property]));
        if (!values.every(value => isNaN(value))) {
          sums[index] = values.reduce((prev, curr) => {
            const value = Number(curr);
            if (!isNaN(value)) {
              return prev + curr
            } else {
              return prev
            }
          }, 0);
        } else {
          sums[index] = '';
        }
      });
      let newSums = ['Totals']
      for (const ele of sums) {
        if (ele !== 'Totals'){          
            newSums.push(ele.toLocaleString('en-US', {
            style: 'currency',
            currency: 'USD',
          }))
        }          
      }    
    //  console.log(newSums.filter(t => !t[17]))
     return newSums
    },
    validateEmail(m){
    let regex = new RegExp("([!#-'*+/-9=?A-Z^-~-]+(\.[!#-'*+/-9=?A-Z^-~-]+)*|\"\(\[\]!#-[^-~ \t]|(\\[\t -~]))+\")@([!#-'*+/-9=?A-Z^-~-]+(\.[!#-'*+/-9=?A-Z^-~-]+)*|\[[\t -Z^-~]*])");
    if (m) {
      if (regex.test(m)){
        this.isValidEmail = true
        return (true)
      }
      MessageDialogService.showDialog({
        message: `Please enter a valid email address.  Example: "john@example.com"`,
        type: MessageDialogService.msgTypes.WARNING,
        
      });
      this.isValidEmail = false
      //  console.log( this.isValidEmail)
      return (false)
    }
  } ,
  validatePhoneNumber(m){
    if (m) {
      if (m.length == 14){
        console.log(m.length)
        this.isValidWorkNum = true
        return (true)    
      } else {
        this.isValidWorkNum = false
          // console.log(this.isValidWorkNum )
        MessageDialogService.showDialog({
          message: `Please enter a valid 10 digit phone number.  Example: (508) 345-2342`,
          type: MessageDialogService.msgTypes.WARNING
        });
      }  
    }
  },
  validateMobPhoneNumber(m){
    if (m) {
  if (m.length == 14)
    {
    //   console.log(m.length)
      this.isValidMobNum = true
      return (true)    
    }
      //  console.log(this.isValidMobNum )
    MessageDialogService.showDialog({
      message: `Please enter a valid 10 digit phone number.  Example: (508) 345-2342`,
      type: MessageDialogService.msgTypes.WARNING,
      
    });
      this.isValidMobNum = false
      return (false)
    }
  },
  acceptNumber() {
    if(this.workNumberVal){
      let x = this.workNumberVal.replace(/\D/g, '').match(/(\d{0,3})(\d{0,3})(\d{0,4})/);
      this.workNumberVal = !x[2] ? x[1] : '(' + x[1] + ') ' + x[2] + (x[3] ? '-' + x[3] : '');
    }
      if(this.workNumberValNew){
      let  x = this.workNumberValNew.replace(/\D/g, '').match(/(\d{0,3})(\d{0,3})(\d{0,4})/);
      this.workNumberValNew = !x[2] ? x[1] : '(' + x[1] + ') ' + x[2] + (x[3] ? '-' + x[3] : '');
    }
    if(this.mobNumberVal){
      let x = this.mobNumberVal.replace(/\D/g, '').match(/(\d{0,3})(\d{0,3})(\d{0,4})/);
      this.mobNumberVal = !x[2] ? x[1] : '(' + x[1] + ') ' + x[2] + (x[3] ? '-' + x[3] : '');
    }
    if(this.mobNumberValNew){
      let  x = this.mobNumberValNew.replace(/\D/g, '').match(/(\d{0,3})(\d{0,3})(\d{0,4})/);
      this.mobNumberValNew = !x[2] ? x[1] : '(' + x[1] + ') ' + x[2] + (x[3] ? '-' + x[3] : '');
    }
     
    },
  backHomeBtn() {
      window.location.pathname = "/";
    }, 
  openPocModal(){
    this.pocDialogVisible = true;
    this.fetchContractPOCs()
  },   
  openContractTask(index, row, programId){
    console.log(this.programNames)
    this.contractProgID = programId
    this.programContractRowID = row.id
     this.fetchContracts(programId)  
  }, 
  editMode(index, rows) {
    //console.log(rows)
    //console.log(this.programNames)
    this.rowIndex = index,
    this.rowId = rows.id
    if(rows.contract_current_pop_start_date){
      this.popStartDate = rows.contract_current_pop_start_date;
    }
    if(rows.contract_current_pop_end_date){
      this.popEndDate = rows.contract_current_pop_end_date;
    }
    if(rows.contract_start_date){
      this.contractStartDate = rows.contract_start_date;
    }
    if(rows.contract_end_date){
      this.contractEndDate = rows.contract_end_date;
    }
  }, 
  editPocRow(index, rows) {
    console.log(rows)
    this.pocRowIndex = index,
    this.pocRowId = rows.id
    this.workNumberVal = rows.work_number
    this.mobNumberVal = rows.mobile_number
  },  
  saveNewPocRow(){
    // Row create action will occur here
    //After save, dont forget to push new empty object to append new create row
     this.pocRowIndex = null;
    this.pocRowId = null;
  },
 deleteContractPoc(index, rows) {
        this.$confirm(
        `Are you sure you want to delete ${rows.name} from your Contract POC's?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
       ).then(() => {
        this.deleteContractPOC(rows.id);
      });     
    },
  deleteContractProj(index, rows) {
        this.$confirm(
        `Are you sure you want to delete ${rows.name} from your Contract Projects?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: MessageDialogService.msgTypes.WARNING,
        }
       ).then(() => {
        this.deleteContractProject(rows.id);
      });     
    },
  saveContractProject(index, row){
    this.rowIndex = null;
    this.rowId = null;
    let id = null;
    let vehicle = "";
    let updateExpired = false;
    let ignoreExpired = false;
    
    if (row.id) {
      id = row.id
      if(this.blankVehicle !== '') {
        vehicle = this.blankVehicle
      }
      if(row.ignore_expired == true && this.contractEndDate > this.today) {
       updateExpired = true
      }
      if(row.contract_vehicle_id && row.contract_vehicle && row.contract_vehicle.name) {
        vehicle = row.contract_vehicle_id
      }
      if (!this.contractEndDate) {
        this.contractEndDate = row.contract_end_date
      }
      if (!this.contractStartDate) {
        this.contractStartDate = row.contract_start_date
      }       
      if (!this.popStartDate){
        this.popStartDate = row.contract_current_pop_start_date
      }
      if (!this.popEndDate){
        this.popEndDate = row.contract_current_pop_end_date
      }
    }
    if (!row.id){
        vehicle = row.contract_vehicle_id;
        this.contractStartDate = this.newContractStartDate;
        this.contractEndDate = this.newContractEndDate;
        this.popStartDate = this.newPopStartDate;
        this.popEndDate = this.newPopEndDate;
    }
    let contractProjectData = {
          cProjectData: {
            expiredStatus: updateExpired,
            expired: ignoreExpired,
            charge_code: row.charge_code,
            name: row.name,   
            notes: row.notes,   
            prime_or_sub: row.prime_or_sub,
            contract_customer_id: row.contract_customer_id, 
            contract_start_date: this.contractStartDate,
            contract_end_date: this.contractEndDate,
            total_contract_value: row.total_contract_value,
            contract_current_pop_start_date: this.popStartDate,
            contract_current_pop_end_date: this.popEndDate,
            contract_vehicle_id: vehicle,
            number:  row.contract_number_id,
            contract_naic_id: row.contract_naic_id,
            contract_award_type_id: row.contract_award_type_id,
            contract_award_to_id: row.contract_award_to_id,
            contract_type_id: row.contract_type_id,
            contract_pop_id: row.contract_pop_id,
            contract_current_pop_id: row.contract_current_pop_id,        
        },
      };
    console.log(vehicle)
    if (id){
      this.updateContractProject({...contractProjectData, id})
    } else {
      this.createContractProject({...contractProjectData})     
    }
   
  },
   setIgnoreStatus(index, row){
    this.rowIndex = null;
    this.rowId = null;
    let id = row.id;
  
   let contractProjectData = {
          cProjectData: {
            isExpired: false
        },
      };
    this.updateIgnoreExpired({...contractProjectData, id})
   
  },
  saveContractPOC(index, row){
    let filteredNote = ''
    if(row.notes) {
    filteredNote = row.notes
    }
    let workNumber = ''
    let mobNumber = ''
    if (row.id){
        workNumber = this.workNumberVal
        mobNumber = this.mobNumberVal
    } else {
        workNumber = this.workNumberValNew
        mobNumber = this.mobNumberValNew
    } 
    let contractPOCdata = {
          cPOCsData: {
            name: row.name, 
            pocType: row.poc_type, 
            email: row.email, 
            title: row.title, 
            workNum: workNumber, 
            mobileNum: mobNumber, 
            notes: filteredNote,   
        },
      };
       console.log(row)
      if (row.id){
      if ((this.workNumberVal && this.workNumberVal.length !== 14) || (this.mobNumberVal && this.mobNumberVal.length !== 14)){
         MessageDialogService.showDialog({
              message: `Please fix invalid field(s) before saving.`,
              type: MessageDialogService.msgTypes.WARNING,
              
            });

        } else {
              let id = row.id
              this.updateContractPOC({...contractPOCdata, id})
           }
      }  else {
         if ((this.workNumberValNew && this.workNumberValNew.length !== 14) || (this.mobNumberValNew && this.mobNumberValNew.length !== 14)){
         MessageDialogService.showDialog({
              message: `Please fix invalid field(s) before saving.`,
              type: MessageDialogService.msgTypes.WARNING,
              
            });

        } else {      
          console.log(contractPOCdata)
            this.createContractPOC({...contractPOCdata})
            }
       }     
     
    },
  cancelPocEdits() {
    this.pocRowIndex = null;
    this.pocRowId = null;
    this.workNumberVal = null;
    this.fetchContractPOCs()
       
  },
  cancelNewPoc(rows) {
    let row = rows
    for (let i in row) {
      if (row[i] != "") {
        row[i] = ""
      }
    }
    this.workNumberValNew ?
        this.workNumberValNew = null
        : this.workNumberValNew
    this.mobNumberValNew ?
      this.mobNumberValNew = null
      : this.mobNumberValNew
  },
  checkEmpty(str) {
    if (str && typeof str === "string"){
      return str.trim().length > 0 ? str : ""
    }
    if (typeof str != "string") {
      return str
    }
  },
  cancelEdits(index, rows) {
    this.rowIndex = null;
    this.rowId = null;
    this.fetchContractProjects();       
  },
  cancelNewRow(rows) {
    console.log(rows)
    let row = rows
    for (let i in row) {
      if (typeof row[i] == "string" && row[i] != "") {
        row[i] = ""
      }
      else if (typeof row[i] == "number" && row[i] != null) {
        row[i] = null
      }
    }
    this.newContractStartDate ?
      this.newContractStartDate = null
      : this.newContractStartDate
    this.newContractEndDate ?
      this.newContractEndDate = null
      : this.newContractEndDate
    this.newPopEndDate ?
      this.newPopEndDate = null
      : this.newPopEndDate
    this.newPopStartDate ?
      this.newPopStartDate = null
      : this.newPopStartDate
  },
  handleDelete(index, row) {
    console.log(index, row);
  },
  disabledPoPEndDate(date) {
  if (this.popStartDate){
    date.setHours(0, 0, 0, 0);
    const startDate = new Date(this.popStartDate);
    startDate.setHours(48, 0, 0, 0);
    return date < startDate;  
    }      
  },  
  disabledContractEndDate(date) {
  if (this.contractStartDate){
    // console.log(this.contractStartDate, date)
    date.setHours(0, 0, 0, 0);
    const startDate = new Date(this.contractStartDate);
    startDate.setHours(48, 0, 0, 0);
    return date < startDate;  
    }      
  },  
  disabledNewPoPEndDate(date) {
  if (this.newPopStartDate){
    date.setHours(0, 0, 0, 0);
    const startDate = new Date(this.newPopStartDate);
    startDate.setHours(48, 0, 0, 0);
    return date < startDate;  
    }      
  },  
  disabledNewContractEndDate(date) {
  if (this.newContractStartDate){
    // console.log(this.contractStartDate, date)
    date.setHours(0, 0, 0, 0);
    const startDate = new Date(this.newContractStartDate);
    startDate.setHours(48, 0, 0, 0);
    return date < startDate;  
    }      
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
   },
  },
  mounted() {
    this.fetchContractProjects()
    this.fetchContractVehicles()
    this.fetchPortfolioPrograms()
    this.fetchContractDataOptions()    
  },
  computed: {
    ...mapGetters([
      "contracts",
      "portfolioPrograms",
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

      //Option items for all dropdowns
      "contractDataOptions"

    ]), 
   tableData(){
      if (this.contractProjects && this.contractProjects.length > 0){
        let data = this.contractProjects.filter(t => t.contract_end_date > this.today || t.ignore_expired == true )
         data.push({})
        //  console.log(data)
         return data   

     } else {
        let data = []
         data.push({})
         return data
     }      
    },
    programNames(){
      if(this.portfolioPrograms && this.portfolioPrograms.length > 0){
        return this.portfolioPrograms
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
        console.log(unique)
         return unique.filter(u => u.name.trim().length !== 0 && u.name !== 'null')
      }
    },
    primeOrSub(){
      return ['Prime', 'Sub']
    },                  
    contractNumbers(){
     if (this.tableData && this.contractDataOptions && this.contractDataOptions.contract_numbers && 
       this.contractDataOptions.contract_numbers.length > 0){
          let viableContractNums = this.tableData.map(t => t.contract_number_id)
          let vehicleContractNums = this.contractVehicles.map(t => t.contract_number_id)   
          let contractNums = this.contractDataOptions.contract_numbers
          .filter(t => t && t.name !== undefined && t && t.name !== 'undefined' && t.name !== 'null')
          .filter(t => viableContractNums.includes(t.id) || vehicleContractNums.includes(t.id) ) 
         return contractNums.filter(u => u.name.trim().length !== 0 && u.name !== 'null')        
      } else return []
    },
    // vehicleOptions is foreign key value and must come from contract_vehicles data, not from contractProjects
    vehicleOptions(){
     if (this.contractVehicles && this.contractVehicles.length > 0){
        let vehicles = this.contractVehicles.filter(t => t && t.id)
        return vehicles.filter(u => u.name.trim().length !== 0 && u.name !== 'null')
      }
    },
    customerOptions(){
     if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueCustomerOptions = _.uniq(this.contractProjects.filter(t => t.contract_customer_id))
        let customers = uniqueCustomerOptions.map(t => t.contract_customer).filter(t => t !== undefined)
        let unique = [];
        // console.log(customers)
        customers.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
        return unique.filter(t => t.name.trim().length !== 0 && t.name !== 'null')
      }
    },
    naicsOptions(){
     if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueNaics = _.uniq(this.contractProjects.filter(t => t.contract_naic_id))
        let naics = uniqueNaics.map(t => t.contract_naic).filter(t => t && t.id && t !== undefined && t !== null)
        let unique = [];
        // console.log(naics)
        naics.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
        return unique.filter(u => u.name.trim().length !== 0 && u.name !== 'null')
      }
    },
    awardTypes(){
      if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueAwardTypes = _.uniq(this.contractProjects.filter(t => t.contract_award_type_id))
        let awardType = uniqueAwardTypes.map(t => t.contract_award_type).filter(t => t && t.id && t !== undefined && t !== null)
        let unique = [];
        // console.log(awardType)
        awardType.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
        console.log(unique)
        return unique.filter(u => u.name.trim().length !== 0 && u.name !== 'null')
      }
    },
    pops(){
      if (this.contractProjects && this.contractProjects.length > 0){
        let uniquePoPs = _.uniq(this.contractProjects.filter(t => t.contract_pop_id))
        let pops = uniquePoPs.map(t => t.contract_pop).filter(t => t && t.id && t !== undefined && t !== null)
        let unique = [];
        // console.log(pops)
        pops.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
         return unique.filter(t => t.name.trim().length !== 0 && t.name !== 'null')
      }
    },
    currentPops(){
      if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueCurrentPoPs = _.uniq(this.contractProjects.filter(t => t.contract_current_pop_id))
        let currentPoPs = uniqueCurrentPoPs.map(t => t.contract_current_pop).filter(t => t && t.id && t !== undefined && t !== null)
        let unique = [];
        // console.log(currentPoPs)
        currentPoPs.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
         return unique.filter(t => t.name.trim().length !== 0 && t.name !== 'null')
      }
    },
    contractTypes(){
     if (this.contractProjects && this.contractProjects.length > 0){
        let uniqueContractTypes = _.uniq(this.contractProjects.filter(t => t.contract_type_id))
        let contractTypes = uniqueContractTypes.map(t => t.contract_type).filter(t => t && t.id && t !== undefined && t !== null)
        let unique = [];
        // console.log(contractTypes)
        contractTypes.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
         return unique.filter(t => t.name.trim().length !== 0 && t.name !== 'null')
      }
    },
  },
  watch: {
    contractProjectStatus: {
      handler() {
        if (this.contractProjectStatus == 200) {
          MessageDialogService.showDialog({
            message: `Contract Project saved successfully.`,
            
            
          });
          this.contractStartDate = null;
          this.contractEndDate = null;
          this.popStartDate = null;
          this.popEndDate = null;
          this.newContractStartDate = null;
          this.newContractEndDate = null;
          this.newPopStartDate = null;
          this.newPopEndDate = null;  
          this.blankVehicle = '';  
          this.SET_CONTRACT_PROJECT_STATUS(0);
          this.fetchContractProjects();
          this.fetchContractVehicles()
        }
      },
    }, 
    contracts: {
      handler() {
        if (this.contracts && this.contracts.length > 0 && this.contractProgID && this.programContractRowID) {
          let programContractId = this.contracts.filter(c => c.id ==  this.programContractRowID )[0].project_contract_id
            window.open(`/programs/${this.contractProgID}/sheet/contracts/${programContractId}/tasks`)  
          }                    
        }
    },
    contractPOCsStatus: {
      handler() {
        if (this.contractPOCsStatus == 200) {
          MessageDialogService.showDialog({
            message: `POC data saved successfully.`,
            
            
          });
          this.SET_CONTRACT_POCS_STATUS(0);
          this.fetchContractPOCs();
          this.fetchContractProjects();
          this.workNumberVal = '';
          this.workNumberValNew = '';
          this.mobNumberVal = '', 
          this.mobNumberValNew = '',
          this.pocRowIndex = null;
          this.pocRowId = null;
        }
      },
    },     
  },
};
</script>
    
<style scoped lang="scss">
::v-deep.el-tabs--border-card {
  padding-bottom: 0;
}
.requiredFields{
    font-size: .88rem;
  }
  .bottomTabs{
    position: absolute;
    bottom: 3.5%;
    width: 100%;
  }
 ::v-deep.el-dialog {
  width: 70%;  
 }
::v-deep.el-input__inner {
  padding: 1px 1px 1px 2px;
}
::v-deep.el-tabs__content {
  padding-bottom: 0;
}
::v-deep.el-table {
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
