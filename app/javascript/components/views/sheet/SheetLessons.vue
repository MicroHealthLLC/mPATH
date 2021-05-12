<template>
  <div class="">
    <div class="my-3">
      <el-input type="search" placeholder="Search Lessons">
        <el-button slot="prepend" icon="el-icon-search"></el-button>
      </el-input>
    </div>
    <div class="wrapper p-3">
      <button class="btn btn-md btn-primary mr-3">
        <font-awesome-icon icon="plus-circle" />
        Add Lesson
      </button>
      <table>
        <colgroup></colgroup>
        <tr>
          <th>Lesson</th>
          <th>Date</th>
          <th>Successes</th>
          <th>Failures</th>
          <th>Best Practices</th>
        </tr>
        <tr>
          <td>Example Lesson Name</td>
          <td>Today</td>
          <td>Got everything done</td>
          <td>Nothing</td>
          <td>A best practice here...</td>
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
export default {};
</script>

<style lang="scss" scoped>
.wrapper {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  border: 1px solid #dee2e6;
}
</style>
