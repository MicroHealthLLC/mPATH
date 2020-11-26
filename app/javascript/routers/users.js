
export default new VueRouter({
  routes: [
    {
      name: 'Profile',
      path: '/profile',
      component: () => import('./../components/users/profile')
    }
  ],
  hashbang: false,
  mode    : 'history',
  base    : '/',
  scrollBehavior () {
    return { x: 0, y: 0 }
  }
})
