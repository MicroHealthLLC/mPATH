<template>
  <div id="members">
    <div class="container mt-4">
      <h3 class="mt-3 mb-1"><span><i class="fas fa-users mr-2"></i></span>Team</h3>
      <button
        @click.prevent="download"
        id="printBtn"
        class="btn btn-sm btn-dark mb-3">
        <font-awesome-icon icon="file-pdf" class="mr-2" />
        Export to PDF
      </button>
      <div class="float-right">
        <button class="btn btn-md btn-info mb-3 team-total">
        Team Total: {{teamMembers.length}}
        </button>
      </div>
      <div>
        <table ref="table" id="teamMembersList" class="table-bordered">
          <thead>
            <tr class="teamHead">
              <th class="sort-th col-1" @click="sort('id')">#<i class="fas fa-sort scroll"></i></th>
              <th class="sort-th" @click="sort('firstName')">First Name<i class="fas fa-sort scroll"></i></th>
              <th class="sort-th" @click="sort('lastName')">Last Name<i class="fas fa-sort scroll"></i> </th>
              <th class="sort-th" @click="sort('title')">Position<i class="fas fa-sort scroll ml-2"></i></th>
              <th class="sort-th" @click="sort('organization')">Organization<i class="fas fa-sort scroll"></i></th>
              <th class="sort-th" @click="sort('email')">Email<i class="fas fa-sort scroll" ></i></th>
              <th class="sort-th" @click="sort('phoneNumber')">Phone Number<i class="fas fa-sort scroll"></i></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="value in sortedTeamMembers" :key="value.id" class="teamTable">
              <td id="col-1-row">{{ value.id }}</td>
              <td>{{ value.firstName }}</td>
              <td>{{ value.lastName }}</td>
              <td>{{ value.title }}</td>
              <td>{{ value.organization }}</td>
              <td><a :href="`mailto:${value.email}`">{{ value.email }}</a></td>
              <td><a :href="`tel:${value.phoneNumber}`">{{ value.phoneNumber }}</a></td>
            </tr>
          </tbody>
        </table>
        <div class="float-right my-3">
          <button class="btn btn-sm page-btns h-auto" @click="prevPage"><i class="fas fa-angle-left"></i></button>
          <button class="btn btn-sm page-btns h-auto disabled" id="page-count">Page {{ currentPage }} of {{ Math.ceil(this.teamMembers.length / pageSize) }} </button>
          <button class="btn btn-sm page-btns h-auto" @click="nextPage"><i class="fas fa-angle-right"></i></button>
        </div>
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
        pageSize: 25,
        currentPage: 1,
        currentSort: 'id',
        currentSortDir: 'asc',
      }
    },
    methods: {
      sort(s) {
        if (s === this.currentSort) {
          this.currentSortDir = this.currentSortDir === 'asc' ? 'desc' : 'asc';
        }
        this.currentSort = s;
      },
      nextPage() {
        if ((this.currentPage*this.pageSize) < this.teamMembers.length) this.currentPage++;
      },
      prevPage() {
        if(this.currentPage > 1) this.currentPage--;
      },
      download() {
        const doc = new jsPDF("l")
        const html = this.$refs.table.innerHTML
        doc.autoTable({ html: '#teamMembersList' })
        doc.save("Team_Members_list.pdf")
      }
    },
    computed: {
      ...mapGetters([
        'projectUsers'
      ]),
      teamMembers() {
        return this.projectUsers
      },
      sortedTeamMembers() {
        return this.teamMembers.sort((a,b) => {
          let modifier = 1;
          if (this.currentSortDir === 'desc') modifier = -1;
          if (a[this.currentSort] < b[this.currentSort]) return -1 * modifier;
          if (a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
          return 0;
        }).filter((row, index) => {
          let start = (this.currentPage-1) * this.pageSize;
          let end = this.currentPage * this.pageSize;
          if (index >= start && index < end) return true;
          return end
        });
      }
    }
  }
</script>

<style scoped lang="scss">
 table {
    table-layout: fixed;
    width: 100%;
    box-shadow: 0 2.5px 5px rgba(56,56, 56,0.19), 0 3px 3px rgba(56,56,56,0.23);
  }
  .col-1 {
    width: 6%
  }
  #col-1-row {
    text-align: center;
  }
  thead {
    background-color: #ededed;
  }
  .sort-th {
    font-size: 1rem !important;
    text-align: center;
  }
  .teamHead {
    height: 40px;
  }
  td {
    overflow-wrap: break-word;
    padding: 5px !important;
  }
 .scroll {
    cursor:pointer !important;
    top: 12px;
    right: 5px;
    position:absolute;
    font-size: 1rem;
    color: #383838 !important;
    padding-left:4px !important
  }
  /deep/.sort-th {
    position:relative;
    padding: 3px;
    cursor: pointer;
    letter-spacing: 2px;
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
  .page-btns {
    width: 20px;
    line-height: 1 !important;
    border: none !important;
    height: 25px;
    margin-right: 1px;
    background-color: white;
    box-shadow: 0 5px 10px rgba(56,56, 56,0.19), 0 6px 6px rgba(56,56,56,0.23);
    color: #383838;
    cursor: pointer;
  }
  .page-btns:hover {
    background-color: #ededed;
  }
  #page-count {
    width: auto !important;
    cursor: default;
  }
  .page-btns.active  {
    background-color: rgba(211, 211, 211, 10%);
    border: none !important;
  }
  .team-total {
    cursor: default;
  }
</style>