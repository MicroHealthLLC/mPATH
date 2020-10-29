<template>
  <div id="members">
    <div class="container mt-4" ref="content">
      <button @click="download" 
      id="printBtn" 
      class="btn btn-sm btn-outline-dark mt-1 mr-1 mb-1"
      style="font-size:.80rem" >EXPORT TO PDF</button>
       <button class="btn btn-sm btn-outline-dark m-1"
      style="font-size:.80rem"
      disabled>EXPORT TO CSV</button>
      <div class="table-responsive-md">
        <table class="table table-sm table-bordered" id="teamMembersList">        
          <thead>
            <tr>
              <th></th>
              <th>Name</th>
              <th>Title</th>
              <th>Organization</th>
              <th>Email</th>
              <th>Phone</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(user, i) in orderedUsers">
              <td class="text-center">{{i+1}}</td>
              <td>{{user.fullName}}</td>
              <td>{{user.title}}</td>
              <td>{{user.organization}}</td>
              <td><a :href="`mailto:${user.email}`">{{user.email}}</a></td>
              <td><a :href="`tel:${user.phoneNumber}`">{{user.phoneNumber}}</a></td>
              <td class="text-center">
                <span :class="`badge-${user.status}`">{{user.status}}</span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
  import {mapGetters, mapActions} from 'vuex';
  import  {jsPDF} from "jspdf";
  import 'jspdf-autotable';
  export default {
    name: "TeamMembersView",
    methods: {      
      download(){
        const doc = new jsPDF("l")
        const html = this.$refs.content.innerHTML

       doc.autoTable({ html: '#teamMembersList' })

       doc.save("Team_Members_list.pdf")
      }
    },
    computed: {
      ...mapGetters([
        'projectUsers'
      ]),
      orderedUsers: function() {
        return _.orderBy(this.projectUsers, 'lastName', 'asc')
      }
    }
  }
</script>

<style lang="scss">
</style>
