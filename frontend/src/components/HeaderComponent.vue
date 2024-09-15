<script setup>

</script>
<template>
    <div class="w-full flex py-2 px-4 items-end text-slate-100 text-xl font-thin">
        <h1 class="text-3xl w-max whitespace-nowrap">Weather-app</h1>
        <ul class="flex w-full ml-5 gap-5 justify-start whitespace-nowrap">
            <li>
                <RouterLink activeClass="text-slate-700" class="hover:opacity-70" :to="{name:'search'}">Search</RouterLink>
            </li>
            <li>
                <RouterLink activeClass="text-slate-700" class="hover:opacity-70" to="/favourite-cities">Favourite cities</RouterLink>
            </li>
        </ul>
       
        
    </div>
</template>