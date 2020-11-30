<template>
  <div id="members">
    <div class="container mt-4">
      <h3 class="mt-3 mb-1"><span><i class="fas fa-users mr-2"></i></span>Team</h3>
      <button
        @click.prevent="download"
        id="printBtn"
        class="btn btn-sm btn-outline-dark mb-3"
      >Export to PDF</button>
      <button
        @click.prevent="tableToExcel('table', 'Team Members')"
        class="btn btn-sm btn-outline-dark ml-1 mb-3"
        disabled
        id="printBtn" 
      >Export to Excel</button>   
      <div>
      <h5 class="pb-0 team-total m-0 text-primary" style="display:inline-block;float:right">
        Team Total: {{ items.length }}
      </h5>
      </div>

      <div>         
        <sorted-table :values="values" ref="table" id="teamMembersList">
         <thead>
          <tr class="tableHead"> 
            <!-- <th scope="col" style="text-align: left; width: 4rem;">
            <sort-link name="id">#</sort-link>
            </th>                   -->
            <th scope="col" class="pl-3" style="text-align: left; width: 10rem;">
            <sort-link name="firstName">First Name</sort-link>
            </th>
             <th scope="col" style="text-align: left; width: 10rem;">
            <sort-link name="lastName">Last Name</sort-link>
            </th>
            <th scope="col" style="text-align: left; width: 8rem;">
            <sort-link name="title">Position</sort-link>
            </th>
            <th scope="col" style="text-align: left; width: 11rem;">
            <sort-link name="organization">Organization</sort-link>
            </th>
            <th scope="col" style="text-align: left; width: 15rem;">
            <sort-link name="email">Email</sort-link>
            </th>
             <th scope="col" style="text-align: left; width: 10rem;">
            <sort-link name="phoneNumber">Phone Number</sort-link>
            </th>
          </tr>
          </thead>
          <template #body="sort">
          <tbody>            
          <tr v-for="value in sort.values" :key="value.id" class="teamTable"   :load="log(value)"> 
            <!-- <td>{{ value.id }}</td>           -->
            <td class="pl-3" >{{ value.firstName }}</td>
            <td>{{ value.lastName }}</td>
            <td>{{ value.title }}</td>
            <td>{{ value.organization }}</td>
            <td><a :href="`mailto:${value.email}`">{{ value.email }}</a></td>
            <td><a :href="`tel:${value.phoneNumber}`">{{ value.phoneNumber }}</a></td>
          </tr>
          </tbody>
          </template>
        </sorted-table> 
        <paginated
        class="team-pagination"
        :page-count="getPageCount"
        :page-range="3"
        :margin-pages="2"
        :click-handler="clickCallback"
        :prev-text="'＜'"
        :next-text="'＞'"
        :container-class="'pagination'"
        :page-class="'page-item'">
       </paginated>       
      </div>
    </div>
  </div>
</template>

<script>

  import {mapGetters, mapActions} from 'vuex'
  import {jsPDF} from "jspdf"
  import 'jspdf-autotable'
  import VuejsPaginate from 'vuejs-paginate'
  Vue.component('paginated', VuejsPaginate)


  export default {
    name: "TeamMembersView",
     components: {
     VuejsPaginate
    },
    data() {
      return {  
        parPage: 8,
        currentPage: 1,     
        uri :'data:application/vnd.ms-excel;base64,',
        template:'<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="https://www.w3.org/TR/2018/SPSD-html401-20180327/"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
        base64: (s) => window.btoa(unescape(encodeURIComponent(s))),
        format: (s, c) => s.replace(/{(\w+)}/g, function(m, p) { return c[p]; })
      }
    },
    methods: {
      //download() method for PDF
      //tableToExcel() method for excel
      clickCallback: function (pageNum) {
        this.currentPage = Number(pageNum);
       },
       log(value) {
       console.log(value)
       },
      download() {
        const doc = new jsPDF("l")
        const html = this.$refs.table.innerHTML
        doc.autoTable({ html: '#teamMembersList' })
        doc.save("Team_Members_list.pdf")
      },
      tableToExcel(table, name) {
        if (!table.nodeType) table = this.$refs.table
        let ctx = {worksheet: name || 'Worksheet', table: table.innerHTML}
        window.location.href = this.uri + this.base64(this.format(this.template, ctx))
      },
     onChangePage(values) {
            // update page of items
            this.values = values;
        }
    },
    computed: {
      ...mapGetters([
        'projectUsers'
      ]),
      items() {
        return this.projectUsers
      },
      values: function() {
        let current = this.currentPage * this.parPage;
        let start = current - this.parPage;
        return this.items.slice(start, current);
      },
      getPageCount: function() {
        return Math.ceil(this.items.length / this.parPage);  
      }
    },
  }
</script>

<style scoped lang="scss">
 table {
    table-layout: fixed ;   
    margin-bottom: .5rem !important;   
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);   
  }
  thead {
    background-color: #ededed;
  }
  td {
    overflow-wrap: break-word;
   
  }
  .teamTable:hover {
   cursor: default;
    background-color: rgba(91, 192, 222, 0.3);
    border-left: solid rgb(91, 192, 222);
  }

  a:visited, a:active, a:hover {
    text-decoration-line: none !important;    
  }
  th > a {
    color: #383838 !important;
  }
  /deep/.team-pagination {
    margin-top: 8px;
    list-style: none !important;
    user-select: none;
    float:right;

    a:visited, a:active, a:hover {
      text-decoration-line: none !important;    
    }
    li { 
      display: inline !important;
      margin-bottom: 20px !important;     
     }
    a {
      width: 30px;
      height: 36px;
      margin-right: 1px;
      background-color: white;
      box-shadow: 0 5px 10px rgba(56,56, 56,0.19), 0 6px 6px rgba(56,56,56,0.23);
      color: #383838;
      padding: 10px 24px;
      padding-bottom: 10px !important;
      cursor: pointer;
    }
    a:hover {
      background-color: #ededed
    }
    li.active a {
      font-weight: bold;
      background-color: rgba(211, 211, 211, 10%);
    }
    a.active  {
      background-color: rgba(211, 211, 211, 10%);
    }
    li.next:before {
      content: ' | ';
      margin-right: 13px;
      color: #ddd;
    }
    li.disabled a {
      color: #ccc;
      cursor: no-drop;
    }
  }
  
  
</style>
