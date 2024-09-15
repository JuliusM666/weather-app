<script setup>
defineProps({
    date: String,
    temp: String,
    description: String,
    icon: String,
})
</script>
<template>

<div class="bg-slate-100 rounded-xl shadow-slate-700  shadow-sm text-slate-600">
    <div class="grid grid-cols-2 items-center justify-items-center py-2">
        <h1 class="border-r border-slate-600 w-full text-center">{{date}}</h1>
        <h1>{{ temp }}</h1>
        
        
    </div>
    <div class="grid grid-cols-2 items-center h-full justify-items-center bg-slate-200 rounded-b-xl">
        <h1 class="text-center pl-2">{{description}}</h1>
        <img :src="icon" />
    </div>
</div>
</template>