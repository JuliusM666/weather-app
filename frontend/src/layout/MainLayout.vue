<script setup>
import MessageComponent from '@/components/MessageComponent.vue';
import HeaderComponent from '@/components/HeaderComponent.vue';
defineProps({
    message:Object
})

</script>

<template>
    
    <div id="main" class="bg-gradient-to-t from-slate-100 to-blue-300 min-h-screen">
        <HeaderComponent/>
        <MessageComponent :data="message"/>
        <slot/>
    </div>

</template>