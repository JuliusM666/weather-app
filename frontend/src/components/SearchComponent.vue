<script setup>
import { ref } from 'vue';
import { router } from '@/router';
import { onClickOutside } from '@vueuse/core';
defineProps({
    isDisabledSearch:Boolean
})
const mode = ref("by city")
const showModes = ref(false)
const outsideClickTarget = ref(null)
const search = ref("")
const latitude =ref("")
const longitude =ref("")
const toggleShowModes = () => showModes.value=!showModes.value
const setMode = (value) =>{
    mode.value=value
    toggleShowModes()
}
function submit(e){
    e.preventDefault()
    let url = import.meta.env.VITE_SERVER_URL+"search/"
    switch(mode.value){
        case "by city":
            url+="city?city="+search.value
        break
        case "by zip":
            url+="zip?zip="+search.value
        break
        case "by coord":
            url+="coord?lat="+latitude.value+"&lon="+longitude.value
        break
    }
    router.push({ name: 'search', params: { url:url } })
}
onClickOutside(outsideClickTarget,() => showModes.value = false)
</script>

<template>
    
        <form @submit="submit" class="relative  flex items-center justify-items-center shadow-2xl shadow-white" method="POST" action="">
        <input v-model="search" :disabled="mode=='by coord'" class="rounded-xl bg-slate-100  text-xl py-1  pl-3 pr-36 focus:outline-none" type="text" placeholder="search.."/>
        <input v-model="latitude" class="absolute rounded-xl text-md px-2 py-1 left-1  bg-blue-200  w-1/4" v-if="mode=='by coord'" placeholder="Latitude.."/>
        <input v-model="longitude" class="absolute rounded-xl text-md px-2 py-1  bg-blue-200  w-1/4 left-28" v-if="mode=='by coord'" placeholder="Longitude.."/>
        <button :disabled="isDisabledSearch" class="absolute bg-blue-300 rounded-xl px-3 py-1 hover:opacity-70 right-0.5">
            <i class="fa-solid fa-magnifying-glass"/>
        </button>
        
        <button ref="outsideClickTarget" type="button" @click="toggleShowModes" class="z-20 absolute w-24 right-11 top=2  bg-blue-300 px-1 py-1 rounded-xl   hover:opacity-70">
           
                {{ mode }}
                <i class="fa-solid fa-caret-down"/>
            
                
           
           
        </button>
        
        <div ref="outsideClickTarget" class="static">
        <div v-if="showModes" class="z-10 absolute bg-blue-200 w-24 rounded-b-xl px-2 py-1 right-11 top-6 pt-3">
            <button @click="setMode('by city')" class="w-full bg-blue-200 hover:opacity-70 py-2">by city</button>
            <button @click="setMode('by zip')" class="w-full bg-blue-200 hover:opacity-70 border-slate-400 border-t py-2">by zip</button>
            <button @click="setMode('by coord')" class="w-full bg-blue-200 hover:opacity-70 border-slate-400 border-t py-2">by coord</button>
        </div>
        </div>
        </form>
        
   
</template>