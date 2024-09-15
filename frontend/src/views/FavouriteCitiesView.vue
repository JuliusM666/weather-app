<script setup>
import MainLayout from '../layout/MainLayout.vue';
import ConfirmModalComponent from '@/components/ConfirmModalComponent.vue';
import AddCityComponent from '@/components/AddCityComponent.vue';
import FavouriteCityListComponent from '@/components/FavouriteCityListComponent.vue';
import { ref } from 'vue';


const message=ref({text:""})
const loading = ref(false)
</script>

<template>
  <ConfirmModalComponent/>
  <MainLayout :message="message">
    <div  class="grid grid-cols-1 items-center justify-items-center pt-20">
      <AddCityComponent :is-loading="loading" @loading="(val)=>loading=val"  @message="(mess)=>message=mess"/>
      <FavouriteCityListComponent :is-loading="loading" @loading="(val)=>loading=val" @message="(mess)=>message=mess"/>
    </div>
  </MainLayout>
</template>
