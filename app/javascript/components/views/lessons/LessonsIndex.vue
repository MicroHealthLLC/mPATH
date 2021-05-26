<template>
  <div id="members" data-cy="members_view" class="mt-5">
    <div class="container my-2 px-4 pt-2 wrapper" style="border-radius:3px">
      <h2 class="mt-1 mb-1"><span> <font-awesome-icon icon="clipboard" class="mr-2 text-dark"/></span>Lessons Learned</h2>
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
            <button
               class="btn btn-md btn-primary mr-3 addLessonBtn"
              @click.prevent="addNewLesson"
              data-cy="add_lesson"
            >
              <font-awesome-icon icon="plus-circle" />
              Add Lesson
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
              <th class="sort-th" @click="sort('title')">Title
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
              <!-- <th class="sort-th" @click="sort('lastName')">Last Name<span class="sort-icon scroll"><font-awesome-icon icon="sort" /></span> </th> -->
              <th class="sort-th" @click="sort('description')">Description
                <span class="inactive-sort-icon team-scroll" v-if="currentSort !== 'description'">
                  <font-awesome-icon icon="sort" /></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'asc' && currentSort === 'description'">
                  <font-awesome-icon icon="sort-up" /></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !== 'asc' && currentSort === 'description'">
                  <font-awesome-icon icon="sort-up" /></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir ==='desc' && currentSort === 'description'">
                  <font-awesome-icon icon="sort-down" /></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !=='desc' && currentSort === 'description'">
                  <font-awesome-icon icon="sort-down" /></span>
              </th>
              <th class="pl-1 sort-th" @click="sort('date')">Date
                <span class="inactive-sort-icon team-scroll" v-if="currentSort !== 'date'">
                  <font-awesome-icon icon="sort" /></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'asc' && currentSort === 'date'">
                  <font-awesome-icon icon="sort-up" /></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !== 'asc' && currentSort === 'date'">
                  <font-awesome-icon icon="sort-up" /></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir ==='desc' && currentSort === 'date'">
                  <font-awesome-icon icon="sort-down" /></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !=='desc' && currentSort === 'date'">
                  <font-awesome-icon icon="sort-down" /></span>
              </th>
<!--               <th class="sort-th emailCol" @click="sort('project_id')">Projects
                <span class="inactive-sort-icon team-scroll" v-if="currentSort !== 'project_id'">
                  <font-awesome-icon icon="sort" /></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir === 'asc' && currentSort === 'project_id'">
                  <font-awesome-icon icon="sort-up" /></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !== 'asc' && currentSort === 'project_id'">
                  <font-awesome-icon icon="sort-up" /></span>
                <span class="sort-icon team-scroll" v-if="currentSortDir ==='desc' && currentSort === 'project_id'">
                  <font-awesome-icon icon="sort-down" /></span>
                <span class="inactive-sort-icon team-scroll" v-if="currentSortDir !=='desc' && currentSort === 'project_id'">
                  <font-awesome-icon icon="sort-down" /></span>
              </th> -->
            </tr>
          </thead>
          <tbody>
            <tr v-for="(lesson, index) in sortedLessons" :key="index" @click.prevent="editLesson(lesson)" data-cy="user_data">
              <td class="text-center">{{lesson.id}}</td>
              <td>{{lesson.title}}</td>            
              <td>{{lesson.description}}</td>
              <td>{{ moment(lesson.date).format('DD MMM YYYY')}}</td>
              <!-- <td>{{JSON.stringify( lesson.facilities.map( f => (f.facilityName) ) ).replace(/]|[['"]/g, '') }}</td> -->
            </tr>
          </tbody>
        </table>
        <div v-if="tableData.length > 0" class="float-right mb-4 mt-1 font-sm">
          <div class="simple-select my-1 text-right d-inline-block font-sm">
            <span class="mr-2">Displaying </span>
            <el-select v-model="C_lessonsPerPage" class="w-33" track-by="value" value-key="id">
              <el-option v-for="item in getMembersPerPageFilterOptions" :value="item" :key="item.id" :label="item.name">
              </el-option>
            </el-select>
          </div>
          <span class="mr-1 ml-1 pr-3" style="border-right:solid 1px lightgray">Per Page </span>
          <button class="btn btn-sm page-btns ml-2" @click="prevPage"><i class="fas fa-angle-left"></i></button>
          <button class="btn btn-sm page-btns" id="page-count"> {{ currentPage }} of {{ Math.ceil( tableData.length / this.C_lessonsPerPage.value) }} </button>
          <button class="btn btn-sm page-btns" @click="nextPage"><i class="fas fa-angle-right"></i></button>
        </div>
        <div v-else class="float-right mb-4 mt-2 font-md mr-1">
         No Lessons Learned to Display
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import axios from 'axios'
import humps from 'humps'
import { mapGetters, mapMutations } from 'vuex'
import LessonForm from './LessonForm'

export default {
  name: "LessonsIndex",
  props: ['facility', 'from'],
  components: {
    LessonForm,
  },
  data() {
    return {
      newLesson: false,
      DV_facility: Object.assign({}, this.facility),
      currentLesson: null,
      pages: [],
      lessonsList: [],
      currentPage: 1,
      currentSort: 'title',
      currentSortDir: 'asc',
    }
  },
  mounted() {
    if (this.contentLoaded){
      this.fetchLessons()
      // if(!this.currentProject.lessons) {
      //   this.fetchLessons()
      // }else{
      //   this.lessonsList = this.currentProject.lessons
      // }
    }
  },
  computed: {
    ...mapGetters([
      'contentLoaded',
      'currentProject',
      'activeProjectUsers',
      'filterDataForAdvancedFilter',
      'getMembersPerPageFilterOptions',
      'getMembersPerPageFilter',
      'getTaskIssueUserFilter',
      'facilities',
      'projectId',
      'membersPerPageFilter'
    ]),
    tableData() {
      return this.lessonsList
    },
    orderedLessons: function() {
      return _.orderBy(this.lessonsList, 'title', 'asc')
    },
    sortedLessons: function() { 
      return this.tableData.sort((a, b) => {
        let modifier = 1;
        if (this.currentSortDir === 'desc') modifier = -1;
        if (a[this.currentSort] < b[this.currentSort]) return -1 * modifier;
        if (a[this.currentSort] > b[this.currentSort]) return 1 * modifier;
        return 0;
      }).filter((row, index) => {
        let start = (this.currentPage - 1) * this.C_lessonsPerPage.value;
        let end = this.currentPage * this.C_lessonsPerPage.value;
        if (index >= start && index < end) return true;
        return this.end
      });
    },
    C_lessonsPerPage: {
      get() {
        //return this.getMembersPerPageFilter || { id: 15, name: '15', value: 15 }
        return { id: 15, name: '15', value: 15 }
      },
      set(value) {
        this.setMembersPerPageFilter(value)
      }
    },
  },
  methods: {
    ...mapMutations([
      'setMembersPerPageFilter',
      'setLessonForManager',
    ]),
    // log(e){
    //   console.log("This is the lesson obj: " + JSON.stringify(e)) 
    // },
    editLesson(lesson) {
      this.$router.push(`/programs/${this.currentProject.id}/lessons/${lesson.id}`)
    },
    lessonCreated(risk) {
      this.facility.risks.unshift(risk)
      this.newRisk = false
      this.$emit('refresh-facility')
    },
    lessonUpdated(risk, refresh=true) {
      let index = this.facility.risks.findIndex((t) => t.id == risk.id)
      if (index > -1) Vue.set(this.facility.risks, index, risk)
      if (refresh) {
        this.newRisk = false
        this.$emit('refresh-facility')
      } else {
        this.updateFacilityHash(this.facility)
      }
    },
    addNewLesson() {
      this.setLessonForManager({key: 'lesson', value: {}})
      // Route to new task form page
      this.$router.push(
        `/programs/${this.$route.params.programId}/lessons/new`
      );
    },
    fetchLessons(){
      let url = `/projects/${this.currentProject.id}/lessons.json`
      let method = "GET"

      axios({
        method: method,
        url: url,
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').attributes['content'].value
        }
      })
      .then((response) => {
        this.lessonsList = humps.camelizeKeys(response.data.lessons)
        this.currentProject.lessons = this.lessonsList
      })
      .catch((err) => {
        // var errors = err.response.data.errors
        console.log(err)
        this.$message({
          message: err.response.data.error ,
          type: "error",
          showClose: true,
        });
      })
      .finally(() => {
        this.loading = false
      })
    },
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
      if ((this.currentPage * this.C_lessonsPerPage.value) < this.tableData.length) this.currentPage++;
    },
    prevPage: function() {
      if (this.currentPage > 1) this.currentPage--;
    },
    clear: function() {
      this.$alert('this button works',
      {
        confirmButtonText: 'OK',
        type:'info'      
      });
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
  },
  watch: {
    // This will fire off when page is refreshed because the application needs to wait until it receives data from the backend request
    contentLoaded: {
      handler() {
        if (this.$route.params.lessonId !== "new") {
          this.fetchLessons()
        }
      },
    },
  },
};
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