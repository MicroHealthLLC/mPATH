<template>
  <div>
     <div class="container mt-2">          
          <h3 class="mt-1 mb-1"><span><i class="fas fa-users mr-2"></i></span>Team</h3>
          <button
            @click.prevent="download"
            id="printBtn"
            class="btn btn-sm btn-dark mb-1">
            <font-awesome-icon icon="file-pdf" class="mr-2" />
            Export to PDF
          </button>  
           
          <b-row class="search-row pt-2 pb-0 pl-3">  
          <b-col sm="6" md="4" lg="4" class="my-1 pl-0">           
            <b-input-group size="sm" style="height:38px">
               <div class="input-group-prepend">
                <span class="input-group-text" id="search-addon"><i class="fa fa-search"></i></span>
               </div>
              <b-form-input
                v-model="filter"
                style="height:38px"
                type="search"
                id="filterInput"
                placeholder="Search Team Members"
              ></b-form-input>                  
            </b-input-group>    
          </b-col>

        <b-col class="my-1 pl-3 float-right justify-content-end">           
        <div class="float-right">
            <button class="btn btn-md btn-info mb-3 team-total">
            Team Total: {{items.length}}
            </button>
          </div>  
          <b-col sm="5" md="6" lg="6" class="my-1">
        <b-form-group
          label="Team Members per page"
          label-cols-sm="6"
          label-cols-md="6"
          label-cols-lg="6"
          label-align-sm="right"
          label-size="sm"
          label-for="perPageSelect"
          class="mb-0"
        >
          <b-form-select
            v-model="perPage"
            id="perPageSelect"
            size="sm"
            :options="pageOptions"
          ></b-form-select>
        </b-form-group>
      </b-col> 
        </b-col>
        </b-row>        
        <!-- <paginate ref="paginator" name="items" :list="items" :per="perPage" class="paginate-list" :key="items ? items.length : 1"> -->
        <b-table sticky-header hover 
          class="btable"   
          show-empty   
          sort-icon-left    
          :items="items"
          :fields="fields"
          :sort-by.sync="sortBy"
          :sort-desc.sync="sortDesc"
          :current-page="currentPage"
          :per-page="perPage"
          sort-icon-right
          :filter="filter"
          :filter-included-fields="filterOn"         
          :sort-direction="sortDirection"
          @filtered="onFiltered"
          responsive="md"   
        >              
        </b-table>  
                 
          <div>
          <small>Sorting By: <b>{{ sortBy }}</b> | Sort Direction:
          <b>{{ sortDesc ? 'Descending' : 'Ascending' }}</b></small>
           <b-pagination
          v-model="currentPage"
          :total-rows="totalRows"
          :per-page="perPage"         
          align="fill"
          size="sm"
          class="my-0 float-right"         
        ></b-pagination>
        </div>     
    
        
   </div>
  </div>
</template>

<script>
import {mapGetters, mapActions} from 'vuex'
import {jsPDF} from "jspdf"
import 'jspdf-autotable'
import {library} from '@fortawesome/fontawesome-svg-core'
import {faFilePdf} from '@fortawesome/free-solid-svg-icons'
library.add(faFilePdf)
  export default {
    name: "TeamMembersView",
    data() {
      return {
        sortBy: 'id',
        sortDesc: false,
        sortDirection: 'asc',
        pageOptions: [5, 15, 25, 50,  { value: 100, text: "+100" }],
        totalRows: 1,        
        currentPage: 1,
        filter: null,
        filterOn: [],
        perPage: 15,
        fields: [
          { key: 'id', label:"#", sortable: true, class: 'text-left' },
          { key: 'firstName', sortable: true, class: 'text-left' },
          { key: 'lastName', sortable: true, class: 'text-left' },
          { key: 'title', sortable: true, label: 'Position', class: 'text-left' },
          { key: 'organization', sortable: true,class: 'text-left' },
          { key: 'email', sortable: true, class: 'text-left' },
          { key: 'phoneNumber', sortable: true, class: 'text-left' }
        ], 
      }
    }, 
     mounted() {    
      this.totalRows = this.items.length
    },  
    computed: {
      ...mapGetters([
        'projectUsers'
      ]),
      items() {
        return this.projectUsers
      },
       sortOptions() {
        // Create an options list from our fields
        return this.fields
          .filter(f => f.sortable)
          .map(f => {
            return { text: f.label, value: f.key }
          })
      }
    },  
     methods: {
        onFiltered(filteredItems) {
        // Trigger pagination to update the number of buttons/pages due to filtering
        this.totalRows = filteredItems.length
        this.currentPage = 1
      },      
    }
  }
</script>
<style scoped lang="scss">
 /deep/.btable {
    table-layout: fixed;
    padding-top: 0px;
    margin-top:0;
    width: 100%;
    // min-height: 450px !important;
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
    overflow-y:auto !important;
  } 
  /deep/thead {
    background-color:#ededed !important;
    height: 60px !important;
  }
  /deep/td {
    overflow-wrap: break-word !important;
    padding: 5px !important;
  }
  .team-total {
    cursor: default;
  }
</style>