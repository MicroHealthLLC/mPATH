<template>
  <div id="members" data-cy="members_view">
     <div class="container mt-2"> 
        <h3 class="mt-1 mb-1"><span><i class="fas fa-users mr-2"></i></span>Team</h3>
        <div class="row mt-2 mb-1">
          <div class="col float-left">
          <button
            @click.prevent="download"
            id="printBtn"
            class="btn btn-sm btn-dark mb-1">
            <font-awesome-icon icon="file-pdf" class="mr-2" />
            Export to PDF
          </button>      
          </div>    
       
        </div>  
           <div class="mb-0 p-b-0">
            <el-row>
             <el-col :span="9">
             <div class="input-group w-100 task-search-bar">
                <div class="input-group-prepend">
                <span class="input-group-text" id="search-addon"><i class="fa fa-search"></i></span>
                </div>
               <input type="search"
                class="form-control form-control-sm"
                placeholder="Search All"
                aria-label="Search"
                aria-describedby="search-addon"
                v-model="filters[0].value" >
            </div>          
            </el-col>
              <div class="total" data-cy="team_total">
              <button class="btn btn-sm btn-info mb-3 team-total">
                Team Total: {{tableData.length}}
                </button>
              </div>   
            </el-row>
           </div>      
        <data-tables 
          :data="tableData"  
          ref="table" 
          class="teamMembersList"
          data-cy="team_members_list"          
          :pagination-props="{ pageSizes: [15, 25, 50, 100, 200] }" 
          layout="table, pagination" 
          :table-props="tableProps"     
          :filters="filters">
        <el-table-column 
          v-for="title in titles"                 
          :prop="title.prop" 
          :label="title.label" 
          :key="title.label" 
          sortable="custom">
        </el-table-column>      
      </data-tables>  
     </div>
  </div>
  
</template>

<script>
import {library} from '@fortawesome/fontawesome-svg-core'
import {faFilePdf} from '@fortawesome/free-solid-svg-icons'
import {mapGetters, mapActions} from 'vuex'
import VueDataTables from 'vue-data-tables'
import {jsPDF} from "jspdf"
import 'jspdf-autotable'
Vue.use(VueDataTables)
library.add(faFilePdf)
ELEMENT.locale(ELEMENT.lang.en)

  export default {
    name: "TeamMembersView",
     data() {
      return {        
        search: '',
        total: 0,     
        totalRows: 1,        
        tableProps: {
          stripe: true,
        defaultSort: {
          prop: 'id',
          order: 'ascending'
        },
          prop: 'organization',
          isSortable: false
       },
        filters: [
        {
          prop: ['id', 'firstName', 'lastName', 'title', 'organization', 'email', 'phoneNumber'],
          value: ''
        }
        ],
        layout: 'table, pagination',
        titles: [{
          prop: "id",
          label: "#"
          }, {
          prop: "firstName",
          label: "First Name"
          }, {
          prop: "lastName",
          label: "Last Name"
          }, {
          prop: "title",
          label: "Position"
          }, {
          prop: "organization",
          label: "Organization", 
          sortable: false
          }, {
          prop: "email",
          label: "Email"
          }, {
          prop: "phoneNumber",
          label: "Phone Number"
        }]
      }
    },
     computed: {
      ...mapGetters([
        'projectUsers'
      ]),
      tableData() {
        return this.projectUsers
      },
    }, 
     methods: {    
      download() {
        const doc = new jsPDF("l")
        const html = this.$refs.table.innerHTML
        doc.autoTable({ html: '.el-table .el-table__body-wrapper .el-table__body' })
        doc.save("Team_Members_list.pdf")
      }
    },
}
</script>
<style scoped lang="scss">
  /deep/.el-table {
    padding-top: 0px;
    margin-top:-1.5rem;
    width: 100%;
    margin-bottom: 6px;
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);  
  }
  /deep/.has-gutter {
    background-color: #ededed;
  }
  /deep/.el-pagination, .total {
    text-align: end;
    margin-bottom:2rem;
  }  
  .team-total {
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);  
  }
  input[type=search] {
    color: #383838;
    text-align: left;
    cursor: pointer;
    display: block;
 }

</style>
