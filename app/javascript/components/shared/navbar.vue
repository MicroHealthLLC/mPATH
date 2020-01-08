<template>
  <nav id="s-nav-wrap" class="navbar navbar-expand-lg blue-gradient navbar-light">
    <div class="s-nav-router">
      <ul class="navbar-nav my-2 my-lg-0">
        <li class="nav-item">
          <a class="nav-link" href="javascript:;">Facilities</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="javascript:;">Regions</a>
        </li>
      </ul>
    </div>
  </nav>
</template>

<script>
  export default {
    name: 'Navbar'
  }
</script>
<style scoped lang="scss">
  #s-nav-wrap {
    padding: 20px 60px;
    box-shadow: 0 2px 5px 0 rgba(0,0,0,0.16), 0 2px 10px 0 rgba(0,0,0,0.12);
    z-index: 1030;
    font-weight: 300;
    background: #fff;
  }
  .s-nav-router {
    position: absolute;
    right: 70px;
  }
</style>
