<script setup>
import { ref, watch } from 'vue';
const props = defineProps({
    data : Object
})
const message = ref(null)
const baseStyle = "w-full h-full flex justify-between items-center py-2 px-4 text-lg text-slate-100 shadow-md"
const messageStyle = ref("")
watch(()=>props.data,()=>{
    message.value=props.data
    
    switch(message.value.type){
    case "error":
        messageStyle.value=baseStyle+" bg-red-300 shadow-red-200"
    break
    case "success":
        messageStyle.value=baseStyle+" bg-green-300 shadow-green-200"
    break
}
}, { immediate: true, deep: true })
</script>
<template>
    <div class="h-12">
    <div v-show="message.text!=''" :class="messageStyle">
        <h1>{{ message.text }}</h1> <button @click="()=>message.text=''"><i class="fa-solid fa-x hover:opacity-70"/></button>
    </div>
    </div>
</template>