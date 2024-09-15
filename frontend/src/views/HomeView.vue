<script setup>
import MainLayout from '../layout/MainLayout.vue';
import SearchComponent from '@/components/SearchComponent.vue';
import { ref,watch } from 'vue';
import axios from 'axios';
import WeatherListComponent from '@/components/WeatherListComponent.vue';
import { useRoute } from 'vue-router';
const data=ref(null)
const loading = ref(false)
const message=ref({text:""})
const route = useRoute()
watch(() => route.params.url, fetchData, { immediate: true })
async function fetchData(){
  if(route.params.url==undefined || route.params.url==""){
    return
  }
  loading.value = true
  axios.post(route.params.url)
    .then(function (response) {
      data.value = response.data
    })
    .catch(function (error) {
      message.value = {text:error.response.data, type:'error'}
    })
    .finally(function () {
      loading.value = false
  });
    
}
</script>

<template>
 <MainLayout :message="message">
    <div  class="grid grid-cols-1 items-center justify-items-center pt-20">
      <SearchComponent :is-disabled-search="loading"/>
      <div v-if="loading">Loading...</div>
      <WeatherListComponent :data="data"/>
      
    </div>
   
  </MainLayout>
</template>
