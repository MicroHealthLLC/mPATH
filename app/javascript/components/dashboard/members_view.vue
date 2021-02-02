<template>
  <div id="members" data-cy="members_view" class="mt-5">
     <div class="container my-2 p-4 wrapper" style="border-radius:3px" > 
        <h2 class="mt-1 mb-1"><span><i class="fas fa-users mr-2"></i></span>Team</h2>  
           <div class="mb-0 p-b-0">              
            <el-row>
             <el-col :span="9">
             <div class="input-group w-100 task-search-bar">
                <div class="input-group-prepend">
                <span class="input-group-text" id="search-addon"><i class="fa fa-search"></i></span>                
            </div>
               <input 
                type="text"
                class="form-control searchbox form-control-sm"
                placeholder="Search Team Member Names"
                aria-label="Search"
                v-on:keyup="memberSearch"
                id="memberSearch"
                aria-describedby="search-addon"          
                data-cy="search_team_member">
            </div>
            </el-col>            
            <div class="total" data-cy="team_total">                 
              <button
                @click.prevent="exportToPdf"
                v-tooltip="`Export to PDF`"
                id="printBtn"
                class="btn btn-md exportBtns text-light">
                <font-awesome-icon icon="file-pdf" />              
              </button>     
               <button
                v-tooltip="`Export to Excel`"
                @click.prevent="exportToExcel('table', 'Team Members List')"
                class="btn btn-md exportBtns text-light">
                <font-awesome-icon icon="file-excel"/>         
              </button> 
              <button class="btn btn-md btn-info team-total">
                Team Total: {{tableData.length}}
                </button>
              </div>
            </el-row>

           </div>
       <div class="pb-3">              
         <table class="table table-sm table-bordered" id="taskList1"  ref="table">        
          <thead>
              <tr class="thead" style="background-color:#ededed;">
              <th class="sort-th" @click="sort('id')"># <span class="sort-icon scroll"><font-awesome-icon icon="sort" /></span></th>
              <th class="sort-th" @click="sort('fullName')">Name <span class="sort-icon scroll"><font-awesome-icon icon="sort" /></span></th>
              <!-- <th class="sort-th" @click="sort('lastName')">Last Name<span class="sort-icon scroll"><font-awesome-icon icon="sort" /></span> </th> -->
              <th class="sort-th"  @click="sort('title')">Position<span class="sort-icon scroll"><font-awesome-icon icon="sort" /> </span></th>
              <th class="pl-1 sort-th" @click="sort('organization')">Organization<span class="sort-icon scroll" ><font-awesome-icon icon="sort" /></span></th>
              <th class="pl-1 sort-th" @click="sort('phoneNumber')">Phone Number<span class="sort-icon scroll" ><font-awesome-icon icon="sort" /></span></th>
              <th class="sort-th"  @click="sort('email')" >Email<span class="sort-icon scroll"><font-awesome-icon icon="sort" /></span></th>
              
            </tr>
          </thead>
          <tbody>          
            <tr v-for="(user, index) in sortedMembers" :key="index">        
              <td class="text-center">{{user.id}}</td>
              <td>{{user.fullName}}</td>
              <!-- <td>{{user.lastName}}</td> -->
              <td>{{user.title}}</td>
              <td>{{user.organization}}</td>             
              <td>{{user.phoneNumber}}</td>
              <td>{{user.email}}</td>                        
            </tr>
          </tbody>          
        </table>
         <div class="float-right mb-4 font-sm">
           <span>Displaying </span>
           <div class="simple-select d-inline-block font-sm">
          
            <multiselect 
              v-model="C_membersPerPage" 
              track-by="value"
              label="name"      
              deselect-label=""                     
              :allow-empty="false"
              :options="getMembersPerPageFilterOptions">
                <template slot="singleLabel" slot-scope="{option}">
                      <div class="d-flex">
                        <span class='select__tag-name selected-opt'>{{option.name}}</span>
                      </div>
                </template>
            </multiselect>            
           </div>
          <span class="mr-1 pr-3" style="border-right:solid 1px lightgray">Per Page </span>
          <button class="btn btn-sm page-btns ml-2" @click="prevPage"><i class="fas fa-angle-left"></i></button>
          <button class="btn btn-sm page-btns" id="page-count"> {{ currentPage }} of {{ Math.ceil(this.tableData.length / this.C_membersPerPage.value) }} </button>
          <button class="btn btn-sm page-btns" @click="nextPage"><i class="fas fa-angle-right"></i></button>
        </div>
           </div>
     </div>   
  </div>

</template>

<script>

import {mapGetters, mapMutations} from 'vuex'
import {jsPDF} from "jspdf"
import 'jspdf-autotable'


  export default {
    name: "TeamMembersView",
    props: ['facility', 'from'],
     data() {
      return {
        uri :'data:application/vnd.ms-excel;base64,',
        template:'<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="https://www.w3.org/TR/2018/SPSD-html401-20180327/"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
        base64: function(s){ return window.btoa(unescape(encodeURIComponent(s))) },
        format: function(s, c) { return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) },
        total: 0, 
        pages: [],       
        currentPage:1,        
        currentSort:'id',
        currentSortDir:'asc',     
       }
     },
     computed: {
      ...mapGetters([
        'activeProjectUsers',
        'filterDataForAdvancedFilter',
        'getMembersPerPageFilterOptions',
        'getMembersPerPageFilter',
        'getTaskIssueUserFilter',
        'facilities',
        'membersPerPageFilter'
      ]),
      tableData() {           
        return this.activeProjectUsers        
      },
      orderedUsers: function() {     
        return _.orderBy(this.activeProjectUsers, 'lastName', 'asc')    
      },
      sortedMembers:function() {           
          return this.tableData.sort((a,b) => {
          let modifier = 1;
          if(this.currentSortDir === 'desc') modifier = -1;
          if(a[this.currentSort] < b[this.currentSort]) return -1 * modifier;
          if(a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
          return 0;
           }).filter((row, index) => {
              
          let start = (this.currentPage-1)*this.C_membersPerPage.value;
          let end = this.currentPage*this.C_membersPerPage.value;
          if(index >= start && index < end) return true;
          return this.end
        });
       },
     C_membersPerPage: {
      get() {
        return this.getMembersPerPageFilter || {id: 10, name: '10', value: 10}
      },
      set(value) {
        this.setMembersPerPageFilter(value)
      }

    },
     },
     methods: { 
           ...mapMutations([  
      'setMembersPerPageFilter'
    ]),
       changeHead({row, column, rowIndex, columnIndex}){
      return { backgroundColor: '#343F52', width: '100%' };
    
       },
      sort:function(s) {
        //if s == current sort, reverse
        if(s === this.currentSort) {
          this.currentSortDir = this.currentSortDir==='asc'?'desc':'asc';
        }
          this.currentSort = s;
        },
        nextPage:function() {
          if((this.currentPage*this.C_membersPerPage.value) < this.tableData.length) this.currentPage++;
        },
        prevPage:function() {
          if(this.currentPage > 1) this.currentPage--;
        },
       clear: function(){
            alert('this button works')
        // document.getElementsByClassName("searchbox").empty();
        },
       memberSearch() {
          var input, filter, table, tr, td, i, txtValue;
          input = document.getElementById("memberSearch");
          filter = input.value.toUpperCase();
          table = this.$refs.table;
          tr = table.getElementsByTagName("tr");
          for (i = 0; i < tr.length; i++) {
            td = tr[i].getElementsByTagName("td")[1];      
            if (td) {
              txtValue = td.textContent || td.innerText;
              if (txtValue.toUpperCase().indexOf(filter) > -1) {
                tr[i].style.display = "";
              } else {
                tr[i].style.display = "none";
              }
            }       
         }
      },
      exportToPdf() {     
        const doc = new jsPDF("l")
        const html = this.$refs.table.innerHTML    
        doc.autoTable({html: '#taskList1' })
        doc.save("Team_Members_list.pdf")   
      }, 
      exportToExcel(table, name){      
        if (!table.nodeType) table = this.$refs.table
        var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML}
        window.location.href = this.uri + this.base64(this.format(this.template, ctx))
      }
    },     
  }
</script>
<style scoped lang="scss">
  .wrapper {    
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, .10);
    border: 1px solid #dee2e6 !important;
  }
 .total {
    text-align: end;
    margin-bottom:.75rem;
    padding-right:0;
  }
  .team-total {
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
  }
  .page-btns.active  {
    background-color: rgba(211, 211, 211, 10%);
    border:none !important;
  }
  #page-count {
    width: auto !important;
    cursor: default;
  }
  input[type=search] {
    color: #383838;
    text-align: left;
    cursor: pointer;
    display: block;
 }
  #clear {
      cursor: pointer;
      margin: auto -23px;
    }
</style>