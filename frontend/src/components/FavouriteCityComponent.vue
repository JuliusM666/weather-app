<script setup>
import axios from 'axios';
import { router } from '@/router';
import { watch } from 'vue';
import { confirmModal } from '@/states/confirmModal';
const emit = defineEmits(["message"])
const props=defineProps({
    date: String,
    temp: String,
    description: String,
    icon: String,
    city: String,
})
function showConfirm(event){
    event.stopPropagation()
    confirmModal.isShow = true
    confirmModal.city = props.city
   
}
watch(()=>confirmModal.confirm,deleteCity)
function deleteCity(){
    if(confirmModal.confirm!=true){
        return
    }
    confirmModal.confirm=false
    axios.post(import.meta.env.VITE_SERVER_URL+"city/delete?city="+props.city)
    .then(function (response) {
        emit('message',{text:response.data, type:'success'}) 
    })
    .catch(function (error) {
        emit('message',{text:error.response.data, type:'error'})
    });
}
function showForecasts(){
    router.push({ name: 'search', params: { url:import.meta.env.VITE_SERVER_URL+'search/city?city='+props.city} })
}

</script>
<template>
<div @click="showForecasts" class="shadow-slate-700 bg-slate-200 rounded-xl hover:cursor-pointer hover:opacity-70 shadow-sm text-slate-600">
    <div class="col-span-2 flex justify-between items-center w-full pr-1 py-1 pl-2">
            <h1 class="font-bold">{{ city }}</h1>  
            <button @click="(event)=>showConfirm(event)" class=" bg-blue-300 rounded-xl px-3 py-1 hover:opacity-70">
                <i class="fa-solid fa-trash"/>
            </button>
        </div>
    
    <div class="grid grid-cols-2 items-center rounded-xl bg-slate-100 justify-items-center mx-1 py-2">
       
        <h1 class="border-r border-slate-600  w-full text-center">{{date}}</h1>
        <h1>{{ temp }}</h1>
        
        
    </div>
    <div class="grid grid-cols-2 items-center h-full justify-items-center">
        <h1 class="text-center pl-2">{{description}}</h1>
        <img :src="icon" />
    </div>
</div>
</template>