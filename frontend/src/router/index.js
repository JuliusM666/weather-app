import { createMemoryHistory, createRouter } from 'vue-router'

import HomeView from '@/views/HomeView.vue'
import FavouriteCitiesView from '@/views/FavouriteCitiesView.vue'

const routes = [
  { path: '/:url?', component: HomeView ,name:"search" ,props:true},
  { path: '/favourite-cities', component: FavouriteCitiesView },
]

export const router = createRouter({
  history: createMemoryHistory(),
  routes,
})