<script setup>
import WeatherCardComponent from '@/components/WeatherCardComponent.vue';


defineProps({
  data: Object,
  
})




</script>
<template>
    <div v-if="data!=null"  class="my-2 w-11/12">
        <h1 class="text-slate-100 text-3xl text-center">{{data.list[0].city}}</h1>
        <ul class="grid grid-cols-4 max-sm:grid-cols-1 max-md:grid-cols-2 max-lg:grid-cols-3 gap-2  mt-4">
          
          <li :key="item.date" v-for="item of data.list">
            <WeatherCardComponent :description="item.description" :icon="item.icon" :date="item.date" :temp="item.temp"/>
          </li>
        
        </ul>
        
      
    </div>
</template>