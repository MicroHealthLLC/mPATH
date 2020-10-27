<template>
  <div id="members">
    <div class="container mt-4">
      <div class="table-responsive-md">
        <table class="table table-sm table-bordered">
          <thead>
            <tr>
              <th></th>
              <th>Name</th>
              <th>Title</th>
              <th>Organization</th>
              <th>Email</th>
              <th>Ph Number</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(user, i) in projectUsers">
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
  import {mapGetters, mapActions} from 'vuex'
  export default {
    name: "TeamMembersView",
    computed: {
      ...mapGetters([
        'projectUsers'
      ])
    }
  }
</script>

<style lang="scss">
</style>
