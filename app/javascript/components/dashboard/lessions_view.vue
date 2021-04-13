<template>
  <div id="members" data-cy="members_view" class="mt-5">
    <div class="container my-2 px-4 pt-2 wrapper" style="border-radius:3px">
      <h2 class="mt-1 mb-1"><span><i class="fas fa-document mr-2"></i></span>Lesson</h2>
      <div class="mb-0 p-b-0">
        <el-row>
          <el-col :span="9">
            <div class="input-group w-100 task-search-bar">
              <div class="input-group-prepend">
                <span class="input-group-text" id="search-addon"><i class="fa fa-search"></i></span>
              </div>
              <input type="text" class="form-control searchbox form-control-sm" placeholder="Search Lessons" aria-label="Search" v-on:keyup="memberSearch" id="memberSearch" aria-describedby="search-addon" data-cy="search_team_member">
            </div>
          </el-col>
          <div class="total" data-cy="team_total">
<!--             <button @click.prevent="exportToPdf" v-tooltip="`Export to PDF`" id="printBtn" class="btn btn-md exportBtns text-light">
              <font-awesome-icon icon="file-pdf" />
            </button>
            <button v-tooltip="`Export to Excel`" @click.prevent="exportToExcel('table', 'Team Members List')" class="btn btn-md exportBtns text-light">
              <font-awesome-icon icon="file-excel" />
            </button> -->
            <button class="btn btn-md btn-info team-total">
              New Lesson
            </button>
          </div>
        </el-row>
      </div>
      <div class="pb-2 table-div">
        <table class="table table-sm table-bordered" id="taskList1" ref="table">
          <thead style="min-height:50px">
            <tr class="thead" style="background-color:#ededed;">
              <th class="sort-th firstCol" @click="sort('id')">#
                <span class="inactive-sort-icon team-scroll" v-if="currentSort !== 'id'">
                  <font-awesome-icon icon="sort" /></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'asc' && currentSort === 'id'">
                  <font-awesome-icon icon="sort-up" /></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !== 'asc' && currentSort === 'id'">
                  <font-awesome-icon icon="sort-up" /></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir ==='desc' && currentSort === 'id'">
                  <font-awesome-icon icon="sort-down" /></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !=='desc' && currentSort === 'id'">
                  <font-awesome-icon icon="sort-down" /></span>
              </th>
              <th class="sort-th" @click="sort('fullName')">Title
                <span class="inactive-sort-icon team-scroll" v-if="currentSort !== 'fullName'">
                  <font-awesome-icon icon="sort" /></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'asc' && currentSort === 'fullName'">
                  <font-awesome-icon icon="sort-up" /></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !== 'asc' && currentSort === 'fullName'">
                  <font-awesome-icon icon="sort-up" /></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir ==='desc' && currentSort === 'fullName'">
                  <font-awesome-icon icon="sort-down" /></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !=='desc' && currentSort === 'fullName'">
                  <font-awesome-icon icon="sort-down" /></span>
              </th>
              <!-- <th class="sort-th" @click="sort('lastName')">Last Name<span class="sort-icon scroll"><font-awesome-icon icon="sort" /></span> </th> -->
              <th class="sort-th" @click="sort('title')">Description
                <span class="inactive-sort-icon team-scroll" v-if="currentSort !== 'title'">
                  <font-awesome-icon icon="sort" /></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'asc' && currentSort === 'title'">
                  <font-awesome-icon icon="sort-up" /></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !== 'asc' && currentSort === 'title'">
                  <font-awesome-icon icon="sort-up" /></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir ==='desc' && currentSort === 'title'">
                  <font-awesome-icon icon="sort-down" /></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !=='desc' && currentSort === 'title'">
                  <font-awesome-icon icon="sort-down" /></span>
              </th>
              <th class="pl-1 sort-th" @click="sort('organization')">Date
                <span class="inactive-sort-icon team-scroll" v-if="currentSort !== 'organization'">
                  <font-awesome-icon icon="sort" /></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'asc' && currentSort === 'organization'">
                  <font-awesome-icon icon="sort-up" /></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !== 'asc' && currentSort === 'organization'">
                  <font-awesome-icon icon="sort-up" /></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir ==='desc' && currentSort === 'organization'">
                  <font-awesome-icon icon="sort-down" /></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !=='desc' && currentSort === 'organization'">
                  <font-awesome-icon icon="sort-down" /></span>
              </th>
              <th class="pl-1 sort-th" @click="sort('phoneNumber')">Stage
                <span class="inactive-sort-icon team-scroll" v-if="currentSort !== 'phoneNumber'">
                  <font-awesome-icon icon="sort" /></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'asc' && currentSort === 'phoneNumber'">
                  <font-awesome-icon icon="sort-up" /></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !== 'asc' && currentSort === 'phoneNumber'">
                  <font-awesome-icon icon="sort-up" /></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir ==='desc' && currentSort === 'phoneNumber'">
                  <font-awesome-icon icon="sort-down" /></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !=='desc' && currentSort === 'phoneNumber'">
                  <font-awesome-icon icon="sort-down" /></span>
              </th>
              <th class="sort-th emailCol" @click="sort('email')">Program
                <span class="inactive-sort-icon team-scroll" v-if="currentSort !== 'email'">
                  <font-awesome-icon icon="sort" /></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'asc' && currentSort === 'email'">
                  <font-awesome-icon icon="sort-up" /></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !== 'asc' && currentSort === 'email'">
                  <font-awesome-icon icon="sort-up" /></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir ==='desc' && currentSort === 'email'">
                  <font-awesome-icon icon="sort-down" /></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !=='desc' && currentSort === 'email'">
                  <font-awesome-icon icon="sort-down" /></span>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(user, index) in sortedMembers" :key="index" data-cy="user_data">
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
        <div class="float-right mb-4 mt-1 font-sm">
          <div class="simple-select my-1 text-right d-inline-block font-sm">
            <span class="mr-2">Displaying </span>
            <el-select v-model="C_membersPerPage" class="w-33" track-by="value" value-key="id">
              <el-option v-for="item in getMembersPerPageFilterOptions" :value="item" :key="item.id" :label="item.name">
              </el-option>
            </el-select>
          </div>
          <span class="mr-1 ml-1 pr-3" style="border-right:solid 1px lightgray">Per Page </span>
          <button class="btn btn-sm page-btns ml-2" @click="prevPage"><i class="fas fa-angle-left"></i></button>
          <button class="btn btn-sm page-btns" id="page-count"> {{ currentPage }} of {{ Math.ceil(this.tableData.length / this.C_membersPerPage.value) }} </button>
          <button class="btn btn-sm page-btns" @click="nextPage"><i class="fas fa-angle-right"></i></button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { mapGetters, mapMutations } from 'vuex'
export default {
  name: "LessionsView",
  props: ['facility', 'from'],
  data() {
    return {
      pages: [],
      currentPage: 1,
      currentSort: 'id',
      currentSortDir: 'asc',
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
    sortedMembers: function() {
      return this.tableData.sort((a, b) => {
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
        this.setMembersPerPageFilter(value)
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
    sort: function(s) {
      //if s == current sort, reverse
      if (s === this.currentSort) {
        this.currentSortDir = this.currentSortDir === 'asc' ? 'desc' : 'asc';
      }
      this.currentSort = s;
    },
    nextPage: function() {
      if ((this.currentPage * this.C_membersPerPage.value) < this.tableData.length) this.currentPage++;
    },
    prevPage: function() {
      if (this.currentPage > 1) this.currentPage--;
    },
    clear: function() {
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
      doc.autoTable({ html: '#taskList1' })
      doc.save("Team_Members_list.pdf")
    },
    exportToExcel(table, name) {
      if (!table.nodeType) table = this.$refs.table
      var ctx = { worksheet: name || 'Worksheet', table: table.innerHTML }
      window.location.href = this.uri + this.base64(this.format(this.template, ctx))
    }
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