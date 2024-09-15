<script setup>
import axios from 'axios';
import { ref } from 'vue';
const city = ref("")
const emit = defineEmits(["message","loading"])
defineProps({
    isLoading: Boolean
})
function submit(e){
    e.preventDefault()
    emit("loading",true)
    let url = import.meta.env.VITE_SERVER_URL+"city/add?city="+city.value
    axios.post(url)
    .then(function (response) {
        emit('message',{text:response.data, type:'success'})
    
    })
    .catch(function (error) {
       emit('message',{text:error.response.data, type:'error'})
    })
    .finally(function(){
        emit("loading",false)
    });
    }
</script>
<template>
    <form @submit="submit" action="" method="POST" class="relative  flex items-center justify-items-center shadow-2xl shadow-white">
        <input v-model="city" class="rounded-xl bg-slate-100  text-xl py-1  pl-3 pr-36 focus:outline-none" type="text" placeholder="city.."/>
        <button :disabled="isLoading" class="absolute bg-blue-300 rounded-xl px-3 py-1 hover:opacity-70 right-0.5">
            <i class="fa-solid fa-plus"/>
        </button>
      </form>
</template>