<script setup>
import FavouriteCityComponent from './FavouriteCityComponent.vue';
import axios from 'axios';
import { ref,watch } from 'vue';
import { useWebSocket } from '@vueuse/core';
defineProps({
  isLoading:Boolean
})
const emit = defineEmits(["message","loading"])
const { data } = useWebSocket("/webSocket", {
  autoReconnect: {
    retries: 3,
    delay: 5000,
    onFailed() {
      alert('Failed to connect WebSocket after 3 retries')
    },
  },
  heartbeat: {
    message: 'ping',
    responseMessage: 'pong',
    interval: 10000,
    pongTimeout: 10000,
  },
})
watch(data,getFavouriteCities,{ immediate: true })
const favouriteCities=ref({value:false})
function getFavouriteCities(){
  data.value = ""
  emit("loading",true)
  axios.get(import.meta.env.VITE_SERVER_URL+"favourite-cities")
    .then(function (response) {
      favouriteCities.value = response.data
    })
    .catch(function (error) {
      console.log(error.response.data)
        
    })
    .finally(function(){
      emit("loading",false)
    });
    
}




</script>
<template>
  <div v-if="isLoading">Loading...</div>
    <div v-if="favouriteCities.value!=false"  class="my-2 w-11/12">
        <ul class="grid grid-cols-4 max-sm:grid-cols-1 max-md:grid-cols-2 max-lg:grid-cols-3 gap-2  mt-4">
            
          <li :key="item.list[0].date" v-for="item of favouriteCities">
            <FavouriteCityComponent @message="(mess)=>emit('message',mess)" :city="item.list[0].city" :description="item.list[0].description" :icon="item.list[0].icon" :date="item.list[0].date" :temp="item.list[0].temp"/>
          </li>
        
        </ul>
        
      
    </div>
</template>