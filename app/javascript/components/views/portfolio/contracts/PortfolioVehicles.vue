<template>
  <div class="">
    <el-tabs type="border-card" @tab-click="handleClick">
      <el-tab-pane class="px-3"  style="postion:relative" label="PRIME" >        
      <div style="height:72vh; overflow-y:auto">
      <el-table
      :data="tableData"
      :summary-method="getSummaries"
      show-summary
      border    
      style="width: 95%">
      <el-table-column
        fixed
        label="Prime*"
        width="215"
        >
       <template slot-scope="scope">
        <el-input
          tabindex="1"
          size="small"
          v-if="( _isallowed('write') ) && scope.$index == createRow"
          placeholder="MicroHealth,LLC"
          style="text-align:center"
          v-model="scope.row.prime_name"
          controls-position="right"
        ></el-input>
        <span v-if="( _isallowed('write') ) && rowId == scope.row.id && scope.$index !== createRow">
        <el-input
        size="small"
        placeholder=""
        style="text-align:center"
        v-model="scope.row.prime_name"
        controls-position="right"
        ></el-input>
        </span>
        <span v-if="rowId !== scope.row.id && scope.$index !== createRow">   
          <span v-if="scope.row.prime_name ">
            {{ scope.row.prime_name }} 
          </span>
          <span v-else>
            MicroHealth, LLC
          </span>     
        </span>
        </template>
      </el-table-column>
    <el-table-column
        fixed
        label="Vehicle Nick Name*"
        width="175"
        prop="name">
      <template slot-scope="scope">
      <el-input
        tabindex="1"
        size="small"
        v-if="( _isallowed('write') ) && scope.$index == createRow"
        placeholder=""
        style="text-align:center"
        v-model="scope.row.name"
        controls-position="right"
      ></el-input>
      <span v-if="( _isallowed('write') ) && rowId == scope.row.id && scope.$index !== createRow">
      <el-input
        size="small"
        placeholder=""
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
        label="Vehicle Full Name*"
        width="300"
        >
      <template slot-scope="scope">
      <el-input
        tabindex="2"
        size="small"
        v-if="( _isallowed('write') ) && scope.$index == createRow"
        placeholder=""
        style="text-align:center"
        v-model="scope.row.full_name"
        controls-position="right"
        ></el-input>
      <span v-if="( _isallowed('write') ) && rowId == scope.row.id && scope.$index !== createRow">
      <el-input
        size="small"
        placeholder=""
        style="text-align:center"
        v-model="scope.row.full_name"
        controls-position="right"
        ></el-input>
      </span>
        <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
        {{ scope.row.full_name }}
        </span>

      </template>

      </el-table-column>
        <el-table-column
        label="SINS or Subcategories*"      
        width="325"
        class=""
        >
        <template slot-scope="scope" >
      <span v-if="_isallowed('write')  && (rowId == scope.row.id || scope.$index == createRow)">
        <el-select
          tabindex="3"
          v-model="scope.row.contract_sub_category_id"
          filterable       
          track-by="name"        
          value-key="id"
          class="w-100"
          clearable
          allow-create
          default-first-option
          placeholder=""

        >
          <el-option
            v-for="item in sinsOptions.filter(t => t.name !== 'null')"
            :key="item.id"
            :label="item.name"
            :value="item.id"
          >
          </el-option>
        </el-select>
        </span>
        <span  class="truncate-line-five" v-if="rowId !== scope.row.id && scope.$index !== createRow &&
          (scope.row.contract_sub_category && scope.row.contract_sub_category.name !== null)">
        {{ scope.row.contract_sub_category.name }}
        </span>
        </template>
      </el-table-column>
      <el-table-column
        label="Contracting Agency*"
        width="325"
      >

      <template slot-scope="scope" >
      <span v-if=" _isallowed('write') && (rowId == scope.row.id || scope.$index == createRow)">
        <el-select
          tabindex="4"
          v-model="scope.row.contract_agency_id"
          filterable       
          track-by="name"        
          value-key="id"
          class="w-100"
          clearable
          allow-create
          default-first-option
          placeholder=""

        >
          <el-option
            v-for="item in contractAgencyOptions.filter(t => t.name !== 'null')"
            :key="item.id"
            :label="item.name"
            :value="item.id"
          >
          </el-option>
        </el-select>
        </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== createRow &&
        (scope.row.contract_agency && scope.row.contract_agency.name !== null)">
        {{ scope.row.contract_agency.name }}
        </span>
        </template>
      </el-table-column>
      <el-table-column
        label="Vehicle Type*"
        width="125"
      >
      <template slot-scope="scope" >
      <span v-if=" _isallowed('write')  && (rowId == scope.row.id || scope.$index == createRow)">
        <el-select
          tabindex="5"
          v-model="scope.row.contract_vehicle_type_id"
          filterable       
          track-by="name"        
          value-key="id"
          class="w-100"
          clearable
          allow-create
          default-first-option
          placeholder=""

        >
          <el-option
            v-for="item in vehicleTypes.filter(t => t.name !== 'null')"
            :key="item.id"
            :label="item.name"
            :value="item.id"
          >
          </el-option>
        </el-select>
        </span>
        <span v-if="rowId !== scope.row.id && scope.$index !== createRow &&
          (scope.row.contract_vehicle_type && scope.row.contract_vehicle_type.name !== null)">
        {{ scope.row.contract_vehicle_type.name }}
        </span>
        </template>
      </el-table-column>
      <el-table-column
        label="CAF Fee"
        width="175"
        >
        <template slot-scope="scope">
      <el-input
        tabindex="6"
        size="small"
        v-if="( _isallowed('write') ) && (rowId == scope.row.id || scope.$index == createRow)"
        type="number"
        style="text-align:center"
        placeholder=""
        v-model="scope.row.caf_fees"
        controls-position="right"
        ></el-input>
      
        <span v-if="rowId !== scope.row.id && scope.$index !== createRow &&
        scope.row.caf_fees && scope.row.caf_fees !== '0.0'
        ">
        {{ scope.row.caf_fees }}%
        </span>
        <span v-if="scope.row.caf_fees == '0.0' && scope.$index !== createRow && rowId !== scope.row.id ">
          N/A
        </span>
      
      </template>
      </el-table-column>
      <el-table-column
        label="Contract Number"
        width="125"
      >
      <template slot-scope="scope" >    
        <el-input
        tabindex="7"
        size="small"
        v-if="( _isallowed('write') ) && scope.$index == createRow"
        placeholder=""
        style="text-align:center"
        v-model="newContractNum"
        controls-position="right"
      ></el-input>
      <span v-if="( _isallowed('write') )">
      <el-input
        size="small"
        v-if="rowId == scope.row.id && scope.$index !== createRow  && scope.row.contract_number"
        placeholder=""
        style="text-align:center"
        v-model="scope.row.contract_number.name"
        controls-position="right"
        ></el-input>
        <el-input
        size="small"
        v-if="rowId == scope.row.id && scope.$index !== createRow  && !scope.row.contract_number"
        placeholder=""
        style="text-align:center"
        v-model="updateContractNum"
        controls-position="right"
        ></el-input>
      </span>
    <span v-if="rowId !== scope.row.id && scope.$index !== createRow && scope.row.contract_number">
    {{ scope.row.contract_number.name }} 
    </span>

        </template>
      </el-table-column>
      <el-table-column
        label="Ceiling"
        width="175"
        prop="ceiling">
        <template slot-scope="scope">
      <el-input
        size="small"
        tabindex="8"
        v-if="( _isallowed('write') ) && (rowId == scope.row.id || scope.$index == createRow)"
        type="number"
        style="text-align:center"
        placeholder=""
        v-model="scope.row.ceiling"
        controls-position="right"
        ></el-input>
            
        <span v-if="rowId !== scope.row.id && scope.$index !== createRow &&
        scope.row.ceiling && scope.row.ceiling !== '0.0'
        ">
        {{ scope.row.ceiling | toCurrency  }}
        </span>
        <span v-if="scope.row.ceiling == '0.0' && scope.$index !== createRow && rowId !== scope.row.id ">
          N/A
        </span>

      </template>
      </el-table-column>

      <el-table-column
        label="Base Period Start*"
        width="100"
        >
      <template slot-scope="scope">
        <v2-date-picker
          tabindex="9"
          name="Date"       
          v-if="( _isallowed('write') ) && scope.$index == createRow"
          v-model="newBpStart"  
          value-type="YYYY-MM-DD"                      
          format="MM/DD/YYYY"
          class="w-100"
          />
        <span v-if="( _isallowed('write') ) && rowId == scope.row.id && scope.$index !== createRow">
          <v2-date-picker
          name="Date"    
          v-model="bpStart"     
          value-type="YYYY-MM-DD"                     
          format="MM/DD/YYYY"
          class="w-100"
          />
        </span>  
        <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
          <span v-if="scope.row.base_period_start == null || scope.row.base_period_start == undefined" >        
          </span>
          <span v-else>  {{ moment(scope.row.base_period_start).format("MM-DD-YYYY") }}
          </span>     
        </span>

      </template>
    </el-table-column>
      <el-table-column
        label="Base Period End*"
        width="100"
        >
        <template slot-scope="scope">
      <v2-date-picker
        name="Date" 
        tabindex="10"      
        v-if="( _isallowed('write') ) && scope.$index == createRow"
        v-model="newBpEnd"  
        :disabled-date="disabledNewBpEndDate"
        value-type="YYYY-MM-DD"                     
        format="M/DD/YYYY"
        class="w-100"
        />
      <span v-if="( _isallowed('write') ) && rowId == scope.row.id && scope.$index !== createRow">
        <v2-date-picker
        name="Date"    
        v-model="bpEnd"  
        :disabled-date="disabledBpEndDate"
        value-type="YYYY-MM-DD"                     
        format="M/DD/YYYY"
        class="w-100"
        />
      </span>
    <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
      <span v-if="scope.row.base_period_end == null || scope.row.base_period_end == undefined" >        
      </span>
      <span v-else> {{ moment(scope.row.base_period_end).format("MM-DD-YYYY") }}
      </span>      
    </span>
    </template>
      </el-table-column>
      <el-table-column
        label="Option Period Start"
        width="100"
        >
        <template slot-scope="scope">
          <v2-date-picker
            name="Date" 
            tabindex="11"            
            v-if="_isallowed('write') && scope.$index == createRow"
            v-model="newOpStart"  
            value-type="YYYY-MM-DD"                     
            format="M/DD/YYYY"
            class="w-100"
            />
          <span v-if=" _isallowed('write') && rowId == scope.row.id && scope.$index !== createRow">
          <v2-date-picker
            name="Date"    
            v-model="opStart"     
            value-type="YYYY-MM-DD"                     
            format="M/DD/YYYY"
            class="w-100"
            />
          </span>
        <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
          <span v-if="scope.row.option_period_start == null || scope.row.option_period_start == undefined" >        
          </span>
          <span v-else> {{ moment(scope.row.option_period_start).format("MM-DD-YYYY") }}
          </span>   
        </span>
      </template>
      </el-table-column>
      <el-table-column
        label="Option Period End"
        width="100"
        >
        <template slot-scope="scope">
          <v2-date-picker
            name="Date"  
            tabindex="12"        
            v-if="scope.$index == createRow && _isallowed('write')"
            v-model="newOpEnd" 
            :disabled-date="disabledNewOpEndDate"
            value-type="YYYY-MM-DD"                     
            format="M/DD/YYYY"
            class="w-100"
            />
          <span v-if="_isallowed('write') && rowId == scope.row.id && scope.$index !== createRow">
          <v2-date-picker
            name="Date"    
            v-model="opEnd"   
            :disabled-date="disabledOpEndDate"  
            value-type="YYYY-MM-DD"                     
            format="M/DD/YYYY"
            class="w-100"
            />
          </span>
          <span v-if="rowId !== scope.row.id && scope.$index !== createRow">
            <span v-if="scope.row.option_period_end == null || scope.row.option_period_end == undefined" >        
            </span>
            <span v-else> {{ moment(scope.row.option_period_end).format("MM-DD-YYYY") }}
            </span>   
        </span>
      </template>
      </el-table-column>
      <el-table-column
      label="Actions"
        v-if="_isallowed('write') || _isallowed('delete') "
        width="130"
        fixed="right"
        align="center"
        >
        <template slot-scope="scope">
          <el-button
          type="default"
          @click="saveContractVehicle(scope.$index, scope.row)"
          v-if="( _isallowed('write') )  && scope.$index == rowIndex && (scope.row.name && 
            scope.row.full_name && scope.row.contract_sub_category_id &&
            scope.row.contract_agency_id && scope.row.contract_vehicle_type_id &&
            bpStart && bpEnd)" 
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
            v-if="( _isallowed('write') ) && (scope.$index !== rowIndex) && (scope.$index !== createRow)"
            @click="editMode(scope.$index, scope.row)"><i class="fal fa-edit text-primary"></i>
            </el-button>
            <el-button
            type="default"
            v-tooltip="`Delete`" 
            class="bg-light btn-sm"
            v-if="( _isallowed('delete') ) && (scope.$index !== rowIndex) && (scope.$index !== createRow)"
            @click="deleteContractVeh(scope.$index, scope.row)"><i class="far fa-trash-alt text-danger "></i>   
            </el-button>
            <el-button
            type="default"
            @click="saveContractVehicle(scope.$index, scope.row)"
            v-if="( _isallowed('write') )  && scope.$index == createRow && (scope.row.name && 
            scope.row.full_name && scope.row.contract_sub_category_id &&
            scope.row.contract_agency_id && scope.row.contract_vehicle_type_id &&
            newBpStart && newBpEnd)" 
            v-tooltip="`Save`" 
            class="bg-primary btn-sm text-light mx-0">               
          <i class="far fa-save"></i>
          </el-button> 
          <!-- <el-button
            type="default"
            @click="saveContractVehicle(scope.$index, scope.row)"
            v-if="scope.$index == createRow && 
            scope.row.name && scope.row.full_name && scope.row.contract_sub_category_id && 
            scope.row.contract_agency_id && scope.row.contract_vehicle_type_id && scope.row.ceiling &&
            newBpStart && newBpEnd" 
            v-tooltip="`Save`" 
            class="bg-primary btn-sm text-light mx-0">               
          <i class="far fa-save"></i>
          </el-button> -->
        </template>
      </el-table-column>
      </el-table>
      </div>
      </el-tab-pane>
      <el-tab-pane class="px-3"  style="postion:relative" label="SUBCONTRACT">
      <div style="height:72vh; overflow-y:auto">
      <el-table
        :data="subTableData"
         border      
        style="width: 95%">
      <el-table-column
          fixed
          label="Subcontract Prime*"
          width="215"
          prop="subprime_name">
        <template slot-scope="scope">
        <el-input
          tabindex="1"
          size="small"
          v-if="( _isallowed('write') ) && scope.$index == subCreateRow"
          placeholder=""
          style="text-align:center"
          v-model="scope.row.subprime_name"
          controls-position="right"
        ></el-input>
        <span v-if="( _isallowed('write') ) && rowId == scope.row.id && scope.$index !== subCreateRow">
        <el-input
          size="small"
          placeholder=""
          style="text-align:center"
          v-model="scope.row.subprime_name"
          controls-position="right"
          ></el-input>
        </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== subCreateRow">
      {{ scope.row.subprime_name }} 
      </span>

            </template>
        </el-table-column>
        <el-table-column
          fixed
          label="Vehicle Nick Name*"
          width="175"
          prop="name">
        <template slot-scope="scope">
        <el-input
          tabindex="1"
          size="small"
          v-if="( _isallowed('write') ) && scope.$index == subCreateRow"
          placeholder=""
          style="text-align:center"
          v-model="scope.row.name"
          controls-position="right"
        ></el-input>
        <span v-if="( _isallowed('write') ) && rowId == scope.row.id && scope.$index !== subCreateRow">
        <el-input
          size="small"
          placeholder=""
          style="text-align:center"
          v-model="scope.row.name"
          controls-position="right"
          ></el-input>
        </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== subCreateRow">
      {{ scope.row.name }} 
      </span>

            </template>
        </el-table-column>
        <el-table-column
          label="Vehicle Full Name*"
          width="300"
          >
        <template slot-scope="scope">
        <el-input
          tabindex="2"
          size="small"
          v-if="( _isallowed('write') ) && scope.$index == subCreateRow"
          placeholder=""
          style="text-align:center"
          v-model="scope.row.full_name"
          controls-position="right"
          ></el-input>
        <span v-if="( _isallowed('write') ) && rowId == scope.row.id && scope.$index !== subCreateRow">
        <el-input
          size="small"
          placeholder=""
          style="text-align:center"
          v-model="scope.row.full_name"
          controls-position="right"
          ></el-input>
        </span>
          <span v-if="rowId !== scope.row.id && scope.$index !== subCreateRow">
          {{ scope.row.full_name }}
          </span>

        </template>

        </el-table-column>
        <el-table-column
          label="Contract Name*"
          width="325"
        >

        <template slot-scope="scope">
        <el-input
          tabindex="2"
          size="small"
          v-if="( _isallowed('write') ) && scope.$index == subCreateRow"
          placeholder=""
          style="text-align:center"
          v-model="scope.row.contract_name"
          controls-position="right"
          ></el-input>
        <span v-if="( _isallowed('write') ) && rowId == scope.row.id && scope.$index !== subCreateRow">
        <el-input
          size="small"
          placeholder=""
          style="text-align:center"
          v-model="scope.row.contract_name"
          controls-position="right"
          ></el-input>
        </span>
          <span v-if="rowId !== scope.row.id && scope.$index !== subCreateRow">
          {{ scope.row.contract_name }}
          </span>

        </template>
        </el-table-column>
        <el-table-column
          label="Contracting Agency*"
          width="325"
        >

        <template slot-scope="scope" >
        <span v-if=" _isallowed('write') && (rowId == scope.row.id || scope.$index == subCreateRow)">
          <el-select
            tabindex="4"
            v-model="scope.row.contract_agency_id"
            filterable       
            track-by="name"        
            value-key="id"
            class="w-100"
            clearable
            allow-create
            default-first-option
            placeholder=""

          >
            <el-option
              v-for="item in contractAgencyOptions.filter(t => t.name !== 'null')"
              :key="item.id"
              :label="item.name"
              :value="item.id"
            >
            </el-option>
          </el-select>
          </span>
        <span v-if="rowId !== scope.row.id && scope.$index !== subCreateRow &&
          (scope.row.contract_agency && scope.row.contract_agency.name !== null)">
          {{ scope.row.contract_agency.name }}
          </span>
          </template>
        </el-table-column>
        <el-table-column
          label="Vehicle Type*"
          width="125"
        >
        <template slot-scope="scope" >
        <span v-if=" _isallowed('write')  && (rowId == scope.row.id || scope.$index == subCreateRow)">
          <el-select
            tabindex="5"
            v-model="scope.row.contract_vehicle_type_id"
            filterable       
            track-by="name"        
            value-key="id"
            class="w-100"
            clearable
            allow-create
            default-first-option
            placeholder=""

          >
            <el-option
              v-for="item in vehicleTypes.filter(t => t.name !== 'null')"
              :key="item.id"
              :label="item.name"
              :value="item.id"
            >
            </el-option>
          </el-select>
          </span>
          <span v-if="rowId !== scope.row.id && scope.$index !== subCreateRow &&
            (scope.row.contract_vehicle_type && scope.row.contract_vehicle_type.name !== null)">
          {{ scope.row.contract_vehicle_type.name }}
          </span>
          </template>
        </el-table-column>
      
        <el-table-column
          label="Vehicle/Contract Number"
          width="175"
        >
        <template slot-scope="scope" >    
          <el-input
          tabindex="7"
          size="small"
          v-if="( _isallowed('write') ) && scope.$index == subCreateRow"
          placeholder=""
          style="text-align:center"
          v-model="newContractNum"
          controls-position="right"
        ></el-input>
        <span v-if="( _isallowed('write') )">
        <el-input
          size="small"
          v-if="rowId == scope.row.id && scope.$index !== subCreateRow  && scope.row.contract_number"
          placeholder=""
          style="text-align:center"
          v-model="scope.row.contract_number.name"
          controls-position="right"
          ></el-input>
          <el-input
          size="small"
          v-if="rowId == scope.row.id && scope.$index !== subCreateRow  && !scope.row.contract_number"
          placeholder=""
          style="text-align:center"
          v-model="updateContractNum"
          controls-position="right"
          ></el-input>
        </span>
      <span v-if="rowId !== scope.row.id && scope.$index !== subCreateRow && scope.row.contract_number">
      {{ scope.row.contract_number.name }} 
      </span>

          </template>
        </el-table-column>
      
        
        <el-table-column
        label="Actions"
          v-if="_isallowed('write') || _isallowed('delete') "
          width="130"     
          fixed="right"
          align="center"
          >
          <template slot-scope="scope">
            <el-button
            type="default"
            @click="saveContractVehicle(scope.$index, scope.row)"
            v-if="( _isallowed('write') )  && scope.$index == rowIndex && (scope.row.subprime_name && scope.row.name && 
              scope.row.full_name && scope.row.contract_agency_id && scope.row.contract_vehicle_type_id)" 
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
              v-if="( _isallowed('write') ) && (scope.$index !== rowIndex) && (scope.$index !== subCreateRow)"
              @click="editMode(scope.$index, scope.row)"><i class="fal fa-edit text-primary"></i>
              </el-button>
              <el-button
              type="default"
              v-tooltip="`Delete`" 
              class="bg-light btn-sm"
              v-if="( _isallowed('delete') ) && (scope.$index !== rowIndex) && (scope.$index !== subCreateRow)"
              @click="deleteContractVeh(scope.$index, scope.row)"><i class="far fa-trash-alt text-danger "></i>   
              </el-button>
              <el-button
              type="default"
              @click="saveContractVehicle(scope.$index, scope.row)"
              v-if="( _isallowed('write') )  && scope.$index == subCreateRow && (scope.row.subprime_name && scope.row.name && 
              scope.row.full_name && scope.row.contract_agency_id && scope.row.contract_vehicle_type_id)" 
              v-tooltip="`Save`" 
              class="bg-primary btn-sm text-light mx-0">               
            <i class="far fa-save"></i>
            </el-button> 
            <!-- <el-button
              type="default"
              @click="saveContractVehicle(scope.$index, scope.row)"
              v-if="scope.$index == createRow && 
              scope.row.name && scope.row.full_name && scope.row.contract_sub_category_id && 
              scope.row.contract_agency_id && scope.row.contract_vehicle_type_id && scope.row.ceiling &&
              newBpStart && newBpEnd" 
              v-tooltip="`Save`" 
              class="bg-primary btn-sm text-light mx-0">               
            <i class="far fa-save"></i>
            </el-button> -->
          </template>
        </el-table-column>
      </el-table>
      </div>
      </el-tab-pane>    
    </el-tabs>
  </div>
</template>
    
<script>
import { mapGetters, mapMutations, mapActions } from "vuex";
 Vue.filter('toCurrency', function (value) {
    if (typeof value !== "number") {
        return value;
    }
    var formatter = new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD'
    });
    return formatter.format(value);
});


export default {
  name: "PortfolioVehicles",
  components: {
  },
      data() {    
      return {
        updateCeiling: 0,
        oneOne: 1,
        twoTwo: 2,
        newCeiling: null, 
        nothing: true,
        rowIndex: null, 
        lo: _.uniq(),
        rowId: null, 
        tabPosition: 'bottom',
        bpStart: null,
        newContractNum: '',
        updateContractNum: '',
        bpEnd: null,
        opStart: null,
        opEnd: null,
        newBpStart: null,
        newBpEnd: null,
        newOpStart: null,
        newOpEnd: null,
        search: '',
       };
  },
  
  methods: {
    ...mapMutations([
       "SET_CONTRACT_VEHICLE_STATUS"
    ]),
    ...mapActions([
      "createContractVehicle",
      "fetchContractVehicles",
      "updateContractVehicle",
      "deleteContractVehicle",
      'fetchContractProjects',
      "fetchContractDataOptions"
    ]),
    _isallowed(salut) {     
     return this.checkPortfolioContractPrivileges("PortfolioContracts", salut, this.$route, {settingType: 'Contracts'})
    }, 
    handleClick(tab, event){
      console.log(tab)
      console.log(`${"event:", event}`)
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
            return prev + curr;
          } else {
            return prev;
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
     return newSums
  },
    NumbersOnly(evt) {
      evt = (evt) ? evt : window.event;
      var charCode = (evt.which) ? evt.which : evt.keyCode;
      if ((charCode > 31 && (charCode < 48 || charCode > 57)) && charCode !== 46) {
        evt.preventDefault();;
      } else {
        return true;
        }
    },
    formatCurrency(value) {
      let val = (value/1).toFixed(2).replace('.', ',')
      return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".")
    },
    editMode(index, rows) {
      this.rowIndex = index,
      console.log(rows);    
      this.rowId = rows.id
      let formattedCeiling = parseFloat(rows.ceiling)
      if(rows.ceiling == null) {
        this.updateCeiling = ""
      } else this.updateCeiling = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(formattedCeiling);
     
      if(rows.base_period_start){
        this.bpStart = rows.base_period_start;
      }
      if(rows.base_period_end){
        this.bpEnd = rows.base_period_end;
      }
      if(rows.option_period_start){
        this.opStart = rows.option_period_start;
      }
      if(rows.option_period_end){
        this.opEnd = rows.option_period_end;
      }
    },  
    deleteContractVeh(index, rows) {
        this.$confirm(
        `Are you sure you want to delete ${rows.name} from Vehicles?`,
        "Confirm Delete",
        {
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          type: "warning",
        }
       ).then(() => {
        this.deleteContractVehicle(rows.id);
      });        
    },
    disabledBpEndDate(date) {
    if (this.bpStart){
      date.setHours(0, 0, 0, 0);
      const startDate = new Date(this.bpStart);
      startDate.setHours(48, 0, 0, 0);
      return date < startDate;  
      }      
    },  
    disabledOpEndDate(date) {
    if (this.opStart){
      // console.log(this.contractStartDate, date)
      date.setHours(0, 0, 0, 0);
      const startDate = new Date(this.opStart);
      startDate.setHours(48, 0, 0, 0);
      return date < startDate;  
      }      
    },  
    disabledNewBpEndDate(date) {
    if (this.newBpStart){
      date.setHours(0, 0, 0, 0);
      const startDate = new Date(this.newBpStart);
      startDate.setHours(48, 0, 0, 0);
      return date < startDate;  
      }      
    },  
    disabledNewOpEndDate(date) {
    if (this.newOpStart){
      // console.log(this.contractStartDate, date)
      date.setHours(0, 0, 0, 0);
      const startDate = new Date(this.newOpStart);
      startDate.setHours(48, 0, 0, 0);
      return date < startDate;  
      }      
    },  
    saveContractVehicle(index, rows){
      this.rowIndex = null;
      this.rowId = null;
      let id = null;    
      let contractNumberId = '';

      if (rows.id) {
        id = rows.id
        if (!this.bpEnd) {
          this.bpEnd = rows.base_period_end
        }
        if (!this.bpStart) {
          this.bpStart = rows.base_period_start
        }       
        if (!this.opStart){
          this.opStart = rows.option_period_start
        }
        if (!this.opEnd){
          this.opEnd = rows.option_period_end
        }
        if(this.updateContractNum)  {
          //  console.log("update")
            contractNumberId = this.updateContractNum
        }
        if(rows.contract_number){
          //  console.log("prexisting")
          contractNumberId = rows.contract_number.name
        }
      }
      if (!rows.id){
          this.bpStart = this.newBpStart;
          this.bpEnd = this.newBpEnd
          this.opStart = this.newOpStart;
          this.opEnd = this.newOpEnd; 
          if(this.newContractNum)  {
             contractNumberId = this.newContractNum
          }
      }
      // Row edit action will occur here
      let contractVehicleData = {
          cVehicleData: {
            name: rows.name,
            prime_name: rows.prime_name,
            subprime_name: rows.subprime_name,
            contract_name: rows.contract_name, 
            fullName: rows.full_name,
            subCatId: rows.contract_sub_category_id,
            cAgencyId: rows.contract_agency_id,        
            type: rows.contract_vehicle_type_id,
            cafFees: rows.caf_fees,
            contract_number_id: contractNumberId,
            ceiling: rows.ceiling,
            bp_startDate: this.bpStart,
            bp_endDate: this.bpEnd,
            op_startDate: this.opStart,
            op_endDate: this.opEnd,
        },
      };
      console.log(contractNumberId)
      if (id){
        this.updateContractVehicle({...contractVehicleData, id})
        console.log(contractVehicleData)
      } else {
        this.createContractVehicle({...contractVehicleData})     
      }
    }, 
  cancelEdits(index, rows) {
    this.rowIndex = null;
    this.rowId = null;
    this.updateContractNum = ''
       
  },
  backHomeBtn() {
      window.location.pathname = "/";
  },    
  handleDelete(index, row) {
    console.log(index, row);
  }
  },
  mounted() {
    // this.fetchContractVehicles()
  },
  computed: {
    ...mapGetters([
      "contractProjects",
       //Contract Vehicles
      "contractVehiclesStatus",
      "contractVehicles",
      "contractVehiclesLoaded",
      "contractVehicleStatus",
      "contractVehicle",
      "contractVehicleLoaded",
    ]),   
    tableData(){
      if (this.contractVehiclesLoaded && this.contractVehicles && this.contractVehicles.length > 0){
        let data = this.contractVehicles.filter(v => v && !v.is_subprime)
        console.log(data)
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
    subTableData(){
      if (this.contractVehiclesLoaded && this.contractVehicles && this.contractVehicles.length > 0){
        let data = this.contractVehicles.filter(v => v && v.is_subprime)
        console.log(data)
        data.push({})
        return data
     } else {
        let data = []
         data.push({})
         return data
     }  
    },
    subCreateRow(){
      let lastItem = this.subTableData.length - 1
      //  console.log(lastItem)
      return lastItem

    },
contractAgencyOptions(){
    if (this.contractVehicles && this.contractVehicles.length > 0){
      let uniqueAgencies = _.uniq(this.contractVehicles.filter(t => t.contract_agency_id))
      let agencies = uniqueAgencies.map(t => t.contract_agency).filter(t => t && t.id && t !== undefined && t !== null)
      let unique = [];
      // console.log(naics)
      agencies.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
      return unique
    }
  },
  sinsOptions(){
      if (this.contractVehicles && this.contractVehicles.length > 0){
      let uniqueSins = _.uniq(this.contractVehicles.filter(t => t.contract_sub_category_id))
      let sins = uniqueSins.map(t => t.contract_sub_category).filter(t => t && t.id && t !== undefined && t !== null)
      let unique = [];
      // console.log(naics)
      sins.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
      return unique
    }
  },
  vehicleTypes(){
      if (this.contractVehicles && this.contractVehicles.length > 0){
      let uniqueTypes = _.uniq(this.contractVehicles.filter(t => t.contract_vehicle_type_id))
      let types = uniqueTypes.map(t => t.contract_vehicle_type).filter(t => t && t.id && t !== undefined && t !== null)
      let unique = [];
      // console.log(naics)
      types.map(x => unique.filter(a => a.id == x.id).length > 0 ? null : unique.push(x));
      return unique
     }
    },
  },
  watch: {
   opStart:{
      handler() {
      if (this.opStart !== null) {
          this.opStart == this.opStart
          console.log(this.opStart)
       }
     }
    },
     contractVehicleStatus: {
      handler() {
        if (this.contractVehicleStatus == 200) {
          this.$message({
            message: `Vehicle data saved successfully.`,
            type: "success",
            showClose: true,
          });
          this.SET_CONTRACT_VEHICLE_STATUS(0);
          this.fetchContractVehicles();
          this.fetchContractProjects();
         this.fetchContractDataOptions();
          this.bpStart = null;
          this.newContractNum = '';
          this.updateContractNum = '';
          this.bpEnd = null;
          this.opStart = null;
          this.opEnd = null;   
          this.newBpStart = null;
          this.newBpEnd = null;
          this.newOpStart = null;
          this.newOpEnd = null;   
        }
      },
    },  
    
  },
};
</script>
    
<style scoped lang="scss">
  /deep/.el-scrollbar__view.el-select-dropdown__list{
    width: 450px !important;
  }
  .bottomTabs{
    position: absolute;
    bottom: 2.5%;
    width: 100%;
  }
  option {
    width: 200px; // Adjustable
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
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
  /deep/.el-table {
    font-size: 13px !important;
    th.el-table__cell>.cell {
      word-break: break-word;
      font-size: .88rem;
    }
    th {
      color: #383838;
    }
    td {
    max-width: 0;
    overflow: hidden;
    padding: 5px;
    text-overflow: ellipsis;
    white-space: nowrap;
   }
    tr, td {
      word-break: break-word;
    }
  }    
</style>