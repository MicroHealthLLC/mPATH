<template>
  <div id="members" data-cy="members_view" class="mt-5">
    <div class="container my-2 px-4 pt-2 wrapper" style="border-radius:3px">
      <h2 class="mt-1 mb-1"><span><i class="fas fa-users mr-2"></i></span>Team</h2>
      <div class="mb-0 p-b-0">
        <el-row>
          <el-col :span="9">
            <div class="input-group w-100 task-search-bar">
              <el-input type="search" data-cy="search_team_member" placeholder="Search Team Member Names"
                aria-label="Search" aria-describedby="search-addon" v-model="memberSearchQuery" id="memberSearch">
                <el-button slot="prepend" icon="el-icon-search"></el-button>
              </el-input>
            </div>
          </el-col>
          <div class="total" data-cy="team_total">
            <button @click.prevent="exportToPdf" v-tooltip="`Export to PDF`" id="printBtn"
              class="btn btn-md exportBtns text-light">
              <font-awesome-icon icon="file-pdf" />
            </button>
            <button v-tooltip="`Export to Excel`" @click.prevent="exportToExcel('table', 'Team Members List')"
              class="btn btn-md exportBtns text-light">
              <font-awesome-icon icon="file-excel" />
            </button>
            <button class="btn btn-md btn-info team-total">
              Team Total: {{ filteredMembers.members.length }}
            </button>
          </div>
        </el-row>

      </div>
      <div class="pb-2 table-div" data-cy="user_data">
        <table class="table table-sm table-bordered" id="taskList1" ref="table" data-cy="user_data_table">
          <thead style="min-height:50px" id="member_table_heading">
            <tr class="thead" style="background-color:#ededed;">
              <!-- <th class="sort-th firstCol" @click="sort('id')"># 
                <span class="inactive-sort-icon team-scroll" v-if="currentSort !== 'id'">    
                <i class="fas fa-sort"></i></span>            
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'asc' && currentSort === 'id'">                
                <i class="fas fa-sort-up"></i></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !== 'asc' && currentSort === 'id'">                
                <i class="fas fa-sort-up"></i></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir ==='desc' && currentSort === 'id'">                
                <i class="fas fa-sort-down"></i></span>  
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !=='desc' && currentSort === 'id'">                
                <i class="fas fa-sort-down"></i></span>                
             </th> -->
              <th class="sort-th" @click="sort('fullName')">Name
                <span class="inactive-sort-icon team-scroll" v-if="currentSort !== 'fullName'">
                  <i class="fas fa-sort"></i></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'asc' && currentSort === 'fullName'">
                  <i class="fas fa-sort-up"></i></span>
                <span class="inactive-sort-icon team-scroll"
                  v-if="currentSortDir !== 'asc' && currentSort === 'fullName'">
                  <i class="fas fa-sort-up"></i></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'desc' && currentSort === 'fullName'">
                  <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon team-scroll"
                  v-if="currentSortDir !== 'desc' && currentSort === 'fullName'">
                  <i class="fas fa-sort-down"></i></span>
              </th>
              <!-- <th class="sort-th" @click="sort('lastName')">Last Name<span class="sort-icon scroll"><i class="fas fa-sort"></i></span> </th> -->
              <th class="sort-th" @click="sort('title')">Position
                <span class="inactive-sort-icon team-scroll" v-if="currentSort !== 'title'">
                  <i class="fas fa-sort"></i></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'asc' && currentSort === 'title'">
                  <i class="fas fa-sort-up"></i></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !== 'asc' && currentSort === 'title'">
                  <i class="fas fa-sort-up"></i></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'desc' && currentSort === 'title'">
                  <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !== 'desc' && currentSort === 'title'">
                  <i class="fas fa-sort-down"></i></span>
              </th>
              <th class="pl-1 sort-th" @click="sort('organization')">Organization
                <span class="inactive-sort-icon team-scroll" v-if="currentSort !== 'organization'">
                  <i class="fas fa-sort"></i></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'asc' && currentSort === 'organization'">
                  <i class="fas fa-sort-up"></i></span>
                <span class="inactive-sort-icon team-scroll"
                  v-if="currentSortDir !== 'asc' && currentSort === 'organization'">
                  <i class="fas fa-sort-up"></i></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'desc' && currentSort === 'organization'">
                  <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon team-scroll"
                  v-if="currentSortDir !== 'desc' && currentSort === 'organization'">
                  <i class="fas fa-sort-down"></i></span>
              </th>
              <th class="pl-1 sort-th" @click="sort('phoneNumber')">Phone Number
                <span class="inactive-sort-icon team-scroll" v-if="currentSort !== 'phoneNumber'">
                  <i class="fas fa-sort"></i></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'asc' && currentSort === 'phoneNumber'">
                  <i class="fas fa-sort-up"></i></span>
                <span class="inactive-sort-icon team-scroll"
                  v-if="currentSortDir !== 'asc' && currentSort === 'phoneNumber'">
                  <i class="fas fa-sort-up"></i></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'desc' && currentSort === 'phoneNumber'">
                  <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon team-scroll"
                  v-if="currentSortDir !== 'desc' && currentSort === 'phoneNumber'">
                  <i class="fas fa-sort-down"></i></span>
              </th>
              <th class="sort-th emailCol" @click="sort('email')">Email
                <span class="inactive-sort-icon team-scroll" v-if="currentSort !== 'email'">
                  <i class="fas fa-sort"></i></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'asc' && currentSort === 'email'">
                  <i class="fas fa-sort-up"></i></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !== 'asc' && currentSort === 'email'">
                  <i class="fas fa-sort-up"></i></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'desc' && currentSort === 'email'">
                  <i class="fas fa-sort-down"></i></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !== 'desc' && currentSort === 'email'">
                  <i class="fas fa-sort-down"></i></span>
              </th>
            </tr>
          </thead>
          <tbody id="member_table_body">
            <tr v-for="(user, index) in sortedMembers" :key="index">
              <!-- <td class="text-center">{{user.id}}</td> -->
              <td>{{ user.fullName }}</td>
              <!-- <td>{{user.lastName}}</td> -->
              <td>{{ user.title }}</td>
              <td>{{ user.organization }}</td>
              <td>{{ user.phoneNumber }}</td>
              <td>{{ user.email }}</td>
            </tr>
          </tbody>
        </table>
        <div v-if="filteredMembers.members.length > 0" class="float-right mb-4 mt-1 font-sm">
          <div class="simple-select my-1 text-right d-inline-block font-sm">
            <span class="mr-2">Displaying </span>
            <el-select v-model="C_membersPerPage" class="w-33" track-by="value" value-key="id">
              <el-option v-for="item in getMembersPerPageFilterOptions" :value="item" :key="item.id" :label="item.name">
              </el-option>
            </el-select>
          </div>

          <span class="mr-1 ml-1 pr-3" style="border-right:solid 1px lightgray">Per Page </span>
          <button class="btn btn-sm page-btns ml-2" @click="prevPage"><i class="fas fa-angle-left"></i></button>
          <button class="btn btn-sm page-btns" id="page-count"> {{ currentPage }} of {{
            Math.ceil(filteredMembers.members.length / this.C_membersPerPage.value) }} </button>
          <button class="btn btn-sm page-btns" @click="nextPage"><i class="fas fa-angle-right"></i></button>
        </div>
        <div v-else class="float-right mb-4 mt-2 font-md mr-1">
          No Team Members to Display
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex'
import { jsPDF } from "jspdf"
import 'jspdf-autotable'
import MessageDialogService from "../../services/message_dialog_service";

export default {
  name: "TeamMembersView",
  props: ['facility', 'from'],
  data() {
    return {
      uri: 'data:application/vnd.ms-excel;base64,',
      template: '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="https://www.w3.org/TR/2018/SPSD-html401-20180327/"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
      base64: function (s) { return window.btoa(unescape(encodeURIComponent(s))) },
      format: function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) },
      total: 0,
      pages: [],
      currentPage: 1,
      currentSort: 'id',
      currentSortDir: 'asc',
      memberSearchQuery: '',
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
    orderedUsers: function () {
      return _.orderBy(this.activeProjectUsers, 'lastName', 'asc')
    },
    filteredMembers() {
      let memberData = [];
      memberData = this.tableData;
      let search = this.memberSearchQuery;
      let members = memberData.filter((m) => {
        if (search != "") {
          return (
            m.email.toLowerCase().match(search.toLowerCase()) ||
            m.title.toLowerCase().match(search.toLowerCase()) ||
            m.fullName.toLowerCase().match(search.toLowerCase()) ||
            m.organization.toLowerCase().match(search.toLowerCase()) ||
            m.phoneNumber.toLowerCase().match(search.toLowerCase())
          )
        } else return true;
      });
      return { members: members };
    },
    sortedMembers: function () {
      return this.filteredMembers.members.sort((a, b) => {
        let modifier = 1;
        if (this.currentSortDir === 'desc') modifier = -1;
        if (a[this.currentSort] < b[this.currentSort]) return -1 * modifier;
        if (a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
        return 0;
      }).filter((row, index) => {
        let start = (this.currentPage - 1) * this.C_membersPerPage.value;
        let end = this.currentPage * this.C_membersPerPage.value;
        if (index >= start && index < end) return true;
        return this.end
      });
    },
    C_membersPerPage: {
      get() {
        return this.getMembersPerPageFilter || { id: 15, name: '15', value: 15 }
      },
      set(value) {
        this.setMembersPerPageFilter(value);
        this.currentPage = 1;
      }
    },
  },
  methods: {
    ...mapMutations([
      'setMembersPerPageFilter'
    ]),
    changeHead({ row, column, rowIndex, columnIndex }) {
      return { backgroundColor: '#343F52', width: '100%' };
    },
    sort: function (s) {
      //if s == current sort, reverse
      if (s === this.currentSort) {
        this.currentSortDir = this.currentSortDir === 'asc' ? 'desc' : 'asc';
      }
      this.currentSort = s;
    },
    nextPage: function () {
      if ((this.currentPage * this.C_membersPerPage.value) < this.filteredMembers.members.length) this.currentPage++;
    },
    prevPage: function () {
      if (this.currentPage > 1) this.currentPage--;
    },
    clear: function () {
      alert('this button works')
      // document.getElementsByClassName("searchbox").empty();
    },
    exportToPdf() {
      const doc = new jsPDF("l")
      const html = this.$refs.table.innerHTML
      doc.autoTable({ html: '#taskList1' })
      doc.save("Team_Members_list.pdf")
    },
    exportToExcel(table, name) {
      if (!table.nodeType) table = this.$refs.table
      var ctx = { worksheet: name || 'Worksheet', table: table.innerHTML }
      var link = document.createElement('a');
      link.setAttribute('href', this.uri + this.base64(this.format(this.template, ctx)));
      link.setAttribute('download', 'Team_Members_list.xls');
      link.click();
    },
  }
}
</script>
<style scoped lang="scss">
#members {
  overflow-y: scroll;
  max-height: calc(100vh - 120px) !important;
  padding-bottom: 50px;
}

.table-div {
  overflow-y: auto;
  height: auto;
}

.wrapper {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, .10);
  border: 1px solid #dee2e6 !important;
  overflow-y: auto;
  height: auto;
}

.total {
  text-align: end;
  margin-bottom: .75rem;
  padding-right: 0;
}

.team-total {
  box-shadow: 0 2.5px 5px rgba(56, 56, 56, 0.19), 0 3px 3px rgba(56, 56, 56, 0.23);
}

.page-btns.active {
  background-color: rgba(211, 211, 211, 10%);
  border: none !important;
}

td {
  overflow-wrap: break-word;
}

#page-count {
  width: auto !important;
  cursor: default;
}

.firstCol {
  width: 8%;
}

.emailCol {
  width: 23%;
}

.w-33 {
  width: 33%;
}

input[type=search] {
  color: #383838;
  text-align: left;
  cursor: pointer;
  display: block;
}

.team-scroll {
  cursor: pointer !important;
  top: 28%;
  right: 5px;
  position: absolute;
  padding-left: 4px !important
}

#clear {
  cursor: pointer;
  margin: auto -23px;
}
</style>
