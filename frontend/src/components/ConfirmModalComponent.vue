<script setup>
import { onClickOutside } from '@vueuse/core';
import { ref,watch} from 'vue';
import { confirmModal } from '@/states/confirmModal';
const outsideClickTarget = ref(null)

watch(()=>confirmModal.isShow,()=>{
    if(confirmModal.isShow){
        
    document.getElementById("main").style.filter="opacity(20%)"
    }
})
function confirm(){
    hide()
    confirmModal.confirm=true
}
function hide(){
    document.getElementById("main").style.filter=""
    confirmModal.isShow=false
}
onClickOutside(outsideClickTarget,() => hide())
</script>

<template>
    <div ref="outsideClickTarget" v-if="confirmModal.isShow" class="absolute z-10 top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 bg-slate-100 text-slate-700 text-lg p-2 rounded-lg grid gap-2">
        <div class="p-2 border-b border-slate-400 whitespace-nowrap">Do you want to delete {{ confirmModal.city }}?</div>
        <div class="grid grid-cols-2 gap-2 font-semibold">
            <button class="bg-blue-300 rounded-lg p-2 hover:opacity-70" @click="confirm">Yes</button>
            <button class="bg-slate-200  rounded-lg p-2 hover:opacity-70" @click="hide">No</button>
        </div>
    </div>
</template>