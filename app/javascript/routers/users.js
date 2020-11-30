import Profile from './../components/users/profile'

export default new VueRouter({
  routes: [
    {
      name: 'Profile',
      path: '/profile',
      component: Profile
    }
  ],
  hashbang: false,
  mode    : 'history',
  base    : '/',
  scrollBehavior () {
    return { x: 0, y: 0 }
  }
})
